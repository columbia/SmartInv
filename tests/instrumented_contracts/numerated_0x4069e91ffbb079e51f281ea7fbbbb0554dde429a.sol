1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 “Akai” (赤い) is a japanese adjective meaning “red.”
6 
7 $AKAI is a hyper deflationary token that is on a mission to fuel $SHIB's journey 
8 through the Shibarium chain. Akai has developed a unique contract that will auto-buy
9 Shiba Inu tokens and then burn them by sending the tokens to a dead address, resulting
10 in less $SHIB in circulation. Akai will be used to continuously burn $SHIB!
11 
12 Website 
13 https://akaitoken.com
14 
15 Telegram (Entry Portal)
16 https://t.me/AkaiToken
17 
18 Twitter
19 https://twitter.com/AkaiShibarium
20 
21 */
22 
23 pragma solidity ^0.8.0;
24 
25 // CAUTION
26 // This version of SafeMath should only be used with Solidity 0.8 or later,
27 // because it relies on the compiler's built in overflow checks.
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations.
31  *
32  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
33  * now has built in overflow checking.
34  */
35 library SafeMath {
36     /**
37      * @dev Returns the addition of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             uint256 c = a + b;
44             if (c < a) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b > a) return (false, 0);
57             return (true, a - b);
58         }
59     }
60 
61     /**
62      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69             // benefit is lost if 'b' is also tested.
70             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71             if (a == 0) return (true, 0);
72             uint256 c = a * b;
73             if (c / a != b) return (false, 0);
74             return (true, c);
75         }
76     }
77 
78     /**
79      * @dev Returns the division of two unsigned integers, with a division by zero flag.
80      *
81      * _Available since v3.4._
82      */
83     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
84         unchecked {
85             if (b == 0) return (false, 0);
86             return (true, a / b);
87         }
88     }
89 
90     /**
91      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         unchecked {
97             if (b == 0) return (false, 0);
98             return (true, a % b);
99         }
100     }
101 
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a + b;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a - b;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a * b;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers, reverting on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator.
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a / b;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * reverting when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a % b;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * CAUTION: This function is deprecated because it requires allocating memory for the error
179      * message unnecessarily. For custom revert reasons use {trySub}.
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(
188         uint256 a,
189         uint256 b,
190         string memory errorMessage
191     ) internal pure returns (uint256) {
192         unchecked {
193             require(b <= a, errorMessage);
194             return a - b;
195         }
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a / b;
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b > 0, errorMessage);
243             return a % b;
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Interface of the ERC20 standard as defined in the EIP.
257  */
258 interface IERC20 {
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `to`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address to, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `from` to `to` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(
327         address from,
328         address to,
329         uint256 amount
330     ) external returns (bool);
331 }
332 
333 // File: @openzeppelin/contracts/utils/Context.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Provides information about the current execution context, including the
342  * sender of the transaction and its data. While these are generally available
343  * via msg.sender and msg.data, they should not be accessed in such a direct
344  * manner, since when dealing with meta-transactions the account sending and
345  * paying for execution may not be the actual sender (as far as an application
346  * is concerned).
347  *
348  * This contract is only required for intermediate, library-like contracts.
349  */
350 abstract contract Context {
351     function _msgSender() internal view virtual returns (address) {
352         return msg.sender;
353     }
354 
355     function _msgData() internal view virtual returns (bytes calldata) {
356         return msg.data;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/access/Ownable.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Contract module which provides a basic access control mechanism, where
370  * there is an account (an owner) that can be granted exclusive access to
371  * specific functions.
372  *
373  * By default, the owner account will be the one that deploys the contract. This
374  * can later be changed with {transferOwnership}.
375  *
376  * This module is used through inheritance. It will make available the modifier
377  * `onlyOwner`, which can be applied to your functions to restrict their use to
378  * the owner.
379  */
380 abstract contract Ownable is Context {
381     address private _owner;
382 
383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385     /**
386      * @dev Initializes the contract setting the deployer as the initial owner.
387      */
388     constructor() {
389         _transferOwnership(_msgSender());
390     }
391 
392     /**
393      * @dev Returns the address of the current owner.
394      */
395     function owner() public view virtual returns (address) {
396         return _owner;
397     }
398 
399     /**
400      * @dev Throws if called by any account other than the owner.
401      */
402     modifier onlyOwner() {
403         require(owner() == _msgSender(), "Ownable: caller is not the owner");
404         _;
405     }
406 
407     /**
408      * @dev Leaves the contract without owner. It will not be possible to call
409      * `onlyOwner` functions anymore. Can only be called by the current owner.
410      *
411      * NOTE: Renouncing ownership will leave the contract without an owner,
412      * thereby removing any functionality that is only available to the owner.
413      */
414     function renounceOwnership() public virtual onlyOwner {
415         _transferOwnership(address(0));
416     }
417 
418     /**
419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
420      * Can only be called by the current owner.
421      */
422     function transferOwnership(address newOwner) public virtual onlyOwner {
423         require(newOwner != address(0), "Ownable: new owner is the zero address");
424         _transferOwnership(newOwner);
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Internal function without access restriction.
430      */
431     function _transferOwnership(address newOwner) internal virtual {
432         address oldOwner = _owner;
433         _owner = newOwner;
434         emit OwnershipTransferred(oldOwner, newOwner);
435     }
436 }
437 
438 // File: Tokens/Akai/Akaiv2.sol
439 
440 
441 pragma solidity ^0.8.7;
442 
443 interface IUniswapV2Factory {
444     function createPair(address tokenA, address tokenB) external returns (address pair);
445 }
446 
447 interface IUniswapV2Router02 {
448 
449     function swapExactETHForTokensSupportingFeeOnTransferTokens(
450         uint256 amountOutMin,
451         address[] calldata path,
452         address to,
453         uint256 deadline
454     ) external payable;
455 
456     function swapExactTokensForETHSupportingFeeOnTransferTokens(
457         uint256 amountIn,
458         uint256 amountOutMin,
459         address[] calldata path,
460         address to,
461         uint256 deadline
462     ) external;
463     
464     function factory() external pure returns (address);
465     function WETH() external pure returns (address);
466     function addLiquidityETH(
467         address token,
468         uint256 amountTokenDesired,
469         uint256 amountTokenMin,
470         uint256 amountETHMin,
471         address to,
472         uint256 deadline
473     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
474     
475 }
476 
477 contract Akai is Context, IERC20, Ownable {
478     
479     using SafeMath for uint256;
480 
481     string private constant _name = "Akai";
482     string private constant _symbol = "AKAI";
483     uint8 private constant _decimals = 18;
484     mapping(address => uint256) private _balances;
485 
486     mapping(address => mapping(address => uint256)) private _allowances;
487     uint256 private _tTotal; //Total Supply
488 
489     uint256 public _maxTxAmount;
490     uint256 public _maxWalletAmount;
491     uint256 public swapAmount;
492     uint256 public _buybackThreshold;
493 
494     //Buy Fees
495     uint256 private bLPFee; 
496     uint256 private bMarketingFee; 
497     uint256 private bBuybackFee; 
498 
499     //Sell Fee
500     uint256 private sLPFee; 
501     uint256 private sMarketingFee; 
502     uint256 private sBuybackFee; 
503 
504     //Early Max Sell Fee (Decay)
505     uint256 private sEarlySellFee;
506     
507     //Previous Fee 
508     uint256 private pLPFee = rLPFee;
509     uint256 private pMarketingFee = rMarketingFee;
510     uint256 private pBuybackFee = rBuybackFee;
511     uint256 private pEarlySellFee = rEarlySellFee;
512 
513     //Real Fee
514     uint256 private rLPFee;
515     uint256 private rMarketingFee;
516     uint256 private rBuybackFee;
517     uint256 private rEarlySellFee;
518 
519     struct FeeBreakdown {
520         uint256 tLiq;
521         uint256 tMarket;
522         uint256 tBuyback;
523         uint256 tEarlySell;
524         uint256 tAmount;
525     }
526 
527     mapping(address => bool) private _isExcludedFromFee;
528     mapping(address => bool) public preTrader;
529     mapping(address => bool) public bots;
530 
531     address payable private _taxWallet1;
532     address payable private _taxWallet2;
533 
534     address private _buybackTokenReceiver;
535     address private _lpTokensReceiver;
536     
537     IUniswapV2Router02 private uniswapV2Router;
538     address public uniswapV2Pair;
539 
540     bool private swapEnabled;
541     bool private swapping;
542 
543     //Decaying Tax Logic
544     uint256 private decayTaxExpiration;
545     mapping(address => uint256) private buyTracker;
546     mapping(address => uint256) private lastBuyTimestamp;
547     mapping(address => uint256) private sellTracker;
548 
549     bool private tradingOpen;
550 
551     modifier lockSwap {
552         swapping = true;
553         _;
554         swapping = false;
555     }
556 
557     constructor() {
558 
559         //Initialize numbers for token
560         _tTotal = 1000000000 * 10**18; //Total Supply
561         _maxTxAmount = _tTotal.mul(10000).div(10000); //1%
562         _maxWalletAmount = _tTotal.mul(10000).div(10000); //%
563         swapAmount = _tTotal.mul(1).div(1000); //0.1%
564         _buybackThreshold = 10; //10 wei
565 
566         //Buy Fees
567         bLPFee = 100; 
568         bMarketingFee = 300; 
569         bBuybackFee = 200; 
570 
571         //Sell Fee
572         sLPFee = 100; 
573         sMarketingFee = 300; 
574         sBuybackFee = 200; 
575         sEarlySellFee = 600;
576             
577         _taxWallet1 = payable(0x51513E1054Eed53FA4A0474A589bB5E94C3188e1);
578         _taxWallet2 = payable(0x51513E1054Eed53FA4A0474A589bB5E94C3188e1);
579         _buybackTokenReceiver = 0x000000000000000000000000000000000000dEaD;
580         _lpTokensReceiver = 0x51513E1054Eed53FA4A0474A589bB5E94C3188e1;
581 
582         swapEnabled = true;
583         tradingOpen = false;
584         swapping = false;
585 
586         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
587         uniswapV2Router = _uniswapV2Router;
588         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
589         
590         _balances[_msgSender()] = _tTotal;
591         _isExcludedFromFee[owner()] = true;
592         _isExcludedFromFee[_taxWallet1] = true;
593         _isExcludedFromFee[_taxWallet2] = true;
594         _isExcludedFromFee[_buybackTokenReceiver] = true;
595         _isExcludedFromFee[_lpTokensReceiver] = true;
596         _isExcludedFromFee[address(this)] = true;
597         preTrader[owner()] = true;
598 
599         //initialie decay tax
600         decayTaxExpiration = 2 days;
601 
602         emit Transfer(address(0), _msgSender(), _tTotal);
603     }
604 
605     function name() public pure returns (string memory) {
606         return _name;
607     }
608 
609     function symbol() public pure returns (string memory) {
610         return _symbol;
611     }
612 
613     function decimals() public pure returns (uint8) {
614         return _decimals;
615     }
616 
617     function totalSupply() public view override returns (uint256) {
618         return _tTotal;
619     }
620 
621     function balanceOf(address account) public view override returns (uint256) {
622         return _balances[account];
623     }
624     
625     function transfer(address recipient, uint256 amount) external override returns (bool) {
626         _transfer(_msgSender(), recipient, amount);
627         return true;
628     }
629 
630     function allowance(address owner, address spender) external view override returns (uint256) {
631         return _allowances[owner][spender];
632     }
633 
634     function approve(address spender, uint256 amount) external override returns (bool) {
635         _approve(_msgSender(), spender, amount);
636         return true;
637     }
638 
639     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
640         _transfer(sender, recipient, amount);
641         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
642         return true;
643     }
644 
645     function removeAllFee() private {
646         if (rLPFee == 0 && rMarketingFee == 0 && rBuybackFee == 0 && rEarlySellFee == 0) return;
647         
648         pLPFee = rLPFee;
649         pMarketingFee = rMarketingFee;
650         pBuybackFee = rBuybackFee;
651         pEarlySellFee = rEarlySellFee;
652 
653         rLPFee = 0;
654         rMarketingFee = 0;
655         rBuybackFee = 0;
656         rEarlySellFee = 0;
657     }
658     
659     function restoreAllFee() private {
660         rLPFee = pLPFee;
661         rMarketingFee = pMarketingFee;
662         rBuybackFee = pBuybackFee;
663         rEarlySellFee = pEarlySellFee;
664     }
665 
666     function _approve(address owner, address spender, uint256 amount) private {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669         _allowances[owner][spender] = amount;
670         emit Approval(owner, spender, amount);
671     }
672     
673     function _transfer(address from, address to, uint256 amount) private {
674 
675         require(from != address(0), "ERC20: transfer from the zero address");
676         require(to != address(0), "ERC20: transfer to the zero address");
677         require(amount > 0, "Transfer amount must be greater than zero");
678         require(!bots[from] && !bots[to], "You are blacklisted");
679 
680         bool takeFee = true;
681 
682         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to] && from != address(this) && to != address(this)) {
683 
684             //Trade start check
685             if (!tradingOpen) {
686                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
687             }
688 
689             //Max wallet Limit
690             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
691                 require(balanceOf(to).add(amount) < _maxWalletAmount, "TOKEN: Balance exceeds wallet size!");
692             }
693             
694             //Max txn amount limit
695             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
696 
697             //Set Fee for Buys
698             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
699                 rLPFee = bLPFee;
700                 rMarketingFee = bMarketingFee;
701                 rBuybackFee = bBuybackFee;
702                 rEarlySellFee = 0;
703             }
704                 
705             //Set Fee for Sells
706             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
707                 rLPFee = sLPFee;
708                 rMarketingFee = sMarketingFee;
709                 rBuybackFee = sBuybackFee;
710                 rEarlySellFee = sEarlySellFee;
711             }
712            
713             if(!swapping && swapEnabled && from != uniswapV2Pair) {
714 
715                 uint256 contractTokenBalance = balanceOf(address(this));
716 
717                 if(contractTokenBalance >= _maxTxAmount) {
718                     contractTokenBalance = _maxTxAmount;
719                 }
720                 
721                 if (contractTokenBalance > swapAmount) {
722                     processDistributions(contractTokenBalance);
723                 }
724 
725             }
726             
727         }
728 
729         //No tax on Transfer Tokens
730         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
731             takeFee = false;
732         }
733 
734         _tokenTransfer(from, to, amount, takeFee);
735 
736     }
737 
738     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
739         
740         if(!takeFee) {
741             removeAllFee();
742         }
743 
744         //Define Fee amounts
745         FeeBreakdown memory fees;
746         fees.tLiq = amount.mul(rLPFee).div(10000);
747         fees.tMarket = amount.mul(rMarketingFee).div(10000);
748         fees.tBuyback = amount.mul(rBuybackFee).div(10000);
749 
750         fees.tEarlySell = 0;
751         if(rEarlySellFee > 0) {
752             uint256 finalEarlySellFee = getUserEarlySellTax(sender, amount, rEarlySellFee);
753             fees.tEarlySell = amount.mul(finalEarlySellFee).div(10000);
754         }
755 
756         //Calculate total fee amount
757         uint256 totalFeeAmount = fees.tLiq.add(fees.tBuyback).add(fees.tMarket).add(fees.tEarlySell);
758         fees.tAmount = amount.sub(totalFeeAmount);
759 
760         //Update balances
761         _balances[sender] = _balances[sender].sub(amount);
762         _balances[recipient] = _balances[recipient].add(fees.tAmount);
763         _balances[address(this)] = _balances[address(this)].add(totalFeeAmount);
764         
765         emit Transfer(sender, recipient, fees.tAmount);
766         if(totalFeeAmount > 0) {
767             emit Transfer(sender, address(this), totalFeeAmount);
768         }
769         restoreAllFee();
770 
771         //Update decay tax for user
772         //Set for Buys
773         if(sender == uniswapV2Pair && recipient != address(uniswapV2Router)) {
774             buyTracker[recipient] += amount;
775             lastBuyTimestamp[recipient] = block.timestamp;
776         }
777             
778         //Set for Sells
779         if (recipient == uniswapV2Pair && sender != address(uniswapV2Router)) {
780             sellTracker[sender] += amount;
781         }
782 
783         // if the sell tracker equals or exceeds the amount of tokens bought,
784         // reset all variables here which resets the time-decaying sell tax logic.
785         if(sellTracker[sender] >= buyTracker[sender]) {
786             resetBuySellDecayTax(sender);
787         }
788         
789         // handles transferring to a fresh wallet or wallet that hasn't bought tokens before
790         if(lastBuyTimestamp[recipient] == 0) {
791             resetBuySellDecayTax(recipient);
792         }
793 
794     }
795     
796     /// @notice Get user decayed tax
797     function getUserEarlySellTax(address _seller, uint256 _sellAmount, uint256 _earlySellFee) public view returns (uint256) {
798         uint256 _tax = _earlySellFee;
799 
800         if(lastBuyTimestamp[_seller] == 0) {
801             return _tax;
802         }
803 
804         if(sellTracker[_seller] + _sellAmount > buyTracker[_seller]) {
805             return _tax;
806         }
807 
808         if(block.timestamp > getSellEarlyExpiration(_seller)) {
809             return 0;
810         }
811 
812         uint256 _secondsAfterBuy = block.timestamp - lastBuyTimestamp[_seller];
813         return (_tax * (decayTaxExpiration - _secondsAfterBuy)) / decayTaxExpiration;
814     }
815 
816     function getSellEarlyExpiration(address _seller) private  view returns (uint256) {
817         return lastBuyTimestamp[_seller] == 0 ? 0 : lastBuyTimestamp[_seller] + decayTaxExpiration;
818     }
819 
820     function resetBuySellDecayTax(address _user) private {
821         buyTracker[_user] = balanceOf(_user);
822         lastBuyTimestamp[_user] = block.timestamp;
823         sellTracker[_user] = 0;
824     }
825 
826     //Buyback Module
827     function buyBackTokens() private lockSwap {
828         if(address(this).balance > 0) {
829     	    swapETHForTokens(address(this).balance);
830         }
831     }
832 
833     function swapETHForTokens(uint256 amount) private {
834         address[] memory path = new address[](3);
835         path[0] = uniswapV2Router.WETH();
836         path[1] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //USDC Address
837         path[2] = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE; //SHIB Address
838         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
839             0, // accept any amount of Tokens
840             path,
841             _buybackTokenReceiver, //Send bought tokens to this address
842             block.timestamp.add(300)
843         );
844     }
845 
846     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
847         address[] memory path = new address[](2);
848         path[0] = address(this);
849         path[1] = uniswapV2Router.WETH();
850         _approve(address(this), address(uniswapV2Router), tokenAmount);
851         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
852             tokenAmount,
853             0,
854             path,
855             address(this),
856             block.timestamp
857         );
858     }
859     
860     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
861 
862         // approve token transfer to cover all possible scenarios
863         _approve(address(this), address(uniswapV2Router), tokenAmount);
864 
865         // add the liquidity
866         uniswapV2Router.addLiquidityETH{value: ethAmount}(
867             address(this),
868             tokenAmount,
869             0, // slippage is unavoidable
870             0, // slippage is unavoidable
871             _lpTokensReceiver,
872             block.timestamp
873         );
874     }
875 
876     function sendETHToFee(uint256 amount) private {
877         _taxWallet1.transfer(amount.div(2));
878         _taxWallet2.transfer(amount.div(2));
879     }
880 
881     function processDistributions(uint256 tokens) private {
882 
883         uint256 totalTokensFee = sMarketingFee.add(sLPFee).add(sBuybackFee);
884         uint256 halfLPFee = sLPFee.div(2);
885 
886         //Get tokens to swap for eth. excluding tokens to add to LP
887         uint256 tokensToSwapToETH = tokens.mul(totalTokensFee.sub(halfLPFee)).div(totalTokensFee);
888 
889         //Swap for eth
890         uint256 initialETHBalance = address(this).balance;
891         swapTokensForEth(tokensToSwapToETH);
892         uint256 newETHBalance = address(this).balance.sub(initialETHBalance);
893 
894         uint256 liquidityTokens = tokens.mul(halfLPFee).div(totalTokensFee);
895 
896         uint256 ethMarketingShare = newETHBalance.mul(sMarketingFee).div(totalTokensFee.sub(halfLPFee));
897         uint256 ethLPShare = newETHBalance.mul(halfLPFee).div(totalTokensFee.sub(halfLPFee));
898 
899         //Send eth share to distribute to tax wallets        
900         sendETHToFee(ethMarketingShare);
901         //Send lp share along with tokens to add LP
902         addLiquidity(liquidityTokens, ethLPShare);
903         //Leave the remaining eth in contract itself for buybacking
904 
905         //Process buyback
906         if(address(this).balance >= _buybackThreshold) {
907             buyBackTokens();
908         }
909     }
910     
911     /// @notice Manually convert tokens in contract to Eth
912     function manualswap() external {
913         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
914         uint256 contractBalance = balanceOf(address(this));
915         if (contractBalance > 0) {
916             swapTokensForEth(contractBalance);
917         }
918     }
919 
920     /// @notice Manually send ETH in contract to marketing wallets
921     function manualsend() external {
922         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
923         uint256 contractETHBalance = address(this).balance;
924         if (contractETHBalance > 0) {
925             sendETHToFee(contractETHBalance);
926         }
927     }
928 
929     /// @notice Manually execute buyback with Eth availabe in contract
930     function manualBuyBack() external {
931         require(_msgSender() == _taxWallet1 || _msgSender() == _taxWallet2 || _msgSender() == owner());
932         require(address(0).balance > 0, "No ETH in contract to buyback");
933         buyBackTokens();
934     }
935 
936     receive() external payable {}
937 
938     /// @notice Add an address to a pre trader
939     function allowPreTrading(address account, bool allowed) public onlyOwner {
940         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
941         preTrader[account] = allowed;
942     }
943 
944     /// @notice Add multiple address to exclude/include fee
945     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
946         for(uint256 i = 0; i < accounts.length; i++) {
947             _isExcludedFromFee[accounts[i]] = excluded;
948         }
949     }
950 
951     /// @notice Block address from transfer
952     function blockMultipleBots(address[] calldata _bots, bool status) public onlyOwner {
953         for(uint256 i = 0; i < _bots.length; i++) {
954             bots[_bots[i]] = status;
955         }
956     }
957 
958     /// @notice Enable disable trading
959     function setTrading(bool _tradingOpen) public onlyOwner {
960         tradingOpen = _tradingOpen;
961     }
962 
963     /// @notice Enable/Disable contract fee distribution
964     function toggleSwap(bool _swapEnabled) public onlyOwner {
965         swapEnabled = _swapEnabled;
966     }
967 
968     //Settings: Limits
969     /// @notice Set maximum wallet limit
970     function setMaxWalletAmount(uint256 maxWalletAmount) public onlyOwner() {
971         require(maxWalletAmount > _tTotal.div(1000), "Amount must be greater than 0.1% of supply");
972         _maxWalletAmount = maxWalletAmount;
973     }
974 
975     /// @notice Set max amount a user can buy/sell/transfer
976     function setMaxTxnAmount(uint256 maxTxnAmount) public onlyOwner() {
977         require(_maxTxAmount > _tTotal.div(1000), "Amount must be greater than 0.1% of supply");
978         _maxTxAmount = maxTxnAmount;
979     }
980 
981     /// @notice Set Contract swap amount threshold
982     function setSwapAmount(uint256 _swapAmount) public onlyOwner() {
983         swapAmount = _swapAmount;
984     }
985 
986     /// @notice Set buyback threshold
987     function setBuyBackThreshold(uint256 amount) public onlyOwner {
988         _buybackThreshold = amount;
989     }
990 
991     /// @notice Set wallets
992     function setWallets(address taxWallet1, address taxWallet2, address lpTokensReceiver, address buybackTokenReceiver) public onlyOwner {
993         _taxWallet1 = payable(taxWallet1);
994         _taxWallet2 = payable(taxWallet2);
995         _lpTokensReceiver = lpTokensReceiver;
996         _buybackTokenReceiver = buybackTokenReceiver;
997     }
998 
999     /// @notice Setup fee in rate of 100 (If 1%, then set 100)
1000     function setBuyFee(uint256 _bMarketingFee, uint256 _bLPFee, uint256 _bBuybackFee) public onlyOwner {
1001         
1002         //Hard cap check to prevent honeypot
1003         require(_bMarketingFee <= 2000, "Hard cap 20%");
1004         require(_bLPFee <= 2000, "Hard cap 20%");
1005         require(_bBuybackFee <= 2000, "Hard cap 20%");
1006         
1007         bMarketingFee = _bMarketingFee;
1008         bLPFee = _bLPFee;
1009         bBuybackFee = _bBuybackFee;
1010     
1011     }
1012 
1013     /// @notice Setup fee in rate of 100 (If 1%, then set 100)
1014     function setSellFee(uint256 _sMarketingFee, uint256 _sLPFee, uint256 _sBuybackFee, uint256 _sEarlySellFee) public onlyOwner {
1015         
1016         //Hard cap check to prevent honeypot
1017         require(_sMarketingFee <= 2000, "Hard cap 20%");
1018         require(_sLPFee <= 2000, "Hard cap 20%");
1019         require(_sBuybackFee <= 2000, "Hard cap 20%");
1020         require(_sEarlySellFee <= 2000, "Hard cap 20%");
1021         
1022         sMarketingFee = _sMarketingFee;
1023         sLPFee = _sLPFee;
1024         sBuybackFee = _sBuybackFee;
1025         sEarlySellFee = _sEarlySellFee;
1026     
1027     }
1028 
1029     function readFees() external view returns (uint _totalBuyFee, uint _totalSellFee, uint _marketingFeeBuy, uint _marketingFeeSell, uint _liquidityFeeBuy, uint _liquidityFeeSell, uint _buybackFeeBuy, uint _buybackFeeSell, uint maxEarlySellFee) {
1030 
1031         return (
1032             bMarketingFee+bLPFee+bBuybackFee,
1033             sMarketingFee+sLPFee+sBuybackFee+sEarlySellFee,
1034             bMarketingFee,
1035             sMarketingFee,
1036             bLPFee,
1037             sLPFee,
1038             bBuybackFee,
1039             sBuybackFee,
1040             sEarlySellFee
1041         );
1042     }
1043 
1044     /// @notice Airdropper inbuilt
1045     function multiSend(address[] calldata addresses, uint256[] calldata amounts, bool overrideTracker, uint256 trackerTimestamp) external {
1046         require(addresses.length == amounts.length, "Must be the same length");
1047         for(uint256 i = 0; i < addresses.length; i++){
1048             _transfer(_msgSender(), addresses[i], amounts[i] * 10**_decimals);
1049 
1050             //Suppose to airdrop holders who bought long back and don't want to reset their decaytax
1051             if(overrideTracker) {
1052                 //Override buytracker
1053                 buyTracker[addresses[i]] += amounts[i];
1054                 lastBuyTimestamp[addresses[i]] = trackerTimestamp;
1055             }
1056         }
1057     }
1058     
1059 }