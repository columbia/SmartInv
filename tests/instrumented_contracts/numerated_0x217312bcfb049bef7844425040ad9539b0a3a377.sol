1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/Proxy.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.7;\n\n/// @dev Proxy for NFT Factory\ncontract Proxy {\n\n    // Storage for this proxy\n    bytes32 private constant IMPLEMENTATION_SLOT = bytes32(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);\n    bytes32 private constant ADMIN_SLOT          = bytes32(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103);\n\n    constructor(address impl) {\n        require(impl != address(0));\n\n        _setSlotValue(IMPLEMENTATION_SLOT, bytes32(uint256(uint160(impl))));\n        _setSlotValue(ADMIN_SLOT, bytes32(uint256(uint160(msg.sender))));\n    }\n\n    function setImplementation(address newImpl) public {\n        require(msg.sender == _getAddress(ADMIN_SLOT));\n        _setSlotValue(IMPLEMENTATION_SLOT, bytes32(uint256(uint160(newImpl))));\n    }\n    \n    function setAdmin(address newAdmin) public {\n        require(msg.sender == _getAddress(ADMIN_SLOT));\n        _setSlotValue(ADMIN_SLOT, bytes32(uint256(uint160(newAdmin))));\n    }\n    \n\n    function implementation() public view returns (address impl) {\n        impl = address(uint160(uint256(_getSlotValue(IMPLEMENTATION_SLOT))));\n    }\n\n    function _getAddress(bytes32 key) internal view returns (address add) {\n        add = address(uint160(uint256(_getSlotValue(key))));\n    }\n\n    function _getSlotValue(bytes32 slot_) internal view returns (bytes32 value_) {\n        assembly {\n            value_ := sload(slot_)\n        }\n    }\n\n    function _setSlotValue(bytes32 slot_, bytes32 value_) internal {\n        assembly {\n            sstore(slot_, value_)\n        }\n    }\n\n    /**\n     * @dev Delegates the current call to `implementation`.\n     *\n     * This function does not return to its internall call site, it will return directly to the external caller.\n     */\n    function _delegate(address implementation__) internal virtual {\n        assembly {\n            // Copy msg.data. We take full control of memory in this inline assembly\n            // block because it will not return to Solidity code. We overwrite the\n            // Solidity scratch pad at memory position 0.\n            calldatacopy(0, 0, calldatasize())\n\n            // Call the implementation.\n            // out and outsize are 0 because we don't know the size yet.\n            let result := delegatecall(gas(), implementation__, 0, calldatasize(), 0, 0)\n\n            // Copy the returned data.\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            // delegatecall returns 0 on error.\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    receive() external payable {}\n\n\n    /**\n     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other\n     * function in the contract matches the call data.\n     */\n    fallback() external payable virtual {\n        _delegate(_getAddress(IMPLEMENTATION_SLOT));\n    }\n\n}\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": true,
11       "runs": 200
12     },
13     "outputSelection": {
14       "*": {
15         "*": [
16           "evm.bytecode",
17           "evm.deployedBytecode",
18           "devdoc",
19           "userdoc",
20           "metadata",
21           "abi"
22         ]
23       }
24     },
25     "libraries": {}
26   }
27 }}