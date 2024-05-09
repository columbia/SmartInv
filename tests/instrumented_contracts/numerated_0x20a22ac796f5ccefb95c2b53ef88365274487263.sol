1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/EveraiUpgradeArchive.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface IEveraiMemoryCore {\n    function ownerOf(uint256 tokenId) external view returns (address);\n\n    function burn(uint256 tokenId) external;\n\n    function mint(address to, uint256 quantity) external;\n}\n\ninterface IEveraiOriginArchive {\n    function ownerOf(uint256 tokenId) external view returns (address);\n\n    function burn(uint256 tokenId) external;\n\n    function upgrade(uint256 tokenId, uint16 memoryCoreType) external;\n}\n\ncontract EveraiUpgradeArchive is Ownable {\n    IEveraiMemoryCore public everaiMemoryCore;\n    IEveraiOriginArchive public everaiOriginArchive;\n\n    event Link(uint256 _archiveId);\n\n    constructor(\n        address everaiMemoryCoreAddress,\n        address everaiOriginArchiveAddress\n    ) {\n        everaiMemoryCore = IEveraiMemoryCore(everaiMemoryCoreAddress);\n        everaiOriginArchive = IEveraiOriginArchive(everaiOriginArchiveAddress);\n    }\n\n    modifier callerIsUser() {\n        require(tx.origin == msg.sender, \"the caller is another contract\");\n        _;\n    }\n\n    function link(uint16 archiveId, uint256[] memory memoryCoreIds)\n        external\n        callerIsUser\n    {\n        address originArchiveOwner = everaiOriginArchive.ownerOf(archiveId);\n        require(\n            originArchiveOwner == msg.sender,\n            \"the caller must be owner of the origin archive\"\n        );\n\n        for (uint256 i = 0; i < memoryCoreIds.length; i++) {\n            uint256 tokenId = memoryCoreIds[i];\n            require(\n                everaiMemoryCore.ownerOf(tokenId) == msg.sender,\n                \"the caller must be owner of the selected memory core\"\n            );\n            everaiMemoryCore.burn(tokenId);\n        }\n\n        everaiOriginArchive.upgrade(archiveId, archiveId);\n        emit Link(archiveId);\n    }\n\n    function burnMemoryCore(uint256 id) external onlyOwner {\n        everaiMemoryCore.burn(id);\n    }\n}\n"
6     },
7     "@openzeppelin/contracts/access/Ownable.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
9     },
10     "@openzeppelin/contracts/utils/Context.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
12     }
13   },
14   "settings": {
15     "optimizer": {
16       "enabled": false,
17       "runs": 200
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