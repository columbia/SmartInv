1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
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
174 
175 pragma solidity 0.8.9;
176 
177 /**
178  * @dev Interface of the ERC165 standard, as defined in the
179  * https://eips.ethereum.org/EIPS/eip-165[EIP].
180  *
181  * Implementers can declare support of contract interfaces, which can then be
182  * queried by others ({ERC165Checker}).
183  *
184  * For an implementation, see {ERC165}.
185  */
186 interface IERC165 {
187     /**
188      * @dev Returns true if this contract implements the interface defined by
189      * `interfaceId`. See the corresponding
190      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
191      * to learn more about how these ids are created.
192      *
193      * This function call must use less than 30 000 gas.
194      */
195     function supportsInterface(bytes4 interfaceId) external view returns (bool);
196 }
197 
198 
199 // File contracts/interfaces/IERC721.sol
200 
201 
202 pragma solidity 0.8.9;
203 
204 /**
205  * @dev Required interface of an ERC721 compliant contract.
206  */
207 interface IERC721 is IERC165 {
208     /**
209      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
210      */
211     event Transfer(
212         address indexed from,
213         address indexed to,
214         uint256 indexed tokenId
215     );
216 
217     /**
218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
219      */
220     event Approval(
221         address indexed owner,
222         address indexed approved,
223         uint256 indexed tokenId
224     );
225 
226     /**
227      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
228      */
229     event ApprovalForAll(
230         address indexed owner,
231         address indexed operator,
232         bool approved
233     );
234 
235     /**
236      * @dev Returns the number of tokens in ``owner``'s account.
237      */
238     function balanceOf(address owner) external view returns (uint256 balance);
239 
240     /**
241      * @dev Returns the owner of the `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function ownerOf(uint256 tokenId) external view returns (address owner);
248 
249     /**
250      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
251      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId
267     ) external;
268 
269     /**
270      * @dev Transfers `tokenId` token from `from` to `to`.
271      *
272      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must be owned by `from`.
279      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external;
288 
289     /**
290      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
291      * The approval is cleared when the token is transferred.
292      *
293      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
294      *
295      * Requirements:
296      *
297      * - The caller must own the token or be an approved operator.
298      * - `tokenId` must exist.
299      *
300      * Emits an {Approval} event.
301      */
302     function approve(address to, uint256 tokenId) external;
303 
304     /**
305      * @dev Returns the account approved for `tokenId` token.
306      *
307      * Requirements:
308      *
309      * - `tokenId` must exist.
310      */
311     function getApproved(uint256 tokenId)
312         external
313         view
314         returns (address operator);
315 
316     /**
317      * @dev Approve or remove `operator` as an operator for the caller.
318      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
319      *
320      * Requirements:
321      *
322      * - The `operator` cannot be the caller.
323      *
324      * Emits an {ApprovalForAll} event.
325      */
326     function setApprovalForAll(address operator, bool _approved) external;
327 
328     /**
329      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
330      *
331      * See {setApprovalForAll}
332      */
333     function isApprovedForAll(address owner, address operator)
334         external
335         view
336         returns (bool);
337 
338     /**
339      * @dev Safely transfers `tokenId` token from `from` to `to`.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
348      *
349      * Emits a {Transfer} event.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 }
358 
359 
360 // File contracts/interfaces/IERC721Receiver.sol
361 
362 
363 pragma solidity 0.8.9;
364 
365 /**
366  * @title ERC721 token receiver interface
367  * @dev Interface for any contract that wants to support safeTransfers
368  * from ERC721 asset contracts.
369  */
370 interface IERC721Receiver {
371     /**
372      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
373      * by `operator` from `from`, this function is called.
374      *
375      * It must return its Solidity selector to confirm the token transfer.
376      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
377      *
378      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
379      */
380     function onERC721Received(
381         address operator,
382         address from,
383         uint256 tokenId,
384         bytes calldata data
385     ) external returns (bytes4);
386 }
387 
388 
389 // File contracts/interfaces/IERC721Metadata.sol
390 
391 
392 pragma solidity 0.8.9;
393 
394 /**
395  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
396  * @dev See https://eips.ethereum.org/EIPS/eip-721
397  */
398 interface IERC721Metadata is IERC721 {
399     /**
400      * @dev Returns the token collection name.
401      */
402     function name() external view returns (string memory);
403 
404     /**
405      * @dev Returns the token collection symbol.
406      */
407     function symbol() external view returns (string memory);
408 
409     /**
410      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
411      */
412     function tokenURI(uint256 tokenId) external view returns (string memory);
413 }
414 
415 
416 // File contracts/interfaces/IERC721Enumerable.sol
417 
418 
419 pragma solidity 0.8.9;
420 
421 /**
422  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
423  * @dev See https://eips.ethereum.org/EIPS/eip-721
424  */
425 interface IERC721Enumerable is IERC721 {
426     /**
427      * @dev Returns the total amount of tokens stored by the contract.
428      */
429     function totalSupply() external view returns (uint256);
430 
431     /**
432      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
433      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
434      */
435     function tokenOfOwnerByIndex(address owner, uint256 index)
436         external
437         view
438         returns (uint256 tokenId);
439 
440     /**
441      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
442      * Use along with {totalSupply} to enumerate all tokens.
443      */
444     function tokenByIndex(uint256 index) external view returns (uint256);
445 }
446 
447 
448 // File contracts/Address.sol
449 
450 
451 pragma solidity 0.8.9;
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * [IMPORTANT]
461      * ====
462      * It is unsafe to assume that an address for which this function returns
463      * false is an externally-owned account (EOA) and not a contract.
464      *
465      * Among others, `isContract` will return false for the following
466      * types of addresses:
467      *
468      *  - an externally-owned account
469      *  - a contract in construction
470      *  - an address where a contract will be created
471      *  - an address where a contract lived, but was destroyed
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize, which returns 0 for contracts in
476         // construction, since the code is only stored at the end of the
477         // constructor execution.
478 
479         uint256 size;
480         assembly {
481             size := extcodesize(account)
482         }
483         return size > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(
504             address(this).balance >= amount,
505             "Address: insufficient balance"
506         );
507 
508         (bool success, ) = recipient.call{value: amount}("");
509         require(
510             success,
511             "Address: unable to send value, recipient may have reverted"
512         );
513     }
514 
515     /**
516      * @dev Performs a Solidity function call using a low level `call`. A
517      * plain `call` is an unsafe replacement for a function call: use this
518      * function instead.
519      *
520      * If `target` reverts with a revert reason, it is bubbled up by this
521      * function (like regular Solidity function calls).
522      *
523      * Returns the raw returned data. To convert to the expected return value,
524      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
525      *
526      * Requirements:
527      *
528      * - `target` must be a contract.
529      * - calling `target` with `data` must not revert.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(address target, bytes memory data)
534         internal
535         returns (bytes memory)
536     {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return
571             functionCallWithValue(
572                 target,
573                 data,
574                 value,
575                 "Address: low-level call with value failed"
576             );
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
581      * with `errorMessage` as a fallback revert reason when `target` reverts.
582      *
583      * _Available since v3.1._
584      */
585     function functionCallWithValue(
586         address target,
587         bytes memory data,
588         uint256 value,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         require(
592             address(this).balance >= value,
593             "Address: insufficient balance for call"
594         );
595         require(isContract(target), "Address: call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.call{value: value}(
598             data
599         );
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(address target, bytes memory data)
610         internal
611         view
612         returns (bytes memory)
613     {
614         return
615             functionStaticCall(
616                 target,
617                 data,
618                 "Address: low-level static call failed"
619             );
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
624      * but performing a static call.
625      *
626      * _Available since v3.3._
627      */
628     function functionStaticCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal view returns (bytes memory) {
633         require(isContract(target), "Address: static call to non-contract");
634 
635         (bool success, bytes memory returndata) = target.staticcall(data);
636         return verifyCallResult(success, returndata, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but performing a delegate call.
642      *
643      * _Available since v3.4._
644      */
645     function functionDelegateCall(address target, bytes memory data)
646         internal
647         returns (bytes memory)
648     {
649         return
650             functionDelegateCall(
651                 target,
652                 data,
653                 "Address: low-level delegate call failed"
654             );
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a delegate call.
660      *
661      * _Available since v3.4._
662      */
663     function functionDelegateCall(
664         address target,
665         bytes memory data,
666         string memory errorMessage
667     ) internal returns (bytes memory) {
668         require(isContract(target), "Address: delegate call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.delegatecall(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
676      * revert reason using the provided one.
677      *
678      * _Available since v4.3._
679      */
680     function verifyCallResult(
681         bool success,
682         bytes memory returndata,
683         string memory errorMessage
684     ) internal pure returns (bytes memory) {
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 assembly {
693                     let returndata_size := mload(returndata)
694                     revert(add(32, returndata), returndata_size)
695                 }
696             } else {
697                 revert(errorMessage);
698             }
699         }
700     }
701 }
702 
703 
704 // File contracts/Strings.sol
705 
706 
707 pragma solidity 0.8.9;
708 
709 /**
710  * @dev String operations.
711  */
712 library Strings {
713     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
714 
715     /**
716      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
717      */
718     function toString(uint256 value) internal pure returns (string memory) {
719         // Inspired by OraclizeAPI's implementation - MIT licence
720         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
721 
722         if (value == 0) {
723             return "0";
724         }
725         uint256 temp = value;
726         uint256 digits;
727         while (temp != 0) {
728             digits++;
729             temp /= 10;
730         }
731         bytes memory buffer = new bytes(digits);
732         while (value != 0) {
733             digits -= 1;
734             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
735             value /= 10;
736         }
737         return string(buffer);
738     }
739 
740     /**
741      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
742      */
743     function toHexString(uint256 value) internal pure returns (string memory) {
744         if (value == 0) {
745             return "0x00";
746         }
747         uint256 temp = value;
748         uint256 length = 0;
749         while (temp != 0) {
750             length++;
751             temp >>= 8;
752         }
753         return toHexString(value, length);
754     }
755 
756     /**
757      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
758      */
759     function toHexString(uint256 value, uint256 length)
760         internal
761         pure
762         returns (string memory)
763     {
764         bytes memory buffer = new bytes(2 * length + 2);
765         buffer[0] = "0";
766         buffer[1] = "x";
767         for (uint256 i = 2 * length + 1; i > 1; --i) {
768             buffer[i] = _HEX_SYMBOLS[value & 0xf];
769             value >>= 4;
770         }
771         require(value == 0, "Strings: hex length insufficient");
772         return string(buffer);
773     }
774 }
775 
776 
777 // File contracts/ERC165.sol
778 
779 
780 pragma solidity 0.8.9;
781 
782 /**
783  * @dev Implementation of the {IERC165} interface.
784  *
785  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
786  * for the additional interface id that will be supported. For example:
787  *
788  * ```solidity
789  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
791  * }
792  * ```
793  *
794  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
795  */
796 abstract contract ERC165 is IERC165 {
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId)
801         public
802         view
803         virtual
804         override
805         returns (bool)
806     {
807         return interfaceId == type(IERC165).interfaceId;
808     }
809 }
810 
811 
812 // File contracts/ERC721A.sol
813 
814 
815 pragma solidity 0.8.9;
816 
817 
818 
819 
820 
821 
822 
823 
824 /**
825  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
826  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
827  *
828  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
829  *
830  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
831  *
832  * Does not support burning tokens to address(0).
833  */
834 contract ERC721A is
835     Context,
836     ERC165,
837     IERC721,
838     IERC721Metadata,
839     IERC721Enumerable
840 {
841     using Address for address;
842     using Strings for uint256;
843 
844     struct TokenOwnership {
845         address addr;
846         uint64 startTimestamp;
847     }
848 
849     struct AddressData {
850         uint128 balance;
851         uint128 numberMinted;
852     }
853 
854     uint256 private currentIndex = 0;
855 
856     uint256 internal immutable collectionSize;
857     uint256 internal immutable maxBatchSize;
858 
859     // Token name
860     string private _name;
861 
862     // Token symbol
863     string private _symbol;
864 
865     // Mapping from token ID to ownership details
866     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
867     mapping(uint256 => TokenOwnership) private _ownerships;
868 
869     // Mapping owner address to address data
870     mapping(address => AddressData) private _addressData;
871 
872     // Mapping from token ID to approved address
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     /**
879      * @dev
880      * `maxBatchSize` refers to how much a minter can mint at a time.
881      * `collectionSize_` refers to how many tokens are in the collection.
882      */
883     constructor(
884         string memory name_,
885         string memory symbol_,
886         uint256 maxBatchSize_,
887         uint256 collectionSize_
888     ) {
889         require(
890             collectionSize_ > 0,
891             "ERC721A: collection must have a nonzero supply"
892         );
893         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
894         _name = name_;
895         _symbol = symbol_;
896         maxBatchSize = maxBatchSize_;
897         collectionSize = collectionSize_;
898     }
899 
900     /**
901      * @dev See {IERC721Enumerable-totalSupply}.
902      */
903     function totalSupply() public view override returns (uint256) {
904         return currentIndex;
905     }
906 
907     /**
908      * @dev See {IERC721Enumerable-tokenByIndex}.
909      */
910     function tokenByIndex(uint256 index)
911         public
912         view
913         override
914         returns (uint256)
915     {
916         require(index < totalSupply(), "ERC721A: global index out of bounds");
917         return index;
918     }
919 
920     /**
921      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
922      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
923      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
924      */
925     function tokenOfOwnerByIndex(address owner, uint256 index)
926         public
927         view
928         override
929         returns (uint256)
930     {
931         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
932         uint256 numMintedSoFar = totalSupply();
933         uint256 tokenIdsIdx = 0;
934         address currOwnershipAddr = address(0);
935         for (uint256 i = 0; i < numMintedSoFar; i++) {
936             TokenOwnership memory ownership = _ownerships[i];
937             if (ownership.addr != address(0)) {
938                 currOwnershipAddr = ownership.addr;
939             }
940             if (currOwnershipAddr == owner) {
941                 if (tokenIdsIdx == index) {
942                     return i;
943                 }
944                 tokenIdsIdx++;
945             }
946         }
947         revert("ERC721A: unable to get token of owner by index");
948     }
949 
950     /**
951      * @dev See {IERC165-supportsInterface}.
952      */
953     function supportsInterface(bytes4 interfaceId)
954         public
955         view
956         virtual
957         override(ERC165, IERC165)
958         returns (bool)
959     {
960         return
961             interfaceId == type(IERC721).interfaceId ||
962             interfaceId == type(IERC721Metadata).interfaceId ||
963             interfaceId == type(IERC721Enumerable).interfaceId ||
964             super.supportsInterface(interfaceId);
965     }
966 
967     /**
968      * @dev See {IERC721-balanceOf}.
969      */
970     function balanceOf(address owner) public view override returns (uint256) {
971         require(
972             owner != address(0),
973             "ERC721A: balance query for the zero address"
974         );
975         return uint256(_addressData[owner].balance);
976     }
977 
978     function _numberMinted(address owner) internal view returns (uint256) {
979         require(
980             owner != address(0),
981             "ERC721A: number minted query for the zero address"
982         );
983         return uint256(_addressData[owner].numberMinted);
984     }
985 
986     function ownershipOf(uint256 tokenId)
987         internal
988         view
989         returns (TokenOwnership memory)
990     {
991         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
992 
993         uint256 lowestTokenToCheck;
994         if (tokenId >= maxBatchSize) {
995             lowestTokenToCheck = tokenId - maxBatchSize + 1;
996         }
997 
998         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
999             TokenOwnership memory ownership = _ownerships[curr];
1000             if (ownership.addr != address(0)) {
1001                 return ownership;
1002             }
1003         }
1004 
1005         revert("ERC721A: unable to determine the owner of token");
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view override returns (address) {
1012         return ownershipOf(tokenId).addr;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-name}.
1017      */
1018     function name() public view virtual override returns (string memory) {
1019         return _name;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-symbol}.
1024      */
1025     function symbol() public view virtual override returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-tokenURI}.
1031      */
1032     function tokenURI(uint256 tokenId)
1033         public
1034         view
1035         virtual
1036         override
1037         returns (string memory)
1038     {
1039         require(
1040             _exists(tokenId),
1041             "ERC721Metadata: URI query for nonexistent token"
1042         );
1043 
1044         string memory baseURI = _baseURI();
1045         return
1046             bytes(baseURI).length > 0
1047                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1048                 : "";
1049     }
1050 
1051     /**
1052      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1053      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1054      * by default, can be overriden in child contracts.
1055      */
1056     function _baseURI() internal view virtual returns (string memory) {
1057         return "";
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-approve}.
1062      */
1063     function approve(address to, uint256 tokenId) public override {
1064         address owner = ERC721A.ownerOf(tokenId);
1065         require(to != owner, "ERC721A: approval to current owner");
1066 
1067         require(
1068             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1069             "ERC721A: approve caller is not owner nor approved for all"
1070         );
1071 
1072         _approve(to, tokenId, owner);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-getApproved}.
1077      */
1078     function getApproved(uint256 tokenId)
1079         public
1080         view
1081         override
1082         returns (address)
1083     {
1084         require(
1085             _exists(tokenId),
1086             "ERC721A: approved query for nonexistent token"
1087         );
1088 
1089         return _tokenApprovals[tokenId];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-setApprovalForAll}.
1094      */
1095     function setApprovalForAll(address operator, bool approved)
1096         public
1097         override
1098     {
1099         require(operator != _msgSender(), "ERC721A: approve to caller");
1100 
1101         _operatorApprovals[_msgSender()][operator] = approved;
1102         emit ApprovalForAll(_msgSender(), operator, approved);
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-isApprovedForAll}.
1107      */
1108     function isApprovedForAll(address owner, address operator)
1109         public
1110         view
1111         virtual
1112         override
1113         returns (bool)
1114     {
1115         return _operatorApprovals[owner][operator];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-transferFrom}.
1120      */
1121     function transferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public override {
1126         _transfer(from, to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-safeTransferFrom}.
1131      */
1132     function safeTransferFrom(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) public override {
1137         safeTransferFrom(from, to, tokenId, "");
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-safeTransferFrom}.
1142      */
1143     function safeTransferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) public override {
1149         _transfer(from, to, tokenId);
1150         require(
1151             _checkOnERC721Received(from, to, tokenId, _data),
1152             "ERC721A: transfer to non ERC721Receiver implementer"
1153         );
1154     }
1155 
1156     /**
1157      * @dev Returns whether `tokenId` exists.
1158      *
1159      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1160      *
1161      * Tokens start existing when they are minted (`_mint`),
1162      */
1163     function _exists(uint256 tokenId) internal view returns (bool) {
1164         return tokenId < currentIndex;
1165     }
1166 
1167     function _safeMint(address to, uint256 quantity) internal {
1168         _safeMint(to, quantity, "");
1169     }
1170 
1171     /**
1172      * @dev Mints `quantity` tokens and transfers them to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - there must be `quantity` tokens remaining unminted in the total collection.
1177      * - `to` cannot be the zero address.
1178      * - `quantity` cannot be larger than the max batch size.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _safeMint(
1183         address to,
1184         uint256 quantity,
1185         bytes memory _data
1186     ) internal {
1187         uint256 startTokenId = currentIndex;
1188         require(to != address(0), "ERC721A: mint to the zero address");
1189         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1190         require(!_exists(startTokenId), "ERC721A: token already minted");
1191         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1192 
1193         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1194 
1195         AddressData memory addressData = _addressData[to];
1196         _addressData[to] = AddressData(
1197             addressData.balance + uint128(quantity),
1198             addressData.numberMinted + uint128(quantity)
1199         );
1200         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1201 
1202         uint256 updatedIndex = startTokenId;
1203 
1204         for (uint256 i = 0; i < quantity; i++) {
1205             emit Transfer(address(0), to, updatedIndex);
1206             require(
1207                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1208                 "ERC721A: transfer to non ERC721Receiver implementer"
1209             );
1210             updatedIndex++;
1211         }
1212 
1213         currentIndex = updatedIndex;
1214         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1215     }
1216 
1217     /**
1218      * @dev Transfers `tokenId` from `from` to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `tokenId` token must be owned by `from`.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _transfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) private {
1232         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1233 
1234         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1235             getApproved(tokenId) == _msgSender() ||
1236             isApprovedForAll(prevOwnership.addr, _msgSender()));
1237 
1238         require(
1239             isApprovedOrOwner,
1240             "ERC721A: transfer caller is not owner nor approved"
1241         );
1242 
1243         require(
1244             prevOwnership.addr == from,
1245             "ERC721A: transfer from incorrect owner"
1246         );
1247         require(to != address(0), "ERC721A: transfer to the zero address");
1248 
1249         _beforeTokenTransfers(from, to, tokenId, 1);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId, prevOwnership.addr);
1253 
1254         _addressData[from].balance -= 1;
1255         _addressData[to].balance += 1;
1256         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1257 
1258         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1259         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1260         uint256 nextTokenId = tokenId + 1;
1261         if (_ownerships[nextTokenId].addr == address(0)) {
1262             if (_exists(nextTokenId)) {
1263                 _ownerships[nextTokenId] = TokenOwnership(
1264                     prevOwnership.addr,
1265                     prevOwnership.startTimestamp
1266                 );
1267             }
1268         }
1269 
1270         emit Transfer(from, to, tokenId);
1271         _afterTokenTransfers(from, to, tokenId, 1);
1272     }
1273 
1274     /**
1275      * @dev Approve `to` to operate on `tokenId`
1276      *
1277      * Emits a {Approval} event.
1278      */
1279     function _approve(
1280         address to,
1281         uint256 tokenId,
1282         address owner
1283     ) private {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(owner, to, tokenId);
1286     }
1287 
1288     uint256 public nextOwnerToExplicitlySet = 0;
1289 
1290     /**
1291      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1292      */
1293     function _setOwnersExplicit(uint256 quantity) internal {
1294         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1295         require(quantity > 0, "quantity must be nonzero");
1296         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1297         if (endIndex > collectionSize - 1) {
1298             endIndex = collectionSize - 1;
1299         }
1300         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1301         require(_exists(endIndex), "not enough minted yet for this cleanup");
1302         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1303             if (_ownerships[i].addr == address(0)) {
1304                 TokenOwnership memory ownership = ownershipOf(i);
1305                 _ownerships[i] = TokenOwnership(
1306                     ownership.addr,
1307                     ownership.startTimestamp
1308                 );
1309             }
1310         }
1311         nextOwnerToExplicitlySet = endIndex + 1;
1312     }
1313 
1314     /**
1315      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1316      * The call is not executed if the target address is not a contract.
1317      *
1318      * @param from address representing the previous owner of the given token ID
1319      * @param to target address that will receive the tokens
1320      * @param tokenId uint256 ID of the token to be transferred
1321      * @param _data bytes optional data to send along with the call
1322      * @return bool whether the call correctly returned the expected magic value
1323      */
1324     function _checkOnERC721Received(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) private returns (bool) {
1330         if (to.isContract()) {
1331             try
1332                 IERC721Receiver(to).onERC721Received(
1333                     _msgSender(),
1334                     from,
1335                     tokenId,
1336                     _data
1337                 )
1338             returns (bytes4 retval) {
1339                 return retval == IERC721Receiver(to).onERC721Received.selector;
1340             } catch (bytes memory reason) {
1341                 if (reason.length == 0) {
1342                     revert(
1343                         "ERC721A: transfer to non ERC721Receiver implementer"
1344                     );
1345                 } else {
1346                     assembly {
1347                         revert(add(32, reason), mload(reason))
1348                     }
1349                 }
1350             }
1351         } else {
1352             return true;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` will be minted for `to`.
1367      */
1368     function _beforeTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 
1375     /**
1376      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1377      * minting.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - when `from` and `to` are both non-zero.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 }
1394 
1395 
1396 // File contracts/ControlledAccess.sol
1397 
1398 
1399 pragma solidity 0.8.9;
1400 
1401 /* @title ControlledAccess
1402  * @dev The ControlledAccess contract allows function to be restricted to users
1403  * that possess a signed authorization from the owner of the contract. This signed
1404  * message includes the user to give permission to and the contract address to prevent
1405  * reusing the same authorization message on different contract with same owner.
1406  */
1407 
1408 contract ControlledAccess is Ownable {
1409     address public signerAddress;
1410 
1411     /*
1412      * @dev Requires msg.sender to have valid access message.
1413      * @param _v ECDSA signature parameter v.
1414      * @param _r ECDSA signature parameters r.
1415      * @param _s ECDSA signature parameters s.
1416      */
1417     modifier onlyValidAccess(
1418         bytes32 _r,
1419         bytes32 _s,
1420         uint8 _v
1421     ) {
1422         require(isValidAccessMessage(msg.sender, _r, _s, _v));
1423         _;
1424     }
1425 
1426     function setSignerAddress(address newAddress) external onlyOwner {
1427         signerAddress = newAddress;
1428     }
1429 
1430     /*
1431      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1432      *      Assumes Geth signature prefix.
1433      * @param _add Address of agent with access
1434      * @param _v ECDSA signature parameter v.
1435      * @param _r ECDSA signature parameters r.
1436      * @param _s ECDSA signature parameters s.
1437      * @return Validity of access message for a given address.
1438      */
1439     function isValidAccessMessage(
1440         address _add,
1441         bytes32 _r,
1442         bytes32 _s,
1443         uint8 _v
1444     ) public view returns (bool) {
1445         bytes32 hash = keccak256(abi.encode(owner(), _add));
1446         bytes32 message = keccak256(
1447             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1448         );
1449         address sig = ecrecover(message, _v, _r, _s);
1450 
1451         require(signerAddress == sig, "Signature does not match");
1452 
1453         return signerAddress == sig;
1454     }
1455 }
1456 
1457 
1458 // File contracts/KangarooCountryClub.sol
1459 
1460 
1461 pragma solidity 0.8.9;
1462 
1463 
1464 
1465 
1466 
1467 contract KangarooCountryClub is ERC721A, Ownable, ReentrancyGuard, ControlledAccess {
1468     using Strings for uint256; 
1469     /** Variables initialized in the constructor */
1470     uint256 public immutable maxPublicMintPerAddress;
1471     uint256 public immutable maxPresaleMintPerAddress;
1472     
1473     /** URI Variables */
1474     bytes32 public uriSuffix = ".json";
1475     string private _baseTokenURI = "";
1476     string public hiddenMetadataUri;
1477 
1478     /** Contract Functionality Variables */
1479     uint256 public constant mintPrice = 0.04 ether;
1480     uint256 public constant whitelistMintPrice = 0.03 ether;
1481     bool public publicSaleActive = false;
1482     bool public presaleActive = false;
1483 
1484     /** Constructor - initialize the contract by setting the name, symbol, 
1485         max amount an address can mint, and the total collection size. */
1486     constructor(
1487         uint256 maxBatchSize_, 
1488         uint256 maxPresaleBatchSize_, 
1489         uint256 collectionSize_
1490         )
1491         ERC721A( "Kangaroo Country Club", "KCC", maxBatchSize_, collectionSize_)
1492     {
1493         maxPublicMintPerAddress = maxBatchSize_;
1494         maxPresaleMintPerAddress = maxPresaleBatchSize_;
1495         setHiddenMetadataURI("ipfs://__CID__/hidden.json");
1496     }
1497     /** Modifier - ensures the function caller is the user */
1498     modifier callerIsUser() {
1499         require(tx.origin == msg.sender, "Caller is another contract");
1500         _;
1501     }
1502     /** Modifier - ensures all minting requirements are met, used in both public and presale 
1503         mint functions. Structure allows mintCompliance input values (_quantity, _maxPerAddress 
1504         and _startTime) to be function specific */
1505     modifier mintCompliance(uint256 _quantity, uint256 _maxPerAddress) {
1506         require(totalSupply() + _quantity <= collectionSize, "Max supply reached");
1507         require(_quantity >= 0 && _quantity <= _maxPerAddress, "Invalid mint amount"); 
1508         require(numberMinted(msg.sender) + _quantity <= _maxPerAddress, "Can not mint this many");
1509         _;
1510     }
1511     /** Public Mint Function */
1512     function mint(uint256 quantity)
1513         external
1514         payable
1515         callerIsUser
1516         nonReentrant
1517         mintCompliance(quantity, maxPublicMintPerAddress) /** Mint Complaince for Public Sale */
1518     {
1519         require(publicSaleActive, "Public sale is not live.");
1520         _safeMint(msg.sender, quantity);
1521         refundIfOver(quantity * mintPrice);
1522     }
1523     /** Presale Mint Function */
1524     function presaleMint(uint256 quantity, bytes32 _r, bytes32 _s, uint8 _v)
1525         external
1526         payable
1527         callerIsUser
1528         onlyValidAccess(_r, _s, _v) /** Whitelist */
1529         nonReentrant 
1530         mintCompliance(quantity, maxPresaleMintPerAddress) /** Mint Compliance for Presale */
1531     {
1532         require(presaleActive, "Presale is not live.");
1533         _safeMint(msg.sender, quantity);
1534         refundIfOver(quantity * whitelistMintPrice);
1535     }
1536 
1537     /** Metadata URI */
1538     function _baseURI() internal view virtual override returns (string memory) {
1539         return _baseTokenURI;
1540     }
1541 
1542     /** Total number of NFTs minted from the contract for a given address. Value can only increase and
1543         does not depend on how many NFTs are in your wallet */
1544     function numberMinted(address owner) public view returns (uint256) {
1545         return _numberMinted(owner);
1546     }
1547 
1548     /** Get the owner of a specific token from the tokenId */
1549     function getOwnershipData(uint256 tokenId)
1550         external
1551         view
1552         returns (TokenOwnership memory)
1553     {
1554         return ownershipOf(tokenId);
1555     }
1556 
1557     /**  Refund function which requires the minimum amount for the transaction and returns any extra payment to the sender */
1558     function refundIfOver(uint256 price) private {
1559         require(msg.value >= price, "Need to send more eth");
1560         if (msg.value > price) {
1561             payable(msg.sender).transfer(msg.value - price);
1562         }
1563     }
1564 
1565     /**  Standard TokenURI ERC721A function modified to return hidden metadata
1566          URI until the contract is revealed. */
1567     function tokenURI(uint256 _tokenId)
1568         public
1569         view
1570         virtual
1571         override
1572         returns (string memory)
1573     {
1574         require(_exists(_tokenId), "Nonexistent token!");
1575 
1576         if (keccak256(abi.encodePacked(_baseTokenURI)) == keccak256(abi.encodePacked(""))) {
1577             return hiddenMetadataUri;
1578         }
1579 
1580         return
1581             bytes(_baseTokenURI).length > 0
1582                 ? string(
1583                     abi.encodePacked(_baseTokenURI, _tokenId.toString(), uriSuffix)
1584                 )
1585                 : "";
1586     }
1587     
1588 /// OWNER FUNCTIONS ///
1589 
1590     /** Standard withdraw function for the owner to pull the contract */
1591     function withdrawMoney() external onlyOwner nonReentrant {
1592         uint256 sendAmount = address(this).balance;
1593 
1594         address community = payable(0x416dDEDeE351a1f97Bc5c1ff15bE150Bb14c948c); 
1595         address jphilly = payable(0x7177585d7639f01E597E91918114A850ADc93258);
1596         address jsquared = payable(0xdC0556d45e56c030E12EBbdf8Df290c46d11285A);
1597         address zphilly = payable(0x290F139cc66Fca18fC97991c9383A8B830D29f7a);
1598         address artist = payable(0x322856622dB75cdd6e6d1EEda8e96170656AA6CA);
1599         address ninja = payable(0x9a4069cD84bF8654c329d87cE4102855359FBcE5);
1600         address yeti = payable(0x66c17Dcef1B364014573Ae0F869ad1c05fe01c89);
1601         address zj = payable(0xaFece8854848B04cf0796e246724dA7624eC8bC2);
1602         address willy = payable(0x4Bd3BB6B1D03c8844476e525fF291627FbC3c0eA);
1603         address marketing = payable(0x5c3023309dF0a3F7FE59e530B14629184AeB2035);
1604         address jhutt = payable(0x92718D60473d76075e219e5F5B11C628BcF78152);
1605         
1606         bool success;
1607         (success, ) = jphilly.call{value: ((sendAmount * 1875) / 10000)}("");
1608         require(success, "Transaction unsuccessful");
1609 
1610         (success, ) = jsquared.call{value: ((sendAmount * 1875) / 10000)}("");
1611         require(success, "Transaction unsuccessful");
1612 
1613         (success, ) = zphilly.call{value: ((sendAmount * 1875) / 10000)}("");
1614         require(success, "Transaction unsuccessful");
1615 
1616         (success, ) = community.call{value: ((sendAmount * 1975) / 10000)}("");
1617         require(success, "Transaction unsuccessful");
1618 
1619         (success, ) = ninja.call{value: ((sendAmount * 600) / 10000)}("");
1620         require(success, "Transaction unsuccessful");
1621         
1622         (success, ) = artist.call{value: ((sendAmount * 500) / 10000)}("");
1623         require(success, "Transaction unsuccessful");
1624 
1625         (success, ) = yeti.call{value: ((sendAmount * 300) / 10000)}("");
1626         require(success, "Transaction unsuccessful");
1627 
1628         (success, ) = zj.call{value: ((sendAmount * 300) / 10000)}("");
1629         require(success, "Transaction unsuccessful");
1630 
1631         (success, ) = willy.call{value: ((sendAmount * 300) / 10000)}("");
1632         require(success, "Transaction unsuccessful");
1633 
1634         (success, ) = jhutt.call{value: ((sendAmount * 300) / 10000)}("");
1635         require(success, "Transaction unsuccessful");
1636 
1637         (success, ) = marketing.call{value: ((sendAmount * 100) / 10000)}("");
1638         require(success, "Transaction unsuccessful");
1639     }
1640 
1641     /** Mint Function only usable by contract owner. Use reserved for giveaways and promotions. */
1642     function ownerMint(address to, uint256 quantity) public callerIsUser onlyOwner {
1643         require(quantity + totalSupply() <= collectionSize, 'Max supply reached');
1644         _safeMint(to, quantity);
1645     }
1646 
1647     /** Function for updating the revealed token metadata URI. When setting this value,
1648         only replace _CID_ in the following:  ipfs://_CID_/                          */
1649     function setBaseURI(string memory baseURI) public onlyOwner {
1650         _baseTokenURI = baseURI;
1651     }
1652 
1653     /** Initialized in constructor - Hidden metadata value pointing to unrevealed token URI. */
1654     function setHiddenMetadataURI(string memory _hiddenMetadataURI) public onlyOwner {
1655         hiddenMetadataUri = _hiddenMetadataURI;
1656     }
1657 
1658     function setPresaleActive(bool _active) public onlyOwner {
1659         presaleActive = _active;
1660     }
1661 
1662     function setPublicSaleActive(bool _active) public onlyOwner {
1663         publicSaleActive = _active;
1664     }
1665 
1666    /** adding onlyOwner and nonReentrant modifiers to ERC721A setOwnersExplicit for enhanced security */
1667     function setOwnersExplicit(uint256 quantity)
1668         external
1669         onlyOwner
1670         nonReentrant
1671     {
1672         _setOwnersExplicit(quantity);
1673     }
1674 
1675 }