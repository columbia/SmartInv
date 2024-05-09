1 //SPDX-License-Identifier: UNLISENCED
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and making it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev String operations.
72  */
73 library Strings {
74     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
78      */
79     function toString(uint256 value) internal pure returns (string memory) {
80         // Inspired by OraclizeAPI's implementation - MIT licence
81         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
82 
83         if (value == 0) {
84             return "0";
85         }
86         uint256 temp = value;
87         uint256 digits;
88         while (temp != 0) {
89             digits++;
90             temp /= 10;
91         }
92         bytes memory buffer = new bytes(digits);
93         while (value != 0) {
94             digits -= 1;
95             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
96             value /= 10;
97         }
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
103      */
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
119      */
120     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
121         bytes memory buffer = new bytes(2 * length + 2);
122         buffer[0] = "0";
123         buffer[1] = "x";
124         for (uint256 i = 2 * length + 1; i > 1; --i) {
125             buffer[i] = _HEX_SYMBOLS[value & 0xf];
126             value >>= 4;
127         }
128         require(value == 0, "Strings: hex length insufficient");
129         return string(buffer);
130     }
131 }
132 
133 // File: @openzeppelin/contracts/utils/Context.sol
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Provides information about the current execution context, including the
141  * sender of the transaction and its data. While these are generally available
142  * via msg.sender and msg.data, they should not be accessed in such a direct
143  * manner, since when dealing with meta-transactions the account sending and
144  * paying for execution may not be the actual sender (as far as an application
145  * is concerned).
146  *
147  * This contract is only required for intermediate, library-like contracts.
148  */
149 abstract contract Context {
150     function _msgSender() internal view virtual returns (address) {
151         return msg.sender;
152     }
153 
154     function _msgData() internal view virtual returns (bytes calldata) {
155         return msg.data;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/access/Ownable.sol
160 
161 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev Contract module which provides a basic access control mechanism, where
167  * there is an account (an owner) that can be granted exclusive access to
168  * specific functions.
169  *
170  * By default, the owner account will be the one that deploys the contract. This
171  * can later be changed with {transferOwnership}.
172  *
173  * This module is used through inheritance. It will make available the modifier
174  * `onlyOwner`, which can be applied to your functions to restrict their use to
175  * the owner.
176  */
177 abstract contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     /**
183      * @dev Initializes the contract setting the deployer as the initial owner.
184      */
185     constructor() {
186         _transferOwnership(_msgSender());
187     }
188 
189     /**
190      * @dev Returns the address of the current owner.
191      */
192     function owner() public view virtual returns (address) {
193         return _owner;
194     }
195 
196     /**
197      * @dev Throws if called by any account other than the owner.
198      */
199     modifier onlyOwner() {
200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     /**
205      * @dev Leaves the contract without owner. It will not be possible to call
206      * `onlyOwner` functions anymore. Can only be called by the current owner.
207      *
208      * NOTE: Renouncing ownership will leave the contract without an owner,
209      * thereby removing any functionality that is only available to the owner.
210      */
211     function renounceOwnership() public virtual onlyOwner {
212         _transferOwnership(address(0));
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Can only be called by the current owner.
218      */
219     function transferOwnership(address newOwner) public virtual onlyOwner {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         _transferOwnership(newOwner);
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Internal function without access restriction.
227      */
228     function _transferOwnership(address newOwner) internal virtual {
229         address oldOwner = _owner;
230         _owner = newOwner;
231         emit OwnershipTransferred(oldOwner, newOwner);
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
238 
239 pragma solidity ^0.8.1;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      *
262      * [IMPORTANT]
263      * ====
264      * You shouldn't rely on `isContract` to protect against flash loan attacks!
265      *
266      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
267      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
268      * constructor.
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize/address.code.length, which returns 0
273         // for contracts in construction, since the code is only stored at the end
274         // of the constructor execution.
275 
276         return account.code.length > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 
461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @title ERC721 token receiver interface
467  * @dev Interface for any contract that wants to support safeTransfers
468  * from ERC721 asset contracts.
469  */
470 interface IERC721Receiver {
471     /**
472      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
473      * by `operator` from `from`, this function is called.
474      *
475      * It must return its Solidity selector to confirm the token transfer.
476      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
477      *
478      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
479      */
480     function onERC721Received(
481         address operator,
482         address from,
483         uint256 tokenId,
484         bytes calldata data
485     ) external returns (bytes4);
486 }
487 
488 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Interface of the ERC165 standard, as defined in the
497  * https://eips.ethereum.org/EIPS/eip-165[EIP].
498  *
499  * Implementers can declare support of contract interfaces, which can then be
500  * queried by others ({ERC165Checker}).
501  *
502  * For an implementation, see {ERC165}.
503  */
504 interface IERC165 {
505     /**
506      * @dev Returns true if this contract implements the interface defined by
507      * `interfaceId`. See the corresponding
508      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
509      * to learn more about how these ids are created.
510      *
511      * This function call must use less than 30 000 gas.
512      */
513     function supportsInterface(bytes4 interfaceId) external view returns (bool);
514 }
515 
516 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * ```solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * ```
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Required interface of an ERC721 compliant contract.
557  */
558 interface IERC721 is IERC165 {
559     /**
560      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
566      */
567     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
571      */
572     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
573 
574     /**
575      * @dev Returns the number of tokens in ``owner``'s account.
576      */
577     function balanceOf(address owner) external view returns (uint256 balance);
578 
579     /**
580      * @dev Returns the owner of the `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function ownerOf(uint256 tokenId) external view returns (address owner);
587 
588     /**
589      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
590      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     /**
609      * @dev Transfers `tokenId` token from `from` to `to`.
610      *
611      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      *
620      * Emits a {Transfer} event.
621      */
622     function transferFrom(
623         address from,
624         address to,
625         uint256 tokenId
626     ) external;
627 
628     /**
629      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
630      * The approval is cleared when the token is transferred.
631      *
632      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
633      *
634      * Requirements:
635      *
636      * - The caller must own the token or be an approved operator.
637      * - `tokenId` must exist.
638      *
639      * Emits an {Approval} event.
640      */
641     function approve(address to, uint256 tokenId) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Approve or remove `operator` as an operator for the caller.
654      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
655      *
656      * Requirements:
657      *
658      * - The `operator` cannot be the caller.
659      *
660      * Emits an {ApprovalForAll} event.
661      */
662     function setApprovalForAll(address operator, bool _approved) external;
663 
664     /**
665      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
666      *
667      * See {setApprovalForAll}
668      */
669     function isApprovedForAll(address owner, address operator) external view returns (bool);
670 
671     /**
672      * @dev Safely transfers `tokenId` token from `from` to `to`.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must exist and be owned by `from`.
679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
681      *
682      * Emits a {Transfer} event.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes calldata data
689     ) external;
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Enumerable is IERC721 {
705     /**
706      * @dev Returns the total amount of tokens stored by the contract.
707      */
708     function totalSupply() external view returns (uint256);
709 
710     /**
711      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
712      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
718      * Use along with {totalSupply} to enumerate all tokens.
719      */
720     function tokenByIndex(uint256 index) external view returns (uint256);
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: contracts/ERC721A.sol
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
761  *
762  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
763  *
764  * Does not support burning tokens to address(0).
765  */
766 contract ERC721A is
767   Context,
768   ERC165,
769   IERC721,
770   IERC721Metadata,
771   IERC721Enumerable
772 {
773   using Address for address;
774   using Strings for uint256;
775 
776   struct TokenOwnership {
777     address addr;
778     uint64 startTimestamp;
779   }
780 
781   struct AddressData {
782     uint128 balance;
783     uint128 numberMinted;
784   }
785 
786   uint256 private currentIndex = 1;
787 
788   uint256 internal immutable collectionSize;
789   uint256 internal immutable maxBatchSize;
790 
791   // Token name
792   string private _name;
793 
794   // Token symbol
795   string private _symbol;
796 
797   // Mapping from token ID to ownership details
798   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
799   mapping(uint256 => TokenOwnership) private _ownerships;
800 
801   // Mapping owner address to address data
802   mapping(address => AddressData) private _addressData;
803 
804   // Mapping from token ID to approved address
805   mapping(uint256 => address) private _tokenApprovals;
806 
807   // Mapping from owner to operator approvals
808   mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810   /**
811    * @dev
812    * `maxBatchSize` refers to how much a minter can mint at a time.
813    * `collectionSize_` refers to how many tokens are in the collection.
814    */
815   constructor(
816     string memory name_,
817     string memory symbol_,
818     uint256 maxBatchSize_,
819     uint256 collectionSize_
820   ) {
821     require(
822       collectionSize_ > 0,
823       "ERC721A: collection must have a nonzero supply"
824     );
825     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
826     _name = name_;
827     _symbol = symbol_;
828     maxBatchSize = maxBatchSize_;
829     collectionSize = collectionSize_;
830   }
831 
832   /**
833    * @dev See {IERC721Enumerable-totalSupply}.
834    */
835   function totalSupply() public view override returns (uint256) {
836     return currentIndex;
837   }
838 
839   /**
840    * @dev See {IERC721Enumerable-tokenByIndex}.
841    */
842   function tokenByIndex(uint256 index) public view override returns (uint256) {
843     require(index < totalSupply(), "ERC721A: global index out of bounds");
844     return index;
845   }
846 
847   /**
848    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
849    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
850    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
851    */
852   function tokenOfOwnerByIndex(address owner, uint256 index)
853     public
854     view
855     override
856     returns (uint256)
857   {
858     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
859     uint256 numMintedSoFar = totalSupply();
860     uint256 tokenIdsIdx = 0;
861     address currOwnershipAddr = address(0);
862     for (uint256 i = 0; i < numMintedSoFar; i++) {
863       TokenOwnership memory ownership = _ownerships[i];
864       if (ownership.addr != address(0)) {
865         currOwnershipAddr = ownership.addr;
866       }
867       if (currOwnershipAddr == owner) {
868         if (tokenIdsIdx == index) {
869           return i;
870         }
871         tokenIdsIdx++;
872       }
873     }
874     revert("ERC721A: unable to get token of owner by index");
875   }
876 
877   /**
878    * @dev See {IERC165-supportsInterface}.
879    */
880   function supportsInterface(bytes4 interfaceId)
881     public
882     view
883     virtual
884     override(ERC165, IERC165)
885     returns (bool)
886   {
887     return
888       interfaceId == type(IERC721).interfaceId ||
889       interfaceId == type(IERC721Metadata).interfaceId ||
890       interfaceId == type(IERC721Enumerable).interfaceId ||
891       super.supportsInterface(interfaceId);
892   }
893 
894   /**
895    * @dev See {IERC721-balanceOf}.
896    */
897   function balanceOf(address owner) public view override returns (uint256) {
898     require(owner != address(0), "ERC721A: balance query for the zero address");
899     return uint256(_addressData[owner].balance);
900   }
901 
902   function _numberMinted(address owner) internal view returns (uint256) {
903     require(
904       owner != address(0),
905       "ERC721A: number minted query for the zero address"
906     );
907     return uint256(_addressData[owner].numberMinted);
908   }
909 
910   function ownershipOf(uint256 tokenId)
911     internal
912     view
913     returns (TokenOwnership memory)
914   {
915     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
916 
917     uint256 lowestTokenToCheck;
918     if (tokenId >= maxBatchSize) {
919       lowestTokenToCheck = tokenId - maxBatchSize + 1;
920     }
921 
922     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
923       TokenOwnership memory ownership = _ownerships[curr];
924       if (ownership.addr != address(0)) {
925         return ownership;
926       }
927     }
928 
929     revert("ERC721A: unable to determine the owner of token");
930   }
931 
932   /**
933    * @dev See {IERC721-ownerOf}.
934    */
935   function ownerOf(uint256 tokenId) public view override returns (address) {
936     return ownershipOf(tokenId).addr;
937   }
938 
939   /**
940    * @dev See {IERC721Metadata-name}.
941    */
942   function name() public view virtual override returns (string memory) {
943     return _name;
944   }
945 
946   /**
947    * @dev See {IERC721Metadata-symbol}.
948    */
949   function symbol() public view virtual override returns (string memory) {
950     return _symbol;
951   }
952 
953   /**
954    * @dev See {IERC721Metadata-tokenURI}.
955    */
956   function tokenURI(uint256 tokenId)
957     public
958     view
959     virtual
960     override
961     returns (string memory)
962   {
963     require(
964       _exists(tokenId),
965       "ERC721Metadata: URI query for nonexistent token"
966     );
967 
968     string memory baseURI = _baseURI();
969     return
970       bytes(baseURI).length > 0
971         ? string(abi.encodePacked(baseURI, tokenId.toString()))
972         : "";
973   }
974 
975   /**
976    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978    * by default, can be overriden in child contracts.
979    */
980   function _baseURI() internal view virtual returns (string memory) {
981     return "";
982   }
983 
984   /**
985    * @dev See {IERC721-approve}.
986    */
987   function approve(address to, uint256 tokenId) public override {
988     address owner = ERC721A.ownerOf(tokenId);
989     require(to != owner, "ERC721A: approval to current owner");
990 
991     require(
992       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
993       "ERC721A: approve caller is not owner nor approved for all"
994     );
995 
996     _approve(to, tokenId, owner);
997   }
998 
999   /**
1000    * @dev See {IERC721-getApproved}.
1001    */
1002   function getApproved(uint256 tokenId) public view override returns (address) {
1003     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1004 
1005     return _tokenApprovals[tokenId];
1006   }
1007 
1008   /**
1009    * @dev See {IERC721-setApprovalForAll}.
1010    */
1011   function setApprovalForAll(address operator, bool approved) public override {
1012     require(operator != _msgSender(), "ERC721A: approve to caller");
1013 
1014     _operatorApprovals[_msgSender()][operator] = approved;
1015     emit ApprovalForAll(_msgSender(), operator, approved);
1016   }
1017 
1018   /**
1019    * @dev See {IERC721-isApprovedForAll}.
1020    */
1021   function isApprovedForAll(address owner, address operator)
1022     public
1023     view
1024     virtual
1025     override
1026     returns (bool)
1027   {
1028     return _operatorApprovals[owner][operator];
1029   }
1030 
1031   /**
1032    * @dev See {IERC721-transferFrom}.
1033    */
1034   function transferFrom(
1035     address from,
1036     address to,
1037     uint256 tokenId
1038   ) public override {
1039     _transfer(from, to, tokenId);
1040   }
1041 
1042   /**
1043    * @dev See {IERC721-safeTransferFrom}.
1044    */
1045   function safeTransferFrom(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) public override {
1050     safeTransferFrom(from, to, tokenId, "");
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-safeTransferFrom}.
1055    */
1056   function safeTransferFrom(
1057     address from,
1058     address to,
1059     uint256 tokenId,
1060     bytes memory _data
1061   ) public override {
1062     _transfer(from, to, tokenId);
1063     require(
1064       _checkOnERC721Received(from, to, tokenId, _data),
1065       "ERC721A: transfer to non ERC721Receiver implementer"
1066     );
1067   }
1068 
1069   /**
1070    * @dev Returns whether `tokenId` exists.
1071    *
1072    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1073    *
1074    * Tokens start existing when they are minted (`_mint`),
1075    */
1076   function _exists(uint256 tokenId) internal view returns (bool) {
1077     return tokenId < currentIndex;
1078   }
1079 
1080   function _safeMint(address to, uint256 quantity) internal {
1081     _safeMint(to, quantity, "");
1082   }
1083 
1084   /**
1085    * @dev Mints `quantity` tokens and transfers them to `to`.
1086    *
1087    * Requirements:
1088    *
1089    * - there must be `quantity` tokens remaining unminted in the total collection.
1090    * - `to` cannot be the zero address.
1091    * - `quantity` cannot be larger than the max batch size.
1092    *
1093    * Emits a {Transfer} event.
1094    */
1095   function _safeMint(
1096     address to,
1097     uint256 quantity,
1098     bytes memory _data
1099   ) internal {
1100     uint256 startTokenId = currentIndex;
1101     require(to != address(0), "ERC721A: mint to the zero address");
1102     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1103     require(!_exists(startTokenId), "ERC721A: token already minted");
1104     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1105 
1106     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108     AddressData memory addressData = _addressData[to];
1109     _addressData[to] = AddressData(
1110       addressData.balance + uint128(quantity),
1111       addressData.numberMinted + uint128(quantity)
1112     );
1113     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1114 
1115     uint256 updatedIndex = startTokenId;
1116 
1117     for (uint256 i = 0; i < quantity; i++) {
1118       emit Transfer(address(0), to, updatedIndex);
1119       require(
1120         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1121         "ERC721A: transfer to non ERC721Receiver implementer"
1122       );
1123       updatedIndex++;
1124     }
1125 
1126     currentIndex = updatedIndex;
1127     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128   }
1129 
1130   /**
1131    * @dev Transfers `tokenId` from `from` to `to`.
1132    *
1133    * Requirements:
1134    *
1135    * - `to` cannot be the zero address.
1136    * - `tokenId` token must be owned by `from`.
1137    *
1138    * Emits a {Transfer} event.
1139    */
1140   function _transfer(
1141     address from,
1142     address to,
1143     uint256 tokenId
1144   ) private {
1145     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1146 
1147     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1148       getApproved(tokenId) == _msgSender() ||
1149       isApprovedForAll(prevOwnership.addr, _msgSender()));
1150 
1151     require(
1152       isApprovedOrOwner,
1153       "ERC721A: transfer caller is not owner nor approved"
1154     );
1155 
1156     require(
1157       prevOwnership.addr == from,
1158       "ERC721A: transfer from incorrect owner"
1159     );
1160     require(to != address(0), "ERC721A: transfer to the zero address");
1161 
1162     _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164     // Clear approvals from the previous owner
1165     _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167     _addressData[from].balance -= 1;
1168     _addressData[to].balance += 1;
1169     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1170 
1171     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173     uint256 nextTokenId = tokenId + 1;
1174     if (_ownerships[nextTokenId].addr == address(0)) {
1175       if (_exists(nextTokenId)) {
1176         _ownerships[nextTokenId] = TokenOwnership(
1177           prevOwnership.addr,
1178           prevOwnership.startTimestamp
1179         );
1180       }
1181     }
1182 
1183     emit Transfer(from, to, tokenId);
1184     _afterTokenTransfers(from, to, tokenId, 1);
1185   }
1186 
1187   /**
1188    * @dev Approve `to` to operate on `tokenId`
1189    *
1190    * Emits a {Approval} event.
1191    */
1192   function _approve(
1193     address to,
1194     uint256 tokenId,
1195     address owner
1196   ) private {
1197     _tokenApprovals[tokenId] = to;
1198     emit Approval(owner, to, tokenId);
1199   }
1200 
1201   uint256 public nextOwnerToExplicitlySet = 0;
1202 
1203   /**
1204    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1205    */
1206   function _setOwnersExplicit(uint256 quantity) internal {
1207     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1208     require(quantity > 0, "quantity must be nonzero");
1209     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1210     if (endIndex > collectionSize - 1) {
1211       endIndex = collectionSize - 1;
1212     }
1213     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1214     require(_exists(endIndex), "not enough minted yet for this cleanup");
1215     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1216       if (_ownerships[i].addr == address(0)) {
1217         TokenOwnership memory ownership = ownershipOf(i);
1218         _ownerships[i] = TokenOwnership(
1219           ownership.addr,
1220           ownership.startTimestamp
1221         );
1222       }
1223     }
1224     nextOwnerToExplicitlySet = endIndex + 1;
1225   }
1226 
1227   /**
1228    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1229    * The call is not executed if the target address is not a contract.
1230    *
1231    * @param from address representing the previous owner of the given token ID
1232    * @param to target address that will receive the tokens
1233    * @param tokenId uint256 ID of the token to be transferred
1234    * @param _data bytes optional data to send along with the call
1235    * @return bool whether the call correctly returned the expected magic value
1236    */
1237   function _checkOnERC721Received(
1238     address from,
1239     address to,
1240     uint256 tokenId,
1241     bytes memory _data
1242   ) private returns (bool) {
1243     if (to.isContract()) {
1244       try
1245         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1246       returns (bytes4 retval) {
1247         return retval == IERC721Receiver(to).onERC721Received.selector;
1248       } catch (bytes memory reason) {
1249         if (reason.length == 0) {
1250           revert("ERC721A: transfer to non ERC721Receiver implementer");
1251         } else {
1252           assembly {
1253             revert(add(32, reason), mload(reason))
1254           }
1255         }
1256       }
1257     } else {
1258       return true;
1259     }
1260   }
1261 
1262   /**
1263    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1264    *
1265    * startTokenId - the first token id to be transferred
1266    * quantity - the amount to be transferred
1267    *
1268    * Calling conditions:
1269    *
1270    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1271    * transferred to `to`.
1272    * - When `from` is zero, `tokenId` will be minted for `to`.
1273    */
1274   function _beforeTokenTransfers(
1275     address from,
1276     address to,
1277     uint256 startTokenId,
1278     uint256 quantity
1279   ) internal virtual {}
1280 
1281   /**
1282    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1283    * minting.
1284    *
1285    * startTokenId - the first token id to be transferred
1286    * quantity - the amount to be transferred
1287    *
1288    * Calling conditions:
1289    *
1290    * - when `from` and `to` are both non-zero.
1291    * - `from` and `to` are never both zero.
1292    */
1293   function _afterTokenTransfers(
1294     address from,
1295     address to,
1296     uint256 startTokenId,
1297     uint256 quantity
1298   ) internal virtual {}
1299 }
1300 
1301 abstract contract MerkleProof {
1302     bytes32 internal _merkleRoot;
1303     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
1304         _merkleRoot = merkleRoot_;
1305     }
1306     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
1307         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1308         for (uint256 i = 0; i < proof_.length; i++) {
1309             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1310         }
1311         return _leaf == _merkleRoot;
1312     }
1313 }
1314 
1315 /*********************************************************************************
1316 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1317 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1318 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1319 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1320 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1321 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@░░░░░░@@@@@@@@@░░░░░░@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1322 *@@@@@@@@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@@@@@@@@@@*
1323 *@@@@@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@@@@@@@@*
1324 *@@@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@@@@*
1325 *@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@*
1326 *@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@*
1327 *@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@*
1328 *@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@*
1329 *@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@*
1330 *@@@@@@@@@@@@░░░░░░░░░░░░░░░░░███████████████░░███████████████░░░░░░@@@@@@@@@@@@@*
1331 *@@@@@@@@@@@@@░░░░░░░░░░░░░░░░██░░░░░████████░░███░░░░░███████░░░░░░░@@@@@@@@@@@@*
1332 *@@@@@@@@@@@@░░░░░░░░░██████████░░░░░█████████████░░░░░███████░░░░░░░░@@@@@@@@@@@*
1333 *@@@@@@@@@@@░░░░░░░░░░███░░░░░██░░░░░████████░░███░░░░░███████░░░░░░░░░@@@@@@@@@@*
1334 *@@@@@@@@@@@░░░░░░░░░░███░░░░░██░░░░░████████░░███░░░░░███████░░░░░░░░@@@@@@@@@@@*
1335 *@@@@@@@@@@@@░░░░░░░░░░░░░░░░░███████████████░░███████████████░░░░░░░░@@@@@@@@@@@*
1336 *@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@*
1337 *@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@*
1338 *@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@*
1339 *@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@*
1340 *@@@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@@*
1341 *@@@@@@@@@@@@@@@@@@@@@@@░░░░░░░░░░░░░░░░░@@@@@@░░░░░░░░░░░░░░@@@@@@@@@@@@@@@@@@@@*
1342 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1343 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1344 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1345 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1346 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1347 *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
1348 *********************************************************************** @0xSumo */
1349 
1350 pragma solidity ^0.8.7;
1351 
1352 contract NounSNUG is ERC721A, Ownable, ReentrancyGuard, MerkleProof {
1353 
1354     uint256 public numberOfToken;
1355     uint256 public wlmintPrice = 0.01 ether;
1356     uint256 public mintPrice = 0.02 ether;
1357     uint256 private maxMintsPerWL = 7;
1358     uint256 private maxMints = 77;
1359     uint256 private maxMintsPerPS = 7;
1360     uint256 private _totalSupply = 7777;
1361     string private _baseTokenURI;
1362     string private revealUri;
1363     bool public whitelistSaleEnabled = false;
1364     bool public publicSaleEnabled = false;
1365     bool public revealed = false;
1366     mapping(address => uint256) public wlMinted;
1367     mapping(address => uint256) public psMinted;
1368 
1369     constructor () ERC721A ("NounSNUG","NSNUG", maxMints, _totalSupply) {
1370         numberOfToken = 0;
1371         sethiddenBaseURI("ipfs://QmfB3gEsGXjpNnyJ8g2RHguQLHmCYFbvC8c5g6Lt3rkMu7/nounsnug.json");
1372     }
1373 
1374     function ownerMint(uint256 _amount, address _address) public onlyOwner { 
1375         require((_amount + numberOfToken) <= (_totalSupply), "No more NFTs");
1376 
1377         _safeMint(_address, _amount);
1378         numberOfToken += _amount;
1379     }
1380 
1381     function whitelistMint(uint256 _amount, bytes32[] memory proof_) external payable nonReentrant onlySender {
1382         require(whitelistSaleEnabled, "whitelistMint: Paused");
1383         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1384         require(maxMintsPerWL >= _amount, "whitelistMint: 7 max per tx");
1385         require(maxMintsPerWL >= wlMinted[msg.sender] + _amount, "You have no whitelistMint left");
1386         require(msg.value == wlmintPrice * _amount, "Value sent is not correct");
1387         require((_amount + numberOfToken) <= (_totalSupply), "No more NFTs");
1388 
1389         wlMinted[msg.sender] += _amount;
1390         _safeMint(msg.sender, _amount);
1391         numberOfToken += _amount;
1392     }
1393 
1394     function publicMint(uint256 _amount) public payable nonReentrant onlySender {
1395         require(publicSaleEnabled, "publicMint: Paused");
1396         require(maxMintsPerPS >= _amount, "publicMint: 7 max per tx");
1397         require(maxMintsPerPS >= psMinted[msg.sender] + _amount, "You have no publicMint left");
1398         require(msg.value == mintPrice * _amount, "Value sent is not correct");
1399         require((_amount + numberOfToken) <= (_totalSupply), "No more NFTs");
1400          
1401         psMinted[msg.sender] += _amount;
1402         _safeMint(msg.sender, _amount);
1403         numberOfToken += _amount;
1404     }
1405 
1406     function setwlPrice(uint256 newPrice) external onlyOwner {
1407         wlmintPrice = newPrice;
1408     }
1409 
1410     function setPrice(uint256 newPrice) external onlyOwner {
1411         mintPrice = newPrice;
1412     }
1413 
1414     function setreveal(bool bool_) external onlyOwner {
1415         revealed = bool_;
1416     }
1417     
1418     function setWhitelistSale(bool bool_) external onlyOwner {
1419         whitelistSaleEnabled = bool_;
1420     }
1421 
1422     function setPublicSale(bool bool_) external onlyOwner {
1423         publicSaleEnabled = bool_;
1424     }
1425 
1426     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1427         _setMerkleRoot(merkleRoot_);
1428     }
1429 
1430     function sethiddenBaseURI(string memory uri_) public onlyOwner {
1431         revealUri = uri_;
1432     }
1433 
1434     function setBaseURI(string memory uri_) public onlyOwner {
1435         _baseTokenURI = uri_;
1436     }
1437 
1438     function currentBaseURI() private view returns (string memory){
1439         return _baseTokenURI;
1440     }
1441 
1442     modifier onlySender {
1443         require(msg.sender == tx.origin, "No smart contract"); _; 
1444     }
1445 
1446     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1447         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1448         if(revealed == false) {
1449         return revealUri;
1450         }
1451         return string(abi.encodePacked(currentBaseURI(), Strings.toString(tokenId), ".json"));
1452     }
1453 
1454     function withdraw() public onlyOwner {
1455         uint256 sendAmount = address(this).balance;
1456 
1457         address aa = payable(0x04D0d2eE99777F3F1aD29801435c820ACB5E8432);
1458         address bb = payable(0x182ff9Ab824f102D826813f9C4C569B4FAF3d019);
1459 
1460         bool success;
1461 
1462         (success, ) = aa.call{value: (sendAmount * 800/1000)}("");
1463         require(success, "Failed to withdraw Ether");
1464 
1465         (success, ) = bb.call{value: (sendAmount * 200/1000)}("");
1466         require(success, "Failed to withdraw Ether");
1467     }
1468 
1469     function walletOfOwner(address _address) public view returns (uint256[] memory) {
1470         uint256 ownerTokenCount = balanceOf(_address);
1471         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1472         for (uint256 i; i < ownerTokenCount; i++) {
1473           tokenIds[i] = tokenOfOwnerByIndex(_address, i);
1474         }
1475         return tokenIds;
1476     }
1477 }