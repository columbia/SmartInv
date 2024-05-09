{{
  "language": "Solidity",
  "sources": {
    "contracts/Migration.sol": {
      "content": "// SPDX-License-Identifier: Unlicensed\npragma solidity 0.8.16;\n\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\n\ncontract MINTYSWAPMIGRATION {\n\n    event OwnershipTransferred (address indexed previousOwner, address indexed newOwner);\n    event TokenSwapped (address indexed account, uint256 indexed amount, uint256 indexed swapTime);\n\n    address public owner;\n\n    IERC20 public mintySwapV1;\n    IERC20 public mintySwapV2;\n\n    modifier onlyOwner {\n        require(msg.sender == owner, \"Ownable: caller is not a owner\");\n        _;\n    }\n\n    constructor (IERC20 _mintySwapV1, IERC20 _mintySwapV2) {\n        owner = msg.sender;\n        mintySwapV1 = _mintySwapV1;\n        mintySwapV2 = _mintySwapV2;\n    }\n\n    function swapToken(uint256 amount) external returns(bool) {\n        require(amount != 0,\"Swapping: amount shouldn't be zero\");\n        mintySwapV1.transferFrom(msg.sender, address(this), amount);\n        mintySwapV2.transfer(msg.sender, amount);\n        emit TokenSwapped(msg.sender, amount, block.timestamp);\n        return true;\n    }\n\n    function transferOwnership(address newOwner) external onlyOwner returns(bool) {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(owner, newOwner);\n        owner = newOwner;\n        return true;\n    }\n\n    function recoverETH(uint256 amount) external onlyOwner {\n        payable(owner).transfer(amount);\n    }\n\n    function recoverToken(address tokenAddress,uint256 amount) external onlyOwner {\n        IERC20(tokenAddress).transfer(owner, amount);\n    }\n}"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
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
    },
    "libraries": {}
  }
}}