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
441 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
483                 computedHash = _efficientHash(computedHash, proofElement);
484             } else {
485                 // Hash(current element of the proof + current computed hash)
486                 computedHash = _efficientHash(proofElement, computedHash);
487             }
488         }
489         return computedHash;
490     }
491 
492     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
493         assembly {
494             mstore(0x00, a)
495             mstore(0x20, b)
496             value := keccak256(0x00, 0x40)
497         }
498     }
499 }
500 
501 // File: @openzeppelin/contracts/utils/Context.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Provides information about the current execution context, including the
510  * sender of the transaction and its data. While these are generally available
511  * via msg.sender and msg.data, they should not be accessed in such a direct
512  * manner, since when dealing with meta-transactions the account sending and
513  * paying for execution may not be the actual sender (as far as an application
514  * is concerned).
515  *
516  * This contract is only required for intermediate, library-like contracts.
517  */
518 abstract contract Context {
519     function _msgSender() internal view virtual returns (address) {
520         return msg.sender;
521     }
522 
523     function _msgData() internal view virtual returns (bytes calldata) {
524         return msg.data;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/security/Pausable.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Contract module which allows children to implement an emergency stop
538  * mechanism that can be triggered by an authorized account.
539  *
540  * This module is used through inheritance. It will make available the
541  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
542  * the functions of your contract. Note that they will not be pausable by
543  * simply including this module, only once the modifiers are put in place.
544  */
545 abstract contract Pausable is Context {
546     /**
547      * @dev Emitted when the pause is triggered by `account`.
548      */
549     event Paused(address account);
550 
551     /**
552      * @dev Emitted when the pause is lifted by `account`.
553      */
554     event Unpaused(address account);
555 
556     bool private _paused;
557 
558     /**
559      * @dev Initializes the contract in unpaused state.
560      */
561     constructor() {
562         _paused = false;
563     }
564 
565     /**
566      * @dev Returns true if the contract is paused, and false otherwise.
567      */
568     function paused() public view virtual returns (bool) {
569         return _paused;
570     }
571 
572     /**
573      * @dev Modifier to make a function callable only when the contract is not paused.
574      *
575      * Requirements:
576      *
577      * - The contract must not be paused.
578      */
579     modifier whenNotPaused() {
580         require(!paused(), "Pausable: paused");
581         _;
582     }
583 
584     /**
585      * @dev Modifier to make a function callable only when the contract is paused.
586      *
587      * Requirements:
588      *
589      * - The contract must be paused.
590      */
591     modifier whenPaused() {
592         require(paused(), "Pausable: not paused");
593         _;
594     }
595 
596     /**
597      * @dev Triggers stopped state.
598      *
599      * Requirements:
600      *
601      * - The contract must not be paused.
602      */
603     function _pause() internal virtual whenNotPaused {
604         _paused = true;
605         emit Paused(_msgSender());
606     }
607 
608     /**
609      * @dev Returns to normal state.
610      *
611      * Requirements:
612      *
613      * - The contract must be paused.
614      */
615     function _unpause() internal virtual whenPaused {
616         _paused = false;
617         emit Unpaused(_msgSender());
618     }
619 }
620 
621 // File: @openzeppelin/contracts/access/Ownable.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Contract module which provides a basic access control mechanism, where
631  * there is an account (an owner) that can be granted exclusive access to
632  * specific functions.
633  *
634  * By default, the owner account will be the one that deploys the contract. This
635  * can later be changed with {transferOwnership}.
636  *
637  * This module is used through inheritance. It will make available the modifier
638  * `onlyOwner`, which can be applied to your functions to restrict their use to
639  * the owner.
640  */
641 abstract contract Ownable is Context {
642     address private _owner;
643 
644     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
645 
646     /**
647      * @dev Initializes the contract setting the deployer as the initial owner.
648      */
649     constructor() {
650         _transferOwnership(_msgSender());
651     }
652 
653     /**
654      * @dev Returns the address of the current owner.
655      */
656     function owner() public view virtual returns (address) {
657         return _owner;
658     }
659 
660     /**
661      * @dev Throws if called by any account other than the owner.
662      */
663     modifier onlyOwner() {
664         require(owner() == _msgSender(), "Ownable: caller is not the owner");
665         _;
666     }
667 
668     /**
669      * @dev Leaves the contract without owner. It will not be possible to call
670      * `onlyOwner` functions anymore. Can only be called by the current owner.
671      *
672      * NOTE: Renouncing ownership will leave the contract without an owner,
673      * thereby removing any functionality that is only available to the owner.
674      */
675     function renounceOwnership() public virtual onlyOwner {
676         _transferOwnership(address(0));
677     }
678 
679     /**
680      * @dev Transfers ownership of the contract to a new account (`newOwner`).
681      * Can only be called by the current owner.
682      */
683     function transferOwnership(address newOwner) public virtual onlyOwner {
684         require(newOwner != address(0), "Ownable: new owner is the zero address");
685         _transferOwnership(newOwner);
686     }
687 
688     /**
689      * @dev Transfers ownership of the contract to a new account (`newOwner`).
690      * Internal function without access restriction.
691      */
692     function _transferOwnership(address newOwner) internal virtual {
693         address oldOwner = _owner;
694         _owner = newOwner;
695         emit OwnershipTransferred(oldOwner, newOwner);
696     }
697 }
698 
699 // File: @openzeppelin/contracts/utils/Address.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
703 
704 pragma solidity ^0.8.1;
705 
706 /**
707  * @dev Collection of functions related to the address type
708  */
709 library Address {
710     /**
711      * @dev Returns true if `account` is a contract.
712      *
713      * [IMPORTANT]
714      * ====
715      * It is unsafe to assume that an address for which this function returns
716      * false is an externally-owned account (EOA) and not a contract.
717      *
718      * Among others, `isContract` will return false for the following
719      * types of addresses:
720      *
721      *  - an externally-owned account
722      *  - a contract in construction
723      *  - an address where a contract will be created
724      *  - an address where a contract lived, but was destroyed
725      * ====
726      *
727      * [IMPORTANT]
728      * ====
729      * You shouldn't rely on `isContract` to protect against flash loan attacks!
730      *
731      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
732      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
733      * constructor.
734      * ====
735      */
736     function isContract(address account) internal view returns (bool) {
737         // This method relies on extcodesize/address.code.length, which returns 0
738         // for contracts in construction, since the code is only stored at the end
739         // of the constructor execution.
740 
741         return account.code.length > 0;
742     }
743 
744     /**
745      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
746      * `recipient`, forwarding all available gas and reverting on errors.
747      *
748      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
749      * of certain opcodes, possibly making contracts go over the 2300 gas limit
750      * imposed by `transfer`, making them unable to receive funds via
751      * `transfer`. {sendValue} removes this limitation.
752      *
753      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
754      *
755      * IMPORTANT: because control is transferred to `recipient`, care must be
756      * taken to not create reentrancy vulnerabilities. Consider using
757      * {ReentrancyGuard} or the
758      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
759      */
760     function sendValue(address payable recipient, uint256 amount) internal {
761         require(address(this).balance >= amount, "Address: insufficient balance");
762 
763         (bool success, ) = recipient.call{value: amount}("");
764         require(success, "Address: unable to send value, recipient may have reverted");
765     }
766 
767     /**
768      * @dev Performs a Solidity function call using a low level `call`. A
769      * plain `call` is an unsafe replacement for a function call: use this
770      * function instead.
771      *
772      * If `target` reverts with a revert reason, it is bubbled up by this
773      * function (like regular Solidity function calls).
774      *
775      * Returns the raw returned data. To convert to the expected return value,
776      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
777      *
778      * Requirements:
779      *
780      * - `target` must be a contract.
781      * - calling `target` with `data` must not revert.
782      *
783      * _Available since v3.1._
784      */
785     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
786         return functionCall(target, data, "Address: low-level call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
791      * `errorMessage` as a fallback revert reason when `target` reverts.
792      *
793      * _Available since v3.1._
794      */
795     function functionCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal returns (bytes memory) {
800         return functionCallWithValue(target, data, 0, errorMessage);
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
805      * but also transferring `value` wei to `target`.
806      *
807      * Requirements:
808      *
809      * - the calling contract must have an ETH balance of at least `value`.
810      * - the called Solidity function must be `payable`.
811      *
812      * _Available since v3.1._
813      */
814     function functionCallWithValue(
815         address target,
816         bytes memory data,
817         uint256 value
818     ) internal returns (bytes memory) {
819         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
824      * with `errorMessage` as a fallback revert reason when `target` reverts.
825      *
826      * _Available since v3.1._
827      */
828     function functionCallWithValue(
829         address target,
830         bytes memory data,
831         uint256 value,
832         string memory errorMessage
833     ) internal returns (bytes memory) {
834         require(address(this).balance >= value, "Address: insufficient balance for call");
835         require(isContract(target), "Address: call to non-contract");
836 
837         (bool success, bytes memory returndata) = target.call{value: value}(data);
838         return verifyCallResult(success, returndata, errorMessage);
839     }
840 
841     /**
842      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
843      * but performing a static call.
844      *
845      * _Available since v3.3._
846      */
847     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
848         return functionStaticCall(target, data, "Address: low-level static call failed");
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
853      * but performing a static call.
854      *
855      * _Available since v3.3._
856      */
857     function functionStaticCall(
858         address target,
859         bytes memory data,
860         string memory errorMessage
861     ) internal view returns (bytes memory) {
862         require(isContract(target), "Address: static call to non-contract");
863 
864         (bool success, bytes memory returndata) = target.staticcall(data);
865         return verifyCallResult(success, returndata, errorMessage);
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
870      * but performing a delegate call.
871      *
872      * _Available since v3.4._
873      */
874     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
875         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
880      * but performing a delegate call.
881      *
882      * _Available since v3.4._
883      */
884     function functionDelegateCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal returns (bytes memory) {
889         require(isContract(target), "Address: delegate call to non-contract");
890 
891         (bool success, bytes memory returndata) = target.delegatecall(data);
892         return verifyCallResult(success, returndata, errorMessage);
893     }
894 
895     /**
896      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
897      * revert reason using the provided one.
898      *
899      * _Available since v4.3._
900      */
901     function verifyCallResult(
902         bool success,
903         bytes memory returndata,
904         string memory errorMessage
905     ) internal pure returns (bytes memory) {
906         if (success) {
907             return returndata;
908         } else {
909             // Look for revert reason and bubble it up if present
910             if (returndata.length > 0) {
911                 // The easiest way to bubble the revert reason is using memory via assembly
912 
913                 assembly {
914                     let returndata_size := mload(returndata)
915                     revert(add(32, returndata), returndata_size)
916                 }
917             } else {
918                 revert(errorMessage);
919             }
920         }
921     }
922 }
923 
924 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 /**
932  * @dev Interface of the ERC165 standard, as defined in the
933  * https://eips.ethereum.org/EIPS/eip-165[EIP].
934  *
935  * Implementers can declare support of contract interfaces, which can then be
936  * queried by others ({ERC165Checker}).
937  *
938  * For an implementation, see {ERC165}.
939  */
940 interface IERC165 {
941     /**
942      * @dev Returns true if this contract implements the interface defined by
943      * `interfaceId`. See the corresponding
944      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
945      * to learn more about how these ids are created.
946      *
947      * This function call must use less than 30 000 gas.
948      */
949     function supportsInterface(bytes4 interfaceId) external view returns (bool);
950 }
951 
952 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
953 
954 
955 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 
960 /**
961  * @dev Implementation of the {IERC165} interface.
962  *
963  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
964  * for the additional interface id that will be supported. For example:
965  *
966  * ```solidity
967  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
968  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
969  * }
970  * ```
971  *
972  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
973  */
974 abstract contract ERC165 is IERC165 {
975     /**
976      * @dev See {IERC165-supportsInterface}.
977      */
978     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
979         return interfaceId == type(IERC165).interfaceId;
980     }
981 }
982 
983 // File: @openzeppelin/contracts/access/AccessControl.sol
984 
985 
986 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 
991 
992 
993 
994 /**
995  * @dev Contract module that allows children to implement role-based access
996  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
997  * members except through off-chain means by accessing the contract event logs. Some
998  * applications may benefit from on-chain enumerability, for those cases see
999  * {AccessControlEnumerable}.
1000  *
1001  * Roles are referred to by their `bytes32` identifier. These should be exposed
1002  * in the external API and be unique. The best way to achieve this is by
1003  * using `public constant` hash digests:
1004  *
1005  * ```
1006  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1007  * ```
1008  *
1009  * Roles can be used to represent a set of permissions. To restrict access to a
1010  * function call, use {hasRole}:
1011  *
1012  * ```
1013  * function foo() public {
1014  *     require(hasRole(MY_ROLE, msg.sender));
1015  *     ...
1016  * }
1017  * ```
1018  *
1019  * Roles can be granted and revoked dynamically via the {grantRole} and
1020  * {revokeRole} functions. Each role has an associated admin role, and only
1021  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1022  *
1023  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1024  * that only accounts with this role will be able to grant or revoke other
1025  * roles. More complex role relationships can be created by using
1026  * {_setRoleAdmin}.
1027  *
1028  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1029  * grant and revoke this role. Extra precautions should be taken to secure
1030  * accounts that have been granted it.
1031  */
1032 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1033     struct RoleData {
1034         mapping(address => bool) members;
1035         bytes32 adminRole;
1036     }
1037 
1038     mapping(bytes32 => RoleData) private _roles;
1039 
1040     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1041 
1042     /**
1043      * @dev Modifier that checks that an account has a specific role. Reverts
1044      * with a standardized message including the required role.
1045      *
1046      * The format of the revert reason is given by the following regular expression:
1047      *
1048      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1049      *
1050      * _Available since v4.1._
1051      */
1052     modifier onlyRole(bytes32 role) {
1053         _checkRole(role, _msgSender());
1054         _;
1055     }
1056 
1057     /**
1058      * @dev See {IERC165-supportsInterface}.
1059      */
1060     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1061         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1062     }
1063 
1064     /**
1065      * @dev Returns `true` if `account` has been granted `role`.
1066      */
1067     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1068         return _roles[role].members[account];
1069     }
1070 
1071     /**
1072      * @dev Revert with a standard message if `account` is missing `role`.
1073      *
1074      * The format of the revert reason is given by the following regular expression:
1075      *
1076      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1077      */
1078     function _checkRole(bytes32 role, address account) internal view virtual {
1079         if (!hasRole(role, account)) {
1080             revert(
1081                 string(
1082                     abi.encodePacked(
1083                         "AccessControl: account ",
1084                         Strings.toHexString(uint160(account), 20),
1085                         " is missing role ",
1086                         Strings.toHexString(uint256(role), 32)
1087                     )
1088                 )
1089             );
1090         }
1091     }
1092 
1093     /**
1094      * @dev Returns the admin role that controls `role`. See {grantRole} and
1095      * {revokeRole}.
1096      *
1097      * To change a role's admin, use {_setRoleAdmin}.
1098      */
1099     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1100         return _roles[role].adminRole;
1101     }
1102 
1103     /**
1104      * @dev Grants `role` to `account`.
1105      *
1106      * If `account` had not been already granted `role`, emits a {RoleGranted}
1107      * event.
1108      *
1109      * Requirements:
1110      *
1111      * - the caller must have ``role``'s admin role.
1112      */
1113     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1114         _grantRole(role, account);
1115     }
1116 
1117     /**
1118      * @dev Revokes `role` from `account`.
1119      *
1120      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1121      *
1122      * Requirements:
1123      *
1124      * - the caller must have ``role``'s admin role.
1125      */
1126     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1127         _revokeRole(role, account);
1128     }
1129 
1130     /**
1131      * @dev Revokes `role` from the calling account.
1132      *
1133      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1134      * purpose is to provide a mechanism for accounts to lose their privileges
1135      * if they are compromised (such as when a trusted device is misplaced).
1136      *
1137      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1138      * event.
1139      *
1140      * Requirements:
1141      *
1142      * - the caller must be `account`.
1143      */
1144     function renounceRole(bytes32 role, address account) public virtual override {
1145         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1146 
1147         _revokeRole(role, account);
1148     }
1149 
1150     /**
1151      * @dev Grants `role` to `account`.
1152      *
1153      * If `account` had not been already granted `role`, emits a {RoleGranted}
1154      * event. Note that unlike {grantRole}, this function doesn't perform any
1155      * checks on the calling account.
1156      *
1157      * [WARNING]
1158      * ====
1159      * This function should only be called from the constructor when setting
1160      * up the initial roles for the system.
1161      *
1162      * Using this function in any other way is effectively circumventing the admin
1163      * system imposed by {AccessControl}.
1164      * ====
1165      *
1166      * NOTE: This function is deprecated in favor of {_grantRole}.
1167      */
1168     function _setupRole(bytes32 role, address account) internal virtual {
1169         _grantRole(role, account);
1170     }
1171 
1172     /**
1173      * @dev Sets `adminRole` as ``role``'s admin role.
1174      *
1175      * Emits a {RoleAdminChanged} event.
1176      */
1177     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1178         bytes32 previousAdminRole = getRoleAdmin(role);
1179         _roles[role].adminRole = adminRole;
1180         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1181     }
1182 
1183     /**
1184      * @dev Grants `role` to `account`.
1185      *
1186      * Internal function without access restriction.
1187      */
1188     function _grantRole(bytes32 role, address account) internal virtual {
1189         if (!hasRole(role, account)) {
1190             _roles[role].members[account] = true;
1191             emit RoleGranted(role, account, _msgSender());
1192         }
1193     }
1194 
1195     /**
1196      * @dev Revokes `role` from `account`.
1197      *
1198      * Internal function without access restriction.
1199      */
1200     function _revokeRole(bytes32 role, address account) internal virtual {
1201         if (hasRole(role, account)) {
1202             _roles[role].members[account] = false;
1203             emit RoleRevoked(role, account, _msgSender());
1204         }
1205     }
1206 }
1207 
1208 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1209 
1210 
1211 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 /**
1217  * @dev _Available since v3.1._
1218  */
1219 interface IERC1155Receiver is IERC165 {
1220     /**
1221      * @dev Handles the receipt of a single ERC1155 token type. This function is
1222      * called at the end of a `safeTransferFrom` after the balance has been updated.
1223      *
1224      * NOTE: To accept the transfer, this must return
1225      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1226      * (i.e. 0xf23a6e61, or its own function selector).
1227      *
1228      * @param operator The address which initiated the transfer (i.e. msg.sender)
1229      * @param from The address which previously owned the token
1230      * @param id The ID of the token being transferred
1231      * @param value The amount of tokens being transferred
1232      * @param data Additional data with no specified format
1233      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1234      */
1235     function onERC1155Received(
1236         address operator,
1237         address from,
1238         uint256 id,
1239         uint256 value,
1240         bytes calldata data
1241     ) external returns (bytes4);
1242 
1243     /**
1244      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1245      * is called at the end of a `safeBatchTransferFrom` after the balances have
1246      * been updated.
1247      *
1248      * NOTE: To accept the transfer(s), this must return
1249      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1250      * (i.e. 0xbc197c81, or its own function selector).
1251      *
1252      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1253      * @param from The address which previously owned the token
1254      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1255      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1256      * @param data Additional data with no specified format
1257      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1258      */
1259     function onERC1155BatchReceived(
1260         address operator,
1261         address from,
1262         uint256[] calldata ids,
1263         uint256[] calldata values,
1264         bytes calldata data
1265     ) external returns (bytes4);
1266 }
1267 
1268 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1269 
1270 
1271 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1278  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1279  *
1280  * _Available since v3.1._
1281  */
1282 interface IERC1155 is IERC165 {
1283     /**
1284      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1285      */
1286     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1287 
1288     /**
1289      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1290      * transfers.
1291      */
1292     event TransferBatch(
1293         address indexed operator,
1294         address indexed from,
1295         address indexed to,
1296         uint256[] ids,
1297         uint256[] values
1298     );
1299 
1300     /**
1301      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1302      * `approved`.
1303      */
1304     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1305 
1306     /**
1307      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1308      *
1309      * If an {URI} event was emitted for `id`, the standard
1310      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1311      * returned by {IERC1155MetadataURI-uri}.
1312      */
1313     event URI(string value, uint256 indexed id);
1314 
1315     /**
1316      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1317      *
1318      * Requirements:
1319      *
1320      * - `account` cannot be the zero address.
1321      */
1322     function balanceOf(address account, uint256 id) external view returns (uint256);
1323 
1324     /**
1325      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1326      *
1327      * Requirements:
1328      *
1329      * - `accounts` and `ids` must have the same length.
1330      */
1331     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1332         external
1333         view
1334         returns (uint256[] memory);
1335 
1336     /**
1337      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1338      *
1339      * Emits an {ApprovalForAll} event.
1340      *
1341      * Requirements:
1342      *
1343      * - `operator` cannot be the caller.
1344      */
1345     function setApprovalForAll(address operator, bool approved) external;
1346 
1347     /**
1348      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1349      *
1350      * See {setApprovalForAll}.
1351      */
1352     function isApprovedForAll(address account, address operator) external view returns (bool);
1353 
1354     /**
1355      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1356      *
1357      * Emits a {TransferSingle} event.
1358      *
1359      * Requirements:
1360      *
1361      * - `to` cannot be the zero address.
1362      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1363      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1364      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1365      * acceptance magic value.
1366      */
1367     function safeTransferFrom(
1368         address from,
1369         address to,
1370         uint256 id,
1371         uint256 amount,
1372         bytes calldata data
1373     ) external;
1374 
1375     /**
1376      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1377      *
1378      * Emits a {TransferBatch} event.
1379      *
1380      * Requirements:
1381      *
1382      * - `ids` and `amounts` must have the same length.
1383      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1384      * acceptance magic value.
1385      */
1386     function safeBatchTransferFrom(
1387         address from,
1388         address to,
1389         uint256[] calldata ids,
1390         uint256[] calldata amounts,
1391         bytes calldata data
1392     ) external;
1393 }
1394 
1395 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1396 
1397 
1398 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 
1403 /**
1404  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1405  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1406  *
1407  * _Available since v3.1._
1408  */
1409 interface IERC1155MetadataURI is IERC1155 {
1410     /**
1411      * @dev Returns the URI for token type `id`.
1412      *
1413      * If the `\{id\}` substring is present in the URI, it must be replaced by
1414      * clients with the actual token type ID.
1415      */
1416     function uri(uint256 id) external view returns (string memory);
1417 }
1418 
1419 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1420 
1421 
1422 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1423 
1424 pragma solidity ^0.8.0;
1425 
1426 
1427 
1428 
1429 
1430 
1431 
1432 /**
1433  * @dev Implementation of the basic standard multi-token.
1434  * See https://eips.ethereum.org/EIPS/eip-1155
1435  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1436  *
1437  * _Available since v3.1._
1438  */
1439 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1440     using Address for address;
1441 
1442     // Mapping from token ID to account balances
1443     mapping(uint256 => mapping(address => uint256)) private _balances;
1444 
1445     // Mapping from account to operator approvals
1446     mapping(address => mapping(address => bool)) private _operatorApprovals;
1447 
1448     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1449     string private _uri;
1450 
1451     /**
1452      * @dev See {_setURI}.
1453      */
1454     constructor(string memory uri_) {
1455         _setURI(uri_);
1456     }
1457 
1458     /**
1459      * @dev See {IERC165-supportsInterface}.
1460      */
1461     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1462         return
1463             interfaceId == type(IERC1155).interfaceId ||
1464             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1465             super.supportsInterface(interfaceId);
1466     }
1467 
1468     /**
1469      * @dev See {IERC1155MetadataURI-uri}.
1470      *
1471      * This implementation returns the same URI for *all* token types. It relies
1472      * on the token type ID substitution mechanism
1473      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1474      *
1475      * Clients calling this function must replace the `\{id\}` substring with the
1476      * actual token type ID.
1477      */
1478     function uri(uint256) public view virtual override returns (string memory) {
1479         return _uri;
1480     }
1481 
1482     /**
1483      * @dev See {IERC1155-balanceOf}.
1484      *
1485      * Requirements:
1486      *
1487      * - `account` cannot be the zero address.
1488      */
1489     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1490         require(account != address(0), "ERC1155: balance query for the zero address");
1491         return _balances[id][account];
1492     }
1493 
1494     /**
1495      * @dev See {IERC1155-balanceOfBatch}.
1496      *
1497      * Requirements:
1498      *
1499      * - `accounts` and `ids` must have the same length.
1500      */
1501     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1502         public
1503         view
1504         virtual
1505         override
1506         returns (uint256[] memory)
1507     {
1508         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1509 
1510         uint256[] memory batchBalances = new uint256[](accounts.length);
1511 
1512         for (uint256 i = 0; i < accounts.length; ++i) {
1513             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1514         }
1515 
1516         return batchBalances;
1517     }
1518 
1519     /**
1520      * @dev See {IERC1155-setApprovalForAll}.
1521      */
1522     function setApprovalForAll(address operator, bool approved) public virtual override {
1523         _setApprovalForAll(_msgSender(), operator, approved);
1524     }
1525 
1526     /**
1527      * @dev See {IERC1155-isApprovedForAll}.
1528      */
1529     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1530         return _operatorApprovals[account][operator];
1531     }
1532 
1533     /**
1534      * @dev See {IERC1155-safeTransferFrom}.
1535      */
1536     function safeTransferFrom(
1537         address from,
1538         address to,
1539         uint256 id,
1540         uint256 amount,
1541         bytes memory data
1542     ) public virtual override {
1543         require(
1544             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1545             "ERC1155: caller is not owner nor approved"
1546         );
1547         _safeTransferFrom(from, to, id, amount, data);
1548     }
1549 
1550     /**
1551      * @dev See {IERC1155-safeBatchTransferFrom}.
1552      */
1553     function safeBatchTransferFrom(
1554         address from,
1555         address to,
1556         uint256[] memory ids,
1557         uint256[] memory amounts,
1558         bytes memory data
1559     ) public virtual override {
1560         require(
1561             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1562             "ERC1155: transfer caller is not owner nor approved"
1563         );
1564         _safeBatchTransferFrom(from, to, ids, amounts, data);
1565     }
1566 
1567     /**
1568      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1569      *
1570      * Emits a {TransferSingle} event.
1571      *
1572      * Requirements:
1573      *
1574      * - `to` cannot be the zero address.
1575      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1576      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1577      * acceptance magic value.
1578      */
1579     function _safeTransferFrom(
1580         address from,
1581         address to,
1582         uint256 id,
1583         uint256 amount,
1584         bytes memory data
1585     ) internal virtual {
1586         require(to != address(0), "ERC1155: transfer to the zero address");
1587 
1588         address operator = _msgSender();
1589 
1590         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1591 
1592         uint256 fromBalance = _balances[id][from];
1593         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1594         unchecked {
1595             _balances[id][from] = fromBalance - amount;
1596         }
1597         _balances[id][to] += amount;
1598 
1599         emit TransferSingle(operator, from, to, id, amount);
1600 
1601         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1602     }
1603 
1604     /**
1605      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1606      *
1607      * Emits a {TransferBatch} event.
1608      *
1609      * Requirements:
1610      *
1611      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1612      * acceptance magic value.
1613      */
1614     function _safeBatchTransferFrom(
1615         address from,
1616         address to,
1617         uint256[] memory ids,
1618         uint256[] memory amounts,
1619         bytes memory data
1620     ) internal virtual {
1621         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1622         require(to != address(0), "ERC1155: transfer to the zero address");
1623 
1624         address operator = _msgSender();
1625 
1626         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1627 
1628         for (uint256 i = 0; i < ids.length; ++i) {
1629             uint256 id = ids[i];
1630             uint256 amount = amounts[i];
1631 
1632             uint256 fromBalance = _balances[id][from];
1633             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1634             unchecked {
1635                 _balances[id][from] = fromBalance - amount;
1636             }
1637             _balances[id][to] += amount;
1638         }
1639 
1640         emit TransferBatch(operator, from, to, ids, amounts);
1641 
1642         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1643     }
1644 
1645     /**
1646      * @dev Sets a new URI for all token types, by relying on the token type ID
1647      * substitution mechanism
1648      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1649      *
1650      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1651      * URI or any of the amounts in the JSON file at said URI will be replaced by
1652      * clients with the token type ID.
1653      *
1654      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1655      * interpreted by clients as
1656      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1657      * for token type ID 0x4cce0.
1658      *
1659      * See {uri}.
1660      *
1661      * Because these URIs cannot be meaningfully represented by the {URI} event,
1662      * this function emits no events.
1663      */
1664     function _setURI(string memory newuri) internal virtual {
1665         _uri = newuri;
1666     }
1667 
1668     /**
1669      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1670      *
1671      * Emits a {TransferSingle} event.
1672      *
1673      * Requirements:
1674      *
1675      * - `to` cannot be the zero address.
1676      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1677      * acceptance magic value.
1678      */
1679     function _mint(
1680         address to,
1681         uint256 id,
1682         uint256 amount,
1683         bytes memory data
1684     ) internal virtual {
1685         require(to != address(0), "ERC1155: mint to the zero address");
1686 
1687         address operator = _msgSender();
1688 
1689         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1690 
1691         _balances[id][to] += amount;
1692         emit TransferSingle(operator, address(0), to, id, amount);
1693 
1694         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1695     }
1696 
1697     /**
1698      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1699      *
1700      * Requirements:
1701      *
1702      * - `ids` and `amounts` must have the same length.
1703      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1704      * acceptance magic value.
1705      */
1706     function _mintBatch(
1707         address to,
1708         uint256[] memory ids,
1709         uint256[] memory amounts,
1710         bytes memory data
1711     ) internal virtual {
1712         require(to != address(0), "ERC1155: mint to the zero address");
1713         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1714 
1715         address operator = _msgSender();
1716 
1717         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1718 
1719         for (uint256 i = 0; i < ids.length; i++) {
1720             _balances[ids[i]][to] += amounts[i];
1721         }
1722 
1723         emit TransferBatch(operator, address(0), to, ids, amounts);
1724 
1725         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1726     }
1727 
1728     /**
1729      * @dev Destroys `amount` tokens of token type `id` from `from`
1730      *
1731      * Requirements:
1732      *
1733      * - `from` cannot be the zero address.
1734      * - `from` must have at least `amount` tokens of token type `id`.
1735      */
1736     function _burn(
1737         address from,
1738         uint256 id,
1739         uint256 amount
1740     ) internal virtual {
1741         require(from != address(0), "ERC1155: burn from the zero address");
1742 
1743         address operator = _msgSender();
1744 
1745         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1746 
1747         uint256 fromBalance = _balances[id][from];
1748         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1749         unchecked {
1750             _balances[id][from] = fromBalance - amount;
1751         }
1752 
1753         emit TransferSingle(operator, from, address(0), id, amount);
1754     }
1755 
1756     /**
1757      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1758      *
1759      * Requirements:
1760      *
1761      * - `ids` and `amounts` must have the same length.
1762      */
1763     function _burnBatch(
1764         address from,
1765         uint256[] memory ids,
1766         uint256[] memory amounts
1767     ) internal virtual {
1768         require(from != address(0), "ERC1155: burn from the zero address");
1769         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1770 
1771         address operator = _msgSender();
1772 
1773         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1774 
1775         for (uint256 i = 0; i < ids.length; i++) {
1776             uint256 id = ids[i];
1777             uint256 amount = amounts[i];
1778 
1779             uint256 fromBalance = _balances[id][from];
1780             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1781             unchecked {
1782                 _balances[id][from] = fromBalance - amount;
1783             }
1784         }
1785 
1786         emit TransferBatch(operator, from, address(0), ids, amounts);
1787     }
1788 
1789     /**
1790      * @dev Approve `operator` to operate on all of `owner` tokens
1791      *
1792      * Emits a {ApprovalForAll} event.
1793      */
1794     function _setApprovalForAll(
1795         address owner,
1796         address operator,
1797         bool approved
1798     ) internal virtual {
1799         require(owner != operator, "ERC1155: setting approval status for self");
1800         _operatorApprovals[owner][operator] = approved;
1801         emit ApprovalForAll(owner, operator, approved);
1802     }
1803 
1804     /**
1805      * @dev Hook that is called before any token transfer. This includes minting
1806      * and burning, as well as batched variants.
1807      *
1808      * The same hook is called on both single and batched variants. For single
1809      * transfers, the length of the `id` and `amount` arrays will be 1.
1810      *
1811      * Calling conditions (for each `id` and `amount` pair):
1812      *
1813      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1814      * of token type `id` will be  transferred to `to`.
1815      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1816      * for `to`.
1817      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1818      * will be burned.
1819      * - `from` and `to` are never both zero.
1820      * - `ids` and `amounts` have the same, non-zero length.
1821      *
1822      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1823      */
1824     function _beforeTokenTransfer(
1825         address operator,
1826         address from,
1827         address to,
1828         uint256[] memory ids,
1829         uint256[] memory amounts,
1830         bytes memory data
1831     ) internal virtual {}
1832 
1833     function _doSafeTransferAcceptanceCheck(
1834         address operator,
1835         address from,
1836         address to,
1837         uint256 id,
1838         uint256 amount,
1839         bytes memory data
1840     ) private {
1841         if (to.isContract()) {
1842             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1843                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1844                     revert("ERC1155: ERC1155Receiver rejected tokens");
1845                 }
1846             } catch Error(string memory reason) {
1847                 revert(reason);
1848             } catch {
1849                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1850             }
1851         }
1852     }
1853 
1854     function _doSafeBatchTransferAcceptanceCheck(
1855         address operator,
1856         address from,
1857         address to,
1858         uint256[] memory ids,
1859         uint256[] memory amounts,
1860         bytes memory data
1861     ) private {
1862         if (to.isContract()) {
1863             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1864                 bytes4 response
1865             ) {
1866                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1867                     revert("ERC1155: ERC1155Receiver rejected tokens");
1868                 }
1869             } catch Error(string memory reason) {
1870                 revert(reason);
1871             } catch {
1872                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1873             }
1874         }
1875     }
1876 
1877     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1878         uint256[] memory array = new uint256[](1);
1879         array[0] = element;
1880 
1881         return array;
1882     }
1883 }
1884 
1885 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1886 
1887 
1888 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1889 
1890 pragma solidity ^0.8.0;
1891 
1892 
1893 /**
1894  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1895  *
1896  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1897  * clearly identified. Note: While a totalSupply of 1 might mean the
1898  * corresponding is an NFT, there is no guarantees that no other token with the
1899  * same id are not going to be minted.
1900  */
1901 abstract contract ERC1155Supply is ERC1155 {
1902     mapping(uint256 => uint256) private _totalSupply;
1903 
1904     /**
1905      * @dev Total amount of tokens in with a given id.
1906      */
1907     function totalSupply(uint256 id) public view virtual returns (uint256) {
1908         return _totalSupply[id];
1909     }
1910 
1911     /**
1912      * @dev Indicates whether any token exist with a given id, or not.
1913      */
1914     function exists(uint256 id) public view virtual returns (bool) {
1915         return ERC1155Supply.totalSupply(id) > 0;
1916     }
1917 
1918     /**
1919      * @dev See {ERC1155-_beforeTokenTransfer}.
1920      */
1921     function _beforeTokenTransfer(
1922         address operator,
1923         address from,
1924         address to,
1925         uint256[] memory ids,
1926         uint256[] memory amounts,
1927         bytes memory data
1928     ) internal virtual override {
1929         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1930 
1931         if (from == address(0)) {
1932             for (uint256 i = 0; i < ids.length; ++i) {
1933                 _totalSupply[ids[i]] += amounts[i];
1934             }
1935         }
1936 
1937         if (to == address(0)) {
1938             for (uint256 i = 0; i < ids.length; ++i) {
1939                 _totalSupply[ids[i]] -= amounts[i];
1940             }
1941         }
1942     }
1943 }
1944 
1945 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol
1946 
1947 
1948 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Pausable.sol)
1949 
1950 pragma solidity ^0.8.0;
1951 
1952 
1953 
1954 /**
1955  * @dev ERC1155 token with pausable token transfers, minting and burning.
1956  *
1957  * Useful for scenarios such as preventing trades until the end of an evaluation
1958  * period, or having an emergency switch for freezing all token transfers in the
1959  * event of a large bug.
1960  *
1961  * _Available since v3.1._
1962  */
1963 abstract contract ERC1155Pausable is ERC1155, Pausable {
1964     /**
1965      * @dev See {ERC1155-_beforeTokenTransfer}.
1966      *
1967      * Requirements:
1968      *
1969      * - the contract must not be paused.
1970      */
1971     function _beforeTokenTransfer(
1972         address operator,
1973         address from,
1974         address to,
1975         uint256[] memory ids,
1976         uint256[] memory amounts,
1977         bytes memory data
1978     ) internal virtual override {
1979         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1980 
1981         require(!paused(), "ERC1155Pausable: token transfer while paused");
1982     }
1983 }
1984 
1985 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1986 
1987 
1988 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1989 
1990 pragma solidity ^0.8.0;
1991 
1992 
1993 /**
1994  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1995  * own tokens and those that they have been approved to use.
1996  *
1997  * _Available since v3.1._
1998  */
1999 abstract contract ERC1155Burnable is ERC1155 {
2000     function burn(
2001         address account,
2002         uint256 id,
2003         uint256 value
2004     ) public virtual {
2005         require(
2006             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2007             "ERC1155: caller is not owner nor approved"
2008         );
2009 
2010         _burn(account, id, value);
2011     }
2012 
2013     function burnBatch(
2014         address account,
2015         uint256[] memory ids,
2016         uint256[] memory values
2017     ) public virtual {
2018         require(
2019             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2020             "ERC1155: caller is not owner nor approved"
2021         );
2022 
2023         _burnBatch(account, ids, values);
2024     }
2025 }
2026 
2027 // File: AbstractEditionContract.sol
2028 
2029 
2030 
2031 pragma solidity ^0.8.4;
2032 
2033 
2034 
2035 
2036 
2037 
2038 
2039 abstract contract AbstractEditionContract is AccessControl, ERC1155Pausable, ERC1155Supply, ERC1155Burnable, Ownable {
2040     
2041     string public name_;
2042     string public symbol_;
2043     
2044     function pause() external onlyOwner {
2045         _pause();
2046     }
2047 
2048     function unpause() external onlyOwner {
2049         _unpause();
2050     }    
2051 
2052     function setURI(string memory baseURI) external onlyOwner {
2053         _setURI(baseURI);
2054     }    
2055 
2056     function name() public view returns (string memory) {
2057         return name_;
2058     }
2059 
2060     function symbol() public view returns (string memory) {
2061         return symbol_;
2062     }          
2063 
2064     function _mint(
2065         address account,
2066         uint256 id,
2067         uint256 amount,
2068         bytes memory data
2069     ) internal virtual override(ERC1155) {
2070         super._mint(account, id, amount, data);
2071     }
2072 
2073     function _mintBatch(
2074         address to,
2075         uint256[] memory ids,
2076         uint256[] memory amounts,
2077         bytes memory data
2078     ) internal virtual override(ERC1155) {
2079         super._mintBatch(to, ids, amounts, data);
2080     }
2081 
2082     function _burn(
2083         address account,
2084         uint256 id,
2085         uint256 amount
2086     ) internal virtual override(ERC1155) {
2087         super._burn(account, id, amount);
2088     }
2089 
2090     function _burnBatch(
2091         address account,
2092         uint256[] memory ids,
2093         uint256[] memory amounts
2094     ) internal virtual override(ERC1155) {
2095         super._burnBatch(account, ids, amounts);
2096     }  
2097 
2098     function _beforeTokenTransfer(
2099         address operator,
2100         address from,
2101         address to,
2102         uint256[] memory ids,
2103         uint256[] memory amounts,
2104         bytes memory data
2105     ) internal virtual override(ERC1155Pausable, ERC1155,ERC1155Supply) {
2106         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2107     }  
2108 
2109     function setOwner(address _addr) public onlyOwner {
2110         transferOwnership(_addr);
2111     }
2112 
2113     /**
2114      * @dev See {IERC165-supportsInterface}.
2115      */
2116    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
2117         return super.supportsInterface(interfaceId);
2118     }
2119 
2120 }
2121 // File: WavelengthXmfers.sol
2122 
2123 pragma solidity ^0.8.4;
2124 
2125 // Based on contract by  Dev by @bitcoinski +  @ultra_dao. Extended by @georgefatlion
2126 contract WavelengthXmfers is AbstractEditionContract  {
2127     using SafeMath for uint256;
2128     using Counters for Counters.Counter;
2129 
2130     Counters.Counter private editionCounter; 
2131     
2132     event Claimed(uint index, address indexed account, uint amount);
2133     event ClaimedMultiple(uint[] index, address indexed account, uint[] amount);
2134 
2135     mapping(uint256 => Edition) public editions;
2136     string public _contractURI;
2137 
2138     struct Edition {
2139         bytes32 merkleRoot;
2140         bool saleIsOpen;
2141         uint256 mintPrice;
2142         uint256 maxSupply;
2143         uint256 maxPerWallet;
2144         uint256 maxMintPerTxn;
2145         string metadataLink;
2146         bool merkleProtect;
2147         bool claimMultiple;
2148         mapping(address => uint256) claimedAddress;
2149     }
2150    
2151     constructor(
2152         string memory _name, 
2153         string memory _symbol
2154     ) ERC1155("Editions") {
2155         name_ = _name;
2156         symbol_ = _symbol;
2157     }
2158 
2159     function addEdition(
2160         bytes32 _merkleRoot, 
2161         uint256 _mintPrice, 
2162         uint256 _maxSupply,
2163         uint256 _maxMintPerTxn,
2164         string memory _metadataLink,
2165         uint256 _maxPerWallet,
2166         bool _merkleProtect
2167     ) external onlyOwner {
2168         Edition storage edition = editions[editionCounter.current()];
2169         edition.saleIsOpen = false;
2170         edition.merkleRoot = _merkleRoot;
2171         edition.mintPrice = _mintPrice;
2172         edition.maxSupply = _maxSupply;
2173         edition.maxMintPerTxn = _maxMintPerTxn;
2174         edition.maxPerWallet = _maxPerWallet;
2175         edition.metadataLink = _metadataLink;
2176         edition.merkleProtect = _merkleProtect;
2177         edition.claimMultiple = false;
2178         editionCounter.increment();
2179     }
2180 
2181     function editEdition(
2182         bytes32 _merkleRoot, 
2183         uint256 _mintPrice, 
2184         uint256 _maxSupply,
2185         uint256 _maxMintPerTxn,
2186         string memory _metadataLink,        
2187         uint256 _editionIndex,
2188         bool _saleIsOpen,
2189         uint256 _maxPerWallet,
2190         bool _merkleProtect,
2191         bool _claimMultiple
2192 
2193     ) external onlyOwner {
2194         if(editions[_editionIndex].merkleRoot != _merkleRoot){
2195             editions[_editionIndex].merkleRoot = _merkleRoot;
2196         }
2197         if(editions[_editionIndex].mintPrice != _mintPrice){
2198             editions[_editionIndex].mintPrice = _mintPrice;  
2199         }
2200         if(editions[_editionIndex].maxSupply != _maxSupply){
2201             editions[_editionIndex].maxSupply = _maxSupply;    
2202         }
2203         if(editions[_editionIndex].maxMintPerTxn != _maxMintPerTxn){
2204             editions[_editionIndex].maxMintPerTxn = _maxMintPerTxn; 
2205         }
2206         editions[_editionIndex].metadataLink = _metadataLink;   
2207          
2208         if(editions[_editionIndex].saleIsOpen != _saleIsOpen){
2209             editions[_editionIndex].saleIsOpen = _saleIsOpen; 
2210         }
2211         if(editions[_editionIndex].maxPerWallet != _maxPerWallet){
2212             editions[_editionIndex].maxPerWallet = _maxPerWallet; 
2213         }
2214         if(editions[_editionIndex].merkleProtect != _merkleProtect){
2215             editions[_editionIndex].merkleProtect = _merkleProtect;
2216         }
2217         if(editions[_editionIndex].claimMultiple = _claimMultiple){
2218             editions[_editionIndex].claimMultiple = _claimMultiple;
2219         }
2220     }       
2221 
2222     function claim(
2223         uint256 numPieces,
2224         uint256 amount,
2225         uint256 editionIndex,
2226         bytes32[] calldata merkleProof
2227     ) external payable {
2228         // verify call is valid
2229         require(isValidClaim(numPieces,amount,editionIndex,merkleProof));
2230         
2231         _mint(msg.sender, editionIndex, numPieces, "");
2232         editions[editionIndex].claimedAddress[msg.sender] = editions[editionIndex].claimedAddress[msg.sender].add(numPieces);
2233 
2234         emit Claimed(editionIndex, msg.sender, numPieces);
2235     }
2236 
2237     function claimMultiple(
2238         uint256[] calldata numPieces,
2239         uint256[] calldata amounts,
2240         uint256[] calldata editionIndexes,
2241         bytes32[][] calldata merkleProofs
2242     ) external payable {
2243 
2244          // verify contract is not paused
2245         require(!paused(), "Claim: claiming is paused");
2246 
2247         //validate all tokens being claimed and aggregate a total cost due
2248         uint256 totalPrice = 0;
2249         for (uint i=0; i< editionIndexes.length; i++) {
2250             require(isValidClaim(numPieces[i],amounts[i],editionIndexes[i],merkleProofs[i]), "One or more claims are invalid");
2251             require(editions[editionIndexes[i]].claimMultiple, "Claim multiple not enabled.");
2252 
2253             totalPrice.add(numPieces[i].mul(editions[editionIndexes[i]].mintPrice));
2254         }
2255         // check the message has enough value to cover all tokens. 
2256         require(msg.value >= totalPrice, "Value not enough to cover all transactions");
2257 
2258         for (uint i=0; i< editionIndexes.length; i++) {
2259             require(isValidClaim(numPieces[i],amounts[i],editionIndexes[i],merkleProofs[i]), "One or more claims are invalid");
2260 
2261             editions[editionIndexes[i]].claimedAddress[msg.sender] = editions[editionIndexes[i]].claimedAddress[msg.sender].add(numPieces[i]);
2262         } 
2263 
2264         _mintBatch(msg.sender, editionIndexes, numPieces, "");
2265 
2266         emit ClaimedMultiple(editionIndexes, msg.sender, numPieces);
2267     }
2268 
2269     function mint(
2270         address to,
2271         uint256 editionIndex,
2272         uint256 numPieces
2273     ) public onlyOwner
2274     {
2275         _mint(to, editionIndex, numPieces, "");
2276     }
2277 
2278     function mintBatch(
2279         address to,
2280         uint256[] calldata editionIndexes,
2281         uint256[] calldata numPieces
2282     ) public onlyOwner
2283     {
2284         _mintBatch(to, editionIndexes, numPieces, "");
2285     }
2286 
2287     function isValidClaim( uint256 numPieces,
2288         uint256 amount,
2289         uint256 editionIndex,
2290         bytes32[] calldata merkleProof) internal view returns (bool) {
2291          // verify contract is not paused
2292         require(!paused(), "Claim: claiming is paused");
2293         // verify edition for given index exists
2294         require(editions[editionIndex].maxSupply != 0, "Claim: Edition does not exist");
2295         // verify sale for given edition is open. 
2296         require(editions[editionIndex].saleIsOpen, "Sale is paused");
2297         // Verify minting price
2298         require(msg.value >= numPieces.mul(editions[editionIndex].mintPrice), "Claim: Ether value incorrect");
2299         // Verify numPieces is within remaining claimable amount 
2300         require(editions[editionIndex].claimedAddress[msg.sender].add(numPieces) <= amount, "Claim: Not allowed to claim given amount");
2301         require(editions[editionIndex].claimedAddress[msg.sender].add(numPieces) <= editions[editionIndex].maxPerWallet, "Claim: Not allowed to claim that many from one wallet");
2302         require(numPieces <= editions[editionIndex].maxMintPerTxn, "Max quantity per transaction exceeded");
2303 
2304         require(totalSupply(editionIndex) + numPieces <= editions[editionIndex].maxSupply, "Purchase would exceed max supply");
2305                 
2306         bool isValid = true;
2307         if (editions[editionIndex].merkleProtect)
2308         {
2309             isValid = verifyMerkleProof(merkleProof, editions[editionIndex].merkleRoot);
2310             require(
2311                 isValid,
2312                 "MerkleDistributor: Invalid proof." 
2313             );  
2314         }
2315         return isValid;
2316     }
2317 
2318     function isSaleOpen(uint256 editionIndex) public view returns (bool) {
2319         return editions[editionIndex].saleIsOpen;
2320     }
2321 
2322     function setSaleState(uint256 editionIndex, bool state) external onlyOwner{
2323          editions[editionIndex].saleIsOpen = state;
2324     }
2325 
2326     function verifyMerkleProof(bytes32[] memory proof, bytes32 root)
2327         public
2328         view
2329         returns (bool)
2330     {
2331 
2332         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2333         return MerkleProof.verify(proof, root, leaf);
2334     }
2335 
2336     function char(bytes1 b) internal pure returns (bytes1 c) {
2337         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
2338         else return bytes1(uint8(b) + 0x57);
2339     }
2340     
2341     function withdrawEther(address payable _to, uint256 _amount) public onlyOwner
2342     {
2343         _to.transfer(_amount);
2344     }
2345     
2346     function getClaimedMps(uint256 poolId, address userAdress) public view returns (uint256) {
2347         return editions[poolId].claimedAddress[userAdress];
2348     }
2349 
2350     function uri(uint256 _id) public view override returns (string memory) {
2351             require(totalSupply(_id) > 0, "URI: nonexistent token");
2352             return string(editions[_id].metadataLink);
2353     } 
2354 
2355     function setContractURI(string memory newURI) external onlyOwner{
2356         _contractURI = newURI;
2357     }
2358 
2359     function contractURI() public view returns (string memory) {
2360         return _contractURI;
2361     }
2362 }