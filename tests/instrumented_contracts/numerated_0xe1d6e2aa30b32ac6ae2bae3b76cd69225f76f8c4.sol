1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25  * @dev Required interface of an ERC721 compliant contract.
26  */
27 interface IERC721 is IERC165 {
28     /**
29      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
32 
33     /**
34      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
35      */
36     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42 
43     /**
44      * @dev Returns the number of tokens in ``owner``'s account.
45      */
46     function balanceOf(address owner) external view returns (uint256 balance);
47 
48     /**
49      * @dev Returns the owner of the `tokenId` token.
50      *
51      * Requirements:
52      *
53      * - `tokenId` must exist.
54      */
55     function ownerOf(uint256 tokenId) external view returns (address owner);
56 
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 }
160 
161 
162 
163 /**
164  * @dev String operations.
165  */
166 library Strings {
167     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
171      */
172     function toString(uint256 value) internal pure returns (string memory) {
173         // Inspired by OraclizeAPI's implementation - MIT licence
174         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
175 
176         if (value == 0) {
177             return "0";
178         }
179         uint256 temp = value;
180         uint256 digits;
181         while (temp != 0) {
182             digits++;
183             temp /= 10;
184         }
185         bytes memory buffer = new bytes(digits);
186         while (value != 0) {
187             digits -= 1;
188             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
189             value /= 10;
190         }
191         return string(buffer);
192     }
193 
194 
195     /**
196      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation. 
197      */
198     function toHexString(uint256 value) internal pure returns (string memory) {
199         if (value == 0) {
200             return "0x00";
201         }
202         uint256 temp = value;
203         uint256 length = 0;
204         while (temp != 0) {
205             length++;
206             temp >>= 8;
207         }
208         return toHexString(value, length);
209     }
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
213      */
214     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
215         bytes memory buffer = new bytes(2 * length + 2);
216         buffer[0] = "0";
217         buffer[1] = "x";
218         for (uint256 i = 2 * length + 1; i > 1; --i) {
219             buffer[i] = _HEX_SYMBOLS[value & 0xf];
220             value >>= 4;
221         }
222         require(value == 0, "Strings: hex length insufficient");
223         return string(buffer);
224     }
225 }
226 
227 
228 /*
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 
249 /**
250  * @dev Contract module which provides a basic access control mechanism, where
251  * there is an account (an owner) that can be granted exclusive access to
252  * specific functions.
253  *
254  * By default, the owner account will be the one that deploys the contract. This
255  * can later be changed with {transferOwnership}.
256  *
257  * This module is used through inheritance. It will make available the modifier
258  * `onlyOwner`, which can be applied to your functions to restrict their use to
259  * the owner.
260  */
261 abstract contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266     /**
267      * @dev Initializes the contract setting the deployer as the initial owner.
268      */
269     constructor() {
270         _setOwner(_msgSender());
271     }
272 
273     /**
274      * @dev Returns the address of the current owner.
275      */
276     function owner() public view virtual returns (address) {
277         return _owner;
278     }
279 
280     /**
281      * @dev Throws if called by any account other than the owner.
282      */
283     modifier onlyOwner() {
284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
285         _;
286     }
287 
288     /**
289      * @dev Leaves the contract without owner. It will not be possible to call
290      * `onlyOwner` functions anymore. Can only be called by the current owner.
291      *
292      * NOTE: Renouncing ownership will leave the contract without an owner,
293      * thereby removing any functionality that is only available to the owner.
294      */
295     function renounceOwnership() public virtual onlyOwner {
296         _setOwner(address(0));
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Can only be called by the current owner.
302      */
303     function transferOwnership(address newOwner) public virtual onlyOwner {
304         require(newOwner != address(0), "Ownable: new owner is the zero address");
305         _setOwner(newOwner);
306     }
307 
308     function _setOwner(address newOwner) private {
309         address oldOwner = _owner;
310         _owner = newOwner;
311         emit OwnershipTransferred(oldOwner, newOwner);
312     }
313 }
314 
315 
316 /**
317  * @dev Contract module that helps prevent reentrant calls to a function.
318  *
319  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
320  * available, which can be applied to functions to make sure there are no nested
321  * (reentrant) calls to them.
322  *
323  * Note that because there is a single `nonReentrant` guard, functions marked as
324  * `nonReentrant` may not call one another. This can be worked around by making
325  * those functions `private`, and then adding `external` `nonReentrant` entry
326  * points to them.
327  *
328  * TIP: If you would like to learn more about reentrancy and alternative ways
329  * to protect against it, check out our blog post
330  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
331  */
332 abstract contract ReentrancyGuard {
333     // Booleans are more expensive than uint256 or any type that takes up a full
334     // word because each write operation emits an extra SLOAD to first read the
335     // slot's contents, replace the bits taken up by the boolean, and then write
336     // back. This is the compiler's defense against contract upgrades and
337     // pointer aliasing, and it cannot be disabled.
338 
339     // The values being non-zero value makes deployment a bit more expensive,
340     // but in exchange the refund on every call to nonReentrant will be lower in
341     // amount. Since refunds are capped to a percentage of the total
342     // transaction's gas, it is best to keep them low in cases like this one, to
343     // increase the likelihood of the full refund coming into effect.
344     uint256 private constant _NOT_ENTERED = 1;
345     uint256 private constant _ENTERED = 2;
346 
347     uint256 private _status;
348 
349     constructor() {
350         _status = _NOT_ENTERED;
351     }
352 
353     /**
354      * @dev Prevents a contract from calling itself, directly or indirectly.
355      * Calling a `nonReentrant` function from another `nonReentrant`
356      * function is not supported. It is possible to prevent this from happening
357      * by making the `nonReentrant` function external, and make it call a
358      * `private` function that does the actual work.
359      */
360     modifier nonReentrant() {
361         // On the first call to nonReentrant, _notEntered will be true
362         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
363 
364         // Any calls to nonReentrant after this point will fail
365         _status = _ENTERED;
366 
367         _;
368 
369         // By storing the original value once again, a refund is triggered (see
370         // https://eips.ethereum.org/EIPS/eip-2200)
371         _status = _NOT_ENTERED;
372     }
373 }
374 
375 
376 
377 /**
378  * @title ERC721 token receiver interface
379  * @dev Interface for any contract that wants to support safeTransfers
380  * from ERC721 asset contracts.
381  */
382 interface IERC721Receiver {
383     /**
384      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
385      * by `operator` from `from`, this function is called.
386      *
387      * It must return its Solidity selector to confirm the token transfer.
388      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
389      *
390      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
391      */
392     function onERC721Received(
393         address operator,
394         address from,
395         uint256 tokenId,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         assembly {
429             size := extcodesize(account)
430         }
431         return size > 0;
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         (bool success, ) = recipient.call{value: amount}("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         require(isContract(target), "Address: call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.call{value: value}(data);
528         return _verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
538         return functionStaticCall(target, data, "Address: low-level static call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal view returns (bytes memory) {
552         require(isContract(target), "Address: static call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.staticcall(data);
555         return _verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(isContract(target), "Address: delegate call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.delegatecall(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     function _verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) private pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 
609 
610 
611 /**
612  * @dev Implementation of the {IERC165} interface.
613  *
614  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
615  * for the additional interface id that will be supported. For example:
616  *
617  * ```solidity
618  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
620  * }
621  * ```
622  *
623  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
624  */
625 abstract contract ERC165 is IERC165 {
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
630         return interfaceId == type(IERC165).interfaceId;
631     }
632 }
633 
634 /**
635  * @dev Required interface of an ERC1155 compliant contract, as defined in the
636  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
637  *
638  * _Available since v3.1._
639  */
640 interface IERC1155 is IERC165 {
641     /**
642      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
643      */
644     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
645 
646     /**
647      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
648      * transfers.
649      */
650     event TransferBatch(
651         address indexed operator,
652         address indexed from,
653         address indexed to,
654         uint256[] ids,
655         uint256[] values
656     );
657 
658     /**
659      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
660      * `approved`.
661      */
662     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
663 
664     /**
665      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
666      *
667      * If an {URI} event was emitted for `id`, the standard
668      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
669      * returned by {IERC1155MetadataURI-uri}.
670      */
671     event URI(string value, uint256 indexed id);
672 
673     /**
674      * @dev Returns the amount of tokens of token type `id` owned by `account`.
675      *
676      * Requirements:
677      *
678      * - `account` cannot be the zero address.
679      */
680     function balanceOf(address account, uint256 id) external view returns (uint256);
681 
682     /**
683      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
684      *
685      * Requirements:
686      *
687      * - `accounts` and `ids` must have the same length.
688      */
689     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
690         external
691         view
692         returns (uint256[] memory);
693 
694     /**
695      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
696      *
697      * Emits an {ApprovalForAll} event.
698      *
699      * Requirements:
700      *
701      * - `operator` cannot be the caller.
702      */
703     function setApprovalForAll(address operator, bool approved) external;
704 
705     /**
706      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
707      *
708      * See {setApprovalForAll}.
709      */
710     function isApprovedForAll(address account, address operator) external view returns (bool);
711 
712     /**
713      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
714      *
715      * Emits a {TransferSingle} event.
716      *
717      * Requirements:
718      *
719      * - `to` cannot be the zero address.
720      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
721      * - `from` must have a balance of tokens of type `id` of at least `amount`.
722      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
723      * acceptance magic value.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 id,
729         uint256 amount,
730         bytes calldata data
731     ) external;
732 
733     /**
734      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
735      *
736      * Emits a {TransferBatch} event.
737      *
738      * Requirements:
739      *
740      * - `ids` and `amounts` must have the same length.
741      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
742      * acceptance magic value.
743      */
744     function safeBatchTransferFrom(
745         address from,
746         address to,
747         uint256[] calldata ids,
748         uint256[] calldata amounts,
749         bytes calldata data
750     ) external;
751 }
752 
753 /**
754  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
755  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
756  *
757  * _Available since v3.1._
758  */
759 interface IERC1155MetadataURI is IERC1155 {
760     /**
761      * @dev Returns the URI for token type `id`.
762      *
763      * If the `\{id\}` substring is present in the URI, it must be replaced by
764      * clients with the actual token type ID.
765      */
766     function uri(uint256 id) external view returns (string memory);
767 }
768 
769 /**
770  * @dev _Available since v3.1._
771  */
772 interface IERC1155Receiver is IERC165 {
773     /**
774         @dev Handles the receipt of a single ERC1155 token type. This function is
775         called at the end of a `safeTransferFrom` after the balance has been updated.
776         To accept the transfer, this must return
777         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
778         (i.e. 0xf23a6e61, or its own function selector).
779         @param operator The address which initiated the transfer (i.e. msg.sender)
780         @param from The address which previously owned the token
781         @param id The ID of the token being transferred
782         @param value The amount of tokens being transferred
783         @param data Additional data with no specified format
784         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
785     */
786     function onERC1155Received(
787         address operator,
788         address from,
789         uint256 id,
790         uint256 value,
791         bytes calldata data
792     ) external returns (bytes4);
793 
794     /**
795         @dev Handles the receipt of a multiple ERC1155 token types. This function
796         is called at the end of a `safeBatchTransferFrom` after the balances have
797         been updated. To accept the transfer(s), this must return
798         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
799         (i.e. 0xbc197c81, or its own function selector).
800         @param operator The address which initiated the batch transfer (i.e. msg.sender)
801         @param from The address which previously owned the token
802         @param ids An array containing ids of each token being transferred (order and length must match values array)
803         @param values An array containing amounts of each token being transferred (order and length must match ids array)
804         @param data Additional data with no specified format
805         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
806     */
807     function onERC1155BatchReceived(
808         address operator,
809         address from,
810         uint256[] calldata ids,
811         uint256[] calldata values,
812         bytes calldata data
813     ) external returns (bytes4);
814 }
815 
816 /**
817  * @dev Implementation of the basic standard multi-token.
818  * See https://eips.ethereum.org/EIPS/eip-1155
819  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
820  *
821  * _Available since v3.1._
822  */
823 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
824     using Address for address;
825 
826     // Mapping from token ID to account balances
827     mapping(uint256 => mapping(address => uint256)) private _balances;
828 
829     // Mapping from account to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
833     string private _uri;
834 
835     /**
836      * @dev See {_setURI}.
837      */
838     constructor(string memory uri_) {
839         _setURI(uri_);
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC1155).interfaceId ||
848             interfaceId == type(IERC1155MetadataURI).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC1155MetadataURI-uri}.
854      *
855      * This implementation returns the same URI for *all* token types. It relies
856      * on the token type ID substitution mechanism
857      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
858      *
859      * Clients calling this function must replace the `\{id\}` substring with the
860      * actual token type ID.
861      */
862     function uri(uint256) public view virtual override returns (string memory) {
863         return _uri;
864     }
865 
866     /**
867      * @dev See {IERC1155-balanceOf}.
868      *
869      * Requirements:
870      *
871      * - `account` cannot be the zero address.
872      */
873     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
874         require(account != address(0), "ERC1155: balance query for the zero address");
875         return _balances[id][account];
876     }
877 
878     /**
879      * @dev See {IERC1155-balanceOfBatch}.
880      *
881      * Requirements:
882      *
883      * - `accounts` and `ids` must have the same length.
884      */
885     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
886         public
887         view
888         virtual
889         override
890         returns (uint256[] memory)
891     {
892         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
893 
894         uint256[] memory batchBalances = new uint256[](accounts.length);
895 
896         for (uint256 i = 0; i < accounts.length; ++i) {
897             batchBalances[i] = balanceOf(accounts[i], ids[i]);
898         }
899 
900         return batchBalances;
901     }
902 
903     /**
904      * @dev See {IERC1155-setApprovalForAll}.
905      */
906     function setApprovalForAll(address operator, bool approved) public virtual override {
907         require(_msgSender() != operator, "ERC1155: setting approval status for self");
908 
909         _operatorApprovals[_msgSender()][operator] = approved;
910         emit ApprovalForAll(_msgSender(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC1155-isApprovedForAll}.
915      */
916     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[account][operator];
918     }
919 
920     /**
921      * @dev See {IERC1155-safeTransferFrom}.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 id,
927         uint256 amount,
928         bytes memory data
929     ) public virtual override {
930         require(
931             from == _msgSender() || isApprovedForAll(from, _msgSender()),
932             "ERC1155: caller is not owner nor approved"
933         );
934         _safeTransferFrom(from, to, id, amount, data);
935     }
936 
937     /**
938      * @dev See {IERC1155-safeBatchTransferFrom}.
939      */
940     function safeBatchTransferFrom(
941         address from,
942         address to,
943         uint256[] memory ids,
944         uint256[] memory amounts,
945         bytes memory data
946     ) public virtual override {
947         require(
948             from == _msgSender() || isApprovedForAll(from, _msgSender()),
949             "ERC1155: transfer caller is not owner nor approved"
950         );
951         _safeBatchTransferFrom(from, to, ids, amounts, data);
952     }
953 
954     /**
955      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
956      *
957      * Emits a {TransferSingle} event.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `from` must have a balance of tokens of type `id` of at least `amount`.
963      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
964      * acceptance magic value.
965      */
966     function _safeTransferFrom(
967         address from,
968         address to,
969         uint256 id,
970         uint256 amount,
971         bytes memory data
972     ) internal virtual {
973         require(to != address(0), "ERC1155: transfer to the zero address");
974 
975         address operator = _msgSender();
976 
977         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
978 
979         uint256 fromBalance = _balances[id][from];
980         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
981         unchecked {
982             _balances[id][from] = fromBalance - amount;
983         }
984         _balances[id][to] += amount;
985 
986         emit TransferSingle(operator, from, to, id, amount);
987 
988         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
989     }
990 
991     /**
992      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
993      *
994      * Emits a {TransferBatch} event.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
999      * acceptance magic value.
1000      */
1001     function _safeBatchTransferFrom(
1002         address from,
1003         address to,
1004         uint256[] memory ids,
1005         uint256[] memory amounts,
1006         bytes memory data
1007     ) internal virtual {
1008         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1009         require(to != address(0), "ERC1155: transfer to the zero address");
1010 
1011         address operator = _msgSender();
1012 
1013         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1014 
1015         for (uint256 i = 0; i < ids.length; ++i) {
1016             uint256 id = ids[i];
1017             uint256 amount = amounts[i];
1018 
1019             uint256 fromBalance = _balances[id][from];
1020             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1021             unchecked {
1022                 _balances[id][from] = fromBalance - amount;
1023             }
1024             _balances[id][to] += amount;
1025         }
1026 
1027         emit TransferBatch(operator, from, to, ids, amounts);
1028 
1029         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1030     }
1031 
1032     /**
1033      * @dev Sets a new URI for all token types, by relying on the token type ID
1034      * substitution mechanism
1035      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1036      *
1037      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1038      * URI or any of the amounts in the JSON file at said URI will be replaced by
1039      * clients with the token type ID.
1040      *
1041      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1042      * interpreted by clients as
1043      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1044      * for token type ID 0x4cce0.
1045      *
1046      * See {uri}.
1047      *
1048      * Because these URIs cannot be meaningfully represented by the {URI} event,
1049      * this function emits no events.
1050      */
1051     function _setURI(string memory newuri) internal virtual {
1052         _uri = newuri;
1053     }
1054 
1055     /**
1056      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1057      *
1058      * Emits a {TransferSingle} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `account` cannot be the zero address.
1063      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1064      * acceptance magic value.
1065      */
1066     function _mint(
1067         address account,
1068         uint256 id,
1069         uint256 amount,
1070         bytes memory data
1071     ) internal virtual {
1072         require(account != address(0), "ERC1155: mint to the zero address");
1073 
1074         address operator = _msgSender();
1075 
1076         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1077 
1078         _balances[id][account] += amount;
1079         emit TransferSingle(operator, address(0), account, id, amount);
1080 
1081         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1082     }
1083 
1084     /**
1085      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1086      *
1087      * Requirements:
1088      *
1089      * - `ids` and `amounts` must have the same length.
1090      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1091      * acceptance magic value.
1092      */
1093     function _mintBatch(
1094         address to,
1095         uint256[] memory ids,
1096         uint256[] memory amounts,
1097         bytes memory data
1098     ) internal virtual {
1099         require(to != address(0), "ERC1155: mint to the zero address");
1100         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1101 
1102         address operator = _msgSender();
1103 
1104         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1105 
1106         for (uint256 i = 0; i < ids.length; i++) {
1107             _balances[ids[i]][to] += amounts[i];
1108         }
1109 
1110         emit TransferBatch(operator, address(0), to, ids, amounts);
1111 
1112         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1113     }
1114 
1115     /**
1116      * @dev Destroys `amount` tokens of token type `id` from `account`
1117      *
1118      * Requirements:
1119      *
1120      * - `account` cannot be the zero address.
1121      * - `account` must have at least `amount` tokens of token type `id`.
1122      */
1123     function _burn(
1124         address account,
1125         uint256 id,
1126         uint256 amount
1127     ) internal virtual {
1128         require(account != address(0), "ERC1155: burn from the zero address");
1129 
1130         address operator = _msgSender();
1131 
1132         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1133 
1134         uint256 accountBalance = _balances[id][account];
1135         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1136         unchecked {
1137             _balances[id][account] = accountBalance - amount;
1138         }
1139 
1140         emit TransferSingle(operator, account, address(0), id, amount);
1141     }
1142 
1143     /**
1144      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1145      *
1146      * Requirements:
1147      *
1148      * - `ids` and `amounts` must have the same length.
1149      */
1150     function _burnBatch(
1151         address account,
1152         uint256[] memory ids,
1153         uint256[] memory amounts
1154     ) internal virtual {
1155         require(account != address(0), "ERC1155: burn from the zero address");
1156         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1157 
1158         address operator = _msgSender();
1159 
1160         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1161 
1162         for (uint256 i = 0; i < ids.length; i++) {
1163             uint256 id = ids[i];
1164             uint256 amount = amounts[i];
1165 
1166             uint256 accountBalance = _balances[id][account];
1167             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1168             unchecked {
1169                 _balances[id][account] = accountBalance - amount;
1170             }
1171         }
1172 
1173         emit TransferBatch(operator, account, address(0), ids, amounts);
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before any token transfer. This includes minting
1178      * and burning, as well as batched variants.
1179      *
1180      * The same hook is called on both single and batched variants. For single
1181      * transfers, the length of the `id` and `amount` arrays will be 1.
1182      *
1183      * Calling conditions (for each `id` and `amount` pair):
1184      *
1185      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1186      * of token type `id` will be  transferred to `to`.
1187      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1188      * for `to`.
1189      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1190      * will be burned.
1191      * - `from` and `to` are never both zero.
1192      * - `ids` and `amounts` have the same, non-zero length.
1193      *
1194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1195      */
1196     function _beforeTokenTransfer(
1197         address operator,
1198         address from,
1199         address to,
1200         uint256[] memory ids,
1201         uint256[] memory amounts,
1202         bytes memory data
1203     ) internal virtual {}
1204 
1205     function _doSafeTransferAcceptanceCheck(
1206         address operator,
1207         address from,
1208         address to,
1209         uint256 id,
1210         uint256 amount,
1211         bytes memory data
1212     ) private {
1213         if (to.isContract()) {
1214             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1215                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1216                     revert("ERC1155: ERC1155Receiver rejected tokens");
1217                 }
1218             } catch Error(string memory reason) {
1219                 revert(reason);
1220             } catch {
1221                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1222             }
1223         }
1224     }
1225 
1226     function _doSafeBatchTransferAcceptanceCheck(
1227         address operator,
1228         address from,
1229         address to,
1230         uint256[] memory ids,
1231         uint256[] memory amounts,
1232         bytes memory data
1233     ) private {
1234         if (to.isContract()) {
1235             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1236                 bytes4 response
1237             ) {
1238                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1239                     revert("ERC1155: ERC1155Receiver rejected tokens");
1240                 }
1241             } catch Error(string memory reason) {
1242                 revert(reason);
1243             } catch {
1244                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1245             }
1246         }
1247     }
1248 
1249     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1250         uint256[] memory array = new uint256[](1);
1251         array[0] = element;
1252 
1253         return array;
1254     }
1255 }
1256 
1257 struct StakeEntry {
1258     uint32 selectedStakingPeriod;
1259     uint224 stakingUnlockTimestamp;
1260     address owner;
1261 }
1262 
1263 
1264 contract SteadyStackStaking is ERC1155, IERC721Receiver, ReentrancyGuard, Ownable {
1265     using Strings for uint256;
1266     string private _name;
1267     string private _symbol;
1268     string public baseURI;
1269     address public SSTContract;
1270     bool public stakingOpen;
1271     uint256[] public stakingLengths = [30 days, 90 days, 180 days, 365 days, 1095 days];
1272 
1273 
1274     mapping(address => bool) public admins;
1275     mapping(address => bool) public approvedBurningContracts;
1276     mapping(uint256 => StakeEntry) public stakeEntries;
1277     mapping(address => uint256) public countOfTokensStakedByOwner;
1278 
1279     event Stake(uint256 tokenId, address stakerAddress);
1280     event Unstake(uint256 tokenId, address owner);
1281 
1282     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public override pure returns (bytes4) 
1283     {
1284         return this.onERC721Received.selector ^ 0x23b872dd;
1285     }
1286 
1287     modifier onlyAdmin() {
1288         require(admins[_msgSender()] == true, "Ownable: caller is not the owner");
1289         _;
1290     }
1291 
1292     function airdrop(address[] calldata recipients, uint256[] memory count, uint256 tokenId) external onlyAdmin nonReentrant 
1293     {
1294         for(uint256 i = 0; i < recipients.length; i++)
1295         {
1296             _mint(recipients[i], tokenId, count[i], "");
1297         }
1298     }
1299 
1300     function toggleStakingOpen() external onlyAdmin 
1301     {
1302         stakingOpen = !stakingOpen;
1303     }
1304 
1305     function setAdmin(address adminToToggle) external onlyOwner 
1306     {
1307         admins[adminToToggle] = !admins[adminToToggle];
1308     }
1309 
1310     function stakeTitan(uint256 titanId, uint256 stakingPeriod) public nonReentrant 
1311     {
1312         IERC721 _sstContract = IERC721(SSTContract);
1313 
1314         require(_sstContract.ownerOf(titanId) == _msgSender(), "You do not own that token");
1315         require(stakingPeriod < stakingLengths.length, "Invalid staking period");
1316         require(stakingOpen, "Staking is not open");
1317 
1318         _sstContract.transferFrom(_msgSender(), address(this), titanId);
1319         StakeEntry storage stakeEntry = stakeEntries[titanId];
1320         stakeEntry.stakingUnlockTimestamp = uint224(block.timestamp + stakingLengths[stakingPeriod]);
1321         stakeEntry.selectedStakingPeriod = uint32(stakingPeriod);
1322         stakeEntry.owner = _msgSender();
1323         ++countOfTokensStakedByOwner[_msgSender()];
1324 
1325         emit Stake(titanId, _msgSender());
1326     }
1327 
1328     function unstakeTitan(uint256 titanId)public nonReentrant 
1329     {
1330         require(_msgSender() == stakeEntries[titanId].owner, "You do not own that token");
1331         require(stakeEntries[titanId].stakingUnlockTimestamp < block.timestamp, "Token not ready to unstake");
1332         require(stakeEntries[titanId].stakingUnlockTimestamp > 0, "Token not staked");
1333 
1334         IERC721 _sstContract = IERC721(SSTContract);
1335         _sstContract.transferFrom(address(this), _msgSender(), titanId);
1336         --countOfTokensStakedByOwner[_msgSender()];
1337         delete stakeEntries[titanId];
1338 
1339         emit Unstake(titanId, _msgSender());
1340     }
1341 
1342     function setTitanContract(address contractAddress) public onlyOwner 
1343     {
1344         SSTContract = contractAddress;
1345     }
1346 
1347     function setBaseURI(string memory _newURI) external onlyOwner
1348     {
1349         baseURI = _newURI;
1350     }
1351 
1352     function uri(uint256 tokenId) override public view returns (string memory) {
1353         return string(abi.encodePacked(baseURI, tokenId.toString()));
1354     }
1355 
1356     function toggleApprovedBurningContract(address burningContract) external onlyOwner
1357     {
1358         approvedBurningContracts[burningContract] = !approvedBurningContracts[burningContract];
1359     }
1360 
1361     function burn(address _from, uint256 tokenId, uint256 _amount) external 
1362     {
1363 		require(approvedBurningContracts[msg.sender]);
1364 		_burn(_from, tokenId, _amount);
1365     }
1366 
1367     function name() public view returns (string memory) 
1368     {
1369         return _name;
1370     }
1371 
1372     function symbol() public view returns (string memory) 
1373     {
1374         return _symbol;
1375     }
1376 
1377     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override 
1378     {
1379         require(from == address(0) || to == address(0), "Token is soulbound and cannot be transferred");
1380         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1381     }
1382     
1383     constructor() ERC1155("") Ownable() {
1384         _name = "Soulbound Titan";
1385         _symbol = "SBTTN";
1386         admins[owner()] = true;
1387         SSTContract = 0x916c6AF08BF922Eaf80C05975886c0A421C78A35;
1388     }
1389 }