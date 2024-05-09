{{
  "language": "Solidity",
  "sources": {
    "contracts/InitializedProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.5;\n\n/**\n * @title InitializedProxy\n * @author Anna Carroll\n */\ncontract InitializedProxy {\n    // address of logic contract\n    address public immutable logic;\n\n    // ======== Constructor =========\n\n    constructor(\n        address _logic,\n        bytes memory _initializationCalldata\n    ) {\n        logic = _logic;\n        // Delegatecall into the logic contract, supplying initialization calldata\n        (bool _ok, bytes memory returnData) =\n            _logic.delegatecall(_initializationCalldata);\n        // Revert if delegatecall to implementation reverts\n        require(_ok, string(returnData));\n    }\n\n    // ======== Fallback =========\n\n    fallback() external payable {\n        address _impl = logic;\n        assembly {\n            let ptr := mload(0x40)\n            calldatacopy(ptr, 0, calldatasize())\n            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)\n            let size := returndatasize()\n            returndatacopy(ptr, 0, size)\n\n            switch result\n                case 0 {\n                    revert(ptr, size)\n                }\n                default {\n                    return(ptr, size)\n                }\n        }\n    }\n\n    // ======== Receive =========\n\n    receive() external payable {} // solhint-disable-line no-empty-blocks\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 999999
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}