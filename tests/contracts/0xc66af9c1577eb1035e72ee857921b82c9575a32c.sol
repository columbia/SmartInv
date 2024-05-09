{{
  "language": "Solidity",
  "sources": {
    "lib/UDS/src/proxy/ERC1967Proxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n// ------------- storage\n\n// keccak256(\"eip1967.proxy.implementation\") - 1 = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\nbytes32 constant ERC1967_PROXY_STORAGE_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n\nfunction s() pure returns (ERC1967UpgradeDS storage diamondStorage) {\n    assembly { diamondStorage.slot := ERC1967_PROXY_STORAGE_SLOT } // prettier-ignore\n}\n\nstruct ERC1967UpgradeDS {\n    address implementation;\n}\n\n// ------------- errors\n\nerror InvalidUUID();\nerror NotAContract();\n\n/// @notice ERC1967\n/// @author phaze (https://github.com/0xPhaze/UDS)\nabstract contract ERC1967 {\n    event Upgraded(address indexed implementation);\n\n    function _upgradeToAndCall(address logic, bytes memory data) internal {\n        if (logic.code.length == 0) revert NotAContract();\n\n        if (ERC1822(logic).proxiableUUID() != ERC1967_PROXY_STORAGE_SLOT) revert InvalidUUID();\n\n        if (data.length != 0) {\n            (bool success, ) = logic.delegatecall(data);\n\n            if (!success) {\n                assembly {\n                    returndatacopy(0, 0, returndatasize())\n                    revert(0, returndatasize())\n                }\n            }\n        }\n\n        emit Upgraded(logic);\n\n        s().implementation = logic;\n    }\n}\n\n/// @notice Minimal ERC1967Proxy\n/// @author phaze (https://github.com/0xPhaze/UDS)\ncontract ERC1967Proxy is ERC1967 {\n    constructor(address logic, bytes memory data) payable {\n        _upgradeToAndCall(logic, data);\n    }\n\n    fallback() external payable {\n        assembly {\n            calldatacopy(0, 0, calldatasize())\n\n            let success := delegatecall(gas(), sload(ERC1967_PROXY_STORAGE_SLOT), 0, calldatasize(), 0, 0)\n\n            returndatacopy(0, 0, returndatasize())\n\n            if success {\n                return(0, returndatasize())\n            }\n\n            revert(0, returndatasize())\n        }\n    }\n}\n\n/// @notice ERC1822\n/// @author phaze (https://github.com/0xPhaze/UDS)\nabstract contract ERC1822 {\n    function proxiableUUID() external view virtual returns (bytes32);\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "CRFTD/=src/",
      "ERC721A/=lib/fx-contracts/lib/ERC721M/lib/ERC721A/contracts/",
      "ERC721M/=lib/fx-contracts/lib/ERC721M/src/",
      "UDS/=lib/UDS/src/",
      "ds-test/=lib/solmate/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "futils/=lib/futils/src/",
      "fx-contracts/=lib/fx-contracts/src/",
      "fx-portal/=lib/fx-contracts/lib/ERC721M/lib/fx-portal/contracts/",
      "openzeppelin/=lib/fx-contracts/lib/ERC721M/lib/openzeppelin-contracts/",
      "solmate/=lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 100000
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}