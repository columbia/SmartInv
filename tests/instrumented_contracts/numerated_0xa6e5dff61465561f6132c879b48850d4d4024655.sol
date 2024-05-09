1 // SPDX-License-Identifier: MIT
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
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
704 
705 
706 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Enumerable is IERC721 {
716     /**
717      * @dev Returns the total amount of tokens stored by the contract.
718      */
719     function totalSupply() external view returns (uint256);
720 
721     /**
722      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
723      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
724      */
725     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
726 
727     /**
728      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
729      * Use along with {totalSupply} to enumerate all tokens.
730      */
731     function tokenByIndex(uint256 index) external view returns (uint256);
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
744  * @dev See https://eips.ethereum.org/EIPS/eip-721
745  */
746 interface IERC721Metadata is IERC721 {
747     /**
748      * @dev Returns the token collection name.
749      */
750     function name() external view returns (string memory);
751 
752     /**
753      * @dev Returns the token collection symbol.
754      */
755     function symbol() external view returns (string memory);
756 
757     /**
758      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
759      */
760     function tokenURI(uint256 tokenId) external view returns (string memory);
761 }
762 
763 // File: erc721a/contracts/ERC721A.sol
764 
765 
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 error ApprovalCallerNotOwnerNorApproved();
779 error ApprovalQueryForNonexistentToken();
780 error ApproveToCaller();
781 error ApprovalToCurrentOwner();
782 error BalanceQueryForZeroAddress();
783 error MintedQueryForZeroAddress();
784 error BurnedQueryForZeroAddress();
785 error AuxQueryForZeroAddress();
786 error MintToZeroAddress();
787 error MintZeroQuantity();
788 error OwnerIndexOutOfBounds();
789 error OwnerQueryForNonexistentToken();
790 error TokenIndexOutOfBounds();
791 error TransferCallerNotOwnerNorApproved();
792 error TransferFromIncorrectOwner();
793 error TransferToNonERC721ReceiverImplementer();
794 error TransferToZeroAddress();
795 error URIQueryForNonexistentToken();
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata extension. Built to optimize for lower gas during batch mints.
800  *
801  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
802  *
803  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
804  *
805  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
806  */
807 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
808     using Address for address;
809     using Strings for uint256;
810 
811     // Compiler will pack this into a single 256bit word.
812     struct TokenOwnership {
813         // The address of the owner.
814         address addr;
815         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
816         uint64 startTimestamp;
817         // Whether the token has been burned.
818         bool burned;
819     }
820 
821     // Compiler will pack this into a single 256bit word.
822     struct AddressData {
823         // Realistically, 2**64-1 is more than enough.
824         uint64 balance;
825         // Keeps track of mint count with minimal overhead for tokenomics.
826         uint64 numberMinted;
827         // Keeps track of burn count with minimal overhead for tokenomics.
828         uint64 numberBurned;
829         // For miscellaneous variable(s) pertaining to the address
830         // (e.g. number of whitelist mint slots used).
831         // If there are multiple variables, please pack them into a uint64.
832         uint64 aux;
833     }
834 
835     // The tokenId of the next token to be minted.
836     uint256 internal _currentIndex;
837 
838     // The number of tokens burned.
839     uint256 internal _burnCounter;
840 
841     // Token name
842     string private _name;
843 
844     // Token symbol
845     string private _symbol;
846 
847     // Mapping from token ID to ownership details
848     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
849     mapping(uint256 => TokenOwnership) internal _ownerships;
850 
851     // Mapping owner address to address data
852     mapping(address => AddressData) private _addressData;
853 
854     // Mapping from token ID to approved address
855     mapping(uint256 => address) private _tokenApprovals;
856 
857     // Mapping from owner to operator approvals
858     mapping(address => mapping(address => bool)) private _operatorApprovals;
859 
860     constructor(string memory name_, string memory symbol_) {
861         _name = name_;
862         _symbol = symbol_;
863         _currentIndex = _startTokenId();
864     }
865 
866     /**
867      * To change the starting tokenId, please override this function.
868      */
869     function _startTokenId() internal view virtual returns (uint256) {
870         return 0;
871     }
872 
873     /**
874      * @dev See {IERC721Enumerable-totalSupply}.
875      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
876      */
877     function totalSupply() public view returns (uint256) {
878         // Counter underflow is impossible as _burnCounter cannot be incremented
879         // more than _currentIndex - _startTokenId() times
880         unchecked {
881             return _currentIndex - _burnCounter - _startTokenId();
882         }
883     }
884 
885     /**
886      * Returns the total amount of tokens minted in the contract.
887      */
888     function _totalMinted() internal view returns (uint256) {
889         // Counter underflow is impossible as _currentIndex does not decrement,
890         // and it is initialized to _startTokenId()
891         unchecked {
892             return _currentIndex - _startTokenId();
893         }
894     }
895 
896     /**
897      * @dev See {IERC165-supportsInterface}.
898      */
899     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
900         return
901             interfaceId == type(IERC721).interfaceId ||
902             interfaceId == type(IERC721Metadata).interfaceId ||
903             super.supportsInterface(interfaceId);
904     }
905 
906     /**
907      * @dev See {IERC721-balanceOf}.
908      */
909     function balanceOf(address owner) public view override returns (uint256) {
910         if (owner == address(0)) revert BalanceQueryForZeroAddress();
911         return uint256(_addressData[owner].balance);
912     }
913 
914     /**
915      * Returns the number of tokens minted by `owner`.
916      */
917     function _numberMinted(address owner) internal view returns (uint256) {
918         if (owner == address(0)) revert MintedQueryForZeroAddress();
919         return uint256(_addressData[owner].numberMinted);
920     }
921 
922     /**
923      * Returns the number of tokens burned by or on behalf of `owner`.
924      */
925     function _numberBurned(address owner) internal view returns (uint256) {
926         if (owner == address(0)) revert BurnedQueryForZeroAddress();
927         return uint256(_addressData[owner].numberBurned);
928     }
929 
930     /**
931      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
932      */
933     function _getAux(address owner) internal view returns (uint64) {
934         if (owner == address(0)) revert AuxQueryForZeroAddress();
935         return _addressData[owner].aux;
936     }
937 
938     /**
939      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
940      * If there are multiple variables, please pack them into a uint64.
941      */
942     function _setAux(address owner, uint64 aux) internal {
943         if (owner == address(0)) revert AuxQueryForZeroAddress();
944         _addressData[owner].aux = aux;
945     }
946 
947     /**
948      * Gas spent here starts off proportional to the maximum mint batch size.
949      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
950      */
951     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
952         uint256 curr = tokenId;
953 
954         unchecked {
955             if (_startTokenId() <= curr && curr < _currentIndex) {
956                 TokenOwnership memory ownership = _ownerships[curr];
957                 if (!ownership.burned) {
958                     if (ownership.addr != address(0)) {
959                         return ownership;
960                     }
961                     // Invariant:
962                     // There will always be an ownership that has an address and is not burned
963                     // before an ownership that does not have an address and is not burned.
964                     // Hence, curr will not underflow.
965                     while (true) {
966                         curr--;
967                         ownership = _ownerships[curr];
968                         if (ownership.addr != address(0)) {
969                             return ownership;
970                         }
971                     }
972                 }
973             }
974         }
975         revert OwnerQueryForNonexistentToken();
976     }
977 
978     /**
979      * @dev See {IERC721-ownerOf}.
980      */
981     function ownerOf(uint256 tokenId) public view override returns (address) {
982         return ownershipOf(tokenId).addr;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-name}.
987      */
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-symbol}.
994      */
995     function symbol() public view virtual override returns (string memory) {
996         return _symbol;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-tokenURI}.
1001      */
1002     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1003         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1004 
1005         string memory baseURI = _baseURI();
1006         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1007     }
1008 
1009     /**
1010      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1011      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1012      * by default, can be overriden in child contracts.
1013      */
1014     function _baseURI() internal view virtual returns (string memory) {
1015         return '';
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-approve}.
1020      */
1021     function approve(address to, uint256 tokenId) public override {
1022         address owner = ERC721A.ownerOf(tokenId);
1023         if (to == owner) revert ApprovalToCurrentOwner();
1024 
1025         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1026             revert ApprovalCallerNotOwnerNorApproved();
1027         }
1028 
1029         _approve(to, tokenId, owner);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-getApproved}.
1034      */
1035     function getApproved(uint256 tokenId) public view override returns (address) {
1036         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1037 
1038         return _tokenApprovals[tokenId];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-setApprovalForAll}.
1043      */
1044     function setApprovalForAll(address operator, bool approved) public override {
1045         if (operator == _msgSender()) revert ApproveToCaller();
1046 
1047         _operatorApprovals[_msgSender()][operator] = approved;
1048         emit ApprovalForAll(_msgSender(), operator, approved);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-isApprovedForAll}.
1053      */
1054     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1055         return _operatorApprovals[owner][operator];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-transferFrom}.
1060      */
1061     function transferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) public virtual override {
1066         _transfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-safeTransferFrom}.
1071      */
1072     function safeTransferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) public virtual override {
1077         safeTransferFrom(from, to, tokenId, '');
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) public virtual override {
1089         _transfer(from, to, tokenId);
1090         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1091             revert TransferToNonERC721ReceiverImplementer();
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns whether `tokenId` exists.
1097      *
1098      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099      *
1100      * Tokens start existing when they are minted (`_mint`),
1101      */
1102     function _exists(uint256 tokenId) internal view returns (bool) {
1103         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1104             !_ownerships[tokenId].burned;
1105     }
1106 
1107     function _safeMint(address to, uint256 quantity) internal {
1108         _safeMint(to, quantity, '');
1109     }
1110 
1111     /**
1112      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _safeMint(
1122         address to,
1123         uint256 quantity,
1124         bytes memory _data
1125     ) internal {
1126         _mint(to, quantity, _data, true);
1127     }
1128 
1129     /**
1130      * @dev Mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `quantity` must be greater than 0.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _mint(
1140         address to,
1141         uint256 quantity,
1142         bytes memory _data,
1143         bool safe
1144     ) internal {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are incredibly unrealistic.
1152         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1153         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             if (safe && to.isContract()) {
1165                 do {
1166                     emit Transfer(address(0), to, updatedIndex);
1167                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (updatedIndex != end);
1171                 // Reentrancy protection
1172                 if (_currentIndex != startTokenId) revert();
1173             } else {
1174                 do {
1175                     emit Transfer(address(0), to, updatedIndex++);
1176                 } while (updatedIndex != end);
1177             }
1178             _currentIndex = updatedIndex;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Transfers `tokenId` from `from` to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `to` cannot be the zero address.
1189      * - `tokenId` token must be owned by `from`.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _transfer(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) private {
1198         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1199 
1200         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1201             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1202             getApproved(tokenId) == _msgSender());
1203 
1204         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1205         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1206         if (to == address(0)) revert TransferToZeroAddress();
1207 
1208         _beforeTokenTransfers(from, to, tokenId, 1);
1209 
1210         // Clear approvals from the previous owner
1211         _approve(address(0), tokenId, prevOwnership.addr);
1212 
1213         // Underflow of the sender's balance is impossible because we check for
1214         // ownership above and the recipient's balance can't realistically overflow.
1215         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1216         unchecked {
1217             _addressData[from].balance -= 1;
1218             _addressData[to].balance += 1;
1219 
1220             _ownerships[tokenId].addr = to;
1221             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1222 
1223             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1224             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1225             uint256 nextTokenId = tokenId + 1;
1226             if (_ownerships[nextTokenId].addr == address(0)) {
1227                 // This will suffice for checking _exists(nextTokenId),
1228                 // as a burned slot cannot contain the zero address.
1229                 if (nextTokenId < _currentIndex) {
1230                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1231                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1232                 }
1233             }
1234         }
1235 
1236         emit Transfer(from, to, tokenId);
1237         _afterTokenTransfers(from, to, tokenId, 1);
1238     }
1239 
1240     /**
1241      * @dev Destroys `tokenId`.
1242      * The approval is cleared when the token is burned.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _burn(uint256 tokenId) internal virtual {
1251         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1252 
1253         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId, prevOwnership.addr);
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1261         unchecked {
1262             _addressData[prevOwnership.addr].balance -= 1;
1263             _addressData[prevOwnership.addr].numberBurned += 1;
1264 
1265             // Keep track of who burned the token, and the timestamp of burning.
1266             _ownerships[tokenId].addr = prevOwnership.addr;
1267             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1268             _ownerships[tokenId].burned = true;
1269 
1270             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1271             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1272             uint256 nextTokenId = tokenId + 1;
1273             if (_ownerships[nextTokenId].addr == address(0)) {
1274                 // This will suffice for checking _exists(nextTokenId),
1275                 // as a burned slot cannot contain the zero address.
1276                 if (nextTokenId < _currentIndex) {
1277                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1278                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1279                 }
1280             }
1281         }
1282 
1283         emit Transfer(prevOwnership.addr, address(0), tokenId);
1284         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1285 
1286         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1287         unchecked {
1288             _burnCounter++;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Approve `to` to operate on `tokenId`
1294      *
1295      * Emits a {Approval} event.
1296      */
1297     function _approve(
1298         address to,
1299         uint256 tokenId,
1300         address owner
1301     ) private {
1302         _tokenApprovals[tokenId] = to;
1303         emit Approval(owner, to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1308      *
1309      * @param from address representing the previous owner of the given token ID
1310      * @param to target address that will receive the tokens
1311      * @param tokenId uint256 ID of the token to be transferred
1312      * @param _data bytes optional data to send along with the call
1313      * @return bool whether the call correctly returned the expected magic value
1314      */
1315     function _checkContractOnERC721Received(
1316         address from,
1317         address to,
1318         uint256 tokenId,
1319         bytes memory _data
1320     ) private returns (bool) {
1321         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1322             return retval == IERC721Receiver(to).onERC721Received.selector;
1323         } catch (bytes memory reason) {
1324             if (reason.length == 0) {
1325                 revert TransferToNonERC721ReceiverImplementer();
1326             } else {
1327                 assembly {
1328                     revert(add(32, reason), mload(reason))
1329                 }
1330             }
1331         }
1332     }
1333 
1334     /**
1335      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1336      * And also called before burning one token.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` will be minted for `to`.
1346      * - When `to` is zero, `tokenId` will be burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _beforeTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1358      * minting.
1359      * And also called after one token has been burned.
1360      *
1361      * startTokenId - the first token id to be transferred
1362      * quantity - the amount to be transferred
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` has been minted for `to`.
1369      * - When `to` is zero, `tokenId` has been burned by `from`.
1370      * - `from` and `to` are never both zero.
1371      */
1372     function _afterTokenTransfers(
1373         address from,
1374         address to,
1375         uint256 startTokenId,
1376         uint256 quantity
1377     ) internal virtual {}
1378 }
1379 
1380 // File: contracts/OxSpaceDoodles.sol
1381 
1382 
1383 
1384 pragma solidity ^0.8.4;
1385 
1386 
1387 
1388 
1389 contract OxSpaceDoodles is ERC721A, Ownable, ReentrancyGuard {
1390     using Strings for uint256;
1391 
1392     uint256 public PRICE;
1393     uint256 public MAX_SUPPLY;
1394     string private BASE_URI;
1395     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1396     uint256 public MAX_MINT_AMOUNT_PER_TX;
1397     bool public IS_SALE_ACTIVE;
1398     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1399     bool public METADATA_FROZEN;
1400 
1401     mapping(address => uint256) private freeMintCountMap;
1402 
1403     constructor(
1404         uint256 price,
1405         uint256 maxSupply,
1406         string memory baseUri,
1407         uint256 freeMintAllowance,
1408         uint256 maxMintPerTx,
1409         bool isSaleActive,
1410         uint256 freeMintIsAllowedUntil
1411     ) ERC721A("0xSpaceDoodles", "0xSPCDDL") {
1412         PRICE = price;
1413         MAX_SUPPLY = maxSupply;
1414         BASE_URI = baseUri;
1415         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1416         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1417         IS_SALE_ACTIVE = isSaleActive;
1418         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1419     }
1420 
1421     /** FREE MINT **/
1422 
1423     function updateFreeMintCount(address minter, uint256 count) private {
1424         freeMintCountMap[minter] += count;
1425     }
1426 
1427     /** GETTERS **/
1428 
1429     function _baseURI() internal view virtual override returns (string memory) {
1430         return BASE_URI;
1431     }
1432 
1433     /** SETTERS **/
1434 
1435     function setPrice(uint256 customPrice) external onlyOwner {
1436         PRICE = customPrice;
1437     }
1438 
1439     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1440         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1441         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1442         MAX_SUPPLY = newMaxSupply;
1443     }
1444 
1445     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1446         require(!METADATA_FROZEN, "Metadata frozen!");
1447         BASE_URI = customBaseURI_;
1448     }
1449 
1450     function setFreeMintAllowance(uint256 freeMintAllowance)
1451         external
1452         onlyOwner
1453     {
1454         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1455     }
1456 
1457     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1458         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1459     }
1460 
1461     function setSaleActive(bool saleIsActive) external onlyOwner {
1462         IS_SALE_ACTIVE = saleIsActive;
1463     }
1464 
1465     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1466         external
1467         onlyOwner
1468     {
1469         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1470     }
1471 
1472     function freezeMetadata() external onlyOwner {
1473         METADATA_FROZEN = true;
1474     }
1475 
1476     /** MINT **/
1477 
1478     modifier mintCompliance(uint256 _mintAmount) {
1479         require(
1480             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1481             "Invalid mint amount!"
1482         );
1483         require(
1484             _currentIndex + _mintAmount <= MAX_SUPPLY,
1485             "Max supply exceeded!"
1486         );
1487         _;
1488     }
1489 
1490     function mint(uint256 _mintAmount)
1491         public
1492         payable
1493         mintCompliance(_mintAmount)
1494     {
1495         require(IS_SALE_ACTIVE, "Sale is not active!");
1496 
1497         uint256 price = PRICE * _mintAmount;
1498 
1499         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1500             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1501                 freeMintCountMap[msg.sender];
1502             if (remainingFreeMint > 0) {
1503                 if (_mintAmount >= remainingFreeMint) {
1504                     price -= remainingFreeMint * PRICE;
1505                     updateFreeMintCount(msg.sender, remainingFreeMint);
1506                 } else {
1507                     price -= _mintAmount * PRICE;
1508                     updateFreeMintCount(msg.sender, _mintAmount);
1509                 }
1510             }
1511         }
1512 
1513         require(msg.value >= price, "Insufficient funds!");
1514 
1515         _safeMint(msg.sender, _mintAmount);
1516     }
1517 
1518     function mintOwner(address _to, uint256 _mintAmount)
1519         public
1520         mintCompliance(_mintAmount)
1521         onlyOwner
1522     {
1523         _safeMint(_to, _mintAmount);
1524     }
1525 
1526     /** PAYOUT **/
1527 
1528     address private constant payoutAddress1 =
1529         0xa4A54da531ED37d5F84CF0987b70E600D4B4E55b;
1530     address private constant payoutAddress2 =
1531         0x96415B406f71Fbf7Ef093EA3F435C2daFd1A81c8;
1532 
1533     function withdraw() public onlyOwner nonReentrant {
1534         uint256 balance = address(this).balance;
1535         Address.sendValue(payable(payoutAddress1), balance / 2);
1536         Address.sendValue(payable(payoutAddress2), balance / 2);
1537     }
1538 }