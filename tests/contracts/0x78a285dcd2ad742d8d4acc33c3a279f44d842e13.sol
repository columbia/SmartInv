{{
  "language": "Solidity",
  "sources": {
    "contracts/PepemonMerkleDistributor.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.9;\n\nimport {MerkleProof} from \"@openzeppelin/contracts/utils/cryptography/MerkleProof.sol\";\n\ninterface IPepemonFactory {\n    function mint(\n        address _to,\n        uint256 _id,\n        uint256 _quantity,\n        bytes memory _data\n    ) external;\n}\n\ncontract PepemonMerkleDistributor {\n    event Claimed(\n        uint256 tokenId,\n        uint256 index,\n        address account,\n        uint256 amount\n    );\n\n    IPepemonFactory public factory;\n    mapping(uint256 => bytes32) merkleRoots;\n    mapping(uint256 => mapping(uint256 => uint256)) private claimedTokens;\n\n    // @dev do not use 0 for tokenId\n    constructor(\n        address pepemonFactory_,\n        bytes32[] memory merkleRoots_,\n        uint256[] memory pepemonIds_\n    ) {\n        require(pepemonFactory_ != address(0), \"ZeroFactoryAddress\");\n        require(\n            merkleRoots_.length == pepemonIds_.length,\n            \"RootsIdsCountMismatch\"\n        );\n\n        factory = IPepemonFactory(pepemonFactory_);\n\n        for (uint256 r = 0; r < merkleRoots_.length; r++) {\n            merkleRoots[pepemonIds_[r]] = merkleRoots_[r];\n        }\n    }\n\n    function isClaimed(uint256 pepemonTokenId, uint256 index)\n        public\n        view\n        returns (bool)\n    {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        uint256 claimedWord = claimedTokens[pepemonTokenId][claimedWordIndex];\n        uint256 mask = (1 << claimedBitIndex);\n        return claimedWord & mask == mask;\n    }\n\n    function claim(\n        uint256 tokenId,\n        uint256 index,\n        address account,\n        uint256 amount,\n        bytes32[] calldata merkleProof\n    ) external {\n        require(merkleRoots[tokenId] != 0, \"UnknownTokenId\");\n        require(\n            !isClaimed(tokenId, index),\n            \"MerkleDistributor: Drop already claimed\"\n        );\n\n        bytes32 node = keccak256(abi.encodePacked(index, account, amount));\n        require(\n            MerkleProof.verify(merkleProof, merkleRoots[tokenId], node),\n            \"MerkleDistributor: Invalid proof\"\n        );\n\n        _setClaimed(tokenId, index);\n\n        factory.mint(account, tokenId, 1, \"\");\n\n        emit Claimed(tokenId, index, account, amount);\n    }\n\n    function _setClaimed(uint256 pepemonTokenId, uint256 index) internal {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        claimedTokens[pepemonTokenId][claimedWordIndex] =\n            claimedTokens[pepemonTokenId][claimedWordIndex] |\n            (1 << claimedBitIndex);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev These functions deal with verification of Merkle Trees proofs.\n *\n * The proofs can be generated using the JavaScript library\n * https://github.com/miguelmota/merkletreejs[merkletreejs].\n * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.\n *\n * See `test/utils/cryptography/MerkleProof.test.js` for some examples.\n */\nlibrary MerkleProof {\n    /**\n     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n     * defined by `root`. For this, a `proof` must be provided, containing\n     * sibling hashes on the branch from the leaf to the root of the tree. Each\n     * pair of leaves and each pair of pre-images are assumed to be sorted.\n     */\n    function verify(\n        bytes32[] memory proof,\n        bytes32 root,\n        bytes32 leaf\n    ) internal pure returns (bool) {\n        bytes32 computedHash = leaf;\n\n        for (uint256 i = 0; i < proof.length; i++) {\n            bytes32 proofElement = proof[i];\n\n            if (computedHash <= proofElement) {\n                // Hash(current computed hash + current element of the proof)\n                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n            } else {\n                // Hash(current element of the proof + current computed hash)\n                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n            }\n        }\n\n        // Check if the computed hash (root) is equal to the provided root\n        return computedHash == root;\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 25000
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