1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/access/IAccessControl.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev External interface of AccessControl declared to support ERC165 detection.
238  */
239 interface IAccessControl {
240     /**
241      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
242      *
243      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
244      * {RoleAdminChanged} not being emitted signaling this.
245      *
246      * _Available since v3.1._
247      */
248     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
249 
250     /**
251      * @dev Emitted when `account` is granted `role`.
252      *
253      * `sender` is the account that originated the contract call, an admin role
254      * bearer except when using {AccessControl-_setupRole}.
255      */
256     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
257 
258     /**
259      * @dev Emitted when `account` is revoked `role`.
260      *
261      * `sender` is the account that originated the contract call:
262      *   - if using `revokeRole`, it is the admin role bearer
263      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
264      */
265     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
266 
267     /**
268      * @dev Returns `true` if `account` has been granted `role`.
269      */
270     function hasRole(bytes32 role, address account) external view returns (bool);
271 
272     /**
273      * @dev Returns the admin role that controls `role`. See {grantRole} and
274      * {revokeRole}.
275      *
276      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
277      */
278     function getRoleAdmin(bytes32 role) external view returns (bytes32);
279 
280     /**
281      * @dev Grants `role` to `account`.
282      *
283      * If `account` had not been already granted `role`, emits a {RoleGranted}
284      * event.
285      *
286      * Requirements:
287      *
288      * - the caller must have ``role``'s admin role.
289      */
290     function grantRole(bytes32 role, address account) external;
291 
292     /**
293      * @dev Revokes `role` from `account`.
294      *
295      * If `account` had been granted `role`, emits a {RoleRevoked} event.
296      *
297      * Requirements:
298      *
299      * - the caller must have ``role``'s admin role.
300      */
301     function revokeRole(bytes32 role, address account) external;
302 
303     /**
304      * @dev Revokes `role` from the calling account.
305      *
306      * Roles are often managed via {grantRole} and {revokeRole}: this function's
307      * purpose is to provide a mechanism for accounts to lose their privileges
308      * if they are compromised (such as when a trusted device is misplaced).
309      *
310      * If the calling account had been granted `role`, emits a {RoleRevoked}
311      * event.
312      *
313      * Requirements:
314      *
315      * - the caller must be `account`.
316      */
317     function renounceRole(bytes32 role, address account) external;
318 }
319 
320 // File: @openzeppelin/contracts/utils/Strings.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev String operations.
328  */
329 library Strings {
330     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
334      */
335     function toString(uint256 value) internal pure returns (string memory) {
336         // Inspired by OraclizeAPI's implementation - MIT licence
337         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
338 
339         if (value == 0) {
340             return "0";
341         }
342         uint256 temp = value;
343         uint256 digits;
344         while (temp != 0) {
345             digits++;
346             temp /= 10;
347         }
348         bytes memory buffer = new bytes(digits);
349         while (value != 0) {
350             digits -= 1;
351             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
352             value /= 10;
353         }
354         return string(buffer);
355     }
356 
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
359      */
360     function toHexString(uint256 value) internal pure returns (string memory) {
361         if (value == 0) {
362             return "0x00";
363         }
364         uint256 temp = value;
365         uint256 length = 0;
366         while (temp != 0) {
367             length++;
368             temp >>= 8;
369         }
370         return toHexString(value, length);
371     }
372 
373     /**
374      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
375      */
376     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
377         bytes memory buffer = new bytes(2 * length + 2);
378         buffer[0] = "0";
379         buffer[1] = "x";
380         for (uint256 i = 2 * length + 1; i > 1; --i) {
381             buffer[i] = _HEX_SYMBOLS[value & 0xf];
382             value >>= 4;
383         }
384         require(value == 0, "Strings: hex length insufficient");
385         return string(buffer);
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Context.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Provides information about the current execution context, including the
397  * sender of the transaction and its data. While these are generally available
398  * via msg.sender and msg.data, they should not be accessed in such a direct
399  * manner, since when dealing with meta-transactions the account sending and
400  * paying for execution may not be the actual sender (as far as an application
401  * is concerned).
402  *
403  * This contract is only required for intermediate, library-like contracts.
404  */
405 abstract contract Context {
406     function _msgSender() internal view virtual returns (address) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view virtual returns (bytes calldata) {
411         return msg.data;
412     }
413 }
414 
415 // File: @openzeppelin/contracts/access/Ownable.sol
416 
417 
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Contract module which provides a basic access control mechanism, where
424  * there is an account (an owner) that can be granted exclusive access to
425  * specific functions.
426  *
427  * By default, the owner account will be the one that deploys the contract. This
428  * can later be changed with {transferOwnership}.
429  *
430  * This module is used through inheritance. It will make available the modifier
431  * `onlyOwner`, which can be applied to your functions to restrict their use to
432  * the owner.
433  */
434 abstract contract Ownable is Context {
435     address private _owner;
436 
437     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438 
439     /**
440      * @dev Initializes the contract setting the deployer as the initial owner.
441      */
442     constructor() {
443         _setOwner(_msgSender());
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view virtual returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         require(owner() == _msgSender(), "Ownable: caller is not the owner");
458         _;
459     }
460 
461     /**
462      * @dev Leaves the contract without owner. It will not be possible to call
463      * `onlyOwner` functions anymore. Can only be called by the current owner.
464      *
465      * NOTE: Renouncing ownership will leave the contract without an owner,
466      * thereby removing any functionality that is only available to the owner.
467      */
468     function renounceOwnership() public virtual onlyOwner {
469         _setOwner(address(0));
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         _setOwner(newOwner);
479     }
480 
481     function _setOwner(address newOwner) private {
482         address oldOwner = _owner;
483         _owner = newOwner;
484         emit OwnershipTransferred(oldOwner, newOwner);
485     }
486 }
487 
488 // File: @openzeppelin/contracts/security/Pausable.sol
489 
490 
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Contract module which allows children to implement an emergency stop
497  * mechanism that can be triggered by an authorized account.
498  *
499  * This module is used through inheritance. It will make available the
500  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
501  * the functions of your contract. Note that they will not be pausable by
502  * simply including this module, only once the modifiers are put in place.
503  */
504 abstract contract Pausable is Context {
505     /**
506      * @dev Emitted when the pause is triggered by `account`.
507      */
508     event Paused(address account);
509 
510     /**
511      * @dev Emitted when the pause is lifted by `account`.
512      */
513     event Unpaused(address account);
514 
515     bool private _paused;
516 
517     /**
518      * @dev Initializes the contract in unpaused state.
519      */
520     constructor() {
521         _paused = false;
522     }
523 
524     /**
525      * @dev Returns true if the contract is paused, and false otherwise.
526      */
527     function paused() public view virtual returns (bool) {
528         return _paused;
529     }
530 
531     /**
532      * @dev Modifier to make a function callable only when the contract is not paused.
533      *
534      * Requirements:
535      *
536      * - The contract must not be paused.
537      */
538     modifier whenNotPaused() {
539         require(!paused(), "Pausable: paused");
540         _;
541     }
542 
543     /**
544      * @dev Modifier to make a function callable only when the contract is paused.
545      *
546      * Requirements:
547      *
548      * - The contract must be paused.
549      */
550     modifier whenPaused() {
551         require(paused(), "Pausable: not paused");
552         _;
553     }
554 
555     /**
556      * @dev Triggers stopped state.
557      *
558      * Requirements:
559      *
560      * - The contract must not be paused.
561      */
562     function _pause() internal virtual whenNotPaused {
563         _paused = true;
564         emit Paused(_msgSender());
565     }
566 
567     /**
568      * @dev Returns to normal state.
569      *
570      * Requirements:
571      *
572      * - The contract must be paused.
573      */
574     function _unpause() internal virtual whenPaused {
575         _paused = false;
576         emit Unpaused(_msgSender());
577     }
578 }
579 
580 // File: @openzeppelin/contracts/utils/Address.sol
581 
582 
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @dev Collection of functions related to the address type
588  */
589 library Address {
590     /**
591      * @dev Returns true if `account` is a contract.
592      *
593      * [IMPORTANT]
594      * ====
595      * It is unsafe to assume that an address for which this function returns
596      * false is an externally-owned account (EOA) and not a contract.
597      *
598      * Among others, `isContract` will return false for the following
599      * types of addresses:
600      *
601      *  - an externally-owned account
602      *  - a contract in construction
603      *  - an address where a contract will be created
604      *  - an address where a contract lived, but was destroyed
605      * ====
606      */
607     function isContract(address account) internal view returns (bool) {
608         // This method relies on extcodesize, which returns 0 for contracts in
609         // construction, since the code is only stored at the end of the
610         // constructor execution.
611 
612         uint256 size;
613         assembly {
614             size := extcodesize(account)
615         }
616         return size > 0;
617     }
618 
619     /**
620      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
621      * `recipient`, forwarding all available gas and reverting on errors.
622      *
623      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
624      * of certain opcodes, possibly making contracts go over the 2300 gas limit
625      * imposed by `transfer`, making them unable to receive funds via
626      * `transfer`. {sendValue} removes this limitation.
627      *
628      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
629      *
630      * IMPORTANT: because control is transferred to `recipient`, care must be
631      * taken to not create reentrancy vulnerabilities. Consider using
632      * {ReentrancyGuard} or the
633      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
634      */
635     function sendValue(address payable recipient, uint256 amount) internal {
636         require(address(this).balance >= amount, "Address: insufficient balance");
637 
638         (bool success, ) = recipient.call{value: amount}("");
639         require(success, "Address: unable to send value, recipient may have reverted");
640     }
641 
642     /**
643      * @dev Performs a Solidity function call using a low level `call`. A
644      * plain `call` is an unsafe replacement for a function call: use this
645      * function instead.
646      *
647      * If `target` reverts with a revert reason, it is bubbled up by this
648      * function (like regular Solidity function calls).
649      *
650      * Returns the raw returned data. To convert to the expected return value,
651      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
652      *
653      * Requirements:
654      *
655      * - `target` must be a contract.
656      * - calling `target` with `data` must not revert.
657      *
658      * _Available since v3.1._
659      */
660     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
661         return functionCall(target, data, "Address: low-level call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
666      * `errorMessage` as a fallback revert reason when `target` reverts.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(
671         address target,
672         bytes memory data,
673         string memory errorMessage
674     ) internal returns (bytes memory) {
675         return functionCallWithValue(target, data, 0, errorMessage);
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
680      * but also transferring `value` wei to `target`.
681      *
682      * Requirements:
683      *
684      * - the calling contract must have an ETH balance of at least `value`.
685      * - the called Solidity function must be `payable`.
686      *
687      * _Available since v3.1._
688      */
689     function functionCallWithValue(
690         address target,
691         bytes memory data,
692         uint256 value
693     ) internal returns (bytes memory) {
694         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
699      * with `errorMessage` as a fallback revert reason when `target` reverts.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(
704         address target,
705         bytes memory data,
706         uint256 value,
707         string memory errorMessage
708     ) internal returns (bytes memory) {
709         require(address(this).balance >= value, "Address: insufficient balance for call");
710         require(isContract(target), "Address: call to non-contract");
711 
712         (bool success, bytes memory returndata) = target.call{value: value}(data);
713         return verifyCallResult(success, returndata, errorMessage);
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
718      * but performing a static call.
719      *
720      * _Available since v3.3._
721      */
722     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
723         return functionStaticCall(target, data, "Address: low-level static call failed");
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
728      * but performing a static call.
729      *
730      * _Available since v3.3._
731      */
732     function functionStaticCall(
733         address target,
734         bytes memory data,
735         string memory errorMessage
736     ) internal view returns (bytes memory) {
737         require(isContract(target), "Address: static call to non-contract");
738 
739         (bool success, bytes memory returndata) = target.staticcall(data);
740         return verifyCallResult(success, returndata, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but performing a delegate call.
746      *
747      * _Available since v3.4._
748      */
749     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
750         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
755      * but performing a delegate call.
756      *
757      * _Available since v3.4._
758      */
759     function functionDelegateCall(
760         address target,
761         bytes memory data,
762         string memory errorMessage
763     ) internal returns (bytes memory) {
764         require(isContract(target), "Address: delegate call to non-contract");
765 
766         (bool success, bytes memory returndata) = target.delegatecall(data);
767         return verifyCallResult(success, returndata, errorMessage);
768     }
769 
770     /**
771      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
772      * revert reason using the provided one.
773      *
774      * _Available since v4.3._
775      */
776     function verifyCallResult(
777         bool success,
778         bytes memory returndata,
779         string memory errorMessage
780     ) internal pure returns (bytes memory) {
781         if (success) {
782             return returndata;
783         } else {
784             // Look for revert reason and bubble it up if present
785             if (returndata.length > 0) {
786                 // The easiest way to bubble the revert reason is using memory via assembly
787 
788                 assembly {
789                     let returndata_size := mload(returndata)
790                     revert(add(32, returndata), returndata_size)
791                 }
792             } else {
793                 revert(errorMessage);
794             }
795         }
796     }
797 }
798 
799 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
800 
801 
802 
803 pragma solidity ^0.8.0;
804 
805 /**
806  * @title ERC721 token receiver interface
807  * @dev Interface for any contract that wants to support safeTransfers
808  * from ERC721 asset contracts.
809  */
810 interface IERC721Receiver {
811     /**
812      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
813      * by `operator` from `from`, this function is called.
814      *
815      * It must return its Solidity selector to confirm the token transfer.
816      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
817      *
818      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
819      */
820     function onERC721Received(
821         address operator,
822         address from,
823         uint256 tokenId,
824         bytes calldata data
825     ) external returns (bytes4);
826 }
827 
828 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
829 
830 
831 
832 pragma solidity ^0.8.0;
833 
834 /**
835  * @dev Interface of the ERC165 standard, as defined in the
836  * https://eips.ethereum.org/EIPS/eip-165[EIP].
837  *
838  * Implementers can declare support of contract interfaces, which can then be
839  * queried by others ({ERC165Checker}).
840  *
841  * For an implementation, see {ERC165}.
842  */
843 interface IERC165 {
844     /**
845      * @dev Returns true if this contract implements the interface defined by
846      * `interfaceId`. See the corresponding
847      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
848      * to learn more about how these ids are created.
849      *
850      * This function call must use less than 30 000 gas.
851      */
852     function supportsInterface(bytes4 interfaceId) external view returns (bool);
853 }
854 
855 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
856 
857 
858 
859 pragma solidity ^0.8.0;
860 
861 
862 /**
863  * @dev Implementation of the {IERC165} interface.
864  *
865  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
866  * for the additional interface id that will be supported. For example:
867  *
868  * ```solidity
869  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
870  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
871  * }
872  * ```
873  *
874  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
875  */
876 abstract contract ERC165 is IERC165 {
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
881         return interfaceId == type(IERC165).interfaceId;
882     }
883 }
884 
885 // File: @openzeppelin/contracts/access/AccessControl.sol
886 
887 
888 
889 pragma solidity ^0.8.0;
890 
891 
892 
893 
894 
895 /**
896  * @dev Contract module that allows children to implement role-based access
897  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
898  * members except through off-chain means by accessing the contract event logs. Some
899  * applications may benefit from on-chain enumerability, for those cases see
900  * {AccessControlEnumerable}.
901  *
902  * Roles are referred to by their `bytes32` identifier. These should be exposed
903  * in the external API and be unique. The best way to achieve this is by
904  * using `public constant` hash digests:
905  *
906  * ```
907  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
908  * ```
909  *
910  * Roles can be used to represent a set of permissions. To restrict access to a
911  * function call, use {hasRole}:
912  *
913  * ```
914  * function foo() public {
915  *     require(hasRole(MY_ROLE, msg.sender));
916  *     ...
917  * }
918  * ```
919  *
920  * Roles can be granted and revoked dynamically via the {grantRole} and
921  * {revokeRole} functions. Each role has an associated admin role, and only
922  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
923  *
924  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
925  * that only accounts with this role will be able to grant or revoke other
926  * roles. More complex role relationships can be created by using
927  * {_setRoleAdmin}.
928  *
929  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
930  * grant and revoke this role. Extra precautions should be taken to secure
931  * accounts that have been granted it.
932  */
933 abstract contract AccessControl is Context, IAccessControl, ERC165 {
934     struct RoleData {
935         mapping(address => bool) members;
936         bytes32 adminRole;
937     }
938 
939     mapping(bytes32 => RoleData) private _roles;
940 
941     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
942 
943     /**
944      * @dev Modifier that checks that an account has a specific role. Reverts
945      * with a standardized message including the required role.
946      *
947      * The format of the revert reason is given by the following regular expression:
948      *
949      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
950      *
951      * _Available since v4.1._
952      */
953     modifier onlyRole(bytes32 role) {
954         _checkRole(role, _msgSender());
955         _;
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev Returns `true` if `account` has been granted `role`.
967      */
968     function hasRole(bytes32 role, address account) public view override returns (bool) {
969         return _roles[role].members[account];
970     }
971 
972     /**
973      * @dev Revert with a standard message if `account` is missing `role`.
974      *
975      * The format of the revert reason is given by the following regular expression:
976      *
977      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
978      */
979     function _checkRole(bytes32 role, address account) internal view {
980         if (!hasRole(role, account)) {
981             revert(
982                 string(
983                     abi.encodePacked(
984                         "AccessControl: account ",
985                         Strings.toHexString(uint160(account), 20),
986                         " is missing role ",
987                         Strings.toHexString(uint256(role), 32)
988                     )
989                 )
990             );
991         }
992     }
993 
994     /**
995      * @dev Returns the admin role that controls `role`. See {grantRole} and
996      * {revokeRole}.
997      *
998      * To change a role's admin, use {_setRoleAdmin}.
999      */
1000     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1001         return _roles[role].adminRole;
1002     }
1003 
1004     /**
1005      * @dev Grants `role` to `account`.
1006      *
1007      * If `account` had not been already granted `role`, emits a {RoleGranted}
1008      * event.
1009      *
1010      * Requirements:
1011      *
1012      * - the caller must have ``role``'s admin role.
1013      */
1014     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1015         _grantRole(role, account);
1016     }
1017 
1018     /**
1019      * @dev Revokes `role` from `account`.
1020      *
1021      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1022      *
1023      * Requirements:
1024      *
1025      * - the caller must have ``role``'s admin role.
1026      */
1027     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1028         _revokeRole(role, account);
1029     }
1030 
1031     /**
1032      * @dev Revokes `role` from the calling account.
1033      *
1034      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1035      * purpose is to provide a mechanism for accounts to lose their privileges
1036      * if they are compromised (such as when a trusted device is misplaced).
1037      *
1038      * If the calling account had been granted `role`, emits a {RoleRevoked}
1039      * event.
1040      *
1041      * Requirements:
1042      *
1043      * - the caller must be `account`.
1044      */
1045     function renounceRole(bytes32 role, address account) public virtual override {
1046         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1047 
1048         _revokeRole(role, account);
1049     }
1050 
1051     /**
1052      * @dev Grants `role` to `account`.
1053      *
1054      * If `account` had not been already granted `role`, emits a {RoleGranted}
1055      * event. Note that unlike {grantRole}, this function doesn't perform any
1056      * checks on the calling account.
1057      *
1058      * [WARNING]
1059      * ====
1060      * This function should only be called from the constructor when setting
1061      * up the initial roles for the system.
1062      *
1063      * Using this function in any other way is effectively circumventing the admin
1064      * system imposed by {AccessControl}.
1065      * ====
1066      */
1067     function _setupRole(bytes32 role, address account) internal virtual {
1068         _grantRole(role, account);
1069     }
1070 
1071     /**
1072      * @dev Sets `adminRole` as ``role``'s admin role.
1073      *
1074      * Emits a {RoleAdminChanged} event.
1075      */
1076     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1077         bytes32 previousAdminRole = getRoleAdmin(role);
1078         _roles[role].adminRole = adminRole;
1079         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1080     }
1081 
1082     function _grantRole(bytes32 role, address account) private {
1083         if (!hasRole(role, account)) {
1084             _roles[role].members[account] = true;
1085             emit RoleGranted(role, account, _msgSender());
1086         }
1087     }
1088 
1089     function _revokeRole(bytes32 role, address account) private {
1090         if (hasRole(role, account)) {
1091             _roles[role].members[account] = false;
1092             emit RoleRevoked(role, account, _msgSender());
1093         }
1094     }
1095 }
1096 
1097 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1098 
1099 
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @dev Required interface of an ERC721 compliant contract.
1106  */
1107 interface IERC721 is IERC165 {
1108     /**
1109      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1110      */
1111     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1112 
1113     /**
1114      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1115      */
1116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1117 
1118     /**
1119      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1120      */
1121     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1122 
1123     /**
1124      * @dev Returns the number of tokens in ``owner``'s account.
1125      */
1126     function balanceOf(address owner) external view returns (uint256 balance);
1127 
1128     /**
1129      * @dev Returns the owner of the `tokenId` token.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      */
1135     function ownerOf(uint256 tokenId) external view returns (address owner);
1136 
1137     /**
1138      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1139      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1140      *
1141      * Requirements:
1142      *
1143      * - `from` cannot be the zero address.
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must exist and be owned by `from`.
1146      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) external;
1156 
1157     /**
1158      * @dev Transfers `tokenId` token from `from` to `to`.
1159      *
1160      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1161      *
1162      * Requirements:
1163      *
1164      * - `from` cannot be the zero address.
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must be owned by `from`.
1167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function transferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) external;
1176 
1177     /**
1178      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1179      * The approval is cleared when the token is transferred.
1180      *
1181      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1182      *
1183      * Requirements:
1184      *
1185      * - The caller must own the token or be an approved operator.
1186      * - `tokenId` must exist.
1187      *
1188      * Emits an {Approval} event.
1189      */
1190     function approve(address to, uint256 tokenId) external;
1191 
1192     /**
1193      * @dev Returns the account approved for `tokenId` token.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      */
1199     function getApproved(uint256 tokenId) external view returns (address operator);
1200 
1201     /**
1202      * @dev Approve or remove `operator` as an operator for the caller.
1203      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1204      *
1205      * Requirements:
1206      *
1207      * - The `operator` cannot be the caller.
1208      *
1209      * Emits an {ApprovalForAll} event.
1210      */
1211     function setApprovalForAll(address operator, bool _approved) external;
1212 
1213     /**
1214      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1215      *
1216      * See {setApprovalForAll}
1217      */
1218     function isApprovedForAll(address owner, address operator) external view returns (bool);
1219 
1220     /**
1221      * @dev Safely transfers `tokenId` token from `from` to `to`.
1222      *
1223      * Requirements:
1224      *
1225      * - `from` cannot be the zero address.
1226      * - `to` cannot be the zero address.
1227      * - `tokenId` token must exist and be owned by `from`.
1228      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes calldata data
1238     ) external;
1239 }
1240 
1241 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1242 
1243 
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 
1248 /**
1249  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1250  * @dev See https://eips.ethereum.org/EIPS/eip-721
1251  */
1252 interface IERC721Enumerable is IERC721 {
1253     /**
1254      * @dev Returns the total amount of tokens stored by the contract.
1255      */
1256     function totalSupply() external view returns (uint256);
1257 
1258     /**
1259      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1260      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1261      */
1262     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1263 
1264     /**
1265      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1266      * Use along with {totalSupply} to enumerate all tokens.
1267      */
1268     function tokenByIndex(uint256 index) external view returns (uint256);
1269 }
1270 
1271 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1272 
1273 
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 
1278 /**
1279  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1280  * @dev See https://eips.ethereum.org/EIPS/eip-721
1281  */
1282 interface IERC721Metadata is IERC721 {
1283     /**
1284      * @dev Returns the token collection name.
1285      */
1286     function name() external view returns (string memory);
1287 
1288     /**
1289      * @dev Returns the token collection symbol.
1290      */
1291     function symbol() external view returns (string memory);
1292 
1293     /**
1294      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1295      */
1296     function tokenURI(uint256 tokenId) external view returns (string memory);
1297 }
1298 
1299 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1300 
1301 
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 
1306 
1307 
1308 
1309 
1310 
1311 
1312 /**
1313  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1314  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1315  * {ERC721Enumerable}.
1316  */
1317 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1318     using Address for address;
1319     using Strings for uint256;
1320 
1321     // Token name
1322     string private _name;
1323 
1324     // Token symbol
1325     string private _symbol;
1326 
1327     // Mapping from token ID to owner address
1328     mapping(uint256 => address) private _owners;
1329 
1330     // Mapping owner address to token count
1331     mapping(address => uint256) private _balances;
1332 
1333     // Mapping from token ID to approved address
1334     mapping(uint256 => address) private _tokenApprovals;
1335 
1336     // Mapping from owner to operator approvals
1337     mapping(address => mapping(address => bool)) private _operatorApprovals;
1338 
1339     /**
1340      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1341      */
1342     constructor(string memory name_, string memory symbol_) {
1343         _name = name_;
1344         _symbol = symbol_;
1345     }
1346 
1347     /**
1348      * @dev See {IERC165-supportsInterface}.
1349      */
1350     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1351         return
1352             interfaceId == type(IERC721).interfaceId ||
1353             interfaceId == type(IERC721Metadata).interfaceId ||
1354             super.supportsInterface(interfaceId);
1355     }
1356 
1357     /**
1358      * @dev See {IERC721-balanceOf}.
1359      */
1360     function balanceOf(address owner) public view virtual override returns (uint256) {
1361         require(owner != address(0), "ERC721: balance query for the zero address");
1362         return _balances[owner];
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-ownerOf}.
1367      */
1368     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1369         address owner = _owners[tokenId];
1370         require(owner != address(0), "ERC721: owner query for nonexistent token");
1371         return owner;
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Metadata-name}.
1376      */
1377     function name() public view virtual override returns (string memory) {
1378         return _name;
1379     }
1380 
1381     /**
1382      * @dev See {IERC721Metadata-symbol}.
1383      */
1384     function symbol() public view virtual override returns (string memory) {
1385         return _symbol;
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Metadata-tokenURI}.
1390      */
1391     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1392         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1393 
1394         string memory baseURI = _baseURI();
1395         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1396     }
1397 
1398     /**
1399      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1400      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1401      * by default, can be overriden in child contracts.
1402      */
1403     function _baseURI() internal view virtual returns (string memory) {
1404         return "";
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-approve}.
1409      */
1410     function approve(address to, uint256 tokenId) public virtual override {
1411         address owner = ERC721.ownerOf(tokenId);
1412         require(to != owner, "ERC721: approval to current owner");
1413 
1414         require(
1415             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1416             "ERC721: approve caller is not owner nor approved for all"
1417         );
1418 
1419         _approve(to, tokenId);
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-getApproved}.
1424      */
1425     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1426         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1427 
1428         return _tokenApprovals[tokenId];
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-setApprovalForAll}.
1433      */
1434     function setApprovalForAll(address operator, bool approved) public virtual override {
1435         require(operator != _msgSender(), "ERC721: approve to caller");
1436 
1437         _operatorApprovals[_msgSender()][operator] = approved;
1438         emit ApprovalForAll(_msgSender(), operator, approved);
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-isApprovedForAll}.
1443      */
1444     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1445         return _operatorApprovals[owner][operator];
1446     }
1447 
1448     /**
1449      * @dev See {IERC721-transferFrom}.
1450      */
1451     function transferFrom(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) public virtual override {
1456         //solhint-disable-next-line max-line-length
1457         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1458 
1459         _transfer(from, to, tokenId);
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-safeTransferFrom}.
1464      */
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId
1469     ) public virtual override {
1470         safeTransferFrom(from, to, tokenId, "");
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-safeTransferFrom}.
1475      */
1476     function safeTransferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         bytes memory _data
1481     ) public virtual override {
1482         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1483         _safeTransfer(from, to, tokenId, _data);
1484     }
1485 
1486     /**
1487      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1488      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1489      *
1490      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1491      *
1492      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1493      * implement alternative mechanisms to perform token transfer, such as signature-based.
1494      *
1495      * Requirements:
1496      *
1497      * - `from` cannot be the zero address.
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must exist and be owned by `from`.
1500      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _safeTransfer(
1505         address from,
1506         address to,
1507         uint256 tokenId,
1508         bytes memory _data
1509     ) internal virtual {
1510         _transfer(from, to, tokenId);
1511         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1512     }
1513 
1514     /**
1515      * @dev Returns whether `tokenId` exists.
1516      *
1517      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1518      *
1519      * Tokens start existing when they are minted (`_mint`),
1520      * and stop existing when they are burned (`_burn`).
1521      */
1522     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1523         return _owners[tokenId] != address(0);
1524     }
1525 
1526     /**
1527      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1528      *
1529      * Requirements:
1530      *
1531      * - `tokenId` must exist.
1532      */
1533     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1534         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1535         address owner = ERC721.ownerOf(tokenId);
1536         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1537     }
1538 
1539     /**
1540      * @dev Safely mints `tokenId` and transfers it to `to`.
1541      *
1542      * Requirements:
1543      *
1544      * - `tokenId` must not exist.
1545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1546      *
1547      * Emits a {Transfer} event.
1548      */
1549     function _safeMint(address to, uint256 tokenId) internal virtual {
1550         _safeMint(to, tokenId, "");
1551     }
1552 
1553     /**
1554      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1555      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1556      */
1557     function _safeMint(
1558         address to,
1559         uint256 tokenId,
1560         bytes memory _data
1561     ) internal virtual {
1562         _mint(to, tokenId);
1563         require(
1564             _checkOnERC721Received(address(0), to, tokenId, _data),
1565             "ERC721: transfer to non ERC721Receiver implementer"
1566         );
1567     }
1568 
1569     /**
1570      * @dev Mints `tokenId` and transfers it to `to`.
1571      *
1572      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must not exist.
1577      * - `to` cannot be the zero address.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _mint(address to, uint256 tokenId) internal virtual {
1582         require(to != address(0), "ERC721: mint to the zero address");
1583         require(!_exists(tokenId), "ERC721: token already minted");
1584 
1585         _beforeTokenTransfer(address(0), to, tokenId);
1586 
1587         _balances[to] += 1;
1588         _owners[tokenId] = to;
1589 
1590         emit Transfer(address(0), to, tokenId);
1591     }
1592 
1593     /**
1594      * @dev Destroys `tokenId`.
1595      * The approval is cleared when the token is burned.
1596      *
1597      * Requirements:
1598      *
1599      * - `tokenId` must exist.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function _burn(uint256 tokenId) internal virtual {
1604         address owner = ERC721.ownerOf(tokenId);
1605 
1606         _beforeTokenTransfer(owner, address(0), tokenId);
1607 
1608         // Clear approvals
1609         _approve(address(0), tokenId);
1610 
1611         _balances[owner] -= 1;
1612         delete _owners[tokenId];
1613 
1614         emit Transfer(owner, address(0), tokenId);
1615     }
1616 
1617     /**
1618      * @dev Transfers `tokenId` from `from` to `to`.
1619      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1620      *
1621      * Requirements:
1622      *
1623      * - `to` cannot be the zero address.
1624      * - `tokenId` token must be owned by `from`.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _transfer(
1629         address from,
1630         address to,
1631         uint256 tokenId
1632     ) internal virtual {
1633         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1634         require(to != address(0), "ERC721: transfer to the zero address");
1635 
1636         _beforeTokenTransfer(from, to, tokenId);
1637 
1638         // Clear approvals from the previous owner
1639         _approve(address(0), tokenId);
1640 
1641         _balances[from] -= 1;
1642         _balances[to] += 1;
1643         _owners[tokenId] = to;
1644 
1645         emit Transfer(from, to, tokenId);
1646     }
1647 
1648     /**
1649      * @dev Approve `to` to operate on `tokenId`
1650      *
1651      * Emits a {Approval} event.
1652      */
1653     function _approve(address to, uint256 tokenId) internal virtual {
1654         _tokenApprovals[tokenId] = to;
1655         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1656     }
1657 
1658     /**
1659      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1660      * The call is not executed if the target address is not a contract.
1661      *
1662      * @param from address representing the previous owner of the given token ID
1663      * @param to target address that will receive the tokens
1664      * @param tokenId uint256 ID of the token to be transferred
1665      * @param _data bytes optional data to send along with the call
1666      * @return bool whether the call correctly returned the expected magic value
1667      */
1668     function _checkOnERC721Received(
1669         address from,
1670         address to,
1671         uint256 tokenId,
1672         bytes memory _data
1673     ) private returns (bool) {
1674         if (to.isContract()) {
1675             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1676                 return retval == IERC721Receiver.onERC721Received.selector;
1677             } catch (bytes memory reason) {
1678                 if (reason.length == 0) {
1679                     revert("ERC721: transfer to non ERC721Receiver implementer");
1680                 } else {
1681                     assembly {
1682                         revert(add(32, reason), mload(reason))
1683                     }
1684                 }
1685             }
1686         } else {
1687             return true;
1688         }
1689     }
1690 
1691     /**
1692      * @dev Hook that is called before any token transfer. This includes minting
1693      * and burning.
1694      *
1695      * Calling conditions:
1696      *
1697      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1698      * transferred to `to`.
1699      * - When `from` is zero, `tokenId` will be minted for `to`.
1700      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1701      * - `from` and `to` are never both zero.
1702      *
1703      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1704      */
1705     function _beforeTokenTransfer(
1706         address from,
1707         address to,
1708         uint256 tokenId
1709     ) internal virtual {}
1710 }
1711 
1712 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1713 
1714 
1715 
1716 pragma solidity ^0.8.0;
1717 
1718 
1719 
1720 /**
1721  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1722  * enumerability of all the token ids in the contract as well as all token ids owned by each
1723  * account.
1724  */
1725 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1726     // Mapping from owner to list of owned token IDs
1727     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1728 
1729     // Mapping from token ID to index of the owner tokens list
1730     mapping(uint256 => uint256) private _ownedTokensIndex;
1731 
1732     // Array with all token ids, used for enumeration
1733     uint256[] private _allTokens;
1734 
1735     // Mapping from token id to position in the allTokens array
1736     mapping(uint256 => uint256) private _allTokensIndex;
1737 
1738     /**
1739      * @dev See {IERC165-supportsInterface}.
1740      */
1741     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1742         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1743     }
1744 
1745     /**
1746      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1747      */
1748     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1749         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1750         return _ownedTokens[owner][index];
1751     }
1752 
1753     /**
1754      * @dev See {IERC721Enumerable-totalSupply}.
1755      */
1756     function totalSupply() public view virtual override returns (uint256) {
1757         return _allTokens.length;
1758     }
1759 
1760     /**
1761      * @dev See {IERC721Enumerable-tokenByIndex}.
1762      */
1763     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1764         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1765         return _allTokens[index];
1766     }
1767 
1768     /**
1769      * @dev Hook that is called before any token transfer. This includes minting
1770      * and burning.
1771      *
1772      * Calling conditions:
1773      *
1774      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1775      * transferred to `to`.
1776      * - When `from` is zero, `tokenId` will be minted for `to`.
1777      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1778      * - `from` cannot be the zero address.
1779      * - `to` cannot be the zero address.
1780      *
1781      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1782      */
1783     function _beforeTokenTransfer(
1784         address from,
1785         address to,
1786         uint256 tokenId
1787     ) internal virtual override {
1788         super._beforeTokenTransfer(from, to, tokenId);
1789 
1790         if (from == address(0)) {
1791             _addTokenToAllTokensEnumeration(tokenId);
1792         } else if (from != to) {
1793             _removeTokenFromOwnerEnumeration(from, tokenId);
1794         }
1795         if (to == address(0)) {
1796             _removeTokenFromAllTokensEnumeration(tokenId);
1797         } else if (to != from) {
1798             _addTokenToOwnerEnumeration(to, tokenId);
1799         }
1800     }
1801 
1802     /**
1803      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1804      * @param to address representing the new owner of the given token ID
1805      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1806      */
1807     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1808         uint256 length = ERC721.balanceOf(to);
1809         _ownedTokens[to][length] = tokenId;
1810         _ownedTokensIndex[tokenId] = length;
1811     }
1812 
1813     /**
1814      * @dev Private function to add a token to this extension's token tracking data structures.
1815      * @param tokenId uint256 ID of the token to be added to the tokens list
1816      */
1817     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1818         _allTokensIndex[tokenId] = _allTokens.length;
1819         _allTokens.push(tokenId);
1820     }
1821 
1822     /**
1823      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1824      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1825      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1826      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1827      * @param from address representing the previous owner of the given token ID
1828      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1829      */
1830     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1831         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1832         // then delete the last slot (swap and pop).
1833 
1834         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1835         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1836 
1837         // When the token to delete is the last token, the swap operation is unnecessary
1838         if (tokenIndex != lastTokenIndex) {
1839             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1840 
1841             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1842             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1843         }
1844 
1845         // This also deletes the contents at the last position of the array
1846         delete _ownedTokensIndex[tokenId];
1847         delete _ownedTokens[from][lastTokenIndex];
1848     }
1849 
1850     /**
1851      * @dev Private function to remove a token from this extension's token tracking data structures.
1852      * This has O(1) time complexity, but alters the order of the _allTokens array.
1853      * @param tokenId uint256 ID of the token to be removed from the tokens list
1854      */
1855     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1856         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1857         // then delete the last slot (swap and pop).
1858 
1859         uint256 lastTokenIndex = _allTokens.length - 1;
1860         uint256 tokenIndex = _allTokensIndex[tokenId];
1861 
1862         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1863         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1864         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1865         uint256 lastTokenId = _allTokens[lastTokenIndex];
1866 
1867         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1868         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1869 
1870         // This also deletes the contents at the last position of the array
1871         delete _allTokensIndex[tokenId];
1872         _allTokens.pop();
1873     }
1874 }
1875 
1876 // File: contracts/RoyalEggs.sol
1877 
1878 
1879 pragma solidity ^0.8.0;
1880 
1881 
1882 
1883 
1884 
1885 
1886 
1887 contract RoyalEggs is ERC721Enumerable, Ownable, AccessControl {
1888 
1889     using Strings for uint256; 
1890 
1891     string baseURI;
1892     bytes32 public constant TEAM_ROLE = keccak256("TEAM_ROLE");
1893     uint256 public constant TOTAL_EGGS_SUPPLY = 8888;
1894     uint256 public constant max_mint_transactions = 11;
1895     uint256 public constant max_eggs_per_wallet = 12;
1896     uint256 public cost = 0.05 ether;
1897     uint256 public pre_mint_supply = 2000;
1898     uint256 public giveaway_supply = 300;
1899 
1900     mapping(address => bool) private _pre_sale_minters;
1901 
1902     bool public paused_mint = true;
1903     bool public paused_pre_mint = true;
1904     bool public revealed = false;
1905     string public notRevealedUri;
1906 
1907     // withdraw addresses
1908     address royaleggs_treasury;
1909 
1910     modifier whenMintNotPaused() {
1911         require(!paused_mint, "RoyalEggs: mint is paused");
1912         _;
1913     }
1914 
1915     modifier whenPreMintNotPaused() {
1916         require(!paused_pre_mint, "RoyalEggs: pre mint is paused");
1917         _;
1918     }
1919 
1920     modifier preMintAllowedAccount(address account) {
1921         require(is_pre_mint_allowed(account), "RoyalEggs: account is not allowed to pre mint");
1922         _;
1923     }
1924 
1925     event MintPaused(address account);
1926 
1927     event MintUnpaused(address account);
1928 
1929     event PreMintPaused(address account);
1930 
1931     event PreMintUnpaused(address account);
1932 
1933     event setPreMintRole(address account);
1934 
1935     event redeemedPreMint(address account);
1936 
1937 
1938     constructor(
1939         string memory _name,
1940         string memory _symbol,
1941         address _royaleggs_treasury,
1942         string memory _initBaseURI,
1943         string memory _initNotRevealedUri
1944     )
1945         ERC721(_name, _symbol)
1946     {   
1947 
1948         royaleggs_treasury = _royaleggs_treasury;
1949         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1950         _setupRole(TEAM_ROLE, msg.sender);
1951 
1952         setBaseURI(_initBaseURI);
1953         setNotRevealedURI(_initNotRevealedUri);
1954 
1955     }
1956 
1957     fallback() external payable { }
1958 
1959     receive() external payable { }
1960 
1961     function mint(uint256 num) public payable whenMintNotPaused(){
1962         uint256 supply = totalSupply();
1963         uint256 tokenCount = balanceOf(msg.sender);
1964         require( num <= max_mint_transactions,                              "RoyalEggs: Max Royal Eggs per mint exceeded ! try less " );
1965         require( tokenCount + num <= max_eggs_per_wallet,                   "RoyalEggs: Max Royal Eggs per wallet exceeded ! WOW Many thanks <3" );
1966         require( supply + num <= TOTAL_EGGS_SUPPLY - giveaway_supply,       "RoyalEggs: No More Eggs :(" );
1967         require( msg.value >= cost * num,                                   "RoyalEggs: Not enough to cover the transaction " );
1968 
1969         for(uint256 i; i < num; i++){
1970             _safeMint( msg.sender, supply + i );
1971         }
1972     }
1973 
1974     function pre_mint() public payable whenPreMintNotPaused() preMintAllowedAccount(msg.sender){
1975         require( pre_mint_supply > 0,         "RoyalEggs: No More Eggs for pre mint" );
1976         require( msg.value >= cost,            "RoyalEggs: Not enough to cover cost " );
1977         _pre_sale_minters[msg.sender] = false;
1978         pre_mint_supply -= 1;
1979         uint256 supply = totalSupply();
1980         _safeMint( msg.sender, supply);
1981         emit redeemedPreMint(msg.sender);
1982     }
1983 
1984     function giveAway(address _to) external onlyRole(TEAM_ROLE) {
1985         require(giveaway_supply > 0, "RoyalEggs: No More Free Eggs" );
1986         giveaway_supply -= 1;
1987         uint256 supply = totalSupply();
1988         _safeMint( _to, supply);
1989     }
1990 
1991     function setCost(uint256 _newCost) public onlyRole(TEAM_ROLE) {
1992         cost = _newCost;
1993     
1994     }
1995     
1996     function pauseMint() public onlyRole(TEAM_ROLE) {
1997         paused_mint = true;
1998         emit MintPaused(msg.sender);
1999     }
2000 
2001     function unpauseMint() public onlyRole(TEAM_ROLE) {
2002         paused_mint = false;
2003         emit MintUnpaused(msg.sender);
2004     }
2005 
2006     function pausePreMint() public onlyRole(TEAM_ROLE) {
2007         paused_pre_mint = true;
2008         emit PreMintPaused(msg.sender);
2009     }
2010 
2011     function unpausePreMint() public onlyRole(TEAM_ROLE) {
2012         paused_pre_mint = false;
2013         emit PreMintUnpaused(msg.sender);
2014     }
2015 
2016     function updateTreasuryWalletAddress(address _royaleggs_treasury) public onlyRole(TEAM_ROLE) {
2017         royaleggs_treasury = _royaleggs_treasury;
2018     }
2019 
2020     function setPreMintRoleBatch(address[] calldata _addresses) external onlyRole(TEAM_ROLE) {
2021         for(uint256 i; i < _addresses.length; i++){
2022             _pre_sale_minters[_addresses[i]] = true;
2023             emit setPreMintRole(_addresses[i]);
2024         }
2025     }
2026 
2027     function reaveal() public onlyRole(TEAM_ROLE) {
2028         revealed = true;
2029     }
2030 
2031     function setBaseURI(string memory _newBaseURI) public onlyRole(TEAM_ROLE) {
2032         baseURI = _newBaseURI;
2033     }
2034 
2035     function setNotRevealedURI(string memory _notRevealedURI) public onlyRole(TEAM_ROLE) {
2036         notRevealedUri = _notRevealedURI;
2037     }
2038 
2039     // internal
2040     function _baseURI() internal view virtual override returns (string memory) {
2041         return baseURI;
2042     }
2043 
2044     function withdrawAllToTreasury() public onlyRole(TEAM_ROLE) {
2045         uint256 _balance = address(this).balance ;
2046         require(_balance > 0, "RoyalEggs: No Balance");
2047         require(payable(royaleggs_treasury).send(_balance), "RoyalEggs: FAILED to withdraw ");
2048     }
2049 
2050     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2051         require(_exists(tokenId), "RoyalEggs: URI query for nonexistent token");
2052 
2053         if (revealed == false) {
2054             return notRevealedUri;
2055         }
2056         
2057         string memory currentBaseURI = _baseURI();
2058         string memory json = ".json";
2059         return bytes(currentBaseURI).length > 0
2060             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), json))
2061             : '';
2062     }
2063 
2064     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
2065         uint256 tokenCount = balanceOf(_owner);
2066 
2067         uint256[] memory tokensId = new uint256[](tokenCount);
2068         for(uint256 i; i < tokenCount; i++){
2069             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2070         }
2071         return tokensId;
2072     }
2073 
2074     function getTreasuryWallet() public view onlyRole(TEAM_ROLE) returns(address wallet) {
2075         return royaleggs_treasury;
2076     }
2077 
2078     function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, AccessControl) returns (bool) {
2079         return super.supportsInterface(interfaceId);
2080     }
2081 
2082     function is_pre_mint_allowed(address account) public view returns (bool) {
2083         return _pre_sale_minters[account];
2084     }
2085 }