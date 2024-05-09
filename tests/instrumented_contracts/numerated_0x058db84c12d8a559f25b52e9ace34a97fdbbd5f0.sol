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
716 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
717 
718 
719 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Enumerable is IERC721 {
729     /**
730      * @dev Returns the total amount of tokens stored by the contract.
731      */
732     function totalSupply() external view returns (uint256);
733 
734     /**
735      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
736      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
737      */
738     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
739 
740     /**
741      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
742      * Use along with {totalSupply} to enumerate all tokens.
743      */
744     function tokenByIndex(uint256 index) external view returns (uint256);
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
757  * @dev See https://eips.ethereum.org/EIPS/eip-721
758  */
759 interface IERC721Metadata is IERC721 {
760     /**
761      * @dev Returns the token collection name.
762      */
763     function name() external view returns (string memory);
764 
765     /**
766      * @dev Returns the token collection symbol.
767      */
768     function symbol() external view returns (string memory);
769 
770     /**
771      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
772      */
773     function tokenURI(uint256 tokenId) external view returns (string memory);
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
777 
778 
779 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 
785 
786 
787 
788 
789 
790 /**
791  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
792  * the Metadata extension, but not including the Enumerable extension, which is available separately as
793  * {ERC721Enumerable}.
794  */
795 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
796     using Address for address;
797     using Strings for uint256;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to owner address
806     mapping(uint256 => address) private _owners;
807 
808     // Mapping owner address to token count
809     mapping(address => uint256) private _balances;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     /**
818      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
819      */
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823     }
824 
825     /**
826      * @dev See {IERC165-supportsInterface}.
827      */
828     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
829         return
830             interfaceId == type(IERC721).interfaceId ||
831             interfaceId == type(IERC721Metadata).interfaceId ||
832             super.supportsInterface(interfaceId);
833     }
834 
835     /**
836      * @dev See {IERC721-balanceOf}.
837      */
838     function balanceOf(address owner) public view virtual override returns (uint256) {
839         require(owner != address(0), "ERC721: address zero is not a valid owner");
840         return _balances[owner];
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
847         address owner = _owners[tokenId];
848         require(owner != address(0), "ERC721: invalid token ID");
849         return owner;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-name}.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-symbol}.
861      */
862     function symbol() public view virtual override returns (string memory) {
863         return _symbol;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-tokenURI}.
868      */
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         _requireMinted(tokenId);
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, can be overridden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return "";
883     }
884 
885     /**
886      * @dev See {IERC721-approve}.
887      */
888     function approve(address to, uint256 tokenId) public virtual override {
889         address owner = ERC721.ownerOf(tokenId);
890         require(to != owner, "ERC721: approval to current owner");
891 
892         require(
893             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
894             "ERC721: approve caller is not token owner nor approved for all"
895         );
896 
897         _approve(to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-getApproved}.
902      */
903     function getApproved(uint256 tokenId) public view virtual override returns (address) {
904         _requireMinted(tokenId);
905 
906         return _tokenApprovals[tokenId];
907     }
908 
909     /**
910      * @dev See {IERC721-setApprovalForAll}.
911      */
912     function setApprovalForAll(address operator, bool approved) public virtual override {
913         _setApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         //solhint-disable-next-line max-line-length
932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
933 
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, "");
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory data
956     ) public virtual override {
957         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
958         _safeTransfer(from, to, tokenId, data);
959     }
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
963      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
964      *
965      * `data` is additional data, it has no specified format and it is sent in call to `to`.
966      *
967      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
968      * implement alternative mechanisms to perform token transfer, such as signature-based.
969      *
970      * Requirements:
971      *
972      * - `from` cannot be the zero address.
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must exist and be owned by `from`.
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeTransfer(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory data
984     ) internal virtual {
985         _transfer(from, to, tokenId);
986         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
987     }
988 
989     /**
990      * @dev Returns whether `tokenId` exists.
991      *
992      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
993      *
994      * Tokens start existing when they are minted (`_mint`),
995      * and stop existing when they are burned (`_burn`).
996      */
997     function _exists(uint256 tokenId) internal view virtual returns (bool) {
998         return _owners[tokenId] != address(0);
999     }
1000 
1001     /**
1002      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1009         address owner = ERC721.ownerOf(tokenId);
1010         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1011     }
1012 
1013     /**
1014      * @dev Safely mints `tokenId` and transfers it to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must not exist.
1019      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _safeMint(address to, uint256 tokenId) internal virtual {
1024         _safeMint(to, tokenId, "");
1025     }
1026 
1027     /**
1028      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1029      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1030      */
1031     function _safeMint(
1032         address to,
1033         uint256 tokenId,
1034         bytes memory data
1035     ) internal virtual {
1036         _mint(to, tokenId);
1037         require(
1038             _checkOnERC721Received(address(0), to, tokenId, data),
1039             "ERC721: transfer to non ERC721Receiver implementer"
1040         );
1041     }
1042 
1043     /**
1044      * @dev Mints `tokenId` and transfers it to `to`.
1045      *
1046      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must not exist.
1051      * - `to` cannot be the zero address.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _mint(address to, uint256 tokenId) internal virtual {
1056         require(to != address(0), "ERC721: mint to the zero address");
1057         require(!_exists(tokenId), "ERC721: token already minted");
1058 
1059         _beforeTokenTransfer(address(0), to, tokenId);
1060 
1061         _balances[to] += 1;
1062         _owners[tokenId] = to;
1063 
1064         emit Transfer(address(0), to, tokenId);
1065 
1066         _afterTokenTransfer(address(0), to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId) internal virtual {
1080         address owner = ERC721.ownerOf(tokenId);
1081 
1082         _beforeTokenTransfer(owner, address(0), tokenId);
1083 
1084         // Clear approvals
1085         _approve(address(0), tokenId);
1086 
1087         _balances[owner] -= 1;
1088         delete _owners[tokenId];
1089 
1090         emit Transfer(owner, address(0), tokenId);
1091 
1092         _afterTokenTransfer(owner, address(0), tokenId);
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1098      *
1099      * Requirements:
1100      *
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must be owned by `from`.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _transfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) internal virtual {
1111         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1112         require(to != address(0), "ERC721: transfer to the zero address");
1113 
1114         _beforeTokenTransfer(from, to, tokenId);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId);
1118 
1119         _balances[from] -= 1;
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(from, to, tokenId);
1124 
1125         _afterTokenTransfer(from, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev Approve `to` to operate on `tokenId`
1130      *
1131      * Emits an {Approval} event.
1132      */
1133     function _approve(address to, uint256 tokenId) internal virtual {
1134         _tokenApprovals[tokenId] = to;
1135         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `operator` to operate on all of `owner` tokens
1140      *
1141      * Emits an {ApprovalForAll} event.
1142      */
1143     function _setApprovalForAll(
1144         address owner,
1145         address operator,
1146         bool approved
1147     ) internal virtual {
1148         require(owner != operator, "ERC721: approve to caller");
1149         _operatorApprovals[owner][operator] = approved;
1150         emit ApprovalForAll(owner, operator, approved);
1151     }
1152 
1153     /**
1154      * @dev Reverts if the `tokenId` has not been minted yet.
1155      */
1156     function _requireMinted(uint256 tokenId) internal view virtual {
1157         require(_exists(tokenId), "ERC721: invalid token ID");
1158     }
1159 
1160     /**
1161      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1162      * The call is not executed if the target address is not a contract.
1163      *
1164      * @param from address representing the previous owner of the given token ID
1165      * @param to target address that will receive the tokens
1166      * @param tokenId uint256 ID of the token to be transferred
1167      * @param data bytes optional data to send along with the call
1168      * @return bool whether the call correctly returned the expected magic value
1169      */
1170     function _checkOnERC721Received(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory data
1175     ) private returns (bool) {
1176         if (to.isContract()) {
1177             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1178                 return retval == IERC721Receiver.onERC721Received.selector;
1179             } catch (bytes memory reason) {
1180                 if (reason.length == 0) {
1181                     revert("ERC721: transfer to non ERC721Receiver implementer");
1182                 } else {
1183                     /// @solidity memory-safe-assembly
1184                     assembly {
1185                         revert(add(32, reason), mload(reason))
1186                     }
1187                 }
1188             }
1189         } else {
1190             return true;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before any token transfer. This includes minting
1196      * and burning.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1204      * - `from` and `to` are never both zero.
1205      *
1206      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1207      */
1208     function _beforeTokenTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {}
1213 
1214     /**
1215      * @dev Hook that is called after any transfer of tokens. This includes
1216      * minting and burning.
1217      *
1218      * Calling conditions:
1219      *
1220      * - when `from` and `to` are both non-zero.
1221      * - `from` and `to` are never both zero.
1222      *
1223      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1224      */
1225     function _afterTokenTransfer(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) internal virtual {}
1230 }
1231 
1232 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1233 
1234 
1235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 
1240 
1241 /**
1242  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1243  * enumerability of all the token ids in the contract as well as all token ids owned by each
1244  * account.
1245  */
1246 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1247     // Mapping from owner to list of owned token IDs
1248     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1249 
1250     // Mapping from token ID to index of the owner tokens list
1251     mapping(uint256 => uint256) private _ownedTokensIndex;
1252 
1253     // Array with all token ids, used for enumeration
1254     uint256[] private _allTokens;
1255 
1256     // Mapping from token id to position in the allTokens array
1257     mapping(uint256 => uint256) private _allTokensIndex;
1258 
1259     /**
1260      * @dev See {IERC165-supportsInterface}.
1261      */
1262     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1263         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1268      */
1269     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1270         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1271         return _ownedTokens[owner][index];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Enumerable-totalSupply}.
1276      */
1277     function totalSupply() public view virtual override returns (uint256) {
1278         return _allTokens.length;
1279     }
1280 
1281     /**
1282      * @dev See {IERC721Enumerable-tokenByIndex}.
1283      */
1284     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1285         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1286         return _allTokens[index];
1287     }
1288 
1289     /**
1290      * @dev Hook that is called before any token transfer. This includes minting
1291      * and burning.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1299      * - `from` cannot be the zero address.
1300      * - `to` cannot be the zero address.
1301      *
1302      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1303      */
1304     function _beforeTokenTransfer(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) internal virtual override {
1309         super._beforeTokenTransfer(from, to, tokenId);
1310 
1311         if (from == address(0)) {
1312             _addTokenToAllTokensEnumeration(tokenId);
1313         } else if (from != to) {
1314             _removeTokenFromOwnerEnumeration(from, tokenId);
1315         }
1316         if (to == address(0)) {
1317             _removeTokenFromAllTokensEnumeration(tokenId);
1318         } else if (to != from) {
1319             _addTokenToOwnerEnumeration(to, tokenId);
1320         }
1321     }
1322 
1323     /**
1324      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1325      * @param to address representing the new owner of the given token ID
1326      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1327      */
1328     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1329         uint256 length = ERC721.balanceOf(to);
1330         _ownedTokens[to][length] = tokenId;
1331         _ownedTokensIndex[tokenId] = length;
1332     }
1333 
1334     /**
1335      * @dev Private function to add a token to this extension's token tracking data structures.
1336      * @param tokenId uint256 ID of the token to be added to the tokens list
1337      */
1338     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1339         _allTokensIndex[tokenId] = _allTokens.length;
1340         _allTokens.push(tokenId);
1341     }
1342 
1343     /**
1344      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1345      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1346      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1347      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1348      * @param from address representing the previous owner of the given token ID
1349      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1350      */
1351     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1352         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1353         // then delete the last slot (swap and pop).
1354 
1355         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1356         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1357 
1358         // When the token to delete is the last token, the swap operation is unnecessary
1359         if (tokenIndex != lastTokenIndex) {
1360             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1361 
1362             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1363             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1364         }
1365 
1366         // This also deletes the contents at the last position of the array
1367         delete _ownedTokensIndex[tokenId];
1368         delete _ownedTokens[from][lastTokenIndex];
1369     }
1370 
1371     /**
1372      * @dev Private function to remove a token from this extension's token tracking data structures.
1373      * This has O(1) time complexity, but alters the order of the _allTokens array.
1374      * @param tokenId uint256 ID of the token to be removed from the tokens list
1375      */
1376     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1377         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1378         // then delete the last slot (swap and pop).
1379 
1380         uint256 lastTokenIndex = _allTokens.length - 1;
1381         uint256 tokenIndex = _allTokensIndex[tokenId];
1382 
1383         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1384         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1385         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1386         uint256 lastTokenId = _allTokens[lastTokenIndex];
1387 
1388         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1389         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1390 
1391         // This also deletes the contents at the last position of the array
1392         delete _allTokensIndex[tokenId];
1393         _allTokens.pop();
1394     }
1395 }
1396 
1397 // File: erc721a/contracts/IERC721A.sol
1398 
1399 
1400 // ERC721A Contracts v4.2.3
1401 // Creator: Chiru Labs
1402 
1403 pragma solidity ^0.8.4;
1404 
1405 /**
1406  * @dev Interface of ERC721A.
1407  */
1408 interface IERC721A {
1409     /**
1410      * The caller must own the token or be an approved operator.
1411      */
1412     error ApprovalCallerNotOwnerNorApproved();
1413 
1414     /**
1415      * The token does not exist.
1416      */
1417     error ApprovalQueryForNonexistentToken();
1418 
1419     /**
1420      * Cannot query the balance for the zero address.
1421      */
1422     error BalanceQueryForZeroAddress();
1423 
1424     /**
1425      * Cannot mint to the zero address.
1426      */
1427     error MintToZeroAddress();
1428 
1429     /**
1430      * The quantity of tokens minted must be more than zero.
1431      */
1432     error MintZeroQuantity();
1433 
1434     /**
1435      * The token does not exist.
1436      */
1437     error OwnerQueryForNonexistentToken();
1438 
1439     /**
1440      * The caller must own the token or be an approved operator.
1441      */
1442     error TransferCallerNotOwnerNorApproved();
1443 
1444     /**
1445      * The token must be owned by `from`.
1446      */
1447     error TransferFromIncorrectOwner();
1448 
1449     /**
1450      * Cannot safely transfer to a contract that does not implement the
1451      * ERC721Receiver interface.
1452      */
1453     error TransferToNonERC721ReceiverImplementer();
1454 
1455     /**
1456      * Cannot transfer to the zero address.
1457      */
1458     error TransferToZeroAddress();
1459 
1460     /**
1461      * The token does not exist.
1462      */
1463     error URIQueryForNonexistentToken();
1464 
1465     /**
1466      * The `quantity` minted with ERC2309 exceeds the safety limit.
1467      */
1468     error MintERC2309QuantityExceedsLimit();
1469 
1470     /**
1471      * The `extraData` cannot be set on an unintialized ownership slot.
1472      */
1473     error OwnershipNotInitializedForExtraData();
1474 
1475     // =============================================================
1476     //                            STRUCTS
1477     // =============================================================
1478 
1479     struct TokenOwnership {
1480         // The address of the owner.
1481         address addr;
1482         // Stores the start time of ownership with minimal overhead for tokenomics.
1483         uint64 startTimestamp;
1484         // Whether the token has been burned.
1485         bool burned;
1486         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1487         uint24 extraData;
1488     }
1489 
1490     // =============================================================
1491     //                         TOKEN COUNTERS
1492     // =============================================================
1493 
1494     /**
1495      * @dev Returns the total number of tokens in existence.
1496      * Burned tokens will reduce the count.
1497      * To get the total number of tokens minted, please see {_totalMinted}.
1498      */
1499     function totalSupply() external view returns (uint256);
1500 
1501     // =============================================================
1502     //                            IERC165
1503     // =============================================================
1504 
1505     /**
1506      * @dev Returns true if this contract implements the interface defined by
1507      * `interfaceId`. See the corresponding
1508      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1509      * to learn more about how these ids are created.
1510      *
1511      * This function call must use less than 30000 gas.
1512      */
1513     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1514 
1515     // =============================================================
1516     //                            IERC721
1517     // =============================================================
1518 
1519     /**
1520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1521      */
1522     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1523 
1524     /**
1525      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1526      */
1527     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1528 
1529     /**
1530      * @dev Emitted when `owner` enables or disables
1531      * (`approved`) `operator` to manage all of its assets.
1532      */
1533     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1534 
1535     /**
1536      * @dev Returns the number of tokens in `owner`'s account.
1537      */
1538     function balanceOf(address owner) external view returns (uint256 balance);
1539 
1540     /**
1541      * @dev Returns the owner of the `tokenId` token.
1542      *
1543      * Requirements:
1544      *
1545      * - `tokenId` must exist.
1546      */
1547     function ownerOf(uint256 tokenId) external view returns (address owner);
1548 
1549     /**
1550      * @dev Safely transfers `tokenId` token from `from` to `to`,
1551      * checking first that contract recipients are aware of the ERC721 protocol
1552      * to prevent tokens from being forever locked.
1553      *
1554      * Requirements:
1555      *
1556      * - `from` cannot be the zero address.
1557      * - `to` cannot be the zero address.
1558      * - `tokenId` token must exist and be owned by `from`.
1559      * - If the caller is not `from`, it must be have been allowed to move
1560      * this token by either {approve} or {setApprovalForAll}.
1561      * - If `to` refers to a smart contract, it must implement
1562      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1563      *
1564      * Emits a {Transfer} event.
1565      */
1566     function safeTransferFrom(
1567         address from,
1568         address to,
1569         uint256 tokenId,
1570         bytes calldata data
1571     ) external payable;
1572 
1573     /**
1574      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1575      */
1576     function safeTransferFrom(
1577         address from,
1578         address to,
1579         uint256 tokenId
1580     ) external payable;
1581 
1582     /**
1583      * @dev Transfers `tokenId` from `from` to `to`.
1584      *
1585      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1586      * whenever possible.
1587      *
1588      * Requirements:
1589      *
1590      * - `from` cannot be the zero address.
1591      * - `to` cannot be the zero address.
1592      * - `tokenId` token must be owned by `from`.
1593      * - If the caller is not `from`, it must be approved to move this token
1594      * by either {approve} or {setApprovalForAll}.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function transferFrom(
1599         address from,
1600         address to,
1601         uint256 tokenId
1602     ) external payable;
1603 
1604     /**
1605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1606      * The approval is cleared when the token is transferred.
1607      *
1608      * Only a single account can be approved at a time, so approving the
1609      * zero address clears previous approvals.
1610      *
1611      * Requirements:
1612      *
1613      * - The caller must own the token or be an approved operator.
1614      * - `tokenId` must exist.
1615      *
1616      * Emits an {Approval} event.
1617      */
1618     function approve(address to, uint256 tokenId) external payable;
1619 
1620     /**
1621      * @dev Approve or remove `operator` as an operator for the caller.
1622      * Operators can call {transferFrom} or {safeTransferFrom}
1623      * for any token owned by the caller.
1624      *
1625      * Requirements:
1626      *
1627      * - The `operator` cannot be the caller.
1628      *
1629      * Emits an {ApprovalForAll} event.
1630      */
1631     function setApprovalForAll(address operator, bool _approved) external;
1632 
1633     /**
1634      * @dev Returns the account approved for `tokenId` token.
1635      *
1636      * Requirements:
1637      *
1638      * - `tokenId` must exist.
1639      */
1640     function getApproved(uint256 tokenId) external view returns (address operator);
1641 
1642     /**
1643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1644      *
1645      * See {setApprovalForAll}.
1646      */
1647     function isApprovedForAll(address owner, address operator) external view returns (bool);
1648 
1649     // =============================================================
1650     //                        IERC721Metadata
1651     // =============================================================
1652 
1653     /**
1654      * @dev Returns the token collection name.
1655      */
1656     function name() external view returns (string memory);
1657 
1658     /**
1659      * @dev Returns the token collection symbol.
1660      */
1661     function symbol() external view returns (string memory);
1662 
1663     /**
1664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1665      */
1666     function tokenURI(uint256 tokenId) external view returns (string memory);
1667 
1668     // =============================================================
1669     //                           IERC2309
1670     // =============================================================
1671 
1672     /**
1673      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1674      * (inclusive) is transferred from `from` to `to`, as defined in the
1675      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1676      *
1677      * See {_mintERC2309} for more details.
1678      */
1679     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1680 }
1681 
1682 // File: erc721a/contracts/ERC721A.sol
1683 
1684 
1685 // ERC721A Contracts v4.2.3
1686 // Creator: Chiru Labs
1687 
1688 pragma solidity ^0.8.4;
1689 
1690 
1691 /**
1692  * @dev Interface of ERC721 token receiver.
1693  */
1694 interface ERC721A__IERC721Receiver {
1695     function onERC721Received(
1696         address operator,
1697         address from,
1698         uint256 tokenId,
1699         bytes calldata data
1700     ) external returns (bytes4);
1701 }
1702 
1703 /**
1704  * @title ERC721A
1705  *
1706  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1707  * Non-Fungible Token Standard, including the Metadata extension.
1708  * Optimized for lower gas during batch mints.
1709  *
1710  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1711  * starting from `_startTokenId()`.
1712  *
1713  * Assumptions:
1714  *
1715  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1716  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1717  */
1718 contract ERC721A is IERC721A {
1719     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1720     struct TokenApprovalRef {
1721         address value;
1722     }
1723 
1724     // =============================================================
1725     //                           CONSTANTS
1726     // =============================================================
1727 
1728     // Mask of an entry in packed address data.
1729     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1730 
1731     // The bit position of `numberMinted` in packed address data.
1732     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1733 
1734     // The bit position of `numberBurned` in packed address data.
1735     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1736 
1737     // The bit position of `aux` in packed address data.
1738     uint256 private constant _BITPOS_AUX = 192;
1739 
1740     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1741     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1742 
1743     // The bit position of `startTimestamp` in packed ownership.
1744     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1745 
1746     // The bit mask of the `burned` bit in packed ownership.
1747     uint256 private constant _BITMASK_BURNED = 1 << 224;
1748 
1749     // The bit position of the `nextInitialized` bit in packed ownership.
1750     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1751 
1752     // The bit mask of the `nextInitialized` bit in packed ownership.
1753     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1754 
1755     // The bit position of `extraData` in packed ownership.
1756     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1757 
1758     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1759     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1760 
1761     // The mask of the lower 160 bits for addresses.
1762     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1763 
1764     // The maximum `quantity` that can be minted with {_mintERC2309}.
1765     // This limit is to prevent overflows on the address data entries.
1766     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1767     // is required to cause an overflow, which is unrealistic.
1768     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1769 
1770     // The `Transfer` event signature is given by:
1771     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1772     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1773         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1774 
1775     // =============================================================
1776     //                            STORAGE
1777     // =============================================================
1778 
1779     // The next token ID to be minted.
1780     uint256 private _currentIndex;
1781 
1782     // The number of tokens burned.
1783     uint256 private _burnCounter;
1784 
1785     // Token name
1786     string private _name;
1787 
1788     // Token symbol
1789     string private _symbol;
1790 
1791     // Mapping from token ID to ownership details
1792     // An empty struct value does not necessarily mean the token is unowned.
1793     // See {_packedOwnershipOf} implementation for details.
1794     //
1795     // Bits Layout:
1796     // - [0..159]   `addr`
1797     // - [160..223] `startTimestamp`
1798     // - [224]      `burned`
1799     // - [225]      `nextInitialized`
1800     // - [232..255] `extraData`
1801     mapping(uint256 => uint256) private _packedOwnerships;
1802 
1803     // Mapping owner address to address data.
1804     //
1805     // Bits Layout:
1806     // - [0..63]    `balance`
1807     // - [64..127]  `numberMinted`
1808     // - [128..191] `numberBurned`
1809     // - [192..255] `aux`
1810     mapping(address => uint256) private _packedAddressData;
1811 
1812     // Mapping from token ID to approved address.
1813     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1814 
1815     // Mapping from owner to operator approvals
1816     mapping(address => mapping(address => bool)) private _operatorApprovals;
1817 
1818     // =============================================================
1819     //                          CONSTRUCTOR
1820     // =============================================================
1821 
1822     constructor(string memory name_, string memory symbol_) {
1823         _name = name_;
1824         _symbol = symbol_;
1825         _currentIndex = _startTokenId();
1826     }
1827 
1828     // =============================================================
1829     //                   TOKEN COUNTING OPERATIONS
1830     // =============================================================
1831 
1832     /**
1833      * @dev Returns the starting token ID.
1834      * To change the starting token ID, please override this function.
1835      */
1836     function _startTokenId() internal view virtual returns (uint256) {
1837         return 0;
1838     }
1839 
1840     /**
1841      * @dev Returns the next token ID to be minted.
1842      */
1843     function _nextTokenId() internal view virtual returns (uint256) {
1844         return _currentIndex;
1845     }
1846 
1847     /**
1848      * @dev Returns the total number of tokens in existence.
1849      * Burned tokens will reduce the count.
1850      * To get the total number of tokens minted, please see {_totalMinted}.
1851      */
1852     function totalSupply() public view virtual override returns (uint256) {
1853         // Counter underflow is impossible as _burnCounter cannot be incremented
1854         // more than `_currentIndex - _startTokenId()` times.
1855         unchecked {
1856             return _currentIndex - _burnCounter - _startTokenId();
1857         }
1858     }
1859 
1860     /**
1861      * @dev Returns the total amount of tokens minted in the contract.
1862      */
1863     function _totalMinted() internal view virtual returns (uint256) {
1864         // Counter underflow is impossible as `_currentIndex` does not decrement,
1865         // and it is initialized to `_startTokenId()`.
1866         unchecked {
1867             return _currentIndex - _startTokenId();
1868         }
1869     }
1870 
1871     /**
1872      * @dev Returns the total number of tokens burned.
1873      */
1874     function _totalBurned() internal view virtual returns (uint256) {
1875         return _burnCounter;
1876     }
1877 
1878     // =============================================================
1879     //                    ADDRESS DATA OPERATIONS
1880     // =============================================================
1881 
1882     /**
1883      * @dev Returns the number of tokens in `owner`'s account.
1884      */
1885     function balanceOf(address owner) public view virtual override returns (uint256) {
1886         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1887         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1888     }
1889 
1890     /**
1891      * Returns the number of tokens minted by `owner`.
1892      */
1893     function _numberMinted(address owner) internal view returns (uint256) {
1894         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1895     }
1896 
1897     /**
1898      * Returns the number of tokens burned by or on behalf of `owner`.
1899      */
1900     function _numberBurned(address owner) internal view returns (uint256) {
1901         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1902     }
1903 
1904     /**
1905      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1906      */
1907     function _getAux(address owner) internal view returns (uint64) {
1908         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1909     }
1910 
1911     /**
1912      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1913      * If there are multiple variables, please pack them into a uint64.
1914      */
1915     function _setAux(address owner, uint64 aux) internal virtual {
1916         uint256 packed = _packedAddressData[owner];
1917         uint256 auxCasted;
1918         // Cast `aux` with assembly to avoid redundant masking.
1919         assembly {
1920             auxCasted := aux
1921         }
1922         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1923         _packedAddressData[owner] = packed;
1924     }
1925 
1926     // =============================================================
1927     //                            IERC165
1928     // =============================================================
1929 
1930     /**
1931      * @dev Returns true if this contract implements the interface defined by
1932      * `interfaceId`. See the corresponding
1933      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1934      * to learn more about how these ids are created.
1935      *
1936      * This function call must use less than 30000 gas.
1937      */
1938     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1939         // The interface IDs are constants representing the first 4 bytes
1940         // of the XOR of all function selectors in the interface.
1941         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1942         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1943         return
1944             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1945             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1946             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1947     }
1948 
1949     // =============================================================
1950     //                        IERC721Metadata
1951     // =============================================================
1952 
1953     /**
1954      * @dev Returns the token collection name.
1955      */
1956     function name() public view virtual override returns (string memory) {
1957         return _name;
1958     }
1959 
1960     /**
1961      * @dev Returns the token collection symbol.
1962      */
1963     function symbol() public view virtual override returns (string memory) {
1964         return _symbol;
1965     }
1966 
1967     /**
1968      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1969      */
1970     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1971         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1972 
1973         string memory baseURI = _baseURI();
1974         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1975     }
1976 
1977     /**
1978      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1979      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1980      * by default, it can be overridden in child contracts.
1981      */
1982     function _baseURI() internal view virtual returns (string memory) {
1983         return '';
1984     }
1985 
1986     // =============================================================
1987     //                     OWNERSHIPS OPERATIONS
1988     // =============================================================
1989 
1990     /**
1991      * @dev Returns the owner of the `tokenId` token.
1992      *
1993      * Requirements:
1994      *
1995      * - `tokenId` must exist.
1996      */
1997     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1998         return address(uint160(_packedOwnershipOf(tokenId)));
1999     }
2000 
2001     /**
2002      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2003      * It gradually moves to O(1) as tokens get transferred around over time.
2004      */
2005     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2006         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2007     }
2008 
2009     /**
2010      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2011      */
2012     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2013         return _unpackedOwnership(_packedOwnerships[index]);
2014     }
2015 
2016     /**
2017      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2018      */
2019     function _initializeOwnershipAt(uint256 index) internal virtual {
2020         if (_packedOwnerships[index] == 0) {
2021             _packedOwnerships[index] = _packedOwnershipOf(index);
2022         }
2023     }
2024 
2025     /**
2026      * Returns the packed ownership data of `tokenId`.
2027      */
2028     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2029         uint256 curr = tokenId;
2030 
2031         unchecked {
2032             if (_startTokenId() <= curr)
2033                 if (curr < _currentIndex) {
2034                     uint256 packed = _packedOwnerships[curr];
2035                     // If not burned.
2036                     if (packed & _BITMASK_BURNED == 0) {
2037                         // Invariant:
2038                         // There will always be an initialized ownership slot
2039                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2040                         // before an unintialized ownership slot
2041                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2042                         // Hence, `curr` will not underflow.
2043                         //
2044                         // We can directly compare the packed value.
2045                         // If the address is zero, packed will be zero.
2046                         while (packed == 0) {
2047                             packed = _packedOwnerships[--curr];
2048                         }
2049                         return packed;
2050                     }
2051                 }
2052         }
2053         revert OwnerQueryForNonexistentToken();
2054     }
2055 
2056     /**
2057      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2058      */
2059     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2060         ownership.addr = address(uint160(packed));
2061         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2062         ownership.burned = packed & _BITMASK_BURNED != 0;
2063         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2064     }
2065 
2066     /**
2067      * @dev Packs ownership data into a single uint256.
2068      */
2069     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2070         assembly {
2071             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2072             owner := and(owner, _BITMASK_ADDRESS)
2073             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2074             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2075         }
2076     }
2077 
2078     /**
2079      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2080      */
2081     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2082         // For branchless setting of the `nextInitialized` flag.
2083         assembly {
2084             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2085             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2086         }
2087     }
2088 
2089     // =============================================================
2090     //                      APPROVAL OPERATIONS
2091     // =============================================================
2092 
2093     /**
2094      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2095      * The approval is cleared when the token is transferred.
2096      *
2097      * Only a single account can be approved at a time, so approving the
2098      * zero address clears previous approvals.
2099      *
2100      * Requirements:
2101      *
2102      * - The caller must own the token or be an approved operator.
2103      * - `tokenId` must exist.
2104      *
2105      * Emits an {Approval} event.
2106      */
2107     function approve(address to, uint256 tokenId) public payable virtual override {
2108         address owner = ownerOf(tokenId);
2109 
2110         if (_msgSenderERC721A() != owner)
2111             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2112                 revert ApprovalCallerNotOwnerNorApproved();
2113             }
2114 
2115         _tokenApprovals[tokenId].value = to;
2116         emit Approval(owner, to, tokenId);
2117     }
2118 
2119     /**
2120      * @dev Returns the account approved for `tokenId` token.
2121      *
2122      * Requirements:
2123      *
2124      * - `tokenId` must exist.
2125      */
2126     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2127         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2128 
2129         return _tokenApprovals[tokenId].value;
2130     }
2131 
2132     /**
2133      * @dev Approve or remove `operator` as an operator for the caller.
2134      * Operators can call {transferFrom} or {safeTransferFrom}
2135      * for any token owned by the caller.
2136      *
2137      * Requirements:
2138      *
2139      * - The `operator` cannot be the caller.
2140      *
2141      * Emits an {ApprovalForAll} event.
2142      */
2143     function setApprovalForAll(address operator, bool approved) public virtual override {
2144         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2145         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2146     }
2147 
2148     /**
2149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2150      *
2151      * See {setApprovalForAll}.
2152      */
2153     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2154         return _operatorApprovals[owner][operator];
2155     }
2156 
2157     /**
2158      * @dev Returns whether `tokenId` exists.
2159      *
2160      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2161      *
2162      * Tokens start existing when they are minted. See {_mint}.
2163      */
2164     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2165         return
2166             _startTokenId() <= tokenId &&
2167             tokenId < _currentIndex && // If within bounds,
2168             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2169     }
2170 
2171     /**
2172      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2173      */
2174     function _isSenderApprovedOrOwner(
2175         address approvedAddress,
2176         address owner,
2177         address msgSender
2178     ) private pure returns (bool result) {
2179         assembly {
2180             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2181             owner := and(owner, _BITMASK_ADDRESS)
2182             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2183             msgSender := and(msgSender, _BITMASK_ADDRESS)
2184             // `msgSender == owner || msgSender == approvedAddress`.
2185             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2186         }
2187     }
2188 
2189     /**
2190      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2191      */
2192     function _getApprovedSlotAndAddress(uint256 tokenId)
2193         private
2194         view
2195         returns (uint256 approvedAddressSlot, address approvedAddress)
2196     {
2197         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2198         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2199         assembly {
2200             approvedAddressSlot := tokenApproval.slot
2201             approvedAddress := sload(approvedAddressSlot)
2202         }
2203     }
2204 
2205     // =============================================================
2206     //                      TRANSFER OPERATIONS
2207     // =============================================================
2208 
2209     /**
2210      * @dev Transfers `tokenId` from `from` to `to`.
2211      *
2212      * Requirements:
2213      *
2214      * - `from` cannot be the zero address.
2215      * - `to` cannot be the zero address.
2216      * - `tokenId` token must be owned by `from`.
2217      * - If the caller is not `from`, it must be approved to move this token
2218      * by either {approve} or {setApprovalForAll}.
2219      *
2220      * Emits a {Transfer} event.
2221      */
2222     function transferFrom(
2223         address from,
2224         address to,
2225         uint256 tokenId
2226     ) public payable virtual override {
2227         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2228 
2229         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2230 
2231         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2232 
2233         // The nested ifs save around 20+ gas over a compound boolean condition.
2234         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2235             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2236 
2237         if (to == address(0)) revert TransferToZeroAddress();
2238 
2239         _beforeTokenTransfers(from, to, tokenId, 1);
2240 
2241         // Clear approvals from the previous owner.
2242         assembly {
2243             if approvedAddress {
2244                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2245                 sstore(approvedAddressSlot, 0)
2246             }
2247         }
2248 
2249         // Underflow of the sender's balance is impossible because we check for
2250         // ownership above and the recipient's balance can't realistically overflow.
2251         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2252         unchecked {
2253             // We can directly increment and decrement the balances.
2254             --_packedAddressData[from]; // Updates: `balance -= 1`.
2255             ++_packedAddressData[to]; // Updates: `balance += 1`.
2256 
2257             // Updates:
2258             // - `address` to the next owner.
2259             // - `startTimestamp` to the timestamp of transfering.
2260             // - `burned` to `false`.
2261             // - `nextInitialized` to `true`.
2262             _packedOwnerships[tokenId] = _packOwnershipData(
2263                 to,
2264                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2265             );
2266 
2267             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2268             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2269                 uint256 nextTokenId = tokenId + 1;
2270                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2271                 if (_packedOwnerships[nextTokenId] == 0) {
2272                     // If the next slot is within bounds.
2273                     if (nextTokenId != _currentIndex) {
2274                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2275                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2276                     }
2277                 }
2278             }
2279         }
2280 
2281         emit Transfer(from, to, tokenId);
2282         _afterTokenTransfers(from, to, tokenId, 1);
2283     }
2284 
2285     /**
2286      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2287      */
2288     function safeTransferFrom(
2289         address from,
2290         address to,
2291         uint256 tokenId
2292     ) public payable virtual override {
2293         safeTransferFrom(from, to, tokenId, '');
2294     }
2295 
2296     /**
2297      * @dev Safely transfers `tokenId` token from `from` to `to`.
2298      *
2299      * Requirements:
2300      *
2301      * - `from` cannot be the zero address.
2302      * - `to` cannot be the zero address.
2303      * - `tokenId` token must exist and be owned by `from`.
2304      * - If the caller is not `from`, it must be approved to move this token
2305      * by either {approve} or {setApprovalForAll}.
2306      * - If `to` refers to a smart contract, it must implement
2307      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2308      *
2309      * Emits a {Transfer} event.
2310      */
2311     function safeTransferFrom(
2312         address from,
2313         address to,
2314         uint256 tokenId,
2315         bytes memory _data
2316     ) public payable virtual override {
2317         transferFrom(from, to, tokenId);
2318         if (to.code.length != 0)
2319             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2320                 revert TransferToNonERC721ReceiverImplementer();
2321             }
2322     }
2323 
2324     /**
2325      * @dev Hook that is called before a set of serially-ordered token IDs
2326      * are about to be transferred. This includes minting.
2327      * And also called before burning one token.
2328      *
2329      * `startTokenId` - the first token ID to be transferred.
2330      * `quantity` - the amount to be transferred.
2331      *
2332      * Calling conditions:
2333      *
2334      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2335      * transferred to `to`.
2336      * - When `from` is zero, `tokenId` will be minted for `to`.
2337      * - When `to` is zero, `tokenId` will be burned by `from`.
2338      * - `from` and `to` are never both zero.
2339      */
2340     function _beforeTokenTransfers(
2341         address from,
2342         address to,
2343         uint256 startTokenId,
2344         uint256 quantity
2345     ) internal virtual {}
2346 
2347     /**
2348      * @dev Hook that is called after a set of serially-ordered token IDs
2349      * have been transferred. This includes minting.
2350      * And also called after one token has been burned.
2351      *
2352      * `startTokenId` - the first token ID to be transferred.
2353      * `quantity` - the amount to be transferred.
2354      *
2355      * Calling conditions:
2356      *
2357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2358      * transferred to `to`.
2359      * - When `from` is zero, `tokenId` has been minted for `to`.
2360      * - When `to` is zero, `tokenId` has been burned by `from`.
2361      * - `from` and `to` are never both zero.
2362      */
2363     function _afterTokenTransfers(
2364         address from,
2365         address to,
2366         uint256 startTokenId,
2367         uint256 quantity
2368     ) internal virtual {}
2369 
2370     /**
2371      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2372      *
2373      * `from` - Previous owner of the given token ID.
2374      * `to` - Target address that will receive the token.
2375      * `tokenId` - Token ID to be transferred.
2376      * `_data` - Optional data to send along with the call.
2377      *
2378      * Returns whether the call correctly returned the expected magic value.
2379      */
2380     function _checkContractOnERC721Received(
2381         address from,
2382         address to,
2383         uint256 tokenId,
2384         bytes memory _data
2385     ) private returns (bool) {
2386         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2387             bytes4 retval
2388         ) {
2389             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2390         } catch (bytes memory reason) {
2391             if (reason.length == 0) {
2392                 revert TransferToNonERC721ReceiverImplementer();
2393             } else {
2394                 assembly {
2395                     revert(add(32, reason), mload(reason))
2396                 }
2397             }
2398         }
2399     }
2400 
2401     // =============================================================
2402     //                        MINT OPERATIONS
2403     // =============================================================
2404 
2405     /**
2406      * @dev Mints `quantity` tokens and transfers them to `to`.
2407      *
2408      * Requirements:
2409      *
2410      * - `to` cannot be the zero address.
2411      * - `quantity` must be greater than 0.
2412      *
2413      * Emits a {Transfer} event for each mint.
2414      */
2415     function _mint(address to, uint256 quantity) internal virtual {
2416         uint256 startTokenId = _currentIndex;
2417         if (quantity == 0) revert MintZeroQuantity();
2418 
2419         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2420 
2421         // Overflows are incredibly unrealistic.
2422         // `balance` and `numberMinted` have a maximum limit of 2**64.
2423         // `tokenId` has a maximum limit of 2**256.
2424         unchecked {
2425             // Updates:
2426             // - `balance += quantity`.
2427             // - `numberMinted += quantity`.
2428             //
2429             // We can directly add to the `balance` and `numberMinted`.
2430             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2431 
2432             // Updates:
2433             // - `address` to the owner.
2434             // - `startTimestamp` to the timestamp of minting.
2435             // - `burned` to `false`.
2436             // - `nextInitialized` to `quantity == 1`.
2437             _packedOwnerships[startTokenId] = _packOwnershipData(
2438                 to,
2439                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2440             );
2441 
2442             uint256 toMasked;
2443             uint256 end = startTokenId + quantity;
2444 
2445             // Use assembly to loop and emit the `Transfer` event for gas savings.
2446             // The duplicated `log4` removes an extra check and reduces stack juggling.
2447             // The assembly, together with the surrounding Solidity code, have been
2448             // delicately arranged to nudge the compiler into producing optimized opcodes.
2449             assembly {
2450                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2451                 toMasked := and(to, _BITMASK_ADDRESS)
2452                 // Emit the `Transfer` event.
2453                 log4(
2454                     0, // Start of data (0, since no data).
2455                     0, // End of data (0, since no data).
2456                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2457                     0, // `address(0)`.
2458                     toMasked, // `to`.
2459                     startTokenId // `tokenId`.
2460                 )
2461 
2462                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2463                 // that overflows uint256 will make the loop run out of gas.
2464                 // The compiler will optimize the `iszero` away for performance.
2465                 for {
2466                     let tokenId := add(startTokenId, 1)
2467                 } iszero(eq(tokenId, end)) {
2468                     tokenId := add(tokenId, 1)
2469                 } {
2470                     // Emit the `Transfer` event. Similar to above.
2471                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2472                 }
2473             }
2474             if (toMasked == 0) revert MintToZeroAddress();
2475 
2476             _currentIndex = end;
2477         }
2478         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2479     }
2480 
2481     /**
2482      * @dev Mints `quantity` tokens and transfers them to `to`.
2483      *
2484      * This function is intended for efficient minting only during contract creation.
2485      *
2486      * It emits only one {ConsecutiveTransfer} as defined in
2487      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2488      * instead of a sequence of {Transfer} event(s).
2489      *
2490      * Calling this function outside of contract creation WILL make your contract
2491      * non-compliant with the ERC721 standard.
2492      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2493      * {ConsecutiveTransfer} event is only permissible during contract creation.
2494      *
2495      * Requirements:
2496      *
2497      * - `to` cannot be the zero address.
2498      * - `quantity` must be greater than 0.
2499      *
2500      * Emits a {ConsecutiveTransfer} event.
2501      */
2502     function _mintERC2309(address to, uint256 quantity) internal virtual {
2503         uint256 startTokenId = _currentIndex;
2504         if (to == address(0)) revert MintToZeroAddress();
2505         if (quantity == 0) revert MintZeroQuantity();
2506         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2507 
2508         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2509 
2510         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2511         unchecked {
2512             // Updates:
2513             // - `balance += quantity`.
2514             // - `numberMinted += quantity`.
2515             //
2516             // We can directly add to the `balance` and `numberMinted`.
2517             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2518 
2519             // Updates:
2520             // - `address` to the owner.
2521             // - `startTimestamp` to the timestamp of minting.
2522             // - `burned` to `false`.
2523             // - `nextInitialized` to `quantity == 1`.
2524             _packedOwnerships[startTokenId] = _packOwnershipData(
2525                 to,
2526                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2527             );
2528 
2529             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2530 
2531             _currentIndex = startTokenId + quantity;
2532         }
2533         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2534     }
2535 
2536     /**
2537      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2538      *
2539      * Requirements:
2540      *
2541      * - If `to` refers to a smart contract, it must implement
2542      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2543      * - `quantity` must be greater than 0.
2544      *
2545      * See {_mint}.
2546      *
2547      * Emits a {Transfer} event for each mint.
2548      */
2549     function _safeMint(
2550         address to,
2551         uint256 quantity,
2552         bytes memory _data
2553     ) internal virtual {
2554         _mint(to, quantity);
2555 
2556         unchecked {
2557             if (to.code.length != 0) {
2558                 uint256 end = _currentIndex;
2559                 uint256 index = end - quantity;
2560                 do {
2561                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2562                         revert TransferToNonERC721ReceiverImplementer();
2563                     }
2564                 } while (index < end);
2565                 // Reentrancy protection.
2566                 if (_currentIndex != end) revert();
2567             }
2568         }
2569     }
2570 
2571     /**
2572      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2573      */
2574     function _safeMint(address to, uint256 quantity) internal virtual {
2575         _safeMint(to, quantity, '');
2576     }
2577 
2578     // =============================================================
2579     //                        BURN OPERATIONS
2580     // =============================================================
2581 
2582     /**
2583      * @dev Equivalent to `_burn(tokenId, false)`.
2584      */
2585     function _burn(uint256 tokenId) internal virtual {
2586         _burn(tokenId, false);
2587     }
2588 
2589     /**
2590      * @dev Destroys `tokenId`.
2591      * The approval is cleared when the token is burned.
2592      *
2593      * Requirements:
2594      *
2595      * - `tokenId` must exist.
2596      *
2597      * Emits a {Transfer} event.
2598      */
2599     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2600         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2601 
2602         address from = address(uint160(prevOwnershipPacked));
2603 
2604         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2605 
2606         if (approvalCheck) {
2607             // The nested ifs save around 20+ gas over a compound boolean condition.
2608             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2609                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2610         }
2611 
2612         _beforeTokenTransfers(from, address(0), tokenId, 1);
2613 
2614         // Clear approvals from the previous owner.
2615         assembly {
2616             if approvedAddress {
2617                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2618                 sstore(approvedAddressSlot, 0)
2619             }
2620         }
2621 
2622         // Underflow of the sender's balance is impossible because we check for
2623         // ownership above and the recipient's balance can't realistically overflow.
2624         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2625         unchecked {
2626             // Updates:
2627             // - `balance -= 1`.
2628             // - `numberBurned += 1`.
2629             //
2630             // We can directly decrement the balance, and increment the number burned.
2631             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2632             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2633 
2634             // Updates:
2635             // - `address` to the last owner.
2636             // - `startTimestamp` to the timestamp of burning.
2637             // - `burned` to `true`.
2638             // - `nextInitialized` to `true`.
2639             _packedOwnerships[tokenId] = _packOwnershipData(
2640                 from,
2641                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2642             );
2643 
2644             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2645             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2646                 uint256 nextTokenId = tokenId + 1;
2647                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2648                 if (_packedOwnerships[nextTokenId] == 0) {
2649                     // If the next slot is within bounds.
2650                     if (nextTokenId != _currentIndex) {
2651                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2652                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2653                     }
2654                 }
2655             }
2656         }
2657 
2658         emit Transfer(from, address(0), tokenId);
2659         _afterTokenTransfers(from, address(0), tokenId, 1);
2660 
2661         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2662         unchecked {
2663             _burnCounter++;
2664         }
2665     }
2666 
2667     // =============================================================
2668     //                     EXTRA DATA OPERATIONS
2669     // =============================================================
2670 
2671     /**
2672      * @dev Directly sets the extra data for the ownership data `index`.
2673      */
2674     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2675         uint256 packed = _packedOwnerships[index];
2676         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2677         uint256 extraDataCasted;
2678         // Cast `extraData` with assembly to avoid redundant masking.
2679         assembly {
2680             extraDataCasted := extraData
2681         }
2682         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2683         _packedOwnerships[index] = packed;
2684     }
2685 
2686     /**
2687      * @dev Called during each token transfer to set the 24bit `extraData` field.
2688      * Intended to be overridden by the cosumer contract.
2689      *
2690      * `previousExtraData` - the value of `extraData` before transfer.
2691      *
2692      * Calling conditions:
2693      *
2694      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2695      * transferred to `to`.
2696      * - When `from` is zero, `tokenId` will be minted for `to`.
2697      * - When `to` is zero, `tokenId` will be burned by `from`.
2698      * - `from` and `to` are never both zero.
2699      */
2700     function _extraData(
2701         address from,
2702         address to,
2703         uint24 previousExtraData
2704     ) internal view virtual returns (uint24) {}
2705 
2706     /**
2707      * @dev Returns the next extra data for the packed ownership data.
2708      * The returned result is shifted into position.
2709      */
2710     function _nextExtraData(
2711         address from,
2712         address to,
2713         uint256 prevOwnershipPacked
2714     ) private view returns (uint256) {
2715         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2716         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2717     }
2718 
2719     // =============================================================
2720     //                       OTHER OPERATIONS
2721     // =============================================================
2722 
2723     /**
2724      * @dev Returns the message sender (defaults to `msg.sender`).
2725      *
2726      * If you are writing GSN compatible contracts, you need to override this function.
2727      */
2728     function _msgSenderERC721A() internal view virtual returns (address) {
2729         return msg.sender;
2730     }
2731 
2732     /**
2733      * @dev Converts a uint256 to its ASCII string decimal representation.
2734      */
2735     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2736         assembly {
2737             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2738             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2739             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2740             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2741             let m := add(mload(0x40), 0xa0)
2742             // Update the free memory pointer to allocate.
2743             mstore(0x40, m)
2744             // Assign the `str` to the end.
2745             str := sub(m, 0x20)
2746             // Zeroize the slot after the string.
2747             mstore(str, 0)
2748 
2749             // Cache the end of the memory to calculate the length later.
2750             let end := str
2751 
2752             // We write the string from rightmost digit to leftmost digit.
2753             // The following is essentially a do-while loop that also handles the zero case.
2754             // prettier-ignore
2755             for { let temp := value } 1 {} {
2756                 str := sub(str, 1)
2757                 // Write the character to the pointer.
2758                 // The ASCII index of the '0' character is 48.
2759                 mstore8(str, add(48, mod(temp, 10)))
2760                 // Keep dividing `temp` until zero.
2761                 temp := div(temp, 10)
2762                 // prettier-ignore
2763                 if iszero(temp) { break }
2764             }
2765 
2766             let length := sub(end, str)
2767             // Move the pointer 32 bytes leftwards to make room for the length.
2768             str := sub(str, 0x20)
2769             // Store the length.
2770             mstore(str, length)
2771         }
2772     }
2773 }
2774 
2775 // File: contracts/TarotLandCards.sol
2776 
2777 
2778 
2779 pragma solidity >=0.8.7 <0.9.0;
2780 
2781 
2782 
2783 
2784 
2785 
2786 interface IToken {
2787     function balanceOf(address) external view returns (uint256);
2788 }
2789 
2790 interface ITarot {
2791     function enableTrading() external ;
2792 }
2793 
2794 contract setUpMystery  {
2795     string public mystery = "Welcome... Please get the first quest.";
2796     Quest[] private quest;
2797     address private addr;// only the person who deploys the contract is allowed to add a Quest;
2798     address public user ;
2799     bool public _mysterySolved = false;
2800     // Only the person who deploys the contract can add Quests
2801     constructor() {
2802         addr = msg.sender;
2803     }
2804 
2805 
2806 
2807     struct Quest {
2808         string mystery;             // Gives Mistery
2809         bytes32 sealedMessage;      // Seal answer into a hash
2810     }
2811   
2812 
2813     function createHashFromAnswer(string memory secret) private pure returns (bytes32 _sealedMessage){
2814         _sealedMessage = keccak256(abi.encodePacked(secret));
2815     }
2816     
2817     function getSolved () external view returns(bool){
2818        return _mysterySolved;
2819 
2820     }
2821 
2822     
2823 
2824     function addQuest(string memory _mystery, string memory _answer) external {   // Note: all answers have to be unique
2825 
2826         // Require an entry for the mystery and an answer
2827         require(addr==msg.sender, "You do not have permission to add a Quest");
2828         require(bytes(_answer).length > 0, "Mystery is empty");
2829         require(bytes(_answer).length > 0, "Answer is empty");
2830 
2831         bytes32 sealedMessage = createHashFromAnswer(_answer);
2832         for(uint i=0; i<quest.length; i++){
2833                 require(sealedMessage != quest[i].sealedMessage,"Answer already exists.");
2834             }
2835 
2836 
2837         // Add mystery and hash of answer to Quest
2838         quest.push(Quest(_mystery,sealedMessage));
2839     }
2840 
2841 
2842     function removeLastQuest() external {   // Note: all answers have to be unique
2843 
2844         require(addr==msg.sender, "You do not have permission to add a Quest");
2845         require(quest.length>0, "There is no Quest available");
2846 
2847         // Add mystery and hash of answer to Quest
2848         quest.pop();
2849     }
2850   
2851     function getQuest(string memory _answer) external returns (string memory) {
2852         
2853         require(quest.length>0,"No Quests available");
2854         bytes32 sealedMessage = createHashFromAnswer(_answer);
2855         uint correctAnswerPosition = quest.length;
2856         // Empty answer or 0 gives first quest
2857         if (bytes(_answer).length==0 || createHashFromAnswer("0")==sealedMessage){
2858             mystery = quest[0].mystery;
2859             _mysterySolved = false;
2860         } else {
2861             // checke if answer is valid for one of the mistery
2862              
2863             for(uint i=0; i<quest.length; i++){
2864                 if (quest[i].sealedMessage == sealedMessage) {
2865                     correctAnswerPosition = i;
2866                     _mysterySolved = false;
2867                 }
2868             }
2869             if (correctAnswerPosition == quest.length){ // No answer was found
2870                 mystery = "You failed.... Try again. Rebsubmit the previous answer to read the question again";
2871                 _mysterySolved = false;
2872             } else if (correctAnswerPosition == quest.length-1){ 
2873                 mystery = "Congratulation, you finished all the Quests!. You will receive your NFT card shortly";
2874                 _mysterySolved = true;
2875             } else {
2876                 mystery = quest[correctAnswerPosition+1].mystery;
2877             }
2878 
2879 
2880         }
2881         
2882         return mystery;
2883        
2884 
2885     }
2886 
2887 
2888 
2889 }
2890 
2891 
2892 
2893 contract Mystery is ERC721A, Ownable, ReentrancyGuard {
2894     using Strings for uint256;
2895     uint256 public cards = 330;
2896     uint256 public _totalSeekers = 0;
2897     uint256 public cardsTillOpen = 222;
2898     bool public openERC20 = false;
2899     address tarotERC20;
2900     string public _tokenURI;
2901     string public baseExtension = ".json";
2902     mapping(address => bool) public claimStatuses;
2903     mapping(address => bool) public hasSolved;
2904     setUpMystery  _mystery;
2905     mapping(address => string) public mystery;
2906     
2907     event Attest(address indexed to, uint256 indexed tokenId);
2908     event Revoke(address indexed to, uint256 indexed tokenId);
2909 
2910 
2911     constructor(address _contractAddress, string memory _baseuri)ERC721A('TarotLandCards', 'TLC') { 
2912         _mystery = setUpMystery(_contractAddress);
2913         _tokenURI=_baseuri;
2914     }
2915     function _startTokenId() internal view virtual override returns (uint256) {
2916         return 1;
2917     }
2918     function _baseURI() internal view virtual override returns (string memory) {
2919         return _tokenURI;
2920     }
2921     function setTarotERC20(address _tarotERC20) public onlyOwner {
2922         tarotERC20 = _tarotERC20;
2923     }
2924     function getSolved () private returns(bool) {
2925        hasSolved[msg.sender] = _mystery.getSolved();
2926        return hasSolved[msg.sender];
2927     }
2928 
2929     function getQuest(string memory _answer) external nonReentrant returns (string memory) {
2930         mystery[msg.sender] = _mystery.getQuest(_answer);
2931              if (getSolved()){ 
2932               uint256 cardId = totalSupply();// Found the answer to the last question
2933               require(cardId < cards, 'No cards left...');
2934               require(!claimStatuses[msg.sender], 'Card already claimed');
2935               _safeMint(msg.sender, 1);
2936               _totalSeekers++;
2937               claimStatuses[msg.sender] = true;
2938                if (_totalSeekers >= cardsTillOpen && !openERC20) {
2939                   ITarot(tarotERC20).enableTrading();
2940                   openERC20 = true;
2941                }
2942             return mystery[msg.sender];
2943       } else {
2944            return mystery[msg.sender];
2945       }       
2946   }
2947   
2948   function burn(uint256 tokenId) external{
2949       require(ownerOf(tokenId) == msg.sender, "Only token owner can burn it");
2950       _burn(tokenId);
2951   }
2952   function revoke(uint256 tokenId) onlyOwner external {
2953       _burn(tokenId);
2954   }
2955   function tokenURI(uint256 tokenId)
2956     public
2957     view
2958     virtual
2959     override
2960     returns (string memory)
2961   {
2962     require(
2963       _exists(tokenId),
2964       "ERC721Metadata: URI query for nonexistent token"
2965     );
2966 
2967     string memory currentBaseURI = _baseURI();
2968     return bytes(currentBaseURI).length > 0
2969         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2970         : "";
2971   }
2972   function _beforeTokenTransfers(
2973         address from,
2974         address to,
2975         uint256 startTokenId,
2976         uint256 quantity
2977     ) internal override virtual {
2978         require(from == address(0) || to == address(0), "You can't transfer this token");
2979     }
2980     function _afterTokenTransfers(
2981         address from, address to,
2982         uint256 startTokenId,
2983         uint256 quantity
2984     ) internal override virtual {
2985         if(from == address(0)) {
2986             emit Attest(to, startTokenId);
2987         } else if (to == address(0)){
2988             emit Revoke(to, startTokenId);
2989         }
2990     }
2991 }