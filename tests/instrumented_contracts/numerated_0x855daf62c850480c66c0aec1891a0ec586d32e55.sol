1 pragma solidity ^0.8.17;
2 
3 interface IPancakeRouter01 {
4     function factory() external pure returns (address);
5     function WETH() external pure returns (address);
6 
7     function addLiquidity(
8         address tokenA,
9         address tokenB,
10         uint amountADesired,
11         uint amountToFsired,
12         uint amountAMin,
13         uint amountBMin,
14         address to,
15         uint deadline
16     ) external returns (uint amountA, uint amountB, uint liquidity);
17     function addLiquidityETH(
18         address token,
19         uint amountTokenDesired,
20         uint amountTokenMin,
21         uint amountETHMin,
22         address to,
23         uint deadline
24     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
25     function removeLiquidity(
26         address tokenA,
27         address tokenB,
28         uint liquidity,
29         uint amountAMin,
30         uint amountBMin,
31         address to,
32         uint deadline
33     ) external returns (uint amountA, uint amountB);
34     function removeLiquidityETH(
35         address token,
36         uint liquidity,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountToken, uint amountETH);
42     function removeLiquidityWithPermit(
43         address tokenA,
44         address tokenB,
45         uint liquidity,
46         uint amountAMin,
47         uint amountBMin,
48         address to,
49         uint deadline,
50         bool approveMax, uint8 v, bytes32 r, bytes32 s
51     ) external returns (uint amountA, uint amountB);
52     function removeLiquidityETHWithPermit(
53         address token,
54         uint liquidity,
55         uint amountTokenMin,
56         uint amountETHMin,
57         address to,
58         uint deadline,
59         bool approveMax, uint8 v, bytes32 r, bytes32 s
60     ) external returns (uint amountToken, uint amountETH);
61     function swapExactTokensForTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external returns (uint[] memory amounts);
68     function swapTokensForExactTokens(
69         uint amountOut,
70         uint amountInMax,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external returns (uint[] memory amounts);
75     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
76     external
77     payable
78     returns (uint[] memory amounts);
79     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
80     external
81     returns (uint[] memory amounts);
82     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
83     external
84     returns (uint[] memory amounts);
85     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
86     external
87     payable
88     returns (uint[] memory amounts);
89 
90     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
91     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
92     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
93     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
94     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
95 }
96 
97 interface IPancakeRouter02 is IPancakeRouter01 {
98     function removeLiquidityETHSupportingFeeOnTransferTokens(
99         address token,
100         uint liquidity,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external returns (uint amountETH);
106     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline,
113         bool approveMax, uint8 v, bytes32 r, bytes32 s
114     ) external returns (uint amountETH);
115 
116     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function swapExactETHForTokensSupportingFeeOnTransferTokens(
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external payable;
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 }
137 
138 interface IPancakeFactory {
139     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
140 
141     function feeTo() external view returns (address);
142     function feeToSetter() external view returns (address);
143 
144     function getPair(address tokenA, address tokenB) external view returns (address pair);
145     function allPairs(uint) external view returns (address pair);
146     function allPairsLength() external view returns (uint);
147 
148     function createPair(address tokenA, address tokenB) external returns (address pair);
149 
150     function setFeeTo(address) external;
151     function setFeeToSetter(address) external;
152 }
153 // File: Context.sol
154 
155 
156 
157 pragma solidity ^0.8.17;
158 
159 /**
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes calldata) {
175         return msg.data;
176     }
177 }
178 // File: Ownable.sol
179 
180 
181 
182 pragma solidity ^0.8.17;
183 
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * By default, the owner account will be the one that deploys the contract. This
191  * can later be changed with {transferOwnership}.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _transferOwnership(_msgSender());
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view virtual returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * @dev Leaves the contract without owner. It will not be possible to call
226      * `onlyOwner` functions anymore. Can only be called by the current owner.
227      *
228      * NOTE: Renouncing ownership will leave the contract without an owner,
229      * thereby removing any functionality that is only available to the owner.
230      */
231     function renounceOwnership() public virtual onlyOwner {
232         _transferOwnership(address(0));
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Can only be called by the current owner.
238      */
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(newOwner != address(0), "Ownable: new owner is the zero address");
241         _transferOwnership(newOwner);
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Internal function without access restriction.
247      */
248     function _transferOwnership(address newOwner) internal virtual {
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252     }
253 }
254 // File: IERC20.sol
255 
256 
257 
258 pragma solidity ^0.8.17;
259 
260 /**
261  * @dev Interface of the ERC20 standard as defined in the EIP.
262  */
263 interface IERC20 {
264     /**
265      * @dev Returns the amount of tokens in existence.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns the amount of tokens owned by `account`.
271      */
272     function balanceOf(address account) external view returns (uint256);
273 
274     /**
275      * @dev Moves `amount` tokens from the caller's account to `recipient`.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transfer(address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Returns the remaining number of tokens that `spender` will be
285      * allowed to spend on behalf of `owner` through {transferFrom}. This is
286      * zero by default.
287      *
288      * This value changes when {approve} or {transferFrom} are called.
289      */
290     function allowance(address owner, address spender) external view returns (uint256);
291 
292     /**
293      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * IMPORTANT: Beware that changing an allowance with this method brings the risk
298      * that someone may use both the old and the new allowance by unfortunate
299      * transaction ordering. One possible solution to mitigate this race
300      * condition is to first reduce the spender's allowance to 0 and set the
301      * desired value afterwards:
302      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303      *
304      * Emits an {Approval} event.
305      */
306     function approve(address spender, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Moves `amount` tokens from `sender` to `recipient` using the
310      * allowance mechanism. `amount` is then deducted from the caller's
311      * allowance.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Emitted when `value` tokens are moved from one account (`from`) to
321      * another (`to`).
322      *
323      * Note that `value` may be zero.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 value);
326 
327     /**
328      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
329      * a call to {approve}. `value` is the new allowance.
330      */
331     event Approval(address indexed owner, address indexed spender, uint256 value);
332 }
333 
334 /**
335  * @dev Interface for the optional metadata functions from the ERC20 standard.
336  *
337  * _Available since v4.1._
338  */
339 interface IERC20Metadata is IERC20 {
340     /**
341      * @dev Returns the name of the token.
342      */
343     function name() external view returns (string memory);
344 
345     /**
346      * @dev Returns the symbol of the token.
347      */
348     function symbol() external view returns (string memory);
349 
350     /**
351      * @dev Returns the decimals places of the token.
352      */
353     function decimals() external view returns (uint8);
354 }
355 // File: ReentrancyGuard.sol
356 
357 
358 
359 pragma solidity ^0.8.17;
360 
361 /**
362  * @dev Contract module that helps prevent reentrant calls to a function.
363  *
364  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
365  * available, which can be applied to functions to make sure there are no nested
366  * (reentrant) calls to them.
367  *
368  * Note that because there is a single `nonReentrant` guard, functions marked as
369  * `nonReentrant` may not call one another. This can be worked around by making
370  * those functions `private`, and then adding `external` `nonReentrant` entry
371  * points to them.
372  *
373  * TIP: If you would like to learn more about reentrancy and alternative ways
374  * to protect against it, check out our blog post
375  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
376  */
377 abstract contract ReentrancyGuard {
378     // Booleans are more expensive than uint256 or any type that takes up a full
379     // word because each write operation emits an extra SLOAD to first read the
380     // slot's contents, replace the bits taken up by the boolean, and then write
381     // back. This is the compiler's defense against contract upgrades and
382     // pointer aliasing, and it cannot be disabled.
383 
384     // The values being non-zero value makes deployment a bit more expensive,
385     // but in exchange the refund on every call to nonReentrant will be lower in
386     // amount. Since refunds are capped to a percentage of the total
387     // transaction's gas, it is best to keep them low in cases like this one, to
388     // increase the likelihood of the full refund coming into effect.
389     uint256 private constant _NOT_ENTERED = 1;
390     uint256 private constant _ENTERED = 2;
391 
392     uint256 private _status;
393 
394     constructor () {
395         _status = _NOT_ENTERED;
396     }
397 
398     /**
399      * @dev Prevents a contract from calling itself, directly or indirectly.
400      * Calling a `nonReentrant` function from another `nonReentrant`
401      * function is not supported. It is possible to prevent this from happening
402      * by making the `nonReentrant` function external, and make it call a
403      * `private` function that does the actual work.
404      */
405     modifier nonReentrant() {
406         // On the first call to nonReentrant, _notEntered will be true
407         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
408 
409         // Any calls to nonReentrant after this point will fail
410         _status = _ENTERED;
411 
412         _;
413 
414         // By storing the original value once again, a refund is triggered (see
415         // https://eips.ethereum.org/EIPS/eip-2200)
416         _status = _NOT_ENTERED;
417     }
418 
419     modifier isHuman() {
420         require(tx.origin == msg.sender, "Humans only");
421         _;
422     }
423 }
424 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
425 
426 
427 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
428 
429 pragma solidity ^0.8.15;
430 
431 // CAUTION
432 // This version of SafeMath should only be used with Solidity 0.8 or later,
433 // because it relies on the compiler's built in overflow checks.
434 
435 /**
436  * @dev Wrappers over Solidity's arithmetic operations.
437  *
438  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
439  * now has built in overflow checking.
440  */
441 library SafeMath {
442     /**
443      * @dev Returns the addition of two unsigned integers, with an overflow flag.
444      *
445      * _Available since v3.4._
446      */
447     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
448         unchecked {
449             uint256 c = a + b;
450             if (c < a) return (false, 0);
451             return (true, c);
452         }
453     }
454 
455     /**
456      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
457      *
458      * _Available since v3.4._
459      */
460     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
461         unchecked {
462             if (b > a) return (false, 0);
463             return (true, a - b);
464         }
465     }
466 
467     /**
468      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
469      *
470      * _Available since v3.4._
471      */
472     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
473         unchecked {
474             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
475             // benefit is lost if 'b' is also tested.
476             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
477             if (a == 0) return (true, 0);
478             uint256 c = a * b;
479             if (c / a != b) return (false, 0);
480             return (true, c);
481         }
482     }
483 
484     /**
485      * @dev Returns the division of two unsigned integers, with a division by zero flag.
486      *
487      * _Available since v3.4._
488      */
489     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
490         unchecked {
491             if (b == 0) return (false, 0);
492             return (true, a / b);
493         }
494     }
495 
496     /**
497      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
498      *
499      * _Available since v3.4._
500      */
501     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
502         unchecked {
503             if (b == 0) return (false, 0);
504             return (true, a % b);
505         }
506     }
507 
508     /**
509      * @dev Returns the addition of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `+` operator.
513      *
514      * Requirements:
515      *
516      * - Addition cannot overflow.
517      */
518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
519         return a + b;
520     }
521 
522     /**
523      * @dev Returns the subtraction of two unsigned integers, reverting on
524      * overflow (when the result is negative).
525      *
526      * Counterpart to Solidity's `-` operator.
527      *
528      * Requirements:
529      *
530      * - Subtraction cannot overflow.
531      */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a - b;
534     }
535 
536     /**
537      * @dev Returns the multiplication of two unsigned integers, reverting on
538      * overflow.
539      *
540      * Counterpart to Solidity's `*` operator.
541      *
542      * Requirements:
543      *
544      * - Multiplication cannot overflow.
545      */
546     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
547         return a * b;
548     }
549 
550     /**
551      * @dev Returns the integer division of two unsigned integers, reverting on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator.
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b) internal pure returns (uint256) {
561         return a / b;
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * reverting when dividing by zero.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
577         return a % b;
578     }
579 
580     /**
581      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
582      * overflow (when the result is negative).
583      *
584      * CAUTION: This function is deprecated because it requires allocating memory for the error
585      * message unnecessarily. For custom revert reasons use {trySub}.
586      *
587      * Counterpart to Solidity's `-` operator.
588      *
589      * Requirements:
590      *
591      * - Subtraction cannot overflow.
592      */
593     function sub(
594         uint256 a,
595         uint256 b,
596         string memory errorMessage
597     ) internal pure returns (uint256) {
598         unchecked {
599             require(b <= a, errorMessage);
600             return a - b;
601         }
602     }
603 
604     /**
605      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
606      * division by zero. The result is rounded towards zero.
607      *
608      * Counterpart to Solidity's `/` operator. Note: this function uses a
609      * `revert` opcode (which leaves remaining gas untouched) while Solidity
610      * uses an invalid opcode to revert (consuming all remaining gas).
611      *
612      * Requirements:
613      *
614      * - The divisor cannot be zero.
615      */
616     function div(
617         uint256 a,
618         uint256 b,
619         string memory errorMessage
620     ) internal pure returns (uint256) {
621         unchecked {
622             require(b > 0, errorMessage);
623             return a / b;
624         }
625     }
626 
627     /**
628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
629      * reverting with custom message when dividing by zero.
630      *
631      * CAUTION: This function is deprecated because it requires allocating memory for the error
632      * message unnecessarily. For custom revert reasons use {tryMod}.
633      *
634      * Counterpart to Solidity's `%` operator. This function uses a `revert`
635      * opcode (which leaves remaining gas untouched) while Solidity uses an
636      * invalid opcode to revert (consuming all remaining gas).
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function mod(
643         uint256 a,
644         uint256 b,
645         string memory errorMessage
646     ) internal pure returns (uint256) {
647         unchecked {
648             require(b > 0, errorMessage);
649             return a % b;
650         }
651     }
652 }
653 
654 // File: ToFStake.sol
655 
656 //SPDX-License-Identifier: MIT
657 
658 pragma solidity ^0.8.17;
659 
660 contract ToFStake is Ownable, ReentrancyGuard {
661     using SafeMath for uint256;
662 
663     uint256 public DECIMALS = 9;   
664     IPancakeRouter02 internal _router;
665     
666     IERC20 public ToF; //address of the token
667     uint256 public poolFee = 3; // % fee deducted from, deposits, withdrawals
668     uint256 public earlyWithdrawFee = 25;
669     uint256 public earlyWithdrawFeeTime = 7 days;
670 
671     address public feeAddress = 0x431c71594CAE3a8935AFCf2133D294e37b84e6F2; // ToF Token Rhllor Contract Address
672 
673     struct userStakeProfile {
674         uint256 stakedAmount;
675         uint256 claimedAmount;
676         uint256 lastBlockCompounded;
677         uint256 lastBlockStaked;
678     }
679     
680     mapping (address => userStakeProfile) public stakings;
681     uint256 public ETHPerBlock;
682     uint256 public totalUsers;
683     uint256 public totalStaked;
684     uint256 public totalClaimed;
685   
686     event StakeUpdated (address indexed recipeint, uint256 indexed _amount);
687     
688     constructor () {        
689         setRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 Router
690         ToF = IERC20(0x90E2Fa98DfC518317600Dd3DC571DE8D071a7238); //ToF Token Rhllor Contract Address
691         setETHPerBlock(40000000000000); // 40000000000000 | Set ETH per block to 0.00004 ETH. ~6646 blocks in 24h. 0.00004 x 6646 = 0.26584 ETH 
692     }
693 
694     function setRouter(address routerAddress) public onlyOwner {
695 		require(routerAddress != address(0), "Cannot use the zero address as router address");
696 		_router = IPancakeRouter02(routerAddress);
697 	}
698 
699     function totalPoolReserve() public view returns(uint256){
700         return address(this).balance;
701     }
702 
703     function swapETHForTokens(address to, address token, uint256 ETHAmount) internal returns(bool) { 
704 		// Generate pair for WETH -> Future
705 		address[] memory path = new address[](2);
706 		path[0] = _router.WETH();
707 		path[1] = token;
708         
709 		// Swap and send the tokens to the 'to' address
710 		try _router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ETHAmount }(0, path, to, block.timestamp + 360) { 
711 			return true;
712 		} 
713 		catch { 
714 			return false;
715 		}
716 	}
717 
718     // Set reward amount per block
719     function setETHPerBlock (uint256 _amount) public onlyOwner {
720         require(_amount >= 0, "ToF per Block can not be negative" );
721         ETHPerBlock = _amount;
722     }
723 
724     /// Stake the provided amount
725     function enterStaking (uint256 _amount) public isHuman {
726         require(ToF.balanceOf(msg.sender) >= _amount, "Insufficient ToF tokens for transfer");
727         require(_amount > 0,"Invalid staking amount");
728         require(totalPoolReserve() > 0, "Reward Pool Exhausted");
729         
730         ToF.transferFrom(msg.sender, address(this), _amount);
731         _amount = takeToFPoolFee(_amount);
732 
733         userStakeProfile memory profile = stakings[msg.sender];
734 
735         if(profile.stakedAmount == 0){
736             profile.lastBlockCompounded = block.number;
737             totalUsers++;
738         }
739             profile.stakedAmount += _amount;
740             profile.lastBlockStaked = block.number;
741 
742             totalStaked += _amount;
743         
744         stakings[msg.sender] = profile; 
745     }
746 
747     //leaves staking 
748     function leaveStaking (uint256 _amount) public isHuman {
749         userStakeProfile memory profile = stakings[msg.sender];
750         require(profile.stakedAmount >= _amount, "Withdraw amount can not be greater than stake");
751 
752         totalStaked -= _amount;
753         profile.stakedAmount -= _amount;
754         stakings[msg.sender] = profile;
755 
756         // claim pending reward
757             if(getReward(msg.sender) > 0){
758                 claim();   
759             }
760             
761         if(block.number < stakings[msg.sender].lastBlockStaked.add(earlyWithdrawFeeTime)){
762             uint256 withdrawalFee = _amount * earlyWithdrawFee / 100;
763             _amount -= withdrawalFee;
764             ToF.transfer(feeAddress, withdrawalFee);
765         }else{
766             _amount = takeToFPoolFee(_amount);
767         }
768 
769         profile.lastBlockCompounded = block.number;
770         ToF.transfer(msg.sender, _amount);
771 
772         //remove
773         if(stakings[msg.sender].stakedAmount == 0){
774             totalUsers--;
775             delete stakings[msg.sender];
776         }
777     }
778     
779     // gets reward amount from a user
780     function getReward(address _address) internal view returns (uint256) {
781 
782         if(block.number <= stakings[_address].lastBlockCompounded){
783             return 0;
784         }else {
785             uint256 totalPool = totalPoolReserve();
786             if(totalPool == 0 || totalStaked == 0 ){
787                 return 0;
788             }else {    
789 
790                 uint256 blocks = block.number.sub(stakings[_address].lastBlockCompounded);
791                 //if the staker reward is greater than total pool => set it to total pool
792                 uint256 totalReward = blocks.mul(ETHPerBlock);
793                 uint256 stakerReward = totalReward.mul(stakings[_address].stakedAmount).div(totalStaked);
794                 if(stakerReward > totalPool){
795                     stakerReward = totalPool;
796                 }
797                 return stakerReward;
798             }
799             
800         }
801     }
802 
803     /// Get pending rewards of a user to display on DAPP, even if farming is disabled it shows remaining balance
804     function pendingReward (address _address) public view returns (uint256){
805         return getReward(_address);
806     }
807 
808     /// transfers the rewards of a user to their address
809     function claim() public isHuman{
810 
811         uint256 reward = getReward(msg.sender);
812         (bool os, ) = payable(msg.sender).call{value: reward}("");
813         require(os,"failed claim");
814         stakings[msg.sender].claimedAmount = stakings[msg.sender].claimedAmount.add(reward);
815         stakings[msg.sender].lastBlockCompounded = block.number;
816         totalClaimed = totalClaimed.add(reward);
817     }
818 
819      /// compounds the rewards of the caller, buys more ToF and stakes that
820     function singleCompound() public isHuman {
821         require(stakings[msg.sender].stakedAmount > 0, "Please Stake ToF to compound");
822         
823         uint256 reward = getReward(msg.sender);
824         reward = takeETHPoolFee(reward); 
825 
826         // swap reward to extra tokens and log
827    	    uint256 initialBalance = ToF.balanceOf(address(this));
828         require(swapETHForTokens(address(this), address(ToF), reward),"swapping failed");
829         uint256 addedBalance = ToF.balanceOf(address(this)) - initialBalance;
830 
831         // add extra tokens
832         stakings[msg.sender].stakedAmount += addedBalance; 
833         totalStaked += addedBalance;
834         stakings[msg.sender].lastBlockCompounded = block.number;
835         totalClaimed = totalClaimed.add(reward);
836 
837         emit StakeUpdated(msg.sender,reward);
838     }
839 
840     // update ecosystem wallet to Token of Fires contract address
841     function updatefeeAddress(address wallet) public onlyOwner{
842         feeAddress = wallet;
843     }
844 
845     // update pool fee
846     function updatePoolFee(uint256 _amount) public onlyOwner{
847        poolFee = _amount;
848     }
849     
850     // remove ETH from totalpool in case of emergency/migration
851     function migratePool() public payable onlyOwner {
852         (bool os, ) = payable(msg.sender).call{value: totalPoolReserve()}("");
853         require(os);
854     }
855 
856     // Remove ETH from vault for marketing/buybacks etc
857     function withdrawEth(uint256 _amount) public payable onlyOwner {
858         require(_amount <  totalPoolReserve(), "Cannot withdraw more ETH than in the pool");
859         (bool os, ) = payable(msg.sender).call{value: _amount}("");
860         require(os);
861     }
862 
863     // sends ETH fee and returns remaining reward for user
864     function takeETHPoolFee(uint256 reward) internal view returns(uint256){
865         uint256 Fee = reward / 100 * poolFee; // take fee 
866         reward -= Fee;
867 		feeAddress.call{value:Fee};
868         return reward;
869     }
870 
871     // sends ToF fee and burns a portion of it
872     function takeToFPoolFee(uint256 reward) internal returns(uint256){
873 
874         uint256 Fee = reward / 100 * poolFee; // take fee 
875         reward -= Fee;
876         ToF.transfer(feeAddress,Fee);
877 
878         return reward;
879     }
880 
881     function returnStakeData() public view returns (bytes memory) {
882         return abi.encode(ToF.balanceOf(msg.sender), stakings[msg.sender].stakedAmount, pendingReward(msg.sender), totalPoolReserve(), totalUsers, totalClaimed, totalStaked,ETHPerBlock);
883     }
884 
885     // Ensures that the contract is able to receive ETH and adds it to the total pool
886     receive() external payable {}
887 }