1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Counters.sol
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Context.sol
50 
51 pragma solidity ^0.8.0;
52 
53 /*
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Interface of the ERC165 standard, as defined in the
79  * https://eips.ethereum.org/EIPS/eip-165[EIP].
80  *
81  * Implementers can declare support of contract interfaces, which can then be
82  * queried by others ({ERC165Checker}).
83  *
84  * For an implementation, see {ERC165}.
85  */
86 interface IERC165 {
87     /**
88      * @dev Returns true if this contract implements the interface defined by
89      * `interfaceId`. See the corresponding
90      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
91      * to learn more about how these ids are created.
92      *
93      * This function call must use less than 30 000 gas.
94      */
95     function supportsInterface(bytes4 interfaceId) external view returns (bool);
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Required interface of an ERC721 compliant contract.
104  */
105 interface IERC721 is IERC165 {
106     /**
107      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
108      */
109     event Transfer(
110         address indexed from,
111         address indexed to,
112         uint256 indexed tokenId
113     );
114 
115     /**
116      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
117      */
118     event Approval(
119         address indexed owner,
120         address indexed approved,
121         uint256 indexed tokenId
122     );
123 
124     /**
125      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
126      */
127     event ApprovalForAll(
128         address indexed owner,
129         address indexed operator,
130         bool approved
131     );
132 
133     /**
134      * @dev Returns the number of tokens in ``owner``'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Transfers `tokenId` token from `from` to `to`.
169      *
170      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
189      * The approval is cleared when the token is transferred.
190      *
191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
192      *
193      * Requirements:
194      *
195      * - The caller must own the token or be an approved operator.
196      * - `tokenId` must exist.
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address to, uint256 tokenId) external;
201 
202     /**
203      * @dev Returns the account approved for `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function getApproved(uint256 tokenId)
210         external
211         view
212         returns (address operator);
213 
214     /**
215      * @dev Approve or remove `operator` as an operator for the caller.
216      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
217      *
218      * Requirements:
219      *
220      * - The `operator` cannot be the caller.
221      *
222      * Emits an {ApprovalForAll} event.
223      */
224     function setApprovalForAll(address operator, bool _approved) external;
225 
226     /**
227      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
228      *
229      * See {setApprovalForAll}
230      */
231     function isApprovedForAll(address owner, address operator)
232         external
233         view
234         returns (bool);
235 
236     /**
237      * @dev Safely transfers `tokenId` token from `from` to `to`.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must exist and be owned by `from`.
244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246      *
247      * Emits a {Transfer} event.
248      */
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 }
256 
257 // File: @openzeppelin/contracts/access/Ownable.sol
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 abstract contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(
277         address indexed previousOwner,
278         address indexed newOwner
279     );
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor() {
285         _setOwner(_msgSender());
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view virtual returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _setOwner(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(
320             newOwner != address(0),
321             "Ownable: new owner is the zero address"
322         );
323         _setOwner(newOwner);
324     }
325 
326     function _setOwner(address newOwner) private {
327         address oldOwner = _owner;
328         _owner = newOwner;
329         emit OwnershipTransferred(oldOwner, newOwner);
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
339  * @dev See https://eips.ethereum.org/EIPS/eip-721
340  */
341 interface IERC721Enumerable is IERC721 {
342     /**
343      * @dev Returns the total amount of tokens stored by the contract.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
349      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
350      */
351     function tokenOfOwnerByIndex(address owner, uint256 index)
352         external
353         view
354         returns (uint256 tokenId);
355 
356     /**
357      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
358      * Use along with {totalSupply} to enumerate all tokens.
359      */
360     function tokenByIndex(uint256 index) external view returns (uint256);
361 }
362 
363 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Implementation of the {IERC165} interface.
369  *
370  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
371  * for the additional interface id that will be supported. For example:
372  *
373  * ```solidity
374  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
376  * }
377  * ```
378  *
379  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
380  */
381 abstract contract ERC165 is IERC165 {
382     /**
383      * @dev See {IERC165-supportsInterface}.
384      */
385     function supportsInterface(bytes4 interfaceId)
386         public
387         view
388         virtual
389         override
390         returns (bool)
391     {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/utils/Strings.sol
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev String operations.
402  */
403 library Strings {
404     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
405 
406     /**
407      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
408      */
409     function toString(uint256 value) internal pure returns (string memory) {
410         // Inspired by OraclizeAPI's implementation - MIT licence
411         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
412 
413         if (value == 0) {
414             return "0";
415         }
416         uint256 temp = value;
417         uint256 digits;
418         while (temp != 0) {
419             digits++;
420             temp /= 10;
421         }
422         bytes memory buffer = new bytes(digits);
423         while (value != 0) {
424             digits -= 1;
425             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
426             value /= 10;
427         }
428         return string(buffer);
429     }
430 
431     /**
432      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
433      */
434     function toHexString(uint256 value) internal pure returns (string memory) {
435         if (value == 0) {
436             return "0x00";
437         }
438         uint256 temp = value;
439         uint256 length = 0;
440         while (temp != 0) {
441             length++;
442             temp >>= 8;
443         }
444         return toHexString(value, length);
445     }
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
449      */
450     function toHexString(uint256 value, uint256 length)
451         internal
452         pure
453         returns (string memory)
454     {
455         bytes memory buffer = new bytes(2 * length + 2);
456         buffer[0] = "0";
457         buffer[1] = "x";
458         for (uint256 i = 2 * length + 1; i > 1; --i) {
459             buffer[i] = _HEX_SYMBOLS[value & 0xf];
460             value >>= 4;
461         }
462         require(value == 0, "Strings: hex length insufficient");
463         return string(buffer);
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/Address.sol
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Collection of functions related to the address type
473  */
474 library Address {
475     /**
476      * @dev Returns true if `account` is a contract.
477      *
478      * [IMPORTANT]
479      * ====
480      * It is unsafe to assume that an address for which this function returns
481      * false is an externally-owned account (EOA) and not a contract.
482      *
483      * Among others, `isContract` will return false for the following
484      * types of addresses:
485      *
486      *  - an externally-owned account
487      *  - a contract in construction
488      *  - an address where a contract will be created
489      *  - an address where a contract lived, but was destroyed
490      * ====
491      */
492     function isContract(address account) internal view returns (bool) {
493         // This method relies on extcodesize, which returns 0 for contracts in
494         // construction, since the code is only stored at the end of the
495         // constructor execution.
496 
497         uint256 size;
498         assembly {
499             size := extcodesize(account)
500         }
501         return size > 0;
502     }
503 
504     /**
505      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
506      * `recipient`, forwarding all available gas and reverting on errors.
507      *
508      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
509      * of certain opcodes, possibly making contracts go over the 2300 gas limit
510      * imposed by `transfer`, making them unable to receive funds via
511      * `transfer`. {sendValue} removes this limitation.
512      *
513      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
514      *
515      * IMPORTANT: because control is transferred to `recipient`, care must be
516      * taken to not create reentrancy vulnerabilities. Consider using
517      * {ReentrancyGuard} or the
518      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
519      */
520     function sendValue(address payable recipient, uint256 amount) internal {
521         require(
522             address(this).balance >= amount,
523             "Address: insufficient balance"
524         );
525 
526         (bool success, ) = recipient.call{value: amount}("");
527         require(
528             success,
529             "Address: unable to send value, recipient may have reverted"
530         );
531     }
532 
533     /**
534      * @dev Performs a Solidity function call using a low level `call`. A
535      * plain `call` is an unsafe replacement for a function call: use this
536      * function instead.
537      *
538      * If `target` reverts with a revert reason, it is bubbled up by this
539      * function (like regular Solidity function calls).
540      *
541      * Returns the raw returned data. To convert to the expected return value,
542      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
543      *
544      * Requirements:
545      *
546      * - `target` must be a contract.
547      * - calling `target` with `data` must not revert.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data)
552         internal
553         returns (bytes memory)
554     {
555         return functionCall(target, data, "Address: low-level call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
560      * `errorMessage` as a fallback revert reason when `target` reverts.
561      *
562      * _Available since v3.1._
563      */
564     function functionCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         return functionCallWithValue(target, data, 0, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but also transferring `value` wei to `target`.
575      *
576      * Requirements:
577      *
578      * - the calling contract must have an ETH balance of at least `value`.
579      * - the called Solidity function must be `payable`.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value
587     ) internal returns (bytes memory) {
588         return
589             functionCallWithValue(
590                 target,
591                 data,
592                 value,
593                 "Address: low-level call with value failed"
594             );
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(
604         address target,
605         bytes memory data,
606         uint256 value,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(
610             address(this).balance >= value,
611             "Address: insufficient balance for call"
612         );
613         require(isContract(target), "Address: call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.call{value: value}(
616             data
617         );
618         return _verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data)
628         internal
629         view
630         returns (bytes memory)
631     {
632         return
633             functionStaticCall(
634                 target,
635                 data,
636                 "Address: low-level static call failed"
637             );
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
642      * but performing a static call.
643      *
644      * _Available since v3.3._
645      */
646     function functionStaticCall(
647         address target,
648         bytes memory data,
649         string memory errorMessage
650     ) internal view returns (bytes memory) {
651         require(isContract(target), "Address: static call to non-contract");
652 
653         (bool success, bytes memory returndata) = target.staticcall(data);
654         return _verifyCallResult(success, returndata, errorMessage);
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
659      * but performing a delegate call.
660      *
661      * _Available since v3.4._
662      */
663     function functionDelegateCall(address target, bytes memory data)
664         internal
665         returns (bytes memory)
666     {
667         return
668             functionDelegateCall(
669                 target,
670                 data,
671                 "Address: low-level delegate call failed"
672             );
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(
682         address target,
683         bytes memory data,
684         string memory errorMessage
685     ) internal returns (bytes memory) {
686         require(isContract(target), "Address: delegate call to non-contract");
687 
688         (bool success, bytes memory returndata) = target.delegatecall(data);
689         return _verifyCallResult(success, returndata, errorMessage);
690     }
691 
692     function _verifyCallResult(
693         bool success,
694         bytes memory returndata,
695         string memory errorMessage
696     ) private pure returns (bytes memory) {
697         if (success) {
698             return returndata;
699         } else {
700             // Look for revert reason and bubble it up if present
701             if (returndata.length > 0) {
702                 // The easiest way to bubble the revert reason is using memory via assembly
703 
704                 assembly {
705                     let returndata_size := mload(returndata)
706                     revert(add(32, returndata), returndata_size)
707                 }
708             } else {
709                 revert(errorMessage);
710             }
711         }
712     }
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
721  * @dev See https://eips.ethereum.org/EIPS/eip-721
722  */
723 interface IERC721Metadata is IERC721 {
724     /**
725      * @dev Returns the token collection name.
726      */
727     function name() external view returns (string memory);
728 
729     /**
730      * @dev Returns the token collection symbol.
731      */
732     function symbol() external view returns (string memory);
733 
734     /**
735      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
736      */
737     function tokenURI(uint256 tokenId) external view returns (string memory);
738 }
739 
740 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @title ERC721 token receiver interface
746  * @dev Interface for any contract that wants to support safeTransfers
747  * from ERC721 asset contracts.
748  */
749 interface IERC721Receiver {
750     /**
751      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
752      * by `operator` from `from`, this function is called.
753      *
754      * It must return its Solidity selector to confirm the token transfer.
755      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
756      *
757      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
758      */
759     function onERC721Received(
760         address operator,
761         address from,
762         uint256 tokenId,
763         bytes calldata data
764     ) external returns (bytes4);
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
774  * {ERC721Enumerable}.
775  */
776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to owner address
787     mapping(uint256 => address) private _owners;
788 
789     // Mapping owner address to token count
790     mapping(address => uint256) private _balances;
791 
792     // Mapping from token ID to approved address
793     mapping(uint256 => address) private _tokenApprovals;
794 
795     // Mapping from owner to operator approvals
796     mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798     /**
799      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
800      */
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId)
810         public
811         view
812         virtual
813         override(ERC165, IERC165)
814         returns (bool)
815     {
816         return
817             interfaceId == type(IERC721).interfaceId ||
818             interfaceId == type(IERC721Metadata).interfaceId ||
819             super.supportsInterface(interfaceId);
820     }
821 
822     /**
823      * @dev See {IERC721-balanceOf}.
824      */
825     function balanceOf(address owner)
826         public
827         view
828         virtual
829         override
830         returns (uint256)
831     {
832         require(
833             owner != address(0),
834             "ERC721: balance query for the zero address"
835         );
836         return _balances[owner];
837     }
838 
839     /**
840      * @dev See {IERC721-ownerOf}.
841      */
842     function ownerOf(uint256 tokenId)
843         public
844         view
845         virtual
846         override
847         returns (address)
848     {
849         address owner = _owners[tokenId];
850         require(
851             owner != address(0),
852             "ERC721: owner query for nonexistent token"
853         );
854         return owner;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-name}.
859      */
860     function name() public view virtual override returns (string memory) {
861         return _name;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-symbol}.
866      */
867     function symbol() public view virtual override returns (string memory) {
868         return _symbol;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-tokenURI}.
873      */
874     function tokenURI(uint256 tokenId)
875         public
876         view
877         virtual
878         override
879         returns (string memory)
880     {
881         require(
882             _exists(tokenId),
883             "ERC721Metadata: URI query for nonexistent token"
884         );
885 
886         string memory baseURI = _baseURI();
887         return
888             bytes(baseURI).length > 0
889                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
890                 : "";
891     }
892 
893     /**
894      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896      * by default, can be overriden in child contracts.
897      */
898     function _baseURI() internal view virtual returns (string memory) {
899         return "";
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public virtual override {
906         address owner = ERC721.ownerOf(tokenId);
907         require(to != owner, "ERC721: approval to current owner");
908 
909         require(
910             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
911             "ERC721: approve caller is not owner nor approved for all"
912         );
913 
914         _approve(to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId)
921         public
922         view
923         virtual
924         override
925         returns (address)
926     {
927         require(
928             _exists(tokenId),
929             "ERC721: approved query for nonexistent token"
930         );
931 
932         return _tokenApprovals[tokenId];
933     }
934 
935     /**
936      * @dev See {IERC721-setApprovalForAll}.
937      */
938     function setApprovalForAll(address operator, bool approved)
939         public
940         virtual
941         override
942     {
943         require(operator != _msgSender(), "ERC721: approve to caller");
944 
945         _operatorApprovals[_msgSender()][operator] = approved;
946         emit ApprovalForAll(_msgSender(), operator, approved);
947     }
948 
949     /**
950      * @dev See {IERC721-isApprovedForAll}.
951      */
952     function isApprovedForAll(address owner, address operator)
953         public
954         view
955         virtual
956         override
957         returns (bool)
958     {
959         return _operatorApprovals[owner][operator];
960     }
961 
962     /**
963      * @dev See {IERC721-transferFrom}.
964      */
965     function transferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         //solhint-disable-next-line max-line-length
971         require(
972             _isApprovedOrOwner(_msgSender(), tokenId),
973             "ERC721: transfer caller is not owner nor approved"
974         );
975 
976         _transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         safeTransferFrom(from, to, tokenId, "");
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) public virtual override {
999         require(
1000             _isApprovedOrOwner(_msgSender(), tokenId),
1001             "ERC721: transfer caller is not owner nor approved"
1002         );
1003         _safeTransfer(from, to, tokenId, _data);
1004     }
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1008      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1009      *
1010      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1011      *
1012      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1013      * implement alternative mechanisms to perform token transfer, such as signature-based.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must exist and be owned by `from`.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _safeTransfer(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) internal virtual {
1030         _transfer(from, to, tokenId);
1031         require(
1032             _checkOnERC721Received(from, to, tokenId, _data),
1033             "ERC721: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted (`_mint`),
1043      * and stop existing when they are burned (`_burn`).
1044      */
1045     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1046         return _owners[tokenId] != address(0);
1047     }
1048 
1049     /**
1050      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must exist.
1055      */
1056     function _isApprovedOrOwner(address spender, uint256 tokenId)
1057         internal
1058         view
1059         virtual
1060         returns (bool)
1061     {
1062         require(
1063             _exists(tokenId),
1064             "ERC721: operator query for nonexistent token"
1065         );
1066         address owner = ERC721.ownerOf(tokenId);
1067         return (spender == owner ||
1068             getApproved(tokenId) == spender ||
1069             isApprovedForAll(owner, spender));
1070     }
1071 
1072     /**
1073      * @dev Safely mints `tokenId` and transfers it to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(address to, uint256 tokenId) internal virtual {
1083         _safeMint(to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1088      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) internal virtual {
1095         _mint(to, tokenId);
1096         require(
1097             _checkOnERC721Received(address(0), to, tokenId, _data),
1098             "ERC721: transfer to non ERC721Receiver implementer"
1099         );
1100     }
1101 
1102     /**
1103      * @dev Mints `tokenId` and transfers it to `to`.
1104      *
1105      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must not exist.
1110      * - `to` cannot be the zero address.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(address to, uint256 tokenId) internal virtual {
1115         require(to != address(0), "ERC721: mint to the zero address");
1116         require(!_exists(tokenId), "ERC721: token already minted");
1117 
1118         _beforeTokenTransfer(address(0), to, tokenId);
1119 
1120         _balances[to] += 1;
1121         _owners[tokenId] = to;
1122 
1123         emit Transfer(address(0), to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Destroys `tokenId`.
1128      * The approval is cleared when the token is burned.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must exist.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _burn(uint256 tokenId) internal virtual {
1137         address owner = ERC721.ownerOf(tokenId);
1138 
1139         _beforeTokenTransfer(owner, address(0), tokenId);
1140 
1141         // Clear approvals
1142         _approve(address(0), tokenId);
1143 
1144         _balances[owner] -= 1;
1145         delete _owners[tokenId];
1146 
1147         emit Transfer(owner, address(0), tokenId);
1148     }
1149 
1150     /**
1151      * @dev Transfers `tokenId` from `from` to `to`.
1152      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _transfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {
1166         require(
1167             ERC721.ownerOf(tokenId) == from,
1168             "ERC721: transfer of token that is not own"
1169         );
1170         require(to != address(0), "ERC721: transfer to the zero address");
1171 
1172         _beforeTokenTransfer(from, to, tokenId);
1173 
1174         // Clear approvals from the previous owner
1175         _approve(address(0), tokenId);
1176 
1177         _balances[from] -= 1;
1178         _balances[to] += 1;
1179         _owners[tokenId] = to;
1180 
1181         emit Transfer(from, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Approve `to` to operate on `tokenId`
1186      *
1187      * Emits a {Approval} event.
1188      */
1189     function _approve(address to, uint256 tokenId) internal virtual {
1190         _tokenApprovals[tokenId] = to;
1191         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1196      * The call is not executed if the target address is not a contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         if (to.isContract()) {
1211             try
1212                 IERC721Receiver(to).onERC721Received(
1213                     _msgSender(),
1214                     from,
1215                     tokenId,
1216                     _data
1217                 )
1218             returns (bytes4 retval) {
1219                 return retval == IERC721Receiver(to).onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert(
1223                         "ERC721: transfer to non ERC721Receiver implementer"
1224                     );
1225                 } else {
1226                     assembly {
1227                         revert(add(32, reason), mload(reason))
1228                     }
1229                 }
1230             }
1231         } else {
1232             return true;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Hook that is called before any token transfer. This includes minting
1238      * and burning.
1239      *
1240      * Calling conditions:
1241      *
1242      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1243      * transferred to `to`.
1244      * - When `from` is zero, `tokenId` will be minted for `to`.
1245      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1246      * - `from` and `to` are never both zero.
1247      *
1248      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1249      */
1250     function _beforeTokenTransfer(
1251         address from,
1252         address to,
1253         uint256 tokenId
1254     ) internal virtual {}
1255 }
1256 
1257 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1263  * enumerability of all the token ids in the contract as well as all token ids owned by each
1264  * account.
1265  */
1266 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1267     // Mapping from owner to list of owned token IDs
1268     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1269 
1270     // Mapping from token ID to index of the owner tokens list
1271     mapping(uint256 => uint256) private _ownedTokensIndex;
1272 
1273     // Array with all token ids, used for enumeration
1274     uint256[] private _allTokens;
1275 
1276     // Mapping from token id to position in the allTokens array
1277     mapping(uint256 => uint256) private _allTokensIndex;
1278 
1279     /**
1280      * @dev See {IERC165-supportsInterface}.
1281      */
1282     function supportsInterface(bytes4 interfaceId)
1283         public
1284         view
1285         virtual
1286         override(IERC165, ERC721)
1287         returns (bool)
1288     {
1289         return
1290             interfaceId == type(IERC721Enumerable).interfaceId ||
1291             super.supportsInterface(interfaceId);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1296      */
1297     function tokenOfOwnerByIndex(address owner, uint256 index)
1298         public
1299         view
1300         virtual
1301         override
1302         returns (uint256)
1303     {
1304         require(
1305             index < ERC721.balanceOf(owner),
1306             "ERC721Enumerable: owner index out of bounds"
1307         );
1308         return _ownedTokens[owner][index];
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Enumerable-totalSupply}.
1313      */
1314     function totalSupply() public view virtual override returns (uint256) {
1315         return _allTokens.length;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Enumerable-tokenByIndex}.
1320      */
1321     function tokenByIndex(uint256 index)
1322         public
1323         view
1324         virtual
1325         override
1326         returns (uint256)
1327     {
1328         require(
1329             index < ERC721Enumerable.totalSupply(),
1330             "ERC721Enumerable: global index out of bounds"
1331         );
1332         return _allTokens[index];
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before any token transfer. This includes minting
1337      * and burning.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1345      * - `from` cannot be the zero address.
1346      * - `to` cannot be the zero address.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual override {
1355         super._beforeTokenTransfer(from, to, tokenId);
1356 
1357         if (from == address(0)) {
1358             _addTokenToAllTokensEnumeration(tokenId);
1359         } else if (from != to) {
1360             _removeTokenFromOwnerEnumeration(from, tokenId);
1361         }
1362         if (to == address(0)) {
1363             _removeTokenFromAllTokensEnumeration(tokenId);
1364         } else if (to != from) {
1365             _addTokenToOwnerEnumeration(to, tokenId);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1371      * @param to address representing the new owner of the given token ID
1372      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1373      */
1374     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1375         uint256 length = ERC721.balanceOf(to);
1376         _ownedTokens[to][length] = tokenId;
1377         _ownedTokensIndex[tokenId] = length;
1378     }
1379 
1380     /**
1381      * @dev Private function to add a token to this extension's token tracking data structures.
1382      * @param tokenId uint256 ID of the token to be added to the tokens list
1383      */
1384     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1385         _allTokensIndex[tokenId] = _allTokens.length;
1386         _allTokens.push(tokenId);
1387     }
1388 
1389     /**
1390      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1391      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1392      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1393      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1394      * @param from address representing the previous owner of the given token ID
1395      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1396      */
1397     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1398         private
1399     {
1400         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1401         // then delete the last slot (swap and pop).
1402 
1403         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1404         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1405 
1406         // When the token to delete is the last token, the swap operation is unnecessary
1407         if (tokenIndex != lastTokenIndex) {
1408             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1409 
1410             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1411             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1412         }
1413 
1414         // This also deletes the contents at the last position of the array
1415         delete _ownedTokensIndex[tokenId];
1416         delete _ownedTokens[from][lastTokenIndex];
1417     }
1418 
1419     /**
1420      * @dev Private function to remove a token from this extension's token tracking data structures.
1421      * This has O(1) time complexity, but alters the order of the _allTokens array.
1422      * @param tokenId uint256 ID of the token to be removed from the tokens list
1423      */
1424     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1425         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1426         // then delete the last slot (swap and pop).
1427 
1428         uint256 lastTokenIndex = _allTokens.length - 1;
1429         uint256 tokenIndex = _allTokensIndex[tokenId];
1430 
1431         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1432         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1433         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1434         uint256 lastTokenId = _allTokens[lastTokenIndex];
1435 
1436         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1437         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1438 
1439         // This also deletes the contents at the last position of the array
1440         delete _allTokensIndex[tokenId];
1441         _allTokens.pop();
1442     }
1443 }
1444 
1445 // File: NFTToken.sol
1446 // Project By: Coin Factory Inc
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 contract PsychoTeddy  is ERC721Enumerable, Ownable {
1451     using Counters for Counters.Counter;
1452     Counters.Counter private _tokenId;
1453 
1454     uint256 public MAX_SUPPlY = 8000;
1455     uint256 public PRESALE_SUPPLY = 2000;
1456     uint256 public MAX_ALLOWED = 20;
1457     uint256 public MAX_PRESALE_ALLOWED = 2;
1458     uint256 public price = 66600000000000000; //0.0666 Ether
1459 
1460     string baseTokenURI;
1461     bool public saleOpen = false;
1462     bool public presaleOpen = false;
1463 
1464     event NFTMinted(uint256 totalMinted);
1465 
1466     constructor(string memory baseURI) ERC721("Psycho Teddy", "TEDDY") {
1467         setBaseURI(baseURI);
1468     }
1469 
1470     //Get token Ids of all tokens owned by _owner
1471     function walletOfOwner(address _owner)
1472         external
1473         view
1474         returns (uint256[] memory)
1475     {
1476         uint256 tokenCount = balanceOf(_owner);
1477 
1478         uint256[] memory tokensId = new uint256[](tokenCount);
1479         for (uint256 i = 0; i < tokenCount; i++) {
1480             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1481         }
1482 
1483         return tokensId;
1484     }
1485 
1486     function setBaseURI(string memory baseURI) public onlyOwner {
1487         baseTokenURI = baseURI;
1488     }
1489 
1490     function setPrice(uint256 _newPrice) public onlyOwner {
1491         price = _newPrice;
1492     }
1493 
1494 
1495      //Close presale if open, open presale if closed
1496     function pausePreSale() public onlyOwner {
1497         presaleOpen = false;
1498     }
1499     
1500      //Close sale if open, open sale if closed
1501     function unpausePreSale() public onlyOwner {
1502         presaleOpen = true;
1503     }
1504     
1505     //Close sale if open, open sale if closed
1506     function pauseSale() public onlyOwner {
1507         saleOpen = false;
1508     }
1509     
1510      //Close sale if open, open sale if closed
1511     function unpauseSale() public onlyOwner {
1512         saleOpen = true;
1513     }
1514 
1515     function withdrawAll() public onlyOwner {
1516         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1517         require(success, "Transfer failed.");
1518     }
1519     
1520     
1521     //Presale mint NFT
1522     function presaleMintNFT(uint256 _count) public payable {
1523         if (msg.sender != owner()) {
1524             require(presaleOpen, "Preale is paused please try again later");
1525         }
1526         
1527         require(
1528             _count > 0 && _count <= MAX_PRESALE_ALLOWED,
1529             "Min 1 & Max 2 NFTs can be minted per transaction"
1530         );
1531         
1532         if (msg.sender != owner()) {
1533             require(
1534                 totalSupply() + _count <= (PRESALE_SUPPLY),
1535                 "All NFTs sold"
1536             );
1537         }else{
1538             require(
1539                 totalSupply() + _count <= (PRESALE_SUPPLY),
1540                 "All Presale NFTs sold"
1541             );
1542         }
1543         
1544         require(
1545             msg.value >= price * _count,
1546             "Ether sent with this transaction is not correct"
1547         );
1548 
1549         address _to = msg.sender;
1550 
1551         for (uint256 i = 0; i < _count; i++) {
1552             _mint(_to);
1553             
1554         }
1555     }
1556 
1557     //mint NFT
1558     function mintNFT(uint256 _count) public payable {
1559         if (msg.sender != owner()) {
1560             require(saleOpen, "Sale is paused please try again later");
1561         }
1562         
1563         require(
1564             _count > 0 && _count <= MAX_ALLOWED,
1565             "Min 1 & Max 20 NFTs can be minted per transaction"
1566         );
1567         
1568         if (msg.sender != owner()) {
1569             require(
1570                 totalSupply() + _count <= (MAX_SUPPlY),
1571                 "All NFTs sold"
1572             );
1573         }else{
1574             require(
1575                 totalSupply() + _count <= (MAX_SUPPlY),
1576                 "All NFTs sold"
1577             );
1578         }
1579         
1580         require(
1581             msg.value >= price * _count,
1582             "Ether sent with this transaction is not correct"
1583         );
1584 
1585         address _to = msg.sender;
1586 
1587         for (uint256 i = 0; i < _count; i++) {
1588             _mint(_to);
1589         }
1590     }
1591     
1592     function airdrop(address[] calldata _recipients) external onlyOwner {
1593         require(
1594             totalSupply() + _recipients.length <= (MAX_SUPPlY),
1595             "Airdrop minting will exceed maximum supply"
1596         );
1597         require(_recipients.length != 0, "Address not found for minting");
1598         for (uint256 i = 0; i < _recipients.length; i++) {
1599             require(_recipients[i] != address(0), "Minting to Null address");
1600             _mint(_recipients[i]);
1601         }
1602     }
1603 
1604     function _mint(address _to) private {
1605         _tokenId.increment();
1606         uint256 tokenId = _tokenId.current();
1607         _safeMint(_to, tokenId);
1608         emit NFTMinted(tokenId);
1609     }
1610 
1611     function _baseURI() internal view virtual override returns (string memory) {
1612         return baseTokenURI;
1613     }
1614     
1615 }