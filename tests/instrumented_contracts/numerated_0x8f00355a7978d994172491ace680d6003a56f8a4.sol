1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Counters.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @title Counters
74  * @author Matt Condon (@shrugs)
75  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
76  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
77  *
78  * Include with `using Counters for Counters.Counter;`
79  */
80 library Counters {
81     struct Counter {
82         // This variable should never be directly accessed by users of the library: interactions must be restricted to
83         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
84         // this feature: see https://github.com/ethereum/solidity/issues/4637
85         uint256 _value; // default: 0
86     }
87 
88     function current(Counter storage counter) internal view returns (uint256) {
89         return counter._value;
90     }
91 
92     function increment(Counter storage counter) internal {
93         unchecked {
94             counter._value += 1;
95         }
96     }
97 
98     function decrement(Counter storage counter) internal {
99         uint256 value = counter._value;
100         require(value > 0, "Counter: decrement overflow");
101         unchecked {
102             counter._value = value - 1;
103         }
104     }
105 
106     function reset(Counter storage counter) internal {
107         counter._value = 0;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Strings.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
126      */
127     function toString(uint256 value) internal pure returns (string memory) {
128         // Inspired by OraclizeAPI's implementation - MIT licence
129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
130 
131         if (value == 0) {
132             return "0";
133         }
134         uint256 temp = value;
135         uint256 digits;
136         while (temp != 0) {
137             digits++;
138             temp /= 10;
139         }
140         bytes memory buffer = new bytes(digits);
141         while (value != 0) {
142             digits -= 1;
143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
144             value /= 10;
145         }
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
151      */
152     function toHexString(uint256 value) internal pure returns (string memory) {
153         if (value == 0) {
154             return "0x00";
155         }
156         uint256 temp = value;
157         uint256 length = 0;
158         while (temp != 0) {
159             length++;
160             temp >>= 8;
161         }
162         return toHexString(value, length);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
167      */
168     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
169         bytes memory buffer = new bytes(2 * length + 2);
170         buffer[0] = "0";
171         buffer[1] = "x";
172         for (uint256 i = 2 * length + 1; i > 1; --i) {
173             buffer[i] = _HEX_SYMBOLS[value & 0xf];
174             value >>= 4;
175         }
176         require(value == 0, "Strings: hex length insufficient");
177         return string(buffer);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Context.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Provides information about the current execution context, including the
190  * sender of the transaction and its data. While these are generally available
191  * via msg.sender and msg.data, they should not be accessed in such a direct
192  * manner, since when dealing with meta-transactions the account sending and
193  * paying for execution may not be the actual sender (as far as an application
194  * is concerned).
195  *
196  * This contract is only required for intermediate, library-like contracts.
197  */
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address) {
200         return msg.sender;
201     }
202 
203     function _msgData() internal view virtual returns (bytes calldata) {
204         return msg.data;
205     }
206 }
207 
208 // File: @openzeppelin/contracts/access/Ownable.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Contract module which provides a basic access control mechanism, where
218  * there is an account (an owner) that can be granted exclusive access to
219  * specific functions.
220  *
221  * By default, the owner account will be the one that deploys the contract. This
222  * can later be changed with {transferOwnership}.
223  *
224  * This module is used through inheritance. It will make available the modifier
225  * `onlyOwner`, which can be applied to your functions to restrict their use to
226  * the owner.
227  */
228 abstract contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     /**
234      * @dev Initializes the contract setting the deployer as the initial owner.
235      */
236     constructor() {
237         _transferOwnership(_msgSender());
238     }
239 
240     /**
241      * @dev Returns the address of the current owner.
242      */
243     function owner() public view virtual returns (address) {
244         return _owner;
245     }
246 
247     /**
248      * @dev Throws if called by any account other than the owner.
249      */
250     modifier onlyOwner() {
251         require(owner() == _msgSender(), "Ownable: caller is not the owner");
252         _;
253     }
254 
255     /**
256      * @dev Leaves the contract without owner. It will not be possible to call
257      * `onlyOwner` functions anymore. Can only be called by the current owner.
258      *
259      * NOTE: Renouncing ownership will leave the contract without an owner,
260      * thereby removing any functionality that is only available to the owner.
261      */
262     function renounceOwnership() public virtual onlyOwner {
263         _transferOwnership(address(0));
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         _transferOwnership(newOwner);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Internal function without access restriction.
278      */
279     function _transferOwnership(address newOwner) internal virtual {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
290 
291 pragma solidity ^0.8.1;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      *
314      * [IMPORTANT]
315      * ====
316      * You shouldn't rely on `isContract` to protect against flash loan attacks!
317      *
318      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
319      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
320      * constructor.
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize/address.code.length, which returns 0
325         // for contracts in construction, since the code is only stored at the end
326         // of the constructor execution.
327 
328         return account.code.length > 0;
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         (bool success, ) = recipient.call{value: amount}("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain `call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 value
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         require(isContract(target), "Address: call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.call{value: value}(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
435         return functionStaticCall(target, data, "Address: low-level static call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal view returns (bytes memory) {
449         require(isContract(target), "Address: static call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.staticcall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(isContract(target), "Address: delegate call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.delegatecall(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
484      * revert reason using the provided one.
485      *
486      * _Available since v4.3._
487      */
488     function verifyCallResult(
489         bool success,
490         bytes memory returndata,
491         string memory errorMessage
492     ) internal pure returns (bytes memory) {
493         if (success) {
494             return returndata;
495         } else {
496             // Look for revert reason and bubble it up if present
497             if (returndata.length > 0) {
498                 // The easiest way to bubble the revert reason is using memory via assembly
499 
500                 assembly {
501                     let returndata_size := mload(returndata)
502                     revert(add(32, returndata), returndata_size)
503                 }
504             } else {
505                 revert(errorMessage);
506             }
507         }
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @title ERC721 token receiver interface
520  * @dev Interface for any contract that wants to support safeTransfers
521  * from ERC721 asset contracts.
522  */
523 interface IERC721Receiver {
524     /**
525      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
526      * by `operator` from `from`, this function is called.
527      *
528      * It must return its Solidity selector to confirm the token transfer.
529      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
530      *
531      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
532      */
533     function onERC721Received(
534         address operator,
535         address from,
536         uint256 tokenId,
537         bytes calldata data
538     ) external returns (bytes4);
539 }
540 
541 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Interface of the ERC165 standard, as defined in the
550  * https://eips.ethereum.org/EIPS/eip-165[EIP].
551  *
552  * Implementers can declare support of contract interfaces, which can then be
553  * queried by others ({ERC165Checker}).
554  *
555  * For an implementation, see {ERC165}.
556  */
557 interface IERC165 {
558     /**
559      * @dev Returns true if this contract implements the interface defined by
560      * `interfaceId`. See the corresponding
561      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
562      * to learn more about how these ids are created.
563      *
564      * This function call must use less than 30 000 gas.
565      */
566     function supportsInterface(bytes4 interfaceId) external view returns (bool);
567 }
568 
569 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @dev Required interface of an ERC721 compliant contract.
610  */
611 interface IERC721 is IERC165 {
612     /**
613      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
614      */
615     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
616 
617     /**
618      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
619      */
620     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
621 
622     /**
623      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
624      */
625     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
626 
627     /**
628      * @dev Returns the number of tokens in ``owner``'s account.
629      */
630     function balanceOf(address owner) external view returns (uint256 balance);
631 
632     /**
633      * @dev Returns the owner of the `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function ownerOf(uint256 tokenId) external view returns (address owner);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
651      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
652      *
653      * Emits a {Transfer} event.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) external;
660 
661     /**
662      * @dev Transfers `tokenId` token from `from` to `to`.
663      *
664      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      *
673      * Emits a {Transfer} event.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) external;
680 
681     /**
682      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
683      * The approval is cleared when the token is transferred.
684      *
685      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
686      *
687      * Requirements:
688      *
689      * - The caller must own the token or be an approved operator.
690      * - `tokenId` must exist.
691      *
692      * Emits an {Approval} event.
693      */
694     function approve(address to, uint256 tokenId) external;
695 
696     /**
697      * @dev Returns the account approved for `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function getApproved(uint256 tokenId) external view returns (address operator);
704 
705     /**
706      * @dev Approve or remove `operator` as an operator for the caller.
707      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
708      *
709      * Requirements:
710      *
711      * - The `operator` cannot be the caller.
712      *
713      * Emits an {ApprovalForAll} event.
714      */
715     function setApprovalForAll(address operator, bool _approved) external;
716 
717     /**
718      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
719      *
720      * See {setApprovalForAll}
721      */
722     function isApprovedForAll(address owner, address operator) external view returns (bool);
723 
724     /**
725      * @dev Safely transfers `tokenId` token from `from` to `to`.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId,
741         bytes calldata data
742     ) external;
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
746 
747 
748 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 
753 /**
754  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
755  * @dev See https://eips.ethereum.org/EIPS/eip-721
756  */
757 interface IERC721Metadata is IERC721 {
758     /**
759      * @dev Returns the token collection name.
760      */
761     function name() external view returns (string memory);
762 
763     /**
764      * @dev Returns the token collection symbol.
765      */
766     function symbol() external view returns (string memory);
767 
768     /**
769      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
770      */
771     function tokenURI(uint256 tokenId) external view returns (string memory);
772 }
773 
774 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 
783 
784 
785 
786 
787 
788 /**
789  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
790  * the Metadata extension, but not including the Enumerable extension, which is available separately as
791  * {ERC721Enumerable}.
792  */
793 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
794     using Address for address;
795     using Strings for uint256;
796 
797     // Token name
798     string private _name;
799 
800     // Token symbol
801     string private _symbol;
802 
803     // Mapping from token ID to owner address
804     mapping(uint256 => address) private _owners;
805 
806     // Mapping owner address to token count
807     mapping(address => uint256) private _balances;
808 
809     // Mapping from token ID to approved address
810     mapping(uint256 => address) private _tokenApprovals;
811 
812     // Mapping from owner to operator approvals
813     mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815     /**
816      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
817      */
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      */
826     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
827         return
828             interfaceId == type(IERC721).interfaceId ||
829             interfaceId == type(IERC721Metadata).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view virtual override returns (uint256) {
837         require(owner != address(0), "ERC721: balance query for the zero address");
838         return _balances[owner];
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
845         address owner = _owners[tokenId];
846         require(owner != address(0), "ERC721: owner query for nonexistent token");
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return "";
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public virtual override {
887         address owner = ERC721.ownerOf(tokenId);
888         require(to != owner, "ERC721: approval to current owner");
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             "ERC721: approve caller is not owner nor approved for all"
893         );
894 
895         _approve(to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view virtual override returns (address) {
902         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public virtual override {
911         _setApprovalForAll(_msgSender(), operator, approved);
912     }
913 
914     /**
915      * @dev See {IERC721-isApprovedForAll}.
916      */
917     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         //solhint-disable-next-line max-line-length
930         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
931 
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         safeTransferFrom(from, to, tokenId, "");
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public virtual override {
955         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
956         _safeTransfer(from, to, tokenId, _data);
957     }
958 
959     /**
960      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
961      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
962      *
963      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
964      *
965      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
966      * implement alternative mechanisms to perform token transfer, such as signature-based.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _safeTransfer(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) internal virtual {
983         _transfer(from, to, tokenId);
984         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
985     }
986 
987     /**
988      * @dev Returns whether `tokenId` exists.
989      *
990      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
991      *
992      * Tokens start existing when they are minted (`_mint`),
993      * and stop existing when they are burned (`_burn`).
994      */
995     function _exists(uint256 tokenId) internal view virtual returns (bool) {
996         return _owners[tokenId] != address(0);
997     }
998 
999     /**
1000      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1007         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1008         address owner = ERC721.ownerOf(tokenId);
1009         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1010     }
1011 
1012     /**
1013      * @dev Safely mints `tokenId` and transfers it to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must not exist.
1018      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _safeMint(address to, uint256 tokenId) internal virtual {
1023         _safeMint(to, tokenId, "");
1024     }
1025 
1026     /**
1027      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1028      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1029      */
1030     function _safeMint(
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) internal virtual {
1035         _mint(to, tokenId);
1036         require(
1037             _checkOnERC721Received(address(0), to, tokenId, _data),
1038             "ERC721: transfer to non ERC721Receiver implementer"
1039         );
1040     }
1041 
1042     /**
1043      * @dev Mints `tokenId` and transfers it to `to`.
1044      *
1045      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must not exist.
1050      * - `to` cannot be the zero address.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _mint(address to, uint256 tokenId) internal virtual {
1055         require(to != address(0), "ERC721: mint to the zero address");
1056         require(!_exists(tokenId), "ERC721: token already minted");
1057 
1058         _beforeTokenTransfer(address(0), to, tokenId);
1059 
1060         _balances[to] += 1;
1061         _owners[tokenId] = to;
1062 
1063         emit Transfer(address(0), to, tokenId);
1064 
1065         _afterTokenTransfer(address(0), to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         address owner = ERC721.ownerOf(tokenId);
1080 
1081         _beforeTokenTransfer(owner, address(0), tokenId);
1082 
1083         // Clear approvals
1084         _approve(address(0), tokenId);
1085 
1086         _balances[owner] -= 1;
1087         delete _owners[tokenId];
1088 
1089         emit Transfer(owner, address(0), tokenId);
1090 
1091         _afterTokenTransfer(owner, address(0), tokenId);
1092     }
1093 
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) internal virtual {
1110         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1111         require(to != address(0), "ERC721: transfer to the zero address");
1112 
1113         _beforeTokenTransfer(from, to, tokenId);
1114 
1115         // Clear approvals from the previous owner
1116         _approve(address(0), tokenId);
1117 
1118         _balances[from] -= 1;
1119         _balances[to] += 1;
1120         _owners[tokenId] = to;
1121 
1122         emit Transfer(from, to, tokenId);
1123 
1124         _afterTokenTransfer(from, to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev Approve `to` to operate on `tokenId`
1129      *
1130      * Emits a {Approval} event.
1131      */
1132     function _approve(address to, uint256 tokenId) internal virtual {
1133         _tokenApprovals[tokenId] = to;
1134         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Approve `operator` to operate on all of `owner` tokens
1139      *
1140      * Emits a {ApprovalForAll} event.
1141      */
1142     function _setApprovalForAll(
1143         address owner,
1144         address operator,
1145         bool approved
1146     ) internal virtual {
1147         require(owner != operator, "ERC721: approve to caller");
1148         _operatorApprovals[owner][operator] = approved;
1149         emit ApprovalForAll(owner, operator, approved);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1154      * The call is not executed if the target address is not a contract.
1155      *
1156      * @param from address representing the previous owner of the given token ID
1157      * @param to target address that will receive the tokens
1158      * @param tokenId uint256 ID of the token to be transferred
1159      * @param _data bytes optional data to send along with the call
1160      * @return bool whether the call correctly returned the expected magic value
1161      */
1162     function _checkOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         if (to.isContract()) {
1169             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1170                 return retval == IERC721Receiver.onERC721Received.selector;
1171             } catch (bytes memory reason) {
1172                 if (reason.length == 0) {
1173                     revert("ERC721: transfer to non ERC721Receiver implementer");
1174                 } else {
1175                     assembly {
1176                         revert(add(32, reason), mload(reason))
1177                     }
1178                 }
1179             }
1180         } else {
1181             return true;
1182         }
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1195      * - `from` and `to` are never both zero.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {}
1204 
1205     /**
1206      * @dev Hook that is called after any transfer of tokens. This includes
1207      * minting and burning.
1208      *
1209      * Calling conditions:
1210      *
1211      * - when `from` and `to` are both non-zero.
1212      * - `from` and `to` are never both zero.
1213      *
1214      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1215      */
1216     function _afterTokenTransfer(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) internal virtual {}
1221 }
1222 
1223 // File: contracts/SCLadies_Flat.sol
1224 
1225 
1226 
1227 //
1228 //   _____  _____ _               _ _             _   _ ______ _______
1229 //  / ____|/ ____| |             | (_)           | \ | |  ____|__   __|
1230 // | (___ | |    | |     __ _  __| |_  ___  ___  |  \| | |__     | |
1231 //  \___ \| |    | |    / _` |/ _` | |/ _ \/ __| | . ` |  __|    | |
1232 //  ____) | |____| |___| (_| | (_| | |  __/\__ \ | |\  | |       | |
1233 // |_____/ \_____|______\__,_|\__,_|_|\___||___/ |_| \_|_|       |_|
1234 //
1235 //
1236 
1237 /*
1238  * @creator SC Ladies by San Coiffure
1239  * @author burakcbdn twitter.com/burakcbdn
1240  */
1241 
1242 pragma solidity >=0.7.0 <0.9.0;
1243 
1244 
1245 
1246 
1247 
1248 contract SCLadies is ERC721, Ownable {
1249     using Strings for uint256;
1250     using Counters for Counters.Counter;
1251 
1252     Counters.Counter private supply;
1253 
1254     string public ladiesURI = "";
1255     string public metadataExtension = ".json";
1256 
1257     string public hiddenLadiesURI;
1258 
1259     uint256 public preSalePrice = 0.034 ether;
1260     uint256 public mintPrice = 0.064 ether;
1261 
1262     uint256 public maxSupply = 6434;
1263 
1264     uint256 public maxMintPerTx = 20;
1265     uint256 public maxMintPerFirstLady = 2;
1266 
1267     bool public paused = true;
1268     bool public preSale = false;
1269     bool public publicSale = false;
1270 
1271     bool public revealed = false;
1272 
1273     bytes32 public merkleRoot;
1274 
1275     mapping(address => uint256) public ladyBalances;
1276 
1277     constructor() ERC721("SC Ladies", "LADY"){}
1278 
1279     modifier mintCompliance(uint256 _mintAmount) {
1280         require(
1281             _mintAmount > 0 && _mintAmount <= maxMintPerTx,
1282             "Invalid mint amount!"
1283         );
1284         require(
1285             supply.current() + _mintAmount <= maxSupply,
1286             "Max supply exceeded!"
1287         );
1288         _;
1289     }
1290 
1291     modifier onlyAccounts() {
1292         require(msg.sender == tx.origin, "Invalid origin");
1293         _;
1294     }
1295 
1296     function totalSupply() public view returns (uint256) {
1297         return supply.current();
1298     }
1299 
1300     function mint(uint256 _mintAmount)
1301         public
1302         payable
1303         onlyAccounts
1304         mintCompliance(_mintAmount)
1305     {
1306         require(!paused, "The contract is paused!");
1307         require(publicSale, "Public sale has not started yet!");
1308         require(msg.value >= mintPrice * _mintAmount, "Insufficient funds!");
1309 
1310         _mintLoop(msg.sender, _mintAmount);
1311     }
1312 
1313     function firstLadyMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1314         public
1315         payable
1316         onlyAccounts
1317         mintCompliance(_mintAmount)
1318     {
1319         require(!paused, "The contract is paused!");
1320         require(preSale, "Pre sale is not active!");
1321         require(msg.value >= preSalePrice * _mintAmount, "Insufficient funds!");
1322         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1323         require(
1324             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1325             "Invalid proof!"
1326         );
1327         require(
1328             ladyBalances[msg.sender] + _mintAmount <= maxMintPerFirstLady,
1329             "Whitelist mint claims used!"
1330         );
1331 
1332         _mintLoop(msg.sender, _mintAmount);
1333     }
1334 
1335     function mintForAddress(uint256 _mintAmount, address _receiver)
1336         public
1337         mintCompliance(_mintAmount)
1338         onlyOwner
1339     {
1340         _mintLoop(_receiver, _mintAmount);
1341     }
1342 
1343     function walletOfOwner(address _owner)
1344         public
1345         view
1346         returns (uint256[] memory)
1347     {
1348         uint256 ownerTokenCount = balanceOf(_owner);
1349         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1350         uint256 currentTokenId = 1;
1351         uint256 ownedTokenIndex = 0;
1352 
1353         while (
1354             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1355         ) {
1356             address currentTokenOwner = ownerOf(currentTokenId);
1357 
1358             if (currentTokenOwner == _owner) {
1359                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1360 
1361                 ownedTokenIndex++;
1362             }
1363 
1364             currentTokenId++;
1365         }
1366 
1367         return ownedTokenIds;
1368     }
1369 
1370     function tokenURI(uint256 _tokenId)
1371         public
1372         view
1373         virtual
1374         override
1375         returns (string memory)
1376     {
1377         require(
1378             _exists(_tokenId),
1379             "ERC721Metadata: URI query for nonexistent token"
1380         );
1381 
1382         if (revealed == false) {
1383             return hiddenLadiesURI;
1384         }
1385 
1386         string memory currentBaseURI = _baseURI();
1387         return
1388             bytes(currentBaseURI).length > 0
1389                 ? string(
1390                     abi.encodePacked(
1391                         currentBaseURI,
1392                         _tokenId.toString(),
1393                         metadataExtension
1394                     )
1395                 )
1396                 : "";
1397     }
1398 
1399     // Setter functions
1400 
1401     function setMerkleRoot(bytes32 _newRoot) public onlyOwner {
1402         merkleRoot = _newRoot;
1403     }
1404 
1405     function setHiddenLadiesURI(string memory _hiddenLadiesURI)
1406         public
1407         onlyOwner
1408     {
1409         hiddenLadiesURI = _hiddenLadiesURI;
1410     }
1411 
1412     function setladiesURI(string memory _ladiesURI) public onlyOwner {
1413         ladiesURI = _ladiesURI;
1414     }
1415 
1416     function setExtension(string memory _extension) public onlyOwner {
1417         metadataExtension = _extension;
1418     }
1419 
1420     function setPaused(bool _state) public onlyOwner {
1421         paused = _state;
1422     }
1423 
1424     function setPreSale(bool _state) public onlyOwner {
1425         preSale = _state;
1426     }
1427 
1428     function setPublicSale(bool _state) public onlyOwner {
1429         publicSale = _state;
1430     }
1431 
1432     function setRevealed(bool _state) public onlyOwner {
1433         revealed = _state;
1434     }
1435 
1436     // == 
1437 
1438     function withdraw() public onlyOwner {
1439         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1440         require(os);
1441     }
1442 
1443     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1444         ladyBalances[_receiver] += _mintAmount;
1445         for (uint256 i = 0; i < _mintAmount; i++) {
1446             supply.increment();
1447             _safeMint(_receiver, supply.current());
1448         }
1449     }
1450 
1451     function _baseURI() internal view virtual override returns (string memory) {
1452         return ladiesURI;
1453     }
1454 
1455 }