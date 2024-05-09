1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _setOwner(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _setOwner(newOwner);
82     }
83 
84     function _setOwner(address newOwner) private {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-165[EIP].
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others ({ERC165Checker}).
97  *
98  * For an implementation, see {ERC165}.
99  */
100 interface IERC165 {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 
113 /**
114  * @dev Implementation of the {IERC165} interface.
115  *
116  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
117  * for the additional interface id that will be supported. For example:
118  *
119  * ```solidity
120  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
121  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
122  * }
123  * ```
124  *
125  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
126  */
127 abstract contract ERC165 is IERC165 {
128     /**
129      * @dev See {IERC165-supportsInterface}.
130      */
131     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
132         return interfaceId == type(IERC165).interfaceId;
133     }
134 }
135 
136 /**
137  * @title ERC721 token receiver interface
138  * @dev Interface for any contract that wants to support safeTransfers
139  * from ERC721 asset contracts.
140  */
141 interface IERC721Receiver {
142     /**
143      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
144      * by `operator` from `from`, this function is called.
145      *
146      * It must return its Solidity selector to confirm the token transfer.
147      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
148      *
149      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
150      */
151     function onERC721Received(
152         address operator,
153         address from,
154         uint256 tokenId,
155         bytes calldata data
156     ) external returns (bytes4);
157 }
158 
159 /**
160  * @dev Required interface of an ERC721 compliant contract.
161  */
162 interface IERC721 is IERC165 {
163     /**
164      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
167 
168     /**
169      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
170      */
171     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
172 
173     /**
174      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
175      */
176     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
177 
178     /**
179      * @dev Returns the number of tokens in ``owner``'s account.
180      */
181     function balanceOf(address owner) external view returns (uint256 balance);
182 
183     /**
184      * @dev Returns the owner of the `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function ownerOf(uint256 tokenId) external view returns (address owner);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
194      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Transfers `tokenId` token from `from` to `to`.
214      *
215      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
234      * The approval is cleared when the token is transferred.
235      *
236      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
237      *
238      * Requirements:
239      *
240      * - The caller must own the token or be an approved operator.
241      * - `tokenId` must exist.
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address to, uint256 tokenId) external;
246 
247     /**
248      * @dev Returns the account approved for `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function getApproved(uint256 tokenId) external view returns (address operator);
255 
256     /**
257      * @dev Approve or remove `operator` as an operator for the caller.
258      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
259      *
260      * Requirements:
261      *
262      * - The `operator` cannot be the caller.
263      *
264      * Emits an {ApprovalForAll} event.
265      */
266     function setApprovalForAll(address operator, bool _approved) external;
267 
268     /**
269      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
270      *
271      * See {setApprovalForAll}
272      */
273     function isApprovedForAll(address owner, address operator) external view returns (bool);
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId,
292         bytes calldata data
293     ) external;
294 }
295 
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
299  * @dev See https://eips.ethereum.org/EIPS/eip-721
300  */
301 interface IERC721Metadata is IERC721 {
302     /**
303      * @dev Returns the token collection name.
304      */
305     function name() external view returns (string memory);
306 
307     /**
308      * @dev Returns the token collection symbol.
309      */
310     function symbol() external view returns (string memory);
311 
312     /**
313      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
314      */
315     function tokenURI(uint256 tokenId) external view returns (string memory);
316 }
317 
318 /**
319  * @dev Contract module which allows children to implement an emergency stop
320  * mechanism that can be triggered by an authorized account.
321  *
322  * This module is used through inheritance. It will make available the
323  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
324  * the functions of your contract. Note that they will not be pausable by
325  * simply including this module, only once the modifiers are put in place.
326  */
327 abstract contract Pausable is Context {
328     /**
329      * @dev Emitted when the pause is triggered by `account`.
330      */
331     event Paused(address account);
332 
333     /**
334      * @dev Emitted when the pause is lifted by `account`.
335      */
336     event Unpaused(address account);
337 
338     bool private _paused;
339 
340     /**
341      * @dev Initializes the contract in unpaused state.
342      */
343     constructor() {
344         _paused = true;
345     }
346 
347     /**
348      * @dev Returns true if the contract is paused, and false otherwise.
349      */
350     function paused() public view virtual returns (bool) {
351         return _paused;
352     }
353 
354     /**
355      * @dev Modifier to make a function callable only when the contract is not paused.
356      *
357      * Requirements:
358      *
359      * - The contract must not be paused.
360      */
361     modifier whenNotPaused() {
362         require(!paused(), "Pausable: paused");
363         _;
364     }
365 
366     /**
367      * @dev Modifier to make a function callable only when the contract is paused.
368      *
369      * Requirements:
370      *
371      * - The contract must be paused.
372      */
373     modifier whenPaused() {
374         require(paused(), "Pausable: not paused");
375         _;
376     }
377 
378     /**
379      * @dev Triggers stopped state.
380      *
381      * Requirements:
382      *
383      * - The contract must not be paused.
384      */
385     function _pause() internal virtual whenNotPaused {
386         _paused = true;
387         emit Paused(_msgSender());
388     }
389 
390     /**
391      * @dev Returns to normal state.
392      *
393      * Requirements:
394      *
395      * - The contract must be paused.
396      */
397     function _unpause() internal virtual whenPaused {
398         _paused = false;
399         emit Unpaused(_msgSender());
400     }
401 }
402 
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         assembly {
432             size := extcodesize(account)
433         }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         require(isContract(target), "Address: call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(isContract(target), "Address: delegate call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
590      * revert reason using the provided one.
591      *
592      * _Available since v4.3._
593      */
594     function verifyCallResult(
595         bool success,
596         bytes memory returndata,
597         string memory errorMessage
598     ) internal pure returns (bytes memory) {
599         if (success) {
600             return returndata;
601         } else {
602             // Look for revert reason and bubble it up if present
603             if (returndata.length > 0) {
604                 // The easiest way to bubble the revert reason is using memory via assembly
605 
606                 assembly {
607                     let returndata_size := mload(returndata)
608                     revert(add(32, returndata), returndata_size)
609                 }
610             } else {
611                 revert(errorMessage);
612             }
613         }
614     }
615 }
616 
617 
618 /**
619  * @dev String operations.
620  */
621 library Strings {
622     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
626      */
627     function toString(uint256 value) internal pure returns (string memory) {
628         // Inspired by OraclizeAPI's implementation - MIT licence
629         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
630 
631         if (value == 0) {
632             return "0";
633         }
634         uint256 temp = value;
635         uint256 digits;
636         while (temp != 0) {
637             digits++;
638             temp /= 10;
639         }
640         bytes memory buffer = new bytes(digits);
641         while (value != 0) {
642             digits -= 1;
643             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
644             value /= 10;
645         }
646         return string(buffer);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
651      */
652     function toHexString(uint256 value) internal pure returns (string memory) {
653         if (value == 0) {
654             return "0x00";
655         }
656         uint256 temp = value;
657         uint256 length = 0;
658         while (temp != 0) {
659             length++;
660             temp >>= 8;
661         }
662         return toHexString(value, length);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
667      */
668     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
669         bytes memory buffer = new bytes(2 * length + 2);
670         buffer[0] = "0";
671         buffer[1] = "x";
672         for (uint256 i = 2 * length + 1; i > 1; --i) {
673             buffer[i] = _HEX_SYMBOLS[value & 0xf];
674             value >>= 4;
675         }
676         require(value == 0, "Strings: hex length insufficient");
677         return string(buffer);
678     }
679 }
680 
681 
682 /**
683  * @dev These functions deal with verification of Merkle Trees proofs.
684  *
685  * The proofs can be generated using the JavaScript library
686  * https://github.com/miguelmota/merkletreejs[merkletreejs].
687  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
688  *
689  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
690  */
691 library MerkleProof {
692     /**
693      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
694      * defined by `root`. For this, a `proof` must be provided, containing
695      * sibling hashes on the branch from the leaf to the root of the tree. Each
696      * pair of leaves and each pair of pre-images are assumed to be sorted.
697      */
698     function verify(
699         bytes32[] memory proof,
700         bytes32 root,
701         bytes32 leaf
702     ) internal pure returns (bool) {
703         bytes32 computedHash = leaf;
704 
705         for (uint256 i = 0; i < proof.length; i++) {
706             bytes32 proofElement = proof[i];
707 
708             if (computedHash <= proofElement) {
709                 // Hash(current computed hash + current element of the proof)
710                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
711             } else {
712                 // Hash(current element of the proof + current computed hash)
713                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
714             }
715         }
716 
717         // Check if the computed hash (root) is equal to the provided root
718         return computedHash == root;
719     }
720 }
721 
722 /**
723  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
724  * the Metadata extension, but not including the Enumerable extension, which is available separately as
725  * {ERC721Enumerable}.
726  */
727 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
728     using Address for address;
729     using Strings for uint256;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to owner address
738     mapping(uint256 => address) private _owners;
739 
740     // Mapping owner address to token count
741     mapping(address => uint256) private _balances;
742 
743     // Mapping from token ID to approved address
744     mapping(uint256 => address) private _tokenApprovals;
745 
746     // Mapping from owner to operator approvals
747     mapping(address => mapping(address => bool)) private _operatorApprovals;
748 
749     /**
750      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
751      */
752     constructor(string memory name_, string memory symbol_) {
753         _name = name_;
754         _symbol = symbol_;
755     }
756 
757     /**
758      * @dev See {IERC165-supportsInterface}.
759      */
760     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
761         return
762             interfaceId == type(IERC721).interfaceId ||
763             interfaceId == type(IERC721Metadata).interfaceId ||
764             super.supportsInterface(interfaceId);
765     }
766 
767     /**
768      * @dev See {IERC721-balanceOf}.
769      */
770     function balanceOf(address owner) public view virtual override returns (uint256) {
771         require(owner != address(0), "ERC721: balance query for the zero address");
772         return _balances[owner];
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
779         address owner = _owners[tokenId];
780         require(owner != address(0), "ERC721: owner query for nonexistent token");
781         return owner;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
806     }
807 
808     /**
809      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811      * by default, can be overriden in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return "";
815     }
816 
817     /**
818      * @dev See {IERC721-approve}.
819      */
820     function approve(address to, uint256 tokenId) public virtual override {
821         address owner = ERC721.ownerOf(tokenId);
822         require(to != owner, "ERC721: approval to current owner");
823 
824         require(
825             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
826             "ERC721: approve caller is not owner nor approved for all"
827         );
828 
829         _approve(to, tokenId);
830     }
831 
832     /**
833      * @dev See {IERC721-getApproved}.
834      */
835     function getApproved(uint256 tokenId) public view virtual override returns (address) {
836         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
837 
838         return _tokenApprovals[tokenId];
839     }
840 
841     /**
842      * @dev See {IERC721-setApprovalForAll}.
843      */
844     function setApprovalForAll(address operator, bool approved) public virtual override {
845         require(operator != _msgSender(), "ERC721: approve to caller");
846 
847         _operatorApprovals[_msgSender()][operator] = approved;
848         emit ApprovalForAll(_msgSender(), operator, approved);
849     }
850 
851     /**
852      * @dev See {IERC721-isApprovedForAll}.
853      */
854     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
855         return _operatorApprovals[owner][operator];
856     }
857 
858     /**
859      * @dev See {IERC721-transferFrom}.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         //solhint-disable-next-line max-line-length
867         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
868 
869         _transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         safeTransferFrom(from, to, tokenId, "");
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) public virtual override {
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
893         _safeTransfer(from, to, tokenId, _data);
894     }
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
899      *
900      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
901      *
902      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
903      * implement alternative mechanisms to perform token transfer, such as signature-based.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeTransfer(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _transfer(from, to, tokenId);
921         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
922     }
923 
924     /**
925      * @dev Returns whether `tokenId` exists.
926      *
927      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
928      *
929      * Tokens start existing when they are minted (`_mint`),
930      * and stop existing when they are burned (`_burn`).
931      */
932     function _exists(uint256 tokenId) internal view virtual returns (bool) {
933         return _owners[tokenId] != address(0);
934     }
935 
936     /**
937      * @dev Returns whether `spender` is allowed to manage `tokenId`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must exist.
942      */
943     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
944         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
945         address owner = ERC721.ownerOf(tokenId);
946         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
947     }
948 
949     /**
950      * @dev Safely mints `tokenId` and transfers it to `to`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(address to, uint256 tokenId) internal virtual {
960         _safeMint(to, tokenId, "");
961     }
962 
963     /**
964      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
965      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
966      */
967     function _safeMint(
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) internal virtual {
972         _mint(to, tokenId);
973         require(
974             _checkOnERC721Received(address(0), to, tokenId, _data),
975             "ERC721: transfer to non ERC721Receiver implementer"
976         );
977     }
978 
979     /**
980      * @dev Mints `tokenId` and transfers it to `to`.
981      *
982      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - `to` cannot be the zero address.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _mint(address to, uint256 tokenId) internal virtual {
992         require(to != address(0), "ERC721: mint to the zero address");
993         require(!_exists(tokenId), "ERC721: token already minted");
994 
995         _beforeTokenTransfer(address(0), to, tokenId);
996 
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(address(0), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         address owner = ERC721.ownerOf(tokenId);
1015 
1016         _beforeTokenTransfer(owner, address(0), tokenId);
1017 
1018         // Clear approvals
1019         _approve(address(0), tokenId);
1020 
1021         _balances[owner] -= 1;
1022         delete _owners[tokenId];
1023 
1024         emit Transfer(owner, address(0), tokenId);
1025     }
1026 
1027     /**
1028      * @dev Transfers `tokenId` from `from` to `to`.
1029      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _transfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {
1043         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1044         require(to != address(0), "ERC721: transfer to the zero address");
1045 
1046         _beforeTokenTransfer(from, to, tokenId);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId);
1050 
1051         _balances[from] -= 1;
1052         _balances[to] += 1;
1053         _owners[tokenId] = to;
1054 
1055         emit Transfer(from, to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Approve `to` to operate on `tokenId`
1060      *
1061      * Emits a {Approval} event.
1062      */
1063     function _approve(address to, uint256 tokenId) internal virtual {
1064         _tokenApprovals[tokenId] = to;
1065         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1070      * The call is not executed if the target address is not a contract.
1071      *
1072      * @param from address representing the previous owner of the given token ID
1073      * @param to target address that will receive the tokens
1074      * @param tokenId uint256 ID of the token to be transferred
1075      * @param _data bytes optional data to send along with the call
1076      * @return bool whether the call correctly returned the expected magic value
1077      */
1078     function _checkOnERC721Received(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) private returns (bool) {
1084         if (to.isContract()) {
1085             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1086                 return retval == IERC721Receiver.onERC721Received.selector;
1087             } catch (bytes memory reason) {
1088                 if (reason.length == 0) {
1089                     revert("ERC721: transfer to non ERC721Receiver implementer");
1090                 } else {
1091                     assembly {
1092                         revert(add(32, reason), mload(reason))
1093                     }
1094                 }
1095             }
1096         } else {
1097             return true;
1098         }
1099     }
1100 
1101     /**
1102      * @dev Hook that is called before any token transfer. This includes minting
1103      * and burning.
1104      *
1105      * Calling conditions:
1106      *
1107      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1108      * transferred to `to`.
1109      * - When `from` is zero, `tokenId` will be minted for `to`.
1110      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1111      * - `from` and `to` are never both zero.
1112      *
1113      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1114      */
1115     function _beforeTokenTransfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) internal virtual {}
1120 }
1121 
1122 /**
1123  * @title ERC721 Burnable Token
1124  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1125  */
1126 abstract contract ERC721Burnable is Context, ERC721 {
1127     /**
1128      * @dev Burns `tokenId`. See {ERC721-_burn}.
1129      *
1130      * Requirements:
1131      *
1132      * - The caller must own `tokenId` or be an approved operator.
1133      */
1134     function burn(uint256 tokenId) public virtual {
1135         //solhint-disable-next-line max-line-length
1136         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1137         _burn(tokenId);
1138     }
1139 }
1140 
1141 /**
1142  * @dev ERC721 token with pausable token transfers, minting and burning.
1143  *
1144  * Useful for scenarios such as preventing trades until the end of an evaluation
1145  * period, or having an emergency switch for freezing all token transfers in the
1146  * event of a large bug.
1147  */
1148 abstract contract ERC721Pausable is ERC721, Pausable {
1149     /**
1150      * @dev See {ERC721-_beforeTokenTransfer}.
1151      *
1152      * Requirements:
1153      *
1154      * - the contract must not be paused.
1155      */
1156     function _beforeTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual override {
1161         super._beforeTokenTransfer(from, to, tokenId);
1162 
1163         require(!paused(), "ERC721Pausable: token transfer while paused");
1164     }
1165 }
1166 
1167 contract InuNFT is ERC721, Ownable, ERC721Burnable, ERC721Pausable {
1168     uint256 private _tokenIdTracker;
1169 
1170     uint256 public constant MAX_ELEMENTS = 1000;
1171     uint256 public constant PRESALE_ELEMENTS = 900;
1172     uint256 public constant PRICE = 0.08 ether;
1173     uint256 public constant PRICE2 = 0.08 ether;
1174     uint256 public constant MAX_BY_MINT = 5;
1175     uint256 public constant tierOneMaxMint = 1;
1176     uint256 public constant tierTwoMaxMint = 2;
1177     uint256 public constant tierThreeMaxMint = 3;
1178     
1179     string public baseTokenURI;
1180 
1181     address public withdrawAddress;
1182 
1183     bytes32 public tierOneMerkleRoot;
1184     bytes32 public tierTwoMerkleRoot;
1185     bytes32 public tierThreeMerkleRoot;
1186 
1187     mapping(address => uint256) public whitelistClaimed;
1188 
1189     bool public publicSaleOpen;
1190     bool public tier2Start = false;
1191 
1192     event CreateItem(uint256 indexed id);
1193     constructor()
1194     ERC721("THE INU NFT", "InuNFT") 
1195     {
1196         pause(false);
1197         setWithdrawAddress(_msgSender());
1198         _mintAnElement(msg.sender);
1199     }
1200 
1201     modifier saleIsOpen {
1202         require(_tokenIdTracker <= MAX_ELEMENTS, "Sale end");
1203         if (_msgSender() != owner()) {
1204             require(!paused(), "Pausable: paused");
1205         }
1206         _;
1207     }
1208 
1209     modifier noContract() {
1210         address account = msg.sender;
1211         require(account == tx.origin, "Caller is a contract");
1212         require(account.code.length == 0, "Caller is a contract");
1213         _;
1214     }
1215 
1216     function totalSupply() public view returns (uint256) {
1217         return _tokenIdTracker;
1218     }
1219 
1220     function setPublicSale(bool val) public onlyOwner {
1221         publicSaleOpen = val;
1222     }
1223 
1224     function mint(uint256 _count) public payable saleIsOpen noContract {
1225         uint256 total = totalSupply();
1226         require(publicSaleOpen, "Public sale not open yet");
1227         require(total + _count <= MAX_ELEMENTS, "Max limit");
1228         require(_count <= MAX_BY_MINT, "Exceeds number");
1229         require(msg.value == PRICE2 * _count, "Value is over or under price.");
1230 
1231         for (uint256 i = 0; i < _count; i++) {
1232             _mintAnElement(msg.sender);
1233         }
1234     }
1235 
1236     function setPresaleStart(bool flag) external onlyOwner {
1237         tier2Start = flag;
1238     }
1239 
1240 
1241     function presaleMint(uint256 _count, bytes32[] calldata _proof, uint256 amount, uint256 _tier) public payable saleIsOpen noContract {
1242         uint256 total = totalSupply();
1243         require(_tier == 1 || _tier == 2, "only presale mint");
1244         if (_tier == 2) {
1245             require(tier2Start == true, "presale not start");
1246             require(msg.value == PRICE * _count, "Value is over or under price.");
1247         }
1248         require(total + _count <= PRESALE_ELEMENTS, "Max limit");
1249         require(verifySender(_proof, amount, _tier), "Sender is not whitelisted");
1250         require(canMintAmount(_count, _tier), "Sender max presale mint amount already met");
1251 
1252         whitelistClaimed[msg.sender] += _count;
1253         for (uint256 i = 0; i < _count; i++) {
1254             _mintAnElement(msg.sender);
1255         }
1256     }
1257 
1258     function ownerMint(uint256 _count, address addr) public onlyOwner {
1259         uint256 total = totalSupply();
1260         require(total + _count <= MAX_ELEMENTS, "Sale end");
1261 
1262         for (uint256 i = 0; i < _count; i++) {
1263             _mintAnElement(addr);
1264         }
1265 
1266     }
1267 
1268     function _mintAnElement(address _to) private {
1269         uint id = totalSupply();
1270         _tokenIdTracker += 1;
1271         _mint(_to, id);
1272         emit CreateItem(id);
1273     }
1274 
1275     function canMintAmount(uint256 _count, uint256 _tier) public view returns (bool) {
1276         uint256 maxMintAmount;
1277 
1278         if (_tier == 1) {
1279             maxMintAmount = tierOneMaxMint;
1280         } else if (_tier == 2) {
1281             maxMintAmount = tierTwoMaxMint;
1282         } else if (_tier == 3) {
1283             maxMintAmount = tierThreeMaxMint;
1284         }
1285 
1286         return whitelistClaimed[msg.sender] + _count <= maxMintAmount;
1287     }
1288 
1289     function setWhitelistMerkleRoot(bytes32 _merkleRoot, uint256 _tier) external onlyOwner {
1290         require(_tierExists(_tier), "Tier does not exist");
1291 
1292         if (_tier == 1) {
1293             tierOneMerkleRoot = _merkleRoot;
1294         } else if (_tier == 2) {
1295             tierTwoMerkleRoot = _merkleRoot;
1296         } else if (_tier == 3) {
1297             tierThreeMerkleRoot = _merkleRoot;
1298         }
1299     }
1300 
1301     function _tierExists(uint256 _tier) private pure returns (bool) {
1302         return _tier <= 3;
1303     }
1304 
1305     function verifySender(bytes32[] calldata proof, uint256 amount, uint256 _tier) public view returns (bool) {
1306         return _verify(proof, keccak256(abi.encodePacked(msg.sender, amount)), _tier);
1307     }
1308 
1309     function _verify(bytes32[] calldata proof, bytes32 addressHash, uint256 _tier) internal view returns (bool) {
1310         bytes32 whitelistMerkleRoot;
1311 
1312         if (_tier == 1) {
1313             whitelistMerkleRoot = tierOneMerkleRoot;
1314         } else if (_tier == 2) {
1315             whitelistMerkleRoot = tierTwoMerkleRoot;
1316         } else if (_tier == 3) {
1317             whitelistMerkleRoot = tierThreeMerkleRoot;
1318         }
1319 
1320         return MerkleProof.verify(proof, whitelistMerkleRoot, addressHash);
1321     }
1322 
1323     function _hash(address _address) internal pure returns (bytes32) {
1324         return keccak256(abi.encodePacked(_address));
1325     }
1326 
1327     function _baseURI() internal view virtual override returns (string memory) {
1328         return baseTokenURI;
1329     }
1330 
1331     function setBaseURI(string memory baseURI) public onlyOwner {
1332         baseTokenURI = baseURI;
1333     }
1334 
1335     function pause(bool val) public onlyOwner {
1336         if (val == true) {
1337             _pause();
1338             return;
1339         }
1340         _unpause();
1341     }
1342 
1343     function withdrawAll() public onlyOwner {
1344         uint256 balance = address(this).balance;
1345         require(balance > 0);
1346         _withdraw(withdrawAddress, balance);
1347     }
1348 
1349     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
1350         withdrawAddress = _withdrawAddress;
1351     }
1352 
1353     function _withdraw(address _address, uint256 _amount) private {
1354         (bool success, ) = _address.call{value: _amount}("");
1355         require(success, "Transfer failed.");
1356     }
1357 
1358     function _beforeTokenTransfer(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) internal virtual override(ERC721, ERC721Pausable) {
1363         super._beforeTokenTransfer(from, to, tokenId);
1364     }
1365 
1366     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1367         return super.supportsInterface(interfaceId);
1368     }
1369     
1370 }