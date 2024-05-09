1 // File: contracts/interfaces/IMisphits.sol
2 
3 //SPDX-License-Identifier: UNLICENSED
4 pragma solidity ^0.8.11;
5 interface IMisphits {
6      function mint(address to, uint256 amount) external;
7      function totalSupply() external view returns (uint256);
8      function ownerOf(uint256 tokenId) external view returns (address);
9      function transfer(address to, uint256 tokenId) external;
10 }
11 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 
47 /**
48  * @dev Implementation of the {IERC165} interface.
49  *
50  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
51  * for the additional interface id that will be supported. For example:
52  *
53  * ```solidity
54  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
55  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
56  * }
57  * ```
58  *
59  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
60  */
61 abstract contract ERC165 is IERC165 {
62     /**
63      * @dev See {IERC165-supportsInterface}.
64      */
65     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
66         return interfaceId == type(IERC165).interfaceId;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/access/IAccessControl.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev External interface of AccessControl declared to support ERC165 detection.
79  */
80 interface IAccessControl {
81     /**
82      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
83      *
84      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
85      * {RoleAdminChanged} not being emitted signaling this.
86      *
87      * _Available since v3.1._
88      */
89     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
90 
91     /**
92      * @dev Emitted when `account` is granted `role`.
93      *
94      * `sender` is the account that originated the contract call, an admin role
95      * bearer except when using {AccessControl-_setupRole}.
96      */
97     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
98 
99     /**
100      * @dev Emitted when `account` is revoked `role`.
101      *
102      * `sender` is the account that originated the contract call:
103      *   - if using `revokeRole`, it is the admin role bearer
104      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
105      */
106     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
107 
108     /**
109      * @dev Returns `true` if `account` has been granted `role`.
110      */
111     function hasRole(bytes32 role, address account) external view returns (bool);
112 
113     /**
114      * @dev Returns the admin role that controls `role`. See {grantRole} and
115      * {revokeRole}.
116      *
117      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
118      */
119     function getRoleAdmin(bytes32 role) external view returns (bytes32);
120 
121     /**
122      * @dev Grants `role` to `account`.
123      *
124      * If `account` had not been already granted `role`, emits a {RoleGranted}
125      * event.
126      *
127      * Requirements:
128      *
129      * - the caller must have ``role``'s admin role.
130      */
131     function grantRole(bytes32 role, address account) external;
132 
133     /**
134      * @dev Revokes `role` from `account`.
135      *
136      * If `account` had been granted `role`, emits a {RoleRevoked} event.
137      *
138      * Requirements:
139      *
140      * - the caller must have ``role``'s admin role.
141      */
142     function revokeRole(bytes32 role, address account) external;
143 
144     /**
145      * @dev Revokes `role` from the calling account.
146      *
147      * Roles are often managed via {grantRole} and {revokeRole}: this function's
148      * purpose is to provide a mechanism for accounts to lose their privileges
149      * if they are compromised (such as when a trusted device is misplaced).
150      *
151      * If the calling account had been granted `role`, emits a {RoleRevoked}
152      * event.
153      *
154      * Requirements:
155      *
156      * - the caller must be `account`.
157      */
158     function renounceRole(bytes32 role, address account) external;
159 }
160 
161 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Contract module that helps prevent reentrant calls to a function.
170  *
171  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
172  * available, which can be applied to functions to make sure there are no nested
173  * (reentrant) calls to them.
174  *
175  * Note that because there is a single `nonReentrant` guard, functions marked as
176  * `nonReentrant` may not call one another. This can be worked around by making
177  * those functions `private`, and then adding `external` `nonReentrant` entry
178  * points to them.
179  *
180  * TIP: If you would like to learn more about reentrancy and alternative ways
181  * to protect against it, check out our blog post
182  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
183  */
184 abstract contract ReentrancyGuard {
185     // Booleans are more expensive than uint256 or any type that takes up a full
186     // word because each write operation emits an extra SLOAD to first read the
187     // slot's contents, replace the bits taken up by the boolean, and then write
188     // back. This is the compiler's defense against contract upgrades and
189     // pointer aliasing, and it cannot be disabled.
190 
191     // The values being non-zero value makes deployment a bit more expensive,
192     // but in exchange the refund on every call to nonReentrant will be lower in
193     // amount. Since refunds are capped to a percentage of the total
194     // transaction's gas, it is best to keep them low in cases like this one, to
195     // increase the likelihood of the full refund coming into effect.
196     uint256 private constant _NOT_ENTERED = 1;
197     uint256 private constant _ENTERED = 2;
198 
199     uint256 private _status;
200 
201     constructor() {
202         _status = _NOT_ENTERED;
203     }
204 
205     /**
206      * @dev Prevents a contract from calling itself, directly or indirectly.
207      * Calling a `nonReentrant` function from another `nonReentrant`
208      * function is not supported. It is possible to prevent this from happening
209      * by making the `nonReentrant` function external, and making it call a
210      * `private` function that does the actual work.
211      */
212     modifier nonReentrant() {
213         // On the first call to nonReentrant, _notEntered will be true
214         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
215 
216         // Any calls to nonReentrant after this point will fail
217         _status = _ENTERED;
218 
219         _;
220 
221         // By storing the original value once again, a refund is triggered (see
222         // https://eips.ethereum.org/EIPS/eip-2200)
223         _status = _NOT_ENTERED;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 // CAUTION
235 // This version of SafeMath should only be used with Solidity 0.8 or later,
236 // because it relies on the compiler's built in overflow checks.
237 
238 /**
239  * @dev Wrappers over Solidity's arithmetic operations.
240  *
241  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
242  * now has built in overflow checking.
243  */
244 library SafeMath {
245     /**
246      * @dev Returns the addition of two unsigned integers, with an overflow flag.
247      *
248      * _Available since v3.4._
249      */
250     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             uint256 c = a + b;
253             if (c < a) return (false, 0);
254             return (true, c);
255         }
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
260      *
261      * _Available since v3.4._
262      */
263     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (b > a) return (false, 0);
266             return (true, a - b);
267         }
268     }
269 
270     /**
271      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
272      *
273      * _Available since v3.4._
274      */
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
278             // benefit is lost if 'b' is also tested.
279             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
280             if (a == 0) return (true, 0);
281             uint256 c = a * b;
282             if (c / a != b) return (false, 0);
283             return (true, c);
284         }
285     }
286 
287     /**
288      * @dev Returns the division of two unsigned integers, with a division by zero flag.
289      *
290      * _Available since v3.4._
291      */
292     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         unchecked {
294             if (b == 0) return (false, 0);
295             return (true, a / b);
296         }
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
301      *
302      * _Available since v3.4._
303      */
304     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         unchecked {
306             if (b == 0) return (false, 0);
307             return (true, a % b);
308         }
309     }
310 
311     /**
312      * @dev Returns the addition of two unsigned integers, reverting on
313      * overflow.
314      *
315      * Counterpart to Solidity's `+` operator.
316      *
317      * Requirements:
318      *
319      * - Addition cannot overflow.
320      */
321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a + b;
323     }
324 
325     /**
326      * @dev Returns the subtraction of two unsigned integers, reverting on
327      * overflow (when the result is negative).
328      *
329      * Counterpart to Solidity's `-` operator.
330      *
331      * Requirements:
332      *
333      * - Subtraction cannot overflow.
334      */
335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a - b;
337     }
338 
339     /**
340      * @dev Returns the multiplication of two unsigned integers, reverting on
341      * overflow.
342      *
343      * Counterpart to Solidity's `*` operator.
344      *
345      * Requirements:
346      *
347      * - Multiplication cannot overflow.
348      */
349     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a * b;
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers, reverting on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator.
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function div(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a / b;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * reverting when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
380         return a % b;
381     }
382 
383     /**
384      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
385      * overflow (when the result is negative).
386      *
387      * CAUTION: This function is deprecated because it requires allocating memory for the error
388      * message unnecessarily. For custom revert reasons use {trySub}.
389      *
390      * Counterpart to Solidity's `-` operator.
391      *
392      * Requirements:
393      *
394      * - Subtraction cannot overflow.
395      */
396     function sub(
397         uint256 a,
398         uint256 b,
399         string memory errorMessage
400     ) internal pure returns (uint256) {
401         unchecked {
402             require(b <= a, errorMessage);
403             return a - b;
404         }
405     }
406 
407     /**
408      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
409      * division by zero. The result is rounded towards zero.
410      *
411      * Counterpart to Solidity's `/` operator. Note: this function uses a
412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
413      * uses an invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function div(
420         uint256 a,
421         uint256 b,
422         string memory errorMessage
423     ) internal pure returns (uint256) {
424         unchecked {
425             require(b > 0, errorMessage);
426             return a / b;
427         }
428     }
429 
430     /**
431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
432      * reverting with custom message when dividing by zero.
433      *
434      * CAUTION: This function is deprecated because it requires allocating memory for the error
435      * message unnecessarily. For custom revert reasons use {tryMod}.
436      *
437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
438      * opcode (which leaves remaining gas untouched) while Solidity uses an
439      * invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function mod(
446         uint256 a,
447         uint256 b,
448         string memory errorMessage
449     ) internal pure returns (uint256) {
450         unchecked {
451             require(b > 0, errorMessage);
452             return a % b;
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/interfaces/IERC1271.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Interface of the ERC1271 standard signature validation method for
466  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
467  *
468  * _Available since v4.1._
469  */
470 interface IERC1271 {
471     /**
472      * @dev Should return whether the signature provided is valid for the provided data
473      * @param hash      Hash of the data to be signed
474      * @param signature Signature byte array associated with _data
475      */
476     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
477 }
478 
479 // File: @openzeppelin/contracts/utils/Address.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
483 
484 pragma solidity ^0.8.1;
485 
486 /**
487  * @dev Collection of functions related to the address type
488  */
489 library Address {
490     /**
491      * @dev Returns true if `account` is a contract.
492      *
493      * [IMPORTANT]
494      * ====
495      * It is unsafe to assume that an address for which this function returns
496      * false is an externally-owned account (EOA) and not a contract.
497      *
498      * Among others, `isContract` will return false for the following
499      * types of addresses:
500      *
501      *  - an externally-owned account
502      *  - a contract in construction
503      *  - an address where a contract will be created
504      *  - an address where a contract lived, but was destroyed
505      * ====
506      *
507      * [IMPORTANT]
508      * ====
509      * You shouldn't rely on `isContract` to protect against flash loan attacks!
510      *
511      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
512      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
513      * constructor.
514      * ====
515      */
516     function isContract(address account) internal view returns (bool) {
517         // This method relies on extcodesize/address.code.length, which returns 0
518         // for contracts in construction, since the code is only stored at the end
519         // of the constructor execution.
520 
521         return account.code.length > 0;
522     }
523 
524     /**
525      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
526      * `recipient`, forwarding all available gas and reverting on errors.
527      *
528      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
529      * of certain opcodes, possibly making contracts go over the 2300 gas limit
530      * imposed by `transfer`, making them unable to receive funds via
531      * `transfer`. {sendValue} removes this limitation.
532      *
533      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
534      *
535      * IMPORTANT: because control is transferred to `recipient`, care must be
536      * taken to not create reentrancy vulnerabilities. Consider using
537      * {ReentrancyGuard} or the
538      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
539      */
540     function sendValue(address payable recipient, uint256 amount) internal {
541         require(address(this).balance >= amount, "Address: insufficient balance");
542 
543         (bool success, ) = recipient.call{value: amount}("");
544         require(success, "Address: unable to send value, recipient may have reverted");
545     }
546 
547     /**
548      * @dev Performs a Solidity function call using a low level `call`. A
549      * plain `call` is an unsafe replacement for a function call: use this
550      * function instead.
551      *
552      * If `target` reverts with a revert reason, it is bubbled up by this
553      * function (like regular Solidity function calls).
554      *
555      * Returns the raw returned data. To convert to the expected return value,
556      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
557      *
558      * Requirements:
559      *
560      * - `target` must be a contract.
561      * - calling `target` with `data` must not revert.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionCall(target, data, "Address: low-level call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
571      * `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         return functionCallWithValue(target, data, 0, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but also transferring `value` wei to `target`.
586      *
587      * Requirements:
588      *
589      * - the calling contract must have an ETH balance of at least `value`.
590      * - the called Solidity function must be `payable`.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value
598     ) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
604      * with `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCallWithValue(
609         address target,
610         bytes memory data,
611         uint256 value,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         require(address(this).balance >= value, "Address: insufficient balance for call");
615         require(isContract(target), "Address: call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.call{value: value}(data);
618         return verifyCallResult(success, returndata, errorMessage);
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
644         (bool success, bytes memory returndata) = target.staticcall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
660      * but performing a delegate call.
661      *
662      * _Available since v3.4._
663      */
664     function functionDelegateCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal returns (bytes memory) {
669         require(isContract(target), "Address: delegate call to non-contract");
670 
671         (bool success, bytes memory returndata) = target.delegatecall(data);
672         return verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
677      * revert reason using the provided one.
678      *
679      * _Available since v4.3._
680      */
681     function verifyCallResult(
682         bool success,
683         bytes memory returndata,
684         string memory errorMessage
685     ) internal pure returns (bytes memory) {
686         if (success) {
687             return returndata;
688         } else {
689             // Look for revert reason and bubble it up if present
690             if (returndata.length > 0) {
691                 // The easiest way to bubble the revert reason is using memory via assembly
692                 /// @solidity memory-safe-assembly
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
704 // File: @openzeppelin/contracts/utils/Strings.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 /**
712  * @dev String operations.
713  */
714 library Strings {
715     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
716     uint8 private constant _ADDRESS_LENGTH = 20;
717 
718     /**
719      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
720      */
721     function toString(uint256 value) internal pure returns (string memory) {
722         // Inspired by OraclizeAPI's implementation - MIT licence
723         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
724 
725         if (value == 0) {
726             return "0";
727         }
728         uint256 temp = value;
729         uint256 digits;
730         while (temp != 0) {
731             digits++;
732             temp /= 10;
733         }
734         bytes memory buffer = new bytes(digits);
735         while (value != 0) {
736             digits -= 1;
737             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
738             value /= 10;
739         }
740         return string(buffer);
741     }
742 
743     /**
744      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
745      */
746     function toHexString(uint256 value) internal pure returns (string memory) {
747         if (value == 0) {
748             return "0x00";
749         }
750         uint256 temp = value;
751         uint256 length = 0;
752         while (temp != 0) {
753             length++;
754             temp >>= 8;
755         }
756         return toHexString(value, length);
757     }
758 
759     /**
760      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
761      */
762     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
763         bytes memory buffer = new bytes(2 * length + 2);
764         buffer[0] = "0";
765         buffer[1] = "x";
766         for (uint256 i = 2 * length + 1; i > 1; --i) {
767             buffer[i] = _HEX_SYMBOLS[value & 0xf];
768             value >>= 4;
769         }
770         require(value == 0, "Strings: hex length insufficient");
771         return string(buffer);
772     }
773 
774     /**
775      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
776      */
777     function toHexString(address addr) internal pure returns (string memory) {
778         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
779     }
780 }
781 
782 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
792  *
793  * These functions can be used to verify that a message was signed by the holder
794  * of the private keys of a given address.
795  */
796 library ECDSA {
797     enum RecoverError {
798         NoError,
799         InvalidSignature,
800         InvalidSignatureLength,
801         InvalidSignatureS,
802         InvalidSignatureV
803     }
804 
805     function _throwError(RecoverError error) private pure {
806         if (error == RecoverError.NoError) {
807             return; // no error: do nothing
808         } else if (error == RecoverError.InvalidSignature) {
809             revert("ECDSA: invalid signature");
810         } else if (error == RecoverError.InvalidSignatureLength) {
811             revert("ECDSA: invalid signature length");
812         } else if (error == RecoverError.InvalidSignatureS) {
813             revert("ECDSA: invalid signature 's' value");
814         } else if (error == RecoverError.InvalidSignatureV) {
815             revert("ECDSA: invalid signature 'v' value");
816         }
817     }
818 
819     /**
820      * @dev Returns the address that signed a hashed message (`hash`) with
821      * `signature` or error string. This address can then be used for verification purposes.
822      *
823      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
824      * this function rejects them by requiring the `s` value to be in the lower
825      * half order, and the `v` value to be either 27 or 28.
826      *
827      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
828      * verification to be secure: it is possible to craft signatures that
829      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
830      * this is by receiving a hash of the original message (which may otherwise
831      * be too long), and then calling {toEthSignedMessageHash} on it.
832      *
833      * Documentation for signature generation:
834      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
835      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
836      *
837      * _Available since v4.3._
838      */
839     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
840         if (signature.length == 65) {
841             bytes32 r;
842             bytes32 s;
843             uint8 v;
844             // ecrecover takes the signature parameters, and the only way to get them
845             // currently is to use assembly.
846             /// @solidity memory-safe-assembly
847             assembly {
848                 r := mload(add(signature, 0x20))
849                 s := mload(add(signature, 0x40))
850                 v := byte(0, mload(add(signature, 0x60)))
851             }
852             return tryRecover(hash, v, r, s);
853         } else {
854             return (address(0), RecoverError.InvalidSignatureLength);
855         }
856     }
857 
858     /**
859      * @dev Returns the address that signed a hashed message (`hash`) with
860      * `signature`. This address can then be used for verification purposes.
861      *
862      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
863      * this function rejects them by requiring the `s` value to be in the lower
864      * half order, and the `v` value to be either 27 or 28.
865      *
866      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
867      * verification to be secure: it is possible to craft signatures that
868      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
869      * this is by receiving a hash of the original message (which may otherwise
870      * be too long), and then calling {toEthSignedMessageHash} on it.
871      */
872     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
873         (address recovered, RecoverError error) = tryRecover(hash, signature);
874         _throwError(error);
875         return recovered;
876     }
877 
878     /**
879      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
880      *
881      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
882      *
883      * _Available since v4.3._
884      */
885     function tryRecover(
886         bytes32 hash,
887         bytes32 r,
888         bytes32 vs
889     ) internal pure returns (address, RecoverError) {
890         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
891         uint8 v = uint8((uint256(vs) >> 255) + 27);
892         return tryRecover(hash, v, r, s);
893     }
894 
895     /**
896      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
897      *
898      * _Available since v4.2._
899      */
900     function recover(
901         bytes32 hash,
902         bytes32 r,
903         bytes32 vs
904     ) internal pure returns (address) {
905         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
906         _throwError(error);
907         return recovered;
908     }
909 
910     /**
911      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
912      * `r` and `s` signature fields separately.
913      *
914      * _Available since v4.3._
915      */
916     function tryRecover(
917         bytes32 hash,
918         uint8 v,
919         bytes32 r,
920         bytes32 s
921     ) internal pure returns (address, RecoverError) {
922         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
923         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
924         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
925         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
926         //
927         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
928         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
929         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
930         // these malleable signatures as well.
931         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
932             return (address(0), RecoverError.InvalidSignatureS);
933         }
934         if (v != 27 && v != 28) {
935             return (address(0), RecoverError.InvalidSignatureV);
936         }
937 
938         // If the signature is valid (and not malleable), return the signer address
939         address signer = ecrecover(hash, v, r, s);
940         if (signer == address(0)) {
941             return (address(0), RecoverError.InvalidSignature);
942         }
943 
944         return (signer, RecoverError.NoError);
945     }
946 
947     /**
948      * @dev Overload of {ECDSA-recover} that receives the `v`,
949      * `r` and `s` signature fields separately.
950      */
951     function recover(
952         bytes32 hash,
953         uint8 v,
954         bytes32 r,
955         bytes32 s
956     ) internal pure returns (address) {
957         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
958         _throwError(error);
959         return recovered;
960     }
961 
962     /**
963      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
964      * produces hash corresponding to the one signed with the
965      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
966      * JSON-RPC method as part of EIP-191.
967      *
968      * See {recover}.
969      */
970     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
971         // 32 is the length in bytes of hash,
972         // enforced by the type signature above
973         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
974     }
975 
976     /**
977      * @dev Returns an Ethereum Signed Message, created from `s`. This
978      * produces hash corresponding to the one signed with the
979      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
980      * JSON-RPC method as part of EIP-191.
981      *
982      * See {recover}.
983      */
984     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
985         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
986     }
987 
988     /**
989      * @dev Returns an Ethereum Signed Typed Data, created from a
990      * `domainSeparator` and a `structHash`. This produces hash corresponding
991      * to the one signed with the
992      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
993      * JSON-RPC method as part of EIP-712.
994      *
995      * See {recover}.
996      */
997     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
998         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
999     }
1000 }
1001 
1002 // File: @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
1003 
1004 
1005 // OpenZeppelin Contracts (last updated v4.7.1) (utils/cryptography/SignatureChecker.sol)
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 
1010 
1011 
1012 /**
1013  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
1014  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
1015  * Argent and Gnosis Safe.
1016  *
1017  * _Available since v4.1._
1018  */
1019 library SignatureChecker {
1020     /**
1021      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
1022      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
1023      *
1024      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
1025      * change through time. It could return true at block N and false at block N+1 (or the opposite).
1026      */
1027     function isValidSignatureNow(
1028         address signer,
1029         bytes32 hash,
1030         bytes memory signature
1031     ) internal view returns (bool) {
1032         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
1033         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
1034             return true;
1035         }
1036 
1037         (bool success, bytes memory result) = signer.staticcall(
1038             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
1039         );
1040         return (success &&
1041             result.length == 32 &&
1042             abi.decode(result, (bytes32)) == bytes32(IERC1271.isValidSignature.selector));
1043     }
1044 }
1045 
1046 // File: @openzeppelin/contracts/utils/Context.sol
1047 
1048 
1049 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 /**
1054  * @dev Provides information about the current execution context, including the
1055  * sender of the transaction and its data. While these are generally available
1056  * via msg.sender and msg.data, they should not be accessed in such a direct
1057  * manner, since when dealing with meta-transactions the account sending and
1058  * paying for execution may not be the actual sender (as far as an application
1059  * is concerned).
1060  *
1061  * This contract is only required for intermediate, library-like contracts.
1062  */
1063 abstract contract Context {
1064     function _msgSender() internal view virtual returns (address) {
1065         return msg.sender;
1066     }
1067 
1068     function _msgData() internal view virtual returns (bytes calldata) {
1069         return msg.data;
1070     }
1071 }
1072 
1073 // File: @openzeppelin/contracts/access/AccessControl.sol
1074 
1075 
1076 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 
1082 
1083 
1084 /**
1085  * @dev Contract module that allows children to implement role-based access
1086  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1087  * members except through off-chain means by accessing the contract event logs. Some
1088  * applications may benefit from on-chain enumerability, for those cases see
1089  * {AccessControlEnumerable}.
1090  *
1091  * Roles are referred to by their `bytes32` identifier. These should be exposed
1092  * in the external API and be unique. The best way to achieve this is by
1093  * using `public constant` hash digests:
1094  *
1095  * ```
1096  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1097  * ```
1098  *
1099  * Roles can be used to represent a set of permissions. To restrict access to a
1100  * function call, use {hasRole}:
1101  *
1102  * ```
1103  * function foo() public {
1104  *     require(hasRole(MY_ROLE, msg.sender));
1105  *     ...
1106  * }
1107  * ```
1108  *
1109  * Roles can be granted and revoked dynamically via the {grantRole} and
1110  * {revokeRole} functions. Each role has an associated admin role, and only
1111  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1112  *
1113  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1114  * that only accounts with this role will be able to grant or revoke other
1115  * roles. More complex role relationships can be created by using
1116  * {_setRoleAdmin}.
1117  *
1118  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1119  * grant and revoke this role. Extra precautions should be taken to secure
1120  * accounts that have been granted it.
1121  */
1122 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1123     struct RoleData {
1124         mapping(address => bool) members;
1125         bytes32 adminRole;
1126     }
1127 
1128     mapping(bytes32 => RoleData) private _roles;
1129 
1130     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1131 
1132     /**
1133      * @dev Modifier that checks that an account has a specific role. Reverts
1134      * with a standardized message including the required role.
1135      *
1136      * The format of the revert reason is given by the following regular expression:
1137      *
1138      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1139      *
1140      * _Available since v4.1._
1141      */
1142     modifier onlyRole(bytes32 role) {
1143         _checkRole(role);
1144         _;
1145     }
1146 
1147     /**
1148      * @dev See {IERC165-supportsInterface}.
1149      */
1150     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1151         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1152     }
1153 
1154     /**
1155      * @dev Returns `true` if `account` has been granted `role`.
1156      */
1157     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1158         return _roles[role].members[account];
1159     }
1160 
1161     /**
1162      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1163      * Overriding this function changes the behavior of the {onlyRole} modifier.
1164      *
1165      * Format of the revert message is described in {_checkRole}.
1166      *
1167      * _Available since v4.6._
1168      */
1169     function _checkRole(bytes32 role) internal view virtual {
1170         _checkRole(role, _msgSender());
1171     }
1172 
1173     /**
1174      * @dev Revert with a standard message if `account` is missing `role`.
1175      *
1176      * The format of the revert reason is given by the following regular expression:
1177      *
1178      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1179      */
1180     function _checkRole(bytes32 role, address account) internal view virtual {
1181         if (!hasRole(role, account)) {
1182             revert(
1183                 string(
1184                     abi.encodePacked(
1185                         "AccessControl: account ",
1186                         Strings.toHexString(uint160(account), 20),
1187                         " is missing role ",
1188                         Strings.toHexString(uint256(role), 32)
1189                     )
1190                 )
1191             );
1192         }
1193     }
1194 
1195     /**
1196      * @dev Returns the admin role that controls `role`. See {grantRole} and
1197      * {revokeRole}.
1198      *
1199      * To change a role's admin, use {_setRoleAdmin}.
1200      */
1201     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1202         return _roles[role].adminRole;
1203     }
1204 
1205     /**
1206      * @dev Grants `role` to `account`.
1207      *
1208      * If `account` had not been already granted `role`, emits a {RoleGranted}
1209      * event.
1210      *
1211      * Requirements:
1212      *
1213      * - the caller must have ``role``'s admin role.
1214      *
1215      * May emit a {RoleGranted} event.
1216      */
1217     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1218         _grantRole(role, account);
1219     }
1220 
1221     /**
1222      * @dev Revokes `role` from `account`.
1223      *
1224      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1225      *
1226      * Requirements:
1227      *
1228      * - the caller must have ``role``'s admin role.
1229      *
1230      * May emit a {RoleRevoked} event.
1231      */
1232     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1233         _revokeRole(role, account);
1234     }
1235 
1236     /**
1237      * @dev Revokes `role` from the calling account.
1238      *
1239      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1240      * purpose is to provide a mechanism for accounts to lose their privileges
1241      * if they are compromised (such as when a trusted device is misplaced).
1242      *
1243      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1244      * event.
1245      *
1246      * Requirements:
1247      *
1248      * - the caller must be `account`.
1249      *
1250      * May emit a {RoleRevoked} event.
1251      */
1252     function renounceRole(bytes32 role, address account) public virtual override {
1253         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1254 
1255         _revokeRole(role, account);
1256     }
1257 
1258     /**
1259      * @dev Grants `role` to `account`.
1260      *
1261      * If `account` had not been already granted `role`, emits a {RoleGranted}
1262      * event. Note that unlike {grantRole}, this function doesn't perform any
1263      * checks on the calling account.
1264      *
1265      * May emit a {RoleGranted} event.
1266      *
1267      * [WARNING]
1268      * ====
1269      * This function should only be called from the constructor when setting
1270      * up the initial roles for the system.
1271      *
1272      * Using this function in any other way is effectively circumventing the admin
1273      * system imposed by {AccessControl}.
1274      * ====
1275      *
1276      * NOTE: This function is deprecated in favor of {_grantRole}.
1277      */
1278     function _setupRole(bytes32 role, address account) internal virtual {
1279         _grantRole(role, account);
1280     }
1281 
1282     /**
1283      * @dev Sets `adminRole` as ``role``'s admin role.
1284      *
1285      * Emits a {RoleAdminChanged} event.
1286      */
1287     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1288         bytes32 previousAdminRole = getRoleAdmin(role);
1289         _roles[role].adminRole = adminRole;
1290         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1291     }
1292 
1293     /**
1294      * @dev Grants `role` to `account`.
1295      *
1296      * Internal function without access restriction.
1297      *
1298      * May emit a {RoleGranted} event.
1299      */
1300     function _grantRole(bytes32 role, address account) internal virtual {
1301         if (!hasRole(role, account)) {
1302             _roles[role].members[account] = true;
1303             emit RoleGranted(role, account, _msgSender());
1304         }
1305     }
1306 
1307     /**
1308      * @dev Revokes `role` from `account`.
1309      *
1310      * Internal function without access restriction.
1311      *
1312      * May emit a {RoleRevoked} event.
1313      */
1314     function _revokeRole(bytes32 role, address account) internal virtual {
1315         if (hasRole(role, account)) {
1316             _roles[role].members[account] = false;
1317             emit RoleRevoked(role, account, _msgSender());
1318         }
1319     }
1320 }
1321 
1322 // File: @openzeppelin/contracts/access/Ownable.sol
1323 
1324 
1325 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1326 
1327 pragma solidity ^0.8.0;
1328 
1329 
1330 /**
1331  * @dev Contract module which provides a basic access control mechanism, where
1332  * there is an account (an owner) that can be granted exclusive access to
1333  * specific functions.
1334  *
1335  * By default, the owner account will be the one that deploys the contract. This
1336  * can later be changed with {transferOwnership}.
1337  *
1338  * This module is used through inheritance. It will make available the modifier
1339  * `onlyOwner`, which can be applied to your functions to restrict their use to
1340  * the owner.
1341  */
1342 abstract contract Ownable is Context {
1343     address private _owner;
1344 
1345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1346 
1347     /**
1348      * @dev Initializes the contract setting the deployer as the initial owner.
1349      */
1350     constructor() {
1351         _transferOwnership(_msgSender());
1352     }
1353 
1354     /**
1355      * @dev Throws if called by any account other than the owner.
1356      */
1357     modifier onlyOwner() {
1358         _checkOwner();
1359         _;
1360     }
1361 
1362     /**
1363      * @dev Returns the address of the current owner.
1364      */
1365     function owner() public view virtual returns (address) {
1366         return _owner;
1367     }
1368 
1369     /**
1370      * @dev Throws if the sender is not the owner.
1371      */
1372     function _checkOwner() internal view virtual {
1373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1374     }
1375 
1376     /**
1377      * @dev Leaves the contract without owner. It will not be possible to call
1378      * `onlyOwner` functions anymore. Can only be called by the current owner.
1379      *
1380      * NOTE: Renouncing ownership will leave the contract without an owner,
1381      * thereby removing any functionality that is only available to the owner.
1382      */
1383     function renounceOwnership() public virtual onlyOwner {
1384         _transferOwnership(address(0));
1385     }
1386 
1387     /**
1388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1389      * Can only be called by the current owner.
1390      */
1391     function transferOwnership(address newOwner) public virtual onlyOwner {
1392         require(newOwner != address(0), "Ownable: new owner is the zero address");
1393         _transferOwnership(newOwner);
1394     }
1395 
1396     /**
1397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1398      * Internal function without access restriction.
1399      */
1400     function _transferOwnership(address newOwner) internal virtual {
1401         address oldOwner = _owner;
1402         _owner = newOwner;
1403         emit OwnershipTransferred(oldOwner, newOwner);
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/security/Pausable.sol
1408 
1409 
1410 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 
1415 /**
1416  * @dev Contract module which allows children to implement an emergency stop
1417  * mechanism that can be triggered by an authorized account.
1418  *
1419  * This module is used through inheritance. It will make available the
1420  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1421  * the functions of your contract. Note that they will not be pausable by
1422  * simply including this module, only once the modifiers are put in place.
1423  */
1424 abstract contract Pausable is Context {
1425     /**
1426      * @dev Emitted when the pause is triggered by `account`.
1427      */
1428     event Paused(address account);
1429 
1430     /**
1431      * @dev Emitted when the pause is lifted by `account`.
1432      */
1433     event Unpaused(address account);
1434 
1435     bool private _paused;
1436 
1437     /**
1438      * @dev Initializes the contract in unpaused state.
1439      */
1440     constructor() {
1441         _paused = false;
1442     }
1443 
1444     /**
1445      * @dev Modifier to make a function callable only when the contract is not paused.
1446      *
1447      * Requirements:
1448      *
1449      * - The contract must not be paused.
1450      */
1451     modifier whenNotPaused() {
1452         _requireNotPaused();
1453         _;
1454     }
1455 
1456     /**
1457      * @dev Modifier to make a function callable only when the contract is paused.
1458      *
1459      * Requirements:
1460      *
1461      * - The contract must be paused.
1462      */
1463     modifier whenPaused() {
1464         _requirePaused();
1465         _;
1466     }
1467 
1468     /**
1469      * @dev Returns true if the contract is paused, and false otherwise.
1470      */
1471     function paused() public view virtual returns (bool) {
1472         return _paused;
1473     }
1474 
1475     /**
1476      * @dev Throws if the contract is paused.
1477      */
1478     function _requireNotPaused() internal view virtual {
1479         require(!paused(), "Pausable: paused");
1480     }
1481 
1482     /**
1483      * @dev Throws if the contract is not paused.
1484      */
1485     function _requirePaused() internal view virtual {
1486         require(paused(), "Pausable: not paused");
1487     }
1488 
1489     /**
1490      * @dev Triggers stopped state.
1491      *
1492      * Requirements:
1493      *
1494      * - The contract must not be paused.
1495      */
1496     function _pause() internal virtual whenNotPaused {
1497         _paused = true;
1498         emit Paused(_msgSender());
1499     }
1500 
1501     /**
1502      * @dev Returns to normal state.
1503      *
1504      * Requirements:
1505      *
1506      * - The contract must be paused.
1507      */
1508     function _unpause() internal virtual whenPaused {
1509         _paused = false;
1510         emit Unpaused(_msgSender());
1511     }
1512 }
1513 
1514 // File: @openzeppelin/contracts/utils/Counters.sol
1515 
1516 
1517 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 /**
1522  * @title Counters
1523  * @author Matt Condon (@shrugs)
1524  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1525  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1526  *
1527  * Include with `using Counters for Counters.Counter;`
1528  */
1529 library Counters {
1530     struct Counter {
1531         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1532         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1533         // this feature: see https://github.com/ethereum/solidity/issues/4637
1534         uint256 _value; // default: 0
1535     }
1536 
1537     function current(Counter storage counter) internal view returns (uint256) {
1538         return counter._value;
1539     }
1540 
1541     function increment(Counter storage counter) internal {
1542         unchecked {
1543             counter._value += 1;
1544         }
1545     }
1546 
1547     function decrement(Counter storage counter) internal {
1548         uint256 value = counter._value;
1549         require(value > 0, "Counter: decrement overflow");
1550         unchecked {
1551             counter._value = value - 1;
1552         }
1553     }
1554 
1555     function reset(Counter storage counter) internal {
1556         counter._value = 0;
1557     }
1558 }
1559 
1560 // File: contracts/MisphitsStore.sol
1561 pragma solidity ^0.8.11;
1562 
1563 
1564 
1565 
1566 
1567 
1568 
1569 
1570 
1571 /// @title Misphits Store
1572 /// @author Jordi Gago - acidcode.eth
1573 contract MisphitsStore is Pausable, Ownable, ReentrancyGuard, AccessControl {
1574   using SafeMath for uint256;
1575   using SafeMath for uint16;
1576   using SafeMath for uint8;
1577   using SignatureChecker for address;
1578   address public _signer;
1579   IMisphits public _misphits;
1580   mapping (address => bool) public _minted;
1581 
1582   bytes32 public constant BUYER_ROLE = keccak256("BUYER_ROLE");
1583   constructor(
1584   ){
1585     _setupRole(DEFAULT_ADMIN_ROLE, tx.origin);
1586     transferOwnership(tx.origin);
1587   }
1588 
1589   struct Whitelist {
1590     uint8 maxMint;
1591     uint16 maxSupply;
1592     uint16 minted;
1593     uint32 endsAt;
1594     uint256 price;
1595   }
1596   mapping (uint8 => Whitelist) public _whitelistIds;
1597   mapping (uint8 => mapping(address => bool)) public _walletMintedOn;
1598 
1599   function mint(bytes memory signature, bytes4 data) external payable whenNotPaused nonReentrant {
1600     uint8 whitelistID = uint8(data[0]);
1601     require(block.timestamp < _whitelistIds[whitelistID].endsAt, "Misphits Store: Whitelist ended");
1602     uint8 amount = uint8(data[1]) + uint8(data[2]) + uint8(data[3]);
1603     require(amount.mul(_whitelistIds[whitelistID].price) == msg.value, "Misphits Store: Not enought funds");
1604     require(ECDSA.recover(keccak256(abi.encodePacked(msg.sender, whitelistID)), signature) == _signer, "Misphits Store: Invalid signature");
1605     require(amount <=_whitelistIds[whitelistID].maxMint, "Misphits Store: Max amount exceded");
1606     require(!_walletMintedOn[whitelistID][msg.sender], "Misphits Store: Wallet already minted");
1607     require(_whitelistIds[whitelistID].minted.add(amount) <= _whitelistIds[whitelistID].maxSupply, "Misphits Store: Whitelist supply exceded");
1608     _walletMintedOn[whitelistID][msg.sender] = true;
1609     _whitelistIds[whitelistID].minted += uint16(amount);
1610     _misphits.mint(msg.sender, amount);
1611   }
1612 
1613   function mintTo(address to, bytes4 data ) external whenNotPaused nonReentrant onlyRole(BUYER_ROLE) {
1614     uint8 whitelistID = uint8(data[0]);
1615     require(block.timestamp < _whitelistIds[whitelistID].endsAt, "Misphits Store: Whitelist ended");
1616     uint8 amount = uint8(data[1]) + uint8(data[2]) + uint8(data[3]);
1617     require(amount <=_whitelistIds[whitelistID].maxMint, "Misphits Store: Max amount exceded");
1618     require(!_walletMintedOn[whitelistID][to], "Misphits Store: Wallet already minted");
1619     require(_whitelistIds[whitelistID].minted.add(amount) <= _whitelistIds[whitelistID].maxSupply, "Misphits Store: Whitelist supply exceded");
1620     _walletMintedOn[whitelistID][to] = true;
1621     _whitelistIds[whitelistID].minted += uint16(amount);
1622     _misphits.mint(to, amount);
1623   }
1624 
1625   function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl) returns (bool) {
1626         return super.supportsInterface(interfaceId);
1627   }
1628 
1629   function createWhitelist (uint8 id, uint8 maxMint, uint16 maxSupply, uint32 endsAt, uint256 price) external onlyRole(DEFAULT_ADMIN_ROLE) {
1630     _whitelistIds[id] = Whitelist(maxMint, maxSupply, 0, endsAt, price);
1631   }
1632 
1633   function getWhitelist (uint8 id) external view returns (uint8, uint16, uint16, uint32, uint256) {
1634     return (_whitelistIds[id].maxMint, _whitelistIds[id].maxSupply, _whitelistIds[id].minted, _whitelistIds[id].endsAt, _whitelistIds[id].price);
1635   }
1636 
1637   function walletMinted (uint8 whitelist, address wallet) external view returns (bool) {
1638     return  _walletMintedOn[whitelist][wallet];
1639   }
1640 
1641   function withdraw() external onlyOwner {
1642     payable(owner()).transfer(address(this).balance);
1643   }
1644 
1645   function setSigner(address signer_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1646     _signer = signer_;
1647   }
1648 
1649   function setMisphits(address misphits_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1650     _misphits = IMisphits(misphits_);
1651   }
1652 
1653   function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1654     _pause();
1655   }
1656 
1657   function unPause() external onlyRole(DEFAULT_ADMIN_ROLE) {
1658     _unpause();
1659   }
1660 }