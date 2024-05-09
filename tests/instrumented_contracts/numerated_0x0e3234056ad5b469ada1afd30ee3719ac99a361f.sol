1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/InfinityWithdrawalFeeRegistry.sol": {
5       "content": "//SPDX-License-Identifier: UNLICENSED\npragma solidity 0.8.2;\n\ncontract InfinityWithdrawalFeeRegistry {\n  address public destination;\n  uint256 public paymentId;\n\n  event LogDeposit(\n    address indexed from,\n    string rewardWithdrawalId,\n    uint256 paymentId,\n    uint256 value\n  );\n\n  /**\n    @param destination_ - wallet address which pays out rewards\n   */\n  constructor(address destination_) {\n    destination = destination_;\n  }\n\n  /**\n    @param rewardWithdrawalId for which withdrawal fee is paid\n   */\n  function transfer(string memory rewardWithdrawalId) public payable {\n    require(msg.value > 0, \"Amount must be greater than zero\");\n    require(msg.sender != address(0), \"Transfer from the zero address\");\n    (bool sent, ) = payable(destination).call{value: msg.value}(\"\");\n    require(sent, \"Failed to send Ether\");\n    uint256 paymentId_ = ++paymentId;\n    emit LogDeposit(msg.sender, rewardWithdrawalId, paymentId_, msg.value);\n  }\n}\n"
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
24     },
25     "libraries": {}
26   }
27 }}