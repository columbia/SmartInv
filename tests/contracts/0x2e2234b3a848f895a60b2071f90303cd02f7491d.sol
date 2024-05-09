{{
  "language": "Solidity",
  "sources": {
    "contracts/3_Ballot.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.10;\n\ninterface ERC721Partial {\n    function transferFrom(address from, address to, uint256 tokenId) external;\n}\n\ncontract BatchTransfer {\n    /// @notice Tokens on the given ERC-721 contract are transferred from you to a recipient.\n    ///         Don't forget to execute setApprovalForAll first to authorize this contract.\n    /// @param  tokenContract An ERC-721 contract\n    /// @param  recipient     Who gets the tokens?\n    /// @param  tokenIds      Which token IDs are transferred?\n    function batchTransfer(ERC721Partial tokenContract, address recipient, uint256[] calldata tokenIds) external {\n        for (uint256 index; index < tokenIds.length; index++) {\n            tokenContract.transferFrom(msg.sender, recipient, tokenIds[index]);\n        }\n    }\n}"
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
    }
  }
}}