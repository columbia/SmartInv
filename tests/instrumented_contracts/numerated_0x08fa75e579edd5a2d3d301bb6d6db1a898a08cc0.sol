1 // hevm: flattened sources of src/MerkleMint.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /* import "../utils/Context.sol"; */
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _setOwner(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 ////// lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol
102 
103 /* pragma solidity ^0.8.0; */
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and making it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 ////// lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol
165 
166 /* pragma solidity ^0.8.0; */
167 
168 /**
169  * @dev These functions deal with verification of Merkle Trees proofs.
170  *
171  * The proofs can be generated using the JavaScript library
172  * https://github.com/miguelmota/merkletreejs[merkletreejs].
173  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
174  *
175  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
176  */
177 library MerkleProof {
178     /**
179      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
180      * defined by `root`. For this, a `proof` must be provided, containing
181      * sibling hashes on the branch from the leaf to the root of the tree. Each
182      * pair of leaves and each pair of pre-images are assumed to be sorted.
183      */
184     function verify(
185         bytes32[] memory proof,
186         bytes32 root,
187         bytes32 leaf
188     ) internal pure returns (bool) {
189         bytes32 computedHash = leaf;
190 
191         for (uint256 i = 0; i < proof.length; i++) {
192             bytes32 proofElement = proof[i];
193 
194             if (computedHash <= proofElement) {
195                 // Hash(current computed hash + current element of the proof)
196                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
197             } else {
198                 // Hash(current element of the proof + current computed hash)
199                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
200             }
201         }
202 
203         // Check if the computed hash (root) is equal to the provided root
204         return computedHash == root;
205     }
206 }
207 
208 ////// src/MerkleMint.sol
209 /* pragma solidity ^0.8.0; */
210 
211 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
212 /* import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; */
213 /* import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; */
214 
215 interface IERC1155_2 {
216     function mint(address, uint256, uint256) external;
217     function totalSupply(uint256) external view returns (uint256);
218 }
219 
220 contract MerkleMint is Ownable, ReentrancyGuard {
221     IERC1155_2 public immutable token;
222     uint256 public immutable id;
223     bytes32 public immutable merkleRootPresale;
224     bytes32 public immutable merkleRoot;
225     uint256 public constant PRICE = 0.08 ether;
226     uint256 public constant START = 1634140800;
227     uint256 public constant MAX = 2949;
228 
229     // This is a packed array of booleans.
230     mapping(uint256 => uint256) private claimedBitMapPresale;
231     mapping(uint256 => uint256) private claimedBitMap;
232 
233     event Minted(uint256 index, address account, uint256 amount);
234 
235     constructor(
236         address _token,
237         uint256 _id,
238         bytes32 _merkleRoot,
239         bytes32 _merkleRootPresale
240     ) {
241         token = IERC1155_2(_token);
242         id = _id;
243         merkleRoot = _merkleRoot;
244         merkleRootPresale = _merkleRootPresale;
245     }
246 
247     function amountLeft() public view returns(uint256) {
248         return MAX - token.totalSupply(id);
249     }
250 
251     function isMintedPresale(uint256 index) public view returns (bool) {
252         uint256 claimedWordIndex = index / 256;
253         uint256 claimedBitIndex = index % 256;
254         uint256 claimedWord = claimedBitMapPresale[claimedWordIndex];
255         uint256 mask = (1 << claimedBitIndex);
256         return claimedWord & mask == mask;
257     }
258 
259     function _setMintedPresale(uint256 index) private {
260         uint256 claimedWordIndex = index / 256;
261         uint256 claimedBitIndex = index % 256;
262         claimedBitMapPresale[claimedWordIndex] =
263             claimedBitMapPresale[claimedWordIndex] |
264             (1 << claimedBitIndex);
265     }
266 
267     function isMinted(uint256 index) public view returns (bool) {
268         uint256 claimedWordIndex = index / 256;
269         uint256 claimedBitIndex = index % 256;
270         uint256 claimedWord = claimedBitMap[claimedWordIndex];
271         uint256 mask = (1 << claimedBitIndex);
272         return claimedWord & mask == mask;
273     }
274 
275     function _setMinted(uint256 index) private {
276         uint256 claimedWordIndex = index / 256;
277         uint256 claimedBitIndex = index % 256;
278         claimedBitMap[claimedWordIndex] =
279             claimedBitMap[claimedWordIndex] |
280             (1 << claimedBitIndex);
281     }
282 
283     function mintPresale(
284         uint256 amount,
285         uint256 index,
286         address account,
287         bytes32[] calldata merkleProof
288     ) external payable nonReentrant() {
289         require(block.timestamp > START, "too soon");
290         require(msg.value == amount * PRICE, "wrong price");
291         require(!isMintedPresale(index), "already minted");
292 
293         // Verify the merkle proof.
294         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
295         require(
296             MerkleProof.verify(merkleProof, merkleRootPresale, node),
297             "invalid proof"
298         );
299 
300         // Mark it claimed and send the token.
301         _setMintedPresale(index);
302         _mint(account, amount, index);
303     }
304 
305     function mint(
306         uint256 amount,
307         uint256 index,
308         address account,
309         bytes32[] calldata merkleProof
310     ) external payable nonReentrant() {
311         require(amount < 6, "too many");
312         require(!isMinted(index), "already minted");
313         require(block.timestamp > START + 1 days, "too soon");
314 
315         // Verify the merkle proof.
316         bytes32 node = keccak256(abi.encodePacked(index, account, uint256(1)));
317         require(
318             MerkleProof.verify(merkleProof, merkleRoot, node),
319             "invalid proof"
320         );
321 
322         // Mark it claimed and send the token.
323         _setMinted(index);
324         _mint(account, amount, index);
325     }
326 
327     function mintLeftover(uint256 amount) external payable nonReentrant() {
328         require(block.timestamp > START + 2 days, "too soon");
329         _mint(msg.sender, amount, 99999);
330     }
331 
332     function _mint(address to, uint256 amount, uint256 index) internal {
333         require(amount <= amountLeft(), "too many");
334         require(msg.value == amount * PRICE, "wrong price");
335         token.mint(to, id, amount);
336         emit Minted(index, msg.sender, amount);
337     }
338 
339     function devMint(uint256 amount) external onlyOwner {
340         token.mint(owner(), id, amount);
341     }
342 
343     function withdraw() external onlyOwner {
344         payable(owner()).transfer(address(this).balance);
345     }
346 }