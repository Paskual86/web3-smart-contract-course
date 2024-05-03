// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract functions {
    // Funciones de tipo PURE: No acceden a datos de la blockchain
    function getName() public pure returns (string memory) {
        return "Pablo";
    }

    // Funciones de tipo View: Funciones que accedern a la blockchain
    uint256 x = 100;

    function getNumber() public view returns (uint256) {
        return x * 2;
    }
}
