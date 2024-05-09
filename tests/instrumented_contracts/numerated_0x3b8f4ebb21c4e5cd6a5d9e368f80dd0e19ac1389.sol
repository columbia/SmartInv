1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Context.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/access/Ownable.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Contract module which provides a basic access control mechanism, where
253  * there is an account (an owner) that can be granted exclusive access to
254  * specific functions.
255  *
256  * By default, the owner account will be the one that deploys the contract. This
257  * can later be changed with {transferOwnership}.
258  *
259  * This module is used through inheritance. It will make available the modifier
260  * `onlyOwner`, which can be applied to your functions to restrict their use to
261  * the owner.
262  */
263 abstract contract Ownable is Context {
264     address private _owner;
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268     /**
269      * @dev Initializes the contract setting the deployer as the initial owner.
270      */
271     constructor() {
272         _transferOwnership(_msgSender());
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         _checkOwner();
280         _;
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if the sender is not the owner.
292      */
293     function _checkOwner() internal view virtual {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public virtual onlyOwner {
305         _transferOwnership(address(0));
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Internal function without access restriction.
320      */
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 // File: minter.sol
329 
330 
331 // Copyright (c) 2022 Keisuke OHNO
332 
333 /*
334 
335 Permission is hereby granted, free of charge, to any person obtaining a copy
336 of this software and associated documentation files (the "Software"), to deal
337 in the Software without restriction, including without limitation the rights
338 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
339 copies of the Software, and to permit persons to whom the Software is
340 furnished to do so, subject to the following conditions:
341 
342 The above copyright notice and this permission notice shall be included in all
343 copies or substantial portions of the Software.
344 
345 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
346 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
347 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
348 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
349 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
350 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
351 SOFTWARE.
352 
353 */
354 
355 pragma solidity >=0.7.0 <0.9.0;
356 
357 
358 
359 
360 interface iNFTCollection {
361     function externalMint(address _address , uint256 _amount) external payable ;
362     function totalSupply() external view returns (uint256);
363     function balanceOf(address address_) external view returns (uint256);
364     function ownerOf(uint256 tokenId_) external view returns (address);
365     function tokensOfOwner(address _address) external view returns (uint256[] memory);
366 }
367 
368 contract HalloweenMinter is Ownable {
369 
370     address public constant withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
371     iNFTCollection public NFTCollection = iNFTCollection(0x2d3C8D1A84cA778A3bba0F4fC389330AB96AF3Be); 
372 
373     constructor(){
374         pause(false);
375         setMintCount(false);
376     }
377 
378 
379     uint256 public cost = 0;
380     uint256 public maxSupply = 5000;
381     uint256 public maxMintAmountPerTransaction = 3;
382     uint256 public publicSaleMaxMintAmountPerAddress = 300;
383     bool public paused = true;
384     bool public onlyWhitelisted = true;
385     bool public mintCount = true;
386     mapping(address => uint256) public whitelistMintedAmount;
387     mapping(address => uint256) public publicSaleMintedAmount;
388     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
389 
390     modifier callerIsUser() {
391         require(tx.origin == msg.sender, "The caller is another contract.");
392         _;
393     }
394  
395     //mint with merkle tree
396     bytes32 public merkleRoot;
397     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof) public payable callerIsUser{
398         require(!paused, "the contract is paused");
399         require(0 < _mintAmount, "need to mint at least 1 NFT");
400         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
401         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
402         require(cost * _mintAmount <= msg.value, "insufficient funds");
403         if(onlyWhitelisted == true) {
404             bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
405             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not whitelisted");
406             if(mintCount == true){
407                 require(_mintAmount <= _maxMintAmount - whitelistMintedAmount[msg.sender] , "max NFT per address exceeded");
408                 whitelistMintedAmount[msg.sender] += _mintAmount;
409             }
410         }else{
411             if(mintCount == true){
412                 require(_mintAmount <= publicSaleMaxMintAmountPerAddress - publicSaleMintedAmount[msg.sender] , "max NFT per address exceeded");
413                 publicSaleMintedAmount[msg.sender] += _mintAmount;
414             }
415         }
416         NFTCollection.externalMint( msg.sender , _mintAmount );
417     }
418 
419     function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
420         maxSupply = _maxSupply;
421     }    
422 
423     function totalSupply() public view returns(uint256){
424         return NFTCollection.totalSupply();
425     }
426 
427     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
428         merkleRoot = _merkleRoot;
429     }
430 
431     function setPublicSaleMaxMintAmountPerAddress(uint256 _publicSaleMaxMintAmountPerAddress) public onlyOwner() {
432         publicSaleMaxMintAmountPerAddress = _publicSaleMaxMintAmountPerAddress;
433     }
434 
435     function setCost(uint256 _newCost) public onlyOwner {
436         cost = _newCost;
437     }
438 
439     function setOnlyWhitelisted(bool _state) public onlyOwner {
440         onlyWhitelisted = _state;
441     }
442 
443     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyOwner {
444         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
445     }
446   
447     function pause(bool _state) public onlyOwner {
448         paused = _state;
449     }
450 
451     function setMintCount(bool _state) public onlyOwner {
452         mintCount = _state;
453     }
454 
455 
456 
457 
458 
459     //onlyowner
460     function setNFTCollection(address _address) public onlyOwner() {
461         NFTCollection = iNFTCollection(_address);
462     }
463 
464     function withdraw() public onlyOwner {
465         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
466         require(os);
467     }
468 
469 
470 
471 }