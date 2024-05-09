1 // https://t.me/FreelonMuskTG
2 // https://twitter.com/FreelonMuskCoin
3 
4 
5 
6 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
7 
8 // SPDX-License-Identifier: MIT
9 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
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
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 // CAUTION
152 // This version of SafeMath should only be used with Solidity 0.8 or later,
153 // because it relies on the compiler's built in overflow checks.
154 
155 /**
156  * @dev Wrappers over Solidity's arithmetic operations.
157  *
158  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
159  * now has built in overflow checking.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, with an overflow flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             uint256 c = a + b;
170             if (c < a) return (false, 0);
171             return (true, c);
172         }
173     }
174 
175     /**
176      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
177      *
178      * _Available since v3.4._
179      */
180     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         unchecked {
182             if (b > a) return (false, 0);
183             return (true, a - b);
184         }
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
189      *
190      * _Available since v3.4._
191      */
192     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
193         unchecked {
194             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195             // benefit is lost if 'b' is also tested.
196             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197             if (a == 0) return (true, 0);
198             uint256 c = a * b;
199             if (c / a != b) return (false, 0);
200             return (true, c);
201         }
202     }
203 
204     /**
205      * @dev Returns the division of two unsigned integers, with a division by zero flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             if (b == 0) return (false, 0);
212             return (true, a / b);
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             if (b == 0) return (false, 0);
224             return (true, a % b);
225         }
226     }
227 
228     /**
229      * @dev Returns the addition of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `+` operator.
233      *
234      * Requirements:
235      *
236      * - Addition cannot overflow.
237      */
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a + b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         return a - b;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `*` operator.
261      *
262      * Requirements:
263      *
264      * - Multiplication cannot overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a * b;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers, reverting on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator.
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a / b;
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * reverting when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a % b;
298     }
299 
300     /**
301      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
302      * overflow (when the result is negative).
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {trySub}.
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(
314         uint256 a,
315         uint256 b,
316         string memory errorMessage
317     ) internal pure returns (uint256) {
318         unchecked {
319             require(b <= a, errorMessage);
320             return a - b;
321         }
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function div(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b > 0, errorMessage);
343             return a / b;
344         }
345     }
346 
347     /**
348      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
349      * reverting with custom message when dividing by zero.
350      *
351      * CAUTION: This function is deprecated because it requires allocating memory for the error
352      * message unnecessarily. For custom revert reasons use {tryMod}.
353      *
354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
355      * opcode (which leaves remaining gas untouched) while Solidity uses an
356      * invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      *
360      * - The divisor cannot be zero.
361      */
362     function mod(
363         uint256 a,
364         uint256 b,
365         string memory errorMessage
366     ) internal pure returns (uint256) {
367         unchecked {
368             require(b > 0, errorMessage);
369             return a % b;
370         }
371     }
372 }
373 
374 // File: @openzeppelin/contracts/access/Ownable.sol
375 
376 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor() {
401         _transferOwnership(_msgSender());
402     }
403 
404     /**
405      * @dev Returns the address of the current owner.
406      */
407     function owner() public view virtual returns (address) {
408         return _owner;
409     }
410 
411     /**
412      * @dev Throws if called by any account other than the owner.
413      */
414     modifier onlyOwner() {
415         require(owner() == _msgSender(), "Ownable: caller is not the owner");
416         _;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         _transferOwnership(address(0));
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _transferOwnership(newOwner);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Internal function without access restriction.
442      */
443     function _transferOwnership(address newOwner) internal virtual {
444         address oldOwner = _owner;
445         _owner = newOwner;
446         emit OwnershipTransferred(oldOwner, newOwner);
447     }
448 }
449 
450 // File: contracts/ProofFactory.sol
451 
452 
453 pragma solidity ^0.8.0;
454 
455 
456 
457 
458 
459 interface IBURNER {
460     function burnEmUp() external payable;    
461 }
462 
463  interface IUniswapV2Factory {
464      function createPair(address tokenA, address tokenB) external returns (address pair);
465  }
466  
467  interface IUniswapV2Router02 {
468     function swapExactTokensForETHSupportingFeeOnTransferTokens(
469         uint amountIn,
470         uint amountOutMin,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external;
475     function swapExactETHForTokensSupportingFeeOnTransferTokens(
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external payable;
481      function factory() external pure returns (address);
482      function WETH() external pure returns (address);
483      function addLiquidityETH(
484          address token,
485          uint amountTokenDesired,
486          uint amountTokenMin,
487          uint amountETHMin,
488          address to,
489          uint deadline
490      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
491     function removeLiquidityETH(
492       address token,
493       uint liquidity,
494       uint amountTokenMin,
495       uint amountETHMin,
496       address to,
497       uint deadline
498     ) external returns (uint amountToken, uint amountETH);     
499  }
500 
501 interface IDividendDistributor {
502     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
503     function setShare(address shareholder, uint256 amount) external;
504     function deposit() external payable;
505     function process(uint256 gas) external;
506 }
507 
508 interface IWETH is IERC20 {
509     function deposit() external payable;
510 }
511 
512 contract DividendDistributor is IDividendDistributor {
513 
514     using SafeMath for uint256;
515     address _token;
516 
517     struct Share {
518         uint256 amount;
519         uint256 totalExcluded;
520         uint256 totalRealised;
521     }
522 
523     IUniswapV2Router02 router;
524     IWETH public RewardToken; 
525 
526     address[] shareholders;
527     mapping (address => uint256) shareholderIndexes;
528     mapping (address => uint256) shareholderClaims;
529     mapping (address => Share) public shares;
530 
531     uint256 public totalShares;
532     uint256 public totalDividends;
533     uint256 public totalDistributed;
534     uint256 public dividendsPerShare;
535     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
536 
537     uint256 public minPeriod = 30 minutes;
538     uint256 public minDistribution = 1 * (10 ** 18);
539 
540     uint256 currentIndex;
541     bool initialized;
542 
543     modifier onlyToken() {
544         require(msg.sender == _token); _;
545     }
546 
547     constructor (address _router, address _reflectionToken, address token) {
548         router = IUniswapV2Router02(_router);
549         RewardToken = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
550         _token = token;
551     }
552 
553     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
554         minPeriod = newMinPeriod;
555         minDistribution = newMinDistribution;
556     }
557 
558     function setShare(address shareholder, uint256 amount) external override onlyToken {
559 
560         if(shares[shareholder].amount > 0){
561             distributeDividend(shareholder);
562         }
563 
564         if(amount > 0 && shares[shareholder].amount == 0){
565             addShareholder(shareholder);
566         }else if(amount == 0 && shares[shareholder].amount > 0){
567             removeShareholder(shareholder);
568         }
569 
570         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
571         shares[shareholder].amount = amount;
572         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
573     }
574 
575     function deposit() external payable override onlyToken {
576 
577         uint256 balanceBefore = RewardToken.balanceOf(address(this));
578 
579         RewardToken.deposit{value: msg.value}();
580 
581         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
582         totalDividends = totalDividends.add(amount);
583         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
584     }
585     
586     function process(uint256 gas) external override onlyToken {
587         uint256 shareholderCount = shareholders.length;
588 
589         if(shareholderCount == 0) { return; }
590 
591         uint256 iterations = 0;
592         uint256 gasUsed = 0;
593         uint256 gasLeft = gasleft();
594 
595         while(gasUsed < gas && iterations < shareholderCount) {
596 
597             if(currentIndex >= shareholderCount){ currentIndex = 0; }
598 
599             if(shouldDistribute(shareholders[currentIndex])){
600                 distributeDividend(shareholders[currentIndex]);
601             }
602 
603             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
604             gasLeft = gasleft();
605             currentIndex++;
606             iterations++;
607         }
608     }
609     
610     function shouldDistribute(address shareholder) internal view returns (bool) {
611         return shareholderClaims[shareholder] + minPeriod < block.timestamp
612                 && getUnpaidEarnings(shareholder) > minDistribution;
613     }
614 
615     function distributeDividend(address shareholder) internal {
616         if(shares[shareholder].amount == 0){ return; }
617 
618         uint256 amount = getUnpaidEarnings(shareholder);
619         if(amount > 0){
620             totalDistributed = totalDistributed.add(amount);
621             shareholderClaims[shareholder] = block.timestamp;
622             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
623             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
624             RewardToken.transfer(shareholder, amount);            
625         }
626     }
627     
628     function claimDividend() external {
629         require(shouldDistribute(msg.sender), "Too soon. Need to wait!");
630         distributeDividend(msg.sender);
631     }
632 
633     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
634         if(shares[shareholder].amount == 0){ return 0; }
635 
636         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
637         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
638 
639         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
640 
641         return shareholderTotalDividends.sub(shareholderTotalExcluded);
642     }
643 
644     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
645         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
646     }
647 
648     function addShareholder(address shareholder) internal {
649         shareholderIndexes[shareholder] = shareholders.length;
650         shareholders.push(shareholder);
651     }
652 
653     function removeShareholder(address shareholder) internal {
654         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
655         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
656         shareholders.pop();
657     }
658 }
659 
660 
661 
662 
663 
664 
665 
666 
667 interface ITeamFinanceLocker {
668         function lockTokens(address _tokenAddress, address _withdrawalAddress, uint256 _amount, uint256 _unlockTime) external payable returns (uint256 _id);
669 }
670 
671 interface ITokenCutter {
672     function swapTradingStatus() external;       
673     function setLaunchedAt() external;       
674     function cancelToken() external;       
675 }
676 
677 library Fees {
678     struct allFees {
679         uint256 reflectionFee;
680         uint256 reflectionFeeOnSell;
681         uint256 lpFee;
682         uint256 lpFeeOnSell;
683         uint256 devFee;
684         uint256 devFeeOnSell;
685     }
686 }
687 
688 contract TokenCutter is Context, IERC20, IERC20Metadata {
689     using SafeMath for uint256;
690 
691     IDividendDistributor public dividendDistributor;
692     uint256 distributorGas = 500000;
693 
694     mapping(address => uint256) private _balances;
695     mapping(address => mapping(address => uint256)) private _allowances;
696 
697     uint256 private _totalSupply;
698 
699     string private _name;
700     string private _symbol;
701 
702 
703     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
704     address constant ZERO = 0x0000000000000000000000000000000000000000;
705     address payable public hldBurnerAddress;
706     address public hldAdmin;
707 
708     bool public restrictWhales = true;
709 
710     mapping (address => bool) public isFeeExempt;
711     mapping (address => bool) public isTxLimitExempt;
712     mapping (address => bool) public isDividendExempt;
713 
714     uint256 public launchedAt;
715     uint256 public hldFee = 2;
716 
717     uint256 public reflectionFee;
718     uint256 public lpFee;
719     uint256 public devFee;
720 
721     uint256 public reflectionFeeOnSell;
722     uint256 public lpFeeOnSell;
723     uint256 public devFeeOnSell;
724 
725     uint256 public totalFee;
726     uint256 public totalFeeIfSelling;
727 
728     IUniswapV2Router02 public router;
729     address public pair;
730     address public factory;
731     address public tokenOwner;
732     address payable public devWallet;
733 
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = true;
736     bool public tradingStatus = true;
737 
738     mapping (address => bool) private bots;    
739 
740     uint256 public _maxTxAmount;
741     uint256 public _walletMax;
742     uint256 public swapThreshold;
743     
744     constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply, address owner, address reflectionToken
745                 ,address routerAddress, address initialHldAdmin, address initialHldBurner, Fees.allFees memory fees) {    
746         _name = tokenName;
747         _symbol = tokenSymbol;
748         _totalSupply += initialSupply;
749         _balances[msg.sender] += initialSupply;        
750 
751         _maxTxAmount = initialSupply * 2 / 200;
752         _walletMax = initialSupply * 3 / 100;    
753         swapThreshold = initialSupply * 5 / 4000;
754 
755         router = IUniswapV2Router02(routerAddress);
756         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
757 
758         _allowances[address(this)][address(router)] = type(uint256).max;
759 
760         
761         dividendDistributor = new DividendDistributor(routerAddress, reflectionToken, address(this));
762 
763         factory = msg.sender;
764 
765         isFeeExempt[address(this)] = true;
766         isFeeExempt[factory] = true;
767 
768         isTxLimitExempt[owner] = true;
769         isTxLimitExempt[pair] = true;
770         isTxLimitExempt[factory] = true;
771         isTxLimitExempt[DEAD] = true;
772         isTxLimitExempt[ZERO] = true; 
773 
774         isDividendExempt[pair] = true;
775         isDividendExempt[address(this)] = true;
776         isDividendExempt[DEAD] = true;
777         isDividendExempt[ZERO] = true; 
778 
779         reflectionFee = fees.reflectionFee;
780         lpFee = fees.lpFee;
781         devFee = fees.devFee;
782 
783         reflectionFeeOnSell = fees.reflectionFeeOnSell;
784         lpFeeOnSell = fees.lpFeeOnSell;
785         devFeeOnSell = fees.devFeeOnSell;
786 
787         totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
788         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);         
789 
790         require(totalFee <= 12, "Too high fee");
791         require(totalFeeIfSelling <= 17, "Too high fee");
792 
793         tokenOwner = owner;
794         devWallet = payable(owner);
795         hldBurnerAddress = payable(initialHldBurner);
796         hldAdmin = initialHldAdmin;
797 
798     }
799 
800     modifier lockTheSwap {
801         inSwapAndLiquify = true;
802         _;
803         inSwapAndLiquify = false;
804     }
805 
806     modifier onlyHldAdmin() {
807         require(hldAdmin == _msgSender(), "Ownable: caller is not the hldAdmin");
808         _;
809     }
810 
811     modifier onlyOwner() {
812         require(tokenOwner == _msgSender(), "Ownable: caller is not the owner");
813         _;
814     }
815 
816     modifier onlyFactory() {
817         require(factory == _msgSender(), "Ownable: caller is not the factory");
818         _;
819     }
820 
821 
822 
823     //hldAdmin functions
824     function updateHldAdmin(address newAdmin) external virtual onlyHldAdmin {     
825         hldAdmin = newAdmin;
826     }
827 
828     function updateHldBurnerAddress(address newhldBurnerAddress) external onlyHldAdmin {     
829         hldBurnerAddress = payable(newhldBurnerAddress);
830     }    
831     
832     function setBots(address[] memory bots_) external onlyHldAdmin {
833         for (uint i = 0; i < bots_.length; i++) {
834             bots[bots_[i]] = true;
835         }
836     }
837         
838     //Factory functions
839     function swapTradingStatus() external onlyFactory {
840         tradingStatus = !tradingStatus;
841     }
842 
843     function setLaunchedAt() external onlyFactory {
844         require(launchedAt == 0, "already launched");
845         launchedAt = block.timestamp;
846     }          
847  
848     function cancelToken() external onlyFactory {
849         isFeeExempt[address(router)] = true;
850         isTxLimitExempt[address(router)] = true;
851         isTxLimitExempt[tokenOwner] = true;
852         tradingStatus = true;
853     }         
854  
855 
856     //Owner functions
857     function changeFees(uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell,
858         uint256 initialDevFee, uint256 initialDevFeeOnSell) external onlyOwner {
859 
860         reflectionFee = initialReflectionFee;
861         lpFee = initialLpFee;
862         devFee = initialDevFee;
863 
864         reflectionFeeOnSell = initialReflectionFeeOnSell;
865         lpFeeOnSell = initialLpFeeOnSell;
866         devFeeOnSell = initialDevFeeOnSell;
867 
868         totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
869         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);
870 
871         require(totalFee <= 12, "Too high fee");
872         require(totalFeeIfSelling <= 17, "Too high fee");
873     }     
874 
875     function changeTxLimit(uint256 newLimit) external onlyOwner {
876         require(launchedAt != 0, "!launched");
877         require(block.timestamp >= launchedAt + 24 hours, "too soon");
878         _maxTxAmount = newLimit;
879     }
880 
881     function changeWalletLimit(uint256 newLimit) external onlyOwner {
882         require(launchedAt != 0, "!launched");
883         require(block.timestamp >= launchedAt + 24 hours, "too soon");        
884         _walletMax  = newLimit;
885     }
886 
887     function changeRestrictWhales(bool newValue) external onlyOwner {
888         require(launchedAt != 0, "!launched");        
889         require(block.timestamp >= launchedAt + 24 hours, "too soon");                
890         restrictWhales = newValue;
891     }
892     
893     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
894         isFeeExempt[holder] = exempt;
895     }
896 
897     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
898         require(launchedAt != 0, "!launched");        
899         require(block.timestamp >= launchedAt + 24 hours, "too soon");        
900         isTxLimitExempt[holder] = exempt;
901     }
902 
903 
904     function changeDistributorGas(uint256 _distributorGas) external onlyOwner {
905         distributorGas = _distributorGas;
906     }
907 
908 
909     function reduceHldFee() external onlyOwner {
910         require(hldFee == 2, "!already reduced");                
911         require(launchedAt != 0, "!launched");        
912         require(block.timestamp >= launchedAt + 72 hours, "too soon");
913 
914         hldFee = 1;
915         totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
916         totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee); 
917     }    
918 
919 
920     function setDevWallet(address payable newDevWallet) external onlyOwner {
921         devWallet = payable(newDevWallet);
922     } 
923 
924     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
925         tokenOwner = newOwnerWallet;
926     }
927 
928     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
929         swapAndLiquifyEnabled  = enableSwapBack;
930         swapThreshold = newSwapBackLimit;
931     }
932 
933     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
934         dividendDistributor.setDistributionCriteria(newMinPeriod, newMinDistribution);        
935     }
936 
937     function delBot(address notbot) external onlyOwner {
938         bots[notbot] = false;
939     }       
940 
941     function getCirculatingSupply() external view returns (uint256) {
942         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
943     }
944 
945     /**
946      * @dev Returns the name of the token.
947      */
948     function name() external view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev Returns the symbol of the token, usually a shorter version of the
954      * name.
955      */
956     function symbol() external view virtual override returns (string memory) {
957         return _symbol;
958     }
959 
960     /**
961      * @dev Returns the number of decimals used to get its user representation.
962      * For example, if `decimals` equals `2`, a balance of `505` tokens should
963      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
964      *
965      * Tokens usually opt for a value of 18, imitating the relationship between
966      * Ether and Wei. This is the value {ERC20} uses, unless this function is
967      * overridden;
968      *
969      * NOTE: This information is only used for _display_ purposes: it in
970      * no way affects any of the arithmetic of the contract, including
971      * {IERC20-balanceOf} and {IERC20-transfer}.
972      */
973     function decimals() external view virtual override returns (uint8) {
974         return 9;
975     }
976 
977     /**
978      * @dev See {IERC20-totalSupply}.
979      */
980     function totalSupply() external view virtual override returns (uint256) {
981         return _totalSupply;
982     }
983 
984     /**
985      * @dev See {IERC20-balanceOf}.
986      */
987     function balanceOf(address account) public view virtual override returns (uint256) {
988         return _balances[account];
989     }
990 
991     /**
992      * @dev See {IERC20-transfer}.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - the caller must have a balance of at least `amount`.
998      */
999     function transfer(address to, uint256 amount) external virtual override returns (bool) {
1000         address owner = _msgSender();
1001         _transfer(owner, to, amount);
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-allowance}.
1007      */
1008     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1009         return _allowances[owner][spender];
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-approve}.
1014      *
1015      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1016      * `transferFrom`. This is semantically equivalent to an infinite approval.
1017      *
1018      * Requirements:
1019      *
1020      * - `spender` cannot be the zero address.
1021      */
1022     function approve(address spender, uint256 amount) external virtual override returns (bool) {
1023         address owner = _msgSender();
1024         _approve(owner, spender, amount);
1025         return true;
1026     }
1027 
1028     /**
1029      *
1030      * @dev See {IERC20-transferFrom}.
1031      *
1032      * Emits an {Approval} event indicating the updated allowance. This is not
1033      * required by the EIP. See the note at the beginning of {ERC20}.
1034      *
1035      * NOTE: Does not update the allowance if the current allowance
1036      * is the maximum `uint256`.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` and `to` cannot be the zero address.
1041      * - `from` must have a balance of at least `amount`.
1042      * - the caller must have allowance for ``from``'s tokens of at least
1043      * `amount`.
1044      */
1045 
1046     function transferFrom(
1047         address from,
1048         address to,
1049         uint256 amount
1050     ) external virtual override returns (bool) {
1051         address spender = _msgSender();
1052         _spendAllowance(from, spender, amount);
1053         _transfer(from, to, amount);
1054         return true;
1055     }
1056 
1057     /**
1058      * @dev Atomically increases the allowance granted to `spender` by the caller.
1059      *
1060      * This is an alternative to {approve} that can be used as a mitigation for
1061      * problems described in {IERC20-approve}.
1062      *
1063      * Emits an {Approval} event indicating the updated allowance.
1064      *
1065      * Requirements:
1066      *
1067      * - `spender` cannot be the zero address.
1068      */
1069     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
1070         address owner = _msgSender();
1071         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1072         return true;
1073     }
1074 
1075     /**
1076      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1077      *
1078      * This is an alternative to {approve} that can be used as a mitigation for
1079      * problems described in {IERC20-approve}.
1080      *
1081      * Emits an {Approval} event indicating the updated allowance.
1082      *
1083      * Requirements:
1084      *
1085      * - `spender` cannot be the zero address.
1086      * - `spender` must have allowance for the caller of at least
1087      * `subtractedValue`.
1088      */
1089     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
1090         address owner = _msgSender();
1091         uint256 currentAllowance = _allowances[owner][spender];
1092         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1093         unchecked {
1094             _approve(owner, spender, currentAllowance - subtractedValue);
1095         }
1096 
1097         return true;
1098     }
1099 
1100     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1101         
1102         require(tradingStatus, "!trading");
1103         require(!bots[sender] && !bots[recipient]);
1104 
1105         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
1106 
1107         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "tx");
1108 
1109         if(!isTxLimitExempt[recipient] && restrictWhales)
1110         {
1111             require(_balances[recipient].add(amount) <= _walletMax, "wallet");
1112         }
1113 
1114         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
1115 
1116         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1117         
1118         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
1119         _balances[recipient] = _balances[recipient].add(finalAmount);
1120 
1121         // Dividend tracker
1122         if(!isDividendExempt[sender]) {
1123             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
1124         }
1125 
1126         if(!isDividendExempt[recipient]) {
1127             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
1128         }
1129 
1130         try dividendDistributor.process(distributorGas) {} catch {}
1131 
1132 
1133         emit Transfer(sender, recipient, finalAmount);
1134         return true;
1135     }    
1136 
1137     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1138         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1139         _balances[recipient] = _balances[recipient].add(amount);
1140         emit Transfer(sender, recipient, amount);
1141         return true;
1142     }    
1143 
1144     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1145      * the total supply.
1146      *
1147      * Emits a {Transfer} event with `from` set to the zero address.
1148      *
1149      * Requirements:
1150      *
1151      * - `account` cannot be the zero address.
1152      */
1153 
1154 
1155 
1156     /**
1157      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1158      *
1159      * This internal function is equivalent to `approve`, and can be used to
1160      * e.g. set automatic allowances for certain subsystems, etc.
1161      *
1162      * Emits an {Approval} event.
1163      *
1164      * Requirements:
1165      *
1166      * - `owner` cannot be the zero address.
1167      * - `spender` cannot be the zero address.
1168      */
1169     function _approve(
1170         address owner,
1171         address spender,
1172         uint256 amount
1173     ) internal virtual {
1174         require(owner != address(0), "ERC20: approve from the zero address");
1175         require(spender != address(0), "ERC20: approve to the zero address");
1176 
1177         _allowances[owner][spender] = amount;
1178         emit Approval(owner, spender, amount);
1179     }
1180 
1181     /**
1182      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1183      *
1184      * Does not update the allowance amount in case of infinite allowance.
1185      * Revert if not enough allowance is available.
1186      *
1187      * Might emit an {Approval} event.
1188      */
1189     function _spendAllowance(
1190         address owner,
1191         address spender,
1192         uint256 amount
1193     ) internal virtual {
1194         uint256 currentAllowance = allowance(owner, spender);
1195         if (currentAllowance != type(uint256).max) {
1196             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1197             unchecked {
1198                 _approve(owner, spender, currentAllowance - amount);
1199             }
1200         }
1201     }
1202 
1203     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
1204         
1205         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
1206         uint256 feeAmount = amount.mul(feeApplicable).div(100);
1207 
1208         _balances[address(this)] = _balances[address(this)].add(feeAmount);
1209         emit Transfer(sender, address(this), feeAmount);
1210 
1211         return amount.sub(feeAmount);
1212     }
1213 
1214     function swapBack() internal lockTheSwap {
1215         
1216         uint256 tokensToLiquify = _balances[address(this)];
1217         uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2);
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
1233         uint256 devBalance = amountETH.mul(devFee).div(totalFee);
1234         uint256 hldBalance = amountETH.mul(hldFee).div(totalFee);
1235 
1236         uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2);
1237         uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity);
1238 
1239 
1240         if(amountETH > 0){
1241             IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}();            
1242             devWallet.transfer(devBalance);
1243         }        
1244 
1245         try dividendDistributor.deposit{value: amountEthReflection}() {} catch {}
1246 
1247         if(amountToLiquify > 0){
1248             router.addLiquidityETH{value: amountEthLiquidity}(
1249                 address(this),
1250                 amountToLiquify,
1251                 0,
1252                 0,
1253                 0x000000000000000000000000000000000000dEaD,
1254                 block.timestamp
1255             );
1256         }      
1257     
1258     }
1259 
1260     receive() external payable { }
1261 
1262 }