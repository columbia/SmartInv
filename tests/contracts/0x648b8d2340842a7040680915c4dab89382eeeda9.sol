{{
  "language": "Solidity",
  "sources": {
    "contracts/release/core/fund/comptroller/ComptrollerProxy.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\n/*\n    This file is part of the Enzyme Protocol.\n\n    (c) Enzyme Council <council@enzyme.finance>\n\n    For the full license information, please view the LICENSE\n    file that was distributed with this source code.\n*/\n\npragma solidity 0.6.12;\n\nimport \"../../../utils/NonUpgradableProxy.sol\";\n\n/// @title ComptrollerProxy Contract\n/// @author Enzyme Council <security@enzyme.finance>\n/// @notice A proxy contract for all ComptrollerProxy instances\ncontract ComptrollerProxy is NonUpgradableProxy {\n    constructor(bytes memory _constructData, address _comptrollerLib)\n        public\n        NonUpgradableProxy(_constructData, _comptrollerLib)\n    {}\n}\n"
    },
    "contracts/release/utils/NonUpgradableProxy.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0\n\n/*\n    This file is part of the Enzyme Protocol.\n\n    (c) Enzyme Council <council@enzyme.finance>\n\n    For the full license information, please view the LICENSE\n    file that was distributed with this source code.\n*/\n\npragma solidity 0.6.12;\n\n/// @title NonUpgradableProxy Contract\n/// @author Enzyme Council <security@enzyme.finance>\n/// @notice A proxy contract for use with non-upgradable libs\n/// @dev The recommended constructor-fallback pattern of a proxy in EIP-1822, updated for solc 0.6.12,\n/// and using an immutable lib value to save on gas (since not upgradable).\n/// The EIP-1967 storage slot for the lib is still assigned,\n/// for ease of referring to UIs that understand the pattern, i.e., Etherscan.\nabstract contract NonUpgradableProxy {\n    address private immutable CONTRACT_LOGIC;\n\n    constructor(bytes memory _constructData, address _contractLogic) public {\n        CONTRACT_LOGIC = _contractLogic;\n\n        assembly {\n            // EIP-1967 slot: `bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)`\n            sstore(\n                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc,\n                _contractLogic\n            )\n        }\n        (bool success, bytes memory returnData) = _contractLogic.delegatecall(_constructData);\n        require(success, string(returnData));\n    }\n\n    // solhint-disable-next-line no-complex-fallback\n    fallback() external payable {\n        address contractLogic = CONTRACT_LOGIC;\n\n        assembly {\n            calldatacopy(0x0, 0x0, calldatasize())\n            let success := delegatecall(\n                sub(gas(), 10000),\n                contractLogic,\n                0x0,\n                calldatasize(),\n                0,\n                0\n            )\n            let retSz := returndatasize()\n            returndatacopy(0, 0, retSz)\n            switch success\n                case 0 {\n                    revert(0, retSz)\n                }\n                default {\n                    return(0, retSz)\n                }\n        }\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200,
      "details": {
        "yul": false
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}