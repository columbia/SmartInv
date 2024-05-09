1 {{
2   "language": "Solidity",
3   "sources": {
4     "src/DreamZukiCustomizer.sol": {
5       "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.9;\n\nimport \"openzeppelin/access/Ownable.sol\";\n\nerror InsufficientCustomizationFee(uint256 sent, uint256 expected);\nerror CallerIsNotOwner();\n\ninterface IDreamZuki {\n    function ownerOf(uint256 tokenId) external view returns (address owner);\n}\n\ncontract DreamZukiCustomizer is Ownable {\n    address constant public TEAM_WALLET = 0x7Ab93E182f872AB95593d68bcEf9e7D62c1e5D94;\n    address constant public TEAM_WALLET2 = 0x41c3fA3c2512A858b8099fFf112a18A9a65AD3Ca;\n\n    uint256 public customizeFee = 0.0085 ether;\n    IDreamZuki public nft;\n\n    event Customize(uint256 indexed id, uint256[] traits);\n\n    constructor(address nft_) {\n        nft = IDreamZuki(nft_);\n    }\n\n    function customize(uint256 id, uint256[] calldata traits) external payable {\n        if(msg.value < customizeFee) revert InsufficientCustomizationFee(msg.value, customizeFee);\n        if(nft.ownerOf(id) != msg.sender) revert CallerIsNotOwner();\n\n        emit Customize(id, traits);\n    }\n\n    function setCustomizationFee(uint256 fee) external onlyOwner {\n        customizeFee = fee;\n    }\n\n    function withdraw() external onlyOwner {\n        (bool success, ) = TEAM_WALLET.call{value: address(this).balance * 7 / 10}(\"\");\n        require(success, \"Transfer failed.\");\n\n        (bool success2, ) = TEAM_WALLET2.call{value: address(this).balance}(\"\");\n        require(success2, \"Transfer failed.\");\n    }\n}\n"
6     },
7     "lib/openzeppelin-contracts/contracts/access/Ownable.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
9     },
10     "lib/openzeppelin-contracts/contracts/utils/Context.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
12     }
13   },
14   "settings": {
15     "remappings": [
16       "ERC721A/=lib/ERC721A/contracts/",
17       "ds-test/=lib/forge-std/lib/ds-test/src/",
18       "erc4626-tests/=lib/openzeppelin-contracts/lib/erc4626-tests/",
19       "forge-std/=lib/forge-std/src/",
20       "openzeppelin-contracts-upgradeable/=lib/operator-filter-registry/lib/openzeppelin-contracts-upgradeable/",
21       "openzeppelin-contracts/=lib/openzeppelin-contracts/",
22       "openzeppelin/=lib/openzeppelin-contracts/contracts/",
23       "operator-filter-registry/=lib/operator-filter-registry/"
24     ],
25     "optimizer": {
26       "enabled": true,
27       "runs": 200
28     },
29     "metadata": {
30       "bytecodeHash": "ipfs"
31     },
32     "outputSelection": {
33       "*": {
34         "*": [
35           "evm.bytecode",
36           "evm.deployedBytecode",
37           "devdoc",
38           "userdoc",
39           "metadata",
40           "abi"
41         ]
42       }
43     },
44     "evmVersion": "london",
45     "libraries": {}
46   }
47 }}