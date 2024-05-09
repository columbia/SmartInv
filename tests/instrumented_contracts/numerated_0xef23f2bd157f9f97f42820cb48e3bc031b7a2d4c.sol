1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Strings.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
81      */
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
106      */
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
122      */
123     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
124         bytes memory buffer = new bytes(2 * length + 2);
125         buffer[0] = "0";
126         buffer[1] = "x";
127         for (uint256 i = 2 * length + 1; i > 1; --i) {
128             buffer[i] = _HEX_SYMBOLS[value & 0xf];
129             value >>= 4;
130         }
131         require(value == 0, "Strings: hex length insufficient");
132         return string(buffer);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/access/Ownable.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Returns the address of the current owner.
197      */
198     function owner() public view virtual returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
245 
246 pragma solidity ^0.8.1;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on `isContract` to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * `interfaceId`. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Required interface of an ERC721 compliant contract.
565  */
566 interface IERC721 is IERC165 {
567     /**
568      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
569      */
570     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
574      */
575     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
579      */
580     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
581 
582     /**
583      * @dev Returns the number of tokens in ``owner``'s account.
584      */
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     /**
588      * @dev Returns the owner of the `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function ownerOf(uint256 tokenId) external view returns (address owner);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers `tokenId` token from `from` to `to`.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - `tokenId` must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Returns the account approved for `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function getApproved(uint256 tokenId) external view returns (address operator);
659 
660     /**
661      * @dev Approve or remove `operator` as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The `operator` cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must exist and be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes calldata data
697     ) external;
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Metadata is IERC721 {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 // File: contracts/ERC721A.sol
730 
731 
732 // Creator: Chiru Labs
733 
734 pragma solidity ^0.8.4;
735 
736 
737 
738 
739 
740 
741 
742 
743 error ApprovalCallerNotOwnerNorApproved();
744 error ApprovalQueryForNonexistentToken();
745 error ApproveToCaller();
746 error ApprovalToCurrentOwner();
747 error BalanceQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerQueryForNonexistentToken();
751 error TransferCallerNotOwnerNorApproved();
752 error TransferFromIncorrectOwner();
753 error TransferToNonERC721ReceiverImplementer();
754 error TransferToZeroAddress();
755 error URIQueryForNonexistentToken();
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  *
763  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
764  *
765  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
766  */
767 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
768     using Address for address;
769     using Strings for uint256;
770 
771     // Compiler will pack this into a single 256bit word.
772     struct TokenOwnership {
773         // The address of the owner.
774         address addr;
775         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
776         uint64 startTimestamp;
777         // Whether the token has been burned.
778         bool burned;
779     }
780 
781     // Compiler will pack this into a single 256bit word.
782     struct AddressData {
783         // Realistically, 2**64-1 is more than enough.
784         uint64 balance;
785         // Keeps track of mint count with minimal overhead for tokenomics.
786         uint64 numberMinted;
787         // Keeps track of burn count with minimal overhead for tokenomics.
788         uint64 numberBurned;
789         // For miscellaneous variable(s) pertaining to the address
790         // (e.g. number of whitelist mint slots used).
791         // If there are multiple variables, please pack them into a uint64.
792         uint64 aux;
793     }
794 
795     // The tokenId of the next token to be minted.
796     uint256 internal _currentIndex;
797 
798     // The number of tokens burned.
799     uint256 internal _burnCounter;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
809     mapping(uint256 => TokenOwnership) internal _ownerships;
810 
811     // Mapping owner address to address data
812     mapping(address => AddressData) private _addressData;
813 
814     // Mapping from token ID to approved address
815     mapping(uint256 => address) private _tokenApprovals;
816 
817     // Mapping from owner to operator approvals
818     mapping(address => mapping(address => bool)) private _operatorApprovals;
819 
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823         _currentIndex = _startTokenId();
824     }
825 
826     /**
827      * To change the starting tokenId, please override this function.
828      */
829     function _startTokenId() internal view virtual returns (uint256) {
830         return 1;
831     }
832 
833     /**
834      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
835      */
836     function totalSupply() public view returns (uint256) {
837         // Counter underflow is impossible as _burnCounter cannot be incremented
838         // more than _currentIndex - _startTokenId() times
839         unchecked {
840             return _currentIndex - _burnCounter - _startTokenId();
841         }
842     }
843 
844     /**
845      * Returns the total amount of tokens minted in the contract.
846      */
847     function _totalMinted() internal view returns (uint256) {
848         // Counter underflow is impossible as _currentIndex does not decrement,
849         // and it is initialized to _startTokenId()
850         unchecked {
851             return _currentIndex - _startTokenId();
852         }
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return
860             interfaceId == type(IERC721).interfaceId ||
861             interfaceId == type(IERC721Metadata).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return uint256(_addressData[owner].balance);
871     }
872 
873     /**
874      * Returns the number of tokens minted by `owner`.
875      */
876     function _numberMinted(address owner) internal view returns (uint256) {
877         return uint256(_addressData[owner].numberMinted);
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         return uint256(_addressData[owner].numberBurned);
885     }
886 
887     /**
888      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
889      */
890     function _getAux(address owner) internal view returns (uint64) {
891         return _addressData[owner].aux;
892     }
893 
894     /**
895      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
896      * If there are multiple variables, please pack them into a uint64.
897      */
898     function _setAux(address owner, uint64 aux) internal {
899         _addressData[owner].aux = aux;
900     }
901 
902     /**
903      * Gas spent here starts off proportional to the maximum mint batch size.
904      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
905      */
906     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
907         uint256 curr = tokenId;
908 
909         unchecked {
910             if (_startTokenId() <= curr && curr < _currentIndex) {
911                 TokenOwnership memory ownership = _ownerships[curr];
912                 if (!ownership.burned) {
913                     if (ownership.addr != address(0)) {
914                         return ownership;
915                     }
916                     // Invariant:
917                     // There will always be an ownership that has an address and is not burned
918                     // before an ownership that does not have an address and is not burned.
919                     // Hence, curr will not underflow.
920                     while (true) {
921                         curr--;
922                         ownership = _ownerships[curr];
923                         if (ownership.addr != address(0)) {
924                             return ownership;
925                         }
926                     }
927                 }
928             }
929         }
930         revert OwnerQueryForNonexistentToken();
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view override returns (address) {
937         return _ownershipOf(tokenId).addr;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return '';
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public override {
977         address owner = ERC721A.ownerOf(tokenId);
978         if (to == owner) revert ApprovalToCurrentOwner();
979 
980         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
981             revert ApprovalCallerNotOwnerNorApproved();
982         }
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public virtual override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046             revert TransferToNonERC721ReceiverImplementer();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1059     }
1060 
1061     /**
1062      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1063      */
1064     function _safeMint(address to, uint256 quantity) internal {
1065         _safeMint(to, quantity, '');
1066     }
1067 
1068     /**
1069      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - If `to` refers to a smart contract, it must implement 
1074      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         uint256 startTokenId = _currentIndex;
1085         if (to == address(0)) revert MintToZeroAddress();
1086         if (quantity == 0) revert MintZeroQuantity();
1087 
1088         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1089 
1090         // Overflows are incredibly unrealistic.
1091         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1092         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1093         unchecked {
1094             _addressData[to].balance += uint64(quantity);
1095             _addressData[to].numberMinted += uint64(quantity);
1096 
1097             _ownerships[startTokenId].addr = to;
1098             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1099 
1100             uint256 updatedIndex = startTokenId;
1101             uint256 end = updatedIndex + quantity;
1102 
1103             if (to.isContract()) {
1104                 do {
1105                     emit Transfer(address(0), to, updatedIndex);
1106                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1107                         revert TransferToNonERC721ReceiverImplementer();
1108                     }
1109                 } while (updatedIndex != end);
1110                 // Reentrancy protection
1111                 if (_currentIndex != startTokenId) revert();
1112             } else {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex++);
1115                 } while (updatedIndex != end);
1116             }
1117             _currentIndex = updatedIndex;
1118         }
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _mint(address to, uint256 quantity) internal {
1133         uint256 startTokenId = _currentIndex;
1134         if (to == address(0)) revert MintToZeroAddress();
1135         if (quantity == 0) revert MintZeroQuantity();
1136 
1137         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1138 
1139         // Overflows are incredibly unrealistic.
1140         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1141         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1142         unchecked {
1143             _addressData[to].balance += uint64(quantity);
1144             _addressData[to].numberMinted += uint64(quantity);
1145 
1146             _ownerships[startTokenId].addr = to;
1147             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1148 
1149             uint256 updatedIndex = startTokenId;
1150             uint256 end = updatedIndex + quantity;
1151 
1152             do {
1153                 emit Transfer(address(0), to, updatedIndex++);
1154             } while (updatedIndex != end);
1155 
1156             _currentIndex = updatedIndex;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1177 
1178         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1179 
1180         bool isApprovedOrOwner = (_msgSender() == from ||
1181             isApprovedForAll(from, _msgSender()) ||
1182             getApproved(tokenId) == _msgSender());
1183 
1184         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         if (to == address(0)) revert TransferToZeroAddress();
1186 
1187         _beforeTokenTransfers(from, to, tokenId, 1);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId, from);
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195         unchecked {
1196             _addressData[from].balance -= 1;
1197             _addressData[to].balance += 1;
1198 
1199             TokenOwnership storage currSlot = _ownerships[tokenId];
1200             currSlot.addr = to;
1201             currSlot.startTimestamp = uint64(block.timestamp);
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1204             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205             uint256 nextTokenId = tokenId + 1;
1206             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1207             if (nextSlot.addr == address(0)) {
1208                 // This will suffice for checking _exists(nextTokenId),
1209                 // as a burned slot cannot contain the zero address.
1210                 if (nextTokenId != _currentIndex) {
1211                     nextSlot.addr = from;
1212                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1213                 }
1214             }
1215         }
1216 
1217         emit Transfer(from, to, tokenId);
1218         _afterTokenTransfers(from, to, tokenId, 1);
1219     }
1220 
1221     /**
1222      * @dev Equivalent to `_burn(tokenId, false)`.
1223      */
1224     function _burn(uint256 tokenId) internal virtual {
1225         _burn(tokenId, false);
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1239         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1240 
1241         address from = prevOwnership.addr;
1242 
1243         if (approvalCheck) {
1244             bool isApprovedOrOwner = (_msgSender() == from ||
1245                 isApprovedForAll(from, _msgSender()) ||
1246                 getApproved(tokenId) == _msgSender());
1247 
1248             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1249         }
1250 
1251         _beforeTokenTransfers(from, address(0), tokenId, 1);
1252 
1253         // Clear approvals from the previous owner
1254         _approve(address(0), tokenId, from);
1255 
1256         // Underflow of the sender's balance is impossible because we check for
1257         // ownership above and the recipient's balance can't realistically overflow.
1258         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1259         unchecked {
1260             AddressData storage addressData = _addressData[from];
1261             addressData.balance -= 1;
1262             addressData.numberBurned += 1;
1263 
1264             // Keep track of who burned the token, and the timestamp of burning.
1265             TokenOwnership storage currSlot = _ownerships[tokenId];
1266             currSlot.addr = from;
1267             currSlot.startTimestamp = uint64(block.timestamp);
1268             currSlot.burned = true;
1269 
1270             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1271             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1272             uint256 nextTokenId = tokenId + 1;
1273             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1274             if (nextSlot.addr == address(0)) {
1275                 // This will suffice for checking _exists(nextTokenId),
1276                 // as a burned slot cannot contain the zero address.
1277                 if (nextTokenId != _currentIndex) {
1278                     nextSlot.addr = from;
1279                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, address(0), tokenId);
1285         _afterTokenTransfers(from, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Approve `to` to operate on `tokenId`
1295      *
1296      * Emits a {Approval} event.
1297      */
1298     function _approve(
1299         address to,
1300         uint256 tokenId,
1301         address owner
1302     ) private {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(owner, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1309      *
1310      * @param from address representing the previous owner of the given token ID
1311      * @param to target address that will receive the tokens
1312      * @param tokenId uint256 ID of the token to be transferred
1313      * @param _data bytes optional data to send along with the call
1314      * @return bool whether the call correctly returned the expected magic value
1315      */
1316     function _checkContractOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323             return retval == IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1337      * And also called before burning one token.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, `tokenId` will be burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _beforeTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 
1357     /**
1358      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1359      * minting.
1360      * And also called after one token has been burned.
1361      *
1362      * startTokenId - the first token id to be transferred
1363      * quantity - the amount to be transferred
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` has been minted for `to`.
1370      * - When `to` is zero, `tokenId` has been burned by `from`.
1371      * - `from` and `to` are never both zero.
1372      */
1373     function _afterTokenTransfers(
1374         address from,
1375         address to,
1376         uint256 startTokenId,
1377         uint256 quantity
1378     ) internal virtual {}
1379 }
1380 
1381 
1382 
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 contract TaggersNFT is ERC721A, Ownable, ReentrancyGuard {
1387   using Address for address;
1388   using Strings for uint;
1389 
1390 
1391   string public baseURI = "ipfs://bafybeigm62wa2x26clgmdc2avjd3vaptlr6ipbwwjzzktn75k7puxbzvoa/";
1392   string public hiddenbaseURI = "ipfs://bafkreia47b3fri2tltqjwbbuw5zzecanbt5gglxezlywlttpcib6uuybdm";
1393   uint256 public maxSupply = 5000;
1394   uint256 public MAX_MINTS_PER_WALLET = 5;
1395   uint256 public PUBLIC_SALE_PRICE = 0.06 ether;
1396   uint256 public MAX_FREE_PER_WALLET = 2;
1397   bool public isPublicSaleActive = false;
1398   bool revealed = false;
1399 
1400   constructor(
1401 
1402   ) ERC721A("NFT Taggers", "Taggers") {
1403       _safeMint(msg.sender, 200);
1404   }
1405 
1406 
1407   function mint(uint256 numberOfTokens)
1408       external
1409       payable
1410   {
1411     require(isPublicSaleActive, "Public sale is not open");
1412     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1413     require(balanceOf(msg.sender) + numberOfTokens <= MAX_MINTS_PER_WALLET, "Max mints per wallet exceeded");
1414 
1415     uint overFree;
1416     if(balanceOf(msg.sender) == 0 && numberOfTokens == 1){
1417         overFree = 0;
1418     }
1419     if(balanceOf(msg.sender) == 0 && numberOfTokens == 2){
1420         overFree = 0;
1421     }
1422     if(balanceOf(msg.sender) == 0 && numberOfTokens > 2){
1423         overFree = numberOfTokens - 2;
1424     }
1425     if(balanceOf(msg.sender) == 1 && numberOfTokens == 1){
1426         overFree = 0;
1427     }
1428     if(balanceOf(msg.sender) == 1 && numberOfTokens > 1){
1429         overFree = numberOfTokens - 1;
1430     }
1431     if(balanceOf(msg.sender) > 1 && numberOfTokens >= 1){
1432         overFree = numberOfTokens;
1433     }
1434 
1435 
1436         if (overFree == 0) {
1437         require(
1438             msg.value >= 0,
1439             "Incorrect ETH value sent"
1440         );
1441     
1442         } else {
1443             require(msg.value >= (overFree * PUBLIC_SALE_PRICE), "Incorrect ETH value sent");
1444         }
1445     
1446     _safeMint(msg.sender, numberOfTokens);
1447   }
1448 
1449   function setBaseURI(string memory _newBaseURI)
1450     public
1451     onlyOwner
1452   {
1453     baseURI = _newBaseURI;
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
1490     if(revealed){
1491     return bytes(baseURI).length > 0
1492         ? string(abi.encodePacked(baseURI, (_tokenId).toString(), ".json"))
1493         : "";
1494     }
1495     else {
1496         return bytes(baseURI).length > 0
1497         ? string(abi.encodePacked(hiddenbaseURI))
1498         : "";
1499     }
1500     
1501   }
1502 
1503   function _baseURI()
1504     internal
1505     view
1506     virtual
1507     override
1508     returns (string memory)
1509   {
1510     return baseURI;
1511   }
1512 
1513   function setIsPublicSaleActive(bool _isPublicSaleActive)
1514       external
1515       onlyOwner
1516   {
1517       isPublicSaleActive = _isPublicSaleActive;
1518   }
1519 
1520   function setReveal(bool _reveal)
1521       external
1522       onlyOwner
1523   {
1524       revealed = _reveal;
1525   }
1526 
1527 
1528   function setSalePrice(uint256 _price)
1529       external
1530       onlyOwner
1531   {
1532       PUBLIC_SALE_PRICE = _price;
1533   }
1534 
1535   function setMaxLimitPerWALLET(uint256 _limit)
1536       external
1537       onlyOwner
1538   {
1539       MAX_MINTS_PER_WALLET = _limit;
1540   }
1541 }