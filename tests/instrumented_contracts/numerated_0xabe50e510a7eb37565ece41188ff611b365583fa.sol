1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/CryptidMigrate.sol": {
5       "content": "/*\n*/\n\n//SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol\";\n\ninterface ICryptid {\n    function ownerMint(uint256 numberOfTokens) external;\n    function transferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external;\n    function getLastTokenId() external view returns (uint256);\n    function transferOwnership(address newOwner) external;\n\n\n}\n\ncontract CryptidsFreeMint is Ownable, IERC721Receiver {\n\n\n    ICryptid public constant CRYPTID = ICryptid(0x0B68BE2e1072204E68c6C0b8b46ac108E3E3dDd0);\n\n    bool public isPublicSaleActive;\n\n    mapping(address => bool) public claimed;\n\n    // ============ ACCESS CONTROL/SANITY MODIFIERS ============\n\n    modifier publicSaleActive() {\n        require(isPublicSaleActive, \"Public sale is not open\");\n        _;\n    }\n\n    // ---  PUBLIC MINTING FUNCTIONS ---\n\n    // mint allows for regular minting while the supply does not exceed maxCryptids.\n    function mint()\n        external\n    {\n        require(claimed[msg.sender] == false, \"already claimed\");\n        claimed[msg.sender] = true;\n        CRYPTID.ownerMint(2);\n        CRYPTID.transferFrom(address(this), msg.sender, (CRYPTID.getLastTokenId() - 1));\n        CRYPTID.transferFrom(address(this), msg.sender, CRYPTID.getLastTokenId());\n    }\n\n    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public override returns (bytes4) {\n            return this.onERC721Received.selector;\n    }\n\n    function returnOwnership() public onlyOwner {\n        CRYPTID.transferOwnership(owner());\n    }\n}"
6     },
7     "@openzeppelin/contracts/access/Ownable.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
9     },
10     "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @title ERC721 token receiver interface\n * @dev Interface for any contract that wants to support safeTransfers\n * from ERC721 asset contracts.\n */\ninterface IERC721Receiver {\n    /**\n     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}\n     * by `operator` from `from`, this function is called.\n     *\n     * It must return its Solidity selector to confirm the token transfer.\n     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.\n     *\n     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.\n     */\n    function onERC721Received(\n        address operator,\n        address from,\n        uint256 tokenId,\n        bytes calldata data\n    ) external returns (bytes4);\n}\n"
12     },
13     "@openzeppelin/contracts/utils/Context.sol": {
14       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
15     }
16   },
17   "settings": {
18     "optimizer": {
19       "enabled": true,
20       "runs": 5000
21     },
22     "outputSelection": {
23       "*": {
24         "*": [
25           "evm.bytecode",
26           "evm.deployedBytecode",
27           "devdoc",
28           "userdoc",
29           "metadata",
30           "abi"
31         ]
32       }
33     },
34     "libraries": {}
35   }
36 }}