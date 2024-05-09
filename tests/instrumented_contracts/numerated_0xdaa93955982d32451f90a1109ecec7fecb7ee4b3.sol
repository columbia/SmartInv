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
230 // File: synthetix/contracts/interfaces/IStakingRewards.sol
231 
232 pragma solidity >=0.4.24;
233 
234 
235 interface IStakingRewards {
236     // Views
237     function lastTimeRewardApplicable() external view returns (uint256);
238 
239     function rewardPerToken() external view returns (uint256);
240 
241     function earned(address account) external view returns (uint256);
242 
243     function getRewardForDuration() external view returns (uint256);
244 
245     function totalSupply() external view returns (uint256);
246 
247     function balanceOf(address account) external view returns (uint256);
248 
249     // Mutative
250 
251     function stake(uint256 amount) external;
252 
253     function withdraw(uint256 amount) external;
254 
255     function getReward() external;
256 
257     function exit() external;
258 }
259 
260 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
261 
262 pragma solidity >=0.5.0;
263 
264 interface IUniswapV2Factory {
265     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
266 
267     function feeTo() external view returns (address);
268     function feeToSetter() external view returns (address);
269 
270     function getPair(address tokenA, address tokenB) external view returns (address pair);
271     function allPairs(uint) external view returns (address pair);
272     function allPairsLength() external view returns (uint);
273 
274     function createPair(address tokenA, address tokenB) external returns (address pair);
275 
276     function setFeeTo(address) external;
277     function setFeeToSetter(address) external;
278 }
279 
280 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
281 
282 pragma solidity >=0.5.0;
283 
284 interface IUniswapV2Pair {
285     event Approval(address indexed owner, address indexed spender, uint value);
286     event Transfer(address indexed from, address indexed to, uint value);
287 
288     function name() external pure returns (string memory);
289     function symbol() external pure returns (string memory);
290     function decimals() external pure returns (uint8);
291     function totalSupply() external view returns (uint);
292     function balanceOf(address owner) external view returns (uint);
293     function allowance(address owner, address spender) external view returns (uint);
294 
295     function approve(address spender, uint value) external returns (bool);
296     function transfer(address to, uint value) external returns (bool);
297     function transferFrom(address from, address to, uint value) external returns (bool);
298 
299     function DOMAIN_SEPARATOR() external view returns (bytes32);
300     function PERMIT_TYPEHASH() external pure returns (bytes32);
301     function nonces(address owner) external view returns (uint);
302 
303     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
304 
305     event Mint(address indexed sender, uint amount0, uint amount1);
306     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
307     event Swap(
308         address indexed sender,
309         uint amount0In,
310         uint amount1In,
311         uint amount0Out,
312         uint amount1Out,
313         address indexed to
314     );
315     event Sync(uint112 reserve0, uint112 reserve1);
316 
317     function MINIMUM_LIQUIDITY() external pure returns (uint);
318     function factory() external view returns (address);
319     function token0() external view returns (address);
320     function token1() external view returns (address);
321     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
322     function price0CumulativeLast() external view returns (uint);
323     function price1CumulativeLast() external view returns (uint);
324     function kLast() external view returns (uint);
325 
326     function mint(address to) external returns (uint liquidity);
327     function burn(address to) external returns (uint amount0, uint amount1);
328     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
329     function skim(address to) external;
330     function sync() external;
331 
332     function initialize(address, address) external;
333 }
334 
335 // File: @uniswap/v2-core/contracts/libraries/Math.sol
336 
337 pragma solidity =0.5.16;
338 
339 // a library for performing various math operations
340 
341 library Math {
342     function min(uint x, uint y) internal pure returns (uint z) {
343         z = x < y ? x : y;
344     }
345 
346     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
347     function sqrt(uint y) internal pure returns (uint z) {
348         if (y > 3) {
349             z = y;
350             uint x = y / 2 + 1;
351             while (x < z) {
352                 z = x;
353                 x = (y / x + x) / 2;
354             }
355         } else if (y != 0) {
356             z = 1;
357         }
358     }
359 }
360 
361 // File: contracts/uniswap/IUniswapV2Router02.sol
362 
363 pragma solidity >=0.5.0;
364 
365 interface IUniswapV2Router02 {
366     function factory() external pure returns (address);
367 
368     function WETH() external pure returns (address);
369 
370     function addLiquidity(
371         address tokenA,
372         address tokenB,
373         uint256 amountADesired,
374         uint256 amountBDesired,
375         uint256 amountAMin,
376         uint256 amountBMin,
377         address to,
378         uint256 deadline
379     )
380         external
381         returns (
382             uint256 amountA,
383             uint256 amountB,
384             uint256 liquidity
385         );
386 
387     function addLiquidityETH(
388         address token,
389         uint256 amountTokenDesired,
390         uint256 amountTokenMin,
391         uint256 amountETHMin,
392         address to,
393         uint256 deadline
394     )
395         external
396         payable
397         returns (
398             uint256 amountToken,
399             uint256 amountETH,
400             uint256 liquidity
401         );
402 
403     function removeLiquidity(
404         address tokenA,
405         address tokenB,
406         uint256 liquidity,
407         uint256 amountAMin,
408         uint256 amountBMin,
409         address to,
410         uint256 deadline
411     ) external returns (uint256 amountA, uint256 amountB);
412 
413     function removeLiquidityETH(
414         address token,
415         uint256 liquidity,
416         uint256 amountTokenMin,
417         uint256 amountETHMin,
418         address to,
419         uint256 deadline
420     ) external returns (uint256 amountToken, uint256 amountETH);
421 
422     function removeLiquidityWithPermit(
423         address tokenA,
424         address tokenB,
425         uint256 liquidity,
426         uint256 amountAMin,
427         uint256 amountBMin,
428         address to,
429         uint256 deadline,
430         bool approveMax,
431         uint8 v,
432         bytes32 r,
433         bytes32 s
434     ) external returns (uint256 amountA, uint256 amountB);
435 
436     function removeLiquidityETHWithPermit(
437         address token,
438         uint256 liquidity,
439         uint256 amountTokenMin,
440         uint256 amountETHMin,
441         address to,
442         uint256 deadline,
443         bool approveMax,
444         uint8 v,
445         bytes32 r,
446         bytes32 s
447     ) external returns (uint256 amountToken, uint256 amountETH);
448 
449     function swapExactTokensForTokens(
450         uint256 amountIn,
451         uint256 amountOutMin,
452         address[] calldata path,
453         address to,
454         uint256 deadline
455     ) external returns (uint256[] memory amounts);
456 
457     function swapTokensForExactTokens(
458         uint256 amountOut,
459         uint256 amountInMax,
460         address[] calldata path,
461         address to,
462         uint256 deadline
463     ) external returns (uint256[] memory amounts);
464 
465     function swapExactETHForTokens(
466         uint256 amountOutMin,
467         address[] calldata path,
468         address to,
469         uint256 deadline
470     ) external payable returns (uint256[] memory amounts);
471 
472     function swapTokensForExactETH(
473         uint256 amountOut,
474         uint256 amountInMax,
475         address[] calldata path,
476         address to,
477         uint256 deadline
478     ) external returns (uint256[] memory amounts);
479 
480     function swapExactTokensForETH(
481         uint256 amountIn,
482         uint256 amountOutMin,
483         address[] calldata path,
484         address to,
485         uint256 deadline
486     ) external returns (uint256[] memory amounts);
487 
488     function swapETHForExactTokens(
489         uint256 amountOut,
490         address[] calldata path,
491         address to,
492         uint256 deadline
493     ) external payable returns (uint256[] memory amounts);
494 
495     function quote(
496         uint256 amountA,
497         uint256 reserveA,
498         uint256 reserveB
499     ) external pure returns (uint256 amountB);
500 
501     function getAmountOut(
502         uint256 amountIn,
503         uint256 reserveIn,
504         uint256 reserveOut
505     ) external pure returns (uint256 amountOut);
506 
507     function getAmountIn(
508         uint256 amountOut,
509         uint256 reserveIn,
510         uint256 reserveOut
511     ) external pure returns (uint256 amountIn);
512 
513     function getAmountsOut(uint256 amountIn, address[] calldata path)
514         external
515         view
516         returns (uint256[] memory amounts);
517 
518     function getAmountsIn(uint256 amountOut, address[] calldata path)
519         external
520         view
521         returns (uint256[] memory amounts);
522 
523     function removeLiquidityETHSupportingFeeOnTransferTokens(
524         address token,
525         uint256 liquidity,
526         uint256 amountTokenMin,
527         uint256 amountETHMin,
528         address to,
529         uint256 deadline
530     ) external returns (uint256 amountETH);
531 
532     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
533         address token,
534         uint256 liquidity,
535         uint256 amountTokenMin,
536         uint256 amountETHMin,
537         address to,
538         uint256 deadline,
539         bool approveMax,
540         uint8 v,
541         bytes32 r,
542         bytes32 s
543     ) external returns (uint256 amountETH);
544 
545     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
546         uint256 amountIn,
547         uint256 amountOutMin,
548         address[] calldata path,
549         address to,
550         uint256 deadline
551     ) external;
552 
553     function swapExactETHForTokensSupportingFeeOnTransferTokens(
554         uint256 amountOutMin,
555         address[] calldata path,
556         address to,
557         uint256 deadline
558     ) external payable;
559 
560     function swapExactTokensForETHSupportingFeeOnTransferTokens(
561         uint256 amountIn,
562         uint256 amountOutMin,
563         address[] calldata path,
564         address to,
565         uint256 deadline
566     ) external;
567 }
568 
569 // File: contracts/Strategy.sol
570 
571 pragma solidity 0.5.16;
572 
573 interface Strategy {
574     /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.
575     /// @param user The original user that is interacting with the operator.
576     /// @param debt The user's total debt, for better decision making context.
577     /// @param data Extra calldata information passed along to this strategy.
578     function execute(address user, uint256 debt, bytes calldata data) external payable;
579 }
580 
581 // File: contracts/SafeToken.sol
582 
583 pragma solidity 0.5.16;
584 
585 interface ERC20Interface {
586     function balanceOf(address user) external view returns (uint256);
587 }
588 
589 library SafeToken {
590     function myBalance(address token) internal view returns (uint256) {
591         return ERC20Interface(token).balanceOf(address(this));
592     }
593 
594     function balanceOf(address token, address user) internal view returns (uint256) {
595         return ERC20Interface(token).balanceOf(user);
596     }
597 
598     function safeApprove(address token, address to, uint256 value) internal {
599         // bytes4(keccak256(bytes('approve(address,uint256)')));
600         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
601         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
602     }
603 
604     function safeTransfer(address token, address to, uint256 value) internal {
605         // bytes4(keccak256(bytes('transfer(address,uint256)')));
606         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
607         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
608     }
609 
610     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
611         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
612         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
613         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
614     }
615 
616     function safeTransferETH(address to, uint256 value) internal {
617         (bool success, ) = to.call.value(value)(new bytes(0));
618         require(success, "!safeTransferETH");
619     }
620 }
621 
622 // File: contracts/Goblin.sol
623 
624 pragma solidity 0.5.16;
625 
626 interface Goblin {
627     /// @dev Work on a (potentially new) position. Optionally send ETH back to Bank.
628     function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;
629 
630     /// @dev Re-invest whatever the goblin is working on.
631     function reinvest() external;
632 
633     /// @dev Return the amount of ETH wei to get back if we are to liquidate the position.
634     function health(uint256 id) external view returns (uint256);
635 
636     /// @dev Liquidate the given position to ETH. Send all ETH back to Bank.
637     function liquidate(uint256 id) external;
638 }
639 
640 // File: contracts/UniswapGoblin.sol
641 
642 pragma solidity 0.5.16;
643 
644 
645 
646 
647 
648 
649 
650 
651 
652 
653 
654 
655 contract UniswapGoblin is Ownable, ReentrancyGuard, Goblin {
656     /// @notice Libraries
657     using SafeToken for address;
658     using SafeMath for uint256;
659 
660     /// @notice Events
661     event Reinvest(address indexed caller, uint256 reward, uint256 bounty);
662     event AddShare(uint256 indexed id, uint256 share);
663     event RemoveShare(uint256 indexed id, uint256 share);
664     event Liquidate(uint256 indexed id, uint256 wad);
665 
666     /// @notice Immutable variables
667     IStakingRewards public staking;
668     IUniswapV2Factory public factory;
669     IUniswapV2Router02 public router;
670     IUniswapV2Pair public lpToken;
671     address public weth;
672     address public fToken;
673     address public uni;
674     address public operator;
675 
676     /// @notice Mutable state variables
677     mapping(uint256 => uint256) shares;
678     mapping(address => bool) okStrats;
679     uint256 public totalShare;
680     Strategy public addStrat;
681     Strategy public liqStrat;
682     uint256 public reinvestBountyBps;
683 
684     constructor(
685         address _operator,
686         IStakingRewards _staking,
687         IUniswapV2Router02 _router,
688         address _fToken,
689         address _uni,
690         Strategy _addStrat,
691         Strategy _liqStrat,
692         uint256 _reinvestBountyBps
693     ) public {
694         operator = _operator;
695         weth = _router.WETH();
696         staking = _staking;
697         router = _router;
698         factory = IUniswapV2Factory(_router.factory());
699         lpToken = IUniswapV2Pair(factory.getPair(weth, _fToken));
700         fToken = _fToken;
701         uni = _uni;
702         addStrat = _addStrat;
703         liqStrat = _liqStrat;
704         okStrats[address(addStrat)] = true;
705         okStrats[address(liqStrat)] = true;
706         reinvestBountyBps = _reinvestBountyBps;
707         lpToken.approve(address(_staking), uint256(-1)); // 100% trust in the staking pool
708         lpToken.approve(address(router), uint256(-1)); // 100% trust in the router
709         _fToken.safeApprove(address(router), uint256(-1)); // 100% trust in the router
710         _uni.safeApprove(address(router), uint256(-1)); // 100% trust in the router
711     }
712 
713     /// @dev Require that the caller must be an EOA account to avoid flash loans.
714     modifier onlyEOA() {
715         require(msg.sender == tx.origin, "not eoa");
716         _;
717     }
718 
719     /// @dev Require that the caller must be the operator (the bank).
720     modifier onlyOperator() {
721         require(msg.sender == operator, "not operator");
722         _;
723     }
724 
725     /// @dev Return the entitied LP token balance for the given shares.
726     /// @param share The number of shares to be converted to LP balance.
727     function shareToBalance(uint256 share) public view returns (uint256) {
728         if (totalShare == 0) return share; // When there's no share, 1 share = 1 balance.
729         uint256 totalBalance = staking.balanceOf(address(this));
730         return share.mul(totalBalance).div(totalShare);
731     }
732 
733     /// @dev Return the number of shares to receive if staking the given LP tokens.
734     /// @param balance the number of LP tokens to be converted to shares.
735     function balanceToShare(uint256 balance) public view returns (uint256) {
736         if (totalShare == 0) return balance; // When there's no share, 1 share = 1 balance.
737         uint256 totalBalance = staking.balanceOf(address(this));
738         return balance.mul(totalShare).div(totalBalance);
739     }
740 
741     /// @dev Re-invest whatever this worker has earned back to staked LP tokens.
742     function reinvest() public onlyEOA nonReentrant {
743         // 1. Withdraw all the rewards.
744         staking.getReward();
745         uint256 reward = uni.myBalance();
746         if (reward == 0) return;
747         // 2. Send the reward bounty to the caller.
748         uint256 bounty = reward.mul(reinvestBountyBps) / 10000;
749         uni.safeTransfer(msg.sender, bounty);
750         // 3. Convert all the remaining rewards to ETH.
751         address[] memory path = new address[](2);
752         path[0] = address(uni);
753         path[1] = address(weth);
754         router.swapExactTokensForETH(reward.sub(bounty), 0, path, address(this), now);
755         // 4. Use add ETH strategy to convert all ETH to LP tokens.
756         addStrat.execute.value(address(this).balance)(address(0), 0, abi.encode(fToken, 0));
757         // 5. Mint more LP tokens and stake them for more rewards.
758         staking.stake(lpToken.balanceOf(address(this)));
759         emit Reinvest(msg.sender, reward, bounty);
760     }
761 
762     /// @dev Work on the given position. Must be called by the operator.
763     /// @param id The position ID to work on.
764     /// @param user The original user that is interacting with the operator.
765     /// @param debt The amount of user debt to help the strategy make decisions.
766     /// @param data The encoded data, consisting of strategy address and calldata.
767     function work(uint256 id, address user, uint256 debt, bytes calldata data)
768         external payable
769         onlyOperator nonReentrant
770     {
771         // 1. Convert this position back to LP tokens.
772         _removeShare(id);
773         // 2. Perform the worker strategy; sending LP tokens + ETH; expecting LP tokens + ETH.
774         (address strat, bytes memory ext) = abi.decode(data, (address, bytes));
775         require(okStrats[strat], "unapproved work strategy");
776         lpToken.transfer(strat, lpToken.balanceOf(address(this)));
777         Strategy(strat).execute.value(msg.value)(user, debt, ext);
778         // 3. Add LP tokens back to the farming pool.
779         _addShare(id);
780         // 4. Return any remaining ETH back to the operator.
781         SafeToken.safeTransferETH(msg.sender, address(this).balance);
782     }
783 
784     /// @dev Return maximum output given the input amount and the status of Uniswap reserves.
785     /// @param aIn The amount of asset to market sell.
786     /// @param rIn the amount of asset in reserve for input.
787     /// @param rOut The amount of asset in reserve for output.
788     function getMktSellAmount(uint256 aIn, uint256 rIn, uint256 rOut) public pure returns (uint256) {
789         if (aIn == 0) return 0;
790         require(rIn > 0 && rOut > 0, "bad reserve values");
791         uint256 aInWithFee = aIn.mul(997);
792         uint256 numerator = aInWithFee.mul(rOut);
793         uint256 denominator = rIn.mul(1000).add(aInWithFee);
794         return numerator / denominator;
795     }
796 
797     /// @dev Return the amount of ETH to receive if we are to liquidate the given position.
798     /// @param id The position ID to perform health check.
799     function health(uint256 id) external view returns (uint256) {
800         // 1. Get the position's LP balance and LP total supply.
801         uint256 lpBalance = shareToBalance(shares[id]);
802         uint256 lpSupply = lpToken.totalSupply(); // Ignore pending mintFee as it is insignificant
803         // 2. Get the pool's total supply of WETH and farming token.
804         uint256 totalWETH = weth.balanceOf(address(lpToken));
805         uint256 totalfToken = fToken.balanceOf(address(lpToken));
806         // 3. Convert the position's LP tokens to the underlying assets.
807         uint256 userWETH = lpBalance.mul(totalWETH).div(lpSupply);
808         uint256 userfToken = lpBalance.mul(totalfToken).div(lpSupply);
809         // 4. Convert all farming tokens to ETH and return total ETH.
810         return getMktSellAmount(
811             userfToken, totalfToken.sub(userfToken), totalWETH.sub(userWETH)
812         ).add(userWETH);
813     }
814 
815     /// @dev Liquidate the given position by converting it to ETH and return back to caller.
816     /// @param id The position ID to perform liquidation
817     function liquidate(uint256 id) external onlyOperator nonReentrant {
818         // 1. Convert the position back to LP tokens and use liquidate strategy.
819         _removeShare(id);
820         lpToken.transfer(address(liqStrat), lpToken.balanceOf(address(this)));
821         liqStrat.execute(address(0), 0, abi.encode(fToken, 0));
822         // 2. Return all available ETH back to the operator.
823         uint256 wad = address(this).balance;
824         SafeToken.safeTransferETH(msg.sender, wad);
825         emit Liquidate(id, wad);
826     }
827 
828     /// @dev Internal function to stake all outstanding LP tokens to the given position ID.
829     function _addShare(uint256 id) internal {
830         uint256 balance = lpToken.balanceOf(address(this));
831         if (balance > 0) {
832             uint256 share = balanceToShare(balance);
833             staking.stake(balance);
834             shares[id] = shares[id].add(share);
835             totalShare = totalShare.add(share);
836             emit AddShare(id, share);
837         }
838     }
839 
840     /// @dev Internal function to remove shares of the ID and convert to outstanding LP tokens.
841     function _removeShare(uint256 id) internal {
842         uint256 share = shares[id];
843         if (share > 0) {
844             uint256 balance = shareToBalance(share);
845             staking.withdraw(balance);
846             totalShare = totalShare.sub(share);
847             shares[id] = 0;
848             emit RemoveShare(id, share);
849         }
850     }
851 
852     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
853     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
854     /// @param to The address to send the tokens to.
855     /// @param value The number of tokens to transfer to `to`.
856     function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {
857         token.safeTransfer(to, value);
858     }
859 
860     /// @dev Set the reward bounty for calling reinvest operations.
861     /// @param _reinvestBountyBps The bounty value to update.
862     function setReinvestBountyBps(uint256 _reinvestBountyBps) external onlyOwner {
863         reinvestBountyBps = _reinvestBountyBps;
864     }
865 
866     /// @dev Set the given strategies' approval status.
867     /// @param strats The strategy addresses.
868     /// @param isOk Whether to approve or unapprove the given strategies.
869     function setStrategyOk(address[] calldata strats, bool isOk) external onlyOwner {
870         uint256 len = strats.length;
871         for (uint256 idx = 0; idx < len; idx++) {
872             okStrats[strats[idx]] = isOk;
873         }
874     }
875 
876     /// @dev Update critical strategy smart contracts. EMERGENCY ONLY. Bad strategies can steal funds.
877     /// @param _addStrat The new add strategy contract.
878     /// @param _liqStrat The new liquidate strategy contract.
879     function setCriticalStrategies(Strategy _addStrat, Strategy _liqStrat) external onlyOwner {
880         addStrat = _addStrat;
881         liqStrat = _liqStrat;
882     }
883 
884     function() external payable {}
885 }