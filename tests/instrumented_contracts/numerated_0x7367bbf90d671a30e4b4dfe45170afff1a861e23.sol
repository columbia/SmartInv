1 // SPDX-License-Identifier: MIT
2 // File: Counters.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 // File: Strings.sol
47 
48 
49 
50 pragma solidity ^0.8.1;
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length)
103         internal
104         pure
105         returns (string memory)
106     {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 // File: Context.sol
120 
121 
122 
123 pragma solidity ^0.8.1;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: Ownable.sol
146 
147 
148 
149 pragma solidity ^0.8.1;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(
168         address indexed previousOwner,
169         address indexed newOwner
170     );
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor() {
176         _setOwner(_msgSender());
177     }
178 
179     /**
180      * @dev Returns the address of the current owner.
181      */
182     function owner() public view virtual returns (address) {
183         return _owner;
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public virtual onlyOwner {
202         _setOwner(address(0));
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(
211             newOwner != address(0),
212             "Ownable: new owner is the zero address"
213         );
214         _setOwner(newOwner);
215     }
216 
217     function _setOwner(address newOwner) private {
218         address oldOwner = _owner;
219         _owner = newOwner;
220         emit OwnershipTransferred(oldOwner, newOwner);
221     }
222 }
223 
224 // File: Address.sol
225 
226 
227 
228 pragma solidity ^0.8.1;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(
281             address(this).balance >= amount,
282             "Address: insufficient balance"
283         );
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(
287             success,
288             "Address: unable to send value, recipient may have reverted"
289         );
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data)
311         internal
312         returns (bytes memory)
313     {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return
348             functionCallWithValue(
349                 target,
350                 data,
351                 value,
352                 "Address: low-level call with value failed"
353             );
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(
369             address(this).balance >= value,
370             "Address: insufficient balance for call"
371         );
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(
375             data
376         );
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data)
387         internal
388         view
389         returns (bytes memory)
390     {
391         return
392             functionStaticCall(
393                 target,
394                 data,
395                 "Address: low-level static call failed"
396             );
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
422     function functionDelegateCall(address target, bytes memory data)
423         internal
424         returns (bytes memory)
425     {
426         return
427             functionDelegateCall(
428                 target,
429                 data,
430                 "Address: low-level delegate call failed"
431             );
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: IERC721Receiver.sol
481 
482 
483 
484 pragma solidity ^0.8.1;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: IERC165.sol
510 
511 
512 
513 pragma solidity ^0.8.1;
514 
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 // File: ERC165.sol
537 
538 
539 
540 pragma solidity ^0.8.1;
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId)
562         public
563         view
564         virtual
565         override
566         returns (bool)
567     {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 // File: IERC721.sol
573 
574 
575 
576 pragma solidity ^0.8.1;
577 
578 
579 /**
580  * @dev Required interface of an ERC721 compliant contract.
581  */
582 interface IERC721 is IERC165 {
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(
587         address indexed from,
588         address indexed to,
589         uint256 indexed tokenId
590     );
591 
592     /**
593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
594      */
595     event Approval(
596         address indexed owner,
597         address indexed approved,
598         uint256 indexed tokenId
599     );
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(
605         address indexed owner,
606         address indexed operator,
607         bool approved
608     );
609 
610     /**
611      * @dev Returns the number of tokens in ``owner``'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
626      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) external;
643 
644     /**
645      * @dev Transfers `tokenId` token from `from` to `to`.
646      *
647      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must be owned by `from`.
654      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      *
656      * Emits a {Transfer} event.
657      */
658     function transferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
666      * The approval is cleared when the token is transferred.
667      *
668      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
669      *
670      * Requirements:
671      *
672      * - The caller must own the token or be an approved operator.
673      * - `tokenId` must exist.
674      *
675      * Emits an {Approval} event.
676      */
677     function approve(address to, uint256 tokenId) external;
678 
679     /**
680      * @dev Returns the account approved for `tokenId` token.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function getApproved(uint256 tokenId)
687         external
688         view
689         returns (address operator);
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
704      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
705      *
706      * See {setApprovalForAll}
707      */
708     function isApprovedForAll(address owner, address operator)
709         external
710         view
711         returns (bool);
712 
713     /**
714      * @dev Safely transfers `tokenId` token from `from` to `to`.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must exist and be owned by `from`.
721      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes calldata data
731     ) external;
732 }
733 
734 // File: IERC721Metadata.sol
735 
736 
737 
738 pragma solidity ^0.8.1;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Metadata is IERC721 {
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 // File: ERC721.sol
763 
764 
765 
766 pragma solidity ^0.8.1;
767 
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension, but not including the Enumerable extension, which is available separately as
778  * {ERC721Enumerable}.
779  */
780 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
781     using Address for address;
782     using Strings for uint256;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to owner address
791     mapping(uint256 => address) private _owners;
792 
793     // Mapping owner address to token count
794     mapping(address => uint256) private _balances;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     /**
803      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
804      */
805     constructor(string memory name_, string memory symbol_) {
806         _name = name_;
807         _symbol = symbol_;
808     }
809 
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId)
814         public
815         view
816         virtual
817         override(ERC165, IERC165)
818         returns (bool)
819     {
820         return
821             interfaceId == type(IERC721).interfaceId ||
822             interfaceId == type(IERC721Metadata).interfaceId ||
823             super.supportsInterface(interfaceId);
824     }
825 
826     /**
827      * @dev See {IERC721-balanceOf}.
828      */
829     function balanceOf(address owner)
830         public
831         view
832         virtual
833         override
834         returns (uint256)
835     {
836         require(
837             owner != address(0),
838             "ERC721: balance query for the zero address"
839         );
840         return _balances[owner];
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId)
847         public
848         view
849         virtual
850         override
851         returns (address)
852     {
853         address owner = _owners[tokenId];
854         require(
855             owner != address(0),
856             "ERC721: owner query for nonexistent token"
857         );
858         return owner;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId)
879         public
880         view
881         virtual
882         override
883         returns (string memory)
884     {
885         require(
886             _exists(tokenId),
887             "ERC721Metadata: URI query for nonexistent token"
888         );
889 
890         string memory baseURI = _baseURI();
891         return
892             bytes(baseURI).length > 0
893                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
894                 : "";
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, can be overriden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return "";
904     }
905 
906     /**
907      * @dev See {IERC721-approve}.
908      */
909     function approve(address to, uint256 tokenId) public virtual override {
910         address owner = ERC721.ownerOf(tokenId);
911         require(to != owner, "ERC721: approval to current owner");
912 
913         require(
914             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
915             "ERC721: approve caller is not owner nor approved for all"
916         );
917 
918         _approve(to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-getApproved}.
923      */
924     function getApproved(uint256 tokenId)
925         public
926         view
927         virtual
928         override
929         returns (address)
930     {
931         require(
932             _exists(tokenId),
933             "ERC721: approved query for nonexistent token"
934         );
935 
936         return _tokenApprovals[tokenId];
937     }
938 
939     /**
940      * @dev See {IERC721-setApprovalForAll}.
941      */
942     function setApprovalForAll(address operator, bool approved)
943         public
944         virtual
945         override
946     {
947         require(operator != _msgSender(), "ERC721: approve to caller");
948 
949         _operatorApprovals[_msgSender()][operator] = approved;
950         emit ApprovalForAll(_msgSender(), operator, approved);
951     }
952 
953     /**
954      * @dev See {IERC721-isApprovedForAll}.
955      */
956     function isApprovedForAll(address owner, address operator)
957         public
958         view
959         virtual
960         override
961         returns (bool)
962     {
963         return _operatorApprovals[owner][operator];
964     }
965 
966     /**
967      * @dev See {IERC721-transferFrom}.
968      */
969     function transferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public virtual override {
974         //solhint-disable-next-line max-line-length
975         require(
976             _isApprovedOrOwner(_msgSender(), tokenId),
977             "ERC721: transfer caller is not owner nor approved"
978         );
979 
980         _transfer(from, to, tokenId);
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId
990     ) public virtual override {
991         safeTransferFrom(from, to, tokenId, "");
992     }
993 
994     /**
995      * @dev See {IERC721-safeTransferFrom}.
996      */
997     function safeTransferFrom(
998         address from,
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) public virtual override {
1003         require(
1004             _isApprovedOrOwner(_msgSender(), tokenId),
1005             "ERC721: transfer caller is not owner nor approved"
1006         );
1007         _safeTransfer(from, to, tokenId, _data);
1008     }
1009 
1010     /**
1011      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1012      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1013      *
1014      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1015      *
1016      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1017      * implement alternative mechanisms to perform token transfer, such as signature-based.
1018      *
1019      * Requirements:
1020      *
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must exist and be owned by `from`.
1024      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _safeTransfer(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) internal virtual {
1034         _transfer(from, to, tokenId);
1035         require(
1036             _checkOnERC721Received(from, to, tokenId, _data),
1037             "ERC721: transfer to non ERC721Receiver implementer"
1038         );
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      * and stop existing when they are burned (`_burn`).
1048      */
1049     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1050         return _owners[tokenId] != address(0);
1051     }
1052 
1053     /**
1054      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      */
1060     function _isApprovedOrOwner(address spender, uint256 tokenId)
1061         internal
1062         view
1063         virtual
1064         returns (bool)
1065     {
1066         require(
1067             _exists(tokenId),
1068             "ERC721: operator query for nonexistent token"
1069         );
1070         address owner = ERC721.ownerOf(tokenId);
1071         return (spender == owner ||
1072             getApproved(tokenId) == spender ||
1073             isApprovedForAll(owner, spender));
1074     }
1075 
1076     /**
1077      * @dev Safely mints `tokenId` and transfers it to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must not exist.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeMint(address to, uint256 tokenId) internal virtual {
1087         _safeMint(to, tokenId, "");
1088     }
1089 
1090     /**
1091      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1092      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1093      */
1094     function _safeMint(
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) internal virtual {
1099         _mint(to, tokenId);
1100         require(
1101             _checkOnERC721Received(address(0), to, tokenId, _data),
1102             "ERC721: transfer to non ERC721Receiver implementer"
1103         );
1104     }
1105 
1106     /**
1107      * @dev Mints `tokenId` and transfers it to `to`.
1108      *
1109      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must not exist.
1114      * - `to` cannot be the zero address.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _mint(address to, uint256 tokenId) internal virtual {
1119         require(to != address(0), "ERC721: mint to the zero address");
1120         require(!_exists(tokenId), "ERC721: token already minted");
1121 
1122         _beforeTokenTransfer(address(0), to, tokenId);
1123 
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(address(0), to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Destroys `tokenId`.
1132      * The approval is cleared when the token is burned.
1133      *
1134      * Requirements:
1135      *
1136      * - `tokenId` must exist.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _burn(uint256 tokenId) internal virtual {
1141         address owner = ERC721.ownerOf(tokenId);
1142 
1143         _beforeTokenTransfer(owner, address(0), tokenId);
1144 
1145         // Clear approvals
1146         _approve(address(0), tokenId);
1147 
1148         _balances[owner] -= 1;
1149         delete _owners[tokenId];
1150 
1151         emit Transfer(owner, address(0), tokenId);
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {
1170         require(
1171             ERC721.ownerOf(tokenId) == from,
1172             "ERC721: transfer of token that is not own"
1173         );
1174         require(to != address(0), "ERC721: transfer to the zero address");
1175 
1176         _beforeTokenTransfer(from, to, tokenId);
1177 
1178         // Clear approvals from the previous owner
1179         _approve(address(0), tokenId);
1180 
1181         _balances[from] -= 1;
1182         _balances[to] += 1;
1183         _owners[tokenId] = to;
1184 
1185         emit Transfer(from, to, tokenId);
1186     }
1187 
1188     /**
1189      * @dev Approve `to` to operate on `tokenId`
1190      *
1191      * Emits a {Approval} event.
1192      */
1193     function _approve(address to, uint256 tokenId) internal virtual {
1194         _tokenApprovals[tokenId] = to;
1195         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1200      * The call is not executed if the target address is not a contract.
1201      *
1202      * @param from address representing the previous owner of the given token ID
1203      * @param to target address that will receive the tokens
1204      * @param tokenId uint256 ID of the token to be transferred
1205      * @param _data bytes optional data to send along with the call
1206      * @return bool whether the call correctly returned the expected magic value
1207      */
1208     function _checkOnERC721Received(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) private returns (bool) {
1214         if (to.isContract()) {
1215             try
1216                 IERC721Receiver(to).onERC721Received(
1217                     _msgSender(),
1218                     from,
1219                     tokenId,
1220                     _data
1221                 )
1222             returns (bytes4 retval) {
1223                 return retval == IERC721Receiver.onERC721Received.selector;
1224             } catch (bytes memory reason) {
1225                 if (reason.length == 0) {
1226                     revert(
1227                         "ERC721: transfer to non ERC721Receiver implementer"
1228                     );
1229                 } else {
1230                     assembly {
1231                         revert(add(32, reason), mload(reason))
1232                     }
1233                 }
1234             }
1235         } else {
1236             return true;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Hook that is called before any token transfer. This includes minting
1242      * and burning.
1243      *
1244      * Calling conditions:
1245      *
1246      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1247      * transferred to `to`.
1248      * - When `from` is zero, `tokenId` will be minted for `to`.
1249      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1250      * - `from` and `to` are never both zero.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _beforeTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) internal virtual {}
1259 }
1260 
1261 // File: Apeload.sol
1262 
1263 
1264 pragma solidity ^0.8.9;
1265 
1266 
1267 
1268 
1269 
1270 library OpenSeaGasFreeListing {
1271     function isApprovedForAll(address owner, address operator)
1272         internal
1273         view
1274         returns (bool)
1275     {
1276         ProxyRegistry registry;
1277         assembly {
1278             switch chainid()
1279             case 1 {
1280                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1281             }
1282             case 4 {
1283                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
1284             }
1285         }
1286 
1287         return
1288             address(registry) != address(0) &&
1289             address(registry.proxies(owner)) == operator;
1290     }
1291 }
1292 
1293 contract OwnableDelegateProxy {}
1294 
1295 contract ProxyRegistry {
1296     mapping(address => OwnableDelegateProxy) public proxies;
1297 }
1298 
1299 contract Apeload is ERC721, Ownable {
1300     using Counters for Counters.Counter;
1301     using Strings for uint256;
1302 
1303     bool public saleStart = false;
1304     string public tokenBaseURI;
1305     string public tokenBaseExtension = ".json";
1306     uint256 public cost = 0.02 ether;
1307     uint256 public maxTxnLimit = 10;
1308     uint256 public free = 1000;
1309     uint256 public maxSupply = 5000;
1310 
1311     Counters.Counter public tokenSupply;
1312 
1313     constructor() ERC721("Apeload", "Al") {
1314         _safeMints(1);
1315     }
1316 
1317     function tokenURI(uint256 _tokenId)
1318         public
1319         view
1320         override
1321         returns (string memory)
1322     {
1323         require(_exists(_tokenId), "Query for nonexistent token");
1324 
1325         return
1326             string(
1327                 abi.encodePacked(
1328                     tokenBaseURI,
1329                     _tokenId.toString(),
1330                     tokenBaseExtension
1331                 )
1332             );
1333     }
1334 
1335     function mint(uint256 amount) external payable {
1336         require(saleStart, "Sale has not started");
1337         require(amount > 0 && amount <= maxTxnLimit, "Invalid mint amount");
1338         _safeMints(amount);
1339     }
1340 
1341     function _safeMints(uint256 amount) internal {
1342         if (free < tokenSupply.current() + amount) {
1343             require(
1344                 tokenSupply.current() + amount <= maxSupply,
1345                 "Max supply reached"
1346             );
1347             require(msg.value >= cost * amount, "Insufficient eth");
1348         }
1349 
1350         for (uint256 i = 0; i < amount; i++) {
1351             uint256 mintIndex = tokenSupply.current();
1352 
1353             if (mintIndex < maxSupply) {
1354                 tokenSupply.increment();
1355                 _safeMint(msg.sender, mintIndex + 1);
1356             }
1357         }
1358     }
1359 
1360     function getSupply() external view returns (uint256) {
1361         return tokenSupply.current();
1362     }
1363 
1364     function setTokenBaseExtension(string memory _tokenBaseExtension)
1365         external
1366         onlyOwner
1367     {
1368         tokenBaseExtension = _tokenBaseExtension;
1369     }
1370 
1371     function setTokenBaseURI(string memory _baseURI) external onlyOwner {
1372         tokenBaseURI = _baseURI;
1373     }
1374 
1375     function setSaleState(bool state) external onlyOwner {
1376         saleStart = state;
1377     }
1378 
1379     function setCost(uint256 price) external onlyOwner {
1380         cost = price;
1381     }
1382 
1383     function setFree(uint256 index) external onlyOwner {
1384         free = index;
1385     }
1386 
1387     function setTxnLimit(uint256 txnLimit) external onlyOwner {
1388         maxTxnLimit = txnLimit;
1389     }
1390 
1391     function withdraw() public onlyOwner {
1392         (bool success, ) = payable(owner()).call{value: address(this).balance}(
1393             ""
1394         );
1395         require(success);
1396     }
1397 
1398     function isApprovedForAll(address owner, address operator)
1399         public
1400         view
1401         override
1402         returns (bool)
1403     {
1404         return
1405             OpenSeaGasFreeListing.isApprovedForAll(owner, operator) ||
1406             super.isApprovedForAll(owner, operator);
1407     }
1408 }