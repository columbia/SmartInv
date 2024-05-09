{{
  "language": "Solidity",
  "sources": {
    "contracts/shared/libraries/Multisend.sol": {
      "content": "// SPDX-License-Identifier: LGPL-3.0-only\npragma solidity ^0.8.0;\n\n/**\n * @notice Modified from https://github.com/safe-global/safe-contracts/blob/main/contracts/libraries/MultiSend.sol\n *\n * @dev Modification was to ensure this is called from an EOA, rather than enforcing the\n * `delegatecall` usage as in the original contract.\n */\ncontract MultiSend {\n  address private immutable multisendSingleton;\n\n  constructor() {\n    multisendSingleton = address(this);\n  }\n\n  /**\n   * @dev Sends multiple transactions and reverts all if one fails.\n   * @param transactions Encoded transactions. Each transaction is encoded as a packed bytes of\n   *                     operation as a uint8 with 0 for a call or 1 for a delegatecall (=> 1 byte),\n   *                     to as a address (=> 20 bytes),\n   *                     value as a uint256 (=> 32 bytes),\n   *                     data length as a uint256 (=> 32 bytes),\n   *                     data as bytes.\n   *                     see abi.encodePacked for more information on packed encoding\n   */\n  function multiSend(bytes memory transactions) public payable {\n    require(msg.sender.code.length == 0, \"MultiSend should only be called via EOA\");\n    // solhint-disable-next-line no-inline-assembly\n    assembly {\n      let length := mload(transactions)\n      let i := 0x20\n      for {\n        // Pre block is not used in \"while mode\"\n      } lt(i, length) {\n        // Post block is not used in \"while mode\"\n      } {\n        // First byte of the data is the operation.\n        // We shift by 248 bits (256 - 8 [operation byte]) it right since mload will always load 32 bytes (a word).\n        // This will also zero out unused data.\n        let operation := shr(0xf8, mload(add(transactions, i)))\n        // We offset the load address by 1 byte (operation byte)\n        // We shift it right by 96 bits (256 - 160 [20 address bytes]) to right-align the data and zero out unused data.\n        let to := shr(0x60, mload(add(transactions, add(i, 0x01))))\n        // We offset the load address by 21 byte (operation byte + 20 address bytes)\n        let value := mload(add(transactions, add(i, 0x15)))\n        // We offset the load address by 53 byte (operation byte + 20 address bytes + 32 value bytes)\n        let dataLength := mload(add(transactions, add(i, 0x35)))\n        // We offset the load address by 85 byte (operation byte + 20 address bytes + 32 value bytes + 32 data length bytes)\n        let data := add(transactions, add(i, 0x55))\n        let success := 0\n        switch operation\n        case 0 {\n          success := call(gas(), to, value, data, dataLength, 0, 0)\n        }\n        case 1 {\n          success := delegatecall(gas(), to, data, dataLength, 0, 0)\n        }\n        if eq(success, 0) {\n          revert(0, 0)\n        }\n        // Next entry starts at 85 byte + data length\n        i := add(i, add(0x55, dataLength))\n      }\n    }\n  }\n}\n"
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}