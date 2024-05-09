{{
  "language": "Solidity",
  "sources": {
    "contracts/eth_forwarder.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\n\npragma solidity ^0.8.0;\n\ncontract ETHForwarder {\n    address payable private _forwardAddress;\n    event Received(address indexed sender, uint amount);\n\n    constructor(address payable forwardAddress_) {\n        _forwardAddress = forwardAddress_;\n\n    }\n\n    /**\n     * @dev Allows the contract to recieve ETH.\n     */\n    receive() external payable {\n        emit Received(msg.sender, msg.value);\n    }\n\n    fallback() external payable {\n        emit Received(msg.sender, msg.value);\n    }\n\n    /**\n     * @dev Returns the forward address of the contract.\n     */\n    function forwardAddress() public view virtual returns (address) {\n        return _forwardAddress;\n    }\n\n    /**\n     * @dev Transfers all existing ETH Token to the determined\n     * forwardAddress.\n     *\n     */\n    function forwardETH() public {\n        _forwardAddress.transfer(address(this).balance);\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 1000
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