{{
  "language": "Solidity",
  "sources": {
    "contracts/Contributions.sol": {
      "content": "// SPDX-License-Identifier: Unlicensed\npragma solidity ^0.8.0;\n\ncontract Contributions {\n    address payable public contributionAddress = payable(0x30f47deeB98a3C3bF84dF9e720b8463C0867C47f);\n\n    uint256 public weiRaised;\n    mapping(address => uint256) public balances;\n\n    event Contribution(address from, uint value);\n\n    receive() external payable {\n        _buyTokens(msg.sender);\n    }\n\n    function _buyTokens(address _beneficiary) public payable {\n        uint256 weiAmount = msg.value;\n        weiRaised += weiAmount;\n        balances[_beneficiary] += weiAmount;\n\n        emit Contribution(msg.sender, weiAmount);\n        contributionAddress.transfer(msg.value);\n    }\n\n    function contribution(address _wallet) public view returns (uint256) {\n        return balances[_wallet];\n    }\n}\n"
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