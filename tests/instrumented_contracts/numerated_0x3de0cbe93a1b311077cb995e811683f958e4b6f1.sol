1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 pragma solidity >=0.6.0 <0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/math/SafeMath.sol
96 
97 pragma solidity >=0.6.0 <0.8.0;
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         uint256 c = a + b;
120         if (c < a) return (false, 0);
121         return (true, c);
122     }
123 
124     /**
125      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b > a) return (false, 0);
131         return (true, a - b);
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) return (true, 0);
144         uint256 c = a * b;
145         if (c / a != b) return (false, 0);
146         return (true, c);
147     }
148 
149     /**
150      * @dev Returns the division of two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         if (b == 0) return (false, 0);
156         return (true, a / b);
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         if (b == 0) return (false, 0);
166         return (true, a % b);
167     }
168 
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      *
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SafeMath: addition overflow");
182         return c;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SafeMath: subtraction overflow");
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         if (a == 0) return 0;
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b > 0, "SafeMath: division by zero");
231         return a / b;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b > 0, "SafeMath: modulo by zero");
248         return a % b;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
253      * overflow (when the result is negative).
254      *
255      * CAUTION: This function is deprecated because it requires allocating memory for the error
256      * message unnecessarily. For custom revert reasons use {trySub}.
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(
265         uint256 a,
266         uint256 b,
267         string memory errorMessage
268     ) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
275      * division by zero. The result is rounded towards zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryDiv}.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(
289         uint256 a,
290         uint256 b,
291         string memory errorMessage
292     ) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a / b;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting with custom message when dividing by zero.
300      *
301      * CAUTION: This function is deprecated because it requires allocating memory for the error
302      * message unnecessarily. For custom revert reasons use {tryMod}.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         require(b > 0, errorMessage);
318         return a % b;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
323 
324 pragma solidity >=0.6.0 <0.8.0;
325 
326 /**
327  * @dev Contract module that helps prevent reentrant calls to a function.
328  *
329  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
330  * available, which can be applied to functions to make sure there are no nested
331  * (reentrant) calls to them.
332  *
333  * Note that because there is a single `nonReentrant` guard, functions marked as
334  * `nonReentrant` may not call one another. This can be worked around by making
335  * those functions `private`, and then adding `external` `nonReentrant` entry
336  * points to them.
337  *
338  * TIP: If you would like to learn more about reentrancy and alternative ways
339  * to protect against it, check out our blog post
340  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
341  */
342 abstract contract ReentrancyGuard {
343     // Booleans are more expensive than uint256 or any type that takes up a full
344     // word because each write operation emits an extra SLOAD to first read the
345     // slot's contents, replace the bits taken up by the boolean, and then write
346     // back. This is the compiler's defense against contract upgrades and
347     // pointer aliasing, and it cannot be disabled.
348 
349     // The values being non-zero value makes deployment a bit more expensive,
350     // but in exchange the refund on every call to nonReentrant will be lower in
351     // amount. Since refunds are capped to a percentage of the total
352     // transaction's gas, it is best to keep them low in cases like this one, to
353     // increase the likelihood of the full refund coming into effect.
354     uint256 private constant _NOT_ENTERED = 1;
355     uint256 private constant _ENTERED = 2;
356 
357     uint256 private _status;
358 
359     constructor() internal {
360         _status = _NOT_ENTERED;
361     }
362 
363     /**
364      * @dev Prevents a contract from calling itself, directly or indirectly.
365      * Calling a `nonReentrant` function from another `nonReentrant`
366      * function is not supported. It is possible to prevent this from happening
367      * by making the `nonReentrant` function external, and make it call a
368      * `private` function that does the actual work.
369      */
370     modifier nonReentrant() {
371         // On the first call to nonReentrant, _notEntered will be true
372         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
373 
374         // Any calls to nonReentrant after this point will fail
375         _status = _ENTERED;
376 
377         _;
378 
379         // By storing the original value once again, a refund is triggered (see
380         // https://eips.ethereum.org/EIPS/eip-2200)
381         _status = _NOT_ENTERED;
382     }
383 }
384 
385 // File: bsc-library/contracts/IBEP20.sol
386 
387 pragma solidity >=0.4.0;
388 
389 interface IBEP20 {
390     /**
391      * @dev Returns the amount of tokens in existence.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns the token decimals.
397      */
398     function decimals() external view returns (uint8);
399 
400     /**
401      * @dev Returns the token symbol.
402      */
403     function symbol() external view returns (string memory);
404 
405     /**
406      * @dev Returns the token name.
407      */
408     function name() external view returns (string memory);
409 
410     /**
411      * @dev Returns the bep token owner.
412      */
413     function getOwner() external view returns (address);
414 
415     /**
416      * @dev Returns the amount of tokens owned by `account`.
417      */
418     function balanceOf(address account) external view returns (uint256);
419 
420     /**
421      * @dev Moves `amount` tokens from the caller's account to `recipient`.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transfer(address recipient, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Returns the remaining number of tokens that `spender` will be
431      * allowed to spend on behalf of `owner` through {transferFrom}. This is
432      * zero by default.
433      *
434      * This value changes when {approve} or {transferFrom} are called.
435      */
436     function allowance(address _owner, address spender) external view returns (uint256);
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * IMPORTANT: Beware that changing an allowance with this method brings the risk
444      * that someone may use both the old and the new allowance by unfortunate
445      * transaction ordering. One possible solution to mitigate this race
446      * condition is to first reduce the spender's allowance to 0 and set the
447      * desired value afterwards:
448      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
449      *
450      * Emits an {Approval} event.
451      */
452     function approve(address spender, uint256 amount) external returns (bool);
453 
454     /**
455      * @dev Moves `amount` tokens from `sender` to `recipient` using the
456      * allowance mechanism. `amount` is then deducted from the caller's
457      * allowance.
458      *
459      * Returns a boolean value indicating whether the operation succeeded.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address sender,
465         address recipient,
466         uint256 amount
467     ) external returns (bool);
468 
469     /**
470      * @dev Emitted when `value` tokens are moved from one account (`from`) to
471      * another (`to`).
472      *
473      * Note that `value` may be zero.
474      */
475     event Transfer(address indexed from, address indexed to, uint256 value);
476 
477     /**
478      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
479      * a call to {approve}. `value` is the new allowance.
480      */
481     event Approval(address indexed owner, address indexed spender, uint256 value);
482 }
483 
484 // File: @openzeppelin/contracts/utils/Address.sol
485 
486 pragma solidity >=0.6.2 <0.8.0;
487 
488 /**
489  * @dev Collection of functions related to the address type
490  */
491 library Address {
492     /**
493      * @dev Returns true if `account` is a contract.
494      *
495      * [IMPORTANT]
496      * ====
497      * It is unsafe to assume that an address for which this function returns
498      * false is an externally-owned account (EOA) and not a contract.
499      *
500      * Among others, `isContract` will return false for the following
501      * types of addresses:
502      *
503      *  - an externally-owned account
504      *  - a contract in construction
505      *  - an address where a contract will be created
506      *  - an address where a contract lived, but was destroyed
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize, which returns 0 for contracts in
511         // construction, since the code is only stored at the end of the
512         // constructor execution.
513 
514         uint256 size;
515         // solhint-disable-next-line no-inline-assembly
516         assembly {
517             size := extcodesize(account)
518         }
519         return size > 0;
520     }
521 
522     /**
523      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
524      * `recipient`, forwarding all available gas and reverting on errors.
525      *
526      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
527      * of certain opcodes, possibly making contracts go over the 2300 gas limit
528      * imposed by `transfer`, making them unable to receive funds via
529      * `transfer`. {sendValue} removes this limitation.
530      *
531      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
532      *
533      * IMPORTANT: because control is transferred to `recipient`, care must be
534      * taken to not create reentrancy vulnerabilities. Consider using
535      * {ReentrancyGuard} or the
536      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
537      */
538     function sendValue(address payable recipient, uint256 amount) internal {
539         require(address(this).balance >= amount, "Address: insufficient balance");
540 
541         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
542         (bool success, ) = recipient.call{value: amount}("");
543         require(success, "Address: unable to send value, recipient may have reverted");
544     }
545 
546     /**
547      * @dev Performs a Solidity function call using a low level `call`. A
548      * plain`call` is an unsafe replacement for a function call: use this
549      * function instead.
550      *
551      * If `target` reverts with a revert reason, it is bubbled up by this
552      * function (like regular Solidity function calls).
553      *
554      * Returns the raw returned data. To convert to the expected return value,
555      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
556      *
557      * Requirements:
558      *
559      * - `target` must be a contract.
560      * - calling `target` with `data` must not revert.
561      *
562      * _Available since v3.1._
563      */
564     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionCall(target, data, "Address: low-level call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
570      * `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         return functionCallWithValue(target, data, 0, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but also transferring `value` wei to `target`.
585      *
586      * Requirements:
587      *
588      * - the calling contract must have an ETH balance of at least `value`.
589      * - the called Solidity function must be `payable`.
590      *
591      * _Available since v3.1._
592      */
593     function functionCallWithValue(
594         address target,
595         bytes memory data,
596         uint256 value
597     ) internal returns (bytes memory) {
598         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
603      * with `errorMessage` as a fallback revert reason when `target` reverts.
604      *
605      * _Available since v3.1._
606      */
607     function functionCallWithValue(
608         address target,
609         bytes memory data,
610         uint256 value,
611         string memory errorMessage
612     ) internal returns (bytes memory) {
613         require(address(this).balance >= value, "Address: insufficient balance for call");
614         require(isContract(target), "Address: call to non-contract");
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = target.call{value: value}(data);
618         return _verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
628         return functionStaticCall(target, data, "Address: low-level static call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal view returns (bytes memory) {
642         require(isContract(target), "Address: static call to non-contract");
643 
644         // solhint-disable-next-line avoid-low-level-calls
645         (bool success, bytes memory returndata) = target.staticcall(data);
646         return _verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a delegate call.
652      *
653      * _Available since v3.4._
654      */
655     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
656         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         require(isContract(target), "Address: delegate call to non-contract");
671 
672         // solhint-disable-next-line avoid-low-level-calls
673         (bool success, bytes memory returndata) = target.delegatecall(data);
674         return _verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     function _verifyCallResult(
678         bool success,
679         bytes memory returndata,
680         string memory errorMessage
681     ) private pure returns (bytes memory) {
682         if (success) {
683             return returndata;
684         } else {
685             // Look for revert reason and bubble it up if present
686             if (returndata.length > 0) {
687                 // The easiest way to bubble the revert reason is using memory via assembly
688 
689                 // solhint-disable-next-line no-inline-assembly
690                 assembly {
691                     let returndata_size := mload(returndata)
692                     revert(add(32, returndata), returndata_size)
693                 }
694             } else {
695                 revert(errorMessage);
696             }
697         }
698     }
699 }
700 
701 // File: bsc-library/contracts/SafeBEP20.sol
702 
703 pragma solidity ^0.6.0;
704 
705 /**
706  * @title SafeBEP20
707  * @dev Wrappers around BEP20 operations that throw on failure (when the token
708  * contract returns false). Tokens that return no value (and instead revert or
709  * throw on failure) are also supported, non-reverting calls are assumed to be
710  * successful.
711  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
712  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
713  */
714 library SafeBEP20 {
715     using SafeMath for uint256;
716     using Address for address;
717 
718     function safeTransfer(
719         IBEP20 token,
720         address to,
721         uint256 value
722     ) internal {
723         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
724     }
725 
726     function safeTransferFrom(
727         IBEP20 token,
728         address from,
729         address to,
730         uint256 value
731     ) internal {
732         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
733     }
734 
735     /**
736      * @dev Deprecated. This function has issues similar to the ones found in
737      * {IBEP20-approve}, and its usage is discouraged.
738      *
739      * Whenever possible, use {safeIncreaseAllowance} and
740      * {safeDecreaseAllowance} instead.
741      */
742     function safeApprove(
743         IBEP20 token,
744         address spender,
745         uint256 value
746     ) internal {
747         // safeApprove should only be called when setting an initial allowance,
748         // or when resetting it to zero. To increase and decrease it, use
749         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
750         // solhint-disable-next-line max-line-length
751         require(
752             (value == 0) || (token.allowance(address(this), spender) == 0),
753             "SafeBEP20: approve from non-zero to non-zero allowance"
754         );
755         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
756     }
757 
758     function safeIncreaseAllowance(
759         IBEP20 token,
760         address spender,
761         uint256 value
762     ) internal {
763         uint256 newAllowance = token.allowance(address(this), spender).add(value);
764         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
765     }
766 
767     function safeDecreaseAllowance(
768         IBEP20 token,
769         address spender,
770         uint256 value
771     ) internal {
772         uint256 newAllowance =
773             token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
774         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
775     }
776 
777     /**
778      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
779      * on the return value: the return value is optional (but if data is returned, it must not be false).
780      * @param token The token targeted by the call.
781      * @param data The call data (encoded using abi.encode or one of its variants).
782      */
783     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
784         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
785         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
786         // the target address contains contract code and also asserts for success in the low-level call.
787 
788         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
789         if (returndata.length > 0) {
790             // Return data is optional
791             // solhint-disable-next-line max-line-length
792             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
793         }
794     }
795 }
796 
797 
798 pragma solidity 0.6.12;
799 
800 contract StandardVault is Ownable, ReentrancyGuard {
801     using SafeMath for uint256;
802     using SafeBEP20 for IBEP20;
803 
804     // The address of the smart chef factory
805     address public SMART_CHEF_FACTORY;
806 
807     // Whether a limit is set for users
808     bool public hasUserLimit;
809 
810     // Whether it is initialized
811     bool public isInitialized;
812 
813     // Accrued token per share
814     uint256 public accTokenPerShare;
815 
816     // The block number when CAKE mining ends.
817     uint256 public bonusEndBlock;
818 
819     // The block number when CAKE mining starts.
820     uint256 public startBlock;
821 
822     // The block number of the last pool update
823     uint256 public lastRewardBlock;
824 
825     // The pool limit (0 if none)
826     uint256 public poolLimitPerUser;
827 
828     // CAKE tokens created per block.
829     uint256 public rewardPerBlock;
830     
831     // deposit fee 
832     uint256 public depositFee; 
833     address public feeReceiver; 
834 
835 
836     // The precision factor
837     uint256 public PRECISION_FACTOR;
838 
839     // The reward token
840     IBEP20 public rewardToken;
841 
842     // The staked token
843     IBEP20 public stakedToken;
844 
845     // Info of each user that stakes tokens (stakedToken)
846     mapping(address => UserInfo) public userInfo;
847 
848     struct UserInfo {
849         uint256 amount; // How many staked tokens the user has provided
850         uint256 rewardDebt; // Reward debt
851     }
852 
853     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
854     event Deposit(address indexed user, uint256 amount);
855     event EmergencyWithdraw(address indexed user, uint256 amount);
856     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
857     event NewRewardPerBlock(uint256 rewardPerBlock);
858     event NewPoolLimit(uint256 poolLimitPerUser);
859     event RewardsStop(uint256 blockNumber);
860     event Withdraw(address indexed user, uint256 amount);
861 
862     constructor() public {
863         SMART_CHEF_FACTORY = msg.sender;
864     }
865 
866     /*
867      * @notice Initialize the contract
868      * @param _stakedToken: staked token address
869      * @param _rewardToken: reward token address
870      * @param _rewardPerBlock: reward per block (in rewardToken)
871      * @param _startBlock: start block
872      * @param _bonusEndBlock: end block
873      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
874      * @param _admin: admin address with ownership
875      */
876     function initialize(
877         IBEP20 _stakedToken,
878         IBEP20 _rewardToken,
879         uint256 _rewardPerBlock,
880         uint256 _startBlock,
881         uint256 _bonusEndBlock,
882         uint256 _poolLimitPerUser,
883         address _admin,
884         uint256 _depositfee,
885         address _feereceiver
886     ) external {
887         require(!isInitialized, "Already initialized");
888         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
889 
890         // Make this contract initialized
891         isInitialized = true;
892 
893         stakedToken = _stakedToken;
894         rewardToken = _rewardToken;
895         rewardPerBlock = _rewardPerBlock;
896         startBlock = _startBlock;
897         bonusEndBlock = _bonusEndBlock;
898         depositFee = _depositfee;
899         feeReceiver = _feereceiver;
900 
901         if (_poolLimitPerUser > 0) {
902             hasUserLimit = true;
903             poolLimitPerUser = _poolLimitPerUser;
904         }
905 
906         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
907         require(decimalsRewardToken < 30, "Must be inferior to 30");
908 
909         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
910 
911         // Set the lastRewardBlock as the startBlock
912         lastRewardBlock = startBlock;
913 
914         // Transfer ownership to the admin address who becomes owner of the contract
915         transferOwnership(_admin);
916     }
917     
918     function modifyTimes(uint256 _startTime, uint256 _endTime, uint256 _reward) public onlyOwner {
919         startBlock = _startTime;
920         bonusEndBlock = _endTime;
921         rewardPerBlock = _reward;
922         lastRewardBlock = startBlock;
923     }
924 
925     /*
926      * @notice Deposit staked tokens and collect reward tokens (if any)
927      * @param _amount: amount to withdraw (in rewardToken)
928      */
929     function deposit(uint256 _amount) external nonReentrant {
930         UserInfo storage user = userInfo[msg.sender];
931 
932         if (hasUserLimit) {
933             require(_amount.add(user.amount) <= poolLimitPerUser, "User amount above limit");
934         }
935 
936         _updatePool();
937 
938         if (user.amount > 0) {
939             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
940             if (pending > 0) {
941                 rewardToken.safeTransfer(address(msg.sender), pending);
942             }
943         }
944 
945         if (_amount > 0) {
946             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
947             if(depositFee > 0){
948                 uint256 _depositFee = _amount.mul(depositFee).div(10000);
949                 stakedToken.safeTransfer(feeReceiver, _depositFee);
950                 user.amount = user.amount.add(_amount).sub(_depositFee);
951             } else {
952                 user.amount = user.amount.add(_amount);
953             }
954         }
955 
956         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
957 
958         emit Deposit(msg.sender, _amount);
959     }
960 
961     /*
962      * @notice Withdraw staked tokens and collect reward tokens
963      * @param _amount: amount to withdraw (in rewardToken)
964      */
965     function withdraw(uint256 _amount) external nonReentrant {
966         UserInfo storage user = userInfo[msg.sender];
967         require(user.amount >= _amount, "Amount to withdraw too high");
968 
969         _updatePool();
970 
971         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
972 
973         if (_amount > 0) {
974             user.amount = user.amount.sub(_amount);
975             stakedToken.safeTransfer(address(msg.sender), _amount);
976         }
977 
978         if (pending > 0) {
979             rewardToken.safeTransfer(address(msg.sender), pending);
980         }
981 
982         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
983 
984         emit Withdraw(msg.sender, _amount);
985     }
986 
987     /*
988      * @notice Withdraw staked tokens without caring about rewards rewards
989      * @dev Needs to be for emergency.
990      */
991     function emergencyWithdraw() external nonReentrant {
992         UserInfo storage user = userInfo[msg.sender];
993         uint256 amountToTransfer = user.amount;
994         user.amount = 0;
995         user.rewardDebt = 0;
996 
997         if (amountToTransfer > 0) {
998             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
999         }
1000 
1001         emit EmergencyWithdraw(msg.sender, user.amount);
1002     }
1003 
1004     /*
1005      * @notice Stop rewards
1006      * @dev Only callable by owner. Needs to be for emergency.
1007      */
1008     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1009         rewardToken.safeTransfer(address(msg.sender), _amount);
1010     }
1011 
1012     /**
1013      * @notice It allows the admin to recover wrong tokens sent to the contract
1014      * @param _tokenAddress: the address of the token to withdraw
1015      * @param _tokenAmount: the number of tokens to withdraw
1016      * @dev This function is only callable by admin.
1017      */
1018     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1019         require(_tokenAddress != address(stakedToken), "Cannot be staked token");
1020         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
1021 
1022         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1023 
1024         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1025     }
1026 
1027     /*
1028      * @notice Stop rewards
1029      * @dev Only callable by owner
1030      */
1031     function stopReward() external onlyOwner {
1032         bonusEndBlock = block.number;
1033     }
1034 
1035     /*
1036      * @notice Update pool limit per user
1037      * @dev Only callable by owner.
1038      * @param _hasUserLimit: whether the limit remains forced
1039      * @param _poolLimitPerUser: new pool limit per user
1040      */
1041     function updatePoolLimitPerUser(bool _hasUserLimit, uint256 _poolLimitPerUser) external onlyOwner {
1042         require(hasUserLimit, "Must be set");
1043         if (_hasUserLimit) {
1044             require(_poolLimitPerUser > poolLimitPerUser, "New limit must be higher");
1045             poolLimitPerUser = _poolLimitPerUser;
1046         } else {
1047             hasUserLimit = _hasUserLimit;
1048             poolLimitPerUser = 0;
1049         }
1050         emit NewPoolLimit(poolLimitPerUser);
1051     }
1052 
1053     /*
1054      * @notice Update reward per block
1055      * @dev Only callable by owner.
1056      * @param _rewardPerBlock: the reward per block
1057      */
1058     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1059         require(block.number < startBlock, "Pool has started");
1060         rewardPerBlock = _rewardPerBlock;
1061         emit NewRewardPerBlock(_rewardPerBlock);
1062     }
1063 
1064     /**
1065      * @notice It allows the admin to update start and end blocks
1066      * @dev This function is only callable by owner.
1067      * @param _startBlock: the new start block
1068      * @param _bonusEndBlock: the new end block
1069      */
1070     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
1071         require(block.number < startBlock, "Pool has started");
1072         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
1073         require(block.number < _startBlock, "New startBlock must be higher than current block");
1074 
1075         startBlock = _startBlock;
1076         bonusEndBlock = _bonusEndBlock;
1077 
1078         // Set the lastRewardBlock as the startBlock
1079         lastRewardBlock = startBlock;
1080 
1081         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1082     }
1083 
1084     /*
1085      * @notice View function to see pending reward on frontend.
1086      * @param _user: user address
1087      * @return Pending reward for a given user
1088      */
1089     function pendingReward(address _user) external view returns (uint256) {
1090         UserInfo storage user = userInfo[_user];
1091         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1092         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1093             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1094             uint256 cakeReward = multiplier.mul(rewardPerBlock);
1095             uint256 adjustedTokenPerShare =
1096                 accTokenPerShare.add(cakeReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1097             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1098         } else {
1099             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1100         }
1101     }
1102 
1103     /*
1104      * @notice Update reward variables of the given pool to be up-to-date.
1105      */
1106     function _updatePool() internal {
1107         if (block.number <= lastRewardBlock) {
1108             return;
1109         }
1110 
1111         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1112 
1113         if (stakedTokenSupply == 0) {
1114             lastRewardBlock = block.number;
1115             return;
1116         }
1117 
1118         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1119         uint256 cakeReward = multiplier.mul(rewardPerBlock);
1120         accTokenPerShare = accTokenPerShare.add(cakeReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1121         lastRewardBlock = block.number;
1122     }
1123 
1124     /*
1125      * @notice Return reward multiplier over the given _from to _to block.
1126      * @param _from: block to start
1127      * @param _to: block to finish
1128      */
1129     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1130         if (_to <= bonusEndBlock) {
1131             return _to.sub(_from);
1132         } else if (_from >= bonusEndBlock) {
1133             return 0;
1134         } else {
1135             return bonusEndBlock.sub(_from);
1136         }
1137     }
1138 }