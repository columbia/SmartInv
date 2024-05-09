{{
  "language": "Solidity",
  "sources": {
    "contracts/FeePool.sol": {
      "content": "//SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.4;\n\ncontract FeePool {\n    address destination;\n\n    // Event give info who done to pay for fee\n    event Deposit(address indexed _from, string indexed _hash, uint _value);\n\n    /*\n    @param destination - it's main wallet address which manage withdrawal\n    */\n    constructor(address _destination) {\n        destination = _destination;\n    }\n\n    /*\n    @param _withdrawalId - for which deposit pay fee\n    */\n    function transfer(string memory _hash) public payable {\n        require(msg.value > 0, \"Transfer from the zero address\");\n        (bool sent,) = payable(destination).call{value: msg.value}(\"\");\n        require(sent, \"Failed to send Ether\");\n        emit Deposit(msg.sender, _hash, msg.value);\n    }\n}\n"
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
    },
    "libraries": {}
  }
}}