1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/3_Ballot.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.10;\n\ninterface ERC721Partial {\n    function transferFrom(address from, address to, uint256 tokenId) external;\n}\n\ncontract BatchTransfer {\n    /// @notice Tokens on the given ERC-721 contract are transferred from you to a recipient.\n    ///         Don't forget to execute setApprovalForAll first to authorize this contract.\n    /// @param  tokenContract An ERC-721 contract\n    /// @param  recipient     Who gets the tokens?\n    /// @param  tokenIds      Which token IDs are transferred?\n    function batchTransfer(ERC721Partial tokenContract, address recipient, uint256[] calldata tokenIds) external {\n        for (uint256 index; index < tokenIds.length; index++) {\n            tokenContract.transferFrom(msg.sender, recipient, tokenIds[index]);\n        }\n    }\n}"
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
24     }
25   }
26 }}