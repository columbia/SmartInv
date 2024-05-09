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
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
702 
703 
704 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
727      * Use along with {totalSupply} to enumerate all tokens.
728      */
729     function tokenByIndex(uint256 index) external view returns (uint256);
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
742  * @dev See https://eips.ethereum.org/EIPS/eip-721
743  */
744 interface IERC721Metadata is IERC721 {
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 }
760 
761 // File: contracts/ERC721A.sol
762 
763 
764 
765 pragma solidity ^0.8.0;
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
778  *
779  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
780  *
781  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
782  *
783  * Does not support burning tokens to address(0).
784  */
785 contract ERC721A is
786     Context,
787     ERC165,
788     IERC721,
789     IERC721Metadata,
790     IERC721Enumerable
791 {
792     using Address for address;
793     using Strings for uint256;
794 
795     struct TokenOwnership {
796         address addr;
797         uint64 startTimestamp;
798     }
799 
800     struct AddressData {
801         uint128 balance;
802         uint128 numberMinted;
803     }
804 
805     uint256 private currentIndex = 0;
806 
807     uint256 internal immutable collectionSize;
808     uint256 internal immutable maxBatchSize;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to ownership details
817     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
818     mapping(uint256 => TokenOwnership) private _ownerships;
819 
820     // Mapping owner address to address data
821     mapping(address => AddressData) private _addressData;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     /**
830      * @dev
831      * `maxBatchSize` refers to how much a minter can mint at a time.
832      * `collectionSize_` refers to how many tokens are in the collection.
833      */
834     constructor(
835         string memory name_,
836         string memory symbol_,
837         uint256 maxBatchSize_,
838         uint256 collectionSize_
839     ) {
840         require(
841             collectionSize_ > 0,
842             "ERC721A: collection must have a nonzero supply"
843         );
844         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
845         _name = name_;
846         _symbol = symbol_;
847         maxBatchSize = maxBatchSize_;
848         collectionSize = collectionSize_;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-totalSupply}.
853      */
854     function totalSupply() public view override returns (uint256) {
855         return currentIndex;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-tokenByIndex}.
860      */
861     function tokenByIndex(uint256 index)
862         public
863         view
864         override
865         returns (uint256)
866     {
867         require(index < totalSupply(), "ERC721A: global index out of bounds");
868         return index;
869     }
870 
871     /**
872      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
873      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
874      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
875      */
876     function tokenOfOwnerByIndex(address owner, uint256 index)
877         public
878         view
879         override
880         returns (uint256)
881     {
882         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
883         uint256 numMintedSoFar = totalSupply();
884         uint256 tokenIdsIdx = 0;
885         address currOwnershipAddr = address(0);
886         for (uint256 i = 0; i < numMintedSoFar; i++) {
887             TokenOwnership memory ownership = _ownerships[i];
888             if (ownership.addr != address(0)) {
889                 currOwnershipAddr = ownership.addr;
890             }
891             if (currOwnershipAddr == owner) {
892                 if (tokenIdsIdx == index) {
893                     return i;
894                 }
895                 tokenIdsIdx++;
896             }
897         }
898         revert("ERC721A: unable to get token of owner by index");
899     }
900 
901     /**
902      * @dev See {IERC165-supportsInterface}.
903      */
904     function supportsInterface(bytes4 interfaceId)
905         public
906         view
907         virtual
908         override(ERC165, IERC165)
909         returns (bool)
910     {
911         return
912             interfaceId == type(IERC721).interfaceId ||
913             interfaceId == type(IERC721Metadata).interfaceId ||
914             interfaceId == type(IERC721Enumerable).interfaceId ||
915             super.supportsInterface(interfaceId);
916     }
917 
918     /**
919      * @dev See {IERC721-balanceOf}.
920      */
921     function balanceOf(address owner) public view override returns (uint256) {
922         require(
923             owner != address(0),
924             "ERC721A: balance query for the zero address"
925         );
926         return uint256(_addressData[owner].balance);
927     }
928 
929     function _numberMinted(address owner) internal view returns (uint256) {
930         require(
931             owner != address(0),
932             "ERC721A: number minted query for the zero address"
933         );
934         return uint256(_addressData[owner].numberMinted);
935     }
936 
937     function ownershipOf(uint256 tokenId)
938         internal
939         view
940         returns (TokenOwnership memory)
941     {
942         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
943 
944         uint256 lowestTokenToCheck;
945         if (tokenId >= maxBatchSize) {
946             lowestTokenToCheck = tokenId - maxBatchSize + 1;
947         }
948 
949         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
950             TokenOwnership memory ownership = _ownerships[curr];
951             if (ownership.addr != address(0)) {
952                 return ownership;
953             }
954         }
955 
956         revert("ERC721A: unable to determine the owner of token");
957     }
958 
959     /**
960      * @dev See {IERC721-ownerOf}.
961      */
962     function ownerOf(uint256 tokenId) public view override returns (address) {
963         return ownershipOf(tokenId).addr;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-name}.
968      */
969     function name() public view virtual override returns (string memory) {
970         return _name;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-symbol}.
975      */
976     function symbol() public view virtual override returns (string memory) {
977         return _symbol;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-tokenURI}.
982      */
983     function tokenURI(uint256 tokenId)
984         public
985         view
986         virtual
987         override
988         returns (string memory)
989     {
990         require(
991             _exists(tokenId),
992             "ERC721Metadata: URI query for nonexistent token"
993         );
994 
995         string memory baseURI = _baseURI();
996         string memory baseURIeggs = _baseURIeggs();
997         return
998             bytes(baseURI).length > 0
999                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1000                 : baseURIeggs;
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, can be overriden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return "";
1010     }
1011 
1012     /**
1013      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1014      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1015      * by default, can be overriden in child contracts.
1016      */
1017     function _baseURIeggs() internal view virtual returns (string memory) {
1018         return "";
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-approve}.
1023      */
1024     function approve(address to, uint256 tokenId) public override {
1025         address owner = ERC721A.ownerOf(tokenId);
1026         require(to != owner, "ERC721A: approval to current owner");
1027 
1028         require(
1029             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1030             "ERC721A: approve caller is not owner nor approved for all"
1031         );
1032 
1033         _approve(to, tokenId, owner);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-getApproved}.
1038      */
1039     function getApproved(uint256 tokenId)
1040         public
1041         view
1042         override
1043         returns (address)
1044     {
1045         require(
1046             _exists(tokenId),
1047             "ERC721A: approved query for nonexistent token"
1048         );
1049 
1050         return _tokenApprovals[tokenId];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-setApprovalForAll}.
1055      */
1056     function setApprovalForAll(address operator, bool approved)
1057         public
1058         override
1059     {
1060         require(operator != _msgSender(), "ERC721A: approve to caller");
1061 
1062         _operatorApprovals[_msgSender()][operator] = approved;
1063         emit ApprovalForAll(_msgSender(), operator, approved);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-isApprovedForAll}.
1068      */
1069     function isApprovedForAll(address owner, address operator)
1070         public
1071         view
1072         virtual
1073         override
1074         returns (bool)
1075     {
1076         return _operatorApprovals[owner][operator];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-transferFrom}.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public override {
1087         _transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public override {
1098         safeTransferFrom(from, to, tokenId, "");
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) public override {
1110         _transfer(from, to, tokenId);
1111         require(
1112             _checkOnERC721Received(from, to, tokenId, _data),
1113             "ERC721A: transfer to non ERC721Receiver implementer"
1114         );
1115     }
1116 
1117     /**
1118      * @dev Returns whether `tokenId` exists.
1119      *
1120      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1121      *
1122      * Tokens start existing when they are minted (`_mint`),
1123      */
1124     function _exists(uint256 tokenId) internal view returns (bool) {
1125         return tokenId < currentIndex;
1126     }
1127 
1128     function _safeMint(address to, uint256 quantity) internal {
1129         _safeMint(to, quantity, "");
1130     }
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - there must be `quantity` tokens remaining unminted in the total collection.
1138      * - `to` cannot be the zero address.
1139      * - `quantity` cannot be larger than the max batch size.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _safeMint(
1144         address to,
1145         uint256 quantity,
1146         bytes memory _data
1147     ) internal {
1148         uint256 startTokenId = currentIndex;
1149         require(to != address(0), "ERC721A: mint to the zero address");
1150         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1151         require(!_exists(startTokenId), "ERC721A: token already minted");
1152         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1153 
1154         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1155 
1156         AddressData memory addressData = _addressData[to];
1157         _addressData[to] = AddressData(
1158             addressData.balance + uint128(quantity),
1159             addressData.numberMinted + uint128(quantity)
1160         );
1161         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1162 
1163         uint256 updatedIndex = startTokenId;
1164 
1165         for (uint256 i = 0; i < quantity; i++) {
1166             emit Transfer(address(0), to, updatedIndex);
1167             require(
1168                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1169                 "ERC721A: transfer to non ERC721Receiver implementer"
1170             );
1171             updatedIndex++;
1172         }
1173 
1174         currentIndex = updatedIndex;
1175         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1176     }
1177 
1178     /**
1179      * @dev Transfers `tokenId` from `from` to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must be owned by `from`.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _transfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) private {
1193         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1194 
1195         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1196             getApproved(tokenId) == _msgSender() ||
1197             isApprovedForAll(prevOwnership.addr, _msgSender()));
1198 
1199         require(
1200             isApprovedOrOwner,
1201             "ERC721A: transfer caller is not owner nor approved"
1202         );
1203 
1204         require(
1205             prevOwnership.addr == from,
1206             "ERC721A: transfer from incorrect owner"
1207         );
1208         require(to != address(0), "ERC721A: transfer to the zero address");
1209 
1210         _beforeTokenTransfers(from, to, tokenId, 1);
1211 
1212         // Clear approvals from the previous owner
1213         _approve(address(0), tokenId, prevOwnership.addr);
1214 
1215         _addressData[from].balance -= 1;
1216         _addressData[to].balance += 1;
1217         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1218 
1219         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1220         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1221         uint256 nextTokenId = tokenId + 1;
1222         if (_ownerships[nextTokenId].addr == address(0)) {
1223             if (_exists(nextTokenId)) {
1224                 _ownerships[nextTokenId] = TokenOwnership(
1225                     prevOwnership.addr,
1226                     prevOwnership.startTimestamp
1227                 );
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Approve `to` to operate on `tokenId`
1237      *
1238      * Emits a {Approval} event.
1239      */
1240     function _approve(
1241         address to,
1242         uint256 tokenId,
1243         address owner
1244     ) private {
1245         _tokenApprovals[tokenId] = to;
1246         emit Approval(owner, to, tokenId);
1247     }
1248 
1249     uint256 public nextOwnerToExplicitlySet = 0;
1250 
1251     /**
1252      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1253      */
1254     function _setOwnersExplicit(uint256 quantity) internal {
1255         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1256         require(quantity > 0, "quantity must be nonzero");
1257         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1258         if (endIndex > collectionSize - 1) {
1259             endIndex = collectionSize - 1;
1260         }
1261         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1262         require(_exists(endIndex), "not enough minted yet for this cleanup");
1263         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1264             if (_ownerships[i].addr == address(0)) {
1265                 TokenOwnership memory ownership = ownershipOf(i);
1266                 _ownerships[i] = TokenOwnership(
1267                     ownership.addr,
1268                     ownership.startTimestamp
1269                 );
1270             }
1271         }
1272         nextOwnerToExplicitlySet = endIndex + 1;
1273     }
1274 
1275     /**
1276      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1277      * The call is not executed if the target address is not a contract.
1278      *
1279      * @param from address representing the previous owner of the given token ID
1280      * @param to target address that will receive the tokens
1281      * @param tokenId uint256 ID of the token to be transferred
1282      * @param _data bytes optional data to send along with the call
1283      * @return bool whether the call correctly returned the expected magic value
1284      */
1285     function _checkOnERC721Received(
1286         address from,
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) private returns (bool) {
1291         if (to.isContract()) {
1292             try
1293                 IERC721Receiver(to).onERC721Received(
1294                     _msgSender(),
1295                     from,
1296                     tokenId,
1297                     _data
1298                 )
1299             returns (bytes4 retval) {
1300                 return retval == IERC721Receiver(to).onERC721Received.selector;
1301             } catch (bytes memory reason) {
1302                 if (reason.length == 0) {
1303                     revert(
1304                         "ERC721A: transfer to non ERC721Receiver implementer"
1305                     );
1306                 } else {
1307                     assembly {
1308                         revert(add(32, reason), mload(reason))
1309                     }
1310                 }
1311             }
1312         } else {
1313             return true;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
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
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - when `from` and `to` are both non-zero.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _afterTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 }
1355 
1356 // File: contracts/4_moonblurgs.sol
1357 
1358 
1359 
1360 pragma solidity ^0.8.4;
1361 
1362 
1363 
1364 
1365 
1366 contract moonblurgs is Ownable, ERC721A, ReentrancyGuard {
1367     uint256 public immutable maxPerAddressDuringMint;
1368     uint256 public immutable publicPrice;
1369 
1370     mapping(address => uint256) public allowlist;
1371 
1372     constructor() ERC721A("moonblurgs.wtf", "BLURG", 20, 7833) {
1373         maxPerAddressDuringMint = 20;
1374         publicPrice = 0;
1375     }
1376 
1377     modifier callerIsUser() {
1378         require(tx.origin == msg.sender, "The caller is another contract");
1379         _;
1380     }
1381 
1382     function publicSaleMint(uint256 quantity) external payable callerIsUser {
1383         require(isPublicSaleOn(), "public sale has not begun yet");
1384         require(
1385             totalSupply() + quantity <= collectionSize,
1386             "reached max supply"
1387         );
1388         require(quantity <= maxPerAddressDuringMint, "max 20 per transaction");
1389         _safeMint(msg.sender, quantity);
1390     }
1391 
1392     function refundIfOver(uint256 price) private {
1393         require(msg.value >= price, "Need to send more ETH.");
1394         if (msg.value > price) {
1395             payable(msg.sender).transfer(msg.value - price);
1396         }
1397     }
1398 
1399     // For marketing etc.
1400     function devMint(uint256 quantity) external onlyOwner {
1401         for (uint256 i = 0; i < quantity; i++) {
1402             _safeMint(msg.sender, maxPerAddressDuringMint);
1403         }
1404     }
1405 
1406     string private _baseTokenURI;
1407     string private _baseTokenURIeggs;
1408     bool private _isPublicSaleActive;
1409 
1410     function isPublicSaleOn() public view returns (bool) {
1411         return _isPublicSaleActive;
1412     }
1413 
1414     function _baseURI() internal view virtual override returns (string memory) {
1415         return _baseTokenURI;
1416     }
1417 
1418     function _baseURIeggs()
1419         internal
1420         view
1421         virtual
1422         override
1423         returns (string memory)
1424     {
1425         return _baseTokenURIeggs;
1426     }
1427 
1428     function setBaseURI(string calldata baseURI) external onlyOwner {
1429         _baseTokenURI = baseURI;
1430     }
1431 
1432     function setBaseURIeggs(string calldata baseURI) external onlyOwner {
1433         _baseTokenURIeggs = baseURI;
1434     }
1435 
1436     function setPublicSaleState(bool state) external onlyOwner {
1437         _isPublicSaleActive = state;
1438     }
1439 
1440     function withdrawMoney() external onlyOwner nonReentrant {
1441         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1442         require(success, "Transfer failed.");
1443     }
1444 
1445     function setOwnersExplicit(uint256 quantity)
1446         external
1447         onlyOwner
1448         nonReentrant
1449     {
1450         _setOwnersExplicit(quantity);
1451     }
1452 
1453     function numberMinted(address owner) public view returns (uint256) {
1454         return _numberMinted(owner);
1455     }
1456 
1457     function getOwnershipData(uint256 tokenId)
1458         external
1459         view
1460         returns (TokenOwnership memory)
1461     {
1462         return ownershipOf(tokenId);
1463     }
1464 }