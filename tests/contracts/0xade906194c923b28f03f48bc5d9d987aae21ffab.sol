{{
  "language": "Solidity",
  "sources": {
    "contracts/DataEdge.sol": {
      "content": "// SPDX-License-Identifier: GPL-2.0-or-later\n\npragma solidity ^0.8.12;\n\n/// @title Data Edge contract is only used to store on-chain data, it does not\n///        perform execution. On-chain client services can read the data\n///        and decode the payload for different purposes.\ncontract DataEdge {\n    /// @dev Fallback function, accepts any payload\n    fallback() external payable {\n        // no-op\n    }\n}\n"
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
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}