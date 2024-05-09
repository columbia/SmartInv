1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File contracts/Context.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File contracts/Ownable.sol
31 
32 
33 pragma solidity 0.8.9;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _setOwner(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _setOwner(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(
94             newOwner != address(0),
95             "Ownable: new owner is the zero address"
96         );
97         _setOwner(newOwner);
98     }
99 
100     function _setOwner(address newOwner) private {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File contracts/ReentrancyGuard.sol
109 
110 
111 pragma solidity 0.8.9;
112 
113 /**
114  * @dev Contract module that helps prevent reentrant calls to a function.
115  *
116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
117  * available, which can be applied to functions to make sure there are no nested
118  * (reentrant) calls to them.
119  *
120  * Note that because there is a single `nonReentrant` guard, functions marked as
121  * `nonReentrant` may not call one another. This can be worked around by making
122  * those functions `private`, and then adding `external` `nonReentrant` entry
123  * points to them.
124  *
125  * TIP: If you would like to learn more about reentrancy and alternative ways
126  * to protect against it, check out our blog post
127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
128  */
129 abstract contract ReentrancyGuard {
130     // Booleans are more expensive than uint256 or any type that takes up a full
131     // word because each write operation emits an extra SLOAD to first read the
132     // slot's contents, replace the bits taken up by the boolean, and then write
133     // back. This is the compiler's defense against contract upgrades and
134     // pointer aliasing, and it cannot be disabled.
135 
136     // The values being non-zero value makes deployment a bit more expensive,
137     // but in exchange the refund on every call to nonReentrant will be lower in
138     // amount. Since refunds are capped to a percentage of the total
139     // transaction's gas, it is best to keep them low in cases like this one, to
140     // increase the likelihood of the full refund coming into effect.
141     uint256 private constant _NOT_ENTERED = 1;
142     uint256 private constant _ENTERED = 2;
143 
144     uint256 private _status;
145 
146     constructor() {
147         _status = _NOT_ENTERED;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and make it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         // On the first call to nonReentrant, _notEntered will be true
159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161         // Any calls to nonReentrant after this point will fail
162         _status = _ENTERED;
163 
164         _;
165         // By storing the original value once again, a refund is triggered (see
166         // https://eips.ethereum.org/EIPS/eip-2200)
167         _status = _NOT_ENTERED;
168     }
169 }
170 
171 
172 // File contracts/interfaces/IERC165.sol
173 
174 /**
175  * @dev Interface of the ERC165 standard, as defined in the
176  * https://eips.ethereum.org/EIPS/eip-165[EIP].
177  *
178  * Implementers can declare support of contract interfaces, which can then be
179  * queried by others ({ERC165Checker}).
180  *
181  * For an implementation, see {ERC165}.
182  */
183 interface IERC165 {
184     /**
185      * @dev Returns true if this contract implements the interface defined by
186      * `interfaceId`. See the corresponding
187      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
188      * to learn more about how these ids are created.
189      *
190      * This function call must use less than 30 000 gas.
191      */
192     function supportsInterface(bytes4 interfaceId) external view returns (bool);
193 }
194 
195 
196 // File contracts/interfaces/IERC721.sol
197 
198 /**
199  * @dev Required interface of an ERC721 compliant contract.
200  */
201 interface IERC721 is IERC165 {
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(
206         address indexed from,
207         address indexed to,
208         uint256 indexed tokenId
209     );
210 
211     /**
212      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
213      */
214     event Approval(
215         address indexed owner,
216         address indexed approved,
217         uint256 indexed tokenId
218     );
219 
220     /**
221      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
222      */
223     event ApprovalForAll(
224         address indexed owner,
225         address indexed operator,
226         bool approved
227     );
228 
229     /**
230      * @dev Returns the number of tokens in ``owner``'s account.
231      */
232     function balanceOf(address owner) external view returns (uint256 balance);
233 
234     /**
235      * @dev Returns the owner of the `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function ownerOf(uint256 tokenId) external view returns (address owner);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
245      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
246      *
247      * Requirements:
248      *
249      * - `from` cannot be the zero address.
250      * - `to` cannot be the zero address.
251      * - `tokenId` token must exist and be owned by `from`.
252      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
254      *
255      * Emits a {Transfer} event.
256      */
257     function safeTransferFrom(
258         address from,
259         address to,
260         uint256 tokenId
261     ) external;
262 
263     /**
264      * @dev Transfers `tokenId` token from `from` to `to`.
265      *
266      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must be owned by `from`.
273      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(
278         address from,
279         address to,
280         uint256 tokenId
281     ) external;
282 
283     /**
284      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
285      * The approval is cleared when the token is transferred.
286      *
287      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
288      *
289      * Requirements:
290      *
291      * - The caller must own the token or be an approved operator.
292      * - `tokenId` must exist.
293      *
294      * Emits an {Approval} event.
295      */
296     function approve(address to, uint256 tokenId) external;
297 
298     /**
299      * @dev Returns the account approved for `tokenId` token.
300      *
301      * Requirements:
302      *
303      * - `tokenId` must exist.
304      */
305     function getApproved(uint256 tokenId)
306         external
307         view
308         returns (address operator);
309 
310     /**
311      * @dev Approve or remove `operator` as an operator for the caller.
312      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
313      *
314      * Requirements:
315      *
316      * - The `operator` cannot be the caller.
317      *
318      * Emits an {ApprovalForAll} event.
319      */
320     function setApprovalForAll(address operator, bool _approved) external;
321 
322     /**
323      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
324      *
325      * See {setApprovalForAll}
326      */
327     function isApprovedForAll(address owner, address operator)
328         external
329         view
330         returns (bool);
331 
332     /**
333      * @dev Safely transfers `tokenId` token from `from` to `to`.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must exist and be owned by `from`.
340      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
342      *
343      * Emits a {Transfer} event.
344      */
345     function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId,
349         bytes calldata data
350     ) external;
351 }
352 
353 
354 // File contracts/interfaces/IERC721Receiver.sol
355 
356 /**
357  * @title ERC721 token receiver interface
358  * @dev Interface for any contract that wants to support safeTransfers
359  * from ERC721 asset contracts.
360  */
361 interface IERC721Receiver {
362     /**
363      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
364      * by `operator` from `from`, this function is called.
365      *
366      * It must return its Solidity selector to confirm the token transfer.
367      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
368      *
369      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
370      */
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 
380 // File contracts/interfaces/IERC721Metadata.sol
381 
382 /**
383  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
384  * @dev See https://eips.ethereum.org/EIPS/eip-721
385  */
386 interface IERC721Metadata is IERC721 {
387     /**
388      * @dev Returns the token collection name.
389      */
390     function name() external view returns (string memory);
391 
392     /**
393      * @dev Returns the token collection symbol.
394      */
395     function symbol() external view returns (string memory);
396 
397     /**
398      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
399      */
400     function tokenURI(uint256 tokenId) external view returns (string memory);
401 }
402 
403 
404 // File contracts/interfaces/IERC721Enumerable.sol
405 
406 /**
407  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
408  * @dev See https://eips.ethereum.org/EIPS/eip-721
409  */
410 interface IERC721Enumerable is IERC721 {
411     /**
412      * @dev Returns the total amount of tokens stored by the contract.
413      */
414     function totalSupply() external view returns (uint256);
415 
416     /**
417      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
418      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
419      */
420     function tokenOfOwnerByIndex(address owner, uint256 index)
421         external
422         view
423         returns (uint256 tokenId);
424 
425     /**
426      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
427      * Use along with {totalSupply} to enumerate all tokens.
428      */
429     function tokenByIndex(uint256 index) external view returns (uint256);
430 }
431 
432 
433 // File contracts/Address.sol
434 
435 
436 pragma solidity 0.8.9;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies on extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         assembly {
466             size := extcodesize(account)
467         }
468         return size > 0;
469     }
470 
471     /**
472      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
473      * `recipient`, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by `transfer`, making them unable to receive funds via
478      * `transfer`. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to `recipient`, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(
489             address(this).balance >= amount,
490             "Address: insufficient balance"
491         );
492 
493         (bool success, ) = recipient.call{value: amount}("");
494         require(
495             success,
496             "Address: unable to send value, recipient may have reverted"
497         );
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data)
519         internal
520         returns (bytes memory)
521     {
522         return functionCall(target, data, "Address: low-level call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
527      * `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal returns (bytes memory) {
536         return functionCallWithValue(target, data, 0, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but also transferring `value` wei to `target`.
542      *
543      * Requirements:
544      *
545      * - the calling contract must have an ETH balance of at least `value`.
546      * - the called Solidity function must be `payable`.
547      *
548      * _Available since v3.1._
549      */
550     function functionCallWithValue(
551         address target,
552         bytes memory data,
553         uint256 value
554     ) internal returns (bytes memory) {
555         return
556             functionCallWithValue(
557                 target,
558                 data,
559                 value,
560                 "Address: low-level call with value failed"
561             );
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(
577             address(this).balance >= value,
578             "Address: insufficient balance for call"
579         );
580         require(isContract(target), "Address: call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.call{value: value}(
583             data
584         );
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data)
595         internal
596         view
597         returns (bytes memory)
598     {
599         return
600             functionStaticCall(
601                 target,
602                 data,
603                 "Address: low-level static call failed"
604             );
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(
614         address target,
615         bytes memory data,
616         string memory errorMessage
617     ) internal view returns (bytes memory) {
618         require(isContract(target), "Address: static call to non-contract");
619 
620         (bool success, bytes memory returndata) = target.staticcall(data);
621         return verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data)
631         internal
632         returns (bytes memory)
633     {
634         return
635             functionDelegateCall(
636                 target,
637                 data,
638                 "Address: low-level delegate call failed"
639             );
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(
649         address target,
650         bytes memory data,
651         string memory errorMessage
652     ) internal returns (bytes memory) {
653         require(isContract(target), "Address: delegate call to non-contract");
654 
655         (bool success, bytes memory returndata) = target.delegatecall(data);
656         return verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
661      * revert reason using the provided one.
662      *
663      * _Available since v4.3._
664      */
665     function verifyCallResult(
666         bool success,
667         bytes memory returndata,
668         string memory errorMessage
669     ) internal pure returns (bytes memory) {
670         if (success) {
671             return returndata;
672         } else {
673             // Look for revert reason and bubble it up if present
674             if (returndata.length > 0) {
675                 // The easiest way to bubble the revert reason is using memory via assembly
676 
677                 assembly {
678                     let returndata_size := mload(returndata)
679                     revert(add(32, returndata), returndata_size)
680                 }
681             } else {
682                 revert(errorMessage);
683             }
684         }
685     }
686 }
687 
688 
689 // File contracts/Strings.sol
690 
691 
692 pragma solidity 0.8.9;
693 
694 /**
695  * @dev String operations.
696  */
697 library Strings {
698     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
699 
700     /**
701      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
702      */
703     function toString(uint256 value) internal pure returns (string memory) {
704         // Inspired by OraclizeAPI's implementation - MIT licence
705         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
706 
707         if (value == 0) {
708             return "0";
709         }
710         uint256 temp = value;
711         uint256 digits;
712         while (temp != 0) {
713             digits++;
714             temp /= 10;
715         }
716         bytes memory buffer = new bytes(digits);
717         while (value != 0) {
718             digits -= 1;
719             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
720             value /= 10;
721         }
722         return string(buffer);
723     }
724 
725     /**
726      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
727      */
728     function toHexString(uint256 value) internal pure returns (string memory) {
729         if (value == 0) {
730             return "0x00";
731         }
732         uint256 temp = value;
733         uint256 length = 0;
734         while (temp != 0) {
735             length++;
736             temp >>= 8;
737         }
738         return toHexString(value, length);
739     }
740 
741     /**
742      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
743      */
744     function toHexString(uint256 value, uint256 length)
745         internal
746         pure
747         returns (string memory)
748     {
749         bytes memory buffer = new bytes(2 * length + 2);
750         buffer[0] = "0";
751         buffer[1] = "x";
752         for (uint256 i = 2 * length + 1; i > 1; --i) {
753             buffer[i] = _HEX_SYMBOLS[value & 0xf];
754             value >>= 4;
755         }
756         require(value == 0, "Strings: hex length insufficient");
757         return string(buffer);
758     }
759 }
760 
761 
762 // File contracts/ERC165.sol
763 
764 
765 pragma solidity 0.8.9;
766 
767 /**
768  * @dev Implementation of the {IERC165} interface.
769  *
770  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
771  * for the additional interface id that will be supported. For example:
772  *
773  * ```solidity
774  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
775  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
776  * }
777  * ```
778  *
779  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
780  */
781 abstract contract ERC165 is IERC165 {
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId)
786         public
787         view
788         virtual
789         override
790         returns (bool)
791     {
792         return interfaceId == type(IERC165).interfaceId;
793     }
794 }
795 
796 
797 // File contracts/ERC721A.sol
798 
799 
800 pragma solidity 0.8.9;
801 
802 
803 
804 
805 
806 
807 
808 
809 /**
810  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
811  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
812  *
813  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
814  *
815  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
816  *
817  * Does not support burning tokens to address(0).
818  */
819 contract ERC721A is
820     Context,
821     ERC165,
822     IERC721,
823     IERC721Metadata,
824     IERC721Enumerable
825 {
826     using Address for address;
827     using Strings for uint256;
828 
829     struct TokenOwnership {
830         address addr;
831         uint64 startTimestamp;
832     }
833 
834     struct AddressData {
835         uint128 balance;
836         uint128 numberMinted;
837     }
838 
839     uint256 private currentIndex = 0;
840 
841     uint256 internal immutable collectionSize;
842     uint256 internal immutable maxBatchSize;
843 
844     // Token name
845     string private _name;
846 
847     // Token symbol
848     string private _symbol;
849 
850     // Mapping from token ID to ownership details
851     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
852     mapping(uint256 => TokenOwnership) private _ownerships;
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
863     /**
864      * @dev
865      * `maxBatchSize` refers to how much a minter can mint at a time.
866      * `collectionSize_` refers to how many tokens are in the collection.
867      */
868     constructor(
869         string memory name_,
870         string memory symbol_,
871         uint256 maxBatchSize_,
872         uint256 collectionSize_
873     ) {
874         require(
875             collectionSize_ > 0,
876             "ERC721A: collection must have a nonzero supply"
877         );
878         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
879         _name = name_;
880         _symbol = symbol_;
881         maxBatchSize = maxBatchSize_;
882         collectionSize = collectionSize_;
883     }
884 
885     /**
886      * @dev See {IERC721Enumerable-totalSupply}.
887      */
888     function totalSupply() public view override returns (uint256) {
889         return currentIndex;
890     }
891 
892     /**
893      * @dev See {IERC721Enumerable-tokenByIndex}.
894      */
895     function tokenByIndex(uint256 index)
896         public
897         view
898         override
899         returns (uint256)
900     {
901         require(index < totalSupply(), "ERC721A: global index out of bounds");
902         return index;
903     }
904 
905     /**
906      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
907      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
908      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
909      */
910     function tokenOfOwnerByIndex(address owner, uint256 index)
911         public
912         view
913         override
914         returns (uint256)
915     {
916         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
917         uint256 numMintedSoFar = totalSupply();
918         uint256 tokenIdsIdx = 0;
919         address currOwnershipAddr = address(0);
920         for (uint256 i = 0; i < numMintedSoFar; i++) {
921             TokenOwnership memory ownership = _ownerships[i];
922             if (ownership.addr != address(0)) {
923                 currOwnershipAddr = ownership.addr;
924             }
925             if (currOwnershipAddr == owner) {
926                 if (tokenIdsIdx == index) {
927                     return i;
928                 }
929                 tokenIdsIdx++;
930             }
931         }
932         revert("ERC721A: unable to get token of owner by index");
933     }
934 
935     /**
936      * @dev See {IERC165-supportsInterface}.
937      */
938     function supportsInterface(bytes4 interfaceId)
939         public
940         view
941         virtual
942         override(ERC165, IERC165)
943         returns (bool)
944     {
945         return
946             interfaceId == type(IERC721).interfaceId ||
947             interfaceId == type(IERC721Metadata).interfaceId ||
948             interfaceId == type(IERC721Enumerable).interfaceId ||
949             super.supportsInterface(interfaceId);
950     }
951 
952     /**
953      * @dev See {IERC721-balanceOf}.
954      */
955     function balanceOf(address owner) public view override returns (uint256) {
956         require(
957             owner != address(0),
958             "ERC721A: balance query for the zero address"
959         );
960         return uint256(_addressData[owner].balance);
961     }
962 
963     function _numberMinted(address owner) internal view returns (uint256) {
964         require(
965             owner != address(0),
966             "ERC721A: number minted query for the zero address"
967         );
968         return uint256(_addressData[owner].numberMinted);
969     }
970 
971     function ownershipOf(uint256 tokenId)
972         internal
973         view
974         returns (TokenOwnership memory)
975     {
976         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
977 
978         uint256 lowestTokenToCheck;
979         if (tokenId >= maxBatchSize) {
980             lowestTokenToCheck = tokenId - maxBatchSize + 1;
981         }
982 
983         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
984             TokenOwnership memory ownership = _ownerships[curr];
985             if (ownership.addr != address(0)) {
986                 return ownership;
987             }
988         }
989 
990         revert("ERC721A: unable to determine the owner of token");
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
1017     function tokenURI(uint256 tokenId)
1018         public
1019         view
1020         virtual
1021         override
1022         returns (string memory)
1023     {
1024         require(
1025             _exists(tokenId),
1026             "ERC721Metadata: URI query for nonexistent token"
1027         );
1028 
1029         string memory baseURI = _baseURI();
1030         return
1031             bytes(baseURI).length > 0
1032                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1033                 : "";
1034     }
1035 
1036     /**
1037      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1038      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1039      * by default, can be overriden in child contracts.
1040      */
1041     function _baseURI() internal view virtual returns (string memory) {
1042         return "";
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-approve}.
1047      */
1048     function approve(address to, uint256 tokenId) public override {
1049         address owner = ERC721A.ownerOf(tokenId);
1050         require(to != owner, "ERC721A: approval to current owner");
1051 
1052         require(
1053             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1054             "ERC721A: approve caller is not owner nor approved for all"
1055         );
1056 
1057         _approve(to, tokenId, owner);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-getApproved}.
1062      */
1063     function getApproved(uint256 tokenId)
1064         public
1065         view
1066         override
1067         returns (address)
1068     {
1069         require(
1070             _exists(tokenId),
1071             "ERC721A: approved query for nonexistent token"
1072         );
1073 
1074         return _tokenApprovals[tokenId];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-setApprovalForAll}.
1079      */
1080     function setApprovalForAll(address operator, bool approved)
1081         public
1082         override
1083     {
1084         require(operator != _msgSender(), "ERC721A: approve to caller");
1085 
1086         _operatorApprovals[_msgSender()][operator] = approved;
1087         emit ApprovalForAll(_msgSender(), operator, approved);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-isApprovedForAll}.
1092      */
1093     function isApprovedForAll(address owner, address operator)
1094         public
1095         view
1096         virtual
1097         override
1098         returns (bool)
1099     {
1100         return _operatorApprovals[owner][operator];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-transferFrom}.
1105      */
1106     function transferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public override {
1111         _transfer(from, to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) public override {
1122         safeTransferFrom(from, to, tokenId, "");
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-safeTransferFrom}.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) public override {
1134         _transfer(from, to, tokenId);
1135         require(
1136             _checkOnERC721Received(from, to, tokenId, _data),
1137             "ERC721A: transfer to non ERC721Receiver implementer"
1138         );
1139     }
1140 
1141     /**
1142      * @dev Returns whether `tokenId` exists.
1143      *
1144      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1145      *
1146      * Tokens start existing when they are minted (`_mint`),
1147      */
1148     function _exists(uint256 tokenId) internal view returns (bool) {
1149         return tokenId < currentIndex;
1150     }
1151 
1152     function _safeMint(address to, uint256 quantity) internal {
1153         _safeMint(to, quantity, "");
1154     }
1155 
1156     /**
1157      * @dev Mints `quantity` tokens and transfers them to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - there must be `quantity` tokens remaining unminted in the total collection.
1162      * - `to` cannot be the zero address.
1163      * - `quantity` cannot be larger than the max batch size.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 quantity,
1170         bytes memory _data
1171     ) internal {
1172         uint256 startTokenId = currentIndex;
1173         require(to != address(0), "ERC721A: mint to the zero address");
1174         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1175         require(!_exists(startTokenId), "ERC721A: token already minted");
1176         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1177 
1178         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1179 
1180         AddressData memory addressData = _addressData[to];
1181         _addressData[to] = AddressData(
1182             addressData.balance + uint128(quantity),
1183             addressData.numberMinted + uint128(quantity)
1184         );
1185         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1186 
1187         uint256 updatedIndex = startTokenId;
1188 
1189         for (uint256 i = 0; i < quantity; i++) {
1190             emit Transfer(address(0), to, updatedIndex);
1191             require(
1192                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1193                 "ERC721A: transfer to non ERC721Receiver implementer"
1194             );
1195             updatedIndex++;
1196         }
1197 
1198         currentIndex = updatedIndex;
1199         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1200     }
1201 
1202     /**
1203      * @dev Transfers `tokenId` from `from` to `to`.
1204      *
1205      * Requirements:
1206      *
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must be owned by `from`.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _transfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) private {
1217         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1218 
1219         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1220             getApproved(tokenId) == _msgSender() ||
1221             isApprovedForAll(prevOwnership.addr, _msgSender()));
1222 
1223         require(
1224             isApprovedOrOwner,
1225             "ERC721A: transfer caller is not owner nor approved"
1226         );
1227 
1228         require(
1229             prevOwnership.addr == from,
1230             "ERC721A: transfer from incorrect owner"
1231         );
1232         require(to != address(0), "ERC721A: transfer to the zero address");
1233 
1234         _beforeTokenTransfers(from, to, tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, prevOwnership.addr);
1238 
1239         _addressData[from].balance -= 1;
1240         _addressData[to].balance += 1;
1241         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1242 
1243         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1244         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1245         uint256 nextTokenId = tokenId + 1;
1246         if (_ownerships[nextTokenId].addr == address(0)) {
1247             if (_exists(nextTokenId)) {
1248                 _ownerships[nextTokenId] = TokenOwnership(
1249                     prevOwnership.addr,
1250                     prevOwnership.startTimestamp
1251                 );
1252             }
1253         }
1254 
1255         emit Transfer(from, to, tokenId);
1256         _afterTokenTransfers(from, to, tokenId, 1);
1257     }
1258 
1259     /**
1260      * @dev Approve `to` to operate on `tokenId`
1261      *
1262      * Emits a {Approval} event.
1263      */
1264     function _approve(
1265         address to,
1266         uint256 tokenId,
1267         address owner
1268     ) private {
1269         _tokenApprovals[tokenId] = to;
1270         emit Approval(owner, to, tokenId);
1271     }
1272 
1273     uint256 public nextOwnerToExplicitlySet = 0;
1274 
1275     /**
1276      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1277      */
1278     function _setOwnersExplicit(uint256 quantity) internal {
1279         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1280         require(quantity > 0, "quantity must be nonzero");
1281         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1282         if (endIndex > collectionSize - 1) {
1283             endIndex = collectionSize - 1;
1284         }
1285         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1286         require(_exists(endIndex), "not enough minted yet for this cleanup");
1287         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1288             if (_ownerships[i].addr == address(0)) {
1289                 TokenOwnership memory ownership = ownershipOf(i);
1290                 _ownerships[i] = TokenOwnership(
1291                     ownership.addr,
1292                     ownership.startTimestamp
1293                 );
1294             }
1295         }
1296         nextOwnerToExplicitlySet = endIndex + 1;
1297     }
1298 
1299     /**
1300      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1301      * The call is not executed if the target address is not a contract.
1302      *
1303      * @param from address representing the previous owner of the given token ID
1304      * @param to target address that will receive the tokens
1305      * @param tokenId uint256 ID of the token to be transferred
1306      * @param _data bytes optional data to send along with the call
1307      * @return bool whether the call correctly returned the expected magic value
1308      */
1309     function _checkOnERC721Received(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) private returns (bool) {
1315         if (to.isContract()) {
1316             try
1317                 IERC721Receiver(to).onERC721Received(
1318                     _msgSender(),
1319                     from,
1320                     tokenId,
1321                     _data
1322                 )
1323             returns (bytes4 retval) {
1324                 return retval == IERC721Receiver(to).onERC721Received.selector;
1325             } catch (bytes memory reason) {
1326                 if (reason.length == 0) {
1327                     revert(
1328                         "ERC721A: transfer to non ERC721Receiver implementer"
1329                     );
1330                 } else {
1331                     assembly {
1332                         revert(add(32, reason), mload(reason))
1333                     }
1334                 }
1335             }
1336         } else {
1337             return true;
1338         }
1339     }
1340 
1341     /**
1342      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1343      *
1344      * startTokenId - the first token id to be transferred
1345      * quantity - the amount to be transferred
1346      *
1347      * Calling conditions:
1348      *
1349      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1350      * transferred to `to`.
1351      * - When `from` is zero, `tokenId` will be minted for `to`.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1362      * minting.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - when `from` and `to` are both non-zero.
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
1380 
1381 // File contracts/ControlledAccess.sol
1382 
1383 
1384 pragma solidity 0.8.9;
1385 
1386 /* @title ControlledAccess
1387  * @dev The ControlledAccess contract allows function to be restricted to users
1388  * that possess a signed authorization from the owner of the contract. This signed
1389  * message includes the user to give permission to and the contract address to prevent
1390  * reusing the same authorization message on different contract with same owner.
1391  */
1392 
1393 contract ControlledAccess is Ownable {
1394     address public signerAddress;
1395 
1396     /*
1397      * @dev Requires msg.sender to have valid access message.
1398      * @param _v ECDSA signature parameter v.
1399      * @param _r ECDSA signature parameters r.
1400      * @param _s ECDSA signature parameters s.
1401      */
1402     modifier onlyValidAccess(
1403         bytes32 _r,
1404         bytes32 _s,
1405         uint8 _v
1406     ) {
1407         require(isValidAccessMessage(msg.sender, _r, _s, _v));
1408         _;
1409     }
1410 
1411     function setSignerAddress(address newAddress) external onlyOwner {
1412         signerAddress = newAddress;
1413     }
1414 
1415     /*
1416      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1417      *      Assumes Geth signature prefix.
1418      * @param _add Address of agent with access
1419      * @param _v ECDSA signature parameter v.
1420      * @param _r ECDSA signature parameters r.
1421      * @param _s ECDSA signature parameters s.
1422      * @return Validity of access message for a given address.
1423      */
1424     function isValidAccessMessage(
1425         address _add,
1426         bytes32 _r,
1427         bytes32 _s,
1428         uint8 _v
1429     ) public view returns (bool) {
1430         bytes32 hash = keccak256(abi.encode(owner(), _add));
1431         bytes32 message = keccak256(
1432             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1433         );
1434         address sig = ecrecover(message, _v, _r, _s);
1435 
1436         require(signerAddress == sig, "Signature does not match");
1437 
1438         return signerAddress == sig;
1439     }
1440 }
1441 
1442 
1443 // File contracts/ASF.sol
1444 
1445 
1446 pragma solidity 0.8.9;
1447 
1448 
1449 
1450 
1451 
1452 contract ASF is ERC721A, Ownable, ReentrancyGuard, ControlledAccess {
1453     using Strings for uint256; 
1454     /** Contract Functionality Variables */
1455     uint256 public constant maxPublicMintPerAddress = 10;
1456     uint256 public constant maxPresaleMintPerAddress = 5;
1457     uint256 public constant mintPrice = 0.042 ether;
1458     uint256 public constant whitelistMintPrice = 0.0169 ether;
1459     bool public publicSaleActive = false;
1460     bool public presaleActive = false;
1461 
1462     /** URI Variables */
1463     bytes32 public uriSuffix = ".json";
1464     string private _baseTokenURI = "";
1465     string public hiddenMetadataUri = "ipfs://QmVJf7dx8h9c7FPBN17LoSzRNNHjdgnvXqUG9KG3y8yT7F/hidden.json";
1466 
1467     /** Constructor - initialize the contract by setting the name, symbol, 
1468         max amount an address can mint, and the total collection size. */
1469     constructor() ERC721A( "Alien Scum Fleet", "ASF", maxPublicMintPerAddress, 6969) {
1470     }
1471 
1472     /** Modifier - ensures the function caller is the user */
1473     modifier callerIsUser() {
1474         require(tx.origin == msg.sender, "Caller is another contract");
1475         _;
1476     }
1477 
1478     /** Modifier - ensures all minting requirements are met, used in both public and presale 
1479         mint functions. Structure allows mintCompliance input values (_quantity, _maxPerAddress 
1480         and _startTime) to be function specific */
1481     modifier mintCompliance(uint256 _quantity, uint256 _maxPerAddress) {
1482         require(totalSupply() + _quantity <= collectionSize, "Max supply reached");
1483         require(_quantity >= 0 && _quantity <= _maxPerAddress, "Invalid mint amount"); 
1484         require(numberMinted(msg.sender) + _quantity <= _maxPerAddress, "Can not mint this many");
1485         _;
1486     }
1487 
1488     /** Public Mint Function */
1489     function mint(uint256 quantity)
1490         external
1491         payable
1492         callerIsUser
1493         nonReentrant
1494         mintCompliance(quantity, maxPublicMintPerAddress) /** Mint Compliance for Public Sale */
1495     {
1496         require(publicSaleActive, "Public sale is not live.");
1497         _safeMint(msg.sender, quantity);
1498         refundIfOver(quantity * mintPrice);
1499     }
1500 
1501     /** Presale Mint Function */
1502     function presaleMint(uint256 quantity, bytes32 _r, bytes32 _s, uint8 _v)
1503         external
1504         payable
1505         callerIsUser
1506         onlyValidAccess(_r, _s, _v) /** Whitelist */
1507         nonReentrant 
1508         mintCompliance(quantity, maxPresaleMintPerAddress) /** Mint Compliance for Presale */
1509     {
1510         require(presaleActive, "Presale is not live.");
1511         _safeMint(msg.sender, quantity);
1512         refundIfOver(quantity * whitelistMintPrice);
1513     }
1514 
1515     /** Metadata URI */
1516     function _baseURI() internal view virtual override returns (string memory) {
1517         return _baseTokenURI;
1518     }
1519 
1520     /** Total number of NFTs minted from the contract for a given address. Value can only increase and
1521         does not depend on how many NFTs are in your wallet */
1522     function numberMinted(address owner) public view returns (uint256) {
1523         return _numberMinted(owner);
1524     }
1525 
1526     /** Get the owner of a specific token from the tokenId */
1527     function getOwnershipData(uint256 tokenId)
1528         external
1529         view
1530         returns (TokenOwnership memory)
1531     {
1532         return ownershipOf(tokenId);
1533     }
1534 
1535     /**  Refund function which requires the minimum amount for the transaction and returns any extra payment to the sender */
1536     function refundIfOver(uint256 price) private {
1537         require(msg.value >= price, "Need to send more eth");
1538         if (msg.value > price) {
1539             payable(msg.sender).transfer(msg.value - price);
1540         }
1541     }
1542 
1543     /**  Standard TokenURI ERC721A function modified to return hidden metadata
1544          URI until the contract is revealed. */
1545     function tokenURI(uint256 _tokenId)
1546         public
1547         view
1548         virtual
1549         override
1550         returns (string memory)
1551     {
1552         require(_exists(_tokenId), "Nonexistent token!");
1553 
1554         if (keccak256(abi.encodePacked(_baseTokenURI)) == keccak256(abi.encodePacked(""))) {
1555             return hiddenMetadataUri;
1556         }
1557 
1558         return
1559             bytes(_baseTokenURI).length > 0
1560                 ? string(
1561                     abi.encodePacked(_baseTokenURI, _tokenId.toString(), uriSuffix)
1562                 )
1563                 : "";
1564     }
1565 
1566 /// OWNER FUNCTIONS ///
1567 
1568     /** Standard withdraw function for the owner to pull the contract */
1569     function withdraw() external onlyOwner nonReentrant {
1570         uint256 sendAmount = address(this).balance;
1571 
1572         address lawi = payable(0xdC2719e36B1028Ad840B21Cd08D4F395c09A7015); 
1573         address bunzo = payable(0x987F613dD3460bDCEd24Eeebfe13dE9Bf9D8d2B8); 
1574         address robatic = payable(0xDd730Aa1583396214Aa2D92Cfa92880b9d93E201); 
1575         address lashes = payable(0x141cA54Db6F8277917e0554b30F2B3270F65EB67); 
1576         address willy = payable(0x4Bd3BB6B1D03c8844476e525fF291627FbC3c0eA); 
1577         address yeti = payable(0x66c17Dcef1B364014573Ae0F869ad1c05fe01c89); 
1578         address dale = payable(0x64e293dd4BBA0756895cdB8FE3a2f8E2f4AD4071); 
1579         address marv = payable(0xEcf02b27e4f6Ff7E3C609652DE4B37F65A74d86B); 
1580         address community = payable(0xA868Ce0B203031B2E72330e8512c8729770c0759); 
1581 
1582         bool success;
1583         (success, ) = lawi.call{value: ((sendAmount * 1575) / 10000)}("");
1584         require(success, "Transaction unsuccessful");
1585         (success, ) = bunzo.call{value: ((sendAmount * 1575) / 10000)}("");
1586         require(success, "Transaction unsuccessful");
1587         (success, ) = robatic.call{value: ((sendAmount * 1575) / 10000)}("");
1588         require(success, "Transaction unsuccessful");
1589         (success, ) = lashes.call{value: ((sendAmount * 1575) / 10000)}("");
1590         require(success, "Transaction unsuccessful");
1591         (success, ) = willy.call{value: ((sendAmount * 3) / 100)}("");
1592         require(success, "Transaction unsuccessful");
1593         (success, ) = yeti.call{value: ((sendAmount * 12) / 100)}("");
1594         require(success, "Transaction unsuccessful");
1595         (success, ) = dale.call{value: ((sendAmount * 1) / 100)}("");
1596         require(success, "Transaction unsuccessful");
1597         (success, ) = marv.call{value: ((sendAmount * 1) / 100)}("");
1598         require(success, "Transaction unsuccessful");
1599         (success, ) = community.call{value: ((sendAmount * 20) / 100)}("");
1600         require(success, "Transaction unsuccessful");
1601     }
1602 
1603     /** Mint Function only usable by contract owner. Use reserved for giveaways and promotions. */
1604     function ownerMint(address to, uint256 quantity) public callerIsUser onlyOwner {
1605         require(quantity + totalSupply() <= collectionSize, 'Max supply reached');
1606         _safeMint(to, quantity);
1607     }
1608 
1609     /** Function for updating the revealed token metadata URI. When setting this value,
1610         only replace _CID_ in the following:  ipfs://_CID_/                          */
1611     function setBaseURI(string memory baseURI) public onlyOwner {
1612         _baseTokenURI = baseURI;
1613     }
1614 
1615     /** Initialized in constructor - Hidden metadata value pointing to unrevealed token URI. */
1616     function setHiddenMetadataURI(string memory _hiddenMetadataURI) public onlyOwner {
1617         hiddenMetadataUri = _hiddenMetadataURI;
1618     }
1619 
1620     function togglePresaleActive() public onlyOwner {
1621         presaleActive = !presaleActive;
1622     }
1623 
1624     function togglePublicSaleActive() public onlyOwner {
1625         publicSaleActive = !publicSaleActive;
1626     }
1627 
1628    /** adding onlyOwner and nonReentrant modifiers to ERC721A setOwnersExplicit for enhanced security */
1629     function setOwnersExplicit(uint256 quantity)
1630         external
1631         onlyOwner
1632         nonReentrant
1633     {
1634         _setOwnersExplicit(quantity);
1635     }
1636 
1637 }