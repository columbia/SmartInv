1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-28
3 */
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
74 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83     uint8 private constant _ADDRESS_LENGTH = 20;
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
140 
141     /**
142      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
143      */
144     function toHexString(address addr) internal pure returns (string memory) {
145         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
146     }
147 }
148 
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Provides information about the current execution context, including the
158  * sender of the transaction and its data. While these are generally available
159  * via msg.sender and msg.data, they should not be accessed in such a direct
160  * manner, since when dealing with meta-transactions the account sending and
161  * paying for execution may not be the actual sender (as far as an application
162  * is concerned).
163  *
164  * This contract is only required for intermediate, library-like contracts.
165  */
166 abstract contract Context {
167     function _msgSender() internal view virtual returns (address) {
168         return msg.sender;
169     }
170 
171     function _msgData() internal view virtual returns (bytes calldata) {
172         return msg.data;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/access/Ownable.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor() {
205         _transferOwnership(_msgSender());
206     }
207 
208     /**
209      * @dev Throws if called by any account other than the owner.
210      */
211     modifier onlyOwner() {
212         _checkOwner();
213         _;
214     }
215 
216     /**
217      * @dev Returns the address of the current owner.
218      */
219     function owner() public view virtual returns (address) {
220         return _owner;
221     }
222 
223     /**
224      * @dev Throws if the sender is not the owner.
225      */
226     function _checkOwner() internal view virtual {
227         require(owner() == _msgSender(), "Ownable: caller is not the owner");
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public virtual onlyOwner {
238         _transferOwnership(address(0));
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Internal function without access restriction.
253      */
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
265 
266 pragma solidity ^0.8.1;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      *
289      * [IMPORTANT]
290      * ====
291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
292      *
293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
295      * constructor.
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize/address.code.length, which returns 0
300         // for contracts in construction, since the code is only stored at the end
301         // of the constructor execution.
302 
303         return account.code.length > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
459      * revert reason using the provided one.
460      *
461      * _Available since v4.3._
462      */
463     function verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) internal pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474                 /// @solidity memory-safe-assembly
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
487 
488 
489 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @title ERC721 token receiver interface
495  * @dev Interface for any contract that wants to support safeTransfers
496  * from ERC721 asset contracts.
497  */
498 interface IERC721Receiver {
499     /**
500      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
501      * by `operator` from `from`, this function is called.
502      *
503      * It must return its Solidity selector to confirm the token transfer.
504      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
505      *
506      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
507      */
508     function onERC721Received(
509         address operator,
510         address from,
511         uint256 tokenId,
512         bytes calldata data
513     ) external returns (bytes4);
514 }
515 
516 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Interface of the ERC165 standard, as defined in the
525  * https://eips.ethereum.org/EIPS/eip-165[EIP].
526  *
527  * Implementers can declare support of contract interfaces, which can then be
528  * queried by others ({ERC165Checker}).
529  *
530  * For an implementation, see {ERC165}.
531  */
532 interface IERC165 {
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30 000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) external view returns (bool);
542 }
543 
544 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Required interface of an ERC721 compliant contract.
585  */
586 interface IERC721 is IERC165 {
587     /**
588      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
589      */
590     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
591 
592     /**
593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
594      */
595     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
596 
597     /**
598      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
599      */
600     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
601 
602     /**
603      * @dev Returns the number of tokens in ``owner``'s account.
604      */
605     function balanceOf(address owner) external view returns (uint256 balance);
606 
607     /**
608      * @dev Returns the owner of the `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function ownerOf(uint256 tokenId) external view returns (address owner);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes calldata data
634     ) external;
635 
636     /**
637      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
638      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
639      *
640      * Requirements:
641      *
642      * - `from` cannot be the zero address.
643      * - `to` cannot be the zero address.
644      * - `tokenId` token must exist and be owned by `from`.
645      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
647      *
648      * Emits a {Transfer} event.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external;
655 
656     /**
657      * @dev Transfers `tokenId` token from `from` to `to`.
658      *
659      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must be owned by `from`.
666      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
667      *
668      * Emits a {Transfer} event.
669      */
670     function transferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
678      * The approval is cleared when the token is transferred.
679      *
680      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
681      *
682      * Requirements:
683      *
684      * - The caller must own the token or be an approved operator.
685      * - `tokenId` must exist.
686      *
687      * Emits an {Approval} event.
688      */
689     function approve(address to, uint256 tokenId) external;
690 
691     /**
692      * @dev Approve or remove `operator` as an operator for the caller.
693      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
694      *
695      * Requirements:
696      *
697      * - The `operator` cannot be the caller.
698      *
699      * Emits an {ApprovalForAll} event.
700      */
701     function setApprovalForAll(address operator, bool _approved) external;
702 
703     /**
704      * @dev Returns the account approved for `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function getApproved(uint256 tokenId) external view returns (address operator);
711 
712     /**
713      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
714      *
715      * See {setApprovalForAll}
716      */
717     function isApprovedForAll(address owner, address operator) external view returns (bool);
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
721 
722 
723 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
730  * @dev See https://eips.ethereum.org/EIPS/eip-721
731  */
732 interface IERC721Metadata is IERC721 {
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() external view returns (string memory);
737 
738     /**
739      * @dev Returns the token collection symbol.
740      */
741     function symbol() external view returns (string memory);
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) external view returns (string memory);
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
750 
751 
752 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 
758 
759 
760 
761 
762 
763 /**
764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension, but not including the Enumerable extension, which is available separately as
766  * {ERC721Enumerable}.
767  */
768 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
769     using Address for address;
770     using Strings for uint256;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to owner address
779     mapping(uint256 => address) private _owners;
780 
781     // Mapping owner address to token count
782     mapping(address => uint256) private _balances;
783 
784     // Mapping from token ID to approved address
785     mapping(uint256 => address) private _tokenApprovals;
786 
787     // Mapping from owner to operator approvals
788     mapping(address => mapping(address => bool)) private _operatorApprovals;
789 
790     /**
791      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
792      */
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796     }
797 
798     /**
799      * @dev See {IERC165-supportsInterface}.
800      */
801     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
802         return
803             interfaceId == type(IERC721).interfaceId ||
804             interfaceId == type(IERC721Metadata).interfaceId ||
805             super.supportsInterface(interfaceId);
806     }
807 
808     /**
809      * @dev See {IERC721-balanceOf}.
810      */
811     function balanceOf(address owner) public view virtual override returns (uint256) {
812         require(owner != address(0), "ERC721: address zero is not a valid owner");
813         return _balances[owner];
814     }
815 
816     /**
817      * @dev See {IERC721-ownerOf}.
818      */
819     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
820         address owner = _owners[tokenId];
821         require(owner != address(0), "ERC721: invalid token ID");
822         return owner;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-name}.
827      */
828     function name() public view virtual override returns (string memory) {
829         return _name;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-symbol}.
834      */
835     function symbol() public view virtual override returns (string memory) {
836         return _symbol;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-tokenURI}.
841      */
842     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
843         _requireMinted(tokenId);
844 
845         string memory baseURI = _baseURI();
846         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
847     }
848 
849     /**
850      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
851      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
852      * by default, can be overridden in child contracts.
853      */
854     function _baseURI() internal view virtual returns (string memory) {
855         return "";
856     }
857 
858     /**
859      * @dev See {IERC721-approve}.
860      */
861     function approve(address to, uint256 tokenId) public virtual override {
862         address owner = ERC721.ownerOf(tokenId);
863         require(to != owner, "ERC721: approval to current owner");
864 
865         require(
866             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
867             "ERC721: approve caller is not token owner nor approved for all"
868         );
869 
870         _approve(to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-getApproved}.
875      */
876     function getApproved(uint256 tokenId) public view virtual override returns (address) {
877         _requireMinted(tokenId);
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     /**
883      * @dev See {IERC721-setApprovalForAll}.
884      */
885     function setApprovalForAll(address operator, bool approved) public virtual override {
886         _setApprovalForAll(_msgSender(), operator, approved);
887     }
888 
889     /**
890      * @dev See {IERC721-isApprovedForAll}.
891      */
892     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
893         return _operatorApprovals[owner][operator];
894     }
895 
896     /**
897      * @dev See {IERC721-transferFrom}.
898      */
899     function transferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         //solhint-disable-next-line max-line-length
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
906 
907         _transfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public virtual override {
918         safeTransferFrom(from, to, tokenId, "");
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory data
929     ) public virtual override {
930         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
931         _safeTransfer(from, to, tokenId, data);
932     }
933 
934     /**
935      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
936      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
937      *
938      * `data` is additional data, it has no specified format and it is sent in call to `to`.
939      *
940      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
941      * implement alternative mechanisms to perform token transfer, such as signature-based.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeTransfer(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory data
957     ) internal virtual {
958         _transfer(from, to, tokenId);
959         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      * and stop existing when they are burned (`_burn`).
969      */
970     function _exists(uint256 tokenId) internal view virtual returns (bool) {
971         return _owners[tokenId] != address(0);
972     }
973 
974     /**
975      * @dev Returns whether `spender` is allowed to manage `tokenId`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      */
981     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
982         address owner = ERC721.ownerOf(tokenId);
983         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
984     }
985 
986     /**
987      * @dev Safely mints `tokenId` and transfers it to `to`.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must not exist.
992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeMint(address to, uint256 tokenId) internal virtual {
997         _safeMint(to, tokenId, "");
998     }
999 
1000     /**
1001      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1002      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 tokenId,
1007         bytes memory data
1008     ) internal virtual {
1009         _mint(to, tokenId);
1010         require(
1011             _checkOnERC721Received(address(0), to, tokenId, data),
1012             "ERC721: transfer to non ERC721Receiver implementer"
1013         );
1014     }
1015 
1016     /**
1017      * @dev Mints `tokenId` and transfers it to `to`.
1018      *
1019      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must not exist.
1024      * - `to` cannot be the zero address.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _mint(address to, uint256 tokenId) internal virtual {
1029         require(to != address(0), "ERC721: mint to the zero address");
1030         require(!_exists(tokenId), "ERC721: token already minted");
1031 
1032         _beforeTokenTransfer(address(0), to, tokenId);
1033 
1034         _balances[to] += 1;
1035         _owners[tokenId] = to;
1036 
1037         emit Transfer(address(0), to, tokenId);
1038 
1039         _afterTokenTransfer(address(0), to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Destroys `tokenId`.
1044      * The approval is cleared when the token is burned.
1045      *
1046      * Requirements:
1047      *
1048      * - `tokenId` must exist.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _burn(uint256 tokenId) internal virtual {
1053         address owner = ERC721.ownerOf(tokenId);
1054 
1055         _beforeTokenTransfer(owner, address(0), tokenId);
1056 
1057         // Clear approvals
1058         _approve(address(0), tokenId);
1059 
1060         _balances[owner] -= 1;
1061         delete _owners[tokenId];
1062 
1063         emit Transfer(owner, address(0), tokenId);
1064 
1065         _afterTokenTransfer(owner, address(0), tokenId);
1066     }
1067 
1068     /**
1069      * @dev Transfers `tokenId` from `from` to `to`.
1070      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _transfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {
1084         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1085         require(to != address(0), "ERC721: transfer to the zero address");
1086 
1087         _beforeTokenTransfer(from, to, tokenId);
1088 
1089         // Clear approvals from the previous owner
1090         _approve(address(0), tokenId);
1091 
1092         _balances[from] -= 1;
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(from, to, tokenId);
1097 
1098         _afterTokenTransfer(from, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Approve `to` to operate on `tokenId`
1103      *
1104      * Emits an {Approval} event.
1105      */
1106     function _approve(address to, uint256 tokenId) internal virtual {
1107         _tokenApprovals[tokenId] = to;
1108         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Approve `operator` to operate on all of `owner` tokens
1113      *
1114      * Emits an {ApprovalForAll} event.
1115      */
1116     function _setApprovalForAll(
1117         address owner,
1118         address operator,
1119         bool approved
1120     ) internal virtual {
1121         require(owner != operator, "ERC721: approve to caller");
1122         _operatorApprovals[owner][operator] = approved;
1123         emit ApprovalForAll(owner, operator, approved);
1124     }
1125 
1126     /**
1127      * @dev Reverts if the `tokenId` has not been minted yet.
1128      */
1129     function _requireMinted(uint256 tokenId) internal view virtual {
1130         require(_exists(tokenId), "ERC721: invalid token ID");
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1135      * The call is not executed if the target address is not a contract.
1136      *
1137      * @param from address representing the previous owner of the given token ID
1138      * @param to target address that will receive the tokens
1139      * @param tokenId uint256 ID of the token to be transferred
1140      * @param data bytes optional data to send along with the call
1141      * @return bool whether the call correctly returned the expected magic value
1142      */
1143     function _checkOnERC721Received(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory data
1148     ) private returns (bool) {
1149         if (to.isContract()) {
1150             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1151                 return retval == IERC721Receiver.onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert("ERC721: transfer to non ERC721Receiver implementer");
1155                 } else {
1156                     /// @solidity memory-safe-assembly
1157                     assembly {
1158                         revert(add(32, reason), mload(reason))
1159                     }
1160                 }
1161             }
1162         } else {
1163             return true;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before any token transfer. This includes minting
1169      * and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1177      * - `from` and `to` are never both zero.
1178      *
1179      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1180      */
1181     function _beforeTokenTransfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) internal virtual {}
1186 
1187     /**
1188      * @dev Hook that is called after any transfer of tokens. This includes
1189      * minting and burning.
1190      *
1191      * Calling conditions:
1192      *
1193      * - when `from` and `to` are both non-zero.
1194      * - `from` and `to` are never both zero.
1195      *
1196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1197      */
1198     function _afterTokenTransfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) internal virtual {}
1203 }
1204 
1205 // File: contracts/erc721.sol
1206 
1207 
1208 pragma solidity ^0.8.9;
1209 
1210 
1211 
1212 
1213 // @author codingwithdidem
1214 // @contact codingwithdidem@gmail.com
1215 
1216 
1217 library Counters {
1218     struct Counter {
1219         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1220         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1221         // this feature: see https://github.com/ethereum/solidity/issues/4637
1222         uint256 _value; // default: 0
1223     }
1224 
1225     function current(Counter storage counter) internal view returns (uint256) {
1226         return counter._value;
1227     }
1228 
1229     function increment(Counter storage counter) internal {
1230         unchecked {
1231             counter._value += 1;
1232         }
1233     }
1234 
1235     function decrement(Counter storage counter) internal {
1236         uint256 value = counter._value;
1237         require(value > 0, "Counter: decrement overflow");
1238         unchecked {
1239             counter._value = value - 1;
1240         }
1241     }
1242 
1243     function reset(Counter storage counter) internal {
1244         counter._value = 0;
1245     }
1246 }
1247 
1248 contract DoodlinTown is 
1249     ERC721, 
1250     Ownable, 
1251     ReentrancyGuard
1252 {
1253     using Strings for uint256;
1254     using Counters for Counters.Counter;
1255     bytes32 public root;
1256     
1257     address proxyRegistryAddress;
1258     uint256 public maxSupply = 9999;
1259     string public baseURI; 
1260     string public notRevealedUri = "https://ipfs.io/ipfs/QmSMREUk38XB9Td161fXieX1bVjQWwNBfCua4M6GnzMuwN";
1261     string public baseExtension = ".json";
1262     bool public paused = false;
1263     bool public revealed = false;
1264     bool public presaleM = false;
1265     bool public publicM = false;
1266     uint256 presaleAmountLimit = 4;
1267     mapping(address => uint256) public _presaleClaimed;
1268     uint256 public _price = 0.036 ether; // 0.01 ETH
1269     Counters.Counter private _tokenIds;
1270     
1271     constructor(string memory uri, address _proxyRegistryAddress)
1272         ERC721("DoodlinTown", "DOOD")
1273         
1274         ReentrancyGuard() // A modifier that can prevent reentrancy during certain functions
1275     {
1276         
1277         proxyRegistryAddress = _proxyRegistryAddress;
1278         setBaseURI(uri);
1279     }
1280     function setBaseURI(string memory _tokenBaseURI) public onlyOwner {
1281         baseURI = _tokenBaseURI;
1282     }
1283     
1284     function _baseURI() internal view override returns (string memory) {
1285         return baseURI;
1286     }
1287     function reveal() public onlyOwner {
1288         revealed = true;
1289     }
1290    
1291     modifier onlyAccounts () {
1292         require(msg.sender == tx.origin, "Not allowed origin");
1293         _;
1294     }
1295     
1296     function togglePause() public onlyOwner {
1297         paused = !paused;
1298     }
1299 
1300     function setPrice(uint _amount) external onlyOwner{
1301         _price = _amount;
1302     }
1303 
1304     function togglePresale() public onlyOwner {
1305         presaleM = !presaleM;
1306     }
1307     function togglePublicSale() public onlyOwner {
1308         publicM = !publicM;
1309     }
1310     
1311     function withdraw() external onlyOwner {
1312         payable(msg.sender).transfer(payable(address(this)).balance);
1313     }
1314 
1315     function publicSaleMint(uint256 _amount) 
1316     external 
1317     payable
1318     onlyAccounts
1319     {
1320         require(publicM,                        "Doodlin Town: PublicSale is OFF");
1321         require(!paused, "Doodlin Town: Contract is paused");
1322         require(_amount > 0, "Doodlin Town: zero amount");
1323         uint current = _tokenIds.current();
1324         require(
1325             current + _amount <= maxSupply,
1326             "Doodlin Town: Max supply exceeded"
1327         );
1328         require(
1329             _price * _amount <= msg.value,
1330             "Doodlin Town: Not enough ethers sent"
1331         );
1332         
1333         
1334         for (uint i = 0; i < _amount; i++) {
1335             mintInternal();
1336         }
1337     }
1338     function mintInternal() internal nonReentrant {
1339         _tokenIds.increment();
1340         uint256 tokenId = _tokenIds.current();
1341         _safeMint(msg.sender, tokenId);
1342     }
1343     function tokenURI(uint256 tokenId)
1344         public
1345         view
1346         virtual
1347         override
1348         returns (string memory)
1349     {
1350         require(
1351             _exists(tokenId),
1352             "ERC721Metadata: URI query for nonexistent token"
1353         );
1354         if (revealed == false) {
1355             return notRevealedUri;
1356         }
1357         string memory currentBaseURI = _baseURI();
1358     
1359         return
1360             bytes(currentBaseURI).length > 0
1361                 ? string(
1362                     abi.encodePacked(
1363                         currentBaseURI,
1364                         tokenId.toString(),
1365                         baseExtension
1366                     )
1367                 )
1368                 : "";
1369     }
1370     function setBaseExtension(string memory _newBaseExtension)
1371         public
1372         onlyOwner
1373     {
1374         baseExtension = _newBaseExtension;
1375     }
1376     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1377         notRevealedUri = _notRevealedURI;
1378     }
1379     function totalSupply() public view returns (uint) {
1380         return _tokenIds.current();
1381     }
1382     /**
1383      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1384      */
1385     function isApprovedForAll(address owner, address operator)
1386         override
1387         public
1388         view
1389         returns (bool)
1390     {
1391         // Whitelist OpenSea proxy contract for easy trading.
1392         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1393         if (address(proxyRegistry.proxies(owner)) == operator) {
1394             return true;
1395         }
1396         return super.isApprovedForAll(owner, operator);
1397     }
1398 }
1399 /**
1400   @title An OpenSea delegate proxy contract which we include for whitelisting.
1401   @author OpenSea
1402 */
1403 contract OwnableDelegateProxy {}
1404 /**
1405   @title An OpenSea proxy registry contract which we include for whitelisting.
1406   @author OpenSea
1407 */
1408 contract ProxyRegistry {
1409     mapping(address => OwnableDelegateProxy) public proxies;
1410 }