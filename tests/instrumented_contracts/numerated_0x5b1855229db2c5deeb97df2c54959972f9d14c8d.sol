1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 // SPDX-License-Identifier: MIT
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
124     function toHexString(uint256 value, uint256 length)
125         internal
126         pure
127         returns (string memory)
128     {
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
143 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157 abstract contract Context {
158     function _msgSender() internal view virtual returns (address) {
159         return msg.sender;
160     }
161 
162     function _msgData() internal view virtual returns (bytes calldata) {
163         return msg.data;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
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
188     event OwnershipTransferred(
189         address indexed previousOwner,
190         address indexed newOwner
191     );
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
231         require(
232             newOwner != address(0),
233             "Ownable: new owner is the zero address"
234         );
235         _transferOwnership(newOwner);
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Internal function without access restriction.
241      */
242     function _transferOwnership(address newOwner) internal virtual {
243         address oldOwner = _owner;
244         _owner = newOwner;
245         emit OwnershipTransferred(oldOwner, newOwner);
246     }
247 }
248 
249 // File: @openzeppelin/contracts/utils/Address.sol
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on `isContract` to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(
311             address(this).balance >= amount,
312             "Address: insufficient balance"
313         );
314 
315         (bool success, ) = recipient.call{value: amount}("");
316         require(
317             success,
318             "Address: unable to send value, recipient may have reverted"
319         );
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data)
341         internal
342         returns (bytes memory)
343     {
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
377         return
378             functionCallWithValue(
379                 target,
380                 data,
381                 value,
382                 "Address: low-level call with value failed"
383             );
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(
399             address(this).balance >= value,
400             "Address: insufficient balance for call"
401         );
402         require(isContract(target), "Address: call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.call{value: value}(
405             data
406         );
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data)
417         internal
418         view
419         returns (bytes memory)
420     {
421         return
422             functionStaticCall(
423                 target,
424                 data,
425                 "Address: low-level static call failed"
426             );
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data)
453         internal
454         returns (bytes memory)
455     {
456         return
457             functionDelegateCall(
458                 target,
459                 data,
460                 "Address: low-level delegate call failed"
461             );
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @title ERC721 token receiver interface
518  * @dev Interface for any contract that wants to support safeTransfers
519  * from ERC721 asset contracts.
520  */
521 interface IERC721Receiver {
522     /**
523      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
524      * by `operator` from `from`, this function is called.
525      *
526      * It must return its Solidity selector to confirm the token transfer.
527      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
528      *
529      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
530      */
531     function onERC721Received(
532         address operator,
533         address from,
534         uint256 tokenId,
535         bytes calldata data
536     ) external returns (bytes4);
537 }
538 
539 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Interface of the ERC165 standard, as defined in the
547  * https://eips.ethereum.org/EIPS/eip-165[EIP].
548  *
549  * Implementers can declare support of contract interfaces, which can then be
550  * queried by others ({ERC165Checker}).
551  *
552  * For an implementation, see {ERC165}.
553  */
554 interface IERC165 {
555     /**
556      * @dev Returns true if this contract implements the interface defined by
557      * `interfaceId`. See the corresponding
558      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
559      * to learn more about how these ids are created.
560      *
561      * This function call must use less than 30 000 gas.
562      */
563     function supportsInterface(bytes4 interfaceId) external view returns (bool);
564 }
565 
566 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
567 
568 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Implementation of the {IERC165} interface.
574  *
575  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
576  * for the additional interface id that will be supported. For example:
577  *
578  * ```solidity
579  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
581  * }
582  * ```
583  *
584  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
585  */
586 abstract contract ERC165 is IERC165 {
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId)
591         public
592         view
593         virtual
594         override
595         returns (bool)
596     {
597         return interfaceId == type(IERC165).interfaceId;
598     }
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Required interface of an ERC721 compliant contract.
609  */
610 interface IERC721 is IERC165 {
611     /**
612      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
613      */
614     event Transfer(
615         address indexed from,
616         address indexed to,
617         uint256 indexed tokenId
618     );
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(
624         address indexed owner,
625         address indexed approved,
626         uint256 indexed tokenId
627     );
628 
629     /**
630      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
631      */
632     event ApprovalForAll(
633         address indexed owner,
634         address indexed operator,
635         bool approved
636     );
637 
638     /**
639      * @dev Returns the number of tokens in ``owner``'s account.
640      */
641     function balanceOf(address owner) external view returns (uint256 balance);
642 
643     /**
644      * @dev Returns the owner of the `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function ownerOf(uint256 tokenId) external view returns (address owner);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
654      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) external;
671 
672     /**
673      * @dev Transfers `tokenId` token from `from` to `to`.
674      *
675      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must be owned by `from`.
682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
683      *
684      * Emits a {Transfer} event.
685      */
686     function transferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) external;
691 
692     /**
693      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
694      * The approval is cleared when the token is transferred.
695      *
696      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
697      *
698      * Requirements:
699      *
700      * - The caller must own the token or be an approved operator.
701      * - `tokenId` must exist.
702      *
703      * Emits an {Approval} event.
704      */
705     function approve(address to, uint256 tokenId) external;
706 
707     /**
708      * @dev Returns the account approved for `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function getApproved(uint256 tokenId)
715         external
716         view
717         returns (address operator);
718 
719     /**
720      * @dev Approve or remove `operator` as an operator for the caller.
721      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
722      *
723      * Requirements:
724      *
725      * - The `operator` cannot be the caller.
726      *
727      * Emits an {ApprovalForAll} event.
728      */
729     function setApprovalForAll(address operator, bool _approved) external;
730 
731     /**
732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
733      *
734      * See {setApprovalForAll}
735      */
736     function isApprovedForAll(address owner, address operator)
737         external
738         view
739         returns (bool);
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes calldata data
759     ) external;
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
763 
764 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
765 
766 pragma solidity ^0.8.0;
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 }
788 
789 // File: contracts/ERC721A.sol
790 
791 // Creator: Chiru Labs
792 
793 pragma solidity ^0.8.4;
794 
795 error ApprovalCallerNotOwnerNorApproved();
796 error ApprovalQueryForNonexistentToken();
797 error ApproveToCaller();
798 error ApprovalToCurrentOwner();
799 error BalanceQueryForZeroAddress();
800 error MintToZeroAddress();
801 error MintZeroQuantity();
802 error OwnerQueryForNonexistentToken();
803 error TransferCallerNotOwnerNorApproved();
804 error TransferFromIncorrectOwner();
805 error TransferToNonERC721ReceiverImplementer();
806 error TransferToZeroAddress();
807 error URIQueryForNonexistentToken();
808 
809 /**
810  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
811  * the Metadata extension. Built to optimize for lower gas during batch mints.
812  *
813  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
814  *
815  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
816  *
817  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
818  */
819 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
820     using Address for address;
821     using Strings for uint256;
822 
823     // Compiler will pack this into a single 256bit word.
824     struct TokenOwnership {
825         // The address of the owner.
826         address addr;
827         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
828         uint64 startTimestamp;
829         // Whether the token has been burned.
830         bool burned;
831     }
832 
833     // Compiler will pack this into a single 256bit word.
834     struct AddressData {
835         // Realistically, 2**64-1 is more than enough.
836         uint64 balance;
837         // Keeps track of mint count with minimal overhead for tokenomics.
838         uint64 numberMinted;
839         // Keeps track of burn count with minimal overhead for tokenomics.
840         uint64 numberBurned;
841         // For miscellaneous variable(s) pertaining to the address
842         // (e.g. number of whitelist mint slots used).
843         // If there are multiple variables, please pack them into a uint64.
844         uint64 aux;
845     }
846 
847     // The tokenId of the next token to be minted.
848     uint256 internal _currentIndex;
849 
850     // The number of tokens burned.
851     uint256 internal _burnCounter;
852 
853     // Token name
854     string private _name;
855 
856     // Token symbol
857     string private _symbol;
858 
859     // Mapping from token ID to ownership details
860     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
861     mapping(uint256 => TokenOwnership) internal _ownerships;
862 
863     // Mapping owner address to address data
864     mapping(address => AddressData) private _addressData;
865 
866     // Mapping from token ID to approved address
867     mapping(uint256 => address) private _tokenApprovals;
868 
869     // Mapping from owner to operator approvals
870     mapping(address => mapping(address => bool)) private _operatorApprovals;
871 
872     constructor(string memory name_, string memory symbol_) {
873         _name = name_;
874         _symbol = symbol_;
875         _currentIndex = _startTokenId();
876     }
877 
878     /**
879      * To change the starting tokenId, please override this function.
880      */
881     function _startTokenId() internal view virtual returns (uint256) {
882         return 1;
883     }
884 
885     /**
886      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
887      */
888     function totalSupply() public view returns (uint256) {
889         // Counter underflow is impossible as _burnCounter cannot be incremented
890         // more than _currentIndex - _startTokenId() times
891         unchecked {
892             return _currentIndex - _burnCounter - _startTokenId();
893         }
894     }
895 
896     /**
897      * Returns the total amount of tokens minted in the contract.
898      */
899     function _totalMinted() internal view returns (uint256) {
900         // Counter underflow is impossible as _currentIndex does not decrement,
901         // and it is initialized to _startTokenId()
902         unchecked {
903             return _currentIndex - _startTokenId();
904         }
905     }
906 
907     /**
908      * @dev See {IERC165-supportsInterface}.
909      */
910     function supportsInterface(bytes4 interfaceId)
911         public
912         view
913         virtual
914         override(ERC165, IERC165)
915         returns (bool)
916     {
917         return
918             interfaceId == type(IERC721).interfaceId ||
919             interfaceId == type(IERC721Metadata).interfaceId ||
920             super.supportsInterface(interfaceId);
921     }
922 
923     /**
924      * @dev See {IERC721-balanceOf}.
925      */
926     function balanceOf(address owner) public view override returns (uint256) {
927         if (owner == address(0)) revert BalanceQueryForZeroAddress();
928         return uint256(_addressData[owner].balance);
929     }
930 
931     /**
932      * Returns the number of tokens minted by `owner`.
933      */
934     function _numberMinted(address owner) internal view returns (uint256) {
935         return uint256(_addressData[owner].numberMinted);
936     }
937 
938     /**
939      * Returns the number of tokens burned by or on behalf of `owner`.
940      */
941     function _numberBurned(address owner) internal view returns (uint256) {
942         return uint256(_addressData[owner].numberBurned);
943     }
944 
945     /**
946      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
947      */
948     function _getAux(address owner) internal view returns (uint64) {
949         return _addressData[owner].aux;
950     }
951 
952     /**
953      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
954      * If there are multiple variables, please pack them into a uint64.
955      */
956     function _setAux(address owner, uint64 aux) internal {
957         _addressData[owner].aux = aux;
958     }
959 
960     /**
961      * Gas spent here starts off proportional to the maximum mint batch size.
962      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
963      */
964     function _ownershipOf(uint256 tokenId)
965         internal
966         view
967         returns (TokenOwnership memory)
968     {
969         uint256 curr = tokenId;
970 
971         unchecked {
972             if (_startTokenId() <= curr && curr < _currentIndex) {
973                 TokenOwnership memory ownership = _ownerships[curr];
974                 if (!ownership.burned) {
975                     if (ownership.addr != address(0)) {
976                         return ownership;
977                     }
978                     // Invariant:
979                     // There will always be an ownership that has an address and is not burned
980                     // before an ownership that does not have an address and is not burned.
981                     // Hence, curr will not underflow.
982                     while (true) {
983                         curr--;
984                         ownership = _ownerships[curr];
985                         if (ownership.addr != address(0)) {
986                             return ownership;
987                         }
988                     }
989                 }
990             }
991         }
992         revert OwnerQueryForNonexistentToken();
993     }
994 
995     /**
996      * @dev See {IERC721-ownerOf}.
997      */
998     function ownerOf(uint256 tokenId) public view override returns (address) {
999         return _ownershipOf(tokenId).addr;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-name}.
1004      */
1005     function name() public view virtual override returns (string memory) {
1006         return _name;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Metadata-symbol}.
1011      */
1012     function symbol() public view virtual override returns (string memory) {
1013         return _symbol;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-tokenURI}.
1018      */
1019     function tokenURI(uint256 tokenId)
1020         public
1021         view
1022         virtual
1023         override
1024         returns (string memory)
1025     {
1026         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1027 
1028         string memory baseURI = _baseURI();
1029         return
1030             bytes(baseURI).length != 0
1031                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1032                 : "";
1033     }
1034 
1035     /**
1036      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1037      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1038      * by default, can be overriden in child contracts.
1039      */
1040     function _baseURI() internal view virtual returns (string memory) {
1041         return "";
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-approve}.
1046      */
1047     function approve(address to, uint256 tokenId) public override {
1048         address owner = ERC721A.ownerOf(tokenId);
1049         if (to == owner) revert ApprovalToCurrentOwner();
1050 
1051         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1052             revert ApprovalCallerNotOwnerNorApproved();
1053         }
1054 
1055         _approve(to, tokenId, owner);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-getApproved}.
1060      */
1061     function getApproved(uint256 tokenId)
1062         public
1063         view
1064         override
1065         returns (address)
1066     {
1067         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved)
1076         public
1077         virtual
1078         override
1079     {
1080         if (operator == _msgSender()) revert ApproveToCaller();
1081 
1082         _operatorApprovals[_msgSender()][operator] = approved;
1083         emit ApprovalForAll(_msgSender(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator)
1090         public
1091         view
1092         virtual
1093         override
1094         returns (bool)
1095     {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-transferFrom}.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         _transfer(from, to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public virtual override {
1118         safeTransferFrom(from, to, tokenId, "");
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) public virtual override {
1130         _transfer(from, to, tokenId);
1131         if (
1132             to.isContract() &&
1133             !_checkContractOnERC721Received(from, to, tokenId, _data)
1134         ) {
1135             revert TransferToNonERC721ReceiverImplementer();
1136         }
1137     }
1138 
1139     /**
1140      * @dev Returns whether `tokenId` exists.
1141      *
1142      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1143      *
1144      * Tokens start existing when they are minted (`_mint`),
1145      */
1146     function _exists(uint256 tokenId) internal view returns (bool) {
1147         return
1148             _startTokenId() <= tokenId &&
1149             tokenId < _currentIndex &&
1150             !_ownerships[tokenId].burned;
1151     }
1152 
1153     /**
1154      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1155      */
1156     function _safeMint(address to, uint256 quantity) internal {
1157         _safeMint(to, quantity, "");
1158     }
1159 
1160     /**
1161      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - If `to` refers to a smart contract, it must implement
1166      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1167      * - `quantity` must be greater than 0.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _safeMint(
1172         address to,
1173         uint256 quantity,
1174         bytes memory _data
1175     ) internal {
1176         uint256 startTokenId = _currentIndex;
1177         if (to == address(0)) revert MintToZeroAddress();
1178         if (quantity == 0) revert MintZeroQuantity();
1179 
1180         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1181 
1182         // Overflows are incredibly unrealistic.
1183         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1184         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1185         unchecked {
1186             _addressData[to].balance += uint64(quantity);
1187             _addressData[to].numberMinted += uint64(quantity);
1188 
1189             _ownerships[startTokenId].addr = to;
1190             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1191 
1192             uint256 updatedIndex = startTokenId;
1193             uint256 end = updatedIndex + quantity;
1194 
1195             if (to.isContract()) {
1196                 do {
1197                     emit Transfer(address(0), to, updatedIndex);
1198                     if (
1199                         !_checkContractOnERC721Received(
1200                             address(0),
1201                             to,
1202                             updatedIndex++,
1203                             _data
1204                         )
1205                     ) {
1206                         revert TransferToNonERC721ReceiverImplementer();
1207                     }
1208                 } while (updatedIndex != end);
1209                 // Reentrancy protection
1210                 if (_currentIndex != startTokenId) revert();
1211             } else {
1212                 do {
1213                     emit Transfer(address(0), to, updatedIndex++);
1214                 } while (updatedIndex != end);
1215             }
1216             _currentIndex = updatedIndex;
1217         }
1218         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1219     }
1220 
1221     /**
1222      * @dev Mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - `to` cannot be the zero address.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _mint(address to, uint256 quantity) internal {
1232         uint256 startTokenId = _currentIndex;
1233         if (to == address(0)) revert MintToZeroAddress();
1234         if (quantity == 0) revert MintZeroQuantity();
1235 
1236         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1237 
1238         // Overflows are incredibly unrealistic.
1239         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1240         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1241         unchecked {
1242             _addressData[to].balance += uint64(quantity);
1243             _addressData[to].numberMinted += uint64(quantity);
1244 
1245             _ownerships[startTokenId].addr = to;
1246             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1247 
1248             uint256 updatedIndex = startTokenId;
1249             uint256 end = updatedIndex + quantity;
1250 
1251             do {
1252                 emit Transfer(address(0), to, updatedIndex++);
1253             } while (updatedIndex != end);
1254 
1255             _currentIndex = updatedIndex;
1256         }
1257         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1258     }
1259 
1260     /**
1261      * @dev Transfers `tokenId` from `from` to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) private {
1275         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1276 
1277         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1278 
1279         bool isApprovedOrOwner = (_msgSender() == from ||
1280             isApprovedForAll(from, _msgSender()) ||
1281             getApproved(tokenId) == _msgSender());
1282 
1283         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1284         if (to == address(0)) revert TransferToZeroAddress();
1285 
1286         _beforeTokenTransfers(from, to, tokenId, 1);
1287 
1288         // Clear approvals from the previous owner
1289         _approve(address(0), tokenId, from);
1290 
1291         // Underflow of the sender's balance is impossible because we check for
1292         // ownership above and the recipient's balance can't realistically overflow.
1293         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1294         unchecked {
1295             _addressData[from].balance -= 1;
1296             _addressData[to].balance += 1;
1297 
1298             TokenOwnership storage currSlot = _ownerships[tokenId];
1299             currSlot.addr = to;
1300             currSlot.startTimestamp = uint64(block.timestamp);
1301 
1302             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1303             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1304             uint256 nextTokenId = tokenId + 1;
1305             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1306             if (nextSlot.addr == address(0)) {
1307                 // This will suffice for checking _exists(nextTokenId),
1308                 // as a burned slot cannot contain the zero address.
1309                 if (nextTokenId != _currentIndex) {
1310                     nextSlot.addr = from;
1311                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1312                 }
1313             }
1314         }
1315 
1316         emit Transfer(from, to, tokenId);
1317         _afterTokenTransfers(from, to, tokenId, 1);
1318     }
1319 
1320     /**
1321      * @dev Equivalent to `_burn(tokenId, false)`.
1322      */
1323     function _burn(uint256 tokenId) internal virtual {
1324         _burn(tokenId, false);
1325     }
1326 
1327     /**
1328      * @dev Destroys `tokenId`.
1329      * The approval is cleared when the token is burned.
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must exist.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1338         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1339 
1340         address from = prevOwnership.addr;
1341 
1342         if (approvalCheck) {
1343             bool isApprovedOrOwner = (_msgSender() == from ||
1344                 isApprovedForAll(from, _msgSender()) ||
1345                 getApproved(tokenId) == _msgSender());
1346 
1347             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1348         }
1349 
1350         _beforeTokenTransfers(from, address(0), tokenId, 1);
1351 
1352         // Clear approvals from the previous owner
1353         _approve(address(0), tokenId, from);
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1358         unchecked {
1359             AddressData storage addressData = _addressData[from];
1360             addressData.balance -= 1;
1361             addressData.numberBurned += 1;
1362 
1363             // Keep track of who burned the token, and the timestamp of burning.
1364             TokenOwnership storage currSlot = _ownerships[tokenId];
1365             currSlot.addr = from;
1366             currSlot.startTimestamp = uint64(block.timestamp);
1367             currSlot.burned = true;
1368 
1369             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1370             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1371             uint256 nextTokenId = tokenId + 1;
1372             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1373             if (nextSlot.addr == address(0)) {
1374                 // This will suffice for checking _exists(nextTokenId),
1375                 // as a burned slot cannot contain the zero address.
1376                 if (nextTokenId != _currentIndex) {
1377                     nextSlot.addr = from;
1378                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1379                 }
1380             }
1381         }
1382 
1383         emit Transfer(from, address(0), tokenId);
1384         _afterTokenTransfers(from, address(0), tokenId, 1);
1385 
1386         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1387         unchecked {
1388             _burnCounter++;
1389         }
1390     }
1391 
1392     /**
1393      * @dev Approve `to` to operate on `tokenId`
1394      *
1395      * Emits a {Approval} event.
1396      */
1397     function _approve(
1398         address to,
1399         uint256 tokenId,
1400         address owner
1401     ) private {
1402         _tokenApprovals[tokenId] = to;
1403         emit Approval(owner, to, tokenId);
1404     }
1405 
1406     /**
1407      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1408      *
1409      * @param from address representing the previous owner of the given token ID
1410      * @param to target address that will receive the tokens
1411      * @param tokenId uint256 ID of the token to be transferred
1412      * @param _data bytes optional data to send along with the call
1413      * @return bool whether the call correctly returned the expected magic value
1414      */
1415     function _checkContractOnERC721Received(
1416         address from,
1417         address to,
1418         uint256 tokenId,
1419         bytes memory _data
1420     ) private returns (bool) {
1421         try
1422             IERC721Receiver(to).onERC721Received(
1423                 _msgSender(),
1424                 from,
1425                 tokenId,
1426                 _data
1427             )
1428         returns (bytes4 retval) {
1429             return retval == IERC721Receiver(to).onERC721Received.selector;
1430         } catch (bytes memory reason) {
1431             if (reason.length == 0) {
1432                 revert TransferToNonERC721ReceiverImplementer();
1433             } else {
1434                 assembly {
1435                     revert(add(32, reason), mload(reason))
1436                 }
1437             }
1438         }
1439     }
1440 
1441     /**
1442      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1443      * And also called before burning one token.
1444      *
1445      * startTokenId - the first token id to be transferred
1446      * quantity - the amount to be transferred
1447      *
1448      * Calling conditions:
1449      *
1450      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1451      * transferred to `to`.
1452      * - When `from` is zero, `tokenId` will be minted for `to`.
1453      * - When `to` is zero, `tokenId` will be burned by `from`.
1454      * - `from` and `to` are never both zero.
1455      */
1456     function _beforeTokenTransfers(
1457         address from,
1458         address to,
1459         uint256 startTokenId,
1460         uint256 quantity
1461     ) internal virtual {}
1462 
1463     /**
1464      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1465      * minting.
1466      * And also called after one token has been burned.
1467      *
1468      * startTokenId - the first token id to be transferred
1469      * quantity - the amount to be transferred
1470      *
1471      * Calling conditions:
1472      *
1473      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1474      * transferred to `to`.
1475      * - When `from` is zero, `tokenId` has been minted for `to`.
1476      * - When `to` is zero, `tokenId` has been burned by `from`.
1477      * - `from` and `to` are never both zero.
1478      */
1479     function _afterTokenTransfers(
1480         address from,
1481         address to,
1482         uint256 startTokenId,
1483         uint256 quantity
1484     ) internal virtual {}
1485 }
1486 
1487 pragma solidity ^0.8.0;
1488 
1489 contract gltchzz is ERC721A, Ownable, ReentrancyGuard {
1490     using Address for address;
1491     using Strings for uint256;
1492 
1493     string public baseTokenURI = "ipfs://QmYFbsGbnewG6ixKNHGsvoUY3LaGwZy8o3UErs4RRiXPoy";
1494     uint256 public maxSupply = 4444;
1495     uint256 public MAX_TOKENS_PER_TX = 3;
1496     uint256 public SALE_PRICE = 0.008 ether;
1497     uint256 public WALLET_LIMIT = 3;
1498     bool public isPublicSaleActive = false;
1499 
1500     constructor() ERC721A("GLTCHZ", "gltchz") {}
1501 
1502     function mint(uint256 numberOfTokens) external payable {
1503         require(isPublicSaleActive, "Public sale is not open");
1504         require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1505         require(
1506             balanceOf(msg.sender) + numberOfTokens <= WALLET_LIMIT,
1507             "Max mints per wallet exceeded "
1508         );
1509         require(
1510             numberOfTokens <= MAX_TOKENS_PER_TX,
1511             "Max mints per transaction exceeded"
1512         );
1513         require(
1514             (SALE_PRICE * numberOfTokens) <= msg.value,
1515             "Incorrect ETH value sent"
1516         );
1517 
1518         _safeMint(msg.sender, numberOfTokens);
1519     }
1520 
1521     function devMint(uint256 _quantity) external onlyOwner {
1522         _safeMint(msg.sender, _quantity);
1523     }
1524 
1525     function setBaseURI(string memory baseURI) public onlyOwner {
1526         baseTokenURI = baseURI;
1527     }
1528 
1529     function treasuryMint(uint256 quantity) public onlyOwner {
1530         require(quantity > 0, "Invalid mint amount");
1531         require(
1532             totalSupply() + quantity <= maxSupply,
1533             "Maximum supply exceeded"
1534         );
1535         _safeMint(msg.sender, quantity);
1536     }
1537 
1538     function withdraw() public onlyOwner nonReentrant {
1539         Address.sendValue(payable(msg.sender), address(this).balance);
1540     }
1541 
1542     function tokenURI(uint256 _tokenId)
1543         public
1544         view
1545         virtual
1546         override
1547         returns (string memory)
1548     {
1549         require(
1550             _exists(_tokenId),
1551             "ERC721Metadata: URI query for nonexistent token"
1552         );
1553         return
1554             string(
1555                 abi.encodePacked(
1556                     baseTokenURI,
1557                     "/",
1558                     _tokenId.toString(),
1559                     ".json"
1560                 )
1561             );
1562     }
1563 
1564     function _baseURI() internal view virtual override returns (string memory) {
1565         return baseTokenURI;
1566     }
1567 
1568     function setIsPublicSaleActive(bool _isPublicSaleActive)
1569         external
1570         onlyOwner
1571     {
1572         isPublicSaleActive = _isPublicSaleActive;
1573     }
1574 
1575     function setSalePrice(uint256 _price) external onlyOwner {
1576         SALE_PRICE = _price;
1577     }
1578 
1579     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner {
1580         MAX_TOKENS_PER_TX = _limit;
1581     }
1582 }