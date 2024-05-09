1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Counters.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @title Counters
65  * @author Matt Condon (@shrugs)
66  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
67  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
68  *
69  * Include with `using Counters for Counters.Counter;`
70  */
71 library Counters {
72     struct Counter {
73         // This variable should never be directly accessed by users of the library: interactions must be restricted to
74         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
75         // this feature: see https://github.com/ethereum/solidity/issues/4637
76         uint256 _value; // default: 0
77     }
78 
79     function current(Counter storage counter) internal view returns (uint256) {
80         return counter._value;
81     }
82 
83     function increment(Counter storage counter) internal {
84         unchecked {
85             counter._value += 1;
86         }
87     }
88 
89     function decrement(Counter storage counter) internal {
90         uint256 value = counter._value;
91         require(value > 0, "Counter: decrement overflow");
92         unchecked {
93             counter._value = value - 1;
94         }
95     }
96 
97     function reset(Counter storage counter) internal {
98         counter._value = 0;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Strings.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Context.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Provides information about the current execution context, including the
181  * sender of the transaction and its data. While these are generally available
182  * via msg.sender and msg.data, they should not be accessed in such a direct
183  * manner, since when dealing with meta-transactions the account sending and
184  * paying for execution may not be the actual sender (as far as an application
185  * is concerned).
186  *
187  * This contract is only required for intermediate, library-like contracts.
188  */
189 abstract contract Context {
190     function _msgSender() internal view virtual returns (address) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view virtual returns (bytes calldata) {
195         return msg.data;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/access/Ownable.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Contract module which provides a basic access control mechanism, where
209  * there is an account (an owner) that can be granted exclusive access to
210  * specific functions.
211  *
212  * By default, the owner account will be the one that deploys the contract. This
213  * can later be changed with {transferOwnership}.
214  *
215  * This module is used through inheritance. It will make available the modifier
216  * `onlyOwner`, which can be applied to your functions to restrict their use to
217  * the owner.
218  */
219 abstract contract Ownable is Context {
220     address private _owner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() {
228         _transferOwnership(_msgSender());
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _transferOwnership(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _transferOwnership(newOwner);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Internal function without access restriction.
269      */
270     function _transferOwnership(address newOwner) internal virtual {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize, which returns 0 for contracts in
307         // construction, since the code is only stored at the end of the
308         // constructor execution.
309 
310         uint256 size;
311         assembly {
312             size := extcodesize(account)
313         }
314         return size > 0;
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         (bool success, ) = recipient.call{value: amount}("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain `call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but also transferring `value` wei to `target`.
379      *
380      * Requirements:
381      *
382      * - the calling contract must have an ETH balance of at least `value`.
383      * - the called Solidity function must be `payable`.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value
391     ) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
397      * with `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 value,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         require(isContract(target), "Address: call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.call{value: value}(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
421         return functionStaticCall(target, data, "Address: low-level static call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal view returns (bytes memory) {
435         require(isContract(target), "Address: static call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.staticcall(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(isContract(target), "Address: delegate call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
470      * revert reason using the provided one.
471      *
472      * _Available since v4.3._
473      */
474     function verifyCallResult(
475         bool success,
476         bytes memory returndata,
477         string memory errorMessage
478     ) internal pure returns (bytes memory) {
479         if (success) {
480             return returndata;
481         } else {
482             // Look for revert reason and bubble it up if present
483             if (returndata.length > 0) {
484                 // The easiest way to bubble the revert reason is using memory via assembly
485 
486                 assembly {
487                     let returndata_size := mload(returndata)
488                     revert(add(32, returndata), returndata_size)
489                 }
490             } else {
491                 revert(errorMessage);
492             }
493         }
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @title ERC721 token receiver interface
506  * @dev Interface for any contract that wants to support safeTransfers
507  * from ERC721 asset contracts.
508  */
509 interface IERC721Receiver {
510     /**
511      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
512      * by `operator` from `from`, this function is called.
513      *
514      * It must return its Solidity selector to confirm the token transfer.
515      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
516      *
517      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
518      */
519     function onERC721Received(
520         address operator,
521         address from,
522         uint256 tokenId,
523         bytes calldata data
524     ) external returns (bytes4);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Interface of the ERC165 standard, as defined in the
536  * https://eips.ethereum.org/EIPS/eip-165[EIP].
537  *
538  * Implementers can declare support of contract interfaces, which can then be
539  * queried by others ({ERC165Checker}).
540  *
541  * For an implementation, see {ERC165}.
542  */
543 interface IERC165 {
544     /**
545      * @dev Returns true if this contract implements the interface defined by
546      * `interfaceId`. See the corresponding
547      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
548      * to learn more about how these ids are created.
549      *
550      * This function call must use less than 30 000 gas.
551      */
552     function supportsInterface(bytes4 interfaceId) external view returns (bool);
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Required interface of an ERC721 compliant contract.
596  */
597 interface IERC721 is IERC165 {
598     /**
599      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
600      */
601     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
602 
603     /**
604      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
605      */
606     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
607 
608     /**
609      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
610      */
611     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
612 
613     /**
614      * @dev Returns the number of tokens in ``owner``'s account.
615      */
616     function balanceOf(address owner) external view returns (uint256 balance);
617 
618     /**
619      * @dev Returns the owner of the `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function ownerOf(uint256 tokenId) external view returns (address owner);
626 
627     /**
628      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
629      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) external;
646 
647     /**
648      * @dev Transfers `tokenId` token from `from` to `to`.
649      *
650      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must be owned by `from`.
657      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
658      *
659      * Emits a {Transfer} event.
660      */
661     function transferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) external;
666 
667     /**
668      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
669      * The approval is cleared when the token is transferred.
670      *
671      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
672      *
673      * Requirements:
674      *
675      * - The caller must own the token or be an approved operator.
676      * - `tokenId` must exist.
677      *
678      * Emits an {Approval} event.
679      */
680     function approve(address to, uint256 tokenId) external;
681 
682     /**
683      * @dev Returns the account approved for `tokenId` token.
684      *
685      * Requirements:
686      *
687      * - `tokenId` must exist.
688      */
689     function getApproved(uint256 tokenId) external view returns (address operator);
690 
691     /**
692      * @dev Approve or remove `operator` as an operator for the caller.
693      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
694      *
695      * Requirements:
696      *
697      * - The `operator` cannot be the caller.
698      *
699      * Emits an {ApprovalForAll} event.
700      */
701     function setApprovalForAll(address operator, bool _approved) external;
702 
703     /**
704      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
705      *
706      * See {setApprovalForAll}
707      */
708     function isApprovedForAll(address owner, address operator) external view returns (bool);
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must exist and be owned by `from`.
718      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
719      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
720      *
721      * Emits a {Transfer} event.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId,
727         bytes calldata data
728     ) external;
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 /**
740  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
741  * @dev See https://eips.ethereum.org/EIPS/eip-721
742  */
743 interface IERC721Metadata is IERC721 {
744     /**
745      * @dev Returns the token collection name.
746      */
747     function name() external view returns (string memory);
748 
749     /**
750      * @dev Returns the token collection symbol.
751      */
752     function symbol() external view returns (string memory);
753 
754     /**
755      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
756      */
757     function tokenURI(uint256 tokenId) external view returns (string memory);
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 
769 
770 
771 
772 
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata extension, but not including the Enumerable extension, which is available separately as
777  * {ERC721Enumerable}.
778  */
779 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
780     using Address for address;
781     using Strings for uint256;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to owner address
790     mapping(uint256 => address) private _owners;
791 
792     // Mapping owner address to token count
793     mapping(address => uint256) private _balances;
794 
795     // Mapping from token ID to approved address
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     /**
802      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
803      */
804     constructor(string memory name_, string memory symbol_) {
805         _name = name_;
806         _symbol = symbol_;
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
813         return
814             interfaceId == type(IERC721).interfaceId ||
815             interfaceId == type(IERC721Metadata).interfaceId ||
816             super.supportsInterface(interfaceId);
817     }
818 
819     /**
820      * @dev See {IERC721-balanceOf}.
821      */
822     function balanceOf(address owner) public view virtual override returns (uint256) {
823         require(owner != address(0), "ERC721: balance query for the zero address");
824         return _balances[owner];
825     }
826 
827     /**
828      * @dev See {IERC721-ownerOf}.
829      */
830     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
831         address owner = _owners[tokenId];
832         require(owner != address(0), "ERC721: owner query for nonexistent token");
833         return owner;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-name}.
838      */
839     function name() public view virtual override returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-symbol}.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-tokenURI}.
852      */
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
858     }
859 
860     /**
861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
863      * by default, can be overriden in child contracts.
864      */
865     function _baseURI() internal view virtual returns (string memory) {
866         return "";
867     }
868 
869     /**
870      * @dev See {IERC721-approve}.
871      */
872     function approve(address to, uint256 tokenId) public virtual override {
873         address owner = ERC721.ownerOf(tokenId);
874         require(to != owner, "ERC721: approval to current owner");
875 
876         require(
877             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
878             "ERC721: approve caller is not owner nor approved for all"
879         );
880 
881         _approve(to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-getApproved}.
886      */
887     function getApproved(uint256 tokenId) public view virtual override returns (address) {
888         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved) public virtual override {
897         _setApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         //solhint-disable-next-line max-line-length
916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
917 
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         safeTransferFrom(from, to, tokenId, "");
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public virtual override {
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942         _safeTransfer(from, to, tokenId, _data);
943     }
944 
945     /**
946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
948      *
949      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
950      *
951      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
952      * implement alternative mechanisms to perform token transfer, such as signature-based.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeTransfer(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) internal virtual {
969         _transfer(from, to, tokenId);
970         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted (`_mint`),
979      * and stop existing when they are burned (`_burn`).
980      */
981     function _exists(uint256 tokenId) internal view virtual returns (bool) {
982         return _owners[tokenId] != address(0);
983     }
984 
985     /**
986      * @dev Returns whether `spender` is allowed to manage `tokenId`.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
993         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
994         address owner = ERC721.ownerOf(tokenId);
995         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
996     }
997 
998     /**
999      * @dev Safely mints `tokenId` and transfers it to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(address to, uint256 tokenId) internal virtual {
1009         _safeMint(to, tokenId, "");
1010     }
1011 
1012     /**
1013      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1014      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1015      */
1016     function _safeMint(
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) internal virtual {
1021         _mint(to, tokenId);
1022         require(
1023             _checkOnERC721Received(address(0), to, tokenId, _data),
1024             "ERC721: transfer to non ERC721Receiver implementer"
1025         );
1026     }
1027 
1028     /**
1029      * @dev Mints `tokenId` and transfers it to `to`.
1030      *
1031      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - `to` cannot be the zero address.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _mint(address to, uint256 tokenId) internal virtual {
1041         require(to != address(0), "ERC721: mint to the zero address");
1042         require(!_exists(tokenId), "ERC721: token already minted");
1043 
1044         _beforeTokenTransfer(address(0), to, tokenId);
1045 
1046         _balances[to] += 1;
1047         _owners[tokenId] = to;
1048 
1049         emit Transfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074     }
1075 
1076     /**
1077      * @dev Transfers `tokenId` from `from` to `to`.
1078      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must be owned by `from`.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {
1092         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1093         require(to != address(0), "ERC721: transfer to the zero address");
1094 
1095         _beforeTokenTransfer(from, to, tokenId);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId);
1099 
1100         _balances[from] -= 1;
1101         _balances[to] += 1;
1102         _owners[tokenId] = to;
1103 
1104         emit Transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(address to, uint256 tokenId) internal virtual {
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Approve `operator` to operate on all of `owner` tokens
1119      *
1120      * Emits a {ApprovalForAll} event.
1121      */
1122     function _setApprovalForAll(
1123         address owner,
1124         address operator,
1125         bool approved
1126     ) internal virtual {
1127         require(owner != operator, "ERC721: approve to caller");
1128         _operatorApprovals[owner][operator] = approved;
1129         emit ApprovalForAll(owner, operator, approved);
1130     }
1131 
1132     /**
1133      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1134      * The call is not executed if the target address is not a contract.
1135      *
1136      * @param from address representing the previous owner of the given token ID
1137      * @param to target address that will receive the tokens
1138      * @param tokenId uint256 ID of the token to be transferred
1139      * @param _data bytes optional data to send along with the call
1140      * @return bool whether the call correctly returned the expected magic value
1141      */
1142     function _checkOnERC721Received(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) private returns (bool) {
1148         if (to.isContract()) {
1149             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1150                 return retval == IERC721Receiver.onERC721Received.selector;
1151             } catch (bytes memory reason) {
1152                 if (reason.length == 0) {
1153                     revert("ERC721: transfer to non ERC721Receiver implementer");
1154                 } else {
1155                     assembly {
1156                         revert(add(32, reason), mload(reason))
1157                     }
1158                 }
1159             }
1160         } else {
1161             return true;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Hook that is called before any token transfer. This includes minting
1167      * and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1175      * - `from` and `to` are never both zero.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _beforeTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual {}
1184 }
1185 
1186 // File: contracts/PersonaLamps.sol
1187 
1188 //Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 
1193 
1194 
1195 
1196 contract PersonaLamps is ERC721, Ownable {    
1197     using Counters for Counters.Counter; 
1198 
1199     uint256 public constant MAX_LAMP_PURCHASE = 20;
1200     uint256 public constant MAX_SUPPLY = 4444;
1201     uint256 public constant HOLDER_CAP = 2222;
1202 
1203     bytes32 immutable whitelistRoot;
1204     bytes32 immutable holderRoot;
1205 
1206     uint256 public holderBuys;
1207     uint256 public lampPrice = 0.044 ether;
1208     uint256 public presalePrice = 0.04 ether;
1209     uint256 public saleStartTime = type(uint256).max;
1210     uint256 public presaleStartTime = type(uint256).max;
1211 
1212     string public baseURI;
1213     address treasury = 0xB299aE977acAc0eAc606EBCa28d171B7F5670002;
1214     address uwulabs = 0x354A70969F0b4a4C994403051A81C2ca45db3615;
1215 
1216     bool public saleIsActive = true;
1217     bool private devMinted = false;
1218 
1219     Counters.Counter private _tokenIds;    
1220 
1221     // This is a packed array of booleans.
1222     mapping(uint256 => uint256) private claimedBitMap;
1223 
1224     constructor(uint256 _presaleStartTime, uint256 _saleStartTime, bytes32 _whitelistRoot, bytes32 _holderRoot) Ownable() ERC721("Persona Lamps", "LAMP") {
1225         require(_saleStartTime > _presaleStartTime, "Invalid timestamp");
1226         presaleStartTime = _presaleStartTime;
1227         saleStartTime = _saleStartTime;
1228         whitelistRoot = _whitelistRoot;
1229         holderRoot = _holderRoot;
1230     }
1231 
1232     function devMint() external onlyOwner {
1233         require(!devMinted, "Already minted");
1234         devMinted = true;
1235         for (uint256 i = 0; i < 40; i++) {
1236             _mintNFT(msg.sender);
1237         }
1238     }
1239 
1240     function withdraw() external onlyOwner {
1241         uint256 treasuryShare = (address(this).balance*850)/1000;
1242         require(payable(treasury).send(treasuryShare));
1243         require(payable(uwulabs).send(address(this).balance));
1244     }
1245 
1246     // Function to disable sale and close minting.
1247     function setSaleActive(bool active) external onlyOwner {
1248         saleIsActive = active;
1249     }
1250 
1251     function setPresalePrice(uint256 newPresalePrice) external onlyOwner {
1252         presalePrice = newPresalePrice;
1253     }
1254 
1255     function setLampPrice(uint256 newLampPrice) external onlyOwner {
1256         lampPrice = newLampPrice;
1257     }
1258 
1259     function setPresaleStartTime(uint256 _presaleStartTime) external onlyOwner {
1260         presaleStartTime = _presaleStartTime;
1261     }
1262 
1263     function setSaleStartTime(uint256 startTime) external onlyOwner {
1264         saleStartTime = startTime;
1265     }
1266 
1267     function setBaseURI(string memory newURI) external onlyOwner {
1268         baseURI = newURI;
1269     }
1270 
1271     function holderMint(uint256 index, uint256 amountToMint, bytes32[] calldata merkleProof) external payable {  
1272         require(saleIsActive, "Not active");       
1273         require(block.timestamp >= presaleStartTime, "Presale must be active");     
1274         require(block.timestamp < saleStartTime, "Presale has ended");
1275 
1276         require(amountToMint != 0 && amountToMint <= MAX_LAMP_PURCHASE, "0/limit");
1277         require(holderBuys + amountToMint <= HOLDER_CAP, "Capped holder sale");  
1278         require(msg.value == presalePrice*amountToMint, "Ether value sent is not correct");
1279 
1280         // Verify the merkle proof.
1281         bytes32 node = keccak256(abi.encodePacked(index, msg.sender, uint256(1)));
1282         require(MerkleProof.verify(merkleProof, holderRoot, node), 'MerkleDistributor: Invalid proof.');
1283 
1284         holderBuys += amountToMint;
1285 
1286         for (uint256 i = 0; i < amountToMint; i++) {
1287             _mintNFT(msg.sender);
1288         }
1289     }
1290 
1291     function whitelistMint(uint256 index, bytes32[] calldata merkleProof) external payable { 
1292         require(saleIsActive, "Not active");      
1293         require(block.timestamp >= presaleStartTime, "Presale must be active");  
1294         require(block.timestamp < saleStartTime, "Presale has ended");
1295 
1296         require(msg.value == lampPrice, "Ether value sent is not correct");
1297 
1298         // Verify the merkle proof.
1299         require(!isClaimed(index), "Already claimed");
1300         bytes32 node = keccak256(abi.encodePacked(index, msg.sender, uint256(1)));
1301         require(MerkleProof.verify(merkleProof, whitelistRoot, node), 'MerkleDistributor: Invalid proof.');
1302 
1303         _setClaimed(index);
1304         _mintNFT(msg.sender);
1305     }
1306 
1307     function mint(uint256 numberOfTokens) external payable {
1308         require(saleIsActive, "Not active");      
1309         require(numberOfTokens != 0 && numberOfTokens <= MAX_LAMP_PURCHASE, "0/limit"); 
1310         require(block.timestamp >= saleStartTime, "Sale must be active");
1311         require(msg.value == lampPrice * numberOfTokens, "Ether value sent is not correct");
1312         
1313         for(uint i = 0; i < numberOfTokens; i++) {
1314             _mintNFT(msg.sender);
1315         }
1316     } 
1317 
1318     function totalSupply() external view returns (uint256) {
1319         return _tokenIds.current();
1320     }
1321 
1322     function isClaimed(uint256 index) public view returns (bool) {
1323         uint256 claimedWordIndex = index / 256;
1324         uint256 claimedBitIndex = index % 256;
1325         uint256 claimedWord = claimedBitMap[claimedWordIndex];
1326         uint256 mask = (1 << claimedBitIndex);
1327         return claimedWord & mask == mask;
1328     }
1329 
1330     function _setClaimed(uint256 index) private {
1331         uint256 claimedWordIndex = index / 256;
1332         uint256 claimedBitIndex = index % 256;
1333         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
1334     }
1335 
1336     function _mintNFT(address to) internal {
1337         require(_tokenIds.current() + 1 < MAX_SUPPLY, "MAX_SUPPLY");
1338         uint256 newItemId = _tokenIds.current(); 
1339         _tokenIds.increment(); 
1340         _mint(to, newItemId);
1341     } 
1342 
1343     function _baseURI() internal view virtual override returns (string memory) {
1344         return baseURI;
1345     }
1346 }