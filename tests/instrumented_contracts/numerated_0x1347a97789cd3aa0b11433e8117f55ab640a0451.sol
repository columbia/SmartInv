1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
51             }
52         }
53         return computedHash;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/utils/Counters.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @title Counters
66  * @author Matt Condon (@shrugs)
67  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
68  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
69  *
70  * Include with `using Counters for Counters.Counter;`
71  */
72 library Counters {
73     struct Counter {
74         // This variable should never be directly accessed by users of the library: interactions must be restricted to
75         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
76         // this feature: see https://github.com/ethereum/solidity/issues/4637
77         uint256 _value; // default: 0
78     }
79 
80     function current(Counter storage counter) internal view returns (uint256) {
81         return counter._value;
82     }
83 
84     function increment(Counter storage counter) internal {
85         unchecked {
86             counter._value += 1;
87         }
88     }
89 
90     function decrement(Counter storage counter) internal {
91         uint256 value = counter._value;
92         require(value > 0, "Counter: decrement overflow");
93         unchecked {
94             counter._value = value - 1;
95         }
96     }
97 
98     function reset(Counter storage counter) internal {
99         counter._value = 0;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Strings.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev String operations.
112  */
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Context.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Provides information about the current execution context, including the
182  * sender of the transaction and its data. While these are generally available
183  * via msg.sender and msg.data, they should not be accessed in such a direct
184  * manner, since when dealing with meta-transactions the account sending and
185  * paying for execution may not be the actual sender (as far as an application
186  * is concerned).
187  *
188  * This contract is only required for intermediate, library-like contracts.
189  */
190 abstract contract Context {
191     function _msgSender() internal view virtual returns (address) {
192         return msg.sender;
193     }
194 
195     function _msgData() internal view virtual returns (bytes calldata) {
196         return msg.data;
197     }
198 }
199 
200 // File: @openzeppelin/contracts/access/Ownable.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * By default, the owner account will be the one that deploys the contract. This
214  * can later be changed with {transferOwnership}.
215  *
216  * This module is used through inheritance. It will make available the modifier
217  * `onlyOwner`, which can be applied to your functions to restrict their use to
218  * the owner.
219  */
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor() {
229         _transferOwnership(_msgSender());
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _transferOwnership(address(0));
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _transferOwnership(newOwner);
265     }
266 
267     /**
268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
269      * Internal function without access restriction.
270      */
271     function _transferOwnership(address newOwner) internal virtual {
272         address oldOwner = _owner;
273         _owner = newOwner;
274         emit OwnershipTransferred(oldOwner, newOwner);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Address.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize, which returns 0 for contracts in
308         // construction, since the code is only stored at the end of the
309         // constructor execution.
310 
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
471      * revert reason using the provided one.
472      *
473      * _Available since v4.3._
474      */
475     function verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) internal pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @title ERC721 token receiver interface
507  * @dev Interface for any contract that wants to support safeTransfers
508  * from ERC721 asset contracts.
509  */
510 interface IERC721Receiver {
511     /**
512      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
513      * by `operator` from `from`, this function is called.
514      *
515      * It must return its Solidity selector to confirm the token transfer.
516      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
517      *
518      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
519      */
520     function onERC721Received(
521         address operator,
522         address from,
523         uint256 tokenId,
524         bytes calldata data
525     ) external returns (bytes4);
526 }
527 
528 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Interface of the ERC165 standard, as defined in the
537  * https://eips.ethereum.org/EIPS/eip-165[EIP].
538  *
539  * Implementers can declare support of contract interfaces, which can then be
540  * queried by others ({ERC165Checker}).
541  *
542  * For an implementation, see {ERC165}.
543  */
544 interface IERC165 {
545     /**
546      * @dev Returns true if this contract implements the interface defined by
547      * `interfaceId`. See the corresponding
548      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
549      * to learn more about how these ids are created.
550      *
551      * This function call must use less than 30 000 gas.
552      */
553     function supportsInterface(bytes4 interfaceId) external view returns (bool);
554 }
555 
556 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Required interface of an ERC721 compliant contract.
597  */
598 interface IERC721 is IERC165 {
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
611      */
612     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
613 
614     /**
615      * @dev Returns the number of tokens in ``owner``'s account.
616      */
617     function balanceOf(address owner) external view returns (uint256 balance);
618 
619     /**
620      * @dev Returns the owner of the `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function ownerOf(uint256 tokenId) external view returns (address owner);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
630      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) external;
647 
648     /**
649      * @dev Transfers `tokenId` token from `from` to `to`.
650      *
651      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      *
660      * Emits a {Transfer} event.
661      */
662     function transferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
670      * The approval is cleared when the token is transferred.
671      *
672      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
673      *
674      * Requirements:
675      *
676      * - The caller must own the token or be an approved operator.
677      * - `tokenId` must exist.
678      *
679      * Emits an {Approval} event.
680      */
681     function approve(address to, uint256 tokenId) external;
682 
683     /**
684      * @dev Returns the account approved for `tokenId` token.
685      *
686      * Requirements:
687      *
688      * - `tokenId` must exist.
689      */
690     function getApproved(uint256 tokenId) external view returns (address operator);
691 
692     /**
693      * @dev Approve or remove `operator` as an operator for the caller.
694      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
695      *
696      * Requirements:
697      *
698      * - The `operator` cannot be the caller.
699      *
700      * Emits an {ApprovalForAll} event.
701      */
702     function setApprovalForAll(address operator, bool _approved) external;
703 
704     /**
705      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
706      *
707      * See {setApprovalForAll}
708      */
709     function isApprovedForAll(address owner, address operator) external view returns (bool);
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes calldata data
729     ) external;
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
742  * @dev See https://eips.ethereum.org/EIPS/eip-721
743  */
744 interface IERC721Metadata is IERC721 {
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 }
760 
761 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
762 
763 
764 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
765 
766 pragma solidity ^0.8.0;
767 
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension, but not including the Enumerable extension, which is available separately as
778  * {ERC721Enumerable}.
779  */
780 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
781     using Address for address;
782     using Strings for uint256;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to owner address
791     mapping(uint256 => address) private _owners;
792 
793     // Mapping owner address to token count
794     mapping(address => uint256) private _balances;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     /**
803      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
804      */
805     constructor(string memory name_, string memory symbol_) {
806         _name = name_;
807         _symbol = symbol_;
808     }
809 
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
814         return
815             interfaceId == type(IERC721).interfaceId ||
816             interfaceId == type(IERC721Metadata).interfaceId ||
817             super.supportsInterface(interfaceId);
818     }
819 
820     /**
821      * @dev See {IERC721-balanceOf}.
822      */
823     function balanceOf(address owner) public view virtual override returns (uint256) {
824         require(owner != address(0), "ERC721: balance query for the zero address");
825         return _balances[owner];
826     }
827 
828     /**
829      * @dev See {IERC721-ownerOf}.
830      */
831     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
832         address owner = _owners[tokenId];
833         require(owner != address(0), "ERC721: owner query for nonexistent token");
834         return owner;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-name}.
839      */
840     function name() public view virtual override returns (string memory) {
841         return _name;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-symbol}.
846      */
847     function symbol() public view virtual override returns (string memory) {
848         return _symbol;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-tokenURI}.
853      */
854     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
855         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
856 
857         string memory baseURI = _baseURI();
858         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
859     }
860 
861     /**
862      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
863      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
864      * by default, can be overriden in child contracts.
865      */
866     function _baseURI() internal view virtual returns (string memory) {
867         return "";
868     }
869 
870     /**
871      * @dev See {IERC721-approve}.
872      */
873     function approve(address to, uint256 tokenId) public virtual override {
874         address owner = ERC721.ownerOf(tokenId);
875         require(to != owner, "ERC721: approval to current owner");
876 
877         require(
878             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
879             "ERC721: approve caller is not owner nor approved for all"
880         );
881 
882         _approve(to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-getApproved}.
887      */
888     function getApproved(uint256 tokenId) public view virtual override returns (address) {
889         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
890 
891         return _tokenApprovals[tokenId];
892     }
893 
894     /**
895      * @dev See {IERC721-setApprovalForAll}.
896      */
897     function setApprovalForAll(address operator, bool approved) public virtual override {
898         _setApprovalForAll(_msgSender(), operator, approved);
899     }
900 
901     /**
902      * @dev See {IERC721-isApprovedForAll}.
903      */
904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
905         return _operatorApprovals[owner][operator];
906     }
907 
908     /**
909      * @dev See {IERC721-transferFrom}.
910      */
911     function transferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         //solhint-disable-next-line max-line-length
917         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
918 
919         _transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         safeTransferFrom(from, to, tokenId, "");
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public virtual override {
942         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
943         _safeTransfer(from, to, tokenId, _data);
944     }
945 
946     /**
947      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
948      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
949      *
950      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
951      *
952      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
953      * implement alternative mechanisms to perform token transfer, such as signature-based.
954      *
955      * Requirements:
956      *
957      * - `from` cannot be the zero address.
958      * - `to` cannot be the zero address.
959      * - `tokenId` token must exist and be owned by `from`.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeTransfer(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) internal virtual {
970         _transfer(from, to, tokenId);
971         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
972     }
973 
974     /**
975      * @dev Returns whether `tokenId` exists.
976      *
977      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
978      *
979      * Tokens start existing when they are minted (`_mint`),
980      * and stop existing when they are burned (`_burn`).
981      */
982     function _exists(uint256 tokenId) internal view virtual returns (bool) {
983         return _owners[tokenId] != address(0);
984     }
985 
986     /**
987      * @dev Returns whether `spender` is allowed to manage `tokenId`.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      */
993     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
994         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
995         address owner = ERC721.ownerOf(tokenId);
996         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
997     }
998 
999     /**
1000      * @dev Safely mints `tokenId` and transfers it to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must not exist.
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeMint(address to, uint256 tokenId) internal virtual {
1010         _safeMint(to, tokenId, "");
1011     }
1012 
1013     /**
1014      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1015      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1016      */
1017     function _safeMint(
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) internal virtual {
1022         _mint(to, tokenId);
1023         require(
1024             _checkOnERC721Received(address(0), to, tokenId, _data),
1025             "ERC721: transfer to non ERC721Receiver implementer"
1026         );
1027     }
1028 
1029     /**
1030      * @dev Mints `tokenId` and transfers it to `to`.
1031      *
1032      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - `to` cannot be the zero address.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _mint(address to, uint256 tokenId) internal virtual {
1042         require(to != address(0), "ERC721: mint to the zero address");
1043         require(!_exists(tokenId), "ERC721: token already minted");
1044 
1045         _beforeTokenTransfer(address(0), to, tokenId);
1046 
1047         _balances[to] += 1;
1048         _owners[tokenId] = to;
1049 
1050         emit Transfer(address(0), to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Destroys `tokenId`.
1055      * The approval is cleared when the token is burned.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _burn(uint256 tokenId) internal virtual {
1064         address owner = ERC721.ownerOf(tokenId);
1065 
1066         _beforeTokenTransfer(owner, address(0), tokenId);
1067 
1068         // Clear approvals
1069         _approve(address(0), tokenId);
1070 
1071         _balances[owner] -= 1;
1072         delete _owners[tokenId];
1073 
1074         emit Transfer(owner, address(0), tokenId);
1075     }
1076 
1077     /**
1078      * @dev Transfers `tokenId` from `from` to `to`.
1079      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must be owned by `from`.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _transfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {
1093         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1094         require(to != address(0), "ERC721: transfer to the zero address");
1095 
1096         _beforeTokenTransfer(from, to, tokenId);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId);
1100 
1101         _balances[from] -= 1;
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(from, to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(address to, uint256 tokenId) internal virtual {
1114         _tokenApprovals[tokenId] = to;
1115         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Approve `operator` to operate on all of `owner` tokens
1120      *
1121      * Emits a {ApprovalForAll} event.
1122      */
1123     function _setApprovalForAll(
1124         address owner,
1125         address operator,
1126         bool approved
1127     ) internal virtual {
1128         require(owner != operator, "ERC721: approve to caller");
1129         _operatorApprovals[owner][operator] = approved;
1130         emit ApprovalForAll(owner, operator, approved);
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1135      * The call is not executed if the target address is not a contract.
1136      *
1137      * @param from address representing the previous owner of the given token ID
1138      * @param to target address that will receive the tokens
1139      * @param tokenId uint256 ID of the token to be transferred
1140      * @param _data bytes optional data to send along with the call
1141      * @return bool whether the call correctly returned the expected magic value
1142      */
1143     function _checkOnERC721Received(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) private returns (bool) {
1149         if (to.isContract()) {
1150             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1151                 return retval == IERC721Receiver.onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert("ERC721: transfer to non ERC721Receiver implementer");
1155                 } else {
1156                     assembly {
1157                         revert(add(32, reason), mload(reason))
1158                     }
1159                 }
1160             }
1161         } else {
1162             return true;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Hook that is called before any token transfer. This includes minting
1168      * and burning.
1169      *
1170      * Calling conditions:
1171      *
1172      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1173      * transferred to `to`.
1174      * - When `from` is zero, `tokenId` will be minted for `to`.
1175      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1176      * - `from` and `to` are never both zero.
1177      *
1178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1179      */
1180     function _beforeTokenTransfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual {}
1185 }
1186 
1187 // File: LongLostFunction.sol
1188 
1189 
1190 
1191 pragma solidity >=0.7.0 <0.9.0;
1192 
1193 
1194 contract LongLost is ERC721, Ownable {
1195 
1196     using Strings for uint256;
1197     using Counters for Counters.Counter;
1198 
1199     Counters.Counter private supply;
1200 
1201     string public uriPrefix = "";
1202     string public uriSuffix = ".json";
1203     string public hiddenMetadataUri;
1204 
1205     uint256 public cost = 0.04 ether;
1206     uint256 public maxSupply = 10000;
1207     uint256 public maxMintAmountPerTx = 10;
1208 
1209     uint8 public publicMintAmount = 20;
1210     uint8 public allowListMintAmount = 5;
1211 
1212     bool public paused = true;
1213     bool public isAllowListActive = true;
1214     bool public revealed = false;
1215 
1216     bytes32 public whitelistMerkleRoot = 0x0758ddc53129da410a7d4536b32e8f2f00e4edf3568e11b199fdc384d06a55d3;
1217 
1218     mapping(address => uint8) private _mintAllowList;
1219     mapping(address => uint8) private _mintPublicList;
1220 
1221 
1222     
1223     
1224 
1225     constructor() ERC721("Long Lost", "LOST") {
1226         setHiddenMetadataUri("ipfs://QmZeF9ef2XnK2iiYC2grQ8W8xTMaUchofPEmn1FF1EryNn/hidden.json");
1227     }
1228 
1229     // -- compliance checks for tx -- 
1230     //Checks and records # of mints per wallet address for public. 
1231     function setMintList(uint8 _mintAmount) internal {
1232 
1233 
1234         if(!isAllowListActive) {
1235             require(_mintPublicList[msg.sender] + _mintAmount <= publicMintAmount);
1236             _mintPublicList[msg.sender] = _mintPublicList[msg.sender] + _mintAmount;
1237         }
1238 
1239         if(isAllowListActive) {
1240             require(_mintAllowList[msg.sender] + _mintAmount <= allowListMintAmount);
1241             _mintAllowList[msg.sender] = _mintAllowList[msg.sender] + _mintAmount;
1242         }
1243     }
1244 
1245 
1246     //supply limit / tx checks
1247     modifier mintCompliance(uint256 _mintAmount) {
1248         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1249         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1250         _;
1251     }
1252 
1253     //supply check
1254     function totalSupply() public view returns (uint256) {
1255         return supply.current();
1256     }
1257 
1258     //Contract enablement functions
1259     function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
1260         isAllowListActive = _isAllowListActive;
1261     }
1262 
1263     function setPaused(bool _state) public onlyOwner {
1264         paused = _state;
1265     }
1266     
1267     //check minting amounts. Doubles as access check
1268     function remainingAllowListMints(address userAddress) public view returns (uint256) {
1269             return allowListMintAmount - _mintAllowList[userAddress];
1270     }
1271     
1272 
1273     function remainingPublicMints(address userAddress) public view returns (uint256) { 
1274             return publicMintAmount - _mintPublicList[userAddress];
1275     }
1276 
1277     //merkletree 
1278     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1279         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1280     }
1281 
1282     function _leaf(address account) internal pure returns (bytes32) {
1283         return keccak256(abi.encodePacked(account));
1284     }
1285 
1286     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1287         whitelistMerkleRoot = _whitelistMerkleRoot;
1288     }
1289 
1290     
1291     //public mint function
1292     function mint(uint8 _mintAmount) public payable mintCompliance(_mintAmount) {
1293         require(!paused, "The contract is paused!");
1294         require(!isAllowListActive, "Whitelist is still active");
1295 
1296         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1297 
1298         setMintList(_mintAmount); //compliance check for public minting limits - check minting # per wallet. 
1299         _mintLoop(msg.sender, _mintAmount);
1300     }
1301 
1302     //allowlist mint function
1303     function mintAllowList(uint8 _mintAmount, bytes32[] calldata proof) public payable mintCompliance(_mintAmount) {
1304         require(!paused, "The contract is paused"); 
1305         require(isAllowListActive, "Whitelist is paused");
1306         
1307         require(_mintAmount <= allowListMintAmount); 
1308         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1309         require(_verify(_leaf(msg.sender), proof), "Invalid proof");
1310 
1311         
1312         setMintList(_mintAmount);
1313         _mintLoop(msg.sender, _mintAmount);
1314     }
1315 
1316     //freemint function
1317     function mintForAddress(uint8 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1318         _mintLoop(_receiver, _mintAmount);
1319     }
1320 
1321     //safemint function
1322     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1323         for (uint256 i = 0; i < _mintAmount; i++) {
1324             supply.increment();
1325             _safeMint(_receiver, supply.current());
1326         }
1327     }
1328 
1329     function walletOfOwner(address _owner)
1330         public
1331         view
1332         returns (uint256[] memory)
1333         {
1334             uint256 ownerTokenCount = balanceOf(_owner);
1335             uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1336             uint256 currentTokenId = 1;
1337             uint256 ownedTokenIndex = 0;
1338 
1339     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1340         address currentTokenOwner = ownerOf(currentTokenId);
1341 
1342             if (currentTokenOwner == _owner) {
1343             ownedTokenIds[ownedTokenIndex] = currentTokenId;
1344 
1345             ownedTokenIndex++;
1346             }
1347 
1348         currentTokenId++;
1349     }
1350 
1351         return ownedTokenIds;
1352     }
1353 
1354     function tokenURI(uint256 _tokenId)
1355         public
1356         view
1357         virtual
1358         override
1359         returns (string memory)
1360     {
1361     require(
1362         _exists(_tokenId),
1363         "ERC721Metadata: URI query for nonexistent token"
1364     );
1365 
1366     if (revealed == false) {
1367         return hiddenMetadataUri;
1368     }
1369 
1370     string memory currentBaseURI = _baseURI();
1371         return bytes(currentBaseURI).length > 0
1372             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1373             : "";
1374     }
1375 
1376     function setRevealed(bool _state) public onlyOwner {
1377         revealed = _state;
1378     }
1379 
1380     function setCost(uint256 _cost) public onlyOwner {
1381         cost = _cost;
1382     }
1383 
1384 
1385     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1386         hiddenMetadataUri = _hiddenMetadataUri;
1387     }
1388 
1389     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1390         uriPrefix = _uriPrefix;
1391     }
1392 
1393     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1394         uriSuffix = _uriSuffix;
1395     }
1396 
1397     
1398 
1399     function withdraw() public onlyOwner {
1400         
1401         //50% goes to community wallet
1402         (bool hs, ) = payable(0x086C47A4E99cd41aF68166Fba0ad163546AAA50e).call{value: address(this).balance * 50 / 100}("");
1403         require(hs);
1404         //rest to team wallet
1405         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1406         require(os);
1407 
1408     }
1409 
1410     
1411 
1412     function _baseURI() internal view virtual override returns (string memory) {
1413         return uriPrefix;
1414     }
1415 }