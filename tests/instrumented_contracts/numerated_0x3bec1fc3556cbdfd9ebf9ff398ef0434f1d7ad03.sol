1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/Multicall.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\n\ncontract Multicall {\n    struct Call {\n        address target;\n        bytes callData;\n        uint256 gas;\n    }\n\n    struct Result {\n        bool success;\n        bytes returnData;\n    }\n\n    function tryAggregate(\n        bool requireSuccess,\n        Call[] memory calls\n    ) public payable returns (Result[] memory returnData) {\n        returnData = new Result[](calls.length);\n        for (uint256 i = 0; i < calls.length; i++) {\n            (bool success, bytes memory ret) = calls[i].target.call{gas: calls[i].gas}(calls[i].callData);\n\n            if (requireSuccess) {\n                require(success, \"Multicall aggregate: call failed\");\n            }\n\n            returnData[i] = Result(success, ret);\n        }\n    }\n}\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": true,
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