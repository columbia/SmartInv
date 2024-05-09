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
471 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
488      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
560 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Transfers `tokenId` token from `from` to `to`.
640      *
641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
660      * The approval is cleared when the token is transferred.
661      *
662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
663      *
664      * Requirements:
665      *
666      * - The caller must own the token or be an approved operator.
667      * - `tokenId` must exist.
668      *
669      * Emits an {Approval} event.
670      */
671     function approve(address to, uint256 tokenId) external;
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns the account approved for `tokenId` token.
687      *
688      * Requirements:
689      *
690      * - `tokenId` must exist.
691      */
692     function getApproved(uint256 tokenId) external view returns (address operator);
693 
694     /**
695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
696      *
697      * See {setApprovalForAll}
698      */
699     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
731 // File: erc721a/contracts/IERC721A.sol
732 
733 
734 // ERC721A Contracts v3.3.0
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.4;
738 
739 
740 
741 /**
742  * @dev Interface of an ERC721A compliant contract.
743  */
744 interface IERC721A is IERC721, IERC721Metadata {
745     /**
746      * The caller must own the token or be an approved operator.
747      */
748     error ApprovalCallerNotOwnerNorApproved();
749 
750     /**
751      * The token does not exist.
752      */
753     error ApprovalQueryForNonexistentToken();
754 
755     /**
756      * The caller cannot approve to their own address.
757      */
758     error ApproveToCaller();
759 
760     /**
761      * The caller cannot approve to the current owner.
762      */
763     error ApprovalToCurrentOwner();
764 
765     /**
766      * Cannot query the balance for the zero address.
767      */
768     error BalanceQueryForZeroAddress();
769 
770     /**
771      * Cannot mint to the zero address.
772      */
773     error MintToZeroAddress();
774 
775     /**
776      * The quantity of tokens minted must be more than zero.
777      */
778     error MintZeroQuantity();
779 
780     /**
781      * The token does not exist.
782      */
783     error OwnerQueryForNonexistentToken();
784 
785     /**
786      * The caller must own the token or be an approved operator.
787      */
788     error TransferCallerNotOwnerNorApproved();
789 
790     /**
791      * The token must be owned by `from`.
792      */
793     error TransferFromIncorrectOwner();
794 
795     /**
796      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
797      */
798     error TransferToNonERC721ReceiverImplementer();
799 
800     /**
801      * Cannot transfer to the zero address.
802      */
803     error TransferToZeroAddress();
804 
805     /**
806      * The token does not exist.
807      */
808     error URIQueryForNonexistentToken();
809 
810     // Compiler will pack this into a single 256bit word.
811     struct TokenOwnership {
812         // The address of the owner.
813         address addr;
814         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
815         uint64 startTimestamp;
816         // Whether the token has been burned.
817         bool burned;
818     }
819 
820     // Compiler will pack this into a single 256bit word.
821     struct AddressData {
822         // Realistically, 2**64-1 is more than enough.
823         uint64 balance;
824         // Keeps track of mint count with minimal overhead for tokenomics.
825         uint64 numberMinted;
826         // Keeps track of burn count with minimal overhead for tokenomics.
827         uint64 numberBurned;
828         // For miscellaneous variable(s) pertaining to the address
829         // (e.g. number of whitelist mint slots used).
830         // If there are multiple variables, please pack them into a uint64.
831         uint64 aux;
832     }
833 
834     /**
835      * @dev Returns the total amount of tokens stored by the contract.
836      * 
837      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
838      */
839     function totalSupply() external view returns (uint256);
840 }
841 
842 // File: erc721a/contracts/ERC721A.sol
843 
844 
845 // ERC721A Contracts v3.3.0
846 // Creator: Chiru Labs
847 
848 pragma solidity ^0.8.4;
849 
850 
851 
852 
853 
854 
855 
856 /**
857  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
858  * the Metadata extension. Built to optimize for lower gas during batch mints.
859  *
860  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
861  *
862  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
863  *
864  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
865  */
866 contract ERC721A is Context, ERC165, IERC721A {
867     using Address for address;
868     using Strings for uint256;
869 
870     // The tokenId of the next token to be minted.
871     uint256 internal _currentIndex;
872 
873     // The number of tokens burned.
874     uint256 internal _burnCounter;
875 
876     // Token name
877     string private _name;
878 
879     // Token symbol
880     string private _symbol;
881 
882     // Mapping from token ID to ownership details
883     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
884     mapping(uint256 => TokenOwnership) internal _ownerships;
885 
886     // Mapping owner address to address data
887     mapping(address => AddressData) private _addressData;
888 
889     // Mapping from token ID to approved address
890     mapping(uint256 => address) private _tokenApprovals;
891 
892     // Mapping from owner to operator approvals
893     mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895     constructor(string memory name_, string memory symbol_) {
896         _name = name_;
897         _symbol = symbol_;
898         _currentIndex = _startTokenId();
899     }
900 
901     /**
902      * To change the starting tokenId, please override this function.
903      */
904     function _startTokenId() internal view virtual returns (uint256) {
905         return 0;
906     }
907 
908     /**
909      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
910      */
911     function totalSupply() public view override returns (uint256) {
912         // Counter underflow is impossible as _burnCounter cannot be incremented
913         // more than _currentIndex - _startTokenId() times
914         unchecked {
915             return _currentIndex - _burnCounter - _startTokenId();
916         }
917     }
918 
919     /**
920      * Returns the total amount of tokens minted in the contract.
921      */
922     function _totalMinted() internal view returns (uint256) {
923         // Counter underflow is impossible as _currentIndex does not decrement,
924         // and it is initialized to _startTokenId()
925         unchecked {
926             return _currentIndex - _startTokenId();
927         }
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
934         return
935             interfaceId == type(IERC721).interfaceId ||
936             interfaceId == type(IERC721Metadata).interfaceId ||
937             super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view override returns (uint256) {
944         if (owner == address(0)) revert BalanceQueryForZeroAddress();
945         return uint256(_addressData[owner].balance);
946     }
947 
948     /**
949      * Returns the number of tokens minted by `owner`.
950      */
951     function _numberMinted(address owner) internal view returns (uint256) {
952         return uint256(_addressData[owner].numberMinted);
953     }
954 
955     /**
956      * Returns the number of tokens burned by or on behalf of `owner`.
957      */
958     function _numberBurned(address owner) internal view returns (uint256) {
959         return uint256(_addressData[owner].numberBurned);
960     }
961 
962     /**
963      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
964      */
965     function _getAux(address owner) internal view returns (uint64) {
966         return _addressData[owner].aux;
967     }
968 
969     /**
970      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
971      * If there are multiple variables, please pack them into a uint64.
972      */
973     function _setAux(address owner, uint64 aux) internal {
974         _addressData[owner].aux = aux;
975     }
976 
977     /**
978      * Gas spent here starts off proportional to the maximum mint batch size.
979      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
980      */
981     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
982         uint256 curr = tokenId;
983 
984         unchecked {
985             if (_startTokenId() <= curr) if (curr < _currentIndex) {
986                 TokenOwnership memory ownership = _ownerships[curr];
987                 if (!ownership.burned) {
988                     if (ownership.addr != address(0)) {
989                         return ownership;
990                     }
991                     // Invariant:
992                     // There will always be an ownership that has an address and is not burned
993                     // before an ownership that does not have an address and is not burned.
994                     // Hence, curr will not underflow.
995                     while (true) {
996                         curr--;
997                         ownership = _ownerships[curr];
998                         if (ownership.addr != address(0)) {
999                             return ownership;
1000                         }
1001                     }
1002                 }
1003             }
1004         }
1005         revert OwnerQueryForNonexistentToken();
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view override returns (address) {
1012         return _ownershipOf(tokenId).addr;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-name}.
1017      */
1018     function name() public view virtual override returns (string memory) {
1019         return _name;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-symbol}.
1024      */
1025     function symbol() public view virtual override returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-tokenURI}.
1031      */
1032     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1033         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1034 
1035         string memory baseURI = _baseURI();
1036         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1037     }
1038 
1039     /**
1040      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1041      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1042      * by default, can be overriden in child contracts.
1043      */
1044     function _baseURI() internal view virtual returns (string memory) {
1045         return '';
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-approve}.
1050      */
1051     function approve(address to, uint256 tokenId) public override {
1052         address owner = ERC721A.ownerOf(tokenId);
1053         if (to == owner) revert ApprovalToCurrentOwner();
1054 
1055         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1056             revert ApprovalCallerNotOwnerNorApproved();
1057         }
1058 
1059         _approve(to, tokenId, owner);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-getApproved}.
1064      */
1065     function getApproved(uint256 tokenId) public view override returns (address) {
1066         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1067 
1068         return _tokenApprovals[tokenId];
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-setApprovalForAll}.
1073      */
1074     function setApprovalForAll(address operator, bool approved) public virtual override {
1075         if (operator == _msgSender()) revert ApproveToCaller();
1076 
1077         _operatorApprovals[_msgSender()][operator] = approved;
1078         emit ApprovalForAll(_msgSender(), operator, approved);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-isApprovedForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-transferFrom}.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         _transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, '');
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) public virtual override {
1119         _transfer(from, to, tokenId);
1120         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1121             revert TransferToNonERC721ReceiverImplementer();
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns whether `tokenId` exists.
1127      *
1128      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1129      *
1130      * Tokens start existing when they are minted (`_mint`),
1131      */
1132     function _exists(uint256 tokenId) internal view returns (bool) {
1133         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1134     }
1135 
1136     /**
1137      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1138      */
1139     function _safeMint(address to, uint256 quantity) internal {
1140         _safeMint(to, quantity, '');
1141     }
1142 
1143     /**
1144      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - If `to` refers to a smart contract, it must implement
1149      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) revert MintZeroQuantity();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are incredibly unrealistic.
1166         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1167         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1168         unchecked {
1169             _addressData[to].balance += uint64(quantity);
1170             _addressData[to].numberMinted += uint64(quantity);
1171 
1172             _ownerships[startTokenId].addr = to;
1173             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             uint256 updatedIndex = startTokenId;
1176             uint256 end = updatedIndex + quantity;
1177 
1178             if (to.isContract()) {
1179                 do {
1180                     emit Transfer(address(0), to, updatedIndex);
1181                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1182                         revert TransferToNonERC721ReceiverImplementer();
1183                     }
1184                 } while (updatedIndex < end);
1185                 // Reentrancy protection
1186                 if (_currentIndex != startTokenId) revert();
1187             } else {
1188                 do {
1189                     emit Transfer(address(0), to, updatedIndex++);
1190                 } while (updatedIndex < end);
1191             }
1192             _currentIndex = updatedIndex;
1193         }
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     /**
1198      * @dev Mints `quantity` tokens and transfers them to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `quantity` must be greater than 0.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _mint(address to, uint256 quantity) internal {
1208         uint256 startTokenId = _currentIndex;
1209         if (to == address(0)) revert MintToZeroAddress();
1210         if (quantity == 0) revert MintZeroQuantity();
1211 
1212         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1213 
1214         // Overflows are incredibly unrealistic.
1215         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1216         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1217         unchecked {
1218             _addressData[to].balance += uint64(quantity);
1219             _addressData[to].numberMinted += uint64(quantity);
1220 
1221             _ownerships[startTokenId].addr = to;
1222             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1223 
1224             uint256 updatedIndex = startTokenId;
1225             uint256 end = updatedIndex + quantity;
1226 
1227             do {
1228                 emit Transfer(address(0), to, updatedIndex++);
1229             } while (updatedIndex < end);
1230 
1231             _currentIndex = updatedIndex;
1232         }
1233         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1234     }
1235 
1236     /**
1237      * @dev Transfers `tokenId` from `from` to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must be owned by `from`.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _transfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) private {
1251         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1252 
1253         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1254 
1255         bool isApprovedOrOwner = (_msgSender() == from ||
1256             isApprovedForAll(from, _msgSender()) ||
1257             getApproved(tokenId) == _msgSender());
1258 
1259         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1260         if (to == address(0)) revert TransferToZeroAddress();
1261 
1262         _beforeTokenTransfers(from, to, tokenId, 1);
1263 
1264         // Clear approvals from the previous owner
1265         _approve(address(0), tokenId, from);
1266 
1267         // Underflow of the sender's balance is impossible because we check for
1268         // ownership above and the recipient's balance can't realistically overflow.
1269         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1270         unchecked {
1271             _addressData[from].balance -= 1;
1272             _addressData[to].balance += 1;
1273 
1274             TokenOwnership storage currSlot = _ownerships[tokenId];
1275             currSlot.addr = to;
1276             currSlot.startTimestamp = uint64(block.timestamp);
1277 
1278             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1279             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1280             uint256 nextTokenId = tokenId + 1;
1281             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1282             if (nextSlot.addr == address(0)) {
1283                 // This will suffice for checking _exists(nextTokenId),
1284                 // as a burned slot cannot contain the zero address.
1285                 if (nextTokenId != _currentIndex) {
1286                     nextSlot.addr = from;
1287                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1288                 }
1289             }
1290         }
1291 
1292         emit Transfer(from, to, tokenId);
1293         _afterTokenTransfers(from, to, tokenId, 1);
1294     }
1295 
1296     /**
1297      * @dev Equivalent to `_burn(tokenId, false)`.
1298      */
1299     function _burn(uint256 tokenId) internal virtual {
1300         _burn(tokenId, false);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1314         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1315 
1316         address from = prevOwnership.addr;
1317 
1318         if (approvalCheck) {
1319             bool isApprovedOrOwner = (_msgSender() == from ||
1320                 isApprovedForAll(from, _msgSender()) ||
1321                 getApproved(tokenId) == _msgSender());
1322 
1323             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1324         }
1325 
1326         _beforeTokenTransfers(from, address(0), tokenId, 1);
1327 
1328         // Clear approvals from the previous owner
1329         _approve(address(0), tokenId, from);
1330 
1331         // Underflow of the sender's balance is impossible because we check for
1332         // ownership above and the recipient's balance can't realistically overflow.
1333         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1334         unchecked {
1335             AddressData storage addressData = _addressData[from];
1336             addressData.balance -= 1;
1337             addressData.numberBurned += 1;
1338 
1339             // Keep track of who burned the token, and the timestamp of burning.
1340             TokenOwnership storage currSlot = _ownerships[tokenId];
1341             currSlot.addr = from;
1342             currSlot.startTimestamp = uint64(block.timestamp);
1343             currSlot.burned = true;
1344 
1345             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1346             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1347             uint256 nextTokenId = tokenId + 1;
1348             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1349             if (nextSlot.addr == address(0)) {
1350                 // This will suffice for checking _exists(nextTokenId),
1351                 // as a burned slot cannot contain the zero address.
1352                 if (nextTokenId != _currentIndex) {
1353                     nextSlot.addr = from;
1354                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1355                 }
1356             }
1357         }
1358 
1359         emit Transfer(from, address(0), tokenId);
1360         _afterTokenTransfers(from, address(0), tokenId, 1);
1361 
1362         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1363         unchecked {
1364             _burnCounter++;
1365         }
1366     }
1367 
1368     /**
1369      * @dev Approve `to` to operate on `tokenId`
1370      *
1371      * Emits a {Approval} event.
1372      */
1373     function _approve(
1374         address to,
1375         uint256 tokenId,
1376         address owner
1377     ) private {
1378         _tokenApprovals[tokenId] = to;
1379         emit Approval(owner, to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1384      *
1385      * @param from address representing the previous owner of the given token ID
1386      * @param to target address that will receive the tokens
1387      * @param tokenId uint256 ID of the token to be transferred
1388      * @param _data bytes optional data to send along with the call
1389      * @return bool whether the call correctly returned the expected magic value
1390      */
1391     function _checkContractOnERC721Received(
1392         address from,
1393         address to,
1394         uint256 tokenId,
1395         bytes memory _data
1396     ) private returns (bool) {
1397         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1398             return retval == IERC721Receiver(to).onERC721Received.selector;
1399         } catch (bytes memory reason) {
1400             if (reason.length == 0) {
1401                 revert TransferToNonERC721ReceiverImplementer();
1402             } else {
1403                 assembly {
1404                     revert(add(32, reason), mload(reason))
1405                 }
1406             }
1407         }
1408     }
1409 
1410     /**
1411      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1412      * And also called before burning one token.
1413      *
1414      * startTokenId - the first token id to be transferred
1415      * quantity - the amount to be transferred
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      * - When `to` is zero, `tokenId` will be burned by `from`.
1423      * - `from` and `to` are never both zero.
1424      */
1425     function _beforeTokenTransfers(
1426         address from,
1427         address to,
1428         uint256 startTokenId,
1429         uint256 quantity
1430     ) internal virtual {}
1431 
1432     /**
1433      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1434      * minting.
1435      * And also called after one token has been burned.
1436      *
1437      * startTokenId - the first token id to be transferred
1438      * quantity - the amount to be transferred
1439      *
1440      * Calling conditions:
1441      *
1442      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1443      * transferred to `to`.
1444      * - When `from` is zero, `tokenId` has been minted for `to`.
1445      * - When `to` is zero, `tokenId` has been burned by `from`.
1446      * - `from` and `to` are never both zero.
1447      */
1448     function _afterTokenTransfers(
1449         address from,
1450         address to,
1451         uint256 startTokenId,
1452         uint256 quantity
1453     ) internal virtual {}
1454 }
1455 
1456 // File: contracts/whaleeventsbayc.sol
1457 
1458 
1459 
1460 pragma solidity ^0.8.4;
1461 
1462 
1463 
1464 
1465 contract CollectionEvents is ERC721A, Ownable, ReentrancyGuard {
1466     using Strings for uint256;
1467 
1468     uint256 public cost;
1469     uint256 public maxSupply;
1470     string private BASE_URI;
1471     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1472     uint256 public MAX_MINT_AMOUNT_PER_TX;
1473     bool public IS_SALE_ACTIVE;
1474     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1475     bool public METADATA_FROZEN;
1476 
1477     mapping(address => uint256) private freeMintCountMap;
1478 
1479     constructor(
1480         uint256 price,
1481         uint256 max_Supply,
1482         string memory baseUri,
1483         uint256 freeMintAllowance,
1484         uint256 maxMintPerTx,
1485         bool isSaleActive,
1486         uint256 freeMintIsAllowedUntil
1487     ) ERC721A("Collection Events", "PASS") {
1488         cost = price;
1489         maxSupply = max_Supply;
1490         BASE_URI = baseUri;
1491         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1492         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1493         IS_SALE_ACTIVE = isSaleActive;
1494         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1495     }
1496 
1497     /** FREE MINT **/
1498 
1499     function updateFreeMintCount(address minter, uint256 count) private {
1500         freeMintCountMap[minter] += count;
1501     }
1502 
1503     /** GETTERS **/
1504 
1505     function _baseURI() internal view virtual override returns (string memory) {
1506         return BASE_URI;
1507     }
1508 
1509     /** SETTERS **/
1510 
1511     function setPrice(uint256 customPrice) external onlyOwner {
1512         cost = customPrice;
1513     }
1514 
1515     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1516         require(newMaxSupply > maxSupply, "Invalid new max supply");
1517         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1518         maxSupply = newMaxSupply;
1519     }
1520 
1521     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1522         require(!METADATA_FROZEN, "Metadata frozen!");
1523         BASE_URI = customBaseURI_;
1524     }
1525 
1526     function setFreeMintAllowance(uint256 freeMintAllowance)
1527         external
1528         onlyOwner
1529     {
1530         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1531     }
1532 
1533     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1534         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1535     }
1536 
1537     function setSaleActive(bool saleIsActive) external onlyOwner {
1538         IS_SALE_ACTIVE = saleIsActive;
1539     }
1540 
1541     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1542         external
1543         onlyOwner
1544     {
1545         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1546     }
1547 
1548     function freezeMetadata() external onlyOwner {
1549         METADATA_FROZEN = true;
1550     }
1551 
1552     /** MINT **/
1553 
1554     modifier mintCompliance(uint256 _mintAmount) {
1555         require(
1556             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1557             "Invalid mint amount!"
1558         );
1559         require(
1560             _currentIndex + _mintAmount <= maxSupply,
1561             "Max supply exceeded!"
1562         );
1563         _;
1564     }
1565 
1566     function mint(uint256 _mintAmount)
1567         public
1568         payable
1569         mintCompliance(_mintAmount)
1570     {
1571         require(IS_SALE_ACTIVE, "Sale is not active!");
1572 
1573         uint256 price = cost * _mintAmount;
1574 
1575         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1576             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1577                 freeMintCountMap[msg.sender];
1578             if (remainingFreeMint > 0) {
1579                 if (_mintAmount >= remainingFreeMint) {
1580                     price -= remainingFreeMint * cost;
1581                     updateFreeMintCount(msg.sender, remainingFreeMint);
1582                 } else {
1583                     price -= _mintAmount * cost;
1584                     updateFreeMintCount(msg.sender, _mintAmount);
1585                 }
1586             }
1587         }
1588 
1589         require(msg.value >= price, "Insufficient funds!");
1590 
1591         _safeMint(msg.sender, _mintAmount);
1592     }
1593 
1594     function mintOwner(address _to, uint256 _mintAmount)
1595         public
1596         mintCompliance(_mintAmount)
1597         onlyOwner
1598     {
1599         _safeMint(_to, _mintAmount);
1600     }
1601 
1602     /** PAYOUT **/
1603 
1604     function withdraw() public onlyOwner nonReentrant {
1605         uint256 balance = address(this).balance;
1606 
1607         Address.sendValue(
1608             payable(0xA6286487fF71763aE84ea06D2393944eF3c7b390),
1609             balance
1610         );
1611     }
1612 }