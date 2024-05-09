1 /**
2 
3                                                                                                     
4         ((((((((   .(((("/(((       (((((,                 .((((/        /(((((((   *((((((((       
5      ,/(((((((((   .(((("//(((/*    (((((((,             (((((((/     ./(((((((((   /((((((((((*    
6     ((((((                 ((((**       ((((((.       *((((((       .(((((                  /((((   
7     (((/((                 (((((*          .#####   ,##((           ,(/(((                 ./"/"/   
8     ((((((                 (((((/             *#####((              .((((/                 .////(   
9     ((((((                 (((((*             ,((####(              .(((((                 ./((/(   
10     ((((((                 (((((*             ,((((###/             ./((((                 .((((/   
11     ((((((                 (((/(*           "//(((((/(#(/           .(###(                 .((((/   
12     *(((((                 (((((/          *####...*"/###           .(####                 ./((((   
13     (((((/                 ###((/       (####.          (###(       ,((#((                  (((#(   
14      "/((######(    ((#######/*,    (((##( .             . *#((((     .,(((((((#(   ,((##((((((*    
15         (######(    (#######(       (#(#(*                 .(((((        ((((((##   *(#((##((*      
16 
17 
18     0x0 Dashboard contract allows you to claim ETH and compound it back to 0x0 tokens at your discretion, 
19     with any amount in ETH. It utilizes Merkle Proofs, and your ETH amount remains fixed to your address 
20     until you claim it. You can track your claimed and unclaimed rewards, as well as the total distributed rewards.
21     
22     Additionally, you can monitor the volume of ETH added to the contract. The contract also provides calculations 
23     for APY, APR, and your rewards.
24 
25 */
26 
27 
28 // SPDX-License-Identifier: MIT
29 pragma solidity >=0.8.0;
30 
31 interface IUniswapV2Factory {
32     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
33 
34     function feeTo() external view returns (address);
35     function feeToSetter() external view returns (address);
36 
37     function getPair(address tokenA, address tokenB) external view returns (address pair);
38     function allPairs(uint) external view returns (address pair);
39     function allPairsLength() external view returns (uint);
40 
41     function createPair(address tokenA, address tokenB) external returns (address pair);
42 
43     function setFeeTo(address) external;
44     function setFeeToSetter(address) external;
45 }
46 
47 interface IUniswapV2Pair {
48     event Approval(address indexed owner, address indexed spender, uint value);
49     event Transfer(address indexed from, address indexed to, uint value);
50 
51     function name() external pure returns (string memory);
52     function symbol() external pure returns (string memory);
53     function decimals() external pure returns (uint8);
54     function totalSupply() external view returns (uint);
55     function balanceOf(address owner) external view returns (uint);
56     function allowance(address owner, address spender) external view returns (uint);
57 
58     function approve(address spender, uint value) external returns (bool);
59     function transfer(address to, uint value) external returns (bool);
60     function transferFrom(address from, address to, uint value) external returns (bool);
61 
62     function DOMAIN_SEPARATOR() external view returns (bytes32);
63     function PERMIT_TYPEHASH() external pure returns (bytes32);
64     function nonces(address owner) external view returns (uint);
65 
66     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
67 
68     event Mint(address indexed sender, uint amount0, uint amount1);
69     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
70     event Swap(
71         address indexed sender,
72         uint amount0In,
73         uint amount1In,
74         uint amount0Out,
75         uint amount1Out,
76         address indexed to
77     );
78     event Sync(uint112 reserve0, uint112 reserve1);
79 
80     function MINIMUM_LIQUIDITY() external pure returns (uint);
81     function factory() external view returns (address);
82     function token0() external view returns (address);
83     function token1() external view returns (address);
84     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
85     function price0CumulativeLast() external view returns (uint);
86     function price1CumulativeLast() external view returns (uint);
87     function kLast() external view returns (uint);
88 
89     function mint(address to) external returns (uint liquidity);
90     function burn(address to) external returns (uint amount0, uint amount1);
91     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
92     function skim(address to) external;
93     function sync() external;
94 
95     function initialize(address, address) external;
96 }
97 
98 interface IUniswapV2Router01 {
99     function factory() external pure returns (address);
100 
101     function WETH() external pure returns (address);
102 
103     function addLiquidity(
104         address tokenA,
105         address tokenB,
106         uint256 amountADesired,
107         uint256 amountBDesired,
108         uint256 amountAMin,
109         uint256 amountBMin,
110         address to,
111         uint256 deadline
112     )
113         external
114         returns (
115             uint256 amountA,
116             uint256 amountB,
117             uint256 liquidity
118         );
119 
120     function addLiquidityETH(
121         address token,
122         uint256 amountTokenDesired,
123         uint256 amountTokenMin,
124         uint256 amountETHMin,
125         address to,
126         uint256 deadline
127     )
128         external
129         payable
130         returns (
131             uint256 amountToken,
132             uint256 amountETH,
133             uint256 liquidity
134         );
135 
136     function removeLiquidity(
137         address tokenA,
138         address tokenB,
139         uint256 liquidity,
140         uint256 amountAMin,
141         uint256 amountBMin,
142         address to,
143         uint256 deadline
144     ) external returns (uint256 amountA, uint256 amountB);
145 
146     function removeLiquidityETH(
147         address token,
148         uint256 liquidity,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     ) external returns (uint256 amountToken, uint256 amountETH);
154 
155     function removeLiquidityWithPermit(
156         address tokenA,
157         address tokenB,
158         uint256 liquidity,
159         uint256 amountAMin,
160         uint256 amountBMin,
161         address to,
162         uint256 deadline,
163         bool approveMax,
164         uint8 v,
165         bytes32 r,
166         bytes32 s
167     ) external returns (uint256 amountA, uint256 amountB);
168 
169     function removeLiquidityETHWithPermit(
170         address token,
171         uint256 liquidity,
172         uint256 amountTokenMin,
173         uint256 amountETHMin,
174         address to,
175         uint256 deadline,
176         bool approveMax,
177         uint8 v,
178         bytes32 r,
179         bytes32 s
180     ) external returns (uint256 amountToken, uint256 amountETH);
181 
182     function swapExactTokensForTokens(
183         uint256 amountIn,
184         uint256 amountOutMin,
185         address[] calldata path,
186         address to,
187         uint256 deadline
188     ) external returns (uint256[] memory amounts);
189 
190     function swapTokensForExactTokens(
191         uint256 amountOut,
192         uint256 amountInMax,
193         address[] calldata path,
194         address to,
195         uint256 deadline
196     ) external returns (uint256[] memory amounts);
197 
198     function swapExactETHForTokens(
199         uint256 amountOutMin,
200         address[] calldata path,
201         address to,
202         uint256 deadline
203     ) external payable returns (uint256[] memory amounts);
204 
205     function swapTokensForExactETH(
206         uint256 amountOut,
207         uint256 amountInMax,
208         address[] calldata path,
209         address to,
210         uint256 deadline
211     ) external returns (uint256[] memory amounts);
212 
213     function swapExactTokensForETH(
214         uint256 amountIn,
215         uint256 amountOutMin,
216         address[] calldata path,
217         address to,
218         uint256 deadline
219     ) external returns (uint256[] memory amounts);
220 
221     function swapETHForExactTokens(
222         uint256 amountOut,
223         address[] calldata path,
224         address to,
225         uint256 deadline
226     ) external payable returns (uint256[] memory amounts);
227 
228     function quote(
229         uint256 amountA,
230         uint256 reserveA,
231         uint256 reserveB
232     ) external pure returns (uint256 amountB);
233 
234     function getAmountOut(
235         uint256 amountIn,
236         uint256 reserveIn,
237         uint256 reserveOut
238     ) external pure returns (uint256 amountOut);
239 
240     function getAmountIn(
241         uint256 amountOut,
242         uint256 reserveIn,
243         uint256 reserveOut
244     ) external pure returns (uint256 amountIn);
245 
246     function getAmountsOut(uint256 amountIn, address[] calldata path)
247         external
248         view
249         returns (uint256[] memory amounts);
250 
251     function getAmountsIn(uint256 amountOut, address[] calldata path)
252         external
253         view
254         returns (uint256[] memory amounts);
255 }
256 
257 interface IUniswapV2Router02 is IUniswapV2Router01 {
258     function removeLiquidityETHSupportingFeeOnTransferTokens(
259         address token,
260         uint256 liquidity,
261         uint256 amountTokenMin,
262         uint256 amountETHMin,
263         address to,
264         uint256 deadline
265     ) external returns (uint256 amountETH);
266 
267     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
268         address token,
269         uint256 liquidity,
270         uint256 amountTokenMin,
271         uint256 amountETHMin,
272         address to,
273         uint256 deadline,
274         bool approveMax,
275         uint8 v,
276         bytes32 r,
277         bytes32 s
278     ) external returns (uint256 amountETH);
279 
280     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
281         uint256 amountIn,
282         uint256 amountOutMin,
283         address[] calldata path,
284         address to,
285         uint256 deadline
286     ) external;
287 
288     function swapExactETHForTokensSupportingFeeOnTransferTokens(
289         uint256 amountOutMin,
290         address[] calldata path,
291         address to,
292         uint256 deadline
293     ) external payable;
294 
295     function swapExactTokensForETHSupportingFeeOnTransferTokens(
296         uint256 amountIn,
297         uint256 amountOutMin,
298         address[] calldata path,
299         address to,
300         uint256 deadline
301     ) external;
302 }
303 
304 library MerkleProof {
305     /**
306      *@dev The multiproof provided is not valid.
307      */
308     error MerkleProofInvalidMultiproof();
309 
310     /**
311      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
312      * defined by `root`. For this, a `proof` must be provided, containing
313      * sibling hashes on the branch from the leaf to the root of the tree. Each
314      * pair of leaves and each pair of pre-images are assumed to be sorted.
315      */
316     function verify(
317         bytes32[] memory proof,
318         bytes32 root,
319         bytes32 leaf
320     ) internal pure returns (bool) {
321         return processProof(proof, leaf) == root;
322     }
323 
324     /**
325      * @dev Calldata version of {verify}
326      *
327      * _Available since v4.7._
328      */
329     function verifyCalldata(
330         bytes32[] calldata proof,
331         bytes32 root,
332         bytes32 leaf
333     ) internal pure returns (bool) {
334         return processProofCalldata(proof, leaf) == root;
335     }
336 
337     /**
338      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
339      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
340      * hash matches the root of the tree. When processing the proof, the pairs
341      * of leafs & pre-images are assumed to be sorted.
342      *
343      * _Available since v4.4._
344      */
345     function processProof(bytes32[] memory proof, bytes32 leaf)
346         internal
347         pure
348         returns (bytes32)
349     {
350         bytes32 computedHash = leaf;
351         for (uint256 i = 0; i < proof.length; i++) {
352             computedHash = _hashPair(computedHash, proof[i]);
353         }
354         return computedHash;
355     }
356 
357     /**
358      * @dev Calldata version of {processProof}
359      *
360      * _Available since v4.7._
361      */
362     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
363         internal
364         pure
365         returns (bytes32)
366     {
367         bytes32 computedHash = leaf;
368         for (uint256 i = 0; i < proof.length; i++) {
369             computedHash = _hashPair(computedHash, proof[i]);
370         }
371         return computedHash;
372     }
373 
374     /**
375      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
376      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
377      *
378      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
379      *
380      * _Available since v4.7._
381      */
382     function multiProofVerify(
383         bytes32[] memory proof,
384         bool[] memory proofFlags,
385         bytes32 root,
386         bytes32[] memory leaves
387     ) internal pure returns (bool) {
388         return processMultiProof(proof, proofFlags, leaves) == root;
389     }
390 
391     /**
392      * @dev Calldata version of {multiProofVerify}
393      *
394      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
395      *
396      * _Available since v4.7._
397      */
398     function multiProofVerifyCalldata(
399         bytes32[] calldata proof,
400         bool[] calldata proofFlags,
401         bytes32 root,
402         bytes32[] memory leaves
403     ) internal pure returns (bool) {
404         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
405     }
406 
407     /**
408      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
409      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
410      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
411      * respectively.
412      *
413      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
414      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
415      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
416      *
417      * _Available since v4.7._
418      */
419     function processMultiProof(
420         bytes32[] memory proof,
421         bool[] memory proofFlags,
422         bytes32[] memory leaves
423     ) internal pure returns (bytes32 merkleRoot) {
424         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
425         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
426         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
427         // the merkle tree.
428         uint256 leavesLen = leaves.length;
429         uint256 proofLen = proof.length;
430         uint256 totalHashes = proofFlags.length;
431 
432         // Check proof validity.
433         if (leavesLen + proofLen - 1 != totalHashes) {
434             revert MerkleProofInvalidMultiproof();
435         }
436 
437         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
438         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
439         bytes32[] memory hashes = new bytes32[](totalHashes);
440         uint256 leafPos = 0;
441         uint256 hashPos = 0;
442         uint256 proofPos = 0;
443         // At each step, we compute the next hash using two values:
444         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
445         //   get the next hash.
446         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
447         //   `proof` array.
448         for (uint256 i = 0; i < totalHashes; i++) {
449             bytes32 a = leafPos < leavesLen
450                 ? leaves[leafPos++]
451                 : hashes[hashPos++];
452             bytes32 b = proofFlags[i]
453                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
454                 : proof[proofPos++];
455             hashes[i] = _hashPair(a, b);
456         }
457 
458         if (totalHashes > 0) {
459             if (proofPos != proofLen) {
460                 revert MerkleProofInvalidMultiproof();
461             }
462             unchecked {
463                 return hashes[totalHashes - 1];
464             }
465         } else if (leavesLen > 0) {
466             return leaves[0];
467         } else {
468             return proof[0];
469         }
470     }
471 
472     /**
473      * @dev Calldata version of {processMultiProof}.
474      *
475      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
476      *
477      * _Available since v4.7._
478      */
479     function processMultiProofCalldata(
480         bytes32[] calldata proof,
481         bool[] calldata proofFlags,
482         bytes32[] memory leaves
483     ) internal pure returns (bytes32 merkleRoot) {
484         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
485         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
486         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
487         // the merkle tree.
488         uint256 leavesLen = leaves.length;
489         uint256 proofLen = proof.length;
490         uint256 totalHashes = proofFlags.length;
491 
492         // Check proof validity.
493         if (leavesLen + proofLen - 1 != totalHashes) {
494             revert MerkleProofInvalidMultiproof();
495         }
496 
497         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
498         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
499         bytes32[] memory hashes = new bytes32[](totalHashes);
500         uint256 leafPos = 0;
501         uint256 hashPos = 0;
502         uint256 proofPos = 0;
503         // At each step, we compute the next hash using two values:
504         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
505         //   get the next hash.
506         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
507         //   `proof` array.
508         for (uint256 i = 0; i < totalHashes; i++) {
509             bytes32 a = leafPos < leavesLen
510                 ? leaves[leafPos++]
511                 : hashes[hashPos++];
512             bytes32 b = proofFlags[i]
513                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
514                 : proof[proofPos++];
515             hashes[i] = _hashPair(a, b);
516         }
517 
518         if (totalHashes > 0) {
519             if (proofPos != proofLen) {
520                 revert MerkleProofInvalidMultiproof();
521             }
522             unchecked {
523                 return hashes[totalHashes - 1];
524             }
525         } else if (leavesLen > 0) {
526             return leaves[0];
527         } else {
528             return proof[0];
529         }
530     }
531 
532     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
533         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
534     }
535 
536     function _efficientHash(bytes32 a, bytes32 b)
537         private
538         pure
539         returns (bytes32 value)
540     {
541         /// @solidity memory-safe-assembly
542         assembly {
543             mstore(0x00, a)
544             mstore(0x20, b)
545             value := keccak256(0x00, 0x40)
546         }
547     }
548 }
549 
550 interface IERC20 {
551     function transfer(address recipient, uint256 amount) external returns (bool);
552     function balanceOf(address account) external view returns (uint256);
553     function totalSupply() external view returns (uint256);
554     function decimals() external view returns (uint256);
555     function symbol() external view returns (uint256);
556 }
557 
558 contract OxODashboardClaim {
559     IUniswapV2Router02 public router;
560 
561     address public token;
562 
563     address public owner;
564 
565     bool public claimingEnabled;
566 
567     bytes32 public merkleRoot;
568 
569     mapping(address => uint256) public amountClaimed;
570 
571     uint256 public totalEthForRewards;
572     uint256 public lastEthForRewards;
573     uint256 public totalClaimedEth;
574     uint256 public totalRounds;
575     uint256 public lastRewardTime;
576 
577     uint256 year = 365;
578     uint256 public rewardReplenishFrequency = 7;
579 
580     uint256 constant PRECISION = 10**18;
581 
582     // Ineligible holders
583     address[] private ineligibleHolders;
584 
585     error ExceedsClaim();
586     error NotInMerkle();
587     error ClaimingDisabled();
588 
589     constructor() {
590         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
591         token = 0x5a3e6A77ba2f983eC0d371ea3B475F8Bc0811AD5;
592         owner = msg.sender;
593         addIneligibleHolder(0x000000000000000000000000000000000000dEaD);
594         addIneligibleHolder(0x9Ec9367b8c4Dd45ec8E7b800b1F719251053AD60);
595         addIneligibleHolder(0x5a3e6A77ba2f983eC0d371ea3B475F8Bc0811AD5);
596         addIneligibleHolder(0x0E7619cCcfa3E181898E3b885A2527968953cf4B);
597         addIneligibleHolder(0x120051a72966950B8ce12eB5496B5D1eEEC1541B);
598         addIneligibleHolder(0x5bdf85216ec1e38D6458C870992A69e38e03F7Ef);
599     }
600    
601 
602     event Claim(
603         address indexed to,
604         uint256 amount,
605         uint256 amountClaimed
606     );
607 
608     modifier onlyOwner() {
609         require(owner == msg.sender, "Ownable: caller is not the owner");
610         _;
611     }
612     
613     function processClaim(
614         address to,
615         uint256 amount,
616         bytes32[] calldata proof,
617         uint256 claimAmount
618     ) internal {
619         // Throw if address tries to claim too many tokens
620         if (amountClaimed[to] + claimAmount > amount)
621             revert ExceedsClaim();
622         if(!claimingEnabled)
623             revert ClaimingDisabled();
624 
625         // Verify merkle proof, or revert if not in tree
626         bytes32 leaf = keccak256(abi.encodePacked(to, amount));
627         bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
628         if (!isValidLeaf) revert NotInMerkle();
629 
630         // Track ETH claimed
631         amountClaimed[to] += claimAmount;
632         totalClaimedEth += claimAmount;
633     }
634 
635     function claimTokens(
636         uint256 amount,
637         bytes32[] calldata proof,
638         uint256 claimAmount,
639         uint256 minAmount
640     ) external {
641 
642         address to = msg.sender;
643 
644         // Check if the claimer is not an ineligible holder
645         require(!isIneligibleHolder(to), "Claimer is ineligible.");
646 
647         processClaim(to, amount, proof, claimAmount);
648 
649         swapEthForTokens(claimAmount, to, minAmount);
650 
651         // Emit claim event
652         emit Claim(to, amount, claimAmount);
653     }
654 
655     function claimEth(
656         uint256 amount,
657         bytes32[] calldata proof,
658         uint256 claimAmount
659     ) external returns (bool success) {
660 
661         address to = msg.sender;
662 
663         // Check if the claimer is not an ineligible holder
664         require(!isIneligibleHolder(to), "Claimer is ineligible.");
665 
666         processClaim(to, amount, proof, claimAmount);
667 
668         // Send ETH to address
669         (success, ) = to.call{value: claimAmount}("");
670 
671         // Emit claim event
672         emit Claim(to, amount, claimAmount);
673     }
674 
675     function swapEthForTokens(uint256 ethAmount, address to, uint256 minAmount) internal {
676 
677         address[] memory path = new address[](2);
678         path[0] = router.WETH();
679         path[1] = token;
680 
681         // make the swap
682         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
683             value: ethAmount
684         }(
685             minAmount,
686             path,
687             to,
688             block.timestamp
689         );
690     }
691 
692     function getAmountOut(uint256 ethIn) external view returns(uint256){
693         (uint256 reserveA, uint256 reserveB,) = IUniswapV2Pair(IUniswapV2Factory(router.factory()).getPair(token, router.WETH())).getReserves();
694 
695         return router.getAmountOut(ethIn, reserveB, reserveA);
696     }
697 
698     function toggleClaiming() external onlyOwner {
699         claimingEnabled = !claimingEnabled;
700     }
701 
702     function transferOwnership(address _newOwner) external onlyOwner {
703         owner = _newOwner;
704     }
705 
706     function newRoot(bytes32 root) public payable onlyOwner {
707         require(msg.value > 0, "Must send some ETH with the newRoot function.");
708 
709         totalEthForRewards += msg.value;
710         lastEthForRewards = msg.value;
711         rewardReplenishFrequency = (block.timestamp - lastRewardTime) / (60 * 60 * 24);
712 
713         // Check if rewardReplenishFrequency is 0, set it to 1
714         if (rewardReplenishFrequency == 0) {
715             rewardReplenishFrequency = 1;
716         }
717 
718         merkleRoot = root;
719         lastRewardTime = block.timestamp;
720         totalRounds++; // Increment the totalRounds counter
721     }
722 
723     function withdrawETH(uint256 _amount, address payable _to) external onlyOwner {
724         require(_to != address(0), "Zero address is invalid.");
725         require(_amount > 0, "Amount must be greater than zero.");
726         require(address(this).balance >= _amount, "Not enough ETH!");
727         
728         // totalEthForRewards -= _amount;
729 
730         (bool success, ) = _to.call{value: _amount}("");
731         require(success, "Transfer failed!");
732     }
733 
734     function withdrawToken(uint256 _amount, address _to, address _token) external onlyOwner {
735         require(_to != address(0), "Zero address is invalid.");
736         require(_amount > 0, "Amount must be greater than zero.");
737         require(_amount <= IERC20(_token).balanceOf(address(this)), "Not enough tokens!");
738 
739         bool success = IERC20(_token).transfer(msg.sender, _amount);
740         require(success, "Transfer failed!");
741     }
742 
743     // Calculate the adjusted token supply without decimals
744     function calculateAdjustedTokenSupply() public view returns (uint256 adjustedSupplyWithNoDecimals) {
745         adjustedSupplyWithNoDecimals = IERC20(token).totalSupply();
746 
747         // Subtract the token balance of each ineligible holder from the total supply
748         for (uint256 i = 0; i < ineligibleHolders.length; i++) {
749             uint256 removeFromSupply = IERC20(token).balanceOf(ineligibleHolders[i]);
750             adjustedSupplyWithNoDecimals -= removeFromSupply;
751         }
752 
753         // Adjust for decimals
754         adjustedSupplyWithNoDecimals = adjustedSupplyWithNoDecimals / (10**IERC20(token).decimals());
755 
756         return adjustedSupplyWithNoDecimals;
757     }
758 
759     // Calculate the price of 1 token in terms of WETH (output in Wei)
760     function calculateTokenPriceInWETH() public view returns (uint256 tokenPriceInWei) {
761         address[] memory path = new address[](2);
762         path[0] = token;
763         path[1] = router.WETH();
764 
765         // Get the amounts out for 1 unit of the token in terms of WETH
766         uint256[] memory amountsOut = router.getAmountsOut(1e9, path);
767 
768         // Ensure that the token is the output token in the path
769         require(amountsOut.length > 0 && amountsOut[amountsOut.length - 1] > 0, "Invalid output token");
770 
771         tokenPriceInWei = amountsOut[amountsOut.length - 1];
772         return (tokenPriceInWei);
773     }
774 
775     // Calculate the reward of 1 token (without decimals) in terms of WETH (output in Wei)
776     function calculateRewardPerTokenInWETH() public view returns (uint256 rewardPerTokenInWei) {
777 
778         uint256 adjustedSupply = calculateAdjustedTokenSupply();
779 
780         // Get reward of 1 token
781         rewardPerTokenInWei = totalEthForRewards / totalRounds / adjustedSupply;
782 
783         return (rewardPerTokenInWei);
784     }
785 
786     // Calculate the rewards in terms of WETH
787     // How much ETH will I receive if I hold `tokenAmount` number of tokens?
788     function calculateRewardsInWETH(uint256 tokenAmount) public view returns (uint256 rewardsInWei) {
789         uint256 rewardPerTokenInWETH = calculateRewardPerTokenInWETH();
790 
791         // Calculate the rewards in WETH (output in Wei) 
792         rewardsInWei = rewardPerTokenInWETH * tokenAmount; // tokenAmount with no decimals
793     }
794 
795     // Calculate the holder rewards in terms of WETH
796     function calculateHolderRewardsInWETH(address holderAddress) public view returns (uint256 holderRewardsInWei) {
797         uint256 rewardPerTokenInWETH = calculateRewardPerTokenInWETH();
798 
799         // Calculate holder rewards in WETH (output in Wei)
800         holderRewardsInWei = rewardPerTokenInWETH * IERC20(token).balanceOf(holderAddress) / (10**IERC20(token).decimals()); // tokenAmount with no decimals
801     }
802 
803     // Calculate APR and APY
804     /* 
805         Formula:
806             uint256 rewardPerTokenInWETH = calculateRewardPerTokenInWETH();
807             uint256 tokenPriceInWETH = calculateTokenPriceInWETH();
808         
809             uint256 r = rewardPerTokenInWETH / tokenPriceInWETH;
810             uint256 n = year / rewardReplenishFrequency;
811 
812             // Calculate APR
813             APR = r * n;
814 
815             // Calculate APY
816             APY = ((1 + (r / n))**n) - 1;
817     */
818     function calculateRAndN() public view returns (uint256 r, uint256 n) {
819         uint256 rewardPerTokenInWETH = calculateRewardPerTokenInWETH();
820         uint256 tokenPriceInWETH = calculateTokenPriceInWETH();
821 
822         r = (rewardPerTokenInWETH * PRECISION) / tokenPriceInWETH;
823         n = year / rewardReplenishFrequency;
824 
825         return (r, n);
826     }
827 
828     function calculateAPYAndAPR() public view returns (uint256 APR, uint256 APY) {
829         uint256 r;
830         uint256 n;
831         (r, n) = calculateRAndN();
832 
833         // Calculate APR (precision in Wei, i.e., 18 decimals)
834         APR = r * n;
835 
836         // Calculate APY iteratively (precision in Wei, i.e., 18 decimals)
837         uint256 tempAPY = PRECISION;
838         for (uint256 i = 0; i < n; i++) {
839             tempAPY = (tempAPY * (r + PRECISION)) / PRECISION;
840         }
841         APY = tempAPY - PRECISION;
842     }
843 
844     // Calculate custom volume
845     // How much ETH will I receive if I hold `tokenAmount` number of tokens 
846     // if `ethReplenishedForRewardsInWei` amount of ETH is added 
847     // every `ethReplenishedFrequencyInDays` and what's the APY and APR?
848     function calculateCustomVolume(
849         uint256 tokenAmount, 
850         uint256 ethReplenishedForRewardsInWei, 
851         uint256 ethReplenishedFrequencyInDays
852         ) public view returns (
853         uint256 yourEthRewardsInWei,
854         uint256 r,
855         uint256 n,
856         uint256 APR, 
857         uint256 APY
858         ) {
859         
860         uint256 adjustedSupply = calculateAdjustedTokenSupply();
861         uint256 tokenPriceInWETH = calculateTokenPriceInWETH();
862         uint256 rewardPerTokenInWETH = ethReplenishedForRewardsInWei / adjustedSupply;
863 
864         r = (rewardPerTokenInWETH * PRECISION) / tokenPriceInWETH;
865         n = year / ethReplenishedFrequencyInDays;
866 
867         // Calculate the rewards in terms of WETH (output in Wei)
868         yourEthRewardsInWei = rewardPerTokenInWETH * tokenAmount; // tokenAmount with no decimals
869 
870         // Calculate APR (precision in Wei, i.e., 18 decimals)
871         APR = r * n;
872 
873         // Calculate APY iteratively (precision in Wei, i.e., 18 decimals)
874         uint256 tempAPY = PRECISION;
875         for (uint256 i = 0; i < n; i++) {
876             tempAPY = (tempAPY * (r + PRECISION)) / PRECISION;
877         }
878         APY = tempAPY - PRECISION;
879     }
880 
881     function updateRewardReplenishFrequency(uint256 _rewardReplenishFrequency) public onlyOwner {
882         rewardReplenishFrequency =  _rewardReplenishFrequency;
883     }
884 
885     function updateTotalRounds(uint256 _totalRounds) public onlyOwner {
886         totalRounds =  _totalRounds;
887     }
888 
889     function updateTotalEthForRewards(uint256 _totalEthForRewards) public onlyOwner {
890         totalEthForRewards =  _totalEthForRewards;
891     }
892 
893     function updateToken(address _token) public onlyOwner {
894         token = _token;
895     }
896 
897     function updateRouter(address _router) public onlyOwner {
898         router = IUniswapV2Router02(_router);
899     }
900 
901     function addIneligibleHolder(address user) public onlyOwner {
902       ineligibleHolders.push(user);
903     }
904     
905     function removeIneligibleHolder(address user) public onlyOwner {
906       uint256 len = ineligibleHolders.length;
907       for(uint i; i < len; i++) {
908         if(ineligibleHolders[i] == user) {
909           ineligibleHolders[i] = ineligibleHolders[len - 1];
910           ineligibleHolders.pop();
911           break;
912         }
913       }
914     }
915 
916     // Function to check if an address is an ineligible holder
917     function isIneligibleHolder(address user) public view returns (bool) {
918         for (uint256 i = 0; i < ineligibleHolders.length; i++) {
919             if (ineligibleHolders[i] == user) {
920                 return true;
921             }
922         }
923         return false;
924     }
925 
926     // Function to allow setting the claimed amount for addresses
927     function setAmountClaimed(address _address, uint256 _amount) public onlyOwner {
928         require(!isIneligibleHolder(_address), "Address is ineligible");
929         amountClaimed[_address] = _amount;
930     }
931 
932     function setAmountClaimedBatch(address[] calldata addresses, uint256[] calldata amounts) public onlyOwner {
933         require(addresses.length == amounts.length, "Arrays must have the same length");
934 
935         for (uint256 i = 0; i < addresses.length; i++) {
936             address _address = addresses[i];
937             uint256 _amount = amounts[i];
938 
939             require(!isIneligibleHolder(_address), "Address is ineligible");
940             amountClaimed[_address] = _amount;
941         }
942     }
943 
944 }