1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "enabled": true,
12       "runs": 1000
13     },
14     "remappings": [],
15     "outputSelection": {
16       "*": {
17         "*": [
18           "evm.bytecode",
19           "evm.deployedBytecode",
20           "abi"
21         ]
22       }
23     }
24   },
25   "sources": {
26     "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
27       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.7.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"
28     },
29     "src/Interfaces/IIQERC20.sol": {
30       "content": "// SPDX-License-Identifier: AGPL-3.0\n\npragma solidity 0.7.1;\n\nimport \"./IMinter.sol\";\n\n// solhint-disable-next-line no-empty-blocks\ninterface IIQERC20 {\n    function mint(address _addr, uint256 _amount) external;\n\n    function burn(address _addr, uint256 _amount) external;\n\n    function setMinter(IMinter _addr) external;\n\n    function minter() external view returns (address);\n}\n"
31     },
32     "src/Interfaces/IMinter.sol": {
33       "content": "// SPDX-License-Identifier: AGPL-3.0\n\npragma solidity 0.7.1;\n\ninterface IMinter {\n    event Minted(address _sender, uint256 _amount);\n    event Burned(address _sender, uint256 _amount);\n\n    function mint(uint256 _amount) external;\n\n    function burn(uint256 _amount) external;\n\n    function iQ() external view returns (address);\n\n    function wrappedIQ() external view returns (address);\n}\n"
34     },
35     "src/Minters/TokenMinter.sol": {
36       "content": "// SPDX-License-Identifier: AGPL-3.0\npragma solidity 0.7.1;\n\nimport \"../Interfaces/IMinter.sol\";\nimport \"../Interfaces/IIQERC20.sol\";\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\n\ncontract TokenMinter is IMinter {\n    IIQERC20 private _iQ;\n    IERC20 private _wrappedIQ;\n    bool internal locked;\n\n    modifier blockReentrancy {\n        require(!locked, \"Contract is locked\");\n        locked = true;\n        _;\n        locked = false;\n    }\n\n    constructor(IIQERC20 iQ, IERC20 wrappedIQ) {\n        _iQ = iQ;\n        _wrappedIQ = wrappedIQ;\n    }\n\n    function mint(uint256 _amount) external override blockReentrancy {\n        require(_wrappedIQ.transferFrom(msg.sender, address(this), _amount), \"Transfer has failed\");\n        _iQ.mint(msg.sender, _amount);\n        emit Minted(msg.sender, _amount);\n    }\n\n    function burn(uint256 _amount) external override blockReentrancy {\n        _iQ.burn(msg.sender, _amount);\n        require(_wrappedIQ.transfer(msg.sender, _amount), \"Transfer has failed\");\n        emit Burned(msg.sender, _amount);\n    }\n\n    function transferWrapped(address _addr, uint256 _amount) external {\n        require(msg.sender == Ownable(address(_iQ)).owner(), \"Only IQ owner can tranfer wrapped tokens\");\n        require(address(this) != _iQ.minter(), \"Minter is still in use\");\n        require(_wrappedIQ.transfer(_addr, _amount), \"Transfer has failed\");\n    }\n\n    function iQ() external view override returns (address) {\n        return address(_iQ);\n    }\n\n    function wrappedIQ() external view override returns (address) {\n        return address(_wrappedIQ);\n    }\n}\n\nabstract contract Ownable {\n    function owner() public view virtual returns (address);\n}\n"
37     }
38   }
39 }}