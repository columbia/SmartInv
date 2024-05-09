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
12       "runs": 30000
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
35     "contracts/MinterWhitelist.sol": {
36       "content": "pragma solidity ^0.8.0;\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface IERC721 {\n  function mint(address to, uint256 quantity) external;\n\n  function max() external view returns (uint256);\n\n  function totalSupply() external view returns (uint256);\n}\n\ncontract MinterWhitelist is Ownable {\n  IERC721 public erc721;\n  mapping(address => uint256) public whitelistA;\n  mapping(address => bool) public whitelistB;\n\n  uint256 public whitelistSize;\n  uint256 public mintedA;\n  uint256 public mintedB;\n  uint256 public mintQuantityB;\n\n  bool public publicMint;\n  bool public wlMint;\n\n  constructor(IERC721 _erc721) public {\n    erc721 = _erc721;\n    mintQuantityB = 1;\n  }\n\n  function viewAllocationB() public view returns (uint256) {\n    return erc721.max() - erc721.totalSupply() - whitelistSize;\n  }\n\n  function mint() public {\n    require(wlMint, \"mint not started\");\n    require(\n      whitelistA[msg.sender] > 0 || whitelistB[msg.sender],\n      \"Address not whitelisted\"\n    );\n    if (whitelistA[msg.sender] > 0) {\n      erc721.mint(msg.sender, whitelistA[msg.sender]);\n      mintedA = mintedA + whitelistA[msg.sender];\n      whitelistSize = whitelistSize - whitelistA[msg.sender];\n      whitelistA[msg.sender] = 0;\n      return;\n    }\n    require(viewAllocationB() > 0, \"Only reserved mints left\");\n    uint256 quantity = mintQuantityB;\n    if (viewAllocationB() - mintedB < mintQuantityB) {\n      quantity = viewAllocationB() - mintedB;\n    }\n    erc721.mint(msg.sender, quantity);\n    whitelistB[msg.sender] = false;\n    mintedB = mintedB + quantity;\n  }\n\n  function setERC721(IERC721 _erc721) public onlyOwner {\n    erc721 = _erc721;\n  }\n\n  function setMintQuantityB(uint256 _quantity) public onlyOwner {\n    mintQuantityB = _quantity;\n  }\n\n  function setWLMint(bool _isTrue) public onlyOwner {\n    wlMint = _isTrue;\n  }\n\n  function setWhitelistA(\n    address[] memory _whitelist,\n    uint256[] memory _quantities\n  ) public onlyOwner {\n    for (uint256 i = 0; i < _whitelist.length; i++) {\n      whitelistSize =\n        whitelistSize +\n        _quantities[i] -\n        whitelistA[_whitelist[i]];\n      whitelistA[_whitelist[i]] = _quantities[i];\n    }\n  }\n\n  function revokeWhitelistA(address[] memory _whitelist) public onlyOwner {\n    for (uint256 i = 0; i < _whitelist.length; i++) {\n      whitelistSize = whitelistSize - whitelistA[_whitelist[i]];\n      whitelistA[_whitelist[i]] = 0;\n    }\n  }\n\n  function setWhitelistB(address[] memory _whitelist) public onlyOwner {\n    for (uint256 i = 0; i < _whitelist.length; i++) {\n      whitelistB[_whitelist[i]] = true;\n    }\n  }\n\n  function revokeWhitelistB(address[] memory _whitelist) public onlyOwner {\n    for (uint256 i = 0; i < _whitelist.length; i++) {\n      whitelistB[_whitelist[i]] = false;\n    }\n  }\n}\n"
37     }
38   }
39 }}