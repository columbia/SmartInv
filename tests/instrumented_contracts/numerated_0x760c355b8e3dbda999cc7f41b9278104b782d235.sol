1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 // CAUTION
74 // This version of SafeMath should only be used with Solidity 0.8 or later,
75 // because it relies on the compiler's built in overflow checks.
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations.
79  *
80  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
81  * now has built in overflow checking.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, with an overflow flag.
86      *
87      * _Available since v3.4._
88      */
89     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91             uint256 c = a + b;
92             if (c < a) return (false, 0);
93             return (true, c);
94         }
95     }
96 
97     /**
98      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b > a) return (false, 0);
105             return (true, a - b);
106         }
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117             // benefit is lost if 'b' is also tested.
118             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119             if (a == 0) return (true, 0);
120             uint256 c = a * b;
121             if (c / a != b) return (false, 0);
122             return (true, c);
123         }
124     }
125 
126     /**
127      * @dev Returns the division of two unsigned integers, with a division by zero flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         unchecked {
133             if (b == 0) return (false, 0);
134             return (true, a / b);
135         }
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b == 0) return (false, 0);
146             return (true, a % b);
147         }
148     }
149 
150     /**
151      * @dev Returns the addition of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `+` operator.
155      *
156      * Requirements:
157      *
158      * - Addition cannot overflow.
159      */
160     function add(uint256 a, uint256 b) internal pure returns (uint256) {
161         return a + b;
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a - b;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         return a * b;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers, reverting on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator.
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a / b;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a % b;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
224      * overflow (when the result is negative).
225      *
226      * CAUTION: This function is deprecated because it requires allocating memory for the error
227      * message unnecessarily. For custom revert reasons use {trySub}.
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(
236         uint256 a,
237         uint256 b,
238         string memory errorMessage
239     ) internal pure returns (uint256) {
240         unchecked {
241             require(b <= a, errorMessage);
242             return a - b;
243         }
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(
259         uint256 a,
260         uint256 b,
261         string memory errorMessage
262     ) internal pure returns (uint256) {
263         unchecked {
264             require(b > 0, errorMessage);
265             return a / b;
266         }
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * reverting with custom message when dividing by zero.
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {tryMod}.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function mod(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         unchecked {
290             require(b > 0, errorMessage);
291             return a % b;
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/Strings.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev String operations.
305  */
306 library Strings {
307     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
311      */
312     function toString(uint256 value) internal pure returns (string memory) {
313         // Inspired by OraclizeAPI's implementation - MIT licence
314         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
315 
316         if (value == 0) {
317             return "0";
318         }
319         uint256 temp = value;
320         uint256 digits;
321         while (temp != 0) {
322             digits++;
323             temp /= 10;
324         }
325         bytes memory buffer = new bytes(digits);
326         while (value != 0) {
327             digits -= 1;
328             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
329             value /= 10;
330         }
331         return string(buffer);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
336      */
337     function toHexString(uint256 value) internal pure returns (string memory) {
338         if (value == 0) {
339             return "0x00";
340         }
341         uint256 temp = value;
342         uint256 length = 0;
343         while (temp != 0) {
344             length++;
345             temp >>= 8;
346         }
347         return toHexString(value, length);
348     }
349 
350     /**
351      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
352      */
353     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
354         bytes memory buffer = new bytes(2 * length + 2);
355         buffer[0] = "0";
356         buffer[1] = "x";
357         for (uint256 i = 2 * length + 1; i > 1; --i) {
358             buffer[i] = _HEX_SYMBOLS[value & 0xf];
359             value >>= 4;
360         }
361         require(value == 0, "Strings: hex length insufficient");
362         return string(buffer);
363     }
364 }
365 
366 // File: @openzeppelin/contracts/utils/Context.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Provides information about the current execution context, including the
375  * sender of the transaction and its data. While these are generally available
376  * via msg.sender and msg.data, they should not be accessed in such a direct
377  * manner, since when dealing with meta-transactions the account sending and
378  * paying for execution may not be the actual sender (as far as an application
379  * is concerned).
380  *
381  * This contract is only required for intermediate, library-like contracts.
382  */
383 abstract contract Context {
384     function _msgSender() internal view virtual returns (address) {
385         return msg.sender;
386     }
387 
388     function _msgData() internal view virtual returns (bytes calldata) {
389         return msg.data;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/access/Ownable.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Contract module which provides a basic access control mechanism, where
403  * there is an account (an owner) that can be granted exclusive access to
404  * specific functions.
405  *
406  * By default, the owner account will be the one that deploys the contract. This
407  * can later be changed with {transferOwnership}.
408  *
409  * This module is used through inheritance. It will make available the modifier
410  * `onlyOwner`, which can be applied to your functions to restrict their use to
411  * the owner.
412  */
413 abstract contract Ownable is Context {
414     address private _owner;
415 
416     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 
418     /**
419      * @dev Initializes the contract setting the deployer as the initial owner.
420      */
421     constructor() {
422         _transferOwnership(_msgSender());
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view virtual returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(owner() == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         _transferOwnership(address(0));
449     }
450 
451     /**
452      * @dev Transfers ownership of the contract to a new account (`newOwner`).
453      * Can only be called by the current owner.
454      */
455     function transferOwnership(address newOwner) public virtual onlyOwner {
456         require(newOwner != address(0), "Ownable: new owner is the zero address");
457         _transferOwnership(newOwner);
458     }
459 
460     /**
461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
462      * Internal function without access restriction.
463      */
464     function _transferOwnership(address newOwner) internal virtual {
465         address oldOwner = _owner;
466         _owner = newOwner;
467         emit OwnershipTransferred(oldOwner, newOwner);
468     }
469 }
470 
471 // File: @openzeppelin/contracts/utils/Address.sol
472 
473 
474 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
475 
476 pragma solidity ^0.8.1;
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * [IMPORTANT]
486      * ====
487      * It is unsafe to assume that an address for which this function returns
488      * false is an externally-owned account (EOA) and not a contract.
489      *
490      * Among others, `isContract` will return false for the following
491      * types of addresses:
492      *
493      *  - an externally-owned account
494      *  - a contract in construction
495      *  - an address where a contract will be created
496      *  - an address where a contract lived, but was destroyed
497      * ====
498      *
499      * [IMPORTANT]
500      * ====
501      * You shouldn't rely on `isContract` to protect against flash loan attacks!
502      *
503      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
504      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
505      * constructor.
506      * ====
507      */
508     function isContract(address account) internal view returns (bool) {
509         // This method relies on extcodesize/address.code.length, which returns 0
510         // for contracts in construction, since the code is only stored at the end
511         // of the constructor execution.
512 
513         return account.code.length > 0;
514     }
515 
516     /**
517      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
518      * `recipient`, forwarding all available gas and reverting on errors.
519      *
520      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
521      * of certain opcodes, possibly making contracts go over the 2300 gas limit
522      * imposed by `transfer`, making them unable to receive funds via
523      * `transfer`. {sendValue} removes this limitation.
524      *
525      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
526      *
527      * IMPORTANT: because control is transferred to `recipient`, care must be
528      * taken to not create reentrancy vulnerabilities. Consider using
529      * {ReentrancyGuard} or the
530      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
531      */
532     function sendValue(address payable recipient, uint256 amount) internal {
533         require(address(this).balance >= amount, "Address: insufficient balance");
534 
535         (bool success, ) = recipient.call{value: amount}("");
536         require(success, "Address: unable to send value, recipient may have reverted");
537     }
538 
539     /**
540      * @dev Performs a Solidity function call using a low level `call`. A
541      * plain `call` is an unsafe replacement for a function call: use this
542      * function instead.
543      *
544      * If `target` reverts with a revert reason, it is bubbled up by this
545      * function (like regular Solidity function calls).
546      *
547      * Returns the raw returned data. To convert to the expected return value,
548      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
549      *
550      * Requirements:
551      *
552      * - `target` must be a contract.
553      * - calling `target` with `data` must not revert.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
558         return functionCall(target, data, "Address: low-level call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
563      * `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value
590     ) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
596      * with `errorMessage` as a fallback revert reason when `target` reverts.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(address(this).balance >= value, "Address: insufficient balance for call");
607         require(isContract(target), "Address: call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.call{value: value}(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a static call.
616      *
617      * _Available since v3.3._
618      */
619     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
620         return functionStaticCall(target, data, "Address: low-level static call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal view returns (bytes memory) {
634         require(isContract(target), "Address: static call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.staticcall(data);
637         return verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but performing a delegate call.
643      *
644      * _Available since v3.4._
645      */
646     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
647         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(
657         address target,
658         bytes memory data,
659         string memory errorMessage
660     ) internal returns (bytes memory) {
661         require(isContract(target), "Address: delegate call to non-contract");
662 
663         (bool success, bytes memory returndata) = target.delegatecall(data);
664         return verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
669      * revert reason using the provided one.
670      *
671      * _Available since v4.3._
672      */
673     function verifyCallResult(
674         bool success,
675         bytes memory returndata,
676         string memory errorMessage
677     ) internal pure returns (bytes memory) {
678         if (success) {
679             return returndata;
680         } else {
681             // Look for revert reason and bubble it up if present
682             if (returndata.length > 0) {
683                 // The easiest way to bubble the revert reason is using memory via assembly
684 
685                 assembly {
686                     let returndata_size := mload(returndata)
687                     revert(add(32, returndata), returndata_size)
688                 }
689             } else {
690                 revert(errorMessage);
691             }
692         }
693     }
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @title ERC721 token receiver interface
705  * @dev Interface for any contract that wants to support safeTransfers
706  * from ERC721 asset contracts.
707  */
708 interface IERC721Receiver {
709     /**
710      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
711      * by `operator` from `from`, this function is called.
712      *
713      * It must return its Solidity selector to confirm the token transfer.
714      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
715      *
716      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
717      */
718     function onERC721Received(
719         address operator,
720         address from,
721         uint256 tokenId,
722         bytes calldata data
723     ) external returns (bytes4);
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Interface of the ERC165 standard, as defined in the
735  * https://eips.ethereum.org/EIPS/eip-165[EIP].
736  *
737  * Implementers can declare support of contract interfaces, which can then be
738  * queried by others ({ERC165Checker}).
739  *
740  * For an implementation, see {ERC165}.
741  */
742 interface IERC165 {
743     /**
744      * @dev Returns true if this contract implements the interface defined by
745      * `interfaceId`. See the corresponding
746      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
747      * to learn more about how these ids are created.
748      *
749      * This function call must use less than 30 000 gas.
750      */
751     function supportsInterface(bytes4 interfaceId) external view returns (bool);
752 }
753 
754 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Implementation of the {IERC165} interface.
764  *
765  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
766  * for the additional interface id that will be supported. For example:
767  *
768  * ```solidity
769  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
771  * }
772  * ```
773  *
774  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
775  */
776 abstract contract ERC165 is IERC165 {
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
781         return interfaceId == type(IERC165).interfaceId;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev Required interface of an ERC721 compliant contract.
795  */
796 interface IERC721 is IERC165 {
797     /**
798      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
799      */
800     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
801 
802     /**
803      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
804      */
805     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
806 
807     /**
808      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
809      */
810     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
811 
812     /**
813      * @dev Returns the number of tokens in ``owner``'s account.
814      */
815     function balanceOf(address owner) external view returns (uint256 balance);
816 
817     /**
818      * @dev Returns the owner of the `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function ownerOf(uint256 tokenId) external view returns (address owner);
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
828      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) external;
845 
846     /**
847      * @dev Transfers `tokenId` token from `from` to `to`.
848      *
849      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must be owned by `from`.
856      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) external;
865 
866     /**
867      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
868      * The approval is cleared when the token is transferred.
869      *
870      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
871      *
872      * Requirements:
873      *
874      * - The caller must own the token or be an approved operator.
875      * - `tokenId` must exist.
876      *
877      * Emits an {Approval} event.
878      */
879     function approve(address to, uint256 tokenId) external;
880 
881     /**
882      * @dev Returns the account approved for `tokenId` token.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function getApproved(uint256 tokenId) external view returns (address operator);
889 
890     /**
891      * @dev Approve or remove `operator` as an operator for the caller.
892      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
893      *
894      * Requirements:
895      *
896      * - The `operator` cannot be the caller.
897      *
898      * Emits an {ApprovalForAll} event.
899      */
900     function setApprovalForAll(address operator, bool _approved) external;
901 
902     /**
903      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
904      *
905      * See {setApprovalForAll}
906      */
907     function isApprovedForAll(address owner, address operator) external view returns (bool);
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes calldata data
927     ) external;
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
931 
932 
933 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
940  * @dev See https://eips.ethereum.org/EIPS/eip-721
941  */
942 interface IERC721Enumerable is IERC721 {
943     /**
944      * @dev Returns the total amount of tokens stored by the contract.
945      */
946     function totalSupply() external view returns (uint256);
947 
948     /**
949      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
950      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
951      */
952     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
953 
954     /**
955      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
956      * Use along with {totalSupply} to enumerate all tokens.
957      */
958     function tokenByIndex(uint256 index) external view returns (uint256);
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
962 
963 
964 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Metadata is IERC721 {
974     /**
975      * @dev Returns the token collection name.
976      */
977     function name() external view returns (string memory);
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() external view returns (string memory);
983 
984     /**
985      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
986      */
987     function tokenURI(uint256 tokenId) external view returns (string memory);
988 }
989 
990 // File: contracts/ERC721A.sol
991 
992 
993 
994 pragma solidity ^0.8.10;
995 
996 
997 
998 
999 
1000 
1001 
1002 
1003 
1004 /**
1005  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1006  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1007  *
1008  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1009  *
1010  * Does not support burning tokens to address(0).
1011  */
1012 contract ERC721A is
1013   Context,
1014   ERC165,
1015   IERC721,
1016   IERC721Metadata,
1017   IERC721Enumerable
1018 {
1019   using Address for address;
1020   using Strings for uint256;
1021 
1022   struct TokenOwnership {
1023     address addr;
1024     uint64 startTimestamp;
1025   }
1026 
1027   struct AddressData {
1028     uint128 balance;
1029     uint128 numberMinted;
1030   }
1031 
1032   uint256 private currentIndex = 1;
1033 
1034 
1035   // Token name
1036   string private _name;
1037 
1038   // Token symbol
1039   string private _symbol;
1040 
1041   // Mapping from token ID to ownership details
1042   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1043   mapping(uint256 => TokenOwnership) private _ownerships;
1044 
1045   // Mapping owner address to address data
1046   mapping(address => AddressData) private _addressData;
1047 
1048   // Mapping from token ID to approved address
1049   mapping(uint256 => address) private _tokenApprovals;
1050 
1051   // Mapping from owner to operator approvals
1052   mapping(address => mapping(address => bool)) private _operatorApprovals;
1053 
1054   /**
1055    * @dev
1056    * `maxBatchSize` refers to how much a minter can mint at a time.
1057    */
1058   constructor(
1059     string memory name_,
1060     string memory symbol_ //uint256 maxBatchSize_
1061   ) {
1062     //require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1063     _name = name_;
1064     _symbol = symbol_;
1065     // maxBatchSize = maxBatchSize_;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Enumerable-totalSupply}.
1070    */
1071   function totalSupply() public view override returns (uint256) {
1072     return currentIndex - 1;
1073   }
1074 
1075   /**
1076    * @dev See {IERC721Enumerable-tokenByIndex}.
1077    */
1078   function tokenByIndex(uint256 index) public view override returns (uint256) {
1079     require(index < totalSupply(), "ERC721A: global index out of bounds");
1080     return index;
1081   }
1082 
1083   /**
1084    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1085    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1086    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1087    */
1088   function tokenOfOwnerByIndex(address owner, uint256 index)
1089     public
1090     view
1091     override
1092     returns (uint256)
1093   {
1094     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1095     uint256 numMintedSoFar = totalSupply();
1096     uint256 tokenIdsIdx = 0;
1097     address currOwnershipAddr = address(0);
1098     for (uint256 i = 0; i < numMintedSoFar; i++) {
1099       TokenOwnership memory ownership = _ownerships[i];
1100       if (ownership.addr != address(0)) {
1101         currOwnershipAddr = ownership.addr;
1102       }
1103       if (currOwnershipAddr == owner) {
1104         if (tokenIdsIdx == index) {
1105           return i;
1106         }
1107         tokenIdsIdx++;
1108       }
1109     }
1110     revert("ERC721A: unable to get token of owner by index");
1111   }
1112 
1113   /**
1114    * @dev See {IERC165-supportsInterface}.
1115    */
1116   function supportsInterface(bytes4 interfaceId)
1117     public
1118     view
1119     virtual
1120     override(ERC165, IERC165)
1121     returns (bool)
1122   {
1123     return
1124       interfaceId == type(IERC721).interfaceId ||
1125       interfaceId == type(IERC721Metadata).interfaceId ||
1126       interfaceId == type(IERC721Enumerable).interfaceId ||
1127       super.supportsInterface(interfaceId);
1128   }
1129 
1130   /**
1131    * @dev See {IERC721-balanceOf}.
1132    */
1133   function balanceOf(address owner) public view override returns (uint256) {
1134     require(owner != address(0), "ERC721A: balance query for the zero address");
1135     return uint256(_addressData[owner].balance);
1136   }
1137 
1138   function _numberMinted(address owner) internal view returns (uint256) {
1139     require(
1140       owner != address(0),
1141       "ERC721A: number minted query for the zero address"
1142     );
1143     return uint256(_addressData[owner].numberMinted);
1144   }
1145 
1146   function ownershipOf(uint256 tokenId)
1147     internal
1148     view
1149     returns (TokenOwnership memory)
1150   {
1151     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1152 
1153     // uint256 lowestTokenToCheck;
1154    //  if (tokenId >= maxBatchSize) {
1155     //   lowestTokenToCheck = tokenId - maxBatchSize + 1;
1156    // }
1157 
1158     for (uint256 curr = tokenId; ; curr--) {
1159       TokenOwnership memory ownership = _ownerships[curr];
1160       if (ownership.addr != address(0)) {
1161         return ownership;
1162       }
1163     }
1164 
1165 // unreachable statement
1166     revert("ERC721A: unable to determine the owner of token");
1167   }
1168 
1169   /**
1170    * @dev See {IERC721-ownerOf}.
1171    */
1172   function ownerOf(uint256 tokenId) public view override returns (address) {
1173     return ownershipOf(tokenId).addr;
1174   }
1175 
1176   /**
1177    * @dev See {IERC721Metadata-name}.
1178    */
1179   function name() public view virtual override returns (string memory) {
1180     return _name;
1181   }
1182 
1183   /**
1184    * @dev See {IERC721Metadata-symbol}.
1185    */
1186   function symbol() public view virtual override returns (string memory) {
1187     return _symbol;
1188   }
1189 
1190   /**
1191    * @dev See {IERC721Metadata-tokenURI}.
1192    */
1193   function tokenURI(uint256 tokenId)
1194     public
1195     view
1196     virtual
1197     override
1198     returns (string memory)
1199   {
1200     require(
1201       _exists(tokenId),
1202       "ERC721Metadata: URI query for nonexistent token"
1203     );
1204 
1205     string memory baseURI = _baseURI();
1206     return
1207       bytes(baseURI).length > 0
1208         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1209         : "";
1210   }
1211 
1212   /**
1213    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1214    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1215    * by default, can be overriden in child contracts.
1216    */
1217   function _baseURI() internal view virtual returns (string memory) {
1218     return "";
1219   }
1220 
1221   /**
1222    * @dev See {IERC721-approve}.
1223    */
1224   function approve(address to, uint256 tokenId) public override {
1225     address owner = ERC721A.ownerOf(tokenId);
1226     require(to != owner, "ERC721A: approval to current owner");
1227 
1228     require(
1229       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1230       "ERC721A: approve caller is not owner nor approved for all"
1231     );
1232 
1233     _approve(to, tokenId, owner);
1234   }
1235 
1236   /**
1237    * @dev See {IERC721-getApproved}.
1238    */
1239   function getApproved(uint256 tokenId) public view override returns (address) {
1240     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1241 
1242     return _tokenApprovals[tokenId];
1243   }
1244 
1245   /**
1246    * @dev See {IERC721-setApprovalForAll}.
1247    */
1248   function setApprovalForAll(address operator, bool approved) public override {
1249     require(operator != _msgSender(), "ERC721A: approve to caller");
1250 
1251     _operatorApprovals[_msgSender()][operator] = approved;
1252     emit ApprovalForAll(_msgSender(), operator, approved);
1253   }
1254 
1255   /**
1256    * @dev See {IERC721-isApprovedForAll}.
1257    */
1258   function isApprovedForAll(address owner, address operator)
1259     public
1260     view
1261     virtual
1262     override
1263     returns (bool)
1264   {
1265     return _operatorApprovals[owner][operator];
1266   }
1267 
1268   /**
1269    * @dev See {IERC721-transferFrom}.
1270    */
1271   function transferFrom(
1272     address from,
1273     address to,
1274     uint256 tokenId
1275   ) public override {
1276     _transfer(from, to, tokenId);
1277   }
1278 
1279   /**
1280    * @dev See {IERC721-safeTransferFrom}.
1281    */
1282   function safeTransferFrom(
1283     address from,
1284     address to,
1285     uint256 tokenId
1286   ) public override {
1287     safeTransferFrom(from, to, tokenId, "");
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-safeTransferFrom}.
1292    */
1293   function safeTransferFrom(
1294     address from,
1295     address to,
1296     uint256 tokenId,
1297     bytes memory _data
1298   ) public override {
1299     _transfer(from, to, tokenId);
1300     require(
1301       _checkOnERC721Received(from, to, tokenId, _data),
1302       "ERC721A: transfer to non ERC721Receiver implementer"
1303     );
1304   }
1305 
1306   /**
1307    * @dev Returns whether `tokenId` exists.
1308    *
1309    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1310    *
1311    * Tokens start existing when they are minted (`_mint`),
1312    */
1313   function _exists(uint256 tokenId) internal view returns (bool) {
1314     return tokenId < currentIndex;
1315   }
1316 
1317   function _safeMint(address to, uint256 quantity) internal {
1318     _safeMint(to, quantity, "");
1319   }
1320 
1321   /**
1322    * @dev Mints `quantity` tokens and transfers them to `to`.
1323    *
1324    * Requirements:
1325    *
1326    * - `to` cannot be the zero address.
1327    * - `quantity` cannot be larger than the max batch size.
1328    *
1329    * Emits a {Transfer} event.
1330    */
1331   function _safeMint(
1332     address to,
1333     uint256 quantity,
1334     bytes memory _data
1335   ) internal {
1336     uint256 startTokenId = currentIndex;
1337     require(to != address(0), "ERC721A: mint to the zero address");
1338     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1339     require(!_exists(startTokenId), "ERC721A: token already minted");
1340     //require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1341 
1342     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1343 
1344     AddressData memory addressData = _addressData[to];
1345     _addressData[to] = AddressData(
1346       addressData.balance + uint128(quantity),
1347       addressData.numberMinted + uint128(quantity)
1348     );
1349     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1350 
1351     uint256 updatedIndex = startTokenId;
1352 
1353     for (uint256 i = 0; i < quantity; i++) {
1354       emit Transfer(address(0), to, updatedIndex);
1355       require(
1356         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1357         "ERC721A: transfer to non ERC721Receiver implementer"
1358       );
1359       updatedIndex++;
1360     }
1361 
1362     currentIndex = updatedIndex;
1363     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1364   }
1365 
1366   /**
1367    * @dev Transfers `tokenId` from `from` to `to`.
1368    *
1369    * Requirements:
1370    *
1371    * - `to` cannot be the zero address.
1372    * - `tokenId` token must be owned by `from`.
1373    *
1374    * Emits a {Transfer} event.
1375    */
1376   function _transfer(
1377     address from,
1378     address to,
1379     uint256 tokenId
1380   ) private {
1381     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1382 
1383     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1384       getApproved(tokenId) == _msgSender() ||
1385       isApprovedForAll(prevOwnership.addr, _msgSender()));
1386 
1387     require(
1388       isApprovedOrOwner,
1389       "ERC721A: transfer caller is not owner nor approved"
1390     );
1391 
1392     require(
1393       prevOwnership.addr == from,
1394       "ERC721A: transfer from incorrect owner"
1395     );
1396     require(to != address(0), "ERC721A: transfer to the zero address");
1397 
1398     _beforeTokenTransfers(from, to, tokenId, 1);
1399 
1400     // Clear approvals from the previous owner
1401     _approve(address(0), tokenId, prevOwnership.addr);
1402 
1403     _addressData[from].balance -= 1;
1404     _addressData[to].balance += 1;
1405     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1406 
1407     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1408     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1409     uint256 nextTokenId = tokenId + 1;
1410     if (_ownerships[nextTokenId].addr == address(0)) {
1411       if (_exists(nextTokenId)) {
1412         _ownerships[nextTokenId] = TokenOwnership(
1413           prevOwnership.addr,
1414           prevOwnership.startTimestamp
1415         );
1416       }
1417     }
1418 
1419     emit Transfer(from, to, tokenId);
1420     _afterTokenTransfers(from, to, tokenId, 1);
1421   }
1422 
1423   /**
1424    * @dev Approve `to` to operate on `tokenId`
1425    *
1426    * Emits a {Approval} event.
1427    */
1428   function _approve(
1429     address to,
1430     uint256 tokenId,
1431     address owner
1432   ) private {
1433     _tokenApprovals[tokenId] = to;
1434     emit Approval(owner, to, tokenId);
1435   }
1436 
1437   uint256 public nextOwnerToExplicitlySet = 0;
1438 
1439   /**
1440    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1441    */
1442   function _setOwnersExplicit(uint256 quantity) internal {
1443     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1444     require(quantity > 0, "quantity must be nonzero");
1445     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1446     if (endIndex > currentIndex - 1) {
1447       endIndex = currentIndex - 1;
1448     }
1449     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1450     require(_exists(endIndex), "not enough minted yet for this cleanup");
1451     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1452       if (_ownerships[i].addr == address(0)) {
1453         TokenOwnership memory ownership = ownershipOf(i);
1454         _ownerships[i] = TokenOwnership(
1455           ownership.addr,
1456           ownership.startTimestamp
1457         );
1458       }
1459     }
1460     nextOwnerToExplicitlySet = endIndex + 1;
1461   }
1462 
1463   /**
1464    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1465    * The call is not executed if the target address is not a contract.
1466    *
1467    * @param from address representing the previous owner of the given token ID
1468    * @param to target address that will receive the tokens
1469    * @param tokenId uint256 ID of the token to be transferred
1470    * @param _data bytes optional data to send along with the call
1471    * @return bool whether the call correctly returned the expected magic value
1472    */
1473   function _checkOnERC721Received(
1474     address from,
1475     address to,
1476     uint256 tokenId,
1477     bytes memory _data
1478   ) private returns (bool) {
1479     if (to.isContract()) {
1480       try
1481         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1482       returns (bytes4 retval) {
1483         return retval == IERC721Receiver(to).onERC721Received.selector;
1484       } catch (bytes memory reason) {
1485         if (reason.length == 0) {
1486           revert("ERC721A: transfer to non ERC721Receiver implementer");
1487         } else {
1488           assembly {
1489             revert(add(32, reason), mload(reason))
1490           }
1491         }
1492       }
1493     } else {
1494       return true;
1495     }
1496   }
1497 
1498   /**
1499    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1500    *
1501    * startTokenId - the first token id to be transferred
1502    * quantity - the amount to be transferred
1503    *
1504    * Calling conditions:
1505    *
1506    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1507    * transferred to `to`.
1508    * - When `from` is zero, `tokenId` will be minted for `to`.
1509    */
1510   function _beforeTokenTransfers(
1511     address from,
1512     address to,
1513     uint256 startTokenId,
1514     uint256 quantity
1515   ) internal virtual {}
1516 
1517   /**
1518    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1519    * minting.
1520    *
1521    * startTokenId - the first token id to be transferred
1522    * quantity - the amount to be transferred
1523    *
1524    * Calling conditions:
1525    *
1526    * - when `from` and `to` are both non-zero.
1527    * - `from` and `to` are never both zero.
1528    */
1529   function _afterTokenTransfers(
1530     address from,
1531     address to,
1532     uint256 startTokenId,
1533     uint256 quantity
1534   ) internal virtual {}
1535 }
1536 // File: contracts/Grimmies.sol
1537 
1538 
1539 
1540 //Developer : WesleyETH
1541 /*
1542                             
1543 _ _ _      .               .  ___     ___
1544 |       |/ | |\  /| |\  /| | / _ \  / __| 
1545 |   __  |  | | \/ | | \/ | | |  __/ \__ \
1546 |_ _ _| |  | |    | |    | |  \___| |___/
1547                                      
1548 */
1549 
1550 
1551 pragma solidity >=0.7.0 <0.9.0;
1552 
1553 
1554 
1555 
1556 
1557 
1558 contract Grimmies is ERC721A, Ownable {
1559   using Strings for uint256;
1560 
1561   string public baseURI; 
1562   string public baseExtension = ".json";
1563   string public notRevealedUri;
1564   uint256 public cost = 0.08 ether;
1565   uint256 public wlcost = 0 ether;
1566   uint256 public maxSupply = 10000;
1567   uint256 public WlSupply = 3000;
1568   uint256 public MaxperWallet = 5; // max per wallet
1569   uint256 public MaxperWalletWl = 1; // max per wallet wl
1570   uint256 public MaxperTxWl = 1; // max mint per tx for wl
1571   uint256 public maxsize = 5 ; // max mint per tx
1572   bool public paused = false;
1573   bool public revealed = false;
1574   bool public preSale = true;
1575   bool public publicSale = false;
1576   bytes32 public merkleRoot = 0x7d47dd9d8fd212164c3a9e8d23f89077455d468a3e287590d7f66b9c5ed8dcfd;
1577 
1578   constructor(
1579     string memory _initBaseURI,
1580     string memory _initNotRevealedUri
1581   ) ERC721A("Grimmies", "GRIM") {
1582     setBaseURI(_initBaseURI);
1583     setNotRevealedURI(_initNotRevealedUri);
1584   }
1585 
1586   // internal
1587   function _baseURI() internal view virtual override returns (string memory) {
1588     return baseURI;
1589   }
1590 
1591   // public
1592   function mint(uint256 tokens) public payable {
1593     require(!paused, "GRIM: Oops! Contract is currently paused");
1594     require(publicSale, "GRIM: Public sale has not started yet");
1595     uint256 supply = totalSupply();
1596     uint256 ownerTokenCount = balanceOf(_msgSender());
1597     require(tokens > 0, "GRIM: need to mint at least 1 NFT");
1598     require(tokens <= maxsize, "GRIM: max mint amount per tx exceeded");
1599     require(supply + tokens <= maxSupply, "GRIM: We Soldout");
1600     require(ownerTokenCount + tokens <= MaxperWallet, "GRIM: Max NFT Per Wallet exceeded");
1601     require(msg.value >= cost * tokens, "GRIM: insufficient funds");
1602 
1603       _safeMint(_msgSender(), tokens);
1604     
1605   }
1606 /// @dev presale mint for whitelisted
1607     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable  {
1608     require(!paused, "GRIM: oops contract is paused");
1609     require(preSale, "GRIM: Presale Hasn't started yet");
1610     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "GRIM: You are not Whitelisted");
1611     uint256 supply = totalSupply();
1612     uint256 ownerTokenCount = balanceOf(_msgSender());
1613     require(ownerTokenCount + tokens <= MaxperWalletWl, "GRIM: Max NFT Per Wallet exceeded");
1614     require(tokens > 0, "GRIM: need to mint at least 1 NFT");
1615     require(tokens <= maxsize, "GRIM: max mint per Tx exceeded");
1616     require(supply + tokens <= WlSupply, "GRIM: Whitelist MaxSupply exceeded");
1617     require(msg.value >= wlcost * tokens, "GRIM: insufficient funds");
1618 
1619       _safeMint(_msgSender(), tokens);
1620     
1621   }
1622 
1623 
1624 
1625 
1626   /// @dev use it for giveaway and mint for yourself
1627      function airdrop(uint256 _mintAmount, address destination) public onlyOwner {
1628     require(_mintAmount > 0, "need to mint at least 1 NFT");
1629     uint256 supply = totalSupply();
1630     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1631 
1632       _safeMint(destination, _mintAmount);
1633     
1634   }
1635 
1636   
1637 
1638 
1639   function walletOfOwner(address _owner)
1640     public
1641     view
1642     returns (uint256[] memory)
1643   {
1644     uint256 ownerTokenCount = balanceOf(_owner);
1645     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1646     for (uint256 i; i < ownerTokenCount; i++) {
1647       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1648     }
1649     return tokenIds;
1650   }
1651 
1652   function tokenURI(uint256 tokenId)
1653     public
1654     view
1655     virtual
1656     override
1657     returns (string memory)
1658   {
1659     require(
1660       _exists(tokenId),
1661       "ERC721AMetadata: URI query for nonexistent token"
1662     );
1663     
1664     if(revealed == false) {
1665         return notRevealedUri;
1666     }
1667 
1668     string memory currentBaseURI = _baseURI();
1669     return bytes(currentBaseURI).length > 0
1670         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1671         : "";
1672   }
1673 
1674   //only owner
1675   function reveal(bool _state) public onlyOwner {
1676       revealed = _state;
1677   }
1678 
1679   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1680         merkleRoot = _merkleRoot;
1681     }
1682   
1683   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1684     MaxperWallet = _limit;
1685   }
1686 
1687     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1688     MaxperWalletWl = _limit;
1689   }
1690 
1691   function setmaxsize(uint256 _maxsize) public onlyOwner {
1692     maxsize = _maxsize;
1693   }
1694 
1695     function setWLMaxpertx(uint256 _maxpertx) public onlyOwner {
1696     MaxperTxWl = _maxpertx;
1697   }
1698   
1699   function setCost(uint256 _newCost) public onlyOwner {
1700     cost = _newCost;
1701   }
1702 
1703     function setWlCost(uint256 _newWlCost) public onlyOwner {
1704     wlcost = _newWlCost;
1705   }
1706 
1707     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1708     maxSupply = _newsupply;
1709   }
1710 
1711     function setwlsupply(uint256 _newsupply) public onlyOwner {
1712     WlSupply = _newsupply;
1713   }
1714 
1715   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1716     baseURI = _newBaseURI;
1717   }
1718 
1719   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1720     baseExtension = _newBaseExtension;
1721   }
1722   
1723   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1724     notRevealedUri = _notRevealedURI;
1725   }
1726 
1727   function pause(bool _state) public onlyOwner {
1728     paused = _state;
1729   }
1730 
1731     function togglepreSale(bool _state) external onlyOwner {
1732         preSale = _state;
1733     }
1734 
1735     function togglepublicSale(bool _state) external onlyOwner {
1736         publicSale = _state;
1737     }
1738   
1739  
1740   function withdraw() public payable onlyOwner {
1741     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1742     require(success);
1743   }
1744 }