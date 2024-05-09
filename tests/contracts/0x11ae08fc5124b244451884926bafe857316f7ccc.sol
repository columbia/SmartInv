{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
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
  },
  "sources": {
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"
    },
    "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev These functions deal with verification of Merkle Trees proofs.\n *\n * The proofs can be generated using the JavaScript library\n * https://github.com/miguelmota/merkletreejs[merkletreejs].\n * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.\n *\n * See `test/utils/cryptography/MerkleProof.test.js` for some examples.\n */\nlibrary MerkleProof {\n    /**\n     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n     * defined by `root`. For this, a `proof` must be provided, containing\n     * sibling hashes on the branch from the leaf to the root of the tree. Each\n     * pair of leaves and each pair of pre-images are assumed to be sorted.\n     */\n    function verify(\n        bytes32[] memory proof,\n        bytes32 root,\n        bytes32 leaf\n    ) internal pure returns (bool) {\n        return processProof(proof, leaf) == root;\n    }\n\n    /**\n     * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up\n     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt\n     * hash matches the root of the tree. When processing the proof, the pairs\n     * of leafs & pre-images are assumed to be sorted.\n     *\n     * _Available since v4.4._\n     */\n    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {\n        bytes32 computedHash = leaf;\n        for (uint256 i = 0; i < proof.length; i++) {\n            bytes32 proofElement = proof[i];\n            if (computedHash <= proofElement) {\n                // Hash(current computed hash + current element of the proof)\n                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n            } else {\n                // Hash(current element of the proof + current computed hash)\n                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n            }\n        }\n        return computedHash;\n    }\n}\n"
    },
    "contracts/MerkleDistributor.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.11;\n\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/utils/cryptography/MerkleProof.sol\";\n\ncontract MerkleDistributor {\n  address public immutable token;\n  bytes32 public immutable merkleRoot;\n  mapping(address => bool) private claimed;\n  uint256 private immutable airdropStart;\n\n  event Claimed(address account, uint256 amount);\n\n  constructor(address token_, bytes32 merkleRoot_) {\n    token = token_;\n    merkleRoot = merkleRoot_;\n    airdropStart = block.timestamp;\n  }\n\n  function isClaimed(address user) public view returns (bool) {\n    return claimed[user];\n  }\n\n  function claim(\n    address account,\n    uint256 amount,\n    bytes32[] calldata merkleProof\n  ) public {\n    require(!isClaimed(account), \"MerkleDistributor: Drop already claimed.\");\n    bytes32 node = keccak256(abi.encodePacked(account, amount));\n\n    require(\n        MerkleProof.verify(merkleProof, merkleRoot, node),\n        \"MerkleDistributor: Invalid proof.\"\n    );\n\n    claimed[account] = true;\n    require(IERC20(token).transfer(account, amount * 10**18), \"MerkleDistributor: Transfer failed.\");\n\n    emit Claimed(account, amount);\n  }\n\n  function sweep() public {\n    require(block.timestamp > airdropStart + 180 days, \"MerkleDistributor: Airdrop period has not ended.\");\n    require(\n      msg.sender == 0x1489A38EA1B5b1547301a480f19Fa17a0A3db223\n      || msg.sender == 0x2F075618681D45458aE20E17ca3CCf1C797d6E1a,\n      \"MerkleDistributor: Only the owner can sweep.\"\n    );\n    require(\n      IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this))),\n      \"MerkleDistributor: Transfer failed.\"\n    );\n  }\n}"
    }
  }
}}