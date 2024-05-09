1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/Airdrop.sol": {
5       "content": "pragma solidity ^0.8.0;\n\n/*\n\n      |>(|)<|\n      .-'^'-.\n     '/\"'\"^\"\\'\n    :( *   * ):\n    ::)  ,| (::\n    '(       )'          _.\n     '\\ --- /'          / /\n   .-'       '-.      .__D\n ,\"      |      \\    / : (=|\n:   Y    |    \\  \\  /  : (=|\n|   |o__/ \\__o:   \\/  \" \\ \\\n|   |          \\     '   \"-.\n|    `.    ___ \\:._.'\n \".__  \"-\" __ \\ \\\n  .|''---''------|               _\n  / -.          _\"\"-.--.        C )\n '    '/.___.--'        '._    : |\n|     --_   ^\"--...__      ''-.' |\n|        ''---.o)    \"\"._        |\n ^'--.._      |o)        '`-..._./\n        '--.._|o)\n              'O)\n\n*/\n\n/* proof is:\n\n0x63b8398f3ebcf782015a0019a4300bc20e74cf94e6626e4b18f93dd85d150f34\n\n*/\ninterface IERC20 {\n    function mint(address to, uint256 amount) external;\n}\n\nlibrary MerkleProof {\n    function verify(\n        bytes32[] memory proof,\n        bytes32 root,\n        bytes32 leaf\n    ) internal pure returns (bool) {\n        bytes32 computedHash = leaf;\n\n        for (uint256 i = 0; i < proof.length; i++) {\n            bytes32 proofElement = proof[i];\n\n            if (computedHash <= proofElement) {\n                computedHash = keccak256(\n                    abi.encodePacked(computedHash, proofElement)\n                );\n            } else {\n                computedHash = keccak256(\n                    abi.encodePacked(proofElement, computedHash)\n                );\n            }\n        }\n        return computedHash == root;\n    }\n}\n\ncontract Airdrop {\n    IERC20 public immutable token;\n    bytes32 public immutable merkleRoot;\n    mapping(uint256 => uint256) private claimedBitMap;\n\n    constructor(IERC20 token_, bytes32 merkleRoot_) {\n        token = token_;\n        merkleRoot = merkleRoot_;\n    }\n\n    function isClaimed(uint256 index) public view returns (bool) {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n        uint256 mask = (1 << claimedBitIndex);\n        return claimedWord & mask == mask;\n    }\n\n    function _setClaimed(uint256 index) private {\n        uint256 claimedWordIndex = index / 256;\n        uint256 claimedBitIndex = index % 256;\n        claimedBitMap[claimedWordIndex] =\n            claimedBitMap[claimedWordIndex] |\n            (1 << claimedBitIndex);\n    }\n\n    function claim(bytes calldata node, bytes32[] calldata merkleProof)\n        external\n    {\n        uint256 index;\n        uint256 amount;\n        address recipient;\n        (index, recipient, amount) = abi.decode(\n            node,\n            (uint256, address, uint256)\n        );\n\n        require(recipient == msg.sender);\n        require(!isClaimed(index), \"MerkleDistributor: Drop already claimed.\");\n\n        require(\n            MerkleProof.verify(merkleProof, merkleRoot, keccak256(node)),\n            \"MerkleDistributor: Invalid proof.\"\n        );\n\n        _setClaimed(index);\n        token.mint(msg.sender, amount * 10 * 1 ether);\n    }\n}\n"
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
18           "abi"
19         ]
20       }
21     },
22     "libraries": {}
23   }
24 }}