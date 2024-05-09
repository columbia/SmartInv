1 // File: contracts/IAnimeGang.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
5 
6 interface IAnimeGang {
7 
8     function mintMemberPresale(bytes32[] memory proof, uint256 numberOfTokens) external payable;
9 
10     function mintMemberPublicSale(uint256 numberOfTokens) external payable;
11 
12     function togglePublicSaleStatus() external;
13 
14     function setMerkleProof(bytes32 proof) external;
15 
16     function setAGIProvenance(string memory AGIProvenance) external;
17 
18     function setAGCOPProvenance(string memory AGCOProvenance) external;
19 
20     function togglePresaleStatus() external;
21 
22     function withdraw() external;
23 
24     function reserve(uint256 gangToReserve) external;
25 
26     function countClaimedTokensFromPresaleListBy(address owner) external returns (uint256);
27 
28     function setBaseURI(string calldata URI) external;
29 
30 }
31 
32 // File: openzeppelin-solidity/contracts/utils/cryptography/MerkleProof.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev These functions deal with verification of Merkle Trees proofs.
41  *
42  * The proofs can be generated using the JavaScript library
43  * https://github.com/miguelmota/merkletreejs[merkletreejs].
44  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
45  *
46  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
47  */
48 library MerkleProof {
49     /**
50      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
51      * defined by `root`. For this, a `proof` must be provided, containing
52      * sibling hashes on the branch from the leaf to the root of the tree. Each
53      * pair of leaves and each pair of pre-images are assumed to be sorted.
54      */
55     function verify(
56         bytes32[] memory proof,
57         bytes32 root,
58         bytes32 leaf
59     ) internal pure returns (bool) {
60         return processProof(proof, leaf) == root;
61     }
62 
63     /**
64      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
65      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
66      * hash matches the root of the tree. When processing the proof, the pairs
67      * of leafs & pre-images are assumed to be sorted.
68      *
69      * _Available since v4.4._
70      */
71     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             bytes32 proofElement = proof[i];
75             if (computedHash <= proofElement) {
76                 // Hash(current computed hash + current element of the proof)
77                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
78             } else {
79                 // Hash(current element of the proof + current computed hash)
80                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
81             }
82         }
83         return computedHash;
84     }
85 }
86 
87 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 // CAUTION
95 // This version of SafeMath should only be used with Solidity 0.8 or later,
96 // because it relies on the compiler's built in overflow checks.
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations.
100  *
101  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
102  * now has built in overflow checking.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             uint256 c = a + b;
113             if (c < a) return (false, 0);
114             return (true, c);
115         }
116     }
117 
118     /**
119      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         unchecked {
125             if (b > a) return (false, 0);
126             return (true, a - b);
127         }
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         unchecked {
137             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138             // benefit is lost if 'b' is also tested.
139             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140             if (a == 0) return (true, 0);
141             uint256 c = a * b;
142             if (c / a != b) return (false, 0);
143             return (true, c);
144         }
145     }
146 
147     /**
148      * @dev Returns the division of two unsigned integers, with a division by zero flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             if (b == 0) return (false, 0);
155             return (true, a / b);
156         }
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             if (b == 0) return (false, 0);
167             return (true, a % b);
168         }
169     }
170 
171     /**
172      * @dev Returns the addition of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `+` operator.
176      *
177      * Requirements:
178      *
179      * - Addition cannot overflow.
180      */
181     function add(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a + b;
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
196         return a - b;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      *
207      * - Multiplication cannot overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a * b;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers, reverting on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator.
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a / b;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * reverting when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a % b;
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * CAUTION: This function is deprecated because it requires allocating memory for the error
248      * message unnecessarily. For custom revert reasons use {trySub}.
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      *
254      * - Subtraction cannot overflow.
255      */
256     function sub(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         unchecked {
262             require(b <= a, errorMessage);
263             return a - b;
264         }
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(
280         uint256 a,
281         uint256 b,
282         string memory errorMessage
283     ) internal pure returns (uint256) {
284         unchecked {
285             require(b > 0, errorMessage);
286             return a / b;
287         }
288     }
289 
290     /**
291      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
292      * reverting with custom message when dividing by zero.
293      *
294      * CAUTION: This function is deprecated because it requires allocating memory for the error
295      * message unnecessarily. For custom revert reasons use {tryMod}.
296      *
297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
298      * opcode (which leaves remaining gas untouched) while Solidity uses an
299      * invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function mod(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a % b;
313         }
314     }
315 }
316 
317 // File: openzeppelin-solidity/contracts/utils/Strings.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev String operations.
326  */
327 library Strings {
328     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
329 
330     /**
331      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
332      */
333     function toString(uint256 value) internal pure returns (string memory) {
334         // Inspired by OraclizeAPI's implementation - MIT licence
335         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
336 
337         if (value == 0) {
338             return "0";
339         }
340         uint256 temp = value;
341         uint256 digits;
342         while (temp != 0) {
343             digits++;
344             temp /= 10;
345         }
346         bytes memory buffer = new bytes(digits);
347         while (value != 0) {
348             digits -= 1;
349             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
350             value /= 10;
351         }
352         return string(buffer);
353     }
354 
355     /**
356      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
357      */
358     function toHexString(uint256 value) internal pure returns (string memory) {
359         if (value == 0) {
360             return "0x00";
361         }
362         uint256 temp = value;
363         uint256 length = 0;
364         while (temp != 0) {
365             length++;
366             temp >>= 8;
367         }
368         return toHexString(value, length);
369     }
370 
371     /**
372      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
373      */
374     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
375         bytes memory buffer = new bytes(2 * length + 2);
376         buffer[0] = "0";
377         buffer[1] = "x";
378         for (uint256 i = 2 * length + 1; i > 1; --i) {
379             buffer[i] = _HEX_SYMBOLS[value & 0xf];
380             value >>= 4;
381         }
382         require(value == 0, "Strings: hex length insufficient");
383         return string(buffer);
384     }
385 }
386 
387 // File: openzeppelin-solidity/contracts/utils/Context.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 abstract contract Context {
405     function _msgSender() internal view virtual returns (address) {
406         return msg.sender;
407     }
408 
409     function _msgData() internal view virtual returns (bytes calldata) {
410         return msg.data;
411     }
412 }
413 
414 // File: openzeppelin-solidity/contracts/access/Ownable.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
443         _transferOwnership(_msgSender());
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
469         _transferOwnership(address(0));
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         _transferOwnership(newOwner);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Internal function without access restriction.
484      */
485     function _transferOwnership(address newOwner) internal virtual {
486         address oldOwner = _owner;
487         _owner = newOwner;
488         emit OwnershipTransferred(oldOwner, newOwner);
489     }
490 }
491 
492 // File: openzeppelin-solidity/contracts/utils/Address.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Collection of functions related to the address type
501  */
502 library Address {
503     /**
504      * @dev Returns true if `account` is a contract.
505      *
506      * [IMPORTANT]
507      * ====
508      * It is unsafe to assume that an address for which this function returns
509      * false is an externally-owned account (EOA) and not a contract.
510      *
511      * Among others, `isContract` will return false for the following
512      * types of addresses:
513      *
514      *  - an externally-owned account
515      *  - a contract in construction
516      *  - an address where a contract will be created
517      *  - an address where a contract lived, but was destroyed
518      * ====
519      */
520     function isContract(address account) internal view returns (bool) {
521         // This method relies on extcodesize, which returns 0 for contracts in
522         // construction, since the code is only stored at the end of the
523         // constructor execution.
524 
525         uint256 size;
526         assembly {
527             size := extcodesize(account)
528         }
529         return size > 0;
530     }
531 
532     /**
533      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
534      * `recipient`, forwarding all available gas and reverting on errors.
535      *
536      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
537      * of certain opcodes, possibly making contracts go over the 2300 gas limit
538      * imposed by `transfer`, making them unable to receive funds via
539      * `transfer`. {sendValue} removes this limitation.
540      *
541      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
542      *
543      * IMPORTANT: because control is transferred to `recipient`, care must be
544      * taken to not create reentrancy vulnerabilities. Consider using
545      * {ReentrancyGuard} or the
546      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
547      */
548     function sendValue(address payable recipient, uint256 amount) internal {
549         require(address(this).balance >= amount, "Address: insufficient balance");
550 
551         (bool success, ) = recipient.call{value: amount}("");
552         require(success, "Address: unable to send value, recipient may have reverted");
553     }
554 
555     /**
556      * @dev Performs a Solidity function call using a low level `call`. A
557      * plain `call` is an unsafe replacement for a function call: use this
558      * function instead.
559      *
560      * If `target` reverts with a revert reason, it is bubbled up by this
561      * function (like regular Solidity function calls).
562      *
563      * Returns the raw returned data. To convert to the expected return value,
564      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
565      *
566      * Requirements:
567      *
568      * - `target` must be a contract.
569      * - calling `target` with `data` must not revert.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
574         return functionCall(target, data, "Address: low-level call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
579      * `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, 0, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but also transferring `value` wei to `target`.
594      *
595      * Requirements:
596      *
597      * - the calling contract must have an ETH balance of at least `value`.
598      * - the called Solidity function must be `payable`.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value
606     ) internal returns (bytes memory) {
607         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
612      * with `errorMessage` as a fallback revert reason when `target` reverts.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(
617         address target,
618         bytes memory data,
619         uint256 value,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(address(this).balance >= value, "Address: insufficient balance for call");
623         require(isContract(target), "Address: call to non-contract");
624 
625         (bool success, bytes memory returndata) = target.call{value: value}(data);
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a static call.
632      *
633      * _Available since v3.3._
634      */
635     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
636         return functionStaticCall(target, data, "Address: low-level static call failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
641      * but performing a static call.
642      *
643      * _Available since v3.3._
644      */
645     function functionStaticCall(
646         address target,
647         bytes memory data,
648         string memory errorMessage
649     ) internal view returns (bytes memory) {
650         require(isContract(target), "Address: static call to non-contract");
651 
652         (bool success, bytes memory returndata) = target.staticcall(data);
653         return verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
663         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a delegate call.
669      *
670      * _Available since v3.4._
671      */
672     function functionDelegateCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal returns (bytes memory) {
677         require(isContract(target), "Address: delegate call to non-contract");
678 
679         (bool success, bytes memory returndata) = target.delegatecall(data);
680         return verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
685      * revert reason using the provided one.
686      *
687      * _Available since v4.3._
688      */
689     function verifyCallResult(
690         bool success,
691         bytes memory returndata,
692         string memory errorMessage
693     ) internal pure returns (bytes memory) {
694         if (success) {
695             return returndata;
696         } else {
697             // Look for revert reason and bubble it up if present
698             if (returndata.length > 0) {
699                 // The easiest way to bubble the revert reason is using memory via assembly
700 
701                 assembly {
702                     let returndata_size := mload(returndata)
703                     revert(add(32, returndata), returndata_size)
704                 }
705             } else {
706                 revert(errorMessage);
707             }
708         }
709     }
710 }
711 
712 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @title ERC721 token receiver interface
721  * @dev Interface for any contract that wants to support safeTransfers
722  * from ERC721 asset contracts.
723  */
724 interface IERC721Receiver {
725     /**
726      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
727      * by `operator` from `from`, this function is called.
728      *
729      * It must return its Solidity selector to confirm the token transfer.
730      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
731      *
732      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
733      */
734     function onERC721Received(
735         address operator,
736         address from,
737         uint256 tokenId,
738         bytes calldata data
739     ) external returns (bytes4);
740 }
741 
742 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev Interface of the ERC165 standard, as defined in the
751  * https://eips.ethereum.org/EIPS/eip-165[EIP].
752  *
753  * Implementers can declare support of contract interfaces, which can then be
754  * queried by others ({ERC165Checker}).
755  *
756  * For an implementation, see {ERC165}.
757  */
758 interface IERC165 {
759     /**
760      * @dev Returns true if this contract implements the interface defined by
761      * `interfaceId`. See the corresponding
762      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
763      * to learn more about how these ids are created.
764      *
765      * This function call must use less than 30 000 gas.
766      */
767     function supportsInterface(bytes4 interfaceId) external view returns (bool);
768 }
769 
770 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
771 
772 
773 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 
778 /**
779  * @dev Implementation of the {IERC165} interface.
780  *
781  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
782  * for the additional interface id that will be supported. For example:
783  *
784  * ```solidity
785  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
786  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
787  * }
788  * ```
789  *
790  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
791  */
792 abstract contract ERC165 is IERC165 {
793     /**
794      * @dev See {IERC165-supportsInterface}.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
797         return interfaceId == type(IERC165).interfaceId;
798     }
799 }
800 
801 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
802 
803 
804 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
805 
806 pragma solidity ^0.8.0;
807 
808 
809 /**
810  * @dev Required interface of an ERC721 compliant contract.
811  */
812 interface IERC721 is IERC165 {
813     /**
814      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
815      */
816     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
817 
818     /**
819      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
820      */
821     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
822 
823     /**
824      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
825      */
826     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
827 
828     /**
829      * @dev Returns the number of tokens in ``owner``'s account.
830      */
831     function balanceOf(address owner) external view returns (uint256 balance);
832 
833     /**
834      * @dev Returns the owner of the `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function ownerOf(uint256 tokenId) external view returns (address owner);
841 
842     /**
843      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
844      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) external;
861 
862     /**
863      * @dev Transfers `tokenId` token from `from` to `to`.
864      *
865      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      *
874      * Emits a {Transfer} event.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) external;
881 
882     /**
883      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
884      * The approval is cleared when the token is transferred.
885      *
886      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
887      *
888      * Requirements:
889      *
890      * - The caller must own the token or be an approved operator.
891      * - `tokenId` must exist.
892      *
893      * Emits an {Approval} event.
894      */
895     function approve(address to, uint256 tokenId) external;
896 
897     /**
898      * @dev Returns the account approved for `tokenId` token.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      */
904     function getApproved(uint256 tokenId) external view returns (address operator);
905 
906     /**
907      * @dev Approve or remove `operator` as an operator for the caller.
908      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
909      *
910      * Requirements:
911      *
912      * - The `operator` cannot be the caller.
913      *
914      * Emits an {ApprovalForAll} event.
915      */
916     function setApprovalForAll(address operator, bool _approved) external;
917 
918     /**
919      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
920      *
921      * See {setApprovalForAll}
922      */
923     function isApprovedForAll(address owner, address operator) external view returns (bool);
924 
925     /**
926      * @dev Safely transfers `tokenId` token from `from` to `to`.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must exist and be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes calldata data
943     ) external;
944 }
945 
946 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 
954 /**
955  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
956  * @dev See https://eips.ethereum.org/EIPS/eip-721
957  */
958 interface IERC721Enumerable is IERC721 {
959     /**
960      * @dev Returns the total amount of tokens stored by the contract.
961      */
962     function totalSupply() external view returns (uint256);
963 
964     /**
965      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
966      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
967      */
968     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
969 
970     /**
971      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
972      * Use along with {totalSupply} to enumerate all tokens.
973      */
974     function tokenByIndex(uint256 index) external view returns (uint256);
975 }
976 
977 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
987  * @dev See https://eips.ethereum.org/EIPS/eip-721
988  */
989 interface IERC721Metadata is IERC721 {
990     /**
991      * @dev Returns the token collection name.
992      */
993     function name() external view returns (string memory);
994 
995     /**
996      * @dev Returns the token collection symbol.
997      */
998     function symbol() external view returns (string memory);
999 
1000     /**
1001      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1002      */
1003     function tokenURI(uint256 tokenId) external view returns (string memory);
1004 }
1005 
1006 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1007 
1008 
1009 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 /**
1021  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1022  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1023  * {ERC721Enumerable}.
1024  */
1025 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1026     using Address for address;
1027     using Strings for uint256;
1028 
1029     // Token name
1030     string private _name;
1031 
1032     // Token symbol
1033     string private _symbol;
1034 
1035     // Mapping from token ID to owner address
1036     mapping(uint256 => address) private _owners;
1037 
1038     // Mapping owner address to token count
1039     mapping(address => uint256) private _balances;
1040 
1041     // Mapping from token ID to approved address
1042     mapping(uint256 => address) private _tokenApprovals;
1043 
1044     // Mapping from owner to operator approvals
1045     mapping(address => mapping(address => bool)) private _operatorApprovals;
1046 
1047     /**
1048      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1049      */
1050     constructor(string memory name_, string memory symbol_) {
1051         _name = name_;
1052         _symbol = symbol_;
1053     }
1054 
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1059         return
1060             interfaceId == type(IERC721).interfaceId ||
1061             interfaceId == type(IERC721Metadata).interfaceId ||
1062             super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-balanceOf}.
1067      */
1068     function balanceOf(address owner) public view virtual override returns (uint256) {
1069         require(owner != address(0), "ERC721: balance query for the zero address");
1070         return _balances[owner];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-ownerOf}.
1075      */
1076     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1077         address owner = _owners[tokenId];
1078         require(owner != address(0), "ERC721: owner query for nonexistent token");
1079         return owner;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-name}.
1084      */
1085     function name() public view virtual override returns (string memory) {
1086         return _name;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-symbol}.
1091      */
1092     function symbol() public view virtual override returns (string memory) {
1093         return _symbol;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-tokenURI}.
1098      */
1099     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1100         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1101 
1102         string memory baseURI = _baseURI();
1103         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1104     }
1105 
1106     /**
1107      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1108      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1109      * by default, can be overriden in child contracts.
1110      */
1111     function _baseURI() internal view virtual returns (string memory) {
1112         return "";
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public virtual override {
1119         address owner = ERC721.ownerOf(tokenId);
1120         require(to != owner, "ERC721: approval to current owner");
1121 
1122         require(
1123             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1124             "ERC721: approve caller is not owner nor approved for all"
1125         );
1126 
1127         _approve(to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-getApproved}.
1132      */
1133     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1134         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1135 
1136         return _tokenApprovals[tokenId];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-setApprovalForAll}.
1141      */
1142     function setApprovalForAll(address operator, bool approved) public virtual override {
1143         _setApprovalForAll(_msgSender(), operator, approved);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-isApprovedForAll}.
1148      */
1149     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1150         return _operatorApprovals[owner][operator];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-transferFrom}.
1155      */
1156     function transferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) public virtual override {
1161         //solhint-disable-next-line max-line-length
1162         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1163 
1164         _transfer(from, to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-safeTransferFrom}.
1169      */
1170     function safeTransferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) public virtual override {
1175         safeTransferFrom(from, to, tokenId, "");
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-safeTransferFrom}.
1180      */
1181     function safeTransferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) public virtual override {
1187         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1188         _safeTransfer(from, to, tokenId, _data);
1189     }
1190 
1191     /**
1192      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1193      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1194      *
1195      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1196      *
1197      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1198      * implement alternative mechanisms to perform token transfer, such as signature-based.
1199      *
1200      * Requirements:
1201      *
1202      * - `from` cannot be the zero address.
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must exist and be owned by `from`.
1205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _safeTransfer(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) internal virtual {
1215         _transfer(from, to, tokenId);
1216         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1217     }
1218 
1219     /**
1220      * @dev Returns whether `tokenId` exists.
1221      *
1222      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1223      *
1224      * Tokens start existing when they are minted (`_mint`),
1225      * and stop existing when they are burned (`_burn`).
1226      */
1227     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1228         return _owners[tokenId] != address(0);
1229     }
1230 
1231     /**
1232      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      */
1238     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1239         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1240         address owner = ERC721.ownerOf(tokenId);
1241         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1242     }
1243 
1244     /**
1245      * @dev Safely mints `tokenId` and transfers it to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must not exist.
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _safeMint(address to, uint256 tokenId) internal virtual {
1255         _safeMint(to, tokenId, "");
1256     }
1257 
1258     /**
1259      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1260      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) internal virtual {
1267         _mint(to, tokenId);
1268         require(
1269             _checkOnERC721Received(address(0), to, tokenId, _data),
1270             "ERC721: transfer to non ERC721Receiver implementer"
1271         );
1272     }
1273 
1274     /**
1275      * @dev Mints `tokenId` and transfers it to `to`.
1276      *
1277      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must not exist.
1282      * - `to` cannot be the zero address.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _mint(address to, uint256 tokenId) internal virtual {
1287         require(to != address(0), "ERC721: mint to the zero address");
1288         require(!_exists(tokenId), "ERC721: token already minted");
1289 
1290         _beforeTokenTransfer(address(0), to, tokenId);
1291 
1292         _balances[to] += 1;
1293         _owners[tokenId] = to;
1294 
1295         emit Transfer(address(0), to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Destroys `tokenId`.
1300      * The approval is cleared when the token is burned.
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must exist.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function _burn(uint256 tokenId) internal virtual {
1309         address owner = ERC721.ownerOf(tokenId);
1310 
1311         _beforeTokenTransfer(owner, address(0), tokenId);
1312 
1313         // Clear approvals
1314         _approve(address(0), tokenId);
1315 
1316         _balances[owner] -= 1;
1317         delete _owners[tokenId];
1318 
1319         emit Transfer(owner, address(0), tokenId);
1320     }
1321 
1322     /**
1323      * @dev Transfers `tokenId` from `from` to `to`.
1324      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1325      *
1326      * Requirements:
1327      *
1328      * - `to` cannot be the zero address.
1329      * - `tokenId` token must be owned by `from`.
1330      *
1331      * Emits a {Transfer} event.
1332      */
1333     function _transfer(
1334         address from,
1335         address to,
1336         uint256 tokenId
1337     ) internal virtual {
1338         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1339         require(to != address(0), "ERC721: transfer to the zero address");
1340 
1341         _beforeTokenTransfer(from, to, tokenId);
1342 
1343         // Clear approvals from the previous owner
1344         _approve(address(0), tokenId);
1345 
1346         _balances[from] -= 1;
1347         _balances[to] += 1;
1348         _owners[tokenId] = to;
1349 
1350         emit Transfer(from, to, tokenId);
1351     }
1352 
1353     /**
1354      * @dev Approve `to` to operate on `tokenId`
1355      *
1356      * Emits a {Approval} event.
1357      */
1358     function _approve(address to, uint256 tokenId) internal virtual {
1359         _tokenApprovals[tokenId] = to;
1360         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev Approve `operator` to operate on all of `owner` tokens
1365      *
1366      * Emits a {ApprovalForAll} event.
1367      */
1368     function _setApprovalForAll(
1369         address owner,
1370         address operator,
1371         bool approved
1372     ) internal virtual {
1373         require(owner != operator, "ERC721: approve to caller");
1374         _operatorApprovals[owner][operator] = approved;
1375         emit ApprovalForAll(owner, operator, approved);
1376     }
1377 
1378     /**
1379      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1380      * The call is not executed if the target address is not a contract.
1381      *
1382      * @param from address representing the previous owner of the given token ID
1383      * @param to target address that will receive the tokens
1384      * @param tokenId uint256 ID of the token to be transferred
1385      * @param _data bytes optional data to send along with the call
1386      * @return bool whether the call correctly returned the expected magic value
1387      */
1388     function _checkOnERC721Received(
1389         address from,
1390         address to,
1391         uint256 tokenId,
1392         bytes memory _data
1393     ) private returns (bool) {
1394         if (to.isContract()) {
1395             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1396                 return retval == IERC721Receiver.onERC721Received.selector;
1397             } catch (bytes memory reason) {
1398                 if (reason.length == 0) {
1399                     revert("ERC721: transfer to non ERC721Receiver implementer");
1400                 } else {
1401                     assembly {
1402                         revert(add(32, reason), mload(reason))
1403                     }
1404                 }
1405             }
1406         } else {
1407             return true;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before any token transfer. This includes minting
1413      * and burning.
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` will be minted for `to`.
1420      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1421      * - `from` and `to` are never both zero.
1422      *
1423      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1424      */
1425     function _beforeTokenTransfer(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) internal virtual {}
1430 }
1431 
1432 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1433 
1434 
1435 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1436 
1437 pragma solidity ^0.8.0;
1438 
1439 
1440 
1441 /**
1442  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1443  * enumerability of all the token ids in the contract as well as all token ids owned by each
1444  * account.
1445  */
1446 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1447     // Mapping from owner to list of owned token IDs
1448     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1449 
1450     // Mapping from token ID to index of the owner tokens list
1451     mapping(uint256 => uint256) private _ownedTokensIndex;
1452 
1453     // Array with all token ids, used for enumeration
1454     uint256[] private _allTokens;
1455 
1456     // Mapping from token id to position in the allTokens array
1457     mapping(uint256 => uint256) private _allTokensIndex;
1458 
1459     /**
1460      * @dev See {IERC165-supportsInterface}.
1461      */
1462     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1463         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1468      */
1469     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1470         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1471         return _ownedTokens[owner][index];
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-totalSupply}.
1476      */
1477     function totalSupply() public view virtual override returns (uint256) {
1478         return _allTokens.length;
1479     }
1480 
1481     /**
1482      * @dev See {IERC721Enumerable-tokenByIndex}.
1483      */
1484     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1485         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1486         return _allTokens[index];
1487     }
1488 
1489     /**
1490      * @dev Hook that is called before any token transfer. This includes minting
1491      * and burning.
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` will be minted for `to`.
1498      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1499      * - `from` cannot be the zero address.
1500      * - `to` cannot be the zero address.
1501      *
1502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1503      */
1504     function _beforeTokenTransfer(
1505         address from,
1506         address to,
1507         uint256 tokenId
1508     ) internal virtual override {
1509         super._beforeTokenTransfer(from, to, tokenId);
1510 
1511         if (from == address(0)) {
1512             _addTokenToAllTokensEnumeration(tokenId);
1513         } else if (from != to) {
1514             _removeTokenFromOwnerEnumeration(from, tokenId);
1515         }
1516         if (to == address(0)) {
1517             _removeTokenFromAllTokensEnumeration(tokenId);
1518         } else if (to != from) {
1519             _addTokenToOwnerEnumeration(to, tokenId);
1520         }
1521     }
1522 
1523     /**
1524      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1525      * @param to address representing the new owner of the given token ID
1526      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1527      */
1528     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1529         uint256 length = ERC721.balanceOf(to);
1530         _ownedTokens[to][length] = tokenId;
1531         _ownedTokensIndex[tokenId] = length;
1532     }
1533 
1534     /**
1535      * @dev Private function to add a token to this extension's token tracking data structures.
1536      * @param tokenId uint256 ID of the token to be added to the tokens list
1537      */
1538     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1539         _allTokensIndex[tokenId] = _allTokens.length;
1540         _allTokens.push(tokenId);
1541     }
1542 
1543     /**
1544      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1545      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1546      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1547      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1548      * @param from address representing the previous owner of the given token ID
1549      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1550      */
1551     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1552         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1553         // then delete the last slot (swap and pop).
1554 
1555         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1556         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1557 
1558         // When the token to delete is the last token, the swap operation is unnecessary
1559         if (tokenIndex != lastTokenIndex) {
1560             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1561 
1562             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1563             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1564         }
1565 
1566         // This also deletes the contents at the last position of the array
1567         delete _ownedTokensIndex[tokenId];
1568         delete _ownedTokens[from][lastTokenIndex];
1569     }
1570 
1571     /**
1572      * @dev Private function to remove a token from this extension's token tracking data structures.
1573      * This has O(1) time complexity, but alters the order of the _allTokens array.
1574      * @param tokenId uint256 ID of the token to be removed from the tokens list
1575      */
1576     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1577         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1578         // then delete the last slot (swap and pop).
1579 
1580         uint256 lastTokenIndex = _allTokens.length - 1;
1581         uint256 tokenIndex = _allTokensIndex[tokenId];
1582 
1583         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1584         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1585         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1586         uint256 lastTokenId = _allTokens[lastTokenIndex];
1587 
1588         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1589         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1590 
1591         // This also deletes the contents at the last position of the array
1592         delete _allTokensIndex[tokenId];
1593         _allTokens.pop();
1594     }
1595 }
1596 
1597 // File: contracts/AnimeGang.sol
1598 
1599 
1600 
1601 
1602 pragma solidity ^0.8.2;
1603 
1604 
1605 
1606 
1607 
1608 
1609 
1610 
1611 
1612 
1613 //      ___      .__   __.  __  .___  ___.  _______      _______      ___      .__   __.   _______ 
1614 //     /   \     |  \ |  | |  | |   \/   | |   ____|    /  _____|    /   \     |  \ |  |  /  _____|
1615 //    /  ^  \    |   \|  | |  | |  \  /  | |  |__      |  |  __     /  ^  \    |   \|  | |  |  __  
1616 //   /  /_\  \   |  . `  | |  | |  |\/|  | |   __|     |  | |_ |   /  /_\  \   |  . `  | |  | |_ | 
1617 //  /  _____  \  |  |\   | |  | |  |  |  | |  |____    |  |__| |  /  _____  \  |  |\   | |  |__| | 
1618 // /__/     \__\ |__| \__| |__| |__|  |__| |_______|    \______| /__/     \__\ |__| \__|  \______| 
1619                                                                                                                                                                                                      
1620 contract AnimeGang is ERC721, ERC721Enumerable, Ownable, IAnimeGang  {
1621 
1622     using SafeMath for uint256;
1623 
1624     uint256 public reserveSupply;
1625     uint256 public animeGangSupply;
1626     mapping(address => uint256) private _presaleCountClaimedTokens;
1627 
1628     bool public isPublicSaleActive = false;
1629     bool public isPresaleActive = false;
1630 
1631     string public _baseTokenURI;
1632     bytes32 private merkleRoot;
1633 
1634     string public AGIP_PROVENANCE;
1635     string public AGCOP_PROVENANCE;
1636 
1637     uint256 public constant maxPresaleMint = 5;
1638     uint256 public constant maxGangMembersMint = 10;
1639     //@dev these tokens will be for us and giveaways
1640     uint256 private constant OWNERS_GANG = 60;
1641     uint256 private constant MAX_ANIME_GANG_MEMBERS = 9940;
1642     uint256 private constant MAX_ANIME_GANG_MEMBERS_PRE_SALE = 1000;
1643 
1644     uint256 private constant MINT_PRESALE_PRICE = 0.075 ether;
1645     uint256 private constant MINT_PUBLIC_SALE_PRICE = 0.09 ether;
1646 
1647     constructor(string memory name,
1648         string memory symbol,
1649         string memory baseTokenURI) ERC721(name, symbol) {
1650         _baseTokenURI = baseTokenURI;
1651     }
1652 
1653     /**
1654     * Pause presale if active, make active if paused
1655     */
1656     function togglePresaleStatus() external override onlyOwner {
1657         isPresaleActive = !isPresaleActive;
1658     }
1659 
1660     /**
1661     * Pause public sale if active, make active if paused
1662     */
1663     function togglePublicSaleStatus() external override onlyOwner {
1664         isPublicSaleActive = !isPublicSaleActive;
1665     }
1666 
1667     function setMerkleProof(bytes32 proof) external override onlyOwner {
1668         merkleRoot = proof;
1669     }
1670 
1671     function setAGIProvenance(string memory AGIProvenance) external override onlyOwner {
1672         AGIP_PROVENANCE = AGIProvenance;
1673     }
1674 
1675     function setAGCOPProvenance(string memory AGCOProvenance) external override onlyOwner {
1676         AGCOP_PROVENANCE = AGCOProvenance;
1677     }
1678 
1679     function mintMemberPublicSale(uint256 numberOfGangMembers) external override payable {
1680         require(isPublicSaleActive, "You cannot became a gang member, public sale is inactive. q-_-p");
1681         require(!isPresaleActive, "You cannot became a gang member, using public sale mint. q-_-p");
1682         require(totalSupply() <= MAX_ANIME_GANG_MEMBERS.add(OWNERS_GANG), "All tokens have been minted");
1683         require(numberOfGangMembers <= maxGangMembersMint, "Can mint only 10 tokens per request. ");
1684         require(animeGangSupply.add(numberOfGangMembers) <= MAX_ANIME_GANG_MEMBERS, "The purchase will exceed the member slots");
1685         require(MINT_PUBLIC_SALE_PRICE.mul(numberOfGangMembers) <= msg.value, "Ether value sent is not enough");
1686 
1687         for(uint i = 0; i < numberOfGangMembers; i++) {
1688             uint mintIndex = totalSupply().add(1);
1689             animeGangSupply += 1;
1690             _safeMint(msg.sender, mintIndex);
1691         }
1692     }
1693 
1694     function mintMemberPresale(bytes32[] memory proof, uint256 numberOfGangMembers) external override payable {
1695         require(isPresaleActive, "You cannot became a gang member, presale is inactive. q-_-p");
1696         require(!isPublicSaleActive, "You cannot became a gang member, using presale sale mint. q-_-p");
1697         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You're a not in the presale list. q-_-p");
1698         require(_presaleCountClaimedTokens[msg.sender].add(numberOfGangMembers) <= maxPresaleMint, "Purchase exceeds max allowed presale mints. ");
1699         require(totalSupply().add(numberOfGangMembers) <= MAX_ANIME_GANG_MEMBERS_PRE_SALE, "The purchase will exceed the member slots for PRE-SALE. ");
1700         require(MINT_PRESALE_PRICE.mul(numberOfGangMembers) <= msg.value, "Ether value sent is not enough");
1701 
1702         for(uint i = 0; i < numberOfGangMembers; i++) {
1703             uint mintIndex = totalSupply().add(1);
1704             _presaleCountClaimedTokens[msg.sender] += 1;
1705             animeGangSupply += 1;
1706             _safeMint(msg.sender, mintIndex);
1707         }
1708 
1709     }
1710 
1711     function countClaimedTokensFromPresaleListBy(address member) external view override returns (uint256) {
1712         require(member != address(0), "Zero address not in the list");
1713 
1714         return _presaleCountClaimedTokens[member];
1715     }
1716 
1717     function withdraw() public override onlyOwner {
1718         uint balance = address(this).balance;
1719         payable(msg.sender).transfer(balance);
1720     }
1721 
1722     function reserve(uint256 gangToReserve) external override onlyOwner {
1723         require(totalSupply() <= MAX_ANIME_GANG_MEMBERS.add(OWNERS_GANG), "All tokens have been minted");
1724         require(reserveSupply.add(gangToReserve) <= OWNERS_GANG, "Tokens claimed already.");
1725 
1726         for (uint256 i = 0; i < gangToReserve; i++) {
1727             uint256 tokenId = totalSupply().add(1);
1728             reserveSupply += 1;
1729             _safeMint(msg.sender, tokenId);
1730         }
1731     }
1732 
1733     function setBaseURI(string calldata baseURI) external override onlyOwner {
1734         _baseTokenURI = baseURI;
1735     }
1736 
1737     function _baseURI() internal view virtual override returns (string memory) {
1738         return _baseTokenURI;
1739     }
1740 
1741     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1742         super._beforeTokenTransfer(from, to, tokenId);
1743     }
1744 
1745     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1746         return super.supportsInterface(interfaceId);
1747     }
1748 
1749 }