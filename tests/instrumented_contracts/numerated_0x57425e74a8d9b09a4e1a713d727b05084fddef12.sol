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
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
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
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         _checkOwner();
209         _;
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if the sender is not the owner.
221      */
222     function _checkOwner() internal view virtual {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Address.sol
258 
259 
260 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
261 
262 pragma solidity ^0.8.1;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      *
285      * [IMPORTANT]
286      * ====
287      * You shouldn't rely on `isContract` to protect against flash loan attacks!
288      *
289      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
290      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
291      * constructor.
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize/address.code.length, which returns 0
296         // for contracts in construction, since the code is only stored at the end
297         // of the constructor execution.
298 
299         return account.code.length > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain `call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
406         return functionStaticCall(target, data, "Address: low-level static call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         require(isContract(target), "Address: static call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
455      * revert reason using the provided one.
456      *
457      * _Available since v4.3._
458      */
459     function verifyCallResult(
460         bool success,
461         bytes memory returndata,
462         string memory errorMessage
463     ) internal pure returns (bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470                 /// @solidity memory-safe-assembly
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
483 
484 
485 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @title ERC721 token receiver interface
491  * @dev Interface for any contract that wants to support safeTransfers
492  * from ERC721 asset contracts.
493  */
494 interface IERC721Receiver {
495     /**
496      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
497      * by `operator` from `from`, this function is called.
498      *
499      * It must return its Solidity selector to confirm the token transfer.
500      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
501      *
502      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
503      */
504     function onERC721Received(
505         address operator,
506         address from,
507         uint256 tokenId,
508         bytes calldata data
509     ) external returns (bytes4);
510 }
511 
512 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Interface of the ERC165 standard, as defined in the
521  * https://eips.ethereum.org/EIPS/eip-165[EIP].
522  *
523  * Implementers can declare support of contract interfaces, which can then be
524  * queried by others ({ERC165Checker}).
525  *
526  * For an implementation, see {ERC165}.
527  */
528 interface IERC165 {
529     /**
530      * @dev Returns true if this contract implements the interface defined by
531      * `interfaceId`. See the corresponding
532      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
533      * to learn more about how these ids are created.
534      *
535      * This function call must use less than 30 000 gas.
536      */
537     function supportsInterface(bytes4 interfaceId) external view returns (bool);
538 }
539 
540 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
572 
573 
574 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @dev Required interface of an ERC721 compliant contract.
581  */
582 interface IERC721 is IERC165 {
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
590      */
591     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
595      */
596     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
597 
598     /**
599      * @dev Returns the number of tokens in ``owner``'s account.
600      */
601     function balanceOf(address owner) external view returns (uint256 balance);
602 
603     /**
604      * @dev Returns the owner of the `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function ownerOf(uint256 tokenId) external view returns (address owner);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external;
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
634      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Transfers `tokenId` token from `from` to `to`.
654      *
655      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must be owned by `from`.
662      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
663      *
664      * Emits a {Transfer} event.
665      */
666     function transferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) external;
671 
672     /**
673      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
674      * The approval is cleared when the token is transferred.
675      *
676      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
677      *
678      * Requirements:
679      *
680      * - The caller must own the token or be an approved operator.
681      * - `tokenId` must exist.
682      *
683      * Emits an {Approval} event.
684      */
685     function approve(address to, uint256 tokenId) external;
686 
687     /**
688      * @dev Approve or remove `operator` as an operator for the caller.
689      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
690      *
691      * Requirements:
692      *
693      * - The `operator` cannot be the caller.
694      *
695      * Emits an {ApprovalForAll} event.
696      */
697     function setApprovalForAll(address operator, bool _approved) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId) external view returns (address operator);
707 
708     /**
709      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
710      *
711      * See {setApprovalForAll}
712      */
713     function isApprovedForAll(address owner, address operator) external view returns (bool);
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Metadata is IERC721 {
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() external view returns (string memory);
733 
734     /**
735      * @dev Returns the token collection symbol.
736      */
737     function symbol() external view returns (string memory);
738 
739     /**
740      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
741      */
742     function tokenURI(uint256 tokenId) external view returns (string memory);
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
746 
747 
748 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 
753 
754 
755 
756 
757 
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension, but not including the Enumerable extension, which is available separately as
762  * {ERC721Enumerable}.
763  */
764 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to owner address
775     mapping(uint256 => address) private _owners;
776 
777     // Mapping owner address to token count
778     mapping(address => uint256) private _balances;
779 
780     // Mapping from token ID to approved address
781     mapping(uint256 => address) private _tokenApprovals;
782 
783     // Mapping from owner to operator approvals
784     mapping(address => mapping(address => bool)) private _operatorApprovals;
785 
786     /**
787      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
788      */
789     constructor(string memory name_, string memory symbol_) {
790         _name = name_;
791         _symbol = symbol_;
792     }
793 
794     /**
795      * @dev See {IERC165-supportsInterface}.
796      */
797     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
798         return
799             interfaceId == type(IERC721).interfaceId ||
800             interfaceId == type(IERC721Metadata).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     /**
805      * @dev See {IERC721-balanceOf}.
806      */
807     function balanceOf(address owner) public view virtual override returns (uint256) {
808         require(owner != address(0), "ERC721: address zero is not a valid owner");
809         return _balances[owner];
810     }
811 
812     /**
813      * @dev See {IERC721-ownerOf}.
814      */
815     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
816         address owner = _owners[tokenId];
817         require(owner != address(0), "ERC721: invalid token ID");
818         return owner;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-name}.
823      */
824     function name() public view virtual override returns (string memory) {
825         return _name;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-symbol}.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-tokenURI}.
837      */
838     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
839         _requireMinted(tokenId);
840 
841         string memory baseURI = _baseURI();
842         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
843     }
844 
845     /**
846      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
847      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
848      * by default, can be overridden in child contracts.
849      */
850     function _baseURI() internal view virtual returns (string memory) {
851         return "";
852     }
853 
854     /**
855      * @dev See {IERC721-approve}.
856      */
857     function approve(address to, uint256 tokenId) public virtual override {
858         address owner = ERC721.ownerOf(tokenId);
859         require(to != owner, "ERC721: approval to current owner");
860 
861         require(
862             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
863             "ERC721: approve caller is not token owner nor approved for all"
864         );
865 
866         _approve(to, tokenId);
867     }
868 
869     /**
870      * @dev See {IERC721-getApproved}.
871      */
872     function getApproved(uint256 tokenId) public view virtual override returns (address) {
873         _requireMinted(tokenId);
874 
875         return _tokenApprovals[tokenId];
876     }
877 
878     /**
879      * @dev See {IERC721-setApprovalForAll}.
880      */
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         _setApprovalForAll(_msgSender(), operator, approved);
883     }
884 
885     /**
886      * @dev See {IERC721-isApprovedForAll}.
887      */
888     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
889         return _operatorApprovals[owner][operator];
890     }
891 
892     /**
893      * @dev See {IERC721-transferFrom}.
894      */
895     function transferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         //solhint-disable-next-line max-line-length
901         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
902 
903         _transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         safeTransferFrom(from, to, tokenId, "");
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory data
925     ) public virtual override {
926         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
927         _safeTransfer(from, to, tokenId, data);
928     }
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * `data` is additional data, it has no specified format and it is sent in call to `to`.
935      *
936      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
937      * implement alternative mechanisms to perform token transfer, such as signature-based.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeTransfer(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory data
953     ) internal virtual {
954         _transfer(from, to, tokenId);
955         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
956     }
957 
958     /**
959      * @dev Returns whether `tokenId` exists.
960      *
961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
962      *
963      * Tokens start existing when they are minted (`_mint`),
964      * and stop existing when they are burned (`_burn`).
965      */
966     function _exists(uint256 tokenId) internal view virtual returns (bool) {
967         return _owners[tokenId] != address(0);
968     }
969 
970     /**
971      * @dev Returns whether `spender` is allowed to manage `tokenId`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      */
977     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
978         address owner = ERC721.ownerOf(tokenId);
979         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
980     }
981 
982     /**
983      * @dev Safely mints `tokenId` and transfers it to `to`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _safeMint(address to, uint256 tokenId) internal virtual {
993         _safeMint(to, tokenId, "");
994     }
995 
996     /**
997      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
998      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
999      */
1000     function _safeMint(
1001         address to,
1002         uint256 tokenId,
1003         bytes memory data
1004     ) internal virtual {
1005         _mint(to, tokenId);
1006         require(
1007             _checkOnERC721Received(address(0), to, tokenId, data),
1008             "ERC721: transfer to non ERC721Receiver implementer"
1009         );
1010     }
1011 
1012     /**
1013      * @dev Mints `tokenId` and transfers it to `to`.
1014      *
1015      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must not exist.
1020      * - `to` cannot be the zero address.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(address to, uint256 tokenId) internal virtual {
1025         require(to != address(0), "ERC721: mint to the zero address");
1026         require(!_exists(tokenId), "ERC721: token already minted");
1027 
1028         _beforeTokenTransfer(address(0), to, tokenId);
1029 
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(address(0), to, tokenId);
1034 
1035         _afterTokenTransfer(address(0), to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Destroys `tokenId`.
1040      * The approval is cleared when the token is burned.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _burn(uint256 tokenId) internal virtual {
1049         address owner = ERC721.ownerOf(tokenId);
1050 
1051         _beforeTokenTransfer(owner, address(0), tokenId);
1052 
1053         // Clear approvals
1054         _approve(address(0), tokenId);
1055 
1056         _balances[owner] -= 1;
1057         delete _owners[tokenId];
1058 
1059         emit Transfer(owner, address(0), tokenId);
1060 
1061         _afterTokenTransfer(owner, address(0), tokenId);
1062     }
1063 
1064     /**
1065      * @dev Transfers `tokenId` from `from` to `to`.
1066      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) internal virtual {
1080         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1081         require(to != address(0), "ERC721: transfer to the zero address");
1082 
1083         _beforeTokenTransfer(from, to, tokenId);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId);
1087 
1088         _balances[from] -= 1;
1089         _balances[to] += 1;
1090         _owners[tokenId] = to;
1091 
1092         emit Transfer(from, to, tokenId);
1093 
1094         _afterTokenTransfer(from, to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Approve `to` to operate on `tokenId`
1099      *
1100      * Emits an {Approval} event.
1101      */
1102     function _approve(address to, uint256 tokenId) internal virtual {
1103         _tokenApprovals[tokenId] = to;
1104         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `operator` to operate on all of `owner` tokens
1109      *
1110      * Emits an {ApprovalForAll} event.
1111      */
1112     function _setApprovalForAll(
1113         address owner,
1114         address operator,
1115         bool approved
1116     ) internal virtual {
1117         require(owner != operator, "ERC721: approve to caller");
1118         _operatorApprovals[owner][operator] = approved;
1119         emit ApprovalForAll(owner, operator, approved);
1120     }
1121 
1122     /**
1123      * @dev Reverts if the `tokenId` has not been minted yet.
1124      */
1125     function _requireMinted(uint256 tokenId) internal view virtual {
1126         require(_exists(tokenId), "ERC721: invalid token ID");
1127     }
1128 
1129     /**
1130      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1131      * The call is not executed if the target address is not a contract.
1132      *
1133      * @param from address representing the previous owner of the given token ID
1134      * @param to target address that will receive the tokens
1135      * @param tokenId uint256 ID of the token to be transferred
1136      * @param data bytes optional data to send along with the call
1137      * @return bool whether the call correctly returned the expected magic value
1138      */
1139     function _checkOnERC721Received(
1140         address from,
1141         address to,
1142         uint256 tokenId,
1143         bytes memory data
1144     ) private returns (bool) {
1145         if (to.isContract()) {
1146             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1147                 return retval == IERC721Receiver.onERC721Received.selector;
1148             } catch (bytes memory reason) {
1149                 if (reason.length == 0) {
1150                     revert("ERC721: transfer to non ERC721Receiver implementer");
1151                 } else {
1152                     /// @solidity memory-safe-assembly
1153                     assembly {
1154                         revert(add(32, reason), mload(reason))
1155                     }
1156                 }
1157             }
1158         } else {
1159             return true;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before any token transfer. This includes minting
1165      * and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1170      * transferred to `to`.
1171      * - When `from` is zero, `tokenId` will be minted for `to`.
1172      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1173      * - `from` and `to` are never both zero.
1174      *
1175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1176      */
1177     function _beforeTokenTransfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) internal virtual {}
1182 
1183     /**
1184      * @dev Hook that is called after any transfer of tokens. This includes
1185      * minting and burning.
1186      *
1187      * Calling conditions:
1188      *
1189      * - when `from` and `to` are both non-zero.
1190      * - `from` and `to` are never both zero.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _afterTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {}
1199 }
1200 
1201 // File: contracts/SWEETS.sol
1202 
1203 
1204 pragma solidity 0.8.12;
1205 
1206 
1207 
1208 
1209 contract SWEETS is ERC721, Ownable, ReentrancyGuard {
1210 
1211     string[] private shapes = [
1212     "Pillhead",
1213     "Smiler",
1214     "Spektral",
1215     "Helix",
1216     "Tesseract",
1217     "Torus",
1218     "Obelisk"
1219     ];
1220 
1221     string[] private sizes = [
1222     "Nibble",
1223     "Bite",
1224     "Devour"
1225     ];
1226 
1227     string[] private surfaces = [
1228     "Hydro",
1229     "Plated",
1230     "Tactile"
1231     ];
1232 
1233     string[] private colors = [
1234     "#E7434F",
1235     "#E7973D",
1236     "#E7DC4E",
1237     "#5CE75D",
1238     "#2981E7",
1239     "#5D21E7",
1240     "#E777E4",
1241     "#E7E7E7",
1242     "#312624",
1243     "#E7969F",
1244     "#E7B277",
1245     "#E7DD8F",
1246     "#8CE7C3",
1247     "#87B2E7",
1248     "#A082E7",
1249     "#E4B7E7"
1250     ];
1251 
1252     string public algorithm;
1253     uint256 private n;
1254 
1255     constructor() ERC721 ("SWEETS", "SWEETS") Ownable() {}
1256 
1257     function mint() public nonReentrant {
1258         require(n < 4500);
1259         n++;
1260         _safeMint(msg.sender, n);
1261     }
1262 
1263     function ownerMint(uint256 id) public nonReentrant onlyOwner {
1264         require(id > 4500 && id <= 5000);
1265         _safeMint(msg.sender, id);
1266     }
1267 
1268     function setAlgo(string memory algo) public onlyOwner {
1269         algorithm = algo;
1270     }
1271 
1272     function rand(uint256 id, string memory trait, string[] memory values) internal pure returns (string memory) {
1273         uint256 k = uint256(keccak256(abi.encodePacked(trait, toString(id))));
1274         return values[k % values.length];
1275     }
1276 
1277     function getSize(uint256 id) public view returns (string memory) {
1278         return rand(id, "size", sizes);
1279     }
1280 
1281     function getSurface(uint256 id) public view returns (string memory) {
1282         return rand(id, "surface", surfaces);
1283     }
1284 
1285     function getShape(uint256 id) public view returns (string memory) {
1286         return rand(id, "shape", shapes);
1287     }
1288 
1289     function getParamValues(uint256 tokenId) public view returns (string[4] memory, string memory shape, string memory size, string memory surface) {
1290         return (getPalette(tokenId), getShape(tokenId), getSize(tokenId), getSurface(tokenId));
1291     }
1292 
1293     function getPalette(uint256 id) public view returns (string[4] memory) {
1294         string[4] memory palette;
1295         palette[0] = rand(id, "color 0", colors);
1296         palette[1] = rand(id, "color 1", colors);
1297         palette[2] = rand(id, "color 2", colors);
1298         palette[3] = rand(id, "color 3", colors);
1299         return palette;
1300     }
1301 
1302     function toString(uint256 value) internal pure returns (string memory) {
1303         if (value == 0) {return "0";}
1304         uint256 temp = value;
1305         uint256 digits;
1306         while (temp != 0) {
1307             digits++;
1308             temp /= 10;
1309         }
1310         bytes memory buffer = new bytes(digits);
1311         while (value != 0) {
1312             digits -= 1;
1313             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1314             value /= 10;
1315 
1316         }
1317         return string(buffer);
1318     }
1319 
1320     function _baseURI() internal view override returns (string memory) {
1321         return "https://rendering.rove.to/v1/rendered-nft/1/metadata/";
1322     }
1323 }