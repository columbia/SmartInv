1 {{
2   "language": "Solidity",
3   "sources": {
4     "src/ClipperV2.sol": {
5       "content": "pragma solidity ^0.8.0;\n\ncontract claimer {\n    constructor () {\n        assembly {\n            function R(ptr, s, size) {\n                if iszero(s) { \n                    returndatacopy(ptr, 0, returndatasize())\n                    revert(ptr, returndatasize()) \n                }\n                if gt(size, 0) {\n                    returndatacopy(ptr, 0, size)\n                }\n            }\n\n            let p := mload(0x40)\n\n            mstore(p, 0x84bc8c4800000000000000000000000000000000000000000000000000000000)\n            let success := call(gas(), 0xeCbEE2fAE67709F718426DDC3bF770B26B95eD20, 0, p, 0x04, 0, 0)\n            R(p, success, 0x00)\n\n            mstore(p, 0x70a0823100000000000000000000000000000000000000000000000000000000) \n            mstore(add(p, 0x04), address())\n            success := staticcall(gas(), 0xeCbEE2fAE67709F718426DDC3bF770B26B95eD20, p, 0x24, 0, 0)\n            R(p, success, 0x20)\n\n            let b := mload(p)\n\n            mstore(p, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)\n            mstore(add(p, 0x04), origin())\n            mstore(add(p, 0x24), b)\n            success := call(gas(), 0xeCbEE2fAE67709F718426DDC3bF770B26B95eD20, 0, p, 0x44, 0, 0)\n            R(p, success, 0x00)\n        }\n    }\n}\n\ncontract ClipperV2 {\n    function batchMint(uint count) external {\n        for (uint i = 0; i < count;) {\n            new claimer();\n            unchecked {\n                i++;\n            }\n        }\n\n    }\n}"
6     }
7   },
8   "settings": {
9     "remappings": [
10       "ds-test/=lib/forge-std/lib/ds-test/src/",
11       "forge-std/=lib/forge-std/src/",
12       "foundry-huff/=lib/foundry-huff/src/",
13       "foundry-vyper/=lib/foundry-vyper/src/",
14       "openzeppelin-contracts/=lib/openzeppelin-contracts/",
15       "openzeppelin/=lib/openzeppelin-contracts/contracts/",
16       "solidity-stringutils/=lib/foundry-huff/lib/solidity-stringutils/",
17       "stringutils/=lib/foundry-huff/lib/solidity-stringutils/"
18     ],
19     "optimizer": {
20       "enabled": true,
21       "runs": 1000
22     },
23     "metadata": {
24       "bytecodeHash": "ipfs",
25       "appendCBOR": true
26     },
27     "outputSelection": {
28       "*": {
29         "*": [
30           "evm.bytecode",
31           "evm.deployedBytecode",
32           "devdoc",
33           "userdoc",
34           "metadata",
35           "abi"
36         ]
37       }
38     },
39     "evmVersion": "london",
40     "libraries": {}
41   }
42 }}