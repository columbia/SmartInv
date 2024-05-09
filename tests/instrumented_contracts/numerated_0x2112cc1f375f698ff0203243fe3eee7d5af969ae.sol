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
702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Enumerable is IERC721 {
715     /**
716      * @dev Returns the total amount of tokens stored by the contract.
717      */
718     function totalSupply() external view returns (uint256);
719 
720     /**
721      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
722      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
723      */
724     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
725 
726     /**
727      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
728      * Use along with {totalSupply} to enumerate all tokens.
729      */
730     function tokenByIndex(uint256 index) external view returns (uint256);
731 }
732 
733 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
734 
735 
736 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Metadata is IERC721 {
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 // File: erc721a/contracts/ERC721A.sol
763 
764 
765 // Creator: Chiru Labs
766 
767 pragma solidity ^0.8.4;
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 error ApprovalCallerNotOwnerNorApproved();
778 error ApprovalQueryForNonexistentToken();
779 error ApproveToCaller();
780 error ApprovalToCurrentOwner();
781 error BalanceQueryForZeroAddress();
782 error MintedQueryForZeroAddress();
783 error BurnedQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
806     using Address for address;
807     using Strings for uint256;
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
827     }
828 
829     // Compiler will pack the following 
830     // _currentIndex and _burnCounter into a single 256bit word.
831     
832     // The tokenId of the next token to be minted.
833     uint128 internal _currentIndex;
834 
835     // The number of tokens burned.
836     uint128 internal _burnCounter;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to ownership details
845     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
846     mapping(uint256 => TokenOwnership) internal _ownerships;
847 
848     // Mapping owner address to address data
849     mapping(address => AddressData) private _addressData;
850 
851     // Mapping from token ID to approved address
852     mapping(uint256 => address) private _tokenApprovals;
853 
854     // Mapping from owner to operator approvals
855     mapping(address => mapping(address => bool)) private _operatorApprovals;
856 
857     constructor(string memory name_, string memory symbol_) {
858         _name = name_;
859         _symbol = symbol_;
860     }
861 
862     /**
863      * @dev See {IERC721Enumerable-totalSupply}.
864      */
865     function totalSupply() public view override returns (uint256) {
866         // Counter underflow is impossible as _burnCounter cannot be incremented
867         // more than _currentIndex times
868         unchecked {
869             return _currentIndex - _burnCounter;    
870         }
871     }
872 
873     /**
874      * @dev See {IERC721Enumerable-tokenByIndex}.
875      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
876      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
877      */
878     function tokenByIndex(uint256 index) public view override returns (uint256) {
879         uint256 numMintedSoFar = _currentIndex;
880         uint256 tokenIdsIdx;
881 
882         // Counter overflow is impossible as the loop breaks when
883         // uint256 i is equal to another uint256 numMintedSoFar.
884         unchecked {
885             for (uint256 i; i < numMintedSoFar; i++) {
886                 TokenOwnership memory ownership = _ownerships[i];
887                 if (!ownership.burned) {
888                     if (tokenIdsIdx == index) {
889                         return i;
890                     }
891                     tokenIdsIdx++;
892                 }
893             }
894         }
895         revert TokenIndexOutOfBounds();
896     }
897 
898     /**
899      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
900      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
901      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
902      */
903     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
904         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
905         uint256 numMintedSoFar = _currentIndex;
906         uint256 tokenIdsIdx;
907         address currOwnershipAddr;
908 
909         // Counter overflow is impossible as the loop breaks when
910         // uint256 i is equal to another uint256 numMintedSoFar.
911         unchecked {
912             for (uint256 i; i < numMintedSoFar; i++) {
913                 TokenOwnership memory ownership = _ownerships[i];
914                 if (ownership.burned) {
915                     continue;
916                 }
917                 if (ownership.addr != address(0)) {
918                     currOwnershipAddr = ownership.addr;
919                 }
920                 if (currOwnershipAddr == owner) {
921                     if (tokenIdsIdx == index) {
922                         return i;
923                     }
924                     tokenIdsIdx++;
925                 }
926             }
927         }
928 
929         // Execution should never reach this point.
930         revert();
931     }
932 
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
937         return
938             interfaceId == type(IERC721).interfaceId ||
939             interfaceId == type(IERC721Metadata).interfaceId ||
940             interfaceId == type(IERC721Enumerable).interfaceId ||
941             super.supportsInterface(interfaceId);
942     }
943 
944     /**
945      * @dev See {IERC721-balanceOf}.
946      */
947     function balanceOf(address owner) public view override returns (uint256) {
948         if (owner == address(0)) revert BalanceQueryForZeroAddress();
949         return uint256(_addressData[owner].balance);
950     }
951 
952     function _numberMinted(address owner) internal view returns (uint256) {
953         if (owner == address(0)) revert MintedQueryForZeroAddress();
954         return uint256(_addressData[owner].numberMinted);
955     }
956 
957     function _numberBurned(address owner) internal view returns (uint256) {
958         if (owner == address(0)) revert BurnedQueryForZeroAddress();
959         return uint256(_addressData[owner].numberBurned);
960     }
961 
962     /**
963      * Gas spent here starts off proportional to the maximum mint batch size.
964      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
965      */
966     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
967         uint256 curr = tokenId;
968 
969         unchecked {
970             if (curr < _currentIndex) {
971                 TokenOwnership memory ownership = _ownerships[curr];
972                 if (!ownership.burned) {
973                     if (ownership.addr != address(0)) {
974                         return ownership;
975                     }
976                     // Invariant: 
977                     // There will always be an ownership that has an address and is not burned 
978                     // before an ownership that does not have an address and is not burned.
979                     // Hence, curr will not underflow.
980                     while (true) {
981                         curr--;
982                         ownership = _ownerships[curr];
983                         if (ownership.addr != address(0)) {
984                             return ownership;
985                         }
986                     }
987                 }
988             }
989         }
990         revert OwnerQueryForNonexistentToken();
991     }
992 
993     /**
994      * @dev See {IERC721-ownerOf}.
995      */
996     function ownerOf(uint256 tokenId) public view override returns (address) {
997         return ownershipOf(tokenId).addr;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-name}.
1002      */
1003     function name() public view virtual override returns (string memory) {
1004         return _name;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-symbol}.
1009      */
1010     function symbol() public view virtual override returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1018         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1019 
1020         string memory baseURI = _baseURI();
1021         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1022     }
1023 
1024     /**
1025      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1026      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1027      * by default, can be overriden in child contracts.
1028      */
1029     function _baseURI() internal view virtual returns (string memory) {
1030         return '';
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-approve}.
1035      */
1036     function approve(address to, uint256 tokenId) public override {
1037         address owner = ERC721A.ownerOf(tokenId);
1038         if (to == owner) revert ApprovalToCurrentOwner();
1039 
1040         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1041             revert ApprovalCallerNotOwnerNorApproved();
1042         }
1043 
1044         _approve(to, tokenId, owner);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-getApproved}.
1049      */
1050     function getApproved(uint256 tokenId) public view override returns (address) {
1051         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1052 
1053         return _tokenApprovals[tokenId];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-setApprovalForAll}.
1058      */
1059     function setApprovalForAll(address operator, bool approved) public override {
1060         if (operator == _msgSender()) revert ApproveToCaller();
1061 
1062         _operatorApprovals[_msgSender()][operator] = approved;
1063         emit ApprovalForAll(_msgSender(), operator, approved);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-isApprovedForAll}.
1068      */
1069     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1070         return _operatorApprovals[owner][operator];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-transferFrom}.
1075      */
1076     function transferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         _transfer(from, to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-safeTransferFrom}.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) public virtual override {
1092         safeTransferFrom(from, to, tokenId, '');
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-safeTransferFrom}.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) public virtual override {
1104         _transfer(from, to, tokenId);
1105         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1106             revert TransferToNonERC721ReceiverImplementer();
1107         }
1108     }
1109 
1110     /**
1111      * @dev Returns whether `tokenId` exists.
1112      *
1113      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1114      *
1115      * Tokens start existing when they are minted (`_mint`),
1116      */
1117     function _exists(uint256 tokenId) internal view returns (bool) {
1118         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1119     }
1120 
1121     function _safeMint(address to, uint256 quantity) internal {
1122         _safeMint(to, quantity, '');
1123     }
1124 
1125     /**
1126      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _safeMint(
1136         address to,
1137         uint256 quantity,
1138         bytes memory _data
1139     ) internal {
1140         _mint(to, quantity, _data, true);
1141     }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _mint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data,
1157         bool safe
1158     ) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) revert MintZeroQuantity();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are incredibly unrealistic.
1166         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1167         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1168         unchecked {
1169             _addressData[to].balance += uint64(quantity);
1170             _addressData[to].numberMinted += uint64(quantity);
1171 
1172             _ownerships[startTokenId].addr = to;
1173             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             uint256 updatedIndex = startTokenId;
1176 
1177             for (uint256 i; i < quantity; i++) {
1178                 emit Transfer(address(0), to, updatedIndex);
1179                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1180                     revert TransferToNonERC721ReceiverImplementer();
1181                 }
1182                 updatedIndex++;
1183             }
1184 
1185             _currentIndex = uint128(updatedIndex);
1186         }
1187         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1188     }
1189 
1190     /**
1191      * @dev Transfers `tokenId` from `from` to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `to` cannot be the zero address.
1196      * - `tokenId` token must be owned by `from`.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _transfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) private {
1205         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1206 
1207         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1208             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1209             getApproved(tokenId) == _msgSender());
1210 
1211         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1212         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1213         if (to == address(0)) revert TransferToZeroAddress();
1214 
1215         _beforeTokenTransfers(from, to, tokenId, 1);
1216 
1217         // Clear approvals from the previous owner
1218         _approve(address(0), tokenId, prevOwnership.addr);
1219 
1220         // Underflow of the sender's balance is impossible because we check for
1221         // ownership above and the recipient's balance can't realistically overflow.
1222         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1223         unchecked {
1224             _addressData[from].balance -= 1;
1225             _addressData[to].balance += 1;
1226 
1227             _ownerships[tokenId].addr = to;
1228             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1229 
1230             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1231             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1232             uint256 nextTokenId = tokenId + 1;
1233             if (_ownerships[nextTokenId].addr == address(0)) {
1234                 // This will suffice for checking _exists(nextTokenId),
1235                 // as a burned slot cannot contain the zero address.
1236                 if (nextTokenId < _currentIndex) {
1237                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1238                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1239                 }
1240             }
1241         }
1242 
1243         emit Transfer(from, to, tokenId);
1244         _afterTokenTransfers(from, to, tokenId, 1);
1245     }
1246 
1247     /**
1248      * @dev Destroys `tokenId`.
1249      * The approval is cleared when the token is burned.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _burn(uint256 tokenId) internal virtual {
1258         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1259 
1260         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId, prevOwnership.addr);
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1268         unchecked {
1269             _addressData[prevOwnership.addr].balance -= 1;
1270             _addressData[prevOwnership.addr].numberBurned += 1;
1271 
1272             // Keep track of who burned the token, and the timestamp of burning.
1273             _ownerships[tokenId].addr = prevOwnership.addr;
1274             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1275             _ownerships[tokenId].burned = true;
1276 
1277             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1278             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1279             uint256 nextTokenId = tokenId + 1;
1280             if (_ownerships[nextTokenId].addr == address(0)) {
1281                 // This will suffice for checking _exists(nextTokenId),
1282                 // as a burned slot cannot contain the zero address.
1283                 if (nextTokenId < _currentIndex) {
1284                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1285                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1286                 }
1287             }
1288         }
1289 
1290         emit Transfer(prevOwnership.addr, address(0), tokenId);
1291         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1292 
1293         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1294         unchecked { 
1295             _burnCounter++;
1296         }
1297     }
1298 
1299     /**
1300      * @dev Approve `to` to operate on `tokenId`
1301      *
1302      * Emits a {Approval} event.
1303      */
1304     function _approve(
1305         address to,
1306         uint256 tokenId,
1307         address owner
1308     ) private {
1309         _tokenApprovals[tokenId] = to;
1310         emit Approval(owner, to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1315      * The call is not executed if the target address is not a contract.
1316      *
1317      * @param from address representing the previous owner of the given token ID
1318      * @param to target address that will receive the tokens
1319      * @param tokenId uint256 ID of the token to be transferred
1320      * @param _data bytes optional data to send along with the call
1321      * @return bool whether the call correctly returned the expected magic value
1322      */
1323     function _checkOnERC721Received(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory _data
1328     ) private returns (bool) {
1329         if (to.isContract()) {
1330             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1331                 return retval == IERC721Receiver(to).onERC721Received.selector;
1332             } catch (bytes memory reason) {
1333                 if (reason.length == 0) {
1334                     revert TransferToNonERC721ReceiverImplementer();
1335                 } else {
1336                     assembly {
1337                         revert(add(32, reason), mload(reason))
1338                     }
1339                 }
1340             }
1341         } else {
1342             return true;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1348      * And also called before burning one token.
1349      *
1350      * startTokenId - the first token id to be transferred
1351      * quantity - the amount to be transferred
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, `tokenId` will be burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      * And also called after one token has been burned.
1372      *
1373      * startTokenId - the first token id to be transferred
1374      * quantity - the amount to be transferred
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` has been minted for `to`.
1381      * - When `to` is zero, `tokenId` has been burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 }
1391 
1392 // File: contracts/Fridgits.sol
1393 
1394 
1395 pragma solidity ^0.8.4;
1396 
1397 
1398 
1399 
1400 
1401 contract Fridgits is ERC721A, Ownable {
1402     using Strings for uint256;
1403 
1404     string public baseURI;
1405     string public baseExtension = ".json";
1406     string public notRevealedUri;
1407     uint256 public cost = 0.05 ether;
1408     uint256 public maxSupply = 10000;
1409     uint256 public maxMintAmount = 100;
1410     uint256 public nftPerAddressLimit = 100;
1411     bool public paused = false;
1412     bool public revealed = false;
1413     bool public onlyWhitelisted = true;
1414     address[] public whitelistedAddresses;
1415 
1416     mapping(address => uint256) public addressMintedBalance;
1417     constructor(
1418         string memory _name,
1419         string memory _symbol,
1420         string memory _initBaseURI,
1421         string memory _initNotRevealedUri
1422     ) ERC721A(_name, _symbol) {
1423         setBaseURI(_initBaseURI);
1424         setNotRevealedURI(_initNotRevealedUri);
1425     }
1426 
1427     // internal
1428     function _baseURI() internal view virtual override returns (string memory) 
1429     {
1430         return baseURI;
1431     }
1432 
1433     // public
1434     function mint(uint256 _mintAmount) public payable 
1435     {
1436         require(!paused, "the contract is paused");
1437         uint256 supply = totalSupply();
1438         require(_mintAmount > 0, "need to mint at least 1 NFT");
1439         require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1440         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1441 
1442         if (msg.sender != owner()) {
1443             if(onlyWhitelisted == true) {
1444                 require(isWhitelisted(msg.sender), "user is not whitelisted");
1445                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1446                 require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1447             }
1448             require(msg.value >= cost * _mintAmount, "insufficient funds");
1449         }
1450         
1451         _safeMint(msg.sender, _mintAmount);
1452     }
1453 
1454     function isWhitelisted(address _user) public view returns (bool) 
1455     {
1456         for (uint i = 0; i < whitelistedAddresses.length; i++) {
1457             if (whitelistedAddresses[i] == _user) {
1458                 return true;
1459             }
1460         }
1461         return false;
1462     }
1463 
1464     function walletOfOwner(address _owner)
1465         public
1466         view
1467         returns (uint256[] memory)
1468     {
1469         uint256 ownerTokenCount = balanceOf(_owner);
1470         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1471         for (uint256 i; i < ownerTokenCount; i++) {
1472         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1473         }
1474         return tokenIds;
1475     }
1476 
1477     function tokenURI(uint256 tokenId)
1478         public
1479         view
1480         virtual
1481         override
1482         returns (string memory)
1483     {
1484         require(
1485         _exists(tokenId),
1486         "ERC721Metadata: URI query for nonexistent token"
1487         );
1488         
1489         if(revealed == false) {
1490             return notRevealedUri;
1491         }
1492 
1493         string memory currentBaseURI = _baseURI();
1494         return bytes(currentBaseURI).length > 0
1495             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1496             : "";
1497     }
1498 
1499     //only owner
1500     function reveal() public onlyOwner {
1501         revealed = true;
1502     }
1503     
1504     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1505         nftPerAddressLimit = _limit;
1506     }
1507     
1508     function setCost(uint256 _newCost) public onlyOwner {
1509         cost = _newCost;
1510     }
1511 
1512     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1513         maxMintAmount = _newmaxMintAmount;
1514     }
1515 
1516     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1517         baseURI = _newBaseURI;
1518     }
1519 
1520     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1521         baseExtension = _newBaseExtension;
1522     }
1523     
1524     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1525         notRevealedUri = _notRevealedURI;
1526     }
1527 
1528     function pause(bool _state) public onlyOwner {
1529         paused = _state;
1530     }
1531     
1532     function setOnlyWhitelisted(bool _state) public onlyOwner {
1533         onlyWhitelisted = _state;
1534     }
1535     
1536     function whitelistUsers(address[] calldata _users) public onlyOwner {
1537         delete whitelistedAddresses;
1538         whitelistedAddresses = _users;
1539     }
1540 
1541     function withdraw() public payable onlyOwner {
1542         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1543         require(os);
1544     }
1545 }