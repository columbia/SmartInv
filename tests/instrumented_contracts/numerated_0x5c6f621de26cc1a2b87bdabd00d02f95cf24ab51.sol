1 // SPDX-License-Identifier: MIT
2 
3 //V2 Phunks is an NFT project created in 2022 with 10,000 sorta randomly generated V2 Phunks on the Ethereum blockchain.
4 
5 //The original left-behind punks, now facing left.
6 
7 //Created by the CryptoPhunks community. Not affiliated with Larva Labs
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Metadata is IERC721 {
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
568 
569 
570 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Enumerable is IERC721 {
580     /**
581      * @dev Returns the total amount of tokens stored by the contract.
582      */
583     function totalSupply() external view returns (uint256);
584 
585     /**
586      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
587      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
588      */
589     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
590 
591     /**
592      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
593      * Use along with {totalSupply} to enumerate all tokens.
594      */
595     function tokenByIndex(uint256 index) external view returns (uint256);
596 }
597 
598 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Contract module that helps prevent reentrant calls to a function.
607  *
608  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
609  * available, which can be applied to functions to make sure there are no nested
610  * (reentrant) calls to them.
611  *
612  * Note that because there is a single `nonReentrant` guard, functions marked as
613  * `nonReentrant` may not call one another. This can be worked around by making
614  * those functions `private`, and then adding `external` `nonReentrant` entry
615  * points to them.
616  *
617  * TIP: If you would like to learn more about reentrancy and alternative ways
618  * to protect against it, check out our blog post
619  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
620  */
621 abstract contract ReentrancyGuard {
622     // Booleans are more expensive than uint256 or any type that takes up a full
623     // word because each write operation emits an extra SLOAD to first read the
624     // slot's contents, replace the bits taken up by the boolean, and then write
625     // back. This is the compiler's defense against contract upgrades and
626     // pointer aliasing, and it cannot be disabled.
627 
628     // The values being non-zero value makes deployment a bit more expensive,
629     // but in exchange the refund on every call to nonReentrant will be lower in
630     // amount. Since refunds are capped to a percentage of the total
631     // transaction's gas, it is best to keep them low in cases like this one, to
632     // increase the likelihood of the full refund coming into effect.
633     uint256 private constant _NOT_ENTERED = 1;
634     uint256 private constant _ENTERED = 2;
635 
636     uint256 private _status;
637 
638     constructor() {
639         _status = _NOT_ENTERED;
640     }
641 
642     /**
643      * @dev Prevents a contract from calling itself, directly or indirectly.
644      * Calling a `nonReentrant` function from another `nonReentrant`
645      * function is not supported. It is possible to prevent this from happening
646      * by making the `nonReentrant` function external, and making it call a
647      * `private` function that does the actual work.
648      */
649     modifier nonReentrant() {
650         // On the first call to nonReentrant, _notEntered will be true
651         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
652 
653         // Any calls to nonReentrant after this point will fail
654         _status = _ENTERED;
655 
656         _;
657 
658         // By storing the original value once again, a refund is triggered (see
659         // https://eips.ethereum.org/EIPS/eip-2200)
660         _status = _NOT_ENTERED;
661     }
662 }
663 
664 // File: @openzeppelin/contracts/utils/Context.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Provides information about the current execution context, including the
673  * sender of the transaction and its data. While these are generally available
674  * via msg.sender and msg.data, they should not be accessed in such a direct
675  * manner, since when dealing with meta-transactions the account sending and
676  * paying for execution may not be the actual sender (as far as an application
677  * is concerned).
678  *
679  * This contract is only required for intermediate, library-like contracts.
680  */
681 abstract contract Context {
682     function _msgSender() internal view virtual returns (address) {
683         return msg.sender;
684     }
685 
686     function _msgData() internal view virtual returns (bytes calldata) {
687         return msg.data;
688     }
689 }
690 
691 // File: @openzeppelin/contracts/access/Ownable.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Contract module which provides a basic access control mechanism, where
701  * there is an account (an owner) that can be granted exclusive access to
702  * specific functions.
703  *
704  * By default, the owner account will be the one that deploys the contract. This
705  * can later be changed with {transferOwnership}.
706  *
707  * This module is used through inheritance. It will make available the modifier
708  * `onlyOwner`, which can be applied to your functions to restrict their use to
709  * the owner.
710  */
711 abstract contract Ownable is Context {
712     address private _owner;
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
734         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
769 // File:
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
1267 contract V2Phunks  is ERC721A, Ownable, ReentrancyGuard {
1268     string public baseURI           = "ipfs/";
1269     uint   public price             = 0.002 ether;
1270     uint   public maxPerTx          = 10;
1271     uint   public maxPerFree        = 0;
1272     uint   public totalFree         = 0;
1273     uint   public maxSupply         = 10000;
1274     bool   public mintEnabled       = false;
1275 
1276     mapping(address => uint256) private _mintedFreeAmount;
1277 
1278     constructor() ERC721A("V2 Phunks", "V2PHUNKS"){}
1279 
1280 
1281     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1282         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1283         string memory currentBaseURI = _baseURI();
1284         return bytes(currentBaseURI).length > 0
1285             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1286             : "";
1287     }
1288 
1289     function mint(uint256 count) external payable {
1290         uint256 cost = price;
1291         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1292             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1293 
1294         if (isFree) {
1295             cost = 0;
1296             _mintedFreeAmount[msg.sender] += count;
1297         }
1298 
1299         require(msg.value >= count * cost, "Please send the exact amount.");
1300         require(totalSupply() + count <= maxSupply, "No more");
1301         require(mintEnabled, "Minting is not live yet..");
1302         require(count <= maxPerTx, "Max per TX reached.");
1303 
1304         _safeMint(msg.sender, count);
1305     }
1306 
1307     function toggleMinting() external onlyOwner {
1308       mintEnabled = !mintEnabled;
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
1327 
1328 
1329 }