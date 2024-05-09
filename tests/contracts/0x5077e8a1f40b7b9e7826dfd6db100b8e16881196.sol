{{
  "language": "Solidity",
  "sources": {
    "contracts/claim.sol": {
      "content": "//SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IinterleaveNFT {\r\n    function mint(address to, uint256 id, uint256 amount) external;\r\n}\r\n\r\ncontract InterleaveClaims {\r\n    bytes32 _root;\r\n\r\n    mapping (uint256 => mapping(address => bool)) private _isClaimed;\r\n\r\n    address public interleaveNFT;\r\n    address public owner;\r\n\r\n    constructor() {\r\n        _root = 0xc1bef884e9c09a044ac646fde85f284e3bc25b487384edd98eb2cab32e693481;\r\n        interleaveNFT = 0xB02FDEddE59aba04FF14062519e880B5E6BA316E;\r\n        owner = msg.sender;\r\n    }  \r\n\r\n    function verify(\r\n        bytes32[] memory proof,\r\n        bytes32 root,\r\n        bytes32 leaf\r\n    ) internal pure returns (bool) {\r\n        bytes32 computedHash = leaf;\r\n\r\n        for (uint256 i = 0; i < proof.length; i++) {\r\n            bytes32 proofElement = proof[i];\r\n\r\n            if (computedHash <= proofElement) {\r\n                // Hash(current computed hash + current element of the proof)\r\n                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\r\n            } else {\r\n                // Hash(current element of the proof + current computed hash)\r\n                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\r\n            }\r\n        }\r\n\r\n        // Check if the computed hash (root) is equal to the provided root\r\n        return computedHash == root;\r\n    }\r\n \r\n\r\n    function updateMerkleRoot(bytes32 newRoot) public {\r\n        require(msg.sender == owner, \"You are not the owner!\");\r\n        _root = newRoot;\r\n    }\r\n\r\n    function changeInterleave(address newAddress) public {\r\n        require(msg.sender == owner,\"You are not the owner!\");\r\n        interleaveNFT = newAddress;\r\n    }\r\n\r\n    function isClaimed(uint256 id, address userAddress) public view returns (bool) {\r\n        return _isClaimed[id][userAddress];\r\n    }\r\n\r\n    function claim(uint256 id, uint256 amount, address userAddress, bytes32[] memory merkleProof) public {\r\n        require(!isClaimed(id, userAddress), \"You've already claimed!\");\r\n\r\n        // Verify the merkle proof.\r\n        bytes32 node = keccak256(abi.encodePacked(id, amount, userAddress));\r\n        require(verify(merkleProof, _root, node), 'Invalid proof.');\r\n\r\n        _isClaimed[id][userAddress] = true;\r\n        \r\n        IinterleaveNFT(interleaveNFT).mint(userAddress, id, amount);\r\n\r\n    }\r\n\r\n}"
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
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  }
}}