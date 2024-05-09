1 // SPDX-License-Identifier: MIT
2 /*
3 
4 ███████ ██ ███    ██ ██    ██ 
5    ███  ██ ████   ██ ██    ██ 
6   ███   ██ ██ ██  ██ ██    ██ 
7  ███    ██ ██  ██ ██ ██    ██ 
8 ███████ ██ ██   ████  ██████  
9                                        
10 Linktree: 
11 https://linktr.ee/ZombieInu
12 
13 Website: 
14 https://wearezinu.com
15 
16 Telegram: 
17 https://t.me/zombieinuofficial
18 
19 Discord: 
20 https://discord.com/invite/wearezinu
21 
22 Medium: 
23 https://medium.com/@ZombieInu
24 
25 OpenSea: 
26 https://opensea.io/collection/zombiemobsecretsociety
27 
28 Whitepaper: 
29 https://app.pitch.com/app/presentation/58d34159-9a3a-4898-b6e7-5c63bc85304b/1f5600fb-72bf-4d68-abaf-173a4b6c56aa
30 
31 */
32 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 // CAUTION
40 // This version of SafeMath should only be used with Solidity 0.8 or later,
41 // because it relies on the compiler's built in overflow checks.
42 
43 /**
44  * @dev Wrappers over Solidity's arithmetic operations.
45  *
46  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
47  * now has built in overflow checking.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, with an overflow flag.
52      *
53      * _Available since v3.4._
54      */
55     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             uint256 c = a + b;
58             if (c < a) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b > a) return (false, 0);
71             return (true, a - b);
72         }
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83             // benefit is lost if 'b' is also tested.
84             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85             if (a == 0) return (true, 0);
86             uint256 c = a * b;
87             if (c / a != b) return (false, 0);
88             return (true, c);
89         }
90     }
91 
92     /**
93      * @dev Returns the division of two unsigned integers, with a division by zero flag.
94      *
95      * _Available since v3.4._
96      */
97     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             if (b == 0) return (false, 0);
100             return (true, a / b);
101         }
102     }
103 
104     /**
105      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             if (b == 0) return (false, 0);
112             return (true, a % b);
113         }
114     }
115 
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a + b;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a - b;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a * b;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers, reverting on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator.
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a / b;
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * reverting when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a % b;
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
190      * overflow (when the result is negative).
191      *
192      * CAUTION: This function is deprecated because it requires allocating memory for the error
193      * message unnecessarily. For custom revert reasons use {trySub}.
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         unchecked {
207             require(b <= a, errorMessage);
208             return a - b;
209         }
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(
225         uint256 a,
226         uint256 b,
227         string memory errorMessage
228     ) internal pure returns (uint256) {
229         unchecked {
230             require(b > 0, errorMessage);
231             return a / b;
232         }
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * reverting with custom message when dividing by zero.
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {tryMod}.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(
251         uint256 a,
252         uint256 b,
253         string memory errorMessage
254     ) internal pure returns (uint256) {
255         unchecked {
256             require(b > 0, errorMessage);
257             return a % b;
258         }
259     }
260 }
261 
262 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273     /**
274      * @dev Emitted when `value` tokens are moved from one account (`from`) to
275      * another (`to`).
276      *
277      * Note that `value` may be zero.
278      */
279     event Transfer(address indexed from, address indexed to, uint256 value);
280 
281     /**
282      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
283      * a call to {approve}. `value` is the new allowance.
284      */
285     event Approval(address indexed owner, address indexed spender, uint256 value);
286 
287     /**
288      * @dev Returns the amount of tokens in existence.
289      */
290     function totalSupply() external view returns (uint256);
291 
292     /**
293      * @dev Returns the amount of tokens owned by `account`.
294      */
295     function balanceOf(address account) external view returns (uint256);
296 
297     /**
298      * @dev Moves `amount` tokens from the caller's account to `to`.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transfer(address to, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Returns the remaining number of tokens that `spender` will be
308      * allowed to spend on behalf of `owner` through {transferFrom}. This is
309      * zero by default.
310      *
311      * This value changes when {approve} or {transferFrom} are called.
312      */
313     function allowance(address owner, address spender) external view returns (uint256);
314 
315     /**
316      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * IMPORTANT: Beware that changing an allowance with this method brings the risk
321      * that someone may use both the old and the new allowance by unfortunate
322      * transaction ordering. One possible solution to mitigate this race
323      * condition is to first reduce the spender's allowance to 0 and set the
324      * desired value afterwards:
325      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326      *
327      * Emits an {Approval} event.
328      */
329     function approve(address spender, uint256 amount) external returns (bool);
330 
331     /**
332      * @dev Moves `amount` tokens from `from` to `to` using the
333      * allowance mechanism. `amount` is then deducted from the caller's
334      * allowance.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transferFrom(
341         address from,
342         address to,
343         uint256 amount
344     ) external returns (bool);
345 }
346 
347 // File: @openzeppelin/contracts/utils/Context.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Provides information about the current execution context, including the
356  * sender of the transaction and its data. While these are generally available
357  * via msg.sender and msg.data, they should not be accessed in such a direct
358  * manner, since when dealing with meta-transactions the account sending and
359  * paying for execution may not be the actual sender (as far as an application
360  * is concerned).
361  *
362  * This contract is only required for intermediate, library-like contracts.
363  */
364 abstract contract Context {
365     function _msgSender() internal view virtual returns (address) {
366         return msg.sender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes calldata) {
370         return msg.data;
371     }
372 }
373 
374 // File: @openzeppelin/contracts/access/Ownable.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 abstract contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor() {
403         _transferOwnership(_msgSender());
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view virtual returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(owner() == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         _transferOwnership(address(0));
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         _transferOwnership(newOwner);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Internal function without access restriction.
444      */
445     function _transferOwnership(address newOwner) internal virtual {
446         address oldOwner = _owner;
447         _owner = newOwner;
448         emit OwnershipTransferred(oldOwner, newOwner);
449     }
450 }
451 
452 // File: Tokens/ZINU/ZINUv2.sol
453 
454 
455 pragma solidity ^0.8.7;
456 
457 interface IUniswapV2Factory {
458     function createPair(address tokenA, address tokenB) external returns (address pair);
459 }
460 
461 interface IUniswapV2Router02 {
462 
463     function swapExactETHForTokensSupportingFeeOnTransferTokens(
464         uint256 amountOutMin,
465         address[] calldata path,
466         address to,
467         uint256 deadline
468     ) external payable;
469 
470     function swapExactTokensForETHSupportingFeeOnTransferTokens(
471         uint256 amountIn,
472         uint256 amountOutMin,
473         address[] calldata path,
474         address to,
475         uint256 deadline
476     ) external;
477     
478     function factory() external pure returns (address);
479     function WETH() external pure returns (address);
480     function addLiquidityETH(
481         address token,
482         uint256 amountTokenDesired,
483         uint256 amountTokenMin,
484         uint256 amountETHMin,
485         address to,
486         uint256 deadline
487     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
488     
489 }
490 
491 contract ZINU is Context, IERC20, Ownable {
492     
493     using SafeMath for uint256;
494 
495     string private constant _name = "ZINU";
496     string private constant _symbol = "ZINU";
497     uint8 private constant _decimals = 9;
498     mapping(address => uint256) private _balances;
499 
500     mapping(address => mapping(address => uint256)) private _allowances;
501     uint256 private _tTotal; //Total Supply
502     uint256 private _tBurned; //Total Burned
503 
504     uint256 public maxSwapAmount;
505     uint256 public maxHodlAmount;
506     uint256 public contractSwapThreshold;
507     uint256 public buybackThreshold;
508 
509     //Buy Fees
510     uint256 private bBurnFee; 
511     uint256 private bLPFee; 
512     uint256 private bMarketingFee; 
513     uint256 private bBuybackFee; 
514 
515     //Sell Fee
516     uint256 private sBurnFee; 
517     uint256 private sLPFee; 
518     uint256 private sMarketingFee; 
519     uint256 private sBuybackFee; 
520 
521     //Early Max Sell Fee (Decay)
522     uint256 private sEarlySellFee;
523     
524     //Previous Fee 
525     uint256 private pBurnFee = rBurnFee;
526     uint256 private pLPFee = rLPFee;
527     uint256 private pMarketingFee = rMarketingFee;
528     uint256 private pBuybackFee = rBuybackFee;
529     uint256 private pEarlySellFee = rEarlySellFee;
530 
531     //Real Fee
532     uint256 private rBurnFee;
533     uint256 private rLPFee;
534     uint256 private rMarketingFee;
535     uint256 private rBuybackFee;
536     uint256 private rEarlySellFee;
537 
538     struct FeeBreakdown {
539         uint256 tBurn;
540         uint256 tLiq;
541         uint256 tMarket;
542         uint256 tBuyback;
543         uint256 tEarlySell;
544         uint256 tAmount;
545     }
546 
547     mapping(address => bool) private _isExcludedFromFee;
548     mapping(address => bool) public preTrader;
549     mapping(address => bool) public bots;
550 
551     address payable private _taxWallet1;
552     address payable private _taxWallet2;
553 
554     address private _buybackTokenReceiver;
555     address private _lpTokensReceiver;
556     
557     IUniswapV2Router02 private uniswapV2Router;
558     address public uniswapV2Pair;
559 
560     bool private contractSwapEnabled;
561     bool private contractSwapping;
562 
563     //Decaying Tax Logic
564     uint256 private decayTaxExpiration;
565     mapping(address => uint256) private buyTracker;
566     mapping(address => uint256) private lastBuyTimestamp;
567     mapping(address => uint256) private sellTracker;
568 
569     bool private tradingOpen;
570 
571     modifier lockSwap {
572         contractSwapping = true;
573         _;
574         contractSwapping = false;
575     }
576 
577     constructor() {
578 
579         //Initialize numbers for token
580         _tTotal = 1000000000 * 10**9; //Total Supply
581         maxSwapAmount = _tTotal.mul(10).div(10000); //0.1%
582         maxHodlAmount = _tTotal.mul(100).div(10000); //1%
583         contractSwapThreshold = _tTotal.mul(10).div(10000); //0.1%
584         buybackThreshold = 10; //10 wei
585 
586         //Buy Fees
587         bBurnFee = 100; 
588         bLPFee = 100; 
589         bMarketingFee = 200; 
590         bBuybackFee = 100; 
591 
592         //Sell Fee
593         sBurnFee = 100; 
594         sLPFee = 100; 
595         sMarketingFee = 200; 
596         sBuybackFee = 100; 
597         sEarlySellFee = 700;
598             
599         _taxWallet1 = payable(0x1ac943b22593464FBd00ae0dC07F98e1F881bd01);
600         _taxWallet2 = payable(0x6A53c4cde998556F8507240F9A431D5Baa9072eC);
601         _buybackTokenReceiver = 0xD951bf2928c9aDc3BE5C4B310F93A7bb37223454;
602         _lpTokensReceiver = 0x1ac943b22593464FBd00ae0dC07F98e1F881bd01;
603 
604         contractSwapEnabled = true;
605         tradingOpen = false;
606         contractSwapping = false;
607 
608         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
609         uniswapV2Router = _uniswapV2Router;
610         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
611         
612         _balances[_msgSender()] = _tTotal;
613         _isExcludedFromFee[owner()] = true;
614         _isExcludedFromFee[_taxWallet1] = true;
615         _isExcludedFromFee[_taxWallet2] = true;
616         _isExcludedFromFee[_buybackTokenReceiver] = true;
617         _isExcludedFromFee[_lpTokensReceiver] = true;
618         _isExcludedFromFee[address(this)] = true;
619         preTrader[owner()] = true;
620 
621         //initialie decay tax
622         decayTaxExpiration = 8 days;
623 
624         emit Transfer(address(0), _msgSender(), _tTotal);
625 
626     }
627 
628     function name() public pure returns (string memory) {
629         return _name;
630     }
631 
632     function symbol() public pure returns (string memory) {
633         return _symbol;
634     }
635 
636     function decimals() public pure returns (uint8) {
637         return _decimals;
638     }
639 
640     function totalSupply() public view override returns (uint256) {
641         return _tTotal;
642     }
643 
644     function totalBurned() public view returns (uint256) {
645         return _tBurned;
646     }
647 
648     function balanceOf(address account) public view override returns (uint256) {
649         return _balances[account];
650     }
651     
652     function transfer(address recipient, uint256 amount) external override returns (bool) {
653         _transfer(_msgSender(), recipient, amount);
654         return true;
655     }
656 
657     function allowance(address owner, address spender) external view override returns (uint256) {
658         return _allowances[owner][spender];
659     }
660 
661     function approve(address spender, uint256 amount) external override returns (bool) {
662         _approve(_msgSender(), spender, amount);
663         return true;
664     }
665 
666     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
667         _transfer(sender, recipient, amount);
668         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
669         return true;
670     }
671 
672     function removeAllFee() private {
673         if (rBurnFee == 0 && rLPFee == 0 && rMarketingFee == 0 && rBuybackFee == 0 && rEarlySellFee == 0) return;
674         
675         pBurnFee = rBurnFee;
676         pLPFee = rLPFee;
677         pMarketingFee = rMarketingFee;
678         pBuybackFee = rBuybackFee;
679         pEarlySellFee = rEarlySellFee;
680 
681         rBurnFee = 0;
682         rLPFee = 0;
683         rMarketingFee = 0;
684         rBuybackFee = 0;
685         rEarlySellFee = 0;
686     }
687     
688     function restoreAllFee() private {
689         rBurnFee = pBurnFee;
690         rLPFee = pLPFee;
691         rMarketingFee = pMarketingFee;
692         rBuybackFee = pBuybackFee;
693         rEarlySellFee = pEarlySellFee;
694     }
695 
696     function _approve(address owner, address spender, uint256 amount) private {
697         require(owner != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699         _allowances[owner][spender] = amount;
700         emit Approval(owner, spender, amount);
701     }
702     
703     function _transfer(address from, address to, uint256 amount) private {
704 
705         require(from != address(0), "ERC20: transfer from the zero address");
706         require(to != address(0), "ERC20: transfer to the zero address");
707         require(amount > 0, "Transfer amount must be greater than zero");
708         require(!bots[from] && !bots[to], "You are blacklisted");
709 
710         bool takeFee = true;
711 
712         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to] && from != address(this) && to != address(this)) {
713 
714             //Trade start check
715             if (!tradingOpen) {
716                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
717             }
718 
719             //Max wallet Limit
720             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
721                 require(balanceOf(to).add(amount) < maxHodlAmount, "TOKEN: Balance exceeds wallet size!");
722             }
723             
724             //Max txn amount limit
725             require(amount <= maxSwapAmount, "TOKEN: Max Transaction Limit");
726 
727             //Set Fee for Buys
728             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
729                 rBurnFee = bBurnFee;
730                 rLPFee = bLPFee;
731                 rMarketingFee = bMarketingFee;
732                 rBuybackFee = bBuybackFee;
733                 rEarlySellFee = 0;
734             }
735                 
736             //Set Fee for Sells
737             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
738                 rBurnFee = sBurnFee;
739                 rLPFee = sLPFee;
740                 rMarketingFee = sMarketingFee;
741                 rBuybackFee = sBuybackFee;
742                 rEarlySellFee = sEarlySellFee;
743             }
744            
745             if(!contractSwapping && contractSwapEnabled && from != uniswapV2Pair) {
746 
747                 uint256 contractTokenBalance = balanceOf(address(this));
748 
749                 if(contractTokenBalance >= maxSwapAmount) {
750                     contractTokenBalance = maxSwapAmount;
751                 }
752                 
753                 if (contractTokenBalance > contractSwapThreshold) {
754                     processDistributions(contractTokenBalance);
755                 }
756 
757             }
758             
759         }
760 
761         //No tax on Transfer Tokens
762         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
763             takeFee = false;
764         }
765 
766         _tokenTransfer(from, to, amount, takeFee);
767 
768     }
769 
770     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
771         
772         if(!takeFee) {
773             removeAllFee();
774         }
775 
776         //Define Fee amounts
777         FeeBreakdown memory fees;
778         fees.tBurn = amount.mul(rBurnFee).div(10000);
779         fees.tLiq = amount.mul(rLPFee).div(10000);
780         fees.tMarket = amount.mul(rMarketingFee).div(10000);
781         fees.tBuyback = amount.mul(rBuybackFee).div(10000);
782 
783         fees.tEarlySell = 0;
784         if(rEarlySellFee > 0) {
785             uint256 finalEarlySellFee = getUserEarlySellTax(sender, amount, rEarlySellFee);
786             fees.tEarlySell = amount.mul(finalEarlySellFee).div(10000);
787         }
788 
789         //Calculate total fee amount
790         uint256 totalFeeAmount = fees.tBurn.add(fees.tLiq).add(fees.tBuyback).add(fees.tMarket).add(fees.tEarlySell);
791         fees.tAmount = amount.sub(totalFeeAmount);
792 
793         //Update balances
794         _balances[sender] = _balances[sender].sub(amount);
795         _balances[recipient] = _balances[recipient].add(fees.tAmount);
796         _balances[address(this)] = _balances[address(this)].add(totalFeeAmount);
797         
798         emit Transfer(sender, recipient, fees.tAmount);
799         if(totalFeeAmount > 0) {
800             emit Transfer(sender, address(this), totalFeeAmount);
801         }
802         restoreAllFee();
803 
804         //Update decay tax for user
805         //Set for Buys
806         if(sender == uniswapV2Pair && recipient != address(uniswapV2Router)) {
807             buyTracker[recipient] += amount;
808             lastBuyTimestamp[recipient] = block.timestamp;
809         }
810             
811         //Set for Sells
812         if (recipient == uniswapV2Pair && sender != address(uniswapV2Router)) {
813             sellTracker[sender] += amount;
814         }
815 
816         // if the sell tracker equals or exceeds the amount of tokens bought,
817         // reset all variables here which resets the time-decaying sell tax logic.
818         if(sellTracker[sender] >= buyTracker[sender]) {
819             resetBuySellDecayTax(sender);
820         }
821         
822         // handles transferring to a fresh wallet or wallet that hasn't bought tokens before
823         if(lastBuyTimestamp[recipient] == 0) {
824             resetBuySellDecayTax(recipient);
825         }
826 
827     }
828     
829     /// @notice Get user decayed tax
830     function getUserEarlySellTax(address _seller, uint256 _sellAmount, uint256 _earlySellFee) public view returns (uint256) {
831         uint256 _tax = _earlySellFee;
832 
833         if(lastBuyTimestamp[_seller] == 0) {
834             return _tax;
835         }
836 
837         if(sellTracker[_seller] + _sellAmount > buyTracker[_seller]) {
838             return _tax;
839         }
840 
841         if(block.timestamp > getSellEarlyExpiration(_seller)) {
842             return 0;
843         }
844 
845         uint256 _secondsAfterBuy = block.timestamp - lastBuyTimestamp[_seller];
846         return (_tax * (decayTaxExpiration - _secondsAfterBuy)) / decayTaxExpiration;
847     }
848 
849     function getSellEarlyExpiration(address _seller) private  view returns (uint256) {
850         return lastBuyTimestamp[_seller] == 0 ? 0 : lastBuyTimestamp[_seller] + decayTaxExpiration;
851     }
852 
853     function resetBuySellDecayTax(address _user) private {
854         buyTracker[_user] = balanceOf(_user);
855         lastBuyTimestamp[_user] = block.timestamp;
856         sellTracker[_user] = 0;
857     }
858 
859     //Buyback Module
860     function buyBackTokens() private lockSwap {
861         if(address(this).balance > 0) {
862     	    swapETHForTokens(address(this).balance);
863         }
864     }
865 
866     function swapETHForTokens(uint256 amount) private {
867         address[] memory path = new address[](2);
868         path[0] = uniswapV2Router.WETH();
869         path[1] = address(this);
870         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
871             0, // accept any amount of Tokens
872             path,
873             _buybackTokenReceiver, //Send bought tokens to this address
874             block.timestamp.add(300)
875         );
876     }
877 
878     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
879         address[] memory path = new address[](2);
880         path[0] = address(this);
881         path[1] = uniswapV2Router.WETH();
882         _approve(address(this), address(uniswapV2Router), tokenAmount);
883         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
884             tokenAmount,
885             0,
886             path,
887             address(this),
888             block.timestamp
889         );
890     }
891     
892     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
893 
894         // approve token transfer to cover all possible scenarios
895         _approve(address(this), address(uniswapV2Router), tokenAmount);
896 
897         // add the liquidity
898         uniswapV2Router.addLiquidityETH{value: ethAmount}(
899             address(this),
900             tokenAmount,
901             0, // slippage is unavoidable
902             0, // slippage is unavoidable
903             _lpTokensReceiver,
904             block.timestamp
905         );
906     }
907 
908     function sendETHToFee(uint256 amount) private {
909         _taxWallet1.transfer(amount.div(2));
910         _taxWallet2.transfer(amount.div(2));
911     }
912 
913     //True Burn
914     function _burn(address account, uint256 amount) internal virtual {
915         require(account != address(0), "ERC20: burn from the zero address");
916 
917         _beforeTokenTransfer(account, address(0), amount);
918 
919         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
920         _tTotal = _tTotal.sub(amount);
921         _tBurned = _tBurned.add(amount);
922         
923         emit Transfer(account, address(0), amount);
924     }
925 
926     function _beforeTokenTransfer(
927         address from,
928         address to,
929         uint256 amount
930     ) internal virtual {}
931 
932     function processDistributions(uint256 tokens) private {
933 
934         uint256 totalTokensFee = sBurnFee + sMarketingFee + sLPFee + sBuybackFee;
935 
936         //Get tokens to stay in contract
937         uint tokensForLP = (tokens * sLPFee / totalTokensFee)/2; //alf of tokens goes to LP and another half as ETH
938         uint tokensForBurn = (tokens * sBurnFee / totalTokensFee);
939 
940         //Get tokens to swap for ETH
941         uint tokensForETHSwap = tokens - (tokensForBurn + tokensForBurn);
942 
943         //Swap for eth
944         uint256 initialETHBalance = address(this).balance;
945         swapTokensForEth(tokensForETHSwap);
946         uint256 newETHBalance = address(this).balance.sub(initialETHBalance);
947 
948         uint256 ethForMarketing = newETHBalance * sMarketingFee / (totalTokensFee - (sLPFee/2) - sBurnFee);
949         uint256 ethForLP = newETHBalance * (sLPFee/2) / (totalTokensFee - (sLPFee/2) - sBurnFee);
950 
951         //Send eth share to distribute to tax wallets        
952         sendETHToFee(ethForMarketing);
953         //Send lp share along with tokens to add LP
954         addLiquidity(tokensForLP, ethForLP);
955         //Burn
956         _burn(address(this), tokensForBurn);
957 
958         //Leave the remaining eth in contract itself for buybacking
959         //Process buyback
960         if(address(this).balance >= buybackThreshold) {
961             buyBackTokens();
962         }
963 
964     }
965     
966     /// @notice Manually convert tokens in contract to Eth
967     function manualswap() external {
968         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
969         uint256 contractBalance = balanceOf(address(this));
970         if (contractBalance > 0) {
971             swapTokensForEth(contractBalance);
972         }
973     }
974 
975     /// @notice Manually send ETH in contract to marketing wallets
976     function manualsend() external {
977         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
978         uint256 contractETHBalance = address(this).balance;
979         if (contractETHBalance > 0) {
980             sendETHToFee(contractETHBalance);
981         }
982     }
983 
984     /// @notice Manually execute buyback with Eth availabe in contract
985     function manualBuyBack() external {
986         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
987         require(address(0).balance > 0, "No ETH in contract to buyback");
988         buyBackTokens();
989     }
990 
991     receive() external payable {}
992 
993     /// @notice Add an address to a pre trader
994     function allowPreTrading(address account, bool allowed) public onlyOwner {
995         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
996         preTrader[account] = allowed;
997     }
998 
999     /// @notice Add multiple address to exclude/include fee
1000     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1001         for(uint256 i = 0; i < accounts.length; i++) {
1002             _isExcludedFromFee[accounts[i]] = excluded;
1003         }
1004     }
1005 
1006     /// @notice Block address from transfer
1007     function blockMultipleBots(address[] calldata _bots, bool status) public onlyOwner {
1008         for(uint256 i = 0; i < _bots.length; i++) {
1009             bots[_bots[i]] = status;
1010         }
1011     }
1012 
1013     /// @notice Enable disable trading
1014     function setTrading(bool _tradingOpen) public onlyOwner {
1015         tradingOpen = _tradingOpen;
1016     }
1017 
1018     /// @notice Enable/Disable contract fee distribution
1019     function toggleContractSwap(bool _contractSwapEnabled) public onlyOwner {
1020         contractSwapEnabled = _contractSwapEnabled;
1021     }
1022 
1023     //Settings: Limits
1024     /// @notice Set maximum wallet limit
1025     function setMaxHodlAmount(uint256 _maxHodlAmount) public onlyOwner() {
1026         require(_maxHodlAmount > _tTotal.div(1000), "Amount must be greater than 0.1% of supply");
1027         maxHodlAmount = _maxHodlAmount;
1028     }
1029 
1030     /// @notice Set max amount a user can buy/sell/transfer
1031     function setMaxSwapAmount(uint256 _maxSwapAmount) public onlyOwner() {
1032         require(_maxSwapAmount > _tTotal.div(1000), "Amount must be greater than 0.1% of supply");
1033         maxSwapAmount = _maxSwapAmount;
1034     }
1035 
1036     /// @notice Set Contract swap amount threshold
1037     function setcontractSwapThreshold(uint256 _contractSwapThreshold) public onlyOwner() {
1038         contractSwapThreshold = _contractSwapThreshold;
1039     }
1040 
1041     /// @notice Set buyback threshold
1042     function setBuyBackThreshold(uint256 _buybackThreshold) public onlyOwner {
1043         buybackThreshold = _buybackThreshold;
1044     }
1045 
1046     /// @notice Set wallets
1047     function setWallets(address taxWallet1, address taxWallet2, address lpTokensReceiver, address buybackTokenReceiver) public onlyOwner {
1048         _taxWallet1 = payable(taxWallet1);
1049         _taxWallet2 = payable(taxWallet2);
1050         _lpTokensReceiver = lpTokensReceiver;
1051         _buybackTokenReceiver = buybackTokenReceiver;
1052     }
1053 
1054     /// @notice Setup fee in rate of 100 (If 1%, then set 100)
1055     function setBuyFee(uint256 _bBurnFee, uint256 _bMarketingFee, uint256 _bLPFee, uint256 _bBuybackFee) public onlyOwner {
1056         
1057         //Hard cap check to prevent honeypot
1058         require(_bBurnFee <= 2000, "Hard cap 20%");
1059         require(_bMarketingFee <= 2000, "Hard cap 20%");
1060         require(_bLPFee <= 2000, "Hard cap 20%");
1061         require(_bBuybackFee <= 2000, "Hard cap 20%");
1062         
1063         bBurnFee = _bBurnFee;
1064         bMarketingFee = _bMarketingFee;
1065         bLPFee = _bLPFee;
1066         bBuybackFee = _bBuybackFee;
1067     
1068     }
1069 
1070     /// @notice Setup fee in rate of 100 (If 1%, then set 100)
1071     function setSellFee(uint256 _sBurnFee, uint256 _sMarketingFee, uint256 _sLPFee, uint256 _sBuybackFee, uint256 _sEarlySellFee, uint256 _decayTaxExpiration) public onlyOwner {
1072         
1073         //Hard cap check to prevent honeypot
1074         require(_sBurnFee <= 2000, "Hard cap 20%");
1075         require(_sMarketingFee <= 2000, "Hard cap 20%");
1076         require(_sLPFee <= 2000, "Hard cap 20%");
1077         require(_sBuybackFee <= 2000, "Hard cap 20%");
1078         require(_sEarlySellFee <= 2000, "Hard cap 20%");
1079         
1080         sBurnFee = _sBurnFee;
1081         sMarketingFee = _sMarketingFee;
1082         sLPFee = _sLPFee;
1083         sBuybackFee = _sBuybackFee;
1084         sEarlySellFee = _sEarlySellFee;
1085         decayTaxExpiration = 1 days * _decayTaxExpiration;
1086     
1087     }
1088 
1089     function readFees() external view returns (uint _totalBuyFee, uint _totalSellFee, uint _burnFeeBuy, uint _burnFeeSell, uint _marketingFeeBuy, uint _marketingFeeSell, uint _liquidityFeeBuy, uint _liquidityFeeSell, uint _buybackFeeBuy, uint _buybackFeeSell, uint maxEarlySellFee) {
1090         return (
1091             bBurnFee+bMarketingFee+bLPFee+bBuybackFee,
1092             sBurnFee+sMarketingFee+sLPFee+sBuybackFee+sEarlySellFee,
1093             bBurnFee,
1094             sBurnFee,
1095             bMarketingFee,
1096             sMarketingFee,
1097             bLPFee,
1098             sLPFee,
1099             bBuybackFee,
1100             sBuybackFee,
1101             sEarlySellFee
1102         );
1103     }
1104 
1105     /// @notice Airdropper inbuilt
1106     function multiSend(address[] calldata addresses, uint256[] calldata amounts, bool overrideTracker, uint256 trackerTimestamp) external {
1107         require(addresses.length == amounts.length, "Must be the same length");
1108         for(uint256 i = 0; i < addresses.length; i++){
1109             _transfer(_msgSender(), addresses[i], amounts[i] * 10**_decimals);
1110 
1111             //Suppose to airdrop holders who bought long back and don't want to reset their decaytax
1112             if(overrideTracker) {
1113                 //Override buytracker
1114                 buyTracker[addresses[i]] += amounts[i];
1115                 lastBuyTimestamp[addresses[i]] = trackerTimestamp;
1116             }
1117         }
1118     }
1119     
1120 }