{{
  "language": "Solidity",
  "sources": {
    "contracts/v2/proxy/accountProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.7.0;\n\ninterface AccountImplementations {\n    function getImplementation(bytes4 _sig) external view returns (address);\n}\n\n/**\n * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM\n * instruction `delegatecall`.\n */\ncontract InstaAccountV2 {\n\n    AccountImplementations public immutable implementations;\n\n    constructor(address _implementations) {\n        implementations = AccountImplementations(_implementations);\n    }\n\n    /**\n     * @dev Delegates the current call to `implementation`.\n     * \n     * This function does not return to its internall call site, it will return directly to the external caller.\n     */\n    function _delegate(address implementation) internal {\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            // Copy msg.data. We take full control of memory in this inline assembly\n            // block because it will not return to Solidity code. We overwrite the\n            // Solidity scratch pad at memory position 0.\n            calldatacopy(0, 0, calldatasize())\n\n            // Call the implementation.\n            // out and outsize are 0 because we don't know the size yet.\n            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)\n\n            // Copy the returned data.\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            // delegatecall returns 0 on error.\n            case 0 { revert(0, returndatasize()) }\n            default { return(0, returndatasize()) }\n        }\n    }\n\n    /**\n     * @dev Delegates the current call to the address returned by Implementations registry.\n     * \n     * This function does not return to its internall call site, it will return directly to the external caller.\n     */\n    function _fallback(bytes4 _sig) internal {\n        address _implementation = implementations.getImplementation(_sig);\n        require(_implementation != address(0), \"InstaAccountV2: Not able to find _implementation\");\n        _delegate(_implementation);\n    }\n\n    /**\n     * @dev Fallback function that delegates calls to the address returned by Implementations registry.\n     */\n    fallback () external payable {\n        _fallback(msg.sig);\n    }\n\n    /**\n     * @dev Fallback function that delegates calls to the address returned by Implementations registry.\n     */\n    receive () external payable {\n        if (msg.sig != 0x00000000) {\n            _fallback(msg.sig);\n        }\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
      "runs": 200
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}