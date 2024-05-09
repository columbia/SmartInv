{{
  "language": "Solidity",
  "sources": {
    "contracts/SpawnSale2.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.12;\n\nimport \"./interface/IAzimuth.sol\";\nimport \"./interface/IEcliptic.sol\";\nimport \"./interface/IERC721.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/utils/Context.sol\";\n\ncontract UrbitexSpawnSale_v2 is Context, Ownable\n{\n\n  // This contract facilitates the sale of planets via spawning from a host star.\n  // The intent is to be used only by the exchange owner to supply greater inventory to the \n  // marketplace without having to first spawn dozens of planets.\n\n  //  SpawnedPurchase: sale has occurred\n  //\n    event SpawnedPurchase(\n      uint32[] _points\n    );\n\n  //  azimuth: points state data store\n  //\n  IAzimuth public azimuth;\n\n  //  price: fixed price to be set across all planets\n  //\n  uint256 public price;\n\n\n  //  constructor(): configure the points data store and planet price\n  //\n  constructor(IAzimuth _azimuth, uint256 _price)\n  {\n    azimuth = _azimuth;\n    setPrice(_price);\n  }\n\n    //  purchase(): pay the price, acquire ownership of the planets\n    //\n\n    function purchase(uint32[] calldata _points)\n      external\n      payable\n    {\n      // amount transferred must match price set by exchange owner\n      require (msg.value == price*_points.length);\n\n      //  omitting all checks here to save on gas fees (for example if transfer proxy is approved for the star)\n      //  the transaction will just fail in that case regardless, which is intended.\n      // \n      IEcliptic ecliptic = IEcliptic(azimuth.owner());\n\n      //  spawn the planets, then immediately transfer to the buyer\n      // \n      \n      for (uint32 index; index < _points.length; index++) {\n          ecliptic.spawn(_points[index], address(this));\n          ecliptic.transferPoint(_points[index], _msgSender(), false);\n        }\n\n      emit SpawnedPurchase(_points);\n    }\n\n\n    // EXCHANGE OWNER OPERATIONS \n\n    function setPrice(uint256 _price) public onlyOwner {\n      require(0 < _price);\n      price = _price;\n    }\n\n    function withdraw(address payable _target) external onlyOwner  {\n      require(address(0) != _target);\n      _target.transfer(address(this).balance);\n    }\n\n    function close(address payable _target) external onlyOwner  {\n      require(address(0) != _target);\n      selfdestruct(_target);\n    }\n}"
    },
    "contracts/interface/IAzimuth.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.11;\n\ninterface IAzimuth {\n    function owner() external returns (address);\n    function isSpawnProxy(uint32, address) external returns (bool);\n    function hasBeenLinked(uint32) external returns (bool);\n    function getPrefix(uint32) external returns (uint16);\n    function getOwner(uint32) view external returns (address);\n    function canTransfer(uint32, address) view external returns (bool);\n    function isOwner(uint32, address) view external returns (bool);\n    function getKeyRevisionNumber(uint32 _point) view external returns(uint32);\n    function getSpawnCount(uint32 _point) view external returns(uint32);\n}    \n"
    },
    "contracts/interface/IEcliptic.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.11;\n\ninterface IEcliptic {\n    function isApprovedForAll(address, address) external returns (bool);\n    function transferFrom(address, address, uint256) external;\n    function spawn(uint32, address) external;\n    function transferPoint(uint32, address, bool) external;\n\n\n}"
    },
    "contracts/interface/IERC721.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.11;\n\ninterface IERC721Partial {\n    function transferFrom(address from, address to, uint256 tokenId) external;\n}\n\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _setOwner(_msgSender());\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _setOwner(newOwner);\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 100000
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