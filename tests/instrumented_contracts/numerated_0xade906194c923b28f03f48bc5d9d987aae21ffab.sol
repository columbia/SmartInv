1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/DataEdge.sol": {
5       "content": "// SPDX-License-Identifier: GPL-2.0-or-later\n\npragma solidity ^0.8.12;\n\n/// @title Data Edge contract is only used to store on-chain data, it does not\n///        perform execution. On-chain client services can read the data\n///        and decode the payload for different purposes.\ncontract DataEdge {\n    /// @dev Fallback function, accepts any payload\n    fallback() external payable {\n        // no-op\n    }\n}\n"
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