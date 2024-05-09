1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/MapMyAddress.sol": {
5       "content": "// SPDX-License-Identifier: UNLICENSED\r\npragma solidity ^0.6.12;\r\n\r\ncontract MapMyAddress {\r\n    mapping(address => bool) public mapped;\r\n    \r\n    event Mapped(address sender, string cardanoAddress);\r\n    \r\n    function mapAddress(string memory cardanoAddress) external {\r\n        require(!mapped[msg.sender],\"Already mapped\");\r\n        mapped[msg.sender] = true;\r\n        emit Mapped(msg.sender,cardanoAddress);\r\n    }\r\n}"
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