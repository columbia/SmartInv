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
470 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Approve or remove `operator` as an operator for the caller.
663      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
664      *
665      * Requirements:
666      *
667      * - The `operator` cannot be the caller.
668      *
669      * Emits an {ApprovalForAll} event.
670      */
671     function setApprovalForAll(address operator, bool _approved) external;
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes calldata data
698     ) external;
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
730 // File: contracts/ERC721A.sol
731 
732 
733 // Creator: Chiru Labs
734 
735 pragma solidity ^0.8.4;
736 
737 
738 
739 
740 
741 
742 
743 
744 error ApprovalCallerNotOwnerNorApproved();
745 error ApprovalQueryForNonexistentToken();
746 error ApproveToCaller();
747 error ApprovalToCurrentOwner();
748 error BalanceQueryForZeroAddress();
749 error MintToZeroAddress();
750 error MintZeroQuantity();
751 error OwnerQueryForNonexistentToken();
752 error TransferCallerNotOwnerNorApproved();
753 error TransferFromIncorrectOwner();
754 error TransferToNonERC721ReceiverImplementer();
755 error TransferToZeroAddress();
756 error URIQueryForNonexistentToken();
757 
758 /**
759  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
760  * the Metadata extension. Built to optimize for lower gas during batch mints.
761  *
762  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
763  *
764  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
765  *
766  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
767  */
768 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
769     using Address for address;
770     using Strings for uint256;
771 
772     // Compiler will pack this into a single 256bit word.
773     struct TokenOwnership {
774         // The address of the owner.
775         address addr;
776         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
777         uint64 startTimestamp;
778         // Whether the token has been burned.
779         bool burned;
780     }
781 
782     // Compiler will pack this into a single 256bit word.
783     struct AddressData {
784         // Realistically, 2**64-1 is more than enough.
785         uint64 balance;
786         // Keeps track of mint count with minimal overhead for tokenomics.
787         uint64 numberMinted;
788         // Keeps track of burn count with minimal overhead for tokenomics.
789         uint64 numberBurned;
790         // For miscellaneous variable(s) pertaining to the address
791         // (e.g. number of whitelist mint slots used).
792         // If there are multiple variables, please pack them into a uint64.
793         uint64 aux;
794     }
795 
796     // The tokenId of the next token to be minted.
797     uint256 internal _currentIndex;
798 
799     // The number of tokens burned.
800     uint256 internal _burnCounter;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
810     mapping(uint256 => TokenOwnership) internal _ownerships;
811 
812     // Mapping owner address to address data
813     mapping(address => AddressData) private _addressData;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824         _currentIndex = _startTokenId();
825     }
826 
827     /**
828      * To change the starting tokenId, please override this function.
829      */
830     function _startTokenId() internal view virtual returns (uint256) {
831         return 0;
832     }
833 
834     /**
835      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
836      */
837     function totalSupply() public view returns (uint256) {
838         // Counter underflow is impossible as _burnCounter cannot be incremented
839         // more than _currentIndex - _startTokenId() times
840         unchecked {
841             return _currentIndex - _burnCounter - _startTokenId();
842         }
843     }
844 
845     /**
846      * Returns the total amount of tokens minted in the contract.
847      */
848     function _totalMinted() internal view returns (uint256) {
849         // Counter underflow is impossible as _currentIndex does not decrement,
850         // and it is initialized to _startTokenId()
851         unchecked {
852             return _currentIndex - _startTokenId();
853         }
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869     function balanceOf(address owner) public view override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871         return uint256(_addressData[owner].balance);
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         return uint256(_addressData[owner].numberMinted);
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         return uint256(_addressData[owner].numberBurned);
886     }
887 
888     /**
889      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         return _addressData[owner].aux;
893     }
894 
895     /**
896      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal {
900         _addressData[owner].aux = aux;
901     }
902 
903     /**
904      * Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
906      */
907     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
908         uint256 curr = tokenId;
909 
910         unchecked {
911             if (_startTokenId() <= curr && curr < _currentIndex) {
912                 TokenOwnership memory ownership = _ownerships[curr];
913                 if (!ownership.burned) {
914                     if (ownership.addr != address(0)) {
915                         return ownership;
916                     }
917                     // Invariant:
918                     // There will always be an ownership that has an address and is not burned
919                     // before an ownership that does not have an address and is not burned.
920                     // Hence, curr will not underflow.
921                     while (true) {
922                         curr--;
923                         ownership = _ownerships[curr];
924                         if (ownership.addr != address(0)) {
925                             return ownership;
926                         }
927                     }
928                 }
929             }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         return _ownershipOf(tokenId).addr;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-name}.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-symbol}.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-tokenURI}.
957      */
958     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
959         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
960 
961         string memory baseURI = _baseURI();
962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, can be overriden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return '';
972     }
973 
974     /**
975      * @dev See {IERC721-approve}.
976      */
977     function approve(address to, uint256 tokenId) public override {
978         address owner = ERC721A.ownerOf(tokenId);
979         if (to == owner) revert ApprovalToCurrentOwner();
980 
981         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
982             revert ApprovalCallerNotOwnerNorApproved();
983         }
984 
985         _approve(to, tokenId, owner);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId) public view override returns (address) {
992         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
993 
994         return _tokenApprovals[tokenId];
995     }
996 
997     /**
998      * @dev See {IERC721-setApprovalForAll}.
999      */
1000     function setApprovalForAll(address operator, bool approved) public virtual override {
1001         if (operator == _msgSender()) revert ApproveToCaller();
1002 
1003         _operatorApprovals[_msgSender()][operator] = approved;
1004         emit ApprovalForAll(_msgSender(), operator, approved);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-isApprovedForAll}.
1009      */
1010     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1011         return _operatorApprovals[owner][operator];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-transferFrom}.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         safeTransferFrom(from, to, tokenId, '');
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1047             revert TransferToNonERC721ReceiverImplementer();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      */
1058     function _exists(uint256 tokenId) internal view returns (bool) {
1059         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1060     }
1061 
1062     /**
1063      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1064      */
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, '');
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement 
1075      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         uint256 startTokenId = _currentIndex;
1086         if (to == address(0)) revert MintToZeroAddress();
1087         if (quantity == 0) revert MintZeroQuantity();
1088 
1089         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1090 
1091         // Overflows are incredibly unrealistic.
1092         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1093         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1094         unchecked {
1095             _addressData[to].balance += uint64(quantity);
1096             _addressData[to].numberMinted += uint64(quantity);
1097 
1098             _ownerships[startTokenId].addr = to;
1099             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1100 
1101             uint256 updatedIndex = startTokenId;
1102             uint256 end = updatedIndex + quantity;
1103 
1104             if (to.isContract()) {
1105                 do {
1106                     emit Transfer(address(0), to, updatedIndex);
1107                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1108                         revert TransferToNonERC721ReceiverImplementer();
1109                     }
1110                 } while (updatedIndex != end);
1111                 // Reentrancy protection
1112                 if (_currentIndex != startTokenId) revert();
1113             } else {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex++);
1116                 } while (updatedIndex != end);
1117             }
1118             _currentIndex = updatedIndex;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _mint(address to, uint256 quantity) internal {
1134         uint256 startTokenId = _currentIndex;
1135         if (to == address(0)) revert MintToZeroAddress();
1136         if (quantity == 0) revert MintZeroQuantity();
1137 
1138         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1139 
1140         // Overflows are incredibly unrealistic.
1141         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1142         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1143         unchecked {
1144             _addressData[to].balance += uint64(quantity);
1145             _addressData[to].numberMinted += uint64(quantity);
1146 
1147             _ownerships[startTokenId].addr = to;
1148             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             uint256 updatedIndex = startTokenId;
1151             uint256 end = updatedIndex + quantity;
1152 
1153             do {
1154                 emit Transfer(address(0), to, updatedIndex++);
1155             } while (updatedIndex != end);
1156 
1157             _currentIndex = updatedIndex;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Transfers `tokenId` from `from` to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must be owned by `from`.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _transfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) private {
1177         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1178 
1179         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1180 
1181         bool isApprovedOrOwner = (_msgSender() == from ||
1182             isApprovedForAll(from, _msgSender()) ||
1183             getApproved(tokenId) == _msgSender());
1184 
1185         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1186         if (to == address(0)) revert TransferToZeroAddress();
1187 
1188         _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, from);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             _addressData[from].balance -= 1;
1198             _addressData[to].balance += 1;
1199 
1200             TokenOwnership storage currSlot = _ownerships[tokenId];
1201             currSlot.addr = to;
1202             currSlot.startTimestamp = uint64(block.timestamp);
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1208             if (nextSlot.addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId != _currentIndex) {
1212                     nextSlot.addr = from;
1213                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, to, tokenId);
1219         _afterTokenTransfers(from, to, tokenId, 1);
1220     }
1221 
1222     /**
1223      * @dev Equivalent to `_burn(tokenId, false)`.
1224      */
1225     function _burn(uint256 tokenId) internal virtual {
1226         _burn(tokenId, false);
1227     }
1228 
1229     /**
1230      * @dev Destroys `tokenId`.
1231      * The approval is cleared when the token is burned.
1232      *
1233      * Requirements:
1234      *
1235      * - `tokenId` must exist.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1240         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1241 
1242         address from = prevOwnership.addr;
1243 
1244         if (approvalCheck) {
1245             bool isApprovedOrOwner = (_msgSender() == from ||
1246                 isApprovedForAll(from, _msgSender()) ||
1247                 getApproved(tokenId) == _msgSender());
1248 
1249             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1250         }
1251 
1252         _beforeTokenTransfers(from, address(0), tokenId, 1);
1253 
1254         // Clear approvals from the previous owner
1255         _approve(address(0), tokenId, from);
1256 
1257         // Underflow of the sender's balance is impossible because we check for
1258         // ownership above and the recipient's balance can't realistically overflow.
1259         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1260         unchecked {
1261             AddressData storage addressData = _addressData[from];
1262             addressData.balance -= 1;
1263             addressData.numberBurned += 1;
1264 
1265             // Keep track of who burned the token, and the timestamp of burning.
1266             TokenOwnership storage currSlot = _ownerships[tokenId];
1267             currSlot.addr = from;
1268             currSlot.startTimestamp = uint64(block.timestamp);
1269             currSlot.burned = true;
1270 
1271             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1272             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1273             uint256 nextTokenId = tokenId + 1;
1274             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1275             if (nextSlot.addr == address(0)) {
1276                 // This will suffice for checking _exists(nextTokenId),
1277                 // as a burned slot cannot contain the zero address.
1278                 if (nextTokenId != _currentIndex) {
1279                     nextSlot.addr = from;
1280                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1281                 }
1282             }
1283         }
1284 
1285         emit Transfer(from, address(0), tokenId);
1286         _afterTokenTransfers(from, address(0), tokenId, 1);
1287 
1288         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1289         unchecked {
1290             _burnCounter++;
1291         }
1292     }
1293 
1294     /**
1295      * @dev Approve `to` to operate on `tokenId`
1296      *
1297      * Emits a {Approval} event.
1298      */
1299     function _approve(
1300         address to,
1301         uint256 tokenId,
1302         address owner
1303     ) private {
1304         _tokenApprovals[tokenId] = to;
1305         emit Approval(owner, to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1310      *
1311      * @param from address representing the previous owner of the given token ID
1312      * @param to target address that will receive the tokens
1313      * @param tokenId uint256 ID of the token to be transferred
1314      * @param _data bytes optional data to send along with the call
1315      * @return bool whether the call correctly returned the expected magic value
1316      */
1317     function _checkContractOnERC721Received(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) private returns (bool) {
1323         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1324             return retval == IERC721Receiver(to).onERC721Received.selector;
1325         } catch (bytes memory reason) {
1326             if (reason.length == 0) {
1327                 revert TransferToNonERC721ReceiverImplementer();
1328             } else {
1329                 assembly {
1330                     revert(add(32, reason), mload(reason))
1331                 }
1332             }
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1338      * And also called before burning one token.
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` will be minted for `to`.
1348      * - When `to` is zero, `tokenId` will be burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _beforeTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1360      * minting.
1361      * And also called after one token has been burned.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` has been minted for `to`.
1371      * - When `to` is zero, `tokenId` has been burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _afterTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 }
1381 // File: contracts/Zukibirds.sol
1382 
1383 
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 
1388 
1389 
1390 
1391 contract Zukibirds is ERC721A, Ownable, ReentrancyGuard {
1392   using Address for address;
1393   using Strings for uint;
1394 
1395 
1396   string  public  baseTokenURI = "https://gateway.pinata.cloud/ipfs/QmYwenf3oGb4R9b4k1qktBm1CzRvim2hWLgytrF23ocnG8";
1397   uint256  public  maxSupply = 2222;
1398   uint256 public  MAX_MINTS_PER_TX = 5;
1399   uint256 public  PUBLIC_SALE_PRICE = 0.01 ether;
1400   uint256 public  NUM_FREE_MINTS = 0;
1401   uint256 public  MAX_FREE_PER_WALLET = 0;
1402   uint256 public freeNFTAlreadyMinted = 0;
1403   bool public isPublicSaleActive = true;
1404 
1405   constructor(
1406 
1407   ) ERC721A("Zukibirds", "ZUKIBIRDS") {
1408 
1409   }
1410 
1411 
1412   function mint(uint256 numberOfTokens)
1413       external
1414       payable
1415   {
1416     require(isPublicSaleActive, "Public sale is not open");
1417 
1418     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1419         require(
1420             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1421             "Incorrect ETH value sent"
1422         );
1423     } else {
1424         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1425         require(
1426             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1427             "Incorrect ETH value sent"
1428         );
1429         require(
1430             numberOfTokens <= MAX_MINTS_PER_TX,
1431             "Max mints per transaction exceeded"
1432         );
1433         } else {
1434             require(
1435                 numberOfTokens <= MAX_FREE_PER_WALLET,
1436                 "Max mints per transaction exceeded"
1437             );
1438             freeNFTAlreadyMinted += numberOfTokens;
1439         }
1440     }
1441     _safeMint(msg.sender, numberOfTokens);
1442   }
1443 
1444   function setBaseURI(string memory baseURI)
1445     public
1446     onlyOwner
1447   {
1448     baseTokenURI = baseURI;
1449   }
1450 
1451   function treasuryMint(uint quantity)
1452     public
1453     onlyOwner
1454   {
1455     require(
1456       quantity > 0,
1457       "Invalid mint amount"
1458     );
1459     require(
1460       totalSupply() + quantity <= maxSupply,
1461       "Maximum supply exceeded"
1462     );
1463     _safeMint(msg.sender, quantity);
1464   }
1465 
1466   function withdraw()
1467     public
1468     onlyOwner
1469     nonReentrant
1470   {
1471     Address.sendValue(payable(msg.sender), address(this).balance);
1472   }
1473 
1474   function tokenURI(uint _tokenId)
1475     public
1476     view
1477     virtual
1478     override
1479     returns (string memory)
1480   {
1481     require(
1482       _exists(_tokenId),
1483       "ERC721Metadata: URI query for nonexistent token"
1484     );
1485     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1486   }
1487 
1488   function _baseURI()
1489     internal
1490     view
1491     virtual
1492     override
1493     returns (string memory)
1494   {
1495     return baseTokenURI;
1496   }
1497 
1498   function setIsPublicSaleActive(bool _isPublicSaleActive)
1499       external
1500       onlyOwner
1501   {
1502       isPublicSaleActive = _isPublicSaleActive;
1503   }
1504 
1505   function setNumFreeMints(uint256 _numfreemints)
1506       external
1507       onlyOwner
1508   {
1509       NUM_FREE_MINTS = _numfreemints;
1510   }
1511 
1512   function setSalePrice(uint256 _price)
1513       external
1514       onlyOwner
1515   {
1516       PUBLIC_SALE_PRICE = _price;
1517   }
1518 
1519   function setMaxLimitPerTransaction(uint256 _limit)
1520       external
1521       onlyOwner
1522   {
1523       MAX_MINTS_PER_TX = _limit;
1524   }
1525 
1526   function setFreeLimitPerWallet(uint256 _limit)
1527       external
1528       onlyOwner
1529   {
1530       MAX_FREE_PER_WALLET = _limit;
1531   }
1532 }