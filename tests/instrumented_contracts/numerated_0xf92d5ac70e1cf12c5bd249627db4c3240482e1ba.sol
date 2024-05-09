1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
246 
247 pragma solidity ^0.8.1;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      *
270      * [IMPORTANT]
271      * ====
272      * You shouldn't rely on `isContract` to protect against flash loan attacks!
273      *
274      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
275      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
276      * constructor.
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize/address.code.length, which returns 0
281         // for contracts in construction, since the code is only stored at the end
282         // of the constructor execution.
283 
284         return account.code.length > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Interface of the ERC165 standard, as defined in the
506  * https://eips.ethereum.org/EIPS/eip-165[EIP].
507  *
508  * Implementers can declare support of contract interfaces, which can then be
509  * queried by others ({ERC165Checker}).
510  *
511  * For an implementation, see {ERC165}.
512  */
513 interface IERC165 {
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30 000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         return interfaceId == type(IERC165).interfaceId;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Required interface of an ERC721 compliant contract.
566  */
567 interface IERC721 is IERC165 {
568     /**
569      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
575      */
576     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
582 
583     /**
584      * @dev Returns the number of tokens in ``owner``'s account.
585      */
586     function balanceOf(address owner) external view returns (uint256 balance);
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) external view returns (address owner);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
619      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Transfers `tokenId` token from `from` to `to`.
639      *
640      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      *
649      * Emits a {Transfer} event.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external;
656 
657     /**
658      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
659      * The approval is cleared when the token is transferred.
660      *
661      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
662      *
663      * Requirements:
664      *
665      * - The caller must own the token or be an approved operator.
666      * - `tokenId` must exist.
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address to, uint256 tokenId) external;
671 
672     /**
673      * @dev Approve or remove `operator` as an operator for the caller.
674      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
675      *
676      * Requirements:
677      *
678      * - The `operator` cannot be the caller.
679      *
680      * Emits an {ApprovalForAll} event.
681      */
682     function setApprovalForAll(address operator, bool _approved) external;
683 
684     /**
685      * @dev Returns the account approved for `tokenId` token.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function getApproved(uint256 tokenId) external view returns (address operator);
692 
693     /**
694      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
695      *
696      * See {setApprovalForAll}
697      */
698     function isApprovedForAll(address owner, address operator) external view returns (bool);
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Metadata is IERC721 {
714     /**
715      * @dev Returns the token collection name.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the token collection symbol.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
726      */
727     function tokenURI(uint256 tokenId) external view returns (string memory);
728 }
729 
730 // File: erc721a/contracts/IERC721A.sol
731 
732 
733 // ERC721A Contracts v3.3.0
734 // Creator: Chiru Labs
735 
736 pragma solidity ^0.8.4;
737 
738 
739 
740 /**
741  * @dev Interface of an ERC721A compliant contract.
742  */
743 interface IERC721A is IERC721, IERC721Metadata {
744     /**
745      * The caller must own the token or be an approved operator.
746      */
747     error ApprovalCallerNotOwnerNorApproved();
748 
749     /**
750      * The token does not exist.
751      */
752     error ApprovalQueryForNonexistentToken();
753 
754     /**
755      * The caller cannot approve to their own address.
756      */
757     error ApproveToCaller();
758 
759     /**
760      * The caller cannot approve to the current owner.
761      */
762     error ApprovalToCurrentOwner();
763 
764     /**
765      * Cannot query the balance for the zero address.
766      */
767     error BalanceQueryForZeroAddress();
768 
769     /**
770      * Cannot mint to the zero address.
771      */
772     error MintToZeroAddress();
773 
774     /**
775      * The quantity of tokens minted must be more than zero.
776      */
777     error MintZeroQuantity();
778 
779     /**
780      * The token does not exist.
781      */
782     error OwnerQueryForNonexistentToken();
783 
784     /**
785      * The caller must own the token or be an approved operator.
786      */
787     error TransferCallerNotOwnerNorApproved();
788 
789     /**
790      * The token must be owned by `from`.
791      */
792     error TransferFromIncorrectOwner();
793 
794     /**
795      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
796      */
797     error TransferToNonERC721ReceiverImplementer();
798 
799     /**
800      * Cannot transfer to the zero address.
801      */
802     error TransferToZeroAddress();
803 
804     /**
805      * The token does not exist.
806      */
807     error URIQueryForNonexistentToken();
808 
809     // Compiler will pack this into a single 256bit word.
810     struct TokenOwnership {
811         // The address of the owner.
812         address addr;
813         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
814         uint64 startTimestamp;
815         // Whether the token has been burned.
816         bool burned;
817     }
818 
819     // Compiler will pack this into a single 256bit word.
820     struct AddressData {
821         // Realistically, 2**64-1 is more than enough.
822         uint64 balance;
823         // Keeps track of mint count with minimal overhead for tokenomics.
824         uint64 numberMinted;
825         // Keeps track of burn count with minimal overhead for tokenomics.
826         uint64 numberBurned;
827         // For miscellaneous variable(s) pertaining to the address
828         // (e.g. number of whitelist mint slots used).
829         // If there are multiple variables, please pack them into a uint64.
830         uint64 aux;
831     }
832 
833     /**
834      * @dev Returns the total amount of tokens stored by the contract.
835      * 
836      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
837      */
838     function totalSupply() external view returns (uint256);
839 }
840 
841 // File: erc721a/contracts/ERC721A.sol
842 
843 
844 // ERC721A Contracts v3.3.0
845 // Creator: Chiru Labs
846 
847 pragma solidity ^0.8.4;
848 
849 
850 
851 
852 
853 
854 
855 /**
856  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
857  * the Metadata extension. Built to optimize for lower gas during batch mints.
858  *
859  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
860  *
861  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
862  *
863  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
864  */
865 contract ERC721A is Context, ERC165, IERC721A {
866     using Address for address;
867     using Strings for uint256;
868 
869     // The tokenId of the next token to be minted.
870     uint256 internal _currentIndex;
871 
872     // The number of tokens burned.
873     uint256 internal _burnCounter;
874 
875     // Token name
876     string private _name;
877 
878     // Token symbol
879     string private _symbol;
880 
881     // Mapping from token ID to ownership details
882     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
883     mapping(uint256 => TokenOwnership) internal _ownerships;
884 
885     // Mapping owner address to address data
886     mapping(address => AddressData) private _addressData;
887 
888     // Mapping from token ID to approved address
889     mapping(uint256 => address) private _tokenApprovals;
890 
891     // Mapping from owner to operator approvals
892     mapping(address => mapping(address => bool)) private _operatorApprovals;
893 
894     constructor(string memory name_, string memory symbol_) {
895         _name = name_;
896         _symbol = symbol_;
897         _currentIndex = _startTokenId();
898     }
899 
900     /**
901      * To change the starting tokenId, please override this function.
902      */
903     function _startTokenId() internal view virtual returns (uint256) {
904         return 0;
905     }
906 
907     /**
908      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
909      */
910     function totalSupply() public view override returns (uint256) {
911         // Counter underflow is impossible as _burnCounter cannot be incremented
912         // more than _currentIndex - _startTokenId() times
913         unchecked {
914             return _currentIndex - _burnCounter - _startTokenId();
915         }
916     }
917 
918     /**
919      * Returns the total amount of tokens minted in the contract.
920      */
921     function _totalMinted() internal view returns (uint256) {
922         // Counter underflow is impossible as _currentIndex does not decrement,
923         // and it is initialized to _startTokenId()
924         unchecked {
925             return _currentIndex - _startTokenId();
926         }
927     }
928 
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
933         return
934             interfaceId == type(IERC721).interfaceId ||
935             interfaceId == type(IERC721Metadata).interfaceId ||
936             super.supportsInterface(interfaceId);
937     }
938 
939     /**
940      * @dev See {IERC721-balanceOf}.
941      */
942     function balanceOf(address owner) public view override returns (uint256) {
943         if (owner == address(0)) revert BalanceQueryForZeroAddress();
944         return uint256(_addressData[owner].balance);
945     }
946 
947     /**
948      * Returns the number of tokens minted by `owner`.
949      */
950     function _numberMinted(address owner) internal view returns (uint256) {
951         return uint256(_addressData[owner].numberMinted);
952     }
953 
954     /**
955      * Returns the number of tokens burned by or on behalf of `owner`.
956      */
957     function _numberBurned(address owner) internal view returns (uint256) {
958         return uint256(_addressData[owner].numberBurned);
959     }
960 
961     /**
962      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
963      */
964     function _getAux(address owner) internal view returns (uint64) {
965         return _addressData[owner].aux;
966     }
967 
968     /**
969      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
970      * If there are multiple variables, please pack them into a uint64.
971      */
972     function _setAux(address owner, uint64 aux) internal {
973         _addressData[owner].aux = aux;
974     }
975 
976     /**
977      * Gas spent here starts off proportional to the maximum mint batch size.
978      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
979      */
980     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
981         uint256 curr = tokenId;
982 
983         unchecked {
984             if (_startTokenId() <= curr) if (curr < _currentIndex) {
985                 TokenOwnership memory ownership = _ownerships[curr];
986                 if (!ownership.burned) {
987                     if (ownership.addr != address(0)) {
988                         return ownership;
989                     }
990                     // Invariant:
991                     // There will always be an ownership that has an address and is not burned
992                     // before an ownership that does not have an address and is not burned.
993                     // Hence, curr will not underflow.
994                     while (true) {
995                         curr--;
996                         ownership = _ownerships[curr];
997                         if (ownership.addr != address(0)) {
998                             return ownership;
999                         }
1000                     }
1001                 }
1002             }
1003         }
1004         revert OwnerQueryForNonexistentToken();
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-ownerOf}.
1009      */
1010     function ownerOf(uint256 tokenId) public view override returns (address) {
1011         return _ownershipOf(tokenId).addr;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-name}.
1016      */
1017     function name() public view virtual override returns (string memory) {
1018         return _name;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Metadata-symbol}.
1023      */
1024     function symbol() public view virtual override returns (string memory) {
1025         return _symbol;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Metadata-tokenURI}.
1030      */
1031     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1032         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1033 
1034         string memory baseURI = _baseURI();
1035         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1036     }
1037 
1038     /**
1039      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1040      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1041      * by default, can be overriden in child contracts.
1042      */
1043     function _baseURI() internal view virtual returns (string memory) {
1044         return '';
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-approve}.
1049      */
1050     function approve(address to, uint256 tokenId) public override {
1051         address owner = ERC721A.ownerOf(tokenId);
1052         if (to == owner) revert ApprovalToCurrentOwner();
1053 
1054         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1055             revert ApprovalCallerNotOwnerNorApproved();
1056         }
1057 
1058         _approve(to, tokenId, owner);
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-getApproved}.
1063      */
1064     function getApproved(uint256 tokenId) public view override returns (address) {
1065         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1066 
1067         return _tokenApprovals[tokenId];
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-setApprovalForAll}.
1072      */
1073     function setApprovalForAll(address operator, bool approved) public virtual override {
1074         if (operator == _msgSender()) revert ApproveToCaller();
1075 
1076         _operatorApprovals[_msgSender()][operator] = approved;
1077         emit ApprovalForAll(_msgSender(), operator, approved);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-isApprovedForAll}.
1082      */
1083     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1084         return _operatorApprovals[owner][operator];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-transferFrom}.
1089      */
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         _transfer(from, to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-safeTransferFrom}.
1100      */
1101     function safeTransferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) public virtual override {
1106         safeTransferFrom(from, to, tokenId, '');
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-safeTransferFrom}.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) public virtual override {
1118         _transfer(from, to, tokenId);
1119         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1120             revert TransferToNonERC721ReceiverImplementer();
1121         }
1122     }
1123 
1124     /**
1125      * @dev Returns whether `tokenId` exists.
1126      *
1127      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1128      *
1129      * Tokens start existing when they are minted (`_mint`),
1130      */
1131     function _exists(uint256 tokenId) internal view returns (bool) {
1132         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1133     }
1134 
1135     /**
1136      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1137      */
1138     function _safeMint(address to, uint256 quantity) internal {
1139         _safeMint(to, quantity, '');
1140     }
1141 
1142     /**
1143      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - If `to` refers to a smart contract, it must implement
1148      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _safeMint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data
1157     ) internal {
1158         uint256 startTokenId = _currentIndex;
1159         if (to == address(0)) revert MintToZeroAddress();
1160         if (quantity == 0) revert MintZeroQuantity();
1161 
1162         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1163 
1164         // Overflows are incredibly unrealistic.
1165         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1166         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1167         unchecked {
1168             _addressData[to].balance += uint64(quantity);
1169             _addressData[to].numberMinted += uint64(quantity);
1170 
1171             _ownerships[startTokenId].addr = to;
1172             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1173 
1174             uint256 updatedIndex = startTokenId;
1175             uint256 end = updatedIndex + quantity;
1176 
1177             if (to.isContract()) {
1178                 do {
1179                     emit Transfer(address(0), to, updatedIndex);
1180                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1181                         revert TransferToNonERC721ReceiverImplementer();
1182                     }
1183                 } while (updatedIndex < end);
1184                 // Reentrancy protection
1185                 if (_currentIndex != startTokenId) revert();
1186             } else {
1187                 do {
1188                     emit Transfer(address(0), to, updatedIndex++);
1189                 } while (updatedIndex < end);
1190             }
1191             _currentIndex = updatedIndex;
1192         }
1193         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1194     }
1195 
1196     /**
1197      * @dev Mints `quantity` tokens and transfers them to `to`.
1198      *
1199      * Requirements:
1200      *
1201      * - `to` cannot be the zero address.
1202      * - `quantity` must be greater than 0.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _mint(address to, uint256 quantity) internal {
1207         uint256 startTokenId = _currentIndex;
1208         if (to == address(0)) revert MintToZeroAddress();
1209         if (quantity == 0) revert MintZeroQuantity();
1210 
1211         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1212 
1213         // Overflows are incredibly unrealistic.
1214         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1215         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1216         unchecked {
1217             _addressData[to].balance += uint64(quantity);
1218             _addressData[to].numberMinted += uint64(quantity);
1219 
1220             _ownerships[startTokenId].addr = to;
1221             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1222 
1223             uint256 updatedIndex = startTokenId;
1224             uint256 end = updatedIndex + quantity;
1225 
1226             do {
1227                 emit Transfer(address(0), to, updatedIndex++);
1228             } while (updatedIndex < end);
1229 
1230             _currentIndex = updatedIndex;
1231         }
1232         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1233     }
1234 
1235     /**
1236      * @dev Transfers `tokenId` from `from` to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must be owned by `from`.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) private {
1250         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1251 
1252         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1253 
1254         bool isApprovedOrOwner = (_msgSender() == from ||
1255             isApprovedForAll(from, _msgSender()) ||
1256             getApproved(tokenId) == _msgSender());
1257 
1258         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1259         if (to == address(0)) revert TransferToZeroAddress();
1260 
1261         _beforeTokenTransfers(from, to, tokenId, 1);
1262 
1263         // Clear approvals from the previous owner
1264         _approve(address(0), tokenId, from);
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             _addressData[from].balance -= 1;
1271             _addressData[to].balance += 1;
1272 
1273             TokenOwnership storage currSlot = _ownerships[tokenId];
1274             currSlot.addr = to;
1275             currSlot.startTimestamp = uint64(block.timestamp);
1276 
1277             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1278             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1279             uint256 nextTokenId = tokenId + 1;
1280             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1281             if (nextSlot.addr == address(0)) {
1282                 // This will suffice for checking _exists(nextTokenId),
1283                 // as a burned slot cannot contain the zero address.
1284                 if (nextTokenId != _currentIndex) {
1285                     nextSlot.addr = from;
1286                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1287                 }
1288             }
1289         }
1290 
1291         emit Transfer(from, to, tokenId);
1292         _afterTokenTransfers(from, to, tokenId, 1);
1293     }
1294 
1295     /**
1296      * @dev Equivalent to `_burn(tokenId, false)`.
1297      */
1298     function _burn(uint256 tokenId) internal virtual {
1299         _burn(tokenId, false);
1300     }
1301 
1302     /**
1303      * @dev Destroys `tokenId`.
1304      * The approval is cleared when the token is burned.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1313         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1314 
1315         address from = prevOwnership.addr;
1316 
1317         if (approvalCheck) {
1318             bool isApprovedOrOwner = (_msgSender() == from ||
1319                 isApprovedForAll(from, _msgSender()) ||
1320                 getApproved(tokenId) == _msgSender());
1321 
1322             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1323         }
1324 
1325         _beforeTokenTransfers(from, address(0), tokenId, 1);
1326 
1327         // Clear approvals from the previous owner
1328         _approve(address(0), tokenId, from);
1329 
1330         // Underflow of the sender's balance is impossible because we check for
1331         // ownership above and the recipient's balance can't realistically overflow.
1332         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1333         unchecked {
1334             AddressData storage addressData = _addressData[from];
1335             addressData.balance -= 1;
1336             addressData.numberBurned += 1;
1337 
1338             // Keep track of who burned the token, and the timestamp of burning.
1339             TokenOwnership storage currSlot = _ownerships[tokenId];
1340             currSlot.addr = from;
1341             currSlot.startTimestamp = uint64(block.timestamp);
1342             currSlot.burned = true;
1343 
1344             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1345             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1346             uint256 nextTokenId = tokenId + 1;
1347             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1348             if (nextSlot.addr == address(0)) {
1349                 // This will suffice for checking _exists(nextTokenId),
1350                 // as a burned slot cannot contain the zero address.
1351                 if (nextTokenId != _currentIndex) {
1352                     nextSlot.addr = from;
1353                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1354                 }
1355             }
1356         }
1357 
1358         emit Transfer(from, address(0), tokenId);
1359         _afterTokenTransfers(from, address(0), tokenId, 1);
1360 
1361         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1362         unchecked {
1363             _burnCounter++;
1364         }
1365     }
1366 
1367     /**
1368      * @dev Approve `to` to operate on `tokenId`
1369      *
1370      * Emits a {Approval} event.
1371      */
1372     function _approve(
1373         address to,
1374         uint256 tokenId,
1375         address owner
1376     ) private {
1377         _tokenApprovals[tokenId] = to;
1378         emit Approval(owner, to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkContractOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1397             return retval == IERC721Receiver(to).onERC721Received.selector;
1398         } catch (bytes memory reason) {
1399             if (reason.length == 0) {
1400                 revert TransferToNonERC721ReceiverImplementer();
1401             } else {
1402                 assembly {
1403                     revert(add(32, reason), mload(reason))
1404                 }
1405             }
1406         }
1407     }
1408 
1409     /**
1410      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1411      * And also called before burning one token.
1412      *
1413      * startTokenId - the first token id to be transferred
1414      * quantity - the amount to be transferred
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, `tokenId` will be burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _beforeTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 
1431     /**
1432      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1433      * minting.
1434      * And also called after one token has been burned.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` has been minted for `to`.
1444      * - When `to` is zero, `tokenId` has been burned by `from`.
1445      * - `from` and `to` are never both zero.
1446      */
1447     function _afterTokenTransfers(
1448         address from,
1449         address to,
1450         uint256 startTokenId,
1451         uint256 quantity
1452     ) internal virtual {}
1453 }
1454 
1455 // File: contracts/AIGoblins.sol
1456 
1457 //SPDX-License-Identifier: MIT
1458 
1459 pragma solidity ^0.8.0;
1460 
1461 
1462 
1463 
1464 contract AIGoblins is ERC721A, ReentrancyGuard, Ownable {
1465     string private baseURI;
1466     uint256 public maxSupply = 10000;
1467     uint256 public maxPerWallet = 20;
1468     uint256 public maxPerTx = 20;
1469     uint256 public totalFree = 3000;
1470     uint256 public price = 0.005 ether;
1471     
1472     bool private saleStatus;
1473     bool private revealStatus;
1474 
1475     mapping(address => uint256) private mintOG;
1476 
1477     constructor() ERC721A("AIGoblins", "AIGBLNS") {}
1478 
1479     function setBaseURI(string memory _URI) external onlyOwner {
1480         baseURI = _URI;
1481     }
1482 
1483     function _baseURI() internal view virtual override returns (string memory) {
1484         return baseURI;
1485     }
1486 
1487     function setSaleStatus() external onlyOwner {
1488         saleStatus = !saleStatus;
1489     }
1490 
1491 
1492 
1493 
1494     // Mint Function
1495 
1496 
1497     function mint(uint256 amt) external payable {
1498         uint256 cost = price;
1499         if (totalSupply() + amt < totalFree + 1) {
1500             cost = 0;
1501         }
1502 
1503         require(msg.value >= amt * cost, "Please send the exact amount.");
1504         require(totalSupply() + amt < maxSupply + 1, "No more AIGoblins");
1505         require(saleStatus, "Minting is not live yet, hold on.");
1506         require(amt < maxPerTx + 1, "Max per TX reached.");
1507         require(
1508             _numberMinted(msg.sender) + amt <= maxPerWallet,
1509             "Too many per wallet!"
1510         );
1511 
1512         _safeMint(msg.sender, amt);
1513 
1514     
1515     }
1516 
1517     // Reveal Mechanism
1518 
1519     function setReveal() external onlyOwner {
1520         revealStatus = !revealStatus;
1521     }
1522 
1523     function tokenURI(uint256 tokenId)
1524         public
1525         view
1526         virtual
1527         override
1528         returns (string memory)
1529     {
1530         require(
1531             _exists(tokenId),
1532             "ERC721Metadata: URI query for nonexistent token"
1533         );
1534 
1535         if (!revealStatus) {
1536             return baseURI;
1537         }
1538         return super.tokenURI(tokenId);
1539     }
1540 
1541     // Withdraw Balance
1542 
1543     address private payoutAddress = 0x90ade7710257b5F5Afd0d0b66e8c9815D842753a;
1544 
1545     function withdraw() external onlyOwner {
1546         uint256 balance = address(this).balance;
1547         payable(payoutAddress).transfer(balance);
1548     }
1549 }