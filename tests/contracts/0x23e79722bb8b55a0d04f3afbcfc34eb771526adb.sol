{{
  "language": "Solidity",
  "sources": {
    "contracts/Dispenser.sol": {
      "content": "// SPDX-License-Identifier: Unlicense\r\npragma solidity ^0.8.11;\r\n\r\ncontract AstraDispenser {\r\n    function dispense(address payable[] memory recipients) external payable {\r\n        assembly {\r\n            let len := mload(recipients)\r\n            let amount_per := div(callvalue(), len)\r\n            \r\n            let data := add(recipients, 0x20)\r\n            for\r\n                { let end := add(data, mul(len, 0x20)) }\r\n                lt(data, end)\r\n                { data := add(data, 0x20) }\r\n            {\r\n                pop(call(\r\n                    21000,\r\n                    mload(data),\r\n                    amount_per,\r\n                    0,\r\n                    0,\r\n                    0,\r\n                    0\r\n                ))\r\n            }\r\n\r\n            // Check if there is any leftover funds\r\n            let leftover := selfbalance()\r\n            if eq(leftover, 0) {\r\n                return(0, 0)\r\n            }\r\n\r\n            pop(call(\r\n                21000,\r\n                caller(),\r\n                leftover,\r\n                0,\r\n                0,\r\n                0,\r\n                0\r\n            ))\r\n        }\r\n    }\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 1337
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
    }
  }
}}