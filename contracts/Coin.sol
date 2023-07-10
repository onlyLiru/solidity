// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Coin {
    address public minter;
    mapping(address => uint256) public balances;

    event Sent(address from, address to, uint256 amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint256 required, uint256 availible);

    function send(address receiver, uint256 amount) public {
        if(amount > balances[msg.sender]) {
            revert InsufficientBalance({
                required: amount,
                availible: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
    }
}
