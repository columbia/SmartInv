1 // File contracts/openzeppelin_contracts/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available 
10  * via msg.sender and msg.data, they should not be accessed in such a direct   
11  * manner, since when dealing with meta-transactions the account sending and   
12  * paying for execution may not be the actual sender (as far as an application 
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.    
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {       
23         return msg.data;
24     }
25 }
26 
27 
28 // File contracts/openzeppelin_contracts/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 
101 // File contracts/openzeppelin_contracts/contracts/token/ERC20/IERC20.sol
102 
103 
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 // File contracts/openzeppelin_contracts/contracts/utils/Address.sol
187 
188 
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Collection of functions related to the address type
194  */
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * [IMPORTANT]
200      * ====
201      * It is unsafe to assume that an address for which this function returns
202      * false is an externally-owned account (EOA) and not a contract.
203      *
204      * Among others, `isContract` will return false for the following
205      * types of addresses:
206      *
207      *  - an externally-owned account
208      *  - a contract in construction
209      *  - an address where a contract will be created
210      *  - an address where a contract lived, but was destroyed
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize, which returns 0 for contracts in
215         // construction, since the code is only stored at the end of the
216         // constructor execution.
217 
218         uint256 size;
219         assembly {
220             size := extcodesize(account)
221         }
222         return size > 0;
223     }
224 
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248     /**
249      * @dev Performs a Solidity function call using a low level `call`. A
250      * plain `call` is an unsafe replacement for a function call: use this
251      * function instead.
252      *
253      * If `target` reverts with a revert reason, it is bubbled up by this
254      * function (like regular Solidity function calls).
255      *
256      * Returns the raw returned data. To convert to the expected return value,
257      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
258      *
259      * Requirements:
260      *
261      * - `target` must be a contract.
262      * - calling `target` with `data` must not revert.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionCall(target, data, "Address: low-level call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
272      * `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(isContract(target), "Address: delegate call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
378      * revert reason using the provided one.
379      *
380      * _Available since v4.3._
381      */
382     function verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 
406 // File contracts/openzeppelin_contracts/contracts/token/ERC20/utils/SafeERC20.sol
407 
408 
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @title SafeERC20
415  * @dev Wrappers around ERC20 operations that throw on failure (when the token
416  * contract returns false). Tokens that return no value (and instead revert or
417  * throw on failure) are also supported, non-reverting calls are assumed to be
418  * successful.
419  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
420  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
421  */
422 library SafeERC20 {
423     using Address for address;
424 
425     function safeTransfer(
426         IERC20 token,
427         address to,
428         uint256 value
429     ) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
431     }
432 
433     function safeTransferFrom(
434         IERC20 token,
435         address from,
436         address to,
437         uint256 value
438     ) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
440     }
441 
442     /**
443      * @dev Deprecated. This function has issues similar to the ones found in
444      * {IERC20-approve}, and its usage is discouraged.
445      *
446      * Whenever possible, use {safeIncreaseAllowance} and
447      * {safeDecreaseAllowance} instead.
448      */
449     function safeApprove(
450         IERC20 token,
451         address spender,
452         uint256 value
453     ) internal {
454         // safeApprove should only be called when setting an initial allowance,
455         // or when resetting it to zero. To increase and decrease it, use
456         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
457         require(
458             (value == 0) || (token.allowance(address(this), spender) == 0),
459             "SafeERC20: approve from non-zero to non-zero allowance"
460         );
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
462     }
463 
464     function safeIncreaseAllowance(
465         IERC20 token,
466         address spender,
467         uint256 value
468     ) internal {
469         uint256 newAllowance = token.allowance(address(this), spender) + value;
470         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     function safeDecreaseAllowance(
474         IERC20 token,
475         address spender,
476         uint256 value
477     ) internal {
478         unchecked {
479             uint256 oldAllowance = token.allowance(address(this), spender);
480             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
481             uint256 newAllowance = oldAllowance - value;
482             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483         }
484     }
485 
486     /**
487      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
488      * on the return value: the return value is optional (but if data is returned, it must not be false).
489      * @param token The token targeted by the call.
490      * @param data The call data (encoded using abi.encode or one of its variants).
491      */
492     function _callOptionalReturn(IERC20 token, bytes memory data) private {
493         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
494         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
495         // the target address contains contract code and also asserts for success in the low-level call.
496 
497         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
498         if (returndata.length > 0) {
499             // Return data is optional
500             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
501         }
502     }
503 }
504 
505 
506 // File contracts/openzeppelin_contracts/contracts/utils/math/SafeMath.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 // CAUTION
513 // This version of SafeMath should only be used with Solidity 0.8 or later,
514 // because it relies on the compiler's built in overflow checks.
515 
516 /**
517  * @dev Wrappers over Solidity's arithmetic operations.
518  *
519  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
520  * now has built in overflow checking.
521  */
522 library SafeMath {
523     /**
524      * @dev Returns the addition of two unsigned integers, with an overflow flag.
525      *
526      * _Available since v3.4._
527      */
528     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
529         unchecked {
530             uint256 c = a + b;
531             if (c < a) return (false, 0);
532             return (true, c);
533         }
534     }
535 
536     /**
537      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
538      *
539      * _Available since v3.4._
540      */
541     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             if (b > a) return (false, 0);
544             return (true, a - b);
545         }
546     }
547 
548     /**
549      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
550      *
551      * _Available since v3.4._
552      */
553     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
554         unchecked {
555             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
556             // benefit is lost if 'b' is also tested.
557             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
558             if (a == 0) return (true, 0);
559             uint256 c = a * b;
560             if (c / a != b) return (false, 0);
561             return (true, c);
562         }
563     }
564 
565     /**
566      * @dev Returns the division of two unsigned integers, with a division by zero flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b == 0) return (false, 0);
573             return (true, a / b);
574         }
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             if (b == 0) return (false, 0);
585             return (true, a % b);
586         }
587     }
588 
589     /**
590      * @dev Returns the addition of two unsigned integers, reverting on
591      * overflow.
592      *
593      * Counterpart to Solidity's `+` operator.
594      *
595      * Requirements:
596      *
597      * - Addition cannot overflow.
598      */
599     function add(uint256 a, uint256 b) internal pure returns (uint256) {
600         return a + b;
601     }
602 
603     /**
604      * @dev Returns the subtraction of two unsigned integers, reverting on
605      * overflow (when the result is negative).
606      *
607      * Counterpart to Solidity's `-` operator.
608      *
609      * Requirements:
610      *
611      * - Subtraction cannot overflow.
612      */
613     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a - b;
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, reverting on
619      * overflow.
620      *
621      * Counterpart to Solidity's `*` operator.
622      *
623      * Requirements:
624      *
625      * - Multiplication cannot overflow.
626      */
627     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a * b;
629     }
630 
631     /**
632      * @dev Returns the integer division of two unsigned integers, reverting on
633      * division by zero. The result is rounded towards zero.
634      *
635      * Counterpart to Solidity's `/` operator.
636      *
637      * Requirements:
638      *
639      * - The divisor cannot be zero.
640      */
641     function div(uint256 a, uint256 b) internal pure returns (uint256) {
642         return a / b;
643     }
644 
645     /**
646      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
647      * reverting when dividing by zero.
648      *
649      * Counterpart to Solidity's `%` operator. This function uses a `revert`
650      * opcode (which leaves remaining gas untouched) while Solidity uses an
651      * invalid opcode to revert (consuming all remaining gas).
652      *
653      * Requirements:
654      *
655      * - The divisor cannot be zero.
656      */
657     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
658         return a % b;
659     }
660 
661     /**
662      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
663      * overflow (when the result is negative).
664      *
665      * CAUTION: This function is deprecated because it requires allocating memory for the error
666      * message unnecessarily. For custom revert reasons use {trySub}.
667      *
668      * Counterpart to Solidity's `-` operator.
669      *
670      * Requirements:
671      *
672      * - Subtraction cannot overflow.
673      */
674     function sub(
675         uint256 a,
676         uint256 b,
677         string memory errorMessage
678     ) internal pure returns (uint256) {
679         unchecked {
680             require(b <= a, errorMessage);
681             return a - b;
682         }
683     }
684 
685     /**
686      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
687      * division by zero. The result is rounded towards zero.
688      *
689      * Counterpart to Solidity's `/` operator. Note: this function uses a
690      * `revert` opcode (which leaves remaining gas untouched) while Solidity
691      * uses an invalid opcode to revert (consuming all remaining gas).
692      *
693      * Requirements:
694      *
695      * - The divisor cannot be zero.
696      */
697     function div(
698         uint256 a,
699         uint256 b,
700         string memory errorMessage
701     ) internal pure returns (uint256) {
702         unchecked {
703             require(b > 0, errorMessage);
704             return a / b;
705         }
706     }
707 
708     /**
709      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
710      * reverting with custom message when dividing by zero.
711      *
712      * CAUTION: This function is deprecated because it requires allocating memory for the error
713      * message unnecessarily. For custom revert reasons use {tryMod}.
714      *
715      * Counterpart to Solidity's `%` operator. This function uses a `revert`
716      * opcode (which leaves remaining gas untouched) while Solidity uses an
717      * invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function mod(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b > 0, errorMessage);
730             return a % b;
731         }
732     }
733 }
734 
735 
736 // File contracts/openzeppelin_contracts/contracts/security/ReentrancyGuard.sol
737 
738 
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @dev Contract module that helps prevent reentrant calls to a function.
744  *
745  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
746  * available, which can be applied to functions to make sure there are no nested
747  * (reentrant) calls to them.
748  *
749  * Note that because there is a single `nonReentrant` guard, functions marked as
750  * `nonReentrant` may not call one another. This can be worked around by making
751  * those functions `private`, and then adding `external` `nonReentrant` entry
752  * points to them.
753  *
754  * TIP: If you would like to learn more about reentrancy and alternative ways
755  * to protect against it, check out our blog post
756  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
757  */
758 abstract contract ReentrancyGuard {
759     // Booleans are more expensive than uint256 or any type that takes up a full
760     // word because each write operation emits an extra SLOAD to first read the
761     // slot's contents, replace the bits taken up by the boolean, and then write
762     // back. This is the compiler's defense against contract upgrades and
763     // pointer aliasing, and it cannot be disabled.
764 
765     // The values being non-zero value makes deployment a bit more expensive,
766     // but in exchange the refund on every call to nonReentrant will be lower in
767     // amount. Since refunds are capped to a percentage of the total
768     // transaction's gas, it is best to keep them low in cases like this one, to
769     // increase the likelihood of the full refund coming into effect.
770     uint256 private constant _NOT_ENTERED = 1;
771     uint256 private constant _ENTERED = 2;
772 
773     uint256 private _status;
774 
775     constructor() {
776         _status = _NOT_ENTERED;
777     }
778 
779     /**
780      * @dev Prevents a contract from calling itself, directly or indirectly.
781      * Calling a `nonReentrant` function from another `nonReentrant`
782      * function is not supported. It is possible to prevent this from happening
783      * by making the `nonReentrant` function external, and make it call a
784      * `private` function that does the actual work.
785      */
786     modifier nonReentrant() {
787         // On the first call to nonReentrant, _notEntered will be true
788         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
789 
790         // Any calls to nonReentrant after this point will fail
791         _status = _ENTERED;
792 
793         _;
794 
795         // By storing the original value once again, a refund is triggered (see
796         // https://eips.ethereum.org/EIPS/eip-2200)
797         _status = _NOT_ENTERED;
798     }
799 }
800 
801 
802 // File contracts/openzeppelin_contracts/contracts/security/Pausable.sol
803 
804 
805 
806 pragma solidity ^0.8.0;
807 
808 /**
809  * @dev Contract module which allows children to implement an emergency stop
810  * mechanism that can be triggered by an authorized account.
811  *
812  * This module is used through inheritance. It will make available the
813  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
814  * the functions of your contract. Note that they will not be pausable by
815  * simply including this module, only once the modifiers are put in place.
816  */
817 abstract contract Pausable is Context {
818     /**
819      * @dev Emitted when the pause is triggered by `account`.
820      */
821     event Paused(address account);
822 
823     /**
824      * @dev Emitted when the pause is lifted by `account`.
825      */
826     event Unpaused(address account);
827 
828     bool private _paused;
829 
830     /**
831      * @dev Initializes the contract in unpaused state.
832      */
833     constructor() {
834         _paused = false;
835     }
836 
837     /**
838      * @dev Returns true if the contract is paused, and false otherwise.
839      */
840     function paused() public view virtual returns (bool) {
841         return _paused;
842     }
843 
844     /**
845      * @dev Modifier to make a function callable only when the contract is not paused.
846      *
847      * Requirements:
848      *
849      * - The contract must not be paused.
850      */
851     modifier whenNotPaused() {
852         require(!paused(), "Pausable: paused");
853         _;
854     }
855 
856     /**
857      * @dev Modifier to make a function callable only when the contract is paused.
858      *
859      * Requirements:
860      *
861      * - The contract must be paused.
862      */
863     modifier whenPaused() {
864         require(paused(), "Pausable: not paused");
865         _;
866     }
867 
868     /**
869      * @dev Triggers stopped state.
870      *
871      * Requirements:
872      *
873      * - The contract must not be paused.
874      */
875     function _pause() internal virtual whenNotPaused {
876         _paused = true;
877         emit Paused(_msgSender());
878     }
879 
880     /**
881      * @dev Returns to normal state.
882      *
883      * Requirements:
884      *
885      * - The contract must be paused.
886      */
887     function _unpause() internal virtual whenPaused {
888         _paused = false;
889         emit Unpaused(_msgSender());
890     }
891 }
892 
893 
894 // File contracts/erc20delegate.sol
895 
896 
897 pragma solidity ^0.8.0;
898 pragma experimental ABIEncoderV2 ;
899 interface x22IERC721 {
900     function safeTransferFrom(address from, address to, uint256 tokenId) external;
901     function tokenOfOwnerByIndex(address _address , uint256 _index) external returns(uint256);
902     function balanceOf(address _address) external returns(uint256);
903     function ownerOf(uint256 _tokenId) external returns(address);
904     function mint(address) external;
905     function batchMint(address,uint256) external;
906     function faction() external returns(string memory);
907 }
908 
909 interface SwapPair {
910     function getReserves() external view
911         returns (
912             uint112 reserve0,
913             uint112 reserve1,
914             uint32 blockTimestampLast
915         );
916 }
917 
918 contract Whitelist is Ownable,Pausable {
919 
920     bool public isWhitelist;
921 
922     address[] public addressesList;
923     mapping(address => bool) private whitelist;
924 
925 
926     event AddressAddition(address indexed _address);
927     event AddressRemoval(address indexed _address);
928 
929     modifier onlyWhitlisted(){
930         require(isWhitelisted(msg.sender) || !isWhitelist,"Whitelist: address is not whitelisted");
931         _;
932     }
933 
934     constructor(bool _isWhitelist) public{
935         isWhitelist = _isWhitelist;
936         _pause();
937     }
938 
939     function isWhitelisted(address _address) public view returns (bool) {
940         return whitelist[_address];
941     }
942 
943     function addAddress(address _address) public onlyOwner() {
944         require(isWhitelist,"Whitelist: Not whitelist run");
945         // checks if the address is already whitelisted
946         if (whitelist[_address]) {
947             return;
948         }
949         whitelist[_address] = true;
950         addressesList.push(_address);
951         emit AddressAddition(_address);
952     }
953 
954     function addAddresses(address[] memory _addresses) public {
955         for (uint256 i = 0; i < _addresses.length; i++) {
956             addAddress(_addresses[i]);
957         }
958     }
959 
960     function removeAddress(address _address,uint256 _index) public onlyOwner() {
961         // checks if the address is actually whitelisted
962         require(_address == addressesList[_index],"Whitelist: _index is not a valid index");
963         if (!whitelist[_address]) {
964             return;
965         }
966 
967         whitelist[_address] = false;
968         emit AddressRemoval(_address);
969     }
970 
971     function removeAddresses(address[] memory _addresses,uint256[] memory _index) public {
972         for (uint256 i = 0; i < _addresses.length; i++) {
973             removeAddress(_addresses[i],_index[i]);
974         }
975     }
976 
977     function getWhitelistAddresses() public view returns(address[] memory){
978         return addressesList;
979     }
980 
981     function pause() public onlyOwner(){
982         _pause();
983     }
984 
985     function unpause() public onlyOwner(){
986         _unpause();
987     }
988 }
989 
990 // SPDX-License-Identifier: MIT
991 
992 contract Purchase is Whitelist,ReentrancyGuard {
993 
994     using SafeMath for uint256;
995     using SafeERC20 for IERC20;
996 
997     SwapPair public x22_eth_Pair;
998 
999     x22IERC721 public nft;
1000     IERC20 public x22;
1001 
1002     address payable public treasurerAddress;
1003 
1004     uint256 public constant DENOMINATOR = 10000;
1005 
1006     uint256 public maxTokenForOnePresaleTransaction;
1007     uint256 public maxTokenForOneSaleTransaction;
1008     uint256 public discount;
1009     uint256 public priceInETH;
1010 
1011     event BuyNFTforETH(address _buyer,uint256 _amount,uint256 _numberOfToken);
1012     event BuyNFTforX22(address _buyer,uint256 _amount,uint256 _numberOfToken);
1013     event UpdateWhitelist(bool _isWhitelist);
1014     event SetPrices(uint256 _priceInETH);
1015     event SetDiscount(uint256 _discount);
1016     event SetTokensLimit(uint256 _forPresale,uint256 _normalSale);
1017 
1018     modifier validTokensAmount(uint256 _numberOfToken){
1019         if(isWhitelist){
1020             require(_numberOfToken <= maxTokenForOnePresaleTransaction,"Purchase: enter valid token amount for presale");
1021         }
1022         else{
1023             require(_numberOfToken <= maxTokenForOneSaleTransaction,"Purchase: enter valid token amount for normal sale");
1024         }
1025         _;
1026     }
1027 
1028     constructor(address _nft,address _x22,address _pair,bool _isWhitelist) public Whitelist(_isWhitelist){
1029         require(_nft != address(0));
1030         require(_x22 != address(0));
1031         nft = x22IERC721(_nft);
1032         x22 = IERC20(_x22);
1033         x22_eth_Pair = SwapPair(_pair);
1034         priceInETH = 60000000000000000;
1035         discount = 5000;
1036         maxTokenForOneSaleTransaction = 2;
1037         maxTokenForOnePresaleTransaction = 2;
1038     }
1039 
1040     function setTokensLimit(uint256 _forPresale,uint256 _normalSale) public onlyOwner(){
1041         maxTokenForOnePresaleTransaction = _forPresale;
1042         maxTokenForOneSaleTransaction = _normalSale;
1043         emit SetTokensLimit(maxTokenForOnePresaleTransaction,maxTokenForOneSaleTransaction);
1044     }
1045 
1046     function updateWhitelist(bool _isWhitelist) public onlyOwner(){
1047         isWhitelist = _isWhitelist;
1048         emit UpdateWhitelist(isWhitelist);
1049     }
1050 
1051     function setPrices(uint256 _priceInETH) public onlyOwner() {
1052         require(_priceInETH > 0 ,"Purchase: Price must be greater than zero");
1053         priceInETH = _priceInETH;
1054         emit SetPrices(_priceInETH);
1055     }
1056 
1057     function setDiscount(uint _discount) public onlyOwner(){
1058         require(_discount > 0 && _discount <= DENOMINATOR,"Purchase: Discount in not valid ");
1059         discount = _discount;
1060         emit SetDiscount(discount);
1061     }
1062 
1063     function setTreasurerAddress(address payable _treasurerAddress) public onlyOwner(){
1064         require(_treasurerAddress != address(0),"Purchase: _treasurerAddress not be zero address");
1065         treasurerAddress = _treasurerAddress ;
1066     }
1067 
1068     function buyWithETH(uint256 _numberOfToken) public payable nonReentrant() validTokensAmount(_numberOfToken) whenNotPaused() onlyWhitlisted(){    
1069         require (_numberOfToken > 0 ,"Purchase: _numberOfToken must be greater than zero");
1070         require(msg.value >= priceInETH.mul(_numberOfToken),"Purchase: amount of ETH must be equal to token price" );
1071         uint256 extraAmount = msg.value.sub(priceInETH.mul(_numberOfToken));
1072         if(_safeTransferETH(treasurerAddress,priceInETH.mul(_numberOfToken))){
1073             nft.batchMint(msg.sender,_numberOfToken);
1074         }
1075         _safeTransferETH(msg.sender,extraAmount);
1076         emit BuyNFTforETH(msg.sender,priceInETH.mul(_numberOfToken),_numberOfToken);
1077 
1078     }
1079 
1080     function buyWithX22(uint256 amount,uint256 _numberOfToken) public nonReentrant() validTokensAmount(_numberOfToken) whenNotPaused() onlyWhitlisted(){
1081         require (_numberOfToken > 0 ,"Purchase: _numberOfToken must be greater than zero");
1082         require(amount >= amountToPay().mul(_numberOfToken), "Purchase: amount of x22 must be equal to token price");
1083         x22.transferFrom(msg.sender, treasurerAddress, amountToPay().mul(_numberOfToken));
1084         nft.batchMint(msg.sender,_numberOfToken);
1085         emit BuyNFTforX22(msg.sender,amountToPay().mul(_numberOfToken),_numberOfToken);
1086     }
1087 
1088     function amountToPay() public view returns(uint256) {
1089         uint256 temp = priceInETH.mul(DENOMINATOR.sub(discount)).div(DENOMINATOR);
1090         return getPriceInx22(temp);
1091     }
1092 
1093     function getPriceInx22(uint256 _amount) public view returns(uint256){
1094         (uint256 reserve0,uint256 reserve1,) = x22_eth_Pair.getReserves();
1095         uint256 temp = reserve0.mul(10**18).div(reserve1);
1096         return temp.mul(_amount).div(10**18);
1097     }
1098 
1099     function _safeTransferETH(address to, uint256 value) internal returns (bool) {
1100         (bool success, ) = to.call{value: value}(new bytes(0));
1101         return success;
1102     }
1103 }