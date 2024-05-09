{{
  "language": "Solidity",
  "sources": {
    "contracts/Mailer.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nimport \"./interfaces/IZKBridgeEntrypoint.sol\";\r\nimport \"./interfaces/IZKBridgeReceiver.sol\";\r\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\r\n\r\n/// @title Mailer\r\n/// @notice An example contract for sending messages to other chains, using the ZKBridgeEntrypoint.\r\ncontract Mailer is Ownable {\r\n    /// @notice The ZKBridgeEntrypoint contract, which sends messages to other chains.\r\n    IZKBridgeEntrypoint public zkBridgeEntrypoint;\r\n\r\n    uint256 public fee;\r\n\r\n    event MessageSend(uint64 indexed sequence, uint32 indexed dstChainId, address indexed dstAddress, address sender, address recipient, string message);\r\n\r\n    constructor(address zkBridgeEntrypointAddress) {\r\n        zkBridgeEntrypoint = IZKBridgeEntrypoint(zkBridgeEntrypointAddress);\r\n    }\r\n\r\n    /// @notice Sends a message to a destination MessageBridge.\r\n    /// @param dstChainId The chain ID where the destination MessageBridge.\r\n    /// @param dstAddress The address of the destination MessageBridge.\r\n    /// @param message The message to send.\r\n    function sendMessage(uint16 dstChainId, address dstAddress, address recipient, string memory message) external payable {\r\n        require(msg.value >= fee, \"Insufficient Fee\");\r\n        bytes memory payload = abi.encode(msg.sender, recipient, message);\r\n        uint64 sequence = zkBridgeEntrypoint.send(dstChainId, dstAddress, payload);\r\n        emit MessageSend(sequence, dstChainId, dstAddress,msg.sender, recipient,message);\r\n    }\r\n\r\n    // @notice Allows owner to set a new fee.\r\n    // @param fee The new fee to use.\r\n    function setFee(uint256 _fee) external onlyOwner {\r\n        fee = _fee;\r\n    }\r\n\r\n    // @notice Allows owner to claim all fees sent to this contract.\r\n    function claimFees() external onlyOwner {\r\n        payable(owner()).transfer(address(this).balance);\r\n    }\r\n\r\n}\r\n"
    },
    "contracts/interfaces/IZKBridgeEntrypoint.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IZKBridgeEntrypoint {\r\n    function send(uint16 dstChainId, address dstAddress, bytes memory payload) external payable returns (uint64 sequence);\r\n}\r\n"
    },
    "contracts/interfaces/IZKBridgeReceiver.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IZKBridgeReceiver {\r\n    // @notice ZKBridge endpoint will invoke this function to deliver the message on the destination\r\n    // @param srcChainId - the source endpoint identifier\r\n    // @param srcAddress - the source sending contract address from the source chain\r\n    // @param sequence - the ordered message nonce\r\n    // @param payload - the signed payload is the UA bytes has encoded to be sent\r\n    function zkReceive(uint16 srcChainId, address srcAddress, uint64 sequence, bytes calldata payload) external;\r\n}\r\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
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