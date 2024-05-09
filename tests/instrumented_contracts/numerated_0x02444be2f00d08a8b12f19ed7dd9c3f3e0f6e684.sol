1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/PdexMigrate.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\n\ncontract PdexMigrate {\n    address private burnTokenAddress =\n        0x3737373737373737373737373737373737373737;\n\n    event PdexMigratedEvent(uint256 amount, bytes32 pdexAddress);\n\n    function migrate(\n        address _tokenOwnerAddress,\n        bytes32 _recipient,\n        uint256 _amount\n    ) public {\n        // Pdex Mainnet address => 0xF59ae934f6fe444afC309586cC60a84a0F89Aaea\n        require(\n            IERC20(0xF59ae934f6fe444afC309586cC60a84a0F89Aaea).transferFrom(\n                _tokenOwnerAddress,\n                burnTokenAddress,\n                _amount\n            ),\n            \"Contract token allowances insufficient to complete this migration\"\n        );\n        emit PdexMigratedEvent(_amount, _recipient);\n    }\n}\n"
6     },
7     "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"
9     }
10   },
11   "settings": {
12     "optimizer": {
13       "enabled": false,
14       "runs": 200
15     },
16     "outputSelection": {
17       "*": {
18         "*": [
19           "evm.bytecode",
20           "evm.deployedBytecode",
21           "abi"
22         ]
23       }
24     },
25     "libraries": {}
26   }
27 }}