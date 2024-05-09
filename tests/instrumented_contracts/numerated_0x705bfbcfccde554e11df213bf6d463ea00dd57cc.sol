1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/bulk/ETHBulkRegistrar.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.8.4;\nimport \"./IETHBulkRegistrar.sol\";\nimport \"./IETHRegistrarController.sol\";\n\ncontract ETHBulkRegistrar is IETHBulkRegistrar {\n    IETHRegistrarController public immutable registrarController;\n\n    constructor(IETHRegistrarController _registrarController) {\n        registrarController = _registrarController;\n    }\n\n    function bulkRentPrice(string[] calldata names, uint256 duration) external view override returns (uint256 total) {\n        for (uint256 i = 0; i < names.length; i++) {\n            uint price = registrarController.rentPrice(names[i], duration);\n            total += price;\n        }\n        return total;\n    }\n\n    function bulkMakeCommitment(string[] calldata name, address owner, bytes32 secret) external view override returns (bytes32[] memory commitmentList) {\n        commitmentList = new bytes32[](name.length);\n        for (uint256 i = 0; i < name.length; i++) {\n            commitmentList[i] = registrarController.makeCommitmentWithConfig(name[i], owner, secret, address(0), address(0));\n        }\n        return commitmentList;\n    }\n\n    function commitments(bytes32 commit) external view override returns (uint256) {\n        return registrarController.commitments(commit);\n    }\n\n    function bulkCommit(bytes32[] calldata commitmentList) external override {\n        for (uint256 i = 0; i < commitmentList.length; i++) {\n            registrarController.commit(commitmentList[i]);\n        }\n    }\n\n    function bulkRegister(string[] calldata names, address owner, uint duration, bytes32 secret) external payable override {\n        uint256 cost = 0;\n        for (uint256 i = 0; i < names.length; i++) {\n            uint price = registrarController.rentPrice(names[i], duration);\n            registrarController.register{value: (price)}(names[i], owner, duration, secret);\n            cost = cost + price;\n        }\n\n        // Send any excess funds back\n        if (msg.value > cost) {\n            (bool sent, ) = msg.sender.call{value: msg.value - cost}(\"\");\n            require(sent, \"Failed to send Ether\");\n        }\n    }\n\n    function bulkRenew(string[] calldata names, uint duration) external payable override {\n        uint256 cost = 0;\n        for (uint256 i = 0; i < names.length; i++) {\n            uint price = registrarController.rentPrice(names[i], duration);\n            registrarController.renew{value: (price)}(names[i], duration);\n            cost = cost + price;\n        }\n\n        // Send any excess funds back\n        if (msg.value > cost) {\n            (bool sent, ) = msg.sender.call{value: msg.value - cost}(\"\");\n            require(sent, \"Failed to send Ether\");\n        }\n    }\n\n    function registerWithConfig(string calldata name, address owner, uint duration, bytes32 secret, address resolver, address addr) external payable override {\n        uint cost = registrarController.rentPrice(name, duration);\n        registrarController.registerWithConfig{value: cost}(name, owner, duration, secret, resolver, addr);\n        // Send any excess funds back\n        if (msg.value > cost) {\n            (bool sent, ) = msg.sender.call{value: msg.value - cost}(\"\");\n            require(sent, \"Failed to send Ether\");\n        }\n    }\n\n    function makeCommitmentWithConfig(string calldata name, address owner, bytes32 secret, address resolver, address addr) external view override returns (bytes32 commitment) {\n        commitment = registrarController.makeCommitmentWithConfig(name, owner, secret, resolver, addr);\n        return commitment;\n    }\n}\n"
6     },
7     "contracts/bulk/IETHBulkRegistrar.sol": {
8       "content": "pragma solidity >=0.8.4;\n\ninterface IETHBulkRegistrar {\n    function bulkRentPrice(string[] calldata names, uint256 duration) external view returns (uint256 total);\n\n    function bulkRegister(string[] calldata names, address owner, uint duration, bytes32 secret) external payable;\n\n    function bulkRenew(string[] calldata names, uint duration) external payable;\n\n    function bulkCommit(bytes32[] calldata commitments) external;\n\n    function bulkMakeCommitment(string[] calldata name, address owner, bytes32 secret) external view returns (bytes32[] memory commitments);\n\n    function commitments(bytes32 commit) external view returns (uint256);\n\n    function registerWithConfig(string calldata name, address owner, uint duration, bytes32 secret, address resolver, address addr) external payable;\n\n    function makeCommitmentWithConfig(string calldata name, address owner, bytes32 secret, address resolver, address addr) external view returns (bytes32);\n}\n"
9     },
10     "contracts/bulk/IETHRegistrarController.sol": {
11       "content": "pragma solidity >=0.8.4;\n\ninterface IETHRegistrarController {\n    function rentPrice(string memory, uint) external view returns (uint);\n\n    function available(string memory) external returns (bool);\n\n    function commit(bytes32) external;\n\n    function register(string calldata, address, uint256, bytes32) external payable;\n\n    function registerWithConfig(string memory, address, uint256, bytes32, address, address) external payable;\n\n    function makeCommitmentWithConfig(string memory, address, bytes32, address, address) external pure returns (bytes32);\n\n    function renew(string calldata, uint256) external payable;\n\n    function commitments(bytes32) external view returns (uint256);\n}\n"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": true,
17       "runs": 10000
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "devdoc",
25           "userdoc",
26           "metadata",
27           "abi"
28         ]
29       }
30     },
31     "metadata": {
32       "useLiteralContent": true
33     },
34     "libraries": {}
35   }
36 }}