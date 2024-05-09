{{
  "language": "Solidity",
  "sources": {
    "contracts/_utilities/BatchTxCaller.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\npragma solidity 0.7.3;\npragma experimental ABIEncoderV2;\n\n/**\n * @title BatchTxCaller\n * @notice Utility that executes an array of provided transactions.\n */\ncontract BatchTxCaller {\n    event TransactionFailed(address indexed destination, uint256 index, bytes data, bytes reason);\n\n    /**\n     * @notice Executes all transactions marked enabled.\n     *         If any transaction in the transaction list reverts, it returns false.\n     */\n    function executeAll(\n        address[] memory destinations,\n        bytes[] memory data,\n        uint256[] memory values\n    ) external payable returns (bool) {\n        bool exeuctionSuccess = true;\n\n        for (uint256 i = 0; i < destinations.length; i++) {\n            (bool result, bytes memory reason) = destinations[i].call{value: values[i]}(data[i]);\n            if (!result) {\n                emit TransactionFailed(destinations[i], i, data[i], reason);\n                exeuctionSuccess = false;\n            }\n        }\n\n        return exeuctionSuccess;\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}