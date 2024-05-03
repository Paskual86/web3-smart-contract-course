// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Fallback_Receive {
    event log(string _name, address _sender, uint _amount, bytes);

    fallback() external payable {
        emit log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit log("receive", msg.sender, msg.value, "");
    }
}

/* 
    - Las funciones fallback y receive son funciones que permiten recibir ethers en el smart contract.
    - Solo puede haber uno de cada una de las funciones declaradas.
    - La diferencia entre ambas esta en que el receive se ejecuda solo cuando en msg.data no existe informacion adicional.
    - En el caso de que la funcion receive no exista y si exista la funcion fallback, es esta ultima la que se ejecuta.
*/
