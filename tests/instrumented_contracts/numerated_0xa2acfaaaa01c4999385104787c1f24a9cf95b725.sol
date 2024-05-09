1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, dipeshsukhani, nodarjanashia, suhailg, sebaudet, sumitrajput, apoorvlathey
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice this contract adds liquidity to Balancer liquidity pools in one transaction
22 
23 // File: @openzeppelin/contracts/utils/Address.sol
24 
25 pragma solidity ^0.5.5;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
50         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
51         // for accounts without code, i.e. `keccak256('')`
52         bytes32 codehash;
53 
54 
55             bytes32 accountHash
56          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
57         // solhint-disable-next-line no-inline-assembly
58         assembly {
59             codehash := extcodehash(account)
60         }
61         return (codehash != accountHash && codehash != 0x0);
62     }
63 
64     /**
65      * @dev Converts an `address` into `address payable`. Note that this is
66      * simply a type cast: the actual underlying value is not changed.
67      *
68      * _Available since v2.4.0._
69      */
70     function toPayable(address account)
71         internal
72         pure
73         returns (address payable)
74     {
75         return address(uint160(account));
76     }
77 
78     /**
79      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
80      * `recipient`, forwarding all available gas and reverting on errors.
81      *
82      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
83      * of certain opcodes, possibly making contracts go over the 2300 gas limit
84      * imposed by `transfer`, making them unable to receive funds via
85      * `transfer`. {sendValue} removes this limitation.
86      *
87      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
88      *
89      * IMPORTANT: because control is transferred to `recipient`, care must be
90      * taken to not create reentrancy vulnerabilities. Consider using
91      * {ReentrancyGuard} or the
92      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
93      *
94      * _Available since v2.4.0._
95      */
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(
98             address(this).balance >= amount,
99             "Address: insufficient balance"
100         );
101 
102         // solhint-disable-next-line avoid-call-value
103         (bool success, ) = recipient.call.value(amount)("");
104         require(
105             success,
106             "Address: unable to send value, recipient may have reverted"
107         );
108     }
109 }
110 
111 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
115  * the optional functions; to access them see {ERC20Detailed}.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount)
136         external
137         returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender)
147         external
148         view
149         returns (uint256);
150 
151     /**
152      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * IMPORTANT: Beware that changing an allowance with this method brings the risk
157      * that someone may use both the old and the new allowance by unfortunate
158      * transaction ordering. One possible solution to mitigate this race
159      * condition is to first reduce the spender's allowance to 0 and set the
160      * desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      *
163      * Emits an {Approval} event.
164      */
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Moves `amount` tokens from `sender` to `recipient` using the
169      * allowance mechanism. `amount` is then deducted from the caller's
170      * allowance.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) external returns (bool);
181 
182     /**
183      * @dev Emitted when `value` tokens are moved from one account (`from`) to
184      * another (`to`).
185      *
186      * Note that `value` may be zero.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     /**
191      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
192      * a call to {approve}. `value` is the new allowance.
193      */
194     event Approval(
195         address indexed owner,
196         address indexed spender,
197         uint256 value
198     );
199 }
200 
201 // File: @openzeppelin/contracts/GSN/Context.sol
202 
203 /*
204  * @dev Provides information about the current execution context, including the
205  * sender of the transaction and its data. While these are generally available
206  * via msg.sender and msg.data, they should not be accessed in such a direct
207  * manner, since when dealing with GSN meta-transactions the account sending and
208  * paying for execution may not be the actual sender (as far as an application
209  * is concerned).
210  *
211  * This contract is only required for intermediate, library-like contracts.
212  */
213 contract Context {
214     // Empty internal constructor, to prevent people from mistakenly deploying
215     // an instance of this contract, which should be used via inheritance.
216     constructor() internal {}
217 
218     // solhint-disable-previous-line no-empty-blocks
219 
220     function _msgSender() internal view returns (address payable) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view returns (bytes memory) {
225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/ownership/Ownable.sol
231 
232 /**
233  * @dev Contract module which provides a basic access control mechanism, where
234  * there is an account (an owner) that can be granted exclusive access to
235  * specific functions.
236  *
237  * This module is used through inheritance. It will make available the modifier
238  * `onlyOwner`, which can be applied to your functions to restrict their use to
239  * the owner.
240  */
241 contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(
245         address indexed previousOwner,
246         address indexed newOwner
247     );
248 
249     /**
250      * @dev Initializes the contract setting the deployer as the initial owner.
251      */
252     constructor() internal {
253         address msgSender = _msgSender();
254         _owner = msgSender;
255         emit OwnershipTransferred(address(0), msgSender);
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(isOwner(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Returns true if the caller is the current owner.
275      */
276     function isOwner() public view returns (bool) {
277         return _msgSender() == _owner;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public onlyOwner {
288         emit OwnershipTransferred(_owner, address(0));
289         _owner = address(0);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public onlyOwner {
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      */
303     function _transferOwnership(address newOwner) internal {
304         require(
305             newOwner != address(0),
306             "Ownable: new owner is the zero address"
307         );
308         emit OwnershipTransferred(_owner, newOwner);
309         _owner = newOwner;
310     }
311 }
312 
313 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
314 
315 /**
316  * @dev Contract module that helps prevent reentrant calls to a function.
317  *
318  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
319  * available, which can be applied to functions to make sure there are no nested
320  * (reentrant) calls to them.
321  *
322  * Note that because there is a single `nonReentrant` guard, functions marked as
323  * `nonReentrant` may not call one another. This can be worked around by making
324  * those functions `private`, and then adding `external` `nonReentrant` entry
325  * points to them.
326  *
327  * TIP: If you would like to learn more about reentrancy and alternative ways
328  * to protect against it, check out our blog post
329  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
330  *
331  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
332  * metering changes introduced in the Istanbul hardfork.
333  */
334 contract ReentrancyGuard {
335     bool private _notEntered;
336 
337     constructor() internal {
338         // Storing an initial non-zero value makes deployment a bit more
339         // expensive, but in exchange the refund on every call to nonReentrant
340         // will be lower in amount. Since refunds are capped to a percetange of
341         // the total transaction's gas, it is best to keep them low in cases
342         // like this one, to increase the likelihood of the full refund coming
343         // into effect.
344         _notEntered = true;
345     }
346 
347     /**
348      * @dev Prevents a contract from calling itself, directly or indirectly.
349      * Calling a `nonReentrant` function from another `nonReentrant`
350      * function is not supported. It is possible to prevent this from happening
351      * by making the `nonReentrant` function external, and make it call a
352      * `private` function that does the actual work.
353      */
354     modifier nonReentrant() {
355         // On the first call to nonReentrant, _notEntered will be true
356         require(_notEntered, "ReentrancyGuard: reentrant call");
357 
358         // Any calls to nonReentrant after this point will fail
359         _notEntered = false;
360 
361         _;
362 
363         // By storing the original value once again, a refund is triggered (see
364         // https://eips.ethereum.org/EIPS/eip-2200)
365         _notEntered = true;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/math/SafeMath.sol
370 
371 /**
372  * @dev Wrappers over Solidity's arithmetic operations with added overflow
373  * checks.
374  *
375  * Arithmetic operations in Solidity wrap on overflow. This can easily result
376  * in bugs, because programmers usually assume that an overflow raises an
377  * error, which is the standard behavior in high level programming languages.
378  * `SafeMath` restores this intuition by reverting the transaction when an
379  * operation overflows.
380  *
381  * Using this library instead of the unchecked operations eliminates an entire
382  * class of bugs, so it's recommended to use it always.
383  */
384 library SafeMath {
385     /**
386      * @dev Returns the addition of two unsigned integers, reverting on
387      * overflow.
388      *
389      * Counterpart to Solidity's `+` operator.
390      *
391      * Requirements:
392      * - Addition cannot overflow.
393      */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         require(c >= a, "SafeMath: addition overflow");
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the subtraction of two unsigned integers, reverting on
403      * overflow (when the result is negative).
404      *
405      * Counterpart to Solidity's `-` operator.
406      *
407      * Requirements:
408      * - Subtraction cannot overflow.
409      */
410     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411         return sub(a, b, "SafeMath: subtraction overflow");
412     }
413 
414     /**
415      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
416      * overflow (when the result is negative).
417      *
418      * Counterpart to Solidity's `-` operator.
419      *
420      * Requirements:
421      * - Subtraction cannot overflow.
422      *
423      * _Available since v2.4.0._
424      */
425     function sub(
426         uint256 a,
427         uint256 b,
428         string memory errorMessage
429     ) internal pure returns (uint256) {
430         require(b <= a, errorMessage);
431         uint256 c = a - b;
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the multiplication of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `*` operator.
441      *
442      * Requirements:
443      * - Multiplication cannot overflow.
444      */
445     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
446         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
447         // benefit is lost if 'b' is also tested.
448         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
449         if (a == 0) {
450             return 0;
451         }
452 
453         uint256 c = a * b;
454         require(c / a == b, "SafeMath: multiplication overflow");
455 
456         return c;
457     }
458 
459     /**
460      * @dev Returns the integer division of two unsigned integers. Reverts on
461      * division by zero. The result is rounded towards zero.
462      *
463      * Counterpart to Solidity's `/` operator. Note: this function uses a
464      * `revert` opcode (which leaves remaining gas untouched) while Solidity
465      * uses an invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      * - The divisor cannot be zero.
469      */
470     function div(uint256 a, uint256 b) internal pure returns (uint256) {
471         return div(a, b, "SafeMath: division by zero");
472     }
473 
474     /**
475      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
476      * division by zero. The result is rounded towards zero.
477      *
478      * Counterpart to Solidity's `/` operator. Note: this function uses a
479      * `revert` opcode (which leaves remaining gas untouched) while Solidity
480      * uses an invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      * - The divisor cannot be zero.
484      *
485      * _Available since v2.4.0._
486      */
487     function div(
488         uint256 a,
489         uint256 b,
490         string memory errorMessage
491     ) internal pure returns (uint256) {
492         // Solidity only automatically asserts when dividing by 0
493         require(b > 0, errorMessage);
494         uint256 c = a / b;
495         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
496 
497         return c;
498     }
499 
500     /**
501      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
502      * Reverts when dividing by zero.
503      *
504      * Counterpart to Solidity's `%` operator. This function uses a `revert`
505      * opcode (which leaves remaining gas untouched) while Solidity uses an
506      * invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      * - The divisor cannot be zero.
510      */
511     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
512         return mod(a, b, "SafeMath: modulo by zero");
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * Reverts with custom message when dividing by zero.
518      *
519      * Counterpart to Solidity's `%` operator. This function uses a `revert`
520      * opcode (which leaves remaining gas untouched) while Solidity uses an
521      * invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      * - The divisor cannot be zero.
525      *
526      * _Available since v2.4.0._
527      */
528     function mod(
529         uint256 a,
530         uint256 b,
531         string memory errorMessage
532     ) internal pure returns (uint256) {
533         require(b != 0, errorMessage);
534         return a % b;
535     }
536 }
537 
538 interface IBFactory {
539     function isBPool(address b) external view returns (bool);
540 }
541 
542 interface IBPool {
543     function joinswapExternAmountIn(
544         address tokenIn,
545         uint256 tokenAmountIn,
546         uint256 minPoolAmountOut
547     ) external payable returns (uint256 poolAmountOut);
548 
549     function isBound(address t) external view returns (bool);
550 
551     function getFinalTokens() external view returns (address[] memory tokens);
552 
553     function totalSupply() external view returns (uint256);
554 
555     function getDenormalizedWeight(address token)
556         external
557         view
558         returns (uint256);
559 
560     function getTotalDenormalizedWeight() external view returns (uint256);
561 
562     function getSwapFee() external view returns (uint256);
563 
564     function calcPoolOutGivenSingleIn(
565         uint256 tokenBalanceIn,
566         uint256 tokenWeightIn,
567         uint256 poolSupply,
568         uint256 totalWeight,
569         uint256 tokenAmountIn,
570         uint256 swapFee
571     ) external pure returns (uint256 poolAmountOut);
572 
573     function getBalance(address token) external view returns (uint256);
574 }
575 
576 interface IWETH {
577     function deposit() external payable;
578 
579     function transfer(address to, uint256 value) external returns (bool);
580 
581     function withdraw(uint256) external;
582 }
583 
584 library TransferHelper {
585     function safeApprove(
586         address token,
587         address to,
588         uint256 value
589     ) internal {
590         // bytes4(keccak256(bytes('approve(address,uint256)')));
591         (bool success, bytes memory data) = token.call(
592             abi.encodeWithSelector(0x095ea7b3, to, value)
593         );
594         require(
595             success && (data.length == 0 || abi.decode(data, (bool))),
596             "TransferHelper: APPROVE_FAILED"
597         );
598     }
599 
600     function safeTransfer(
601         address token,
602         address to,
603         uint256 value
604     ) internal {
605         // bytes4(keccak256(bytes('transfer(address,uint256)')));
606         (bool success, bytes memory data) = token.call(
607             abi.encodeWithSelector(0xa9059cbb, to, value)
608         );
609         require(
610             success && (data.length == 0 || abi.decode(data, (bool))),
611             "TransferHelper: TRANSFER_FAILED"
612         );
613     }
614 
615     function safeTransferFrom(
616         address token,
617         address from,
618         address to,
619         uint256 value
620     ) internal {
621         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
622         (bool success, bytes memory data) = token.call(
623             abi.encodeWithSelector(0x23b872dd, from, to, value)
624         );
625         require(
626             success && (data.length == 0 || abi.decode(data, (bool))),
627             "TransferHelper: TRANSFER_FROM_FAILED"
628         );
629     }
630 }
631 
632 interface IUniswapV2Factory {
633     function getPair(address tokenA, address tokenB)
634         external
635         view
636         returns (address);
637 }
638 
639 interface IUniswapRouter02 {
640     //get estimated amountOut
641     function getAmountsOut(uint256 amountIn, address[] calldata path)
642         external
643         view
644         returns (uint256[] memory amounts);
645 
646     function getAmountsIn(uint256 amountOut, address[] calldata path)
647         external
648         view
649         returns (uint256[] memory amounts);
650 
651     //token 2 token
652     function swapExactTokensForTokens(
653         uint256 amountIn,
654         uint256 amountOutMin,
655         address[] calldata path,
656         address to,
657         uint256 deadline
658     ) external returns (uint256[] memory amounts);
659 
660     function swapTokensForExactTokens(
661         uint256 amountOut,
662         uint256 amountInMax,
663         address[] calldata path,
664         address to,
665         uint256 deadline
666     ) external returns (uint256[] memory amounts);
667 
668     //eth 2 token
669     function swapExactETHForTokens(
670         uint256 amountOutMin,
671         address[] calldata path,
672         address to,
673         uint256 deadline
674     ) external payable returns (uint256[] memory amounts);
675 
676     function swapETHForExactTokens(
677         uint256 amountOut,
678         address[] calldata path,
679         address to,
680         uint256 deadline
681     ) external payable returns (uint256[] memory amounts);
682 
683     //token 2 eth
684     function swapTokensForExactETH(
685         uint256 amountOut,
686         uint256 amountInMax,
687         address[] calldata path,
688         address to,
689         uint256 deadline
690     ) external returns (uint256[] memory amounts);
691 
692     function swapExactTokensForETH(
693         uint256 amountIn,
694         uint256 amountOutMin,
695         address[] calldata path,
696         address to,
697         uint256 deadline
698     ) external returns (uint256[] memory amounts);
699 }
700 
701 contract Balancer_ZapIn_General_V2_5 is ReentrancyGuard, Ownable {
702     using SafeMath for uint256;
703     using Address for address;
704     bool public stopped = false;
705     uint16 public goodwill;
706 
707     IBFactory BalancerFactory = IBFactory(
708         0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
709     );
710     IUniswapV2Factory
711         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
712         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
713     );
714     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
715         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
716     );
717 
718     address
719         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
720     address
721         private constant dzgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
722 
723     uint256
724         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
725 
726     event Zapin(
727         address _toWhomToIssue,
728         address _toBalancerPoolAddress,
729         uint256 _OutgoingBPT
730     );
731 
732     constructor(uint16 _goodwill) public {
733         goodwill = _goodwill;
734     }
735 
736     // circuit breaker modifiers
737     modifier stopInEmergency {
738         if (stopped) {
739             revert("Temporarily Paused");
740         } else {
741             _;
742         }
743     }
744 
745     /**
746     @notice This function is used to invest in given balancer pool through ETH/ERC20 Tokens
747     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
748     @param _ToBalancerPoolAddress The address of balancer pool to zapin
749     @param _amount The amount of ERC to invest
750     @param _minPoolTokens for slippage
751     @return success or failure
752      */
753     function EasyZapIn(
754         address _FromTokenContractAddress,
755         address _ToBalancerPoolAddress,
756         uint256 _amount,
757         uint256 _minPoolTokens
758     )
759         public
760         payable
761         nonReentrant
762         stopInEmergency
763         returns (uint256 tokensBought)
764     {
765         require(
766             BalancerFactory.isBPool(_ToBalancerPoolAddress),
767             "Invalid Balancer Pool"
768         );
769 
770         if (_FromTokenContractAddress == address(0)) {
771             require(msg.value > 0, "ERR: No ETH sent");
772 
773             address _IntermediateToken = _getBestDeal(
774                 _ToBalancerPoolAddress,
775                 msg.value,
776                 _FromTokenContractAddress
777             );
778 
779             tokensBought = _performZapIn(
780                 msg.sender,
781                 _FromTokenContractAddress,
782                 _ToBalancerPoolAddress,
783                 msg.value,
784                 _IntermediateToken,
785                 _minPoolTokens
786             );
787 
788             return tokensBought;
789         }
790 
791         require(_amount > 0, "ERR: No ERC sent");
792         require(msg.value == 0, "ERR: ETH sent with tokens");
793 
794         //transfer tokens to contract
795         TransferHelper.safeTransferFrom(
796             _FromTokenContractAddress,
797             msg.sender,
798             address(this),
799             _amount
800         );
801 
802         address _IntermediateToken = _getBestDeal(
803             _ToBalancerPoolAddress,
804             _amount,
805             _FromTokenContractAddress
806         );
807 
808         tokensBought = _performZapIn(
809             msg.sender,
810             _FromTokenContractAddress,
811             _ToBalancerPoolAddress,
812             _amount,
813             _IntermediateToken,
814             _minPoolTokens
815         );
816     }
817 
818     /**
819     @notice This function internally called by ZapIn() and EasyZapIn()
820     @param _toWhomToIssue The user address who want to invest
821     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
822     @param _ToBalancerPoolAddress The address of balancer pool to zapin
823     @param _amount The amount of ETH/ERC to invest
824     @param _IntermediateToken The token for intermediate conversion before zapin
825     @param _minPoolTokens for slippage
826     @return The quantity of Balancer Pool tokens returned
827      */
828     function _performZapIn(
829         address _toWhomToIssue,
830         address _FromTokenContractAddress,
831         address _ToBalancerPoolAddress,
832         uint256 _amount,
833         address _IntermediateToken,
834         uint256 _minPoolTokens
835     ) internal returns (uint256 tokensBought) {
836         // check if isBound()
837         bool isBound = IBPool(_ToBalancerPoolAddress).isBound(
838             _FromTokenContractAddress
839         );
840 
841         uint256 balancerTokens;
842 
843         if (isBound) {
844             balancerTokens = _enter2Balancer(
845                 _ToBalancerPoolAddress,
846                 _FromTokenContractAddress,
847                 _amount,
848                 _minPoolTokens
849             );
850         } else {
851             // swap tokens or eth
852             uint256 tokenBought;
853             if (_FromTokenContractAddress == address(0)) {
854                 tokenBought = _eth2Token(_IntermediateToken);
855             } else {
856                 tokenBought = _token2Token(
857                     _FromTokenContractAddress,
858                     _IntermediateToken,
859                     _amount
860                 );
861             }
862 
863             //get BPT
864             balancerTokens = _enter2Balancer(
865                 _ToBalancerPoolAddress,
866                 _IntermediateToken,
867                 tokenBought,
868                 _minPoolTokens
869             );
870         }
871 
872         //transfer goodwill
873         uint256 goodwillPortion = _transferGoodwill(
874             _ToBalancerPoolAddress,
875             balancerTokens
876         );
877 
878         emit Zapin(
879             _toWhomToIssue,
880             _ToBalancerPoolAddress,
881             SafeMath.sub(balancerTokens, goodwillPortion)
882         );
883 
884         //transfer tokens to user
885         TransferHelper.safeTransfer(
886             _ToBalancerPoolAddress,
887             _toWhomToIssue,
888             SafeMath.sub(balancerTokens, goodwillPortion)
889         );
890         return SafeMath.sub(balancerTokens, goodwillPortion);
891     }
892 
893     /**
894     @notice This function is used to zapin to balancer pool
895     @param _ToBalancerPoolAddress The address of balancer pool to zap in
896     @param _FromTokenContractAddress The token used to zap in
897     @param tokens2Trade The amount of tokens to invest
898     @return The quantity of Balancer Pool tokens returned
899      */
900     function _enter2Balancer(
901         address _ToBalancerPoolAddress,
902         address _FromTokenContractAddress,
903         uint256 tokens2Trade,
904         uint256 _minPoolTokens
905     ) internal returns (uint256 poolTokensOut) {
906         require(
907             IBPool(_ToBalancerPoolAddress).isBound(_FromTokenContractAddress),
908             "Token not bound"
909         );
910 
911         uint256 allowance = IERC20(_FromTokenContractAddress).allowance(
912             address(this),
913             _ToBalancerPoolAddress
914         );
915 
916         if (allowance < tokens2Trade) {
917             TransferHelper.safeApprove(
918                 _FromTokenContractAddress,
919                 _ToBalancerPoolAddress,
920                 uint256(-1)
921             );
922         }
923 
924         poolTokensOut = IBPool(_ToBalancerPoolAddress).joinswapExternAmountIn(
925             _FromTokenContractAddress,
926             tokens2Trade,
927             _minPoolTokens
928         );
929 
930         require(poolTokensOut > 0, "Error in entering balancer pool");
931     }
932 
933     /**
934     @notice This function finds best token from the final tokens of balancer pool
935     @param _ToBalancerPoolAddress The address of balancer pool to zap in
936     @param _amount amount of eth/erc to invest
937     @param _FromTokenContractAddress the token address which is used to invest
938     @return The token address having max liquidity
939      */
940     function _getBestDeal(
941         address _ToBalancerPoolAddress,
942         uint256 _amount,
943         address _FromTokenContractAddress
944     ) internal view returns (address _token) {
945         // If input is not eth or weth
946         if (
947             _FromTokenContractAddress != address(0) &&
948             _FromTokenContractAddress != wethTokenAddress
949         ) {
950             // check if input token or weth is bound and if so return it as intermediate
951             bool isBound = IBPool(_ToBalancerPoolAddress).isBound(
952                 _FromTokenContractAddress
953             );
954             if (isBound) return _FromTokenContractAddress;
955         }
956 
957         bool wethIsBound = IBPool(_ToBalancerPoolAddress).isBound(
958             wethTokenAddress
959         );
960         if (wethIsBound) return wethTokenAddress;
961 
962         //get token list
963         address[] memory tokens = IBPool(_ToBalancerPoolAddress)
964             .getFinalTokens();
965 
966         uint256 amount = _amount;
967         address[] memory path = new address[](2);
968 
969         if (
970             _FromTokenContractAddress != address(0) &&
971             _FromTokenContractAddress != wethTokenAddress
972         ) {
973             path[0] = _FromTokenContractAddress;
974             path[1] = wethTokenAddress;
975             //get eth value for given token
976             amount = uniswapRouter.getAmountsOut(_amount, path)[1];
977         }
978 
979         uint256 maxBPT;
980         path[0] = wethTokenAddress;
981 
982         for (uint256 index = 0; index < tokens.length; index++) {
983             uint256 expectedBPT;
984 
985             if (tokens[index] != wethTokenAddress) {
986                 if (
987                     UniSwapV2FactoryAddress.getPair(
988                         tokens[index],
989                         wethTokenAddress
990                     ) == address(0)
991                 ) {
992                     continue;
993                 }
994 
995                 //get qty of tokens
996                 path[1] = tokens[index];
997                 uint256 expectedTokens = uniswapRouter.getAmountsOut(
998                     amount,
999                     path
1000                 )[1];
1001 
1002                 //get bpt for given tokens
1003                 expectedBPT = getToken2BPT(
1004                     _ToBalancerPoolAddress,
1005                     expectedTokens,
1006                     tokens[index]
1007                 );
1008 
1009                 //get token giving max BPT
1010                 if (maxBPT < expectedBPT) {
1011                     maxBPT = expectedBPT;
1012                     _token = tokens[index];
1013                 }
1014             } else {
1015                 //get bpt for given weth tokens
1016                 expectedBPT = getToken2BPT(
1017                     _ToBalancerPoolAddress,
1018                     amount,
1019                     tokens[index]
1020                 );
1021             }
1022 
1023             //get token giving max BPT
1024             if (maxBPT < expectedBPT) {
1025                 maxBPT = expectedBPT;
1026                 _token = tokens[index];
1027             }
1028         }
1029     }
1030 
1031     /**
1032     @notice Function gives the expected amount of pool tokens on investing
1033     @param _ToBalancerPoolAddress Address of balancer pool to zapin
1034     @param _IncomingERC The amount of ERC to invest
1035     @param _FromToken Address of token to zap in with
1036     @return Amount of BPT token
1037      */
1038     function getToken2BPT(
1039         address _ToBalancerPoolAddress,
1040         uint256 _IncomingERC,
1041         address _FromToken
1042     ) internal view returns (uint256 tokensReturned) {
1043         uint256 totalSupply = IBPool(_ToBalancerPoolAddress).totalSupply();
1044         uint256 swapFee = IBPool(_ToBalancerPoolAddress).getSwapFee();
1045         uint256 totalWeight = IBPool(_ToBalancerPoolAddress)
1046             .getTotalDenormalizedWeight();
1047         uint256 balance = IBPool(_ToBalancerPoolAddress).getBalance(_FromToken);
1048         uint256 denorm = IBPool(_ToBalancerPoolAddress).getDenormalizedWeight(
1049             _FromToken
1050         );
1051 
1052         tokensReturned = IBPool(_ToBalancerPoolAddress)
1053             .calcPoolOutGivenSingleIn(
1054             balance,
1055             denorm,
1056             totalSupply,
1057             totalWeight,
1058             _IncomingERC,
1059             swapFee
1060         );
1061     }
1062 
1063     /**
1064     @notice This function is used to buy tokens from eth
1065     @param _tokenContractAddress Token address which we want to buy
1066     @return The quantity of token bought
1067      */
1068     function _eth2Token(address _tokenContractAddress)
1069         internal
1070         returns (uint256 tokenBought)
1071     {
1072         if (_tokenContractAddress == wethTokenAddress) {
1073             IWETH(wethTokenAddress).deposit.value(msg.value)();
1074             return msg.value;
1075         }
1076 
1077         address[] memory path = new address[](2);
1078         path[0] = wethTokenAddress;
1079         path[1] = _tokenContractAddress;
1080         tokenBought = uniswapRouter.swapExactETHForTokens.value(msg.value)(
1081             1,
1082             path,
1083             address(this),
1084             deadline
1085         )[path.length - 1];
1086     }
1087 
1088     /**
1089     @notice This function is used to swap tokens
1090     @param _FromTokenContractAddress The token address to swap from
1091     @param _ToTokenContractAddress The token address to swap to
1092     @param tokens2Trade The amount of tokens to swap
1093     @return The quantity of tokens bought
1094      */
1095     function _token2Token(
1096         address _FromTokenContractAddress,
1097         address _ToTokenContractAddress,
1098         uint256 tokens2Trade
1099     ) public returns (uint256 tokenBought) {
1100         TransferHelper.safeApprove(
1101             _FromTokenContractAddress,
1102             address(uniswapRouter),
1103             tokens2Trade
1104         );
1105 
1106         if (_FromTokenContractAddress != wethTokenAddress) {
1107             if (_ToTokenContractAddress != wethTokenAddress) {
1108                 address[] memory path = new address[](3);
1109                 path[0] = _FromTokenContractAddress;
1110                 path[1] = wethTokenAddress;
1111                 path[2] = _ToTokenContractAddress;
1112                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1113                     tokens2Trade,
1114                     1,
1115                     path,
1116                     address(this),
1117                     deadline
1118                 )[path.length - 1];
1119             } else {
1120                 address[] memory path = new address[](2);
1121                 path[0] = _FromTokenContractAddress;
1122                 path[1] = wethTokenAddress;
1123 
1124                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1125                     tokens2Trade,
1126                     1,
1127                     path,
1128                     address(this),
1129                     deadline
1130                 )[path.length - 1];
1131             }
1132         } else {
1133             address[] memory path = new address[](2);
1134             path[0] = wethTokenAddress;
1135             path[1] = _ToTokenContractAddress;
1136             tokenBought = uniswapRouter.swapExactTokensForTokens(
1137                 tokens2Trade,
1138                 1,
1139                 path,
1140                 address(this),
1141                 deadline
1142             )[path.length - 1];
1143         }
1144 
1145         require(tokenBought > 0, "Error in swapping ERC: 1");
1146     }
1147 
1148     /**
1149     @notice This function is used to calculate and transfer goodwill
1150     @param _tokenContractAddress Token in which goodwill is deducted
1151     @param tokens2Trade The total amount of tokens to be zapped in
1152     @return The quantity of goodwill deducted
1153      */
1154     function _transferGoodwill(
1155         address _tokenContractAddress,
1156         uint256 tokens2Trade
1157     ) internal returns (uint256 goodwillPortion) {
1158         goodwillPortion = SafeMath.div(
1159             SafeMath.mul(tokens2Trade, goodwill),
1160             10000
1161         );
1162 
1163         if (goodwillPortion == 0) {
1164             return 0;
1165         }
1166 
1167         TransferHelper.safeTransfer(
1168             _tokenContractAddress,
1169             dzgoodwillAddress,
1170             goodwillPortion
1171         );
1172     }
1173 
1174     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1175         require(
1176             _new_goodwill >= 0 && _new_goodwill < 10000,
1177             "GoodWill Value not allowed"
1178         );
1179         goodwill = _new_goodwill;
1180     }
1181 
1182     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1183         uint256 qty = _TokenAddress.balanceOf(address(this));
1184         TransferHelper.safeTransfer(address(_TokenAddress), owner(), qty);
1185     }
1186 
1187     // - to Pause the contract
1188     function toggleContractActive() public onlyOwner {
1189         stopped = !stopped;
1190     }
1191 
1192     // - to withdraw any ETH balance sitting in the contract
1193     function withdraw() public onlyOwner {
1194         uint256 contractBalance = address(this).balance;
1195         address payable _to = owner().toPayable();
1196         _to.transfer(contractBalance);
1197     }
1198 
1199     function() external payable {}
1200 }