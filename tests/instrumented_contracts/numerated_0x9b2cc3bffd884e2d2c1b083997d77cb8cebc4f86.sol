1 // File: IPancakeRouterV2.sol
2 
3 
4 
5 pragma solidity 0.8.5;
6 
7 interface IPancakeRouter01 {
8     function factory() external pure returns (address);
9     function WETH() external pure returns (address);
10 
11     function addLiquidity(
12         address tokenA,
13         address tokenB,
14         uint amountADesired,
15         uint amountBDesired,
16         uint amountAMin,
17         uint amountBMin,
18         address to,
19         uint deadline
20     ) external returns (uint amountA, uint amountB, uint liquidity);
21     function addLiquidityETH(
22         address token,
23         uint amountTokenDesired,
24         uint amountTokenMin,
25         uint amountETHMin,
26         address to,
27         uint deadline
28     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
29     function removeLiquidity(
30         address tokenA,
31         address tokenB,
32         uint liquidity,
33         uint amountAMin,
34         uint amountBMin,
35         address to,
36         uint deadline
37     ) external returns (uint amountA, uint amountB);
38     function removeLiquidityETH(
39         address token,
40         uint liquidity,
41         uint amountTokenMin,
42         uint amountETHMin,
43         address to,
44         uint deadline
45     ) external returns (uint amountToken, uint amountETH);
46     function removeLiquidityWithPermit(
47         address tokenA,
48         address tokenB,
49         uint liquidity,
50         uint amountAMin,
51         uint amountBMin,
52         address to,
53         uint deadline,
54         bool approveMax, uint8 v, bytes32 r, bytes32 s
55     ) external returns (uint amountA, uint amountB);
56     function removeLiquidityETHWithPermit(
57         address token,
58         uint liquidity,
59         uint amountTokenMin,
60         uint amountETHMin,
61         address to,
62         uint deadline,
63         bool approveMax, uint8 v, bytes32 r, bytes32 s
64     ) external returns (uint amountToken, uint amountETH);
65     function swapExactTokensForTokens(
66         uint amountIn,
67         uint amountOutMin,
68         address[] calldata path,
69         address to,
70         uint deadline
71     ) external returns (uint[] memory amounts);
72     function swapTokensForExactTokens(
73         uint amountOut,
74         uint amountInMax,
75         address[] calldata path,
76         address to,
77         uint deadline
78     ) external returns (uint[] memory amounts);
79     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
80     external
81     payable
82     returns (uint[] memory amounts);
83     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
84     external
85     returns (uint[] memory amounts);
86     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
87     external
88     returns (uint[] memory amounts);
89     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
90     external
91     payable
92     returns (uint[] memory amounts);
93 
94     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
95     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
96     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
97     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
98     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
99 }
100 
101 interface IPancakeRouter02 is IPancakeRouter01 {
102     function removeLiquidityETHSupportingFeeOnTransferTokens(
103         address token,
104         uint liquidity,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external returns (uint amountETH);
110     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
111         address token,
112         uint liquidity,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline,
117         bool approveMax, uint8 v, bytes32 r, bytes32 s
118     ) external returns (uint amountETH);
119 
120     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function swapExactETHForTokensSupportingFeeOnTransferTokens(
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external payable;
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140 }
141 
142 interface IPancakeFactory {
143     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
144 
145     function feeTo() external view returns (address);
146     function feeToSetter() external view returns (address);
147 
148     function getPair(address tokenA, address tokenB) external view returns (address pair);
149     function allPairs(uint) external view returns (address pair);
150     function allPairsLength() external view returns (uint);
151 
152     function createPair(address tokenA, address tokenB) external returns (address pair);
153 
154     function setFeeTo(address) external;
155     function setFeeToSetter(address) external;
156 }
157 // File: Context.sol
158 
159 
160 
161 pragma solidity >= 0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 // File: Ownable.sol
183 
184 
185 
186 pragma solidity >= 0.8.0;
187 
188 
189 /**
190  * @dev Contract module which provides a basic access control mechanism, where
191  * there is an account (an owner) that can be granted exclusive access to
192  * specific functions.
193  *
194  * By default, the owner account will be the one that deploys the contract. This
195  * can later be changed with {transferOwnership}.
196  *
197  * This module is used through inheritance. It will make available the modifier
198  * `onlyOwner`, which can be applied to your functions to restrict their use to
199  * the owner.
200  */
201 abstract contract Ownable is Context {
202     address private _owner;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206     /**
207      * @dev Initializes the contract setting the deployer as the initial owner.
208      */
209     constructor() {
210         _transferOwnership(_msgSender());
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 // File: IERC20.sol
259 
260 
261 
262 pragma solidity >= 0.8.0;
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP.
266  */
267 interface IERC20 {
268     /**
269      * @dev Returns the amount of tokens in existence.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns the amount of tokens owned by `account`.
275      */
276     function balanceOf(address account) external view returns (uint256);
277 
278     /**
279      * @dev Moves `amount` tokens from the caller's account to `recipient`.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transfer(address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Returns the remaining number of tokens that `spender` will be
289      * allowed to spend on behalf of `owner` through {transferFrom}. This is
290      * zero by default.
291      *
292      * This value changes when {approve} or {transferFrom} are called.
293      */
294     function allowance(address owner, address spender) external view returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `sender` to `recipient` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Emitted when `value` tokens are moved from one account (`from`) to
325      * another (`to`).
326      *
327      * Note that `value` may be zero.
328      */
329     event Transfer(address indexed from, address indexed to, uint256 value);
330 
331     /**
332      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
333      * a call to {approve}. `value` is the new allowance.
334      */
335     event Approval(address indexed owner, address indexed spender, uint256 value);
336 }
337 
338 /**
339  * @dev Interface for the optional metadata functions from the ERC20 standard.
340  *
341  * _Available since v4.1._
342  */
343 interface IERC20Metadata is IERC20 {
344     /**
345      * @dev Returns the name of the token.
346      */
347     function name() external view returns (string memory);
348 
349     /**
350      * @dev Returns the symbol of the token.
351      */
352     function symbol() external view returns (string memory);
353 
354     /**
355      * @dev Returns the decimals places of the token.
356      */
357     function decimals() external view returns (uint8);
358 }
359 // File: ReentrancyGuard.sol
360 
361 
362 
363 pragma solidity >= 0.8.0;
364 
365 /**
366  * @dev Contract module that helps prevent reentrant calls to a function.
367  *
368  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
369  * available, which can be applied to functions to make sure there are no nested
370  * (reentrant) calls to them.
371  *
372  * Note that because there is a single `nonReentrant` guard, functions marked as
373  * `nonReentrant` may not call one another. This can be worked around by making
374  * those functions `private`, and then adding `external` `nonReentrant` entry
375  * points to them.
376  *
377  * TIP: If you would like to learn more about reentrancy and alternative ways
378  * to protect against it, check out our blog post
379  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
380  */
381 abstract contract ReentrancyGuard {
382     // Booleans are more expensive than uint256 or any type that takes up a full
383     // word because each write operation emits an extra SLOAD to first read the
384     // slot's contents, replace the bits taken up by the boolean, and then write
385     // back. This is the compiler's defense against contract upgrades and
386     // pointer aliasing, and it cannot be disabled.
387 
388     // The values being non-zero value makes deployment a bit more expensive,
389     // but in exchange the refund on every call to nonReentrant will be lower in
390     // amount. Since refunds are capped to a percentage of the total
391     // transaction's gas, it is best to keep them low in cases like this one, to
392     // increase the likelihood of the full refund coming into effect.
393     uint256 private constant _NOT_ENTERED = 1;
394     uint256 private constant _ENTERED = 2;
395 
396     uint256 private _status;
397 
398     constructor () {
399         _status = _NOT_ENTERED;
400     }
401 
402     /**
403      * @dev Prevents a contract from calling itself, directly or indirectly.
404      * Calling a `nonReentrant` function from another `nonReentrant`
405      * function is not supported. It is possible to prevent this from happening
406      * by making the `nonReentrant` function external, and make it call a
407      * `private` function that does the actual work.
408      */
409     modifier nonReentrant() {
410         // On the first call to nonReentrant, _notEntered will be true
411         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
412 
413         // Any calls to nonReentrant after this point will fail
414         _status = _ENTERED;
415 
416         _;
417 
418         // By storing the original value once again, a refund is triggered (see
419         // https://eips.ethereum.org/EIPS/eip-2200)
420         _status = _NOT_ENTERED;
421     }
422 
423     modifier isHuman() {
424         require(tx.origin == msg.sender, "Humans only");
425         _;
426     }
427 }
428 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
429 
430 
431 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 // CAUTION
436 // This version of SafeMath should only be used with Solidity 0.8 or later,
437 // because it relies on the compiler's built in overflow checks.
438 
439 /**
440  * @dev Wrappers over Solidity's arithmetic operations.
441  *
442  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
443  * now has built in overflow checking.
444  */
445 library SafeMath {
446     /**
447      * @dev Returns the addition of two unsigned integers, with an overflow flag.
448      *
449      * _Available since v3.4._
450      */
451     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
452         unchecked {
453             uint256 c = a + b;
454             if (c < a) return (false, 0);
455             return (true, c);
456         }
457     }
458 
459     /**
460      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
461      *
462      * _Available since v3.4._
463      */
464     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
465         unchecked {
466             if (b > a) return (false, 0);
467             return (true, a - b);
468         }
469     }
470 
471     /**
472      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
473      *
474      * _Available since v3.4._
475      */
476     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
477         unchecked {
478             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
479             // benefit is lost if 'b' is also tested.
480             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
481             if (a == 0) return (true, 0);
482             uint256 c = a * b;
483             if (c / a != b) return (false, 0);
484             return (true, c);
485         }
486     }
487 
488     /**
489      * @dev Returns the division of two unsigned integers, with a division by zero flag.
490      *
491      * _Available since v3.4._
492      */
493     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
494         unchecked {
495             if (b == 0) return (false, 0);
496             return (true, a / b);
497         }
498     }
499 
500     /**
501      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
502      *
503      * _Available since v3.4._
504      */
505     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
506         unchecked {
507             if (b == 0) return (false, 0);
508             return (true, a % b);
509         }
510     }
511 
512     /**
513      * @dev Returns the addition of two unsigned integers, reverting on
514      * overflow.
515      *
516      * Counterpart to Solidity's `+` operator.
517      *
518      * Requirements:
519      *
520      * - Addition cannot overflow.
521      */
522     function add(uint256 a, uint256 b) internal pure returns (uint256) {
523         return a + b;
524     }
525 
526     /**
527      * @dev Returns the subtraction of two unsigned integers, reverting on
528      * overflow (when the result is negative).
529      *
530      * Counterpart to Solidity's `-` operator.
531      *
532      * Requirements:
533      *
534      * - Subtraction cannot overflow.
535      */
536     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
537         return a - b;
538     }
539 
540     /**
541      * @dev Returns the multiplication of two unsigned integers, reverting on
542      * overflow.
543      *
544      * Counterpart to Solidity's `*` operator.
545      *
546      * Requirements:
547      *
548      * - Multiplication cannot overflow.
549      */
550     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
551         return a * b;
552     }
553 
554     /**
555      * @dev Returns the integer division of two unsigned integers, reverting on
556      * division by zero. The result is rounded towards zero.
557      *
558      * Counterpart to Solidity's `/` operator.
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b) internal pure returns (uint256) {
565         return a / b;
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * reverting when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return a % b;
582     }
583 
584     /**
585      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
586      * overflow (when the result is negative).
587      *
588      * CAUTION: This function is deprecated because it requires allocating memory for the error
589      * message unnecessarily. For custom revert reasons use {trySub}.
590      *
591      * Counterpart to Solidity's `-` operator.
592      *
593      * Requirements:
594      *
595      * - Subtraction cannot overflow.
596      */
597     function sub(
598         uint256 a,
599         uint256 b,
600         string memory errorMessage
601     ) internal pure returns (uint256) {
602         unchecked {
603             require(b <= a, errorMessage);
604             return a - b;
605         }
606     }
607 
608     /**
609      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
610      * division by zero. The result is rounded towards zero.
611      *
612      * Counterpart to Solidity's `/` operator. Note: this function uses a
613      * `revert` opcode (which leaves remaining gas untouched) while Solidity
614      * uses an invalid opcode to revert (consuming all remaining gas).
615      *
616      * Requirements:
617      *
618      * - The divisor cannot be zero.
619      */
620     function div(
621         uint256 a,
622         uint256 b,
623         string memory errorMessage
624     ) internal pure returns (uint256) {
625         unchecked {
626             require(b > 0, errorMessage);
627             return a / b;
628         }
629     }
630 
631     /**
632      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
633      * reverting with custom message when dividing by zero.
634      *
635      * CAUTION: This function is deprecated because it requires allocating memory for the error
636      * message unnecessarily. For custom revert reasons use {tryMod}.
637      *
638      * Counterpart to Solidity's `%` operator. This function uses a `revert`
639      * opcode (which leaves remaining gas untouched) while Solidity uses an
640      * invalid opcode to revert (consuming all remaining gas).
641      *
642      * Requirements:
643      *
644      * - The divisor cannot be zero.
645      */
646     function mod(
647         uint256 a,
648         uint256 b,
649         string memory errorMessage
650     ) internal pure returns (uint256) {
651         unchecked {
652             require(b > 0, errorMessage);
653             return a % b;
654         }
655     }
656 }
657 
658 // File: HULKStake.sol
659 
660 //SPDX-License-Identifier: MIT
661 
662 pragma solidity >= 0.8.0;
663 
664 
665 
666 
667 
668 
669 contract HULKStake is Ownable, ReentrancyGuard {
670     using SafeMath for uint256;
671 
672     uint256 public DECIMALS = 18;   
673     IPancakeRouter02 internal _router;
674     //address of the token
675     IERC20 public HULK;
676     uint256 poolFee = 3; // fee deducted from, deposits, withdrawals
677     uint256 public earlyWithdrawFee = 10;
678     uint256 public earlyWithdrawFeeTime = 3 days;
679 
680     address public devWallet = 0x2E8c54dE18F9f12caab6C0Ddf82b4711F591b6C2;
681 
682     struct userStakeProfile {
683         uint256 stakedAmount;
684         uint256 claimedAmount;
685         uint256 lastBlockCompounded;
686         uint256 lastBlockStaked;
687     }
688     
689     mapping (address => userStakeProfile) public stakings;
690     uint256 public ETHPerBlock;
691     uint256 public totalUsers;
692     uint256 public totalStaked;
693     uint256 public totalClaimed;
694   
695     event StakeUpdated (address indexed recipeint, uint256 indexed _amount);
696     
697     constructor () {
698         
699         setRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
700         HULK = IERC20(0x91a5de30e57831529a3c1aF636A78a7E4E83f3aa);
701         setETHPerBlock(40000000000000); // set ETH per block to 0.00004 ETH. ~6646 blocks in 24h. 0.00004 x 6646 = 0.26584 ETH 
702           
703     }
704 
705     function setRouter(address routerAddress) public onlyOwner {
706 		require(routerAddress != address(0), "Cannot use the zero address as router address");
707 		_router = IPancakeRouter02(routerAddress);
708 	}
709 
710     function totalPoolReserve() public view returns(uint256){
711         return address(this).balance;
712     }
713 
714     	function swapETHForTokens(address to, address token, uint256 ETHAmount) internal returns(bool) { 
715 		// Generate pair for WETH -> Future
716 		address[] memory path = new address[](2);
717 		path[0] = _router.WETH();
718 		path[1] = token;
719         
720 		// Swap and send the tokens to the 'to' address
721 		try _router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ETHAmount }(0, path, to, block.timestamp + 360) { 
722 			return true;
723 		} 
724 		catch { 
725 			return false;
726 		}
727 	}
728 
729     // Set reward amount per block
730     function setETHPerBlock (uint256 _amount) public onlyOwner {
731         require(_amount >= 0, "HULK per Block can not be negative" );
732         ETHPerBlock = _amount;
733     }
734 
735     /// Stake the provided amount
736     function enterStaking (uint256 _amount) public isHuman {
737         require(HULK.balanceOf(msg.sender) >= _amount, "Insufficient HULK tokens for transfer");
738         require(_amount > 0,"Invalid staking amount");
739         require(totalPoolReserve() > 0, "Reward Pool Exhausted");
740         
741         HULK.transferFrom(msg.sender, address(this), _amount);
742         _amount = takeHULKPoolFee(_amount);
743 
744         userStakeProfile memory profile = stakings[msg.sender];
745 
746         if(profile.stakedAmount == 0){
747             profile.lastBlockCompounded = block.number;
748             totalUsers++;
749         }
750             profile.stakedAmount += _amount;
751             profile.lastBlockStaked = block.number;
752 
753             totalStaked += _amount;
754         
755         stakings[msg.sender] = profile; 
756     }
757 
758     //leaves staking 
759     function leaveStaking (uint256 _amount) public isHuman {
760         userStakeProfile memory profile = stakings[msg.sender];
761         require(profile.stakedAmount >= _amount, "Withdraw amount can not be greater than stake");
762 
763         totalStaked -= _amount;
764         profile.stakedAmount -= _amount;
765         stakings[msg.sender] = profile;
766 
767         // claim pending reward
768             if(getReward(msg.sender) > 0){
769                 claim();   
770             }
771             
772         if(block.number < stakings[msg.sender].lastBlockStaked.add(earlyWithdrawFeeTime)){
773             uint256 withdrawalFee = _amount * earlyWithdrawFee / 100;
774             _amount -= withdrawalFee;
775             HULK.transfer(devWallet, withdrawalFee);
776         }else{
777             _amount = takeHULKPoolFee(_amount);
778         }
779 
780         profile.lastBlockCompounded = block.number;
781         HULK.transfer(msg.sender, _amount);
782 
783         //remove
784         if(stakings[msg.sender].stakedAmount == 0){
785             totalUsers--;
786             delete stakings[msg.sender];
787         }
788     }
789     
790     // gets reward amount from a user
791     function getReward(address _address) internal view returns (uint256) {
792 
793         if(block.number <= stakings[_address].lastBlockCompounded){
794             return 0;
795         }else {
796             uint256 totalPool = totalPoolReserve();
797             if(totalPool == 0 || totalStaked == 0 ){
798                 return 0;
799             }else {    
800 
801                 uint256 blocks = block.number.sub(stakings[_address].lastBlockCompounded);
802                 //if the staker reward is greater than total pool => set it to total pool
803                 uint256 totalReward = blocks.mul(ETHPerBlock);
804                 uint256 stakerReward = totalReward.mul(stakings[_address].stakedAmount).div(totalStaked);
805                 if(stakerReward > totalPool){
806                     stakerReward = totalPool;
807                 }
808                 return stakerReward;
809             }
810             
811         }
812     }
813 
814     /// Get pending rewards of a user to display on DAPP, even if farming is disabled it shows remaining balance
815     function pendingReward (address _address) public view returns (uint256){
816         return getReward(_address);
817     }
818 
819     /// transfers the rewards of a user to their address
820     function claim() public isHuman{
821 
822         uint256 reward = getReward(msg.sender);
823         (bool os, ) = payable(msg.sender).call{value: reward}("");
824         require(os,"failed claim");
825         stakings[msg.sender].claimedAmount = stakings[msg.sender].claimedAmount.add(reward);
826         stakings[msg.sender].lastBlockCompounded = block.number;
827         totalClaimed = totalClaimed.add(reward);
828     }
829 
830      /// compounds the rewards of the caller, buys more HULK and stakes that
831     function singleCompound() public isHuman {
832         require(stakings[msg.sender].stakedAmount > 0, "Please Stake HULK to compound");
833         
834         uint256 reward = getReward(msg.sender);
835         reward = takeETHPoolFee(reward); 
836 
837         // swap reward to extra tokens and log
838    	    uint256 initialBalance = HULK.balanceOf(address(this));
839         require(swapETHForTokens(address(this), address(HULK), reward),"swapping failed");
840         uint256 addedBalance = HULK.balanceOf(address(this)) - initialBalance;
841 
842         // add extra tokens
843         stakings[msg.sender].stakedAmount += addedBalance; 
844         totalStaked += addedBalance;
845         stakings[msg.sender].lastBlockCompounded = block.number;
846         totalClaimed = totalClaimed.add(reward);
847 
848         emit StakeUpdated(msg.sender,reward);
849     }
850 
851     // update ecosystem wallet
852     function updatedevWallet(address wallet) public onlyOwner{
853         devWallet = wallet;
854     }
855 
856     // update pool fee
857     function updatePoolFee(uint256 _amount) public onlyOwner{
858        poolFee = _amount;
859     }
860     
861     // remove ETH from totalpool in case of emergency/migration
862     function migratePool() public payable onlyOwner {
863         (bool os, ) = payable(devWallet).call{value: totalPoolReserve()}("");
864         require(os);
865     }
866 
867     // sends ETH fee and returns remaining reward for user
868     function takeETHPoolFee(uint256 reward) internal view returns(uint256){
869         uint256 Fee = reward / 100 * poolFee; // take fee 
870         reward -= Fee;
871 		devWallet.call{value:Fee};
872         return reward;
873     }
874 
875     // sends HULK fee and burns a portion of it
876     function takeHULKPoolFee(uint256 reward) internal returns(uint256){
877 
878         uint256 Fee = reward / 100 * poolFee; // take fee 
879         reward -= Fee;
880         HULK.transfer(devWallet,Fee);
881 
882         return reward;
883     }
884 
885     function returnStakeData() public view returns (bytes memory) {
886         return abi.encode(HULK.balanceOf(msg.sender), stakings[msg.sender].stakedAmount, pendingReward(msg.sender), totalPoolReserve(), totalUsers, totalClaimed, totalStaked,ETHPerBlock);
887     }
888 
889     // Ensures that the contract is able to receive ETH and adds it to the total pool
890     receive() external payable {}
891 }