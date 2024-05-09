1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-24
3 */
4 
5 /**
6 
7                                                                                                     
8         ((((((((   .(((("/(((       (((((,                 .((((/        /(((((((   *((((((((       
9      ,/(((((((((   .(((("//(((/*    (((((((,             (((((((/     ./(((((((((   /((((((((((*    
10     ((((((                 ((((**       ((((((.       *((((((       .(((((                  /((((   
11     (((/((                 (((((*          .#####   ,##((           ,(/(((                 ./"/"/   
12     ((((((                 (((((/             *#####((              .((((/                 .////(   
13     ((((((                 (((((*             ,((####(              .(((((                 ./((/(   
14     ((((((                 (((((*             ,((((###/             ./((((                 .((((/   
15     ((((((                 (((/(*           "//(((((/(#(/           .(###(                 .((((/   
16     *(((((                 (((((/          *####...*"/###           .(####                 ./((((   
17     (((((/                 ###((/       (####.          (###(       ,((#((                  (((#(   
18      "/((######(    ((#######/*,    (((##( .             . *#((((     .,(((((((#(   ,((##((((((*    
19         (######(    (#######(       (#(#(*                 .(((((        ((((((##   *(#((##((*      
20                                                                                                     
21 
22 */
23 
24 
25 // SPDX-License-Identifier: MIT
26 pragma solidity >=0.8.0;
27 
28 interface IUniswapV2Factory {
29     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
30 
31     function feeTo() external view returns (address);
32     function feeToSetter() external view returns (address);
33 
34     function getPair(address tokenA, address tokenB) external view returns (address pair);
35     function allPairs(uint) external view returns (address pair);
36     function allPairsLength() external view returns (uint);
37 
38     function createPair(address tokenA, address tokenB) external returns (address pair);
39 
40     function setFeeTo(address) external;
41     function setFeeToSetter(address) external;
42 }
43 
44 interface IUniswapV2Pair {
45     event Approval(address indexed owner, address indexed spender, uint value);
46     event Transfer(address indexed from, address indexed to, uint value);
47 
48     function name() external pure returns (string memory);
49     function symbol() external pure returns (string memory);
50     function decimals() external pure returns (uint8);
51     function totalSupply() external view returns (uint);
52     function balanceOf(address owner) external view returns (uint);
53     function allowance(address owner, address spender) external view returns (uint);
54 
55     function approve(address spender, uint value) external returns (bool);
56     function transfer(address to, uint value) external returns (bool);
57     function transferFrom(address from, address to, uint value) external returns (bool);
58 
59     function DOMAIN_SEPARATOR() external view returns (bytes32);
60     function PERMIT_TYPEHASH() external pure returns (bytes32);
61     function nonces(address owner) external view returns (uint);
62 
63     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
64 
65     event Mint(address indexed sender, uint amount0, uint amount1);
66     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
67     event Swap(
68         address indexed sender,
69         uint amount0In,
70         uint amount1In,
71         uint amount0Out,
72         uint amount1Out,
73         address indexed to
74     );
75     event Sync(uint112 reserve0, uint112 reserve1);
76 
77     function MINIMUM_LIQUIDITY() external pure returns (uint);
78     function factory() external view returns (address);
79     function token0() external view returns (address);
80     function token1() external view returns (address);
81     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
82     function price0CumulativeLast() external view returns (uint);
83     function price1CumulativeLast() external view returns (uint);
84     function kLast() external view returns (uint);
85 
86     function mint(address to) external returns (uint liquidity);
87     function burn(address to) external returns (uint amount0, uint amount1);
88     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
89     function skim(address to) external;
90     function sync() external;
91 
92     function initialize(address, address) external;
93 }
94 
95 interface IUniswapV2Router01 {
96     function factory() external pure returns (address);
97 
98     function WETH() external pure returns (address);
99 
100     function addLiquidity(
101         address tokenA,
102         address tokenB,
103         uint256 amountADesired,
104         uint256 amountBDesired,
105         uint256 amountAMin,
106         uint256 amountBMin,
107         address to,
108         uint256 deadline
109     )
110         external
111         returns (
112             uint256 amountA,
113             uint256 amountB,
114             uint256 liquidity
115         );
116 
117     function addLiquidityETH(
118         address token,
119         uint256 amountTokenDesired,
120         uint256 amountTokenMin,
121         uint256 amountETHMin,
122         address to,
123         uint256 deadline
124     )
125         external
126         payable
127         returns (
128             uint256 amountToken,
129             uint256 amountETH,
130             uint256 liquidity
131         );
132 
133     function removeLiquidity(
134         address tokenA,
135         address tokenB,
136         uint256 liquidity,
137         uint256 amountAMin,
138         uint256 amountBMin,
139         address to,
140         uint256 deadline
141     ) external returns (uint256 amountA, uint256 amountB);
142 
143     function removeLiquidityETH(
144         address token,
145         uint256 liquidity,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     ) external returns (uint256 amountToken, uint256 amountETH);
151 
152     function removeLiquidityWithPermit(
153         address tokenA,
154         address tokenB,
155         uint256 liquidity,
156         uint256 amountAMin,
157         uint256 amountBMin,
158         address to,
159         uint256 deadline,
160         bool approveMax,
161         uint8 v,
162         bytes32 r,
163         bytes32 s
164     ) external returns (uint256 amountA, uint256 amountB);
165 
166     function removeLiquidityETHWithPermit(
167         address token,
168         uint256 liquidity,
169         uint256 amountTokenMin,
170         uint256 amountETHMin,
171         address to,
172         uint256 deadline,
173         bool approveMax,
174         uint8 v,
175         bytes32 r,
176         bytes32 s
177     ) external returns (uint256 amountToken, uint256 amountETH);
178 
179     function swapExactTokensForTokens(
180         uint256 amountIn,
181         uint256 amountOutMin,
182         address[] calldata path,
183         address to,
184         uint256 deadline
185     ) external returns (uint256[] memory amounts);
186 
187     function swapTokensForExactTokens(
188         uint256 amountOut,
189         uint256 amountInMax,
190         address[] calldata path,
191         address to,
192         uint256 deadline
193     ) external returns (uint256[] memory amounts);
194 
195     function swapExactETHForTokens(
196         uint256 amountOutMin,
197         address[] calldata path,
198         address to,
199         uint256 deadline
200     ) external payable returns (uint256[] memory amounts);
201 
202     function swapTokensForExactETH(
203         uint256 amountOut,
204         uint256 amountInMax,
205         address[] calldata path,
206         address to,
207         uint256 deadline
208     ) external returns (uint256[] memory amounts);
209 
210     function swapExactTokensForETH(
211         uint256 amountIn,
212         uint256 amountOutMin,
213         address[] calldata path,
214         address to,
215         uint256 deadline
216     ) external returns (uint256[] memory amounts);
217 
218     function swapETHForExactTokens(
219         uint256 amountOut,
220         address[] calldata path,
221         address to,
222         uint256 deadline
223     ) external payable returns (uint256[] memory amounts);
224 
225     function quote(
226         uint256 amountA,
227         uint256 reserveA,
228         uint256 reserveB
229     ) external pure returns (uint256 amountB);
230 
231     function getAmountOut(
232         uint256 amountIn,
233         uint256 reserveIn,
234         uint256 reserveOut
235     ) external pure returns (uint256 amountOut);
236 
237     function getAmountIn(
238         uint256 amountOut,
239         uint256 reserveIn,
240         uint256 reserveOut
241     ) external pure returns (uint256 amountIn);
242 
243     function getAmountsOut(uint256 amountIn, address[] calldata path)
244         external
245         view
246         returns (uint256[] memory amounts);
247 
248     function getAmountsIn(uint256 amountOut, address[] calldata path)
249         external
250         view
251         returns (uint256[] memory amounts);
252 }
253 
254 interface IUniswapV2Router02 is IUniswapV2Router01 {
255     function removeLiquidityETHSupportingFeeOnTransferTokens(
256         address token,
257         uint256 liquidity,
258         uint256 amountTokenMin,
259         uint256 amountETHMin,
260         address to,
261         uint256 deadline
262     ) external returns (uint256 amountETH);
263 
264     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
265         address token,
266         uint256 liquidity,
267         uint256 amountTokenMin,
268         uint256 amountETHMin,
269         address to,
270         uint256 deadline,
271         bool approveMax,
272         uint8 v,
273         bytes32 r,
274         bytes32 s
275     ) external returns (uint256 amountETH);
276 
277     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
278         uint256 amountIn,
279         uint256 amountOutMin,
280         address[] calldata path,
281         address to,
282         uint256 deadline
283     ) external;
284 
285     function swapExactETHForTokensSupportingFeeOnTransferTokens(
286         uint256 amountOutMin,
287         address[] calldata path,
288         address to,
289         uint256 deadline
290     ) external payable;
291 
292     function swapExactTokensForETHSupportingFeeOnTransferTokens(
293         uint256 amountIn,
294         uint256 amountOutMin,
295         address[] calldata path,
296         address to,
297         uint256 deadline
298     ) external;
299 }
300 
301 library MerkleProof {
302     /**
303      *@dev The multiproof provided is not valid.
304      */
305     error MerkleProofInvalidMultiproof();
306 
307     /**
308      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
309      * defined by `root`. For this, a `proof` must be provided, containing
310      * sibling hashes on the branch from the leaf to the root of the tree. Each
311      * pair of leaves and each pair of pre-images are assumed to be sorted.
312      */
313     function verify(
314         bytes32[] memory proof,
315         bytes32 root,
316         bytes32 leaf
317     ) internal pure returns (bool) {
318         return processProof(proof, leaf) == root;
319     }
320 
321     /**
322      * @dev Calldata version of {verify}
323      *
324      * _Available since v4.7._
325      */
326     function verifyCalldata(
327         bytes32[] calldata proof,
328         bytes32 root,
329         bytes32 leaf
330     ) internal pure returns (bool) {
331         return processProofCalldata(proof, leaf) == root;
332     }
333 
334     /**
335      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
336      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
337      * hash matches the root of the tree. When processing the proof, the pairs
338      * of leafs & pre-images are assumed to be sorted.
339      *
340      * _Available since v4.4._
341      */
342     function processProof(bytes32[] memory proof, bytes32 leaf)
343         internal
344         pure
345         returns (bytes32)
346     {
347         bytes32 computedHash = leaf;
348         for (uint256 i = 0; i < proof.length; i++) {
349             computedHash = _hashPair(computedHash, proof[i]);
350         }
351         return computedHash;
352     }
353 
354     /**
355      * @dev Calldata version of {processProof}
356      *
357      * _Available since v4.7._
358      */
359     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
360         internal
361         pure
362         returns (bytes32)
363     {
364         bytes32 computedHash = leaf;
365         for (uint256 i = 0; i < proof.length; i++) {
366             computedHash = _hashPair(computedHash, proof[i]);
367         }
368         return computedHash;
369     }
370 
371     /**
372      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
373      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
374      *
375      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
376      *
377      * _Available since v4.7._
378      */
379     function multiProofVerify(
380         bytes32[] memory proof,
381         bool[] memory proofFlags,
382         bytes32 root,
383         bytes32[] memory leaves
384     ) internal pure returns (bool) {
385         return processMultiProof(proof, proofFlags, leaves) == root;
386     }
387 
388     /**
389      * @dev Calldata version of {multiProofVerify}
390      *
391      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
392      *
393      * _Available since v4.7._
394      */
395     function multiProofVerifyCalldata(
396         bytes32[] calldata proof,
397         bool[] calldata proofFlags,
398         bytes32 root,
399         bytes32[] memory leaves
400     ) internal pure returns (bool) {
401         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
402     }
403 
404     /**
405      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
406      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
407      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
408      * respectively.
409      *
410      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
411      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
412      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
413      *
414      * _Available since v4.7._
415      */
416     function processMultiProof(
417         bytes32[] memory proof,
418         bool[] memory proofFlags,
419         bytes32[] memory leaves
420     ) internal pure returns (bytes32 merkleRoot) {
421         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
422         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
423         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
424         // the merkle tree.
425         uint256 leavesLen = leaves.length;
426         uint256 proofLen = proof.length;
427         uint256 totalHashes = proofFlags.length;
428 
429         // Check proof validity.
430         if (leavesLen + proofLen - 1 != totalHashes) {
431             revert MerkleProofInvalidMultiproof();
432         }
433 
434         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
435         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
436         bytes32[] memory hashes = new bytes32[](totalHashes);
437         uint256 leafPos = 0;
438         uint256 hashPos = 0;
439         uint256 proofPos = 0;
440         // At each step, we compute the next hash using two values:
441         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
442         //   get the next hash.
443         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
444         //   `proof` array.
445         for (uint256 i = 0; i < totalHashes; i++) {
446             bytes32 a = leafPos < leavesLen
447                 ? leaves[leafPos++]
448                 : hashes[hashPos++];
449             bytes32 b = proofFlags[i]
450                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
451                 : proof[proofPos++];
452             hashes[i] = _hashPair(a, b);
453         }
454 
455         if (totalHashes > 0) {
456             if (proofPos != proofLen) {
457                 revert MerkleProofInvalidMultiproof();
458             }
459             unchecked {
460                 return hashes[totalHashes - 1];
461             }
462         } else if (leavesLen > 0) {
463             return leaves[0];
464         } else {
465             return proof[0];
466         }
467     }
468 
469     /**
470      * @dev Calldata version of {processMultiProof}.
471      *
472      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
473      *
474      * _Available since v4.7._
475      */
476     function processMultiProofCalldata(
477         bytes32[] calldata proof,
478         bool[] calldata proofFlags,
479         bytes32[] memory leaves
480     ) internal pure returns (bytes32 merkleRoot) {
481         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
482         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
483         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
484         // the merkle tree.
485         uint256 leavesLen = leaves.length;
486         uint256 proofLen = proof.length;
487         uint256 totalHashes = proofFlags.length;
488 
489         // Check proof validity.
490         if (leavesLen + proofLen - 1 != totalHashes) {
491             revert MerkleProofInvalidMultiproof();
492         }
493 
494         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
495         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
496         bytes32[] memory hashes = new bytes32[](totalHashes);
497         uint256 leafPos = 0;
498         uint256 hashPos = 0;
499         uint256 proofPos = 0;
500         // At each step, we compute the next hash using two values:
501         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
502         //   get the next hash.
503         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
504         //   `proof` array.
505         for (uint256 i = 0; i < totalHashes; i++) {
506             bytes32 a = leafPos < leavesLen
507                 ? leaves[leafPos++]
508                 : hashes[hashPos++];
509             bytes32 b = proofFlags[i]
510                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
511                 : proof[proofPos++];
512             hashes[i] = _hashPair(a, b);
513         }
514 
515         if (totalHashes > 0) {
516             if (proofPos != proofLen) {
517                 revert MerkleProofInvalidMultiproof();
518             }
519             unchecked {
520                 return hashes[totalHashes - 1];
521             }
522         } else if (leavesLen > 0) {
523             return leaves[0];
524         } else {
525             return proof[0];
526         }
527     }
528 
529     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
530         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
531     }
532 
533     function _efficientHash(bytes32 a, bytes32 b)
534         private
535         pure
536         returns (bytes32 value)
537     {
538         /// @solidity memory-safe-assembly
539         assembly {
540             mstore(0x00, a)
541             mstore(0x20, b)
542             value := keccak256(0x00, 0x40)
543         }
544     }
545 }
546 
547 interface IERC20 {
548     function transfer(address recipient, uint256 amount) external returns (bool);
549     function balanceOf(address account) external view returns (uint256);
550     function totalSupply() external view returns (uint256);
551 }
552 
553 contract OxODashboardClaim {
554     IUniswapV2Router02 public router;
555 
556     address public token;
557 
558     address public owner;
559 
560     bool public claimingEnabled;
561 
562     bytes32 public merkleRoot;
563 
564     mapping(address => uint256) public amountClaimed;
565 
566     uint256 public totalEthForRewards;
567     uint256 public totalClaimedEth;
568     uint256 public totalRounds;
569     uint256 public lastRewardTime;
570 
571     uint256 year = 365;
572     uint256 public rewardReplenishFrequency = 7;
573 
574     // Ineligible holders
575     address[] public ineligibleHolders;
576 
577     error ExceedsClaim();
578     error NotInMerkle();
579     error ClaimingDisabled();
580 
581     constructor() {
582         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
583         token = 0x5a3e6A77ba2f983eC0d371ea3B475F8Bc0811AD5;
584         owner = msg.sender;
585         addIneligibleHolder(0x000000000000000000000000000000000000dEaD);
586         addIneligibleHolder(0x9Ec9367b8c4Dd45ec8E7b800b1F719251053AD60);
587         addIneligibleHolder(0x5a3e6A77ba2f983eC0d371ea3B475F8Bc0811AD5);
588         addIneligibleHolder(0x0E7619cCcfa3E181898E3b885A2527968953cf4B);
589         addIneligibleHolder(0x120051a72966950B8ce12eB5496B5D1eEEC1541B);
590         addIneligibleHolder(0x5bdf85216ec1e38D6458C870992A69e38e03F7Ef);
591     }
592    
593 
594     event Claim(
595         address indexed to,
596         uint256 amount,
597         uint256 amountClaimed
598     );
599 
600     modifier onlyOwner() {
601         require(owner == msg.sender, "Ownable: caller is not the owner");
602         _;
603     }
604     
605     function processClaim(
606         address to,
607         uint256 amount,
608         bytes32[] calldata proof,
609         uint256 claimAmount
610     ) internal {
611         // Throw if address tries to claim too many tokens
612         if (amountClaimed[to] + claimAmount > amount)
613             revert ExceedsClaim();
614         if(!claimingEnabled)
615             revert ClaimingDisabled();
616 
617         // Verify merkle proof, or revert if not in tree
618         bytes32 leaf = keccak256(abi.encodePacked(to, amount));
619         bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
620         if (!isValidLeaf) revert NotInMerkle();
621 
622         // Track ETH claimed
623         amountClaimed[to] += claimAmount;
624         totalClaimedEth += claimAmount;
625     }
626 
627     function claimTokens(
628         uint256 amount,
629         bytes32[] calldata proof,
630         uint256 claimAmount,
631         uint256 minAmount
632     ) external {
633 
634         address to = msg.sender;
635 
636         processClaim(to, amount, proof, claimAmount);
637 
638         swapEthForTokens(claimAmount, to, minAmount);
639 
640         // Emit claim event
641         emit Claim(to, amount, claimAmount);
642     }
643 
644     function claimEth(
645         uint256 amount,
646         bytes32[] calldata proof,
647         uint256 claimAmount
648     ) external returns (bool success) {
649 
650         address to = msg.sender;
651 
652         processClaim(to, amount, proof, claimAmount);
653 
654         // Send ETH to address
655         (success, ) = to.call{value: claimAmount}("");
656 
657         // Emit claim event
658         emit Claim(to, amount, claimAmount);
659     }
660 
661     function swapEthForTokens(uint256 ethAmount, address to, uint256 minAmount) internal {
662 
663         address[] memory path = new address[](2);
664         path[0] = router.WETH();
665         path[1] = token;
666 
667         // make the swap
668         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
669             value: ethAmount
670         }(
671             minAmount,
672             path,
673             to,
674             block.timestamp
675         );
676     }
677 
678     function getAmountOut(uint256 ethIn) external view returns(uint256){
679         (uint256 reserveA, uint256 reserveB,) = IUniswapV2Pair(IUniswapV2Factory(router.factory()).getPair(token, router.WETH())).getReserves();
680 
681         return router.getAmountOut(ethIn, reserveB, reserveA);
682     }
683 
684     function toggleClaiming() external onlyOwner {
685         claimingEnabled = !claimingEnabled;
686     }
687 
688     function transferOwnership(address _newOwner) external onlyOwner {
689         owner = _newOwner;
690     }
691 
692     function newRoot(bytes32 root) public payable onlyOwner {
693         require(msg.value > 0, "Must send some ETH with the newRoot function.");
694 
695         totalEthForRewards += msg.value;
696         rewardReplenishFrequency = (block.timestamp - lastRewardTime) / (60 * 60 * 24);
697         merkleRoot = root;
698         lastRewardTime = block.timestamp;
699         totalRounds++; // Increment the totalRounds counter
700     }
701 
702     function withdrawETH(uint256 _amount, address payable _to) external onlyOwner {
703         require(_to != address(0), "Zero address is invalid.");
704         require(_amount > 0, "Amount must be greater than zero.");
705         require(address(this).balance >= _amount, "Not enough ETH!");
706         
707         totalEthForRewards -= _amount;
708 
709         (bool success, ) = _to.call{value: _amount}("");
710         require(success, "Transfer failed!");
711     }
712 
713     function withdrawToken(uint256 _amount, address _to, address _token) external onlyOwner {
714         require(_to != address(0), "Zero address is invalid.");
715         require(_amount > 0, "Amount must be greater than zero.");
716         require(_amount <= IERC20(_token).balanceOf(address(this)), "Not enough tokens!");
717 
718         bool success = IERC20(_token).transfer(msg.sender, _amount);
719         require(success, "Transfer failed!");
720     }
721 
722     // Calculate the adjusted token supply
723     function calculateAdjustedTokenSupply() public view returns (uint256 adjustedSupply) {
724         adjustedSupply = IERC20(token).totalSupply();
725 
726         // Subtract the token balance of each ineligible holder from the total supply
727         for (uint256 i = 0; i < ineligibleHolders.length; i++) {
728             adjustedSupply -= IERC20(token).balanceOf(ineligibleHolders[i]);
729         }
730 
731         return adjustedSupply;
732     }
733 
734     // Calculate the price of 1 token in terms of WETH
735     function calculateTokenPriceInWETH() public view returns (uint256 tokenPriceInWETH) {
736         address[] memory path = new address[](2);
737         path[0] = token;
738         path[1] = router.WETH();
739 
740         // Get the amounts out for 1 unit of the token in terms of WETH
741         uint256[] memory amountsOut = router.getAmountsOut(1e9, path);
742 
743         // Ensure that the token is the output token in the path
744         require(amountsOut.length > 0 && amountsOut[amountsOut.length - 1] > 0, "Invalid output token");
745 
746         tokenPriceInWETH = amountsOut[amountsOut.length - 1];
747         return (tokenPriceInWETH);
748     }
749 
750     // Calculate the reward of 1 token in terms of WETH
751     function calculateRewardPerToken() public view returns (uint256 rewardPerToken) {
752 
753         uint256 adjustedSupply = calculateAdjustedTokenSupply();
754 
755         // Get reward of 1 token
756         rewardPerToken = totalEthForRewards / totalRounds / adjustedSupply;
757         /* 
758         Formula:
759             uint256 r = rewardPerToken / tokenPriceInWETH;
760             uint256 n = year / rewardReplenishFrequency;
761             APR = r * n
762             APY = (1+r/n)n - 1
763         */
764 
765         return (rewardPerToken);
766     }
767 
768     // Calculate the holder rewards
769     function calculateHolderRewards(address holder) public view returns (uint256 holderRewards) {
770         uint256 rewardPerToken = calculateRewardPerToken();
771         holderRewards = rewardPerToken * IERC20(token).balanceOf(holder) ** 1e9; // Calculate holderRewards in ETH
772     }
773 
774     function updateRewardReplenishFrequency(uint256 _rewardReplenishFrequency) public onlyOwner {
775         rewardReplenishFrequency =  _rewardReplenishFrequency;
776     }
777 
778     function updateTotalRounds(uint256 _totalRounds) public onlyOwner {
779         totalRounds =  _totalRounds;
780     }
781 
782     function addIneligibleHolder(address user) public onlyOwner {
783       ineligibleHolders.push(user);
784     }
785     
786     function removedIneligibleHolder(address user) public onlyOwner {
787       uint256 len = ineligibleHolders.length;
788       for(uint i; i < len; i++) {
789         if(ineligibleHolders[i] == user) {
790           ineligibleHolders[i] = ineligibleHolders[len - 1];
791           ineligibleHolders.pop();
792           break;
793         }
794       }
795     }
796 
797 }