1 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b <= a, "SafeMath: subtraction overflow");
124         uint256 c = a - b;
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `*` operator.
134      *
135      * Requirements:
136      * - Multiplication cannot overflow.
137      */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers. Reverts on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator. Note: this function uses a
157      * `revert` opcode (which leaves remaining gas untouched) while Solidity
158      * uses an invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Solidity only automatically asserts when dividing by 0
165         require(b > 0, "SafeMath: division by zero");
166         uint256 c = a / b;
167         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b != 0, "SafeMath: modulo by zero");
185         return a % b;
186     }
187 }
188 
189 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Contract module that helps prevent reentrant calls to a function.
195  *
196  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
197  * available, which can be aplied to functions to make sure there are no nested
198  * (reentrant) calls to them.
199  *
200  * Note that because there is a single `nonReentrant` guard, functions marked as
201  * `nonReentrant` may not call one another. This can be worked around by making
202  * those functions `private`, and then adding `external` `nonReentrant` entry
203  * points to them.
204  */
205 contract ReentrancyGuard {
206     /// @dev counter to allow mutex lock with only one SSTORE operation
207     uint256 private _guardCounter;
208 
209     constructor () internal {
210         // The counter starts at one to prevent changing it from zero to a non-zero
211         // value, which is a more expensive operation.
212         _guardCounter = 1;
213     }
214 
215     /**
216      * @dev Prevents a contract from calling itself, directly or indirectly.
217      * Calling a `nonReentrant` function from another `nonReentrant`
218      * function is not supported. It is possible to prevent this from happening
219      * by making the `nonReentrant` function external, and make it call a
220      * `private` function that does the actual work.
221      */
222     modifier nonReentrant() {
223         _guardCounter += 1;
224         uint256 localCounter = _guardCounter;
225         _;
226         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
227     }
228 }
229 
230 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /**
235  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
236  * the optional functions; to access them see `ERC20Detailed`.
237  */
238 interface IERC20 {
239     /**
240      * @dev Returns the amount of tokens in existence.
241      */
242     function totalSupply() external view returns (uint256);
243 
244     /**
245      * @dev Returns the amount of tokens owned by `account`.
246      */
247     function balanceOf(address account) external view returns (uint256);
248 
249     /**
250      * @dev Moves `amount` tokens from the caller's account to `recipient`.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * Emits a `Transfer` event.
255      */
256     function transfer(address recipient, uint256 amount) external returns (bool);
257 
258     /**
259      * @dev Returns the remaining number of tokens that `spender` will be
260      * allowed to spend on behalf of `owner` through `transferFrom`. This is
261      * zero by default.
262      *
263      * This value changes when `approve` or `transferFrom` are called.
264      */
265     function allowance(address owner, address spender) external view returns (uint256);
266 
267     /**
268      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * > Beware that changing an allowance with this method brings the risk
273      * that someone may use both the old and the new allowance by unfortunate
274      * transaction ordering. One possible solution to mitigate this race
275      * condition is to first reduce the spender's allowance to 0 and set the
276      * desired value afterwards:
277      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278      *
279      * Emits an `Approval` event.
280      */
281     function approve(address spender, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Moves `amount` tokens from `sender` to `recipient` using the
285      * allowance mechanism. `amount` is then deducted from the caller's
286      * allowance.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * Emits a `Transfer` event.
291      */
292     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
293 
294     /**
295      * @dev Emitted when `value` tokens are moved from one account (`from`) to
296      * another (`to`).
297      *
298      * Note that `value` may be zero.
299      */
300     event Transfer(address indexed from, address indexed to, uint256 value);
301 
302     /**
303      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
304      * a call to `approve`. `value` is the new allowance.
305      */
306     event Approval(address indexed owner, address indexed spender, uint256 value);
307 }
308 
309 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
310 
311 pragma solidity >=0.5.0;
312 
313 interface IUniswapV2Factory {
314     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
315 
316     function feeTo() external view returns (address);
317     function feeToSetter() external view returns (address);
318 
319     function getPair(address tokenA, address tokenB) external view returns (address pair);
320     function allPairs(uint) external view returns (address pair);
321     function allPairsLength() external view returns (uint);
322 
323     function createPair(address tokenA, address tokenB) external returns (address pair);
324 
325     function setFeeTo(address) external;
326     function setFeeToSetter(address) external;
327 }
328 
329 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
330 
331 pragma solidity >=0.5.0;
332 
333 interface IUniswapV2Pair {
334     event Approval(address indexed owner, address indexed spender, uint value);
335     event Transfer(address indexed from, address indexed to, uint value);
336 
337     function name() external pure returns (string memory);
338     function symbol() external pure returns (string memory);
339     function decimals() external pure returns (uint8);
340     function totalSupply() external view returns (uint);
341     function balanceOf(address owner) external view returns (uint);
342     function allowance(address owner, address spender) external view returns (uint);
343 
344     function approve(address spender, uint value) external returns (bool);
345     function transfer(address to, uint value) external returns (bool);
346     function transferFrom(address from, address to, uint value) external returns (bool);
347 
348     function DOMAIN_SEPARATOR() external view returns (bytes32);
349     function PERMIT_TYPEHASH() external pure returns (bytes32);
350     function nonces(address owner) external view returns (uint);
351 
352     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
353 
354     event Mint(address indexed sender, uint amount0, uint amount1);
355     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
356     event Swap(
357         address indexed sender,
358         uint amount0In,
359         uint amount1In,
360         uint amount0Out,
361         uint amount1Out,
362         address indexed to
363     );
364     event Sync(uint112 reserve0, uint112 reserve1);
365 
366     function MINIMUM_LIQUIDITY() external pure returns (uint);
367     function factory() external view returns (address);
368     function token0() external view returns (address);
369     function token1() external view returns (address);
370     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
371     function price0CumulativeLast() external view returns (uint);
372     function price1CumulativeLast() external view returns (uint);
373     function kLast() external view returns (uint);
374 
375     function mint(address to) external returns (uint liquidity);
376     function burn(address to) external returns (uint amount0, uint amount1);
377     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
378     function skim(address to) external;
379     function sync() external;
380 
381     function initialize(address, address) external;
382 }
383 
384 // File: @uniswap/v2-core/contracts/libraries/Math.sol
385 
386 pragma solidity =0.5.16;
387 
388 // a library for performing various math operations
389 
390 library Math {
391     function min(uint x, uint y) internal pure returns (uint z) {
392         z = x < y ? x : y;
393     }
394 
395     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
396     function sqrt(uint y) internal pure returns (uint z) {
397         if (y > 3) {
398             z = y;
399             uint x = y / 2 + 1;
400             while (x < z) {
401                 z = x;
402                 x = (y / x + x) / 2;
403             }
404         } else if (y != 0) {
405             z = 1;
406         }
407     }
408 }
409 
410 // File: contracts/5/uniswap/IUniswapV2Router02.sol
411 
412 pragma solidity >=0.5.0;
413 
414 interface IUniswapV2Router02 {
415     function factory() external pure returns (address);
416 
417     function WETH() external pure returns (address);
418 
419     function addLiquidity(
420         address tokenA,
421         address tokenB,
422         uint256 amountADesired,
423         uint256 amountBDesired,
424         uint256 amountAMin,
425         uint256 amountBMin,
426         address to,
427         uint256 deadline
428     )
429         external
430         returns (
431             uint256 amountA,
432             uint256 amountB,
433             uint256 liquidity
434         );
435 
436     function addLiquidityETH(
437         address token,
438         uint256 amountTokenDesired,
439         uint256 amountTokenMin,
440         uint256 amountETHMin,
441         address to,
442         uint256 deadline
443     )
444         external
445         payable
446         returns (
447             uint256 amountToken,
448             uint256 amountETH,
449             uint256 liquidity
450         );
451 
452     function removeLiquidity(
453         address tokenA,
454         address tokenB,
455         uint256 liquidity,
456         uint256 amountAMin,
457         uint256 amountBMin,
458         address to,
459         uint256 deadline
460     ) external returns (uint256 amountA, uint256 amountB);
461 
462     function removeLiquidityETH(
463         address token,
464         uint256 liquidity,
465         uint256 amountTokenMin,
466         uint256 amountETHMin,
467         address to,
468         uint256 deadline
469     ) external returns (uint256 amountToken, uint256 amountETH);
470 
471     function removeLiquidityWithPermit(
472         address tokenA,
473         address tokenB,
474         uint256 liquidity,
475         uint256 amountAMin,
476         uint256 amountBMin,
477         address to,
478         uint256 deadline,
479         bool approveMax,
480         uint8 v,
481         bytes32 r,
482         bytes32 s
483     ) external returns (uint256 amountA, uint256 amountB);
484 
485     function removeLiquidityETHWithPermit(
486         address token,
487         uint256 liquidity,
488         uint256 amountTokenMin,
489         uint256 amountETHMin,
490         address to,
491         uint256 deadline,
492         bool approveMax,
493         uint8 v,
494         bytes32 r,
495         bytes32 s
496     ) external returns (uint256 amountToken, uint256 amountETH);
497 
498     function swapExactTokensForTokens(
499         uint256 amountIn,
500         uint256 amountOutMin,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external returns (uint256[] memory amounts);
505 
506     function swapTokensForExactTokens(
507         uint256 amountOut,
508         uint256 amountInMax,
509         address[] calldata path,
510         address to,
511         uint256 deadline
512     ) external returns (uint256[] memory amounts);
513 
514     function swapExactETHForTokens(
515         uint256 amountOutMin,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external payable returns (uint256[] memory amounts);
520 
521     function swapTokensForExactETH(
522         uint256 amountOut,
523         uint256 amountInMax,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external returns (uint256[] memory amounts);
528 
529     function swapExactTokensForETH(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external returns (uint256[] memory amounts);
536 
537     function swapETHForExactTokens(
538         uint256 amountOut,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external payable returns (uint256[] memory amounts);
543 
544     function quote(
545         uint256 amountA,
546         uint256 reserveA,
547         uint256 reserveB
548     ) external pure returns (uint256 amountB);
549 
550     function getAmountOut(
551         uint256 amountIn,
552         uint256 reserveIn,
553         uint256 reserveOut
554     ) external pure returns (uint256 amountOut);
555 
556     function getAmountIn(
557         uint256 amountOut,
558         uint256 reserveIn,
559         uint256 reserveOut
560     ) external pure returns (uint256 amountIn);
561 
562     function getAmountsOut(uint256 amountIn, address[] calldata path)
563         external
564         view
565         returns (uint256[] memory amounts);
566 
567     function getAmountsIn(uint256 amountOut, address[] calldata path)
568         external
569         view
570         returns (uint256[] memory amounts);
571 
572     function removeLiquidityETHSupportingFeeOnTransferTokens(
573         address token,
574         uint256 liquidity,
575         uint256 amountTokenMin,
576         uint256 amountETHMin,
577         address to,
578         uint256 deadline
579     ) external returns (uint256 amountETH);
580 
581     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
582         address token,
583         uint256 liquidity,
584         uint256 amountTokenMin,
585         uint256 amountETHMin,
586         address to,
587         uint256 deadline,
588         bool approveMax,
589         uint8 v,
590         bytes32 r,
591         bytes32 s
592     ) external returns (uint256 amountETH);
593 
594     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
595         uint256 amountIn,
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external;
601 
602     function swapExactETHForTokensSupportingFeeOnTransferTokens(
603         uint256 amountOutMin,
604         address[] calldata path,
605         address to,
606         uint256 deadline
607     ) external payable;
608 
609     function swapExactTokensForETHSupportingFeeOnTransferTokens(
610         uint256 amountIn,
611         uint256 amountOutMin,
612         address[] calldata path,
613         address to,
614         uint256 deadline
615     ) external;
616 }
617 
618 // File: contracts/5/Strategy.sol
619 
620 pragma solidity 0.5.16;
621 
622 interface Strategy {
623     /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.
624     /// @param user The original user that is interacting with the operator.
625     /// @param debt The user's total debt, for better decision making context.
626     /// @param data Extra calldata information passed along to this strategy.
627     function execute(address user, uint256 debt, bytes calldata data) external payable;
628 }
629 
630 // File: contracts/5/SafeToken.sol
631 
632 pragma solidity 0.5.16;
633 
634 interface ERC20Interface {
635     function balanceOf(address user) external view returns (uint256);
636 }
637 
638 library SafeToken {
639     function myBalance(address token) internal view returns (uint256) {
640         return ERC20Interface(token).balanceOf(address(this));
641     }
642 
643     function balanceOf(address token, address user) internal view returns (uint256) {
644         return ERC20Interface(token).balanceOf(user);
645     }
646 
647     function safeApprove(address token, address to, uint256 value) internal {
648         // bytes4(keccak256(bytes('approve(address,uint256)')));
649         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
650         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
651     }
652 
653     function safeTransfer(address token, address to, uint256 value) internal {
654         // bytes4(keccak256(bytes('transfer(address,uint256)')));
655         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
656         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
657     }
658 
659     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
660         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
661         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
662         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
663     }
664 
665     function safeTransferETH(address to, uint256 value) internal {
666         (bool success, ) = to.call.value(value)(new bytes(0));
667         require(success, "!safeTransferETH");
668     }
669 }
670 
671 // File: contracts/5/Goblin.sol
672 
673 pragma solidity 0.5.16;
674 
675 interface Goblin {
676     /// @dev Work on a (potentially new) position. Optionally send ETH back to Bank.
677     function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;
678 
679     /// @dev Re-invest whatever the goblin is working on.
680     function reinvest() external;
681 
682     /// @dev Return the amount of ETH wei to get back if we are to liquidate the position.
683     function health(uint256 id) external view returns (uint256);
684 
685     /// @dev Liquidate the given position to ETH. Send all ETH back to Bank.
686     function liquidate(uint256 id) external;
687 }
688 
689 // File: contracts/5/interfaces/IMasterChef.sol
690 
691 pragma solidity 0.5.16;
692 
693 
694 // Making the original MasterChef as an interface leads to compilation fail.
695 // Use Contract instead of Interface here
696 contract IMasterChef {
697     // Info of each user.
698     struct UserInfo {
699         uint256 amount; // How many LP tokens the user has provided.
700         uint256 rewardDebt; // Reward debt. See explanation below.
701     }
702 
703     // Info of each pool.
704     struct PoolInfo {
705         IERC20 lpToken; // Address of LP token contract.
706         uint256 allocPoint; // How many allocation points assigned to this pool. SUSHIs to distribute per block.
707         uint256 lastRewardBlock; // Last block number that SUSHIs distribution occurs.
708         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
709     }
710 
711     address public sushi;
712 
713     // Info of each user that stakes LP tokens.
714     mapping(uint256 => PoolInfo) public poolInfo;
715     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
716 
717     // Deposit LP tokens to MasterChef for SUSHI allocation.
718     function deposit(uint256 _pid, uint256 _amount) external {}
719 
720     // Withdraw LP tokens from MasterChef.
721     function withdraw(uint256 _pid, uint256 _amount) external {}
722 }
723 
724 // File: contracts/5/SushiswapGoblin.sol
725 
726 pragma solidity 0.5.16;
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 contract SushiswapGoblin is Ownable, ReentrancyGuard, Goblin {
741     /// @notice Libraries
742     using SafeToken for address;
743     using SafeMath for uint256;
744 
745     /// @notice Events
746     event Reinvest(address indexed caller, uint256 reward, uint256 bounty);
747     event AddShare(uint256 indexed id, uint256 share);
748     event RemoveShare(uint256 indexed id, uint256 share);
749     event Liquidate(uint256 indexed id, uint256 wad);
750 
751     /// @notice Immutable variables
752     IMasterChef public masterChef;
753     IUniswapV2Factory public factory;
754     IUniswapV2Router02 public router;
755     IUniswapV2Pair public lpToken;
756     address public weth;
757     address public fToken;
758     address public sushi;
759     address public operator;
760     uint256 public pid;
761 
762     /// @notice Mutable state variables
763     mapping(uint256 => uint256) public shares;
764     mapping(address => bool) public okStrats;
765     uint256 public totalShare;
766     Strategy public addStrat;
767     Strategy public liqStrat;
768     uint256 public reinvestBountyBps;
769 
770     constructor(
771         address _operator,
772         IMasterChef _masterChef,
773         IUniswapV2Router02 _router,
774         uint256 _pid,        
775         Strategy _addStrat,
776         Strategy _liqStrat,
777         uint256 _reinvestBountyBps
778     ) public {
779         operator = _operator;
780         weth = _router.WETH();
781         masterChef = _masterChef;
782         router = _router;
783         factory = IUniswapV2Factory(_router.factory());
784         // Get lpToken and fToken from MasterChef pool
785         pid = _pid;
786         (IERC20 _lpToken, , , ) = masterChef.poolInfo(_pid);
787         lpToken = IUniswapV2Pair(address(_lpToken));
788         address token0 = lpToken.token0();
789         address token1 = lpToken.token1();
790         fToken = token0 == weth ? token1 : token0;
791         sushi = address(masterChef.sushi());
792         addStrat = _addStrat;
793         liqStrat = _liqStrat;
794         okStrats[address(addStrat)] = true;
795         okStrats[address(liqStrat)] = true;
796         reinvestBountyBps = _reinvestBountyBps;
797         lpToken.approve(address(_masterChef), uint256(-1)); // 100% trust in the staking pool
798         lpToken.approve(address(router), uint256(-1)); // 100% trust in the router
799         fToken.safeApprove(address(router), uint256(-1)); // 100% trust in the router
800         sushi.safeApprove(address(router), uint256(-1)); // 100% trust in the router
801     }
802 
803     /// @dev Require that the caller must be an EOA account to avoid flash loans.
804     modifier onlyEOA() {
805         require(msg.sender == tx.origin, "not eoa");
806         _;
807     }
808 
809     /// @dev Require that the caller must be the operator (the bank).
810     modifier onlyOperator() {
811         require(msg.sender == operator, "not operator");
812         _;
813     }
814 
815     /// @dev Return the entitied LP token balance for the given shares.
816     /// @param share The number of shares to be converted to LP balance.
817     function shareToBalance(uint256 share) public view returns (uint256) {
818         if (totalShare == 0) return share; // When there's no share, 1 share = 1 balance.
819         (uint256 totalBalance, ) = masterChef.userInfo(pid, address(this));
820         return share.mul(totalBalance).div(totalShare);
821     }
822 
823     /// @dev Return the number of shares to receive if staking the given LP tokens.
824     /// @param balance the number of LP tokens to be converted to shares.
825     function balanceToShare(uint256 balance) public view returns (uint256) {
826         if (totalShare == 0) return balance; // When there's no share, 1 share = 1 balance.
827         (uint256 totalBalance, ) = masterChef.userInfo(pid, address(this));
828         return balance.mul(totalShare).div(totalBalance);
829     }
830 
831     /// @dev Re-invest whatever this worker has earned back to staked LP tokens.
832     function reinvest() public onlyEOA nonReentrant {
833         // 1. Withdraw all the rewards.        
834         masterChef.withdraw(pid, 0);
835         uint256 reward = sushi.balanceOf(address(this));
836         if (reward == 0) return;
837         // 2. Send the reward bounty to the caller.
838         uint256 bounty = reward.mul(reinvestBountyBps) / 10000;
839         sushi.safeTransfer(msg.sender, bounty);
840         // 3. Convert all the remaining rewards to ETH.
841         address[] memory path = new address[](2);
842         path[0] = address(sushi);
843         path[1] = address(weth);
844         router.swapExactTokensForETH(reward.sub(bounty), 0, path, address(this), now);
845         // 4. Use add ETH strategy to convert all ETH to LP tokens.
846         addStrat.execute.value(address(this).balance)(address(0), 0, abi.encode(fToken, 0));
847         // 5. Mint more LP tokens and stake them for more rewards.
848         masterChef.deposit(pid, lpToken.balanceOf(address(this)));
849         emit Reinvest(msg.sender, reward, bounty);
850     }
851 
852     /// @dev Work on the given position. Must be called by the operator.
853     /// @param id The position ID to work on.
854     /// @param user The original user that is interacting with the operator.
855     /// @param debt The amount of user debt to help the strategy make decisions.
856     /// @param data The encoded data, consisting of strategy address and calldata.
857     function work(uint256 id, address user, uint256 debt, bytes calldata data) 
858         external payable 
859         onlyOperator nonReentrant 
860     {
861         // 1. Convert this position back to LP tokens.
862         _removeShare(id);
863         // 2. Perform the worker strategy; sending LP tokens + ETH; expecting LP tokens + ETH.
864         (address strat, bytes memory ext) = abi.decode(data, (address, bytes));
865         require(okStrats[strat], "unapproved work strategy");
866         lpToken.transfer(strat, lpToken.balanceOf(address(this)));
867         Strategy(strat).execute.value(msg.value)(user, debt, ext);
868         // 3. Add LP tokens back to the farming pool.
869         _addShare(id);
870         // 4. Return any remaining ETH back to the operator.
871         SafeToken.safeTransferETH(msg.sender, address(this).balance);
872     }
873 
874     /// @dev Return maximum output given the input amount and the status of Uniswap reserves.
875     /// @param aIn The amount of asset to market sell.
876     /// @param rIn the amount of asset in reserve for input.
877     /// @param rOut The amount of asset in reserve for output.
878     function getMktSellAmount(uint256 aIn, uint256 rIn, uint256 rOut) public pure returns (uint256) {
879         if (aIn == 0) return 0;
880         require(rIn > 0 && rOut > 0, "bad reserve values");
881         uint256 aInWithFee = aIn.mul(997);
882         uint256 numerator = aInWithFee.mul(rOut);
883         uint256 denominator = rIn.mul(1000).add(aInWithFee);
884         return numerator / denominator;
885     }
886 
887     /// @dev Return the amount of ETH to receive if we are to liquidate the given position.
888     /// @param id The position ID to perform health check.
889     function health(uint256 id) external view returns (uint256) {
890         // 1. Get the position's LP balance and LP total supply.
891         uint256 lpBalance = shareToBalance(shares[id]);
892         uint256 lpSupply = lpToken.totalSupply(); // Ignore pending mintFee as it is insignificant
893         // 2. Get the pool's total supply of WETH and farming token.
894         (uint256 r0, uint256 r1,) = lpToken.getReserves();
895         (uint256 totalWETH, uint256 totalfToken) = lpToken.token0() == weth ? (r0, r1) : (r1, r0);
896         // 3. Convert the position's LP tokens to the underlying assets.
897         uint256 userWETH = lpBalance.mul(totalWETH).div(lpSupply);
898         uint256 userfToken = lpBalance.mul(totalfToken).div(lpSupply);
899         // 4. Convert all farming tokens to ETH and return total ETH.
900         return getMktSellAmount(
901             userfToken, totalfToken.sub(userfToken), totalWETH.sub(userWETH)
902         ).add(userWETH);
903     }
904 
905     /// @dev Liquidate the given position by converting it to ETH and return back to caller.
906     /// @param id The position ID to perform liquidation
907     function liquidate(uint256 id) external onlyOperator nonReentrant {
908         // 1. Convert the position back to LP tokens and use liquidate strategy.
909         _removeShare(id);
910         lpToken.transfer(address(liqStrat), lpToken.balanceOf(address(this)));
911         liqStrat.execute(address(0), 0, abi.encode(fToken, 0));
912         // 2. Return all available ETH back to the operator.
913         uint256 wad = address(this).balance;
914         SafeToken.safeTransferETH(msg.sender, wad);
915         emit Liquidate(id, wad);
916     }
917 
918     /// @dev Internal function to stake all outstanding LP tokens to the given position ID.
919     function _addShare(uint256 id) internal {
920         uint256 balance = lpToken.balanceOf(address(this));
921         if (balance > 0) {
922             uint256 share = balanceToShare(balance);
923             masterChef.deposit(pid, balance);
924             shares[id] = shares[id].add(share);
925             totalShare = totalShare.add(share);
926             emit AddShare(id, share);
927         }
928     }
929 
930     /// @dev Internal function to remove shares of the ID and convert to outstanding LP tokens.
931     function _removeShare(uint256 id) internal {
932         uint256 share = shares[id];
933         if (share > 0) {
934             uint256 balance = shareToBalance(share);
935             masterChef.withdraw(pid, balance);
936             totalShare = totalShare.sub(share);
937             shares[id] = 0;
938             emit RemoveShare(id, share);
939         }
940     }
941 
942     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
943     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
944     /// @param to The address to send the tokens to.
945     /// @param value The number of tokens to transfer to `to`.
946     function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {
947         token.safeTransfer(to, value);
948     }
949 
950     /// @dev Set the reward bounty for calling reinvest operations.
951     /// @param _reinvestBountyBps The bounty value to update.
952     function setReinvestBountyBps(uint256 _reinvestBountyBps) external onlyOwner {
953         reinvestBountyBps = _reinvestBountyBps;
954     }
955 
956     /// @dev Set the given strategies' approval status.
957     /// @param strats The strategy addresses.
958     /// @param isOk Whether to approve or unapprove the given strategies.
959     function setStrategyOk(address[] calldata strats, bool isOk) external onlyOwner {
960         uint256 len = strats.length;
961         for (uint256 idx = 0; idx < len; idx++) {
962             okStrats[strats[idx]] = isOk;
963         }
964     }
965 
966     /// @dev Update critical strategy smart contracts. EMERGENCY ONLY. Bad strategies can steal funds.
967     /// @param _addStrat The new add strategy contract.
968     /// @param _liqStrat The new liquidate strategy contract.
969     function setCriticalStrategies(Strategy _addStrat, Strategy _liqStrat) external onlyOwner {
970         addStrat = _addStrat;
971         liqStrat = _liqStrat;
972     }
973 
974     function() external payable {}
975 }