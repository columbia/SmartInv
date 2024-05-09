{{
  "language": "Solidity",
  "sources": {
    "contracts/TransferKEYS.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\nimport \"./IERC20.sol\";\n\n// TransferKEYS Contract\n// Developed by Daniel Kantor\n\n// This contract will allow you to transfer KEYS to any address with NO 3% transfer tax.\n\n// In order to use this contract, make sure you approve the amount of KEYS you would like to transfer\n// with the approve() function on the KEYS contract located here: \n// https://etherscan.io/token/0xe0a189C975e4928222978A74517442239a0b86ff#writeContract\n// After you approve the amount of KEYS you'd like to send, \n// you can call transferKEYS or transferKEYSWholeTokenAmounts\n\ncontract TransferKEYS {\n    // KEYS Contract Address\n    address constant KEYS = 0xe0a189C975e4928222978A74517442239a0b86ff;\n\n    function transferKEYS(address toAddress, uint256 amount) public {\n        bool s = IERC20(KEYS).transferFrom(msg.sender, address(this), amount);\n        require(s, \"Failure to transfer from sender to contract\");\n\n        // Transfer KEYS Tokens To User\n        bool s1 = IERC20(KEYS).transfer(toAddress, amount);\n        require(s1, \"Failure to transfer from contract to receiver\");\n    }\n\n    function transferKEYSWholeTokenAmounts(address toAddress, uint256 amount) public {\n        bool s = IERC20(KEYS).transferFrom(msg.sender, address(this), amount * 10**9);\n        require(s, \"Failure to transfer from sender to contract\");\n\n        // Transfer KEYS Tokens To User\n        bool s1 = IERC20(KEYS).transfer(toAddress, amount * 10**9);\n        require(s1, \"Failure to transfer from contract to receiver\");\n    }\n}"
    },
    "contracts/IERC20.sol": {
      "content": "    //SPDX-License-Identifier: MIT\n    pragma solidity 0.8.4;\n\n    interface IERC20 {\n        function totalSupply() external view returns (uint256);\n\n        function symbol() external view returns (string memory);\n\n        function name() external view returns (string memory);\n\n        /**\n        * @dev Returns the amount of tokens owned by `account`.\n        */\n        function balanceOf(address account) external view returns (uint256);\n\n        /**\n        * @dev Returns the number of decimal places\n        */\n        function decimals() external view returns (uint8);\n\n        /**\n        * @dev Moves `amount` tokens from the caller's account to `recipient`.\n        *\n        * Returns a boolean value indicating whether the operation succeeded.\n        *\n        * Emits a {Transfer} event.\n        */\n        function transfer(address recipient, uint256 amount) external returns (bool);\n\n        /**\n        * @dev Returns the remaining number of tokens that `spender` will be\n        * allowed to spend on behalf of `owner` through {transferFrom}. This is\n        * zero by default.\n        *\n        * This value changes when {approve} or {transferFrom} are called.\n        */\n        function allowance(address owner, address spender) external view returns (uint256);\n\n        /**\n        * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n        *\n        * Returns a boolean value indicating whether the operation succeeded.\n        *\n        * IMPORTANT: Beware that changing an allowance with this method brings the risk\n        * that someone may use both the old and the new allowance by unfortunate\n        * transaction ordering. One possible solution to mitigate this race\n        * condition is to first reduce the spender's allowance to 0 and set the\n        * desired value afterwards:\n        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n        *\n        * Emits an {Approval} event.\n        */\n        function approve(address spender, uint256 amount) external returns (bool);\n\n        /**\n        * @dev Moves `amount` tokens from `sender` to `recipient` using the\n        * allowance mechanism. `amount` is then deducted from the caller's\n        * allowance.\n        *\n        * Returns a boolean value indicating whether the operation succeeded.\n        *\n        * Emits a {Transfer} event.\n        */\n        function transferFrom(\n            address sender,\n            address recipient,\n            uint256 amount\n        ) external returns (bool);\n\n        /**\n        * @dev Emitted when `value` tokens are moved from one account (`from`) to\n        * another (`to`).\n        *\n        * Note that `value` may be zero.\n        */\n        event Transfer(address indexed from, address indexed to, uint256 value);\n\n        /**\n        * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n        * a call to {approve}. `value` is the new allowance.\n        */\n        event Approval(address indexed owner, address indexed spender, uint256 value);\n    }\n"
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