1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/_utilities/BatchTxCaller.sol": {
5       "content": "// SPDX-License-Identifier: GPL-3.0-or-later\npragma solidity 0.7.3;\npragma experimental ABIEncoderV2;\n\n/**\n * @title BatchTxCaller\n * @notice Utility that executes an array of provided transactions.\n */\ncontract BatchTxCaller {\n    event TransactionFailed(address indexed destination, uint256 index, bytes data, bytes reason);\n\n    /**\n     * @notice Executes all transactions marked enabled.\n     *         If any transaction in the transaction list reverts, it returns false.\n     */\n    function executeAll(\n        address[] memory destinations,\n        bytes[] memory data,\n        uint256[] memory values\n    ) external payable returns (bool) {\n        bool exeuctionSuccess = true;\n\n        for (uint256 i = 0; i < destinations.length; i++) {\n            (bool result, bytes memory reason) = destinations[i].call{value: values[i]}(data[i]);\n            if (!result) {\n                emit TransactionFailed(destinations[i], i, data[i], reason);\n                exeuctionSuccess = false;\n            }\n        }\n\n        return exeuctionSuccess;\n    }\n}\n"
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
18           "abi"
19         ]
20       }
21     },
22     "libraries": {}
23   }
24 }}