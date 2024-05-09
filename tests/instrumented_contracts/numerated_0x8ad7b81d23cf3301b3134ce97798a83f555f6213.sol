1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Contract module that helps prevent reentrant calls to a function.
15  *
16  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
17  * available, which can be applied to functions to make sure there are no nested
18  * (reentrant) calls to them.
19  *
20  * Note that because there is a single `nonReentrant` guard, functions marked as
21  * `nonReentrant` may not call one another. This can be worked around by making
22  * those functions `private`, and then adding `external` `nonReentrant` entry
23  * points to them.
24  *
25  * TIP: If you would like to learn more about reentrancy and alternative ways
26  * to protect against it, check out our blog post
27  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
28  */
29 abstract contract ReentrancyGuard {
30     // Booleans are more expensive than uint256 or any type that takes up a full
31     // word because each write operation emits an extra SLOAD to first read the
32     // slot's contents, replace the bits taken up by the boolean, and then write
33     // back. This is the compiler's defense against contract upgrades and
34     // pointer aliasing, and it cannot be disabled.
35 
36     // The values being non-zero value makes deployment a bit more expensive,
37     // but in exchange the refund on every call to nonReentrant will be lower in
38     // amount. Since refunds are capped to a percentage of the total
39     // transaction's gas, it is best to keep them low in cases like this one, to
40     // increase the likelihood of the full refund coming into effect.
41     uint256 private constant _NOT_ENTERED = 1;
42     uint256 private constant _ENTERED = 2;
43 
44     uint256 private _status;
45 
46     constructor() {
47         _status = _NOT_ENTERED;
48     }
49 
50     /**
51      * @dev Prevents a contract from calling itself, directly or indirectly.
52      * Calling a `nonReentrant` function from another `nonReentrant`
53      * function is not supported. It is possible to prevent this from happening
54      * by making the `nonReentrant` function external, and making it call a
55      * `private` function that does the actual work.
56      */
57     modifier nonReentrant() {
58         // On the first call to nonReentrant, _notEntered will be true
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63 
64         _;
65 
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Strings.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev String operations.
81  */
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
87      */
88     function toString(uint256 value) internal pure returns (string memory) {
89         // Inspired by OraclizeAPI's implementation - MIT licence
90         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
91 
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
112      */
113     function toHexString(uint256 value) internal pure returns (string memory) {
114         if (value == 0) {
115             return "0x00";
116         }
117         uint256 temp = value;
118         uint256 length = 0;
119         while (temp != 0) {
120             length++;
121             temp >>= 8;
122         }
123         return toHexString(value, length);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
128      */
129     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
130         bytes memory buffer = new bytes(2 * length + 2);
131         buffer[0] = "0";
132         buffer[1] = "x";
133         for (uint256 i = 2 * length + 1; i > 1; --i) {
134             buffer[i] = _HEX_SYMBOLS[value & 0xf];
135             value >>= 4;
136         }
137         require(value == 0, "Strings: hex length insufficient");
138         return string(buffer);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/Context.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes calldata) {
165         return msg.data;
166     }
167 }
168 
169 // File: @openzeppelin/contracts/access/Ownable.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Contract module which provides a basic access control mechanism, where
179  * there is an account (an owner) that can be granted exclusive access to
180  * specific functions.
181  *
182  * By default, the owner account will be the one that deploys the contract. This
183  * can later be changed with {transferOwnership}.
184  *
185  * This module is used through inheritance. It will make available the modifier
186  * `onlyOwner`, which can be applied to your functions to restrict their use to
187  * the owner.
188  */
189 abstract contract Ownable is Context {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev Initializes the contract setting the deployer as the initial owner.
196      */
197     constructor() {
198         _transferOwnership(_msgSender());
199     }
200 
201     /**
202      * @dev Returns the address of the current owner.
203      */
204     function owner() public view virtual returns (address) {
205         return _owner;
206     }
207 
208     /**
209      * @dev Throws if called by any account other than the owner.
210      */
211     modifier onlyOwner() {
212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
213         _;
214     }
215 
216     /**
217      * @dev Leaves the contract without owner. It will not be possible to call
218      * `onlyOwner` functions anymore. Can only be called by the current owner.
219      *
220      * NOTE: Renouncing ownership will leave the contract without an owner,
221      * thereby removing any functionality that is only available to the owner.
222      */
223     function renounceOwnership() public virtual onlyOwner {
224         _transferOwnership(address(0));
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Can only be called by the current owner.
230      */
231     function transferOwnership(address newOwner) public virtual onlyOwner {
232         require(newOwner != address(0), "Ownable: new owner is the zero address");
233         _transferOwnership(newOwner);
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Internal function without access restriction.
239      */
240     function _transferOwnership(address newOwner) internal virtual {
241         address oldOwner = _owner;
242         _owner = newOwner;
243         emit OwnershipTransferred(oldOwner, newOwner);
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 
250 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
251 
252 pragma solidity ^0.8.1;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      *
275      * [IMPORTANT]
276      * ====
277      * You shouldn't rely on `isContract` to protect against flash loan attacks!
278      *
279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
281      * constructor.
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize/address.code.length, which returns 0
286         // for contracts in construction, since the code is only stored at the end
287         // of the constructor execution.
288 
289         return account.code.length > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         (bool success, ) = recipient.call{value: amount}("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain `call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         require(isContract(target), "Address: call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.call{value: value}(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
396         return functionStaticCall(target, data, "Address: low-level static call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.staticcall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
423         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(isContract(target), "Address: delegate call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.delegatecall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
445      * revert reason using the provided one.
446      *
447      * _Available since v4.3._
448      */
449     function verifyCallResult(
450         bool success,
451         bytes memory returndata,
452         string memory errorMessage
453     ) internal pure returns (bytes memory) {
454         if (success) {
455             return returndata;
456         } else {
457             // Look for revert reason and bubble it up if present
458             if (returndata.length > 0) {
459                 // The easiest way to bubble the revert reason is using memory via assembly
460 
461                 assembly {
462                     let returndata_size := mload(returndata)
463                     revert(add(32, returndata), returndata_size)
464                 }
465             } else {
466                 revert(errorMessage);
467             }
468         }
469     }
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @title ERC721 token receiver interface
481  * @dev Interface for any contract that wants to support safeTransfers
482  * from ERC721 asset contracts.
483  */
484 interface IERC721Receiver {
485     /**
486      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
487      * by `operator` from `from`, this function is called.
488      *
489      * It must return its Solidity selector to confirm the token transfer.
490      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
491      *
492      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
493      */
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Interface of the ERC165 standard, as defined in the
511  * https://eips.ethereum.org/EIPS/eip-165[EIP].
512  *
513  * Implementers can declare support of contract interfaces, which can then be
514  * queried by others ({ERC165Checker}).
515  *
516  * For an implementation, see {ERC165}.
517  */
518 interface IERC165 {
519     /**
520      * @dev Returns true if this contract implements the interface defined by
521      * `interfaceId`. See the corresponding
522      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
523      * to learn more about how these ids are created.
524      *
525      * This function call must use less than 30 000 gas.
526      */
527     function supportsInterface(bytes4 interfaceId) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * ```solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * ```
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Required interface of an ERC721 compliant contract.
571  */
572 interface IERC721 is IERC165 {
573     /**
574      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
575      */
576     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
580      */
581     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
585      */
586     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
587 
588     /**
589      * @dev Returns the number of tokens in ``owner``'s account.
590      */
591     function balanceOf(address owner) external view returns (uint256 balance);
592 
593     /**
594      * @dev Returns the owner of the `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function ownerOf(uint256 tokenId) external view returns (address owner);
601 
602     /**
603      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
604      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must exist and be owned by `from`.
611      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Transfers `tokenId` token from `from` to `to`.
624      *
625      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      *
634      * Emits a {Transfer} event.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external;
641 
642     /**
643      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Approve or remove `operator` as an operator for the caller.
668      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
669      *
670      * Requirements:
671      *
672      * - The `operator` cannot be the caller.
673      *
674      * Emits an {ApprovalForAll} event.
675      */
676     function setApprovalForAll(address operator, bool _approved) external;
677 
678     /**
679      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
680      *
681      * See {setApprovalForAll}
682      */
683     function isApprovedForAll(address owner, address operator) external view returns (bool);
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes calldata data
703     ) external;
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
707 
708 
709 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
716  * @dev See https://eips.ethereum.org/EIPS/eip-721
717  */
718 interface IERC721Enumerable is IERC721 {
719     /**
720      * @dev Returns the total amount of tokens stored by the contract.
721      */
722     function totalSupply() external view returns (uint256);
723 
724     /**
725      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
726      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
727      */
728     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
729 
730     /**
731      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
732      * Use along with {totalSupply} to enumerate all tokens.
733      */
734     function tokenByIndex(uint256 index) external view returns (uint256);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
747  * @dev See https://eips.ethereum.org/EIPS/eip-721
748  */
749 interface IERC721Metadata is IERC721 {
750     /**
751      * @dev Returns the token collection name.
752      */
753     function name() external view returns (string memory);
754 
755     /**
756      * @dev Returns the token collection symbol.
757      */
758     function symbol() external view returns (string memory);
759 
760     /**
761      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
762      */
763     function tokenURI(uint256 tokenId) external view returns (string memory);
764 }
765 
766 // File: contracts/ERC721A.sol
767 
768 
769 // Creator: Chiru Labs
770 
771 pragma solidity ^0.8.4;
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 error ApprovalCallerNotOwnerNorApproved();
782 error ApprovalQueryForNonexistentToken();
783 error ApproveToCaller();
784 error ApprovalToCurrentOwner();
785 error BalanceQueryForZeroAddress();
786 error MintedQueryForZeroAddress();
787 error BurnedQueryForZeroAddress();
788 error AuxQueryForZeroAddress();
789 error MintToZeroAddress();
790 error MintZeroQuantity();
791 error OwnerIndexOutOfBounds();
792 error OwnerQueryForNonexistentToken();
793 error TokenIndexOutOfBounds();
794 error TransferCallerNotOwnerNorApproved();
795 error TransferFromIncorrectOwner();
796 error TransferToNonERC721ReceiverImplementer();
797 error TransferToZeroAddress();
798 error URIQueryForNonexistentToken();
799 
800 /**
801  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
802  * the Metadata extension. Built to optimize for lower gas during batch mints.
803  *
804  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
805  *
806  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
807  *
808  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
809  */
810 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
811     using Address for address;
812     using Strings for uint256;
813 
814     // Compiler will pack this into a single 256bit word.
815     struct TokenOwnership {
816         // The address of the owner.
817         address addr;
818         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
819         uint64 startTimestamp;
820         // Whether the token has been burned.
821         bool burned;
822     }
823 
824     // Compiler will pack this into a single 256bit word.
825     struct AddressData {
826         // Realistically, 2**64-1 is more than enough.
827         uint64 balance;
828         // Keeps track of mint count with minimal overhead for tokenomics.
829         uint64 numberMinted;
830         // Keeps track of burn count with minimal overhead for tokenomics.
831         uint64 numberBurned;
832         // For miscellaneous variable(s) pertaining to the address
833         // (e.g. number of whitelist mint slots used). 
834         // If there are multiple variables, please pack them into a uint64.
835         uint64 aux;
836     }
837 
838     // The tokenId of the next token to be minted.
839     uint256 internal _currentIndex;
840 
841     // The number of tokens burned.
842     uint256 internal _burnCounter;
843 
844     // Token name
845     string private _name;
846 
847     // Token symbol
848     string private _symbol;
849 
850     // Mapping from token ID to ownership details
851     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
852     mapping(uint256 => TokenOwnership) internal _ownerships;
853 
854     // Mapping owner address to address data
855     mapping(address => AddressData) private _addressData;
856 
857     // Mapping from token ID to approved address
858     mapping(uint256 => address) private _tokenApprovals;
859 
860     // Mapping from owner to operator approvals
861     mapping(address => mapping(address => bool)) private _operatorApprovals;
862 
863     constructor(string memory name_, string memory symbol_) {
864         _name = name_;
865         _symbol = symbol_;
866     }
867 
868     /**
869      * @dev See {IERC721Enumerable-totalSupply}.
870      */
871     function totalSupply() public view returns (uint256) {
872         // Counter underflow is impossible as _burnCounter cannot be incremented
873         // more than _currentIndex times
874         unchecked {
875             return _currentIndex - _burnCounter;    
876         }
877     }
878 
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892     function balanceOf(address owner) public view override returns (uint256) {
893         if (owner == address(0)) revert BalanceQueryForZeroAddress();
894         return uint256(_addressData[owner].balance);
895     }
896 
897     /**
898      * Returns the number of tokens minted by `owner`.
899      */
900     function _numberMinted(address owner) internal view returns (uint256) {
901         if (owner == address(0)) revert MintedQueryForZeroAddress();
902         return uint256(_addressData[owner].numberMinted);
903     }
904 
905     /**
906      * Returns the number of tokens burned by or on behalf of `owner`.
907      */
908     function _numberBurned(address owner) internal view returns (uint256) {
909         if (owner == address(0)) revert BurnedQueryForZeroAddress();
910         return uint256(_addressData[owner].numberBurned);
911     }
912 
913     /**
914      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
915      */
916     function _getAux(address owner) internal view returns (uint64) {
917         if (owner == address(0)) revert AuxQueryForZeroAddress();
918         return _addressData[owner].aux;
919     }
920 
921     /**
922      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
923      * If there are multiple variables, please pack them into a uint64.
924      */
925     function _setAux(address owner, uint64 aux) internal {
926         if (owner == address(0)) revert AuxQueryForZeroAddress();
927         _addressData[owner].aux = aux;
928     }
929 
930     /**
931      * Gas spent here starts off proportional to the maximum mint batch size.
932      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
933      */
934     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
935         uint256 curr = tokenId;
936 
937         unchecked {
938             if (curr < _currentIndex) {
939                 TokenOwnership memory ownership = _ownerships[curr];
940                 if (!ownership.burned) {
941                     if (ownership.addr != address(0)) {
942                         return ownership;
943                     }
944                     // Invariant: 
945                     // There will always be an ownership that has an address and is not burned 
946                     // before an ownership that does not have an address and is not burned.
947                     // Hence, curr will not underflow.
948                     while (true) {
949                         curr--;
950                         ownership = _ownerships[curr];
951                         if (ownership.addr != address(0)) {
952                             return ownership;
953                         }
954                     }
955                 }
956             }
957         }
958         revert OwnerQueryForNonexistentToken();
959     }
960 
961     /**
962      * @dev See {IERC721-ownerOf}.
963      */
964     function ownerOf(uint256 tokenId) public view override returns (address) {
965         return ownershipOf(tokenId).addr;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return '';
999     }
1000 
1001     /**
1002      * @dev See {IERC721-approve}.
1003      */
1004     function approve(address to, uint256 tokenId) public override {
1005         address owner = ERC721A.ownerOf(tokenId);
1006         if (to == owner) revert ApprovalToCurrentOwner();
1007 
1008         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1009             revert ApprovalCallerNotOwnerNorApproved();
1010         }
1011 
1012         _approve(to, tokenId, owner);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-getApproved}.
1017      */
1018     function getApproved(uint256 tokenId) public view override returns (address) {
1019         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1020 
1021         return _tokenApprovals[tokenId];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-setApprovalForAll}.
1026      */
1027     function setApprovalForAll(address operator, bool approved) public override {
1028         if (operator == _msgSender()) revert ApproveToCaller();
1029 
1030         _operatorApprovals[_msgSender()][operator] = approved;
1031         emit ApprovalForAll(_msgSender(), operator, approved);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-isApprovedForAll}.
1036      */
1037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1038         return _operatorApprovals[owner][operator];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-transferFrom}.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public virtual override {
1060         safeTransferFrom(from, to, tokenId, '');
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1074             revert TransferToNonERC721ReceiverImplementer();
1075         }
1076     }
1077 
1078     /**
1079      * @dev Returns whether `tokenId` exists.
1080      *
1081      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1082      *
1083      * Tokens start existing when they are minted (`_mint`),
1084      */
1085     function _exists(uint256 tokenId) internal view returns (bool) {
1086         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1087     }
1088 
1089     function _safeMint(address to, uint256 quantity) internal {
1090         _safeMint(to, quantity, '');
1091     }
1092 
1093     /**
1094      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _safeMint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data
1107     ) internal {
1108         _mint(to, quantity, _data, true);
1109     }
1110 
1111     /**
1112      * @dev Mints `quantity` tokens and transfers them to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _mint(
1122         address to,
1123         uint256 quantity,
1124         bytes memory _data,
1125         bool safe
1126     ) internal {
1127         uint256 startTokenId = _currentIndex;
1128         if (to == address(0)) revert MintToZeroAddress();
1129         if (quantity == 0) revert MintZeroQuantity();
1130 
1131         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1132 
1133         // Overflows are incredibly unrealistic.
1134         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1135         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1136         unchecked {
1137             _addressData[to].balance += uint64(quantity);
1138             _addressData[to].numberMinted += uint64(quantity);
1139 
1140             _ownerships[startTokenId].addr = to;
1141             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1142 
1143             uint256 updatedIndex = startTokenId;
1144 
1145             for (uint256 i; i < quantity; i++) {
1146                 emit Transfer(address(0), to, updatedIndex);
1147                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1148                     revert TransferToNonERC721ReceiverImplementer();
1149                 }
1150                 updatedIndex++;
1151             }
1152 
1153             _currentIndex = updatedIndex;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     /**
1159      * @dev Transfers `tokenId` from `from` to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `tokenId` token must be owned by `from`.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _transfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) private {
1173         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1174 
1175         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1176             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1177             getApproved(tokenId) == _msgSender());
1178 
1179         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1180         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1181         if (to == address(0)) revert TransferToZeroAddress();
1182 
1183         _beforeTokenTransfers(from, to, tokenId, 1);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId, prevOwnership.addr);
1187 
1188         // Underflow of the sender's balance is impossible because we check for
1189         // ownership above and the recipient's balance can't realistically overflow.
1190         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1191         unchecked {
1192             _addressData[from].balance -= 1;
1193             _addressData[to].balance += 1;
1194 
1195             _ownerships[tokenId].addr = to;
1196             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1197 
1198             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1199             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1200             uint256 nextTokenId = tokenId + 1;
1201             if (_ownerships[nextTokenId].addr == address(0)) {
1202                 // This will suffice for checking _exists(nextTokenId),
1203                 // as a burned slot cannot contain the zero address.
1204                 if (nextTokenId < _currentIndex) {
1205                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1206                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1207                 }
1208             }
1209         }
1210 
1211         emit Transfer(from, to, tokenId);
1212         _afterTokenTransfers(from, to, tokenId, 1);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId) internal virtual {
1226         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1227 
1228         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId, prevOwnership.addr);
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1236         unchecked {
1237             _addressData[prevOwnership.addr].balance -= 1;
1238             _addressData[prevOwnership.addr].numberBurned += 1;
1239 
1240             // Keep track of who burned the token, and the timestamp of burning.
1241             _ownerships[tokenId].addr = prevOwnership.addr;
1242             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1243             _ownerships[tokenId].burned = true;
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             if (_ownerships[nextTokenId].addr == address(0)) {
1249                 // This will suffice for checking _exists(nextTokenId),
1250                 // as a burned slot cannot contain the zero address.
1251                 if (nextTokenId < _currentIndex) {
1252                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1253                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(prevOwnership.addr, address(0), tokenId);
1259         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1260 
1261         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1262         unchecked { 
1263             _burnCounter++;
1264         }
1265     }
1266 
1267     /**
1268      * @dev Approve `to` to operate on `tokenId`
1269      *
1270      * Emits a {Approval} event.
1271      */
1272     function _approve(
1273         address to,
1274         uint256 tokenId,
1275         address owner
1276     ) private {
1277         _tokenApprovals[tokenId] = to;
1278         emit Approval(owner, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1283      * The call is not executed if the target address is not a contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         if (to.isContract()) {
1298             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1299                 return retval == IERC721Receiver(to).onERC721Received.selector;
1300             } catch (bytes memory reason) {
1301                 if (reason.length == 0) {
1302                     revert TransferToNonERC721ReceiverImplementer();
1303                 } else {
1304                     assembly {
1305                         revert(add(32, reason), mload(reason))
1306                     }
1307                 }
1308             }
1309         } else {
1310             return true;
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
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
1339      * And also called after one token has been burned.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 }
1359 // File: contracts/xMfers.sol
1360 
1361 
1362 
1363 pragma solidity ^0.8.4;
1364 
1365 //contract forked from 0xmfers
1366 
1367 
1368 
1369 contract v4apes is ERC721A, Ownable, ReentrancyGuard {
1370     using Strings for uint256;
1371 
1372     uint256 public V4APRICE; //0.01 Ξ = 10000000000000000 Wei
1373     uint256 public V4AMAX_SUPPLY; //MAX SUPPLY IS 10000
1374     uint256 public FREE_MINT_CAP_PER_WALLET_ADDRESS; //2 Free Mints PER WALLET 
1375     uint256 public MAX_MINT_QUANTITY_PER_TX; //MAX 100 PER WALLET
1376     uint256 public FREE_MINT_IS_ALLOWED_UNTIL; // FREE MINT UNTIL X AMOUNT HAVE BEEN CLAIMED
1377     bool public IS_SALE_UP_AND_RUNNING; //ALL THINGS ARE A GO
1378     bool public IS_METADATA_FROZEN; //FREEZE METADATA AFTER MINTED HAS BEEN REVEALED 
1379     string private BASE_URI; //METADATA
1380     string public baseExtension = ".json";
1381 
1382     mapping(address => uint256) private freeMintCountMap;
1383 
1384     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintAllowance, uint256 maxMintPerTx, bool isSaleActive, uint256 freeMintIsAllowedUntil) ERC721A("V4Apes", "V4Apes") {
1385         V4APRICE = price;
1386         V4AMAX_SUPPLY = maxSupply;
1387         BASE_URI = baseUri;
1388         FREE_MINT_CAP_PER_WALLET_ADDRESS = freeMintAllowance;
1389         MAX_MINT_QUANTITY_PER_TX = maxMintPerTx;
1390         IS_SALE_UP_AND_RUNNING = isSaleActive;
1391         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1392     }
1393 
1394     /** GETTERS **/
1395 
1396     function _baseURI() internal view virtual override returns (string memory) {
1397         return BASE_URI;
1398     }
1399 
1400     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1401     {
1402     require(_exists(tokenId),"ERC721AMetadata: URI query for nonexistent token");
1403     string memory currentBaseURI = _baseURI();
1404     return bytes(currentBaseURI).length > 0
1405         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1406         : "ipfs://QmbqCxYz4Ai9J1Zt1AdzvYAgMSJREq8UQWNs2WQs5NfHX1/";
1407         }
1408 
1409     /** SETTERS  **/
1410 
1411     function setPrice(uint256 customPrice) external onlyOwner {
1412         V4APRICE = customPrice;
1413     }
1414 
1415     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1416         require(newMaxSupply < V4AMAX_SUPPLY, "Invalid new max supply");
1417         require(newMaxSupply >= _currentIndex, "Invalid new max supply");
1418         V4AMAX_SUPPLY = newMaxSupply;
1419     }
1420 
1421     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1422         require(!IS_METADATA_FROZEN, "Metadata is already frozen!");
1423         BASE_URI = customBaseURI_;
1424     }
1425 
1426     function setFreeMintAllowance(uint256 freeMintAllowance) external onlyOwner {
1427         FREE_MINT_CAP_PER_WALLET_ADDRESS = freeMintAllowance;
1428     }
1429 
1430     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1431         MAX_MINT_QUANTITY_PER_TX = maxMintPerTx;
1432     }
1433 
1434     function setSaleActive(bool saleIsActive) external onlyOwner {
1435         IS_SALE_UP_AND_RUNNING = saleIsActive;
1436     }
1437 
1438     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1439         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1440     }
1441 
1442     function freezeMetadata() external onlyOwner {
1443         IS_METADATA_FROZEN = true;
1444     }
1445 
1446     /** FREE MINT FOR THE LUCKY APES**/
1447 
1448     function updateFreeMintCount(address minter, uint256 count) private {
1449         freeMintCountMap[minter] += count;
1450     }
1451 
1452     /** MINT APES **/
1453 
1454     modifier mintCompliance(uint256 _mintAmount) {
1455         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_QUANTITY_PER_TX, "Invalid mint amount!");
1456         require(_currentIndex + _mintAmount <= V4AMAX_SUPPLY, "Max supply exceeded!");
1457         _;
1458     }
1459 
1460     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1461         require(IS_SALE_UP_AND_RUNNING, "Sale is not active!");
1462 
1463         uint256 price = V4APRICE * _mintAmount;
1464 
1465         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1466             uint256 remainingFreeMint = FREE_MINT_CAP_PER_WALLET_ADDRESS - freeMintCountMap[msg.sender];
1467             if (remainingFreeMint > 0) {
1468                 if (_mintAmount >= remainingFreeMint) {
1469                     price -= remainingFreeMint * V4APRICE;
1470                     updateFreeMintCount(msg.sender, remainingFreeMint);
1471                 } else {
1472                     price -= _mintAmount * V4APRICE;
1473                     updateFreeMintCount(msg.sender, _mintAmount);
1474                 }
1475             }
1476         }
1477 
1478         require(msg.value >= price, "Insufficient funds!");
1479 
1480         _safeMint(msg.sender, _mintAmount);
1481     }
1482 
1483     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1484         _safeMint(_to, _mintAmount);
1485     }
1486 
1487     /** WITHDRAW **/
1488     
1489     //DAO WALLET
1490     address private constant payoutAddress1 = 0xc144647c80F49d8CF5a96872D86B9fA19943cFB8;
1491     
1492 
1493     function withdraw() public onlyOwner nonReentrant {
1494         uint256 balance = address(this).balance;
1495 
1496         Address.sendValue(payable(payoutAddress1), balance / 2);
1497         
1498     }
1499 }