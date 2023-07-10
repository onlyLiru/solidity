// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 txId);
    event Approve(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed owner, uint256 indexed txId);
    event Execute(uint256 txId);

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 required;

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExist(uint256 txId) {
        require(txId < transactions.length);
        _;
    }

    modifier txNotExecute(uint256 txId) {
        require(!transactions[txId].executed, "transaction is executed");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "owners required");
        require(
            _owners.length >= _required && _required > 0,
            "invalid required of owners"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0));
            require(!isOwner[_owners[i]], "owner is not unique");

            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function _getApproveCount(uint256 txId)
        internal
        view
        returns (uint256 count)
    {
        for (uint256 i = 0; i < owners.length; i++) {
            if (approved[txId][owners[i]]) {
                count++;
            }
        }
    }

    function submit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner {
        transactions.push(
            Transaction({to: _to, value: _value, data: _data, executed: false})
        );
        emit Submit(transactions.length - 1);
    }

    function approve(uint256 txId)
        external
        onlyOwner
        txExist(txId)
        txNotExecute(txId)
    {
        require(!approved[txId][msg.sender], "already approved");
        approved[txId][msg.sender] = true;
        emit Approve(msg.sender, txId);
    }

    function execute(uint256 txId)
        external
        onlyOwner
        txExist(txId)
        txNotExecute(txId)
    {
        require(_getApproveCount(txId) >= required, "approved < required");
        Transaction storage transaction = transactions[txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );

        require(success, "tx failed");

        emit Execute(txId);
    }

    function revoke(uint256 txId)
        external
        onlyOwner
        txExist(txId)
        txNotExecute(txId)
    {
        require(approved[txId][msg.sender], "not approved");
        approved[txId][msg.sender] = false;

        emit Approve(msg.sender, txId);
    }
}
