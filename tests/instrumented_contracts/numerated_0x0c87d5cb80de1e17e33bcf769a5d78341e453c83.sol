1 // File: Lost Illusion.sol
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
248 
249 pragma solidity ^0.8.1;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      *
272      * [IMPORTANT]
273      * ====
274      * You shouldn't rely on `isContract` to protect against flash loan attacks!
275      *
276      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
277      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
278      * constructor.
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize/address.code.length, which returns 0
283         // for contracts in construction, since the code is only stored at the end
284         // of the constructor execution.
285 
286         return account.code.length > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         (bool success, ) = recipient.call{value: amount}("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain `call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         require(isContract(target), "Address: call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.call{value: value}(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
393         return functionStaticCall(target, data, "Address: low-level static call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal view returns (bytes memory) {
407         require(isContract(target), "Address: static call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.staticcall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.delegatecall(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
442      * revert reason using the provided one.
443      *
444      * _Available since v4.3._
445      */
446     function verifyCallResult(
447         bool success,
448         bytes memory returndata,
449         string memory errorMessage
450     ) internal pure returns (bytes memory) {
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @title ERC721 token receiver interface
478  * @dev Interface for any contract that wants to support safeTransfers
479  * from ERC721 asset contracts.
480  */
481 interface IERC721Receiver {
482     /**
483      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
484      * by `operator` from `from`, this function is called.
485      *
486      * It must return its Solidity selector to confirm the token transfer.
487      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
488      *
489      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
490      */
491     function onERC721Received(
492         address operator,
493         address from,
494         uint256 tokenId,
495         bytes calldata data
496     ) external returns (bytes4);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC165 standard, as defined in the
508  * https://eips.ethereum.org/EIPS/eip-165[EIP].
509  *
510  * Implementers can declare support of contract interfaces, which can then be
511  * queried by others ({ERC165Checker}).
512  *
513  * For an implementation, see {ERC165}.
514  */
515 interface IERC165 {
516     /**
517      * @dev Returns true if this contract implements the interface defined by
518      * `interfaceId`. See the corresponding
519      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
520      * to learn more about how these ids are created.
521      *
522      * This function call must use less than 30 000 gas.
523      */
524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Required interface of an ERC721 compliant contract.
568  */
569 interface IERC721 is IERC165 {
570     /**
571      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
577      */
578     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
582      */
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     /**
586      * @dev Returns the number of tokens in ``owner``'s account.
587      */
588     function balanceOf(address owner) external view returns (uint256 balance);
589 
590     /**
591      * @dev Returns the owner of the `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function ownerOf(uint256 tokenId) external view returns (address owner);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
601      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers `tokenId` token from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
644      *
645      * Requirements:
646      *
647      * - The caller must own the token or be an approved operator.
648      * - `tokenId` must exist.
649      *
650      * Emits an {Approval} event.
651      */
652     function approve(address to, uint256 tokenId) external;
653 
654     /**
655      * @dev Returns the account approved for `tokenId` token.
656      *
657      * Requirements:
658      *
659      * - `tokenId` must exist.
660      */
661     function getApproved(uint256 tokenId) external view returns (address operator);
662 
663     /**
664      * @dev Approve or remove `operator` as an operator for the caller.
665      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
666      *
667      * Requirements:
668      *
669      * - The `operator` cannot be the caller.
670      *
671      * Emits an {ApprovalForAll} event.
672      */
673     function setApprovalForAll(address operator, bool _approved) external;
674 
675     /**
676      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
677      *
678      * See {setApprovalForAll}
679      */
680     function isApprovedForAll(address owner, address operator) external view returns (bool);
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must exist and be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692      *
693      * Emits a {Transfer} event.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId,
699         bytes calldata data
700     ) external;
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Metadata is IERC721 {
716     /**
717      * @dev Returns the token collection name.
718      */
719     function name() external view returns (string memory);
720 
721     /**
722      * @dev Returns the token collection symbol.
723      */
724     function symbol() external view returns (string memory);
725 
726     /**
727      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
728      */
729     function tokenURI(uint256 tokenId) external view returns (string memory);
730 }
731 
732 // File: contracts/ERC721A.sol
733 
734 
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.4;
738 
739 
740 
741 
742 
743 
744 
745 
746 error ApprovalCallerNotOwnerNorApproved();
747 error ApprovalQueryForNonexistentToken();
748 error ApproveToCaller();
749 error ApprovalToCurrentOwner();
750 error BalanceQueryForZeroAddress();
751 error MintToZeroAddress();
752 error MintZeroQuantity();
753 error OwnerQueryForNonexistentToken();
754 error TransferCallerNotOwnerNorApproved();
755 error TransferFromIncorrectOwner();
756 error TransferToNonERC721ReceiverImplementer();
757 error TransferToZeroAddress();
758 error URIQueryForNonexistentToken();
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
765  *
766  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
767  *
768  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
769  */
770 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
771     using Address for address;
772     using Strings for uint256;
773 
774     // Compiler will pack this into a single 256bit word.
775     struct TokenOwnership {
776         // The address of the owner.
777         address addr;
778         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
779         uint64 startTimestamp;
780         // Whether the token has been burned.
781         bool burned;
782     }
783 
784     // Compiler will pack this into a single 256bit word.
785     struct AddressData {
786         // Realistically, 2**64-1 is more than enough.
787         uint64 balance;
788         // Keeps track of mint count with minimal overhead for tokenomics.
789         uint64 numberMinted;
790         // Keeps track of burn count with minimal overhead for tokenomics.
791         uint64 numberBurned;
792         // For miscellaneous variable(s) pertaining to the address
793         // (e.g. number of whitelist mint slots used).
794         // If there are multiple variables, please pack them into a uint64.
795         uint64 aux;
796     }
797 
798     // The tokenId of the next token to be minted.
799     uint256 internal _currentIndex;
800 
801     // The number of tokens burned.
802     uint256 internal _burnCounter;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
812     mapping(uint256 => TokenOwnership) internal _ownerships;
813 
814     // Mapping owner address to address data
815     mapping(address => AddressData) private _addressData;
816 
817     // Mapping from token ID to approved address
818     mapping(uint256 => address) private _tokenApprovals;
819 
820     // Mapping from owner to operator approvals
821     mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826         _currentIndex = _startTokenId();
827     }
828 
829     /**
830      * To change the starting tokenId, please override this function.
831      */
832     function _startTokenId() internal view virtual returns (uint256) {
833         return 1;
834     }
835 
836     /**
837      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
838      */
839     function totalSupply() public view returns (uint256) {
840         // Counter underflow is impossible as _burnCounter cannot be incremented
841         // more than _currentIndex - _startTokenId() times
842         unchecked {
843             return _currentIndex - _burnCounter - _startTokenId();
844         }
845     }
846 
847     /**
848      * Returns the total amount of tokens minted in the contract.
849      */
850     function _totalMinted() internal view returns (uint256) {
851         // Counter underflow is impossible as _currentIndex does not decrement,
852         // and it is initialized to _startTokenId()
853         unchecked {
854             return _currentIndex - _startTokenId();
855         }
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC721).interfaceId ||
864             interfaceId == type(IERC721Metadata).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871     function balanceOf(address owner) public view override returns (uint256) {
872         if (owner == address(0)) revert BalanceQueryForZeroAddress();
873         return uint256(_addressData[owner].balance);
874     }
875 
876     /**
877      * Returns the number of tokens minted by `owner`.
878      */
879     function _numberMinted(address owner) internal view returns (uint256) {
880         return uint256(_addressData[owner].numberMinted);
881     }
882 
883     /**
884      * Returns the number of tokens burned by or on behalf of `owner`.
885      */
886     function _numberBurned(address owner) internal view returns (uint256) {
887         return uint256(_addressData[owner].numberBurned);
888     }
889 
890     /**
891      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      */
893     function _getAux(address owner) internal view returns (uint64) {
894         return _addressData[owner].aux;
895     }
896 
897     /**
898      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      * If there are multiple variables, please pack them into a uint64.
900      */
901     function _setAux(address owner, uint64 aux) internal {
902         _addressData[owner].aux = aux;
903     }
904 
905     /**
906      * Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
908      */
909     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
910         uint256 curr = tokenId;
911 
912         unchecked {
913             if (_startTokenId() <= curr && curr < _currentIndex) {
914                 TokenOwnership memory ownership = _ownerships[curr];
915                 if (!ownership.burned) {
916                     if (ownership.addr != address(0)) {
917                         return ownership;
918                     }
919                     // Invariant:
920                     // There will always be an ownership that has an address and is not burned
921                     // before an ownership that does not have an address and is not burned.
922                     // Hence, curr will not underflow.
923                     while (true) {
924                         curr--;
925                         ownership = _ownerships[curr];
926                         if (ownership.addr != address(0)) {
927                             return ownership;
928                         }
929                     }
930                 }
931             }
932         }
933         revert OwnerQueryForNonexistentToken();
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view override returns (address) {
940         return _ownershipOf(tokenId).addr;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-name}.
945      */
946     function name() public view virtual override returns (string memory) {
947         return _name;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-symbol}.
952      */
953     function symbol() public view virtual override returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-tokenURI}.
959      */
960     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
961         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
962 
963         string memory baseURI = _baseURI();
964         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overriden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return '';
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = ERC721A.ownerOf(tokenId);
981         if (to == owner) revert ApprovalToCurrentOwner();
982 
983         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
984             revert ApprovalCallerNotOwnerNorApproved();
985         }
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public virtual override {
1003         if (operator == _msgSender()) revert ApproveToCaller();
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, '');
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1049             revert TransferToNonERC721ReceiverImplementer();
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted (`_mint`),
1059      */
1060     function _exists(uint256 tokenId) internal view returns (bool) {
1061         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1062     }
1063 
1064     /**
1065      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1066      */
1067     function _safeMint(address to, uint256 quantity) internal {
1068         _safeMint(to, quantity, '');
1069     }
1070 
1071     /**
1072      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - If `to` refers to a smart contract, it must implement 
1077      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data
1086     ) internal {
1087         uint256 startTokenId = _currentIndex;
1088         if (to == address(0)) revert MintToZeroAddress();
1089         if (quantity == 0) revert MintZeroQuantity();
1090 
1091         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1092 
1093         // Overflows are incredibly unrealistic.
1094         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1095         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1096         unchecked {
1097             _addressData[to].balance += uint64(quantity);
1098             _addressData[to].numberMinted += uint64(quantity);
1099 
1100             _ownerships[startTokenId].addr = to;
1101             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1102 
1103             uint256 updatedIndex = startTokenId;
1104             uint256 end = updatedIndex + quantity;
1105 
1106             if (to.isContract()) {
1107                 do {
1108                     emit Transfer(address(0), to, updatedIndex);
1109                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1110                         revert TransferToNonERC721ReceiverImplementer();
1111                     }
1112                 } while (updatedIndex != end);
1113                 // Reentrancy protection
1114                 if (_currentIndex != startTokenId) revert();
1115             } else {
1116                 do {
1117                     emit Transfer(address(0), to, updatedIndex++);
1118                 } while (updatedIndex != end);
1119             }
1120             _currentIndex = updatedIndex;
1121         }
1122         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1123     }
1124 
1125     /**
1126      * @dev Mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _mint(address to, uint256 quantity) internal {
1136         uint256 startTokenId = _currentIndex;
1137         if (to == address(0)) revert MintToZeroAddress();
1138         if (quantity == 0) revert MintZeroQuantity();
1139 
1140         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1141 
1142         // Overflows are incredibly unrealistic.
1143         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1144         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1145         unchecked {
1146             _addressData[to].balance += uint64(quantity);
1147             _addressData[to].numberMinted += uint64(quantity);
1148 
1149             _ownerships[startTokenId].addr = to;
1150             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1151 
1152             uint256 updatedIndex = startTokenId;
1153             uint256 end = updatedIndex + quantity;
1154 
1155             do {
1156                 emit Transfer(address(0), to, updatedIndex++);
1157             } while (updatedIndex != end);
1158 
1159             _currentIndex = updatedIndex;
1160         }
1161         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must be owned by `from`.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _transfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) private {
1179         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1180 
1181         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1182 
1183         bool isApprovedOrOwner = (_msgSender() == from ||
1184             isApprovedForAll(from, _msgSender()) ||
1185             getApproved(tokenId) == _msgSender());
1186 
1187         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1188         if (to == address(0)) revert TransferToZeroAddress();
1189 
1190         _beforeTokenTransfers(from, to, tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, from);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             _addressData[from].balance -= 1;
1200             _addressData[to].balance += 1;
1201 
1202             TokenOwnership storage currSlot = _ownerships[tokenId];
1203             currSlot.addr = to;
1204             currSlot.startTimestamp = uint64(block.timestamp);
1205 
1206             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1207             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1208             uint256 nextTokenId = tokenId + 1;
1209             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1210             if (nextSlot.addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId != _currentIndex) {
1214                     nextSlot.addr = from;
1215                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(from, to, tokenId);
1221         _afterTokenTransfers(from, to, tokenId, 1);
1222     }
1223 
1224     /**
1225      * @dev Equivalent to `_burn(tokenId, false)`.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         _burn(tokenId, false);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1242         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1243 
1244         address from = prevOwnership.addr;
1245 
1246         if (approvalCheck) {
1247             bool isApprovedOrOwner = (_msgSender() == from ||
1248                 isApprovedForAll(from, _msgSender()) ||
1249                 getApproved(tokenId) == _msgSender());
1250 
1251             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1252         }
1253 
1254         _beforeTokenTransfers(from, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner
1257         _approve(address(0), tokenId, from);
1258 
1259         // Underflow of the sender's balance is impossible because we check for
1260         // ownership above and the recipient's balance can't realistically overflow.
1261         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1262         unchecked {
1263             AddressData storage addressData = _addressData[from];
1264             addressData.balance -= 1;
1265             addressData.numberBurned += 1;
1266 
1267             // Keep track of who burned the token, and the timestamp of burning.
1268             TokenOwnership storage currSlot = _ownerships[tokenId];
1269             currSlot.addr = from;
1270             currSlot.startTimestamp = uint64(block.timestamp);
1271             currSlot.burned = true;
1272 
1273             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1274             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1275             uint256 nextTokenId = tokenId + 1;
1276             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1277             if (nextSlot.addr == address(0)) {
1278                 // This will suffice for checking _exists(nextTokenId),
1279                 // as a burned slot cannot contain the zero address.
1280                 if (nextTokenId != _currentIndex) {
1281                     nextSlot.addr = from;
1282                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(from, address(0), tokenId);
1288         _afterTokenTransfers(from, address(0), tokenId, 1);
1289 
1290         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1291         unchecked {
1292             _burnCounter++;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Approve `to` to operate on `tokenId`
1298      *
1299      * Emits a {Approval} event.
1300      */
1301     function _approve(
1302         address to,
1303         uint256 tokenId,
1304         address owner
1305     ) private {
1306         _tokenApprovals[tokenId] = to;
1307         emit Approval(owner, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkContractOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1326             return retval == IERC721Receiver(to).onERC721Received.selector;
1327         } catch (bytes memory reason) {
1328             if (reason.length == 0) {
1329                 revert TransferToNonERC721ReceiverImplementer();
1330             } else {
1331                 assembly {
1332                     revert(add(32, reason), mload(reason))
1333                 }
1334             }
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * startTokenId - the first token id to be transferred
1343      * quantity - the amount to be transferred
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1362      * minting.
1363      * And also called after one token has been burned.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 }
1383 // File: contracts/TheGoblinz.sol
1384 
1385 
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 
1391 
1392 
1393 contract LostIllusion is ERC721A, Ownable, ReentrancyGuard {
1394   using Address for address;
1395   using Strings for uint;
1396 
1397 
1398   string  public  baseTokenURI = "ipfs://QmZUhSi2PF4wYcn3LnKVce1Jkz8k66fgevAwYmq7ApY6aE/";
1399   uint256  public  maxSupply = 999;
1400   uint256 public  MAX_MINTS_PER_TX = 5;
1401   uint256 public  PUBLIC_SALE_PRICE = 0.004 ether;
1402   uint256 public  NUM_FREE_MINTS = 500;
1403   uint256 public  MAX_FREE_PER_WALLET = 1;
1404   uint256 public freeNFTAlreadyMinted = 0;
1405   bool public isPublicSaleActive = false;
1406 
1407   constructor(
1408 
1409   ) ERC721A("Lost Illusion", "Illusion") {
1410 
1411   }
1412 
1413 
1414   function mint(uint256 numberOfTokens)
1415       external
1416       payable
1417   {
1418     require(isPublicSaleActive, "Public sale is not open");
1419     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1420 
1421     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1422         require(
1423             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1424             "Incorrect ETH value sent"
1425         );
1426     } else {
1427         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1428         require(
1429             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1430             "Incorrect ETH value sent"
1431         );
1432         require(
1433             numberOfTokens <= MAX_MINTS_PER_TX,
1434             "Max mints per transaction exceeded"
1435         );
1436         } else {
1437             require(
1438                 numberOfTokens <= MAX_FREE_PER_WALLET,
1439                 "Max mints per transaction exceeded"
1440             );
1441             freeNFTAlreadyMinted += numberOfTokens;
1442         }
1443     }
1444     _safeMint(msg.sender, numberOfTokens);
1445   }
1446 
1447   function setBaseURI(string memory baseURI)
1448     public
1449     onlyOwner
1450   {
1451     baseTokenURI = baseURI;
1452   }
1453 
1454   function treasuryMint(uint quantity)
1455     public
1456     onlyOwner
1457   {
1458     require(
1459       quantity > 0,
1460       "Invalid mint amount"
1461     );
1462     require(
1463       totalSupply() + quantity <= maxSupply,
1464       "Maximum supply exceeded"
1465     );
1466     _safeMint(msg.sender, quantity);
1467   }
1468 
1469   function withdraw()
1470     public
1471     onlyOwner
1472     nonReentrant
1473   {
1474     Address.sendValue(payable(msg.sender), address(this).balance);
1475   }
1476 
1477   function tokenURI(uint _tokenId)
1478     public
1479     view
1480     virtual
1481     override
1482     returns (string memory)
1483   {
1484     require(
1485       _exists(_tokenId),
1486       "ERC721Metadata: URI query for nonexistent token"
1487     );
1488     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1489   }
1490 
1491   function _baseURI()
1492     internal
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497   {
1498     return baseTokenURI;
1499   }
1500 
1501   function setIsPublicSaleActive(bool _isPublicSaleActive)
1502       external
1503       onlyOwner
1504   {
1505       isPublicSaleActive = _isPublicSaleActive;
1506   }
1507 
1508   function setNumFreeMints(uint256 _numfreemints)
1509       external
1510       onlyOwner
1511   {
1512       NUM_FREE_MINTS = _numfreemints;
1513   }
1514 
1515   function setSalePrice(uint256 _price)
1516       external
1517       onlyOwner
1518   {
1519       PUBLIC_SALE_PRICE = _price;
1520   }
1521 
1522   function setMaxLimitPerTransaction(uint256 _limit)
1523       external
1524       onlyOwner
1525   {
1526       MAX_MINTS_PER_TX = _limit;
1527   }
1528 
1529   function setFreeLimitPerWallet(uint256 _limit)
1530       external
1531       onlyOwner
1532   {
1533       MAX_FREE_PER_WALLET = _limit;
1534   }
1535 }