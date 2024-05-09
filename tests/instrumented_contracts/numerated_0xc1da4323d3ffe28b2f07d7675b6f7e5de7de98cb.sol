1 // File: contracts/utils/Counter.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.7;
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
46 // File: contracts/utils/Strings.sol
47 
48 
49 
50 pragma solidity ^0.8.0;
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
119 // File: contracts/utils/Context.sol
120 
121 
122 
123 pragma solidity ^0.8.0;
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
145 // File: contracts/access/Ownable.sol
146 
147 
148 
149 pragma solidity ^0.8.0;
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
224 // File: contracts/utils/Address.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
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
480 // File: contracts/token/ERC721/IERC721Receiver.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
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
509 // File: contracts/utils/introspection/IERC165.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
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
536 // File: contracts/utils/introspection/ERC165.sol
537 
538 
539 
540 pragma solidity ^0.8.0;
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
572 // File: contracts/token/ERC721/IERC721.sol
573 
574 
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
734 // File: contracts/token/ERC721/extensions/IERC721Enumerable.sol
735 
736 
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Enumerable is IERC721 {
746     /**
747      * @dev Returns the total amount of tokens stored by the contract.
748      */
749     function totalSupply() external view returns (uint256);
750 
751     /**
752      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
753      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
754      */
755     function tokenOfOwnerByIndex(address owner, uint256 index)
756         external
757         view
758         returns (uint256 tokenId);
759 
760     /**
761      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
762      * Use along with {totalSupply} to enumerate all tokens.
763      */
764     function tokenByIndex(uint256 index) external view returns (uint256);
765 }
766 
767 // File: contracts/token/ERC721/extensions/IERC721Metadata.sol
768 
769 
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Metadata is IERC721 {
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() external view returns (string memory);
783 
784     /**
785      * @dev Returns the token collection symbol.
786      */
787     function symbol() external view returns (string memory);
788 
789     /**
790      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
791      */
792     function tokenURI(uint256 tokenId) external view returns (string memory);
793 }
794 
795 // File: contracts/token/ERC721/ERC721.sol
796 
797 
798 
799 pragma solidity ^0.8.0;
800 
801 
802 
803 
804 
805 
806 
807 
808 /**
809  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
810  * the Metadata extension, but not including the Enumerable extension, which is available separately as
811  * {ERC721Enumerable}.
812  */
813 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
814     using Address for address;
815     using Strings for uint256;
816 
817     // Token name
818     string private _name;
819 
820     // Token symbol
821     string private _symbol;
822 
823     // Mapping from token ID to owner address
824     mapping(uint256 => address) private _owners;
825 
826     // Mapping owner address to token count
827     mapping(address => uint256) private _balances;
828 
829     // Mapping from token ID to approved address
830     mapping(uint256 => address) private _tokenApprovals;
831 
832     // Mapping from owner to operator approvals
833     mapping(address => mapping(address => bool)) private _operatorApprovals;
834 
835     /**
836      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
837      */
838     constructor(string memory name_, string memory symbol_) {
839         _name = name_;
840         _symbol = symbol_;
841     }
842 
843     /**
844      * @dev See {IERC165-supportsInterface}.
845      */
846     function supportsInterface(bytes4 interfaceId)
847         public
848         view
849         virtual
850         override(ERC165, IERC165)
851         returns (bool)
852     {
853         return
854             interfaceId == type(IERC721).interfaceId ||
855             interfaceId == type(IERC721Metadata).interfaceId ||
856             super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721-balanceOf}.
861      */
862     function balanceOf(address owner)
863         public
864         view
865         virtual
866         override
867         returns (uint256)
868     {
869         require(
870             owner != address(0),
871             "ERC721: balance query for the zero address"
872         );
873         return _balances[owner];
874     }
875 
876     /**
877      * @dev See {IERC721-ownerOf}.
878      */
879     function ownerOf(uint256 tokenId)
880         public
881         view
882         virtual
883         override
884         returns (address)
885     {
886         address owner = _owners[tokenId];
887         require(
888             owner != address(0),
889             "ERC721: owner query for nonexistent token"
890         );
891         return owner;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-name}.
896      */
897     function name() public view virtual override returns (string memory) {
898         return _name;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-symbol}.
903      */
904     function symbol() public view virtual override returns (string memory) {
905         return _symbol;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-tokenURI}.
910      */
911     function tokenURI(uint256 tokenId)
912         public
913         view
914         virtual
915         override
916         returns (string memory)
917     {
918         require(
919             _exists(tokenId),
920             "ERC721Metadata: URI query for nonexistent token"
921         );
922 
923         string memory baseURI = _baseURI();
924         return
925             bytes(baseURI).length > 0
926                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
927                 : "";
928     }
929 
930     /**
931      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
932      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
933      * by default, can be overriden in child contracts.
934      */
935     function _baseURI() internal view virtual returns (string memory) {
936         return "";
937     }
938 
939     /**
940      * @dev See {IERC721-approve}.
941      */
942     function approve(address to, uint256 tokenId) public virtual override {
943         address owner = ERC721.ownerOf(tokenId);
944         require(to != owner, "ERC721: approval to current owner");
945 
946         require(
947             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
948             "ERC721: approve caller is not owner nor approved for all"
949         );
950 
951         _approve(to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-getApproved}.
956      */
957     function getApproved(uint256 tokenId)
958         public
959         view
960         virtual
961         override
962         returns (address)
963     {
964         require(
965             _exists(tokenId),
966             "ERC721: approved query for nonexistent token"
967         );
968 
969         return _tokenApprovals[tokenId];
970     }
971 
972     /**
973      * @dev See {IERC721-setApprovalForAll}.
974      */
975     function setApprovalForAll(address operator, bool approved)
976         public
977         virtual
978         override
979     {
980         require(operator != _msgSender(), "ERC721: approve to caller");
981 
982         _operatorApprovals[_msgSender()][operator] = approved;
983         emit ApprovalForAll(_msgSender(), operator, approved);
984     }
985 
986     /**
987      * @dev See {IERC721-isApprovedForAll}.
988      */
989     function isApprovedForAll(address owner, address operator)
990         public
991         view
992         virtual
993         override
994         returns (bool)
995     {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         //solhint-disable-next-line max-line-length
1008         require(
1009             _isApprovedOrOwner(_msgSender(), tokenId),
1010             "ERC721: transfer caller is not owner nor approved"
1011         );
1012 
1013         _transfer(from, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         safeTransferFrom(from, to, tokenId, "");
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) public virtual override {
1036         require(
1037             _isApprovedOrOwner(_msgSender(), tokenId),
1038             "ERC721: transfer caller is not owner nor approved"
1039         );
1040         _safeTransfer(from, to, tokenId, _data);
1041     }
1042 
1043     /**
1044      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1045      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1046      *
1047      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1048      *
1049      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1050      * implement alternative mechanisms to perform token transfer, such as signature-based.
1051      *
1052      * Requirements:
1053      *
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      * - `tokenId` token must exist and be owned by `from`.
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _safeTransfer(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) internal virtual {
1067         _transfer(from, to, tokenId);
1068         require(
1069             _checkOnERC721Received(from, to, tokenId, _data),
1070             "ERC721: transfer to non ERC721Receiver implementer"
1071         );
1072     }
1073 
1074     /**
1075      * @dev Returns whether `tokenId` exists.
1076      *
1077      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1078      *
1079      * Tokens start existing when they are minted (`_mint`),
1080      * and stop existing when they are burned (`_burn`).
1081      */
1082     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1083         return _owners[tokenId] != address(0);
1084     }
1085 
1086     /**
1087      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      */
1093     function _isApprovedOrOwner(address spender, uint256 tokenId)
1094         internal
1095         view
1096         virtual
1097         returns (bool)
1098     {
1099         require(
1100             _exists(tokenId),
1101             "ERC721: operator query for nonexistent token"
1102         );
1103         address owner = ERC721.ownerOf(tokenId);
1104         return (spender == owner ||
1105             getApproved(tokenId) == spender ||
1106             isApprovedForAll(owner, spender));
1107     }
1108 
1109     /**
1110      * @dev Safely mints `tokenId` and transfers it to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must not exist.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _safeMint(address to, uint256 tokenId) internal virtual {
1120         _safeMint(to, tokenId, "");
1121     }
1122 
1123     /**
1124      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1125      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1126      */
1127     function _safeMint(
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) internal virtual {
1132         _mint(to, tokenId);
1133         require(
1134             _checkOnERC721Received(address(0), to, tokenId, _data),
1135             "ERC721: transfer to non ERC721Receiver implementer"
1136         );
1137     }
1138 
1139     /**
1140      * @dev Mints `tokenId` and transfers it to `to`.
1141      *
1142      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must not exist.
1147      * - `to` cannot be the zero address.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _mint(address to, uint256 tokenId) internal virtual {
1152         require(to != address(0), "ERC721: mint to the zero address");
1153         require(!_exists(tokenId), "ERC721: token already minted");
1154 
1155         _beforeTokenTransfer(address(0), to, tokenId);
1156 
1157         _balances[to] += 1;
1158         _owners[tokenId] = to;
1159 
1160         emit Transfer(address(0), to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Destroys `tokenId`.
1165      * The approval is cleared when the token is burned.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _burn(uint256 tokenId) internal virtual {
1174         address owner = ERC721.ownerOf(tokenId);
1175 
1176         _beforeTokenTransfer(owner, address(0), tokenId);
1177 
1178         // Clear approvals
1179         _approve(address(0), tokenId);
1180 
1181         _balances[owner] -= 1;
1182         delete _owners[tokenId];
1183 
1184         emit Transfer(owner, address(0), tokenId);
1185     }
1186 
1187     /**
1188      * @dev Transfers `tokenId` from `from` to `to`.
1189      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must be owned by `from`.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _transfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) internal virtual {
1203         require(
1204             ERC721.ownerOf(tokenId) == from,
1205             "ERC721: transfer of token that is not own"
1206         );
1207         require(to != address(0), "ERC721: transfer to the zero address");
1208 
1209         _beforeTokenTransfer(from, to, tokenId);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId);
1213 
1214         _balances[from] -= 1;
1215         _balances[to] += 1;
1216         _owners[tokenId] = to;
1217 
1218         emit Transfer(from, to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev Approve `to` to operate on `tokenId`
1223      *
1224      * Emits a {Approval} event.
1225      */
1226     function _approve(address to, uint256 tokenId) internal virtual {
1227         _tokenApprovals[tokenId] = to;
1228         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1233      * The call is not executed if the target address is not a contract.
1234      *
1235      * @param from address representing the previous owner of the given token ID
1236      * @param to target address that will receive the tokens
1237      * @param tokenId uint256 ID of the token to be transferred
1238      * @param _data bytes optional data to send along with the call
1239      * @return bool whether the call correctly returned the expected magic value
1240      */
1241     function _checkOnERC721Received(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) private returns (bool) {
1247         if (to.isContract()) {
1248             try
1249                 IERC721Receiver(to).onERC721Received(
1250                     _msgSender(),
1251                     from,
1252                     tokenId,
1253                     _data
1254                 )
1255             returns (bytes4 retval) {
1256                 return retval == IERC721Receiver.onERC721Received.selector;
1257             } catch (bytes memory reason) {
1258                 if (reason.length == 0) {
1259                     revert(
1260                         "ERC721: transfer to non ERC721Receiver implementer"
1261                     );
1262                 } else {
1263                     assembly {
1264                         revert(add(32, reason), mload(reason))
1265                     }
1266                 }
1267             }
1268         } else {
1269             return true;
1270         }
1271     }
1272 
1273     /**
1274      * @dev Hook that is called before any token transfer. This includes minting
1275      * and burning.
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1283      * - `from` and `to` are never both zero.
1284      *
1285      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1286      */
1287     function _beforeTokenTransfer(
1288         address from,
1289         address to,
1290         uint256 tokenId
1291     ) internal virtual {}
1292 }
1293 
1294 // File: contracts/token/ERC721/extensions/ERC721Enumerable.sol
1295 
1296 
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 
1301 
1302 /**
1303  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1304  * enumerability of all the token ids in the contract as well as all token ids owned by each
1305  * account.
1306  */
1307 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1308     // Mapping from owner to list of owned token IDs
1309     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1310 
1311     // Mapping from token ID to index of the owner tokens list
1312     mapping(uint256 => uint256) private _ownedTokensIndex;
1313 
1314     // Array with all token ids, used for enumeration
1315     uint256[] private _allTokens;
1316 
1317     // Mapping from token id to position in the allTokens array
1318     mapping(uint256 => uint256) private _allTokensIndex;
1319 
1320     /**
1321      * @dev See {IERC165-supportsInterface}.
1322      */
1323     function supportsInterface(bytes4 interfaceId)
1324         public
1325         view
1326         virtual
1327         override(IERC165, ERC721)
1328         returns (bool)
1329     {
1330         return
1331             interfaceId == type(IERC721Enumerable).interfaceId ||
1332             super.supportsInterface(interfaceId);
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1337      */
1338     function tokenOfOwnerByIndex(address owner, uint256 index)
1339         public
1340         view
1341         virtual
1342         override
1343         returns (uint256)
1344     {
1345         require(
1346             index < ERC721.balanceOf(owner),
1347             "ERC721Enumerable: owner index out of bounds"
1348         );
1349         return _ownedTokens[owner][index];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-totalSupply}.
1354      */
1355     function totalSupply() public view virtual override returns (uint256) {
1356         return _allTokens.length;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-tokenByIndex}.
1361      */
1362     function tokenByIndex(uint256 index)
1363         public
1364         view
1365         virtual
1366         override
1367         returns (uint256)
1368     {
1369         require(
1370             index < ERC721Enumerable.totalSupply(),
1371             "ERC721Enumerable: global index out of bounds"
1372         );
1373         return _allTokens[index];
1374     }
1375 
1376     /**
1377      * @dev Hook that is called before any token transfer. This includes minting
1378      * and burning.
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1386      * - `from` cannot be the zero address.
1387      * - `to` cannot be the zero address.
1388      *
1389      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1390      */
1391     function _beforeTokenTransfer(
1392         address from,
1393         address to,
1394         uint256 tokenId
1395     ) internal virtual override {
1396         super._beforeTokenTransfer(from, to, tokenId);
1397 
1398         if (from == address(0)) {
1399             _addTokenToAllTokensEnumeration(tokenId);
1400         } else if (from != to) {
1401             _removeTokenFromOwnerEnumeration(from, tokenId);
1402         }
1403         if (to == address(0)) {
1404             _removeTokenFromAllTokensEnumeration(tokenId);
1405         } else if (to != from) {
1406             _addTokenToOwnerEnumeration(to, tokenId);
1407         }
1408     }
1409 
1410     /**
1411      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1412      * @param to address representing the new owner of the given token ID
1413      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1414      */
1415     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1416         uint256 length = ERC721.balanceOf(to);
1417         _ownedTokens[to][length] = tokenId;
1418         _ownedTokensIndex[tokenId] = length;
1419     }
1420 
1421     /**
1422      * @dev Private function to add a token to this extension's token tracking data structures.
1423      * @param tokenId uint256 ID of the token to be added to the tokens list
1424      */
1425     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1426         _allTokensIndex[tokenId] = _allTokens.length;
1427         _allTokens.push(tokenId);
1428     }
1429 
1430     /**
1431      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1432      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1433      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1434      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1435      * @param from address representing the previous owner of the given token ID
1436      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1437      */
1438     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1439         private
1440     {
1441         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1442         // then delete the last slot (swap and pop).
1443 
1444         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1445         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1446 
1447         // When the token to delete is the last token, the swap operation is unnecessary
1448         if (tokenIndex != lastTokenIndex) {
1449             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1450 
1451             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1452             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1453         }
1454 
1455         // This also deletes the contents at the last position of the array
1456         delete _ownedTokensIndex[tokenId];
1457         delete _ownedTokens[from][lastTokenIndex];
1458     }
1459 
1460     /**
1461      * @dev Private function to remove a token from this extension's token tracking data structures.
1462      * This has O(1) time complexity, but alters the order of the _allTokens array.
1463      * @param tokenId uint256 ID of the token to be removed from the tokens list
1464      */
1465     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1466         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1467         // then delete the last slot (swap and pop).
1468 
1469         uint256 lastTokenIndex = _allTokens.length - 1;
1470         uint256 tokenIndex = _allTokensIndex[tokenId];
1471 
1472         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1473         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1474         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1475         uint256 lastTokenId = _allTokens[lastTokenIndex];
1476 
1477         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1478         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1479 
1480         // This also deletes the contents at the last position of the array
1481         delete _allTokensIndex[tokenId];
1482         _allTokens.pop();
1483     }
1484 }
1485 
1486 // File: tests/HatersClubContract.sol
1487 
1488 //SPDX-License-Identifier: MIT
1489 
1490 pragma solidity ^0.8.7;
1491 
1492 
1493 
1494 
1495 contract HatersClubContract is ERC721Enumerable, Ownable {
1496     using Strings for uint256;
1497     using Counters for Counters.Counter;
1498 
1499     string public baseURI;
1500     string public baseExtension = ".json";
1501     uint256 public cost = 50000000 gwei;
1502     uint256 public OG_cost = 0 ether;
1503 
1504     Counters.Counter private _tokenIdCounter;
1505 
1506     uint256 public maxSupply = 5000;
1507 
1508     bool public paused = false;
1509     bool public freemint = false;
1510 
1511     uint256 public constant PublicSales_time_1st = 20 minutes;
1512     uint256 public constant PublicSales_time_2nd = 40 minutes;
1513     uint256 public constant PublicSales_time_3rd = 60 minutes;
1514     uint256 public constant PublicSales_time_4th = 80 minutes;
1515 
1516     uint256 public PublicSales_1st = 40000000 gwei;
1517     uint256 public PublicSales_2nd = 30000000 gwei;
1518     uint256 public PublicSales_3rd = 20000000 gwei;
1519     uint256 public PublicSales_4th = 10000000 gwei;
1520 
1521     uint256 public DutchAuctionStartTimestamp;
1522 
1523     constructor(
1524         string memory _name,
1525         string memory _symbol,
1526         string memory _initBaseURI
1527     ) ERC721(_name, _symbol) {
1528         setBaseURI(_initBaseURI);
1529         for (uint256 i = 1; i <= 75; i++) {
1530             _safeMint(owner(), i);
1531             _tokenIdCounter.increment();
1532         }
1533     }
1534 
1535     // internal
1536     function _baseURI() internal view virtual override returns (string memory) {
1537         return baseURI;
1538     }
1539 
1540     // public
1541     function mint(uint256 _mintAmount) public payable {
1542         require(!paused);
1543         require(_mintAmount > 0);
1544         require(_tokenIdCounter.current() + _mintAmount <= maxSupply);
1545         
1546         if (msg.sender != owner()) {
1547   
1548             uint256 ownerTokenCount = balanceOf(msg.sender);
1549             if (freemint == true) {require(msg.value >= OG_cost * _mintAmount);}
1550             else if (_tokenIdCounter.current() <= 1999) {
1551                 if (ownerTokenCount < 1) {
1552                 require(_mintAmount == 1);
1553                 require(msg.value >= OG_cost * _mintAmount);                    
1554                 }
1555                 else {
1556                 require(msg.value >= cost * _mintAmount);                    
1557                 }
1558  
1559                 }
1560 
1561             else if (_tokenIdCounter.current() > 1999 && block.timestamp > DutchAuctionStartTimestamp && block.timestamp < DutchAuctionStartTimestamp + PublicSales_time_1st) {
1562                 require(msg.value >= cost * _mintAmount);}
1563             else if (_tokenIdCounter.current() > 1999 && block.timestamp > DutchAuctionStartTimestamp + PublicSales_time_1st && block.timestamp < DutchAuctionStartTimestamp + PublicSales_time_2nd) {
1564                 require(msg.value >= PublicSales_1st * _mintAmount);cost = PublicSales_1st;}
1565             else if (_tokenIdCounter.current() > 1999 && block.timestamp > DutchAuctionStartTimestamp + PublicSales_time_2nd && block.timestamp < DutchAuctionStartTimestamp + PublicSales_time_3rd) {
1566                 require(msg.value >= PublicSales_2nd * _mintAmount);cost = PublicSales_2nd;}
1567             else if (_tokenIdCounter.current() > 1999 && block.timestamp > DutchAuctionStartTimestamp + PublicSales_time_3rd && block.timestamp < DutchAuctionStartTimestamp + PublicSales_time_4th) {
1568                 require(msg.value >= PublicSales_3rd * _mintAmount);cost = PublicSales_3rd;}   
1569             else if (_tokenIdCounter.current() > 1999 && block.timestamp > DutchAuctionStartTimestamp + PublicSales_time_4th) {
1570                 require(msg.value >= PublicSales_4th * _mintAmount);cost = PublicSales_4th;}
1571             else {require(msg.value >= cost * _mintAmount);}          
1572                   
1573         }
1574 
1575         for (uint256 i = 1; i <= _mintAmount; i++) {
1576             _safeMint(msg.sender, _tokenIdCounter.current() + i);
1577         }
1578         for (uint256 i = 1; i <= _mintAmount; i++) {
1579             if (_tokenIdCounter.current() == 1999) {DutchAuctionStartTimestamp = block.timestamp;}
1580             _tokenIdCounter.increment();
1581         }
1582     }
1583 
1584 
1585 
1586 
1587     function starttimestamp() public view returns (uint256) {
1588         return DutchAuctionStartTimestamp;
1589     }
1590 
1591     function tokenIdCounter() public view returns (uint256) {
1592         return _tokenIdCounter.current();
1593     }
1594 
1595  
1596     function walletOfOwner(address _owner)
1597         public
1598         view
1599         returns (uint256[] memory)
1600     {
1601         uint256 ownerTokenCount = balanceOf(_owner);
1602         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1603         for (uint256 i; i < ownerTokenCount; i++) {
1604             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1605         }
1606         return tokenIds;
1607     }
1608 
1609     function tokenURI(uint256 tokenId)
1610         public
1611         view
1612         virtual
1613         override
1614         returns (string memory)
1615     {
1616         require(
1617             _exists(tokenId),
1618             "ERC721Metadata: URI query for nonexistent token"
1619         );
1620 
1621         string memory currentBaseURI = _baseURI();
1622         return
1623             bytes(currentBaseURI).length > 0
1624                 ? string(
1625                     abi.encodePacked(
1626                         currentBaseURI,
1627                         tokenId.toString(),
1628                         baseExtension
1629                     )
1630                 )
1631                 : "";
1632     }
1633 
1634     //only owner
1635 
1636     function setMaxSupply(uint256 _maxsupply) public onlyOwner {
1637         maxSupply = _maxsupply;
1638     }
1639 
1640 
1641     function setPublicMintCost(uint256 _cost) public onlyOwner {
1642         cost = _cost;
1643     }
1644 
1645 
1646     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1647         baseURI = _newBaseURI;
1648     }
1649 
1650     function setBaseExtension(string memory _newBaseExtension)
1651         public
1652         onlyOwner
1653     {
1654         baseExtension = _newBaseExtension;
1655     }
1656 
1657 
1658     function pause(bool _state) public onlyOwner {
1659         paused = _state;
1660     }
1661 
1662     function freeminted(bool _freemint) public onlyOwner {
1663         freemint = _freemint;
1664     }
1665 
1666 
1667     function withdraw() public payable onlyOwner {
1668         (bool success, ) = payable(msg.sender).call{
1669             value: address(this).balance
1670         }("");
1671         require(success);
1672     }
1673 }