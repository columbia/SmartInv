1 // Sources flattened with hardhat v2.0.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/cryptography/MerkleProof.sol@v3.3.0
4 
5 //SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity 0.6.8;
7 pragma experimental ABIEncoderV2;
8 
9 /**
10  * @dev These functions deal with verification of Merkle trees (hash trees),
11  */
12 library MerkleProof {
13     /**
14      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
15      * defined by `root`. For this, a `proof` must be provided, containing
16      * sibling hashes on the branch from the leaf to the root of the tree. Each
17      * pair of leaves and each pair of pre-images are assumed to be sorted.
18      */
19     function verify(
20         bytes32[] memory proof,
21         bytes32 root,
22         bytes32 leaf
23     ) internal pure returns (bool) {
24         bytes32 computedHash = leaf;
25 
26         for (uint256 i = 0; i < proof.length; i++) {
27             bytes32 proofElement = proof[i];
28 
29             if (computedHash <= proofElement) {
30                 // Hash(current computed hash + current element of the proof)
31                 computedHash = keccak256(
32                     abi.encodePacked(computedHash, proofElement)
33                 );
34             } else {
35                 // Hash(current element of the proof + current computed hash)
36                 computedHash = keccak256(
37                     abi.encodePacked(proofElement, computedHash)
38                 );
39             }
40         }
41 
42         // Check if the computed hash (root) is equal to the provided root
43         return computedHash == root;
44     }
45 }
46 
47 // File contracts/interfaces/IMirrorWriteToken.sol
48 
49 interface IMirrorWriteToken {
50     function register(string calldata label, address owner) external;
51 
52     function registrationCost() external view returns (uint256);
53 
54     // ============ ERC20 Interface ============
55 
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     function name() external view returns (string memory);
64 
65     function symbol() external view returns (string memory);
66 
67     function decimals() external view returns (uint8);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address owner) external view returns (uint256);
72 
73     function allowance(address owner, address spender)
74         external
75         view
76         returns (uint256);
77 
78     function approve(address spender, uint256 value) external returns (bool);
79 
80     function transfer(address to, uint256 value) external returns (bool);
81 
82     function transferFrom(
83         address from,
84         address to,
85         uint256 value
86     ) external returns (bool);
87 
88     function permit(
89         address owner,
90         address spender,
91         uint256 value,
92         uint256 deadline,
93         uint8 v,
94         bytes32 r,
95         bytes32 s
96     ) external;
97 
98     function nonces(address owner) external view returns (uint256);
99 
100     function DOMAIN_SEPARATOR() external view returns (bytes32);
101 }
102 
103 // File contracts/lib/SafeMath.sol
104 
105 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
106 
107 library SafeMath {
108     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
109         require((z = x + y) >= x, "ds-math-add-overflow");
110     }
111 
112     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
113         require((z = x - y) <= x, "ds-math-sub-underflow");
114     }
115 
116     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
117         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
118     }
119 }
120 
121 // File contracts/helpers/WriteDistributionHelperV1.sol
122 
123 /**
124  * @title WriteDistributionHelperV1
125  * @author MirrorXYZ
126  *
127  * A helper contract for distributing $WRITE token.
128  */
129 contract WriteDistributionHelperV1 {
130     // ============ Constants ============
131 
132     uint64 constant units = 1e18;
133 
134     // ============ Immutable Storage ============
135 
136     address public immutable token;
137 
138     // ============ Mutable Storage ============
139 
140     address private _owner;
141     /**
142      * @dev Allows for two-step ownership transfer, whereby the next owner
143      * needs to accept the ownership transfer explicitly.
144      */
145     address private _nextOwner;
146     bytes32 public merkleRoot;
147     mapping(uint256 => uint256) private claimedBitMap;
148 
149     // ============ Events ============
150 
151     event Distributed(address account);
152     event RootUpdated(bytes32 oldRoot, bytes32 newRoot);
153     event Claimed(uint256 index, address account, uint256 amount);
154     event Transfer(address indexed from, address indexed to, uint256 value);
155     event OwnershipTransferred(
156         address indexed previousOwner,
157         address indexed newOwner
158     );
159 
160     // ============ Modifiers ============
161 
162     modifier onlyOwner() {
163         require(isOwner(), "WriteDistributionV1: caller is not the owner.");
164         _;
165     }
166 
167     modifier onlyNextOwner() {
168         require(
169             isNextOwner(),
170             "WriteDistributionV1: current owner must set caller as next owner."
171         );
172         _;
173     }
174 
175     // ============ Constructor ============
176 
177     constructor(address token_) public {
178         token = token_;
179 
180         _owner = tx.origin;
181         emit OwnershipTransferred(address(0), _owner);
182     }
183 
184     // ============ Ownership ============
185 
186     /**
187      * @dev Returns true if the caller is the current owner.
188      */
189     function isOwner() public view returns (bool) {
190         return msg.sender == _owner;
191     }
192 
193     /**
194      * @dev Returns true if the caller is the next owner.
195      */
196     function isNextOwner() public view returns (bool) {
197         return msg.sender == _nextOwner;
198     }
199 
200     /**
201      * @dev Allows a new account (`newOwner`) to accept ownership.
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address nextOwner_) external onlyOwner {
205         require(
206             nextOwner_ != address(0),
207             "WriteDistributionV1: next owner is the zero address."
208         );
209 
210         _nextOwner = nextOwner_;
211     }
212 
213     /**
214      * @dev Cancel a transfer of ownership to a new account.
215      * Can only be called by the current owner.
216      */
217     function cancelOwnershipTransfer() external onlyOwner {
218         delete _nextOwner;
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to the caller.
223      * Can only be called by a new potential owner set by the current owner.
224      */
225     function acceptOwnership() external onlyNextOwner {
226         delete _nextOwner;
227 
228         emit OwnershipTransferred(_owner, msg.sender);
229 
230         _owner = msg.sender;
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() external onlyOwner {
241         emit OwnershipTransferred(_owner, address(0));
242         _owner = address(0);
243     }
244 
245     // ============ Distribution ============
246 
247     function distributeTo(address[] memory addresses)
248         public
249         onlyOwner
250         returns (bool ok)
251     {
252         IMirrorWriteToken tokenContract = IMirrorWriteToken(token);
253 
254         for (uint256 i = 0; i < addresses.length; i++) {
255             tokenContract.transfer(addresses[i], units);
256             emit Distributed(addresses[i]);
257         }
258 
259         return true;
260     }
261 
262     // ============ Merkle-Tree Token Claim ============
263 
264     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
265         emit RootUpdated(merkleRoot, merkleRoot_);
266         merkleRoot = merkleRoot_;
267     }
268 
269     function isClaimed(uint256 index) public view returns (bool) {
270         uint256 claimedWordIndex = index / 256;
271         uint256 claimedBitIndex = index % 256;
272         uint256 claimedWord = claimedBitMap[claimedWordIndex];
273         uint256 mask = (1 << claimedBitIndex);
274         return claimedWord & mask == mask;
275     }
276 
277     function _setClaimed(uint256 index) private {
278         uint256 claimedWordIndex = index / 256;
279         uint256 claimedBitIndex = index % 256;
280         claimedBitMap[claimedWordIndex] =
281             claimedBitMap[claimedWordIndex] |
282             (1 << claimedBitIndex);
283     }
284 
285     function claim(
286         uint256 index,
287         address account,
288         uint256 amount,
289         bytes32[] calldata merkleProof
290     ) external {
291         require(!isClaimed(index), "WriteDistributionV1: already claimed.");
292 
293         // Verify the merkle proof.
294         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
295         require(
296             MerkleProof.verify(merkleProof, merkleRoot, node),
297             "WriteDistributionV1: Invalid proof."
298         );
299 
300         // Mark it claimed and send the token.
301         _setClaimed(index);
302         require(
303             IMirrorWriteToken(token).transfer(account, amount),
304             "WriteDistributionV1: Transfer failed."
305         );
306 
307         emit Claimed(index, account, amount);
308     }
309 }