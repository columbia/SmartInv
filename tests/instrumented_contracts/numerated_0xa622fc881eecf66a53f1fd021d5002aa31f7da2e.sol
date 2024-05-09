1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "london",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "enabled": true,
12       "runs": 200
13     },
14     "remappings": [],
15     "outputSelection": {
16       "*": {
17         "*": [
18           "evm.bytecode",
19           "evm.deployedBytecode",
20           "devdoc",
21           "userdoc",
22           "metadata",
23           "abi"
24         ]
25       }
26     }
27   },
28   "sources": {
29     "@openzeppelin/contracts/access/Ownable.sol": {
30       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
31     },
32     "@openzeppelin/contracts/utils/Context.sol": {
33       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
34     },
35     "contracts/HoneyBearOwner.sol": {
36       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface IMinter {\n    function mintTo(address _to, uint256 _amount) external;\n\n    function setOwner(address _newOwner) external;\n}\n\ncontract HoneyBearOwner is Ownable {\n    IMinter immutable honeyMinter;\n\n    mapping(address => uint) public minted;\n\n    constructor(address _honeyMinter) {\n        honeyMinter = IMinter(_honeyMinter);\n    }\n\n    function mint(uint _amount) public {\n        require(minted[_msgSender()] + _amount < 6, \"Max Mint Reached\");\n\n        minted[_msgSender()] += _amount;\n        honeyMinter.mintTo(_msgSender(), _amount);\n    }\n\n    function setOwner(address _newOwner) external onlyOwner {\n        honeyMinter.setOwner(_newOwner);\n    }\n}\n"
37     }
38   }
39 }}