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
745 // File: ERC721A.sol
746 
747 
748 // Creator: Chiru Labs
749 
750 pragma solidity ^0.8.4;
751 
752 
753 
754 
755 
756 
757 
758 
759 error ApprovalCallerNotOwnerNorApproved();
760 error ApprovalQueryForNonexistentToken();
761 error ApproveToCaller();
762 error ApprovalToCurrentOwner();
763 error BalanceQueryForZeroAddress();
764 error MintToZeroAddress();
765 error MintZeroQuantity();
766 error OwnerQueryForNonexistentToken();
767 error TransferCallerNotOwnerNorApproved();
768 error TransferFromIncorrectOwner();
769 error TransferToNonERC721ReceiverImplementer();
770 error TransferToZeroAddress();
771 error URIQueryForNonexistentToken();
772 
773 /**
774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
775  * the Metadata extension. Built to optimize for lower gas during batch mints.
776  *
777  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
778  *
779  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
780  *
781  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
782  */
783 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
784     using Address for address;
785     using Strings for uint256;
786 
787     // Compiler will pack this into a single 256bit word.
788     struct TokenOwnership {
789         // The address of the owner.
790         address addr;
791         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
792         uint64 startTimestamp;
793         // Whether the token has been burned.
794         bool burned;
795     }
796 
797     // Compiler will pack this into a single 256bit word.
798     struct AddressData {
799         // Realistically, 2**64-1 is more than enough.
800         uint64 balance;
801         // Keeps track of mint count with minimal overhead for tokenomics.
802         uint64 numberMinted;
803         // Keeps track of burn count with minimal overhead for tokenomics.
804         uint64 numberBurned;
805         // For miscellaneous variable(s) pertaining to the address
806         // (e.g. number of whitelist mint slots used).
807         // If there are multiple variables, please pack them into a uint64.
808         uint64 aux;
809     }
810 
811     // The tokenId of the next token to be minted.
812     uint256 internal _currentIndex;
813 
814     // The number of tokens burned.
815     uint256 internal _burnCounter;
816 
817     // Token name
818     string private _name;
819 
820     // Token symbol
821     string private _symbol;
822 
823     // Mapping from token ID to ownership details
824     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
825     mapping(uint256 => TokenOwnership) internal _ownerships;
826 
827     // Mapping owner address to address data
828     mapping(address => AddressData) private _addressData;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839         _currentIndex = _startTokenId();
840     }
841 
842     /**
843      * To change the starting tokenId, please override this function.
844      */
845     function _startTokenId() internal view virtual returns (uint256) {
846         return 0;
847     }
848 
849     /**
850      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
851      */
852     function totalSupply() public view returns (uint256) {
853         // Counter underflow is impossible as _burnCounter cannot be incremented
854         // more than _currentIndex - _startTokenId() times
855         unchecked {
856             return _currentIndex - _burnCounter - _startTokenId();
857         }
858     }
859 
860     /**
861      * Returns the total amount of tokens minted in the contract.
862      */
863     function _totalMinted() internal view returns (uint256) {
864         // Counter underflow is impossible as _currentIndex does not decrement,
865         // and it is initialized to _startTokenId()
866         unchecked {
867             return _currentIndex - _startTokenId();
868         }
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886         return uint256(_addressData[owner].balance);
887     }
888 
889     /**
890      * Returns the number of tokens minted by `owner`.
891      */
892     function _numberMinted(address owner) internal view returns (uint256) {
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     /**
897      * Returns the number of tokens burned by or on behalf of `owner`.
898      */
899     function _numberBurned(address owner) internal view returns (uint256) {
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         _addressData[owner].aux = aux;
916     }
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr && curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932                     // Invariant:
933                     // There will always be an ownership that has an address and is not burned
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     while (true) {
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     }
943                 }
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return _ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public virtual override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1075     }
1076 
1077     function _safeMint(address to, uint256 quantity) internal {
1078         _safeMint(to, quantity, '');
1079     }
1080 
1081     /**
1082      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeMint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data
1095     ) internal {
1096         _mint(to, quantity, _data, true);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _mint(
1110         address to,
1111         uint256 quantity,
1112         bytes memory _data,
1113         bool safe
1114     ) internal {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118 
1119         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1120 
1121         // Overflows are incredibly unrealistic.
1122         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1123         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1124         unchecked {
1125             _addressData[to].balance += uint64(quantity);
1126             _addressData[to].numberMinted += uint64(quantity);
1127 
1128             _ownerships[startTokenId].addr = to;
1129             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1130 
1131             uint256 updatedIndex = startTokenId;
1132             uint256 end = updatedIndex + quantity;
1133 
1134             if (safe && to.isContract()) {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex);
1137                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1138                         revert TransferToNonERC721ReceiverImplementer();
1139                     }
1140                 } while (updatedIndex != end);
1141                 // Reentrancy protection
1142                 if (_currentIndex != startTokenId) revert();
1143             } else {
1144                 do {
1145                     emit Transfer(address(0), to, updatedIndex++);
1146                 } while (updatedIndex != end);
1147             }
1148             _currentIndex = updatedIndex;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Transfers `tokenId` from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must be owned by `from`.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _transfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) private {
1168         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1169 
1170         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1171 
1172         bool isApprovedOrOwner = (_msgSender() == from ||
1173             isApprovedForAll(from, _msgSender()) ||
1174             getApproved(tokenId) == _msgSender());
1175 
1176         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1177         if (to == address(0)) revert TransferToZeroAddress();
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId, from);
1183 
1184         // Underflow of the sender's balance is impossible because we check for
1185         // ownership above and the recipient's balance can't realistically overflow.
1186         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1187         unchecked {
1188             _addressData[from].balance -= 1;
1189             _addressData[to].balance += 1;
1190 
1191             TokenOwnership storage currSlot = _ownerships[tokenId];
1192             currSlot.addr = to;
1193             currSlot.startTimestamp = uint64(block.timestamp);
1194 
1195             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1196             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1197             uint256 nextTokenId = tokenId + 1;
1198             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1199             if (nextSlot.addr == address(0)) {
1200                 // This will suffice for checking _exists(nextTokenId),
1201                 // as a burned slot cannot contain the zero address.
1202                 if (nextTokenId != _currentIndex) {
1203                     nextSlot.addr = from;
1204                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1205                 }
1206             }
1207         }
1208 
1209         emit Transfer(from, to, tokenId);
1210         _afterTokenTransfers(from, to, tokenId, 1);
1211     }
1212 
1213     /**
1214      * @dev This is equivalent to _burn(tokenId, false)
1215      */
1216     function _burn(uint256 tokenId) internal virtual {
1217         _burn(tokenId, false);
1218     }
1219 
1220     /**
1221      * @dev Destroys `tokenId`.
1222      * The approval is cleared when the token is burned.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1231         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1232 
1233         address from = prevOwnership.addr;
1234 
1235         if (approvalCheck) {
1236             bool isApprovedOrOwner = (_msgSender() == from ||
1237                 isApprovedForAll(from, _msgSender()) ||
1238                 getApproved(tokenId) == _msgSender());
1239 
1240             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1241         }
1242 
1243         _beforeTokenTransfers(from, address(0), tokenId, 1);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId, from);
1247 
1248         // Underflow of the sender's balance is impossible because we check for
1249         // ownership above and the recipient's balance can't realistically overflow.
1250         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1251         unchecked {
1252             AddressData storage addressData = _addressData[from];
1253             addressData.balance -= 1;
1254             addressData.numberBurned += 1;
1255 
1256             // Keep track of who burned the token, and the timestamp of burning.
1257             TokenOwnership storage currSlot = _ownerships[tokenId];
1258             currSlot.addr = from;
1259             currSlot.startTimestamp = uint64(block.timestamp);
1260             currSlot.burned = true;
1261 
1262             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1263             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1264             uint256 nextTokenId = tokenId + 1;
1265             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1266             if (nextSlot.addr == address(0)) {
1267                 // This will suffice for checking _exists(nextTokenId),
1268                 // as a burned slot cannot contain the zero address.
1269                 if (nextTokenId != _currentIndex) {
1270                     nextSlot.addr = from;
1271                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, address(0), tokenId);
1277         _afterTokenTransfers(from, address(0), tokenId, 1);
1278 
1279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1280         unchecked {
1281             _burnCounter++;
1282         }
1283     }
1284 
1285     /**
1286      * @dev Approve `to` to operate on `tokenId`
1287      *
1288      * Emits a {Approval} event.
1289      */
1290     function _approve(
1291         address to,
1292         uint256 tokenId,
1293         address owner
1294     ) private {
1295         _tokenApprovals[tokenId] = to;
1296         emit Approval(owner, to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1301      *
1302      * @param from address representing the previous owner of the given token ID
1303      * @param to target address that will receive the tokens
1304      * @param tokenId uint256 ID of the token to be transferred
1305      * @param _data bytes optional data to send along with the call
1306      * @return bool whether the call correctly returned the expected magic value
1307      */
1308     function _checkContractOnERC721Received(
1309         address from,
1310         address to,
1311         uint256 tokenId,
1312         bytes memory _data
1313     ) private returns (bool) {
1314         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1315             return retval == IERC721Receiver(to).onERC721Received.selector;
1316         } catch (bytes memory reason) {
1317             if (reason.length == 0) {
1318                 revert TransferToNonERC721ReceiverImplementer();
1319             } else {
1320                 assembly {
1321                     revert(add(32, reason), mload(reason))
1322                 }
1323             }
1324         }
1325     }
1326 
1327     /**
1328      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1329      * And also called before burning one token.
1330      *
1331      * startTokenId - the first token id to be transferred
1332      * quantity - the amount to be transferred
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, `tokenId` will be burned by `from`.
1340      * - `from` and `to` are never both zero.
1341      */
1342     function _beforeTokenTransfers(
1343         address from,
1344         address to,
1345         uint256 startTokenId,
1346         uint256 quantity
1347     ) internal virtual {}
1348 
1349     /**
1350      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1351      * minting.
1352      * And also called after one token has been burned.
1353      *
1354      * startTokenId - the first token id to be transferred
1355      * quantity - the amount to be transferred
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` has been minted for `to`.
1362      * - When `to` is zero, `tokenId` has been burned by `from`.
1363      * - `from` and `to` are never both zero.
1364      */
1365     function _afterTokenTransfers(
1366         address from,
1367         address to,
1368         uint256 startTokenId,
1369         uint256 quantity
1370     ) internal virtual {}
1371 }
1372 // File: RegretThisPurchase.sol
1373 
1374 
1375 
1376 pragma solidity >=0.8.12 <0.9.0;
1377 
1378 
1379 
1380 
1381 contract nft is ERC721A, Ownable, ReentrancyGuard {
1382   using Strings for uint256;
1383   uint constant public supply = 355;
1384   string[supply] public sqOrRect;
1385   string constant private square = "square";
1386   string constant private rectangle = "rectangle";
1387   string private uriPrefix;
1388   string private uriSuffix = ".json";
1389   string private hiddenMetadataUri;
1390   uint public cost;
1391   uint public maxSupply;
1392   bool private paused = true;
1393   bool private revealed = true;
1394 
1395   constructor() ERC721A("Regret This Purchase", "REGRETTHISPURCHASE"){
1396     cost = 0;
1397     maxSupply = supply;
1398     hiddenMetadataUri = "";
1399     uriPrefix = "ipfs://";
1400   }
1401 
1402   function makeSqOrRect(uint256 _mintAmount) internal {    
1403     string[supply] storage _sor = sqOrRect;
1404     uint _indexIncrement = 1;
1405 
1406     for (uint i = 0; i < _mintAmount; i++){
1407       uint current = uint(block.number);   
1408       string memory _sqOrRect = uint(current % 2) == 0 ? square : rectangle;
1409       _sor[_currentIndex - _indexIncrement] = _sqOrRect;
1410       _indexIncrement++;
1411     }
1412   }
1413 
1414   function _baseURI() internal view virtual override returns (string memory){
1415     return uriPrefix;
1416   }
1417 
1418   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
1419     require(!paused, "Minting is paused.");
1420     _safeMint(_msgSender(), _mintAmount);
1421     makeSqOrRect(_mintAmount);
1422 
1423     if (_currentIndex == 100){
1424       paused = true;
1425     }
1426   }
1427  
1428   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1429     _safeMint(_receiver, _mintAmount);
1430   }
1431 
1432   function _startTokenId() internal view virtual override returns (uint256){
1433     return 1;
1434   }
1435 
1436   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1437     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1438 
1439     if (revealed == false){
1440       return hiddenMetadataUri;
1441     }
1442     string memory currentBaseURI = _baseURI();
1443     string memory sor = sqOrRect[_tokenId];
1444 
1445     currentBaseURI = string.concat(currentBaseURI, _tokenId.toString(), "-", sor);
1446 
1447     return bytes(currentBaseURI).length > 0
1448         ? string(abi.encodePacked(currentBaseURI, uriSuffix))
1449         : '';
1450   }
1451 
1452   function setRevealed(bool _state) public onlyOwner {
1453     revealed = _state;
1454   }
1455 
1456   function setCost(uint256 _cost) public onlyOwner {
1457     cost = _cost;
1458   }
1459 
1460   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1461     hiddenMetadataUri = _hiddenMetadataUri;
1462   }
1463 
1464   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1465     uriPrefix = _uriPrefix;
1466   }
1467 
1468   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1469     uriSuffix = _uriSuffix;
1470   }
1471 
1472   function setPaused(bool _state) public onlyOwner {
1473     paused = _state;
1474   }
1475 
1476   function withdraw() public onlyOwner nonReentrant {
1477     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1478     require(os);
1479   }
1480 
1481   modifier mintCompliance(uint256 _mintAmount){
1482     require(_mintAmount > 0, "Invalid mint amount.");
1483     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded.");
1484     _;
1485   }
1486 
1487   modifier mintPriceCompliance(uint256 _mintAmount){
1488     require(msg.value >= cost * _mintAmount, "Insufficient funds.");
1489     _;
1490   }
1491 }