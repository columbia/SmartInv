{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "paris",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 1000
    },
    "remappings": [],
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
    }
  },
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "contracts/TheMysticEmporium.sol": {
      "content": "// SPDX-License-Identifier: None\n\npragma solidity ^0.8.19;\n\nimport {Ownable} from \"@openzeppelin/contracts/access/Ownable.sol\";\n\nerror WrongEtherAmount();\nerror WithdrawalFailed();\nerror ArrayLengthMismatch();\n\ncontract TheMysticEmporium is Ownable {\n  struct Item {\n    uint256 id;\n    uint256 price;\n  }\n\n  mapping(uint256 => Item) public itemsForSale;\n\n  event ItemsPurchased(address buyer, uint256[] itemIds, uint256[] quantities);\n\n  constructor(address deployer) {\n    _transferOwnership(deployer);\n  }\n\n  function buyItems(\n    uint256[] calldata ids,\n    uint256[] calldata quantities\n  ) external payable {\n    if (ids.length != quantities.length) revert ArrayLengthMismatch();\n\n    uint256 totalCost;\n    uint256 len = ids.length;\n\n    for (uint256 i = 0; i < len; ) {\n      totalCost += itemsForSale[ids[i]].price * quantities[i];\n\n      unchecked {\n        ++i;\n      }\n    }\n\n    if (msg.value != totalCost) revert WrongEtherAmount();\n\n    emit ItemsPurchased(msg.sender, ids, quantities);\n  }\n\n  function addItem(uint256 id, uint256 price) external onlyOwner {\n    itemsForSale[id] = Item(id, price);\n  }\n\n  function withdraw() external onlyOwner {\n    (bool success, ) = payable(owner()).call{value: address(this).balance}(\"\");\n\n    if (!success) {\n      revert WithdrawalFailed();\n    }\n  }\n}\n"
    }
  }
}}