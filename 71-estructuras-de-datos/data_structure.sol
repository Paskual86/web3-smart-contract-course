// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract data_structures {
    struct Customer {
        uint256 id;

        string name;

        string email;
    }

    // Declaracion de un objeto
    Customer cust1 = Customer(1, "Pablo", "pablo@mail.com");
    // Array de longitud fija
    uint56 [5] public fixed_list_uints = [1,2,3,4,5];

    // Array Dinamico
    uint256 [] dynamic_list_uints;

    //Array dinamico de tipo Customer
    Customer [] public dynamic_list_customer ; 

    function array_modification (uint256 _id, string memory _name, string memory _email) public {
        Customer memory random_customer = Customer(_id, _name, _email);
        dynamic_list_customer.push(random_customer);
    }

    // mappings

    mapping (address => uint256) public address_uint;
    mapping (string => uint256 []) public string_listUints;
    mapping (address => Customer) public address_dataStructure;

    //Asignar un nuemero a una direccion
    function assignNumber(uint256 _number) public {
        address_uint[msg.sender] = _number;
    }
    // Assignar varios numeros a una direccion
    function assignList(string memory _name, uint256 _number) public {
        string_listUints[_name].push(_number);
    }
    // Assignar una estructura
    function assignStructure(uint256 _id, string memory _name, string memory _email) public {
        address_dataStructure[msg.sender] = Customer(_id, _name, _email);
    }

}