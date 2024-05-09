1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-12
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity >=0.6.0 <0.8.0;
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
34 pragma solidity >=0.6.0 <0.8.0;
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
100 // File: @openzeppelin/contracts/math/SafeMath.sol
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         uint256 c = a + b;
125         if (c < a) return (false, 0);
126         return (true, c);
127     }
128 
129     /**
130      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         if (b > a) return (false, 0);
136         return (true, a - b);
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) return (true, 0);
149         uint256 c = a * b;
150         if (c / a != b) return (false, 0);
151         return (true, c);
152     }
153 
154     /**
155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         if (b == 0) return (false, 0);
161         return (true, a / b);
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a % b);
172     }
173 
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b <= a, "SafeMath: subtraction overflow");
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         if (a == 0) return 0;
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: division by zero");
236         return a / b;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * reverting when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: modulo by zero");
253         return a % b;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
258      * overflow (when the result is negative).
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {trySub}.
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         return a - b;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
280      * division by zero. The result is rounded towards zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryDiv}.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         return a / b;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         require(b > 0, errorMessage);
323         return a % b;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
328 
329 pragma solidity >=0.6.0 <0.8.0;
330 
331 /**
332  * @dev Contract module that helps prevent reentrant calls to a function.
333  *
334  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
335  * available, which can be applied to functions to make sure there are no nested
336  * (reentrant) calls to them.
337  *
338  * Note that because there is a single `nonReentrant` guard, functions marked as
339  * `nonReentrant` may not call one another. This can be worked around by making
340  * those functions `private`, and then adding `external` `nonReentrant` entry
341  * points to them.
342  *
343  * TIP: If you would like to learn more about reentrancy and alternative ways
344  * to protect against it, check out our blog post
345  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
346  */
347 abstract contract ReentrancyGuard {
348     // Booleans are more expensive than uint256 or any type that takes up a full
349     // word because each write operation emits an extra SLOAD to first read the
350     // slot's contents, replace the bits taken up by the boolean, and then write
351     // back. This is the compiler's defense against contract upgrades and
352     // pointer aliasing, and it cannot be disabled.
353 
354     // The values being non-zero value makes deployment a bit more expensive,
355     // but in exchange the refund on every call to nonReentrant will be lower in
356     // amount. Since refunds are capped to a percentage of the total
357     // transaction's gas, it is best to keep them low in cases like this one, to
358     // increase the likelihood of the full refund coming into effect.
359     uint256 private constant _NOT_ENTERED = 1;
360     uint256 private constant _ENTERED = 2;
361 
362     uint256 private _status;
363 
364     constructor() internal {
365         _status = _NOT_ENTERED;
366     }
367 
368     /**
369      * @dev Prevents a contract from calling itself, directly or indirectly.
370      * Calling a `nonReentrant` function from another `nonReentrant`
371      * function is not supported. It is possible to prevent this from happening
372      * by making the `nonReentrant` function external, and make it call a
373      * `private` function that does the actual work.
374      */
375     modifier nonReentrant() {
376         // On the first call to nonReentrant, _notEntered will be true
377         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
378 
379         // Any calls to nonReentrant after this point will fail
380         _status = _ENTERED;
381 
382         _;
383 
384         // By storing the original value once again, a refund is triggered (see
385         // https://eips.ethereum.org/EIPS/eip-2200)
386         _status = _NOT_ENTERED;
387     }
388 }
389 
390 // File: bsc-library/contracts/IBEP20.sol
391 
392 pragma solidity >=0.4.0;
393 
394 interface IBEP20 {
395     /**
396      * @dev Returns the amount of tokens in existence.
397      */
398     function totalSupply() external view returns (uint256);
399 
400     /**
401      * @dev Returns the token decimals.
402      */
403     function decimals() external view returns (uint8);
404 
405     /**
406      * @dev Returns the token symbol.
407      */
408     function symbol() external view returns (string memory);
409 
410     /**
411      * @dev Returns the token name.
412      */
413     function name() external view returns (string memory);
414 
415     /**
416      * @dev Returns the bep token owner.
417      */
418     function getOwner() external view returns (address);
419 
420     /**
421      * @dev Returns the amount of tokens owned by `account`.
422      */
423     function balanceOf(address account) external view returns (uint256);
424 
425     /**
426      * @dev Moves `amount` tokens from the caller's account to `recipient`.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transfer(address recipient, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Returns the remaining number of tokens that `spender` will be
436      * allowed to spend on behalf of `owner` through {transferFrom}. This is
437      * zero by default.
438      *
439      * This value changes when {approve} or {transferFrom} are called.
440      */
441     function allowance(address _owner, address spender) external view returns (uint256);
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * IMPORTANT: Beware that changing an allowance with this method brings the risk
449      * that someone may use both the old and the new allowance by unfortunate
450      * transaction ordering. One possible solution to mitigate this race
451      * condition is to first reduce the spender's allowance to 0 and set the
452      * desired value afterwards:
453      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address spender, uint256 amount) external returns (bool);
458 
459     /**
460      * @dev Moves `amount` tokens from `sender` to `recipient` using the
461      * allowance mechanism. `amount` is then deducted from the caller's
462      * allowance.
463      *
464      * Returns a boolean value indicating whether the operation succeeded.
465      *
466      * Emits a {Transfer} event.
467      */
468     function transferFrom(
469         address sender,
470         address recipient,
471         uint256 amount
472     ) external returns (bool);
473 
474     /**
475      * @dev Emitted when `value` tokens are moved from one account (`from`) to
476      * another (`to`).
477      *
478      * Note that `value` may be zero.
479      */
480     event Transfer(address indexed from, address indexed to, uint256 value);
481 
482     /**
483      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
484      * a call to {approve}. `value` is the new allowance.
485      */
486     event Approval(address indexed owner, address indexed spender, uint256 value);
487 }
488 
489 // File: @openzeppelin/contracts/utils/Address.sol
490 
491 pragma solidity >=0.6.2 <0.8.0;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize, which returns 0 for contracts in
516         // construction, since the code is only stored at the end of the
517         // constructor execution.
518 
519         uint256 size;
520         // solhint-disable-next-line no-inline-assembly
521         assembly {
522             size := extcodesize(account)
523         }
524         return size > 0;
525     }
526 
527     /**
528      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
529      * `recipient`, forwarding all available gas and reverting on errors.
530      *
531      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
532      * of certain opcodes, possibly making contracts go over the 2300 gas limit
533      * imposed by `transfer`, making them unable to receive funds via
534      * `transfer`. {sendValue} removes this limitation.
535      *
536      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
537      *
538      * IMPORTANT: because control is transferred to `recipient`, care must be
539      * taken to not create reentrancy vulnerabilities. Consider using
540      * {ReentrancyGuard} or the
541      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
542      */
543     function sendValue(address payable recipient, uint256 amount) internal {
544         require(address(this).balance >= amount, "Address: insufficient balance");
545 
546         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
547         (bool success, ) = recipient.call{value: amount}("");
548         require(success, "Address: unable to send value, recipient may have reverted");
549     }
550 
551     /**
552      * @dev Performs a Solidity function call using a low level `call`. A
553      * plain`call` is an unsafe replacement for a function call: use this
554      * function instead.
555      *
556      * If `target` reverts with a revert reason, it is bubbled up by this
557      * function (like regular Solidity function calls).
558      *
559      * Returns the raw returned data. To convert to the expected return value,
560      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
561      *
562      * Requirements:
563      *
564      * - `target` must be a contract.
565      * - calling `target` with `data` must not revert.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
570         return functionCall(target, data, "Address: low-level call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
575      * `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         return functionCallWithValue(target, data, 0, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but also transferring `value` wei to `target`.
590      *
591      * Requirements:
592      *
593      * - the calling contract must have an ETH balance of at least `value`.
594      * - the called Solidity function must be `payable`.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value
602     ) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
608      * with `errorMessage` as a fallback revert reason when `target` reverts.
609      *
610      * _Available since v3.1._
611      */
612     function functionCallWithValue(
613         address target,
614         bytes memory data,
615         uint256 value,
616         string memory errorMessage
617     ) internal returns (bytes memory) {
618         require(address(this).balance >= value, "Address: insufficient balance for call");
619         require(isContract(target), "Address: call to non-contract");
620 
621         // solhint-disable-next-line avoid-low-level-calls
622         (bool success, bytes memory returndata) = target.call{value: value}(data);
623         return _verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
633         return functionStaticCall(target, data, "Address: low-level static call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal view returns (bytes memory) {
647         require(isContract(target), "Address: static call to non-contract");
648 
649         // solhint-disable-next-line avoid-low-level-calls
650         (bool success, bytes memory returndata) = target.staticcall(data);
651         return _verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a delegate call.
657      *
658      * _Available since v3.4._
659      */
660     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
661         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
666      * but performing a delegate call.
667      *
668      * _Available since v3.4._
669      */
670     function functionDelegateCall(
671         address target,
672         bytes memory data,
673         string memory errorMessage
674     ) internal returns (bytes memory) {
675         require(isContract(target), "Address: delegate call to non-contract");
676 
677         // solhint-disable-next-line avoid-low-level-calls
678         (bool success, bytes memory returndata) = target.delegatecall(data);
679         return _verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     function _verifyCallResult(
683         bool success,
684         bytes memory returndata,
685         string memory errorMessage
686     ) private pure returns (bytes memory) {
687         if (success) {
688             return returndata;
689         } else {
690             // Look for revert reason and bubble it up if present
691             if (returndata.length > 0) {
692                 // The easiest way to bubble the revert reason is using memory via assembly
693 
694                 // solhint-disable-next-line no-inline-assembly
695                 assembly {
696                     let returndata_size := mload(returndata)
697                     revert(add(32, returndata), returndata_size)
698                 }
699             } else {
700                 revert(errorMessage);
701             }
702         }
703     }
704 }
705 
706 // File: bsc-library/contracts/SafeBEP20.sol
707 
708 pragma solidity ^0.6.0;
709 
710 /**
711  * @title SafeBEP20
712  * @dev Wrappers around BEP20 operations that throw on failure (when the token
713  * contract returns false). Tokens that return no value (and instead revert or
714  * throw on failure) are also supported, non-reverting calls are assumed to be
715  * successful.
716  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
717  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
718  */
719 library SafeBEP20 {
720     using SafeMath for uint256;
721     using Address for address;
722 
723     function safeTransfer(
724         IBEP20 token,
725         address to,
726         uint256 value
727     ) internal {
728         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
729     }
730 
731     function safeTransferFrom(
732         IBEP20 token,
733         address from,
734         address to,
735         uint256 value
736     ) internal {
737         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
738     }
739 
740     /**
741      * @dev Deprecated. This function has issues similar to the ones found in
742      * {IBEP20-approve}, and its usage is discouraged.
743      *
744      * Whenever possible, use {safeIncreaseAllowance} and
745      * {safeDecreaseAllowance} instead.
746      */
747     function safeApprove(
748         IBEP20 token,
749         address spender,
750         uint256 value
751     ) internal {
752         // safeApprove should only be called when setting an initial allowance,
753         // or when resetting it to zero. To increase and decrease it, use
754         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
755         // solhint-disable-next-line max-line-length
756         require(
757             (value == 0) || (token.allowance(address(this), spender) == 0),
758             "SafeBEP20: approve from non-zero to non-zero allowance"
759         );
760         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
761     }
762 
763     function safeIncreaseAllowance(
764         IBEP20 token,
765         address spender,
766         uint256 value
767     ) internal {
768         uint256 newAllowance = token.allowance(address(this), spender).add(value);
769         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
770     }
771 
772     function safeDecreaseAllowance(
773         IBEP20 token,
774         address spender,
775         uint256 value
776     ) internal {
777         uint256 newAllowance =
778             token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
779         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
780     }
781 
782     /**
783      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
784      * on the return value: the return value is optional (but if data is returned, it must not be false).
785      * @param token The token targeted by the call.
786      * @param data The call data (encoded using abi.encode or one of its variants).
787      */
788     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
789         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
790         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
791         // the target address contains contract code and also asserts for success in the low-level call.
792 
793         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
794         if (returndata.length > 0) {
795             // Return data is optional
796             // solhint-disable-next-line max-line-length
797             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
798         }
799     }
800 }
801 
802 pragma solidity 0.6.12;
803 
804 contract Bridge is Ownable, ReentrancyGuard {
805     using SafeMath for uint256;
806     using SafeBEP20 for IBEP20;
807 
808     IBEP20 public token; 
809 
810     uint256 public deposits;
811     uint256 public minDeposit = 6000000000000000000000000; // 6000000 PEPE or $10 at current rate
812     uint256 public tax = 20; // 0.2%
813     uint256 public outterTax = 20; // 0.2%
814     address public bridgeOperator; 
815 
816     event Deposit(address user, uint256 amount, uint256 time);
817     event Withdraw(address user, uint256 amount, uint256 time);
818 
819     constructor(IBEP20 _token) public {
820         token = _token;
821     }
822 
823 
824     struct TxInfo{
825         uint256 deposit;
826         address depositor; 
827     }
828 
829     uint256 public lastId = 0;
830     uint256 public depositorsId = 0;
831     mapping(uint256 => TxInfo) public depositMaps; 
832     mapping(uint256 => TxInfo) public withdrawMaps; 
833 
834     function depositToBridge(uint256 _amount) public nonReentrant {
835         require(_amount >= minDeposit, 'bad rate');
836         uint256 taxesBridge = _amount.mul(tax).div(10000);
837         token.safeTransferFrom(msg.sender, owner(), taxesBridge);
838         token.safeTransferFrom(msg.sender, address(this), _amount.sub(taxesBridge));
839         deposits = deposits + _amount.sub(taxesBridge);
840         depositMaps[lastId].deposit = _amount.sub(taxesBridge);
841         depositMaps[lastId].depositor = msg.sender; 
842         lastId = lastId+1; 
843         emit Deposit(msg.sender, _amount.sub(taxesBridge), block.timestamp);
844     }
845 
846     function withdrawFromBridge(uint256 _amount, address user) public {
847         require(msg.sender == bridgeOperator, 'bad call');
848         uint256 taxesBridge = _amount.mul(outterTax).div(10000);
849         token.safeTransfer(user, _amount.sub(taxesBridge));
850         token.safeTransfer(owner(), taxesBridge);
851         withdrawMaps[lastId].deposit = _amount.sub(taxesBridge); 
852         withdrawMaps[lastId].depositor = user;
853         depositorsId = depositorsId+1;
854         emit Withdraw(msg.sender, _amount.sub(taxesBridge), block.timestamp);
855     }
856 
857     function withdrawFromBridgeMultiple(uint256[] memory _amount, address[] memory user) public {
858         require(msg.sender == bridgeOperator, 'bad call');
859         require(user.length == _amount.length, 'user amounts mismatch');
860 
861         for(uint i=0; i<user.length; i++){
862             uint256 taxesBridge = _amount[i].mul(outterTax).div(10000);
863             token.safeTransfer(user[i], _amount[i].sub(taxesBridge));
864             token.safeTransfer(owner(), taxesBridge);
865             withdrawMaps[lastId].deposit = _amount[i].sub(taxesBridge); 
866             withdrawMaps[lastId].depositor = user[i];
867             depositorsId = depositorsId+1;
868             emit Withdraw(user[i], _amount[i].sub(taxesBridge), block.timestamp);
869         }
870 
871     }
872 
873     function setOperator(address _operator) public onlyOwner {
874         bridgeOperator = _operator;
875     }
876 
877     function changeMinDeposit(uint256 _value) public onlyOwner {
878         minDeposit = _value; 
879     }
880 
881     function changeTax(uint256 _newTax, uint256 _newOuterTax) public onlyOwner {
882         require(_newTax <= 200, 'too large'); // 2% tax bridge max
883         require(outterTax <= 200, 'too large'); // 2% tax bridge max
884         tax = _newTax;
885         outterTax = _newOuterTax;
886     }
887 
888 }