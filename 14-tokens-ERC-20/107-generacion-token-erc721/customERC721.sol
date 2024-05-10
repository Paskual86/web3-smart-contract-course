// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// Importaciones
// Recordar establecer las versiones
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/utils/Counters.sol";

contract erc721 is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokensIds;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    // Esto solo genera un registro del activo que estoy queriendo enviar
    function sendNFT(address account) public {
        _tokensIds.increment();
        uint256 newItemId = _tokensIds.current();
        _safeMint(_account, newItemId);
    }
}
