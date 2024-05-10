El address(0) es una direccion que nunca va a ser usada.

# Hooks del ERC20
Se crearon dos hooks en el codigo llamados "_beforeTokenTransfer" & "_afterTokenTransfer" los cuales permiten agregar un comportamiento a nuestro smart contract heredado.

# Funciones Transfer

Por otro lado es interesante analizar el comportamiento de las funciones transfer.
Existen dos funciones transfer en el codigo
 - Transfer
 - TransferFrom

 El transferFrom tiene un chequeo adicional, en el cual se debe establecer la cantidad permitida para transferir. Esto, en el ejemplo, lo realiza de la siguiente manera.

 Pablo (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), tiene una billetera con 1000 tokens. Pablo, permite que Noelia (0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2) pueda gastar 100 tokens de su billetera. Entonces Noelia le puede enviar dinero a Sebastian (0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db) desde la billetera de Pablo.
 Para poder hacer esto es necesario:
 1) Ejecutar el metodo increaseAllowence (con la direccion de Noelia, desde la direccion de Pablo)
 2) Ejecutar el metodo Transfer From, usando la direccion de Pablo, hacia la de Sebastian.
 

