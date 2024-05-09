{{
  "language": "Solidity",
  "sources": {
    "contracts/Multicall.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\n\ncontract Multicall {\n    struct Call {\n        address target;\n        bytes callData;\n        uint256 gas;\n    }\n\n    struct Result {\n        bool success;\n        bytes returnData;\n    }\n\n    function tryAggregate(\n        bool requireSuccess,\n        Call[] memory calls\n    ) public payable returns (Result[] memory returnData) {\n        returnData = new Result[](calls.length);\n        for (uint256 i = 0; i < calls.length; i++) {\n            (bool success, bytes memory ret) = calls[i].target.call{gas: calls[i].gas}(calls[i].callData);\n\n            if (requireSuccess) {\n                require(success, \"Multicall aggregate: call failed\");\n            }\n\n            returnData[i] = Result(success, ret);\n        }\n    }\n}\n"
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