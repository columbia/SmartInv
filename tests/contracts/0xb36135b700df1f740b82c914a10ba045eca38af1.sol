{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "contracts/lybra/helpers/TokenHelper.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\npragma solidity ^0.8.17;\n\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface IERC20 {\n    function mint(address user, uint256 amount) external returns(bool);\n    function burn(address user, uint256 amount) external returns(bool);\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n\ncontract TokenHelper is Ownable {\n    IERC20 public immutable esLBR;\n    IERC20 public immutable LBR;\n    IERC20 public immutable oldLBR;\n    uint256 public deadline;\n   \n    event BatchEsLBRForUsers(address indexed caller, string desc, uint256 total);\n    event BatchLBRForUsers(address indexed caller, string desc, uint256 total);\n\n    constructor(address _esLBR, address _LBR, address _oldLBR, uint256 _deadline) {\n        esLBR = IERC20(_esLBR);\n        LBR = IERC20(_LBR);\n        oldLBR = IERC20(_oldLBR);\n        deadline = _deadline;\n    }\n\n    function airdropEsLBR(address[] calldata to, uint256[] calldata value, string memory desc) external onlyOwner {\n        require(block.timestamp <= deadline);\n        uint256 total = 0;\n        for(uint256 i = 0; i < to.length; i++){\n            esLBR.mint(to[i], value[i]);\n            total += value[i];\n        }\n        emit BatchEsLBRForUsers(msg.sender, desc, total);\n    }\n\n    function airdropLBR(address[] calldata to, uint256[] calldata value, string memory desc) external onlyOwner {\n        require(block.timestamp <= deadline);\n        uint256 total = 0;\n        for(uint256 i = 0; i < to.length; i++){\n            LBR.mint(to[i], value[i]);\n            total += value[i];\n        }\n        emit BatchLBRForUsers(msg.sender, desc, total);\n    }\n\n    function migrate(uint256 amount) external {\n        require(block.timestamp <= deadline);\n        oldLBR.transferFrom(msg.sender, address(this), amount);\n        LBR.mint(msg.sender, amount);\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
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
    },
    "libraries": {}
  }
}}