1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.4;
3 
4 interface IFlashToken {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function allowance(address owner, address spender) external view returns (uint256);
10 
11     function approve(address spender, uint256 amount) external returns (bool);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     function mint(address to, uint256 value) external returns (bool);
22 
23     function burn(uint256 value) external returns (bool);
24 }
25 
26 
27 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
28 // Modified to include only the essentials
29 library SafeMath {
30     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
31         require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");
32     }
33 
34     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
35         require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42         if (a == 0) {
43             return 0;
44         }
45 
46         uint256 c = a * b;
47         require(c / a == b, "MATH:: MUL_OVERFLOW");
48 
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b > 0, "MATH:: DIVISION_BY_ZERO");
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 }
60 
61 library MerkleProof {
62     /**
63      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
64      * defined by `root`. For this, a `proof` must be provided, containing
65      * sibling hashes on the branch from the leaf to the root of the tree. Each
66      * pair of leaves and each pair of pre-images are assumed to be sorted.
67      */
68     function verify(
69         bytes32[] memory proof,
70         bytes32 root,
71         bytes32 leaf
72     ) internal pure returns (bool) {
73         bytes32 computedHash = leaf;
74 
75         for (uint256 i = 0; i < proof.length; i++) {
76             bytes32 proofElement = proof[i];
77 
78             if (computedHash <= proofElement) {
79                 // Hash(current computed hash + current element of the proof)
80                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
81             } else {
82                 // Hash(current element of the proof + current computed hash)
83                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
84             }
85         }
86 
87         // Check if the computed hash (root) is equal to the provided root
88         return computedHash == root;
89     }
90 }
91 
92 
93 
94 contract ClaimContract {
95     using MerkleProof for bytes;
96     using SafeMath for uint256;
97 
98     enum MigrationType { V1_UNCLAIMED, HOLDER, STAKER }
99 
100     address public constant FLASH_TOKEN_V1 = 0xB4467E8D621105312a914F1D42f10770C0Ffe3c8;
101     address public constant FLASH_TOKEN_V2 = 0x20398aD62bb2D930646d45a6D4292baa0b860C1f;
102     bytes32 public constant MERKLE_ROOT = 0x56dc616cf485d230be34e774839fc4b1b11b0ab99b92d594f7f16f4065f7e814;
103     uint256 public constant V1_UNCLAIMED_DEADLINE = 1617235140;
104 
105     mapping(uint256 => uint256) private claimedBitMap;
106 
107     event Claimed(uint256 index, address sender, uint256 amount);
108 
109     function isClaimed(uint256 index) public view returns (bool) {
110         uint256 claimedWordIndex = index / 256;
111         uint256 claimedBitIndex = index % 256;
112         uint256 claimedWord = claimedBitMap[claimedWordIndex];
113         uint256 mask = (1 << claimedBitIndex);
114         return claimedWord & mask == mask;
115     }
116 
117     function _setClaimed(uint256 index) private {
118         uint256 claimedWordIndex = index / 256;
119         uint256 claimedBitIndex = index % 256;
120         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
121     }
122 
123     function _getMigratableAmountAndTransferV1(address _user, uint256 _balance) private returns (uint256 flashV2Mint) {
124         uint256 flashV1Balance = IFlashToken(FLASH_TOKEN_V1).balanceOf(_user);
125         flashV2Mint = flashV1Balance >= _balance ? _balance : flashV1Balance;
126         IFlashToken(FLASH_TOKEN_V1).transferFrom(_user, address(this), flashV2Mint);
127     }
128 
129     function claim(
130         uint256 index,
131         uint256 balance,
132         uint256 bonusAmount,
133         uint256 expiry,
134         uint256 expireAfter,
135         MigrationType migrationType,
136         bytes32[] calldata merkleProof
137     ) external {
138         require(!isClaimed(index), "FlashV2Migration: Already claimed.");
139 
140         address user = msg.sender;
141 
142         require(
143             MerkleProof.verify(
144                 merkleProof,
145                 MERKLE_ROOT,
146                 keccak256(
147                     abi.encodePacked(index, user, balance, bonusAmount, expiry, expireAfter, uint256(migrationType))
148                 )
149             ),
150             "FlashV2Migration: Invalid proof."
151         );
152 
153         uint256 flashV2Mint = balance;
154 
155         if (migrationType == MigrationType.V1_UNCLAIMED) {
156             require(block.timestamp <= V1_UNCLAIMED_DEADLINE, "FlashV2Migration: V1 claim time expired.");
157         } else if (migrationType == MigrationType.HOLDER) {
158             flashV2Mint = _getMigratableAmountAndTransferV1(user, balance);
159         } else if (migrationType == MigrationType.STAKER) {
160             if (expireAfter > block.timestamp) {
161                 uint256 burnAmount = balance.mul(expireAfter.sub(block.timestamp)).mul(75e16).div(expiry.mul(1e18));
162                 flashV2Mint = balance.sub(burnAmount);
163             }
164         } else {
165             revert("FlashV2Migration: Invalid migration type");
166         }
167 
168         _setClaimed(index);
169 
170         IFlashToken(FLASH_TOKEN_V2).mint(user, flashV2Mint.add(bonusAmount));
171 
172         emit Claimed(index, user, flashV2Mint);
173     }
174 }