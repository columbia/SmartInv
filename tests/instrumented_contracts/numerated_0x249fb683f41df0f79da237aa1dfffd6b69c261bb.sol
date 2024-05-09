1 // SPDX-License-Identifier: MIT
2 // File: GoblinTime_flat.sol
3 
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/access/Ownable.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Contract module which provides a basic access control mechanism, where
178  * there is an account (an owner) that can be granted exclusive access to
179  * specific functions.
180  *
181  * By default, the owner account will be the one that deploys the contract. This
182  * can later be changed with {transferOwnership}.
183  *
184  * This module is used through inheritance. It will make available the modifier
185  * `onlyOwner`, which can be applied to your functions to restrict their use to
186  * the owner.
187  */
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Initializes the contract setting the deployer as the initial owner.
195      */
196     constructor() {
197         _transferOwnership(_msgSender());
198     }
199 
200     /**
201      * @dev Returns the address of the current owner.
202      */
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     /**
208      * @dev Throws if called by any account other than the owner.
209      */
210     modifier onlyOwner() {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     /**
216      * @dev Leaves the contract without owner. It will not be possible to call
217      * `onlyOwner` functions anymore. Can only be called by the current owner.
218      *
219      * NOTE: Renouncing ownership will leave the contract without an owner,
220      * thereby removing any functionality that is only available to the owner.
221      */
222     function renounceOwnership() public virtual onlyOwner {
223         _transferOwnership(address(0));
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Can only be called by the current owner.
229      */
230     function transferOwnership(address newOwner) public virtual onlyOwner {
231         require(newOwner != address(0), "Ownable: new owner is the zero address");
232         _transferOwnership(newOwner);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Internal function without access restriction.
238      */
239     function _transferOwnership(address newOwner) internal virtual {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on `isContract` to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459 
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
472 
473 
474 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @title ERC721 token receiver interface
480  * @dev Interface for any contract that wants to support safeTransfers
481  * from ERC721 asset contracts.
482  */
483 interface IERC721Receiver {
484     /**
485      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
486      * by `operator` from `from`, this function is called.
487      *
488      * It must return its Solidity selector to confirm the token transfer.
489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
490      *
491      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
492      */
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Interface of the ERC165 standard, as defined in the
510  * https://eips.ethereum.org/EIPS/eip-165[EIP].
511  *
512  * Implementers can declare support of contract interfaces, which can then be
513  * queried by others ({ERC165Checker}).
514  *
515  * For an implementation, see {ERC165}.
516  */
517 interface IERC165 {
518     /**
519      * @dev Returns true if this contract implements the interface defined by
520      * `interfaceId`. See the corresponding
521      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
522      * to learn more about how these ids are created.
523      *
524      * This function call must use less than 30 000 gas.
525      */
526     function supportsInterface(bytes4 interfaceId) external view returns (bool);
527 }
528 
529 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Implementation of the {IERC165} interface.
539  *
540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
541  * for the additional interface id that will be supported. For example:
542  *
543  * ```solidity
544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
546  * }
547  * ```
548  *
549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
550  */
551 abstract contract ERC165 is IERC165 {
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         return interfaceId == type(IERC165).interfaceId;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Required interface of an ERC721 compliant contract.
570  */
571 interface IERC721 is IERC165 {
572     /**
573      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
574      */
575     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
579      */
580     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
584      */
585     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
586 
587     /**
588      * @dev Returns the number of tokens in ``owner``'s account.
589      */
590     function balanceOf(address owner) external view returns (uint256 balance);
591 
592     /**
593      * @dev Returns the owner of the `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function ownerOf(uint256 tokenId) external view returns (address owner);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId,
618         bytes calldata data
619     ) external;
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Transfers `tokenId` token from `from` to `to`.
643      *
644      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must be owned by `from`.
651      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
652      *
653      * Emits a {Transfer} event.
654      */
655     function transferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) external;
660 
661     /**
662      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
663      * The approval is cleared when the token is transferred.
664      *
665      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
666      *
667      * Requirements:
668      *
669      * - The caller must own the token or be an approved operator.
670      * - `tokenId` must exist.
671      *
672      * Emits an {Approval} event.
673      */
674     function approve(address to, uint256 tokenId) external;
675 
676     /**
677      * @dev Approve or remove `operator` as an operator for the caller.
678      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
679      *
680      * Requirements:
681      *
682      * - The `operator` cannot be the caller.
683      *
684      * Emits an {ApprovalForAll} event.
685      */
686     function setApprovalForAll(address operator, bool _approved) external;
687 
688     /**
689      * @dev Returns the account approved for `tokenId` token.
690      *
691      * Requirements:
692      *
693      * - `tokenId` must exist.
694      */
695     function getApproved(uint256 tokenId) external view returns (address operator);
696 
697     /**
698      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
699      *
700      * See {setApprovalForAll}
701      */
702     function isApprovedForAll(address owner, address operator) external view returns (bool);
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
715  * @dev See https://eips.ethereum.org/EIPS/eip-721
716  */
717 interface IERC721Metadata is IERC721 {
718     /**
719      * @dev Returns the token collection name.
720      */
721     function name() external view returns (string memory);
722 
723     /**
724      * @dev Returns the token collection symbol.
725      */
726     function symbol() external view returns (string memory);
727 
728     /**
729      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
730      */
731     function tokenURI(uint256 tokenId) external view returns (string memory);
732 }
733 
734 // File: erc721a/contracts/IERC721A.sol
735 
736 
737 // ERC721A Contracts v3.3.0
738 // Creator: Chiru Labs
739 
740 pragma solidity ^0.8.4;
741 
742 
743 
744 /**
745  * @dev Interface of an ERC721A compliant contract.
746  */
747 interface IERC721A is IERC721, IERC721Metadata {
748     /**
749      * The caller must own the token or be an approved operator.
750      */
751     error ApprovalCallerNotOwnerNorApproved();
752 
753     /**
754      * The token does not exist.
755      */
756     error ApprovalQueryForNonexistentToken();
757 
758     /**
759      * The caller cannot approve to their own address.
760      */
761     error ApproveToCaller();
762 
763     /**
764      * The caller cannot approve to the current owner.
765      */
766     error ApprovalToCurrentOwner();
767 
768     /**
769      * Cannot query the balance for the zero address.
770      */
771     error BalanceQueryForZeroAddress();
772 
773     /**
774      * Cannot mint to the zero address.
775      */
776     error MintToZeroAddress();
777 
778     /**
779      * The quantity of tokens minted must be more than zero.
780      */
781     error MintZeroQuantity();
782 
783     /**
784      * The token does not exist.
785      */
786     error OwnerQueryForNonexistentToken();
787 
788     /**
789      * The caller must own the token or be an approved operator.
790      */
791     error TransferCallerNotOwnerNorApproved();
792 
793     /**
794      * The token must be owned by `from`.
795      */
796     error TransferFromIncorrectOwner();
797 
798     /**
799      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
800      */
801     error TransferToNonERC721ReceiverImplementer();
802 
803     /**
804      * Cannot transfer to the zero address.
805      */
806     error TransferToZeroAddress();
807 
808     /**
809      * The token does not exist.
810      */
811     error URIQueryForNonexistentToken();
812 
813     // Compiler will pack this into a single 256bit word.
814     struct TokenOwnership {
815         // The address of the owner.
816         address addr;
817         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
818         uint64 startTimestamp;
819         // Whether the token has been burned.
820         bool burned;
821     }
822 
823     // Compiler will pack this into a single 256bit word.
824     struct AddressData {
825         // Realistically, 2**64-1 is more than enough.
826         uint64 balance;
827         // Keeps track of mint count with minimal overhead for tokenomics.
828         uint64 numberMinted;
829         // Keeps track of burn count with minimal overhead for tokenomics.
830         uint64 numberBurned;
831         // For miscellaneous variable(s) pertaining to the address
832         // (e.g. number of whitelist mint slots used).
833         // If there are multiple variables, please pack them into a uint64.
834         uint64 aux;
835     }
836 
837     /**
838      * @dev Returns the total amount of tokens stored by the contract.
839      * 
840      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
841      */
842     function totalSupply() external view returns (uint256);
843 }
844 
845 // File: erc721a/contracts/ERC721A.sol
846 
847 
848 // ERC721A Contracts v3.3.0
849 // Creator: Chiru Labs
850 
851 pragma solidity ^0.8.4;
852 
853 
854 
855 
856 
857 
858 
859 /**
860  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
861  * the Metadata extension. Built to optimize for lower gas during batch mints.
862  *
863  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
864  *
865  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
866  *
867  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
868  */
869 contract ERC721A is Context, ERC165, IERC721A {
870     using Address for address;
871     using Strings for uint256;
872 
873     // The tokenId of the next token to be minted.
874     uint256 internal _currentIndex;
875 
876     // The number of tokens burned.
877     uint256 internal _burnCounter;
878 
879     // Token name
880     string private _name;
881 
882     // Token symbol
883     string private _symbol;
884 
885     // Mapping from token ID to ownership details
886     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
887     mapping(uint256 => TokenOwnership) internal _ownerships;
888 
889     // Mapping owner address to address data
890     mapping(address => AddressData) private _addressData;
891 
892     // Mapping from token ID to approved address
893     mapping(uint256 => address) private _tokenApprovals;
894 
895     // Mapping from owner to operator approvals
896     mapping(address => mapping(address => bool)) private _operatorApprovals;
897 
898     constructor(string memory name_, string memory symbol_) {
899         _name = name_;
900         _symbol = symbol_;
901         _currentIndex = _startTokenId();
902     }
903 
904     /**
905      * To change the starting tokenId, please override this function.
906      */
907     function _startTokenId() internal view virtual returns (uint256) {
908         return 0;
909     }
910 
911     /**
912      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
913      */
914     function totalSupply() public view override returns (uint256) {
915         // Counter underflow is impossible as _burnCounter cannot be incremented
916         // more than _currentIndex - _startTokenId() times
917         unchecked {
918             return _currentIndex - _burnCounter - _startTokenId();
919         }
920     }
921 
922     /**
923      * Returns the total amount of tokens minted in the contract.
924      */
925     function _totalMinted() internal view returns (uint256) {
926         // Counter underflow is impossible as _currentIndex does not decrement,
927         // and it is initialized to _startTokenId()
928         unchecked {
929             return _currentIndex - _startTokenId();
930         }
931     }
932 
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
937         return
938             interfaceId == type(IERC721).interfaceId ||
939             interfaceId == type(IERC721Metadata).interfaceId ||
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
951     /**
952      * Returns the number of tokens minted by `owner`.
953      */
954     function _numberMinted(address owner) internal view returns (uint256) {
955         return uint256(_addressData[owner].numberMinted);
956     }
957 
958     /**
959      * Returns the number of tokens burned by or on behalf of `owner`.
960      */
961     function _numberBurned(address owner) internal view returns (uint256) {
962         return uint256(_addressData[owner].numberBurned);
963     }
964 
965     /**
966      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
967      */
968     function _getAux(address owner) internal view returns (uint64) {
969         return _addressData[owner].aux;
970     }
971 
972     /**
973      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
974      * If there are multiple variables, please pack them into a uint64.
975      */
976     function _setAux(address owner, uint64 aux) internal {
977         _addressData[owner].aux = aux;
978     }
979 
980     /**
981      * Gas spent here starts off proportional to the maximum mint batch size.
982      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
983      */
984     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
985         uint256 curr = tokenId;
986 
987         unchecked {
988             if (_startTokenId() <= curr) if (curr < _currentIndex) {
989                 TokenOwnership memory ownership = _ownerships[curr];
990                 if (!ownership.burned) {
991                     if (ownership.addr != address(0)) {
992                         return ownership;
993                     }
994                     // Invariant:
995                     // There will always be an ownership that has an address and is not burned
996                     // before an ownership that does not have an address and is not burned.
997                     // Hence, curr will not underflow.
998                     while (true) {
999                         curr--;
1000                         ownership = _ownerships[curr];
1001                         if (ownership.addr != address(0)) {
1002                             return ownership;
1003                         }
1004                     }
1005                 }
1006             }
1007         }
1008         revert OwnerQueryForNonexistentToken();
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-ownerOf}.
1013      */
1014     function ownerOf(uint256 tokenId) public view override returns (address) {
1015         return _ownershipOf(tokenId).addr;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-name}.
1020      */
1021     function name() public view virtual override returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-symbol}.
1027      */
1028     function symbol() public view virtual override returns (string memory) {
1029         return _symbol;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-tokenURI}.
1034      */
1035     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1036         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1037 
1038         string memory baseURI = _baseURI();
1039         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1040     }
1041 
1042     /**
1043      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1044      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1045      * by default, can be overriden in child contracts.
1046      */
1047     function _baseURI() internal view virtual returns (string memory) {
1048         return '';
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-approve}.
1053      */
1054     function approve(address to, uint256 tokenId) public override {
1055         address owner = ERC721A.ownerOf(tokenId);
1056         if (to == owner) revert ApprovalToCurrentOwner();
1057 
1058         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1059             revert ApprovalCallerNotOwnerNorApproved();
1060         }
1061 
1062         _approve(to, tokenId, owner);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-getApproved}.
1067      */
1068     function getApproved(uint256 tokenId) public view override returns (address) {
1069         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1070 
1071         return _tokenApprovals[tokenId];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-setApprovalForAll}.
1076      */
1077     function setApprovalForAll(address operator, bool approved) public virtual override {
1078         if (operator == _msgSender()) revert ApproveToCaller();
1079 
1080         _operatorApprovals[_msgSender()][operator] = approved;
1081         emit ApprovalForAll(_msgSender(), operator, approved);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-isApprovedForAll}.
1086      */
1087     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1088         return _operatorApprovals[owner][operator];
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-transferFrom}.
1093      */
1094     function transferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) public virtual override {
1099         _transfer(from, to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-safeTransferFrom}.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         safeTransferFrom(from, to, tokenId, '');
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) public virtual override {
1122         _transfer(from, to, tokenId);
1123         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1124             revert TransferToNonERC721ReceiverImplementer();
1125         }
1126     }
1127 
1128     /**
1129      * @dev Returns whether `tokenId` exists.
1130      *
1131      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1132      *
1133      * Tokens start existing when they are minted (`_mint`),
1134      */
1135     function _exists(uint256 tokenId) internal view returns (bool) {
1136         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1137     }
1138 
1139     /**
1140      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1141      */
1142     function _safeMint(address to, uint256 quantity) internal {
1143         _safeMint(to, quantity, '');
1144     }
1145 
1146     /**
1147      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - If `to` refers to a smart contract, it must implement
1152      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data
1161     ) internal {
1162         uint256 startTokenId = _currentIndex;
1163         if (to == address(0)) revert MintToZeroAddress();
1164         if (quantity == 0) revert MintZeroQuantity();
1165 
1166         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1167 
1168         // Overflows are incredibly unrealistic.
1169         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1170         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1171         unchecked {
1172             _addressData[to].balance += uint64(quantity);
1173             _addressData[to].numberMinted += uint64(quantity);
1174 
1175             _ownerships[startTokenId].addr = to;
1176             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1177 
1178             uint256 updatedIndex = startTokenId;
1179             uint256 end = updatedIndex + quantity;
1180 
1181             if (to.isContract()) {
1182                 do {
1183                     emit Transfer(address(0), to, updatedIndex);
1184                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1185                         revert TransferToNonERC721ReceiverImplementer();
1186                     }
1187                 } while (updatedIndex < end);
1188                 // Reentrancy protection
1189                 if (_currentIndex != startTokenId) revert();
1190             } else {
1191                 do {
1192                     emit Transfer(address(0), to, updatedIndex++);
1193                 } while (updatedIndex < end);
1194             }
1195             _currentIndex = updatedIndex;
1196         }
1197         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1198     }
1199 
1200     /**
1201      * @dev Mints `quantity` tokens and transfers them to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `quantity` must be greater than 0.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _mint(address to, uint256 quantity) internal {
1211         uint256 startTokenId = _currentIndex;
1212         if (to == address(0)) revert MintToZeroAddress();
1213         if (quantity == 0) revert MintZeroQuantity();
1214 
1215         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1216 
1217         // Overflows are incredibly unrealistic.
1218         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1219         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1220         unchecked {
1221             _addressData[to].balance += uint64(quantity);
1222             _addressData[to].numberMinted += uint64(quantity);
1223 
1224             _ownerships[startTokenId].addr = to;
1225             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1226 
1227             uint256 updatedIndex = startTokenId;
1228             uint256 end = updatedIndex + quantity;
1229 
1230             do {
1231                 emit Transfer(address(0), to, updatedIndex++);
1232             } while (updatedIndex < end);
1233 
1234             _currentIndex = updatedIndex;
1235         }
1236         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1237     }
1238 
1239     /**
1240      * @dev Transfers `tokenId` from `from` to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - `to` cannot be the zero address.
1245      * - `tokenId` token must be owned by `from`.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _transfer(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) private {
1254         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1255 
1256         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1257 
1258         bool isApprovedOrOwner = (_msgSender() == from ||
1259             isApprovedForAll(from, _msgSender()) ||
1260             getApproved(tokenId) == _msgSender());
1261 
1262         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         if (to == address(0)) revert TransferToZeroAddress();
1264 
1265         _beforeTokenTransfers(from, to, tokenId, 1);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId, from);
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             _addressData[from].balance -= 1;
1275             _addressData[to].balance += 1;
1276 
1277             TokenOwnership storage currSlot = _ownerships[tokenId];
1278             currSlot.addr = to;
1279             currSlot.startTimestamp = uint64(block.timestamp);
1280 
1281             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1282             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1283             uint256 nextTokenId = tokenId + 1;
1284             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1285             if (nextSlot.addr == address(0)) {
1286                 // This will suffice for checking _exists(nextTokenId),
1287                 // as a burned slot cannot contain the zero address.
1288                 if (nextTokenId != _currentIndex) {
1289                     nextSlot.addr = from;
1290                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1291                 }
1292             }
1293         }
1294 
1295         emit Transfer(from, to, tokenId);
1296         _afterTokenTransfers(from, to, tokenId, 1);
1297     }
1298 
1299     /**
1300      * @dev Equivalent to `_burn(tokenId, false)`.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         _burn(tokenId, false);
1304     }
1305 
1306     /**
1307      * @dev Destroys `tokenId`.
1308      * The approval is cleared when the token is burned.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1317         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1318 
1319         address from = prevOwnership.addr;
1320 
1321         if (approvalCheck) {
1322             bool isApprovedOrOwner = (_msgSender() == from ||
1323                 isApprovedForAll(from, _msgSender()) ||
1324                 getApproved(tokenId) == _msgSender());
1325 
1326             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1327         }
1328 
1329         _beforeTokenTransfers(from, address(0), tokenId, 1);
1330 
1331         // Clear approvals from the previous owner
1332         _approve(address(0), tokenId, from);
1333 
1334         // Underflow of the sender's balance is impossible because we check for
1335         // ownership above and the recipient's balance can't realistically overflow.
1336         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1337         unchecked {
1338             AddressData storage addressData = _addressData[from];
1339             addressData.balance -= 1;
1340             addressData.numberBurned += 1;
1341 
1342             // Keep track of who burned the token, and the timestamp of burning.
1343             TokenOwnership storage currSlot = _ownerships[tokenId];
1344             currSlot.addr = from;
1345             currSlot.startTimestamp = uint64(block.timestamp);
1346             currSlot.burned = true;
1347 
1348             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1349             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1350             uint256 nextTokenId = tokenId + 1;
1351             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1352             if (nextSlot.addr == address(0)) {
1353                 // This will suffice for checking _exists(nextTokenId),
1354                 // as a burned slot cannot contain the zero address.
1355                 if (nextTokenId != _currentIndex) {
1356                     nextSlot.addr = from;
1357                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1358                 }
1359             }
1360         }
1361 
1362         emit Transfer(from, address(0), tokenId);
1363         _afterTokenTransfers(from, address(0), tokenId, 1);
1364 
1365         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1366         unchecked {
1367             _burnCounter++;
1368         }
1369     }
1370 
1371     /**
1372      * @dev Approve `to` to operate on `tokenId`
1373      *
1374      * Emits a {Approval} event.
1375      */
1376     function _approve(
1377         address to,
1378         uint256 tokenId,
1379         address owner
1380     ) private {
1381         _tokenApprovals[tokenId] = to;
1382         emit Approval(owner, to, tokenId);
1383     }
1384 
1385     /**
1386      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1387      *
1388      * @param from address representing the previous owner of the given token ID
1389      * @param to target address that will receive the tokens
1390      * @param tokenId uint256 ID of the token to be transferred
1391      * @param _data bytes optional data to send along with the call
1392      * @return bool whether the call correctly returned the expected magic value
1393      */
1394     function _checkContractOnERC721Received(
1395         address from,
1396         address to,
1397         uint256 tokenId,
1398         bytes memory _data
1399     ) private returns (bool) {
1400         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1401             return retval == IERC721Receiver(to).onERC721Received.selector;
1402         } catch (bytes memory reason) {
1403             if (reason.length == 0) {
1404                 revert TransferToNonERC721ReceiverImplementer();
1405             } else {
1406                 assembly {
1407                     revert(add(32, reason), mload(reason))
1408                 }
1409             }
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1415      * And also called before burning one token.
1416      *
1417      * startTokenId - the first token id to be transferred
1418      * quantity - the amount to be transferred
1419      *
1420      * Calling conditions:
1421      *
1422      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1423      * transferred to `to`.
1424      * - When `from` is zero, `tokenId` will be minted for `to`.
1425      * - When `to` is zero, `tokenId` will be burned by `from`.
1426      * - `from` and `to` are never both zero.
1427      */
1428     function _beforeTokenTransfers(
1429         address from,
1430         address to,
1431         uint256 startTokenId,
1432         uint256 quantity
1433     ) internal virtual {}
1434 
1435     /**
1436      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1437      * minting.
1438      * And also called after one token has been burned.
1439      *
1440      * startTokenId - the first token id to be transferred
1441      * quantity - the amount to be transferred
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` has been minted for `to`.
1448      * - When `to` is zero, `tokenId` has been burned by `from`.
1449      * - `from` and `to` are never both zero.
1450      */
1451     function _afterTokenTransfers(
1452         address from,
1453         address to,
1454         uint256 startTokenId,
1455         uint256 quantity
1456     ) internal virtual {}
1457 }
1458 
1459 // File: contracts/GoblinTime.sol
1460 
1461 
1462 
1463 pragma solidity ^0.8.4;
1464 
1465 
1466 
1467 
1468 contract GoblinTime is ERC721A, Ownable, ReentrancyGuard {
1469     using Strings for uint256;
1470 
1471     uint256 public PRICE;
1472     uint256 public MAX_SUPPLY;
1473     string private BASE_URI;
1474     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1475     uint256 public MAX_MINT_AMOUNT_PER_TX;
1476     bool public IS_SALE_ACTIVE;
1477     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1478     bool public METADATA_FROZEN;
1479 
1480     mapping(address => uint256) private freeMintCountMap;
1481 
1482     constructor(
1483         uint256 price,
1484         uint256 maxSupply,
1485         string memory baseUri,
1486         uint256 freeMintAllowance,
1487         uint256 maxMintPerTx,
1488         bool isSaleActive,
1489         uint256 freeMintIsAllowedUntil
1490     ) ERC721A("GoblinTime", "GoblinTime") {
1491         PRICE = price;
1492         MAX_SUPPLY = maxSupply;
1493         BASE_URI = baseUri;
1494         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1495         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1496         IS_SALE_ACTIVE = isSaleActive;
1497         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1498     }
1499 
1500     /** FREE MINT **/
1501 
1502     function updateFreeMintCount(address minter, uint256 count) private {
1503         freeMintCountMap[minter] += count;
1504     }
1505 
1506     /** GETTERS **/
1507 
1508     function _baseURI() internal view virtual override returns (string memory) {
1509         return BASE_URI;
1510     }
1511 
1512     /** SETTERS **/
1513 
1514     function setPrice(uint256 customPrice) external onlyOwner {
1515         PRICE = customPrice;
1516     }
1517 
1518     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1519         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1520         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1521         MAX_SUPPLY = newMaxSupply;
1522     }
1523 
1524     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1525         require(!METADATA_FROZEN, "Metadata frozen!");
1526         BASE_URI = customBaseURI_;
1527     }
1528 
1529     function setFreeMintAllowance(uint256 freeMintAllowance)
1530         external
1531         onlyOwner
1532     {
1533         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1534     }
1535 
1536     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1537         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1538     }
1539 
1540     function setSaleActive(bool saleIsActive) external onlyOwner {
1541         IS_SALE_ACTIVE = saleIsActive;
1542     }
1543 
1544     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1545         external
1546         onlyOwner
1547     {
1548         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1549     }
1550 
1551     function freezeMetadata() external onlyOwner {
1552         METADATA_FROZEN = true;
1553     }
1554 
1555     /** MINT **/
1556 
1557     modifier mintCompliance(uint256 _mintAmount) {
1558         require(
1559             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1560             "Invalid mint amount!"
1561         );
1562         require(
1563             _currentIndex + _mintAmount <= MAX_SUPPLY,
1564             "Max supply exceeded!"
1565         );
1566         _;
1567     }
1568 
1569     function mint(uint256 _mintAmount)
1570         public
1571         payable
1572         mintCompliance(_mintAmount)
1573     {
1574         require(IS_SALE_ACTIVE, "Sale is not active!");
1575 
1576         uint256 price = PRICE * _mintAmount;
1577 
1578         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1579             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1580                 freeMintCountMap[msg.sender];
1581             if (remainingFreeMint > 0) {
1582                 if (_mintAmount >= remainingFreeMint) {
1583                     price -= remainingFreeMint * PRICE;
1584                     updateFreeMintCount(msg.sender, remainingFreeMint);
1585                 } else {
1586                     price -= _mintAmount * PRICE;
1587                     updateFreeMintCount(msg.sender, _mintAmount);
1588                 }
1589             }
1590         }
1591 
1592         require(msg.value >= price, "Insufficient funds!");
1593 
1594         _safeMint(msg.sender, _mintAmount);
1595     }
1596 
1597     function mintOwner(address _to, uint256 _mintAmount)
1598         public
1599         mintCompliance(_mintAmount)
1600         onlyOwner
1601     {
1602         _safeMint(_to, _mintAmount);
1603     }
1604 
1605     /** PAYOUT **/
1606 
1607     address private constant payoutAddress1 =
1608         0x843964336B4157E79E36F07cd4A1F607550A854A;
1609 
1610     function withdraw() public onlyOwner nonReentrant {
1611         uint256 balance = address(this).balance;
1612         Address.sendValue(payable(payoutAddress1), balance / 1);
1613     }
1614 }