1 /*
2 https://twitter.com/MutateToken
3 https://www.mutate-token.com/
4 https://t.me/mutateportal
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.19;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Emitted when `value` tokens are moved from one account (`from`) to
17      * another (`to`).
18      *
19      * Note that `value` may be zero.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
25      * a call to {approve}. `value` is the new allowance.
26      */
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 }
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations.
91  *
92  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
93  * now has built in overflow checking.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             uint256 c = a + b;
104             if (c < a) return (false, 0);
105             return (true, c);
106         }
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             if (b > a) return (false, 0);
117             return (true, a - b);
118         }
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129             // benefit is lost if 'b' is also tested.
130             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131             if (a == 0) return (true, 0);
132             uint256 c = a * b;
133             if (c / a != b) return (false, 0);
134             return (true, c);
135         }
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b == 0) return (false, 0);
146             return (true, a / b);
147         }
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             if (b == 0) return (false, 0);
158             return (true, a % b);
159         }
160     }
161 
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a + b;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a - b;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a * b;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers, reverting on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator.
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a % b;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {trySub}.
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         unchecked {
253             require(b <= a, errorMessage);
254             return a - b;
255         }
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         unchecked {
276             require(b > 0, errorMessage);
277             return a / b;
278         }
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * reverting with custom message when dividing by zero.
284      *
285      * CAUTION: This function is deprecated because it requires allocating memory for the error
286      * message unnecessarily. For custom revert reasons use {tryMod}.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b > 0, errorMessage);
303             return a % b;
304         }
305     }
306 }
307 
308 /**
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319     function _msgSender() internal view virtual returns (address) {
320         return msg.sender;
321     }
322 
323     function _msgData() internal view virtual returns (bytes calldata) {
324         return msg.data;
325     }
326 }
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor() {
349         _transferOwnership(_msgSender());
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         _checkOwner();
357         _;
358     }
359 
360     /**
361      * @dev Returns the address of the current owner.
362      */
363     function owner() public view virtual returns (address) {
364         return _owner;
365     }
366 
367     /**
368      * @dev Throws if the sender is not the owner.
369      */
370     function _checkOwner() internal view virtual {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372     }
373 
374     /**
375      * @dev Leaves the contract without owner. It will not be possible to call
376      * `onlyOwner` functions anymore. Can only be called by the current owner.
377      *
378      * NOTE: Renouncing ownership will leave the contract without an owner,
379      * thereby removing any functionality that is only available to the owner.
380      */
381     function renounceOwnership() public virtual onlyOwner {
382         _transferOwnership(address(0));
383     }
384 
385     /**
386      * @dev Transfers ownership of the contract to a new account (`newOwner`).
387      * Can only be called by the current owner.
388      */
389     function transferOwnership(address newOwner) public virtual onlyOwner {
390         require(newOwner != address(0), "Ownable: new owner is the zero address");
391         _transferOwnership(newOwner);
392     }
393 
394     /**
395      * @dev Transfers ownership of the contract to a new account (`newOwner`).
396      * Internal function without access restriction.
397      */
398     function _transferOwnership(address newOwner) internal virtual {
399         address oldOwner = _owner;
400         _owner = newOwner;
401         emit OwnershipTransferred(oldOwner, newOwner);
402     }
403 }
404 
405 interface IUniswapV2Router01 {
406     function factory() external pure returns (address);
407     function WETH() external pure returns (address);
408 
409     function addLiquidity(
410         address tokenA,
411         address tokenB,
412         uint amountADesired,
413         uint amountBDesired,
414         uint amountAMin,
415         uint amountBMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountA, uint amountB, uint liquidity);
419     function addLiquidityETH(
420         address token,
421         uint amountTokenDesired,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
427     function removeLiquidity(
428         address tokenA,
429         address tokenB,
430         uint liquidity,
431         uint amountAMin,
432         uint amountBMin,
433         address to,
434         uint deadline
435     ) external returns (uint amountA, uint amountB);
436     function removeLiquidityETH(
437         address token,
438         uint liquidity,
439         uint amountTokenMin,
440         uint amountETHMin,
441         address to,
442         uint deadline
443     ) external returns (uint amountToken, uint amountETH);
444     function removeLiquidityWithPermit(
445         address tokenA,
446         address tokenB,
447         uint liquidity,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns (uint amountA, uint amountB);
454     function removeLiquidityETHWithPermit(
455         address token,
456         uint liquidity,
457         uint amountTokenMin,
458         uint amountETHMin,
459         address to,
460         uint deadline,
461         bool approveMax, uint8 v, bytes32 r, bytes32 s
462     ) external returns (uint amountToken, uint amountETH);
463     function swapExactTokensForTokens(
464         uint amountIn,
465         uint amountOutMin,
466         address[] calldata path,
467         address to,
468         uint deadline
469     ) external returns (uint[] memory amounts);
470     function swapTokensForExactTokens(
471         uint amountOut,
472         uint amountInMax,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external returns (uint[] memory amounts);
477     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
478         external
479         payable
480         returns (uint[] memory amounts);
481     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
482         external
483         returns (uint[] memory amounts);
484     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
485         external
486         returns (uint[] memory amounts);
487     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
488         external
489         payable
490         returns (uint[] memory amounts);
491 
492     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
493     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
494     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
495     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
496     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
497 }
498 
499 interface IUniswapV2Router02 is IUniswapV2Router01 {
500     function removeLiquidityETHSupportingFeeOnTransferTokens(
501         address token,
502         uint liquidity,
503         uint amountTokenMin,
504         uint amountETHMin,
505         address to,
506         uint deadline
507     ) external returns (uint amountETH);
508     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
509         address token,
510         uint liquidity,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline,
515         bool approveMax, uint8 v, bytes32 r, bytes32 s
516     ) external returns (uint amountETH);
517 
518     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
519         uint amountIn,
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external;
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint amountOutMin,
527         address[] calldata path,
528         address to,
529         uint deadline
530     ) external payable;
531     function swapExactTokensForETHSupportingFeeOnTransferTokens(
532         uint amountIn,
533         uint amountOutMin,
534         address[] calldata path,
535         address to,
536         uint deadline
537     ) external;
538 }
539 
540 interface IUniswapV2Factory {
541     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
542 
543     function feeTo() external view returns (address);
544     function feeToSetter() external view returns (address);
545 
546     function getPair(address tokenA, address tokenB) external view returns (address pair);
547     function allPairs(uint) external view returns (address pair);
548     function allPairsLength() external view returns (uint);
549 
550     function createPair(address tokenA, address tokenB) external returns (address pair);
551 
552     function setFeeTo(address) external;
553     function setFeeToSetter(address) external;
554 }
555 
556 interface IUniswapV2Pair {
557     event Approval(address indexed owner, address indexed spender, uint value);
558     event Transfer(address indexed from, address indexed to, uint value);
559 
560     function name() external pure returns (string memory);
561     function symbol() external pure returns (string memory);
562     function decimals() external pure returns (uint8);
563     function totalSupply() external view returns (uint);
564     function balanceOf(address owner) external view returns (uint);
565     function allowance(address owner, address spender) external view returns (uint);
566 
567     function approve(address spender, uint value) external returns (bool);
568     function transfer(address to, uint value) external returns (bool);
569     function transferFrom(address from, address to, uint value) external returns (bool);
570 
571     function DOMAIN_SEPARATOR() external view returns (bytes32);
572     function PERMIT_TYPEHASH() external pure returns (bytes32);
573     function nonces(address owner) external view returns (uint);
574 
575     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
576 
577     event Mint(address indexed sender, uint amount0, uint amount1);
578     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
579     event Swap(
580         address indexed sender,
581         uint amount0In,
582         uint amount1In,
583         uint amount0Out,
584         uint amount1Out,
585         address indexed to
586     );
587     event Sync(uint112 reserve0, uint112 reserve1);
588 
589     function MINIMUM_LIQUIDITY() external pure returns (uint);
590     function factory() external view returns (address);
591     function token0() external view returns (address);
592     function token1() external view returns (address);
593     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
594     function price0CumulativeLast() external view returns (uint);
595     function price1CumulativeLast() external view returns (uint);
596     function kLast() external view returns (uint);
597 
598     function mint(address to) external returns (uint liquidity);
599     function burn(address to) external returns (uint amount0, uint amount1);
600     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
601     function skim(address to) external;
602     function sync() external;
603 
604     function initialize(address, address) external;
605 }
606 
607 contract MUTATE is IERC20, Ownable {
608     using SafeMath for uint256;
609 
610     address private constant DEAD = address(0xdead);
611     address private constant ZERO = address(0);
612     address private devAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
613     address private treasuryAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
614     address private marketingAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
615     address private liquidityAddress = address(0xeFc9264D68d06502cdc785FC2aEa84bF05a999f2);
616     /**
617      * Token Assets
618      * name, symbol, _decimals totalSupply
619      * This will be defined when we deploy the contract.
620      */
621     string private _name = "MUTATE";
622     string private _symbol = "MUTATE";
623     uint8 private _decimals = 18;
624     uint256 private _totalSupply = 1_000_000_000 * (10 ** _decimals);  // 1 billion
625 
626     mapping(address => uint256) private _balances;
627     mapping(address => mapping(address => uint256)) private _allowances;
628 
629     bool public enableTrading = true;
630     bool public enableSwap = false;
631     uint256 public maxBalance = _totalSupply * 2 / 100; // 2%
632     uint256 public maxTx = _totalSupply * 2 / 100;  // 2%
633     uint256 public swapThreshold = (_totalSupply * 4) / 10000;  // 0.04%
634 
635     uint256 _buyMarketingFee = 0;
636     uint256 _buyLiquidityFee = 0;
637     uint256 _buyReflectionFee = 0;
638     uint256 _buyTreasuryFee = 0;
639 
640     uint256 _sellMarketingFee = 0;
641     uint256 _sellLiquidityFee = 0;
642     uint256 _sellReflectionFee = 0;
643     uint256 _sellTreasuryFee = 0;
644 
645     uint256 public marketingDebt = 0;
646     uint256 public liquidityDebt = 0;
647     uint256 public treasuryDebt = 0;
648     /**
649      * Mode & Fee
650      * mode1(BuyTax: treasury=2%, reflection=3%, SellTax: treasury=2%, reflection=3%)
651      * mode2(BuyTax: 0, SellTax: treasury=2%, reflection=2%, luck holder reward=2%)
652      * mode3(BuyTax: auto burn supply=1%, reflections to all top 150 holders=3%, 
653      *       SellTax: treasury=2%, reflection=3%)
654      * mode4(BuyTax: 0, SellTax: 0)
655      */
656     uint8 public mode = 0;  // current mode
657     bool public isAutoMode = false;
658     uint256 public modeStartTime = 0;
659     uint256 public modePeriod = 3 hours;
660     struct Fee {
661         uint8 treasury;
662         uint8 reflection;
663         uint8 lucky;
664         uint8 burn;
665         uint8 total;
666     }
667     // mode == 0: pre fees
668     // Mode 1
669     Fee public mode1BuyTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
670     Fee public mode1SellTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
671     // Mode 2
672     Fee public mode2BuyTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
673     Fee public mode2SellTax = Fee({treasury: 2, reflection: 2, lucky: 2, burn: 0, total: 6});
674     // Mode 3
675     Fee public mode3BuyTax = Fee({treasury: 0, reflection: 3, lucky: 0, burn: 1, total: 4});
676     Fee public mode3SellTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
677     // Mode 4
678     Fee public mode4BuyTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
679     Fee public mode4SellTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
680 
681     Fee public buyTax;
682     Fee public sellTax;
683 
684     IUniswapV2Router02 public UNISWAP_V2_ROUTER;
685     address public UNISWAP_V2_PAIR;
686 
687     mapping(address => bool) public isFeeExempt;
688     mapping(address => bool) public isReflectionExempt;
689     mapping(address => bool) public isBalanceExempt;
690 
691     mapping(address => bool) public isHolder;
692     address[] public holders;
693     uint256 public totalReflectionAmount;
694     uint256 public topHolderReflectionAmount;
695 
696     // events
697     event UpdateMode(uint8 mode);
698     event Reflection(uint256 amountAdded, uint256 totalAmountAccumulated);
699     event LuckyReward(address holder, uint256 amount);
700     event ChangeTradingStatus(bool status);
701 
702     bool inSwap;
703     modifier swapping() {
704         inSwap = true;
705         _;
706         inSwap = false;
707     }
708 
709     constructor () {
710         require(devAddress != msg.sender, "Please set a different wallet for devAddress");
711         // UNISWAP_V2_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // mainnet
712         UNISWAP_V2_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // goerli
713         UNISWAP_V2_PAIR = IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
714         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = _totalSupply;
715         _allowances[address(this)][address(UNISWAP_V2_PAIR)] = _totalSupply;
716         _allowances[address(this)][msg.sender] = _totalSupply;
717 
718         isFeeExempt[msg.sender] = true;
719         isFeeExempt[devAddress] = true;
720         isFeeExempt[treasuryAddress] = true;
721         isFeeExempt[marketingAddress] = true;
722         isFeeExempt[liquidityAddress] = true;
723         isFeeExempt[ZERO] = true;
724         isFeeExempt[DEAD] = true;
725         isFeeExempt[address(this)] = true;
726 
727         isReflectionExempt[address(this)] = true;
728         isReflectionExempt[address(UNISWAP_V2_ROUTER)] = true;
729         isReflectionExempt[UNISWAP_V2_PAIR] = true;
730         isReflectionExempt[msg.sender] = true;
731         isReflectionExempt[ZERO] = true;
732         isReflectionExempt[DEAD] = true;
733 
734         isBalanceExempt[ZERO] = true;
735         isBalanceExempt[DEAD] = true;
736         isBalanceExempt[address(UNISWAP_V2_ROUTER)] = true;
737         isBalanceExempt[address(UNISWAP_V2_PAIR)] = true;
738         isBalanceExempt[devAddress] = true;
739         isBalanceExempt[msg.sender] = true;
740         isBalanceExempt[address(this)] = true;
741 
742         buyTax = mode1BuyTax;
743         sellTax = mode1SellTax;
744 
745         uint256 devAmount = _totalSupply * 5 / 100;
746         _balances[devAddress] = devAmount;
747         emit Transfer(ZERO, devAddress, devAmount);
748         isHolder[devAddress] = true;
749         holders.push(devAddress);
750 
751         uint256 circulationAmount = _totalSupply - devAmount;
752         _balances[msg.sender] = circulationAmount;
753         emit Transfer(ZERO, msg.sender, circulationAmount);
754         isHolder[msg.sender] = true;
755         holders.push(msg.sender);
756     }
757 
758     receive() external payable {}
759     /**
760      * ERC20 Standard methods with override
761      */
762     function totalSupply() external view override returns (uint256) {
763         return _totalSupply;
764     }
765 
766     function decimals() external view returns (uint8) {
767         return _decimals;
768     }
769 
770     function symbol() external view returns (string memory) {
771         return _symbol;
772     }
773 
774     function name() external view returns (string memory) {
775         return _name;
776     }
777 
778     function balanceOf(address account) public view override returns (uint256) {
779         uint256 totalBalance = _balances[account];
780         if (!isReflectionExempt[account] && totalReflectionAmount > 0 && holders.length > 2) {
781             totalBalance += totalBalance / holders.length;
782         }
783         return totalBalance;
784     }
785 
786     function allowance(address holder, address spender) external view override returns (uint256) {
787         return _allowances[holder][spender];
788     }
789 
790     function approve(address spender, uint256 amount) public override returns (bool) {
791         _allowances[msg.sender][spender] = amount;
792         emit Approval(msg.sender, spender, amount);
793         return true;
794     }
795 
796     function approveMax(address spender) external returns (bool) {
797         return approve(spender, _totalSupply);
798     }
799 
800     function transfer(address recipient, uint256 amount) external override returns (bool) {
801         return _transferFrom(msg.sender, recipient, amount);
802     }
803 
804     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
805         if (_allowances[sender][msg.sender] != type(uint256).max) {
806             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
807             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
808         }
809 
810         return _transferFrom(sender, recipient, amount);
811     }
812 
813     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
814         _checkBuySell(sender, recipient);
815         _checkLimitations(recipient, amount);
816         if (inSwap) {
817             return _basicTransfer(sender, recipient, amount);
818         }
819         if (_shouldSwapBack()) {
820             _swapBack();
821         }
822         if (!isReflectionExempt[sender]){
823             _claim(sender);
824         }
825         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
826         _updateHolders(sender);
827         uint256 amountReceived = _shouldTakeFee(sender, recipient) ? _takeFees(sender, amount) : amount;
828         _balances[recipient] = _balances[recipient].add(amountReceived);
829         _updateHolders(recipient);
830         emit Transfer(sender, recipient, amount);
831 
832         if (isAutoMode) {
833             autoUpdateMode();
834         }
835 
836         return true;
837     }
838 
839     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
840         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
841         _updateHolders(sender);
842         _balances[recipient] = _balances[recipient].add(amount);
843         _updateHolders(recipient);
844         emit Transfer(sender, recipient, amount);
845         return true;
846     }
847 
848     function getRandomHolderIndex(uint256 _numToFetch, uint256 _i) internal view returns (uint256) {
849         uint256 randomNum = uint256(
850             keccak256(
851                 abi.encode(
852                     msg.sender,
853                     tx.gasprice,
854                     block.number,
855                     block.timestamp,
856                     blockhash(block.number - 1),
857                     _numToFetch,
858                     _i
859                 )
860             )
861         );
862         uint256 randomIndex = (randomNum % holders.length);
863         return randomIndex;
864     }
865 
866     function _takePreFees(address sender, uint256 amount) internal returns (uint256) {
867         uint256 _marketingFee = _sellMarketingFee;
868         uint256 _liquidityFee = _sellLiquidityFee;
869         uint256 _reflectionFee = _sellReflectionFee;
870         uint256 _treasuryFee = _sellTreasuryFee;
871         if (sender == UNISWAP_V2_PAIR) {
872             _marketingFee = _buyMarketingFee;
873             _liquidityFee = _buyLiquidityFee;
874             _reflectionFee = _buyReflectionFee;
875             _treasuryFee = _buyTreasuryFee;
876         }
877         uint256 _marketingAmount = amount * _marketingFee / 100;
878         uint256 _liquidityAmount = amount * _liquidityFee / 100;
879         uint256 _treasuryAmount = amount * _treasuryFee / 100;
880         uint256 _reflectionFeeAmount = amount * _reflectionFee / 100;
881         if (_reflectionFee > 0) {
882             totalReflectionAmount += _reflectionFeeAmount;
883             emit Reflection(_reflectionFeeAmount, totalReflectionAmount);
884         }
885         marketingDebt += _marketingAmount;
886         liquidityDebt += _liquidityAmount;
887         treasuryDebt += _treasuryAmount;
888         _balances[address(this)] += _marketingAmount + _liquidityAmount + _treasuryAmount;
889         uint256 _totalFeeAmount = _marketingAmount + _liquidityAmount + _treasuryAmount + _reflectionFeeAmount;
890         return amount.sub(_totalFeeAmount);
891     }
892 
893     function _takeModeFees(address sender, uint256 amount) internal returns (uint256) {
894         Fee memory _feeTax = sellTax;
895         bool _topReflection = false;
896         if (sender == UNISWAP_V2_PAIR) {
897             _feeTax = buyTax;
898             if (mode == 3) {
899                 _topReflection = true;
900             }
901         }
902         uint256 feeAmount = amount * _feeTax.total / 100;
903         if (_feeTax.treasury > 0) {
904             uint256 _treasuryFeeAmount = feeAmount * _feeTax.treasury / _feeTax.total;
905             treasuryDebt += _treasuryFeeAmount;
906             _balances[address(this)] += _treasuryFeeAmount;
907         }
908         if (_feeTax.reflection > 0) {
909             uint256 _reflectionFeeAmount = feeAmount * _feeTax.reflection / _feeTax.total;
910             if (_topReflection) {
911                 _topHolderReflection(_reflectionFeeAmount);
912             } else {
913                 totalReflectionAmount += _reflectionFeeAmount;
914                 emit Reflection(_reflectionFeeAmount, totalReflectionAmount);
915             }
916         }
917         if (_feeTax.lucky > 0) {
918             uint256 _luckyFeeAmount = feeAmount * _feeTax.lucky / _feeTax.total;
919             _luckyReward(_luckyFeeAmount);
920         }
921         if (_feeTax.burn > 0) {
922             uint256 _burnFeeAmount = feeAmount * _feeTax.burn / _feeTax.total;
923             _balances[DEAD] += _burnFeeAmount;
924             emit Transfer(address(this), DEAD, _burnFeeAmount);
925         }
926 
927         return amount.sub(feeAmount);
928     }
929 
930     function _takeFees(address sender, uint256 amount) internal returns (uint256) {
931         if (mode > 0) {
932             return _takeModeFees(sender, amount);
933         } else {
934             return _takePreFees(sender, amount);
935         }
936     }
937 
938     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
939         return !isFeeExempt[sender] || !isFeeExempt[recipient];
940     }
941 
942     function _checkBuySell(address sender, address recipient) internal view {
943         if (!enableTrading) {
944             require(sender != UNISWAP_V2_PAIR && recipient != UNISWAP_V2_PAIR, "Trading is disabled!");
945         }
946     }
947 
948     function _checkLimitations(address recipient, uint256 amount) internal view {
949         if (!isBalanceExempt[recipient]) {
950             require(amount <= maxTx, "Max transaction amount is limited!");
951             uint256 suggestBalance = balanceOf(recipient) + amount;
952             require(suggestBalance <= maxBalance, "Max balance is limited!");
953         }
954     }
955 
956     function _luckyReward(uint256 amount) internal {
957         uint256 randomIndex = getRandomHolderIndex(1, 1);
958         address luckyHolder = holders[randomIndex];
959         if (
960             luckyHolder != ZERO && 
961             luckyHolder != DEAD && 
962             luckyHolder != address(UNISWAP_V2_ROUTER) && 
963             luckyHolder != UNISWAP_V2_PAIR
964         ) {
965             _balances[luckyHolder] += amount;
966             emit Transfer(address(this), luckyHolder, amount);
967         }
968     }
969 
970     function _topHolderReflection(uint256 amount) internal {
971         topHolderReflectionAmount += amount;
972     }
973     
974     function _updateHolders(address holder) internal {
975         uint256 balance = balanceOf(holder);
976         if (balance > 0) {
977             if (!isHolder[holder]) {
978                 isHolder[holder] = true;
979                 holders.push(holder);
980             }
981         } else {
982             if (isHolder[holder]) {
983                 isHolder[holder] = false;
984                 for(uint256 i = 0; i < holders.length - 1; i++) {
985                     if (holders[i] == holder) {
986                         holders[i] = holders[holders.length - 1];
987                     }
988                 }
989                 holders.pop();
990             }
991         }
992     }
993 
994     function _claim(address holder) internal {
995         if (totalReflectionAmount > 0) {
996             uint256 oneReflection = totalReflectionAmount / holders.length;
997             totalReflectionAmount -= oneReflection;
998             _balances[holder] += oneReflection;
999         }
1000     }
1001 
1002     function _shouldSwapBack() internal view returns (bool) {
1003         return msg.sender != UNISWAP_V2_PAIR && 
1004             enableSwap && 
1005             !inSwap && 
1006             balanceOf(address(this)) >= swapThreshold;
1007     }
1008 
1009     function _swapBack() internal swapping {
1010         uint256 amountToSwap = balanceOf(address(this));
1011         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
1012         // swap
1013         address[] memory path = new address[](2);
1014         path[0] = address(this);
1015         path[1] = UNISWAP_V2_ROUTER.WETH();
1016         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
1017             amountToSwap, 0, path, address(this), block.timestamp
1018         );
1019         uint256 amountETH = address(this).balance;
1020         // (bool tmpSuccess,) = payable(liquidityAddress).call{value: amountETH}("");
1021         // payable(liquidityAddress).transfer(amountETH);
1022         _sendFeeETH(amountETH, amountToSwap);
1023     }
1024 
1025     function _sendFeeETH(uint256 amount, uint256 swapAmount) internal {
1026         uint256 totalDebt = marketingDebt + liquidityDebt + treasuryDebt;
1027         uint256 marketingProfit = amount * marketingDebt / totalDebt;
1028         uint256 marketingSwapAmount = swapAmount * marketingDebt / totalDebt;
1029         uint256 liquidityProfit = amount * liquidityDebt / totalDebt;
1030         uint256 liquiditySwapAmount = swapAmount * liquidityDebt / totalDebt;
1031         uint256 treasuryProfit = amount - marketingProfit - liquidityProfit;
1032         uint256 treasurySwapAmount = swapAmount - marketingSwapAmount - liquiditySwapAmount;
1033         if (marketingProfit > 0) {
1034             payable(marketingAddress).transfer(marketingProfit);
1035             marketingDebt -= marketingSwapAmount;
1036         }
1037         if (liquidityProfit > 0) {
1038             payable(liquidityAddress).transfer(liquidityProfit);
1039             liquidityDebt -= liquiditySwapAmount;
1040         }
1041         if (treasuryProfit > 0) {
1042             payable(treasuryAddress).transfer(treasuryProfit);
1043             treasuryDebt -= treasurySwapAmount;
1044         }
1045     }
1046 
1047     function _changeMode(uint8 mode_) internal {
1048         if (mode_ == 2) {
1049             buyTax = mode2BuyTax;
1050             sellTax = mode2SellTax;
1051         } else if (mode_ == 3) {
1052             buyTax = mode3BuyTax;
1053             sellTax = mode3SellTax;
1054         } else if (mode_ == 4) {
1055             buyTax = mode4BuyTax;
1056             sellTax = mode4SellTax;
1057         } else {
1058             buyTax = mode1BuyTax;
1059             sellTax = mode1SellTax;
1060         }
1061         mode = mode_;
1062         emit UpdateMode(mode_);
1063     }
1064 
1065     function autoUpdateMode() internal {
1066         uint8 _currentMode = mode;
1067         if (_currentMode == 0) {
1068             return;
1069         }
1070         uint256 deltaTime = block.timestamp - modeStartTime;
1071         if (deltaTime < modePeriod) {
1072             return;
1073         }
1074         _currentMode = (_currentMode + 1) % 4;
1075         if (_currentMode == 0) {
1076             _currentMode = 1;
1077         }
1078         modeStartTime = block.timestamp;
1079         _changeMode(_currentMode);
1080     }
1081 
1082     function manualUpdateMode(uint8 mode_) external onlyOwner {
1083         require(mode_ < 5, "Undefined Mode");
1084         _changeMode(mode_);
1085     }
1086 
1087     function setAutoMode(bool isAuto_) external onlyOwner {
1088         isAutoMode = isAuto_;
1089     }
1090 
1091     function rewardTopHolders(address[] calldata _topHolders) public onlyOwner {
1092         require(topHolderReflectionAmount > 0, "Reward should be available");
1093         uint256 oneReward = topHolderReflectionAmount / _topHolders.length;
1094         topHolderReflectionAmount = 0;
1095         for (uint8 i = 0; i < _topHolders.length; i++) {
1096             _balances[_topHolders[i]] += oneReward;
1097             emit Transfer(address(this), _topHolders[i], oneReward);
1098         }
1099     }
1100 
1101     function setFeeReceivers(address treasury_) external onlyOwner {
1102         treasuryAddress = treasury_;
1103     }
1104 
1105     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
1106         isFeeExempt[holder] = exempt;
1107     }
1108 
1109     function setIsReflectionExempt(address holder, bool exempt) external onlyOwner {
1110         isReflectionExempt[holder] = exempt;
1111     }
1112 
1113     function setIsBalanceExempt(address holder, bool exempt) external onlyOwner {
1114         isBalanceExempt[holder] = exempt;
1115     }
1116 
1117     function changeTradingStatus(bool _status) external onlyOwner {
1118         enableTrading = _status;
1119         emit ChangeTradingStatus(_status);
1120     }
1121 
1122     function updatePreFees(
1123         uint256 buyMarketingFee_,
1124         uint256 buyLiquidityFee_,
1125         uint256 buyReflectionFee_,
1126         uint256 buyTreasuryFee_,
1127         uint256 sellMarketingFee_,
1128         uint256 sellLiquidityFee_,
1129         uint256 sellReflectionFee_,
1130         uint256 sellTreasuryFee_
1131     ) external onlyOwner {
1132         _buyMarketingFee = buyMarketingFee_;
1133         _buyLiquidityFee = buyLiquidityFee_;
1134         _buyReflectionFee = buyReflectionFee_;
1135         _buyTreasuryFee = buyTreasuryFee_;
1136 
1137         _sellMarketingFee = sellMarketingFee_;
1138         _sellLiquidityFee = sellLiquidityFee_;
1139         _sellReflectionFee = sellReflectionFee_;
1140         _sellTreasuryFee = sellTreasuryFee_;
1141     }
1142 
1143     function updateSwapThreshold(uint256 _swapThreshold) external onlyOwner {
1144         swapThreshold = _swapThreshold;
1145     }
1146 
1147     function manualSwapBack() external onlyOwner {
1148         if (_shouldSwapBack()) {
1149             _swapBack();
1150         }
1151     }
1152 
1153     function changeSwapStatus(bool _enableSwap) external onlyOwner {
1154         enableSwap = _enableSwap;
1155     }
1156 }