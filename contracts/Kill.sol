// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Kill {
    address owner = msg.sender;

    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Helper {
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }
}
