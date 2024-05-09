1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 // SPDX-License-Identifier: MIT
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
731 // File: contracts/ERC721A.sol
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
832         return 1;
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
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
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
1060         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1061     }
1062 
1063     /**
1064      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1065      */
1066     function _safeMint(address to, uint256 quantity) internal {
1067         _safeMint(to, quantity, '');
1068     }
1069 
1070     /**
1071      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - If `to` refers to a smart contract, it must implement 
1076      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeMint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data
1085     ) internal {
1086         uint256 startTokenId = _currentIndex;
1087         if (to == address(0)) revert MintToZeroAddress();
1088         if (quantity == 0) revert MintZeroQuantity();
1089 
1090         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1094         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint64(quantity);
1097             _addressData[to].numberMinted += uint64(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103             uint256 end = updatedIndex + quantity;
1104 
1105             if (to.isContract()) {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex);
1108                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1109                         revert TransferToNonERC721ReceiverImplementer();
1110                     }
1111                 } while (updatedIndex != end);
1112                 // Reentrancy protection
1113                 if (_currentIndex != startTokenId) revert();
1114             } else {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex++);
1117                 } while (updatedIndex != end);
1118             }
1119             _currentIndex = updatedIndex;
1120         }
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Mints `quantity` tokens and transfers them to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `quantity` must be greater than 0.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _mint(address to, uint256 quantity) internal {
1135         uint256 startTokenId = _currentIndex;
1136         if (to == address(0)) revert MintToZeroAddress();
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1143         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1144         unchecked {
1145             _addressData[to].balance += uint64(quantity);
1146             _addressData[to].numberMinted += uint64(quantity);
1147 
1148             _ownerships[startTokenId].addr = to;
1149             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             uint256 updatedIndex = startTokenId;
1152             uint256 end = updatedIndex + quantity;
1153 
1154             do {
1155                 emit Transfer(address(0), to, updatedIndex++);
1156             } while (updatedIndex != end);
1157 
1158             _currentIndex = updatedIndex;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) private {
1178         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1179 
1180         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1181 
1182         bool isApprovedOrOwner = (_msgSender() == from ||
1183             isApprovedForAll(from, _msgSender()) ||
1184             getApproved(tokenId) == _msgSender());
1185 
1186         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1187         if (to == address(0)) revert TransferToZeroAddress();
1188 
1189         _beforeTokenTransfers(from, to, tokenId, 1);
1190 
1191         // Clear approvals from the previous owner
1192         _approve(address(0), tokenId, from);
1193 
1194         // Underflow of the sender's balance is impossible because we check for
1195         // ownership above and the recipient's balance can't realistically overflow.
1196         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1197         unchecked {
1198             _addressData[from].balance -= 1;
1199             _addressData[to].balance += 1;
1200 
1201             TokenOwnership storage currSlot = _ownerships[tokenId];
1202             currSlot.addr = to;
1203             currSlot.startTimestamp = uint64(block.timestamp);
1204 
1205             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1206             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1207             uint256 nextTokenId = tokenId + 1;
1208             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1209             if (nextSlot.addr == address(0)) {
1210                 // This will suffice for checking _exists(nextTokenId),
1211                 // as a burned slot cannot contain the zero address.
1212                 if (nextTokenId != _currentIndex) {
1213                     nextSlot.addr = from;
1214                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(from, to, tokenId);
1220         _afterTokenTransfers(from, to, tokenId, 1);
1221     }
1222 
1223     /**
1224      * @dev Equivalent to `_burn(tokenId, false)`.
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         _burn(tokenId, false);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1241         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1242 
1243         address from = prevOwnership.addr;
1244 
1245         if (approvalCheck) {
1246             bool isApprovedOrOwner = (_msgSender() == from ||
1247                 isApprovedForAll(from, _msgSender()) ||
1248                 getApproved(tokenId) == _msgSender());
1249 
1250             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1251         }
1252 
1253         _beforeTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId, from);
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1261         unchecked {
1262             AddressData storage addressData = _addressData[from];
1263             addressData.balance -= 1;
1264             addressData.numberBurned += 1;
1265 
1266             // Keep track of who burned the token, and the timestamp of burning.
1267             TokenOwnership storage currSlot = _ownerships[tokenId];
1268             currSlot.addr = from;
1269             currSlot.startTimestamp = uint64(block.timestamp);
1270             currSlot.burned = true;
1271 
1272             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1273             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1274             uint256 nextTokenId = tokenId + 1;
1275             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1276             if (nextSlot.addr == address(0)) {
1277                 // This will suffice for checking _exists(nextTokenId),
1278                 // as a burned slot cannot contain the zero address.
1279                 if (nextTokenId != _currentIndex) {
1280                     nextSlot.addr = from;
1281                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(from, address(0), tokenId);
1287         _afterTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1290         unchecked {
1291             _burnCounter++;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Approve `to` to operate on `tokenId`
1297      *
1298      * Emits a {Approval} event.
1299      */
1300     function _approve(
1301         address to,
1302         uint256 tokenId,
1303         address owner
1304     ) private {
1305         _tokenApprovals[tokenId] = to;
1306         emit Approval(owner, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1311      *
1312      * @param from address representing the previous owner of the given token ID
1313      * @param to target address that will receive the tokens
1314      * @param tokenId uint256 ID of the token to be transferred
1315      * @param _data bytes optional data to send along with the call
1316      * @return bool whether the call correctly returned the expected magic value
1317      */
1318     function _checkContractOnERC721Received(
1319         address from,
1320         address to,
1321         uint256 tokenId,
1322         bytes memory _data
1323     ) private returns (bool) {
1324         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1325             return retval == IERC721Receiver(to).onERC721Received.selector;
1326         } catch (bytes memory reason) {
1327             if (reason.length == 0) {
1328                 revert TransferToNonERC721ReceiverImplementer();
1329             } else {
1330                 assembly {
1331                     revert(add(32, reason), mload(reason))
1332                 }
1333             }
1334         }
1335     }
1336 
1337     /**
1338      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1339      * And also called before burning one token.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, `tokenId` will be burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _beforeTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 
1359     /**
1360      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1361      * minting.
1362      * And also called after one token has been burned.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` has been minted for `to`.
1372      * - When `to` is zero, `tokenId` has been burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _afterTokenTransfers(
1376         address from,
1377         address to,
1378         uint256 startTokenId,
1379         uint256 quantity
1380     ) internal virtual {}
1381 }
1382 // File: contracts/Pls
1383 
1384 
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 
1389 
1390 
1391 
1392 contract Electra is ERC721A, Ownable, ReentrancyGuard {
1393   using Address for address;
1394   using Strings for uint;
1395 
1396 
1397   string  public  baseTokenURI = "ipfs://QmYHTuqxQnKpWzRAggqaWMfS1Vgr3H8Yo2PDUPbTnd4Er2/hidden.json";
1398   string  public  STAGE_ONE = "True";
1399   string  public  STAGE_TWO = "False";
1400   string  public  EVOLUTION = "3 Days, 3 Hours, 33 Minutes, 33 Seconds";
1401   uint256 public  maxSupply = 333;
1402   uint256 public  MAX_MINTS_PER_TX = 1;
1403   uint256 public  PUBLIC_SALE_PRICE = 0.0033 ether;
1404   uint256 public  NUM_FREE_MINTS = 0;
1405   uint256 public  MAX_FREE_PER_WALLET = 0;
1406   uint256 public freeNFTAlreadyMinted = 0;
1407   bool public isPublicSaleActive = false;
1408 
1409   constructor(
1410 
1411   ) ERC721A("333 Electra", "ELECTRA") {
1412 
1413   }
1414 
1415 
1416   function mint(uint256 numberOfTokens)
1417       external
1418       payable
1419   {
1420     require(isPublicSaleActive, "Public sale is not open");
1421     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1422 
1423     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1424         require(
1425             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1426             "Incorrect ETH value sent"
1427         );
1428     } else {
1429         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1430         require(
1431             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1432             "Incorrect ETH value sent"
1433         );
1434         require(
1435             numberOfTokens <= MAX_MINTS_PER_TX,
1436             "Max mints per transaction exceeded"
1437         );
1438         } else {
1439             require(
1440                 numberOfTokens <= MAX_FREE_PER_WALLET,
1441                 "Max mints per transaction exceeded"
1442             );
1443             freeNFTAlreadyMinted += numberOfTokens;
1444         }
1445     }
1446     _safeMint(msg.sender, numberOfTokens);
1447   }
1448 
1449   function setBaseURI(string memory baseURI)
1450     public
1451     onlyOwner
1452   {
1453     baseTokenURI = baseURI;
1454   }
1455 
1456   function treasuryMint(uint quantity)
1457     public
1458     onlyOwner
1459   {
1460     require(
1461       quantity > 0,
1462       "Invalid mint amount"
1463     );
1464     require(
1465       totalSupply() + quantity <= maxSupply,
1466       "Maximum supply exceeded"
1467     );
1468     _safeMint(msg.sender, quantity);
1469   }
1470 
1471   function withdraw()
1472     public
1473     onlyOwner
1474     nonReentrant
1475   {
1476     Address.sendValue(payable(msg.sender), address(this).balance);
1477   }
1478 
1479   function tokenURI(uint _tokenId)
1480     public
1481     view
1482     virtual
1483     override
1484     returns (string memory)
1485   {
1486     require(
1487       _exists(_tokenId),
1488       "ERC721Metadata: URI query for nonexistent token"
1489     );
1490     return string(abi.encodePacked(baseTokenURI));
1491   }
1492 
1493   function _baseURI()
1494     internal
1495     view
1496     virtual
1497     override
1498     returns (string memory)
1499   {
1500     return baseTokenURI;
1501   }
1502 
1503   function setIsPublicSaleActive(bool _isPublicSaleActive)
1504       external
1505       onlyOwner
1506   {
1507       isPublicSaleActive = _isPublicSaleActive;
1508   }
1509 
1510   function setNumFreeMints(uint256 _numfreemints)
1511       external
1512       onlyOwner
1513   {
1514       NUM_FREE_MINTS = _numfreemints;
1515   }
1516 
1517   function setSalePrice(uint256 _price)
1518       external
1519       onlyOwner
1520   {
1521       PUBLIC_SALE_PRICE = _price;
1522   }
1523 
1524   function setMaxLimitPerTransaction(uint256 _limit)
1525       external
1526       onlyOwner
1527   {
1528       MAX_MINTS_PER_TX = _limit;
1529   }
1530 
1531   function setFreeLimitPerWallet(uint256 _limit)
1532       external
1533       onlyOwner
1534   {
1535       MAX_FREE_PER_WALLET = _limit;
1536   }
1537 }