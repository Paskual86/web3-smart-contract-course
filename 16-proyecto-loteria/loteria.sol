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
    function minBoleto(address _propietario, uint256 _boleto) public {
        require(
            msg.sender == propietario.contratoPadre,
            "The user doesn't have privileges"
        );
        mainERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }
}
