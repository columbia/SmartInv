1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/utils/Proxy.sol": {
5       "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\nimport \"./LibRawResult.sol\";\nimport \"./Implementation.sol\";\n\n/// @notice Base class for all proxy contracts.\ncontract Proxy {\n    using LibRawResult for bytes;\n\n    /// @notice The address of the implementation contract used by this proxy.\n    Implementation public immutable IMPL;\n\n    // Made `payable` to allow initialized crowdfunds to receive ETH as an\n    // initial contribution.\n    constructor(Implementation impl, bytes memory initCallData) payable {\n        IMPL = impl;\n        (bool s, bytes memory r) = address(impl).delegatecall(initCallData);\n        if (!s) {\n            r.rawRevert();\n        }\n    }\n\n    // Forward all calls to the implementation.\n    fallback() external payable {\n        Implementation impl = IMPL;\n        assembly {\n            calldatacopy(0x00, 0x00, calldatasize())\n            let s := delegatecall(gas(), impl, 0x00, calldatasize(), 0x00, 0)\n            returndatacopy(0x00, 0x00, returndatasize())\n            if iszero(s) {\n                revert(0x00, returndatasize())\n            }\n            return(0x00, returndatasize())\n        }\n    }\n}\n"
6     },
7     "contracts/utils/LibRawResult.sol": {
8       "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\nlibrary LibRawResult {\n    // Revert with the data in `b`.\n    function rawRevert(bytes memory b) internal pure {\n        assembly {\n            revert(add(b, 32), mload(b))\n        }\n    }\n\n    // Return with the data in `b`.\n    function rawReturn(bytes memory b) internal pure {\n        assembly {\n            return(add(b, 32), mload(b))\n        }\n    }\n}\n"
9     },
10     "contracts/utils/Implementation.sol": {
11       "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\n// Base contract for all contracts intended to be delegatecalled into.\nabstract contract Implementation {\n    error OnlyDelegateCallError();\n    error OnlyConstructorError();\n\n    address public immutable IMPL;\n\n    constructor() {\n        IMPL = address(this);\n    }\n\n    // Reverts if the current function context is not inside of a delegatecall.\n    modifier onlyDelegateCall() virtual {\n        if (address(this) == IMPL) {\n            revert OnlyDelegateCallError();\n        }\n        _;\n    }\n\n    // Reverts if the current function context is not inside of a constructor.\n    modifier onlyConstructor() {\n        if (address(this).code.length != 0) {\n            revert OnlyConstructorError();\n        }\n        _;\n    }\n}\n"
12     }
13   },
14   "settings": {
15     "remappings": [
16       "forge-std/=lib/forge-std/src/",
17       "openzeppelin/=lib/openzeppelin-contracts/",
18       "solmate/=lib/solmate/src/",
19       "ds-test/=lib/forge-std/lib/ds-test/src/",
20       "erc4626-tests/=lib/openzeppelin-contracts/lib/erc4626-tests/",
21       "openzeppelin-contracts/=lib/openzeppelin-contracts/",
22       "party-addresses/=lib/party-addresses/"
23     ],
24     "optimizer": {
25       "enabled": true,
26       "runs": 200
27     },
28     "metadata": {
29       "useLiteralContent": false,
30       "bytecodeHash": "ipfs",
31       "appendCBOR": true
32     },
33     "outputSelection": {
34       "*": {
35         "*": [
36           "evm.bytecode",
37           "evm.deployedBytecode",
38           "devdoc",
39           "userdoc",
40           "metadata",
41           "abi"
42         ]
43       }
44     },
45     "evmVersion": "shanghai",
46     "libraries": {
47       "contracts/utils/LibRenderer.sol": {
48         "LibRenderer": "0x39244498e639c4b24910e73dfa3622881d456724"
49       }
50     },
51     "viaIR": true
52   }
53 }}