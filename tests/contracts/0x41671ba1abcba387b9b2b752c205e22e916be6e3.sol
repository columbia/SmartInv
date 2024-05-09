{{
  "language": "Solidity",
  "sources": {
    "contracts/common/proxy/UpgradableProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.6.11;\n\nimport {Proxy} from \"./Proxy.sol\";\nimport {GovernableProxy} from \"./GovernableProxy.sol\";\n\ncontract UpgradableProxy is GovernableProxy, Proxy {\n    bytes32 constant IMPLEMENTATION_SLOT = keccak256(\"proxy.implementation\");\n\n    event ProxyUpdated(address indexed previousImpl, address indexed newImpl);\n\n    fallback() external {\n        delegatedFwd(implementation(), msg.data);\n    }\n\n    function implementation() override public view returns(address _impl) {\n        bytes32 position = IMPLEMENTATION_SLOT;\n        assembly {\n            _impl := sload(position)\n        }\n    }\n\n    function updateImplementation(address _newProxyTo) external onlyGovernance {\n        require(_newProxyTo != address(0x0), \"INVALID_PROXY_ADDRESS\");\n        require(isContract(_newProxyTo), \"DESTINATION_ADDRESS_IS_NOT_A_CONTRACT\");\n        emit ProxyUpdated(implementation(), _newProxyTo);\n        setImplementation(_newProxyTo);\n    }\n\n    function setImplementation(address _newProxyTo) private {\n        bytes32 position = IMPLEMENTATION_SLOT;\n        assembly {\n            sstore(position, _newProxyTo)\n        }\n    }\n\n    function isContract(address _target) internal view returns (bool) {\n        if (_target == address(0)) {\n            return false;\n        }\n        uint size;\n        assembly {\n            size := extcodesize(_target)\n        }\n        return size > 0;\n    }\n}\n"
    },
    "contracts/common/proxy/Proxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.6.11;\n\nimport {IERCProxy} from \"./IERCProxy.sol\";\n\nabstract contract Proxy is IERCProxy {\n    function delegatedFwd(address _dst, bytes memory _calldata) internal {\n        // solium-disable-next-line security/no-inline-assembly\n        assembly {\n            let result := delegatecall(\n                sub(gas(), 10000),\n                _dst,\n                add(_calldata, 0x20),\n                mload(_calldata),\n                0,\n                0\n            )\n            let size := returndatasize()\n\n            let ptr := mload(0x40)\n            returndatacopy(ptr, 0, size)\n\n            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.\n            // if the call returned error data, forward it\n            switch result\n                case 0 {\n                    revert(ptr, size)\n                }\n                default {\n                    return(ptr, size)\n                }\n        }\n    }\n\n    function proxyType() override external pure returns (uint proxyTypeId) {\n        // Upgradeable proxy\n        proxyTypeId = 2;\n    }\n\n    function implementation() override virtual public view returns (address);\n}\n"
    },
    "contracts/common/proxy/GovernableProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.6.11;\n\ncontract GovernableProxy {\n    bytes32 constant OWNER_SLOT = keccak256(\"proxy.owner\");\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() internal {\n        _transferOwnership(msg.sender);\n    }\n\n    modifier onlyGovernance() {\n        require(owner() == msg.sender, \"NOT_OWNER\");\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view returns(address _owner) {\n        bytes32 position = OWNER_SLOT;\n        assembly {\n            _owner := sload(position)\n        }\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     */\n    function transferOwnership(address newOwner) external onlyGovernance {\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal {\n        require(newOwner != address(0), \"OwnableProxy: new owner is the zero address\");\n        emit OwnershipTransferred(owner(), newOwner);\n        bytes32 position = OWNER_SLOT;\n        assembly {\n            sstore(position, newOwner)\n        }\n    }\n}\n"
    },
    "contracts/common/proxy/IERCProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.6.11;\n\ninterface IERCProxy {\n    function proxyType() external pure returns (uint proxyTypeId);\n    function implementation() external view returns (address codeAddr);\n}\n"
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
    "libraries": {}
  }
}}