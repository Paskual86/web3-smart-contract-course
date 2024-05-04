// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract bucles {
    // Suma de numeros en For
    function sumafor(uint _number) public pure returns (uint) {
        uint result = 0;
        for (uint i = 0; i < (10 + _number); i++) {
            result += result + i;
        }
        return result;
    }

    function odd() public pure returns (uint) {
        uint aux_sum = 0;
        uint counter = 0;
        uint counter_odd = 0;

        while (counter_odd < 10) {
            if (counter % 2 != 0) {
                aux_sum = aux_sum + counter;
                counter_odd++;
            }
        }
        return aux_sum;
    }

    function sum_rest(
        string memory operation,
        uint a,
        uint b
    ) public pure returns (uint) {
        // NOTA: No se pueden comparar dos variables de tipo string. No lo soporta. Es necesario generar el codigo Hash.
        // Strings no se pueden comparar de forma literal
        bytes32 hash_operation = keccak256(abi.encodePacked(operation));
        if (hash_operation == keccak256(abi.encodePacked("suma"))) {
            return a + b;
        } else {
            return a - b;
        }
    }
}
