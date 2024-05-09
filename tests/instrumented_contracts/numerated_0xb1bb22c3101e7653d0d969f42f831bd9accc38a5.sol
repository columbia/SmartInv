1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
47 
48 
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev These functions deal with verification of Merkle Trees proofs.
54  *
55  * The proofs can be generated using the JavaScript library
56  * https://github.com/miguelmota/merkletreejs[merkletreejs].
57  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
58  *
59  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
60  */
61 library MerkleProof {
62     /**
63      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
64      * defined by `root`. For this, a `proof` must be provided, containing
65      * sibling hashes on the branch from the leaf to the root of the tree. Each
66      * pair of leaves and each pair of pre-images are assumed to be sorted.
67      */
68     function verify(
69         bytes32[] memory proof,
70         bytes32 root,
71         bytes32 leaf
72     ) internal pure returns (bool) {
73         bytes32 computedHash = leaf;
74 
75         for (uint256 i = 0; i < proof.length; i++) {
76             bytes32 proofElement = proof[i];
77 
78             if (computedHash <= proofElement) {
79                 // Hash(current computed hash + current element of the proof)
80                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
81             } else {
82                 // Hash(current element of the proof + current computed hash)
83                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
84             }
85         }
86 
87         // Check if the computed hash (root) is equal to the provided root
88         return computedHash == root;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Strings.sol
93 
94 
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev String operations.
100  */
101 library Strings {
102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
106      */
107     function toString(uint256 value) internal pure returns (string memory) {
108         // Inspired by OraclizeAPI's implementation - MIT licence
109         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
110 
111         if (value == 0) {
112             return "0";
113         }
114         uint256 temp = value;
115         uint256 digits;
116         while (temp != 0) {
117             digits++;
118             temp /= 10;
119         }
120         bytes memory buffer = new bytes(digits);
121         while (value != 0) {
122             digits -= 1;
123             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
124             value /= 10;
125         }
126         return string(buffer);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
131      */
132     function toHexString(uint256 value) internal pure returns (string memory) {
133         if (value == 0) {
134             return "0x00";
135         }
136         uint256 temp = value;
137         uint256 length = 0;
138         while (temp != 0) {
139             length++;
140             temp >>= 8;
141         }
142         return toHexString(value, length);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
147      */
148     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
149         bytes memory buffer = new bytes(2 * length + 2);
150         buffer[0] = "0";
151         buffer[1] = "x";
152         for (uint256 i = 2 * length + 1; i > 1; --i) {
153             buffer[i] = _HEX_SYMBOLS[value & 0xf];
154             value >>= 4;
155         }
156         require(value == 0, "Strings: hex length insufficient");
157         return string(buffer);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Context.sol
162 
163 
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes calldata) {
183         return msg.data;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/access/Ownable.sol
188 
189 
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * By default, the owner account will be the one that deploys the contract. This
200  * can later be changed with {transferOwnership}.
201  *
202  * This module is used through inheritance. It will make available the modifier
203  * `onlyOwner`, which can be applied to your functions to restrict their use to
204  * the owner.
205  */
206 abstract contract Ownable is Context {
207     address private _owner;
208 
209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211     /**
212      * @dev Initializes the contract setting the deployer as the initial owner.
213      */
214     constructor() {
215         _setOwner(_msgSender());
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view virtual returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
230         _;
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public virtual onlyOwner {
241         _setOwner(address(0));
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(newOwner != address(0), "Ownable: new owner is the zero address");
250         _setOwner(newOwner);
251     }
252 
253     function _setOwner(address newOwner) private {
254         address oldOwner = _owner;
255         _owner = newOwner;
256         emit OwnershipTransferred(oldOwner, newOwner);
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @title ERC721 token receiver interface
487  * @dev Interface for any contract that wants to support safeTransfers
488  * from ERC721 asset contracts.
489  */
490 interface IERC721Receiver {
491     /**
492      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
493      * by `operator` from `from`, this function is called.
494      *
495      * It must return its Solidity selector to confirm the token transfer.
496      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
497      *
498      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
499      */
500     function onERC721Received(
501         address operator,
502         address from,
503         uint256 tokenId,
504         bytes calldata data
505     ) external returns (bytes4);
506 }
507 
508 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Interface of the ERC165 standard, as defined in the
516  * https://eips.ethereum.org/EIPS/eip-165[EIP].
517  *
518  * Implementers can declare support of contract interfaces, which can then be
519  * queried by others ({ERC165Checker}).
520  *
521  * For an implementation, see {ERC165}.
522  */
523 interface IERC165 {
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30 000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 }
534 
535 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
566 
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers `tokenId` token from `from` to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - `tokenId` must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Returns the account approved for `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Approve or remove `operator` as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The `operator` cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
710 
711 
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Enumerable is IERC721 {
721     /**
722      * @dev Returns the total amount of tokens stored by the contract.
723      */
724     function totalSupply() external view returns (uint256);
725 
726     /**
727      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
728      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
729      */
730     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
731 
732     /**
733      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
734      * Use along with {totalSupply} to enumerate all tokens.
735      */
736     function tokenByIndex(uint256 index) external view returns (uint256);
737 }
738 
739 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
740 
741 
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
748  * @dev See https://eips.ethereum.org/EIPS/eip-721
749  */
750 interface IERC721Metadata is IERC721 {
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() external view returns (string memory);
755 
756     /**
757      * @dev Returns the token collection symbol.
758      */
759     function symbol() external view returns (string memory);
760 
761     /**
762      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
763      */
764     function tokenURI(uint256 tokenId) external view returns (string memory);
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
768 
769 
770 
771 pragma solidity ^0.8.0;
772 
773 
774 
775 
776 
777 
778 
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata extension, but not including the Enumerable extension, which is available separately as
783  * {ERC721Enumerable}.
784  */
785 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
786     using Address for address;
787     using Strings for uint256;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to owner address
796     mapping(uint256 => address) private _owners;
797 
798     // Mapping owner address to token count
799     mapping(address => uint256) private _balances;
800 
801     // Mapping from token ID to approved address
802     mapping(uint256 => address) private _tokenApprovals;
803 
804     // Mapping from owner to operator approvals
805     mapping(address => mapping(address => bool)) private _operatorApprovals;
806 
807     /**
808      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
809      */
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813     }
814 
815     /**
816      * @dev See {IERC165-supportsInterface}.
817      */
818     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
819         return
820             interfaceId == type(IERC721).interfaceId ||
821             interfaceId == type(IERC721Metadata).interfaceId ||
822             super.supportsInterface(interfaceId);
823     }
824 
825     /**
826      * @dev See {IERC721-balanceOf}.
827      */
828     function balanceOf(address owner) public view virtual override returns (uint256) {
829         require(owner != address(0), "ERC721: balance query for the zero address");
830         return _balances[owner];
831     }
832 
833     /**
834      * @dev See {IERC721-ownerOf}.
835      */
836     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
837         address owner = _owners[tokenId];
838         require(owner != address(0), "ERC721: owner query for nonexistent token");
839         return owner;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return "";
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public virtual override {
879         address owner = ERC721.ownerOf(tokenId);
880         require(to != owner, "ERC721: approval to current owner");
881 
882         require(
883             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
884             "ERC721: approve caller is not owner nor approved for all"
885         );
886 
887         _approve(to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view virtual override returns (address) {
894         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public virtual override {
903         require(operator != _msgSender(), "ERC721: approve to caller");
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         //solhint-disable-next-line max-line-length
925         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
926 
927         _transfer(from, to, tokenId);
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         safeTransferFrom(from, to, tokenId, "");
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) public virtual override {
950         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
951         _safeTransfer(from, to, tokenId, _data);
952     }
953 
954     /**
955      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
956      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
957      *
958      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
959      *
960      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
961      * implement alternative mechanisms to perform token transfer, such as signature-based.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must exist and be owned by `from`.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeTransfer(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _transfer(from, to, tokenId);
979         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
980     }
981 
982     /**
983      * @dev Returns whether `tokenId` exists.
984      *
985      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
986      *
987      * Tokens start existing when they are minted (`_mint`),
988      * and stop existing when they are burned (`_burn`).
989      */
990     function _exists(uint256 tokenId) internal view virtual returns (bool) {
991         return _owners[tokenId] != address(0);
992     }
993 
994     /**
995      * @dev Returns whether `spender` is allowed to manage `tokenId`.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1002         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1003         address owner = ERC721.ownerOf(tokenId);
1004         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1005     }
1006 
1007     /**
1008      * @dev Safely mints `tokenId` and transfers it to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must not exist.
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _safeMint(address to, uint256 tokenId) internal virtual {
1018         _safeMint(to, tokenId, "");
1019     }
1020 
1021     /**
1022      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1023      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1024      */
1025     function _safeMint(
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) internal virtual {
1030         _mint(to, tokenId);
1031         require(
1032             _checkOnERC721Received(address(0), to, tokenId, _data),
1033             "ERC721: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Mints `tokenId` and transfers it to `to`.
1039      *
1040      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must not exist.
1045      * - `to` cannot be the zero address.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _mint(address to, uint256 tokenId) internal virtual {
1050         require(to != address(0), "ERC721: mint to the zero address");
1051         require(!_exists(tokenId), "ERC721: token already minted");
1052 
1053         _beforeTokenTransfer(address(0), to, tokenId);
1054 
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(address(0), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Destroys `tokenId`.
1063      * The approval is cleared when the token is burned.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _burn(uint256 tokenId) internal virtual {
1072         address owner = ERC721.ownerOf(tokenId);
1073 
1074         _beforeTokenTransfer(owner, address(0), tokenId);
1075 
1076         // Clear approvals
1077         _approve(address(0), tokenId);
1078 
1079         _balances[owner] -= 1;
1080         delete _owners[tokenId];
1081 
1082         emit Transfer(owner, address(0), tokenId);
1083     }
1084 
1085     /**
1086      * @dev Transfers `tokenId` from `from` to `to`.
1087      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must be owned by `from`.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _transfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) internal virtual {
1101         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1102         require(to != address(0), "ERC721: transfer to the zero address");
1103 
1104         _beforeTokenTransfer(from, to, tokenId);
1105 
1106         // Clear approvals from the previous owner
1107         _approve(address(0), tokenId);
1108 
1109         _balances[from] -= 1;
1110         _balances[to] += 1;
1111         _owners[tokenId] = to;
1112 
1113         emit Transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Approve `to` to operate on `tokenId`
1118      *
1119      * Emits a {Approval} event.
1120      */
1121     function _approve(address to, uint256 tokenId) internal virtual {
1122         _tokenApprovals[tokenId] = to;
1123         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128      * The call is not executed if the target address is not a contract.
1129      *
1130      * @param from address representing the previous owner of the given token ID
1131      * @param to target address that will receive the tokens
1132      * @param tokenId uint256 ID of the token to be transferred
1133      * @param _data bytes optional data to send along with the call
1134      * @return bool whether the call correctly returned the expected magic value
1135      */
1136     function _checkOnERC721Received(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) private returns (bool) {
1142         if (to.isContract()) {
1143             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1144                 return retval == IERC721Receiver.onERC721Received.selector;
1145             } catch (bytes memory reason) {
1146                 if (reason.length == 0) {
1147                     revert("ERC721: transfer to non ERC721Receiver implementer");
1148                 } else {
1149                     assembly {
1150                         revert(add(32, reason), mload(reason))
1151                     }
1152                 }
1153             }
1154         } else {
1155             return true;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before any token transfer. This includes minting
1161      * and burning.
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` will be minted for `to`.
1168      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1169      * - `from` and `to` are never both zero.
1170      *
1171      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1172      */
1173     function _beforeTokenTransfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) internal virtual {}
1178 }
1179 
1180 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1181 
1182 
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 
1188 /**
1189  * @title ERC721 Burnable Token
1190  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1191  */
1192 abstract contract ERC721Burnable is Context, ERC721 {
1193     /**
1194      * @dev Burns `tokenId`. See {ERC721-_burn}.
1195      *
1196      * Requirements:
1197      *
1198      * - The caller must own `tokenId` or be an approved operator.
1199      */
1200     function burn(uint256 tokenId) public virtual {
1201         //solhint-disable-next-line max-line-length
1202         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1203         _burn(tokenId);
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1208 
1209 
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 
1214 
1215 /**
1216  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1217  * enumerability of all the token ids in the contract as well as all token ids owned by each
1218  * account.
1219  */
1220 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1221     // Mapping from owner to list of owned token IDs
1222     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1223 
1224     // Mapping from token ID to index of the owner tokens list
1225     mapping(uint256 => uint256) private _ownedTokensIndex;
1226 
1227     // Array with all token ids, used for enumeration
1228     uint256[] private _allTokens;
1229 
1230     // Mapping from token id to position in the allTokens array
1231     mapping(uint256 => uint256) private _allTokensIndex;
1232 
1233     /**
1234      * @dev See {IERC165-supportsInterface}.
1235      */
1236     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1237         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1242      */
1243     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1244         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1245         return _ownedTokens[owner][index];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Enumerable-totalSupply}.
1250      */
1251     function totalSupply() public view virtual override returns (uint256) {
1252         return _allTokens.length;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-tokenByIndex}.
1257      */
1258     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1259         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1260         return _allTokens[index];
1261     }
1262 
1263     /**
1264      * @dev Hook that is called before any token transfer. This includes minting
1265      * and burning.
1266      *
1267      * Calling conditions:
1268      *
1269      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1270      * transferred to `to`.
1271      * - When `from` is zero, `tokenId` will be minted for `to`.
1272      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1273      * - `from` cannot be the zero address.
1274      * - `to` cannot be the zero address.
1275      *
1276      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1277      */
1278     function _beforeTokenTransfer(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) internal virtual override {
1283         super._beforeTokenTransfer(from, to, tokenId);
1284 
1285         if (from == address(0)) {
1286             _addTokenToAllTokensEnumeration(tokenId);
1287         } else if (from != to) {
1288             _removeTokenFromOwnerEnumeration(from, tokenId);
1289         }
1290         if (to == address(0)) {
1291             _removeTokenFromAllTokensEnumeration(tokenId);
1292         } else if (to != from) {
1293             _addTokenToOwnerEnumeration(to, tokenId);
1294         }
1295     }
1296 
1297     /**
1298      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1299      * @param to address representing the new owner of the given token ID
1300      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1301      */
1302     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1303         uint256 length = ERC721.balanceOf(to);
1304         _ownedTokens[to][length] = tokenId;
1305         _ownedTokensIndex[tokenId] = length;
1306     }
1307 
1308     /**
1309      * @dev Private function to add a token to this extension's token tracking data structures.
1310      * @param tokenId uint256 ID of the token to be added to the tokens list
1311      */
1312     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1313         _allTokensIndex[tokenId] = _allTokens.length;
1314         _allTokens.push(tokenId);
1315     }
1316 
1317     /**
1318      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1319      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1320      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1321      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1322      * @param from address representing the previous owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1324      */
1325     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1326         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1327         // then delete the last slot (swap and pop).
1328 
1329         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1330         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1331 
1332         // When the token to delete is the last token, the swap operation is unnecessary
1333         if (tokenIndex != lastTokenIndex) {
1334             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1335 
1336             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1337             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1338         }
1339 
1340         // This also deletes the contents at the last position of the array
1341         delete _ownedTokensIndex[tokenId];
1342         delete _ownedTokens[from][lastTokenIndex];
1343     }
1344 
1345     /**
1346      * @dev Private function to remove a token from this extension's token tracking data structures.
1347      * This has O(1) time complexity, but alters the order of the _allTokens array.
1348      * @param tokenId uint256 ID of the token to be removed from the tokens list
1349      */
1350     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1351         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1352         // then delete the last slot (swap and pop).
1353 
1354         uint256 lastTokenIndex = _allTokens.length - 1;
1355         uint256 tokenIndex = _allTokensIndex[tokenId];
1356 
1357         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1358         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1359         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1360         uint256 lastTokenId = _allTokens[lastTokenIndex];
1361 
1362         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1363         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1364 
1365         // This also deletes the contents at the last position of the array
1366         delete _allTokensIndex[tokenId];
1367         _allTokens.pop();
1368     }
1369 }
1370 
1371 // File: contracts/KitPics.sol
1372 
1373 
1374 
1375 pragma solidity ^0.8.0;
1376 
1377 
1378 
1379 
1380 
1381 
1382 contract KitPics is Ownable, ERC721Enumerable, ERC721Burnable {
1383     using Counters for Counters.Counter;
1384 
1385     event Mint(address indexed owner, uint256 indexed tokenId);
1386 
1387     Counters.Counter public _tokenIdTracker;
1388 
1389     bytes32 immutable public root;
1390 
1391     uint256 public maxTokens = 5555;
1392     uint256 public constant MINT_FEE = 6 * 10**16;
1393     uint256 public constant MAX_MINT_COUNT = 25;
1394     string private _baseTokenURI = "https://kitpics.art/kits/";
1395 
1396     bool public mintEnabled = false; // open minting in general
1397     bool public whitelistMintEnabled = false; // open minting just for whitelist
1398     bool public whitelistRemoved = false; // to be used if a while after mint there are still unclaimed whitelist slots
1399 
1400     constructor(bytes32 merkleroot, uint256 whitelistSize, uint256 _maxTokens) ERC721("KitPics", "KIT") {
1401         root = merkleroot;
1402         _tokenIdTracker._value = whitelistSize + 9; // first N are reserved for whitelist, 9 airdrops
1403         maxTokens = _maxTokens; // 5555, just input easier for testing
1404 
1405         // airdrop mints
1406         _safeMint(0x2488B49Db678a9598A232bF56a90433993F522c5, 0); // canti
1407         _safeMint(0xc32c9d183CF89f4746F000797542f46F6aa8Cd1d, 1); // grug
1408         _safeMint(0xc80824E1A48cFAc44851048B2De463784b0a42Bd, 2); // panckaes
1409         _safeMint(0x8794d984e0AB8A967347290D931baEFba450075a, 3); // big d
1410         _safeMint(0x6240CD386f5b47C793F321327c3dc6C7856b25A0, 4); // smylbot
1411         _safeMint(0x24c306eaF8631F783d83CF837967b31c100B8358, 5); // hux
1412         _safeMint(0x92e9b91AA2171694d740E7066F787739CA1Af9De, 6); // ti
1413         _safeMint(0x12918F13ce746dA4Cf486B907a93CfFAdbbF9A96, 7); // ippo
1414         _safeMint(0x85B6594d35a12e534e8346a1A9087BCb26b622Ed, 8); // pete
1415     }
1416 
1417     function _baseURI() internal view virtual override returns (string memory) {
1418         return _baseTokenURI;
1419     }
1420 
1421     function setBaseURI(string memory baseURI) public onlyOwner {
1422         _baseTokenURI = baseURI;
1423     }
1424 
1425     function mint(uint256 _count) public payable {
1426         uint256 nextId = _tokenIdTracker.current();
1427         require(_count <= MAX_MINT_COUNT, "Cannot mint more than max per transaction");
1428         require(nextId + _count <= maxTokens, "Supply limit reached");
1429         require(msg.value >= MINT_FEE * _count, "Price not met");
1430         require(mintEnabled, "Mint must be enabled");
1431 
1432         for (uint256 i = 0; i < _count; i++) {
1433             _mintSingle();
1434         }
1435     }
1436 
1437     function _mintSingle() private {
1438         uint256 nextId = _tokenIdTracker.current();
1439         _safeMint(msg.sender, nextId);
1440         emit Mint(msg.sender, nextId);
1441         _tokenIdTracker.increment();
1442     }
1443 
1444     function whitelistMint(address account, uint256 tokenId, bytes32[] calldata proof) public payable {
1445         require(whitelistMintEnabled, "Whitelist mint must be enabled");
1446         if (!whitelistRemoved) {
1447             require(_verify(_leaf(account, tokenId), proof), "Invalid merkle proof");
1448         }
1449         require(msg.value >= MINT_FEE, "Price not met");
1450         _safeMint(account, tokenId);
1451         emit Mint(account, tokenId);
1452     }
1453 
1454     function _leaf(address account, uint256 tokenId) internal pure returns (bytes32) {
1455         return keccak256(abi.encodePacked(tokenId, account));
1456     }
1457 
1458     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1459         return MerkleProof.verify(proof, root, leaf);
1460     }
1461 
1462     function withdraw() public onlyOwner {
1463         (bool success, ) = owner().call{value: address(this).balance}("");
1464         require(success, "Transfer failed.");
1465     }
1466 
1467     function toggleMint() public onlyOwner {
1468         mintEnabled = !mintEnabled;
1469     }
1470 
1471     function toggleWhitelistMint() public onlyOwner {
1472         whitelistMintEnabled = !whitelistMintEnabled;
1473     }
1474 
1475     function toggleWhitelistRemoved() public onlyOwner {
1476         whitelistRemoved = !whitelistRemoved;
1477     }
1478 
1479     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1480         super._beforeTokenTransfer(from, to, tokenId);
1481     }
1482 
1483     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1484         return super.supportsInterface(interfaceId);
1485     }
1486 }