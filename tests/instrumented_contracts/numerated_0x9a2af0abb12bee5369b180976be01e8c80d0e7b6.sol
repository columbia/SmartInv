1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Context.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Provides information about the current execution context, including the
240  * sender of the transaction and its data. While these are generally available
241  * via msg.sender and msg.data, they should not be accessed in such a direct
242  * manner, since when dealing with meta-transactions the account sending and
243  * paying for execution may not be the actual sender (as far as an application
244  * is concerned).
245  *
246  * This contract is only required for intermediate, library-like contracts.
247  */
248 abstract contract Context {
249     function _msgSender() internal view virtual returns (address) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view virtual returns (bytes calldata) {
254         return msg.data;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/access/Ownable.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 
266 /**
267  * @dev Contract module which provides a basic access control mechanism, where
268  * there is an account (an owner) that can be granted exclusive access to
269  * specific functions.
270  *
271  * By default, the owner account will be the one that deploys the contract. This
272  * can later be changed with {transferOwnership}.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 abstract contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor() {
287         _transferOwnership(_msgSender());
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         _checkOwner();
295         _;
296     }
297 
298     /**
299      * @dev Returns the address of the current owner.
300      */
301     function owner() public view virtual returns (address) {
302         return _owner;
303     }
304 
305     /**
306      * @dev Throws if the sender is not the owner.
307      */
308     function _checkOwner() internal view virtual {
309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         _transferOwnership(address(0));
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         _transferOwnership(newOwner);
330     }
331 
332     /**
333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
334      * Internal function without access restriction.
335      */
336     function _transferOwnership(address newOwner) internal virtual {
337         address oldOwner = _owner;
338         _owner = newOwner;
339         emit OwnershipTransferred(oldOwner, newOwner);
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
344 
345 
346 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Emitted when `value` tokens are moved from one account (`from`) to
356      * another (`to`).
357      *
358      * Note that `value` may be zero.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 value);
361 
362     /**
363      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
364      * a call to {approve}. `value` is the new allowance.
365      */
366     event Approval(address indexed owner, address indexed spender, uint256 value);
367 
368     /**
369      * @dev Returns the amount of tokens in existence.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     /**
374      * @dev Returns the amount of tokens owned by `account`.
375      */
376     function balanceOf(address account) external view returns (uint256);
377 
378     /**
379      * @dev Moves `amount` tokens from the caller's account to `to`.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transfer(address to, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender) external view returns (uint256);
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * IMPORTANT: Beware that changing an allowance with this method brings the risk
402      * that someone may use both the old and the new allowance by unfortunate
403      * transaction ordering. One possible solution to mitigate this race
404      * condition is to first reduce the spender's allowance to 0 and set the
405      * desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address spender, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Moves `amount` tokens from `from` to `to` using the
414      * allowance mechanism. `amount` is then deducted from the caller's
415      * allowance.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 amount
425     ) external returns (bool);
426 }
427 
428 // File: contracts/35_EmpireToken.sol
429 
430 
431 
432 pragma solidity 0.8.15;
433 
434 
435 
436 
437 
438 
439 
440 interface IUniswapV2Factory {
441     function createPair(address tokenA, address tokenB)
442         external
443         returns (address pair);
444 }
445 
446 interface IUniswapV2Router01 {
447     function factory() external pure returns (address);
448 
449     function WETH() external pure returns (address);
450 
451     function addLiquidityETH(
452         address token,
453         uint256 amountTokenDesired,
454         uint256 amountTokenMin,
455         uint256 amountETHMin,
456         address to,
457         uint256 deadline
458     )
459         external
460         payable
461         returns (
462             uint256 amountToken,
463             uint256 amountETH,
464             uint256 liquidity
465         );
466 }
467 
468 interface IUniswapV2Router02 is IUniswapV2Router01 {
469     function swapExactTokensForETHSupportingFeeOnTransferTokens(
470         uint256 amountIn,
471         uint256 amountOutMin,
472         address[] calldata path,
473         address to,
474         uint256 deadline
475     ) external;
476 }
477 
478 contract EmpireToken is IERC20, Ownable{
479     using SafeMath for uint256;
480 
481     mapping(address => uint256) private _rOwned;
482     mapping(address => uint256) private _tOwned;
483     mapping(address => mapping(address => uint256)) private _allowances;
484 
485     mapping(address => bool) public automatedMarketMakerPairs;
486 
487     mapping(address => bool) private _isExcludedFromFee;
488 
489     mapping(address => bool) private _isExcluded;
490     address[] private _excluded;
491 
492     struct BuyFee {
493         uint256 autoLp;
494         uint256 burn;
495         uint256 marketing;
496         uint256 tax;
497         uint256 team;
498     }
499 
500     struct SellFee {
501         uint256 autoLp;
502         uint256 burn;
503         uint256 marketing;
504         uint256 tax;
505         uint256 team;
506     }
507 
508     BuyFee public buyFee;
509     SellFee public sellFee;
510 
511     uint256 private constant MAX = ~uint256(0);
512     uint256 private constant _tTotal = 10**9 * 10**9;
513     uint256 private _rTotal = (MAX - (MAX % _tTotal));
514     uint256 private _tFeeTotal;
515 
516     string private constant _name = "Empire Token";
517     string private constant _symbol = "EMPIRE";
518     uint8 private constant _decimals = 9;
519 
520     uint256 public _taxFee = 0;
521     uint256 public _liquidityFee = 0;
522     uint256 public _burnFee = 0;
523     uint256 public _marketingFee = 0;
524     uint256 public _teamFee = 0;
525 
526     address public marketingWallet;
527     address public immutable burnWallet;
528     address public liquidityWallet;
529     address public teamWallet;
530 
531     // to accommodate lock or unlock balance by bridge
532     address public bridgeVault;
533 
534     IUniswapV2Router02 public uniswapV2Router;
535 
536     address public bridge;
537 
538     bool private inSwapAndLiquify;
539     bool private shouldTakeFee = false;
540     bool public swapAndLiquifyEnabled = true;
541     bool public isTradingEnabled;
542 
543     uint256 public numTokensSellToAddToLiquidity = 8000 * 10**9;
544 
545     event LogSetAutomatedMarketMakerPair(
546         address indexed setter,
547         address pair,
548         bool enabled
549     );
550     event LogSwapAndLiquify(
551         uint256 tokensSwapped,
552         uint256 ethReceived,
553         uint256 tokensIntoLiquidity
554     );
555     event LogSwapAndDistribute(
556         uint256 forMarketing,
557         uint256 forLiquidity,
558         uint256 forBurn,
559         uint256 forTeam
560     );
561     event LogSwapAndLiquifyEnabledUpdated(address indexed setter, bool enabled);
562     event LogSetBridge(address indexed setter, address bridge);
563     event LogSetSwapTokensAmount(address indexed setter, uint256 amount);
564     event LogSetExcludeFromFee(
565         address indexed setter,
566         address account,
567         bool enabled
568     );
569     event LogTransfer(address from, address to, uint amount);
570     event LogExcludeFromReward(address indexed account);
571     event LogIncludeInReward(address indexed account);
572     event LogFallback(address from, uint256 amount);
573     event LogReceive(address from, uint256 amount);
574     event LogSetEnableTrading(bool enabled);
575     event LogSetMarketingWallet(
576         address indexed setter,
577         address marketingWallet
578     );
579     
580     event LogSetTeamWallet(address indexed setter, address teamWallet);
581     event LogSetBuyFees(address indexed setter, BuyFee buyFee);
582     event LogSetSellFees(address indexed setter, SellFee sellFee);
583     event LogSetRouterAddress(address indexed setter, address router);
584     event LogUpdateLiquidityWallet(
585         address indexed setter,
586         address liquidityWallet
587     );
588     event LogWithdrawalETH(address indexed recipient, uint256 amount);
589     event LogWithdrawToken(
590         address indexed token,
591         address indexed recipient,
592         uint256 amount
593     );
594     event LogWithdrawal(address indexed recipient, uint256 tAmount);
595     event LogLockByBridge(address indexed account, uint256 tAmount);
596     event LogUnlockByBridge(address indexed account, uint256 tAmount);
597     event LogSetBridgeVault(address setter, address _bridgeVault);
598     event LogDeliver(address indexed from, uint256 tAmount);
599 
600 
601     modifier lockTheSwap() {
602         inSwapAndLiquify = true;
603         _;
604         inSwapAndLiquify = false;
605     }
606 
607     constructor(
608         address _router,
609         address _marketingWallet,
610         address _teamWallet,
611         address _bridgeVault
612     ) payable {
613         _rOwned[_msgSender()] = _rTotal;
614         
615         require(_router!=address(0) &&  _marketingWallet!=address(0) && _teamWallet!=address(0) && _bridgeVault!=address(0), "Zero address");
616 
617         marketingWallet = _marketingWallet;
618         burnWallet = address(0xdead);
619         liquidityWallet = owner();
620         teamWallet = _teamWallet;
621 
622         // exclude bridge Vault from receive reflection
623         bridgeVault = _bridgeVault;
624         _isExcluded[bridgeVault] = true;
625         _excluded.push(bridgeVault);
626 
627 
628         // exclude burn address from receive reflection
629         _isExcluded[burnWallet] = true;
630         _excluded.push(burnWallet);
631 
632 
633         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
634         // Create a uniswap pair for this new token
635         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
636             address(this),
637             _uniswapV2Router.WETH()
638         );
639 
640         setAutomatedMarketMakerPair(pair, true);
641 
642         // set the rest of the contract variables
643         uniswapV2Router = _uniswapV2Router;
644 
645         _isExcludedFromFee[address(this)] = true;
646         _isExcludedFromFee[owner()] = true;
647 
648         buyFee.autoLp = 4;
649         buyFee.burn = 0;
650         buyFee.marketing = 3;
651         buyFee.tax = 2;
652         buyFee.team = 1;
653 
654         sellFee.autoLp = 4;
655         sellFee.burn = 0;
656         sellFee.marketing = 3;
657         sellFee.tax = 2;
658         sellFee.team = 1;
659 
660         emit Transfer(address(0), _msgSender(), _tTotal);
661     }
662 
663     function setAutomatedMarketMakerPair(address pair, bool enabled)
664         public
665         onlyOwner
666     {   
667         require(automatedMarketMakerPairs[pair] != enabled, "Pair Already Enabled");
668         automatedMarketMakerPairs[pair] = enabled;
669 
670         emit LogSetAutomatedMarketMakerPair(msg.sender, pair, enabled);
671     }
672 
673     function name() external view returns (string memory) {
674         return _name;
675     }
676 
677     function symbol() external view returns (string memory) {
678         return _symbol;
679     }
680 
681     function decimals() external view returns (uint8) {
682         return _decimals;
683     }
684 
685     function totalSupply() external view override returns (uint256) {
686         return _tTotal;
687     }
688 
689     /**
690      * @dev because bridgeVault not receive reward
691      */
692     function circulatingSupply() external view returns (uint256) {
693         return _tTotal.sub(_tOwned[bridgeVault]).sub(_tOwned[burnWallet]);
694     }
695 
696     /**
697      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
698      * overflow (when the result is negative). Referenced from SafeMath library to preserve transaction integrity.
699      */
700     function balanceCheck(
701         uint256 a,
702         uint256 b,
703         string memory errorMessage
704     ) internal pure returns (uint256) {
705         require(b <= a, errorMessage);
706         uint256 c = a.sub(b);
707 
708         return c;
709     }
710 
711     function balanceOf(address account) public view override returns (uint256) {
712         if (_isExcluded[account]) return _tOwned[account];
713         return tokenFromReflection(_rOwned[account]);
714     }
715 
716     function transfer(address recipient, uint256 amount) 
717         external
718         override
719         returns (bool)
720     {
721 
722         _transfer(_msgSender(), recipient, amount);
723         emit LogTransfer(_msgSender(), recipient, amount);
724         return true;
725     }
726 
727     function allowance(address owner, address spender)
728         external
729         view
730         override
731         returns (uint256)
732     {
733         return _allowances[owner][spender];
734     }
735 
736     function approve(address spender, uint256 amount)
737         external
738         override
739         returns (bool)
740     {
741         _approve(_msgSender(), spender, amount);
742         return true;
743     }
744 
745     function transferFrom(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) external override returns (bool) {
750         _transfer(sender, recipient, amount);
751         _approve(
752             sender,
753             _msgSender(),
754             balanceCheck(
755                 _allowances[sender][_msgSender()],
756                 amount,
757                 "ERC20: transfer amount exceeds allowance"
758             )
759         );
760         return true;
761     }
762 
763     function increaseAllowance(address spender, uint256 addedValue)
764         external
765         virtual
766         returns (bool)
767     {
768         _approve(
769             _msgSender(),
770             spender,
771             _allowances[_msgSender()][spender].add(addedValue)
772         );
773         return true;
774     }
775 
776     function decreaseAllowance(address spender, uint256 subtractedValue)
777         external
778         virtual
779         returns (bool)
780     {
781         _approve(
782             _msgSender(),
783             spender,
784             balanceCheck(
785                 _allowances[_msgSender()][spender],
786                 subtractedValue,
787                 "ERC20: decreased allowance below zero"
788             )
789         );
790         return true;
791     }
792 
793     function isExcludedFromReward(address account)
794         external
795         view
796         returns (bool)
797     {
798         return _isExcluded[account];
799     }
800 
801     function totalFees() external view returns (uint256) {
802         return _tFeeTotal;
803     }
804 
805      // reflection by action of volunteer
806     function deliver(uint256 tAmount) external {
807         address sender = _msgSender();
808         require(
809             !_isExcluded[sender],
810             "Excluded addresses cannot call this function"
811         );
812         (uint256 rAmount, , , , , ) = _getValues(tAmount);
813         _rOwned[sender] = _rOwned[sender].sub(rAmount);
814         _rTotal = _rTotal.sub(rAmount);
815         _tFeeTotal = _tFeeTotal.add(tAmount);
816 
817         emit LogDeliver(msg.sender, tAmount);
818     }
819 
820     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
821         external
822         view
823         returns (uint256)
824     {
825         require(tAmount <= _tTotal, "Amount must be less than supply");
826         if (!deductTransferFee) {
827             (uint256 rAmount, , , , , ) = _getValues(tAmount);
828             return rAmount;
829         } else {
830             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
831             return rTransferAmount;
832         }
833     }
834 
835     function tokenFromReflection(uint256 rAmount)
836         public
837         view
838         returns (uint256)
839     {
840         require(
841             rAmount <= _rTotal,
842             "Amount must be less than total reflections"
843         );
844         uint256 currentRate = _getRate();
845         return rAmount.div(currentRate);
846     }
847 
848     function excludeFromReward(address account) external onlyOwner {
849         require(!_isExcluded[account], "Account is already excluded");
850         if (_rOwned[account] > 0) {
851             _tOwned[account] = tokenFromReflection(_rOwned[account]);
852         }
853         _isExcluded[account] = true;
854         _excluded.push(account);
855 
856         emit LogExcludeFromReward(account);
857     }
858 
859     function includeInReward(address account) external onlyOwner {
860         require(account != bridgeVault, "Bridge Vault can't receive reward");
861         require(_isExcluded[account], "Account is already included");
862         for (uint256 i = 0; i < _excluded.length; i++) {
863             if (_excluded[i] == account) {
864                 _excluded[i] = _excluded[_excluded.length - 1];
865                 _tOwned[account] = 0;
866                 _isExcluded[account] = false;
867                 _excluded.pop();
868                 break;
869             }
870         }
871 
872         emit LogIncludeInReward(account);
873     }
874 
875     //to receive ETH from uniswapV2Router when swapping
876     receive() external payable {
877         emit LogReceive(msg.sender, msg.value);
878     }
879 
880     fallback() external payable {
881         emit LogFallback(msg.sender, msg.value);
882     }
883     
884 
885     // reflection
886     function _reflectFee(uint256 rFee, uint256 tFee) private {
887         _rTotal = _rTotal.sub(rFee);
888         _tFeeTotal = _tFeeTotal.add(tFee);
889     }
890 
891     function _getValues(uint256 tAmount)
892         private
893         view
894         returns (
895             uint256,
896             uint256,
897             uint256,
898             uint256,
899             uint256,
900             uint256
901         )
902     {
903         (
904             uint256 tTransferAmount,
905             uint256 tFee,
906             uint256 tLiquidity,
907             uint256 tMarketing,
908             uint256 tBurn
909         ) = _getTValues(tAmount);
910         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
911             tAmount,
912             tFee,
913             tLiquidity,
914             tMarketing,
915             tBurn,
916             _getRate()
917         );
918         return (
919             rAmount,
920             rTransferAmount,
921             rFee,
922             tTransferAmount,
923             tFee,
924             tLiquidity
925         );
926     }
927 
928     function _getTValues(uint256 tAmount)
929         private
930         view
931         returns (
932             uint256,
933             uint256,
934             uint256,
935             uint256,
936             uint256
937         )
938     {
939         uint256 tFee = calculateTaxFee(tAmount);
940         uint256 tLiquidity = calculateLiquidityFee(tAmount);
941         uint256 tMarketing = calculateMarketingFee(tAmount);
942         uint256 tBurn = calculateBurnFee(tAmount);
943         uint256 tTeam = calculateTeamFee(tAmount);
944         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
945         tTransferAmount = tTransferAmount.sub(tMarketing).sub(tBurn).sub(tTeam);
946         return (tTransferAmount, tFee, tLiquidity, tMarketing, tBurn);
947     }
948 
949     function _getRValues(
950         uint256 tAmount,
951         uint256 tFee,
952         uint256 tLiquidity,
953         uint256 tMarketing,
954         uint256 tBurn,
955         uint256 currentRate
956     )
957         private
958         view
959         returns (
960             uint256,
961             uint256,
962             uint256
963         )
964     {
965         uint256 rAmount = tAmount.mul(currentRate);
966         uint256 rFee = tFee.mul(currentRate);
967         uint256 rLiquidity = tLiquidity.mul(currentRate);
968         uint256 rMarketing = tMarketing.mul(currentRate);
969         uint256 rBurn = tBurn.mul(currentRate);
970         uint256 tTeam = calculateTeamFee(tAmount);
971         uint256 rTeam = tTeam.mul(currentRate);
972         uint256 totalDeduction = rFee.add(rLiquidity).add(rMarketing).add(rBurn).add(rTeam);
973         uint256 rTransferAmount = rAmount.sub(totalDeduction);
974         return (rAmount, rTransferAmount, rFee);
975     }
976 
977     function _getRate() private view returns (uint256) {
978         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
979         return rSupply.div(tSupply);
980     }
981 
982     function _getCurrentSupply() private view returns (uint256, uint256) {
983         uint256 rSupply = _rTotal;
984         uint256 tSupply = _tTotal;
985         for (uint256 i = 0; i < _excluded.length; i++) {
986             if (
987                 _rOwned[_excluded[i]] > rSupply ||
988                 _tOwned[_excluded[i]] > tSupply
989             ) return (_rTotal, _tTotal);
990             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
991             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
992         }
993         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
994         return (rSupply, tSupply);
995     }
996 
997     function _takeLiquidity(uint256 tLiquidity) private {
998         uint256 currentRate = _getRate();
999         uint256 rLiquidity = tLiquidity.mul(currentRate);
1000         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1001         if (_isExcluded[address(this)])
1002             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1003     }
1004 
1005     function _takeTeam(uint256 tTeam) private {
1006         uint256 currentRate = _getRate();
1007         uint256 rTeam = tTeam.mul(currentRate);
1008         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1009         if (_isExcluded[address(this)])
1010             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1011     }
1012 
1013     function _takeMarketingAndBurn(uint256 tMarketing, uint256 tBurn) private {
1014         uint256 currentRate = _getRate();
1015         uint256 rMarketing = tMarketing.mul(currentRate);
1016         uint256 rBurn = tBurn.mul(currentRate);
1017         _rOwned[address(this)] = _rOwned[address(this)].add(rBurn).add(rMarketing);
1018         if (_isExcluded[address(this)])
1019             _tOwned[address(this)] =
1020                 _tOwned[address(this)] +
1021                 (tMarketing + tBurn);
1022     }
1023 
1024     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1025         return _amount.mul(_taxFee).div(10**2);
1026     }
1027 
1028     function calculateLiquidityFee(uint256 _amount)
1029         private
1030         view
1031         returns (uint256)
1032     {
1033         return _amount.mul(_liquidityFee).div(10**2);
1034     }
1035 
1036     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1037         return _amount.mul(_burnFee).div(10**2);
1038     }
1039 
1040     function calculateMarketingFee(uint256 _amount)
1041         private
1042         view
1043         returns (uint256)
1044     {
1045         return _amount.mul(_marketingFee).div(10**2);
1046     }
1047 
1048     function calculateTeamFee(uint256 _amount) private view returns (uint256) {
1049         return _amount.mul(_teamFee).div(10**2);
1050     }
1051 
1052     function restoreAllFee() private {
1053         _taxFee = 0;
1054         _liquidityFee = 0;
1055         _marketingFee = 0;
1056         _burnFee = 0;
1057         _teamFee = 0;
1058     }
1059 
1060     function setBuyFee() private {
1061         _taxFee = buyFee.tax;
1062         _liquidityFee = buyFee.autoLp;
1063         _marketingFee = buyFee.marketing;
1064         _burnFee = buyFee.burn;
1065         _teamFee = buyFee.team;
1066     }
1067 
1068     function setSellFee() private {
1069         _taxFee = sellFee.tax;
1070         _liquidityFee = sellFee.autoLp;
1071         _marketingFee = sellFee.marketing;
1072         _burnFee = sellFee.burn;
1073         _teamFee = sellFee.team;
1074     }
1075 
1076     function setEnableTrading(bool enable) external onlyOwner {
1077         require(isTradingEnabled != enable, "Already set Enable");
1078         isTradingEnabled = enable;
1079 
1080         emit LogSetEnableTrading(isTradingEnabled);
1081     }
1082 
1083     function setBridgeVault (address _bridgeVault) external onlyOwner {
1084         require(_bridgeVault != address(0), "Invalid address");
1085         require(bridgeVault != _bridgeVault, "Already set to this value");
1086         bridgeVault = _bridgeVault;
1087         emit LogSetBridgeVault(msg.sender, bridgeVault);
1088     }
1089 
1090     function isExcludedFromFee(address account) external view returns (bool) {
1091         return _isExcludedFromFee[account];
1092     }
1093 
1094     function _approve(
1095         address owner,
1096         address spender,
1097         uint256 amount
1098     ) private {
1099         require(owner != address(0), "ERC20: approve from the zero address");
1100         require(spender != address(0), "ERC20: approve to the zero address");
1101         
1102         _allowances[owner][spender] = amount;
1103         emit Approval(owner, spender, amount);
1104     }
1105 
1106     function _transfer(
1107         address from,
1108         address to,
1109         uint256 amount
1110     ) private {
1111         require(from != address(0), "ERC20: transfer from the zero address");
1112         require(to != address(0), "ERC20: transfer to the zero address");
1113         require(amount > 0, "Transfer amount must be greater than zero");
1114 
1115         uint256 contractTokenBalance = balanceOf(address(this));
1116         bool overMinTokenBalance = contractTokenBalance >=
1117             numTokensSellToAddToLiquidity;
1118         if (
1119             overMinTokenBalance &&
1120             !inSwapAndLiquify &&
1121             !automatedMarketMakerPairs[from] &&
1122             swapAndLiquifyEnabled &&
1123             from != liquidityWallet &&
1124             to != liquidityWallet
1125         ) {
1126             contractTokenBalance = numTokensSellToAddToLiquidity;
1127 
1128             swapAndDistribute(contractTokenBalance);
1129         }
1130 
1131         //transfer amount, it will take tax, Burn, liquidity fee
1132         _tokenTransfer(from, to, amount);
1133     }
1134 
1135     function swapAndDistribute(uint256 contractTokenBalance)
1136         private
1137         lockTheSwap
1138     {
1139         uint256 total = buyFee.marketing
1140             .add(sellFee.marketing)
1141             .add(buyFee.autoLp)
1142             .add(sellFee.autoLp)
1143             .add(buyFee.burn)
1144             .add(sellFee.burn)
1145             .add(buyFee.team)
1146             .add(sellFee.team);
1147             
1148         uint256 lp = buyFee.autoLp + sellFee.autoLp;
1149         uint256 forLiquidity = contractTokenBalance.mul(lp).div(total);
1150         swapAndLiquify(forLiquidity);
1151 
1152         uint256 totalBurn = buyFee.burn + sellFee.burn;
1153         uint256 forBurn = contractTokenBalance.mul(totalBurn).div(total);
1154         sendToBurn(forBurn);
1155 
1156         uint256 marketingFee = buyFee.marketing + sellFee.marketing;
1157         uint256 forMarketing = contractTokenBalance.mul(marketingFee).div(total);
1158         sendToMarketing(forMarketing);
1159 
1160         uint256 teamFee = buyFee.team + sellFee.team;
1161         uint256 forTeam = contractTokenBalance.mul(teamFee).div(total);
1162         sendToTeam(forTeam);
1163 
1164         emit LogSwapAndDistribute(forMarketing, forLiquidity, forBurn, forTeam);
1165     }
1166 
1167     function sendToBurn(uint256 tBurn) private {
1168         uint256 currentRate = _getRate();
1169         uint256 rBurn = tBurn.mul(currentRate);
1170 
1171         _rOwned[burnWallet] = _rOwned[burnWallet].add(rBurn);
1172         _rOwned[address(this)] = _rOwned[address(this)].sub(rBurn);
1173 
1174         if (_isExcluded[burnWallet])
1175             _tOwned[burnWallet] = _tOwned[burnWallet].add(tBurn);
1176 
1177         if (_isExcluded[address(this)])
1178             _tOwned[address(this)] = _tOwned[address(this)].sub(tBurn);
1179 
1180         emit Transfer(address(this), burnWallet, tBurn);
1181     }
1182 
1183     function sendToTeam(uint256 tTeam) private {
1184         uint256 currentRate = _getRate();
1185         uint256 rTeam = tTeam.mul(currentRate);
1186 
1187         _rOwned[teamWallet] = _rOwned[teamWallet].add(rTeam);
1188         _rOwned[address(this)] = _rOwned[address(this)].sub(rTeam);
1189 
1190         if (_isExcluded[teamWallet])
1191             _tOwned[teamWallet] = _tOwned[teamWallet].add(tTeam);
1192 
1193         if (_isExcluded[address(this)])
1194             _tOwned[address(this)] = _tOwned[address(this)].sub(tTeam);
1195 
1196         emit Transfer(address(this), teamWallet, tTeam);
1197     }
1198 
1199     function sendToMarketing(uint256 tMarketing) private {
1200         uint256 currentRate = _getRate();
1201         uint256 rMarketing = tMarketing.mul(currentRate);
1202 
1203         _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rMarketing);
1204         _rOwned[address(this)] = _rOwned[address(this)].sub(rMarketing);
1205 
1206         if (_isExcluded[marketingWallet])
1207             _tOwned[marketingWallet] = _tOwned[marketingWallet].add(tMarketing);
1208 
1209         if (_isExcluded[address(this)])
1210             _tOwned[address(this)] = _tOwned[address(this)].sub(tMarketing);
1211 
1212         emit Transfer(address(this), marketingWallet, tMarketing);
1213     }
1214 
1215     function swapAndLiquify(uint256 tokens) private {
1216         uint256 half = tokens.div(2);
1217         uint256 otherHalf = tokens.sub(half);
1218 
1219         uint256 initialBalance = address(this).balance;
1220 
1221         swapTokensForETH(half);
1222 
1223         uint256 newBalance = address(this).balance.sub(initialBalance);
1224 
1225         addLiquidity(otherHalf, newBalance);
1226 
1227         emit LogSwapAndLiquify(half, newBalance, otherHalf);
1228     }
1229 
1230     function swapTokensForETH(uint256 tokenAmount) private {
1231         address[] memory path = new address[](2);
1232         path[0] = address(this);
1233         path[1] = uniswapV2Router.WETH();
1234 
1235         _approve(address(this), address(uniswapV2Router), tokenAmount);
1236 
1237         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1238             tokenAmount,
1239             0,
1240             path,
1241             address(this),
1242             block.timestamp
1243         );
1244     }
1245 
1246     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1247         _approve(address(this), address(uniswapV2Router), tokenAmount);
1248 
1249         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1250             address(this),
1251             tokenAmount,
1252             0,
1253             0,
1254             liquidityWallet,
1255             block.timestamp
1256         );
1257     }
1258 
1259     function _tokenTransfer(
1260         address sender,
1261         address recipient,
1262         uint256 amount
1263     ) private {
1264         if (!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]) {
1265             require(isTradingEnabled, "Trading is disabled");
1266 
1267             if (automatedMarketMakerPairs[sender] == true) {
1268                 shouldTakeFee = true;
1269                 setBuyFee();
1270             } else if (automatedMarketMakerPairs[recipient] == true) {
1271                 shouldTakeFee = true;
1272                 setSellFee();
1273             }
1274         }
1275 
1276         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1277             _transferFromExcluded(sender, recipient, amount);
1278         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1279             _transferToExcluded(sender, recipient, amount);
1280         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1281             _transferBothExcluded(sender, recipient, amount);
1282         } else {
1283             _transferStandard(sender, recipient, amount);
1284         }
1285 
1286         if (shouldTakeFee == true) {
1287             shouldTakeFee = false;
1288             restoreAllFee();
1289         }
1290     }
1291 
1292     function _takeFee(
1293         address sender,
1294         uint256 tAmount,
1295         uint256 tLiquidity,
1296         uint256 tFee,
1297         uint256 rFee
1298     ) private {
1299         if (shouldTakeFee == true) {
1300             uint256 tMarketing = calculateMarketingFee(tAmount);
1301             uint256 tBurn = calculateBurnFee(tAmount);
1302             uint256 tTeam = calculateTeamFee(tAmount);
1303 
1304             _takeLiquidity(tLiquidity);
1305             _takeMarketingAndBurn(tMarketing, tBurn);
1306             _takeTeam(tTeam);
1307             // reflection
1308             _reflectFee(rFee, tFee);
1309 
1310             // rFee, tFee
1311             // `tFee` will miss Transfer event and then with the `tFee`, reflect to all token holders.
1312             emit Transfer(
1313                 sender,
1314                 address(this),
1315                 tLiquidity + tMarketing + tBurn + tTeam
1316             );
1317         }
1318     }
1319 
1320     function _transferStandard(
1321         address sender,
1322         address recipient,
1323         uint256 tAmount
1324     ) private {
1325         (
1326             uint256 rAmount,
1327             uint256 rTransferAmount,
1328             uint256 rFee,
1329             uint256 tTransferAmount,
1330             uint256 tFee,
1331             uint256 tLiquidity
1332         ) = _getValues(tAmount);
1333         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1334         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1335         _takeFee(sender, tAmount, tLiquidity, tFee, rFee);
1336         emit Transfer(sender, recipient, tTransferAmount);
1337     }
1338 
1339     function _transferToExcluded(
1340         address sender,
1341         address recipient,
1342         uint256 tAmount
1343     ) private {
1344         (
1345             uint256 rAmount,
1346             uint256 rTransferAmount,
1347             uint256 rFee,
1348             uint256 tTransferAmount,
1349             uint256 tFee,
1350             uint256 tLiquidity
1351         ) = _getValues(tAmount);
1352         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1353         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1354         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1355         _takeFee(sender, tAmount, tLiquidity, tFee, rFee);
1356         emit Transfer(sender, recipient, tTransferAmount);
1357     }
1358 
1359     function _transferFromExcluded(
1360         address sender,
1361         address recipient,
1362         uint256 tAmount
1363     ) private {
1364         (
1365             uint256 rAmount,
1366             uint256 rTransferAmount,
1367             uint256 rFee,
1368             uint256 tTransferAmount,
1369             uint256 tFee,
1370             uint256 tLiquidity
1371         ) = _getValues(tAmount);
1372         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1373         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1375         _takeFee(sender, tAmount, tLiquidity, tFee, rFee);
1376         emit Transfer(sender, recipient, tTransferAmount);
1377     }
1378 
1379     function _transferBothExcluded(
1380         address sender,
1381         address recipient,
1382         uint256 tAmount
1383     ) private {
1384         (
1385             uint256 rAmount,
1386             uint256 rTransferAmount,
1387             uint256 rFee,
1388             uint256 tTransferAmount,
1389             uint256 tFee,
1390             uint256 tLiquidity
1391         ) = _getValues(tAmount);
1392         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1393         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1394         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1395         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1396         _takeFee(sender, tAmount, tLiquidity, tFee, rFee);
1397         emit Transfer(sender, recipient, tTransferAmount);
1398     }
1399 
1400     function setExcludeFromFee(address account, bool enabled)
1401         external
1402         onlyOwner
1403     {
1404         require(account != address(0),"Zero Address");
1405         require(_isExcludedFromFee[account] != enabled,"Already enabled");
1406         _isExcludedFromFee[account] = enabled;
1407         emit LogSetExcludeFromFee(msg.sender, account, enabled);
1408     }
1409 
1410     function setMarketingWallet(address newWallet) external onlyOwner {
1411         require(newWallet != address(0), "Zero Address");
1412         require(newWallet != marketingWallet, "Same Address");
1413         marketingWallet = newWallet;
1414         emit LogSetMarketingWallet(msg.sender, marketingWallet);
1415     }
1416 
1417     function setTeamWallet(address newWallet) external onlyOwner {
1418         require(newWallet != address(0), "Zero Address");
1419         require(newWallet != teamWallet, "Same Address");
1420         teamWallet = newWallet;
1421         emit LogSetTeamWallet(msg.sender, teamWallet);
1422     }
1423 
1424     function setBuyFees(
1425         uint256 _lp,
1426         uint256 _marketing,
1427         uint256 _burn,
1428         uint256 _tax,
1429         uint256 _team
1430     ) external onlyOwner {
1431         require(_lp + _marketing + _burn + _tax + _team <= 50, "Max total fee is 50%");
1432         require(!(buyFee.autoLp == _lp && buyFee.marketing == _marketing && buyFee.burn == _burn && buyFee.tax == _tax &&  buyFee.team == _team), "Nothing is changed");
1433         buyFee.autoLp = _lp;
1434         buyFee.marketing = _marketing;
1435         buyFee.burn = _burn;
1436         buyFee.tax = _tax;
1437         buyFee.team = _team;
1438 
1439         emit LogSetBuyFees(msg.sender, buyFee);
1440     }
1441 
1442     function setSellFees(
1443         uint256 _lp,
1444         uint256 _marketing,
1445         uint256 _burn,
1446         uint256 _tax,
1447         uint256 _team
1448     ) external onlyOwner {
1449         require(_lp + _marketing + _burn + _tax + _team <= 50, "Max total fee is 50%");
1450         sellFee.autoLp = _lp;
1451         sellFee.marketing = _marketing;
1452         sellFee.burn = _burn;
1453         sellFee.tax = _tax;
1454         sellFee.team = _team;
1455 
1456         emit LogSetSellFees(msg.sender, sellFee);
1457     }
1458 
1459     function setRouterAddress(address newRouter) external onlyOwner {
1460         require(newRouter != address(0), "Zero Address");
1461         require(newRouter != address(uniswapV2Router), "Same Address");
1462         uniswapV2Router = IUniswapV2Router02(newRouter);
1463 
1464         emit LogSetRouterAddress(msg.sender, newRouter);
1465     }
1466 
1467     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1468         require(_enabled != swapAndLiquifyEnabled, "Already enabled");
1469         swapAndLiquifyEnabled = _enabled;
1470 
1471         emit LogSwapAndLiquifyEnabledUpdated(msg.sender, _enabled);
1472     }
1473 
1474     function setSwapTokensAmount(uint256 amount) external onlyOwner {
1475         require(amount != numTokensSellToAddToLiquidity, "Same Amount");
1476         numTokensSellToAddToLiquidity = amount;
1477 
1478         emit LogSetSwapTokensAmount(msg.sender, amount);
1479     }
1480 
1481     function updateLiquidityWallet(address newLiquidityWallet)
1482         external
1483         onlyOwner
1484     {
1485         require(newLiquidityWallet != address(0), "Zero Address");
1486         require(newLiquidityWallet != liquidityWallet,"The liquidity wallet is already this address" );
1487         liquidityWallet = newLiquidityWallet;
1488 
1489         emit LogUpdateLiquidityWallet(msg.sender, newLiquidityWallet);
1490     }
1491 
1492     function withdrawETH(address payable recipient, uint256 amount)
1493         external
1494         onlyOwner
1495     {
1496         require(recipient != address(0), "Zero Address");
1497         require(amount <= (address(this)).balance, "Incufficient funds");
1498         recipient.transfer(amount);
1499         emit LogWithdrawalETH(recipient, amount);
1500     }
1501 
1502     /**
1503      * @notice  Should not be withdrawn scam token or this Empire token.
1504      *          Use `withdraw` function to withdraw this Empire token.
1505      */
1506     function withdrawToken(
1507         IERC20 token,
1508         address recipient,
1509         uint256 amount
1510     ) external onlyOwner {
1511         require(address(token) != address(0), "Zero Address of Token");
1512         require(recipient != address(0), "Zero Address of Recepient");
1513         require(amount <= token.balanceOf(address(this)), "Incufficient funds");
1514         require(token.transfer(recipient, amount), "Transfer Fail");
1515 
1516         emit LogWithdrawToken(address(token), recipient, amount);
1517     }
1518 
1519     /**
1520      * @notice  The onlyOwner will withdraw this token to `recipient`.
1521      */
1522     function withdraw(address recipient, uint256 tAmount) external onlyOwner {
1523         require(recipient != address(0), "Zero Address");
1524         require(tAmount > 0, "Withdrawal amount must be greater than zero");
1525 
1526         if (_isExcluded[address(this)] && !_isExcluded[recipient]) {
1527             _transferFromExcluded(address(this), recipient, tAmount);
1528         } else if (!_isExcluded[address(this)] && _isExcluded[recipient]) {
1529             _transferToExcluded(address(this), recipient, tAmount);
1530         } else if (_isExcluded[address(this)] && _isExcluded[recipient]) {
1531             _transferBothExcluded(address(this), recipient, tAmount);
1532         } else {
1533             _transferStandard(address(this), recipient, tAmount);
1534         }
1535 
1536         emit LogWithdrawal(recipient, tAmount);
1537     }
1538 
1539     modifier onlyBridge() {
1540         require(msg.sender == bridge, "Only bridge can perform this action");
1541         _;
1542     }
1543 
1544     function setBridge(address _bridge) external onlyOwner {
1545         require(_bridge != address(0), "Zero Address");
1546         require(bridge != _bridge, "Same Bridge!");
1547         bridge = _bridge;
1548 
1549         emit LogSetBridge(msg.sender, bridge);
1550     }
1551 
1552     /**
1553      * @dev need approval from account
1554      */
1555     function lock(address account, uint256 tAmount) external onlyBridge {
1556         require(account != address(0), "Zero address");
1557         require(tAmount > 0, "Lock amount must be greater than zero");
1558         require(tAmount <= balanceOf(account), "Incufficient funds");
1559         require(_allowances[account][_msgSender()] >= tAmount, "ERC20: transfer amount exceeds allowance");
1560 
1561         if (!_isExcluded[account]) {
1562             _transferToExcluded(account, bridgeVault, tAmount);
1563         } else {
1564             _transferBothExcluded(account, bridgeVault, tAmount);
1565         }
1566 
1567 
1568         emit LogLockByBridge(account, tAmount);
1569     }
1570 
1571     /**
1572      * @dev no need approval, because bridgeVault balance is controlled by EMPIRE
1573      */
1574     function unlock(address account, uint256 tAmount) external onlyBridge {
1575         require(account != address(0), "Zero address");
1576         require(tAmount > 0, "Unlock amount must be greater than zero");
1577         require(tAmount <= balanceOf(bridgeVault), "Incufficient funds");
1578 
1579 
1580         if (!_isExcluded[account]) {
1581             _transferFromExcluded(bridgeVault, account, tAmount);
1582         } else {
1583             _transferBothExcluded(bridgeVault, account, tAmount);
1584         }
1585 
1586         emit LogUnlockByBridge(account, tAmount);
1587     }
1588 }