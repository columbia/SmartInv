{{
  "language": "Solidity",
  "sources": {
    "contracts/InfinityWithdrawalFeeRegistry.sol": {
      "content": "//SPDX-License-Identifier: UNLICENSED\npragma solidity 0.8.2;\n\ncontract InfinityWithdrawalFeeRegistry {\n  address public destination;\n  uint256 public paymentId;\n\n  event LogDeposit(\n    address indexed from,\n    string rewardWithdrawalId,\n    uint256 paymentId,\n    uint256 value\n  );\n\n  /**\n    @param destination_ - wallet address which pays out rewards\n   */\n  constructor(address destination_) {\n    destination = destination_;\n  }\n\n  /**\n    @param rewardWithdrawalId for which withdrawal fee is paid\n   */\n  function transfer(string memory rewardWithdrawalId) public payable {\n    require(msg.value > 0, \"Amount must be greater than zero\");\n    require(msg.sender != address(0), \"Transfer from the zero address\");\n    (bool sent, ) = payable(destination).call{value: msg.value}(\"\");\n    require(sent, \"Failed to send Ether\");\n    uint256 paymentId_ = ++paymentId;\n    emit LogDeposit(msg.sender, rewardWithdrawalId, paymentId_, msg.value);\n  }\n}\n"
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