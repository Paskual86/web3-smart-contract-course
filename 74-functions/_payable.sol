// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

// https://docs.soliditylang.org/en/v0.8.13/security-considerations.html?#sending-and-receiving-ether
// NOTA: El modificador payable, lo que indica es que que vamos a trabajar reciviendo y enviando dinero. SIEMPRE QUE NECESITEMOS
// ENVIAR O RECIBIR ETHER es necesario que este ese identificador
// Es necesario entender que el smart contract para ser ejecutado va a requerir cierta cantidad de GAS.
// Esto quiere decir que si nuestro contrato receptor, ejecuta ciertas operacion al recibir un ether, para poder ejecutarlo correctamente va a necesitarcierta dcantidad de GAS.
// Si no llega a tener GAS, la operacion de recepcion no va a ser ejecutada.

contract ethSend {
    constructor() payable {}

    receive() external payable {}

    // Eventos
    event sendStatus(bool);
    event callStatus(bool, bytes);

    // Transfer

    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(1 ether); // Si no queremos enviar un ether hay que eliminar la palabra ether. En ese caso enviariamos una unidad de GAS
    }

    // Send

    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(1 ether);
        emit sendStatus(sent);
        require(sent == true, "El envio ha fallado");
    }

    // Call
    function sendViaCall(address payable _to) public payable {
        (bool sucess, bytes memory data) = _to.call{value: 1 ether}("");
        emit callStatus(sucess, data);
        require(sucess, "El envio ha fallado");
    }
}

contract ethReceiver {
    event log(uint amount, uint gas);

    receive() external payable {
        emit log(address(this).balance, gasleft());
    }
}
