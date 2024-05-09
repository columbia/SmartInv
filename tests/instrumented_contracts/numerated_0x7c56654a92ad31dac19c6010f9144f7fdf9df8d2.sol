1 /*
2 https://twitter.com/MutateToken
3 https://www.mutate-token.com/
4 https://t.me/mutateportal
5 */
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.19;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations.
90  *
91  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
92  * now has built in overflow checking.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, with an overflow flag.
97      *
98      * _Available since v3.4._
99      */
100     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             uint256 c = a + b;
103             if (c < a) return (false, 0);
104             return (true, c);
105         }
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             if (b > a) return (false, 0);
116             return (true, a - b);
117         }
118     }
119 
120     /**
121      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128             // benefit is lost if 'b' is also tested.
129             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
130             if (a == 0) return (true, 0);
131             uint256 c = a * b;
132             if (c / a != b) return (false, 0);
133             return (true, c);
134         }
135     }
136 
137     /**
138      * @dev Returns the division of two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             if (b == 0) return (false, 0);
145             return (true, a / b);
146         }
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         unchecked {
156             if (b == 0) return (false, 0);
157             return (true, a % b);
158         }
159     }
160 
161     /**
162      * @dev Returns the addition of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `+` operator.
166      *
167      * Requirements:
168      *
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a + b;
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a * b;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers, reverting on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator.
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a / b;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a % b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
235      * overflow (when the result is negative).
236      *
237      * CAUTION: This function is deprecated because it requires allocating memory for the error
238      * message unnecessarily. For custom revert reasons use {trySub}.
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      *
244      * - Subtraction cannot overflow.
245      */
246     function sub(
247         uint256 a,
248         uint256 b,
249         string memory errorMessage
250     ) internal pure returns (uint256) {
251         unchecked {
252             require(b <= a, errorMessage);
253             return a - b;
254         }
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259      * division by zero. The result is rounded towards zero.
260      *
261      * Counterpart to Solidity's `/` operator. Note: this function uses a
262      * `revert` opcode (which leaves remaining gas untouched) while Solidity
263      * uses an invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function div(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a / b;
277         }
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b > 0, errorMessage);
302             return a % b;
303         }
304     }
305 }
306 
307 /**
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 
327 /**
328  * @dev Contract module which provides a basic access control mechanism, where
329  * there is an account (an owner) that can be granted exclusive access to
330  * specific functions.
331  *
332  * By default, the owner account will be the one that deploys the contract. This
333  * can later be changed with {transferOwnership}.
334  *
335  * This module is used through inheritance. It will make available the modifier
336  * `onlyOwner`, which can be applied to your functions to restrict their use to
337  * the owner.
338  */
339 abstract contract Ownable is Context {
340     address private _owner;
341 
342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
343 
344     /**
345      * @dev Initializes the contract setting the deployer as the initial owner.
346      */
347     constructor() {
348         _transferOwnership(_msgSender());
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         _checkOwner();
356         _;
357     }
358 
359     /**
360      * @dev Returns the address of the current owner.
361      */
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     /**
367      * @dev Throws if the sender is not the owner.
368      */
369     function _checkOwner() internal view virtual {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371     }
372 
373     /**
374      * @dev Leaves the contract without owner. It will not be possible to call
375      * `onlyOwner` functions anymore. Can only be called by the current owner.
376      *
377      * NOTE: Renouncing ownership will leave the contract without an owner,
378      * thereby removing any functionality that is only available to the owner.
379      */
380     function renounceOwnership() public virtual onlyOwner {
381         _transferOwnership(address(0));
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Can only be called by the current owner.
387      */
388     function transferOwnership(address newOwner) public virtual onlyOwner {
389         require(newOwner != address(0), "Ownable: new owner is the zero address");
390         _transferOwnership(newOwner);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Internal function without access restriction.
396      */
397     function _transferOwnership(address newOwner) internal virtual {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
403 
404 interface IUniswapV2Router01 {
405     function factory() external pure returns (address);
406     function WETH() external pure returns (address);
407 
408     function addLiquidity(
409         address tokenA,
410         address tokenB,
411         uint amountADesired,
412         uint amountBDesired,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountA, uint amountB, uint liquidity);
418     function addLiquidityETH(
419         address token,
420         uint amountTokenDesired,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline
425     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
426     function removeLiquidity(
427         address tokenA,
428         address tokenB,
429         uint liquidity,
430         uint amountAMin,
431         uint amountBMin,
432         address to,
433         uint deadline
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETH(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline
442     ) external returns (uint amountToken, uint amountETH);
443     function removeLiquidityWithPermit(
444         address tokenA,
445         address tokenB,
446         uint liquidity,
447         uint amountAMin,
448         uint amountBMin,
449         address to,
450         uint deadline,
451         bool approveMax, uint8 v, bytes32 r, bytes32 s
452     ) external returns (uint amountA, uint amountB);
453     function removeLiquidityETHWithPermit(
454         address token,
455         uint liquidity,
456         uint amountTokenMin,
457         uint amountETHMin,
458         address to,
459         uint deadline,
460         bool approveMax, uint8 v, bytes32 r, bytes32 s
461     ) external returns (uint amountToken, uint amountETH);
462     function swapExactTokensForTokens(
463         uint amountIn,
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external returns (uint[] memory amounts);
469     function swapTokensForExactTokens(
470         uint amountOut,
471         uint amountInMax,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external returns (uint[] memory amounts);
476     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
477         external
478         payable
479         returns (uint[] memory amounts);
480     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
481         external
482         returns (uint[] memory amounts);
483     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
484         external
485         returns (uint[] memory amounts);
486     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
487         external
488         payable
489         returns (uint[] memory amounts);
490 
491     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
492     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
493     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
494     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
495     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
496 }
497 
498 interface IUniswapV2Router02 is IUniswapV2Router01 {
499     function removeLiquidityETHSupportingFeeOnTransferTokens(
500         address token,
501         uint liquidity,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline
506     ) external returns (uint amountETH);
507     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
508         address token,
509         uint liquidity,
510         uint amountTokenMin,
511         uint amountETHMin,
512         address to,
513         uint deadline,
514         bool approveMax, uint8 v, bytes32 r, bytes32 s
515     ) external returns (uint amountETH);
516 
517     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524     function swapExactETHForTokensSupportingFeeOnTransferTokens(
525         uint amountOutMin,
526         address[] calldata path,
527         address to,
528         uint deadline
529     ) external payable;
530     function swapExactTokensForETHSupportingFeeOnTransferTokens(
531         uint amountIn,
532         uint amountOutMin,
533         address[] calldata path,
534         address to,
535         uint deadline
536     ) external;
537 }
538 
539 interface IUniswapV2Factory {
540     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
541 
542     function feeTo() external view returns (address);
543     function feeToSetter() external view returns (address);
544 
545     function getPair(address tokenA, address tokenB) external view returns (address pair);
546     function allPairs(uint) external view returns (address pair);
547     function allPairsLength() external view returns (uint);
548 
549     function createPair(address tokenA, address tokenB) external returns (address pair);
550 
551     function setFeeTo(address) external;
552     function setFeeToSetter(address) external;
553 }
554 
555 interface IUniswapV2Pair {
556     event Approval(address indexed owner, address indexed spender, uint value);
557     event Transfer(address indexed from, address indexed to, uint value);
558 
559     function name() external pure returns (string memory);
560     function symbol() external pure returns (string memory);
561     function decimals() external pure returns (uint8);
562     function totalSupply() external view returns (uint);
563     function balanceOf(address owner) external view returns (uint);
564     function allowance(address owner, address spender) external view returns (uint);
565 
566     function approve(address spender, uint value) external returns (bool);
567     function transfer(address to, uint value) external returns (bool);
568     function transferFrom(address from, address to, uint value) external returns (bool);
569 
570     function DOMAIN_SEPARATOR() external view returns (bytes32);
571     function PERMIT_TYPEHASH() external pure returns (bytes32);
572     function nonces(address owner) external view returns (uint);
573 
574     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
575 
576     event Mint(address indexed sender, uint amount0, uint amount1);
577     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
578     event Swap(
579         address indexed sender,
580         uint amount0In,
581         uint amount1In,
582         uint amount0Out,
583         uint amount1Out,
584         address indexed to
585     );
586     event Sync(uint112 reserve0, uint112 reserve1);
587 
588     function MINIMUM_LIQUIDITY() external pure returns (uint);
589     function factory() external view returns (address);
590     function token0() external view returns (address);
591     function token1() external view returns (address);
592     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
593     function price0CumulativeLast() external view returns (uint);
594     function price1CumulativeLast() external view returns (uint);
595     function kLast() external view returns (uint);
596 
597     function mint(address to) external returns (uint liquidity);
598     function burn(address to) external returns (uint amount0, uint amount1);
599     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
600     function skim(address to) external;
601     function sync() external;
602 
603     function initialize(address, address) external;
604 }
605 
606 contract MUTATE is IERC20, Ownable {
607     using SafeMath for uint256;
608 
609     address private constant DEAD = address(0xdead);
610     address private constant ZERO = address(0);
611     address private devAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
612     address private treasuryAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
613     address private marketingAddress = address(0xdE77aC95F80B18Fc89c32FEf18c3D71aF690dd35);
614     address private liquidityAddress = address(0xeFc9264D68d06502cdc785FC2aEa84bF05a999f2);
615     /**
616      * Token Assets
617      * name, symbol, _decimals totalSupply
618      * This will be defined when we deploy the contract.
619      */
620     string private _name = "MUTATE";
621     string private _symbol = "MUTATE";
622     uint8 private _decimals = 18;
623     uint256 private _totalSupply = 1_000_000_000 * (10 ** _decimals);  // 1 billion
624 
625     mapping(address => uint256) private _balances;
626     mapping(address => mapping(address => uint256)) private _allowances;
627 
628     bool public enableTrading = true;
629     bool public enableSwap = false;
630     uint256 public maxBalance = _totalSupply * 2 / 100; // 2%
631     uint256 public maxTx = _totalSupply * 2 / 100;  // 2%
632     uint256 public swapThreshold = (_totalSupply * 4) / 10000;  // 0.04%
633 
634     uint256 _buyMarketingFee = 12;
635     uint256 _buyLiquidityFee = 0;
636     uint256 _buyReflectionFee = 0;
637     uint256 _buyTreasuryFee = 0;
638 
639     uint256 _sellMarketingFee = 12;
640     uint256 _sellLiquidityFee = 0;
641     uint256 _sellReflectionFee = 0;
642     uint256 _sellTreasuryFee = 0;
643 
644     uint256 public marketingDebt = 0;
645     uint256 public liquidityDebt = 0;
646     uint256 public treasuryDebt = 0;
647     /**
648      * Mode & Fee
649      * mode0 = prefee system
650      * mode1(BuyTax: treasury=2%, reflection=3%, SellTax: treasury=2%, reflection=3%)
651      * mode2(BuyTax: 0, SellTax: treasury=2%, reflection=2%, luck holder reward=2%)
652      * mode3(BuyTax: auto burn supply=1%, reflections to all top 50 holders=3%, 
653      *       SellTax: treasury=2%, reflection=3%)
654      * mode4(BuyTax: 0, SellTax: 0)
655      * mode5(BuyTax: reflection=5%, SellTax: reflection=5%)
656      * mode6(Buytax: 0, SellTax: reflection=5% to buyers of this mutation)
657      */
658     uint8 public mode = 0;  // current mode
659     bool public isAutoMode = false;
660     uint256 public modeStartTime = 0;
661     uint256 public modePeriod = 2 hours;
662     struct Fee {
663         uint8 treasury;
664         uint8 reflection;
665         uint8 lucky;
666         uint8 burn;
667         uint8 total;
668     }
669     // mode == 0: pre fees
670     // Mode 1
671     Fee public mode1BuyTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
672     Fee public mode1SellTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
673     // Mode 2
674     Fee public mode2BuyTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
675     Fee public mode2SellTax = Fee({treasury: 2, reflection: 2, lucky: 2, burn: 0, total: 6});
676     // Mode 3
677     Fee public mode3BuyTax = Fee({treasury: 0, reflection: 3, lucky: 0, burn: 1, total: 4});
678     Fee public mode3SellTax = Fee({treasury: 2, reflection: 3, lucky: 0, burn: 0, total: 5});
679     // Mode 4
680     Fee public mode4BuyTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
681     Fee public mode4SellTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
682     // Mode 5
683     Fee public mode5BuyTax = Fee({treasury: 0, reflection: 5, lucky: 0, burn: 0, total: 5});
684     Fee public mode5SellTax = Fee({treasury: 0, reflection: 5, lucky: 0, burn: 0, total: 5});
685     // Mode 6
686     Fee public mode6BuyTax = Fee({treasury: 0, reflection: 0, lucky: 0, burn: 0, total: 0});
687     Fee public mode6SellTax = Fee({treasury: 0, reflection: 5, lucky: 0, burn: 0, total: 5});
688     uint256 public mode6ReflectionAmount = 0;
689     uint256 public session = 0;
690     // session => (buyer => true/false)
691     mapping(uint256 => mapping(address => bool)) public isMode6Buyer;
692     address[] public mode6Buyers;
693 
694     Fee public buyTax;
695     Fee public sellTax;
696 
697     IUniswapV2Router02 public UNISWAP_V2_ROUTER;
698     address public UNISWAP_V2_PAIR;
699 
700     mapping(address => bool) public isFeeExempt;
701     mapping(address => bool) public isReflectionExempt;
702     mapping(address => bool) public isBalanceExempt;
703 
704     mapping(address => bool) public isHolder;
705     address[] public holders;
706     uint256 public totalReflectionAmount;
707     uint256 public topHolderReflectionAmount;
708 
709     // events
710     event UpdateMode(uint8 mode);
711     event Reflection(uint256 amountAdded, uint256 totalAmountAccumulated);
712     event TopHolderReflection(uint256 amountAdded, uint256 totalAmountAccumulated);
713     event BuyerReflection(uint256 amountAdded, uint256 totalAmountAccumulated);
714     event BuyerReflectionTransfer(address[] buyers, uint256 amount);
715     event LuckyReward(address holder, uint256 amount);
716     event ChangeTradingStatus(bool status);
717 
718     bool inSwap;
719     modifier swapping() {
720         inSwap = true;
721         _;
722         inSwap = false;
723     }
724 
725     constructor () {
726         require(devAddress != msg.sender, "Please set a different wallet for devAddress");
727         UNISWAP_V2_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // mainnet = goerli
728         UNISWAP_V2_PAIR = IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
729         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = _totalSupply;
730         _allowances[address(this)][address(UNISWAP_V2_PAIR)] = _totalSupply;
731         _allowances[address(this)][msg.sender] = _totalSupply;
732 
733         isFeeExempt[msg.sender] = true;
734         isFeeExempt[devAddress] = true;
735         isFeeExempt[treasuryAddress] = true;
736         isFeeExempt[marketingAddress] = true;
737         isFeeExempt[liquidityAddress] = true;
738         isFeeExempt[ZERO] = true;
739         isFeeExempt[DEAD] = true;
740         isFeeExempt[address(this)] = true;
741         isFeeExempt[address(UNISWAP_V2_ROUTER)] = true;
742         isFeeExempt[UNISWAP_V2_PAIR] = true;
743 
744         isReflectionExempt[address(this)] = true;
745         isReflectionExempt[address(UNISWAP_V2_ROUTER)] = true;
746         isReflectionExempt[UNISWAP_V2_PAIR] = true;
747         isReflectionExempt[msg.sender] = true;
748         isReflectionExempt[ZERO] = true;
749         isReflectionExempt[DEAD] = true;
750 
751         isBalanceExempt[ZERO] = true;
752         isBalanceExempt[DEAD] = true;
753         isBalanceExempt[address(UNISWAP_V2_ROUTER)] = true;
754         isBalanceExempt[address(UNISWAP_V2_PAIR)] = true;
755         isBalanceExempt[devAddress] = true;
756         isBalanceExempt[msg.sender] = true;
757         isBalanceExempt[address(this)] = true;
758 
759         buyTax = mode1BuyTax;
760         sellTax = mode1SellTax;
761 
762         uint256 devAmount = _totalSupply * 5 / 100;
763         _balances[devAddress] = devAmount;
764         emit Transfer(ZERO, devAddress, devAmount);
765         isHolder[devAddress] = true;
766         holders.push(devAddress);
767 
768         uint256 circulationAmount = _totalSupply - devAmount;
769         _balances[msg.sender] = circulationAmount;
770         emit Transfer(ZERO, msg.sender, circulationAmount);
771         isHolder[msg.sender] = true;
772         holders.push(msg.sender);
773     }
774 
775     receive() external payable {}
776     /**
777      * ERC20 Standard methods with override
778      */
779     function totalSupply() external view override returns (uint256) {
780         return _totalSupply;
781     }
782 
783     function decimals() external view returns (uint8) {
784         return _decimals;
785     }
786 
787     function symbol() external view returns (string memory) {
788         return _symbol;
789     }
790 
791     function name() external view returns (string memory) {
792         return _name;
793     }
794 
795     function balanceOf(address account) public view override returns (uint256) {
796         uint256 totalBalance = _balances[account];
797         if (!isReflectionExempt[account] && totalReflectionAmount > 0 && holders.length > 2) {
798             totalBalance += totalBalance / holders.length;
799         }
800         return totalBalance;
801     }
802 
803     function allowance(address holder, address spender) external view override returns (uint256) {
804         return _allowances[holder][spender];
805     }
806 
807     function approve(address spender, uint256 amount) public override returns (bool) {
808         _allowances[msg.sender][spender] = amount;
809         emit Approval(msg.sender, spender, amount);
810         return true;
811     }
812 
813     function approveMax(address spender) external returns (bool) {
814         return approve(spender, _totalSupply);
815     }
816 
817     function transfer(address recipient, uint256 amount) external override returns (bool) {
818         return _transferFrom(msg.sender, recipient, amount);
819     }
820 
821     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
822         if (_allowances[sender][msg.sender] != type(uint256).max) {
823             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
824             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
825         }
826 
827         return _transferFrom(sender, recipient, amount);
828     }
829 
830     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
831         _checkBuySell(sender, recipient);
832         _checkLimitations(recipient, amount);
833         if (inSwap) {
834             return _basicTransfer(sender, recipient, amount);
835         }
836         if (_shouldSwapBack()) {
837             _swapBack();
838         }
839         if (!isReflectionExempt[sender]){
840             _claim(sender);
841         }
842         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
843         _updateHolders(sender);
844         uint256 amountReceived = _shouldTakeFee(sender, recipient) ? _takeFees(sender, recipient, amount) : amount;
845         _balances[recipient] = _balances[recipient].add(amountReceived);
846         _updateHolders(recipient);
847         emit Transfer(sender, recipient, amount);
848 
849         if (isAutoMode) {
850             autoUpdateMode();
851         }
852 
853         return true;
854     }
855 
856     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
857         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
858         _updateHolders(sender);
859         _balances[recipient] = _balances[recipient].add(amount);
860         _updateHolders(recipient);
861         emit Transfer(sender, recipient, amount);
862         return true;
863     }
864 
865     function getRandomHolderIndex(uint256 _numToFetch, uint256 _i) internal view returns (uint256) {
866         uint256 randomNum = uint256(
867             keccak256(
868                 abi.encode(
869                     msg.sender,
870                     tx.gasprice,
871                     block.number,
872                     block.timestamp,
873                     blockhash(block.number - 1),
874                     _numToFetch,
875                     _i
876                 )
877             )
878         );
879         uint256 randomIndex = (randomNum % holders.length);
880         return randomIndex;
881     }
882 
883     function _takePreFees(address sender, uint256 amount) internal returns (uint256) {
884         uint256 _marketingFee = _sellMarketingFee;
885         uint256 _liquidityFee = _sellLiquidityFee;
886         uint256 _reflectionFee = _sellReflectionFee;
887         uint256 _treasuryFee = _sellTreasuryFee;
888         if (sender == UNISWAP_V2_PAIR) {
889             _marketingFee = _buyMarketingFee;
890             _liquidityFee = _buyLiquidityFee;
891             _reflectionFee = _buyReflectionFee;
892             _treasuryFee = _buyTreasuryFee;
893         }
894         uint256 _marketingAmount = amount * _marketingFee / 100;
895         uint256 _liquidityAmount = amount * _liquidityFee / 100;
896         uint256 _treasuryAmount = amount * _treasuryFee / 100;
897         uint256 _reflectionFeeAmount = amount * _reflectionFee / 100;
898         if (_reflectionFee > 0) {
899             totalReflectionAmount += _reflectionFeeAmount;
900             emit Reflection(_reflectionFeeAmount, totalReflectionAmount);
901         }
902         marketingDebt += _marketingAmount;
903         liquidityDebt += _liquidityAmount;
904         treasuryDebt += _treasuryAmount;
905         _balances[address(this)] += _marketingAmount + _liquidityAmount + _treasuryAmount;
906         uint256 _totalFeeAmount = _marketingAmount + _liquidityAmount + _treasuryAmount + _reflectionFeeAmount;
907         return amount.sub(_totalFeeAmount);
908     }
909 
910     function _takeModeFees(address sender, address recipient, uint256 amount) internal returns (uint256) {
911         Fee memory _feeTax = sellTax;
912         bool _isBuy = false;
913         if (sender == UNISWAP_V2_PAIR) {
914             _feeTax = buyTax;
915             _isBuy = true;
916         }
917         uint256 feeAmount = amount * _feeTax.total / 100;
918         if (_feeTax.treasury > 0) {
919             uint256 _treasuryFeeAmount = feeAmount * _feeTax.treasury / _feeTax.total;
920             treasuryDebt += _treasuryFeeAmount;
921             _balances[address(this)] += _treasuryFeeAmount;
922         }
923         if (_feeTax.reflection > 0) {
924             uint256 _reflectionFeeAmount = feeAmount * _feeTax.reflection / _feeTax.total;
925             if (mode == 3) {
926                 topHolderReflectionAmount += _reflectionFeeAmount;
927                 emit TopHolderReflection(_reflectionFeeAmount, topHolderReflectionAmount);
928             } else if (mode == 6) {
929                 mode6ReflectionAmount += _reflectionFeeAmount;
930                 if (!_isBuy) {
931                     emit BuyerReflection(_reflectionFeeAmount, mode6ReflectionAmount);
932                 } else if (_isBuy && !isMode6Buyer[session][recipient]) {
933                     isMode6Buyer[session][recipient] = true;
934                     mode6Buyers.push(recipient);
935                 }
936             } else {
937                 totalReflectionAmount += _reflectionFeeAmount;
938                 emit Reflection(_reflectionFeeAmount, totalReflectionAmount);
939             }
940         }
941         if (_feeTax.lucky > 0) {
942             uint256 _luckyFeeAmount = feeAmount * _feeTax.lucky / _feeTax.total;
943             _luckyReward(_luckyFeeAmount);
944         }
945         if (_feeTax.burn > 0) {
946             uint256 _burnFeeAmount = feeAmount * _feeTax.burn / _feeTax.total;
947             _balances[DEAD] += _burnFeeAmount;
948             emit Transfer(address(this), DEAD, _burnFeeAmount);
949         }
950 
951         return amount.sub(feeAmount);
952     }
953 
954     function _takeFees(address sender, address recipient, uint256 amount) internal returns (uint256) {
955         if (mode > 0) {
956             return _takeModeFees(sender, recipient, amount);
957         } else {
958             return _takePreFees(sender, amount);
959         }
960     }
961 
962     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
963         return !isFeeExempt[sender] || !isFeeExempt[recipient];
964     }
965 
966     function _checkBuySell(address sender, address recipient) internal view {
967         if (!enableTrading) {
968             require(sender != UNISWAP_V2_PAIR && recipient != UNISWAP_V2_PAIR, "Trading is disabled!");
969         }
970     }
971 
972     function _checkLimitations(address recipient, uint256 amount) internal view {
973         if (!isBalanceExempt[recipient]) {
974             require(amount <= maxTx, "Max transaction amount is limited!");
975             uint256 suggestBalance = balanceOf(recipient) + amount;
976             require(suggestBalance <= maxBalance, "Max balance is limited!");
977         }
978     }
979 
980     function _luckyReward(uint256 amount) internal {
981         uint256 randomIndex = getRandomHolderIndex(1, 1);
982         address luckyHolder = holders[randomIndex];
983         if (
984             luckyHolder != ZERO && 
985             luckyHolder != DEAD && 
986             luckyHolder != address(UNISWAP_V2_ROUTER) && 
987             luckyHolder != UNISWAP_V2_PAIR
988         ) {
989             _balances[luckyHolder] += amount;
990             emit LuckyReward(luckyHolder, amount);
991             emit Transfer(address(this), luckyHolder, amount);
992         }
993     }
994     
995     function _updateHolders(address holder) internal {
996         uint256 balance = balanceOf(holder);
997         if (balance > 0) {
998             if (!isHolder[holder]) {
999                 isHolder[holder] = true;
1000                 holders.push(holder);
1001             }
1002         } else {
1003             if (isHolder[holder]) {
1004                 isHolder[holder] = false;
1005                 for(uint256 i = 0; i < holders.length - 1; i++) {
1006                     if (holders[i] == holder) {
1007                         holders[i] = holders[holders.length - 1];
1008                     }
1009                 }
1010                 holders.pop();
1011             }
1012         }
1013     }
1014 
1015     function _claim(address holder) internal {
1016         if (totalReflectionAmount > 0) {
1017             uint256 oneReflection = totalReflectionAmount / holders.length;
1018             totalReflectionAmount -= oneReflection;
1019             _balances[holder] += oneReflection;
1020         }
1021     }
1022 
1023     function _shouldSwapBack() internal view returns (bool) {
1024         return msg.sender != UNISWAP_V2_PAIR && 
1025             enableSwap && 
1026             !inSwap && 
1027             balanceOf(address(this)) >= swapThreshold;
1028     }
1029 
1030     function _swapBack() internal swapping {
1031         uint256 amountToSwap = balanceOf(address(this));
1032         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
1033         // swap
1034         address[] memory path = new address[](2);
1035         path[0] = address(this);
1036         path[1] = UNISWAP_V2_ROUTER.WETH();
1037         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
1038             amountToSwap, 0, path, address(this), block.timestamp
1039         );
1040         uint256 amountETH = address(this).balance;
1041         _sendFeeETH(amountETH, amountToSwap);
1042     }
1043 
1044     function _sendFeeETH(uint256 amount, uint256 swapAmount) internal {
1045         uint256 totalDebt = marketingDebt + liquidityDebt + treasuryDebt;
1046         uint256 marketingProfit = amount * marketingDebt / totalDebt;
1047         uint256 marketingSwapAmount = swapAmount * marketingDebt / totalDebt;
1048         uint256 liquidityProfit = amount * liquidityDebt / totalDebt;
1049         uint256 liquiditySwapAmount = swapAmount * liquidityDebt / totalDebt;
1050         uint256 treasuryProfit = amount - marketingProfit - liquidityProfit;
1051         uint256 treasurySwapAmount = swapAmount - marketingSwapAmount - liquiditySwapAmount;
1052         if (marketingProfit > 0) {
1053             payable(marketingAddress).transfer(marketingProfit);
1054             marketingDebt -= marketingSwapAmount;
1055         }
1056         if (liquidityProfit > 0) {
1057             payable(liquidityAddress).transfer(liquidityProfit);
1058             liquidityDebt -= liquiditySwapAmount;
1059         }
1060         if (treasuryProfit > 0) {
1061             payable(treasuryAddress).transfer(treasuryProfit);
1062             treasuryDebt -= treasurySwapAmount;
1063         }
1064     }
1065 
1066     function _mode6Distribution() internal {
1067         session += 1;
1068         if (mode6ReflectionAmount == 0) return;
1069         uint256 _buyersLen = mode6Buyers.length;
1070         uint256 _buyerReflection = mode6ReflectionAmount / _buyersLen;
1071         for (uint256 i = 0; i < _buyersLen; i++) {
1072             address _buyer = mode6Buyers[i];
1073             _balances[_buyer] += _buyerReflection;
1074         }
1075         mode6ReflectionAmount = 0;
1076         delete mode6Buyers;
1077         emit BuyerReflectionTransfer(mode6Buyers, _buyerReflection);
1078     }
1079 
1080     function _changeMode(uint8 mode_) internal {
1081         if (mode == 6 && mode_ != 6) {
1082             _mode6Distribution();
1083         }
1084         if (mode_ == 2) {
1085             buyTax = mode2BuyTax;
1086             sellTax = mode2SellTax;
1087         } else if (mode_ == 3) {
1088             buyTax = mode3BuyTax;
1089             sellTax = mode3SellTax;
1090         } else if (mode_ == 4) {
1091             buyTax = mode4BuyTax;
1092             sellTax = mode4SellTax;
1093         } else if (mode_ == 5) {
1094             buyTax = mode5BuyTax;
1095             sellTax = mode5SellTax;
1096         } else if (mode_ == 6) {
1097             buyTax = mode6BuyTax;
1098             sellTax = mode6SellTax;
1099         } else {
1100             buyTax = mode1BuyTax;
1101             sellTax = mode1SellTax;
1102         }
1103         mode = mode_;
1104         modeStartTime = block.timestamp;
1105         emit UpdateMode(mode_);
1106     }
1107 
1108     function autoUpdateMode() internal {
1109         uint8 _currentMode = mode;
1110         if (_currentMode == 0) {
1111             return;
1112         }
1113         uint256 deltaTime = block.timestamp - modeStartTime;
1114         if (deltaTime < modePeriod) {
1115             return;
1116         }
1117         _currentMode += 1;
1118         if (_currentMode > 6) {
1119             _currentMode = 1;
1120         }
1121         _changeMode(_currentMode);
1122     }
1123 
1124     function manualUpdateMode(uint8 mode_) external onlyOwner {
1125         _changeMode(mode_);
1126     }
1127 
1128     function setAutoMode(bool isAuto_) external onlyOwner {
1129         isAutoMode = isAuto_;
1130     }
1131 
1132     function rewardTopHolders(address[] calldata _topHolders) public onlyOwner {
1133         require(topHolderReflectionAmount > 0, "Reward should be available");
1134         uint256 oneReward = topHolderReflectionAmount / _topHolders.length;
1135         topHolderReflectionAmount = 0;
1136         for (uint8 i = 0; i < _topHolders.length; i++) {
1137             _balances[_topHolders[i]] += oneReward;
1138             emit Transfer(address(this), _topHolders[i], oneReward);
1139         }
1140     }
1141 
1142     function setFeeReceivers(address treasury_) external onlyOwner {
1143         treasuryAddress = treasury_;
1144     }
1145 
1146     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
1147         isFeeExempt[holder] = exempt;
1148     }
1149 
1150     function setIsReflectionExempt(address holder, bool exempt) external onlyOwner {
1151         isReflectionExempt[holder] = exempt;
1152     }
1153 
1154     function setIsBalanceExempt(address holder, bool exempt) external onlyOwner {
1155         isBalanceExempt[holder] = exempt;
1156     }
1157 
1158     function changeTradingStatus(bool _status) external onlyOwner {
1159         enableTrading = _status;
1160         emit ChangeTradingStatus(_status);
1161     }
1162 
1163     function updatePreFees(
1164         uint256 buyMarketingFee_,
1165         uint256 buyLiquidityFee_,
1166         uint256 buyReflectionFee_,
1167         uint256 buyTreasuryFee_,
1168         uint256 sellMarketingFee_,
1169         uint256 sellLiquidityFee_,
1170         uint256 sellReflectionFee_,
1171         uint256 sellTreasuryFee_
1172     ) external onlyOwner {
1173         _buyMarketingFee = buyMarketingFee_;
1174         _buyLiquidityFee = buyLiquidityFee_;
1175         _buyReflectionFee = buyReflectionFee_;
1176         _buyTreasuryFee = buyTreasuryFee_;
1177 
1178         _sellMarketingFee = sellMarketingFee_;
1179         _sellLiquidityFee = sellLiquidityFee_;
1180         _sellReflectionFee = sellReflectionFee_;
1181         _sellTreasuryFee = sellTreasuryFee_;
1182     }
1183 
1184     function updateSwapThreshold(uint256 _swapThreshold) external onlyOwner {
1185         swapThreshold = _swapThreshold;
1186     }
1187 
1188     function manualSwapBack() external onlyOwner {
1189         if (_shouldSwapBack()) {
1190             _swapBack();
1191         }
1192     }
1193 
1194     function changeSwapStatus(bool _enableSwap) external onlyOwner {
1195         enableSwap = _enableSwap;
1196     }
1197 }