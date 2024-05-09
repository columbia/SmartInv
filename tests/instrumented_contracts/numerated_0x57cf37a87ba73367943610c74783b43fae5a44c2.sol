1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/BorrowOwned.sol": {
5       "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity ^0.8.0;\n\n// Owned by 0xG\n\ncontract BorrowOwned {\n  IOwned private _owned;\n\n  mapping(uint => uint) public borrowExpire;\n  mapping(uint => uint) public borrowLength;\n\n  constructor(address owned_) {\n    _owned = IOwned(owned_);\n  }\n\n  function borrow(uint tokenId) external {\n    require(block.timestamp > borrowExpire[tokenId], \"Owned: token already borrowed. Retry later\");\n    (address owner, address holder, uint expire) = _owned.tokenInfo(tokenId);\n    require(owner != msg.sender, \"Owned: already owner\");\n    require(holder != msg.sender, \"Owned: holder already borrowed\");\n    require(block.timestamp > expire, \"Owned: token already borrowed. Retry later\");\n    borrowExpire[tokenId] = block.timestamp + borrowLength[tokenId];\n    _owned.lend(msg.sender, tokenId, 0);\n  }\n\n  function setBorrowLength(uint tokenId, uint length) external {\n    (address owner,,) = _owned.tokenInfo(tokenId);\n    require(owner == msg.sender, \"Owned: only owner can update borrow length\");\n    borrowLength[tokenId] = length;\n  }\n}\n\ninterface IOwned {\n  function tokenInfo(uint tokenId) external view returns (address owner, address holder, uint expire);\n  function lend(address to, uint tokenId, uint expire) external;\n}\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": false,
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
24     }
25   }
26 }}