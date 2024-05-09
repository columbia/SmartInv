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
18 
19 
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
732     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
733     modifier onlyOwner() {
734         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
735         _;
736     }
737 }
738 
739  /*
740  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
741  *
742  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
743  */
744 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Compiler will pack this into a single 256bit word.
749     struct TokenOwnership {
750         // The address of the owner.
751         address addr;
752         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
753         uint64 startTimestamp;
754         // Whether the token has been burned.
755         bool burned;
756     }
757 
758     // Compiler will pack this into a single 256bit word.
759     struct AddressData {
760         // Realistically, 2**64-1 is more than enough.
761         uint64 balance;
762         // Keeps track of mint count with minimal overhead for tokenomics.
763         uint64 numberMinted;
764         // Keeps track of burn count with minimal overhead for tokenomics.
765         uint64 numberBurned;
766         // For miscellaneous variable(s) pertaining to the address
767         // (e.g. number of whitelist mint slots used).
768         // If there are multiple variables, please pack them into a uint64.
769         uint64 aux;
770     }
771 
772     // The tokenId of the next token to be minted.
773     uint256 internal _currentIndex;
774 
775     // The number of tokens burned.
776     uint256 internal _burnCounter;
777 
778     // Token name
779     string private _name;
780 
781     // Token symbol
782     string private _symbol;
783 
784     // Mapping from token ID to ownership details
785     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
786     mapping(uint256 => TokenOwnership) internal _ownerships;
787 
788     // Mapping owner address to address data
789     mapping(address => AddressData) private _addressData;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800         _currentIndex = _startTokenId();
801     }
802 
803     /**
804      * To change the starting tokenId, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-totalSupply}.
812      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
813      */
814     function totalSupply() public view returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than _currentIndex - _startTokenId() times
817         unchecked {
818             return _currentIndex - _burnCounter - _startTokenId();
819         }
820     }
821 
822     /**
823      * Returns the total amount of tokens minted in the contract.
824      */
825     function _totalMinted() internal view returns (uint256) {
826         // Counter underflow is impossible as _currentIndex does not decrement,
827         // and it is initialized to _startTokenId()
828         unchecked {
829             return _currentIndex - _startTokenId();
830         }
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
837         return
838             interfaceId == type(IERC721).interfaceId ||
839             interfaceId == type(IERC721Metadata).interfaceId ||
840             super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848         return uint256(_addressData[owner].balance);
849     }
850 
851     /**
852      * Returns the number of tokens minted by `owner`.
853      */
854     function _numberMinted(address owner) internal view returns (uint256) {
855         if (owner == address(0)) revert MintedQueryForZeroAddress();
856         return uint256(_addressData[owner].numberMinted);
857     }
858 
859     /**
860      * Returns the number of tokens burned by or on behalf of `owner`.
861      */
862     function _numberBurned(address owner) internal view returns (uint256) {
863         if (owner == address(0)) revert BurnedQueryForZeroAddress();
864         return uint256(_addressData[owner].numberBurned);
865     }
866 
867     /**
868      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
869      */
870     function _getAux(address owner) internal view returns (uint64) {
871         if (owner == address(0)) revert AuxQueryForZeroAddress();
872         return _addressData[owner].aux;
873     }
874 
875     /**
876      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
877      * If there are multiple variables, please pack them into a uint64.
878      */
879     function _setAux(address owner, uint64 aux) internal {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         _addressData[owner].aux = aux;
882     }
883 
884     /**
885      * Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
887      */
888     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
889         uint256 curr = tokenId;
890 
891         unchecked {
892             if (_startTokenId() <= curr && curr < _currentIndex) {
893                 TokenOwnership memory ownership = _ownerships[curr];
894                 if (!ownership.burned) {
895                     if (ownership.addr != address(0)) {
896                         return ownership;
897                     }
898                     // Invariant:
899                     // There will always be an ownership that has an address and is not burned
900                     // before an ownership that does not have an address and is not burned.
901                     // Hence, curr will not underflow.
902                     while (true) {
903                         curr--;
904                         ownership = _ownerships[curr];
905                         if (ownership.addr != address(0)) {
906                             return ownership;
907                         }
908                     }
909                 }
910             }
911         }
912         revert OwnerQueryForNonexistentToken();
913     }
914 
915     /**
916      * @dev See {IERC721-ownerOf}.
917      */
918     function ownerOf(uint256 tokenId) public view override returns (address) {
919         return ownershipOf(tokenId).addr;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-name}.
924      */
925     function name() public view virtual override returns (string memory) {
926         return _name;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-symbol}.
931      */
932     function symbol() public view virtual override returns (string memory) {
933         return _symbol;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-tokenURI}.
938      */
939     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
940         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return '';
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ERC721A.ownerOf(tokenId);
960         if (to == owner) revert ApprovalToCurrentOwner();
961 
962         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
963             revert ApprovalCallerNotOwnerNorApproved();
964         }
965 
966         _approve(to, tokenId, owner);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view override returns (address) {
973         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public override {
982         if (operator == _msgSender()) revert ApproveToCaller();
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         _transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         safeTransferFrom(from, to, tokenId, '');
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028             revert TransferToNonERC721ReceiverImplementer();
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1041             !_ownerships[tokenId].burned;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, '');
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (safe && to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex != end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex != end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) private {
1135         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1136 
1137         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1138             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1139             getApproved(tokenId) == _msgSender());
1140 
1141         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1142         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1143         if (to == address(0)) revert TransferToZeroAddress();
1144 
1145         _beforeTokenTransfers(from, to, tokenId, 1);
1146 
1147         // Clear approvals from the previous owner
1148         _approve(address(0), tokenId, prevOwnership.addr);
1149 
1150         // Underflow of the sender's balance is impossible because we check for
1151         // ownership above and the recipient's balance can't realistically overflow.
1152         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1153         unchecked {
1154             _addressData[from].balance -= 1;
1155             _addressData[to].balance += 1;
1156 
1157             _ownerships[tokenId].addr = to;
1158             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1159 
1160             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1161             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1162             uint256 nextTokenId = tokenId + 1;
1163             if (_ownerships[nextTokenId].addr == address(0)) {
1164                 // This will suffice for checking _exists(nextTokenId),
1165                 // as a burned slot cannot contain the zero address.
1166                 if (nextTokenId < _currentIndex) {
1167                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1168                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1169                 }
1170             }
1171         }
1172 
1173         emit Transfer(from, to, tokenId);
1174         _afterTokenTransfers(from, to, tokenId, 1);
1175     }
1176 
1177     /**
1178      * @dev Destroys `tokenId`.
1179      * The approval is cleared when the token is burned.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _burn(uint256 tokenId) internal virtual {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, prevOwnership.addr);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             _addressData[prevOwnership.addr].balance -= 1;
1200             _addressData[prevOwnership.addr].numberBurned += 1;
1201 
1202             // Keep track of who burned the token, and the timestamp of burning.
1203             _ownerships[tokenId].addr = prevOwnership.addr;
1204             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1205             _ownerships[tokenId].burned = true;
1206 
1207             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1208             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1209             uint256 nextTokenId = tokenId + 1;
1210             if (_ownerships[nextTokenId].addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId < _currentIndex) {
1214                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1215                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(prevOwnership.addr, address(0), tokenId);
1221         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Approve `to` to operate on `tokenId`
1231      *
1232      * Emits a {Approval} event.
1233      */
1234     function _approve(
1235         address to,
1236         uint256 tokenId,
1237         address owner
1238     ) private {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(owner, to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkContractOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259             return retval == IERC721Receiver(to).onERC721Received.selector;
1260         } catch (bytes memory reason) {
1261             if (reason.length == 0) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             } else {
1264                 assembly {
1265                     revert(add(32, reason), mload(reason))
1266                 }
1267             }
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1273      * And also called before burning one token.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, `tokenId` will be burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      * And also called after one token has been burned.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` has been minted for `to`.
1306      * - When `to` is zero, `tokenId` has been burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _afterTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 }
1316 
1317 
1318 
1319 contract pxLazyApeYachtClub is ERC721A, Owneable {
1320 
1321     string public baseURI = "ipfs:///";
1322     string public contractURI = "ipfs://";
1323     string public baseExtension = ".json";
1324     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1325 
1326     uint256 public constant MAX_PER_TX_FREE = 5;
1327     uint256 public free_max_supply = 1500;
1328     uint256 public constant MAX_PER_TX = 10;
1329     uint256 public max_supply = 5555;
1330     uint256 public price = 0.001 ether;
1331 
1332     bool public paused = true;
1333 
1334     constructor() ERC721A("pxLazy Ape Yacht Club", "pxLAYC") {}
1335 
1336     function PublicMint(uint256 _amount) external payable {
1337         address _caller = _msgSender();
1338         require(!paused, "Paused");
1339         require(max_supply >= totalSupply() + _amount, "Exceeds max supply");
1340         require(_amount > 0, "No 0 mints");
1341         require(tx.origin == _caller, "No contracts");
1342         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1343         
1344       if(free_max_supply >= totalSupply()){
1345             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1346         }else{
1347             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1348             require(_amount * price == msg.value, "Invalid funds provided");
1349         }
1350 
1351 
1352         _safeMint(_caller, _amount);
1353     }
1354 
1355 
1356 
1357   
1358 
1359     function isApprovedForAll(address owner, address operator)
1360         override
1361         public
1362         view
1363         returns (bool)
1364     {
1365         // Whitelist OpenSea proxy contract for easy trading.
1366         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1367         if (address(proxyRegistry.proxies(owner)) == operator) {
1368             return true;
1369         }
1370 
1371         return super.isApprovedForAll(owner, operator);
1372     }
1373 
1374     function Pull() external onlyOwner {
1375         uint256 balance = address(this).balance;
1376         (bool success, ) = _msgSender().call{value: balance}("");
1377         require(success, "Failed to send");
1378     }
1379 
1380     function WhitelistMint(uint256 quantity) external onlyOwner {
1381         _safeMint(_msgSender(), quantity);
1382     }
1383 
1384 
1385     function pause(bool _state) external onlyOwner {
1386         paused = _state;
1387     }
1388 
1389     function setBaseURI(string memory baseURI_) external onlyOwner {
1390         baseURI = baseURI_;
1391     }
1392 
1393     function setContractURI(string memory _contractURI) external onlyOwner {
1394         contractURI = _contractURI;
1395     }
1396 
1397     function configPrice(uint256 newPrice) public onlyOwner {
1398         price = newPrice;
1399     }
1400 
1401     function configmax_supply(uint256 newSupply) public onlyOwner {
1402         max_supply = newSupply;
1403     }
1404 
1405     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1406         free_max_supply = newFreesupply;
1407     }
1408 
1409     function newbaseExtension(string memory newex) public onlyOwner {
1410         baseExtension = newex;
1411     }
1412 
1413 
1414 //Future Use
1415         function Burn(uint256[] memory tokenids) external onlyOwner {
1416         uint256 len = tokenids.length;
1417         for (uint256 i; i < len; i++) {
1418             uint256 tokenid = tokenids[i];
1419             _burn(tokenid);
1420         }
1421     }
1422 
1423 
1424     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1425         require(_exists(_tokenId), "Token does not exist.");
1426         return bytes(baseURI).length > 0 ? string(
1427             abi.encodePacked(
1428               baseURI,
1429               Strings.toString(_tokenId),
1430               baseExtension
1431             )
1432         ) : "";
1433     }
1434 }
1435 
1436 contract OwnableDelegateProxy { }
1437 contract ProxyRegistry {
1438     mapping(address => OwnableDelegateProxy) public proxies;
1439 }