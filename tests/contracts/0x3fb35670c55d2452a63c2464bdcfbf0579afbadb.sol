{{
  "language": "Solidity",
  "sources": {
    "contracts/batch-transfer/BatchTransfer.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.12;\r\n\r\nimport {IERC20} from './IERC20.sol';\r\nimport {IERC721} from './IERC721.sol';\r\n\r\nerror TransferFailed();\r\n\r\ncontract BatchTransfer {\r\n\r\n    // Requires 'approve' before transfer\r\n    function transferERC20(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n            bool success = token.transferFrom(msg.sender, recipients[i], values[i]);\r\n\r\n            if (!success) {\r\n                revert TransferFailed();\r\n            }\r\n        }\r\n    }\r\n\r\n    // Requires 'setApprovalForAll' before transfer\r\n    function transferERC721(IERC721 collection, address recipient, uint256[] calldata tokenIds) external {\r\n        for (uint256 i; i < tokenIds.length; i++) {\r\n            collection.safeTransferFrom(msg.sender, recipient, tokenIds[i]);\r\n        }\r\n    }\r\n\r\n    function transferEther(address[] calldata recipients, uint256[] calldata values) external payable {\r\n        uint256 refund = msg.value;\r\n\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n            (bool success, ) = payable(recipients[i]).call{value: values[i]}('');\r\n\r\n            if (!success) {\r\n                revert TransferFailed();\r\n            }\r\n\r\n            refund -= values[i];\r\n        }\r\n\r\n        // Refund remaining ETH\r\n        if (refund > 0) {\r\n            (bool success, ) = payable(msg.sender).call{value: refund}('');\r\n\r\n            if (!success) {\r\n                revert TransferFailed();\r\n            }\r\n        }\r\n    }\r\n}\r\n"
    },
    "contracts/batch-transfer/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.12;\r\n\r\ninterface IERC20 {\r\n    function transferFrom(address from, address to, uint256 value) external returns (bool);\r\n}\r\n"
    },
    "contracts/batch-transfer/IERC721.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.12;\r\n\r\ninterface IERC721 {\r\n    function safeTransferFrom(address from, address to, uint256 tokenId) external;\r\n}\r\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 800
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