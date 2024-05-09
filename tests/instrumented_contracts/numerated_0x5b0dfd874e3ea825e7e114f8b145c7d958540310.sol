1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
247 
248 pragma solidity ^0.8.1;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      *
271      * [IMPORTANT]
272      * ====
273      * You shouldn't rely on `isContract` to protect against flash loan attacks!
274      *
275      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
276      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
277      * constructor.
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies on extcodesize/address.code.length, which returns 0
282         // for contracts in construction, since the code is only stored at the end
283         // of the constructor execution.
284 
285         return account.code.length > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain `call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         require(isContract(target), "Address: call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.call{value: value}(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
392         return functionStaticCall(target, data, "Address: low-level static call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         require(isContract(target), "Address: static call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(isContract(target), "Address: delegate call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
441      * revert reason using the provided one.
442      *
443      * _Available since v4.3._
444      */
445     function verifyCallResult(
446         bool success,
447         bytes memory returndata,
448         string memory errorMessage
449     ) internal pure returns (bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 interface IERC721Receiver {
481     /**
482      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
483      * by `operator` from `from`, this function is called.
484      *
485      * It must return its Solidity selector to confirm the token transfer.
486      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
487      *
488      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
489      */
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC165 standard, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-165[EIP].
508  *
509  * Implementers can declare support of contract interfaces, which can then be
510  * queried by others ({ERC165Checker}).
511  *
512  * For an implementation, see {ERC165}.
513  */
514 interface IERC165 {
515     /**
516      * @dev Returns true if this contract implements the interface defined by
517      * `interfaceId`. See the corresponding
518      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
519      * to learn more about how these ids are created.
520      *
521      * This function call must use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool);
524 }
525 
526 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Required interface of an ERC721 compliant contract.
567  */
568 interface IERC721 is IERC165 {
569     /**
570      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
571      */
572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
576      */
577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
581      */
582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
583 
584     /**
585      * @dev Returns the number of tokens in ``owner``'s account.
586      */
587     function balanceOf(address owner) external view returns (uint256 balance);
588 
589     /**
590      * @dev Returns the owner of the `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function ownerOf(uint256 tokenId) external view returns (address owner);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Transfers `tokenId` token from `from` to `to`.
620      *
621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
640      * The approval is cleared when the token is transferred.
641      *
642      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
643      *
644      * Requirements:
645      *
646      * - The caller must own the token or be an approved operator.
647      * - `tokenId` must exist.
648      *
649      * Emits an {Approval} event.
650      */
651     function approve(address to, uint256 tokenId) external;
652 
653     /**
654      * @dev Returns the account approved for `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function getApproved(uint256 tokenId) external view returns (address operator);
661 
662     /**
663      * @dev Approve or remove `operator` as an operator for the caller.
664      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
665      *
666      * Requirements:
667      *
668      * - The `operator` cannot be the caller.
669      *
670      * Emits an {ApprovalForAll} event.
671      */
672     function setApprovalForAll(address operator, bool _approved) external;
673 
674     /**
675      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
676      *
677      * See {setApprovalForAll}
678      */
679     function isApprovedForAll(address owner, address operator) external view returns (bool);
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes calldata data
699     ) external;
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Metadata is IERC721 {
715     /**
716      * @dev Returns the token collection name.
717      */
718     function name() external view returns (string memory);
719 
720     /**
721      * @dev Returns the token collection symbol.
722      */
723     function symbol() external view returns (string memory);
724 
725     /**
726      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
727      */
728     function tokenURI(uint256 tokenId) external view returns (string memory);
729 }
730 
731 // File: erc721a/contracts/ERC721A.sol
732 
733 
734 // Creator: Chiru Labs
735 
736 pragma solidity ^0.8.4;
737 
738 
739 
740 
741 
742 
743 
744 
745 error ApprovalCallerNotOwnerNorApproved();
746 error ApprovalQueryForNonexistentToken();
747 error ApproveToCaller();
748 error ApprovalToCurrentOwner();
749 error BalanceQueryForZeroAddress();
750 error MintToZeroAddress();
751 error MintZeroQuantity();
752 error OwnerQueryForNonexistentToken();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension. Built to optimize for lower gas during batch mints.
762  *
763  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
764  *
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766  *
767  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
768  */
769 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Compiler will pack this into a single 256bit word.
774     struct TokenOwnership {
775         // The address of the owner.
776         address addr;
777         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
778         uint64 startTimestamp;
779         // Whether the token has been burned.
780         bool burned;
781     }
782 
783     // Compiler will pack this into a single 256bit word.
784     struct AddressData {
785         // Realistically, 2**64-1 is more than enough.
786         uint64 balance;
787         // Keeps track of mint count with minimal overhead for tokenomics.
788         uint64 numberMinted;
789         // Keeps track of burn count with minimal overhead for tokenomics.
790         uint64 numberBurned;
791         // For miscellaneous variable(s) pertaining to the address
792         // (e.g. number of whitelist mint slots used).
793         // If there are multiple variables, please pack them into a uint64.
794         uint64 aux;
795     }
796 
797     // The tokenId of the next token to be minted.
798     uint256 internal _currentIndex;
799 
800     // The number of tokens burned.
801     uint256 internal _burnCounter;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
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
825         _currentIndex = _startTokenId();
826     }
827 
828     /**
829      * To change the starting tokenId, please override this function.
830      */
831     function _startTokenId() internal view virtual returns (uint256) {
832         return 0;
833     }
834 
835     /**
836      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
837      */
838     function totalSupply() public view returns (uint256) {
839         // Counter underflow is impossible as _burnCounter cannot be incremented
840         // more than _currentIndex - _startTokenId() times
841         unchecked {
842             return _currentIndex - _burnCounter - _startTokenId();
843         }
844     }
845 
846     /**
847      * Returns the total amount of tokens minted in the contract.
848      */
849     function _totalMinted() internal view returns (uint256) {
850         // Counter underflow is impossible as _currentIndex does not decrement,
851         // and it is initialized to _startTokenId()
852         unchecked {
853             return _currentIndex - _startTokenId();
854         }
855     }
856 
857     /**
858      * @dev See {IERC165-supportsInterface}.
859      */
860     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
861         return
862             interfaceId == type(IERC721).interfaceId ||
863             interfaceId == type(IERC721Metadata).interfaceId ||
864             super.supportsInterface(interfaceId);
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870     function balanceOf(address owner) public view override returns (uint256) {
871         if (owner == address(0)) revert BalanceQueryForZeroAddress();
872         return uint256(_addressData[owner].balance);
873     }
874 
875     /**
876      * Returns the number of tokens minted by `owner`.
877      */
878     function _numberMinted(address owner) internal view returns (uint256) {
879         return uint256(_addressData[owner].numberMinted);
880     }
881 
882     /**
883      * Returns the number of tokens burned by or on behalf of `owner`.
884      */
885     function _numberBurned(address owner) internal view returns (uint256) {
886         return uint256(_addressData[owner].numberBurned);
887     }
888 
889     /**
890      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
891      */
892     function _getAux(address owner) internal view returns (uint64) {
893         return _addressData[owner].aux;
894     }
895 
896     /**
897      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      * If there are multiple variables, please pack them into a uint64.
899      */
900     function _setAux(address owner, uint64 aux) internal {
901         _addressData[owner].aux = aux;
902     }
903 
904     /**
905      * Gas spent here starts off proportional to the maximum mint batch size.
906      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
907      */
908     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
909         uint256 curr = tokenId;
910 
911         unchecked {
912             if (_startTokenId() <= curr && curr < _currentIndex) {
913                 TokenOwnership memory ownership = _ownerships[curr];
914                 if (!ownership.burned) {
915                     if (ownership.addr != address(0)) {
916                         return ownership;
917                     }
918                     // Invariant:
919                     // There will always be an ownership that has an address and is not burned
920                     // before an ownership that does not have an address and is not burned.
921                     // Hence, curr will not underflow.
922                     while (true) {
923                         curr--;
924                         ownership = _ownerships[curr];
925                         if (ownership.addr != address(0)) {
926                             return ownership;
927                         }
928                     }
929                 }
930             }
931         }
932         revert OwnerQueryForNonexistentToken();
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return _ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 1 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")): "";
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         if (to == owner) revert ApprovalToCurrentOwner();
981 
982         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
983             revert ApprovalCallerNotOwnerNorApproved();
984         }
985 
986         _approve(to, tokenId, owner);
987     }
988 
989     /**
990      * @dev See {IERC721-getApproved}.
991      */
992     function getApproved(uint256 tokenId) public view override returns (address) {
993         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
994 
995         return _tokenApprovals[tokenId];
996     }
997 
998     /**
999      * @dev See {IERC721-setApprovalForAll}.
1000      */
1001     function setApprovalForAll(address operator, bool approved) public virtual override {
1002         if (operator == _msgSender()) revert ApproveToCaller();
1003 
1004         _operatorApprovals[_msgSender()][operator] = approved;
1005         emit ApprovalForAll(_msgSender(), operator, approved);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-isApprovedForAll}.
1010      */
1011     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1012         return _operatorApprovals[owner][operator];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-transferFrom}.
1017      */
1018     function transferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         _transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) public virtual override {
1034         safeTransferFrom(from, to, tokenId, '');
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-safeTransferFrom}.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) public virtual override {
1046         _transfer(from, to, tokenId);
1047         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1048             revert TransferToNonERC721ReceiverImplementer();
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns whether `tokenId` exists.
1054      *
1055      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1056      *
1057      * Tokens start existing when they are minted (`_mint`),
1058      */
1059     function _exists(uint256 tokenId) internal view returns (bool) {
1060         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1061             !_ownerships[tokenId].burned;
1062     }
1063 
1064     function _safeMint(address to, uint256 quantity) internal {
1065         _safeMint(to, quantity, '');
1066     }
1067 
1068     /**
1069      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 quantity,
1081         bytes memory _data
1082     ) internal {
1083         _mint(to, quantity, _data, true);
1084     }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data,
1100         bool safe
1101     ) internal {
1102         uint256 startTokenId = _currentIndex;
1103         if (to == address(0)) revert MintToZeroAddress();
1104         if (quantity == 0) revert MintZeroQuantity();
1105 
1106         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108         // Overflows are incredibly unrealistic.
1109         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1110         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1111         unchecked {
1112             _addressData[to].balance += uint64(quantity);
1113             _addressData[to].numberMinted += uint64(quantity);
1114 
1115             _ownerships[startTokenId].addr = to;
1116             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1117 
1118             uint256 updatedIndex = startTokenId;
1119             uint256 end = updatedIndex + quantity;
1120 
1121             if (safe && to.isContract()) {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex);
1124                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex != end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex != end);
1134             }
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must be owned by `from`.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _transfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) private {
1155         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1156 
1157         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1158 
1159         bool isApprovedOrOwner = (_msgSender() == from ||
1160             isApprovedForAll(from, _msgSender()) ||
1161             getApproved(tokenId) == _msgSender());
1162 
1163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1164         if (to == address(0)) revert TransferToZeroAddress();
1165 
1166         _beforeTokenTransfers(from, to, tokenId, 1);
1167 
1168         // Clear approvals from the previous owner
1169         _approve(address(0), tokenId, from);
1170 
1171         // Underflow of the sender's balance is impossible because we check for
1172         // ownership above and the recipient's balance can't realistically overflow.
1173         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1174         unchecked {
1175             _addressData[from].balance -= 1;
1176             _addressData[to].balance += 1;
1177 
1178             TokenOwnership storage currSlot = _ownerships[tokenId];
1179             currSlot.addr = to;
1180             currSlot.startTimestamp = uint64(block.timestamp);
1181 
1182             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1183             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1184             uint256 nextTokenId = tokenId + 1;
1185             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1186             if (nextSlot.addr == address(0)) {
1187                 // This will suffice for checking _exists(nextTokenId),
1188                 // as a burned slot cannot contain the zero address.
1189                 if (nextTokenId != _currentIndex) {
1190                     nextSlot.addr = from;
1191                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1192                 }
1193             }
1194         }
1195 
1196         emit Transfer(from, to, tokenId);
1197         _afterTokenTransfers(from, to, tokenId, 1);
1198     }
1199 
1200     /**
1201      * @dev This is equivalent to _burn(tokenId, false)
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1219 
1220         address from = prevOwnership.addr;
1221 
1222         if (approvalCheck) {
1223             bool isApprovedOrOwner = (_msgSender() == from ||
1224                 isApprovedForAll(from, _msgSender()) ||
1225                 getApproved(tokenId) == _msgSender());
1226 
1227             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner
1233         _approve(address(0), tokenId, from);
1234 
1235         // Underflow of the sender's balance is impossible because we check for
1236         // ownership above and the recipient's balance can't realistically overflow.
1237         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1238         unchecked {
1239             AddressData storage addressData = _addressData[from];
1240             addressData.balance -= 1;
1241             addressData.numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             TokenOwnership storage currSlot = _ownerships[tokenId];
1245             currSlot.addr = from;
1246             currSlot.startTimestamp = uint64(block.timestamp);
1247             currSlot.burned = true;
1248 
1249             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1250             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1251             uint256 nextTokenId = tokenId + 1;
1252             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1253             if (nextSlot.addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId != _currentIndex) {
1257                     nextSlot.addr = from;
1258                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, address(0), tokenId);
1264         _afterTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(
1278         address to,
1279         uint256 tokenId,
1280         address owner
1281     ) private {
1282         _tokenApprovals[tokenId] = to;
1283         emit Approval(owner, to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1288      *
1289      * @param from address representing the previous owner of the given token ID
1290      * @param to target address that will receive the tokens
1291      * @param tokenId uint256 ID of the token to be transferred
1292      * @param _data bytes optional data to send along with the call
1293      * @return bool whether the call correctly returned the expected magic value
1294      */
1295     function _checkContractOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1302             return retval == IERC721Receiver(to).onERC721Received.selector;
1303         } catch (bytes memory reason) {
1304             if (reason.length == 0) {
1305                 revert TransferToNonERC721ReceiverImplementer();
1306             } else {
1307                 assembly {
1308                     revert(add(32, reason), mload(reason))
1309                 }
1310             }
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _beforeTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1338      * minting.
1339      * And also called after one token has been burned.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 }
1359 
1360 // File: contracts/drago.sol
1361 
1362 
1363 
1364 pragma solidity ^0.8.4;
1365 
1366 
1367 
1368 
1369 contract dragowtf is ERC721A, Ownable, ReentrancyGuard {
1370     using Strings for uint256;
1371 
1372     uint256 public PRICE;
1373     uint256 public MAX_SUPPLY;
1374     string private BASE_URI;
1375     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1376     uint256 public MAX_MINT_AMOUNT_PER_TX;
1377     bool public IS_SALE_ACTIVE;
1378     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1379     bool public METADATA_FROZEN;
1380 
1381     mapping(address => uint256) private freeMintCountMap;
1382 
1383     constructor(
1384         uint256 price,
1385         uint256 maxSupply,
1386         string memory baseUri,
1387         uint256 freeMintAllowance,
1388         uint256 maxMintPerTx,
1389         bool isSaleActive,
1390         uint256 freeMintIsAllowedUntil
1391     ) ERC721A("dragowtf", "dragowtf") {
1392         PRICE = price;
1393         MAX_SUPPLY = maxSupply;
1394         BASE_URI = baseUri;
1395         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1396         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1397         IS_SALE_ACTIVE = isSaleActive;
1398         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1399     }
1400 
1401     function updateFreeMintCount(address minter, uint256 count) private {
1402         freeMintCountMap[minter] += count;
1403     }
1404 
1405     function _baseURI() internal view virtual override returns (string memory) {
1406         return BASE_URI;
1407     }
1408 
1409     function setPrice(uint256 customPrice) external onlyOwner {
1410         PRICE = customPrice;
1411     }
1412 
1413     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1414         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1415         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1416         MAX_SUPPLY = newMaxSupply;
1417     }
1418 
1419     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1420         require(!METADATA_FROZEN, "Metadata frozen!");
1421         BASE_URI = customBaseURI_;
1422     }
1423 
1424     function setFreeMintAllowance(uint256 freeMintAllowance)
1425         external
1426         onlyOwner
1427     {
1428         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1429     }
1430 
1431     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1432         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1433     }
1434 
1435     function setSaleActive(bool saleIsActive) external onlyOwner {
1436         IS_SALE_ACTIVE = saleIsActive;
1437     }
1438 
1439     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1440         external
1441         onlyOwner
1442     {
1443         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1444     }
1445 
1446     function freezeMetadata() external onlyOwner {
1447         METADATA_FROZEN = true;
1448     }
1449 
1450     modifier mintCompliance(uint256 _mintAmount) {
1451         require(
1452             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1453             "Invalid mint amount!"
1454         );
1455         require(
1456             _currentIndex + _mintAmount <= MAX_SUPPLY,
1457             "Max supply exceeded!"
1458         );
1459         _;
1460     }
1461 
1462     function freeMint(uint256 _mintAmount)
1463         public
1464         payable
1465         mintCompliance(_mintAmount)
1466     {
1467         require(IS_SALE_ACTIVE, "Sale is not active!");
1468 
1469         uint256 price = PRICE * _mintAmount;
1470 
1471         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1472             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1473                 freeMintCountMap[msg.sender];
1474             if (remainingFreeMint > 0) {
1475                 if (_mintAmount >= remainingFreeMint) {
1476                     price -= remainingFreeMint * PRICE;
1477                     updateFreeMintCount(msg.sender, remainingFreeMint);
1478                 } else {
1479                     price -= _mintAmount * PRICE;
1480                     updateFreeMintCount(msg.sender, _mintAmount);
1481                 }
1482             }
1483         }
1484 
1485         require(msg.value >= price, "Insufficient funds!");
1486 
1487         _safeMint(msg.sender, _mintAmount);
1488     }
1489 
1490     function mintOwner(address _to, uint256 _mintAmount) public onlyOwner {
1491         require(
1492             _currentIndex + _mintAmount <= MAX_SUPPLY,
1493             "Max supply exceeded!"
1494         );
1495 
1496         _safeMint(_to, _mintAmount);
1497     }
1498 
1499     function withdraw() public onlyOwner nonReentrant {
1500         uint256 balance = address(this).balance;
1501 
1502         Address.sendValue(
1503             payable(0x30F81d50C92916433084eE6b30772d66236D7Ff7),
1504             balance
1505         );
1506     }
1507 }