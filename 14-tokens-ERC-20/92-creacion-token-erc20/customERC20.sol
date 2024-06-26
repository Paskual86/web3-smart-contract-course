// SPX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC20.sol";

contract customERC20 is ERC20 {
    constructor() ERC20("Pablo", "PSA") {}

    // Creacion de nuevos Tokens
    function createTokens() public {
        _mint(msg.sender, 1000);
    }
}
