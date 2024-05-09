1 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
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
216 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
243 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
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
328 // File: contracts/SeamanMinter.sol
329 
330 
331 pragma solidity ^0.8.7;
332 
333 
334 
335 interface SeamanNFT {
336     function mint(address to, uint256 quantity) external;
337     function numberMinted(address one) external view returns (uint256);
338     function ownerOf(uint256 tokenId) external view returns (address);
339 }
340 
341 contract SeamanMinter is Ownable {
342 
343     struct InvitationRecord {
344         uint256 NumMinted;    // 
345         uint256 NumAssisted;  // 
346         uint256 NumInvited;   // 
347         uint256 NumSecondaryInvited; // 
348         uint256 ProfitAmount; // 
349         address InvitedBy;    // 
350     }
351 
352     SeamanNFT private _seamanNFT;                      // 
353 
354     address private _beneficiary;                      // 
355     uint256 private _profitAmount;                     // 
356 
357     mapping(address => InvitationRecord) private _invitation; // 
358 
359     // claimed profit
360     mapping(address => uint256) private claimedProfit;
361 
362     uint256 private _ratioA = 2000;                    // 20%
363     uint256 private _ratioB = 1000;                    // 10%
364 
365     uint256 private _priceA = 0.03 ether;              // public mint price
366     uint256 private _priceB = 0.02 ether;              // wlmint , invitemint price
367 
368     uint256 private _maxQuantity = 10;                 // 
369     uint256 private _maxNumMinted = 40;                // 
370 
371     bytes32 private _merkleTreeRoot;                   // “0” - wlmint false
372 
373     bool private _openToPublic = false;                // false - wlmint begin
374 
375     event claimed(address indexed wallet, uint256 indexed val);
376     
377     event mintedWithProof(
378         address indexed wallet,
379         uint256 indexed quantity,
380         uint256 indexed price
381     );
382 
383     event minted(
384         address indexed wallet,
385         uint256 indexed quantity,
386         uint256 indexed price
387     );
388 
389     event mintedWithCode(
390         address indexed wallet,
391         uint256 quantity,
392         uint256 price,
393         uint256 code,
394         address indexed rewardeeA,
395         uint256 rewardA,
396         address indexed rewardeeB,
397         uint256 rewardB
398     );
399 
400     /**
401      * 
402      *
403      * `seamanAddress` ERC721
404      */
405     constructor(address seamanContract) {
406         _seamanNFT = SeamanNFT(seamanContract);
407         _beneficiary = msg.sender;
408     }
409 
410     /**
411      * airdrop
412      *
413      * `users`      
414      * `quantities` 
415      */
416     function airdrop(address[] calldata users, uint256[] calldata quantities) public onlyOwner {
417         require(users.length > 0 && users.length == quantities.length, "Parameters error");
418         for (uint256 i = 0; i < users.length; i++) {
419             if (quantities[i] == 0) {
420                 continue;
421             }
422             _seamanNFT.mint(users[i], quantities[i]);
423         }
424     }
425 
426     /**
427      * 
428      *
429      * `proof`    
430      * `quantity` 
431      */
432     function mintWhitelist(bytes32[] calldata proof, uint256 quantity) public payable {
433         require(_merkleTreeRoot != bytes32(0), "Whitelist sale is not live");
434         require(MerkleProof.verify(proof, _merkleTreeRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid proof");
435         require(quantity > 0 && quantity <= _maxQuantity, "Wrong quantity");
436         require(_seamanNFT.numberMinted(msg.sender) + quantity <= _maxNumMinted, "Exceeds max per address");
437         require(msg.value >= _priceB * quantity, "Not enough ETH sent for selected amount");
438         _profitAmount += msg.value;
439         _seamanNFT.mint(msg.sender, quantity);
440         emit mintedWithProof(msg.sender, quantity, _priceB);
441     }
442 
443     /**
444      * 
445      *
446      * `quantity` 
447      */
448     function mint(uint256 quantity) public payable {
449         require(_openToPublic, "Sale is not live");
450         require(quantity > 0 && quantity <= _maxQuantity, "Wrong quantity");
451         require(_seamanNFT.numberMinted(msg.sender) + quantity <= _maxNumMinted, "Exceeds max per address");
452         require(msg.value >= _priceA * quantity, "Not enough ETH sent for selected amount");
453         _profitAmount += msg.value;
454         _seamanNFT.mint(msg.sender, quantity);
455         emit minted(msg.sender, quantity, _priceA);
456     }
457 
458     /**
459      * 
460      *
461      * `code`    TokenID
462      * `quantity` 
463      */
464     function mintWithCode(uint256 code, uint256 quantity) public payable {
465         address rewardeeA = _seamanNFT.ownerOf(code);
466         require(rewardeeA != address(0) && rewardeeA != msg.sender, "Invalid code");
467         require(_openToPublic, "Sale is not live");
468         require(quantity > 0 && quantity <= _maxQuantity, "Wrong quantity");
469         require(_seamanNFT.numberMinted(msg.sender) + quantity <= _maxNumMinted, "Exceeds max per address");
470         uint256 total = _priceB * quantity;
471         require(msg.value >= total, "Not enough ETH sent for selected amount");
472 
473         _seamanNFT.mint(msg.sender, quantity);
474         _invitation[msg.sender].InvitedBy = rewardeeA;
475         _invitation[msg.sender].NumMinted += quantity;
476         _invitation[rewardeeA].NumAssisted += quantity;
477         _invitation[rewardeeA].NumInvited += 1;
478 
479         unchecked {
480             uint256 rewardA = total / 10000 * _ratioA;
481             uint256 rewardB = total / 10000 * _ratioB;
482             _profitAmount += (msg.value - rewardA - rewardB);
483             address rewardeeB = _invitation[rewardeeA].InvitedBy;
484             if (rewardeeB == address(0)) {
485                 _profitAmount += rewardB;
486                 rewardB = 0;
487             } else {
488                 _invitation[rewardeeB].ProfitAmount += rewardB;
489                 _invitation[rewardeeB].NumSecondaryInvited += 1;
490             }
491             _invitation[rewardeeA].ProfitAmount += rewardA;
492             
493             emit mintedWithCode(msg.sender, quantity, _priceB, code, rewardeeA, rewardA, rewardeeB, rewardB);
494         }
495     }
496 
497     /**
498      * 
499      */
500     function profitAmount() public view returns (uint256) {
501         return _profitAmount;
502     }
503 
504    
505     function withdraw() public onlyOwner {
506         require(_beneficiary != address(0), "Beneficiary is zero");
507         require(_profitAmount > 0, "Profit is zero");
508         uint256 profit = _profitAmount;
509         _profitAmount = 0;
510         payable(_beneficiary).transfer(profit);
511     }
512 
513 
514     function withdrawAll() public onlyOwner {
515         require(_beneficiary != address(0), "Beneficiary is zero");
516         uint256 balance = address(this).balance;
517         require(balance > 0, "balance is zero");
518         payable(_beneficiary).transfer(balance);
519     }
520 
521 
522     function invitationRecord(address one) public view returns (InvitationRecord memory) {
523         return _invitation[one];
524     }
525 
526     /**
527      * 
528      */
529     function rewardAmount() public view returns (uint256) {
530         return _invitation[msg.sender].ProfitAmount;
531     }
532 
533     /**
534      * 
535      */
536     function claimedAmount() public view returns (uint256) {
537         return claimedProfit[msg.sender];
538     }
539 
540     /**
541      * 
542      */
543     function claim() public {
544         uint val = _invitation[msg.sender].ProfitAmount;
545         require(val > 0, "Reward is zero");
546         _invitation[msg.sender].ProfitAmount = 0;
547         claimedProfit[msg.sender] = claimedProfit[msg.sender] + val;
548         payable(msg.sender).transfer(val);
549         emit claimed(msg.sender, val);
550     }
551 
552     /* -------------------- config -------------------- */
553 
554     function seaman() public view returns(address) {
555         return address(_seamanNFT);
556     }
557 
558     function setSeaman(address nftContract) public onlyOwner {
559         _seamanNFT = SeamanNFT(nftContract);
560     }
561 
562     function beneficiary() public view returns (address) {
563         return _beneficiary;
564     }
565 
566     function setBeneficiary(address one) public onlyOwner {
567         require(one != address(0));
568         _beneficiary = one;
569     }
570 
571     function ratios() public view returns (uint256, uint256) {
572         return (_ratioA, _ratioB);
573     }
574 
575     function setRatios(uint256 ratioA, uint256 ratioB) public onlyOwner {
576         require(ratioA + ratioB <= 10000);
577         _ratioA = ratioA;
578         _ratioB = ratioB;
579     }
580 
581     function prices() public view returns (uint256, uint256) {
582         return (_priceA, _priceB);
583     }
584 
585     function setPrices(uint256 priceA, uint256 priceB) public onlyOwner {
586         require(priceA >= priceB);
587         _priceA = priceA;
588         _priceB = priceB;
589     }
590 
591     function mintLimits() public view returns (uint256, uint256) {
592         return (_maxQuantity, _maxNumMinted);
593     }
594 
595     function setMintLimits(uint256 maxQuantity, uint256 maxNumMinted) public onlyOwner {
596         require(maxQuantity * maxNumMinted > 0);
597         _maxQuantity = maxQuantity;
598         _maxNumMinted = maxNumMinted;
599     }
600 
601     function merkleTreeRoot() public view returns (bytes32) {
602         return _merkleTreeRoot;
603     }
604 
605     function setMerkleTreeRoot(bytes32 root) public onlyOwner {
606         _merkleTreeRoot = root;
607     }
608 
609     function openToPublic() public view returns (bool) {
610         return _openToPublic;
611     }
612 
613     function setOpenToPublic(bool bln) public onlyOwner {
614         _openToPublic = bln;
615     }
616 
617     /**
618      * receive ETH
619      */
620     receive() external payable {
621         payable(owner()).transfer(msg.value);
622     }
623 
624 }