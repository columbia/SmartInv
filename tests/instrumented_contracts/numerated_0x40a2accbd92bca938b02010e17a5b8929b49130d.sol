1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "ipfs",
8       "useLiteralContent": true
9     },
10     "optimizer": {
11       "enabled": false,
12       "runs": 200
13     },
14     "remappings": [],
15     "outputSelection": {
16       "*": {
17         "*": [
18           "evm.bytecode",
19           "evm.deployedBytecode",
20           "abi"
21         ]
22       }
23     }
24   },
25   "sources": {
26     "contracts/libraries/MultiSendCallOnly.sol": {
27       "content": "// SPDX-License-Identifier: LGPL-3.0-only\npragma solidity >=0.7.0 <0.9.0;\n\n/// @title Multi Send Call Only - Allows to batch multiple transactions into one, but only calls\n/// @author Stefan George - <stefan@gnosis.io>\n/// @author Richard Meissner - <richard@gnosis.io>\n/// @notice The guard logic is not required here as this contract doesn't support nested delegate calls\ncontract MultiSendCallOnly {\n    /// @dev Sends multiple transactions and reverts all if one fails.\n    /// @param transactions Encoded transactions. Each transaction is encoded as a packed bytes of\n    ///                     operation has to be uint8(0) in this version (=> 1 byte),\n    ///                     to as a address (=> 20 bytes),\n    ///                     value as a uint256 (=> 32 bytes),\n    ///                     data length as a uint256 (=> 32 bytes),\n    ///                     data as bytes.\n    ///                     see abi.encodePacked for more information on packed encoding\n    /// @notice The code is for most part the same as the normal MultiSend (to keep compatibility),\n    ///         but reverts if a transaction tries to use a delegatecall.\n    /// @notice This method is payable as delegatecalls keep the msg.value from the previous call\n    ///         If the calling method (e.g. execTransaction) received ETH this would revert otherwise\n    function multiSend(bytes memory transactions) public payable {\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            let length := mload(transactions)\n            let i := 0x20\n            for {\n                // Pre block is not used in \"while mode\"\n            } lt(i, length) {\n                // Post block is not used in \"while mode\"\n            } {\n                // First byte of the data is the operation.\n                // We shift by 248 bits (256 - 8 [operation byte]) it right since mload will always load 32 bytes (a word).\n                // This will also zero out unused data.\n                let operation := shr(0xf8, mload(add(transactions, i)))\n                // We offset the load address by 1 byte (operation byte)\n                // We shift it right by 96 bits (256 - 160 [20 address bytes]) to right-align the data and zero out unused data.\n                let to := shr(0x60, mload(add(transactions, add(i, 0x01))))\n                // We offset the load address by 21 byte (operation byte + 20 address bytes)\n                let value := mload(add(transactions, add(i, 0x15)))\n                // We offset the load address by 53 byte (operation byte + 20 address bytes + 32 value bytes)\n                let dataLength := mload(add(transactions, add(i, 0x35)))\n                // We offset the load address by 85 byte (operation byte + 20 address bytes + 32 value bytes + 32 data length bytes)\n                let data := add(transactions, add(i, 0x55))\n                let success := 0\n                switch operation\n                    case 0 {\n                        success := call(gas(), to, value, data, dataLength, 0, 0)\n                    }\n                    // This version does not allow delegatecalls\n                    case 1 {\n                        revert(0, 0)\n                    }\n                if eq(success, 0) {\n                    revert(0, 0)\n                }\n                // Next entry starts at 85 byte + data length\n                i := add(i, add(0x55, dataLength))\n            }\n        }\n    }\n}\n"
28     }
29   }
30 }}