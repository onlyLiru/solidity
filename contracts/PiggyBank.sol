// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PiggyBank {
    address owner = msg.sender;
    event Deposit(uint256 value);
    event Withdraw(uint256 value);

    receive() external payable {
        emit Deposit(msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function withdraw() external onlyOwner {
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}
