// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Food {
    struct dinnerPlate {
        string name;
        string ingredientes;
    }

    // Menu del dia
    dinnerPlate[] menu;

    // creacion del nuevo menu

    function newMenu(
        string memory _name,
        string memory _ingredientes
    ) internal {
        menu.push(dinnerPlate(_name, _ingredientes));
    }
}

contract Hamburguer is Food {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function doHamburguer(
        string memory _ingredientes,
        uint _unidades
    ) external {
        require(_unidades <= 5, "No puedes pedir mas de 5 hamburguesas");
        newMenu("Hamburguesas", _ingredientes);
    }

    // Modificador
    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "No tienees permisos para ejecutar esta funcion"
        );
        _; // No Olvidar!!!!
    }

    function hashPrivateNumber(
        uint _number
    ) public view onlyOwner returns (bytes32) {
        return keccak256(abi.encodePacked(_number));
    }
}
