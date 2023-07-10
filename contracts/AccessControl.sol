// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AccessControl {
    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    event GrantRole(bytes32 indexed _role, address indexed _addr);
    event RevokeRole(bytes32 indexed _role, address indexed _addr);

    modifier onlyAdmin(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role, address _addr) internal {
        roles[_role][_addr] = true;
        emit GrantRole(_role, _addr);
    }

    function grantRole(bytes32 _role, address _addr) external onlyAdmin(ADMIN) {
        _grantRole(_role, _addr);
    }

    function revokeRole(
        bytes32 _role,
        address _addr
    ) external onlyAdmin(ADMIN) {
        roles[_role][_addr] = false;
        emit RevokeRole(_role, _addr);
    }
}
