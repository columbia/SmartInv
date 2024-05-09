1 {{
2   "language": "Solidity",
3   "sources": {
4     "/Users/adrianhara/work/eth/rewarder/contracts/Presale.sol": {
5       "content": "pragma solidity ^0.6.12;\n\nimport \"@openzeppelin/contracts/GSN/Context.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ncontract Presale is Context, Ownable {\n    uint256 public minContribution = 0.5 ether;\n    uint256 public maxContribution = 1 ether;\n    uint256 public totalContributed = 0;\n    uint256 public totalCap = 50 ether;\n\n    address payable wallet = 0x2963B4311e07da3D9c50F2e1eb14659e42e3f4A9;\n\n    mapping(address => uint256) public contributions;\n\n    receive() external payable {\n        require(totalContributed + msg.value <= totalCap, \"Cap reached\");\n        require(msg.value >= minContribution && msg.value <= maxContribution, \"Min contribution 0.5 max 1 ETH\");\n        require(contributions[msg.sender] + msg.value <= maxContribution, \"Max contribution per wallet 1 ETH\");\n\n        totalContributed += msg.value;\n        contributions[msg.sender] += msg.value;\n    }\n\n    function setWallet(address payable newWallet) external onlyOwner() {\n        wallet = newWallet;\n    }\n\n    function collectFunds() external onlyOwner() {\n        wallet.transfer(address(this).balance);\n    }\n}\n"
6     },
7     "@openzeppelin/contracts/GSN/Context.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.6.0 <0.8.0;\n\nimport \"../utils/Context.sol\";\n"
9     },
10     "@openzeppelin/contracts/access/Ownable.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.6.0 <0.8.0;\n\nimport \"../utils/Context.sol\";\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor () internal {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n"
12     },
13     "@openzeppelin/contracts/utils/Context.sol": {
14       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.6.0 <0.8.0;\n\n/*\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with GSN meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n"
15     }
16   },
17   "settings": {
18     "remappings": [],
19     "optimizer": {
20       "enabled": false,
21       "runs": 200
22     },
23     "evmVersion": "istanbul",
24     "libraries": {},
25     "outputSelection": {
26       "*": {
27         "*": [
28           "evm.bytecode",
29           "evm.deployedBytecode",
30           "abi"
31         ]
32       }
33     }
34   }
35 }}