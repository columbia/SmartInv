1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
204 
205 
206 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Enumerable is IERC721 {
216     /**
217      * @dev Returns the total amount of tokens stored by the contract.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
223      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
224      */
225     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
226 
227     /**
228      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
229      * Use along with {totalSupply} to enumerate all tokens.
230      */
231     function tokenByIndex(uint256 index) external view returns (uint256);
232 }
233 
234 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 /**
243  * @dev Implementation of the {IERC165} interface.
244  *
245  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
246  * for the additional interface id that will be supported. For example:
247  *
248  * ```solidity
249  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
250  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
251  * }
252  * ```
253  *
254  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
255  */
256 abstract contract ERC165 is IERC165 {
257     /**
258      * @dev See {IERC165-supportsInterface}.
259      */
260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
261         return interfaceId == type(IERC165).interfaceId;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
266 
267 
268 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 // File: @openzeppelin/contracts/utils/Context.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         return msg.data;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/access/Ownable.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _transferOwnership(_msgSender());
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view virtual returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public virtual onlyOwner {
377         _transferOwnership(address(0));
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Can only be called by the current owner.
383      */
384     function transferOwnership(address newOwner) public virtual onlyOwner {
385         require(newOwner != address(0), "Ownable: new owner is the zero address");
386         _transferOwnership(newOwner);
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      * Internal function without access restriction.
392      */
393     function _transferOwnership(address newOwner) internal virtual {
394         address oldOwner = _owner;
395         _owner = newOwner;
396         emit OwnershipTransferred(oldOwner, newOwner);
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Address.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
404 
405 pragma solidity ^0.8.1;
406 
407 /**
408  * @dev Collection of functions related to the address type
409  */
410 library Address {
411     /**
412      * @dev Returns true if `account` is a contract.
413      *
414      * [IMPORTANT]
415      * ====
416      * It is unsafe to assume that an address for which this function returns
417      * false is an externally-owned account (EOA) and not a contract.
418      *
419      * Among others, `isContract` will return false for the following
420      * types of addresses:
421      *
422      *  - an externally-owned account
423      *  - a contract in construction
424      *  - an address where a contract will be created
425      *  - an address where a contract lived, but was destroyed
426      * ====
427      *
428      * [IMPORTANT]
429      * ====
430      * You shouldn't rely on `isContract` to protect against flash loan attacks!
431      *
432      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
433      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
434      * constructor.
435      * ====
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies on extcodesize/address.code.length, which returns 0
439         // for contracts in construction, since the code is only stored at the end
440         // of the constructor execution.
441 
442         return account.code.length > 0;
443     }
444 
445     /**
446      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
447      * `recipient`, forwarding all available gas and reverting on errors.
448      *
449      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
450      * of certain opcodes, possibly making contracts go over the 2300 gas limit
451      * imposed by `transfer`, making them unable to receive funds via
452      * `transfer`. {sendValue} removes this limitation.
453      *
454      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
455      *
456      * IMPORTANT: because control is transferred to `recipient`, care must be
457      * taken to not create reentrancy vulnerabilities. Consider using
458      * {ReentrancyGuard} or the
459      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
460      */
461     function sendValue(address payable recipient, uint256 amount) internal {
462         require(address(this).balance >= amount, "Address: insufficient balance");
463 
464         (bool success, ) = recipient.call{value: amount}("");
465         require(success, "Address: unable to send value, recipient may have reverted");
466     }
467 
468     /**
469      * @dev Performs a Solidity function call using a low level `call`. A
470      * plain `call` is an unsafe replacement for a function call: use this
471      * function instead.
472      *
473      * If `target` reverts with a revert reason, it is bubbled up by this
474      * function (like regular Solidity function calls).
475      *
476      * Returns the raw returned data. To convert to the expected return value,
477      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
478      *
479      * Requirements:
480      *
481      * - `target` must be a contract.
482      * - calling `target` with `data` must not revert.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionCall(target, data, "Address: low-level call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
492      * `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, 0, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but also transferring `value` wei to `target`.
507      *
508      * Requirements:
509      *
510      * - the calling contract must have an ETH balance of at least `value`.
511      * - the called Solidity function must be `payable`.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value
519     ) internal returns (bytes memory) {
520         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
525      * with `errorMessage` as a fallback revert reason when `target` reverts.
526      *
527      * _Available since v3.1._
528      */
529     function functionCallWithValue(
530         address target,
531         bytes memory data,
532         uint256 value,
533         string memory errorMessage
534     ) internal returns (bytes memory) {
535         require(address(this).balance >= value, "Address: insufficient balance for call");
536         require(isContract(target), "Address: call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.call{value: value}(data);
539         return verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
549         return functionStaticCall(target, data, "Address: low-level static call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal view returns (bytes memory) {
563         require(isContract(target), "Address: static call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.staticcall(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
576         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         require(isContract(target), "Address: delegate call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.delegatecall(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
598      * revert reason using the provided one.
599      *
600      * _Available since v4.3._
601      */
602     function verifyCallResult(
603         bool success,
604         bytes memory returndata,
605         string memory errorMessage
606     ) internal pure returns (bytes memory) {
607         if (success) {
608             return returndata;
609         } else {
610             // Look for revert reason and bubble it up if present
611             if (returndata.length > 0) {
612                 // The easiest way to bubble the revert reason is using memory via assembly
613 
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 // File: @openzeppelin/contracts/utils/Strings.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev String operations.
634  */
635 library Strings {
636     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
640      */
641     function toString(uint256 value) internal pure returns (string memory) {
642         // Inspired by OraclizeAPI's implementation - MIT licence
643         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
644 
645         if (value == 0) {
646             return "0";
647         }
648         uint256 temp = value;
649         uint256 digits;
650         while (temp != 0) {
651             digits++;
652             temp /= 10;
653         }
654         bytes memory buffer = new bytes(digits);
655         while (value != 0) {
656             digits -= 1;
657             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
658             value /= 10;
659         }
660         return string(buffer);
661     }
662 
663     /**
664      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
665      */
666     function toHexString(uint256 value) internal pure returns (string memory) {
667         if (value == 0) {
668             return "0x00";
669         }
670         uint256 temp = value;
671         uint256 length = 0;
672         while (temp != 0) {
673             length++;
674             temp >>= 8;
675         }
676         return toHexString(value, length);
677     }
678 
679     /**
680      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
681      */
682     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
683         bytes memory buffer = new bytes(2 * length + 2);
684         buffer[0] = "0";
685         buffer[1] = "x";
686         for (uint256 i = 2 * length + 1; i > 1; --i) {
687             buffer[i] = _HEX_SYMBOLS[value & 0xf];
688             value >>= 4;
689         }
690         require(value == 0, "Strings: hex length insufficient");
691         return string(buffer);
692     }
693 }
694 
695 // File: contracts/AbsolutelyNothing.sol
696 
697 
698 pragma solidity ^0.8.7;
699 
700 
701 
702 
703 
704 
705 
706 
707 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
708 
709 pragma solidity ^0.8.4;
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
718 error AuxQueryForZeroAddress();
719 error MintToZeroAddress();
720 error MintZeroQuantity();
721 error OwnerIndexOutOfBounds();
722 error OwnerQueryForNonexistentToken();
723 error TokenIndexOutOfBounds();
724 error TransferCallerNotOwnerNorApproved();
725 error TransferFromIncorrectOwner();
726 error TransferToNonERC721ReceiverImplementer();
727 error TransferToZeroAddress();
728 error URIQueryForNonexistentToken();
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension. Built to optimize for lower gas during batch mints.
733  *
734  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
735  *
736  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
737  *
738  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
739  */
740 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Compiler will pack this into a single 256bit word.
745     struct TokenOwnership {
746         // The address of the owner.
747         address addr;
748         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
749         uint64 startTimestamp;
750         // Whether the token has been burned.
751         bool burned;
752     }
753 
754     // Compiler will pack this into a single 256bit word.
755     struct AddressData {
756         // Realistically, 2**64-1 is more than enough.
757         uint64 balance;
758         // Keeps track of mint count with minimal overhead for tokenomics.
759         uint64 numberMinted;
760         // Keeps track of burn count with minimal overhead for tokenomics.
761         uint64 numberBurned;
762         // For miscellaneous variable(s) pertaining to the address
763         // (e.g. number of whitelist mint slots used). 
764         // If there are multiple variables, please pack them into a uint64.
765         uint64 aux;
766     }
767 
768     // The tokenId of the next token to be minted.
769     uint256 internal _currentIndex;
770 
771     // The number of tokens burned.
772     uint256 internal _burnCounter;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to ownership details
781     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
782     mapping(uint256 => TokenOwnership) internal _ownerships;
783 
784     // Mapping owner address to address data
785     mapping(address => AddressData) private _addressData;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796     }
797 
798     /**
799      * @dev See {IERC721Enumerable-totalSupply}.
800      */
801     function totalSupply() public view returns (uint256) {
802         // Counter underflow is impossible as _burnCounter cannot be incremented
803         // more than _currentIndex times
804         unchecked {
805             return _currentIndex - _burnCounter;    
806         }
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
813         return
814             interfaceId == type(IERC721).interfaceId ||
815             interfaceId == type(IERC721Metadata).interfaceId ||
816             super.supportsInterface(interfaceId);
817     }
818 
819     /**
820      * @dev See {IERC721-balanceOf}.
821      */
822     function balanceOf(address owner) public view override returns (uint256) {
823         if (owner == address(0)) revert BalanceQueryForZeroAddress();
824         return uint256(_addressData[owner].balance);
825     }
826 
827     /**
828      * Returns the number of tokens minted by `owner`.
829      */
830     function _numberMinted(address owner) internal view returns (uint256) {
831         if (owner == address(0)) revert MintedQueryForZeroAddress();
832         return uint256(_addressData[owner].numberMinted);
833     }
834 
835     /**
836      * Returns the number of tokens burned by or on behalf of `owner`.
837      */
838     function _numberBurned(address owner) internal view returns (uint256) {
839         if (owner == address(0)) revert BurnedQueryForZeroAddress();
840         return uint256(_addressData[owner].numberBurned);
841     }
842 
843     /**
844      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
845      */
846     function _getAux(address owner) internal view returns (uint64) {
847         if (owner == address(0)) revert AuxQueryForZeroAddress();
848         return _addressData[owner].aux;
849     }
850 
851     /**
852      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
853      * If there are multiple variables, please pack them into a uint64.
854      */
855     function _setAux(address owner, uint64 aux) internal {
856         if (owner == address(0)) revert AuxQueryForZeroAddress();
857         _addressData[owner].aux = aux;
858     }
859 
860     /**
861      * Gas spent here starts off proportional to the maximum mint batch size.
862      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
863      */
864     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
865         uint256 curr = tokenId;
866 
867         unchecked {
868             if (curr < _currentIndex) {
869                 TokenOwnership memory ownership = _ownerships[curr];
870                 if (!ownership.burned) {
871                     if (ownership.addr != address(0)) {
872                         return ownership;
873                     }
874                     // Invariant: 
875                     // There will always be an ownership that has an address and is not burned 
876                     // before an ownership that does not have an address and is not burned.
877                     // Hence, curr will not underflow.
878                     while (true) {
879                         curr--;
880                         ownership = _ownerships[curr];
881                         if (ownership.addr != address(0)) {
882                             return ownership;
883                         }
884                     }
885                 }
886             }
887         }
888         revert OwnerQueryForNonexistentToken();
889     }
890 
891     /**
892      * @dev See {IERC721-ownerOf}.
893      */
894     function ownerOf(uint256 tokenId) public view override returns (address) {
895         return ownershipOf(tokenId).addr;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-name}.
900      */
901     function name() public view virtual override returns (string memory) {
902         return _name;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-symbol}.
907      */
908     function symbol() public view virtual override returns (string memory) {
909         return _symbol;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-tokenURI}.
914      */
915     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
916         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
917 
918         string memory baseURI = _baseURI();
919         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
920     }
921 
922     /**
923      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
924      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
925      * by default, can be overriden in child contracts.
926      */
927     function _baseURI() internal view virtual returns (string memory) {
928         return '';
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public override {
935         address owner = ERC721A.ownerOf(tokenId);
936         if (to == owner) revert ApprovalToCurrentOwner();
937 
938         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
939             revert ApprovalCallerNotOwnerNorApproved();
940         }
941 
942         _approve(to, tokenId, owner);
943     }
944 
945     /**
946      * @dev See {IERC721-getApproved}.
947      */
948     function getApproved(uint256 tokenId) public view override returns (address) {
949         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
950 
951         return _tokenApprovals[tokenId];
952     }
953 
954     /**
955      * @dev See {IERC721-setApprovalForAll}.
956      */
957     function setApprovalForAll(address operator, bool approved) public override {
958         if (operator == _msgSender()) revert ApproveToCaller();
959 
960         _operatorApprovals[_msgSender()][operator] = approved;
961         emit ApprovalForAll(_msgSender(), operator, approved);
962     }
963 
964     /**
965      * @dev See {IERC721-isApprovedForAll}.
966      */
967     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
968         return _operatorApprovals[owner][operator];
969     }
970 
971     /**
972      * @dev See {IERC721-transferFrom}.
973      */
974     function transferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) public virtual override {
979         _transfer(from, to, tokenId);
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         safeTransferFrom(from, to, tokenId, '');
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1004             revert TransferToNonERC721ReceiverImplementer();
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns whether `tokenId` exists.
1010      *
1011      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012      *
1013      * Tokens start existing when they are minted (`_mint`),
1014      */
1015     function _exists(uint256 tokenId) internal view returns (bool) {
1016         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1017     }
1018 
1019     function _safeMint(address to, uint256 quantity) internal {
1020         _safeMint(to, quantity, '');
1021     }
1022 
1023     /**
1024      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 quantity,
1036         bytes memory _data
1037     ) internal {
1038         _mint(to, quantity, _data, true);
1039     }
1040 
1041     /**
1042      * @dev Mints `quantity` tokens and transfers them to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `quantity` must be greater than 0.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _mint(
1052         address to,
1053         uint256 quantity,
1054         bytes memory _data,
1055         bool safe
1056     ) internal {
1057         uint256 startTokenId = _currentIndex;
1058         if (to == address(0)) revert MintToZeroAddress();
1059         if (quantity == 0) revert MintZeroQuantity();
1060 
1061         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1062 
1063         // Overflows are incredibly unrealistic.
1064         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1065         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1066         unchecked {
1067             _addressData[to].balance += uint64(quantity);
1068             _addressData[to].numberMinted += uint64(quantity);
1069 
1070             _ownerships[startTokenId].addr = to;
1071             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1072 
1073             uint256 updatedIndex = startTokenId;
1074 
1075             for (uint256 i; i < quantity; i++) {
1076                 emit Transfer(address(0), to, updatedIndex);
1077                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1078                     revert TransferToNonERC721ReceiverImplementer();
1079                 }
1080                 updatedIndex++;
1081             }
1082 
1083             _currentIndex = updatedIndex;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Transfers `tokenId` from `from` to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must be owned by `from`.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) private {
1103         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1104 
1105         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1106             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1107             getApproved(tokenId) == _msgSender());
1108 
1109         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1110         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1111         if (to == address(0)) revert TransferToZeroAddress();
1112 
1113         _beforeTokenTransfers(from, to, tokenId, 1);
1114 
1115         // Clear approvals from the previous owner
1116         _approve(address(0), tokenId, prevOwnership.addr);
1117 
1118         // Underflow of the sender's balance is impossible because we check for
1119         // ownership above and the recipient's balance can't realistically overflow.
1120         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1121         unchecked {
1122             _addressData[from].balance -= 1;
1123             _addressData[to].balance += 1;
1124 
1125             _ownerships[tokenId].addr = to;
1126             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1127 
1128             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1129             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1130             uint256 nextTokenId = tokenId + 1;
1131             if (_ownerships[nextTokenId].addr == address(0)) {
1132                 // This will suffice for checking _exists(nextTokenId),
1133                 // as a burned slot cannot contain the zero address.
1134                 if (nextTokenId < _currentIndex) {
1135                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1136                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1137                 }
1138             }
1139         }
1140 
1141         emit Transfer(from, to, tokenId);
1142         _afterTokenTransfers(from, to, tokenId, 1);
1143     }
1144 
1145     /**
1146      * @dev Destroys `tokenId`.
1147      * The approval is cleared when the token is burned.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _burn(uint256 tokenId) internal virtual {
1156         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1157 
1158         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId, prevOwnership.addr);
1162 
1163         // Underflow of the sender's balance is impossible because we check for
1164         // ownership above and the recipient's balance can't realistically overflow.
1165         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1166         unchecked {
1167             _addressData[prevOwnership.addr].balance -= 1;
1168             _addressData[prevOwnership.addr].numberBurned += 1;
1169 
1170             // Keep track of who burned the token, and the timestamp of burning.
1171             _ownerships[tokenId].addr = prevOwnership.addr;
1172             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1173             _ownerships[tokenId].burned = true;
1174 
1175             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1176             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1177             uint256 nextTokenId = tokenId + 1;
1178             if (_ownerships[nextTokenId].addr == address(0)) {
1179                 // This will suffice for checking _exists(nextTokenId),
1180                 // as a burned slot cannot contain the zero address.
1181                 if (nextTokenId < _currentIndex) {
1182                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1183                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(prevOwnership.addr, address(0), tokenId);
1189         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1190 
1191         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1192         unchecked { 
1193             _burnCounter++;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Approve `to` to operate on `tokenId`
1199      *
1200      * Emits a {Approval} event.
1201      */
1202     function _approve(
1203         address to,
1204         uint256 tokenId,
1205         address owner
1206     ) private {
1207         _tokenApprovals[tokenId] = to;
1208         emit Approval(owner, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1213      * The call is not executed if the target address is not a contract.
1214      *
1215      * @param from address representing the previous owner of the given token ID
1216      * @param to target address that will receive the tokens
1217      * @param tokenId uint256 ID of the token to be transferred
1218      * @param _data bytes optional data to send along with the call
1219      * @return bool whether the call correctly returned the expected magic value
1220      */
1221     function _checkOnERC721Received(
1222         address from,
1223         address to,
1224         uint256 tokenId,
1225         bytes memory _data
1226     ) private returns (bool) {
1227         if (to.isContract()) {
1228             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1229                 return retval == IERC721Receiver(to).onERC721Received.selector;
1230             } catch (bytes memory reason) {
1231                 if (reason.length == 0) {
1232                     revert TransferToNonERC721ReceiverImplementer();
1233                 } else {
1234                     assembly {
1235                         revert(add(32, reason), mload(reason))
1236                     }
1237                 }
1238             }
1239         } else {
1240             return true;
1241         }
1242     }
1243 
1244     /**
1245      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1246      * And also called before burning one token.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, `tokenId` will be burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _beforeTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 
1266     /**
1267      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1268      * minting.
1269      * And also called after one token has been burned.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` has been minted for `to`.
1279      * - When `to` is zero, `tokenId` has been burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _afterTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 }
1289 
1290 contract AbsolutelyNothing is ERC721A, Ownable {
1291     using Strings for uint256;
1292     
1293     uint256 public MAX_SUPPLY = 8888;
1294 
1295     string private BASE_URI;
1296     string private UNREVEAL_URI;
1297 
1298     uint256 public PUBLIC_MINT_LIMIT = MAX_SUPPLY;
1299 
1300     uint256 public SALE_STEP = 0; // 0 => NONE, 1 => START
1301 
1302     constructor() ERC721A("Absolutely Nothing NFT", "ABN") {}
1303 
1304     function setPublicMintLimit(uint256 _publicMintLimit) external onlyOwner {
1305         PUBLIC_MINT_LIMIT = _publicMintLimit;
1306     }
1307     
1308     function numberMinted(address _owner) public view returns (uint256) {
1309         return _numberMinted(_owner);
1310     }
1311 
1312     function mintPublic(uint256 _mintAmount) external {
1313         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1314 
1315         require(SALE_STEP == 1, "Public Sale is not opened");
1316 
1317         require((numberMinted(msg.sender) + _mintAmount) <= PUBLIC_MINT_LIMIT, "Exceeds Max Mint Amount");
1318 
1319         _mintLoop(msg.sender, _mintAmount);
1320     }
1321 
1322     function airdrop(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
1323         require(totalSupply() + _airdropAddresses.length * _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1324 
1325         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1326             address to = _airdropAddresses[i];
1327             _mintLoop(to, _mintAmount);
1328         }
1329     }
1330 
1331     function _baseURI() internal view virtual override returns (string memory) {
1332         return BASE_URI;
1333     }
1334 
1335     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1336         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1337         string memory currentBaseURI = _baseURI();
1338         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
1339     }
1340 
1341     function setMaxSupply(uint256 _supply) external onlyOwner {
1342         MAX_SUPPLY = _supply;
1343     }
1344 
1345     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1346         BASE_URI = _newBaseURI;
1347     }
1348 
1349     function setUnrevealURI(string memory _newUnrevealURI) external onlyOwner {
1350         UNREVEAL_URI = _newUnrevealURI;
1351     }
1352 
1353     function setSaleStep(uint256 _saleStep) external onlyOwner {
1354         SALE_STEP = _saleStep;
1355     }
1356 
1357     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1358         _safeMint(_receiver, _mintAmount);
1359     }
1360 
1361     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1362         return ownershipOf(tokenId);
1363     }
1364 
1365     function withdraw() external onlyOwner {
1366         uint256 curBalance = address(this).balance;
1367         payable(msg.sender).transfer(curBalance);
1368     }
1369 }