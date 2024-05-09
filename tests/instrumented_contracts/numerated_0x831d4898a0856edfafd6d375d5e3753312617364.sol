1 // SPDX-License-Identifier: MIT
2 
3 // website:https://www.berc20.cash/
4 
5 //'########::'########:'########:::'######:::'#######::::'#####:::
6 //##.... ##: ##.....:: ##.... ##:'##... ##:'##.... ##::'##.. ##::
7 //##:::: ##: ##::::::: ##:::: ##: ##:::..::..::::: ##:'##:::: ##:
8 //########:: ######::: ########:: ##::::::::'#######:: ##:::: ##:
9 //##.... ##: ##...:::: ##.. ##::: ##:::::::'##:::::::: ##:::: ##:
10 //##:::: ##: ##::::::: ##::. ##:: ##::: ##: ##::::::::. ##:: ##::
11 //########:: ########: ##:::. ##:. ######:: #########::. #####:::
12 //........:::........::..:::::..:::......:::.........::::.....::::
13 pragma solidity ^0.8.9;
14 
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address to, uint256 amount) external returns (bool);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address from,
44         address to,
45         uint256 amount
46     ) external returns (bool);
47 }
48 
49 interface IERC20Metadata is IERC20 {
50 
51     function name() external view returns (string memory);
52 
53     function symbol() external view returns (string memory);
54 
55     function decimals() external view returns (uint8);
56 }
57 
58 library MerkleProof {
59 
60     error MerkleProofInvalidMultiproof();
61 
62     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
63         return processProof(proof, leaf) == root;
64     }
65 
66     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
67         return processProofCalldata(proof, leaf) == root;
68     }
69 
70     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
71         bytes32 computedHash = leaf;
72         for (uint256 i = 0; i < proof.length; i++) {
73             computedHash = _hashPair(computedHash, proof[i]);
74         }
75         return computedHash;
76     }
77 
78     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
79         bytes32 computedHash = leaf;
80         for (uint256 i = 0; i < proof.length; i++) {
81             computedHash = _hashPair(computedHash, proof[i]);
82         }
83         return computedHash;
84     }
85 
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     function multiProofVerifyCalldata(
96         bytes32[] calldata proof,
97         bool[] calldata proofFlags,
98         bytes32 root,
99         bytes32[] memory leaves
100     ) internal pure returns (bool) {
101         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
102     }
103 
104 
105     function processMultiProof(
106         bytes32[] memory proof,
107         bool[] memory proofFlags,
108         bytes32[] memory leaves
109     ) internal pure returns (bytes32 merkleRoot) {
110 
111         uint256 leavesLen = leaves.length;
112         uint256 totalHashes = proofFlags.length;
113 
114         // Check proof validity.
115         if (leavesLen + proof.length - 1 != totalHashes) {
116             revert MerkleProofInvalidMultiproof();
117         }
118 
119         bytes32[] memory hashes = new bytes32[](totalHashes);
120         uint256 leafPos = 0;
121         uint256 hashPos = 0;
122         uint256 proofPos = 0;
123 
124         for (uint256 i = 0; i < totalHashes; i++) {
125             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
126             bytes32 b = proofFlags[i]
127                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
128                 : proof[proofPos++];
129             hashes[i] = _hashPair(a, b);
130         }
131 
132         if (totalHashes > 0) {
133             unchecked {
134                 return hashes[totalHashes - 1];
135             }
136         } else if (leavesLen > 0) {
137             return leaves[0];
138         } else {
139             return proof[0];
140         }
141     }
142 
143 
144     function processMultiProofCalldata(
145         bytes32[] calldata proof,
146         bool[] calldata proofFlags,
147         bytes32[] memory leaves
148     ) internal pure returns (bytes32 merkleRoot) {
149 
150         uint256 leavesLen = leaves.length;
151         uint256 totalHashes = proofFlags.length;
152 
153         // Check proof validity.
154         if (leavesLen + proof.length - 1 != totalHashes) {
155             revert MerkleProofInvalidMultiproof();
156         }
157 
158         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
159         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
160         bytes32[] memory hashes = new bytes32[](totalHashes);
161         uint256 leafPos = 0;
162         uint256 hashPos = 0;
163         uint256 proofPos = 0;
164         // At each step, we compute the next hash using two values:
165         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
166         //   get the next hash.
167         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
168         //   `proof` array.
169         for (uint256 i = 0; i < totalHashes; i++) {
170             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
171             bytes32 b = proofFlags[i]
172                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
173                 : proof[proofPos++];
174             hashes[i] = _hashPair(a, b);
175         }
176 
177         if (totalHashes > 0) {
178             unchecked {
179                 return hashes[totalHashes - 1];
180             }
181         } else if (leavesLen > 0) {
182             return leaves[0];
183         } else {
184             return proof[0];
185         }
186     }
187 
188     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
189         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
190     }
191 
192     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
193         /// @solidity memory-safe-assembly
194         assembly {
195             mstore(0x00, a)
196             mstore(0x20, b)
197             value := keccak256(0x00, 0x40)
198         }
199     }
200 }
201 
202 
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     modifier onlyOwner() {
213         _checkOwner();
214         _;
215     }
216 
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     function _checkOwner() internal view virtual {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223     }
224 
225     function renounceOwnership() public virtual onlyOwner {
226         _transferOwnership(address(0));
227     }
228 
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 contract ERC20 is Context, IERC20, IERC20Metadata {
242     mapping(address => uint256) private _balances;
243 
244     mapping(address => mapping(address => uint256)) private _allowances;
245 
246     uint256 private _totalSupply;
247 
248     string private _name;
249     string private _symbol;
250 
251     constructor(string memory name_, string memory symbol_) {
252         _name = name_;
253         _symbol = symbol_;
254     }
255 
256     function name() public view virtual override returns (string memory) {
257         return _name;
258     }
259 
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263 
264     function decimals() public view virtual override returns (uint8) {
265         return 18;
266     }
267 
268     function totalSupply() public view virtual override returns (uint256) {
269         return _totalSupply;
270     }
271 
272     function balanceOf(address account) public view virtual override returns (uint256) {
273         return _balances[account];
274     }
275 
276     function transfer(address to, uint256 amount) public virtual override returns (bool) {
277         address owner = _msgSender();
278         _transfer(owner, to, amount);
279         return true;
280     }
281 
282 
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         address owner = _msgSender();
289         _approve(owner, spender, amount);
290         return true;
291     }
292 
293     function transferFrom(
294         address from,
295         address to,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         address spender = _msgSender();
299         _spendAllowance(from, spender, amount);
300         _transfer(from, to, amount);
301         return true;
302     }
303 
304 
305     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
306         address owner = _msgSender();
307         _approve(owner, spender, allowance(owner, spender) + addedValue);
308         return true;
309     }
310 
311     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312         address owner = _msgSender();
313         uint256 currentAllowance = allowance(owner, spender);
314         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
315         unchecked {
316             _approve(owner, spender, currentAllowance - subtractedValue);
317         }
318 
319         return true;
320     }
321 
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) internal virtual {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329 
330         _beforeTokenTransfer(from, to, amount);
331 
332         uint256 fromBalance = _balances[from];
333         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
334         unchecked {
335             _balances[from] = fromBalance - amount;
336             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
337             // decrementing then incrementing.
338             _balances[to] += amount;
339         }
340 
341         emit Transfer(from, to, amount);
342 
343         _afterTokenTransfer(from, to, amount);
344     }
345 
346     function _mint(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: mint to the zero address");
348 
349         _beforeTokenTransfer(address(0), account, amount);
350 
351         _totalSupply += amount;
352         unchecked {
353             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
354             _balances[account] += amount;
355         }
356         emit Transfer(address(0), account, amount);
357 
358         _afterTokenTransfer(address(0), account, amount);
359     }
360 
361     function _burn(address account, uint256 amount) internal virtual {
362         require(account != address(0), "ERC20: burn from the zero address");
363 
364         _beforeTokenTransfer(account, address(0), amount);
365 
366         uint256 accountBalance = _balances[account];
367         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
368         unchecked {
369             _balances[account] = accountBalance - amount;
370             // Overflow not possible: amount <= accountBalance <= totalSupply.
371             _totalSupply -= amount;
372         }
373 
374         emit Transfer(account, address(0), amount);
375 
376         _afterTokenTransfer(account, address(0), amount);
377     }
378 
379     function _approve(
380         address owner,
381         address spender,
382         uint256 amount
383     ) internal virtual {
384         require(owner != address(0), "ERC20: approve from the zero address");
385         require(spender != address(0), "ERC20: approve to the zero address");
386 
387         _allowances[owner][spender] = amount;
388         emit Approval(owner, spender, amount);
389     }
390 
391     function _spendAllowance(
392         address owner,
393         address spender,
394         uint256 amount
395     ) internal virtual {
396         uint256 currentAllowance = allowance(owner, spender);
397         if (currentAllowance != type(uint256).max) {
398             require(currentAllowance >= amount, "ERC20: insufficient allowance");
399             unchecked {
400                 _approve(owner, spender, currentAllowance - amount);
401             }
402         }
403     }
404 
405     function _beforeTokenTransfer(
406         address from,
407         address to,
408         uint256 amount
409     ) internal virtual {}
410 
411     function _afterTokenTransfer(
412         address from,
413         address to,
414         uint256 amount
415     ) internal virtual {}
416 }
417 
418 library Counters {
419     struct Counter {
420         uint256 _value; // default: 0
421     }
422 
423     function current(Counter storage counter) internal view returns (uint256) {
424         return counter._value;
425     }
426 
427     function increment(Counter storage counter) internal {
428         unchecked {
429             counter._value += 1;
430         }
431     }
432 
433     function decrement(Counter storage counter) internal {
434         uint256 value = counter._value;
435         require(value > 0, "Counter: decrement overflow");
436         unchecked {
437             counter._value = value - 1;
438         }
439     }
440 
441     function reset(Counter storage counter) internal {
442         counter._value = 0;
443     }
444 }
445 
446 
447 interface IUniswapV2Router01 {
448     function factory() external pure returns (address);
449     function WETH() external pure returns (address);
450 
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint amountADesired,
455         uint amountBDesired,
456         uint amountAMin,
457         uint amountBMin,
458         address to,
459         uint deadline
460     ) external returns (uint amountA, uint amountB, uint liquidity);
461     function addLiquidityETH(
462         address token,
463         uint amountTokenDesired,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
469     function removeLiquidity(
470         address tokenA,
471         address tokenB,
472         uint liquidity,
473         uint amountAMin,
474         uint amountBMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountA, uint amountB);
478     function removeLiquidityETH(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline
485     ) external returns (uint amountToken, uint amountETH);
486     function removeLiquidityWithPermit(
487         address tokenA,
488         address tokenB,
489         uint liquidity,
490         uint amountAMin,
491         uint amountBMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountA, uint amountB);
496     function removeLiquidityETHWithPermit(
497         address token,
498         uint liquidity,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline,
503         bool approveMax, uint8 v, bytes32 r, bytes32 s
504     ) external returns (uint amountToken, uint amountETH);
505     function swapExactTokensForTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external returns (uint[] memory amounts);
512     function swapTokensForExactTokens(
513         uint amountOut,
514         uint amountInMax,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external returns (uint[] memory amounts);
519     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
520         external
521         payable
522         returns (uint[] memory amounts);
523     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
524         external
525         returns (uint[] memory amounts);
526     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
527         external
528         returns (uint[] memory amounts);
529     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
530         external
531         payable
532         returns (uint[] memory amounts);
533 
534     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
535     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
536     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
537     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
538     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
539 }
540 
541 
542 interface IUniswapV2Router02 is IUniswapV2Router01 {
543     function removeLiquidityETHSupportingFeeOnTransferTokens(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external returns (uint amountETH);
551     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
552         address token,
553         uint liquidity,
554         uint amountTokenMin,
555         uint amountETHMin,
556         address to,
557         uint deadline,
558         bool approveMax, uint8 v, bytes32 r, bytes32 s
559     ) external returns (uint amountETH);
560 
561     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
562         uint amountIn,
563         uint amountOutMin,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external;
568     function swapExactETHForTokensSupportingFeeOnTransferTokens(
569         uint amountOutMin,
570         address[] calldata path,
571         address to,
572         uint deadline
573     ) external payable;
574     function swapExactTokensForETHSupportingFeeOnTransferTokens(
575         uint amountIn,
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     ) external;
581 }
582 
583 
584 interface IUniswapV2Pair {
585     event Approval(address indexed owner, address indexed spender, uint value);
586     event Transfer(address indexed from, address indexed to, uint value);
587 
588     function name() external pure returns (string memory);
589     function symbol() external pure returns (string memory);
590     function decimals() external pure returns (uint8);
591     function totalSupply() external view returns (uint);
592     function balanceOf(address owner) external view returns (uint);
593     function allowance(address owner, address spender) external view returns (uint);
594 
595     function approve(address spender, uint value) external returns (bool);
596     function transfer(address to, uint value) external returns (bool);
597     function transferFrom(address from, address to, uint value) external returns (bool);
598 
599     function DOMAIN_SEPARATOR() external view returns (bytes32);
600     function PERMIT_TYPEHASH() external pure returns (bytes32);
601     function nonces(address owner) external view returns (uint);
602 
603     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
604 
605     event Mint(address indexed sender, uint amount0, uint amount1);
606     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
607     event Swap(
608         address indexed sender,
609         uint amount0In,
610         uint amount1In,
611         uint amount0Out,
612         uint amount1Out,
613         address indexed to
614     );
615     event Sync(uint112 reserve0, uint112 reserve1);
616 
617     function MINIMUM_LIQUIDITY() external pure returns (uint);
618     function factory() external view returns (address);
619     function token0() external view returns (address);
620     function token1() external view returns (address);
621     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
622     function price0CumulativeLast() external view returns (uint);
623     function price1CumulativeLast() external view returns (uint);
624     function kLast() external view returns (uint);
625 
626     function mint(address to) external returns (uint liquidity);
627     function burn(address to) external returns (uint amount0, uint amount1);
628     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
629     function skim(address to) external;
630     function sync() external;
631 
632     function initialize(address, address) external;
633 }
634 
635 
636 interface IUniswapV2Factory {
637     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
638 
639     function feeTo() external view returns (address);
640     function feeToSetter() external view returns (address);
641 
642     function getPair(address tokenA, address tokenB) external view returns (address pair);
643     function allPairs(uint) external view returns (address pair);
644     function allPairsLength() external view returns (uint);
645 
646     function createPair(address tokenA, address tokenB) external returns (address pair);
647 
648     function setFeeTo(address) external;
649     function setFeeToSetter(address) external;
650 }
651 
652 interface IWETH {
653     function deposit() external payable;
654     function withdraw(uint256 amount) external;
655     function transfer(address to, uint256 value) external returns (bool);
656     function approve(address spender, uint256 value) external returns (bool);
657     function transferFrom(address from, address to, uint256 value) external returns (bool);
658     function balanceOf(address account) external view returns (uint256);
659 }
660 
661 interface IERC721Enumerable {
662     function totalSupply() external view returns (uint256);
663     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
664     function tokenByIndex(uint256 index) external view returns (uint256);
665 }
666 
667 interface IERC721 {
668     function balanceOf(address owner) external view returns (uint256);
669 }
670 
671 interface IERC1155 {
672     function balanceOf(address account, uint256 id) external view returns (uint256);
673 }
674 
675 interface BercAirdrop {
676     function createAirdrop(address depositContract,address airDropContract, uint256 _airDropNums, uint256 depositeCycle, uint256 claimCycle, uint256 _minDeposit) external;
677 }
678 
679 interface Berc20Store {
680     function createTokenInfo(address tokenAddress,string memory name,string memory symbol,uint256 totalSupply,
681         uint256 maxMintCount,
682         uint256 maxMintPerAddress,
683         uint256 mintPrice,
684         address creator,
685         bytes32 wlRoot,
686         uint256[] memory params,
687         address[] memory authContracts
688         ) external;
689 }
690 
691 contract BlackErc20 is ERC20, Ownable {
692 
693     uint256 private constant DECIMAL_MULTIPLIER = 1e18;
694     address private  blackHole = 0x000000000000000000000000000000000000dEaD;
695 
696 
697     uint256 public _maxMintCount;
698     uint256 public _mintPrice;
699     uint256 public _maxMintPerAddress;
700 
701     mapping(address => uint256) public _mintCounts;
702     uint256 public _mintedCounts;
703 
704     address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
705     //address public wethAddress = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
706     address public lpContract;
707     address public _devAddress;
708     address public _deplyAddress;
709 
710     uint256 public _maxPro = 0;
711 
712     uint256 public deployReserveTokenPro = 0;
713     uint256 public donateReserveTokenPro = 0;
714     uint256 public airDropTokenPro = 0;
715 
716     uint256 public tokenLockDays = 0;
717     uint256 public deployTime;
718     uint256 public tokenUnlockCounts;
719     uint256 public hadTokenUnlockCounts=0;
720     uint256 public totalTokensLocked;
721     uint public totalTokensClaimed;
722 
723 
724     uint256 public deployReserveEthPro = 0;
725     uint256 public donateEthPro = 0;
726 
727     uint256 public wlMintCounts = 0;
728     uint256 public wlMintedCounts = 0;
729     uint256 public wlMintedEndTime;
730 
731 
732     uint256 public mintStartTime=0;
733     uint256 public mintEndTime;
734 
735     uint256 public burnAddressPer=0;
736     uint256 public burnBlockPer=0;
737     uint256 public burnAirDropPer=0;
738 
739     address public  burnAddress;
740     address public  airDropAddress;
741 
742 
743     bytes32 public wlRoot;
744 
745     uint256 public validateNftNumber=0;
746 
747     bool public deployHadClaimEth;
748     bool public devHadClaimEth;
749     uint256 public  remainBalance=0;
750 
751     mapping(uint256 => bool) public tokenExists;
752 
753     enum ContractType {ERC721,ERC20,ERC1155}
754 
755     struct ContractAuth {
756         ContractType contractType;
757         address contractAddress;
758         uint256 tokenCount;
759     }
760 
761     ContractAuth[] public contractAuths;
762 
763     constructor(
764         string memory name,
765         string memory symbol,
766         uint256 totalSupply,
767         uint256 maxMintCount,
768         uint256 maxMintPerAddress,
769         uint256 mintPrice,
770         address factoryContract,
771         address devAddress,
772         address deplyAddress,
773         address _airDropAddress,
774         uint256[] memory params
775     ) ERC20(symbol,name) {
776         _maxMintCount = maxMintCount;
777         _mintPrice = mintPrice;
778         _devAddress = devAddress;
779         _deplyAddress = deplyAddress;
780         _maxMintPerAddress = maxMintPerAddress;
781 
782         deployReserveTokenPro = params[0];
783         donateReserveTokenPro = params[2];
784         wlMintCounts = params[3];
785         validateNftNumber = params[13];
786 
787         tokenLockDays = params[7];
788         if (tokenLockDays>0){
789             require(params[6]>0&&params[6]<tokenLockDays,"tokenUnlockCounts error");
790             tokenUnlockCounts = params[6];
791         }
792         totalTokensLocked = totalSupply*deployReserveTokenPro/1000;
793         deployTime = block.timestamp;
794 
795 
796         deployReserveEthPro = params[4];
797         donateEthPro = params[5];
798 
799         burnAddressPer = params[15];
800         burnBlockPer = params[17];
801         burnAirDropPer = params[18];
802 
803         if(params[1]>0){
804             airDropTokenPro = params[1];
805             _mint(_airDropAddress, totalSupply*airDropTokenPro/1000);
806         }
807 
808         airDropAddress =_airDropAddress;
809 
810         _maxPro = 1000000-(10+params[0]*1000+params[1]*1000+params[2]*1000);
811         _mint(factoryContract, totalSupply*1/100000);
812 
813         if(params[8]>0){
814             mintStartTime = params[8];
815         }
816         if(params[9]>0){
817             mintEndTime = params[9];
818         }
819         if(params[16]>0){
820             wlMintedEndTime = params[16];
821         }
822 
823         if(donateReserveTokenPro>0){
824             _mint(devAddress, totalSupply*donateReserveTokenPro*1000/1000000);
825         }
826 
827         if(deployReserveTokenPro>0&&params[7]==0){
828             _mint(deplyAddress, totalSupply*deployReserveTokenPro*1000/1000000);
829         }
830         _mint(address(this), totalSupply*_maxPro/1000000);
831     }
832 
833     function mintProof(uint256 mintCount,address receiveAds,bytes32[] memory proof) public  payable {
834         require(!isContract(msg.sender),"not supper contract mint");
835         require(mintCount > 0, "Invalid mint count");
836         require(mintCount <= _maxMintPerAddress, "Exceeded maximum mint count per address");
837         require(msg.value >= mintCount*_mintPrice, "illegal price");
838         require(_mintCounts[msg.sender]+mintCount <= _maxMintPerAddress, "over limit");
839         receiveAds = msg.sender;
840 
841         if(isZero(wlRoot)){
842             require(block.timestamp >= mintStartTime, "Minting has not started yet");
843             require(block.timestamp <= mintEndTime, "Minting has ended");
844         }else {
845             if (block.timestamp<wlMintedEndTime){
846                 require(wlMintedCounts+mintCount<=wlMintCounts,"over limit");
847                 bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
848                 require(MerkleProof.verify(proof, wlRoot, leaf),"Not In Wl");
849                 wlMintedCounts += mintCount;
850             }
851         }
852 
853         if (block.timestamp<wlMintedEndTime){
854             require(_mintedCounts-wlMintedCounts+mintCount <= (_maxMintCount - wlMintedCounts), "illegal mintAmount");
855         }
856 
857         IWETH(wethAddress).deposit{value: msg.value*(1000-deployReserveEthPro-donateEthPro)/1000}();
858         IWETH(wethAddress).approve(lpContract, msg.value*(1000-deployReserveEthPro-donateEthPro)/1000);
859         IWETH(wethAddress).transferFrom(address(this), lpContract, msg.value*(1000-deployReserveEthPro-donateEthPro)/1000); 
860 
861         uint256 mintAmount = (totalSupply() * _maxPro * mintCount) / (_maxMintCount * 2000000);
862 
863         for (uint256 i = 0; i < contractAuths.length; i++) {
864             if (contractAuths[i].contractType == ContractType.ERC721) {
865                 if(validateNftNumber==1){
866                     IERC721Enumerable eRC721Enumerable = IERC721Enumerable(contractAuths[i].contractAddress);
867                     uint256 tokenId = eRC721Enumerable.tokenOfOwnerByIndex(msg.sender, 0);
868                     require(!tokenExists[tokenId],"had used!");
869                     tokenExists[tokenId] = true;
870                 }
871                 uint256 tokenCount = getERC721TokenCount(contractAuths[i].contractAddress);
872                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC721 tokens");
873             } else if (contractAuths[i].contractType == ContractType.ERC20) {
874                 uint256 tokenCount = getERC20TokenCount(contractAuths[i].contractAddress);
875                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC20 tokens");
876             } else if (contractAuths[i].contractType == ContractType.ERC1155) {
877                 uint256 tokenCount = getERC1155TokenCount(contractAuths[i].contractAddress, 0);
878                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC1155 tokens");
879             }
880         }
881 
882         // Transfer minted tokens from contract to the sender and blackAddress
883         _transfer(address(this), receiveAds, mintAmount);
884         _transfer(address(this), lpContract, mintAmount);
885         IUniswapV2Pair(lpContract).sync();
886 
887         _mintCounts[msg.sender] += mintCount;
888         _mintedCounts += mintCount;
889     }
890 
891     function mint(uint256 mintCount,address receiveAds) external payable {
892         bytes32[] memory proof = new bytes32[](0);
893         mintProof(mintCount,receiveAds,proof);
894     }
895 
896     function isContract(address addr) private view returns (bool) {
897         uint256 codeSize;
898         assembly {
899             codeSize := extcodesize(addr)
900         }
901         return codeSize > 0;
902     }
903 
904 
905     function setContractAuth(uint256[] memory params, address[] memory authContracts) external onlyOwner {
906         delete contractAuths;
907         if (authContracts[0] != address(0)) {
908             contractAuths.push(ContractAuth({
909                 contractType: ContractType.ERC721,
910                 contractAddress: authContracts[0],
911                 tokenCount: 1
912             }));
913         }
914         if (authContracts[1] != address(0)) {
915             contractAuths.push(ContractAuth({
916                 contractType: ContractType.ERC20,
917                 contractAddress: authContracts[1],
918                 tokenCount: params[14]
919             }));
920         }
921 
922         if (authContracts[2] != address(0)) {
923             contractAuths.push(ContractAuth({
924                 contractType: ContractType.ERC1155,
925                 contractAddress: authContracts[2],
926                 tokenCount: 1
927             }));
928         }
929         if (authContracts[3] != address(0)) {
930            burnAddress = authContracts[3];
931         }
932     }
933 
934     function transfer(address recipient, uint256 amount) public override returns (bool) {
935         uint256 burnAddressAmount = amount * burnAddressPer / 1000;
936         uint256 burnBlockAmount = amount * burnBlockPer / 1000;
937         uint256 burnAirDropAmount = amount * burnAirDropPer / 1000;
938         uint256 transferAmount = amount - burnAddressAmount -burnBlockAmount-burnAirDropAmount;
939         super._transfer(msg.sender, recipient, transferAmount);
940         if(burnAddressAmount>0){
941             super._transfer(msg.sender, burnAddress, burnAddressAmount);
942         }
943         if(burnBlockAmount>0){
944             super._transfer(msg.sender, blackHole, burnBlockAmount);
945         }
946         if(burnAirDropAmount>0){
947             super._transfer(msg.sender, airDropAddress, burnAirDropAmount);
948         }
949         return true;
950     }
951 
952     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
953         uint256 burnAddressAmount = amount * burnAddressPer / 1000;
954         uint256 burnBlockAmount = amount * burnBlockPer / 1000;
955         uint256 burnAirDropAmount = amount * burnAirDropPer / 1000;
956         uint256 transferAmount = amount - burnAddressAmount -burnBlockAmount-burnAirDropAmount;        
957         super._transfer(sender, recipient, transferAmount);
958         if(burnAddressAmount>0){
959             super._transfer(sender, burnAddress, burnAddressAmount);
960         }
961         if(burnBlockAmount>0){
962             super._transfer(sender, blackHole, burnBlockAmount);
963         }
964         if(burnAirDropAmount>0){
965             super._transfer(sender, airDropAddress, burnAirDropAmount);
966         }
967         uint256 currentAllowance = allowance(sender, msg.sender);
968         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
969         super._approve(sender, msg.sender, currentAllowance - amount);
970          return true;
971     }
972 
973 
974     function setLPContract(address lp) external onlyOwner {
975         lpContract = lp;
976     }
977 
978     function setWlRoot(bytes32 root) external onlyOwner {
979         wlRoot = root;
980     }
981 
982     function devAwardEth() external {
983         require(_mintedCounts==_maxMintCount,"waiting mint finish");
984         require(!devHadClaimEth,"had claimed");
985         require(msg.sender==_devAddress,"only dev!");
986         uint256 balance = address(this).balance;
987         require(balance > 0, "Contract has no ETH balance.");
988         address payable sender = payable(_devAddress);
989         uint256 devAmount = donateEthPro*balance/(deployReserveEthPro+donateEthPro);
990         if(remainBalance==0){
991             sender.transfer(devAmount);
992             remainBalance = balance-devAmount;
993         }else{
994             sender.transfer(remainBalance);
995         }
996         devHadClaimEth = true;
997     }
998 
999     function deployAwardEth() external {
1000         require(_mintedCounts==_maxMintCount,"waiting mint finish");
1001         require(!deployHadClaimEth,"had claimed");
1002         require(msg.sender==_deplyAddress,"only deply!");
1003         uint256 balance = address(this).balance;
1004         require(balance > 0, "Contract has no ETH balance.");
1005         address payable sender = payable(_deplyAddress);
1006         uint256 deplyAmount = deployReserveEthPro*balance/(deployReserveEthPro+donateEthPro);
1007         if(remainBalance==0){
1008             sender.transfer(deplyAmount);
1009             remainBalance = balance-deplyAmount;
1010         }else{
1011             sender.transfer(remainBalance);
1012         }
1013         deployHadClaimEth = true;
1014     }
1015 
1016     function deployAwardToken() external {
1017         require(_mintedCounts==_maxMintCount,"waiting mint finish");
1018         require(msg.sender==_deplyAddress,"not deplyer");
1019         require(totalTokensClaimed <= totalTokensLocked, "All tokens have been claimed.");
1020         uint256 currentTimestamp = block.timestamp;
1021         uint256 lockEndTime = deployTime + (tokenLockDays * 86400);
1022         uint256 unlockTimes = (lockEndTime - currentTimestamp) / ((tokenLockDays / tokenUnlockCounts) * 86400) - hadTokenUnlockCounts;
1023         uint256 claimableTokens;
1024         IERC20 token2 = IERC20(address(this));
1025         if (unlockTimes >= tokenUnlockCounts) {
1026             claimableTokens = token2.balanceOf(address(this));
1027             hadTokenUnlockCounts = tokenUnlockCounts;
1028         } else {
1029             require(unlockTimes>0,"not have unlock times!");
1030             claimableTokens = unlockTimes * (totalTokensLocked/tokenUnlockCounts);
1031             hadTokenUnlockCounts += unlockTimes;
1032         }
1033         token2.transfer(msg.sender, claimableTokens);
1034     }
1035 
1036 
1037     function getERC721TokenCount(address contractAddress) internal view returns (uint256) {
1038         IERC721 erc721Contract = IERC721(contractAddress);
1039         return erc721Contract.balanceOf(msg.sender);
1040     }
1041 
1042     function getERC20TokenCount(address contractAddress) internal view returns (uint256) {
1043         IERC20 erc20Contract = IERC20(contractAddress);
1044         return erc20Contract.balanceOf(msg.sender);
1045     }
1046 
1047     function getERC1155TokenCount(address contractAddress, uint256 tokenId) internal view returns (uint256) {
1048         IERC1155 erc1155Contract = IERC1155(contractAddress);
1049         return erc1155Contract.balanceOf(msg.sender, tokenId);
1050     }
1051 
1052     function getMintedCounts() external view returns (uint256) {
1053         return _mintedCounts;
1054     }
1055 
1056     function getContractAuthsLength() public view returns (uint256) {
1057         return contractAuths.length;
1058     }
1059 
1060     function getAllContractAuths() public view returns (ContractAuth[] memory) {
1061         return contractAuths;
1062     }
1063 
1064     function isZero(bytes32 value) private  pure returns (bool) {
1065         return value == 0x0000000000000000000000000000000000000000000000000000000000000000;
1066     }
1067 
1068     function getAllContractTypes() public view returns (uint256[] memory) {
1069         uint256[] memory contractTypes = new uint256[](contractAuths.length);
1070         if (contractAuths.length==0){
1071             return new uint256[](0);
1072         }
1073         for (uint256 i = 0; i < contractAuths.length; i++) {
1074             contractTypes[i] = uint256(contractAuths[i].contractType);
1075         }
1076         return contractTypes;
1077     }
1078 
1079 
1080 }