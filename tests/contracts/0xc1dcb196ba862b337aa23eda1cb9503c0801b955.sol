{{
  "language": "Solidity",
  "sources": {
    "contracts/deposit-service/AxelarDepositServiceProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.9;\n\nimport { Proxy } from '../util/Proxy.sol';\n\ncontract AxelarDepositServiceProxy is Proxy {\n    function contractId() internal pure override returns (bytes32) {\n        return keccak256('axelar-deposit-service');\n    }\n\n    // @dev This function is for receiving refunds when refundAddress was 0x0\n    // solhint-disable-next-line no-empty-blocks\n    receive() external payable override {}\n}\n"
    },
    "contracts/interfaces/IUpgradable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.9;\n\n// General interface for upgradable contracts\ninterface IUpgradable {\n    error NotOwner();\n    error InvalidOwner();\n    error InvalidCodeHash();\n    error InvalidImplementation();\n    error SetupFailed();\n    error NotProxy();\n\n    event Upgraded(address indexed newImplementation);\n    event OwnershipTransferred(address indexed newOwner);\n\n    // Get current owner\n    function owner() external view returns (address);\n\n    function contractId() external pure returns (bytes32);\n\n    function implementation() external view returns (address);\n\n    function upgrade(\n        address newImplementation,\n        bytes32 newImplementationCodeHash,\n        bytes calldata params\n    ) external;\n\n    function setup(bytes calldata data) external;\n}\n"
    },
    "contracts/util/Proxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.9;\n\nimport { IUpgradable } from '../interfaces/IUpgradable.sol';\n\ncontract Proxy {\n    error InvalidImplementation();\n    error SetupFailed();\n    error EtherNotAccepted();\n    error NotOwner();\n    error AlreadyInitialized();\n\n    // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)\n    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n    // keccak256('owner')\n    bytes32 internal constant _OWNER_SLOT = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0;\n\n    constructor() {\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            sstore(_OWNER_SLOT, caller())\n        }\n    }\n\n    function init(\n        address implementationAddress,\n        address newOwner,\n        bytes memory params\n    ) external {\n        address owner;\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            owner := sload(_OWNER_SLOT)\n        }\n        if (msg.sender != owner) revert NotOwner();\n        if (implementation() != address(0)) revert AlreadyInitialized();\n        if (IUpgradable(implementationAddress).contractId() != contractId()) revert InvalidImplementation();\n\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            sstore(_IMPLEMENTATION_SLOT, implementationAddress)\n            sstore(_OWNER_SLOT, newOwner)\n        }\n        // solhint-disable-next-line avoid-low-level-calls\n        (bool success, ) = implementationAddress.delegatecall(\n            //0x9ded06df is the setup selector.\n            abi.encodeWithSelector(0x9ded06df, params)\n        );\n        if (!success) revert SetupFailed();\n    }\n\n    // solhint-disable-next-line no-empty-blocks\n    function contractId() internal pure virtual returns (bytes32) {}\n\n    function implementation() public view returns (address implementation_) {\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            implementation_ := sload(_IMPLEMENTATION_SLOT)\n        }\n    }\n\n    // solhint-disable-next-line no-empty-blocks\n    function setup(bytes calldata data) public {}\n\n    // solhint-disable-next-line no-complex-fallback\n    fallback() external payable {\n        address implementaion_ = implementation();\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            calldatacopy(0, 0, calldatasize())\n\n            let result := delegatecall(gas(), implementaion_, 0, calldatasize(), 0, 0)\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    receive() external payable virtual {\n        revert EtherNotAccepted();\n    }\n}\n"
    }
  },
  "settings": {
    "evmVersion": "london",
    "optimizer": {
      "enabled": true,
      "runs": 1000,
      "details": {
        "peephole": true,
        "inliner": true,
        "jumpdestRemover": true,
        "orderLiterals": true,
        "deduplicate": true,
        "cse": true,
        "constantOptimizer": true,
        "yul": true,
        "yulDetails": {
          "stackAllocation": true
        }
      }
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