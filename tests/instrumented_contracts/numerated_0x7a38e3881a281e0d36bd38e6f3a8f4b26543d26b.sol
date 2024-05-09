1 {{
2   "language": "Solidity",
3   "sources": {
4     "@openzeppelin/contracts/access/Ownable.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
6     },
7     "@openzeppelin/contracts/utils/Context.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
9     },
10     "contracts/Burn.sol": {
11       "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.9;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\n// import \"hardhat/console.sol\";\n\ninterface IToken {\n    function burnFT(address, uint256, uint256) external;\n\n    function mintNFT(address to, uint16 tier, uint256 quantity) external;\n}\n\nstruct TokenMap {\n    bool enabled;\n    uint16 tier;\n    uint256 quantity;\n}\n\ncontract Burn is Ownable {\n    address private _tokenAddress;\n    bool private _enabled;\n\n    mapping(uint256 => TokenMap) _tokenToTier;\n\n    function setEnabled(bool b) public onlyOwner {\n        _enabled = b;\n    }\n\n    function setTokenAddress(address addr) public onlyOwner {\n        _tokenAddress = addr;\n    }\n\n    function setMapping(\n        uint256 fungibleID,\n        bool enabled,\n        uint16 tier,\n        uint256 quantity\n    ) public onlyOwner {\n        _tokenToTier[fungibleID] = TokenMap(enabled, tier, quantity);\n    }\n\n    function breakCrate(address to, uint256 token, uint256 quantity) public {\n        require(_enabled == true, \"Breaking is not enabled.\");\n        require(_tokenToTier[token].enabled, \"Token not configured.\");\n\n        // console.log(\"burning FTs\", token, quantity);\n\n        IToken(_tokenAddress).burnFT(_msgSender(), token, quantity);\n\n        // console.log(\n        //     \"minting NFTs\",\n        //     _tokenToTier[token].tier,\n        //     _tokenToTier[token].quantity * quantity\n        // );\n\n        IToken(_tokenAddress).mintNFT(\n            to,\n            _tokenToTier[token].tier,\n            _tokenToTier[token].quantity * quantity\n        );\n\n        // console.log(\"done with break\");\n    }\n}\n"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": true,
17       "runs": 20000
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "devdoc",
25           "userdoc",
26           "metadata",
27           "abi"
28         ]
29       }
30     },
31     "libraries": {}
32   }
33 }}