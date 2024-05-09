{{
  "language": "Solidity",
  "sources": {
    "contracts/ve/veAllocate.sol": {
      "content": "pragma solidity ^0.8.12;\n// Copyright BigchainDB GmbH and Ocean Protocol contributors\n// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)\n// Code is Apache-2.0 and docs are CC-BY-4.0\n\ncontract veAllocate {\n    mapping(address => mapping(address => mapping(uint256 => uint256)))\n        private veAllocation;\n    mapping(address => uint256) private _totalAllocation;\n\n    event AllocationSet(\n        address indexed sender,\n        address indexed nft,\n        uint256 indexed chainId,\n        uint256 amount\n    );\n\n    event AllocationSetMultiple(\n        address indexed sender,\n        address[] nft,\n        uint256[] chainId,\n        uint256[] amount\n    );\n\n    function getveAllocation(\n        address user,\n        address nft,\n        uint256 chainid\n    ) external view returns (uint256) {\n        return veAllocation[user][nft][chainid];\n    }\n\n    function getTotalAllocation(address user)\n        public\n        view\n        returns (uint256)\n    {\n        return _totalAllocation[user];\n    }\n\n    function setAllocation(\n        uint256 amount,\n        address nft,\n        uint256 chainId\n    ) external {\n        _totalAllocation[msg.sender] =\n            _totalAllocation[msg.sender] +\n            amount -\n            veAllocation[msg.sender][nft][chainId];\n\n        require(_totalAllocation[msg.sender] <= 10000, \"Max Allocation\");\n        veAllocation[msg.sender][nft][chainId] = amount;\n        emit AllocationSet(msg.sender, nft, chainId, amount);\n    }\n\n    function setBatchAllocation(\n        uint256[] calldata amount,\n        address[] calldata nft,\n        uint256[] calldata chainId\n    ) external {\n        require(amount.length <= 150, 'Too Many Operations');\n        require(amount.length == nft.length, 'Nft array size missmatch');\n        require(amount.length == chainId.length, 'Chain array size missmatch');\n        for (uint256 i = 0; i < amount.length; i++) {\n            _totalAllocation[msg.sender] =\n                _totalAllocation[msg.sender] +\n                amount[i] -\n                veAllocation[msg.sender][nft[i]][chainId[i]];\n            veAllocation[msg.sender][nft[i]][chainId[i]] = amount[i];\n        }\n        require(_totalAllocation[msg.sender] <= 10000, \"Max Allocation\");\n        emit AllocationSetMultiple(msg.sender, nft, chainId, amount);\n    }\n}\n"
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