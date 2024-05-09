1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 // CAUTION
150 // This version of SafeMath should only be used with Solidity 0.8 or later,
151 // because it relies on the compiler's built in overflow checks.
152 
153 /**
154  * @dev Wrappers over Solidity's arithmetic operations.
155  *
156  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
157  * now has built in overflow checking.
158  */
159 library SafeMath {
160     /**
161      * @dev Returns the addition of two unsigned integers, with an overflow flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             uint256 c = a + b;
168             if (c < a) return (false, 0);
169             return (true, c);
170         }
171     }
172 
173     /**
174      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
175      *
176      * _Available since v3.4._
177      */
178     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         unchecked {
180             if (b > a) return (false, 0);
181             return (true, a - b);
182         }
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         unchecked {
192             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193             // benefit is lost if 'b' is also tested.
194             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195             if (a == 0) return (true, 0);
196             uint256 c = a * b;
197             if (c / a != b) return (false, 0);
198             return (true, c);
199         }
200     }
201 
202     /**
203      * @dev Returns the division of two unsigned integers, with a division by zero flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         unchecked {
209             if (b == 0) return (false, 0);
210             return (true, a / b);
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
216      *
217      * _Available since v3.4._
218      */
219     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
220         unchecked {
221             if (b == 0) return (false, 0);
222             return (true, a % b);
223         }
224     }
225 
226     /**
227      * @dev Returns the addition of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `+` operator.
231      *
232      * Requirements:
233      *
234      * - Addition cannot overflow.
235      */
236     function add(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a + b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting on
242      * overflow (when the result is negative).
243      *
244      * Counterpart to Solidity's `-` operator.
245      *
246      * Requirements:
247      *
248      * - Subtraction cannot overflow.
249      */
250     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a - b;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      *
262      * - Multiplication cannot overflow.
263      */
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a * b;
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers, reverting on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator.
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a / b;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting when dividing by zero.
285      *
286      * Counterpart to Solidity's `%` operator. This function uses a `revert`
287      * opcode (which leaves remaining gas untouched) while Solidity uses an
288      * invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a % b;
296     }
297 
298     /**
299      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
300      * overflow (when the result is negative).
301      *
302      * CAUTION: This function is deprecated because it requires allocating memory for the error
303      * message unnecessarily. For custom revert reasons use {trySub}.
304      *
305      * Counterpart to Solidity's `-` operator.
306      *
307      * Requirements:
308      *
309      * - Subtraction cannot overflow.
310      */
311     function sub(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         unchecked {
317             require(b <= a, errorMessage);
318             return a - b;
319         }
320     }
321 
322     /**
323      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
324      * division by zero. The result is rounded towards zero.
325      *
326      * Counterpart to Solidity's `/` operator. Note: this function uses a
327      * `revert` opcode (which leaves remaining gas untouched) while Solidity
328      * uses an invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function div(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a / b;
342         }
343     }
344 
345     /**
346      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
347      * reverting with custom message when dividing by zero.
348      *
349      * CAUTION: This function is deprecated because it requires allocating memory for the error
350      * message unnecessarily. For custom revert reasons use {tryMod}.
351      *
352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
353      * opcode (which leaves remaining gas untouched) while Solidity uses an
354      * invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function mod(
361         uint256 a,
362         uint256 b,
363         string memory errorMessage
364     ) internal pure returns (uint256) {
365         unchecked {
366             require(b > 0, errorMessage);
367             return a % b;
368         }
369     }
370 }
371 
372 // File: @openzeppelin/contracts/access/Ownable.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * there is an account (an owner) that can be granted exclusive access to
382  * specific functions.
383  *
384  * By default, the owner account will be the one that deploys the contract. This
385  * can later be changed with {transferOwnership}.
386  *
387  * This module is used through inheritance. It will make available the modifier
388  * `onlyOwner`, which can be applied to your functions to restrict their use to
389  * the owner.
390  */
391 abstract contract Ownable is Context {
392     address private _owner;
393 
394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor() {
400         _transferOwnership(_msgSender());
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view virtual returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(owner() == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         _transferOwnership(address(0));
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Can only be called by the current owner.
432      */
433     function transferOwnership(address newOwner) public virtual onlyOwner {
434         require(newOwner != address(0), "Ownable: new owner is the zero address");
435         _transferOwnership(newOwner);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Internal function without access restriction.
441      */
442     function _transferOwnership(address newOwner) internal virtual {
443         address oldOwner = _owner;
444         _owner = newOwner;
445         emit OwnershipTransferred(oldOwner, newOwner);
446     }
447 }
448 
449 // File: contracts/BabyApe.sol
450 
451 
452 
453 
454 pragma solidity ^0.8.0;
455 
456 
457 
458 
459 
460 interface IBURNER {
461     function burnEmUp() external payable;    
462 }
463 
464  interface IUniswapV2Factory {
465      function createPair(address tokenA, address tokenB) external returns (address pair);
466  }
467  
468  interface IUniswapV2Router02 {
469     function swapExactTokensForETHSupportingFeeOnTransferTokens(
470         uint amountIn,
471         uint amountOutMin,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external;
476     function swapExactETHForTokensSupportingFeeOnTransferTokens(
477         uint amountOutMin,
478         address[] calldata path,
479         address to,
480         uint deadline
481     ) external payable;
482      function factory() external pure returns (address);
483      function WETH() external pure returns (address);
484      function addLiquidityETH(
485          address token,
486          uint amountTokenDesired,
487          uint amountTokenMin,
488          uint amountETHMin,
489          address to,
490          uint deadline
491      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
492     function removeLiquidityETH(
493       address token,
494       uint liquidity,
495       uint amountTokenMin,
496       uint amountETHMin,
497       address to,
498       uint deadline
499     ) external returns (uint amountToken, uint amountETH);     
500  }
501 
502 interface IDividendDistributor {
503     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
504     function setShare(address shareholder, uint256 amount) external;
505     function deposit() external payable;
506     function process(uint256 gas) external;
507 }
508 
509 
510 contract DividendDistributor is IDividendDistributor {
511 
512     using SafeMath for uint256;
513     address _token;
514 
515     struct Share {
516         uint256 amount;
517         uint256 totalExcluded;
518         uint256 totalRealised;
519     }
520 
521     IUniswapV2Router02 router;
522     IERC20 public RewardToken; 
523 
524     address[] shareholders;
525     mapping (address => uint256) shareholderIndexes;
526     mapping (address => uint256) shareholderClaims;
527     mapping (address => Share) public shares;
528 
529     uint256 public totalShares;
530     uint256 public totalDividends;
531     uint256 public totalDistributed;
532     uint256 public dividendsPerShare;
533     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
534 
535     uint256 public minPeriod = 30 minutes;
536     uint256 public minDistribution = 1 * (10 ** 18);
537 
538     uint256 public currentIndex;
539     bool initialized;
540 
541     modifier initialization() {
542         require(!initialized);
543         _;
544         initialized = true;
545     }
546 
547     modifier onlyToken() {
548         require(msg.sender == _token); _;
549     }
550 
551     constructor (address _router, address _reflectionToken, address token) {
552         router = IUniswapV2Router02(_router);
553         RewardToken = IERC20(_reflectionToken);
554         _token = token;
555     }
556 
557     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
558         minPeriod = newMinPeriod;
559         minDistribution = newMinDistribution;
560     }
561 
562     function setShare(address shareholder, uint256 amount) external override onlyToken {
563 
564         if(shares[shareholder].amount > 0){
565             distributeDividend(shareholder);
566         }
567 
568         if(amount > 0 && shares[shareholder].amount == 0){
569             addShareholder(shareholder);
570         }else if(amount == 0 && shares[shareholder].amount > 0){
571             removeShareholder(shareholder);
572         }
573 
574         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
575         shares[shareholder].amount = amount;
576         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
577     }
578 
579     function deposit() external payable override onlyToken {
580 
581         uint256 balanceBefore = RewardToken.balanceOf(address(this));
582 
583         address[] memory path = new address[](2);
584         path[0] = router.WETH();
585         path[1] = address(RewardToken);
586 
587         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
588             0,
589             path,
590             address(this),
591             block.timestamp
592         );
593 
594         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
595         totalDividends = totalDividends.add(amount);
596         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
597     }
598     
599     function process(uint256 gas) external override {
600         uint256 shareholderCount = shareholders.length;
601 
602         if(shareholderCount == 0) { return; }
603 
604         uint256 iterations = 0;
605         uint256 gasUsed = 0;
606         uint256 gasLeft = gasleft();
607 
608         while(gasUsed < gas && iterations < shareholderCount) {
609 
610             if(currentIndex >= shareholderCount){ currentIndex = 0; }
611 
612             if(shouldDistribute(shareholders[currentIndex])){
613                 distributeDividend(shareholders[currentIndex]);
614             }
615 
616             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
617             gasLeft = gasleft();
618             currentIndex++;
619             iterations++;
620         }
621     }
622     
623     function shouldDistribute(address shareholder) public view returns (bool) {
624         return shareholderClaims[shareholder] + minPeriod < block.timestamp
625                 && getUnpaidEarnings(shareholder) > minDistribution;
626     }
627 
628     function distributeDividend(address shareholder) internal {
629         if(shares[shareholder].amount == 0){ return; }
630 
631         uint256 amount = getUnpaidEarnings(shareholder);
632         if(amount > 0){
633             totalDistributed = totalDistributed.add(amount);
634             RewardToken.transfer(shareholder, amount);
635             shareholderClaims[shareholder] = block.timestamp;
636             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
637             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
638         }
639     }
640     
641     function claimDividend() external {
642         require(shouldDistribute(msg.sender), "Too soon. Need to wait!");
643         distributeDividend(msg.sender);
644     }
645 
646     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
647         if(shares[shareholder].amount == 0){ return 0; }
648 
649         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
650         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
651 
652         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
653 
654         return shareholderTotalDividends.sub(shareholderTotalExcluded);
655     }
656 
657     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
658         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
659     }
660 
661     function addShareholder(address shareholder) internal {
662         shareholderIndexes[shareholder] = shareholders.length;
663         shareholders.push(shareholder);
664     }
665 
666     function removeShareholder(address shareholder) internal {
667         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
668         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
669         shareholders.pop();
670     }
671 }
672 
673 
674 contract ApeInu is Context, IERC20, IERC20Metadata {
675     using SafeMath for uint256;
676 
677     IDividendDistributor public dividendDistributor;
678     uint256 public distributorGas = 50000;
679 
680     mapping(address => uint256) private _balances;
681     mapping(address => mapping(address => uint256)) private _allowances;
682 
683     uint256 private _totalSupply;
684 
685     string private _name;
686     string private _symbol;
687 
688 
689     address DEAD = 0x000000000000000000000000000000000000dEaD;
690     address ZERO = 0x0000000000000000000000000000000000000000;
691     address public hldAdmin;
692 
693     bool public restrictWhales = true;
694 
695     mapping (address => bool) public isFeeExempt;
696     mapping (address => bool) public isTxLimitExempt;
697     mapping (address => bool) public isDividendExempt;
698 
699     uint256 public launchedAt;
700     address public lpWallet = DEAD;
701 
702     uint256 public reflectionFee;
703     uint256 public lpFee;
704     uint256 public devFee;
705 
706     uint256 public reflectionFeeOnSell;
707     uint256 public lpFeeOnSell;
708     uint256 public devFeeOnSell;
709 
710     uint256 public totalFee;
711     uint256 public totalFeeIfSelling;
712 
713     IUniswapV2Router02 public router;
714     address public pair;
715     address public factory;
716     address public tokenOwner;
717     address payable public devWallet;
718 
719     bool inSwapAndLiquify;
720     bool public swapAndLiquifyEnabled = true;
721     bool public tradingStatus = true;
722 
723     mapping (address => bool) private bots;    
724 
725     uint256 public _maxTxAmount;
726     uint256 public _walletMax;
727     uint256 public swapThreshold;
728     bool public tradingActive = false;
729     bool private restrictBots = true;
730     uint256 public tradingActiveBlock = 0;
731     event EnabledTrading(bool tradingActive);
732     event TransferForeignToken(address token, uint256 amount);
733     
734     constructor(uint256 initialSupply, address reflectionToken, address routerAddress, address initialHldAdmin) {
735 
736         _name = "Ape Inu";
737         _symbol = "APEINU";
738         _totalSupply += initialSupply;
739         _balances[msg.sender] += initialSupply;        
740 
741         _maxTxAmount = initialSupply * 1 / 400;
742         _walletMax = initialSupply * 1 / 200;
743         swapThreshold = initialSupply * 5 / 4000;
744 
745      
746 
747         router = IUniswapV2Router02(routerAddress);
748         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
749 
750         _allowances[address(this)][address(router)] = type(uint256).max;
751 
752         dividendDistributor = new DividendDistributor(routerAddress, reflectionToken, address(this));
753 
754         factory = msg.sender;
755 
756         isFeeExempt[address(this)] = true;
757         isFeeExempt[factory] = true;
758 
759         isTxLimitExempt[msg.sender] = true;
760         isTxLimitExempt[pair] = true;
761         isTxLimitExempt[factory] = true;
762         isTxLimitExempt[DEAD] = true;
763         isTxLimitExempt[ZERO] = true; 
764 
765         isDividendExempt[pair] = true;
766         isDividendExempt[address(this)] = true;
767         isDividendExempt[DEAD] = true;
768         isDividendExempt[ZERO] = true;
769 
770 
771         reflectionFee = 3;
772         lpFee = 3;
773         devFee = 5;
774 
775         reflectionFeeOnSell = 10;
776         lpFeeOnSell = 8;
777         devFeeOnSell = 10;
778 
779         totalFee = devFee.add(lpFee).add(reflectionFee);
780         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell);        
781 
782         tokenOwner = msg.sender;
783         devWallet = payable(msg.sender);
784         hldAdmin = initialHldAdmin;
785 
786     }
787 
788     modifier lockTheSwap {
789         inSwapAndLiquify = true;
790         _;
791         inSwapAndLiquify = false;
792     }
793 
794     modifier onlyHldAdmin() {
795         require(hldAdmin == _msgSender(), "Ownable: caller is not the hldAdmin");
796         _;
797     }
798 
799     modifier onlyOwner() {
800         require(tokenOwner == _msgSender(), "Ownable: caller is not the owner");
801         _;
802     }
803 
804     //hldAdmin functions
805     function updateHldAdmin(address newAdmin) public virtual onlyHldAdmin {     
806         hldAdmin = newAdmin;
807     }
808 
809     function setBots(address[] memory bots_) external onlyHldAdmin {
810         for (uint i = 0; i < bots_.length; i++) {
811             bots[bots_[i]] = true;
812         }
813     }
814 
815     //Owner functions
816     function changeFees(uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell,
817         uint256 initialDevFee, uint256 initialDevFeeOnSell) external onlyOwner {
818 
819         reflectionFee = initialReflectionFee;
820         lpFee = initialLpFee;
821         devFee = initialDevFee;
822 
823         reflectionFeeOnSell = initialReflectionFeeOnSell;
824         lpFeeOnSell = initialLpFeeOnSell;
825         devFeeOnSell = initialDevFeeOnSell;
826 
827         totalFee = devFee.add(lpFee).add(reflectionFee);
828         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell);
829 
830         require(totalFee <= 15, "Too high fee");
831         require(totalFeeIfSelling <= 30, "Too high fee");
832     }
833 
834     function removeHldAdmin() public virtual onlyOwner {
835         hldAdmin = address(0);
836     }
837 
838     function changeTxLimit(uint256 newLimit) external onlyOwner {
839         _maxTxAmount = newLimit;
840     }
841 
842     function changeWalletLimit(uint256 newLimit) external onlyOwner {
843         _walletMax  = newLimit;
844     }
845 
846     function multiTransfer(address[] calldata addresses, uint256 tokens) external onlyOwner {
847 
848         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); 
849 
850         uint256 SCCC = tokens* 10**decimals() * addresses.length;
851 
852         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
853 
854         for(uint i=0; i < addresses.length; i++){
855             _transfer(msg.sender,addresses[i],(tokens* 10**decimals()));
856             }
857     }
858 
859     function changeRestrictWhales(bool newValue) external onlyOwner {            
860         restrictWhales = newValue;
861     }
862     
863     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
864         isFeeExempt[holder] = exempt;
865     }
866 
867     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
868         isTxLimitExempt[holder] = exempt;
869     }
870 
871      function enableTrading(bool _status) external onlyOwner {
872         require(!tradingActive, "Cannot re enable trading");
873         tradingActive = _status;
874         emit EnabledTrading(tradingActive);
875         if (tradingActive && tradingActiveBlock == 0) {
876             tradingActiveBlock = block.number;
877         }
878     }
879 
880     function updateRestrictBots(bool _status) external onlyOwner {
881        restrictBots = _status;
882     }
883 
884 
885     function setDevWallet(address payable newDevWallet) external onlyOwner {
886         devWallet = payable(newDevWallet);
887     }
888 
889     function setLpWallet(address newLpWallet) external onlyOwner {
890         lpWallet = newLpWallet;
891     }    
892 
893     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
894         tokenOwner = newOwnerWallet;
895     }     
896 
897     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
898         swapAndLiquifyEnabled  = enableSwapBack;
899         swapThreshold = newSwapBackLimit;
900     }
901 
902     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
903         dividendDistributor.setDistributionCriteria(newMinPeriod, newMinDistribution);        
904     }
905 
906     function delBot(address notbot) external onlyOwner {
907         bots[notbot] = false;
908     }
909 
910     function changeDistributorGas(uint256 _distributorGas) external onlyOwner {
911         distributorGas = _distributorGas;
912     }           
913 
914     function getCirculatingSupply() public view returns (uint256) {
915         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
916     }
917 
918     /**
919      * @dev Returns the name of the token.
920      */
921     function name() public view virtual override returns (string memory) {
922         return _name;
923     }
924 
925     /**
926      * @dev Returns the symbol of the token, usually a shorter version of the
927      * name.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev Returns the number of decimals used to get its user representation.
935      * For example, if `decimals` equals `2`, a balance of `505` tokens should
936      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
937      *
938      * Tokens usually opt for a value of 18, imitating the relationship between
939      * Ether and Wei. This is the value {ERC20} uses, unless this function is
940      * overridden;
941      *
942      * NOTE: This information is only used for _display_ purposes: it in
943      * no way affects any of the arithmetic of the contract, including
944      * {IERC20-balanceOf} and {IERC20-transfer}.
945      */
946     function decimals() public view virtual override returns (uint8) {
947         return 9;
948     }
949 
950     /**
951      * @dev See {IERC20-totalSupply}.
952      */
953     function totalSupply() public view virtual override returns (uint256) {
954         return _totalSupply;
955     }
956 
957     /**
958      * @dev See {IERC20-balanceOf}.
959      */
960     function balanceOf(address account) public view virtual override returns (uint256) {
961         return _balances[account];
962     }
963 
964     /**
965      * @dev See {IERC20-transfer}.
966      *
967      * Requirements:
968      *
969      * - `to` cannot be the zero address.
970      * - the caller must have a balance of at least `amount`.
971      */
972     function transfer(address to, uint256 amount) public virtual override returns (bool) {
973         _transfer(_msgSender(), to, amount);
974         return true;
975     }
976 
977     /**
978      * @dev See {IERC20-allowance}.
979      */
980     function allowance(address owner, address spender) public view virtual override returns (uint256) {
981         return _allowances[owner][spender];
982     }
983 
984     /**
985      * @dev See {IERC20-approve}.
986      *
987      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
988      * `transferFrom`. This is semantically equivalent to an infinite approval.
989      *
990      * Requirements:
991      *
992      * - `spender` cannot be the zero address.
993      */
994     function approve(address spender, uint256 amount) public virtual override returns (bool) {
995         address owner = _msgSender();
996         _approve(owner, spender, amount);
997         return true;
998     }
999 
1000     /**
1001      *
1002      * @dev See {IERC20-transferFrom}.
1003      *
1004      * Emits an {Approval} event indicating the updated allowance. This is not
1005      * required by the EIP. See the note at the beginning of {ERC20}.
1006      *
1007      * NOTE: Does not update the allowance if the current allowance
1008      * is the maximum `uint256`.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` and `to` cannot be the zero address.
1013      * - `from` must have a balance of at least `amount`.
1014      * - the caller must have allowance for ``from``'s tokens of at least
1015      * `amount`.
1016      */
1017 
1018     function transferFrom(
1019         address from,
1020         address to,
1021         uint256 amount
1022     ) public virtual override returns (bool) {
1023         address spender = _msgSender();
1024         _spendAllowance(from, spender, amount);
1025         _transfer(from, to, amount);
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Atomically increases the allowance granted to `spender` by the caller.
1031      *
1032      * This is an alternative to {approve} that can be used as a mitigation for
1033      * problems described in {IERC20-approve}.
1034      *
1035      * Emits an {Approval} event indicating the updated allowance.
1036      *
1037      * Requirements:
1038      *
1039      * - `spender` cannot be the zero address.
1040      */
1041     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1042         address owner = _msgSender();
1043         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1044         return true;
1045     }
1046 
1047     /**
1048      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1049      *
1050      * This is an alternative to {approve} that can be used as a mitigation for
1051      * problems described in {IERC20-approve}.
1052      *
1053      * Emits an {Approval} event indicating the updated allowance.
1054      *
1055      * Requirements:
1056      *
1057      * - `spender` cannot be the zero address.
1058      * - `spender` must have allowance for the caller of at least
1059      * `subtractedValue`.
1060      */
1061     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1062         address owner = _msgSender();
1063         uint256 currentAllowance = _allowances[owner][spender];
1064         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1065         unchecked {
1066             _approve(owner, spender, currentAllowance - subtractedValue);
1067         }
1068 
1069         return true;
1070     }  
1071 
1072     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1073         
1074         require(!bots[sender] && !bots[recipient]);
1075     
1076         if(!tradingActive){
1077               require(sender == hldAdmin, "Trading is enabled");
1078         }
1079 
1080         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
1081 
1082         if(restrictBots && tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
1083         
1084         }
1085         else{
1086 
1087             require(amount <= _maxTxAmount || isTxLimitExempt[sender], "tx");
1088             if(!isTxLimitExempt[recipient] && restrictWhales)
1089             {
1090                 require(_balances[recipient].add(amount) <= _walletMax, "wallet");
1091             }
1092         }
1093 
1094         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
1095 
1096         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1097         
1098         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
1099         
1100         _balances[recipient] = _balances[recipient].add(finalAmount);
1101         // Dividend tracker
1102         if(!isDividendExempt[sender]) {
1103             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
1104         }
1105 
1106         if(!isDividendExempt[recipient]) {
1107             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
1108         }
1109 
1110         if (distributorGas > 0) {
1111             try dividendDistributor.process(distributorGas) {} catch {}
1112         }
1113 
1114         emit Transfer(sender, recipient, finalAmount);
1115         return true;
1116     }    
1117 
1118     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1119         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1120         _balances[recipient] = _balances[recipient].add(amount);
1121         emit Transfer(sender, recipient, amount);
1122         return true;
1123     }    
1124 
1125     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1126      * the total supply.
1127      *
1128      * Emits a {Transfer} event with `from` set to the zero address.
1129      *
1130      * Requirements:
1131      *
1132      * - `account` cannot be the zero address.
1133      */
1134 
1135 
1136 
1137     /**
1138      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1139      *
1140      * This internal function is equivalent to `approve`, and can be used to
1141      * e.g. set automatic allowances for certain subsystems, etc.
1142      *
1143      * Emits an {Approval} event.
1144      *
1145      * Requirements:
1146      *
1147      * - `owner` cannot be the zero address.
1148      * - `spender` cannot be the zero address.
1149      */
1150     function _approve(
1151         address owner,
1152         address spender,
1153         uint256 amount
1154     ) internal virtual {
1155         require(owner != address(0), "ERC20: approve from the zero address");
1156         require(spender != address(0), "ERC20: approve to the zero address");
1157 
1158         _allowances[owner][spender] = amount;
1159         emit Approval(owner, spender, amount);
1160     }
1161 
1162     /**
1163      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1164      *
1165      * Does not update the allowance amount in case of infinite allowance.
1166      * Revert if not enough allowance is available.
1167      *
1168      * Might emit an {Approval} event.
1169      */
1170     function _spendAllowance(
1171         address owner,
1172         address spender,
1173         uint256 amount
1174     ) internal virtual {
1175         uint256 currentAllowance = allowance(owner, spender);
1176         if (currentAllowance != type(uint256).max) {
1177             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1178             unchecked {
1179                 _approve(owner, spender, currentAllowance - amount);
1180             }
1181         }
1182     }
1183 
1184     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
1185         
1186         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
1187 
1188         //restrictbots
1189         if(restrictBots && tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
1190             feeApplicable=90;
1191         }
1192 
1193         uint256 feeAmount = amount.mul(feeApplicable).div(100);
1194 
1195         _balances[address(this)] = _balances[address(this)].add(feeAmount);
1196         emit Transfer(sender, address(this), feeAmount);
1197 
1198         return amount.sub(feeAmount);
1199     }
1200 
1201 
1202 
1203     function swapBack() internal lockTheSwap {
1204     
1205         uint256 tokensToLiquify = _balances[address(this)];
1206 
1207         uint256 amountToLiquify;
1208         uint256 devBalance;
1209         uint256 amountEthLiquidity;        
1210 
1211         // Use sell ratios if buy tax too low
1212         if (totalFee <= 2) {
1213             amountToLiquify = tokensToLiquify.mul(lpFeeOnSell).div(totalFeeIfSelling).div(2);
1214         } else {
1215             amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2);                 
1216         }
1217 
1218         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
1219 
1220         address[] memory path = new address[](2);
1221         path[0] = address(this);
1222         path[1] = router.WETH();
1223 
1224         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1225             amountToSwap,
1226             0,
1227             path,
1228             address(this),
1229             block.timestamp
1230         );
1231 
1232         uint256 amountETH = address(this).balance;
1233 
1234         // Use sell ratios if buy tax too low
1235         if (totalFee <= 2) {
1236             devBalance = amountETH.mul(devFeeOnSell).div(totalFeeIfSelling);
1237             amountEthLiquidity = amountETH.mul(lpFeeOnSell).div(totalFeeIfSelling).div(2);
1238 
1239         } else {
1240             devBalance = amountETH.mul(devFee).div(totalFee);
1241             amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2);            
1242         }
1243 
1244         uint256 amountEthReflection = amountETH.sub(devBalance).sub(amountEthLiquidity);
1245 
1246         if(amountETH > 0){       
1247             devWallet.transfer(devBalance);
1248         }        
1249 
1250         try dividendDistributor.deposit{value: amountEthReflection}() {} catch {}
1251 
1252         if(amountToLiquify > 0){
1253             router.addLiquidityETH{value: amountEthLiquidity}(
1254                 address(this),
1255                 amountToLiquify,
1256                 0,
1257                 0,
1258                 lpWallet,
1259                 block.timestamp
1260             );
1261         }      
1262     
1263     }
1264 
1265      function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
1266         require(_token != address(0), "_token address cannot be 0");
1267         require(_token != address(this), "Can't withdraw native tokens");
1268         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1269         _sent = IERC20(_token).transfer(_to, _contractBalance);
1270         emit TransferForeignToken(_token, _contractBalance);
1271     }
1272 
1273     // withdraw ETH if stuck or someone sends to the address
1274     function withdrawStuckETH() external onlyOwner {
1275         bool success;
1276         (success,) = address(msg.sender).call{value: address(this).balance}("");
1277     }
1278 
1279 
1280     receive() external payable { }
1281 
1282 }