{{
  "language": "Solidity",
  "sources": {
    "contracts/Proxy.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\n// Deployed with donations via Gitcoin GR9\n\npragma solidity 0.7.6;\npragma abicoder v2;\n\ncontract Proxy {\n    // EIP1967\n    // bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)\n    bytes32 private constant adminPosition = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;\n\n    // EIP1967\n    // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)\n    bytes32 private constant implementationPosition =\n        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n\n    // EIP1967\n    event AdminChanged(address previousAdmin, address newAdmin);\n    event Upgraded(address indexed implementation);\n\n    constructor(address _implementation) {\n        _setAdmin(address(0), msg.sender);\n        setImplementation(_implementation);\n    }\n\n    function implementation() public view returns (address _implementation) {\n        assembly {\n            _implementation := sload(implementationPosition)\n        }\n    }\n\n    function setImplementation(address _implementation) public {\n        require(msg.sender == admin(), 'PX00');\n        require(_implementation != implementation(), 'PX01');\n        require(_implementation != address(0), 'PX02');\n\n        assembly {\n            sstore(implementationPosition, _implementation)\n        }\n\n        emit Upgraded(_implementation);\n    }\n\n    function admin() public view returns (address _admin) {\n        assembly {\n            _admin := sload(adminPosition)\n        }\n    }\n\n    function setAdmin(address _admin) external {\n        address currentAdmin = admin();\n        require(msg.sender == currentAdmin, 'PX00');\n        require(_admin != currentAdmin, 'PX01');\n        require(_admin != address(0), 'PX02');\n\n        _setAdmin(currentAdmin, _admin);\n    }\n\n    function _setAdmin(address currentAdmin, address newAdmin) internal {\n        assembly {\n            sstore(adminPosition, newAdmin)\n        }\n\n        emit AdminChanged(currentAdmin, newAdmin);\n    }\n\n    /**\n     * @dev Delegates the current call to `implementation`.\n     *\n     * This function does not return to its internal call site, it will return directly to the external caller.\n     */\n    function _fallback() internal {\n        address _implementation = implementation();\n\n        assembly {\n            // Copy msg.data.\n            calldatacopy(0, 0, calldatasize())\n\n            // Call the implementation.\n            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)\n\n            // Copy the returned data.\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            // delegatecall returns 0 on error.\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    fallback() external payable {\n        _fallback();\n    }\n\n    receive() external payable {\n        _fallback();\n    }\n}\n"
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
    "libraries": {}
  }
}}