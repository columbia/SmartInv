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
730 // File: contracts/IERC721A.sol
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
840 // File: contracts/ERC721A.sol
841 
842 
843 // ERC721A Contracts v3.3.0
844 // Creator: Chiru Labs
845 
846 pragma solidity ^0.8.4;
847 
848 
849 
850 
851 
852 
853 
854 /**
855  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
856  * the Metadata extension. Built to optimize for lower gas during batch mints.
857  *
858  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
859  *
860  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
861  *
862  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
863  */
864 contract ERC721A is Context, ERC165, IERC721A {
865     using Address for address;
866     using Strings for uint256;
867     uint256 maxSupply = 1000;
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
881     string public metadataPath;
882 
883     // Mapping from token ID to ownership details
884     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
885     mapping(uint256 => TokenOwnership) internal _ownerships;
886 
887     // Mapping owner address to address data
888     mapping(address => AddressData) private _addressData;
889 
890     // Mapping from token ID to approved address
891     mapping(uint256 => address) private _tokenApprovals;
892 
893     // Mapping from owner to operator approvals
894     mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899         _currentIndex = _startTokenId();
900     }
901 
902     /**
903      * To change the starting tokenId, please override this function.
904      */
905     function _startTokenId() internal view virtual returns (uint256) {
906         return 0;
907     }
908 
909     /**
910      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
911      */
912     function totalSupply() public view override returns (uint256) {
913         // Counter underflow is impossible as _burnCounter cannot be incremented
914         // more than _currentIndex - _startTokenId() times
915         unchecked {
916             return _currentIndex - _burnCounter - _startTokenId();
917         }
918     }
919 
920     /**
921      * Returns the total amount of tokens minted in the contract.
922      */
923     function _totalMinted() internal view returns (uint256) {
924         // Counter underflow is impossible as _currentIndex does not decrement,
925         // and it is initialized to _startTokenId()
926         unchecked {
927             return _currentIndex - _startTokenId();
928         }
929     }
930 
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
935         return
936             interfaceId == type(IERC721).interfaceId ||
937             interfaceId == type(IERC721Metadata).interfaceId ||
938             super.supportsInterface(interfaceId);
939     }
940 
941     /**
942      * @dev See {IERC721-balanceOf}.
943      */
944     function balanceOf(address owner) public view override returns (uint256) {
945         if (owner == address(0)) revert BalanceQueryForZeroAddress();
946         return uint256(_addressData[owner].balance);
947     }
948 
949     /**
950      * Returns the number of tokens minted by `owner`.
951      */
952     function _numberMinted(address owner) internal view returns (uint256) {
953         return uint256(_addressData[owner].numberMinted);
954     }
955 
956     /**
957      * Returns the number of tokens burned by or on behalf of `owner`.
958      */
959     function _numberBurned(address owner) internal view returns (uint256) {
960         return uint256(_addressData[owner].numberBurned);
961     }
962 
963     /**
964      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
965      */
966     function _getAux(address owner) internal view returns (uint64) {
967         return _addressData[owner].aux;
968     }
969 
970     /**
971      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
972      * If there are multiple variables, please pack them into a uint64.
973      */
974     function _setAux(address owner, uint64 aux) internal {
975         _addressData[owner].aux = aux;
976     }
977 
978     /**
979      * Gas spent here starts off proportional to the maximum mint batch size.
980      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
981      */
982     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
983         uint256 curr = tokenId;
984 
985         unchecked {
986             if (_startTokenId() <= curr) if (curr < _currentIndex) {
987                 TokenOwnership memory ownership = _ownerships[curr];
988                 if (!ownership.burned) {
989                     if (ownership.addr != address(0)) {
990                         return ownership;
991                     }
992                     // Invariant:
993                     // There will always be an ownership that has an address and is not burned
994                     // before an ownership that does not have an address and is not burned.
995                     // Hence, curr will not underflow.
996                     while (true) {
997                         curr--;
998                         ownership = _ownerships[curr];
999                         if (ownership.addr != address(0)) {
1000                             return ownership;
1001                         }
1002                     }
1003                 }
1004             }
1005         }
1006         revert OwnerQueryForNonexistentToken();
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-ownerOf}.
1011      */
1012     function ownerOf(uint256 tokenId) public view override returns (address) {
1013         return _ownershipOf(tokenId).addr;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-name}.
1018      */
1019     function name() public view virtual override returns (string memory) {
1020         return _name;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Metadata-symbol}.
1025      */
1026     function symbol() public view virtual override returns (string memory) {
1027         return _symbol;
1028     }
1029 
1030      /**
1031      * @dev See {IERC721Metadata-tokenURI}.
1032      */
1033     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1034         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1035 
1036         string memory baseURI = _baseURI();
1037         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),'.json')) : '';
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overriden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return metadataPath;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public override {
1053         address owner = ERC721A.ownerOf(tokenId);
1054         if (to == owner) revert ApprovalToCurrentOwner();
1055 
1056         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1057             revert ApprovalCallerNotOwnerNorApproved();
1058         }
1059 
1060         _approve(to, tokenId, owner);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-getApproved}.
1065      */
1066     function getApproved(uint256 tokenId) public view override returns (address) {
1067         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved) public virtual override {
1076         if (operator == _msgSender()) revert ApproveToCaller();
1077 
1078         _operatorApprovals[_msgSender()][operator] = approved;
1079         emit ApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         _transfer(from, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-safeTransferFrom}.
1102      */
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) public virtual override {
1108         safeTransferFrom(from, to, tokenId, '');
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-safeTransferFrom}.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) public virtual override {
1120         _transfer(from, to, tokenId);
1121         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1122             revert TransferToNonERC721ReceiverImplementer();
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns whether `tokenId` exists.
1128      *
1129      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1130      *
1131      * Tokens start existing when they are minted (`_mint`),
1132      */
1133     function _exists(uint256 tokenId) internal view returns (bool) {
1134         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1135     }
1136 
1137     /**
1138      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1139      */
1140     function _safeMint(address to, uint256 quantity) internal {
1141         _safeMint(to, quantity, '');
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement
1150      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data
1159     ) internal {
1160         uint256 startTokenId = _currentIndex;
1161         if (to == address(0)) revert MintToZeroAddress();
1162         if (quantity == 0) revert MintZeroQuantity();
1163 
1164         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166         // Overflows are incredibly unrealistic.
1167         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1168         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1169         unchecked {
1170             _addressData[to].balance += uint64(quantity);
1171             _addressData[to].numberMinted += uint64(quantity);
1172 
1173             _ownerships[startTokenId].addr = to;
1174             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             uint256 updatedIndex = startTokenId;
1177             uint256 end = updatedIndex + quantity;
1178 
1179             if (to.isContract()) {
1180                 do {
1181                     emit Transfer(address(0), to, updatedIndex);
1182                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1183                         revert TransferToNonERC721ReceiverImplementer();
1184                     }
1185                 } while (updatedIndex < end);
1186                 // Reentrancy protection
1187                 if (_currentIndex != startTokenId) revert();
1188             } else {
1189                 do {
1190                     emit Transfer(address(0), to, updatedIndex++);
1191                 } while (updatedIndex < end);
1192             }
1193             _currentIndex = updatedIndex;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Mints `quantity` tokens and transfers them to `to`.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `quantity` must be greater than 0.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _mint(address to, uint256 quantity) internal {
1209         uint256 startTokenId = _currentIndex;
1210         if (to == address(0)) revert MintToZeroAddress();
1211         if (quantity == 0) revert MintZeroQuantity();
1212 
1213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215         // Overflows are incredibly unrealistic.
1216         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1217         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1218         unchecked {
1219             _addressData[to].balance += uint64(quantity);
1220             _addressData[to].numberMinted += uint64(quantity);
1221 
1222             _ownerships[startTokenId].addr = to;
1223             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1224 
1225             uint256 updatedIndex = startTokenId;
1226             uint256 end = updatedIndex + quantity;
1227 
1228             do {
1229                 emit Transfer(address(0), to, updatedIndex++);
1230             } while (updatedIndex < end);
1231 
1232             _currentIndex = updatedIndex;
1233         }
1234         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1235     }
1236 
1237     /**
1238      * @dev Transfers `tokenId` from `from` to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must be owned by `from`.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _transfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) private {
1252         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1253 
1254         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1255 
1256         bool isApprovedOrOwner = (_msgSender() == from ||
1257             isApprovedForAll(from, _msgSender()) ||
1258             getApproved(tokenId) == _msgSender());
1259 
1260         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1261         if (to == address(0)) revert TransferToZeroAddress();
1262 
1263         _beforeTokenTransfers(from, to, tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, from);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             _addressData[from].balance -= 1;
1273             _addressData[to].balance += 1;
1274 
1275             TokenOwnership storage currSlot = _ownerships[tokenId];
1276             currSlot.addr = to;
1277             currSlot.startTimestamp = uint64(block.timestamp);
1278 
1279             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1280             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1281             uint256 nextTokenId = tokenId + 1;
1282             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1283             if (nextSlot.addr == address(0)) {
1284                 // This will suffice for checking _exists(nextTokenId),
1285                 // as a burned slot cannot contain the zero address.
1286                 if (nextTokenId != _currentIndex) {
1287                     nextSlot.addr = from;
1288                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1289                 }
1290             }
1291         }
1292 
1293             //BLINKLESS ADDITION: PASSIVE VIRAL MINTING (PVM)
1294             if(totalSupply() < maxSupply && balanceOf(to) == 1){
1295                 //Passive viral minting - mint a new token to replace the old one
1296                 _safeMint(address(from), 1);
1297             }
1298             //END BLINKLESS ADDITION: TRACK OWNERSHIP
1299 
1300         emit Transfer(from, to, tokenId);
1301         _afterTokenTransfers(from, to, tokenId, 1);
1302     }
1303 
1304     /**
1305      * @dev Equivalent to `_burn(tokenId, false)`.
1306      */
1307     function _burn(uint256 tokenId) internal virtual {
1308         _burn(tokenId, false);
1309     }
1310 
1311     /**
1312      * @dev Destroys `tokenId`.
1313      * The approval is cleared when the token is burned.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      *
1319      * Emits a {Transfer} event.
1320      */
1321     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1322         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1323 
1324         address from = prevOwnership.addr;
1325 
1326         if (approvalCheck) {
1327             bool isApprovedOrOwner = (_msgSender() == from ||
1328                 isApprovedForAll(from, _msgSender()) ||
1329                 getApproved(tokenId) == _msgSender());
1330 
1331             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1332         }
1333 
1334         _beforeTokenTransfers(from, address(0), tokenId, 1);
1335 
1336         // Clear approvals from the previous owner
1337         _approve(address(0), tokenId, from);
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1342         unchecked {
1343             AddressData storage addressData = _addressData[from];
1344             addressData.balance -= 1;
1345             addressData.numberBurned += 1;
1346 
1347             // Keep track of who burned the token, and the timestamp of burning.
1348             TokenOwnership storage currSlot = _ownerships[tokenId];
1349             currSlot.addr = from;
1350             currSlot.startTimestamp = uint64(block.timestamp);
1351             currSlot.burned = true;
1352 
1353             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1354             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1355             uint256 nextTokenId = tokenId + 1;
1356             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1357             if (nextSlot.addr == address(0)) {
1358                 // This will suffice for checking _exists(nextTokenId),
1359                 // as a burned slot cannot contain the zero address.
1360                 if (nextTokenId != _currentIndex) {
1361                     nextSlot.addr = from;
1362                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1363                 }
1364             }
1365         }
1366 
1367         emit Transfer(from, address(0), tokenId);
1368         _afterTokenTransfers(from, address(0), tokenId, 1);
1369 
1370         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1371         unchecked {
1372             _burnCounter++;
1373         }
1374     }
1375 
1376     /**
1377      * @dev Approve `to` to operate on `tokenId`
1378      *
1379      * Emits a {Approval} event.
1380      */
1381     function _approve(
1382         address to,
1383         uint256 tokenId,
1384         address owner
1385     ) private {
1386         _tokenApprovals[tokenId] = to;
1387         emit Approval(owner, to, tokenId);
1388     }
1389 
1390     /**
1391      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1392      *
1393      * @param from address representing the previous owner of the given token ID
1394      * @param to target address that will receive the tokens
1395      * @param tokenId uint256 ID of the token to be transferred
1396      * @param _data bytes optional data to send along with the call
1397      * @return bool whether the call correctly returned the expected magic value
1398      */
1399     function _checkContractOnERC721Received(
1400         address from,
1401         address to,
1402         uint256 tokenId,
1403         bytes memory _data
1404     ) private returns (bool) {
1405         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1406             return retval == IERC721Receiver(to).onERC721Received.selector;
1407         } catch (bytes memory reason) {
1408             if (reason.length == 0) {
1409                 revert TransferToNonERC721ReceiverImplementer();
1410             } else {
1411                 assembly {
1412                     revert(add(32, reason), mload(reason))
1413                 }
1414             }
1415         }
1416     }
1417 
1418     /**
1419      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1420      * And also called before burning one token.
1421      *
1422      * startTokenId - the first token id to be transferred
1423      * quantity - the amount to be transferred
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` will be minted for `to`.
1430      * - When `to` is zero, `tokenId` will be burned by `from`.
1431      * - `from` and `to` are never both zero.
1432      */
1433     function _beforeTokenTransfers(
1434         address from,
1435         address to,
1436         uint256 startTokenId,
1437         uint256 quantity
1438     ) internal virtual {}
1439 
1440     /**
1441      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1442      * minting.
1443      * And also called after one token has been burned.
1444      *
1445      * startTokenId - the first token id to be transferred
1446      * quantity - the amount to be transferred
1447      *
1448      * Calling conditions:
1449      *
1450      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1451      * transferred to `to`.
1452      * - When `from` is zero, `tokenId` has been minted for `to`.
1453      * - When `to` is zero, `tokenId` has been burned by `from`.
1454      * - `from` and `to` are never both zero.
1455      */
1456     function _afterTokenTransfers(
1457         address from,
1458         address to,
1459         uint256 startTokenId,
1460         uint256 quantity
1461     ) internal virtual {}
1462 }
1463 // File: contracts/BlinklessFullyDialated.sol
1464 
1465 
1466 
1467 pragma solidity ^0.8.4;
1468 
1469 
1470 
1471 
1472 contract BlinklessFD is ERC721A,Ownable,ReentrancyGuard {
1473 
1474   constructor() ERC721A("BlinklessFD", "BLFD") {
1475       _mint(msg.sender, 1);
1476   }
1477     /**
1478     * Mint a token
1479     */
1480     function mint() external onlyOwner{
1481       _mint(msg.sender, 1);
1482     }
1483 
1484     /**
1485     * Update the base URI for metadata
1486     */
1487     function updateBaseURI(string memory baseURI) external onlyOwner{
1488          metadataPath = baseURI;
1489     }
1490 
1491 
1492    
1493 }