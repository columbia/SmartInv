{{
  "language": "Solidity",
  "sources": {
    "contracts/MapMyAddress.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\r\npragma solidity ^0.6.12;\r\n\r\ncontract MapMyAddress {\r\n    mapping(address => bool) public mapped;\r\n    \r\n    event Mapped(address sender, string cardanoAddress);\r\n    \r\n    function mapAddress(string memory cardanoAddress) external {\r\n        require(!mapped[msg.sender],\"Already mapped\");\r\n        mapped[msg.sender] = true;\r\n        emit Mapped(msg.sender,cardanoAddress);\r\n    }\r\n}"
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