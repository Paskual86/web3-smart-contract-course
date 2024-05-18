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
}

contract mainERC721 is ERC721 {
    constructor() ERC721("loteria", "PSA721") {}
}
