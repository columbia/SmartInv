1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-13
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.6.12;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 pragma solidity 0.6.12;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 pragma solidity 0.6.12;
101 
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     /**
109      * @dev Returns the token decimals.
110      */
111     function decimals() external view returns (uint8);
112 
113     /**
114      * @dev Returns the token symbol.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the token name.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the erc token owner.
125      */
126     function getOwner() external view returns (address);
127 
128     /**
129      * @dev Returns the amount of tokens owned by `account`.
130      */
131     function balanceOf(address account) external view returns (uint256);
132 
133     /**
134      * @dev Moves `amount` tokens from the caller's account to `recipient`.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transfer(address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address _owner, address spender) external view returns (uint256);
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
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 // File: @openzeppelin/contracts/math/SafeMath.sol
198 
199 pragma solidity 0.6.12;
200 
201 /**
202  * @dev Wrappers over Solidity's arithmetic operations with added overflow
203  * checks.
204  *
205  * Arithmetic operations in Solidity wrap on overflow. This can easily result
206  * in bugs, because programmers usually assume that an overflow raises an
207  * error, which is the standard behavior in high level programming languages.
208  * `SafeMath` restores this intuition by reverting the transaction when an
209  * operation overflows.
210  *
211  * Using this library instead of the unchecked operations eliminates an entire
212  * class of bugs, so it's recommended to use it always.
213  */
214 library SafeMath {
215     /**
216      * @dev Returns the addition of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         uint256 c = a + b;
222         if (c < a) return (false, 0);
223         return (true, c);
224     }
225 
226     /**
227      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
228      *
229      * _Available since v3.4._
230      */
231     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         if (b > a) return (false, 0);
233         return (true, a - b);
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) return (true, 0);
246         uint256 c = a * b;
247         if (c / a != b) return (false, 0);
248         return (true, c);
249     }
250 
251     /**
252      * @dev Returns the division of two unsigned integers, with a division by zero flag.
253      *
254      * _Available since v3.4._
255      */
256     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         if (b == 0) return (false, 0);
258         return (true, a / b);
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
263      *
264      * _Available since v3.4._
265      */
266     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         if (b == 0) return (false, 0);
268         return (true, a % b);
269     }
270 
271     /**
272      * @dev Returns the addition of two unsigned integers, reverting on
273      * overflow.
274      *
275      * Counterpart to Solidity's `+` operator.
276      *
277      * Requirements:
278      *
279      * - Addition cannot overflow.
280      */
281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
282         uint256 c = a + b;
283         require(c >= a, "SafeMath: addition overflow");
284         return c;
285     }
286 
287     /**
288      * @dev Returns the subtraction of two unsigned integers, reverting on
289      * overflow (when the result is negative).
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
298         require(b <= a, "SafeMath: subtraction overflow");
299         return a - b;
300     }
301 
302     /**
303      * @dev Returns the multiplication of two unsigned integers, reverting on
304      * overflow.
305      *
306      * Counterpart to Solidity's `*` operator.
307      *
308      * Requirements:
309      *
310      * - Multiplication cannot overflow.
311      */
312     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
313         if (a == 0) return 0;
314         uint256 c = a * b;
315         require(c / a == b, "SafeMath: multiplication overflow");
316         return c;
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers, reverting on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         require(b > 0, "SafeMath: division by zero");
333         return a / b;
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * reverting when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
349         require(b > 0, "SafeMath: modulo by zero");
350         return a % b;
351     }
352 
353     /**
354      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
355      * overflow (when the result is negative).
356      *
357      * CAUTION: This function is deprecated because it requires allocating memory for the error
358      * message unnecessarily. For custom revert reasons use {trySub}.
359      *
360      * Counterpart to Solidity's `-` operator.
361      *
362      * Requirements:
363      *
364      * - Subtraction cannot overflow.
365      */
366     function sub(
367         uint256 a,
368         uint256 b,
369         string memory errorMessage
370     ) internal pure returns (uint256) {
371         require(b <= a, errorMessage);
372         return a - b;
373     }
374 
375     /**
376      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
377      * division by zero. The result is rounded towards zero.
378      *
379      * CAUTION: This function is deprecated because it requires allocating memory for the error
380      * message unnecessarily. For custom revert reasons use {tryDiv}.
381      *
382      * Counterpart to Solidity's `/` operator. Note: this function uses a
383      * `revert` opcode (which leaves remaining gas untouched) while Solidity
384      * uses an invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         require(b > 0, errorMessage);
396         return a / b;
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
401      * reverting with custom message when dividing by zero.
402      *
403      * CAUTION: This function is deprecated because it requires allocating memory for the error
404      * message unnecessarily. For custom revert reasons use {tryMod}.
405      *
406      * Counterpart to Solidity's `%` operator. This function uses a `revert`
407      * opcode (which leaves remaining gas untouched) while Solidity uses an
408      * invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function mod(
415         uint256 a,
416         uint256 b,
417         string memory errorMessage
418     ) internal pure returns (uint256) {
419         require(b > 0, errorMessage);
420         return a % b;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
425 
426 pragma solidity 0.6.12;
427 
428 /**
429  * @dev Contract module that helps prevent reentrant calls to a function.
430  *
431  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
432  * available, which can be applied to functions to make sure there are no nested
433  * (reentrant) calls to them.
434  *
435  * Note that because there is a single `nonReentrant` guard, functions marked as
436  * `nonReentrant` may not call one another. This can be worked around by making
437  * those functions `private`, and then adding `external` `nonReentrant` entry
438  * points to them.
439  *
440  * TIP: If you would like to learn more about reentrancy and alternative ways
441  * to protect against it, check out our blog post
442  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
443  */
444 abstract contract ReentrancyGuard {
445     // Booleans are more expensive than uint256 or any type that takes up a full
446     // word because each write operation emits an extra SLOAD to first read the
447     // slot's contents, replace the bits taken up by the boolean, and then write
448     // back. This is the compiler's defense against contract upgrades and
449     // pointer aliasing, and it cannot be disabled.
450 
451     // The values being non-zero value makes deployment a bit more expensive,
452     // but in exchange the refund on every call to nonReentrant will be lower in
453     // amount. Since refunds are capped to a percentage of the total
454     // transaction's gas, it is best to keep them low in cases like this one, to
455     // increase the likelihood of the full refund coming into effect.
456     uint256 private constant _NOT_ENTERED = 1;
457     uint256 private constant _ENTERED = 2;
458 
459     uint256 private _status;
460 
461     constructor() internal {
462         _status = _NOT_ENTERED;
463     }
464 
465     /**
466      * @dev Prevents a contract from calling itself, directly or indirectly.
467      * Calling a `nonReentrant` function from another `nonReentrant`
468      * function is not supported. It is possible to prevent this from happening
469      * by making the `nonReentrant` function external, and make it call a
470      * `private` function that does the actual work.
471      */
472     modifier nonReentrant() {
473         // On the first call to nonReentrant, _notEntered will be true
474         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
475 
476         // Any calls to nonReentrant after this point will fail
477         _status = _ENTERED;
478 
479         _;
480 
481         // By storing the original value once again, a refund is triggered (see
482         // https://eips.ethereum.org/EIPS/eip-2200)
483         _status = _NOT_ENTERED;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/utils/Address.sol
488 
489 pragma solidity 0.6.12;
490 
491 /**
492  * @dev Collection of functions related to the address type
493  */
494 library Address {
495     /**
496      * @dev Returns true if `account` is a contract.
497      *
498      * [IMPORTANT]
499      * ====
500      * It is unsafe to assume that an address for which this function returns
501      * false is an externally-owned account (EOA) and not a contract.
502      *
503      * Among others, `isContract` will return false for the following
504      * types of addresses:
505      *
506      *  - an externally-owned account
507      *  - a contract in construction
508      *  - an address where a contract will be created
509      *  - an address where a contract lived, but was destroyed
510      * ====
511      */
512     function isContract(address account) internal view returns (bool) {
513         // This method relies on extcodesize, which returns 0 for contracts in
514         // construction, since the code is only stored at the end of the
515         // constructor execution.
516 
517         uint256 size;
518         // solhint-disable-next-line no-inline-assembly
519         assembly {
520             size := extcodesize(account)
521         }
522         return size > 0;
523     }
524 
525     /**
526      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
527      * `recipient`, forwarding all available gas and reverting on errors.
528      *
529      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
530      * of certain opcodes, possibly making contracts go over the 2300 gas limit
531      * imposed by `transfer`, making them unable to receive funds via
532      * `transfer`. {sendValue} removes this limitation.
533      *
534      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
535      *
536      * IMPORTANT: because control is transferred to `recipient`, care must be
537      * taken to not create reentrancy vulnerabilities. Consider using
538      * {ReentrancyGuard} or the
539      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
540      */
541     function sendValue(address payable recipient, uint256 amount) internal {
542         require(address(this).balance >= amount, "Address: insufficient balance");
543 
544         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
545         (bool success, ) = recipient.call{value: amount}("");
546         require(success, "Address: unable to send value, recipient may have reverted");
547     }
548 
549     /**
550      * @dev Performs a Solidity function call using a low level `call`. A
551      * plain`call` is an unsafe replacement for a function call: use this
552      * function instead.
553      *
554      * If `target` reverts with a revert reason, it is bubbled up by this
555      * function (like regular Solidity function calls).
556      *
557      * Returns the raw returned data. To convert to the expected return value,
558      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
559      *
560      * Requirements:
561      *
562      * - `target` must be a contract.
563      * - calling `target` with `data` must not revert.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionCall(target, data, "Address: low-level call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
573      * `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         return functionCallWithValue(target, data, 0, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but also transferring `value` wei to `target`.
588      *
589      * Requirements:
590      *
591      * - the calling contract must have an ETH balance of at least `value`.
592      * - the called Solidity function must be `payable`.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(
597         address target,
598         bytes memory data,
599         uint256 value
600     ) internal returns (bytes memory) {
601         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
606      * with `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(
611         address target,
612         bytes memory data,
613         uint256 value,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(address(this).balance >= value, "Address: insufficient balance for call");
617         require(isContract(target), "Address: call to non-contract");
618 
619         // solhint-disable-next-line avoid-low-level-calls
620         (bool success, bytes memory returndata) = target.call{value: value}(data);
621         return _verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
631         return functionStaticCall(target, data, "Address: low-level static call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal view returns (bytes memory) {
645         require(isContract(target), "Address: static call to non-contract");
646 
647         // solhint-disable-next-line avoid-low-level-calls
648         (bool success, bytes memory returndata) = target.staticcall(data);
649         return _verifyCallResult(success, returndata, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
659         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
664      * but performing a delegate call.
665      *
666      * _Available since v3.4._
667      */
668     function functionDelegateCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal returns (bytes memory) {
673         require(isContract(target), "Address: delegate call to non-contract");
674 
675         // solhint-disable-next-line avoid-low-level-calls
676         (bool success, bytes memory returndata) = target.delegatecall(data);
677         return _verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     function _verifyCallResult(
681         bool success,
682         bytes memory returndata,
683         string memory errorMessage
684     ) private pure returns (bytes memory) {
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 // solhint-disable-next-line no-inline-assembly
693                 assembly {
694                     let returndata_size := mload(returndata)
695                     revert(add(32, returndata), returndata_size)
696                 }
697             } else {
698                 revert(errorMessage);
699             }
700         }
701     }
702 }
703 
704 // File: bsc-library/contracts/SafeBEP20.sol
705 
706 pragma solidity 0.6.12;
707 
708 /**
709  * @title SafeBEP20
710  * @dev Wrappers around BEP20 operations that throw on failure (when the token
711  * contract returns false). Tokens that return no value (and instead revert or
712  * throw on failure) are also supported, non-reverting calls are assumed to be
713  * successful.
714  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
715  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
716  */
717 library SafeERC20 {
718     using SafeMath for uint256;
719     using Address for address;
720 
721     function safeTransfer(
722         IERC20 token,
723         address to,
724         uint256 value
725     ) internal {
726         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
727     }
728 
729     function safeTransferFrom(
730         IERC20 token,
731         address from,
732         address to,
733         uint256 value
734     ) internal {
735         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
736     }
737 
738     /**
739      * @dev Deprecated. This function has issues similar to the ones found in
740      * {IERC20-approve}, and its usage is discouraged.
741      *
742      * Whenever possible, use {safeIncreaseAllowance} and
743      * {safeDecreaseAllowance} instead.
744      */
745     function safeApprove(
746         IERC20 token,
747         address spender,
748         uint256 value
749     ) internal {
750         // safeApprove should only be called when setting an initial allowance,
751         // or when resetting it to zero. To increase and decrease it, use
752         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
753         // solhint-disable-next-line max-line-length
754         require(
755             (value == 0) || (token.allowance(address(this), spender) == 0),
756             "SafeERC20: approve from non-zero to non-zero allowance"
757         );
758         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
759     }
760 
761     function safeIncreaseAllowance(
762         IERC20 token,
763         address spender,
764         uint256 value
765     ) internal {
766         uint256 newAllowance = token.allowance(address(this), spender).add(value);
767         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
768     }
769 
770     function safeDecreaseAllowance(
771         IERC20 token,
772         address spender,
773         uint256 value
774     ) internal {
775         uint256 newAllowance =
776         token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
777         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
778     }
779 
780     /**
781      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
782      * on the return value: the return value is optional (but if data is returned, it must not be false).
783      * @param token The token targeted by the call.
784      * @param data The call data (encoded using abi.encode or one of its variants).
785      */
786     function _callOptionalReturn(IERC20 token, bytes memory data) private {
787         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
788         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
789         // the target address contains contract code and also asserts for success in the low-level call.
790 
791         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
792         if (returndata.length > 0) {
793             // Return data is optional
794             // solhint-disable-next-line max-line-length
795             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
796         }
797     }
798 }
799 
800 // File: contracts/SmartChefInitializable.sol
801 
802 pragma solidity 0.6.12;
803 
804 contract SmartChefInitializable is Ownable, ReentrancyGuard {
805     using SafeMath for uint256;
806     using SafeERC20 for IERC20;
807 
808     uint256 public lockTime; // 432,000 blocks = 15 days;
809     uint256 public endLockTime;
810 
811     // The address of the smart chef factory
812     address public SMART_CHEF_FACTORY;
813 
814     // Whether a limit is set for users
815     bool public hasUserLimit;
816 
817     // Whether it is initialized
818     bool public isInitialized;
819 
820     // Accrued token per share
821     uint256 public accTokenPerShare;
822 
823     // The block number when SOKU mining ends.
824     uint256 public bonusEndBlock;
825 
826     // The block number when SOKU mining starts.
827     uint256 public startBlock;
828 
829     // The block number of the last pool update
830     uint256 public lastRewardBlock;
831 
832     // The pool limit (0 if none)
833     uint256 public poolLimitPerUser;
834 
835     // SOKU tokens created per block.
836     uint256 public rewardPerBlock;
837 
838     // The precision factor
839     uint256 public PRECISION_FACTOR;
840 
841     // The reward token
842     IERC20 public rewardToken;
843 
844     // The staked token
845     IERC20 public stakedToken;
846 
847     // Info of each user that stakes tokens (stakedToken)
848     mapping(address => UserInfo) public userInfo;
849 
850     mapping(address => uint256) public addressEndLockTime;
851 
852     bool public hasSavedPendingRewardUpdatedByAdmin = true;
853     bool public hasAllRewardDistributedByAdmin = true;
854 
855     uint public numberOfClaimSavedPendingReward;
856     uint public numberOfClaimCurrentAndTotalPendingReward;
857 
858     mapping(address => uint256) public temporaryPendingReward;
859 
860     struct UserInfo {
861         uint256 amount; // How many staked tokens the user has provided
862         uint256 rewardDebt; // Reward debt
863     }
864 
865     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
866     event Deposit(address indexed user, uint256 amount);
867     event ClaimReward(address indexed user, uint256 amount);
868     event EmergencyWithdraw(address indexed user, uint256 amount);
869     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
870     event NewRewardPerBlock(uint256 rewardPerBlock);
871     event NewPoolLimit(uint256 poolLimitPerUser);
872     event Withdraw(address indexed user, uint256 amount);
873 
874     constructor() public {
875         SMART_CHEF_FACTORY = msg.sender;
876     }
877 
878     /*
879      * @notice Initialize the contract
880      * @param _stakedToken: staked token address
881      * @param _rewardToken: reward token address
882      * @param _rewardPerBlock: reward per block (in rewardToken)
883      * @param _startBlock: start block
884      * @param _bonusEndBlock: end block
885      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
886      * @param _admin: admin address with ownership
887      */
888     function initialize(
889         IERC20 _stakedToken,
890         IERC20 _rewardToken,
891         uint256 _rewardPerBlock,
892         uint256 _startBlock,
893         uint256 _bonusEndBlock,
894         uint256 _lockTime,
895         uint256 _poolLimitPerUser,
896         address _admin
897     ) external {
898         require(!isInitialized, "Already initialized");
899         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
900 
901         // Make this contract initialized
902         isInitialized = true;
903 
904         stakedToken = _stakedToken;
905         rewardToken = _rewardToken;
906         rewardPerBlock = _rewardPerBlock;
907         startBlock = _startBlock;
908         bonusEndBlock = _bonusEndBlock;
909         lockTime = _lockTime;
910         endLockTime = block.number.add(lockTime);
911 
912 
913 
914         if (_poolLimitPerUser > 0) {
915             hasUserLimit = true;
916             poolLimitPerUser = _poolLimitPerUser;
917         }
918 
919         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
920         require(decimalsRewardToken < 30, "Must be inferior to 30");
921 
922         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
923 
924         // Set the lastRewardBlock as the startBlock
925         lastRewardBlock = startBlock;
926 
927         // Transfer ownership to the admin address who becomes owner of the contract
928         transferOwnership(_admin);
929     }
930 
931     /*
932      * @notice Deposit staked tokens and collect reward tokens (if any)
933      * @param _amount: amount to withdraw (in rewardToken)
934      */
935     function deposit(uint256 _amount) external nonReentrant {
936 
937             UserInfo storage user = userInfo[msg.sender];
938             uint256 balanceDiff = 0;
939 
940             if (hasUserLimit) {
941                 require(_amount.add(user.amount) <= poolLimitPerUser, "User amount above limit");
942             }
943             _updatePool();
944 
945             if (_amount > 0) {
946                 uint256 balanceBefore = stakedToken.balanceOf(address(this));
947                 stakedToken.transferFrom(msg.sender, address(this), _amount);
948                 uint256 balanceAfter = stakedToken.balanceOf(address(this));
949                 balanceDiff = balanceAfter - balanceBefore;
950 
951                 user.amount = user.amount.add(balanceDiff);
952             }
953 
954             user.rewardDebt = user.rewardDebt.add(balanceDiff.mul(accTokenPerShare).div(PRECISION_FACTOR));
955 
956 
957             emit Deposit(msg.sender, balanceDiff);
958             _resetAddressEndLockTime();
959 
960         }
961 
962     function claimReward() external {
963         _claimReward(msg.sender);
964     }
965 
966 
967     /*
968      * @notice Withdraw staked tokens and collect reward tokens
969      * @param _amount: amount to withdraw (in rewardToken)
970      */
971     function withdraw(uint256 _amount) external nonReentrant {
972         uint256 localAddressEndLockTime;
973 
974         if(addressEndLockTime[msg.sender] == 0) {
975             localAddressEndLockTime = endLockTime;
976         } else {
977             localAddressEndLockTime = addressEndLockTime[msg.sender];
978         }
979 
980         require(block.number >= localAddressEndLockTime || block.number >= bonusEndBlock, "Lock still in affect, or pool has not ended yet.");
981 
982         UserInfo storage user = userInfo[msg.sender];
983         require(user.amount >= _amount, "Amount to withdraw too high");
984 
985         _updatePool();
986 
987         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
988 
989         if (_amount > 0) {
990             user.amount = user.amount.sub(_amount);
991             stakedToken.safeTransfer(address(msg.sender), _amount);
992         }
993 
994         if (pending > 0) {
995             rewardToken.safeTransfer(address(msg.sender), pending);
996         }
997 
998         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
999 
1000         emit Withdraw(msg.sender, _amount);
1001     }
1002 
1003     /*
1004      * @notice Withdraw staked tokens without caring about reward reward
1005      * @dev Needs to be for emergency.
1006      */
1007     function emergencyWithdraw() external nonReentrant {
1008         UserInfo storage user = userInfo[msg.sender];
1009         uint256 amountToTransfer = user.amount;
1010         user.amount = 0;
1011         user.rewardDebt = 0;
1012 
1013         if (amountToTransfer > 0) {
1014             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
1015         }
1016 
1017         emit EmergencyWithdraw(msg.sender, user.amount);
1018     }
1019 
1020     /*
1021      * @notice Stop reward
1022      * @dev Only callable by owner. Needs to be for emergency.
1023      */
1024     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1025         rewardToken.safeTransfer(address(msg.sender), _amount);
1026     }
1027 
1028     /**
1029      * @notice It allows the admin to recover wrong tokens sent to the contract
1030      * @param _tokenAddress: the address of the token to withdraw
1031      * @param _tokenAmount: the number of tokens to withdraw
1032      * @dev This function is only callable by admin.
1033      */
1034     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1035         // require(_tokenAddress != address(stakedToken), "Cannot be staked token");
1036         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
1037         IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1038 
1039         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1040     }
1041 
1042     /*
1043      * @notice Stop reward
1044      * @dev Only callable by owner
1045      */
1046     function stopReward() external onlyOwner {
1047         bonusEndBlock = block.number;
1048     }
1049 
1050     /*
1051      * @notice Update pool limit per user
1052      * @dev Only callable by owner.
1053      * @param _hasUserLimit: whether the limit remains forced
1054      * @param _poolLimitPerUser: new pool limit per user
1055      */
1056     function updatePoolLimitPerUser(bool _hasUserLimit, uint256 _poolLimitPerUser) external onlyOwner {
1057         require(hasUserLimit, "Must be set");
1058         if (_hasUserLimit) {
1059             require(_poolLimitPerUser > poolLimitPerUser, "New limit must be higher");
1060             poolLimitPerUser = _poolLimitPerUser;
1061         } else {
1062             hasUserLimit = _hasUserLimit;
1063             poolLimitPerUser = 0;
1064         }
1065         emit NewPoolLimit(poolLimitPerUser);
1066     }
1067 
1068     /*
1069      * @notice Update reward per block
1070      * @dev Only callable by owner.
1071      * @param _rewardPerBlock: the reward per block
1072      */
1073 
1074     //  ** When updating rewardPerBlock, claim every users tokens ** //
1075     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1076         _updatePool();
1077         rewardPerBlock = _rewardPerBlock;
1078         emit NewRewardPerBlock(_rewardPerBlock);
1079     }
1080 
1081     /**
1082      * @notice It allows the admin to update start and end blocks
1083      * @dev This function is only callable by owner.
1084      * @param _startBlock: the new start block
1085      * @param _bonusEndBlock: the new end block
1086      */
1087     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
1088         require(block.number < startBlock, "Pool has started");
1089         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
1090         require(block.number < _startBlock, "New startBlock must be higher than current block");
1091 
1092         startBlock = _startBlock;
1093         bonusEndBlock = _bonusEndBlock;
1094 
1095         // Set the lastRewardBlock as the startBlock
1096         lastRewardBlock = startBlock;
1097 
1098         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1099     }
1100 
1101     /*
1102      * @notice View function to see pending reward on frontend.
1103      * @param _user: user address
1104      * @return Pending reward for a given user
1105      */
1106     function pendingReward(address _user) public view returns (uint256) {
1107         UserInfo storage user = userInfo[_user];
1108         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1109         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1110             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1111             uint256 SOKUReward = multiplier.mul(rewardPerBlock);
1112             uint256 adjustedTokenPerShare =
1113             accTokenPerShare.add(SOKUReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1114             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1115         } else {
1116             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1117         }
1118     }
1119 
1120     function getRemainingLockTime(address _user) external view returns (uint256) {
1121         if (addressEndLockTime[_user] < block.number) {
1122             return 0;
1123         }
1124         return addressEndLockTime[_user] - block.number;
1125     }
1126 
1127     function _resetAddressEndLockTime() internal {
1128         addressEndLockTime[msg.sender] = block.number.add(lockTime);
1129     }
1130 
1131     /*
1132      * @notice Update reward variables of the given pool to be up-to-date.
1133      */
1134     function _updatePool() internal {
1135         if (block.number <= lastRewardBlock) {
1136             return;
1137         }
1138 
1139         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1140 
1141         if (stakedTokenSupply == 0) {
1142             lastRewardBlock = block.number;
1143             return;
1144         }
1145 
1146         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1147         uint256 SOKUReward = multiplier.mul(rewardPerBlock);
1148         accTokenPerShare = accTokenPerShare.add(SOKUReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1149         lastRewardBlock = block.number;
1150     }
1151 
1152     /*
1153      * @notice Return reward multiplier over the given _from to _to block.
1154      * @param _from: block to start
1155      * @param _to: block to finish
1156      */
1157     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1158         if (_to <= bonusEndBlock) {
1159             return _to.sub(_from);
1160         } else if (_from >= bonusEndBlock) {
1161             return 0;
1162         } else {
1163             return bonusEndBlock.sub(_from);
1164         }
1165     }
1166 
1167     function _claimReward(address _user) internal {
1168         UserInfo storage user = userInfo[_user];
1169 
1170         _updatePool();
1171 
1172         if (user.amount > 0) {
1173             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1174             if (pending > 0) {
1175 
1176                 uint256 localAddressEndLockTime;
1177 
1178                 if (addressEndLockTime[_user] == 0) {
1179                     localAddressEndLockTime = endLockTime;
1180                 } else {
1181                     localAddressEndLockTime = addressEndLockTime[_user];
1182                 }
1183 
1184                 // If the lock time (i.e. 15 days) has passed or pool has ended
1185                 require(block.number >= localAddressEndLockTime || block.number >= bonusEndBlock, "Lock time has not expired, or the pool has not ended yet.");
1186                 rewardToken.safeTransfer(address(_user), pending);
1187             }
1188 
1189             user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
1190             emit ClaimReward(_user, pending);
1191         }
1192     }
1193 }
1194 
1195 // File: contracts/SmartChefFactory.sol
1196 
1197 pragma solidity 0.6.12;
1198 
1199 contract SmartChefFactory is Ownable {
1200     event NewSmartChefContract(address indexed smartChef);
1201 
1202     constructor() public {
1203         //
1204     }
1205 
1206     /*
1207      * @notice Deploy the pool
1208      * @param _stakedToken: staked token address
1209      * @param _rewardToken: reward token address
1210      * @param _rewardPerBlock: reward per block (in rewardToken)
1211      * @param _startBlock: start block
1212      * @param _endBlock: end block
1213      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
1214      * @param _admin: admin address with ownership
1215      * @return address of new smart chef contract
1216      */
1217     function deployPool(
1218         IERC20 _stakedToken,
1219         IERC20 _rewardToken,
1220         uint256 _rewardPerBlock,
1221         uint256 _startBlock,
1222         uint256 _bonusEndBlock,
1223         uint256 _lockTime,
1224         uint256 _poolLimitPerUser,
1225         address _admin
1226     ) external onlyOwner {
1227         require(_stakedToken.totalSupply() >= 0);
1228         require(_rewardToken.totalSupply() >= 0);
1229         require(_stakedToken != _rewardToken, "Tokens must be be different");
1230 
1231         bytes memory bytecode = type(SmartChefInitializable).creationCode;
1232         bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _rewardToken, _startBlock));
1233         address smartChefAddress;
1234 
1235         assembly {
1236             smartChefAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
1237         }
1238 
1239         SmartChefInitializable(smartChefAddress).initialize(
1240             _stakedToken,
1241             _rewardToken,
1242             _rewardPerBlock,
1243             _startBlock,
1244             _bonusEndBlock,
1245             _lockTime,
1246             _poolLimitPerUser,
1247             _admin
1248         );
1249 
1250         emit NewSmartChefContract(smartChefAddress);
1251     }
1252 }