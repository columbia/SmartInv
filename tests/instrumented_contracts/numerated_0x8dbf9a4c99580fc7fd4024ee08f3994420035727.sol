1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/proxy/ForwardProxy.sol": {
5       "content": "/* -*- c-basic-offset: 4 -*- */\n// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"./ForwardTarget.sol\";\n\n/* solhint-disable avoid-low-level-calls, no-inline-assembly */\n\n/** @title Upgradable proxy */\ncontract ForwardProxy {\n    // this is the storage slot to hold the target of the proxy\n    // keccak256(\"com.eco.ForwardProxy.target\")\n    uint256 private constant IMPLEMENTATION_SLOT =\n        0xf86c915dad5894faca0dfa067c58fdf4307406d255ed0a65db394f82b77f53d4;\n\n    /** Construct a new proxy.\n     *\n     * @param _impl The default target address.\n     */\n    constructor(ForwardTarget _impl) {\n        (bool _success, ) = address(_impl).delegatecall(\n            abi.encodeWithSelector(_impl.initialize.selector, _impl)\n        );\n        require(_success, \"initialize call failed\");\n\n        // Store forwarding target address at specified storage slot, copied\n        // from ForwardTarget#IMPLEMENTATION_SLOT\n        assembly {\n            sstore(IMPLEMENTATION_SLOT, _impl)\n        }\n    }\n\n    /** @notice Default function that forwards call to proxy target\n     */\n    fallback() external payable {\n        /* This default-function is optimized for minimum gas cost, to make the\n         * proxy overhead as small as possible. As such, the entire function is\n         * structured to optimize gas cost in the case of successful function\n         * calls. As such, calls to e.g. calldatasize and calldatasize are\n         * repeated, since calling them again is no more expensive than\n         * duplicating them on stack.\n         * This is also the only function in this contract, which avoids the\n         * function dispatch overhead.\n         */\n\n        assembly {\n            // Copy all call arguments to memory starting at 0x0\n            calldatacopy(0x0, 0, calldatasize())\n\n            // Forward to proxy target (loaded from IMPLEMENTATION_SLOT), using\n            // arguments from memory 0x0 and having results written to\n            // memory 0x0.\n            let delegate_result := delegatecall(\n                gas(),\n                sload(IMPLEMENTATION_SLOT),\n                0x0,\n                calldatasize(),\n                0x0,\n                0\n            )\n\n            let result_size := returndatasize()\n\n            //copy result into return buffer\n            returndatacopy(0x0, 0, result_size)\n\n            if delegate_result {\n                // If the call was successful, return\n                return(0x0, result_size)\n            }\n\n            // If the call was not successful, revert\n            revert(0x0, result_size)\n        }\n    }\n}\n"
6     },
7     "contracts/proxy/ForwardTarget.sol": {
8       "content": "/* -*- c-basic-offset: 4 -*- */\n// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n/* solhint-disable no-inline-assembly */\n\n/** @title Target for ForwardProxy and EcoInitializable */\nabstract contract ForwardTarget {\n    // Must match definition in ForwardProxy\n    // keccak256(\"com.eco.ForwardProxy.target\")\n    uint256 private constant IMPLEMENTATION_SLOT =\n        0xf86c915dad5894faca0dfa067c58fdf4307406d255ed0a65db394f82b77f53d4;\n\n    modifier onlyConstruction() {\n        require(\n            implementation() == address(0),\n            \"Can only be called during initialization\"\n        );\n        _;\n    }\n\n    constructor() {\n        setImplementation(address(this));\n    }\n\n    /** @notice Storage initialization of cloned contract\n     *\n     * This is used to initialize the storage of the forwarded contract, and\n     * should (typically) copy or repeat any work that would normally be\n     * done in the constructor of the proxied contract.\n     *\n     * Implementations of ForwardTarget should override this function,\n     * and chain to super.initialize(_self).\n     *\n     * @param _self The address of the original contract instance (the one being\n     *              forwarded to).\n     */\n    function initialize(address _self) public virtual onlyConstruction {\n        address _implAddress = address(ForwardTarget(_self).implementation());\n        require(\n            _implAddress != address(0),\n            \"initialization failure: nothing to implement\"\n        );\n        setImplementation(_implAddress);\n    }\n\n    /** Get the address of the proxy target contract.\n     */\n    function implementation() public view returns (address _impl) {\n        assembly {\n            _impl := sload(IMPLEMENTATION_SLOT)\n        }\n    }\n\n    /** @notice Set new implementation */\n    function setImplementation(address _impl) internal {\n        require(implementation() != _impl, \"Implementation already matching\");\n        assembly {\n            sstore(IMPLEMENTATION_SLOT, _impl)\n        }\n    }\n}\n"
9     }
10   },
11   "settings": {
12     "metadata": {
13       "bytecodeHash": "none"
14     },
15     "optimizer": {
16       "enabled": true,
17       "runs": 999999
18     },
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "devdoc",
25           "userdoc",
26           "metadata",
27           "abi"
28         ]
29       }
30     },
31     "libraries": {}
32   }
33 }}