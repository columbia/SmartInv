{{
  "language": "Solidity",
  "sources": {
    "contracts/Proxy.sol": {
      "content": "\npragma solidity ^0.8.7;\n\n/**\n * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM\n * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to\n * be specified by overriding the virtual {_implementation} function.\n *\n * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a\n * different contract through the {_delegate} function.\n *\n * The success and return data of the delegated call will be returned back to the caller of the proxy.\n */\ncontract Proxy {\n\n    address implementation_;\n    address public admin;\n\n    constructor(address impl) {\n        implementation_ = impl;\n        admin = msg.sender;\n    }\n\n    receive() external payable {}\n\n    function setImplementation(address newImpl) public {\n        require(msg.sender == admin);\n        implementation_ = newImpl;\n    }\n    \n    function implementation() public view returns (address impl) {\n        impl = implementation_;\n    }\n\n    /**\n     * @dev Delegates the current call to `implementation`.\n     *\n     * This function does not return to its internall call site, it will return directly to the external caller.\n     */\n    function _delegate(address implementation__) internal virtual {\n        assembly {\n            // Copy msg.data. We take full control of memory in this inline assembly\n            // block because it will not return to Solidity code. We overwrite the\n            // Solidity scratch pad at memory position 0.\n            calldatacopy(0, 0, calldatasize())\n\n            // Call the implementation.\n            // out and outsize are 0 because we don't know the size yet.\n            let result := delegatecall(gas(), implementation__, 0, calldatasize(), 0, 0)\n\n            // Copy the returned data.\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            // delegatecall returns 0 on error.\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    /**\n     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function\n     * and {_fallback} should delegate.\n     */\n    function _implementation() internal view returns (address) {\n        return implementation_;\n    }\n\n\n    /**\n     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other\n     * function in the contract matches the call data.\n     */\n    fallback() external payable virtual {\n        _delegate(_implementation());\n    }\n\n}\n"
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