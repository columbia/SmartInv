1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/DIAOracleV2.sol": {
5       "content": "pragma solidity ^0.8.0;\n\ncontract DIAOracleV2 {\n    mapping (string => uint256) public values;\n    address public oracleUpdater;\n    \n    event OracleUpdate(string key, uint128 value, uint128 timestamp);\n    event UpdaterAddressChange(address newUpdater);\n    \n    constructor() {\n        oracleUpdater = msg.sender;\n    }\n    \n    function setValue(string memory key, uint128 value, uint128 timestamp) public {\n        require(msg.sender == oracleUpdater,\"not a updater\");\n        uint256 cValue = (((uint256)(value)) << 128) + timestamp;\n        values[key] = cValue;\n        emit OracleUpdate(key, value, timestamp);\n    }\n    \n    function getValue(string memory key) external view returns (uint128, uint128) {\n        uint256 cValue = values[key];\n        uint128 timestamp = (uint128)(cValue % 2**128);\n        uint128 value = (uint128)(cValue >> 128);\n        return (value, timestamp);\n    }\n    \n    function updateOracleUpdaterAddress(address newOracleUpdaterAddress) public {\n        require(msg.sender == oracleUpdater,\"not a updater\");\n        oracleUpdater = newOracleUpdaterAddress;\n        emit UpdaterAddressChange(newOracleUpdaterAddress);\n    }\n}\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": false,
11       "runs": 200
12     },
13     "outputSelection": {
14       "*": {
15         "*": [
16           "evm.bytecode",
17           "evm.deployedBytecode",
18           "devdoc",
19           "userdoc",
20           "metadata",
21           "abi"
22         ]
23       }
24     },
25     "libraries": {}
26   }
27 }}