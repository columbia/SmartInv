1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/utils/Counters.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @title Counters
101  * @author Matt Condon (@shrugs)
102  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
103  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
104  *
105  * Include with `using Counters for Counters.Counter;`
106  */
107 library Counters {
108     struct Counter {
109         // This variable should never be directly accessed by users of the library: interactions must be restricted to
110         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
111         // this feature: see https://github.com/ethereum/solidity/issues/4637
112         uint256 _value; // default: 0
113     }
114 
115     function current(Counter storage counter) internal view returns (uint256) {
116         return counter._value;
117     }
118 
119     function increment(Counter storage counter) internal {
120         unchecked {
121             counter._value += 1;
122         }
123     }
124 
125     function decrement(Counter storage counter) internal {
126         uint256 value = counter._value;
127         require(value > 0, "Counter: decrement overflow");
128         unchecked {
129             counter._value = value - 1;
130         }
131     }
132 
133     function reset(Counter storage counter) internal {
134         counter._value = 0;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 // CAUTION
146 // This version of SafeMath should only be used with Solidity 0.8 or later,
147 // because it relies on the compiler's built in overflow checks.
148 
149 /**
150  * @dev Wrappers over Solidity's arithmetic operations.
151  *
152  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
153  * now has built in overflow checking.
154  */
155 library SafeMath {
156     /**
157      * @dev Returns the addition of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         unchecked {
163             uint256 c = a + b;
164             if (c < a) return (false, 0);
165             return (true, c);
166         }
167     }
168 
169     /**
170      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
171      *
172      * _Available since v3.4._
173      */
174     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b > a) return (false, 0);
177             return (true, a - b);
178         }
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189             // benefit is lost if 'b' is also tested.
190             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191             if (a == 0) return (true, 0);
192             uint256 c = a * b;
193             if (c / a != b) return (false, 0);
194             return (true, c);
195         }
196     }
197 
198     /**
199      * @dev Returns the division of two unsigned integers, with a division by zero flag.
200      *
201      * _Available since v3.4._
202      */
203     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204         unchecked {
205             if (b == 0) return (false, 0);
206             return (true, a / b);
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
212      *
213      * _Available since v3.4._
214      */
215     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
216         unchecked {
217             if (b == 0) return (false, 0);
218             return (true, a % b);
219         }
220     }
221 
222     /**
223      * @dev Returns the addition of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `+` operator.
227      *
228      * Requirements:
229      *
230      * - Addition cannot overflow.
231      */
232     function add(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a + b;
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      *
244      * - Subtraction cannot overflow.
245      */
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a - b;
248     }
249 
250     /**
251      * @dev Returns the multiplication of two unsigned integers, reverting on
252      * overflow.
253      *
254      * Counterpart to Solidity's `*` operator.
255      *
256      * Requirements:
257      *
258      * - Multiplication cannot overflow.
259      */
260     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a * b;
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers, reverting on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator.
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a % b;
292     }
293 
294     /**
295      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
296      * overflow (when the result is negative).
297      *
298      * CAUTION: This function is deprecated because it requires allocating memory for the error
299      * message unnecessarily. For custom revert reasons use {trySub}.
300      *
301      * Counterpart to Solidity's `-` operator.
302      *
303      * Requirements:
304      *
305      * - Subtraction cannot overflow.
306      */
307     function sub(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         unchecked {
313             require(b <= a, errorMessage);
314             return a - b;
315         }
316     }
317 
318     /**
319      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
320      * division by zero. The result is rounded towards zero.
321      *
322      * Counterpart to Solidity's `/` operator. Note: this function uses a
323      * `revert` opcode (which leaves remaining gas untouched) while Solidity
324      * uses an invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function div(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a / b;
338         }
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * reverting with custom message when dividing by zero.
344      *
345      * CAUTION: This function is deprecated because it requires allocating memory for the error
346      * message unnecessarily. For custom revert reasons use {tryMod}.
347      *
348      * Counterpart to Solidity's `%` operator. This function uses a `revert`
349      * opcode (which leaves remaining gas untouched) while Solidity uses an
350      * invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function mod(
357         uint256 a,
358         uint256 b,
359         string memory errorMessage
360     ) internal pure returns (uint256) {
361         unchecked {
362             require(b > 0, errorMessage);
363             return a % b;
364         }
365     }
366 }
367 
368 // File: @openzeppelin/contracts/utils/Strings.sol
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev String operations.
377  */
378 library Strings {
379     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
383      */
384     function toString(uint256 value) internal pure returns (string memory) {
385         // Inspired by OraclizeAPI's implementation - MIT licence
386         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
387 
388         if (value == 0) {
389             return "0";
390         }
391         uint256 temp = value;
392         uint256 digits;
393         while (temp != 0) {
394             digits++;
395             temp /= 10;
396         }
397         bytes memory buffer = new bytes(digits);
398         while (value != 0) {
399             digits -= 1;
400             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
401             value /= 10;
402         }
403         return string(buffer);
404     }
405 
406     /**
407      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
408      */
409     function toHexString(uint256 value) internal pure returns (string memory) {
410         if (value == 0) {
411             return "0x00";
412         }
413         uint256 temp = value;
414         uint256 length = 0;
415         while (temp != 0) {
416             length++;
417             temp >>= 8;
418         }
419         return toHexString(value, length);
420     }
421 
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
424      */
425     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
426         bytes memory buffer = new bytes(2 * length + 2);
427         buffer[0] = "0";
428         buffer[1] = "x";
429         for (uint256 i = 2 * length + 1; i > 1; --i) {
430             buffer[i] = _HEX_SYMBOLS[value & 0xf];
431             value >>= 4;
432         }
433         require(value == 0, "Strings: hex length insufficient");
434         return string(buffer);
435     }
436 }
437 
438 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev These functions deal with verification of Merkle Trees proofs.
447  *
448  * The proofs can be generated using the JavaScript library
449  * https://github.com/miguelmota/merkletreejs[merkletreejs].
450  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
451  *
452  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
453  */
454 library MerkleProof {
455     /**
456      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
457      * defined by `root`. For this, a `proof` must be provided, containing
458      * sibling hashes on the branch from the leaf to the root of the tree. Each
459      * pair of leaves and each pair of pre-images are assumed to be sorted.
460      */
461     function verify(
462         bytes32[] memory proof,
463         bytes32 root,
464         bytes32 leaf
465     ) internal pure returns (bool) {
466         return processProof(proof, leaf) == root;
467     }
468 
469     /**
470      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
471      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
472      * hash matches the root of the tree. When processing the proof, the pairs
473      * of leafs & pre-images are assumed to be sorted.
474      *
475      * _Available since v4.4._
476      */
477     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
478         bytes32 computedHash = leaf;
479         for (uint256 i = 0; i < proof.length; i++) {
480             bytes32 proofElement = proof[i];
481             if (computedHash <= proofElement) {
482                 // Hash(current computed hash + current element of the proof)
483                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
484             } else {
485                 // Hash(current element of the proof + current computed hash)
486                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
487             }
488         }
489         return computedHash;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/utils/Context.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Provides information about the current execution context, including the
502  * sender of the transaction and its data. While these are generally available
503  * via msg.sender and msg.data, they should not be accessed in such a direct
504  * manner, since when dealing with meta-transactions the account sending and
505  * paying for execution may not be the actual sender (as far as an application
506  * is concerned).
507  *
508  * This contract is only required for intermediate, library-like contracts.
509  */
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 // File: @openzeppelin/contracts/security/Pausable.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Contract module which allows children to implement an emergency stop
530  * mechanism that can be triggered by an authorized account.
531  *
532  * This module is used through inheritance. It will make available the
533  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
534  * the functions of your contract. Note that they will not be pausable by
535  * simply including this module, only once the modifiers are put in place.
536  */
537 abstract contract Pausable is Context {
538     /**
539      * @dev Emitted when the pause is triggered by `account`.
540      */
541     event Paused(address account);
542 
543     /**
544      * @dev Emitted when the pause is lifted by `account`.
545      */
546     event Unpaused(address account);
547 
548     bool private _paused;
549 
550     /**
551      * @dev Initializes the contract in unpaused state.
552      */
553     constructor() {
554         _paused = false;
555     }
556 
557     /**
558      * @dev Returns true if the contract is paused, and false otherwise.
559      */
560     function paused() public view virtual returns (bool) {
561         return _paused;
562     }
563 
564     /**
565      * @dev Modifier to make a function callable only when the contract is not paused.
566      *
567      * Requirements:
568      *
569      * - The contract must not be paused.
570      */
571     modifier whenNotPaused() {
572         require(!paused(), "Pausable: paused");
573         _;
574     }
575 
576     /**
577      * @dev Modifier to make a function callable only when the contract is paused.
578      *
579      * Requirements:
580      *
581      * - The contract must be paused.
582      */
583     modifier whenPaused() {
584         require(paused(), "Pausable: not paused");
585         _;
586     }
587 
588     /**
589      * @dev Triggers stopped state.
590      *
591      * Requirements:
592      *
593      * - The contract must not be paused.
594      */
595     function _pause() internal virtual whenNotPaused {
596         _paused = true;
597         emit Paused(_msgSender());
598     }
599 
600     /**
601      * @dev Returns to normal state.
602      *
603      * Requirements:
604      *
605      * - The contract must be paused.
606      */
607     function _unpause() internal virtual whenPaused {
608         _paused = false;
609         emit Unpaused(_msgSender());
610     }
611 }
612 
613 // File: @openzeppelin/contracts/access/Ownable.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Contract module which provides a basic access control mechanism, where
623  * there is an account (an owner) that can be granted exclusive access to
624  * specific functions.
625  *
626  * By default, the owner account will be the one that deploys the contract. This
627  * can later be changed with {transferOwnership}.
628  *
629  * This module is used through inheritance. It will make available the modifier
630  * `onlyOwner`, which can be applied to your functions to restrict their use to
631  * the owner.
632  */
633 abstract contract Ownable is Context {
634     address private _owner;
635 
636     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
637 
638     /**
639      * @dev Initializes the contract setting the deployer as the initial owner.
640      */
641     constructor() {
642         _transferOwnership(_msgSender());
643     }
644 
645     /**
646      * @dev Returns the address of the current owner.
647      */
648     function owner() public view virtual returns (address) {
649         return _owner;
650     }
651 
652     /**
653      * @dev Throws if called by any account other than the owner.
654      */
655     modifier onlyOwner() {
656         require(owner() == _msgSender(), "Ownable: caller is not the owner");
657         _;
658     }
659 
660     /**
661      * @dev Leaves the contract without owner. It will not be possible to call
662      * `onlyOwner` functions anymore. Can only be called by the current owner.
663      *
664      * NOTE: Renouncing ownership will leave the contract without an owner,
665      * thereby removing any functionality that is only available to the owner.
666      */
667     function renounceOwnership() public virtual onlyOwner {
668         _transferOwnership(address(0));
669     }
670 
671     /**
672      * @dev Transfers ownership of the contract to a new account (`newOwner`).
673      * Can only be called by the current owner.
674      */
675     function transferOwnership(address newOwner) public virtual onlyOwner {
676         require(newOwner != address(0), "Ownable: new owner is the zero address");
677         _transferOwnership(newOwner);
678     }
679 
680     /**
681      * @dev Transfers ownership of the contract to a new account (`newOwner`).
682      * Internal function without access restriction.
683      */
684     function _transferOwnership(address newOwner) internal virtual {
685         address oldOwner = _owner;
686         _owner = newOwner;
687         emit OwnershipTransferred(oldOwner, newOwner);
688     }
689 }
690 
691 // File: @openzeppelin/contracts/utils/Address.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @dev Collection of functions related to the address type
700  */
701 library Address {
702     /**
703      * @dev Returns true if `account` is a contract.
704      *
705      * [IMPORTANT]
706      * ====
707      * It is unsafe to assume that an address for which this function returns
708      * false is an externally-owned account (EOA) and not a contract.
709      *
710      * Among others, `isContract` will return false for the following
711      * types of addresses:
712      *
713      *  - an externally-owned account
714      *  - a contract in construction
715      *  - an address where a contract will be created
716      *  - an address where a contract lived, but was destroyed
717      * ====
718      */
719     function isContract(address account) internal view returns (bool) {
720         // This method relies on extcodesize, which returns 0 for contracts in
721         // construction, since the code is only stored at the end of the
722         // constructor execution.
723 
724         uint256 size;
725         assembly {
726             size := extcodesize(account)
727         }
728         return size > 0;
729     }
730 
731     /**
732      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
733      * `recipient`, forwarding all available gas and reverting on errors.
734      *
735      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
736      * of certain opcodes, possibly making contracts go over the 2300 gas limit
737      * imposed by `transfer`, making them unable to receive funds via
738      * `transfer`. {sendValue} removes this limitation.
739      *
740      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
741      *
742      * IMPORTANT: because control is transferred to `recipient`, care must be
743      * taken to not create reentrancy vulnerabilities. Consider using
744      * {ReentrancyGuard} or the
745      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
746      */
747     function sendValue(address payable recipient, uint256 amount) internal {
748         require(address(this).balance >= amount, "Address: insufficient balance");
749 
750         (bool success, ) = recipient.call{value: amount}("");
751         require(success, "Address: unable to send value, recipient may have reverted");
752     }
753 
754     /**
755      * @dev Performs a Solidity function call using a low level `call`. A
756      * plain `call` is an unsafe replacement for a function call: use this
757      * function instead.
758      *
759      * If `target` reverts with a revert reason, it is bubbled up by this
760      * function (like regular Solidity function calls).
761      *
762      * Returns the raw returned data. To convert to the expected return value,
763      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
764      *
765      * Requirements:
766      *
767      * - `target` must be a contract.
768      * - calling `target` with `data` must not revert.
769      *
770      * _Available since v3.1._
771      */
772     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
773         return functionCall(target, data, "Address: low-level call failed");
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
778      * `errorMessage` as a fallback revert reason when `target` reverts.
779      *
780      * _Available since v3.1._
781      */
782     function functionCall(
783         address target,
784         bytes memory data,
785         string memory errorMessage
786     ) internal returns (bytes memory) {
787         return functionCallWithValue(target, data, 0, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but also transferring `value` wei to `target`.
793      *
794      * Requirements:
795      *
796      * - the calling contract must have an ETH balance of at least `value`.
797      * - the called Solidity function must be `payable`.
798      *
799      * _Available since v3.1._
800      */
801     function functionCallWithValue(
802         address target,
803         bytes memory data,
804         uint256 value
805     ) internal returns (bytes memory) {
806         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
811      * with `errorMessage` as a fallback revert reason when `target` reverts.
812      *
813      * _Available since v3.1._
814      */
815     function functionCallWithValue(
816         address target,
817         bytes memory data,
818         uint256 value,
819         string memory errorMessage
820     ) internal returns (bytes memory) {
821         require(address(this).balance >= value, "Address: insufficient balance for call");
822         require(isContract(target), "Address: call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.call{value: value}(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a static call.
831      *
832      * _Available since v3.3._
833      */
834     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
835         return functionStaticCall(target, data, "Address: low-level static call failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a static call.
841      *
842      * _Available since v3.3._
843      */
844     function functionStaticCall(
845         address target,
846         bytes memory data,
847         string memory errorMessage
848     ) internal view returns (bytes memory) {
849         require(isContract(target), "Address: static call to non-contract");
850 
851         (bool success, bytes memory returndata) = target.staticcall(data);
852         return verifyCallResult(success, returndata, errorMessage);
853     }
854 
855     /**
856      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
857      * but performing a delegate call.
858      *
859      * _Available since v3.4._
860      */
861     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
862         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
867      * but performing a delegate call.
868      *
869      * _Available since v3.4._
870      */
871     function functionDelegateCall(
872         address target,
873         bytes memory data,
874         string memory errorMessage
875     ) internal returns (bytes memory) {
876         require(isContract(target), "Address: delegate call to non-contract");
877 
878         (bool success, bytes memory returndata) = target.delegatecall(data);
879         return verifyCallResult(success, returndata, errorMessage);
880     }
881 
882     /**
883      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
884      * revert reason using the provided one.
885      *
886      * _Available since v4.3._
887      */
888     function verifyCallResult(
889         bool success,
890         bytes memory returndata,
891         string memory errorMessage
892     ) internal pure returns (bytes memory) {
893         if (success) {
894             return returndata;
895         } else {
896             // Look for revert reason and bubble it up if present
897             if (returndata.length > 0) {
898                 // The easiest way to bubble the revert reason is using memory via assembly
899 
900                 assembly {
901                     let returndata_size := mload(returndata)
902                     revert(add(32, returndata), returndata_size)
903                 }
904             } else {
905                 revert(errorMessage);
906             }
907         }
908     }
909 }
910 
911 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 /**
919  * @dev Interface of the ERC165 standard, as defined in the
920  * https://eips.ethereum.org/EIPS/eip-165[EIP].
921  *
922  * Implementers can declare support of contract interfaces, which can then be
923  * queried by others ({ERC165Checker}).
924  *
925  * For an implementation, see {ERC165}.
926  */
927 interface IERC165 {
928     /**
929      * @dev Returns true if this contract implements the interface defined by
930      * `interfaceId`. See the corresponding
931      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
932      * to learn more about how these ids are created.
933      *
934      * This function call must use less than 30 000 gas.
935      */
936     function supportsInterface(bytes4 interfaceId) external view returns (bool);
937 }
938 
939 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 
947 /**
948  * @dev Implementation of the {IERC165} interface.
949  *
950  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
951  * for the additional interface id that will be supported. For example:
952  *
953  * ```solidity
954  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
955  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
956  * }
957  * ```
958  *
959  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
960  */
961 abstract contract ERC165 is IERC165 {
962     /**
963      * @dev See {IERC165-supportsInterface}.
964      */
965     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
966         return interfaceId == type(IERC165).interfaceId;
967     }
968 }
969 
970 // File: @openzeppelin/contracts/access/AccessControl.sol
971 
972 
973 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 
978 
979 
980 
981 /**
982  * @dev Contract module that allows children to implement role-based access
983  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
984  * members except through off-chain means by accessing the contract event logs. Some
985  * applications may benefit from on-chain enumerability, for those cases see
986  * {AccessControlEnumerable}.
987  *
988  * Roles are referred to by their `bytes32` identifier. These should be exposed
989  * in the external API and be unique. The best way to achieve this is by
990  * using `public constant` hash digests:
991  *
992  * ```
993  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
994  * ```
995  *
996  * Roles can be used to represent a set of permissions. To restrict access to a
997  * function call, use {hasRole}:
998  *
999  * ```
1000  * function foo() public {
1001  *     require(hasRole(MY_ROLE, msg.sender));
1002  *     ...
1003  * }
1004  * ```
1005  *
1006  * Roles can be granted and revoked dynamically via the {grantRole} and
1007  * {revokeRole} functions. Each role has an associated admin role, and only
1008  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1009  *
1010  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1011  * that only accounts with this role will be able to grant or revoke other
1012  * roles. More complex role relationships can be created by using
1013  * {_setRoleAdmin}.
1014  *
1015  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1016  * grant and revoke this role. Extra precautions should be taken to secure
1017  * accounts that have been granted it.
1018  */
1019 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1020     struct RoleData {
1021         mapping(address => bool) members;
1022         bytes32 adminRole;
1023     }
1024 
1025     mapping(bytes32 => RoleData) private _roles;
1026 
1027     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1028 
1029     /**
1030      * @dev Modifier that checks that an account has a specific role. Reverts
1031      * with a standardized message including the required role.
1032      *
1033      * The format of the revert reason is given by the following regular expression:
1034      *
1035      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1036      *
1037      * _Available since v4.1._
1038      */
1039     modifier onlyRole(bytes32 role) {
1040         _checkRole(role, _msgSender());
1041         _;
1042     }
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1048         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev Returns `true` if `account` has been granted `role`.
1053      */
1054     function hasRole(bytes32 role, address account) public view override returns (bool) {
1055         return _roles[role].members[account];
1056     }
1057 
1058     /**
1059      * @dev Revert with a standard message if `account` is missing `role`.
1060      *
1061      * The format of the revert reason is given by the following regular expression:
1062      *
1063      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1064      */
1065     function _checkRole(bytes32 role, address account) internal view {
1066         if (!hasRole(role, account)) {
1067             revert(
1068                 string(
1069                     abi.encodePacked(
1070                         "AccessControl: account ",
1071                         Strings.toHexString(uint160(account), 20),
1072                         " is missing role ",
1073                         Strings.toHexString(uint256(role), 32)
1074                     )
1075                 )
1076             );
1077         }
1078     }
1079 
1080     /**
1081      * @dev Returns the admin role that controls `role`. See {grantRole} and
1082      * {revokeRole}.
1083      *
1084      * To change a role's admin, use {_setRoleAdmin}.
1085      */
1086     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1087         return _roles[role].adminRole;
1088     }
1089 
1090     /**
1091      * @dev Grants `role` to `account`.
1092      *
1093      * If `account` had not been already granted `role`, emits a {RoleGranted}
1094      * event.
1095      *
1096      * Requirements:
1097      *
1098      * - the caller must have ``role``'s admin role.
1099      */
1100     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1101         _grantRole(role, account);
1102     }
1103 
1104     /**
1105      * @dev Revokes `role` from `account`.
1106      *
1107      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1108      *
1109      * Requirements:
1110      *
1111      * - the caller must have ``role``'s admin role.
1112      */
1113     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1114         _revokeRole(role, account);
1115     }
1116 
1117     /**
1118      * @dev Revokes `role` from the calling account.
1119      *
1120      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1121      * purpose is to provide a mechanism for accounts to lose their privileges
1122      * if they are compromised (such as when a trusted device is misplaced).
1123      *
1124      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1125      * event.
1126      *
1127      * Requirements:
1128      *
1129      * - the caller must be `account`.
1130      */
1131     function renounceRole(bytes32 role, address account) public virtual override {
1132         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1133 
1134         _revokeRole(role, account);
1135     }
1136 
1137     /**
1138      * @dev Grants `role` to `account`.
1139      *
1140      * If `account` had not been already granted `role`, emits a {RoleGranted}
1141      * event. Note that unlike {grantRole}, this function doesn't perform any
1142      * checks on the calling account.
1143      *
1144      * [WARNING]
1145      * ====
1146      * This function should only be called from the constructor when setting
1147      * up the initial roles for the system.
1148      *
1149      * Using this function in any other way is effectively circumventing the admin
1150      * system imposed by {AccessControl}.
1151      * ====
1152      *
1153      * NOTE: This function is deprecated in favor of {_grantRole}.
1154      */
1155     function _setupRole(bytes32 role, address account) internal virtual {
1156         _grantRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Sets `adminRole` as ``role``'s admin role.
1161      *
1162      * Emits a {RoleAdminChanged} event.
1163      */
1164     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1165         bytes32 previousAdminRole = getRoleAdmin(role);
1166         _roles[role].adminRole = adminRole;
1167         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1168     }
1169 
1170     /**
1171      * @dev Grants `role` to `account`.
1172      *
1173      * Internal function without access restriction.
1174      */
1175     function _grantRole(bytes32 role, address account) internal virtual {
1176         if (!hasRole(role, account)) {
1177             _roles[role].members[account] = true;
1178             emit RoleGranted(role, account, _msgSender());
1179         }
1180     }
1181 
1182     /**
1183      * @dev Revokes `role` from `account`.
1184      *
1185      * Internal function without access restriction.
1186      */
1187     function _revokeRole(bytes32 role, address account) internal virtual {
1188         if (hasRole(role, account)) {
1189             _roles[role].members[account] = false;
1190             emit RoleRevoked(role, account, _msgSender());
1191         }
1192     }
1193 }
1194 
1195 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1196 
1197 
1198 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 
1203 /**
1204  * @dev _Available since v3.1._
1205  */
1206 interface IERC1155Receiver is IERC165 {
1207     /**
1208         @dev Handles the receipt of a single ERC1155 token type. This function is
1209         called at the end of a `safeTransferFrom` after the balance has been updated.
1210         To accept the transfer, this must return
1211         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1212         (i.e. 0xf23a6e61, or its own function selector).
1213         @param operator The address which initiated the transfer (i.e. msg.sender)
1214         @param from The address which previously owned the token
1215         @param id The ID of the token being transferred
1216         @param value The amount of tokens being transferred
1217         @param data Additional data with no specified format
1218         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1219     */
1220     function onERC1155Received(
1221         address operator,
1222         address from,
1223         uint256 id,
1224         uint256 value,
1225         bytes calldata data
1226     ) external returns (bytes4);
1227 
1228     /**
1229         @dev Handles the receipt of a multiple ERC1155 token types. This function
1230         is called at the end of a `safeBatchTransferFrom` after the balances have
1231         been updated. To accept the transfer(s), this must return
1232         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1233         (i.e. 0xbc197c81, or its own function selector).
1234         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1235         @param from The address which previously owned the token
1236         @param ids An array containing ids of each token being transferred (order and length must match values array)
1237         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1238         @param data Additional data with no specified format
1239         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1240     */
1241     function onERC1155BatchReceived(
1242         address operator,
1243         address from,
1244         uint256[] calldata ids,
1245         uint256[] calldata values,
1246         bytes calldata data
1247     ) external returns (bytes4);
1248 }
1249 
1250 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1251 
1252 
1253 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 
1258 /**
1259  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1260  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1261  *
1262  * _Available since v3.1._
1263  */
1264 interface IERC1155 is IERC165 {
1265     /**
1266      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1267      */
1268     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1269 
1270     /**
1271      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1272      * transfers.
1273      */
1274     event TransferBatch(
1275         address indexed operator,
1276         address indexed from,
1277         address indexed to,
1278         uint256[] ids,
1279         uint256[] values
1280     );
1281 
1282     /**
1283      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1284      * `approved`.
1285      */
1286     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1287 
1288     /**
1289      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1290      *
1291      * If an {URI} event was emitted for `id`, the standard
1292      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1293      * returned by {IERC1155MetadataURI-uri}.
1294      */
1295     event URI(string value, uint256 indexed id);
1296 
1297     /**
1298      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1299      *
1300      * Requirements:
1301      *
1302      * - `account` cannot be the zero address.
1303      */
1304     function balanceOf(address account, uint256 id) external view returns (uint256);
1305 
1306     /**
1307      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1308      *
1309      * Requirements:
1310      *
1311      * - `accounts` and `ids` must have the same length.
1312      */
1313     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1314         external
1315         view
1316         returns (uint256[] memory);
1317 
1318     /**
1319      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1320      *
1321      * Emits an {ApprovalForAll} event.
1322      *
1323      * Requirements:
1324      *
1325      * - `operator` cannot be the caller.
1326      */
1327     function setApprovalForAll(address operator, bool approved) external;
1328 
1329     /**
1330      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1331      *
1332      * See {setApprovalForAll}.
1333      */
1334     function isApprovedForAll(address account, address operator) external view returns (bool);
1335 
1336     /**
1337      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1338      *
1339      * Emits a {TransferSingle} event.
1340      *
1341      * Requirements:
1342      *
1343      * - `to` cannot be the zero address.
1344      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1345      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1346      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1347      * acceptance magic value.
1348      */
1349     function safeTransferFrom(
1350         address from,
1351         address to,
1352         uint256 id,
1353         uint256 amount,
1354         bytes calldata data
1355     ) external;
1356 
1357     /**
1358      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1359      *
1360      * Emits a {TransferBatch} event.
1361      *
1362      * Requirements:
1363      *
1364      * - `ids` and `amounts` must have the same length.
1365      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1366      * acceptance magic value.
1367      */
1368     function safeBatchTransferFrom(
1369         address from,
1370         address to,
1371         uint256[] calldata ids,
1372         uint256[] calldata amounts,
1373         bytes calldata data
1374     ) external;
1375 }
1376 
1377 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1378 
1379 
1380 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 
1385 /**
1386  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1387  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1388  *
1389  * _Available since v3.1._
1390  */
1391 interface IERC1155MetadataURI is IERC1155 {
1392     /**
1393      * @dev Returns the URI for token type `id`.
1394      *
1395      * If the `\{id\}` substring is present in the URI, it must be replaced by
1396      * clients with the actual token type ID.
1397      */
1398     function uri(uint256 id) external view returns (string memory);
1399 }
1400 
1401 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1402 
1403 
1404 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 
1409 
1410 
1411 
1412 
1413 
1414 /**
1415  * @dev Implementation of the basic standard multi-token.
1416  * See https://eips.ethereum.org/EIPS/eip-1155
1417  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1418  *
1419  * _Available since v3.1._
1420  */
1421 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1422     using Address for address;
1423 
1424     // Mapping from token ID to account balances
1425     mapping(uint256 => mapping(address => uint256)) private _balances;
1426 
1427     // Mapping from account to operator approvals
1428     mapping(address => mapping(address => bool)) private _operatorApprovals;
1429 
1430     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1431     string private _uri;
1432 
1433     /**
1434      * @dev See {_setURI}.
1435      */
1436     constructor(string memory uri_) {
1437         _setURI(uri_);
1438     }
1439 
1440     /**
1441      * @dev See {IERC165-supportsInterface}.
1442      */
1443     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1444         return
1445             interfaceId == type(IERC1155).interfaceId ||
1446             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1447             super.supportsInterface(interfaceId);
1448     }
1449 
1450     /**
1451      * @dev See {IERC1155MetadataURI-uri}.
1452      *
1453      * This implementation returns the same URI for *all* token types. It relies
1454      * on the token type ID substitution mechanism
1455      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1456      *
1457      * Clients calling this function must replace the `\{id\}` substring with the
1458      * actual token type ID.
1459      */
1460     function uri(uint256) public view virtual override returns (string memory) {
1461         return _uri;
1462     }
1463 
1464     /**
1465      * @dev See {IERC1155-balanceOf}.
1466      *
1467      * Requirements:
1468      *
1469      * - `account` cannot be the zero address.
1470      */
1471     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1472         require(account != address(0), "ERC1155: balance query for the zero address");
1473         return _balances[id][account];
1474     }
1475 
1476     /**
1477      * @dev See {IERC1155-balanceOfBatch}.
1478      *
1479      * Requirements:
1480      *
1481      * - `accounts` and `ids` must have the same length.
1482      */
1483     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1484         public
1485         view
1486         virtual
1487         override
1488         returns (uint256[] memory)
1489     {
1490         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1491 
1492         uint256[] memory batchBalances = new uint256[](accounts.length);
1493 
1494         for (uint256 i = 0; i < accounts.length; ++i) {
1495             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1496         }
1497 
1498         return batchBalances;
1499     }
1500 
1501     /**
1502      * @dev See {IERC1155-setApprovalForAll}.
1503      */
1504     function setApprovalForAll(address operator, bool approved) public virtual override {
1505         _setApprovalForAll(_msgSender(), operator, approved);
1506     }
1507 
1508     /**
1509      * @dev See {IERC1155-isApprovedForAll}.
1510      */
1511     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1512         return _operatorApprovals[account][operator];
1513     }
1514 
1515     /**
1516      * @dev See {IERC1155-safeTransferFrom}.
1517      */
1518     function safeTransferFrom(
1519         address from,
1520         address to,
1521         uint256 id,
1522         uint256 amount,
1523         bytes memory data
1524     ) public virtual override {
1525         require(
1526             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1527             "ERC1155: caller is not owner nor approved"
1528         );
1529         _safeTransferFrom(from, to, id, amount, data);
1530     }
1531 
1532     /**
1533      * @dev See {IERC1155-safeBatchTransferFrom}.
1534      */
1535     function safeBatchTransferFrom(
1536         address from,
1537         address to,
1538         uint256[] memory ids,
1539         uint256[] memory amounts,
1540         bytes memory data
1541     ) public virtual override {
1542         require(
1543             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1544             "ERC1155: transfer caller is not owner nor approved"
1545         );
1546         _safeBatchTransferFrom(from, to, ids, amounts, data);
1547     }
1548 
1549     /**
1550      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1551      *
1552      * Emits a {TransferSingle} event.
1553      *
1554      * Requirements:
1555      *
1556      * - `to` cannot be the zero address.
1557      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1558      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1559      * acceptance magic value.
1560      */
1561     function _safeTransferFrom(
1562         address from,
1563         address to,
1564         uint256 id,
1565         uint256 amount,
1566         bytes memory data
1567     ) internal virtual {
1568         require(to != address(0), "ERC1155: transfer to the zero address");
1569 
1570         address operator = _msgSender();
1571 
1572         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1573 
1574         uint256 fromBalance = _balances[id][from];
1575         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1576         unchecked {
1577             _balances[id][from] = fromBalance - amount;
1578         }
1579         _balances[id][to] += amount;
1580 
1581         emit TransferSingle(operator, from, to, id, amount);
1582 
1583         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1584     }
1585 
1586     /**
1587      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1588      *
1589      * Emits a {TransferBatch} event.
1590      *
1591      * Requirements:
1592      *
1593      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1594      * acceptance magic value.
1595      */
1596     function _safeBatchTransferFrom(
1597         address from,
1598         address to,
1599         uint256[] memory ids,
1600         uint256[] memory amounts,
1601         bytes memory data
1602     ) internal virtual {
1603         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1604         require(to != address(0), "ERC1155: transfer to the zero address");
1605 
1606         address operator = _msgSender();
1607 
1608         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1609 
1610         for (uint256 i = 0; i < ids.length; ++i) {
1611             uint256 id = ids[i];
1612             uint256 amount = amounts[i];
1613 
1614             uint256 fromBalance = _balances[id][from];
1615             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1616             unchecked {
1617                 _balances[id][from] = fromBalance - amount;
1618             }
1619             _balances[id][to] += amount;
1620         }
1621 
1622         emit TransferBatch(operator, from, to, ids, amounts);
1623 
1624         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1625     }
1626 
1627     /**
1628      * @dev Sets a new URI for all token types, by relying on the token type ID
1629      * substitution mechanism
1630      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1631      *
1632      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1633      * URI or any of the amounts in the JSON file at said URI will be replaced by
1634      * clients with the token type ID.
1635      *
1636      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1637      * interpreted by clients as
1638      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1639      * for token type ID 0x4cce0.
1640      *
1641      * See {uri}.
1642      *
1643      * Because these URIs cannot be meaningfully represented by the {URI} event,
1644      * this function emits no events.
1645      */
1646     function _setURI(string memory newuri) internal virtual {
1647         _uri = newuri;
1648     }
1649 
1650     /**
1651      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1652      *
1653      * Emits a {TransferSingle} event.
1654      *
1655      * Requirements:
1656      *
1657      * - `to` cannot be the zero address.
1658      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1659      * acceptance magic value.
1660      */
1661     function _mint(
1662         address to,
1663         uint256 id,
1664         uint256 amount,
1665         bytes memory data
1666     ) internal virtual {
1667         require(to != address(0), "ERC1155: mint to the zero address");
1668 
1669         address operator = _msgSender();
1670 
1671         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1672 
1673         _balances[id][to] += amount;
1674         emit TransferSingle(operator, address(0), to, id, amount);
1675 
1676         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1677     }
1678 
1679     /**
1680      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1681      *
1682      * Requirements:
1683      *
1684      * - `ids` and `amounts` must have the same length.
1685      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1686      * acceptance magic value.
1687      */
1688     function _mintBatch(
1689         address to,
1690         uint256[] memory ids,
1691         uint256[] memory amounts,
1692         bytes memory data
1693     ) internal virtual {
1694         require(to != address(0), "ERC1155: mint to the zero address");
1695         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1696 
1697         address operator = _msgSender();
1698 
1699         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1700 
1701         for (uint256 i = 0; i < ids.length; i++) {
1702             _balances[ids[i]][to] += amounts[i];
1703         }
1704 
1705         emit TransferBatch(operator, address(0), to, ids, amounts);
1706 
1707         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1708     }
1709 
1710     /**
1711      * @dev Destroys `amount` tokens of token type `id` from `from`
1712      *
1713      * Requirements:
1714      *
1715      * - `from` cannot be the zero address.
1716      * - `from` must have at least `amount` tokens of token type `id`.
1717      */
1718     function _burn(
1719         address from,
1720         uint256 id,
1721         uint256 amount
1722     ) internal virtual {
1723         require(from != address(0), "ERC1155: burn from the zero address");
1724 
1725         address operator = _msgSender();
1726 
1727         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1728 
1729         uint256 fromBalance = _balances[id][from];
1730         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1731         unchecked {
1732             _balances[id][from] = fromBalance - amount;
1733         }
1734 
1735         emit TransferSingle(operator, from, address(0), id, amount);
1736     }
1737 
1738     /**
1739      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1740      *
1741      * Requirements:
1742      *
1743      * - `ids` and `amounts` must have the same length.
1744      */
1745     function _burnBatch(
1746         address from,
1747         uint256[] memory ids,
1748         uint256[] memory amounts
1749     ) internal virtual {
1750         require(from != address(0), "ERC1155: burn from the zero address");
1751         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1752 
1753         address operator = _msgSender();
1754 
1755         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1756 
1757         for (uint256 i = 0; i < ids.length; i++) {
1758             uint256 id = ids[i];
1759             uint256 amount = amounts[i];
1760 
1761             uint256 fromBalance = _balances[id][from];
1762             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1763             unchecked {
1764                 _balances[id][from] = fromBalance - amount;
1765             }
1766         }
1767 
1768         emit TransferBatch(operator, from, address(0), ids, amounts);
1769     }
1770 
1771     /**
1772      * @dev Approve `operator` to operate on all of `owner` tokens
1773      *
1774      * Emits a {ApprovalForAll} event.
1775      */
1776     function _setApprovalForAll(
1777         address owner,
1778         address operator,
1779         bool approved
1780     ) internal virtual {
1781         require(owner != operator, "ERC1155: setting approval status for self");
1782         _operatorApprovals[owner][operator] = approved;
1783         emit ApprovalForAll(owner, operator, approved);
1784     }
1785 
1786     /**
1787      * @dev Hook that is called before any token transfer. This includes minting
1788      * and burning, as well as batched variants.
1789      *
1790      * The same hook is called on both single and batched variants. For single
1791      * transfers, the length of the `id` and `amount` arrays will be 1.
1792      *
1793      * Calling conditions (for each `id` and `amount` pair):
1794      *
1795      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1796      * of token type `id` will be  transferred to `to`.
1797      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1798      * for `to`.
1799      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1800      * will be burned.
1801      * - `from` and `to` are never both zero.
1802      * - `ids` and `amounts` have the same, non-zero length.
1803      *
1804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1805      */
1806     function _beforeTokenTransfer(
1807         address operator,
1808         address from,
1809         address to,
1810         uint256[] memory ids,
1811         uint256[] memory amounts,
1812         bytes memory data
1813     ) internal virtual {}
1814 
1815     function _doSafeTransferAcceptanceCheck(
1816         address operator,
1817         address from,
1818         address to,
1819         uint256 id,
1820         uint256 amount,
1821         bytes memory data
1822     ) private {
1823         if (to.isContract()) {
1824             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1825                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1826                     revert("ERC1155: ERC1155Receiver rejected tokens");
1827                 }
1828             } catch Error(string memory reason) {
1829                 revert(reason);
1830             } catch {
1831                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1832             }
1833         }
1834     }
1835 
1836     function _doSafeBatchTransferAcceptanceCheck(
1837         address operator,
1838         address from,
1839         address to,
1840         uint256[] memory ids,
1841         uint256[] memory amounts,
1842         bytes memory data
1843     ) private {
1844         if (to.isContract()) {
1845             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1846                 bytes4 response
1847             ) {
1848                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1849                     revert("ERC1155: ERC1155Receiver rejected tokens");
1850                 }
1851             } catch Error(string memory reason) {
1852                 revert(reason);
1853             } catch {
1854                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1855             }
1856         }
1857     }
1858 
1859     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1860         uint256[] memory array = new uint256[](1);
1861         array[0] = element;
1862 
1863         return array;
1864     }
1865 }
1866 
1867 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1868 
1869 
1870 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 /**
1876  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1877  *
1878  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1879  * clearly identified. Note: While a totalSupply of 1 might mean the
1880  * corresponding is an NFT, there is no guarantees that no other token with the
1881  * same id are not going to be minted.
1882  */
1883 abstract contract ERC1155Supply is ERC1155 {
1884     mapping(uint256 => uint256) private _totalSupply;
1885 
1886     /**
1887      * @dev Total amount of tokens in with a given id.
1888      */
1889     function totalSupply(uint256 id) public view virtual returns (uint256) {
1890         return _totalSupply[id];
1891     }
1892 
1893     /**
1894      * @dev Indicates whether any token exist with a given id, or not.
1895      */
1896     function exists(uint256 id) public view virtual returns (bool) {
1897         return ERC1155Supply.totalSupply(id) > 0;
1898     }
1899 
1900     /**
1901      * @dev See {ERC1155-_beforeTokenTransfer}.
1902      */
1903     function _beforeTokenTransfer(
1904         address operator,
1905         address from,
1906         address to,
1907         uint256[] memory ids,
1908         uint256[] memory amounts,
1909         bytes memory data
1910     ) internal virtual override {
1911         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1912 
1913         if (from == address(0)) {
1914             for (uint256 i = 0; i < ids.length; ++i) {
1915                 _totalSupply[ids[i]] += amounts[i];
1916             }
1917         }
1918 
1919         if (to == address(0)) {
1920             for (uint256 i = 0; i < ids.length; ++i) {
1921                 _totalSupply[ids[i]] -= amounts[i];
1922             }
1923         }
1924     }
1925 }
1926 
1927 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol
1928 
1929 
1930 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Pausable.sol)
1931 
1932 pragma solidity ^0.8.0;
1933 
1934 
1935 
1936 /**
1937  * @dev ERC1155 token with pausable token transfers, minting and burning.
1938  *
1939  * Useful for scenarios such as preventing trades until the end of an evaluation
1940  * period, or having an emergency switch for freezing all token transfers in the
1941  * event of a large bug.
1942  *
1943  * _Available since v3.1._
1944  */
1945 abstract contract ERC1155Pausable is ERC1155, Pausable {
1946     /**
1947      * @dev See {ERC1155-_beforeTokenTransfer}.
1948      *
1949      * Requirements:
1950      *
1951      * - the contract must not be paused.
1952      */
1953     function _beforeTokenTransfer(
1954         address operator,
1955         address from,
1956         address to,
1957         uint256[] memory ids,
1958         uint256[] memory amounts,
1959         bytes memory data
1960     ) internal virtual override {
1961         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1962 
1963         require(!paused(), "ERC1155Pausable: token transfer while paused");
1964     }
1965 }
1966 
1967 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1968 
1969 
1970 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1971 
1972 pragma solidity ^0.8.0;
1973 
1974 
1975 /**
1976  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1977  * own tokens and those that they have been approved to use.
1978  *
1979  * _Available since v3.1._
1980  */
1981 abstract contract ERC1155Burnable is ERC1155 {
1982     function burn(
1983         address account,
1984         uint256 id,
1985         uint256 value
1986     ) public virtual {
1987         require(
1988             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1989             "ERC1155: caller is not owner nor approved"
1990         );
1991 
1992         _burn(account, id, value);
1993     }
1994 
1995     function burnBatch(
1996         address account,
1997         uint256[] memory ids,
1998         uint256[] memory values
1999     ) public virtual {
2000         require(
2001             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2002             "ERC1155: caller is not owner nor approved"
2003         );
2004 
2005         _burnBatch(account, ids, values);
2006     }
2007 }
2008 
2009 // File: AbstractEditionContract.sol
2010 
2011 
2012 
2013 pragma solidity ^0.8.4;
2014 
2015 
2016 
2017 
2018 
2019 
2020 abstract contract AbstractEditionContract is AccessControl, ERC1155Pausable, ERC1155Supply, ERC1155Burnable, Ownable {
2021     
2022     string public name_;
2023     string public symbol_;
2024     
2025     function pause() external onlyOwner {
2026         _pause();
2027     }
2028 
2029     function unpause() external onlyOwner {
2030         _unpause();
2031     }    
2032 
2033     function setURI(string memory baseURI) external onlyOwner {
2034         _setURI(baseURI);
2035     }    
2036 
2037     function name() public view returns (string memory) {
2038         return name_;
2039     }
2040 
2041     function symbol() public view returns (string memory) {
2042         return symbol_;
2043     }          
2044 
2045     function _mint(
2046         address account,
2047         uint256 id,
2048         uint256 amount,
2049         bytes memory data
2050     ) internal virtual override {
2051         super._mint(account, id, amount, data);
2052     }
2053 
2054     function _mintBatch(
2055         address to,
2056         uint256[] memory ids,
2057         uint256[] memory amounts,
2058         bytes memory data
2059     ) internal virtual override{
2060         super._mintBatch(to, ids, amounts, data);
2061     }
2062 
2063     function _burn(
2064         address account,
2065         uint256 id,
2066         uint256 amount
2067     ) internal virtual override {
2068         super._burn(account, id, amount);
2069     }
2070 
2071     function _burnBatch(
2072         address account,
2073         uint256[] memory ids,
2074         uint256[] memory amounts
2075     ) internal virtual override {
2076         super._burnBatch(account, ids, amounts);
2077     }  
2078 
2079     function _beforeTokenTransfer(
2080         address operator,
2081         address from,
2082         address to,
2083         uint256[] memory ids,
2084         uint256[] memory amounts,
2085         bytes memory data
2086     ) internal virtual override(ERC1155Pausable, ERC1155, ERC1155Supply) {
2087         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2088     }  
2089 
2090     function setOwner(address _addr) public onlyOwner {
2091         transferOwnership(_addr);
2092     }
2093 
2094     /**
2095      * @dev See {IERC165-supportsInterface}.
2096      */
2097    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
2098         return super.supportsInterface(interfaceId);
2099     }
2100 
2101 }
2102 // File: KalebsEditions.sol
2103 
2104 
2105 // Based on contract by  Dev by @bitcoinski +  @ultra_dao. Extended by @georgefatlion
2106 pragma solidity ^0.8.4;
2107 
2108 
2109 
2110 
2111 
2112 
2113 
2114 contract KalebsEditions is AbstractEditionContract  {
2115     using SafeMath for uint256;
2116     using Counters for Counters.Counter;
2117 
2118     Counters.Counter private editionCounter; 
2119     
2120     event Claimed(uint index, address indexed account, uint amount);
2121     event ClaimedMultiple(uint[] index, address indexed account, uint[] amount);
2122 
2123     mapping(uint256 => Edition) public editions;
2124     string public _contractURI;
2125 
2126     struct Edition {
2127         bytes32 merkleRoot;
2128         bool saleIsOpen;
2129         uint256 mintPrice;
2130         uint256 maxSupply;
2131         uint256 maxPerWallet;
2132         uint256 maxMintPerTxn;
2133         string metadataLink;
2134         bool merkleProtect;
2135         bool claimMultiple;
2136         mapping(address => uint256) claimedAddress;
2137     }
2138    
2139     constructor(
2140         string memory _name, 
2141         string memory _symbol
2142     ) ERC1155("Editions") {
2143         name_ = _name;
2144         symbol_ = _symbol;
2145     }
2146 
2147     function addEdition(
2148         bytes32 _merkleRoot, 
2149         uint256 _mintPrice, 
2150         uint256 _maxSupply,
2151         uint256 _maxMintPerTxn,
2152         string memory _metadataLink,
2153         uint256 _maxPerWallet,
2154         bool _merkleProtect
2155     ) external onlyOwner {
2156         Edition storage edition = editions[editionCounter.current()];
2157         edition.saleIsOpen = false;
2158         edition.merkleRoot = _merkleRoot;
2159         edition.mintPrice = _mintPrice;
2160         edition.maxSupply = _maxSupply;
2161         edition.maxMintPerTxn = _maxMintPerTxn;
2162         edition.maxPerWallet = _maxPerWallet;
2163         edition.metadataLink = _metadataLink;
2164         edition.merkleProtect = _merkleProtect;
2165         edition.claimMultiple = false;
2166         editionCounter.increment();
2167     }
2168 
2169     function editEdition(
2170         bytes32 _merkleRoot, 
2171         uint256 _mintPrice, 
2172         uint256 _maxSupply,
2173         uint256 _maxMintPerTxn,
2174         string memory _metadataLink,        
2175         uint256 _editionIndex,
2176         bool _saleIsOpen,
2177         uint256 _maxPerWallet,
2178         bool _merkleProtect,
2179         bool _claimMultiple
2180 
2181     ) external onlyOwner {
2182         if(editions[_editionIndex].merkleRoot != _merkleRoot){
2183             editions[_editionIndex].merkleRoot = _merkleRoot;
2184         }
2185         if(editions[_editionIndex].mintPrice != _mintPrice){
2186             editions[_editionIndex].mintPrice = _mintPrice;  
2187         }
2188         if(editions[_editionIndex].maxSupply != _maxSupply){
2189             editions[_editionIndex].maxSupply = _maxSupply;    
2190         }
2191         if(editions[_editionIndex].maxMintPerTxn != _maxMintPerTxn){
2192             editions[_editionIndex].maxMintPerTxn = _maxMintPerTxn; 
2193         }
2194         editions[_editionIndex].metadataLink = _metadataLink;   
2195          
2196         if(editions[_editionIndex].saleIsOpen != _saleIsOpen){
2197             editions[_editionIndex].saleIsOpen = _saleIsOpen; 
2198         }
2199         if(editions[_editionIndex].maxPerWallet != _maxPerWallet){
2200             editions[_editionIndex].maxPerWallet = _maxPerWallet; 
2201         }
2202         if(editions[_editionIndex].merkleProtect != _merkleProtect){
2203             editions[_editionIndex].merkleProtect = _merkleProtect;
2204         }
2205         if(editions[_editionIndex].claimMultiple = _claimMultiple){
2206             editions[_editionIndex].claimMultiple = _claimMultiple;
2207         }
2208     }       
2209 
2210     function claim(
2211         uint256 numPieces,
2212         uint256 amount,
2213         uint256 editionIndex,
2214         bytes32[] calldata merkleProof
2215     ) external payable {
2216         // verify call is valid
2217         require(isValidClaim(numPieces,amount,editionIndex,merkleProof));
2218         
2219         _mint(msg.sender, editionIndex, numPieces, "");
2220         editions[editionIndex].claimedAddress[msg.sender] = editions[editionIndex].claimedAddress[msg.sender].add(numPieces);
2221 
2222         emit Claimed(editionIndex, msg.sender, numPieces);
2223     }
2224 
2225     function claimMultiple(
2226         uint256[] calldata numPieces,
2227         uint256[] calldata amounts,
2228         uint256[] calldata editionIndexes,
2229         bytes32[][] calldata merkleProofs
2230     ) external payable {
2231 
2232          // verify contract is not paused
2233         require(!paused(), "Claim: claiming is paused");
2234 
2235         //validate all tokens being claimed and aggregate a total cost due
2236         uint256 totalPrice = 0;
2237         for (uint i=0; i< editionIndexes.length; i++) {
2238             require(isValidClaim(numPieces[i],amounts[i],editionIndexes[i],merkleProofs[i]), "One or more claims are invalid");
2239             require(editions[editionIndexes[i]].claimMultiple, "Claim multiple not enabled.");
2240 
2241             totalPrice.add(numPieces[i].mul(editions[editionIndexes[i]].mintPrice));
2242         }
2243         // check the message has enough value to cover all tokens. 
2244         require(msg.value >= totalPrice, "Value not enough to cover all transactions");
2245 
2246         for (uint i=0; i< editionIndexes.length; i++) {
2247             require(isValidClaim(numPieces[i],amounts[i],editionIndexes[i],merkleProofs[i]), "One or more claims are invalid");
2248 
2249             editions[editionIndexes[i]].claimedAddress[msg.sender] = editions[editionIndexes[i]].claimedAddress[msg.sender].add(numPieces[i]);
2250         } 
2251 
2252         _mintBatch(msg.sender, editionIndexes, numPieces, "");
2253 
2254         emit ClaimedMultiple(editionIndexes, msg.sender, numPieces);
2255     }
2256 
2257     function mint(
2258         address to,
2259         uint256 editionIndex,
2260         uint256 numPieces
2261     ) public onlyOwner
2262     {
2263         _mint(to, editionIndex, numPieces, "");
2264     }
2265 
2266     function mintBatch(
2267         address to,
2268         uint256[] calldata editionIndexes,
2269         uint256[] calldata numPieces
2270     ) public onlyOwner
2271     {
2272         _mintBatch(to, editionIndexes, numPieces, "");
2273     }
2274 
2275     function isValidClaim( uint256 numPieces,
2276         uint256 amount,
2277         uint256 editionIndex,
2278         bytes32[] calldata merkleProof) internal view returns (bool) {
2279          // verify contract is not paused
2280         require(!paused(), "Claim: claiming is paused");
2281         // verify edition for given index exists
2282         require(editions[editionIndex].maxSupply != 0, "Claim: Edition does not exist");
2283         // verify sale for given edition is open. 
2284         require(editions[editionIndex].saleIsOpen, "Sale is paused");
2285         // Verify minting price
2286         require(msg.value >= numPieces.mul(editions[editionIndex].mintPrice), "Claim: Ether value incorrect");
2287         // Verify numPieces is within remaining claimable amount 
2288         require(editions[editionIndex].claimedAddress[msg.sender].add(numPieces) <= amount, "Claim: Not allowed to claim given amount");
2289         require(editions[editionIndex].claimedAddress[msg.sender].add(numPieces) <= editions[editionIndex].maxPerWallet, "Claim: Not allowed to claim that many from one wallet");
2290         require(numPieces <= editions[editionIndex].maxMintPerTxn, "Max quantity per transaction exceeded");
2291 
2292         require(totalSupply(editionIndex) + numPieces <= editions[editionIndex].maxSupply, "Purchase would exceed max supply");
2293                 
2294         bool isValid = true;
2295         if (editions[editionIndex].merkleProtect)
2296         {
2297             isValid = verifyMerkleProof(merkleProof, editions[editionIndex].merkleRoot);
2298             require(
2299                 isValid,
2300                 "MerkleDistributor: Invalid proof." 
2301             );  
2302         }
2303         return isValid;
2304     }
2305 
2306     function isSaleOpen(uint256 editionIndex) public view returns (bool) {
2307         return editions[editionIndex].saleIsOpen;
2308     }
2309 
2310     function setSaleState(uint256 editionIndex, bool state) external onlyOwner{
2311          editions[editionIndex].saleIsOpen = state;
2312     }
2313 
2314     function verifyMerkleProof(bytes32[] memory proof, bytes32 root)
2315         public
2316         view
2317         returns (bool)
2318     {
2319 
2320         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2321         return MerkleProof.verify(proof, root, leaf);
2322     }
2323 
2324     function char(bytes1 b) internal pure returns (bytes1 c) {
2325         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
2326         else return bytes1(uint8(b) + 0x57);
2327     }
2328     
2329     function withdrawEther(address payable _to, uint256 _amount) public onlyOwner
2330     {
2331         _to.transfer(_amount);
2332     }
2333     
2334     function getClaimedMps(uint256 poolId, address userAdress) public view returns (uint256) {
2335         return editions[poolId].claimedAddress[userAdress];
2336     }
2337 
2338     function uri(uint256 _id) public view override returns (string memory) {
2339             require(totalSupply(_id) > 0, "URI: nonexistent token");
2340             return string(editions[_id].metadataLink);
2341     } 
2342 
2343     function setContractURI(string memory newURI) external onlyOwner{
2344         _contractURI = newURI;
2345     }
2346 
2347     function contractURI() public view returns (string memory) {
2348         return _contractURI;
2349     }
2350 }