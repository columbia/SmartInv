1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, apoorv, sumit
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
19 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
20 
21 ///@author Zapper
22 ///@notice this contract implements one click Liquidity Swap from one UniswapV2 Pool to Another
23 
24 // File: @openzeppelin/contracts/math/SafeMath.sol
25 
26 pragma solidity ^0.5.0;
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      * - Subtraction cannot overflow.
79      *
80      * _Available since v2.4.0._
81      */
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      *
183      * _Available since v2.4.0._
184      */
185     function mod(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 // File: @openzeppelin/contracts/GSN/Context.sol
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 contract Context {
208     // Empty internal constructor, to prevent people from mistakenly deploying
209     // an instance of this contract, which should be used via inheritance.
210     constructor() internal {}
211 
212     // solhint-disable-previous-line no-empty-blocks
213 
214     function _msgSender() internal view returns (address payable) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view returns (bytes memory) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/ownership/Ownable.sol
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(
239         address indexed previousOwner,
240         address indexed newOwner
241     );
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor() internal {
247         address msgSender = _msgSender();
248         _owner = msgSender;
249         emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(isOwner(), "Ownable: caller is not the owner");
264         _;
265     }
266 
267     /**
268      * @dev Returns true if the caller is the current owner.
269      */
270     function isOwner() public view returns (bool) {
271         return _msgSender() == _owner;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public onlyOwner {
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      */
297     function _transferOwnership(address newOwner) internal {
298         require(
299             newOwner != address(0),
300             "Ownable: new owner is the zero address"
301         );
302         emit OwnershipTransferred(_owner, newOwner);
303         _owner = newOwner;
304     }
305 }
306 
307 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
308 
309 /**
310  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
311  * the optional functions; to access them see {ERC20Detailed}.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `recipient`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address recipient, uint256 amount)
332         external
333         returns (bool);
334 
335     /**
336      * @dev Returns the remaining number of tokens that `spender` will be
337      * allowed to spend on behalf of `owner` through {transferFrom}. This is
338      * zero by default.
339      *
340      * This value changes when {approve} or {transferFrom} are called.
341      */
342     function allowance(address owner, address spender)
343         external
344         view
345         returns (uint256);
346 
347     /**
348      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * IMPORTANT: Beware that changing an allowance with this method brings the risk
353      * that someone may use both the old and the new allowance by unfortunate
354      * transaction ordering. One possible solution to mitigate this race
355      * condition is to first reduce the spender's allowance to 0 and set the
356      * desired value afterwards:
357      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address spender, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Moves `amount` tokens from `sender` to `recipient` using the
365      * allowance mechanism. `amount` is then deducted from the caller's
366      * allowance.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) external returns (bool);
377 
378     /**
379      * @dev Emitted when `value` tokens are moved from one account (`from`) to
380      * another (`to`).
381      *
382      * Note that `value` may be zero.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 value);
385 
386     /**
387      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
388      * a call to {approve}. `value` is the new allowance.
389      */
390     event Approval(
391         address indexed owner,
392         address indexed spender,
393         uint256 value
394     );
395 }
396 
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(
402         IERC20 token,
403         address to,
404         uint256 value
405     ) internal {
406         callOptionalReturn(
407             token,
408             abi.encodeWithSelector(token.transfer.selector, to, value)
409         );
410     }
411 
412     function safeTransferFrom(
413         IERC20 token,
414         address from,
415         address to,
416         uint256 value
417     ) internal {
418         callOptionalReturn(
419             token,
420             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
421         );
422     }
423 
424     function safeApprove(
425         IERC20 token,
426         address spender,
427         uint256 value
428     ) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require(
434             (value == 0) || (token.allowance(address(this), spender) == 0),
435             "SafeERC20: approve from non-zero to non-zero allowance"
436         );
437         callOptionalReturn(
438             token,
439             abi.encodeWithSelector(token.approve.selector, spender, value)
440         );
441     }
442 
443     function safeIncreaseAllowance(
444         IERC20 token,
445         address spender,
446         uint256 value
447     ) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).add(
449             value
450         );
451         callOptionalReturn(
452             token,
453             abi.encodeWithSelector(
454                 token.approve.selector,
455                 spender,
456                 newAllowance
457             )
458         );
459     }
460 
461     function safeDecreaseAllowance(
462         IERC20 token,
463         address spender,
464         uint256 value
465     ) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(
467             value,
468             "SafeERC20: decreased allowance below zero"
469         );
470         callOptionalReturn(
471             token,
472             abi.encodeWithSelector(
473                 token.approve.selector,
474                 spender,
475                 newAllowance
476             )
477         );
478     }
479 
480     /**
481      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
482      * on the return value: the return value is optional (but if data is returned, it must not be false).
483      * @param token The token targeted by the call.
484      * @param data The call data (encoded using abi.encode or one of its variants).
485      */
486     function callOptionalReturn(IERC20 token, bytes memory data) private {
487         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
488         // we're implementing it ourselves.
489 
490         // A Solidity high level call has three parts:
491         //  1. The target address is checked to verify it contains contract code
492         //  2. The call itself is made, and success asserted
493         //  3. The return value is decoded, which in turn checks the size of the returned data.
494         // solhint-disable-next-line max-line-length
495         require(address(token).isContract(), "SafeERC20: call to non-contract");
496 
497         // solhint-disable-next-line avoid-low-level-calls
498         (bool success, bytes memory returndata) = address(token).call(data);
499         require(success, "SafeERC20: low-level call failed");
500 
501         if (returndata.length > 0) {
502             // Return data is optional
503             // solhint-disable-next-line max-line-length
504             require(
505                 abi.decode(returndata, (bool)),
506                 "SafeERC20: ERC20 operation did not succeed"
507             );
508         }
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Address.sol
513 
514 /**
515  * @dev Collection of functions related to the address type
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * [IMPORTANT]
522      * ====
523      * It is unsafe to assume that an address for which this function returns
524      * false is an externally-owned account (EOA) and not a contract.
525      *
526      * Among others, `isContract` will return false for the following
527      * types of addresses:
528      *
529      *  - an externally-owned account
530      *  - a contract in construction
531      *  - an address where a contract will be created
532      *  - an address where a contract lived, but was destroyed
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
537         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
538         // for accounts without code, i.e. `keccak256('')`
539         bytes32 codehash;
540 
541 
542             bytes32 accountHash
543          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
544         // solhint-disable-next-line no-inline-assembly
545         assembly {
546             codehash := extcodehash(account)
547         }
548         return (codehash != accountHash && codehash != 0x0);
549     }
550 
551     /**
552      * @dev Converts an `address` into `address payable`. Note that this is
553      * simply a type cast: the actual underlying value is not changed.
554      *
555      * _Available since v2.4.0._
556      */
557     function toPayable(address account)
558         internal
559         pure
560         returns (address payable)
561     {
562         return address(uint160(account));
563     }
564 
565     /**
566      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
567      * `recipient`, forwarding all available gas and reverting on errors.
568      *
569      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
570      * of certain opcodes, possibly making contracts go over the 2300 gas limit
571      * imposed by `transfer`, making them unable to receive funds via
572      * `transfer`. {sendValue} removes this limitation.
573      *
574      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
575      *
576      * IMPORTANT: because control is transferred to `recipient`, care must be
577      * taken to not create reentrancy vulnerabilities. Consider using
578      * {ReentrancyGuard} or the
579      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
580      *
581      * _Available since v2.4.0._
582      */
583     function sendValue(address payable recipient, uint256 amount) internal {
584         require(
585             address(this).balance >= amount,
586             "Address: insufficient balance"
587         );
588 
589         // solhint-disable-next-line avoid-call-value
590         (bool success, ) = recipient.call.value(amount)("");
591         require(
592             success,
593             "Address: unable to send value, recipient may have reverted"
594         );
595     }
596 }
597 
598 /**
599  * @dev Contract module that helps prevent reentrant calls to a function.
600  *
601  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
602  * available, which can be applied to functions to make sure there are no nested
603  * (reentrant) calls to them.
604  *
605  * Note that because there is a single `nonReentrant` guard, functions marked as
606  * `nonReentrant` may not call one another. This can be worked around by making
607  * those functions `private`, and then adding `external` `nonReentrant` entry
608  * points to them.
609  *
610  * TIP: If you would like to learn more about reentrancy and alternative ways
611  * to protect against it, check out our blog post
612  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
613  *
614  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
615  * metering changes introduced in the Istanbul hardfork.
616  */
617 contract ReentrancyGuard {
618     bool private _notEntered;
619 
620     constructor() internal {
621         // Storing an initial non-zero value makes deployment a bit more
622         // expensive, but in exchange the refund on every call to nonReentrant
623         // will be lower in amount. Since refunds are capped to a percetange of
624         // the total transaction's gas, it is best to keep them low in cases
625         // like this one, to increase the likelihood of the full refund coming
626         // into effect.
627         _notEntered = true;
628     }
629 
630     /**
631      * @dev Prevents a contract from calling itself, directly or indirectly.
632      * Calling a `nonReentrant` function from another `nonReentrant`
633      * function is not supported. It is possible to prevent this from happening
634      * by making the `nonReentrant` function external, and make it call a
635      * `private` function that does the actual work.
636      */
637     modifier nonReentrant() {
638         // On the first call to nonReentrant, _notEntered will be true
639         require(_notEntered, "ReentrancyGuard: reentrant call");
640 
641         // Any calls to nonReentrant after this point will fail
642         _notEntered = false;
643 
644         _;
645 
646         // By storing the original value once again, a refund is triggered (see
647         // https://eips.ethereum.org/EIPS/eip-2200)
648         _notEntered = true;
649     }
650 }
651 
652 interface IUniswapV2Factory {
653     function getPair(address tokenA, address tokenB)
654         external
655         view
656         returns (address);
657 }
658 
659 interface IUniV2ZapOut {
660     function ZapOut(
661         address _ToTokenContractAddress,
662         address _FromUniPoolAddress,
663         uint256 _IncomingLP,
664         uint256 _minTokensRec
665     ) external payable returns (uint256);
666 }
667 
668 interface IUniV2ZapIn {
669     function ZapIn(
670         address _toWhomToIssue,
671         address _FromTokenContractAddress,
672         address _ToUnipoolToken0,
673         address _ToUnipoolToken1,
674         uint256 _amount,
675         uint256 _minPoolTokens
676     ) external payable returns (uint256);
677 }
678 
679 interface IUniswapV2Pair {
680     function token0() external pure returns (address);
681 
682     function token1() external pure returns (address);
683 
684     function permit(
685         address owner,
686         address spender,
687         uint256 value,
688         uint256 deadline,
689         uint8 v,
690         bytes32 r,
691         bytes32 s
692     ) external;
693 }
694 
695 contract UniswapV2_Pipe_V1_1 is ReentrancyGuard, Ownable {
696     using SafeMath for uint256;
697     using Address for address;
698     using SafeERC20 for IERC20;
699     bool private stopped = false;
700     uint16 public goodwill;
701     address
702         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
703 
704     IUniV2ZapOut public uniV2ZapOut;
705     IUniV2ZapIn public uniV2ZapIn;
706 
707     address private constant wethTokenAddress = address(
708         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
709     );
710 
711     constructor(
712         address _uniV2ZapInAddress,
713         address _uniV2ZapOutAddress,
714         uint16 _goodwill
715     ) public {
716         uniV2ZapIn = IUniV2ZapIn(_uniV2ZapInAddress);
717         uniV2ZapOut = IUniV2ZapOut(_uniV2ZapOutAddress);
718         goodwill = _goodwill;
719     }
720 
721     // circuit breaker modifiers
722     modifier stopInEmergency {
723         if (stopped) {
724             revert("Temporarily Paused");
725         } else {
726             _;
727         }
728     }
729 
730     function PipeUniV2(
731         address payable _toWhomToIssue,
732         address _incomingUniV2Exchange,
733         uint256 _IncomingLPT,
734         address _toUniV2Exchange,
735         uint256 _minPoolTokens
736     ) public nonReentrant stopInEmergency returns (uint256 lptReceived) {
737         // transfer lpt
738         IERC20(_incomingUniV2Exchange).safeTransferFrom(
739             msg.sender,
740             address(this),
741             _IncomingLPT
742         );
743 
744         // find all 4 tokens
745         IUniswapV2Pair pair1 = IUniswapV2Pair(_incomingUniV2Exchange);
746         IUniswapV2Pair pair2 = IUniswapV2Pair(_toUniV2Exchange);
747 
748         address token1_1 = pair1.token0();
749         address token1_2 = pair1.token1();
750         address token2_1 = pair2.token0();
751         address token2_2 = pair2.token1();
752 
753         address intermediateToken = wethTokenAddress;
754 
755         // check for common token
756         if (token1_1 == token2_1 || token1_1 == token2_2) {
757             intermediateToken = token1_1;
758         } else if (token1_2 == token2_1 || token1_2 == token2_2) {
759             intermediateToken = token1_2;
760         }
761 
762         // approve ZapOut contract
763         IERC20(_incomingUniV2Exchange).safeApprove(
764             address(uniV2ZapOut),
765             _IncomingLPT
766         );
767 
768         // zapout
769         uint256 intermediateReceived = uniV2ZapOut.ZapOut(
770             intermediateToken,
771             _incomingUniV2Exchange,
772             _IncomingLPT,
773             1
774         );
775 
776         // transfer goodwill portion
777         uint256 goodwillPortion = _transferGoodwill(
778             intermediateToken,
779             intermediateReceived
780         );
781 
782         // approve ZapIn
783         IERC20(intermediateToken).safeApprove(
784             address(uniV2ZapIn),
785             intermediateReceived.sub(goodwillPortion)
786         );
787 
788         // ZapIn with intermediate
789         lptReceived = _performZapIn(
790             _toWhomToIssue,
791             intermediateToken,
792             token2_1,
793             token2_2,
794             intermediateReceived.sub(goodwillPortion)
795         );
796         require(lptReceived >= _minPoolTokens, "Err: High Slippage");
797     }
798 
799     function PipeUniV2WithPermit(
800         address payable _toWhomToIssue,
801         address _incomingUniV2Exchange,
802         uint256 _IncomingLPT,
803         address _toUniV2Exchange,
804         uint256 _minPoolTokens,
805         uint256 _approvalAmount,
806         uint256 _deadline,
807         uint8 v,
808         bytes32 r,
809         bytes32 s
810     ) external returns (uint256) {
811         // permit
812         IUniswapV2Pair(_incomingUniV2Exchange).permit(
813             msg.sender,
814             address(this),
815             _approvalAmount,
816             _deadline,
817             v,
818             r,
819             s
820         );
821 
822         return (
823             PipeUniV2(
824                 _toWhomToIssue,
825                 _incomingUniV2Exchange,
826                 _IncomingLPT,
827                 _toUniV2Exchange,
828                 _minPoolTokens
829             )
830         );
831     }
832 
833     function _performZapIn(
834         address _toWhomToIssue,
835         address intermediateToken,
836         address token2_1,
837         address token2_2,
838         uint256 intermediateAmt
839     ) internal returns (uint256 _lptRec) {
840         return (
841             uniV2ZapIn.ZapIn(
842                 _toWhomToIssue,
843                 intermediateToken,
844                 token2_1,
845                 token2_2,
846                 intermediateAmt,
847                 1
848             )
849         );
850     }
851 
852     /**
853     @notice This function is used to calculate and transfer goodwill
854     @param _tokenContractAddress Token in which goodwill is deducted
855     @param tokens2Trade The total amount of tokens to be zapped in
856     @return goodwillPortion The quantity of goodwill deducted
857      */
858     function _transferGoodwill(
859         address _tokenContractAddress,
860         uint256 tokens2Trade
861     ) internal returns (uint256 goodwillPortion) {
862         goodwillPortion = SafeMath.div(
863             SafeMath.mul(tokens2Trade, goodwill),
864             10000
865         );
866 
867         if (goodwillPortion == 0) {
868             return 0;
869         }
870 
871         IERC20(_tokenContractAddress).safeTransfer(
872             zgoodwillAddress,
873             goodwillPortion
874         );
875     }
876 
877     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
878         require(
879             _new_goodwill >= 0 && _new_goodwill < 10000,
880             "GoodWill Value not allowed"
881         );
882         goodwill = _new_goodwill;
883     }
884 
885     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
886         uint256 qty = _TokenAddress.balanceOf(address(this));
887         _TokenAddress.safeTransfer(owner(), qty);
888     }
889 
890     // - to Pause the contract
891     function toggleContractActive() public onlyOwner {
892         stopped = !stopped;
893     }
894 
895     // - to withdraw any ETH balance sitting in the contract
896     function withdraw() public onlyOwner {
897         uint256 contractBalance = address(this).balance;
898         address payable _to = owner().toPayable();
899         _to.transfer(contractBalance);
900     }
901 
902     function() external payable {
903         require(msg.sender != tx.origin, "Do not send ETH directly");
904     }
905 }