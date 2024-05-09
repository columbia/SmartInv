1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ####################################################################################
5 #######################  #################################  ########################
6 #########################     ######################     ###########################
7 ############################    ##################    ##############################
8 #############################    ###############    ################################
9 #############################    ###############    ################################
10 ############################      #############      ###############################
11 ############################      #############      ###############################
12 ############################                         ###############################
13 ##############################                     #################################
14 ######################################     #########################################
15 #####################################       ########################################
16 ###################################           ######################################
17 ###############################    C r y p t o     ##################################
18 ############################         B u l l         ###############################
19 ##########################          B a l l s          #############################
20 ########################                                 ###########################
21 #########################               #               ############################
22 ##########################             ###             #############################
23 ###########################        ###########        ##############################
24 ####################################################################################
25 ####################################################################################
26 ####################################################################################
27 
28 //Smart contract by ScecarelloGuy
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
42      */
43     function toString(uint256 value) internal pure returns (string memory) {
44         // Inspired by OraclizeAPI's implementation - MIT licence
45         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Context.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 // File: @openzeppelin/contracts/access/Ownable.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Contract module which provides a basic access control mechanism, where
134  * there is an account (an owner) that can be granted exclusive access to
135  * specific functions.
136  *
137  * By default, the owner account will be the one that deploys the contract. This
138  * can later be changed with {transferOwnership}.
139  *
140  * This module is used through inheritance. It will make available the modifier
141  * `onlyOwner`, which can be applied to your functions to restrict their use to
142  * the owner.
143  */
144 abstract contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149     /**
150      * @dev Initializes the contract setting the deployer as the initial owner.
151      */
152     constructor() {
153         _transferOwnership(_msgSender());
154     }
155 
156     /**
157      * @dev Returns the address of the current owner.
158      */
159     function owner() public view virtual returns (address) {
160         return _owner;
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         require(owner() == _msgSender(), "Ownable: caller is not the owner");
168         _;
169     }
170 
171     /**
172      * @dev Leaves the contract without owner. It will not be possible to call
173      * `onlyOwner` functions anymore. Can only be called by the current owner.
174      *
175      * NOTE: Renouncing ownership will leave the contract without an owner,
176      * thereby removing any functionality that is only available to the owner.
177      */
178     function renounceOwnership() public virtual onlyOwner {
179         _transferOwnership(address(0));
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public virtual onlyOwner {
187         require(newOwner != address(0), "Ownable: new owner is the zero address");
188         _transferOwnership(newOwner);
189     }
190 
191     /**
192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
193      * Internal function without access restriction.
194      */
195     function _transferOwnership(address newOwner) internal virtual {
196         address oldOwner = _owner;
197         _owner = newOwner;
198         emit OwnershipTransferred(oldOwner, newOwner);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Address.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @title ERC721 token receiver interface
431  * @dev Interface for any contract that wants to support safeTransfers
432  * from ERC721 asset contracts.
433  */
434 interface IERC721Receiver {
435     /**
436      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
437      * by `operator` from `from`, this function is called.
438      *
439      * It must return its Solidity selector to confirm the token transfer.
440      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
441      *
442      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
443      */
444     function onERC721Received(
445         address operator,
446         address from,
447         uint256 tokenId,
448         bytes calldata data
449     ) external returns (bytes4);
450 }
451 
452 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Interface of the ERC165 standard, as defined in the
461  * https://eips.ethereum.org/EIPS/eip-165[EIP].
462  *
463  * Implementers can declare support of contract interfaces, which can then be
464  * queried by others ({ERC165Checker}).
465  *
466  * For an implementation, see {ERC165}.
467  */
468 interface IERC165 {
469     /**
470      * @dev Returns true if this contract implements the interface defined by
471      * `interfaceId`. See the corresponding
472      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
473      * to learn more about how these ids are created.
474      *
475      * This function call must use less than 30 000 gas.
476      */
477     function supportsInterface(bytes4 interfaceId) external view returns (bool);
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Implementation of the {IERC165} interface.
490  *
491  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
492  * for the additional interface id that will be supported. For example:
493  *
494  * ```solidity
495  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
497  * }
498  * ```
499  *
500  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
501  */
502 abstract contract ERC165 is IERC165 {
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         return interfaceId == type(IERC165).interfaceId;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Required interface of an ERC721 compliant contract.
521  */
522 interface IERC721 is IERC165 {
523     /**
524      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
525      */
526     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
527 
528     /**
529      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
530      */
531     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
535      */
536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
537 
538     /**
539      * @dev Returns the number of tokens in ``owner``'s account.
540      */
541     function balanceOf(address owner) external view returns (uint256 balance);
542 
543     /**
544      * @dev Returns the owner of the `tokenId` token.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      */
550     function ownerOf(uint256 tokenId) external view returns (address owner);
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Transfers `tokenId` token from `from` to `to`.
574      *
575      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
594      * The approval is cleared when the token is transferred.
595      *
596      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
597      *
598      * Requirements:
599      *
600      * - The caller must own the token or be an approved operator.
601      * - `tokenId` must exist.
602      *
603      * Emits an {Approval} event.
604      */
605     function approve(address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Returns the account approved for `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function getApproved(uint256 tokenId) external view returns (address operator);
615 
616     /**
617      * @dev Approve or remove `operator` as an operator for the caller.
618      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
619      *
620      * Requirements:
621      *
622      * - The `operator` cannot be the caller.
623      *
624      * Emits an {ApprovalForAll} event.
625      */
626     function setApprovalForAll(address operator, bool _approved) external;
627 
628     /**
629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
630      *
631      * See {setApprovalForAll}
632      */
633     function isApprovedForAll(address owner, address operator) external view returns (bool);
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId,
652         bytes calldata data
653     ) external;
654 }
655 
656 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Enumerable is IERC721 {
669     /**
670      * @dev Returns the total amount of tokens stored by the contract.
671      */
672     function totalSupply() external view returns (uint256);
673 
674     /**
675      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
676      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
677      */
678     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
679 
680     /**
681      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
682      * Use along with {totalSupply} to enumerate all tokens.
683      */
684     function tokenByIndex(uint256 index) external view returns (uint256);
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
697  * @dev See https://eips.ethereum.org/EIPS/eip-721
698  */
699 interface IERC721Metadata is IERC721 {
700     /**
701      * @dev Returns the token collection name.
702      */
703     function name() external view returns (string memory);
704 
705     /**
706      * @dev Returns the token collection symbol.
707      */
708     function symbol() external view returns (string memory);
709 
710     /**
711      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
712      */
713     function tokenURI(uint256 tokenId) external view returns (string memory);
714 }
715 
716 // File: contracts/LowerGas.sol
717 
718 
719 // Creator: Chiru Labs
720 
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev These functions deal with verification of Merkle Trees proofs.
726  *
727  * The proofs can be generated using the JavaScript library
728  * https://github.com/miguelmota/merkletreejs[merkletreejs].
729  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
730  *
731  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
732  */
733 library MerkleProof {
734     /**
735      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
736      * defined by `root`. For this, a `proof` must be provided, containing
737      * sibling hashes on the branch from the leaf to the root of the tree. Each
738      * pair of leaves and each pair of pre-images are assumed to be sorted.
739      */
740     function verify(
741         bytes32[] memory proof,
742         bytes32 root,
743         bytes32 leaf
744     ) internal pure returns (bool) {
745         return processProof(proof, leaf) == root;
746     }
747 
748     /**
749      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
750      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
751      * hash matches the root of the tree. When processing the proof, the pairs
752      * of leafs & pre-images are assumed to be sorted.
753      *
754      * _Available since v4.4._
755      */
756     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
757         bytes32 computedHash = leaf;
758         for (uint256 i = 0; i < proof.length; i++) {
759             bytes32 proofElement = proof[i];
760             if (computedHash <= proofElement) {
761                 // Hash(current computed hash + current element of the proof)
762                 computedHash = _efficientHash(computedHash, proofElement);
763             } else {
764                 // Hash(current element of the proof + current computed hash)
765                 computedHash = _efficientHash(proofElement, computedHash);
766             }
767         }
768         return computedHash;
769     }
770 
771     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
772         assembly {
773             mstore(0x00, a)
774             mstore(0x20, b)
775             value := keccak256(0x00, 0x40)
776         }
777     }
778 }
779 
780 pragma solidity ^0.8.0;
781 
782 
783 
784 
785 
786 
787 
788 
789 
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
794  *
795  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
796  *
797  * Does not support burning tokens to address(0).
798  *
799  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
800  */
801 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
802     using Address for address;
803     using Strings for uint256;
804 
805     struct TokenOwnership {
806         address addr;
807         uint64 startTimestamp;
808     }
809 
810     struct AddressData {
811         uint128 balance;
812         uint128 numberMinted;
813     }
814 
815     uint256 internal currentIndex = 0;
816 
817     uint256 internal immutable maxBatchSize;
818 
819     // Token name
820     string private _name;
821 
822     // Token symbol
823     string private _symbol;
824 
825     // Mapping from token ID to ownership details
826     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
827     mapping(uint256 => TokenOwnership) internal _ownerships;
828 
829     // Mapping owner address to address data
830     mapping(address => AddressData) private _addressData;
831 
832     // Mapping from token ID to approved address
833     mapping(uint256 => address) private _tokenApprovals;
834 
835     // Mapping from owner to operator approvals
836     mapping(address => mapping(address => bool)) private _operatorApprovals;
837 
838     /**
839      * @dev
840      * `maxBatchSize` refers to how much a minter can mint at a time.
841      */
842     constructor(
843         string memory name_,
844         string memory symbol_,
845         uint256 maxBatchSize_
846     ) {
847         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
848         _name = name_;
849         _symbol = symbol_;
850         maxBatchSize = maxBatchSize_;
851     }
852 
853     /**
854      * @dev See {IERC721Enumerable-totalSupply}.
855      */
856     function totalSupply() public view override returns (uint256) {
857         return currentIndex;
858     }
859 
860     /**
861      * @dev See {IERC721Enumerable-tokenByIndex}.
862      */
863     function tokenByIndex(uint256 index) public view override returns (uint256) {
864         require(index < totalSupply(), 'ERC721A: global index out of bounds');
865         return index;
866     }
867 
868     /**
869      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
870      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
871      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
872      */
873     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
874         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
875         uint256 numMintedSoFar = totalSupply();
876         uint256 tokenIdsIdx = 0;
877         address currOwnershipAddr = address(0);
878         for (uint256 i = 0; i < numMintedSoFar; i++) {
879             TokenOwnership memory ownership = _ownerships[i];
880             if (ownership.addr != address(0)) {
881                 currOwnershipAddr = ownership.addr;
882             }
883             if (currOwnershipAddr == owner) {
884                 if (tokenIdsIdx == index) {
885                     return i;
886                 }
887                 tokenIdsIdx++;
888             }
889         }
890         revert('ERC721A: unable to get token of owner by index');
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             interfaceId == type(IERC721Enumerable).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907     function balanceOf(address owner) public view override returns (uint256) {
908         require(owner != address(0), 'ERC721A: balance query for the zero address');
909         return uint256(_addressData[owner].balance);
910     }
911 
912     function _numberMinted(address owner) internal view returns (uint256) {
913         require(owner != address(0), 'ERC721A: number minted query for the zero address');
914         return uint256(_addressData[owner].numberMinted);
915     }
916 
917     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
918         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
919 
920         uint256 lowestTokenToCheck;
921         if (tokenId >= maxBatchSize) {
922             lowestTokenToCheck = tokenId - maxBatchSize + 1;
923         }
924 
925         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
926             TokenOwnership memory ownership = _ownerships[curr];
927             if (ownership.addr != address(0)) {
928                 return ownership;
929             }
930         }
931 
932         revert('ERC721A: unable to determine the owner of token');
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         require(to != owner, 'ERC721A: approval to current owner');
981 
982         require(
983             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984             'ERC721A: approve caller is not owner nor approved for all'
985         );
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public override {
1003         require(operator != _msgSender(), 'ERC721A: approve to caller');
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public override {
1035         safeTransferFrom(from, to, tokenId, '');
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public override {
1047         _transfer(from, to, tokenId);
1048         require(
1049             _checkOnERC721Received(from, to, tokenId, _data),
1050             'ERC721A: transfer to non ERC721Receiver implementer'
1051         );
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      */
1061     function _exists(uint256 tokenId) internal view returns (bool) {
1062         return tokenId < currentIndex;
1063     }
1064 
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, '');
1067     }
1068 
1069     /**
1070      * @dev Mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `quantity` cannot be larger than the max batch size.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         uint256 startTokenId = currentIndex;
1085         require(to != address(0), 'ERC721A: mint to the zero address');
1086         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1087         require(!_exists(startTokenId), 'ERC721A: token already minted');
1088         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1089         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1090 
1091         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1092 
1093         AddressData memory addressData = _addressData[to];
1094         _addressData[to] = AddressData(
1095             addressData.balance + uint128(quantity),
1096             addressData.numberMinted + uint128(quantity)
1097         );
1098         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1099 
1100         uint256 updatedIndex = startTokenId;
1101 
1102         for (uint256 i = 0; i < quantity; i++) {
1103             emit Transfer(address(0), to, updatedIndex);
1104             require(
1105                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1106                 'ERC721A: transfer to non ERC721Receiver implementer'
1107             );
1108             updatedIndex++;
1109         }
1110 
1111         currentIndex = updatedIndex;
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) private {
1130         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1131 
1132         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1133             getApproved(tokenId) == _msgSender() ||
1134             isApprovedForAll(prevOwnership.addr, _msgSender()));
1135 
1136         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1137 
1138         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1139         require(to != address(0), 'ERC721A: transfer to the zero address');
1140 
1141         _beforeTokenTransfers(from, to, tokenId, 1);
1142 
1143         // Clear approvals from the previous owner
1144         _approve(address(0), tokenId, prevOwnership.addr);
1145 
1146         // Underflow of the sender's balance is impossible because we check for
1147         // ownership above and the recipient's balance can't realistically overflow.
1148         unchecked {
1149             _addressData[from].balance -= 1;
1150             _addressData[to].balance += 1;
1151         }
1152 
1153         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1154 
1155         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1156         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157         uint256 nextTokenId = tokenId + 1;
1158         if (_ownerships[nextTokenId].addr == address(0)) {
1159             if (_exists(nextTokenId)) {
1160                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1161             }
1162         }
1163 
1164         emit Transfer(from, to, tokenId);
1165         _afterTokenTransfers(from, to, tokenId, 1);
1166     }
1167 
1168     /**
1169      * @dev Approve `to` to operate on `tokenId`
1170      *
1171      * Emits a {Approval} event.
1172      */
1173     function _approve(
1174         address to,
1175         uint256 tokenId,
1176         address owner
1177     ) private {
1178         _tokenApprovals[tokenId] = to;
1179         emit Approval(owner, to, tokenId);
1180     }
1181 
1182     /**
1183      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1184      * The call is not executed if the target address is not a contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         if (to.isContract()) {
1199             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1200                 return retval == IERC721Receiver(to).onERC721Received.selector;
1201             } catch (bytes memory reason) {
1202                 if (reason.length == 0) {
1203                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1204                 } else {
1205                     assembly {
1206                         revert(add(32, reason), mload(reason))
1207                     }
1208                 }
1209             }
1210         } else {
1211             return true;
1212         }
1213     }
1214 
1215     /**
1216      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1217      *
1218      * startTokenId - the first token id to be transferred
1219      * quantity - the amount to be transferred
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` will be minted for `to`.
1226      */
1227     function _beforeTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 
1234     /**
1235      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1236      * minting.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - when `from` and `to` are both non-zero.
1244      * - `from` and `to` are never both zero.
1245      */
1246     function _afterTokenTransfers(
1247         address from,
1248         address to,
1249         uint256 startTokenId,
1250         uint256 quantity
1251     ) internal virtual {}
1252 }
1253 
1254 interface HolderC {
1255     
1256     function balanceOf(address owner) external view returns (uint256 balance);
1257 }
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 contract CryptoBullBalls is ERC721A, Ownable {
1262   using Strings for uint256;
1263 
1264   string private uriPrefix = "";
1265   string private uriSuffix = ".json";
1266   string public hiddenMetadataUri;
1267   
1268   uint256 public price = 0.005 ether; 
1269   uint256 public maxSupply = 6969; 
1270   uint256 public maxMintAmountPerTx = 10; 
1271   uint256 public nftPerAddressLimitWl = 10; 
1272   
1273 
1274   bool public paused = true;
1275   bool public revealed = false;
1276   bool public onlyWhitelisted = false;
1277 
1278   bytes32 public whitelistMerkleRoot;
1279   mapping(address => uint256) public addressMintedBalance;
1280 
1281   HolderC public holderc;
1282 
1283   constructor() ERC721A("CryptoBullBalls", "CBB", maxMintAmountPerTx) {
1284     setHiddenMetadataUri("ipfs://QmZZwfQzy5BHXha6Gq99HdvuX1Y41AeeCLFi6VYd9YoSSK");
1285   }
1286 
1287   /**
1288     * @dev validates merkleProof
1289     */
1290   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1291     require(
1292         MerkleProof.verify(
1293             merkleProof,
1294             root,
1295             keccak256(abi.encodePacked(msg.sender))
1296         ),
1297         "Address does not exist in list"
1298     );
1299     _;
1300   }
1301 
1302   modifier mintCompliance(uint256 _mintAmount) {
1303     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1304     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1305     _;
1306   }
1307 
1308 
1309   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1310    {
1311     require(!paused, "The contract is paused!");
1312     require(!onlyWhitelisted, "Presale is on");
1313     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1314 
1315     _safeMint(msg.sender, _mintAmount);
1316   }
1317 
1318   function mintHolder(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1319     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1320     require(!paused, "The contract is paused!");
1321     require(onlyWhitelisted, "Presale has ended");
1322     require(holderc.balanceOf(msg.sender) > 0 , "you are not a holder");
1323     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1324     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1325 
1326     addressMintedBalance[msg.sender]+=_mintAmount;
1327     _safeMint(msg.sender, _mintAmount);
1328   }
1329 
1330   function mintWhitelist(bytes32[] calldata merkleProof, uint256 _mintAmount) public payable isValidMerkleProof(merkleProof, whitelistMerkleRoot){
1331     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1332     
1333     require(!paused, "The contract is paused!");
1334     require(onlyWhitelisted, "Presale has ended");
1335     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1336     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1337     
1338     addressMintedBalance[msg.sender]+=_mintAmount;
1339     
1340     _safeMint(msg.sender, _mintAmount);
1341   }
1342   
1343   function NftToAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1344     _safeMint(_to, _mintAmount);
1345   }
1346 
1347  
1348   function walletOfOwner(address _owner)
1349     public
1350     view
1351     returns (uint256[] memory)
1352   {
1353     uint256 ownerTokenCount = balanceOf(_owner);
1354     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1355     uint256 currentTokenId = 0;
1356     uint256 ownedTokenIndex = 0;
1357 
1358     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1359       address currentTokenOwner = ownerOf(currentTokenId);
1360 
1361       if (currentTokenOwner == _owner) {
1362         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1363 
1364         ownedTokenIndex++;
1365       }
1366 
1367       currentTokenId++;
1368     }
1369 
1370     return ownedTokenIds;
1371   }
1372 
1373   function tokenURI(uint256 _tokenId)
1374     public
1375     view
1376     virtual
1377     override
1378     returns (string memory)
1379   {
1380     require(
1381       _exists(_tokenId),
1382       "ERC721Metadata: URI query for nonexistent token"
1383     );
1384 
1385     if (revealed == false) {
1386       return hiddenMetadataUri;
1387     }
1388 
1389     string memory currentBaseURI = _baseURI();
1390     return bytes(currentBaseURI).length > 0
1391         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1392         : "";
1393   }
1394 
1395   function setRevealed(bool _state) public onlyOwner {
1396     revealed = _state;
1397   }
1398 
1399   function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1400     whitelistMerkleRoot = merkleRoot;
1401   }
1402 
1403   function setOnlyWhitelisted(bool _state) public onlyOwner {
1404     onlyWhitelisted = _state;
1405   }
1406 
1407   function setPrice(uint256 _price) public onlyOwner {
1408     price = _price;
1409 
1410   }
1411 
1412   function setHolderC(address _address) public {
1413     holderc = HolderC(_address);
1414   }
1415 
1416   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1417     hiddenMetadataUri = _hiddenMetadataUri;
1418   }
1419 
1420   function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1421     nftPerAddressLimitWl = _limit;
1422   }
1423 
1424   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1425     uriPrefix = _uriPrefix;
1426   }
1427 
1428   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1429     uriSuffix = _uriSuffix;
1430   }
1431 
1432   function setPaused(bool _state) public onlyOwner {
1433     paused = _state;
1434   }
1435 
1436   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1437       _safeMint(_receiver, _mintAmount);
1438   }
1439 
1440   function _baseURI() internal view virtual override returns (string memory) {
1441     return uriPrefix;
1442     
1443   }
1444 
1445     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1446     maxMintAmountPerTx = _maxMintAmountPerTx;
1447 
1448   }
1449 
1450     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1451     maxSupply = _maxSupply;
1452 
1453   }
1454 
1455   // withdrawall addresses
1456   address t1 = 0x9191c1F39Be40bbA3B4d57c023da85A500a02DDb; 
1457   address t2 = 0x9e9E6D6aC9E59410E4AbAbB13475C5d54e5356ad; 
1458   address t3 = 0xD37905283aDf21d3E628B423cBE20c4583BA9979; 
1459   address t4 = 0xed124a7fAf7a6B54741EDADc6BE7D1E60C76787d; 
1460   address t5 = 0xA05e5B6B5199735e157bCCa08f3CA680cACC4764; 
1461   
1462 
1463   function withdrawall() public onlyOwner {
1464         uint256 _balance = address(this).balance;
1465         
1466 
1467         require(payable(t1).send(_balance * 20 / 100 ));
1468         require(payable(t2).send(_balance * 20 / 100 ));
1469         require(payable(t3).send(_balance * 20 / 100 ));
1470         require(payable(t4).send(_balance * 20 / 100 ));
1471         require(payable(t5).send(_balance * 20 / 100 ));
1472         
1473   }
1474 }