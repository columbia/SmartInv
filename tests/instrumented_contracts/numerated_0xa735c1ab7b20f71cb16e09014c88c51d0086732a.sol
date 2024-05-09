1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "details": {
12         "constantOptimizer": true,
13         "cse": true,
14         "deduplicate": true,
15         "jumpdestRemover": true,
16         "orderLiterals": true,
17         "peephole": true,
18         "yul": false
19       },
20       "runs": 200
21     },
22     "remappings": [],
23     "outputSelection": {
24       "*": {
25         "*": [
26           "evm.bytecode",
27           "evm.deployedBytecode",
28           "devdoc",
29           "userdoc",
30           "metadata",
31           "abi"
32         ]
33       }
34     }
35   },
36   "sources": {
37     "contracts/core/RadarBridgeProxy.sol": {
38       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract RadarBridgeProxy {\n    \n    constructor(bytes memory _constructorData, address _radarBridge) {\n\n        assembly {\n            // solium-disable-line\n            sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, _radarBridge)\n        }\n\n        (bool success, bytes memory returnData) = _radarBridge.delegatecall(_constructorData); // solium-disable-line\n        require(success, string(returnData));\n    }\n\n    fallback() external payable {\n        assembly {\n            // solium-disable-line\n            let contractLogic := sload(\n                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc\n            )\n            calldatacopy(0x0, 0x0, calldatasize())\n            let success := delegatecall(\n                sub(gas(), 10000),\n                contractLogic,\n                0x0,\n                calldatasize(),\n                0,\n                0\n            )\n            let retSz := returndatasize()\n            returndatacopy(0, 0, retSz)\n            switch success\n                case 0 {\n                    revert(0, retSz)\n                }\n                default {\n                    return(0, retSz)\n                }\n        }\n    }\n}"
39     }
40   }
41 }}