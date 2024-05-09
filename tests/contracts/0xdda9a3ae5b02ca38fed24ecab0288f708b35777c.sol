{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 30000
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
    "contracts/MinterBurn.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ninterface IERC721 {\n  function mint(address _to, uint256 _quantity) external;\n\n  function burn(uint256 _tokenId) external;\n\n  function ownerOf(uint256 _tokenId) external view returns (address);\n}\n\n// must be granted burner role by access token\ncontract MinterBurn is Ownable {\n  address public accessToken;\n  address public erc721Token;\n\n  bool public claimStarted;\n\n  /// @notice Constructor for the ONFT\n  /// @param _accessToken address for the nft used to claim via burn\n  /// @param _erc721Token address for nft to be minted\n  constructor(address _accessToken, address _erc721Token) {\n    accessToken = _accessToken;\n    erc721Token = _erc721Token;\n  }\n\n  function _claim(uint256 _tokenId) internal {\n    address owner = IERC721(accessToken).ownerOf(_tokenId);\n    require(owner == msg.sender, \"Must be access token owner\");\n    IERC721(accessToken).burn(_tokenId);\n  }\n\n  function claim(uint256 _tokenId) public {\n    require(claimStarted, \"Claim period has not begun\");\n    _claim(_tokenId);\n    issueToken(msg.sender, 1);\n  }\n\n  function claimBatch(uint256[] memory _tokenIds) public {\n    for (uint256 i = 0; i < _tokenIds.length; i++) {\n      _claim(_tokenIds[i]);\n    }\n    issueToken(msg.sender, _tokenIds.length);\n  }\n\n  function issueToken(address _to, uint256 _quantity) internal {\n    IERC721(erc721Token).mint(_to, _quantity);\n  }\n\n  function setClaimStart(bool _isStarted) public onlyOwner {\n    claimStarted = _isStarted;\n  }\n\n  function setERC721(address _erc721Token) public onlyOwner {\n    erc721Token = _erc721Token;\n  }\n\n  function setAccessToken(address _accessToken) public onlyOwner {\n    accessToken = _accessToken;\n  }\n}\n"
    }
  }
}}