1 // SPDX-License-Identifier: MIT
2 /**
3     ██████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗██████╗░██╗░░░░░███████╗███╗░░██╗██████╗░
4     ██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░██╔╝██╔══██╗██║░░░░░██╔════╝████╗░██║██╔══██╗
5     ██████╦╝██║░░░░░██║░░██║██║░░╚═╝█████═╝░██████╦╝██║░░░░░█████╗░░██╔██╗██║██║░░██║
6     ██╔══██╗██║░░░░░██║░░██║██║░░██╗██╔═██╗░██╔══██╗██║░░░░░██╔══╝░░██║╚████║██║░░██║
7     ██████╦╝███████╗╚█████╔╝╚█████╔╝██║░╚██╗██████╦╝███████╗███████╗██║░╚███║██████╔╝
8     ╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝╚═════╝░╚══════╝╚══════╝╚═╝░░╚══╝╚═════╝░
9     Telegram - https://t.me/blockblendIO
10     Audited
11 */
12 
13 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
14 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 // CAUTION
19 // This version of SafeMath should only be used with Solidity 0.8 or later,
20 // because it relies on the compiler's built in overflow checks.
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations.
24  *
25  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
26  * now has built in overflow checking.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     /**
43      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b > a) return (false, 0);
50             return (true, a - b);
51         }
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62             // benefit is lost if 'b' is also tested.
63             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64             if (a == 0) return (true, 0);
65             uint256 c = a * b;
66             if (c / a != b) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the division of two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a / b);
80         }
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a % b);
92         }
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a + b;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a - b;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers, reverting on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator.
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * reverting when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a % b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b <= a, errorMessage);
187             return a - b;
188         }
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         unchecked {
209             require(b > 0, errorMessage);
210             return a / b;
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a % b;
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Context.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Provides information about the current execution context, including the
250  * sender of the transaction and its data. While these are generally available
251  * via msg.sender and msg.data, they should not be accessed in such a direct
252  * manner, since when dealing with meta-transactions the account sending and
253  * paying for execution may not be the actual sender (as far as an application
254  * is concerned).
255  *
256  * This contract is only required for intermediate, library-like contracts.
257  */
258 abstract contract Context {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes calldata) {
264         return msg.data;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/access/Ownable.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 abstract contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor() {
297         _transferOwnership(_msgSender());
298     }
299 
300     /**
301      * @dev Returns the address of the current owner.
302      */
303     function owner() public view virtual returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public virtual onlyOwner {
323         _transferOwnership(address(0));
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Internal function without access restriction.
338      */
339     function _transferOwnership(address newOwner) internal virtual {
340         address oldOwner = _owner;
341         _owner = newOwner;
342         emit OwnershipTransferred(oldOwner, newOwner);
343     }
344 }
345 
346 // File: ethtoken.sol
347 
348 pragma solidity ^0.8.7;
349 
350 
351 
352 /**
353  * @dev Interfaces
354  */
355 
356 interface IDEXFactory {
357     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
358 
359     function feeTo() external view returns (address);
360     function feeToSetter() external view returns (address);
361 
362     function getPair(address tokenA, address tokenB) external view returns (address pair);
363     function allPairs(uint) external view returns (address pair);
364     function allPairsLength() external view returns (uint);
365 
366     function createPair(address tokenA, address tokenB) external returns (address pair);
367 
368     function setFeeTo(address) external;
369     function setFeeToSetter(address) external;
370 }
371 
372 interface IDEXRouter {
373     function factory() external pure returns (address);
374     function WETH() external pure returns (address);
375 
376     function addLiquidity(
377         address tokenA,
378         address tokenB,
379         uint amountADesired,
380         uint amountBDesired,
381         uint amountAMin,
382         uint amountBMin,
383         address to,
384         uint deadline
385     ) external returns (uint amountA, uint amountB, uint liquidity);
386 
387     function addLiquidityETH(
388         address token,
389         uint amountTokenDesired,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
395 
396     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
397         uint amountIn,
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external;
403 
404     function swapExactTokensForETHSupportingFeeOnTransferTokens(
405         uint amountIn,
406         uint amountOutMin,
407         address[] calldata path,
408         address to,
409         uint deadline
410     ) external;
411 }
412 
413 interface IPancakeswapV2Pair {
414     event Approval(address indexed owner, address indexed spender, uint value);
415     event Transfer(address indexed from, address indexed to, uint value);
416 
417     function name() external pure returns (string memory);
418     function symbol() external pure returns (string memory);
419     function decimals() external pure returns (uint8);
420     function totalSupply() external view returns (uint);
421     function balanceOf(address owner) external view returns (uint);
422     function allowance(address owner, address spender) external view returns (uint);
423 
424     function approve(address spender, uint value) external returns (bool);
425     function transfer(address to, uint value) external returns (bool);
426     function transferFrom(address from, address to, uint value) external returns (bool);
427 
428     function DOMAIN_SEPARATOR() external view returns (bytes32);
429     function PERMIT_TYPEHASH() external pure returns (bytes32);
430     function nonces(address owner) external view returns (uint);
431 
432     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
433 
434     event Mint(address indexed sender, uint amount0, uint amount1);
435     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
436     event Swap(
437         address indexed sender,
438         uint amount0In,
439         uint amount1In,
440         uint amount0Out,
441         uint amount1Out,
442         address indexed to
443     );
444     event Sync(uint112 reserve0, uint112 reserve1);
445 
446     function MINIMUM_LIQUIDITY() external pure returns (uint);
447     function factory() external view returns (address);
448     function token0() external view returns (address);
449     function token1() external view returns (address);
450     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
451     function price0CumulativeLast() external view returns (uint);
452     function price1CumulativeLast() external view returns (uint);
453     function kLast() external view returns (uint);
454 
455     function mint(address to) external returns (uint liquidity);
456     function burn(address to) external returns (uint amount0, uint amount1);
457     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
458     function skim(address to) external;
459     function sync() external;
460 
461     function initialize(address, address) external;
462 }
463 
464 /**
465  * @dev Interface of the ERC20 standard as defined in the EIP.
466  */
467 interface IERC20 {
468     function totalSupply() external view returns (uint256);
469     function balanceOf(address account) external view returns (uint256);
470     function transfer(address to, uint256 amount) external returns (bool);
471     function allowance(address owner, address spender) external view returns (uint256);
472     function approve(address spender, uint256 amount) external returns (bool);
473 
474     /**
475      * @dev Returns the decimals places of the token.
476      */
477     function decimals() external view returns (uint8);
478 
479     /**
480      * @dev Moves `amount` tokens from `from` to `to` using the
481      * allowance mechanism. `amount` is then deducted from the caller's
482      * allowance.
483      *
484      * Returns a boolean value indicating whether the operation succeeded.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 amount
492     ) external returns (bool);
493 
494     /**
495      * @dev Emitted when `value` tokens are moved from one account (`from`) to
496      * another (`to`).
497      *
498      * Note that `value` may be zero.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 value);
501 
502     /**
503      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
504      * a call to {approve}. `value` is the new allowance.
505      */
506     event Approval(address indexed owner, address indexed spender, uint256 value);
507 }
508 
509 /**
510  * @dev Interface for the optional metadata functions from the ERC20 standard.
511  *
512  * _Available since v4.1._
513  */
514 interface IERC20Metadata is IERC20 {
515     /**
516      * @dev Returns the name of the token.
517      */
518     function name() external view returns (string memory);
519 
520     /**
521      * @dev Returns the symbol of the token.
522      */
523     function symbol() external view returns (string memory);
524 }
525 
526 contract BlockBlend is Context, IERC20, IERC20Metadata, Ownable {
527     using SafeMath for uint256;
528 
529     mapping(address => uint256) private _balances;
530 
531     mapping(address => mapping(address => uint256)) private _allowances;
532 
533     uint256 _totalSupply;
534     uint256 _maxSupply = 100_000_000 * (10 ** decimals());
535     string private _name;
536     string private _symbol;
537     uint8 private _decimals;
538 
539     // fees & addresses
540     mapping (string => uint) txFees;
541     
542     mapping (address => bool) public feeExempt;
543     mapping (address => bool) public txLimitExempt;
544     
545     address public farmingAddress = 0xA56CC65a2aa9B7cC3A2a1819D14B67532Cf031dc;
546     address public taxAddress = 0xA56CC65a2aa9B7cC3A2a1819D14B67532Cf031dc;
547 
548     // taxes for differnet levels
549     struct TaxLevels {
550         uint taxDiscount;
551         uint amount;
552     }
553 
554     struct TokenFee {
555         uint forMarketing;
556         uint forLiquidity;
557         uint forDev;
558         uint forFarming;
559     }
560 
561     struct TxLimit {
562         uint buyLimit;
563         uint sellLimit;
564         uint cooldown;
565         mapping(address => uint) buys;
566         mapping(address => uint) sells;
567         mapping(address => uint) lastTx;
568     }
569 
570     mapping (uint => TaxLevels) taxTiers;
571     TxLimit txLimits;
572 
573     IDEXRouter public router;
574     address public pair;
575     address bridge;
576 
577     constructor(address _bridge) {
578         _name = "BlockBlend";
579         _symbol = "BBL";
580         _decimals = 18;
581         bridge = _bridge;
582         
583         /**
584             Disable fees & limits for:
585             - deployer
586             - farming
587             - tax collector
588         */
589         feeExempt[msg.sender] = true;
590         txLimitExempt[msg.sender] = true;
591         feeExempt[farmingAddress] = true;
592         txLimitExempt[farmingAddress] = true;
593         feeExempt[taxAddress] = true;
594         txLimitExempt[taxAddress] = true;
595 
596         /**
597             Set default buy/sell tx fees (no tax on transfers)
598             - marketing, dev, liqudity, farming
599         */
600         txFees["marketingBuy"] = 2;
601         txFees["devBuy"] = 1;
602         txFees["liquidityBuy"] = 1;
603         txFees["farmingBuy"] = 1;
604 
605         txFees["marketingSell"] = 3;
606         txFees["devSell"] = 2;
607         txFees["liquiditySell"] = 2;
608         txFees["farmingSell"] = 2;
609 
610         /**
611             Set default tx limits
612             - Cooldown, buy limit, sell limit
613         */
614         txLimits.cooldown = 3 minutes;
615         txLimits.buyLimit = 200_000 ether;
616         txLimits.sellLimit = 50_000 ether; // 0.25%
617         
618         /**
619             Set default tax levels.
620             - 150k+ tokens: 15% discount on fees
621             - 1m+ tokens: 35% discount on fees
622         */
623         taxTiers[0].taxDiscount = 50;
624         taxTiers[0].amount = 500_000 ether;
625         taxTiers[1].taxDiscount = 100;
626         taxTiers[1].amount = 1_000_000 ether;
627 
628         address WBNB = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH Mainnet
629         address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap
630         router = IDEXRouter(_router);
631         pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
632         _allowances[address(this)][address(router)] = _totalSupply;
633         approve(_router, _totalSupply);
634     }
635 
636     /**
637         Sets buy/sell transaction fees
638     */
639     event Fees(
640         uint _marketingBuy,
641         uint _devBuy,
642         uint _liquidityBuy,
643         uint _farmingBuy,
644         uint _marketingSell,
645         uint _devSell,
646         uint _liquiditySell,
647         uint _farmingSell
648     );
649 
650     function setFees(
651         uint _marketingBuy,
652         uint _devBuy,
653         uint _liquidityBuy,
654         uint _farmingBuy,
655         uint _marketingSell,
656         uint _devSell,
657         uint _liquiditySell,
658         uint _farmingSell
659     ) external onlyOwner {
660         require(_marketingBuy <= 8, "Marketing fee is too high!");
661         require(_devBuy <= 8, "Dev fee is too high!");
662         require(_liquidityBuy <= 8, "Liquidity fee is too high!");
663         require(_farmingBuy <= 8, "Farming fee is too high!");
664         require(_marketingSell <= 8, "Marketing fee is too high!");
665         require(_devSell <= 8, "Dev fee is too high!");
666         require(_liquiditySell <= 8, "Liquidity fee is too high!");
667         require(_farmingSell <= 8, "Farming fee is too high!");
668 
669         txFees["marketingBuy"] = _marketingBuy;
670         txFees["devBuy"] = _devBuy;
671         txFees["liquidityBuy"] = _liquidityBuy;
672         txFees["farmingBuy"] = _farmingBuy;
673 
674         txFees["marketingSell"] = _marketingSell;
675         txFees["devSell"] = _devSell;
676         txFees["liquiditySell"] = _liquiditySell;
677         txFees["farmingSell"] = _farmingSell;
678 
679         emit Fees(
680             _marketingBuy,
681             _devBuy,
682             _liquidityBuy,
683             _farmingBuy,
684             _marketingSell,
685             _devSell,
686             _liquiditySell,
687             _farmingSell
688         );
689     }
690 
691     /**
692         Returns buy/sell transaction fees
693     */
694     function getFees() public view returns(
695         uint marketingBuy,
696         uint devBuy,
697         uint liquidityBuy,
698         uint farmingBuy,
699         uint marketingSell,
700         uint devSell,
701         uint liquiditySell,
702         uint farmingSell
703     ) {
704         return (
705             txFees["marketingBuy"],
706             txFees["devBuy"],
707             txFees["liquidityBuy"],
708             txFees["farmingBuy"],
709             txFees["marketingSell"],
710             txFees["devSell"],
711             txFees["liquiditySell"],
712             txFees["farmingSell"]
713         );
714     }
715 
716     /**
717         Sets the tax collector contracts
718     */
719     function setTaxAddress(address _farmingAddress, address _taxAddress) external onlyOwner {
720         farmingAddress = _farmingAddress;
721         taxAddress = _taxAddress;
722     }
723 
724     /**
725         Sets the tax free trading for the specific address
726     */
727     function setFeeExempt(address _address, bool _value) external onlyOwner {
728         feeExempt[_address] = _value;
729     }
730 
731     /**
732         Sets the limit free trading for the specific address
733     */
734     function setTxLimitExempt(address _address, bool _value) external onlyOwner {
735         txLimitExempt[_address] = _value;
736     }
737 
738     /**
739         Sets the different tax levels for buy transactions
740     */
741     function setTaxTiers(uint _discount1, uint _amount1, uint _discount2, uint _amount2) external onlyOwner {
742         require(_discount1 > 0 && _discount2 > 0 && _amount1 > 0 && _amount2 > 0, "Values have to be bigger than zero!");
743         taxTiers[0].taxDiscount = _discount1;
744         taxTiers[0].amount = _amount1;
745         taxTiers[1].taxDiscount = _discount2;
746         taxTiers[1].amount = _amount2;
747     }
748 
749     /**
750         Returns the different tax levels for buy transactions
751     */
752     function getTaxTiers() public view returns(uint discount1, uint amount1, uint discount2, uint amount2) {
753         return (taxTiers[0].taxDiscount, taxTiers[0].amount, taxTiers[1].taxDiscount, taxTiers[1].amount);
754     }
755 
756     /**
757         Sets the sell/buy limits & cooldown period
758     */
759     function setTxLimits(uint _buyLimit, uint _sellLimit, uint _cooldown) external onlyOwner {
760         require(_buyLimit >= _totalSupply.div(200), "Buy transaction limit is too low!"); // 0.5%
761         require(_sellLimit >= _totalSupply.div(400), "Sell transaction limit is too low!"); // 0.25%
762         require(_cooldown <= 30 minutes, "Cooldown should be 30 minutes or less!");
763 
764         txLimits.buyLimit = _buyLimit;
765         txLimits.sellLimit = _sellLimit;
766         txLimits.cooldown = _cooldown;
767     }
768 
769     /**
770         Returns the sell/buy limits & cooldown period
771     */
772     function getTxLimits() public view returns(uint buyLimit, uint sellLimit, uint cooldown) {
773         return (txLimits.buyLimit, txLimits.sellLimit, txLimits.cooldown);
774     }
775 
776     /**
777         Checks the BUY transaction limits for the specific user with the sent amount
778     */
779     function checkBuyTxLimit(address _sender, uint256 _amount) internal view {
780         require(
781             txLimitExempt[_sender] == true ||
782             txLimits.buys[_sender].add(_amount) < txLimits.buyLimit,
783             "Buy transaction limit reached!"
784         );
785     }
786 
787     /**
788         Checks the SELL transaction limits for the specific user with the sent amount
789     */
790     function checkSellTxLimit(address _sender, uint256 _amount) internal view {
791         require(
792             txLimitExempt[_sender] == true ||
793             txLimits.sells[_sender].add(_amount) < txLimits.sellLimit,
794             "Sell transaction limit reached!"
795         );
796     }
797     
798     /**
799         Saves the recent buy/sell transactions
800         The function used by _transfer() when the cooldown/tx limit is active
801     */
802     function setRecentTx(bool _isSell, address _sender, uint _amount) internal {
803         if(txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp) {
804             _isSell ? txLimits.sells[_sender] = _amount : txLimits.buys[_sender] = _amount;
805         } else {
806             _isSell ? txLimits.sells[_sender] += _amount : txLimits.buys[_sender] += _amount;
807         }
808 
809         txLimits.lastTx[_sender] = block.timestamp;
810     }
811 
812     /**
813         Returns the recent buys, sells and the last transaction for the specific wallet
814     */
815     function getRecentTx(address _address) public view returns(uint buys, uint sells, uint lastTx) {
816         return (txLimits.buys[_address], txLimits.sells[_address], txLimits.lastTx[_address]);
817     }
818 
819     /**
820         Returns the token price
821     */
822     function getTokenPrice(uint _amount) public view returns(uint) {
823         IPancakeswapV2Pair pcsPair = IPancakeswapV2Pair(pair);
824         IERC20 token1 = IERC20(pcsPair.token1());
825     
826     
827         (uint Res0, uint Res1,) = pcsPair.getReserves();
828 
829         // decimals
830         uint res0 = Res0*(10**token1.decimals());
831         //uint256 res0 = Res0*(10**decimals());
832         return((_amount.mul(res0)).div(Res1)); // returns how much kaiken you will get on that eth amount
833     }
834 
835     /**
836      * @dev Returns the name of the token.
837      */
838     function name() public view virtual override returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev Returns the symbol of the token, usually a shorter version of the
844      * name.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     function decimals() public view virtual override returns (uint8) {
851         return _decimals;
852     }
853     
854     function totalSupply() public view virtual override returns (uint256) {
855         return _totalSupply;
856     }
857 
858     function balanceOf(address account) public view virtual override returns (uint256) {
859         return _balances[account];
860     }
861 
862     /**
863      * @dev See {IERC20-transfer}.
864      *
865      * Requirements:
866      *
867      * - `to` cannot be the zero address.
868      * - the caller must have a balance of at least `amount`.
869      */
870     function transfer(address to, uint256 amount) public virtual override returns (bool) {
871         address owner = _msgSender();
872         _transfer(owner, to, amount);
873         return true;
874     }
875 
876     /**
877      * @dev See {IERC20-allowance}.
878      */
879     function allowance(address owner, address spender) public view virtual override returns (uint256) {
880         return _allowances[owner][spender];
881     }
882 
883     /**
884      * @dev See {IERC20-approve}.
885      *
886      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
887      * `transferFrom`. This is semantically equivalent to an infinite approval.
888      *
889      * Requirements:
890      *
891      * - `spender` cannot be the zero address.
892      */
893     function approve(address spender, uint256 amount) public virtual override returns (bool) {
894         address owner = _msgSender();
895         _approve(owner, spender, amount);
896         return true;
897     }
898 
899     /**
900      * @dev See {IERC20-transferFrom}.
901      *
902      * Emits an {Approval} event indicating the updated allowance. This is not
903      * required by the EIP. See the note at the beginning of {ERC20}.
904      *
905      * NOTE: Does not update the allowance if the current allowance
906      * is the maximum `uint256`.
907      *
908      * Requirements:
909      *
910      * - `from` and `to` cannot be the zero address.
911      * - `from` must have a balance of at least `amount`.
912      * - the caller must have allowance for ``from``'s tokens of at least
913      * `amount`.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 amount
919     ) public virtual override returns (bool) {
920         address spender = _msgSender();
921         _spendAllowance(from, spender, amount);
922         _transfer(from, to, amount);
923         return true;
924     }
925 
926     /**
927      * @dev Atomically increases the allowance granted to `spender` by the caller.
928      *
929      * This is an alternative to {approve} that can be used as a mitigation for
930      * problems described in {IERC20-approve}.
931      *
932      * Emits an {Approval} event indicating the updated allowance.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      */
938     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
939         address owner = _msgSender();
940         _approve(owner, spender, allowance(owner, spender) + addedValue);
941         return true;
942     }
943 
944     /**
945      * @dev Atomically decreases the allowance granted to `spender` by the caller.
946      *
947      * This is an alternative to {approve} that can be used as a mitigation for
948      * problems described in {IERC20-approve}.
949      *
950      * Emits an {Approval} event indicating the updated allowance.
951      *
952      * Requirements:
953      *
954      * - `spender` cannot be the zero address.
955      * - `spender` must have allowance for the caller of at least
956      * `subtractedValue`.
957      */
958     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
959         address owner = _msgSender();
960         uint256 currentAllowance = allowance(owner, spender);
961         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
962         unchecked {
963             _approve(owner, spender, currentAllowance - subtractedValue);
964         }
965 
966         return true;
967     }
968 
969     /**
970      * @dev Moves `amount` of tokens from `sender` to `recipient`.
971      *
972      * This internal function is equivalent to {transfer}, and can be used to
973      * e.g. implement automatic token fees, slashing mechanisms, etc.
974      *
975      * Emits a {Transfer} event.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `from` must have a balance of at least `amount`.
982      */
983     function _transfer(
984         address from,
985         address to,
986         uint256 amount
987     ) internal virtual {
988         require(from != address(0), "ERC20: transfer from the zero address");
989         require(to != address(0), "ERC20: transfer to the zero address");
990 
991         uint256 fromBalance = _balances[from];
992         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
993 
994         uint marketingFee;
995         uint devFee;
996         uint liquidityFee;
997         uint farmingFee;
998 
999         uint taxDiscount;
1000         bool hasFees = true;
1001 
1002         // BUY
1003         if(from == pair) {
1004             checkBuyTxLimit(to, amount); // todo test
1005 
1006             setRecentTx(false, to, amount);
1007 
1008             marketingFee = txFees["marketingBuy"];
1009             devFee = txFees["devBuy"];
1010             liquidityFee = txFees["liquidityBuy"];
1011             farmingFee = txFees["farmingBuy"];
1012 
1013             // Tax levels for bigger buys
1014             if(amount >= taxTiers[0].amount && amount < taxTiers[1].amount) {
1015                 taxDiscount = taxTiers[0].taxDiscount;
1016             } else if(amount >= taxTiers[1].amount) {
1017                 taxDiscount = taxTiers[1].taxDiscount;
1018             }
1019         }
1020         // SELL
1021         else if(to == pair) {
1022             checkSellTxLimit(from, amount);
1023 
1024             setRecentTx(true, from, amount);
1025 
1026             marketingFee = txFees["marketingSell"];
1027             devFee = txFees["devSell"];
1028             liquidityFee = txFees["liquiditySell"];
1029             farmingFee = txFees["farmingSell"];
1030         }
1031 
1032         unchecked {
1033             _balances[from] = fromBalance - amount;
1034         }
1035 
1036         if(feeExempt[to] || feeExempt[from]) {
1037             hasFees = false;
1038         }
1039 
1040         if(hasFees && (to == pair || from == pair)) {
1041             TokenFee memory TokenFees;
1042             TokenFees.forMarketing = amount.mul(marketingFee).mul(100 - taxDiscount).div(10000);
1043             TokenFees.forLiquidity = amount.mul(liquidityFee).mul(100 - taxDiscount).div(10000);
1044             TokenFees.forDev = amount.mul(devFee).mul(100 - taxDiscount).div(10000);
1045             TokenFees.forFarming = amount.mul(farmingFee).mul(100 - taxDiscount).div(10000);
1046 
1047             uint totalFees =
1048                 TokenFees.forMarketing
1049                 .add(TokenFees.forLiquidity)
1050                 .add(TokenFees.forDev)
1051                 .add(TokenFees.forFarming);
1052 
1053             amount = amount.sub(totalFees);
1054 
1055             //_balances[farmingAddress] += TokenFees.forFarming; // farming pool
1056             //emit Transfer(from, farmingAddress, TokenFees.forFarming);
1057 
1058             _balances[taxAddress] += totalFees; // dev, lp, marketing fees (+ farming to save gas)
1059             emit Transfer(from, taxAddress, totalFees);
1060         }
1061 
1062         _balances[to] += amount;
1063 
1064         emit Transfer(from, to, amount);
1065     }
1066 
1067     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1068      * the total supply.
1069      *
1070      * Emits a {Transfer} event with `from` set to the zero address.
1071      *
1072      * Requirements:
1073      *
1074      * - `account` cannot be the zero address.
1075      */
1076     function _mint(address account, uint256 amount) internal virtual {
1077         require(account != address(0), "ERC20: mint to the zero address");
1078         require(_maxSupply <= _totalSupply + amount, "Mint error! Amount can't be more than the total supply on BSC!");
1079 
1080         _totalSupply += amount;
1081         _balances[account] += amount;
1082         
1083         emit Transfer(address(0), account, amount);
1084     }
1085 
1086     function mint(address recipient, uint256 amount) public virtual onlyBridge {
1087         _mint(recipient, amount);
1088     }
1089 
1090     /**
1091      * @dev Destroys `amount` tokens from `account`, reducing the
1092      * total supply.
1093      *
1094      * Emits a {Transfer} event with `to` set to the zero address.
1095      *
1096      * Requirements:
1097      *
1098      * - `account` cannot be the zero address.
1099      * - `account` must have at least `amount` tokens.
1100      */
1101     function _burn(address account, uint256 amount) internal virtual {
1102         require(account != address(0), "ERC20: burn from the zero address");
1103 
1104         uint256 accountBalance = _balances[account];
1105         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1106         unchecked {
1107             _balances[account] = accountBalance - amount;
1108         }
1109         _totalSupply -= amount;
1110 
1111         emit Transfer(account, address(0), amount);
1112     }
1113 
1114     function burn(uint256 amount) public virtual onlyBridge {
1115         _burn(_msgSender(), amount);
1116     }
1117 
1118     /**
1119      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1120      *
1121      * This internal function is equivalent to `approve`, and can be used to
1122      * e.g. set automatic allowances for certain subsystems, etc.
1123      *
1124      * Emits an {Approval} event.
1125      *
1126      * Requirements:
1127      *
1128      * - `owner` cannot be the zero address.
1129      * - `spender` cannot be the zero address.
1130      */
1131     function _approve(
1132         address owner,
1133         address spender,
1134         uint256 amount
1135     ) internal virtual {
1136         require(owner != address(0), "ERC20: approve from the zero address");
1137         require(spender != address(0), "ERC20: approve to the zero address");
1138 
1139         _allowances[owner][spender] = amount;
1140         emit Approval(owner, spender, amount);
1141     }
1142 
1143     /**
1144      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1145      *
1146      * Does not update the allowance amount in case of infinite allowance.
1147      * Revert if not enough allowance is available.
1148      *
1149      * Might emit an {Approval} event.
1150      */
1151     function _spendAllowance(
1152         address owner,
1153         address spender,
1154         uint256 amount
1155     ) internal virtual {
1156         uint256 currentAllowance = allowance(owner, spender);
1157         if (currentAllowance != type(uint256).max) {
1158             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1159             unchecked {
1160                 _approve(owner, spender, currentAllowance - amount);
1161             }
1162         }
1163     }
1164 
1165     modifier onlyBridge {
1166       require(msg.sender == bridge, "only bridge has access to this child token function");
1167       _;
1168     }
1169 }