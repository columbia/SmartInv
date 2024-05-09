1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity 0.6.12;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 pragma solidity 0.6.12;
95 
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the token decimals.
104      */
105     function decimals() external view returns (uint8);
106 
107     /**
108      * @dev Returns the token symbol.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the token name.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the erc token owner.
119      */
120     function getOwner() external view returns (address);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address _owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: @openzeppelin/contracts/math/SafeMath.sol
192 
193 pragma solidity 0.6.12;
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations with added overflow
197  * checks.
198  *
199  * Arithmetic operations in Solidity wrap on overflow. This can easily result
200  * in bugs, because programmers usually assume that an overflow raises an
201  * error, which is the standard behavior in high level programming languages.
202  * `SafeMath` restores this intuition by reverting the transaction when an
203  * operation overflows.
204  *
205  * Using this library instead of the unchecked operations eliminates an entire
206  * class of bugs, so it's recommended to use it always.
207  */
208 library SafeMath {
209     /**
210      * @dev Returns the addition of two unsigned integers, with an overflow flag.
211      *
212      * _Available since v3.4._
213      */
214     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         uint256 c = a + b;
216         if (c < a) return (false, 0);
217         return (true, c);
218     }
219 
220     /**
221      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
222      *
223      * _Available since v3.4._
224      */
225     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         if (b > a) return (false, 0);
227         return (true, a - b);
228     }
229 
230     /**
231      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
232      *
233      * _Available since v3.4._
234      */
235     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
237         // benefit is lost if 'b' is also tested.
238         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
239         if (a == 0) return (true, 0);
240         uint256 c = a * b;
241         if (c / a != b) return (false, 0);
242         return (true, c);
243     }
244 
245     /**
246      * @dev Returns the division of two unsigned integers, with a division by zero flag.
247      *
248      * _Available since v3.4._
249      */
250     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         if (b == 0) return (false, 0);
252         return (true, a / b);
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
257      *
258      * _Available since v3.4._
259      */
260     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         if (b == 0) return (false, 0);
262         return (true, a % b);
263     }
264 
265     /**
266      * @dev Returns the addition of two unsigned integers, reverting on
267      * overflow.
268      *
269      * Counterpart to Solidity's `+` operator.
270      *
271      * Requirements:
272      *
273      * - Addition cannot overflow.
274      */
275     function add(uint256 a, uint256 b) internal pure returns (uint256) {
276         uint256 c = a + b;
277         require(c >= a, "SafeMath: addition overflow");
278         return c;
279     }
280 
281     /**
282      * @dev Returns the subtraction of two unsigned integers, reverting on
283      * overflow (when the result is negative).
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         require(b <= a, "SafeMath: subtraction overflow");
293         return a - b;
294     }
295 
296     /**
297      * @dev Returns the multiplication of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      *
304      * - Multiplication cannot overflow.
305      */
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         if (a == 0) return 0;
308         uint256 c = a * b;
309         require(c / a == b, "SafeMath: multiplication overflow");
310         return c;
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers, reverting on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
326         require(b > 0, "SafeMath: division by zero");
327         return a / b;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         require(b > 0, "SafeMath: modulo by zero");
344         return a % b;
345     }
346 
347     /**
348      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
349      * overflow (when the result is negative).
350      *
351      * CAUTION: This function is deprecated because it requires allocating memory for the error
352      * message unnecessarily. For custom revert reasons use {trySub}.
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(
361         uint256 a,
362         uint256 b,
363         string memory errorMessage
364     ) internal pure returns (uint256) {
365         require(b <= a, errorMessage);
366         return a - b;
367     }
368 
369     /**
370      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
371      * division by zero. The result is rounded towards zero.
372      *
373      * CAUTION: This function is deprecated because it requires allocating memory for the error
374      * message unnecessarily. For custom revert reasons use {tryDiv}.
375      *
376      * Counterpart to Solidity's `/` operator. Note: this function uses a
377      * `revert` opcode (which leaves remaining gas untouched) while Solidity
378      * uses an invalid opcode to revert (consuming all remaining gas).
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function div(
385         uint256 a,
386         uint256 b,
387         string memory errorMessage
388     ) internal pure returns (uint256) {
389         require(b > 0, errorMessage);
390         return a / b;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * reverting with custom message when dividing by zero.
396      *
397      * CAUTION: This function is deprecated because it requires allocating memory for the error
398      * message unnecessarily. For custom revert reasons use {tryMod}.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         require(b > 0, errorMessage);
414         return a % b;
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
419 
420 pragma solidity 0.6.12;
421 
422 /**
423  * @dev Contract module that helps prevent reentrant calls to a function.
424  *
425  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
426  * available, which can be applied to functions to make sure there are no nested
427  * (reentrant) calls to them.
428  *
429  * Note that because there is a single `nonReentrant` guard, functions marked as
430  * `nonReentrant` may not call one another. This can be worked around by making
431  * those functions `private`, and then adding `external` `nonReentrant` entry
432  * points to them.
433  *
434  * TIP: If you would like to learn more about reentrancy and alternative ways
435  * to protect against it, check out our blog post
436  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
437  */
438 abstract contract ReentrancyGuard {
439     // Booleans are more expensive than uint256 or any type that takes up a full
440     // word because each write operation emits an extra SLOAD to first read the
441     // slot's contents, replace the bits taken up by the boolean, and then write
442     // back. This is the compiler's defense against contract upgrades and
443     // pointer aliasing, and it cannot be disabled.
444 
445     // The values being non-zero value makes deployment a bit more expensive,
446     // but in exchange the refund on every call to nonReentrant will be lower in
447     // amount. Since refunds are capped to a percentage of the total
448     // transaction's gas, it is best to keep them low in cases like this one, to
449     // increase the likelihood of the full refund coming into effect.
450     uint256 private constant _NOT_ENTERED = 1;
451     uint256 private constant _ENTERED = 2;
452 
453     uint256 private _status;
454 
455     constructor() internal {
456         _status = _NOT_ENTERED;
457     }
458 
459     /**
460      * @dev Prevents a contract from calling itself, directly or indirectly.
461      * Calling a `nonReentrant` function from another `nonReentrant`
462      * function is not supported. It is possible to prevent this from happening
463      * by making the `nonReentrant` function external, and make it call a
464      * `private` function that does the actual work.
465      */
466     modifier nonReentrant() {
467         // On the first call to nonReentrant, _notEntered will be true
468         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
469 
470         // Any calls to nonReentrant after this point will fail
471         _status = _ENTERED;
472 
473         _;
474 
475         // By storing the original value once again, a refund is triggered (see
476         // https://eips.ethereum.org/EIPS/eip-2200)
477         _status = _NOT_ENTERED;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Address.sol
482 
483 pragma solidity 0.6.12;
484 
485 /**
486  * @dev Collection of functions related to the address type
487  */
488 library Address {
489     /**
490      * @dev Returns true if `account` is a contract.
491      *
492      * [IMPORTANT]
493      * ====
494      * It is unsafe to assume that an address for which this function returns
495      * false is an externally-owned account (EOA) and not a contract.
496      *
497      * Among others, `isContract` will return false for the following
498      * types of addresses:
499      *
500      *  - an externally-owned account
501      *  - a contract in construction
502      *  - an address where a contract will be created
503      *  - an address where a contract lived, but was destroyed
504      * ====
505      */
506     function isContract(address account) internal view returns (bool) {
507         // This method relies on extcodesize, which returns 0 for contracts in
508         // construction, since the code is only stored at the end of the
509         // constructor execution.
510 
511         uint256 size;
512         // solhint-disable-next-line no-inline-assembly
513         assembly {
514             size := extcodesize(account)
515         }
516         return size > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
539         (bool success, ) = recipient.call{value: amount}("");
540         require(success, "Address: unable to send value, recipient may have reverted");
541     }
542 
543     /**
544      * @dev Performs a Solidity function call using a low level `call`. A
545      * plain`call` is an unsafe replacement for a function call: use this
546      * function instead.
547      *
548      * If `target` reverts with a revert reason, it is bubbled up by this
549      * function (like regular Solidity function calls).
550      *
551      * Returns the raw returned data. To convert to the expected return value,
552      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
553      *
554      * Requirements:
555      *
556      * - `target` must be a contract.
557      * - calling `target` with `data` must not revert.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionCall(target, data, "Address: low-level call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
567      * `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         return functionCallWithValue(target, data, 0, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but also transferring `value` wei to `target`.
582      *
583      * Requirements:
584      *
585      * - the calling contract must have an ETH balance of at least `value`.
586      * - the called Solidity function must be `payable`.
587      *
588      * _Available since v3.1._
589      */
590     function functionCallWithValue(
591         address target,
592         bytes memory data,
593         uint256 value
594     ) internal returns (bytes memory) {
595         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
600      * with `errorMessage` as a fallback revert reason when `target` reverts.
601      *
602      * _Available since v3.1._
603      */
604     function functionCallWithValue(
605         address target,
606         bytes memory data,
607         uint256 value,
608         string memory errorMessage
609     ) internal returns (bytes memory) {
610         require(address(this).balance >= value, "Address: insufficient balance for call");
611         require(isContract(target), "Address: call to non-contract");
612 
613         // solhint-disable-next-line avoid-low-level-calls
614         (bool success, bytes memory returndata) = target.call{value: value}(data);
615         return _verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
625         return functionStaticCall(target, data, "Address: low-level static call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal view returns (bytes memory) {
639         require(isContract(target), "Address: static call to non-contract");
640 
641         // solhint-disable-next-line avoid-low-level-calls
642         (bool success, bytes memory returndata) = target.staticcall(data);
643         return _verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but performing a delegate call.
649      *
650      * _Available since v3.4._
651      */
652     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
653         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(
663         address target,
664         bytes memory data,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(isContract(target), "Address: delegate call to non-contract");
668 
669         // solhint-disable-next-line avoid-low-level-calls
670         (bool success, bytes memory returndata) = target.delegatecall(data);
671         return _verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     function _verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) private pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685 
686                 // solhint-disable-next-line no-inline-assembly
687                 assembly {
688                     let returndata_size := mload(returndata)
689                     revert(add(32, returndata), returndata_size)
690                 }
691             } else {
692                 revert(errorMessage);
693             }
694         }
695     }
696 }
697 
698 // File: bsc-library/contracts/SafeBEP20.sol
699 
700 pragma solidity 0.6.12;
701 
702 /**
703  * @title SafeBEP20
704  * @dev Wrappers around BEP20 operations that throw on failure (when the token
705  * contract returns false). Tokens that return no value (and instead revert or
706  * throw on failure) are also supported, non-reverting calls are assumed to be
707  * successful.
708  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
709  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
710  */
711 library SafeERC20 {
712     using SafeMath for uint256;
713     using Address for address;
714 
715     function safeTransfer(
716         IERC20 token,
717         address to,
718         uint256 value
719     ) internal {
720         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
721     }
722 
723     function safeTransferFrom(
724         IERC20 token,
725         address from,
726         address to,
727         uint256 value
728     ) internal {
729         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
730     }
731 
732     /**
733      * @dev Deprecated. This function has issues similar to the ones found in
734      * {IERC20-approve}, and its usage is discouraged.
735      *
736      * Whenever possible, use {safeIncreaseAllowance} and
737      * {safeDecreaseAllowance} instead.
738      */
739     function safeApprove(
740         IERC20 token,
741         address spender,
742         uint256 value
743     ) internal {
744         // safeApprove should only be called when setting an initial allowance,
745         // or when resetting it to zero. To increase and decrease it, use
746         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
747         // solhint-disable-next-line max-line-length
748         require(
749             (value == 0) || (token.allowance(address(this), spender) == 0),
750             "SafeERC20: approve from non-zero to non-zero allowance"
751         );
752         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
753     }
754 
755     function safeIncreaseAllowance(
756         IERC20 token,
757         address spender,
758         uint256 value
759     ) internal {
760         uint256 newAllowance = token.allowance(address(this), spender).add(value);
761         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
762     }
763 
764     function safeDecreaseAllowance(
765         IERC20 token,
766         address spender,
767         uint256 value
768     ) internal {
769         uint256 newAllowance =
770         token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
771         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
772     }
773 
774     /**
775      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
776      * on the return value: the return value is optional (but if data is returned, it must not be false).
777      * @param token The token targeted by the call.
778      * @param data The call data (encoded using abi.encode or one of its variants).
779      */
780     function _callOptionalReturn(IERC20 token, bytes memory data) private {
781         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
782         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
783         // the target address contains contract code and also asserts for success in the low-level call.
784 
785         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
786         if (returndata.length > 0) {
787             // Return data is optional
788             // solhint-disable-next-line max-line-length
789             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
790         }
791     }
792 }
793 
794 // File: contracts/SmartChefInitializable.sol
795 
796 pragma solidity 0.6.12;
797 
798 contract SmartChefInitializable is Ownable, ReentrancyGuard {
799     using SafeMath for uint256;
800     using SafeERC20 for IERC20;
801 
802     uint256 public lockTime; // 432,000 blocks = 15 days;
803     uint256 public endLockTime;
804 
805     // The address of the smart chef factory
806     address public SMART_CHEF_FACTORY;
807 
808     // Whether a limit is set for users
809     bool public hasUserLimit;
810 
811     // Whether it is initialized
812     bool public isInitialized;
813 
814     // Accrued token per share
815     uint256 public accTokenPerShare;
816 
817     // The block number when SOKU mining ends.
818     uint256 public bonusEndBlock;
819 
820     // The block number when SOKU mining starts.
821     uint256 public startBlock;
822 
823     // The block number of the last pool update
824     uint256 public lastRewardBlock;
825 
826     // The pool limit (0 if none)
827     uint256 public poolLimitPerUser;
828 
829     // SOKU tokens created per block.
830     uint256 public rewardPerBlock;
831 
832     // The precision factor
833     uint256 public PRECISION_FACTOR;
834 
835     // The reward token
836     IERC20 public rewardToken;
837 
838     // The staked token
839     IERC20 public stakedToken;
840 
841     // Info of each user that stakes tokens (stakedToken)
842     mapping(address => UserInfo) public userInfo;
843 
844     mapping(address => uint256) public addressEndLockTime;
845 
846     bool public hasSavedPendingRewardUpdatedByAdmin = true;
847     bool public hasAllRewardDistributedByAdmin = true;
848 
849     uint public numberOfClaimSavedPendingReward;
850     uint public numberOfClaimCurrentAndTotalPendingReward;
851 
852     mapping(address => uint256) public temporaryPendingReward;
853 
854     struct UserInfo {
855         uint256 amount; // How many staked tokens the user has provided
856         uint256 rewardDebt; // Reward debt
857     }
858 
859     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
860     event Deposit(address indexed user, uint256 amount);
861     event ClaimReward(address indexed user, uint256 amount);
862     event EmergencyWithdraw(address indexed user, uint256 amount);
863     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
864     event NewRewardPerBlock(uint256 rewardPerBlock);
865     event NewPoolLimit(uint256 poolLimitPerUser);
866     event Withdraw(address indexed user, uint256 amount);
867 
868     constructor() public {
869         SMART_CHEF_FACTORY = msg.sender;
870     }
871 
872     /*
873      * @notice Initialize the contract
874      * @param _stakedToken: staked token address
875      * @param _rewardToken: reward token address
876      * @param _rewardPerBlock: reward per block (in rewardToken)
877      * @param _startBlock: start block
878      * @param _bonusEndBlock: end block
879      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
880      * @param _admin: admin address with ownership
881      */
882     function initialize(
883         IERC20 _stakedToken,
884         IERC20 _rewardToken,
885         uint256 _rewardPerBlock,
886         uint256 _startBlock,
887         uint256 _bonusEndBlock,
888         uint256 _lockTime,
889         uint256 _poolLimitPerUser,
890         address _admin
891     ) external {
892         require(!isInitialized, "Already initialized");
893         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
894 
895         // Make this contract initialized
896         isInitialized = true;
897 
898         stakedToken = _stakedToken;
899         rewardToken = _rewardToken;
900         rewardPerBlock = _rewardPerBlock;
901         startBlock = _startBlock;
902         bonusEndBlock = _bonusEndBlock;
903         lockTime = _lockTime;
904         endLockTime = block.number.add(lockTime);
905 
906 
907 
908         if (_poolLimitPerUser > 0) {
909             hasUserLimit = true;
910             poolLimitPerUser = _poolLimitPerUser;
911         }
912 
913         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
914         require(decimalsRewardToken < 30, "Must be inferior to 30");
915 
916         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
917 
918         // Set the lastRewardBlock as the startBlock
919         lastRewardBlock = startBlock;
920 
921         // Transfer ownership to the admin address who becomes owner of the contract
922         transferOwnership(_admin);
923     }
924 
925     /*
926      * @notice Deposit staked tokens and collect reward tokens (if any)
927      * @param _amount: amount to withdraw (in rewardToken)
928      */
929     function deposit(uint256 _amount) external nonReentrant {
930 
931         UserInfo storage user = userInfo[msg.sender];
932 
933         if (hasUserLimit) {
934             require(_amount.add(user.amount) <= poolLimitPerUser, "User amount above limit");
935         }
936         _updatePool();
937 
938         if (_amount > 0) {
939             user.amount = user.amount.add(_amount);
940             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
941         }
942 
943         user.rewardDebt = user.rewardDebt.add(_amount.mul(accTokenPerShare).div(PRECISION_FACTOR));
944 
945 
946         emit Deposit(msg.sender, _amount);
947         _resetAddressEndLockTime();
948 
949     }
950 
951     function claimReward() external {
952         _claimReward(msg.sender);
953     }
954 
955 
956     /*
957      * @notice Withdraw staked tokens and collect reward tokens
958      * @param _amount: amount to withdraw (in rewardToken)
959      */
960     function withdraw(uint256 _amount) external nonReentrant {
961         uint256 localAddressEndLockTime;
962 
963         if(addressEndLockTime[msg.sender] == 0) {
964             localAddressEndLockTime = endLockTime;
965         } else {
966             localAddressEndLockTime = addressEndLockTime[msg.sender];
967         }
968 
969         require(block.number >= localAddressEndLockTime || block.number >= bonusEndBlock, "Lock still in affect, or pool has not ended yet.");
970 
971         UserInfo storage user = userInfo[msg.sender];
972         require(user.amount >= _amount, "Amount to withdraw too high");
973 
974         _updatePool();
975 
976         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
977 
978         if (_amount > 0) {
979             user.amount = user.amount.sub(_amount);
980             stakedToken.safeTransfer(address(msg.sender), _amount);
981         }
982 
983         if (pending > 0) {
984             rewardToken.safeTransfer(address(msg.sender), pending);
985         }
986 
987         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
988 
989         emit Withdraw(msg.sender, _amount);
990     }
991 
992     /*
993      * @notice Withdraw staked tokens without caring about reward reward
994      * @dev Needs to be for emergency.
995      */
996     function emergencyWithdraw() external nonReentrant {
997         UserInfo storage user = userInfo[msg.sender];
998         uint256 amountToTransfer = user.amount;
999         user.amount = 0;
1000         user.rewardDebt = 0;
1001 
1002         if (amountToTransfer > 0) {
1003             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
1004         }
1005 
1006         emit EmergencyWithdraw(msg.sender, user.amount);
1007     }
1008 
1009     /*
1010      * @notice Stop reward
1011      * @dev Only callable by owner. Needs to be for emergency.
1012      */
1013     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1014         rewardToken.safeTransfer(address(msg.sender), _amount);
1015     }
1016 
1017     /**
1018      * @notice It allows the admin to recover wrong tokens sent to the contract
1019      * @param _tokenAddress: the address of the token to withdraw
1020      * @param _tokenAmount: the number of tokens to withdraw
1021      * @dev This function is only callable by admin.
1022      */
1023     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1024         // require(_tokenAddress != address(stakedToken), "Cannot be staked token");
1025         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
1026         IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1027 
1028         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1029     }
1030 
1031     /*
1032      * @notice Stop reward
1033      * @dev Only callable by owner
1034      */
1035     function stopReward() external onlyOwner {
1036         bonusEndBlock = block.number;
1037     }
1038 
1039     /*
1040      * @notice Update pool limit per user
1041      * @dev Only callable by owner.
1042      * @param _hasUserLimit: whether the limit remains forced
1043      * @param _poolLimitPerUser: new pool limit per user
1044      */
1045     function updatePoolLimitPerUser(bool _hasUserLimit, uint256 _poolLimitPerUser) external onlyOwner {
1046         require(hasUserLimit, "Must be set");
1047         if (_hasUserLimit) {
1048             require(_poolLimitPerUser > poolLimitPerUser, "New limit must be higher");
1049             poolLimitPerUser = _poolLimitPerUser;
1050         } else {
1051             hasUserLimit = _hasUserLimit;
1052             poolLimitPerUser = 0;
1053         }
1054         emit NewPoolLimit(poolLimitPerUser);
1055     }
1056 
1057     /*
1058      * @notice Update reward per block
1059      * @dev Only callable by owner.
1060      * @param _rewardPerBlock: the reward per block
1061      */
1062 
1063     //  ** When updating rewardPerBlock, claim every users tokens ** //
1064     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1065         _updatePool();
1066         rewardPerBlock = _rewardPerBlock;
1067         emit NewRewardPerBlock(_rewardPerBlock);
1068     }
1069 
1070     /**
1071      * @notice It allows the admin to update start and end blocks
1072      * @dev This function is only callable by owner.
1073      * @param _startBlock: the new start block
1074      * @param _bonusEndBlock: the new end block
1075      */
1076     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
1077         require(block.number < startBlock, "Pool has started");
1078         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
1079         require(block.number < _startBlock, "New startBlock must be higher than current block");
1080 
1081         startBlock = _startBlock;
1082         bonusEndBlock = _bonusEndBlock;
1083 
1084         // Set the lastRewardBlock as the startBlock
1085         lastRewardBlock = startBlock;
1086 
1087         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1088     }
1089 
1090     /*
1091      * @notice View function to see pending reward on frontend.
1092      * @param _user: user address
1093      * @return Pending reward for a given user
1094      */
1095     function pendingReward(address _user) public view returns (uint256) {
1096         UserInfo storage user = userInfo[_user];
1097         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1098         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1099             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1100             uint256 SOKUReward = multiplier.mul(rewardPerBlock);
1101             uint256 adjustedTokenPerShare =
1102             accTokenPerShare.add(SOKUReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1103             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1104         } else {
1105             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1106         }
1107     }
1108 
1109     function getRemainingLockTime(address _user) external view returns (uint256) {
1110         if (addressEndLockTime[_user] < block.number) {
1111             return 0;
1112         }
1113         return addressEndLockTime[_user] - block.number;
1114     }
1115 
1116     function _resetAddressEndLockTime() internal {
1117         addressEndLockTime[msg.sender] = block.number.add(lockTime);
1118     }
1119 
1120     /*
1121      * @notice Update reward variables of the given pool to be up-to-date.
1122      */
1123     function _updatePool() internal {
1124         if (block.number <= lastRewardBlock) {
1125             return;
1126         }
1127 
1128         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1129 
1130         if (stakedTokenSupply == 0) {
1131             lastRewardBlock = block.number;
1132             return;
1133         }
1134 
1135         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1136         uint256 SOKUReward = multiplier.mul(rewardPerBlock);
1137         accTokenPerShare = accTokenPerShare.add(SOKUReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1138         lastRewardBlock = block.number;
1139     }
1140 
1141     /*
1142      * @notice Return reward multiplier over the given _from to _to block.
1143      * @param _from: block to start
1144      * @param _to: block to finish
1145      */
1146     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1147         if (_to <= bonusEndBlock) {
1148             return _to.sub(_from);
1149         } else if (_from >= bonusEndBlock) {
1150             return 0;
1151         } else {
1152             return bonusEndBlock.sub(_from);
1153         }
1154     }
1155 
1156     function _claimReward(address _user) internal {
1157         UserInfo storage user = userInfo[_user];
1158 
1159         _updatePool();
1160 
1161         if (user.amount > 0) {
1162             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1163             if (pending > 0) {
1164 
1165                 uint256 localAddressEndLockTime;
1166 
1167                 if (addressEndLockTime[_user] == 0) {
1168                     localAddressEndLockTime = endLockTime;
1169                 } else {
1170                     localAddressEndLockTime = addressEndLockTime[_user];
1171                 }
1172 
1173                 // If the lock time (i.e. 15 days) has passed or pool has ended
1174                 require(block.number >= localAddressEndLockTime || block.number >= bonusEndBlock, "Lock time has not expired, or the pool has not ended yet.");
1175                 rewardToken.safeTransfer(address(_user), pending);
1176             }
1177 
1178             user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
1179             emit ClaimReward(_user, pending);
1180         }
1181     }
1182 }