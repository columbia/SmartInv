{{
  "language": "Solidity",
  "sources": {
    "contracts/utils/Proxy.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\nimport \"./LibRawResult.sol\";\nimport \"./Implementation.sol\";\n\n/// @notice Base class for all proxy contracts.\ncontract Proxy {\n    using LibRawResult for bytes;\n\n    /// @notice The address of the implementation contract used by this proxy.\n    Implementation public immutable IMPL;\n\n    // Made `payable` to allow initialized crowdfunds to receive ETH as an\n    // initial contribution.\n    constructor(Implementation impl, bytes memory initCallData) payable {\n        IMPL = impl;\n        (bool s, bytes memory r) = address(impl).delegatecall(initCallData);\n        if (!s) {\n            r.rawRevert();\n        }\n    }\n\n    // Forward all calls to the implementation.\n    fallback() external payable {\n        Implementation impl = IMPL;\n        assembly {\n            calldatacopy(0x00, 0x00, calldatasize())\n            let s := delegatecall(gas(), impl, 0x00, calldatasize(), 0x00, 0)\n            returndatacopy(0x00, 0x00, returndatasize())\n            if iszero(s) {\n                revert(0x00, returndatasize())\n            }\n            return(0x00, returndatasize())\n        }\n    }\n}\n"
    },
    "contracts/utils/LibRawResult.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\nlibrary LibRawResult {\n    // Revert with the data in `b`.\n    function rawRevert(bytes memory b) internal pure {\n        assembly {\n            revert(add(b, 32), mload(b))\n        }\n    }\n\n    // Return with the data in `b`.\n    function rawReturn(bytes memory b) internal pure {\n        assembly {\n            return(add(b, 32), mload(b))\n        }\n    }\n}\n"
    },
    "contracts/utils/Implementation.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.8.20;\n\n// Base contract for all contracts intended to be delegatecalled into.\nabstract contract Implementation {\n    error OnlyDelegateCallError();\n    error OnlyConstructorError();\n\n    address public immutable IMPL;\n\n    constructor() {\n        IMPL = address(this);\n    }\n\n    // Reverts if the current function context is not inside of a delegatecall.\n    modifier onlyDelegateCall() virtual {\n        if (address(this) == IMPL) {\n            revert OnlyDelegateCallError();\n        }\n        _;\n    }\n\n    // Reverts if the current function context is not inside of a constructor.\n    modifier onlyConstructor() {\n        if (address(this).code.length != 0) {\n            revert OnlyConstructorError();\n        }\n        _;\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "forge-std/=lib/forge-std/src/",
      "openzeppelin/=lib/openzeppelin-contracts/",
      "solmate/=lib/solmate/src/",
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "erc4626-tests/=lib/openzeppelin-contracts/lib/erc4626-tests/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/",
      "party-addresses/=lib/party-addresses/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "useLiteralContent": false,
      "bytecodeHash": "ipfs",
      "appendCBOR": true
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
    "evmVersion": "shanghai",
    "libraries": {
      "contracts/utils/LibRenderer.sol": {
        "LibRenderer": "0x39244498e639c4b24910e73dfa3622881d456724"
      }
    },
    "viaIR": true
  }
}}