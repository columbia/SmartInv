1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId,
79         bytes calldata data
80     ) external;
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns the account approved for `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function getApproved(uint256 tokenId) external view returns (address operator);
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator) external view returns (bool);
164 }
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/structs/BitMaps.sol)
167 
168 /**
169  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
170  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
171  */
172 library BitMaps {
173     struct BitMap {
174         mapping(uint256 => uint256) _data;
175     }
176 
177     /**
178      * @dev Returns whether the bit at `index` is set.
179      */
180     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
181         uint256 bucket = index >> 8;
182         uint256 mask = 1 << (index & 0xff);
183         return bitmap._data[bucket] & mask != 0;
184     }
185 
186     /**
187      * @dev Sets the bit at `index` to the boolean `value`.
188      */
189     function setTo(
190         BitMap storage bitmap,
191         uint256 index,
192         bool value
193     ) internal {
194         if (value) {
195             set(bitmap, index);
196         } else {
197             unset(bitmap, index);
198         }
199     }
200 
201     /**
202      * @dev Sets the bit at `index`.
203      */
204     function set(BitMap storage bitmap, uint256 index) internal {
205         uint256 bucket = index >> 8;
206         uint256 mask = 1 << (index & 0xff);
207         bitmap._data[bucket] |= mask;
208     }
209 
210     /**
211      * @dev Unsets the bit at `index`.
212      */
213     function unset(BitMap storage bitmap, uint256 index) internal {
214         uint256 bucket = index >> 8;
215         uint256 mask = 1 << (index & 0xff);
216         bitmap._data[bucket] &= ~mask;
217     }
218 }
219 
220 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
221 
222 /**
223  * @dev Contract module that helps prevent reentrant calls to a function.
224  *
225  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
226  * available, which can be applied to functions to make sure there are no nested
227  * (reentrant) calls to them.
228  *
229  * Note that because there is a single `nonReentrant` guard, functions marked as
230  * `nonReentrant` may not call one another. This can be worked around by making
231  * those functions `private`, and then adding `external` `nonReentrant` entry
232  * points to them.
233  *
234  * TIP: If you would like to learn more about reentrancy and alternative ways
235  * to protect against it, check out our blog post
236  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
237  */
238 abstract contract ReentrancyGuard {
239     // Booleans are more expensive than uint256 or any type that takes up a full
240     // word because each write operation emits an extra SLOAD to first read the
241     // slot's contents, replace the bits taken up by the boolean, and then write
242     // back. This is the compiler's defense against contract upgrades and
243     // pointer aliasing, and it cannot be disabled.
244 
245     // The values being non-zero value makes deployment a bit more expensive,
246     // but in exchange the refund on every call to nonReentrant will be lower in
247     // amount. Since refunds are capped to a percentage of the total
248     // transaction's gas, it is best to keep them low in cases like this one, to
249     // increase the likelihood of the full refund coming into effect.
250     uint256 private constant _NOT_ENTERED = 1;
251     uint256 private constant _ENTERED = 2;
252 
253     uint256 private _status;
254 
255     constructor() {
256         _status = _NOT_ENTERED;
257     }
258 
259     /**
260      * @dev Prevents a contract from calling itself, directly or indirectly.
261      * Calling a `nonReentrant` function from another `nonReentrant`
262      * function is not supported. It is possible to prevent this from happening
263      * by making the `nonReentrant` function external, and making it call a
264      * `private` function that does the actual work.
265      */
266     modifier nonReentrant() {
267         _nonReentrantBefore();
268         _;
269         _nonReentrantAfter();
270     }
271 
272     function _nonReentrantBefore() private {
273         // On the first call to nonReentrant, _notEntered will be true
274         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
275 
276         // Any calls to nonReentrant after this point will fail
277         _status = _ENTERED;
278     }
279 
280     function _nonReentrantAfter() private {
281         // By storing the original value once again, a refund is triggered (see
282         // https://eips.ethereum.org/EIPS/eip-2200)
283         _status = _NOT_ENTERED;
284     }
285 }
286 
287 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
303      */
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
313 
314 /**
315  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
316  * @dev See https://eips.ethereum.org/EIPS/eip-721
317  */
318 interface IERC721Metadata is IERC721 {
319     /**
320      * @dev Returns the token collection name.
321      */
322     function name() external view returns (string memory);
323 
324     /**
325      * @dev Returns the token collection symbol.
326      */
327     function symbol() external view returns (string memory);
328 
329     /**
330      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
331      */
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      *
358      * [IMPORTANT]
359      * ====
360      * You shouldn't rely on `isContract` to protect against flash loan attacks!
361      *
362      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
363      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
364      * constructor.
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize/address.code.length, which returns 0
369         // for contracts in construction, since the code is only stored at the end
370         // of the constructor execution.
371 
372         return account.code.length > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         (bool success, bytes memory returndata) = target.call{value: value}(data);
467         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
477         return functionStaticCall(target, data, "Address: low-level static call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal view returns (bytes memory) {
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
522      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
523      *
524      * _Available since v4.8._
525      */
526     function verifyCallResultFromTarget(
527         address target,
528         bool success,
529         bytes memory returndata,
530         string memory errorMessage
531     ) internal view returns (bytes memory) {
532         if (success) {
533             if (returndata.length == 0) {
534                 // only check isContract if the call was successful and the return data is empty
535                 // otherwise we already know that it was a contract
536                 require(isContract(target), "Address: call to non-contract");
537             }
538             return returndata;
539         } else {
540             _revert(returndata, errorMessage);
541         }
542     }
543 
544     /**
545      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason or using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             _revert(returndata, errorMessage);
559         }
560     }
561 
562     function _revert(bytes memory returndata, string memory errorMessage) private pure {
563         // Look for revert reason and bubble it up if present
564         if (returndata.length > 0) {
565             // The easiest way to bubble the revert reason is using memory via assembly
566             /// @solidity memory-safe-assembly
567             assembly {
568                 let returndata_size := mload(returndata)
569                 revert(add(32, returndata), returndata_size)
570             }
571         } else {
572             revert(errorMessage);
573         }
574     }
575 }
576 
577 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
578 
579 /**
580  * @dev Provides information about the current execution context, including the
581  * sender of the transaction and its data. While these are generally available
582  * via msg.sender and msg.data, they should not be accessed in such a direct
583  * manner, since when dealing with meta-transactions the account sending and
584  * paying for execution may not be the actual sender (as far as an application
585  * is concerned).
586  *
587  * This contract is only required for intermediate, library-like contracts.
588  */
589 abstract contract Context {
590     function _msgSender() internal view virtual returns (address) {
591         return msg.sender;
592     }
593 
594     function _msgData() internal view virtual returns (bytes calldata) {
595         return msg.data;
596     }
597 }
598 
599 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
600 
601 /**
602  * @dev String operations.
603  */
604 library Strings {
605     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
606     uint8 private constant _ADDRESS_LENGTH = 20;
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
610      */
611     function toString(uint256 value) internal pure returns (string memory) {
612         // Inspired by OraclizeAPI's implementation - MIT licence
613         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
614 
615         if (value == 0) {
616             return "0";
617         }
618         uint256 temp = value;
619         uint256 digits;
620         while (temp != 0) {
621             digits++;
622             temp /= 10;
623         }
624         bytes memory buffer = new bytes(digits);
625         while (value != 0) {
626             digits -= 1;
627             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
628             value /= 10;
629         }
630         return string(buffer);
631     }
632 
633     /**
634      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
635      */
636     function toHexString(uint256 value) internal pure returns (string memory) {
637         if (value == 0) {
638             return "0x00";
639         }
640         uint256 temp = value;
641         uint256 length = 0;
642         while (temp != 0) {
643             length++;
644             temp >>= 8;
645         }
646         return toHexString(value, length);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
651      */
652     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
653         bytes memory buffer = new bytes(2 * length + 2);
654         buffer[0] = "0";
655         buffer[1] = "x";
656         for (uint256 i = 2 * length + 1; i > 1; --i) {
657             buffer[i] = _HEX_SYMBOLS[value & 0xf];
658             value >>= 4;
659         }
660         require(value == 0, "Strings: hex length insufficient");
661         return string(buffer);
662     }
663 
664     /**
665      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
666      */
667     function toHexString(address addr) internal pure returns (string memory) {
668         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
669     }
670 }
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 error ApprovalCallerNotOwnerNorApproved();
698 error ApprovalQueryForNonexistentToken();
699 error ApproveToCaller();
700 error ApprovalToCurrentOwner();
701 error BalanceQueryForZeroAddress();
702 error MintToZeroAddress();
703 error MintZeroQuantity();
704 error TokenDataQueryForNonexistentToken();
705 error OwnerQueryForNonexistentToken();
706 error OperatorQueryForNonexistentToken();
707 error TransferCallerNotOwnerNorApproved();
708 error TransferFromIncorrectOwner();
709 error TransferToNonERC721ReceiverImplementer();
710 error TransferToZeroAddress();
711 error URIQueryForNonexistentToken();
712 
713 contract Rookies is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     using Strings for uint256;
716 
717     struct TokenData {
718         address owner;
719         bytes12 aux;
720     }
721 
722     uint256 private immutable MAX_SUPPLY;
723     uint256 private constant maxBatchSize = 5;
724 
725     mapping(uint256 => TokenData) private tokens;
726 
727     uint256 public currentSupply;
728     string public override name = "RKL Rookies";
729     string public override symbol = "ROOKIES";
730     string public baseURI;
731     address private admin;
732 
733     mapping(uint256 => address) private tokenApprovals;
734     mapping(address => mapping(address => bool)) private operatorApprovals;
735 
736     constructor(uint256 maxSupply) {
737         MAX_SUPPLY = maxSupply;
738         admin = address(msg.sender);
739     }
740 
741     /// EFFECTS ///
742 
743     function mint(uint256 amount, address to) internal {
744         require(currentSupply + amount <= MAX_SUPPLY, "Exceeds max supply");
745         _safeMint(to, amount);
746     }
747 
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory data
753     )
754         public
755         virtual
756         override
757     {
758         TokenData memory token = _tokenData(tokenId);
759         if (!_isApprovedOrOwner(_msgSender(), tokenId, token.owner)) {
760             revert TransferCallerNotOwnerNorApproved();
761         }
762         _safeTransfer(from, to, tokenId, token, data);
763     }
764 
765     function transferFrom(address from, address to, uint256 tokenId)
766         public
767         virtual
768         override
769     {
770         TokenData memory token = _tokenData(tokenId);
771         if (!_isApprovedOrOwner(_msgSender(), tokenId, token.owner)) {
772             revert TransferCallerNotOwnerNorApproved();
773         }
774         _transfer(from, to, tokenId, token);
775     }
776 
777     function approve(address to, uint256 tokenId) public virtual override {
778         TokenData memory token = _tokenData(tokenId);
779         address owner = token.owner;
780         if (to == owner) {
781             revert ApprovalToCurrentOwner();
782         }
783         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
784             revert ApprovalCallerNotOwnerNorApproved();
785         }
786         _approve(to, tokenId, token);
787     }
788 
789     function setApprovalForAll(address operator, bool approved)
790         public
791         virtual
792         override
793     {
794         if (operator == _msgSender()) {
795             revert ApproveToCaller();
796         }
797         operatorApprovals[_msgSender()][operator] = approved;
798         emit ApprovalForAll(_msgSender(), operator, approved);
799     }
800 
801     function _safeTransfer(
802         address from,
803         address to,
804         uint256 tokenId,
805         TokenData memory token,
806         bytes memory data
807     )
808         internal
809         virtual
810     {
811         _transfer(from, to, tokenId, token);
812         if (to.isContract() && !_checkOnERC721Received(from, to, tokenId, data))
813         {
814             revert TransferToNonERC721ReceiverImplementer();
815         }
816     }
817 
818     function _safeMint(address to, uint256 quantity, bytes memory data)
819         internal
820         virtual
821     {
822         _mint(to, quantity);
823         if (to.isContract()) {
824             unchecked {
825                 for (uint256 i; i < quantity; ++i) {
826                     if (
827                         !_checkOnERC721Received(address(0), to, currentSupply + i, data)
828                     ) {
829                         revert TransferToNonERC721ReceiverImplementer();
830                     }
831                 }
832             }
833         }
834     }
835 
836     function _mint(address to, uint256 quantity) internal virtual {
837         if (to == address(0)) {
838             revert MintToZeroAddress();
839         }
840         if (quantity == 0) {
841             revert MintZeroQuantity();
842         }
843         unchecked {
844             for (uint256 i; i < quantity; ++i) {
845                 if (i % maxBatchSize == 0) {
846                     TokenData storage token = tokens[currentSupply + i];
847                     token.owner = to;
848                     token.aux =
849                         _calculateAux(address(0), to, currentSupply + i, 0);
850                 }
851                 emit Transfer(address(0), to, currentSupply + i);
852             }
853             currentSupply += quantity;
854         }
855     }
856 
857     function _transfer(
858         address from,
859         address to,
860         uint256 tokenId,
861         TokenData memory token
862     )
863         internal
864         virtual
865     {
866         if (token.owner != from) {
867             revert TransferFromIncorrectOwner();
868         }
869         if (to == address(0)) {
870             revert TransferToZeroAddress();
871         }
872         _approve(address(0), tokenId, token);
873         unchecked {
874             uint256 nextTokenId = tokenId + 1;
875             if (_exists(nextTokenId)) {
876                 TokenData storage nextToken = tokens[nextTokenId];
877                 if (nextToken.owner == address(0)) {
878                     nextToken.owner = token.owner;
879                     nextToken.aux = token.aux;
880                 }
881             }
882         }
883         TokenData storage newToken = tokens[tokenId];
884         newToken.owner = to;
885         newToken.aux = _calculateAux(from, to, tokenId, token.aux);
886         emit Transfer(from, to, tokenId);
887     }
888 
889     function _approve(address to, uint256 tokenId, TokenData memory token)
890         internal
891         virtual
892     {
893         tokenApprovals[tokenId] = to;
894         emit Approval(token.owner, to, tokenId);
895     }
896 
897     function _checkOnERC721Received(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory data
902     )
903         private
904         returns (bool)
905     {
906         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data)
907         returns (bytes4 retval) {
908             return retval == IERC721Receiver.onERC721Received.selector;
909         } catch (bytes memory reason) {
910             if (reason.length == 0) {
911                 revert TransferToNonERC721ReceiverImplementer();
912             } else {
913                 assembly {
914                     revert(add(32, reason), mload(reason))
915                 }
916             }
917         }
918     }
919 
920     function _safeMint(address to, uint256 quantity) internal virtual {
921         _safeMint(to, quantity, "");
922     }
923 
924     function safeTransferFrom(address from, address to, uint256 tokenId)
925         public
926         virtual
927         override
928     {
929         safeTransferFrom(from, to, tokenId, "");
930     }
931 
932     /// INTERNAL READ ///
933 
934     function _exists(uint256 tokenId) internal view virtual returns (bool) {
935         return tokenId < currentSupply;
936     }
937 
938     function _isApprovedOrOwner(address spender, uint256 tokenId, address owner)
939         internal
940         view
941         virtual
942         returns (bool)
943     {
944         return (
945             spender == owner || isApprovedForAll(owner, spender)
946                 || getApproved(tokenId) == spender
947         );
948     }
949 
950     function _tokenData(uint256 tokenId)
951         internal
952         view
953         returns (TokenData storage)
954     {
955         if (!_exists(tokenId)) {
956             revert TokenDataQueryForNonexistentToken();
957         }
958         TokenData storage token = tokens[tokenId];
959         uint256 currentIndex = tokenId;
960         while (token.owner == address(0)) {
961             unchecked {
962                 --currentIndex;
963             }
964             token = tokens[currentIndex];
965         }
966         return token;
967     }
968 
969     function _calculateAux(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes12 current
974     )
975         internal
976         view
977         virtual
978         returns (bytes12)
979     {
980         return
981             from == address(0)
982             ? bytes12(
983                 keccak256(abi.encodePacked(tokenId, to, block.difficulty, block.timestamp))
984             )
985             : current;
986     }
987 
988     function setBaseURI(string calldata uri) external {
989         require(msg.sender == admin);
990         baseURI = uri;
991     }
992 
993     function renounceOwnership() external {
994         require(msg.sender == admin);
995         admin = address(0);
996     }
997 
998     /// PUBLIC READ ///
999 
1000     function totalSupply() public view returns (uint256) {
1001         return MAX_SUPPLY;
1002     }
1003 
1004     function getApproved(uint256 tokenId)
1005         public
1006         view
1007         virtual
1008         override
1009         returns (address)
1010     {
1011         if (!_exists(tokenId)) {
1012             revert ApprovalQueryForNonexistentToken();
1013         }
1014         return tokenApprovals[tokenId];
1015     }
1016 
1017     function isApprovedForAll(address owner, address operator)
1018         public
1019         view
1020         virtual
1021         override
1022         returns (bool)
1023     {
1024         return operatorApprovals[owner][operator];
1025     }
1026 
1027     function balanceOf(address owner)
1028         public
1029         view
1030         virtual
1031         override
1032         returns (uint256)
1033     {
1034         if (owner == address(0)) {
1035             revert BalanceQueryForZeroAddress();
1036         }
1037         uint256 count;
1038         address lastOwner;
1039         for (uint256 i; i < currentSupply; ++i) {
1040             address tokenOwner = tokens[i].owner;
1041             if (tokenOwner != address(0)) {
1042                 lastOwner = tokenOwner;
1043             }
1044             if (lastOwner == owner) {
1045                 ++count;
1046             }
1047         }
1048         return count;
1049     }
1050 
1051     function ownerOf(uint256 tokenId)
1052         public
1053         view
1054         virtual
1055         override
1056         returns (address)
1057     {
1058         if (!_exists(tokenId)) {
1059             revert OwnerQueryForNonexistentToken();
1060         }
1061         return _tokenData(tokenId).owner;
1062     }
1063 
1064     function supportsInterface(bytes4 interfaceId)
1065         public
1066         view
1067         virtual
1068         override (ERC165, IERC165)
1069         returns (bool)
1070     {
1071         return interfaceId == type(IERC721).interfaceId
1072             || interfaceId == type(IERC721Metadata).interfaceId
1073             || super.supportsInterface(interfaceId);
1074     }
1075 
1076     function tokenURI(uint256 tokenId)
1077         public
1078         view
1079         virtual
1080         override
1081         returns (string memory)
1082     {
1083         if (!_exists(tokenId)) {
1084             revert URIQueryForNonexistentToken();
1085         }
1086         return
1087             bytes(baseURI).length > 0
1088             ? string(abi.encodePacked(baseURI, tokenId.toString()))
1089             : "";
1090     }
1091 }
1092 
1093 contract RookiesClaim is Rookies(10000), ReentrancyGuard {
1094     using BitMaps for BitMaps.BitMap;
1095 
1096     uint256 public immutable startClaimTimestamp;
1097     uint256 public immutable endClaimTimestamp;
1098     uint256 public constant FOUR_WEEKS = 4 * 7 * 24 * 60 * 60;
1099 
1100     BitMaps.BitMap private claimable;
1101     address private immutable admin;
1102     address private expiredRookiesClaimer;
1103     IERC721 private kongs;
1104 
1105     event Claimed(uint256 indexed kongTokenId);
1106 
1107     constructor(uint256 startClaimTmstp, address kongCollection) {
1108         startClaimTimestamp = startClaimTmstp;
1109         endClaimTimestamp = startClaimTmstp + FOUR_WEEKS;
1110         kongs = IERC721(kongCollection);
1111         admin = msg.sender;
1112     }
1113 
1114     function redeem(uint256[] calldata kongTokenIds) external nonReentrant {
1115         require(block.timestamp >= startClaimTimestamp, "Claim not yet started");
1116         require(block.timestamp <= endClaimTimestamp, "Claim has expired");
1117         for (uint256 i; i < kongTokenIds.length; i++) {
1118             require(canClaim(kongTokenIds[i]), "Cannot claim");
1119             claimable.set(kongTokenIds[i]);
1120             emit Claimed(kongTokenIds[i]);
1121         }
1122         mint(kongTokenIds.length, _msgSender());
1123     }
1124 
1125     function canClaim(uint256 kongTokenId) public view returns (bool) {
1126         bool isOwner = kongs.ownerOf(kongTokenId) == _msgSender();
1127         bool isClaimed = claimable.get(kongTokenId);
1128         return isOwner && !isClaimed;
1129     }
1130 
1131     /// Assumes the owner is valid
1132     /// Useful for checking whether a connected account can claim rookies
1133     /// on the frontend.
1134     function canClaimAll(uint256[] calldata kongTokenIds)
1135         external
1136         view
1137         returns (bool[] memory)
1138     {
1139         bool[] memory _canClaim = new bool[](kongTokenIds.length);
1140         for (uint256 i; i < kongTokenIds.length; i++) {
1141             _canClaim[i] = claimable.get(kongTokenIds[i]);
1142         }
1143         return _canClaim;
1144     }
1145 
1146     /// ADMIN ///
1147 
1148     // to trigger OS to show the collection
1149     function spawnOneRookie() external {
1150         require(msg.sender == admin, "Only admin can mint");
1151         require(claimable.get(0) == false, "Cannot mint again");
1152         mint(1, msg.sender);
1153         claimable.set(0);
1154         emit Claimed(0);
1155     }
1156 
1157     function setExpiredRookiesClaimer(address _expiredRookiesClaimer)
1158         external
1159     {
1160         require(msg.sender == admin, "Only admin can set expiredRookiesClaimer");
1161         expiredRookiesClaimer = _expiredRookiesClaimer;
1162     }
1163 
1164     function adminRedeem(uint256[] calldata kongTokenIds, address to)
1165         external
1166     {
1167         require(
1168             msg.sender == expiredRookiesClaimer,
1169             "Only expiredRookiesClaimer can redeem"
1170         );
1171         require(
1172             block.timestamp > endClaimTimestamp, "Claim has not expired yet"
1173         );
1174         bool isClaimed;
1175         for (uint256 i; i < kongTokenIds.length; i++) {
1176             isClaimed = claimable.get(kongTokenIds[i]);
1177             require(!isClaimed, "Cannot claim");
1178             claimable.set(kongTokenIds[i]);
1179             emit Claimed(kongTokenIds[i]);
1180         }
1181         mint(kongTokenIds.length, to);
1182     }
1183 }