1 // SPDX-License-Identifier: MIT
2 
3 
4 // GIFPUNKS SMART CONTRACT
5 
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Address.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
81 
82 pragma solidity ^0.8.1;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      *
105      * [IMPORTANT]
106      * ====
107      * You shouldn't rely on `isContract` to protect against flash loan attacks!
108      *
109      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
110      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
111      * constructor.
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize/address.code.length, which returns 0
116         // for contracts in construction, since the code is only stored at the end
117         // of the constructor execution.
118 
119         return account.code.length > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         (bool success, ) = recipient.call{value: amount}("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain `call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.call{value: value}(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(isContract(target), "Address: delegate call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.delegatecall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
275      * revert reason using the provided one.
276      *
277      * _Available since v4.3._
278      */
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @title ERC721 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  * from ERC721 asset contracts.
313  */
314 interface IERC721Receiver {
315     /**
316      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
317      * by `operator` from `from`, this function is called.
318      *
319      * It must return its Solidity selector to confirm the token transfer.
320      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
321      *
322      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
323      */
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Interface of the ERC165 standard, as defined in the
341  * https://eips.ethereum.org/EIPS/eip-165[EIP].
342  *
343  * Implementers can declare support of contract interfaces, which can then be
344  * queried by others ({ERC165Checker}).
345  *
346  * For an implementation, see {ERC165}.
347  */
348 interface IERC165 {
349     /**
350      * @dev Returns true if this contract implements the interface defined by
351      * `interfaceId`. See the corresponding
352      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
353      * to learn more about how these ids are created.
354      *
355      * This function call must use less than 30 000 gas.
356      */
357     function supportsInterface(bytes4 interfaceId) external view returns (bool);
358 }
359 
360 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Implementation of the {IERC165} interface.
370  *
371  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
372  * for the additional interface id that will be supported. For example:
373  *
374  * ```solidity
375  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
377  * }
378  * ```
379  *
380  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
381  */
382 abstract contract ERC165 is IERC165 {
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      */
386     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387         return interfaceId == type(IERC165).interfaceId;
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
392 
393 
394 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Required interface of an ERC721 compliant contract.
401  */
402 interface IERC721 is IERC165 {
403     /**
404      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
410      */
411     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
415      */
416     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
417 
418     /**
419      * @dev Returns the number of tokens in ``owner``'s account.
420      */
421     function balanceOf(address owner) external view returns (uint256 balance);
422 
423     /**
424      * @dev Returns the owner of the `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId,
449         bytes calldata data
450     ) external;
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
454      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Transfers `tokenId` token from `from` to `to`.
474      *
475      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must be owned by `from`.
482      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
483      *
484      * Emits a {Transfer} event.
485      */
486     function transferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
494      * The approval is cleared when the token is transferred.
495      *
496      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
497      *
498      * Requirements:
499      *
500      * - The caller must own the token or be an approved operator.
501      * - `tokenId` must exist.
502      *
503      * Emits an {Approval} event.
504      */
505     function approve(address to, uint256 tokenId) external;
506 
507     /**
508      * @dev Approve or remove `operator` as an operator for the caller.
509      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
510      *
511      * Requirements:
512      *
513      * - The `operator` cannot be the caller.
514      *
515      * Emits an {ApprovalForAll} event.
516      */
517     function setApprovalForAll(address operator, bool _approved) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
530      *
531      * See {setApprovalForAll}
532      */
533     function isApprovedForAll(address owner, address operator) external view returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 interface IERC721Metadata is IERC721 {
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() external view returns (string memory);
553 
554     /**
555      * @dev Returns the token collection symbol.
556      */
557     function symbol() external view returns (string memory);
558 
559     /**
560      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
561      */
562     function tokenURI(uint256 tokenId) external view returns (string memory);
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
566 
567 
568 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://eips.ethereum.org/EIPS/eip-721
576  */
577 interface IERC721Enumerable is IERC721 {
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
585      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
586      */
587     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
588 
589     /**
590      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
591      * Use along with {totalSupply} to enumerate all tokens.
592      */
593     function tokenByIndex(uint256 index) external view returns (uint256);
594 }
595 
596 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Contract module that helps prevent reentrant calls to a function.
605  *
606  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
607  * available, which can be applied to functions to make sure there are no nested
608  * (reentrant) calls to them.
609  *
610  * Note that because there is a single `nonReentrant` guard, functions marked as
611  * `nonReentrant` may not call one another. This can be worked around by making
612  * those functions `private`, and then adding `external` `nonReentrant` entry
613  * points to them.
614  *
615  * TIP: If you would like to learn more about reentrancy and alternative ways
616  * to protect against it, check out our blog post
617  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
618  */
619 abstract contract ReentrancyGuard {
620     // Booleans are more expensive than uint256 or any type that takes up a full
621     // word because each write operation emits an extra SLOAD to first read the
622     // slot's contents, replace the bits taken up by the boolean, and then write
623     // back. This is the compiler's defense against contract upgrades and
624     // pointer aliasing, and it cannot be disabled.
625 
626     // The values being non-zero value makes deployment a bit more expensive,
627     // but in exchange the refund on every call to nonReentrant will be lower in
628     // amount. Since refunds are capped to a percentage of the total
629     // transaction's gas, it is best to keep them low in cases like this one, to
630     // increase the likelihood of the full refund coming into effect.
631     uint256 private constant _NOT_ENTERED = 1;
632     uint256 private constant _ENTERED = 2;
633 
634     uint256 private _status;
635 
636     constructor() {
637         _status = _NOT_ENTERED;
638     }
639 
640     /**
641      * @dev Prevents a contract from calling itself, directly or indirectly.
642      * Calling a `nonReentrant` function from another `nonReentrant`
643      * function is not supported. It is possible to prevent this from happening
644      * by making the `nonReentrant` function external, and making it call a
645      * `private` function that does the actual work.
646      */
647     modifier nonReentrant() {
648         // On the first call to nonReentrant, _notEntered will be true
649         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
650 
651         // Any calls to nonReentrant after this point will fail
652         _status = _ENTERED;
653 
654         _;
655 
656         // By storing the original value once again, a refund is triggered (see
657         // https://eips.ethereum.org/EIPS/eip-2200)
658         _status = _NOT_ENTERED;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/utils/Context.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Provides information about the current execution context, including the
671  * sender of the transaction and its data. While these are generally available
672  * via msg.sender and msg.data, they should not be accessed in such a direct
673  * manner, since when dealing with meta-transactions the account sending and
674  * paying for execution may not be the actual sender (as far as an application
675  * is concerned).
676  *
677  * This contract is only required for intermediate, library-like contracts.
678  */
679 abstract contract Context {
680     function _msgSender() internal view virtual returns (address) {
681         return msg.sender;
682     }
683 
684     function _msgData() internal view virtual returns (bytes calldata) {
685         return msg.data;
686     }
687 }
688 
689 // File: @openzeppelin/contracts/access/Ownable.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Contract module which provides a basic access control mechanism, where
699  * there is an account (an owner) that can be granted exclusive access to
700  * specific functions.
701  *
702  * By default, the owner account will be the one that deploys the contract. This
703  * can later be changed with {transferOwnership}.
704  *
705  * This module is used through inheritance. It will make available the modifier
706  * `onlyOwner`, which can be applied to your functions to restrict their use to
707  * the owner.
708  */
709 abstract contract Ownable is Context {
710     address private _owner;
711 
712     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
713 
714     /**
715      * @dev Initializes the contract setting the deployer as the initial owner.
716      */
717     constructor() {
718         _transferOwnership(_msgSender());
719     }
720 
721     /**
722      * @dev Returns the address of the current owner.
723      */
724     function owner() public view virtual returns (address) {
725         return _owner;
726     }
727 
728     /**
729      * @dev Throws if called by any account other than the owner.
730      */
731     modifier onlyOwner() {
732         require(owner() == _msgSender(), "Ownable: caller is not the owner");
733         _;
734     }
735 
736     /**
737      * @dev Leaves the contract without owner. It will not be possible to call
738      * `onlyOwner` functions anymore. Can only be called by the current owner.
739      *
740      * NOTE: Renouncing ownership will leave the contract without an owner,
741      * thereby removing any functionality that is only available to the owner.
742      */
743     function renounceOwnership() public virtual onlyOwner {
744         _transferOwnership(address(0));
745     }
746 
747     /**
748      * @dev Transfers ownership of the contract to a new account (`newOwner`).
749      * Can only be called by the current owner.
750      */
751     function transferOwnership(address newOwner) public virtual onlyOwner {
752         require(newOwner != address(0), "Ownable: new owner is the zero address");
753         _transferOwnership(newOwner);
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (`newOwner`).
758      * Internal function without access restriction.
759      */
760     function _transferOwnership(address newOwner) internal virtual {
761         address oldOwner = _owner;
762         _owner = newOwner;
763         emit OwnershipTransferred(oldOwner, newOwner);
764     }
765 }
766 
767 // File:
768 
769 
770 pragma solidity ^0.8.0;
771 
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
786  *
787  * Does not support burning tokens to address(0).
788  *
789  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
790  */
791 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
792     using Address for address;
793     using Strings for uint256;
794 
795     struct TokenOwnership {
796         address addr;
797         uint64 startTimestamp;
798     }
799 
800     struct AddressData {
801         uint128 balance;
802         uint128 numberMinted;
803     }
804 
805     uint256 internal currentIndex;
806 
807     // Token name
808     string private _name;
809 
810     // Token symbol
811     string private _symbol;
812 
813     // Mapping from token ID to ownership details
814     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
815     mapping(uint256 => TokenOwnership) internal _ownerships;
816 
817     // Mapping owner address to address data
818     mapping(address => AddressData) private _addressData;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     constructor(string memory name_, string memory symbol_) {
827         _name = name_;
828         _symbol = symbol_;
829     }
830 
831     /**
832      * @dev See {IERC721Enumerable-totalSupply}.
833      */
834     function totalSupply() public view override returns (uint256) {
835         return currentIndex;
836     }
837 
838     /**
839      * @dev See {IERC721Enumerable-tokenByIndex}.
840      */
841     function tokenByIndex(uint256 index) public view override returns (uint256) {
842         require(index < totalSupply(), "ERC721A: global index out of bounds");
843         return index;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
848      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
849      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
850      */
851     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
852         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
853         uint256 numMintedSoFar = totalSupply();
854         uint256 tokenIdsIdx;
855         address currOwnershipAddr;
856 
857         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
858         unchecked {
859             for (uint256 i; i < numMintedSoFar; i++) {
860                 TokenOwnership memory ownership = _ownerships[i];
861                 if (ownership.addr != address(0)) {
862                     currOwnershipAddr = ownership.addr;
863                 }
864                 if (currOwnershipAddr == owner) {
865                     if (tokenIdsIdx == index) {
866                         return i;
867                     }
868                     tokenIdsIdx++;
869                 }
870             }
871         }
872 
873         revert("ERC721A: unable to get token of owner by index");
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
880         return
881             interfaceId == type(IERC721).interfaceId ||
882             interfaceId == type(IERC721Metadata).interfaceId ||
883             interfaceId == type(IERC721Enumerable).interfaceId ||
884             super.supportsInterface(interfaceId);
885     }
886 
887     /**
888      * @dev See {IERC721-balanceOf}.
889      */
890     function balanceOf(address owner) public view override returns (uint256) {
891         require(owner != address(0), "ERC721A: balance query for the zero address");
892         return uint256(_addressData[owner].balance);
893     }
894 
895     function _numberMinted(address owner) internal view returns (uint256) {
896         require(owner != address(0), "ERC721A: number minted query for the zero address");
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
906 
907         unchecked {
908             for (uint256 curr = tokenId; curr >= 0; curr--) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (ownership.addr != address(0)) {
911                     return ownership;
912                 }
913             }
914         }
915 
916         revert("ERC721A: unable to determine the owner of token");
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view override returns (address) {
923         return ownershipOf(tokenId).addr;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, can be overriden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return "";
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public override {
963         address owner = ERC721A.ownerOf(tokenId);
964         require(to != owner, "ERC721A: approval to current owner");
965 
966         require(
967             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
968             "ERC721A: approve caller is not owner nor approved for all"
969         );
970 
971         _approve(to, tokenId, owner);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view override returns (address) {
978         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved) public override {
987         require(operator != _msgSender(), "ERC721A: approve to caller");
988 
989         _operatorApprovals[_msgSender()][operator] = approved;
990         emit ApprovalForAll(_msgSender(), operator, approved);
991     }
992 
993     /**
994      * @dev See {IERC721-isApprovedForAll}.
995      */
996     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
997         return _operatorApprovals[owner][operator];
998     }
999 
1000     /**
1001      * @dev See {IERC721-transferFrom}.
1002      */
1003     function transferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
1008         _transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, "");
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public override {
1031         _transfer(from, to, tokenId);
1032         require(
1033             _checkOnERC721Received(from, to, tokenId, _data),
1034             "ERC721A: transfer to non ERC721Receiver implementer"
1035         );
1036     }
1037 
1038     /**
1039      * @dev Returns whether `tokenId` exists.
1040      *
1041      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1042      *
1043      * Tokens start existing when they are minted (`_mint`),
1044      */
1045     function _exists(uint256 tokenId) internal view returns (bool) {
1046         return tokenId < currentIndex;
1047     }
1048 
1049     function _safeMint(address to, uint256 quantity) internal {
1050         _safeMint(to, quantity, "");
1051     }
1052 
1053     /**
1054      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 quantity,
1066         bytes memory _data
1067     ) internal {
1068         _mint(to, quantity, _data, true);
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _mint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data,
1085         bool safe
1086     ) internal {
1087         uint256 startTokenId = currentIndex;
1088         require(to != address(0), "ERC721A: mint to the zero address");
1089         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1090 
1091         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1092 
1093         // Overflows are incredibly unrealistic.
1094         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1095         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1096         unchecked {
1097             _addressData[to].balance += uint128(quantity);
1098             _addressData[to].numberMinted += uint128(quantity);
1099 
1100             _ownerships[startTokenId].addr = to;
1101             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1102 
1103             uint256 updatedIndex = startTokenId;
1104 
1105             for (uint256 i; i < quantity; i++) {
1106                 emit Transfer(address(0), to, updatedIndex);
1107                 if (safe) {
1108                     require(
1109                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1110                         "ERC721A: transfer to non ERC721Receiver implementer"
1111                     );
1112                 }
1113 
1114                 updatedIndex++;
1115             }
1116 
1117             currentIndex = updatedIndex;
1118         }
1119 
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) private {
1138         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1139 
1140         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1141             getApproved(tokenId) == _msgSender() ||
1142             isApprovedForAll(prevOwnership.addr, _msgSender()));
1143 
1144         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1145 
1146         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1147         require(to != address(0), "ERC721A: transfer to the zero address");
1148 
1149         _beforeTokenTransfers(from, to, tokenId, 1);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId, prevOwnership.addr);
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1157         unchecked {
1158             _addressData[from].balance -= 1;
1159             _addressData[to].balance += 1;
1160 
1161             _ownerships[tokenId].addr = to;
1162             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1163 
1164             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1165             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1166             uint256 nextTokenId = tokenId + 1;
1167             if (_ownerships[nextTokenId].addr == address(0)) {
1168                 if (_exists(nextTokenId)) {
1169                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1170                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1171                 }
1172             }
1173         }
1174 
1175         emit Transfer(from, to, tokenId);
1176         _afterTokenTransfers(from, to, tokenId, 1);
1177     }
1178 
1179     /**
1180      * @dev Approve `to` to operate on `tokenId`
1181      *
1182      * Emits a {Approval} event.
1183      */
1184     function _approve(
1185         address to,
1186         uint256 tokenId,
1187         address owner
1188     ) private {
1189         _tokenApprovals[tokenId] = to;
1190         emit Approval(owner, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1195      * The call is not executed if the target address is not a contract.
1196      *
1197      * @param from address representing the previous owner of the given token ID
1198      * @param to target address that will receive the tokens
1199      * @param tokenId uint256 ID of the token to be transferred
1200      * @param _data bytes optional data to send along with the call
1201      * @return bool whether the call correctly returned the expected magic value
1202      */
1203     function _checkOnERC721Received(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) private returns (bool) {
1209         if (to.isContract()) {
1210             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1211                 return retval == IERC721Receiver(to).onERC721Received.selector;
1212             } catch (bytes memory reason) {
1213                 if (reason.length == 0) {
1214                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1215                 } else {
1216                     assembly {
1217                         revert(add(32, reason), mload(reason))
1218                     }
1219                 }
1220             }
1221         } else {
1222             return true;
1223         }
1224     }
1225 
1226     /**
1227      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1228      *
1229      * startTokenId - the first token id to be transferred
1230      * quantity - the amount to be transferred
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      */
1238     function _beforeTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1247      * minting.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _afterTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 }
1264 
1265 contract GIFPUNKS  is ERC721A, Ownable, ReentrancyGuard {
1266     string public baseURI           = "ipfs/";
1267     uint   public price             = 0.005 ether;
1268     uint   public maxPerTx          = 20;
1269     uint   public maxPerFree        = 3;
1270     uint   public totalFree         = 10000;
1271     uint   public maxSupply         = 10000;
1272     bool   public mintEnabled       = false;
1273 
1274     mapping(address => uint256) private _mintedFreeAmount;
1275 
1276     constructor() ERC721A("GIFPUNKS", "GIFPNK"){}
1277 
1278 
1279     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1280         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1281         string memory currentBaseURI = _baseURI();
1282         return bytes(currentBaseURI).length > 0
1283             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1284             : "";
1285     }
1286 
1287     function mint(uint256 count) external payable {
1288         uint256 cost = price;
1289         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1290             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1291 
1292         if (isFree) {
1293             cost = 0;
1294             _mintedFreeAmount[msg.sender] += count;
1295         }
1296 
1297         require(msg.value >= count * cost, "Please send the exact amount.");
1298         require(totalSupply() + count <= maxSupply, "No more");
1299         require(mintEnabled, "Minting is not live yet..");
1300         require(count <= maxPerTx, "Max per TX reached.");
1301 
1302         _safeMint(msg.sender, count);
1303     }
1304 
1305     function toggleMinting() external onlyOwner {
1306       mintEnabled = !mintEnabled;
1307     }
1308 
1309     function _baseURI() internal view virtual override returns (string memory) {
1310         return baseURI;
1311     }
1312 
1313     function setBaseUri(string memory baseuri_) public onlyOwner {
1314         baseURI = baseuri_;
1315     }
1316 
1317     function setPrice(uint256 price_) external onlyOwner {
1318         price = price_;
1319     }
1320 
1321     function withdraw() external onlyOwner nonReentrant {
1322         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1323         require(success, "Transfer failed.");
1324     }
1325 
1326 
1327 }