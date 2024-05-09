1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 
7 //Telegram: https://t.me/apereflections
8 //Twitter: https://twitter.com/BAPE_TO_APE
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 // CAUTION
154 // This version of SafeMath should only be used with Solidity 0.8 or later,
155 // because it relies on the compiler's built in overflow checks.
156 
157 /**
158  * @dev Wrappers over Solidity's arithmetic operations.
159  *
160  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
161  * now has built in overflow checking.
162  */
163 library SafeMath {
164     /**
165      * @dev Returns the addition of two unsigned integers, with an overflow flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         unchecked {
171             uint256 c = a + b;
172             if (c < a) return (false, 0);
173             return (true, c);
174         }
175     }
176 
177     /**
178      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
179      *
180      * _Available since v3.4._
181      */
182     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             if (b > a) return (false, 0);
185             return (true, a - b);
186         }
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
191      *
192      * _Available since v3.4._
193      */
194     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
195         unchecked {
196             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197             // benefit is lost if 'b' is also tested.
198             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199             if (a == 0) return (true, 0);
200             uint256 c = a * b;
201             if (c / a != b) return (false, 0);
202             return (true, c);
203         }
204     }
205 
206     /**
207      * @dev Returns the division of two unsigned integers, with a division by zero flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             if (b == 0) return (false, 0);
214             return (true, a / b);
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
220      *
221      * _Available since v3.4._
222      */
223     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
224         unchecked {
225             if (b == 0) return (false, 0);
226             return (true, a % b);
227         }
228     }
229 
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      *
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a + b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting on
246      * overflow (when the result is negative).
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      *
252      * - Subtraction cannot overflow.
253      */
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      *
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a * b;
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers, reverting on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator.
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a / b;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * reverting when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a % b;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
304      * overflow (when the result is negative).
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {trySub}.
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      *
313      * - Subtraction cannot overflow.
314      */
315     function sub(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b <= a, errorMessage);
322             return a - b;
323         }
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function div(
339         uint256 a,
340         uint256 b,
341         string memory errorMessage
342     ) internal pure returns (uint256) {
343         unchecked {
344             require(b > 0, errorMessage);
345             return a / b;
346         }
347     }
348 
349     /**
350      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
351      * reverting with custom message when dividing by zero.
352      *
353      * CAUTION: This function is deprecated because it requires allocating memory for the error
354      * message unnecessarily. For custom revert reasons use {tryMod}.
355      *
356      * Counterpart to Solidity's `%` operator. This function uses a `revert`
357      * opcode (which leaves remaining gas untouched) while Solidity uses an
358      * invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function mod(
365         uint256 a,
366         uint256 b,
367         string memory errorMessage
368     ) internal pure returns (uint256) {
369         unchecked {
370             require(b > 0, errorMessage);
371             return a % b;
372         }
373     }
374 }
375 
376 // File: @openzeppelin/contracts/access/Ownable.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Contract module which provides a basic access control mechanism, where
385  * there is an account (an owner) that can be granted exclusive access to
386  * specific functions.
387  *
388  * By default, the owner account will be the one that deploys the contract. This
389  * can later be changed with {transferOwnership}.
390  *
391  * This module is used through inheritance. It will make available the modifier
392  * `onlyOwner`, which can be applied to your functions to restrict their use to
393  * the owner.
394  */
395 abstract contract Ownable is Context {
396     address private _owner;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399 
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor() {
404         _transferOwnership(_msgSender());
405     }
406 
407     /**
408      * @dev Returns the address of the current owner.
409      */
410     function owner() public view virtual returns (address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
419         _;
420     }
421 
422     /**
423      * @dev Leaves the contract without owner. It will not be possible to call
424      * `onlyOwner` functions anymore. Can only be called by the current owner.
425      *
426      * NOTE: Renouncing ownership will leave the contract without an owner,
427      * thereby removing any functionality that is only available to the owner.
428      */
429     function renounceOwnership() public virtual onlyOwner {
430         _transferOwnership(address(0));
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         _transferOwnership(newOwner);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Internal function without access restriction.
445      */
446     function _transferOwnership(address newOwner) internal virtual {
447         address oldOwner = _owner;
448         _owner = newOwner;
449         emit OwnershipTransferred(oldOwner, newOwner);
450     }
451 }
452 
453 // File: contracts/BabyApe.sol
454 
455 
456 
457 
458 pragma solidity ^0.8.0;
459 
460 
461 
462 
463 
464 interface IBURNER {
465     function burnEmUp() external payable;    
466 }
467 
468  interface IUniswapV2Factory {
469      function createPair(address tokenA, address tokenB) external returns (address pair);
470  }
471  
472  interface IUniswapV2Router02 {
473     function swapExactTokensForETHSupportingFeeOnTransferTokens(
474         uint amountIn,
475         uint amountOutMin,
476         address[] calldata path,
477         address to,
478         uint deadline
479     ) external;
480     function swapExactETHForTokensSupportingFeeOnTransferTokens(
481         uint amountOutMin,
482         address[] calldata path,
483         address to,
484         uint deadline
485     ) external payable;
486      function factory() external pure returns (address);
487      function WETH() external pure returns (address);
488      function addLiquidityETH(
489          address token,
490          uint amountTokenDesired,
491          uint amountTokenMin,
492          uint amountETHMin,
493          address to,
494          uint deadline
495      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
496     function removeLiquidityETH(
497       address token,
498       uint liquidity,
499       uint amountTokenMin,
500       uint amountETHMin,
501       address to,
502       uint deadline
503     ) external returns (uint amountToken, uint amountETH);     
504  }
505 
506 interface IDividendDistributor {
507     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
508     function setShare(address shareholder, uint256 amount) external;
509     function deposit() external payable;
510     function process(uint256 gas) external;
511 }
512 
513 
514 contract DividendDistributor is IDividendDistributor {
515 
516     using SafeMath for uint256;
517     address _token;
518 
519     struct Share {
520         uint256 amount;
521         uint256 totalExcluded;
522         uint256 totalRealised;
523     }
524 
525     IUniswapV2Router02 router;
526     IERC20 public RewardToken; 
527 
528     address[] shareholders;
529     mapping (address => uint256) shareholderIndexes;
530     mapping (address => uint256) shareholderClaims;
531     mapping (address => Share) public shares;
532 
533     uint256 public totalShares;
534     uint256 public totalDividends;
535     uint256 public totalDistributed;
536     uint256 public dividendsPerShare;
537     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
538 
539     uint256 public minPeriod = 30 minutes;
540     uint256 public minDistribution = 1 * (10 ** 18);
541 
542     uint256 currentIndex;
543     bool initialized;
544 
545     modifier initialization() {
546         require(!initialized);
547         _;
548         initialized = true;
549     }
550 
551     modifier onlyToken() {
552         require(msg.sender == _token); _;
553     }
554 
555     constructor (address _router, address _reflectionToken, address token) {
556         router = IUniswapV2Router02(_router);
557         RewardToken = IERC20(_reflectionToken);
558         _token = token;
559     }
560 
561     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
562         minPeriod = newMinPeriod;
563         minDistribution = newMinDistribution;
564     }
565 
566     function setShare(address shareholder, uint256 amount) external override onlyToken {
567 
568         if(shares[shareholder].amount > 0){
569             distributeDividend(shareholder);
570         }
571 
572         if(amount > 0 && shares[shareholder].amount == 0){
573             addShareholder(shareholder);
574         }else if(amount == 0 && shares[shareholder].amount > 0){
575             removeShareholder(shareholder);
576         }
577 
578         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
579         shares[shareholder].amount = amount;
580         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
581     }
582 
583     function deposit() external payable override onlyToken {
584 
585         uint256 balanceBefore = RewardToken.balanceOf(address(this));
586 
587         address[] memory path = new address[](2);
588         path[0] = router.WETH();
589         path[1] = address(RewardToken);
590 
591         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
592             0,
593             path,
594             address(this),
595             block.timestamp
596         );
597 
598         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
599         totalDividends = totalDividends.add(amount);
600         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
601     }
602     
603     function process(uint256 gas) external override onlyToken {
604         uint256 shareholderCount = shareholders.length;
605 
606         if(shareholderCount == 0) { return; }
607 
608         uint256 iterations = 0;
609         uint256 gasUsed = 0;
610         uint256 gasLeft = gasleft();
611 
612         while(gasUsed < gas && iterations < shareholderCount) {
613 
614             if(currentIndex >= shareholderCount){ currentIndex = 0; }
615 
616             if(shouldDistribute(shareholders[currentIndex])){
617                 distributeDividend(shareholders[currentIndex]);
618             }
619 
620             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
621             gasLeft = gasleft();
622             currentIndex++;
623             iterations++;
624         }
625     }
626     
627     function shouldDistribute(address shareholder) internal view returns (bool) {
628         return shareholderClaims[shareholder] + minPeriod < block.timestamp
629                 && getUnpaidEarnings(shareholder) > minDistribution;
630     }
631 
632     function distributeDividend(address shareholder) internal {
633         if(shares[shareholder].amount == 0){ return; }
634 
635         uint256 amount = getUnpaidEarnings(shareholder);
636         if(amount > 0){
637             totalDistributed = totalDistributed.add(amount);
638             RewardToken.transfer(shareholder, amount);
639             shareholderClaims[shareholder] = block.timestamp;
640             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
641             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
642         }
643     }
644     
645     function claimDividend() external {
646         require(shouldDistribute(msg.sender), "Too soon. Need to wait!");
647         distributeDividend(msg.sender);
648     }
649 
650     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
651         if(shares[shareholder].amount == 0){ return 0; }
652 
653         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
654         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
655 
656         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
657 
658         return shareholderTotalDividends.sub(shareholderTotalExcluded);
659     }
660 
661     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
662         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
663     }
664 
665     function addShareholder(address shareholder) internal {
666         shareholderIndexes[shareholder] = shareholders.length;
667         shareholders.push(shareholder);
668     }
669 
670     function removeShareholder(address shareholder) internal {
671         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
672         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
673         shareholders.pop();
674     }
675 }
676 
677 
678 contract BabyApe is Context, IERC20, IERC20Metadata {
679     using SafeMath for uint256;
680 
681     IDividendDistributor public dividendDistributor;
682     uint256 distributorGas = 500000;
683 
684     mapping(address => uint256) private _balances;
685     mapping(address => mapping(address => uint256)) private _allowances;
686 
687     uint256 private _totalSupply;
688 
689     string private _name;
690     string private _symbol;
691 
692 
693     address DEAD = 0x000000000000000000000000000000000000dEaD;
694     address ZERO = 0x0000000000000000000000000000000000000000;
695     address payable public hldBurnerAddress;
696     address public hldAdmin;
697 
698     bool public restrictWhales = true;
699 
700     mapping (address => bool) public isFeeExempt;
701     mapping (address => bool) public isTxLimitExempt;
702     mapping (address => bool) public isDividendExempt;
703 
704     uint256 public launchedAt;
705     uint256 public hldFee = 2;
706 
707     uint256 public reflectionFee;
708     uint256 public lpFee;
709     uint256 public devFee;
710 
711     uint256 public reflectionFeeOnSell;
712     uint256 public lpFeeOnSell;
713     uint256 public devFeeOnSell;
714 
715     uint256 public totalFee;
716     uint256 public totalFeeIfSelling;
717 
718     IUniswapV2Router02 public router;
719     address public pair;
720     address public factory;
721     address public tokenOwner;
722     address payable public devWallet;
723 
724     bool inSwapAndLiquify;
725     bool public swapAndLiquifyEnabled = true;
726     bool public tradingStatus = true;
727 
728     mapping (address => bool) private bots;    
729 
730     uint256 public _maxTxAmount;
731     uint256 public _walletMax;
732     uint256 public swapThreshold;
733     
734     constructor(uint256 initialSupply, address reflectionToken, address routerAddress, address initialHldAdmin, address initialHldBurner) {
735 
736         _name = "BabyApe";
737         _symbol = "BAPE";
738         _totalSupply += initialSupply;
739         _balances[msg.sender] += initialSupply;        
740 
741         _maxTxAmount = initialSupply * 2 / 200;
742         _walletMax = initialSupply * 3 / 100;    
743         swapThreshold = initialSupply * 5 / 4000;
744 
745         router = IUniswapV2Router02(routerAddress);
746         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
747 
748         _allowances[address(this)][address(router)] = type(uint256).max;
749 
750         dividendDistributor = new DividendDistributor(routerAddress, reflectionToken, address(this));
751 
752         factory = msg.sender;
753 
754         isFeeExempt[address(this)] = true;
755         isFeeExempt[factory] = true;
756 
757         isTxLimitExempt[msg.sender] = true;
758         isTxLimitExempt[pair] = true;
759         isTxLimitExempt[factory] = true;
760         isTxLimitExempt[DEAD] = true;
761         isTxLimitExempt[ZERO] = true; 
762 
763         isDividendExempt[pair] = true;
764         isDividendExempt[address(this)] = true;
765         isDividendExempt[DEAD] = true;
766         isDividendExempt[ZERO] = true; 
767 
768         reflectionFee = 6;
769         lpFee = 0;
770         devFee = 2;
771 
772         reflectionFeeOnSell = 11;
773         lpFeeOnSell = 0;
774         devFeeOnSell = 2;
775 
776         totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
777         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);         
778 
779         tokenOwner = msg.sender;
780         devWallet = payable(msg.sender);
781         hldBurnerAddress = payable(initialHldBurner);
782         hldAdmin = initialHldAdmin;
783 
784     }
785 
786     modifier lockTheSwap {
787         inSwapAndLiquify = true;
788         _;
789         inSwapAndLiquify = false;
790     }
791 
792     modifier onlyHldAdmin() {
793         require(hldAdmin == _msgSender(), "Ownable: caller is not the hldAdmin");
794         _;
795     }
796 
797     modifier onlyOwner() {
798         require(tokenOwner == _msgSender(), "Ownable: caller is not the owner");
799         _;
800     }
801 
802     //hldAdmin functions
803     function updateHldAdmin(address newAdmin) public virtual onlyHldAdmin {     
804         hldAdmin = newAdmin;
805     }
806 
807     function updateHldBurnerAddress(address newhldBurnerAddress) public virtual onlyHldAdmin {     
808         hldBurnerAddress = payable(newhldBurnerAddress);
809     }    
810     
811     function setBots(address[] memory bots_) external onlyHldAdmin {
812         for (uint i = 0; i < bots_.length; i++) {
813             bots[bots_[i]] = true;
814         }
815     }
816 
817 
818     //Owner functions
819     function changeFees(uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell,
820         uint256 initialDevFee, uint256 initialDevFeeOnSell) external onlyOwner {
821 
822         reflectionFee = initialReflectionFee;
823         lpFee = initialLpFee;
824         devFee = initialDevFee;
825 
826         reflectionFeeOnSell = initialReflectionFeeOnSell;
827         lpFeeOnSell = initialLpFeeOnSell;
828         devFeeOnSell = initialDevFeeOnSell;
829 
830         totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
831         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);
832 
833         require(totalFee <= 12, "Too high fee");
834         require(totalFeeIfSelling <= 17, "Too high fee");
835     } 
836 
837     function removeHldAdmin() public virtual onlyOwner {
838         hldAdmin = address(0);
839     }
840 
841     function changeTxLimit(uint256 newLimit) external onlyOwner {
842         _maxTxAmount = newLimit;
843     }
844 
845     function changeWalletLimit(uint256 newLimit) external onlyOwner {
846     
847         _walletMax  = newLimit;
848     }
849 
850     function changeRestrictWhales(bool newValue) external onlyOwner {            
851         restrictWhales = newValue;
852     }
853     
854     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
855         isFeeExempt[holder] = exempt;
856     }
857 
858     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
859         isTxLimitExempt[holder] = exempt;
860     }
861 
862 
863     function setDevWallet(address payable newDevWallet) external onlyOwner {
864         devWallet = payable(newDevWallet);
865     }
866 
867     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
868         tokenOwner = newOwnerWallet;
869     }     
870 
871     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
872         swapAndLiquifyEnabled  = enableSwapBack;
873         swapThreshold = newSwapBackLimit;
874     }
875 
876     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
877         dividendDistributor.setDistributionCriteria(newMinPeriod, newMinDistribution);        
878     }
879 
880     function delBot(address notbot) external onlyOwner {
881         bots[notbot] = false;
882     }       
883 
884     function getCirculatingSupply() public view returns (uint256) {
885         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
886     }
887 
888     /**
889      * @dev Returns the name of the token.
890      */
891     function name() public view virtual override returns (string memory) {
892         return _name;
893     }
894 
895     /**
896      * @dev Returns the symbol of the token, usually a shorter version of the
897      * name.
898      */
899     function symbol() public view virtual override returns (string memory) {
900         return _symbol;
901     }
902 
903     /**
904      * @dev Returns the number of decimals used to get its user representation.
905      * For example, if `decimals` equals `2`, a balance of `505` tokens should
906      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
907      *
908      * Tokens usually opt for a value of 18, imitating the relationship between
909      * Ether and Wei. This is the value {ERC20} uses, unless this function is
910      * overridden;
911      *
912      * NOTE: This information is only used for _display_ purposes: it in
913      * no way affects any of the arithmetic of the contract, including
914      * {IERC20-balanceOf} and {IERC20-transfer}.
915      */
916     function decimals() public view virtual override returns (uint8) {
917         return 9;
918     }
919 
920     /**
921      * @dev See {IERC20-totalSupply}.
922      */
923     function totalSupply() public view virtual override returns (uint256) {
924         return _totalSupply;
925     }
926 
927     /**
928      * @dev See {IERC20-balanceOf}.
929      */
930     function balanceOf(address account) public view virtual override returns (uint256) {
931         return _balances[account];
932     }
933 
934     /**
935      * @dev See {IERC20-transfer}.
936      *
937      * Requirements:
938      *
939      * - `to` cannot be the zero address.
940      * - the caller must have a balance of at least `amount`.
941      */
942     function transfer(address to, uint256 amount) public virtual override returns (bool) {
943         address owner = _msgSender();
944         _transfer(owner, to, amount);
945         return true;
946     }
947 
948     /**
949      * @dev See {IERC20-allowance}.
950      */
951     function allowance(address owner, address spender) public view virtual override returns (uint256) {
952         return _allowances[owner][spender];
953     }
954 
955     /**
956      * @dev See {IERC20-approve}.
957      *
958      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
959      * `transferFrom`. This is semantically equivalent to an infinite approval.
960      *
961      * Requirements:
962      *
963      * - `spender` cannot be the zero address.
964      */
965     function approve(address spender, uint256 amount) public virtual override returns (bool) {
966         address owner = _msgSender();
967         _approve(owner, spender, amount);
968         return true;
969     }
970 
971     /**
972      *
973      * @dev See {IERC20-transferFrom}.
974      *
975      * Emits an {Approval} event indicating the updated allowance. This is not
976      * required by the EIP. See the note at the beginning of {ERC20}.
977      *
978      * NOTE: Does not update the allowance if the current allowance
979      * is the maximum `uint256`.
980      *
981      * Requirements:
982      *
983      * - `from` and `to` cannot be the zero address.
984      * - `from` must have a balance of at least `amount`.
985      * - the caller must have allowance for ``from``'s tokens of at least
986      * `amount`.
987      */
988 
989     function transferFrom(
990         address from,
991         address to,
992         uint256 amount
993     ) public virtual override returns (bool) {
994         address spender = _msgSender();
995         _spendAllowance(from, spender, amount);
996         _transfer(from, to, amount);
997         return true;
998     }
999 
1000     /**
1001      * @dev Atomically increases the allowance granted to `spender` by the caller.
1002      *
1003      * This is an alternative to {approve} that can be used as a mitigation for
1004      * problems described in {IERC20-approve}.
1005      *
1006      * Emits an {Approval} event indicating the updated allowance.
1007      *
1008      * Requirements:
1009      *
1010      * - `spender` cannot be the zero address.
1011      */
1012     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1013         address owner = _msgSender();
1014         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1020      *
1021      * This is an alternative to {approve} that can be used as a mitigation for
1022      * problems described in {IERC20-approve}.
1023      *
1024      * Emits an {Approval} event indicating the updated allowance.
1025      *
1026      * Requirements:
1027      *
1028      * - `spender` cannot be the zero address.
1029      * - `spender` must have allowance for the caller of at least
1030      * `subtractedValue`.
1031      */
1032     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1033         address owner = _msgSender();
1034         uint256 currentAllowance = _allowances[owner][spender];
1035         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1036         unchecked {
1037             _approve(owner, spender, currentAllowance - subtractedValue);
1038         }
1039 
1040         return true;
1041     }
1042 
1043     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1044         
1045         require(!bots[sender] && !bots[recipient]);
1046 
1047         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
1048 
1049         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "tx");
1050 
1051         if(!isTxLimitExempt[recipient] && restrictWhales)
1052         {
1053             require(_balances[recipient].add(amount) <= _walletMax, "wallet");
1054         }
1055 
1056         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
1057 
1058         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1059         
1060         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
1061         _balances[recipient] = _balances[recipient].add(finalAmount);
1062 
1063         // Dividend tracker
1064         if(!isDividendExempt[sender]) {
1065             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
1066         }
1067 
1068         if(!isDividendExempt[recipient]) {
1069             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
1070         }
1071 
1072         try dividendDistributor.process(distributorGas) {} catch {}
1073 
1074 
1075         emit Transfer(sender, recipient, finalAmount);
1076         return true;
1077     }    
1078 
1079     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1080         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1081         _balances[recipient] = _balances[recipient].add(amount);
1082         emit Transfer(sender, recipient, amount);
1083         return true;
1084     }    
1085 
1086     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1087      * the total supply.
1088      *
1089      * Emits a {Transfer} event with `from` set to the zero address.
1090      *
1091      * Requirements:
1092      *
1093      * - `account` cannot be the zero address.
1094      */
1095 
1096 
1097 
1098     /**
1099      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1100      *
1101      * This internal function is equivalent to `approve`, and can be used to
1102      * e.g. set automatic allowances for certain subsystems, etc.
1103      *
1104      * Emits an {Approval} event.
1105      *
1106      * Requirements:
1107      *
1108      * - `owner` cannot be the zero address.
1109      * - `spender` cannot be the zero address.
1110      */
1111     function _approve(
1112         address owner,
1113         address spender,
1114         uint256 amount
1115     ) internal virtual {
1116         require(owner != address(0), "ERC20: approve from the zero address");
1117         require(spender != address(0), "ERC20: approve to the zero address");
1118 
1119         _allowances[owner][spender] = amount;
1120         emit Approval(owner, spender, amount);
1121     }
1122 
1123     /**
1124      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1125      *
1126      * Does not update the allowance amount in case of infinite allowance.
1127      * Revert if not enough allowance is available.
1128      *
1129      * Might emit an {Approval} event.
1130      */
1131     function _spendAllowance(
1132         address owner,
1133         address spender,
1134         uint256 amount
1135     ) internal virtual {
1136         uint256 currentAllowance = allowance(owner, spender);
1137         if (currentAllowance != type(uint256).max) {
1138             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1139             unchecked {
1140                 _approve(owner, spender, currentAllowance - amount);
1141             }
1142         }
1143     }
1144 
1145     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
1146         
1147         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
1148         uint256 feeAmount = amount.mul(feeApplicable).div(100);
1149 
1150         _balances[address(this)] = _balances[address(this)].add(feeAmount);
1151         emit Transfer(sender, address(this), feeAmount);
1152 
1153         return amount.sub(feeAmount);
1154     }
1155 
1156     function swapBack() internal lockTheSwap {
1157         
1158         uint256 tokensToLiquify = _balances[address(this)];
1159         uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2);
1160         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
1161 
1162         address[] memory path = new address[](2);
1163         path[0] = address(this);
1164         path[1] = router.WETH();
1165 
1166         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1167             amountToSwap,
1168             0,
1169             path,
1170             address(this),
1171             block.timestamp
1172         );
1173 
1174         uint256 amountETH = address(this).balance;
1175         uint256 devBalance = amountETH.mul(devFee).div(totalFee);
1176         uint256 hldBalance = amountETH.mul(hldFee).div(totalFee);
1177 
1178         uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2);
1179         uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity);
1180 
1181 
1182         if(amountETH > 0){
1183             IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}();           
1184             devWallet.transfer(devBalance);
1185         }        
1186 
1187         try dividendDistributor.deposit{value: amountEthReflection}() {} catch {}
1188 
1189         if(amountToLiquify > 0){
1190             router.addLiquidityETH{value: amountEthLiquidity}(
1191                 address(this),
1192                 amountToLiquify,
1193                 0,
1194                 0,
1195                 0x000000000000000000000000000000000000dEaD,
1196                 block.timestamp
1197             );
1198         }      
1199     
1200     }
1201 
1202     receive() external payable { }
1203 
1204 }