// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract padre {
    mapping(address => address) public personal_contract;

    function Factory() public {
        address addr_personal_contract = address(
            new hijo(msg.sender, address(this))
        );
        personal_contract[msg.sender] = addr_personal_contract;
    }
}

contract hijo {
    struct Owner {
        address _owner;
        address _smartContractPadre;
    }

    Owner public propietario;

    constructor(address _account, address _accountSC) {
        propietario._owner = _account;
        propietario._smartContractPadre = _accountSC;
    }
}
