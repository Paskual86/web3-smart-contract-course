// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract padre {
    mapping (address => address) personal_contract;

    function Factory() public {
        address addr_personal_contract = address (new hijo(msg.sender, address(this)));
    }
}

contract hijo {
    string Owner {
        address _owner;
        address _smartContractPadre;
    }

    Owner public propiertario;

    constructor(address _account, address _accountSC) {
        propietario._owner = _account;
        propietario._smartContractPadre = _accountSC;
    }
}