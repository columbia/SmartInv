{{
  "language": "Solidity",
  "sources": {
    "contracts/BorrowOwned.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity ^0.8.0;\n\n// Owned by 0xG\n\ncontract BorrowOwned {\n  IOwned private _owned;\n\n  mapping(uint => uint) public borrowExpire;\n  mapping(uint => uint) public borrowLength;\n\n  constructor(address owned_) {\n    _owned = IOwned(owned_);\n  }\n\n  function borrow(uint tokenId) external {\n    require(block.timestamp > borrowExpire[tokenId], \"Owned: token already borrowed. Retry later\");\n    (address owner, address holder, uint expire) = _owned.tokenInfo(tokenId);\n    require(owner != msg.sender, \"Owned: already owner\");\n    require(holder != msg.sender, \"Owned: holder already borrowed\");\n    require(block.timestamp > expire, \"Owned: token already borrowed. Retry later\");\n    borrowExpire[tokenId] = block.timestamp + borrowLength[tokenId];\n    _owned.lend(msg.sender, tokenId, 0);\n  }\n\n  function setBorrowLength(uint tokenId, uint length) external {\n    (address owner,,) = _owned.tokenInfo(tokenId);\n    require(owner == msg.sender, \"Owned: only owner can update borrow length\");\n    borrowLength[tokenId] = length;\n  }\n}\n\ninterface IOwned {\n  function tokenInfo(uint tokenId) external view returns (address owner, address holder, uint expire);\n  function lend(address to, uint tokenId, uint expire) external;\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
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