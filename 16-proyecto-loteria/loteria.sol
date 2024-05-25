// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract loteria is ERC20, Ownable {
    // Gestion de tokens

    // Direccion del contrato NFT del proyecto
    address public nft;

    constructor() ERC20("loteria", "PSA") {
        _mint(address(this), 1000);
        nft = address(new mainERC721());
    }

    // Ganador del premio de la loteria
    address public ganador;

    // registro del usuario
    mapping(address => address) public usuario_contracts;

    // Precio de los tokens
    function precioTokens(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (1 ether);
    }

    // Visualizacion del balance de tokens ERC-20 de un usuario
    function balanceToken(address _account) public view returns (uint256) {
        return balanceOf(_account);
    }

    // Visualizacion del balance de tokens ERC-20 del SmartContracts
    function balanceTokenSC() public view returns (uint256) {
        return balanceOf(address(this));
    }

    //Visualizacion del balance del Smart Contracts
    // 1 ether = 10^18 wei
    function balanceEtherSC() public view returns (uint256) {
        return address(this).balance / 10 ** 18;
    }

    //Generacion de nuevos tokens ERC-20
    function mint(uint256 _cantidad) public onlyOwner {
        _mint(address(this), _cantidad);
    }

    // Registro de usuarios
    function registrar() internal {
        address addr_personal_contract = address(
            new boletosNFTs(msg.sender, address(this), nft)
        );
        usuario_contracts[msg.sender] = addr_personal_contract;
    }

    // Return User Information
    function usersInfo(address _account) public view returns (address) {
        return usuario_contracts[_account];
    }

    // Compra de tokens
    function compraTokens(uint256 _numTokens) public payable {
        // Si es cero, es que el usuario no se ha registrado
        if (usuario_contracts[msg.sender] == address(0)) {
            registrar();
        }
        //Precio de los tokens que se van a comprar
        uint256 coste = precioTokens(_numTokens);
        require(msg.value >= coste, "Compra menos tokens o paga mas ethers");
        // Obtencion del numero de tokens ERC-20 disponibles
        uint256 balance = balanceTokenSC();
        require(_numTokens <= balance, "Compra un numero menor de tokens");
        // Devolucion del dinero sobrante
        uint256 returnValue = msg.value - coste;
        if (returnValue > 0) {
            // El SC devuelve la cantidad restante
            payable(msg.sender).transfer(returnValue);
        }
        // Envio de los tokens al cliente/usuario
        _transfer(address(this), msg.sender, _numTokens);
    }

    //Devolucion de tokens al Smart Contracts
    function devolverTokens(uint _numTokens) public payable {
        // El numbero de tokens debe ser mayor a 0
        require(
            _numTokens > 0,
            "Necesitas devolver un numero de tokens mayor a 0"
        );
        // El usuario debe tener la cantidad de tokens a devolver
        require(
            _numTokens <= balanceToken(msg.sender),
            "No tienes los tokens que deseas devolver"
        );
        // El usuario transfiere los token a SC
        _transfer(msg.sender, address(this), _numTokens);
        // El Smart contract envia los ethers al usuario
        payable(msg.sender).transfer(precioTokens(_numTokens));
    }

    // ++++++++++++++++++++++++++++++++++++++++++++
    // Gestion de Loteria
    // ++++++++++++++++++++++++++++++++++++++++++++

    // Precio del boleto de loteria (en tokens ERC-20)
    uint public precioBoleto = 5;
    // Relacion: Persona que compra los boletos => el numero de los boletos
    mapping(address => uint[]) idPersona_boletos;
    // Relacion: boleto => ganador
    mapping(uint => address) ADNBoleto;
    // Numero aleatorio
    uint randNonce = 0;
    // Boletos de la loteria generadores
    uint[] boletosComprados;

    function compraBoletos(uint _numBoletos) public {
        // precio total de los boletos a comprar
        uint precioTotal = _numBoletos * precioBoleto;
        // Verificacion de los tokens del usuario
        require(
            precioTotal <= balanceToken(msg.sender),
            "No tienes tokens suficientes"
        );
        // Transferencias de tokens del usuario al Smart Contracts
        _transfer(msg.sender, address(this), precioTotal);

        for (uint i = 0; i < _numBoletos; i++) {
            // el modulo 10000 me deja de un numero finito de 5 digitos
            uint random = uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % 10000;
            randNonce++;
            // Almacenamiento de los datos de los boletos
            boletosComprados.push(random);
            // Asignacion del ADN del Boleto para la generacion de un ganador
            ADNBoleto[random] = msg.sender;
            // Creacion de un nuevo NFT para el numero de boleto
            boletosNFTs(usuario_contracts[msg.sender]).mintBoleto(
                msg.sender,
                random
            );
        }
    }

    // Visualizacion de los boletos del usuario
    function tusBoletos(
        address _propietario
    ) public view returns (uint[] memory) {
        return idPersona_boletos[_propietario];
    }

    // Generacion del ganador de la loteria
    function generarGanador() public onlyOwner {
        // Declaracion de la longitud del array
        uint longitud = boletosComprados.length;
        // Verificacion de la compra de al menos de 1 boleto
        require(longitud > 0, "No hay boletos comprados");
        // Eleccion aleatoria de un numero entre: [0 - longitud]
        uint random = uint(
            uint(keccak256(abi.encodePacked(block.timestamp))) % longitud
        );
        // Seleccion del numero aleatorio
        uint eleccion = boletosComprados[random];
        // Direccion del ganador de la loteria
        ganador = ADNBoleto[eleccion];
        // Envio del 95% del premio de la loteria al ganador
        payable(ganador).transfer((address(this).balance * 95) / 100);
        // Envio del 5 % del premio de loteria al owner
        payable(owner()).transfer((address(this).balance * 5) / 100);
    }
}

//Smart Contracts NFT
contract mainERC721 is ERC721 {
    address public direccionLoteria;

    constructor() ERC721("loteria", "PSA721") {
        direccionLoteria = msg.sender;
    }

    // Creacion de NFTs
    function safeMint(address _propietario, uint256 _boleto) public {
        require(
            msg.sender == loteria(direccionLoteria).usersInfo(_propietario),
            "The user doesn't have privileges"
        );
        _safeMint(_propietario, _boleto);
    }
}

contract boletosNFTs {
    // Datos Relevantes
    struct Owner {
        address direccionPropietario;
        address contratoPadre;
        address contratoNFT;
        address contratoUsuario;
    }

    Owner public propietario;
    // Constructor
    constructor(
        address _propietario,
        address _contratoPadre,
        address _contratoNFT
    ) {
        //propietario.direccionPropietario = _propietario;
        //propietario.contratoPadre = _contratoPadre;
        //propietario.contratoNFT = _contratoNFT;
        // O
        propietario = Owner(
            _propietario,
            _contratoPadre,
            _contratoNFT,
            address(this)
        );
    }

    // Conversion de los numeros de los boletos de loteria
    function mintBoleto(address _propietario, uint256 _boleto) public {
        require(
            msg.sender == propietario.contratoPadre,
            "The user doesn't have privileges"
        );
        mainERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }
}
