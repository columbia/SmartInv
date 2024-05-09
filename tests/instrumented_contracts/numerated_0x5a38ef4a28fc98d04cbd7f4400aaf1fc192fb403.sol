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
764 // Creator: Chiru Labs
765 
766 pragma solidity ^0.8.4;
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 error ApprovalCallerNotOwnerNorApproved();
777 error ApprovalQueryForNonexistentToken();
778 error ApproveToCaller();
779 error ApprovalToCurrentOwner();
780 error BalanceQueryForZeroAddress();
781 error MintedQueryForZeroAddress();
782 error BurnedQueryForZeroAddress();
783 error MintToZeroAddress();
784 error MintZeroQuantity();
785 error OwnerIndexOutOfBounds();
786 error OwnerQueryForNonexistentToken();
787 error TokenIndexOutOfBounds();
788 error TransferCallerNotOwnerNorApproved();
789 error TransferFromIncorrectOwner();
790 error TransferToNonERC721ReceiverImplementer();
791 error TransferToZeroAddress();
792 error URIQueryForNonexistentToken();
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
797  *
798  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
799  *
800  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
801  *
802  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
803  */
804 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Compiler will pack this into a single 256bit word.
809     struct TokenOwnership {
810         // The address of the owner.
811         address addr;
812         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
813         uint64 startTimestamp;
814         // Whether the token has been burned.
815         bool burned;
816     }
817 
818     // Compiler will pack this into a single 256bit word.
819     struct AddressData {
820         // Realistically, 2**64-1 is more than enough.
821         uint64 balance;
822         // Keeps track of mint count with minimal overhead for tokenomics.
823         uint64 numberMinted;
824         // Keeps track of burn count with minimal overhead for tokenomics.
825         uint64 numberBurned;
826     }
827 
828     // Compiler will pack the following 
829     // _currentIndex and _burnCounter into a single 256bit word.
830     
831     // The tokenId of the next token to be minted.
832     uint128 internal _currentIndex;
833 
834     // The number of tokens burned.
835     uint128 internal _burnCounter;
836 
837     // Token name
838     string private _name;
839 
840     // Token symbol
841     string private _symbol;
842 
843     // Mapping from token ID to ownership details
844     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
845     mapping(uint256 => TokenOwnership) internal _ownerships;
846 
847     // Mapping owner address to address data
848     mapping(address => AddressData) private _addressData;
849 
850     // Mapping from token ID to approved address
851     mapping(uint256 => address) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping(address => mapping(address => bool)) private _operatorApprovals;
855 
856     constructor(string memory name_, string memory symbol_) {
857         _name = name_;
858         _symbol = symbol_;
859     }
860 
861     /**
862      * @dev See {IERC721Enumerable-totalSupply}.
863      */
864     function totalSupply() public view override returns (uint256) {
865         // Counter underflow is impossible as _burnCounter cannot be incremented
866         // more than _currentIndex times
867         unchecked {
868             return _currentIndex - _burnCounter;    
869         }
870     }
871 
872     /**
873      * @dev See {IERC721Enumerable-tokenByIndex}.
874      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
875      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
876      */
877     function tokenByIndex(uint256 index) public view override returns (uint256) {
878         uint256 numMintedSoFar = _currentIndex;
879         uint256 tokenIdsIdx;
880 
881         // Counter overflow is impossible as the loop breaks when
882         // uint256 i is equal to another uint256 numMintedSoFar.
883         unchecked {
884             for (uint256 i; i < numMintedSoFar; i++) {
885                 TokenOwnership memory ownership = _ownerships[i];
886                 if (!ownership.burned) {
887                     if (tokenIdsIdx == index) {
888                         return i;
889                     }
890                     tokenIdsIdx++;
891                 }
892             }
893         }
894         revert TokenIndexOutOfBounds();
895     }
896 
897     /**
898      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
899      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
900      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
901      */
902     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
903         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
904         uint256 numMintedSoFar = _currentIndex;
905         uint256 tokenIdsIdx;
906         address currOwnershipAddr;
907 
908         // Counter overflow is impossible as the loop breaks when
909         // uint256 i is equal to another uint256 numMintedSoFar.
910         unchecked {
911             for (uint256 i; i < numMintedSoFar; i++) {
912                 TokenOwnership memory ownership = _ownerships[i];
913                 if (ownership.burned) {
914                     continue;
915                 }
916                 if (ownership.addr != address(0)) {
917                     currOwnershipAddr = ownership.addr;
918                 }
919                 if (currOwnershipAddr == owner) {
920                     if (tokenIdsIdx == index) {
921                         return i;
922                     }
923                     tokenIdsIdx++;
924                 }
925             }
926         }
927 
928         // Execution should never reach this point.
929         revert();
930     }
931 
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
936         return
937             interfaceId == type(IERC721).interfaceId ||
938             interfaceId == type(IERC721Metadata).interfaceId ||
939             interfaceId == type(IERC721Enumerable).interfaceId ||
940             super.supportsInterface(interfaceId);
941     }
942 
943     /**
944      * @dev See {IERC721-balanceOf}.
945      */
946     function balanceOf(address owner) public view override returns (uint256) {
947         if (owner == address(0)) revert BalanceQueryForZeroAddress();
948         return uint256(_addressData[owner].balance);
949     }
950 
951     function _numberMinted(address owner) internal view returns (uint256) {
952         if (owner == address(0)) revert MintedQueryForZeroAddress();
953         return uint256(_addressData[owner].numberMinted);
954     }
955 
956     function _numberBurned(address owner) internal view returns (uint256) {
957         if (owner == address(0)) revert BurnedQueryForZeroAddress();
958         return uint256(_addressData[owner].numberBurned);
959     }
960 
961     /**
962      * Gas spent here starts off proportional to the maximum mint batch size.
963      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
964      */
965     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
966         uint256 curr = tokenId;
967 
968         unchecked {
969             if (curr < _currentIndex) {
970                 TokenOwnership memory ownership = _ownerships[curr];
971                 if (!ownership.burned) {
972                     if (ownership.addr != address(0)) {
973                         return ownership;
974                     }
975                     // Invariant: 
976                     // There will always be an ownership that has an address and is not burned 
977                     // before an ownership that does not have an address and is not burned.
978                     // Hence, curr will not underflow.
979                     while (true) {
980                         curr--;
981                         ownership = _ownerships[curr];
982                         if (ownership.addr != address(0)) {
983                             return ownership;
984                         }
985                     }
986                 }
987             }
988         }
989         revert OwnerQueryForNonexistentToken();
990     }
991 
992     /**
993      * @dev See {IERC721-ownerOf}.
994      */
995     function ownerOf(uint256 tokenId) public view override returns (address) {
996         return ownershipOf(tokenId).addr;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-name}.
1001      */
1002     function name() public view virtual override returns (string memory) {
1003         return _name;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-symbol}.
1008      */
1009     function symbol() public view virtual override returns (string memory) {
1010         return _symbol;
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Metadata-tokenURI}.
1015      */
1016     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1017         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1018 
1019         string memory baseURI = _baseURI();
1020         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1021     }
1022 
1023     /**
1024      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1025      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1026      * by default, can be overriden in child contracts.
1027      */
1028     function _baseURI() internal view virtual returns (string memory) {
1029         return '';
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-approve}.
1034      */
1035     function approve(address to, uint256 tokenId) public override {
1036         address owner = ERC721A.ownerOf(tokenId);
1037         if (to == owner) revert ApprovalToCurrentOwner();
1038 
1039         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1040             revert ApprovalCallerNotOwnerNorApproved();
1041         }
1042 
1043         _approve(to, tokenId, owner);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view override returns (address) {
1050         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public override {
1059         if (operator == _msgSender()) revert ApproveToCaller();
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-safeTransferFrom}.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public virtual override {
1091         safeTransferFrom(from, to, tokenId, '');
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) public virtual override {
1103         _transfer(from, to, tokenId);
1104         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1105             revert TransferToNonERC721ReceiverImplementer();
1106         }
1107     }
1108 
1109     /**
1110      * @dev Returns whether `tokenId` exists.
1111      *
1112      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1113      *
1114      * Tokens start existing when they are minted (`_mint`),
1115      */
1116     function _exists(uint256 tokenId) internal view returns (bool) {
1117         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1118     }
1119 
1120     function _safeMint(address to, uint256 quantity) internal {
1121         _safeMint(to, quantity, '');
1122     }
1123 
1124     /**
1125      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1130      * - `quantity` must be greater than 0.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _safeMint(
1135         address to,
1136         uint256 quantity,
1137         bytes memory _data
1138     ) internal {
1139         _mint(to, quantity, _data, true);
1140     }
1141 
1142     /**
1143      * @dev Mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _mint(
1153         address to,
1154         uint256 quantity,
1155         bytes memory _data,
1156         bool safe
1157     ) internal {
1158         uint256 startTokenId = _currentIndex;
1159         if (to == address(0)) revert MintToZeroAddress();
1160         if (quantity == 0) revert MintZeroQuantity();
1161 
1162         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1163 
1164         // Overflows are incredibly unrealistic.
1165         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1166         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1167         unchecked {
1168             _addressData[to].balance += uint64(quantity);
1169             _addressData[to].numberMinted += uint64(quantity);
1170 
1171             _ownerships[startTokenId].addr = to;
1172             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1173 
1174             uint256 updatedIndex = startTokenId;
1175 
1176             for (uint256 i; i < quantity; i++) {
1177                 emit Transfer(address(0), to, updatedIndex);
1178                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1179                     revert TransferToNonERC721ReceiverImplementer();
1180                 }
1181                 updatedIndex++;
1182             }
1183 
1184             _currentIndex = uint128(updatedIndex);
1185         }
1186         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1187     }
1188 
1189     /**
1190      * @dev Transfers `tokenId` from `from` to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _transfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) private {
1204         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1205 
1206         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1207             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1208             getApproved(tokenId) == _msgSender());
1209 
1210         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1211         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1212         if (to == address(0)) revert TransferToZeroAddress();
1213 
1214         _beforeTokenTransfers(from, to, tokenId, 1);
1215 
1216         // Clear approvals from the previous owner
1217         _approve(address(0), tokenId, prevOwnership.addr);
1218 
1219         // Underflow of the sender's balance is impossible because we check for
1220         // ownership above and the recipient's balance can't realistically overflow.
1221         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1222         unchecked {
1223             _addressData[from].balance -= 1;
1224             _addressData[to].balance += 1;
1225 
1226             _ownerships[tokenId].addr = to;
1227             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1228 
1229             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1230             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231             uint256 nextTokenId = tokenId + 1;
1232             if (_ownerships[nextTokenId].addr == address(0)) {
1233                 // This will suffice for checking _exists(nextTokenId),
1234                 // as a burned slot cannot contain the zero address.
1235                 if (nextTokenId < _currentIndex) {
1236                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1237                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1238                 }
1239             }
1240         }
1241 
1242         emit Transfer(from, to, tokenId);
1243         _afterTokenTransfers(from, to, tokenId, 1);
1244     }
1245 
1246     /**
1247      * @dev Destroys `tokenId`.
1248      * The approval is cleared when the token is burned.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must exist.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _burn(uint256 tokenId) internal virtual {
1257         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1258 
1259         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1260 
1261         // Clear approvals from the previous owner
1262         _approve(address(0), tokenId, prevOwnership.addr);
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1267         unchecked {
1268             _addressData[prevOwnership.addr].balance -= 1;
1269             _addressData[prevOwnership.addr].numberBurned += 1;
1270 
1271             // Keep track of who burned the token, and the timestamp of burning.
1272             _ownerships[tokenId].addr = prevOwnership.addr;
1273             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1274             _ownerships[tokenId].burned = true;
1275 
1276             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1277             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1278             uint256 nextTokenId = tokenId + 1;
1279             if (_ownerships[nextTokenId].addr == address(0)) {
1280                 // This will suffice for checking _exists(nextTokenId),
1281                 // as a burned slot cannot contain the zero address.
1282                 if (nextTokenId < _currentIndex) {
1283                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1284                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1285                 }
1286             }
1287         }
1288 
1289         emit Transfer(prevOwnership.addr, address(0), tokenId);
1290         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1291 
1292         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1293         unchecked { 
1294             _burnCounter++;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Approve `to` to operate on `tokenId`
1300      *
1301      * Emits a {Approval} event.
1302      */
1303     function _approve(
1304         address to,
1305         uint256 tokenId,
1306         address owner
1307     ) private {
1308         _tokenApprovals[tokenId] = to;
1309         emit Approval(owner, to, tokenId);
1310     }
1311 
1312     /**
1313      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1314      * The call is not executed if the target address is not a contract.
1315      *
1316      * @param from address representing the previous owner of the given token ID
1317      * @param to target address that will receive the tokens
1318      * @param tokenId uint256 ID of the token to be transferred
1319      * @param _data bytes optional data to send along with the call
1320      * @return bool whether the call correctly returned the expected magic value
1321      */
1322     function _checkOnERC721Received(
1323         address from,
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) private returns (bool) {
1328         if (to.isContract()) {
1329             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1330                 return retval == IERC721Receiver(to).onERC721Received.selector;
1331             } catch (bytes memory reason) {
1332                 if (reason.length == 0) {
1333                     revert TransferToNonERC721ReceiverImplementer();
1334                 } else {
1335                     assembly {
1336                         revert(add(32, reason), mload(reason))
1337                     }
1338                 }
1339             }
1340         } else {
1341             return true;
1342         }
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1347      * And also called before burning one token.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, `tokenId` will be burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1369      * minting.
1370      * And also called after one token has been burned.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` has been minted for `to`.
1380      * - When `to` is zero, `tokenId` has been burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _afterTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 }
1390 
1391 // File: contracts/maggies.sol
1392 
1393 
1394 
1395 //shoutout to Daniel Dil for his Square Bears video - i borrowed most the contract off of that. 
1396 //Also shoutout to Azuki for the ERC721A contract
1397 //magpie season is approaching. cunts are gonna swoop on ya soon. watch ya head.
1398 pragma solidity ^0.8.4;
1399 
1400 
1401 
1402 
1403 contract MoonMaggies is ERC721A, Ownable, ReentrancyGuard{
1404     using Strings for uint256;
1405 
1406     uint256 public constant MAX_SUPPLY = 4000;
1407     uint256 public constant MAX_PUBLIC_MINT = 10;
1408     uint256 public PUBLIC_SALE_PRICE = .02 ether;
1409 
1410 
1411     string private  baseTokenUri;
1412     string public   placeholderTokenUri;
1413 
1414     //deploy smart contract, toggle publicSale 
1415     bool public isRevealed;
1416     bool public publicSale;
1417     bool public pause;
1418     bool public teamMinted;
1419 
1420 
1421     mapping(address => uint256) public totalPublicMint;
1422 
1423     constructor() ERC721A("Moon Maggies", "MAGGIE"){
1424 
1425     }
1426     //ensure minting is only called by a user and not a contract
1427     modifier callerIsUser() {
1428         require(tx.origin == msg.sender, "Moon Maggies :: Cannot be called by a contract");
1429         _;
1430     }
1431     //public mint function. Checks if user is a user and not contract. Max user mint is 4. 
1432     function mint(uint256 _quantity) external payable callerIsUser{
1433         require(publicSale, "Sale Not Yet Active.");
1434         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Beyond Max Supply");
1435         require((totalPublicMint[msg.sender] +_quantity) <= MAX_PUBLIC_MINT, "Already minted 4 times!");
1436         require(msg.value >= (PUBLIC_SALE_PRICE * _quantity), "Mint amount below cost price");
1437 
1438         totalPublicMint[msg.sender] += _quantity;
1439         _safeMint(msg.sender, _quantity);
1440     }
1441     //function to allow team to mint before public sale for marketing purposes or to dump on plebs - only 5 allocated to the team
1442     function teamMint() external onlyOwner{
1443         require(!teamMinted, "Moon Maggies :: Team already minted");
1444         teamMinted = true;
1445         _safeMint(msg.sender, 5);
1446     }
1447 
1448         /// @notice Airdrop for a single a wallet.
1449     function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
1450         _safeMint(_receiver, _mintAmount);
1451     }
1452 
1453     /// @notice Airdrops to multiple wallets.
1454     function batchMintForAddress(address[] calldata addresses, uint256[] calldata quantities) external onlyOwner {
1455         uint32 i;
1456         for (i=0; i < addresses.length; ++i) {
1457             _safeMint(addresses[i], quantities[i]);
1458         }
1459     }
1460 
1461     function _baseURI() internal view virtual override returns (string memory) {
1462         return baseTokenUri;
1463     }
1464 
1465     //return uri for certain token - public function to call URI for a specific token. Ensure project is revealed first before giving away URI
1466     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1467         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1468 
1469         uint256 trueId = tokenId + 1;
1470 
1471         if(!isRevealed){
1472             return placeholderTokenUri;
1473         }
1474         //string memory baseURI = _baseURI();
1475         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
1476     }
1477     //Setters
1478     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
1479         baseTokenUri = _baseTokenUri;
1480     }
1481     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
1482         placeholderTokenUri = _placeholderTokenUri;
1483     }
1484 
1485     function togglePause() external onlyOwner{
1486         pause = !pause;
1487     }
1488 
1489     function setSalePrice(uint256 _price) public onlyOwner{
1490         PUBLIC_SALE_PRICE = _price;
1491     }
1492 
1493     function togglePublicSale() external onlyOwner{
1494         publicSale = !publicSale;
1495     }
1496 
1497     function toggleReveal() external onlyOwner{
1498         isRevealed = !isRevealed;
1499     }
1500     //withdrawl
1501     function withdraw() external onlyOwner nonReentrant{
1502         uint256 balance = address(this).balance;
1503         payable(msg.sender).transfer(balance);
1504     }
1505 }