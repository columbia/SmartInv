1 // SPDX-License-Identifier: MIT
2 /*
3 ####################################################################################
4 #######################  #################################  ########################
5 #########################     ######################     ###########################
6 ############################    ##################    ##############################
7 #############################    ###############    ################################
8 #############################    ###############    ################################
9 ############################      #############      ###############################
10 ############################      #############      ###############################
11 ############################                         ###############################
12 ##############################                     #################################
13 ######################################     #########################################
14 #####################################       ########################################
15 ###################################           ######################################
16 ###############################      B u l l      ##################################
17 ############################                         ###############################
18 ##########################          B a l l s          #############################
19 ########################                                 ###########################
20 #########################               #               ############################
21 ##########################             ###             #############################
22 ###########################        ###########        ##############################
23 ####################################################################################
24 ####################################################################################
25 ####################################################################################
26 
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
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
723  *
724  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
725  *
726  * Does not support burning tokens to address(0).
727  *
728  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
729  */
730 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
731     using Address for address;
732     using Strings for uint256;
733 
734     struct TokenOwnership {
735         address addr;
736         uint64 startTimestamp;
737     }
738 
739     struct AddressData {
740         uint128 balance;
741         uint128 numberMinted;
742     }
743 
744     uint256 internal currentIndex = 0;
745 
746     uint256 internal immutable maxBatchSize;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to ownership details
755     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
756     mapping(uint256 => TokenOwnership) internal _ownerships;
757 
758     // Mapping owner address to address data
759     mapping(address => AddressData) private _addressData;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev
769      * `maxBatchSize` refers to how much a minter can mint at a time.
770      */
771     constructor(
772         string memory name_,
773         string memory symbol_,
774         uint256 maxBatchSize_
775     ) {
776         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
777         _name = name_;
778         _symbol = symbol_;
779         maxBatchSize = maxBatchSize_;
780     }
781 
782     /**
783      * @dev See {IERC721Enumerable-totalSupply}.
784      */
785     function totalSupply() public view override returns (uint256) {
786         return currentIndex;
787     }
788 
789     /**
790      * @dev See {IERC721Enumerable-tokenByIndex}.
791      */
792     function tokenByIndex(uint256 index) public view override returns (uint256) {
793         require(index < totalSupply(), 'ERC721A: global index out of bounds');
794         return index;
795     }
796 
797     /**
798      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
799      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
800      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
801      */
802     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
803         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
804         uint256 numMintedSoFar = totalSupply();
805         uint256 tokenIdsIdx = 0;
806         address currOwnershipAddr = address(0);
807         for (uint256 i = 0; i < numMintedSoFar; i++) {
808             TokenOwnership memory ownership = _ownerships[i];
809             if (ownership.addr != address(0)) {
810                 currOwnershipAddr = ownership.addr;
811             }
812             if (currOwnershipAddr == owner) {
813                 if (tokenIdsIdx == index) {
814                     return i;
815                 }
816                 tokenIdsIdx++;
817             }
818         }
819         revert('ERC721A: unable to get token of owner by index');
820     }
821 
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
826         return
827             interfaceId == type(IERC721).interfaceId ||
828             interfaceId == type(IERC721Metadata).interfaceId ||
829             interfaceId == type(IERC721Enumerable).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view override returns (uint256) {
837         require(owner != address(0), 'ERC721A: balance query for the zero address');
838         return uint256(_addressData[owner].balance);
839     }
840 
841     function _numberMinted(address owner) internal view returns (uint256) {
842         require(owner != address(0), 'ERC721A: number minted query for the zero address');
843         return uint256(_addressData[owner].numberMinted);
844     }
845 
846     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
847         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
848 
849         uint256 lowestTokenToCheck;
850         if (tokenId >= maxBatchSize) {
851             lowestTokenToCheck = tokenId - maxBatchSize + 1;
852         }
853 
854         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
855             TokenOwnership memory ownership = _ownerships[curr];
856             if (ownership.addr != address(0)) {
857                 return ownership;
858             }
859         }
860 
861         revert('ERC721A: unable to determine the owner of token');
862     }
863 
864     /**
865      * @dev See {IERC721-ownerOf}.
866      */
867     function ownerOf(uint256 tokenId) public view override returns (address) {
868         return ownershipOf(tokenId).addr;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-name}.
873      */
874     function name() public view virtual override returns (string memory) {
875         return _name;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-symbol}.
880      */
881     function symbol() public view virtual override returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-tokenURI}.
887      */
888     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
889         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
890 
891         string memory baseURI = _baseURI();
892         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
893     }
894 
895     /**
896      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
897      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
898      * by default, can be overriden in child contracts.
899      */
900     function _baseURI() internal view virtual returns (string memory) {
901         return '';
902     }
903 
904     /**
905      * @dev See {IERC721-approve}.
906      */
907     function approve(address to, uint256 tokenId) public override {
908         address owner = ERC721A.ownerOf(tokenId);
909         require(to != owner, 'ERC721A: approval to current owner');
910 
911         require(
912             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
913             'ERC721A: approve caller is not owner nor approved for all'
914         );
915 
916         _approve(to, tokenId, owner);
917     }
918 
919     /**
920      * @dev See {IERC721-getApproved}.
921      */
922     function getApproved(uint256 tokenId) public view override returns (address) {
923         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
924 
925         return _tokenApprovals[tokenId];
926     }
927 
928     /**
929      * @dev See {IERC721-setApprovalForAll}.
930      */
931     function setApprovalForAll(address operator, bool approved) public override {
932         require(operator != _msgSender(), 'ERC721A: approve to caller');
933 
934         _operatorApprovals[_msgSender()][operator] = approved;
935         emit ApprovalForAll(_msgSender(), operator, approved);
936     }
937 
938     /**
939      * @dev See {IERC721-isApprovedForAll}.
940      */
941     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev See {IERC721-transferFrom}.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public override {
953         _transfer(from, to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) public override {
964         safeTransferFrom(from, to, tokenId, '');
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) public override {
976         _transfer(from, to, tokenId);
977         require(
978             _checkOnERC721Received(from, to, tokenId, _data),
979             'ERC721A: transfer to non ERC721Receiver implementer'
980         );
981     }
982 
983     /**
984      * @dev Returns whether `tokenId` exists.
985      *
986      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
987      *
988      * Tokens start existing when they are minted (`_mint`),
989      */
990     function _exists(uint256 tokenId) internal view returns (bool) {
991         return tokenId < currentIndex;
992     }
993 
994     function _safeMint(address to, uint256 quantity) internal {
995         _safeMint(to, quantity, '');
996     }
997 
998     /**
999      * @dev Mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `quantity` cannot be larger than the max batch size.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(
1009         address to,
1010         uint256 quantity,
1011         bytes memory _data
1012     ) internal {
1013         uint256 startTokenId = currentIndex;
1014         require(to != address(0), 'ERC721A: mint to the zero address');
1015         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1016         require(!_exists(startTokenId), 'ERC721A: token already minted');
1017         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1018         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         AddressData memory addressData = _addressData[to];
1023         _addressData[to] = AddressData(
1024             addressData.balance + uint128(quantity),
1025             addressData.numberMinted + uint128(quantity)
1026         );
1027         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1028 
1029         uint256 updatedIndex = startTokenId;
1030 
1031         for (uint256 i = 0; i < quantity; i++) {
1032             emit Transfer(address(0), to, updatedIndex);
1033             require(
1034                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1035                 'ERC721A: transfer to non ERC721Receiver implementer'
1036             );
1037             updatedIndex++;
1038         }
1039 
1040         currentIndex = updatedIndex;
1041         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _transfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) private {
1059         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1060 
1061         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1062             getApproved(tokenId) == _msgSender() ||
1063             isApprovedForAll(prevOwnership.addr, _msgSender()));
1064 
1065         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1066 
1067         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1068         require(to != address(0), 'ERC721A: transfer to the zero address');
1069 
1070         _beforeTokenTransfers(from, to, tokenId, 1);
1071 
1072         // Clear approvals from the previous owner
1073         _approve(address(0), tokenId, prevOwnership.addr);
1074 
1075         // Underflow of the sender's balance is impossible because we check for
1076         // ownership above and the recipient's balance can't realistically overflow.
1077         unchecked {
1078             _addressData[from].balance -= 1;
1079             _addressData[to].balance += 1;
1080         }
1081 
1082         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1083 
1084         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1085         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1086         uint256 nextTokenId = tokenId + 1;
1087         if (_ownerships[nextTokenId].addr == address(0)) {
1088             if (_exists(nextTokenId)) {
1089                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1090             }
1091         }
1092 
1093         emit Transfer(from, to, tokenId);
1094         _afterTokenTransfers(from, to, tokenId, 1);
1095     }
1096 
1097     /**
1098      * @dev Approve `to` to operate on `tokenId`
1099      *
1100      * Emits a {Approval} event.
1101      */
1102     function _approve(
1103         address to,
1104         uint256 tokenId,
1105         address owner
1106     ) private {
1107         _tokenApprovals[tokenId] = to;
1108         emit Approval(owner, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1113      * The call is not executed if the target address is not a contract.
1114      *
1115      * @param from address representing the previous owner of the given token ID
1116      * @param to target address that will receive the tokens
1117      * @param tokenId uint256 ID of the token to be transferred
1118      * @param _data bytes optional data to send along with the call
1119      * @return bool whether the call correctly returned the expected magic value
1120      */
1121     function _checkOnERC721Received(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory _data
1126     ) private returns (bool) {
1127         if (to.isContract()) {
1128             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1129                 return retval == IERC721Receiver(to).onERC721Received.selector;
1130             } catch (bytes memory reason) {
1131                 if (reason.length == 0) {
1132                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1133                 } else {
1134                     assembly {
1135                         revert(add(32, reason), mload(reason))
1136                     }
1137                 }
1138             }
1139         } else {
1140             return true;
1141         }
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1146      *
1147      * startTokenId - the first token id to be transferred
1148      * quantity - the amount to be transferred
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` will be minted for `to`.
1155      */
1156     function _beforeTokenTransfers(
1157         address from,
1158         address to,
1159         uint256 startTokenId,
1160         uint256 quantity
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1165      * minting.
1166      *
1167      * startTokenId - the first token id to be transferred
1168      * quantity - the amount to be transferred
1169      *
1170      * Calling conditions:
1171      *
1172      * - when `from` and `to` are both non-zero.
1173      * - `from` and `to` are never both zero.
1174      */
1175     function _afterTokenTransfers(
1176         address from,
1177         address to,
1178         uint256 startTokenId,
1179         uint256 quantity
1180     ) internal virtual {}
1181 }
1182 
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 contract BullBalls is ERC721A, Ownable {
1187   using Strings for uint256;
1188 
1189   string private uriPrefix = "";
1190   string private uriSuffix = ".json";
1191   string public hiddenMetadataUri;
1192   
1193   uint256 public price = 0.019 ether; 
1194   uint256 public maxSupply = 6969; 
1195   uint256 public maxMintAmountPerTx = 50; 
1196   uint256 public nftPerAddressLimitWl = 20; 
1197   
1198   bool public paused = true;
1199   bool public revealed = true;
1200   bool public onlyWhitelisted = false;
1201   address[] public whitelistedAddresses;
1202   mapping(address => uint256) public addressMintedBalance;
1203 
1204 
1205   constructor() ERC721A("BullBalls", "BALL$", maxMintAmountPerTx) {
1206     setHiddenMetadataUri("");
1207   }
1208 
1209   modifier mintCompliance(uint256 _mintAmount) {
1210     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1211     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1212     _;
1213   }
1214 
1215   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1216    {
1217     require(!paused, "The contract is paused!");
1218     require(!onlyWhitelisted, "Presale is on");
1219     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1220     
1221     
1222     _safeMint(msg.sender, _mintAmount);
1223   }
1224 
1225    function WhitelistMint(uint256 _mintAmount) public payable {
1226     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1227     
1228     require(!paused, "The contract is paused!");
1229     require(onlyWhitelisted, "Presale has ended");
1230     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1231     if(onlyWhitelisted == true) {
1232             require(isWhitelisted(msg.sender), "address is not Whitelisted");
1233         }
1234     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1235     
1236     addressMintedBalance[msg.sender]+=_mintAmount;
1237     
1238     _safeMint(msg.sender, _mintAmount);
1239   }
1240 
1241 
1242 
1243   
1244   function NftToAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1245     _safeMint(_to, _mintAmount);
1246   }
1247 
1248  
1249   function walletOfOwner(address _owner)
1250     public
1251     view
1252     returns (uint256[] memory)
1253   {
1254     uint256 ownerTokenCount = balanceOf(_owner);
1255     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1256     uint256 currentTokenId = 0;
1257     uint256 ownedTokenIndex = 0;
1258 
1259     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1260       address currentTokenOwner = ownerOf(currentTokenId);
1261 
1262       if (currentTokenOwner == _owner) {
1263         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1264 
1265         ownedTokenIndex++;
1266       }
1267 
1268       currentTokenId++;
1269     }
1270 
1271     return ownedTokenIds;
1272   }
1273 
1274   function tokenURI(uint256 _tokenId)
1275     public
1276     view
1277     virtual
1278     override
1279     returns (string memory)
1280   {
1281     require(
1282       _exists(_tokenId),
1283       "ERC721Metadata: URI query for nonexistent token"
1284     );
1285 
1286     if (revealed == false) {
1287       return hiddenMetadataUri;
1288     }
1289 
1290     string memory currentBaseURI = _baseURI();
1291     return bytes(currentBaseURI).length > 0
1292         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1293         : "";
1294   }
1295 
1296   function setRevealed(bool _state) public onlyOwner {
1297     revealed = _state;
1298   }
1299 
1300 
1301   function setOnlyWhitelisted(bool _state) public onlyOwner {
1302     onlyWhitelisted = _state;
1303   }
1304 
1305   function setPrice(uint256 _price) public onlyOwner {
1306     price = _price;
1307 
1308   }
1309  
1310   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1311     hiddenMetadataUri = _hiddenMetadataUri;
1312   }
1313 
1314   function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1315     nftPerAddressLimitWl = _limit;
1316   }
1317 
1318   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1319     uriPrefix = _uriPrefix;
1320   }
1321 
1322   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1323     uriSuffix = _uriSuffix;
1324   }
1325 
1326   function setPaused(bool _state) public onlyOwner {
1327     paused = _state;
1328   }
1329 
1330   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1331       _safeMint(_receiver, _mintAmount);
1332   }
1333 
1334   function _baseURI() internal view virtual override returns (string memory) {
1335     return uriPrefix;
1336     
1337   }
1338 
1339     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1340     maxMintAmountPerTx = _maxMintAmountPerTx;
1341 
1342   }
1343 
1344     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1345     maxSupply = _maxSupply;
1346 
1347   }
1348 
1349   function addWhitelistUsers(address _users) public onlyOwner {
1350     whitelistedAddresses.push(_users);
1351        
1352   }
1353 
1354     function isWhitelisted(address _user) public view returns (bool) {
1355     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1356       if (whitelistedAddresses[i] == _user) {
1357           return true;
1358       }
1359     }
1360     return false;
1361   }
1362 
1363   // withdrawall addresses
1364   address t1 = 0x9191c1F39Be40bbA3B4d57c023da85A500a02DDb; 
1365   address t2 = 0x9e9E6D6aC9E59410E4AbAbB13475C5d54e5356ad; 
1366   address t3 = 0xD37905283aDf21d3E628B423cBE20c4583BA9979; 
1367   address t4 = 0xed124a7fAf7a6B54741EDADc6BE7D1E60C76787d; 
1368   address t5 = 0xA05e5B6B5199735e157bCCa08f3CA680cACC4764; 
1369   address t6 = 0x3f58DDF49e9eACd01D33FBfa1dE8600ceC446Ee0; 
1370   address t7 = 0xF14d484b29A8aC040FEb489aFADB4b972422B4E9; 
1371 
1372   function withdrawall() public onlyOwner {
1373         uint256 _balance = address(this).balance;
1374         
1375         require(payable(t1).send(_balance * 155 / 1000 ));
1376         require(payable(t2).send(_balance * 155 / 1000 ));
1377         require(payable(t3).send(_balance * 155 / 1000 ));
1378         require(payable(t4).send(_balance * 155 / 1000 ));
1379         require(payable(t5).send(_balance * 155 / 1000 ));
1380         require(payable(t6).send(_balance * 25 / 1000 ));
1381         require(payable(t7).send(_balance * 25 / 1000 ));
1382 
1383  // This will transfer the remaining contract balance to the owner.
1384 
1385     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1386     require(os);
1387   }
1388   
1389 }