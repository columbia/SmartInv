1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Tree proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Calldata version of {verify}
105      *
106      * _Available since v4.7._
107      */
108     function verifyCalldata(
109         bytes32[] calldata proof,
110         bytes32 root,
111         bytes32 leaf
112     ) internal pure returns (bool) {
113         return processProofCalldata(proof, leaf) == root;
114     }
115 
116     /**
117      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
119      * hash matches the root of the tree. When processing the proof, the pairs
120      * of leafs & pre-images are assumed to be sorted.
121      *
122      * _Available since v4.4._
123      */
124     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             computedHash = _hashPair(computedHash, proof[i]);
128         }
129         return computedHash;
130     }
131 
132     /**
133      * @dev Calldata version of {processProof}
134      *
135      * _Available since v4.7._
136      */
137     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
138         bytes32 computedHash = leaf;
139         for (uint256 i = 0; i < proof.length; i++) {
140             computedHash = _hashPair(computedHash, proof[i]);
141         }
142         return computedHash;
143     }
144 
145     /**
146      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
147      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
148      *
149      * _Available since v4.7._
150      */
151     function multiProofVerify(
152         bytes32[] memory proof,
153         bool[] memory proofFlags,
154         bytes32 root,
155         bytes32[] memory leaves
156     ) internal pure returns (bool) {
157         return processMultiProof(proof, proofFlags, leaves) == root;
158     }
159 
160     /**
161      * @dev Calldata version of {multiProofVerify}
162      *
163      * _Available since v4.7._
164      */
165     function multiProofVerifyCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32 root,
169         bytes32[] memory leaves
170     ) internal pure returns (bool) {
171         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
172     }
173 
174     /**
175      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
176      * consuming from one or the other at each step according to the instructions given by
177      * `proofFlags`.
178      *
179      * _Available since v4.7._
180      */
181     function processMultiProof(
182         bytes32[] memory proof,
183         bool[] memory proofFlags,
184         bytes32[] memory leaves
185     ) internal pure returns (bytes32 merkleRoot) {
186         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
187         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
188         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
189         // the merkle tree.
190         uint256 leavesLen = leaves.length;
191         uint256 totalHashes = proofFlags.length;
192 
193         // Check proof validity.
194         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
195 
196         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
197         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
198         bytes32[] memory hashes = new bytes32[](totalHashes);
199         uint256 leafPos = 0;
200         uint256 hashPos = 0;
201         uint256 proofPos = 0;
202         // At each step, we compute the next hash using two values:
203         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
204         //   get the next hash.
205         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
206         //   `proof` array.
207         for (uint256 i = 0; i < totalHashes; i++) {
208             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
209             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
210             hashes[i] = _hashPair(a, b);
211         }
212 
213         if (totalHashes > 0) {
214             return hashes[totalHashes - 1];
215         } else if (leavesLen > 0) {
216             return leaves[0];
217         } else {
218             return proof[0];
219         }
220     }
221 
222     /**
223      * @dev Calldata version of {processMultiProof}
224      *
225      * _Available since v4.7._
226      */
227     function processMultiProofCalldata(
228         bytes32[] calldata proof,
229         bool[] calldata proofFlags,
230         bytes32[] memory leaves
231     ) internal pure returns (bytes32 merkleRoot) {
232         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
233         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
234         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
235         // the merkle tree.
236         uint256 leavesLen = leaves.length;
237         uint256 totalHashes = proofFlags.length;
238 
239         // Check proof validity.
240         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
241 
242         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
243         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
244         bytes32[] memory hashes = new bytes32[](totalHashes);
245         uint256 leafPos = 0;
246         uint256 hashPos = 0;
247         uint256 proofPos = 0;
248         // At each step, we compute the next hash using two values:
249         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
250         //   get the next hash.
251         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
252         //   `proof` array.
253         for (uint256 i = 0; i < totalHashes; i++) {
254             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
255             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
256             hashes[i] = _hashPair(a, b);
257         }
258 
259         if (totalHashes > 0) {
260             return hashes[totalHashes - 1];
261         } else if (leavesLen > 0) {
262             return leaves[0];
263         } else {
264             return proof[0];
265         }
266     }
267 
268     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
269         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
270     }
271 
272     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
273         /// @solidity memory-safe-assembly
274         assembly {
275             mstore(0x00, a)
276             mstore(0x20, b)
277             value := keccak256(0x00, 0x40)
278         }
279     }
280 }
281 
282 // File: @openzeppelin/contracts/utils/Context.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Provides information about the current execution context, including the
291  * sender of the transaction and its data. While these are generally available
292  * via msg.sender and msg.data, they should not be accessed in such a direct
293  * manner, since when dealing with meta-transactions the account sending and
294  * paying for execution may not be the actual sender (as far as an application
295  * is concerned).
296  *
297  * This contract is only required for intermediate, library-like contracts.
298  */
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes calldata) {
305         return msg.data;
306     }
307 }
308 
309 // File: @openzeppelin/contracts/access/Ownable.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @dev Contract module which provides a basic access control mechanism, where
319  * there is an account (an owner) that can be granted exclusive access to
320  * specific functions.
321  *
322  * By default, the owner account will be the one that deploys the contract. This
323  * can later be changed with {transferOwnership}.
324  *
325  * This module is used through inheritance. It will make available the modifier
326  * `onlyOwner`, which can be applied to your functions to restrict their use to
327  * the owner.
328  */
329 abstract contract Ownable is Context {
330     address private _owner;
331 
332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334     /**
335      * @dev Initializes the contract setting the deployer as the initial owner.
336      */
337     constructor() {
338         _transferOwnership(_msgSender());
339     }
340 
341     /**
342      * @dev Throws if called by any account other than the owner.
343      */
344     modifier onlyOwner() {
345         _checkOwner();
346         _;
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if the sender is not the owner.
358      */
359     function _checkOwner() internal view virtual {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361     }
362 
363     /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         _transferOwnership(address(0));
372     }
373 
374     /**
375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
376      * Can only be called by the current owner.
377      */
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         _transferOwnership(newOwner);
381     }
382 
383     /**
384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
385      * Internal function without access restriction.
386      */
387     function _transferOwnership(address newOwner) internal virtual {
388         address oldOwner = _owner;
389         _owner = newOwner;
390         emit OwnershipTransferred(oldOwner, newOwner);
391     }
392 }
393 
394 // File: contracts/sale.sol
395 
396 
397 
398 pragma solidity ^0.8.14;
399 
400 
401 
402 
403 
404 interface ITestNFT {
405     function totalSupply() external view returns (uint);
406     function MAX_SUPPLY() external returns (uint);
407     function startingIndex() external returns (uint);
408     function mintBySaleContract(address _addressBuyer, uint _quantity) external;
409     function stakeNFT(uint tokenId) external;
410     function unstakeNFT(uint[] memory tokenId, address _to) external;
411     function ownerOf(uint tokenId) external view returns (address owner);
412 }
413 
414 interface ILotteryContractInterface {
415   function requestRandomWords() external;
416   function returnLotteryRandomNumber() external view returns(uint);
417   function returnStartIndexRandomNumber(uint _SaleSupply) external view returns(uint);
418 }
419 
420 contract GatesOfOxyaLandSale is Ownable, ReentrancyGuard {
421 
422     event SaleStarted(uint _session);
423     event RoundTimeUpdated(uint _time);
424     event RandomResult(uint _number);
425     event IsWinner(bool _winner);
426     event StartIndex(uint startIndex);
427 
428     // Merklee Tree root
429     bytes32 public root;
430     bytes32 public freeMintRoot;
431 
432     // Is the sales initialized?
433     bool public initialized;
434 
435     // Timestamp when a new round start
436     uint public startTime;
437 
438     // Number of the round & Duration of rounds
439     uint public dutchRoundNumber;
440     mapping(uint => uint) dutchDurationPerRound; // Time rleft until next round
441 
442     // Potential winning percentage per address
443     mapping(address => mapping(uint => uint)) public chanceToWinPerAddress;
444 
445     // Potential winning percentage per address whitelisted
446     mapping(address => mapping(uint => uint)) public chanceToWinPerAddressWhitelist;
447 
448     // Mapping to follow the freemint used
449     mapping(uint => mapping(address => uint)) public freeMintsUsed;
450 
451     // Mapping to follow the number of token by wallet
452      mapping(uint => mapping(address => uint)) public tokenPerWallet;
453 
454      // Starting index of the metadata attribution
455     uint public startingIndex;
456 
457     // Dutch auction mecanisms
458     uint public constant DUTCH_PRICE_START = 0.6 ether;
459     uint public constant DUTCH_PRICE_END = 0.2 ether;
460     uint public constant FIRST_DUTCH_DROPPING_STEP = 0.1 ether;
461     uint public constant DUTCH_DROPPING_STEP = 0.05 ether;
462     uint public constant DUTCH_ROUND_DURATION = 15*60 seconds;
463     uint public constant DUTCH_ROUND_MAX_DURATION = 15*60 seconds;
464     uint public constant DUTCH_AUCTION_MAX_DURATION = 1440*60 seconds;
465     uint public constant DUTCH_AUCTION_MAX_ROUND = 7; // Round start to 0, there is 8
466     uint public session;
467 
468     // Address of the NFT contract
469     address public oxyalandsNFTAddress;
470 
471     // Address of the Lottery Contract
472     address public lotteryAddress;
473 
474     // Sales status
475     bool public isActive;
476     bool public isFreeMintActive;
477 
478     // Lottery status
479     bool public isLotteryActive;
480 
481     // Max supply for current sale
482     uint public maxSupplySale = 3244;
483     uint public countMintedBySale;
484     uint public maxSupplyFreeMint = 1400;
485     uint public countMintedByFreeMint;
486 
487     uint64 public REWARD=3 ether;
488 
489     uint8[6] public PUBLIC_PERCENTAGE = [50,25,13,7,3,2];
490     uint8[6] public WHITELIST_PERCENTAGE = [100,50,25,13,7,3];
491 
492     constructor(address _lotteryAddress, address _oxyalandsNFTAddress) {
493         lotteryAddress = _lotteryAddress;
494         oxyalandsNFTAddress = _oxyalandsNFTAddress;
495     }
496 
497     modifier isInitialized {
498         require(initialized, "Sale has not started");
499         _;
500     }
501 
502     modifier isPublicSaleActive {
503         require(isActive == true, "Sale has not started");
504         _;
505     }
506 
507     function setMerkleRoot(bytes32 _root) public onlyOwner {
508         root = _root;
509     }
510 
511     function setFreeMintMerkleRoot(bytes32 _root) public onlyOwner {
512         freeMintRoot = _root;
513     }
514 
515     function setIsActive() external onlyOwner {
516         isActive = !isActive;
517     }
518 
519     function setIsFreeMintActive() external onlyOwner {
520         isFreeMintActive = !isFreeMintActive;
521     }
522 
523     function setIsLotteryActive() external onlyOwner {
524         isLotteryActive = !isLotteryActive;
525     }
526 
527     /*
528      * Sale supply
529      * function to change SaleSupply
530      */
531     function setSaleSupply(uint _newSaleSupply) external onlyOwner {
532         require(_newSaleSupply > countMintedBySale, "supply minimum reached");
533         require(_newSaleSupply <= ITestNFT(oxyalandsNFTAddress).MAX_SUPPLY() - ITestNFT(oxyalandsNFTAddress).totalSupply(), "Max supply reached");
534         maxSupplySale = _newSaleSupply;
535     }
536 
537     /*
538      * FreeMint supply
539      * function to change FreeMintSupply
540      */
541     function setFreeMintSupply(uint _newFreeMintSupply) external onlyOwner {
542         require(_newFreeMintSupply > countMintedByFreeMint, "supply minimum reached");
543         require(_newFreeMintSupply <= ITestNFT(oxyalandsNFTAddress).MAX_SUPPLY() - ITestNFT(oxyalandsNFTAddress).totalSupply(), "Max supply reached");
544         maxSupplyFreeMint = _newFreeMintSupply;
545     }
546 
547     /*
548      * Time mecanism
549      * Time remaining in seconds for the active round
550      */
551     function getRoundRemainingTime() public view returns(uint) {
552         uint activeRound = getRound();
553         if(activeRound == DUTCH_AUCTION_MAX_ROUND){
554             return block.timestamp;
555         }
556         return getRoundEndingUTC() - block.timestamp;
557     }
558 
559     /*
560      *  Returns active round ending time in utc seconds.
561      *  This will be used front end to display new round before blockhain knows it,
562      *  when we are between two blockchain blocks
563      */
564     function getRoundEndingUTC() public view returns(uint) {
565         uint activeRound = getRound();
566         uint sum = startTime + dutchDurationPerRound[dutchRoundNumber];
567 
568         for (uint i=dutchRoundNumber + 1; i < activeRound + 1; i++) {
569              sum+= DUTCH_ROUND_DURATION;
570         }
571         return sum;
572     }
573 
574     /*
575      * Round mecanism
576      */
577     function getRound() public view returns(uint) {
578         if((startTime + dutchDurationPerRound[dutchRoundNumber]) > block.timestamp) { 
579             return dutchRoundNumber;
580         }
581         else {
582             uint round = dutchRoundNumber + (block.timestamp - (startTime + dutchDurationPerRound[dutchRoundNumber])) / DUTCH_ROUND_DURATION + 1;
583             if(round < DUTCH_AUCTION_MAX_ROUND){
584                 return round;
585             } else {
586                 return DUTCH_AUCTION_MAX_ROUND;
587             }
588         }
589        }
590 
591     /*
592      * Price mecanisms
593      */
594     function getPrice() public view returns(uint) {
595         if(block.timestamp < startTime){
596           return DUTCH_PRICE_START;
597        }
598         uint currentRound = getRound();
599         if(block.timestamp - startTime >= DUTCH_AUCTION_MAX_DURATION || currentRound >= DUTCH_AUCTION_MAX_ROUND  ) {
600          return DUTCH_PRICE_END;
601         }
602         else if(currentRound == 0 || currentRound == 1 ){
603             return DUTCH_PRICE_START - ( currentRound * FIRST_DUTCH_DROPPING_STEP);
604         }
605         else {
606          return DUTCH_PRICE_START - FIRST_DUTCH_DROPPING_STEP - ((currentRound - 1) * DUTCH_DROPPING_STEP);
607         }
608      }
609      
610     /*
611      * Initialize the sale
612      */
613     function initialize() external onlyOwner {
614         initialized = true;
615         dutchRoundNumber = 0;
616         dutchDurationPerRound[0] = DUTCH_ROUND_DURATION;
617         for (uint i = 1; i < DUTCH_AUCTION_MAX_ROUND + 1; i++) {
618             dutchDurationPerRound[i] = 0;
619         }
620         startTime = block.timestamp;
621         session += 1;
622         emit SaleStarted(session);
623     }
624 
625     /*
626      * Function to mint freeMints
627      */
628     function freeMint(uint _quantity, uint count, bytes32[] calldata proof) external isInitialized  nonReentrant {
629         require(!isActive == true, "Sale is still running");
630         require(isFreeMintActive == true, "Free mint is not started");
631         require(
632                 MerkleProof.verify(
633                     proof,
634                     freeMintRoot,
635                     keccak256(abi.encode(msg.sender, count))
636                 ),
637                 "!proof"
638             );
639         require(countMintedByFreeMint + _quantity <= maxSupplyFreeMint , 'Max supply freemint reached');
640         require(freeMintsUsed[session][msg.sender] + _quantity <= count, 'Not allowed to freemint this quantity');
641         countMintedByFreeMint += _quantity;
642         freeMintsUsed[session][msg.sender]+= _quantity;
643         ITestNFT(oxyalandsNFTAddress).mintBySaleContract(msg.sender, _quantity);  
644     }
645     
646     /*
647      * Mint function
648      * Basic mint function for the dutch auction
649      */
650     function mint(uint _quantity, address _to, uint maxTokenPerWallet) private isInitialized isPublicSaleActive   {
651         uint price = getPrice();
652         require(msg.value >= price * _quantity, "Not enough ETH");
653         require(countMintedBySale + _quantity <= maxSupplySale, "Max supply for this sale reached");
654         require(tokenPerWallet[session][_to] + _quantity <= maxTokenPerWallet, "Max tokens per wallet reached");
655         tokenPerWallet[session][_to] += _quantity;
656         countMintedBySale += _quantity;
657         uint roundRemainingTime = getRoundRemainingTime();
658         uint currentRound = getRound();
659 
660         if((startTime + dutchDurationPerRound[dutchRoundNumber]) > block.timestamp && dutchDurationPerRound[dutchRoundNumber] < DUTCH_ROUND_MAX_DURATION && currentRound != DUTCH_AUCTION_MAX_ROUND) {
661             if (roundRemainingTime >= 60) {
662                 dutchDurationPerRound[dutchRoundNumber] += 20 seconds;
663                 emit RoundTimeUpdated(getRoundEndingUTC());
664             }
665         }
666         if(currentRound > dutchRoundNumber && dutchRoundNumber < DUTCH_AUCTION_MAX_ROUND && currentRound != DUTCH_AUCTION_MAX_ROUND) {
667             startTime = block.timestamp - (DUTCH_ROUND_DURATION - roundRemainingTime);
668             dutchRoundNumber = currentRound;
669             
670             if (roundRemainingTime >= 60) {
671                 dutchDurationPerRound[dutchRoundNumber] = DUTCH_ROUND_DURATION + 20 seconds;
672             } else {
673                 dutchDurationPerRound[dutchRoundNumber] = DUTCH_ROUND_DURATION;
674             }
675             emit RoundTimeUpdated(getRoundEndingUTC());
676         }
677 
678          if(currentRound == DUTCH_AUCTION_MAX_ROUND){
679             dutchRoundNumber = DUTCH_AUCTION_MAX_ROUND;
680         }
681         emit RoundTimeUpdated(getRoundEndingUTC());
682 
683         ITestNFT(oxyalandsNFTAddress).mintBySaleContract(_to, _quantity);
684     }
685 
686     /*
687      * Public Mint function
688      * function without automatic staking 
689      */
690     function publicMint(uint _quantity, address _to) public payable nonReentrant {
691         mint(_quantity, _to, 4);
692     }
693 
694     /*
695      * Public Mint Staking function
696      * function with automatic staking 
697      */
698     function publicMintStake(uint _quantity) external payable nonReentrant {
699         uint totalSupply=ITestNFT(oxyalandsNFTAddress).totalSupply();
700         mint(_quantity, msg.sender, 4);
701         
702         if(dutchRoundNumber < 6){
703             chanceToWinPerAddress[msg.sender][dutchRoundNumber] += _quantity;
704         }
705 
706         for(uint i=0; i < _quantity; i++){
707         stake(totalSupply + i, msg.sender);
708     }         
709     }
710 
711     /*
712      * Whitelist Mint Staking function
713      * function without automatic staking 
714      */
715     function whitelistMint(uint _quantity, bytes32[] memory proof, address _to, uint maxPerWallet) public payable nonReentrant  {
716         require(MerkleProof.verify(proof, root, keccak256(abi.encode(_to, maxPerWallet))), "You're not in the whitelist");
717         mint(_quantity, _to, maxPerWallet);
718     }
719 
720     /*
721      * Whitelist Mint Staking function
722      * function with automatic staking 
723      */
724     function whitelistMintStake(uint _quantity, bytes32[] memory proof, uint maxPerWallet) external payable nonReentrant  {
725         require(MerkleProof.verify(proof, root, keccak256(abi.encode(msg.sender, maxPerWallet))), "You're not in the whitelist");
726         uint totalSupply=ITestNFT(oxyalandsNFTAddress).totalSupply();
727         mint(_quantity, msg.sender, maxPerWallet);
728 
729         if(dutchRoundNumber < 6)
730             chanceToWinPerAddressWhitelist[msg.sender][dutchRoundNumber] += _quantity;
731   
732         for(uint i=0; i < _quantity; i++){
733             stake(totalSupply + i, msg.sender);
734         }   
735     }
736 
737     /*
738      * Lottery function
739      * function that sends rewards if the lottery ticket is a winner based on Chainlink VRF
740      */
741     function lottery() external isInitialized nonReentrant {
742         require(!isActive, "Sale isn't over");
743         require(isLotteryActive, "Lottery is not active");
744         require(tx.origin == msg.sender, "Cannot be called by contract account");
745 
746         if(chanceToWinPerAddress[msg.sender][0] + chanceToWinPerAddress[msg.sender][1] + chanceToWinPerAddress[msg.sender][2] + chanceToWinPerAddress[msg.sender][3] + chanceToWinPerAddress[msg.sender][4] + chanceToWinPerAddress[msg.sender][5] > 0) {
747             ILotteryContractInterface(lotteryAddress).requestRandomWords();
748             uint randomNumber = ILotteryContractInterface(lotteryAddress).returnLotteryRandomNumber();
749             for(uint i = 0; i < 6; i++) {
750                 uint count = chanceToWinPerAddress[msg.sender][i];
751                 if(count != 0){
752                     for(uint j = 0; j < count ; j++) {
753                         //should call VRF
754                         uint randomNumberFinal = uint(keccak256(abi.encodePacked(randomNumber,i, j))) % 1000;
755                         emit RandomResult(randomNumberFinal);
756                         bool hasWin =  randomNumberFinal < PUBLIC_PERCENTAGE[i];
757                         chanceToWinPerAddress[msg.sender][i]-=1;
758 
759                         emit IsWinner(hasWin);
760                     
761                         if(hasWin==true){
762                             //send Rewards
763                             (bool success, ) = payable(msg.sender).call{value: REWARD}(
764                                 ""
765                             );
766                             require(success, "!transfer");
767                         }
768                     } 
769                  }     
770             }
771         }
772         if(chanceToWinPerAddressWhitelist[msg.sender][0] + chanceToWinPerAddressWhitelist[msg.sender][1] + chanceToWinPerAddressWhitelist[msg.sender][2] + chanceToWinPerAddressWhitelist[msg.sender][3] + chanceToWinPerAddressWhitelist[msg.sender][4] + chanceToWinPerAddressWhitelist[msg.sender][5] > 0) {
773             ILotteryContractInterface(lotteryAddress).requestRandomWords();
774             uint randomNumber = ILotteryContractInterface(lotteryAddress).returnLotteryRandomNumber();
775             for(uint i = 0; i < 6; i++) {
776                 uint count = chanceToWinPerAddressWhitelist[msg.sender][i];
777                  if(count != 0){
778                     for(uint j = 0; j < count ; j++) {
779                         //should call VRF
780                         uint randomNumberFinal = uint(keccak256(abi.encodePacked(randomNumber,i, j))) % 1000;
781                         emit RandomResult(randomNumberFinal);
782                         bool hasWin =  randomNumberFinal < WHITELIST_PERCENTAGE[i];
783                         chanceToWinPerAddressWhitelist[msg.sender][i] -= 1;
784 
785                         emit IsWinner(hasWin);
786                     
787                         if(hasWin==true){
788                             //send Rewards
789                             (bool success, ) = payable(msg.sender).call{value: REWARD}(
790                                 ""
791                             );
792                             require(success, "!transfer");
793                         }
794                     }
795                 }
796             }
797         }
798     }
799 
800     function withdraw() external onlyOwner nonReentrant {
801         (bool success, ) = payable(msg.sender).call{
802             value: address(this).balance
803         }("");
804         require(success, "!transfer");
805     }
806     
807     /*
808      * Staking function
809      * private function that stakes NFT
810      */
811     function stake(uint _tokenId, address _to) private {
812         require(ITestNFT(oxyalandsNFTAddress).ownerOf(_tokenId) == _to, "not your nft");
813         ITestNFT(oxyalandsNFTAddress).stakeNFT(_tokenId);
814     }
815 
816     /*
817      * Unstaking function
818      * function that unstakes NFT and delete any chances for the lottery
819      */
820     function unstake(uint[] memory _tokenId) external {
821         address to = msg.sender;
822         ITestNFT(oxyalandsNFTAddress).unstakeNFT(_tokenId, to);
823         
824          for(uint i = 0; i < 6; i++) {
825                 uint count = chanceToWinPerAddressWhitelist[to][i];
826 
827                 if(count != 0){
828                     chanceToWinPerAddressWhitelist[to][i] -= count;
829                     return;
830                 }
831          }
832            for(uint i = 0; i < 6; i++) {
833                 uint count = chanceToWinPerAddress[to][i];
834 
835                 if(count != 0){
836                     chanceToWinPerAddress[to][i] -= count;
837                     return;
838                 }
839          }
840     }
841 
842     /*
843      * Starting index function
844      * function that gets random starting index for metadata attribution
845      */
846     function getStartingIndex() external isInitialized onlyOwner {
847         require(!isActive, "Sale isn't over");
848         ILotteryContractInterface(lotteryAddress).requestRandomWords();
849         uint randomNumber = ILotteryContractInterface(lotteryAddress).returnStartIndexRandomNumber(countMintedBySale + countMintedByFreeMint);
850         startingIndex = randomNumber;
851         emit StartIndex(randomNumber);
852     }
853 }