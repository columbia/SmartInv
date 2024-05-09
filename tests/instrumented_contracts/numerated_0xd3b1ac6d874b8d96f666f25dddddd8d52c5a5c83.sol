1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Context.sol
47 
48 pragma solidity ^0.8.0;
49 
50 /*
51  * @dev Provides information about the current execution context, including the
52  * sender of the transaction and its data. While these are generally available
53  * via msg.sender and msg.data, they should not be accessed in such a direct
54  * manner, since when dealing with meta-transactions the account sending and
55  * paying for execution may not be the actual sender (as far as an application
56  * is concerned).
57  *
58  * This contract is only required for intermediate, library-like contracts.
59  */
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Required interface of an ERC721 compliant contract.
101  */
102 interface IERC721 is IERC165 {
103     /**
104      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
105      */
106     event Transfer(
107         address indexed from,
108         address indexed to,
109         uint256 indexed tokenId
110     );
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(
116         address indexed owner,
117         address indexed approved,
118         uint256 indexed tokenId
119     );
120 
121     /**
122      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
123      */
124     event ApprovalForAll(
125         address indexed owner,
126         address indexed operator,
127         bool approved
128     );
129 
130     /**
131      * @dev Returns the number of tokens in ``owner``'s account.
132      */
133     function balanceOf(address owner) external view returns (uint256 balance);
134 
135     /**
136      * @dev Returns the owner of the `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function ownerOf(uint256 tokenId) external view returns (address owner);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
146      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId
162     ) external;
163 
164     /**
165      * @dev Transfers `tokenId` token from `from` to `to`.
166      *
167      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     /**
185      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
186      * The approval is cleared when the token is transferred.
187      *
188      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
189      *
190      * Requirements:
191      *
192      * - The caller must own the token or be an approved operator.
193      * - `tokenId` must exist.
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address to, uint256 tokenId) external;
198 
199     /**
200      * @dev Returns the account approved for `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function getApproved(uint256 tokenId)
207         external
208         view
209         returns (address operator);
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
225      *
226      * See {setApprovalForAll}
227      */
228     function isApprovedForAll(address owner, address operator)
229         external
230         view
231         returns (bool);
232 
233     /**
234      * @dev Safely transfers `tokenId` token from `from` to `to`.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must exist and be owned by `from`.
241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
243      *
244      * Emits a {Transfer} event.
245      */
246     function safeTransferFrom(
247         address from,
248         address to,
249         uint256 tokenId,
250         bytes calldata data
251     ) external;
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(
274         address indexed previousOwner,
275         address indexed newOwner
276     );
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor() {
282         _setOwner(_msgSender());
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view virtual returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @dev Leaves the contract without owner. It will not be possible to call
302      * `onlyOwner` functions anymore. Can only be called by the current owner.
303      *
304      * NOTE: Renouncing ownership will leave the contract without an owner,
305      * thereby removing any functionality that is only available to the owner.
306      */
307     function renounceOwnership() public virtual onlyOwner {
308         _setOwner(address(0));
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(
317             newOwner != address(0),
318             "Ownable: new owner is the zero address"
319         );
320         _setOwner(newOwner);
321     }
322 
323     function _setOwner(address newOwner) private {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
336  * @dev See https://eips.ethereum.org/EIPS/eip-721
337  */
338 interface IERC721Enumerable is IERC721 {
339     /**
340      * @dev Returns the total amount of tokens stored by the contract.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
346      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
347      */
348     function tokenOfOwnerByIndex(address owner, uint256 index)
349         external
350         view
351         returns (uint256 tokenId);
352 
353     /**
354      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
355      * Use along with {totalSupply} to enumerate all tokens.
356      */
357     function tokenByIndex(uint256 index) external view returns (uint256);
358 }
359 
360 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId)
383         public
384         view
385         virtual
386         override
387         returns (bool)
388     {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/utils/Strings.sol
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev String operations.
399  */
400 library Strings {
401     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
402 
403     /**
404      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
405      */
406     function toString(uint256 value) internal pure returns (string memory) {
407         // Inspired by OraclizeAPI's implementation - MIT licence
408         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
409 
410         if (value == 0) {
411             return "0";
412         }
413         uint256 temp = value;
414         uint256 digits;
415         while (temp != 0) {
416             digits++;
417             temp /= 10;
418         }
419         bytes memory buffer = new bytes(digits);
420         while (value != 0) {
421             digits -= 1;
422             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
423             value /= 10;
424         }
425         return string(buffer);
426     }
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
430      */
431     function toHexString(uint256 value) internal pure returns (string memory) {
432         if (value == 0) {
433             return "0x00";
434         }
435         uint256 temp = value;
436         uint256 length = 0;
437         while (temp != 0) {
438             length++;
439             temp >>= 8;
440         }
441         return toHexString(value, length);
442     }
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
446      */
447     function toHexString(uint256 value, uint256 length)
448         internal
449         pure
450         returns (string memory)
451     {
452         bytes memory buffer = new bytes(2 * length + 2);
453         buffer[0] = "0";
454         buffer[1] = "x";
455         for (uint256 i = 2 * length + 1; i > 1; --i) {
456             buffer[i] = _HEX_SYMBOLS[value & 0xf];
457             value >>= 4;
458         }
459         require(value == 0, "Strings: hex length insufficient");
460         return string(buffer);
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/Address.sol
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Collection of functions related to the address type
470  */
471 library Address {
472     /**
473      * @dev Returns true if `account` is a contract.
474      *
475      * [IMPORTANT]
476      * ====
477      * It is unsafe to assume that an address for which this function returns
478      * false is an externally-owned account (EOA) and not a contract.
479      *
480      * Among others, `isContract` will return false for the following
481      * types of addresses:
482      *
483      *  - an externally-owned account
484      *  - a contract in construction
485      *  - an address where a contract will be created
486      *  - an address where a contract lived, but was destroyed
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize, which returns 0 for contracts in
491         // construction, since the code is only stored at the end of the
492         // constructor execution.
493 
494         uint256 size;
495         assembly {
496             size := extcodesize(account)
497         }
498         return size > 0;
499     }
500 
501     /**
502      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
503      * `recipient`, forwarding all available gas and reverting on errors.
504      *
505      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
506      * of certain opcodes, possibly making contracts go over the 2300 gas limit
507      * imposed by `transfer`, making them unable to receive funds via
508      * `transfer`. {sendValue} removes this limitation.
509      *
510      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
511      *
512      * IMPORTANT: because control is transferred to `recipient`, care must be
513      * taken to not create reentrancy vulnerabilities. Consider using
514      * {ReentrancyGuard} or the
515      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
516      */
517     function sendValue(address payable recipient, uint256 amount) internal {
518         require(
519             address(this).balance >= amount,
520             "Address: insufficient balance"
521         );
522 
523         (bool success, ) = recipient.call{value: amount}("");
524         require(
525             success,
526             "Address: unable to send value, recipient may have reverted"
527         );
528     }
529 
530     /**
531      * @dev Performs a Solidity function call using a low level `call`. A
532      * plain `call` is an unsafe replacement for a function call: use this
533      * function instead.
534      *
535      * If `target` reverts with a revert reason, it is bubbled up by this
536      * function (like regular Solidity function calls).
537      *
538      * Returns the raw returned data. To convert to the expected return value,
539      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
540      *
541      * Requirements:
542      *
543      * - `target` must be a contract.
544      * - calling `target` with `data` must not revert.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(address target, bytes memory data)
549         internal
550         returns (bytes memory)
551     {
552         return functionCall(target, data, "Address: low-level call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
557      * `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, 0, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but also transferring `value` wei to `target`.
572      *
573      * Requirements:
574      *
575      * - the calling contract must have an ETH balance of at least `value`.
576      * - the called Solidity function must be `payable`.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value
584     ) internal returns (bytes memory) {
585         return
586             functionCallWithValue(
587                 target,
588                 data,
589                 value,
590                 "Address: low-level call with value failed"
591             );
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
596      * with `errorMessage` as a fallback revert reason when `target` reverts.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(
607             address(this).balance >= value,
608             "Address: insufficient balance for call"
609         );
610         require(isContract(target), "Address: call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.call{value: value}(
613             data
614         );
615         return _verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data)
625         internal
626         view
627         returns (bytes memory)
628     {
629         return
630             functionStaticCall(
631                 target,
632                 data,
633                 "Address: low-level static call failed"
634             );
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a static call.
640      *
641      * _Available since v3.3._
642      */
643     function functionStaticCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal view returns (bytes memory) {
648         require(isContract(target), "Address: static call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.staticcall(data);
651         return _verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a delegate call.
657      *
658      * _Available since v3.4._
659      */
660     function functionDelegateCall(address target, bytes memory data)
661         internal
662         returns (bytes memory)
663     {
664         return
665             functionDelegateCall(
666                 target,
667                 data,
668                 "Address: low-level delegate call failed"
669             );
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
674      * but performing a delegate call.
675      *
676      * _Available since v3.4._
677      */
678     function functionDelegateCall(
679         address target,
680         bytes memory data,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         require(isContract(target), "Address: delegate call to non-contract");
684 
685         (bool success, bytes memory returndata) = target.delegatecall(data);
686         return _verifyCallResult(success, returndata, errorMessage);
687     }
688 
689     function _verifyCallResult(
690         bool success,
691         bytes memory returndata,
692         string memory errorMessage
693     ) private pure returns (bytes memory) {
694         if (success) {
695             return returndata;
696         } else {
697             // Look for revert reason and bubble it up if present
698             if (returndata.length > 0) {
699                 // The easiest way to bubble the revert reason is using memory via assembly
700 
701                 assembly {
702                     let returndata_size := mload(returndata)
703                     revert(add(32, returndata), returndata_size)
704                 }
705             } else {
706                 revert(errorMessage);
707             }
708         }
709     }
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Metadata is IERC721 {
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() external view returns (string memory);
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() external view returns (string memory);
730 
731     /**
732      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
733      */
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @title ERC721 token receiver interface
743  * @dev Interface for any contract that wants to support safeTransfers
744  * from ERC721 asset contracts.
745  */
746 interface IERC721Receiver {
747     /**
748      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
749      * by `operator` from `from`, this function is called.
750      *
751      * It must return its Solidity selector to confirm the token transfer.
752      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
753      *
754      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
755      */
756     function onERC721Received(
757         address operator,
758         address from,
759         uint256 tokenId,
760         bytes calldata data
761     ) external returns (bytes4);
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
765 
766 pragma solidity ^0.8.0;
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata extension, but not including the Enumerable extension, which is available separately as
771  * {ERC721Enumerable}.
772  */
773 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
774     using Address for address;
775     using Strings for uint256;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to owner address
784     mapping(uint256 => address) private _owners;
785 
786     // Mapping owner address to token count
787     mapping(address => uint256) private _balances;
788 
789     // Mapping from token ID to approved address
790     mapping(uint256 => address) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     /**
796      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
797      */
798     constructor(string memory name_, string memory symbol_) {
799         _name = name_;
800         _symbol = symbol_;
801     }
802 
803     /**
804      * @dev See {IERC165-supportsInterface}.
805      */
806     function supportsInterface(bytes4 interfaceId)
807         public
808         view
809         virtual
810         override(ERC165, IERC165)
811         returns (bool)
812     {
813         return
814             interfaceId == type(IERC721).interfaceId ||
815             interfaceId == type(IERC721Metadata).interfaceId ||
816             super.supportsInterface(interfaceId);
817     }
818 
819     /**
820      * @dev See {IERC721-balanceOf}.
821      */
822     function balanceOf(address owner)
823         public
824         view
825         virtual
826         override
827         returns (uint256)
828     {
829         require(
830             owner != address(0),
831             "ERC721: balance query for the zero address"
832         );
833         return _balances[owner];
834     }
835 
836     /**
837      * @dev See {IERC721-ownerOf}.
838      */
839     function ownerOf(uint256 tokenId)
840         public
841         view
842         virtual
843         override
844         returns (address)
845     {
846         address owner = _owners[tokenId];
847         require(
848             owner != address(0),
849             "ERC721: owner query for nonexistent token"
850         );
851         return owner;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId)
872         public
873         view
874         virtual
875         override
876         returns (string memory)
877     {
878         require(
879             _exists(tokenId),
880             "ERC721Metadata: URI query for nonexistent token"
881         );
882 
883         string memory baseURI = _baseURI();
884         return
885             bytes(baseURI).length > 0
886                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
887                 : "";
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return "";
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ERC721.ownerOf(tokenId);
904         require(to != owner, "ERC721: approval to current owner");
905 
906         require(
907             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
908             "ERC721: approve caller is not owner nor approved for all"
909         );
910 
911         _approve(to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId)
918         public
919         view
920         virtual
921         override
922         returns (address)
923     {
924         require(
925             _exists(tokenId),
926             "ERC721: approved query for nonexistent token"
927         );
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved)
936         public
937         virtual
938         override
939     {
940         require(operator != _msgSender(), "ERC721: approve to caller");
941 
942         _operatorApprovals[_msgSender()][operator] = approved;
943         emit ApprovalForAll(_msgSender(), operator, approved);
944     }
945 
946     /**
947      * @dev See {IERC721-isApprovedForAll}.
948      */
949     function isApprovedForAll(address owner, address operator)
950         public
951         view
952         virtual
953         override
954         returns (bool)
955     {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev See {IERC721-transferFrom}.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public virtual override {
967         //solhint-disable-next-line max-line-length
968         require(
969             _isApprovedOrOwner(_msgSender(), tokenId),
970             "ERC721: transfer caller is not owner nor approved"
971         );
972 
973         _transfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         safeTransferFrom(from, to, tokenId, "");
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public virtual override {
996         require(
997             _isApprovedOrOwner(_msgSender(), tokenId),
998             "ERC721: transfer caller is not owner nor approved"
999         );
1000         _safeTransfer(from, to, tokenId, _data);
1001     }
1002 
1003     /**
1004      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1005      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1006      *
1007      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1008      *
1009      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1010      * implement alternative mechanisms to perform token transfer, such as signature-based.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must exist and be owned by `from`.
1017      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _safeTransfer(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) internal virtual {
1027         _transfer(from, to, tokenId);
1028         require(
1029             _checkOnERC721Received(from, to, tokenId, _data),
1030             "ERC721: transfer to non ERC721Receiver implementer"
1031         );
1032     }
1033 
1034     /**
1035      * @dev Returns whether `tokenId` exists.
1036      *
1037      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1038      *
1039      * Tokens start existing when they are minted (`_mint`),
1040      * and stop existing when they are burned (`_burn`).
1041      */
1042     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1043         return _owners[tokenId] != address(0);
1044     }
1045 
1046     /**
1047      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      */
1053     function _isApprovedOrOwner(address spender, uint256 tokenId)
1054         internal
1055         view
1056         virtual
1057         returns (bool)
1058     {
1059         require(
1060             _exists(tokenId),
1061             "ERC721: operator query for nonexistent token"
1062         );
1063         address owner = ERC721.ownerOf(tokenId);
1064         return (spender == owner ||
1065             getApproved(tokenId) == spender ||
1066             isApprovedForAll(owner, spender));
1067     }
1068 
1069     /**
1070      * @dev Safely mints `tokenId` and transfers it to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must not exist.
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(address to, uint256 tokenId) internal virtual {
1080         _safeMint(to, tokenId, "");
1081     }
1082 
1083     /**
1084      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1085      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) internal virtual {
1092         _mint(to, tokenId);
1093         require(
1094             _checkOnERC721Received(address(0), to, tokenId, _data),
1095             "ERC721: transfer to non ERC721Receiver implementer"
1096         );
1097     }
1098 
1099     /**
1100      * @dev Mints `tokenId` and transfers it to `to`.
1101      *
1102      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must not exist.
1107      * - `to` cannot be the zero address.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(address to, uint256 tokenId) internal virtual {
1112         require(to != address(0), "ERC721: mint to the zero address");
1113         require(!_exists(tokenId), "ERC721: token already minted");
1114 
1115         _beforeTokenTransfer(address(0), to, tokenId);
1116 
1117         _balances[to] += 1;
1118         _owners[tokenId] = to;
1119 
1120         emit Transfer(address(0), to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Destroys `tokenId`.
1125      * The approval is cleared when the token is burned.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _burn(uint256 tokenId) internal virtual {
1134         address owner = ERC721.ownerOf(tokenId);
1135 
1136         _beforeTokenTransfer(owner, address(0), tokenId);
1137 
1138         // Clear approvals
1139         _approve(address(0), tokenId);
1140 
1141         _balances[owner] -= 1;
1142         delete _owners[tokenId];
1143 
1144         emit Transfer(owner, address(0), tokenId);
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal virtual {
1163         require(
1164             ERC721.ownerOf(tokenId) == from,
1165             "ERC721: transfer of token that is not own"
1166         );
1167         require(to != address(0), "ERC721: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(from, to, tokenId);
1170 
1171         // Clear approvals from the previous owner
1172         _approve(address(0), tokenId);
1173 
1174         _balances[from] -= 1;
1175         _balances[to] += 1;
1176         _owners[tokenId] = to;
1177 
1178         emit Transfer(from, to, tokenId);
1179     }
1180 
1181     /**
1182      * @dev Approve `to` to operate on `tokenId`
1183      *
1184      * Emits a {Approval} event.
1185      */
1186     function _approve(address to, uint256 tokenId) internal virtual {
1187         _tokenApprovals[tokenId] = to;
1188         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193      * The call is not executed if the target address is not a contract.
1194      *
1195      * @param from address representing the previous owner of the given token ID
1196      * @param to target address that will receive the tokens
1197      * @param tokenId uint256 ID of the token to be transferred
1198      * @param _data bytes optional data to send along with the call
1199      * @return bool whether the call correctly returned the expected magic value
1200      */
1201     function _checkOnERC721Received(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) private returns (bool) {
1207         if (to.isContract()) {
1208             try
1209                 IERC721Receiver(to).onERC721Received(
1210                     _msgSender(),
1211                     from,
1212                     tokenId,
1213                     _data
1214                 )
1215             returns (bytes4 retval) {
1216                 return retval == IERC721Receiver(to).onERC721Received.selector;
1217             } catch (bytes memory reason) {
1218                 if (reason.length == 0) {
1219                     revert(
1220                         "ERC721: transfer to non ERC721Receiver implementer"
1221                     );
1222                 } else {
1223                     assembly {
1224                         revert(add(32, reason), mload(reason))
1225                     }
1226                 }
1227             }
1228         } else {
1229             return true;
1230         }
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before any token transfer. This includes minting
1235      * and burning.
1236      *
1237      * Calling conditions:
1238      *
1239      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1240      * transferred to `to`.
1241      * - When `from` is zero, `tokenId` will be minted for `to`.
1242      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1243      * - `from` and `to` are never both zero.
1244      *
1245      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1246      */
1247     function _beforeTokenTransfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) internal virtual {}
1252 }
1253 
1254 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1260  * enumerability of all the token ids in the contract as well as all token ids owned by each
1261  * account.
1262  */
1263 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1264     // Mapping from owner to list of owned token IDs
1265     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1266 
1267     // Mapping from token ID to index of the owner tokens list
1268     mapping(uint256 => uint256) private _ownedTokensIndex;
1269 
1270     // Array with all token ids, used for enumeration
1271     uint256[] private _allTokens;
1272 
1273     // Mapping from token id to position in the allTokens array
1274     mapping(uint256 => uint256) private _allTokensIndex;
1275 
1276     /**
1277      * @dev See {IERC165-supportsInterface}.
1278      */
1279     function supportsInterface(bytes4 interfaceId)
1280         public
1281         view
1282         virtual
1283         override(IERC165, ERC721)
1284         returns (bool)
1285     {
1286         return
1287             interfaceId == type(IERC721Enumerable).interfaceId ||
1288             super.supportsInterface(interfaceId);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1293      */
1294     function tokenOfOwnerByIndex(address owner, uint256 index)
1295         public
1296         view
1297         virtual
1298         override
1299         returns (uint256)
1300     {
1301         require(
1302             index < ERC721.balanceOf(owner),
1303             "ERC721Enumerable: owner index out of bounds"
1304         );
1305         return _ownedTokens[owner][index];
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Enumerable-totalSupply}.
1310      */
1311     function totalSupply() public view virtual override returns (uint256) {
1312         return _allTokens.length;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Enumerable-tokenByIndex}.
1317      */
1318     function tokenByIndex(uint256 index)
1319         public
1320         view
1321         virtual
1322         override
1323         returns (uint256)
1324     {
1325         require(
1326             index < ERC721Enumerable.totalSupply(),
1327             "ERC721Enumerable: global index out of bounds"
1328         );
1329         return _allTokens[index];
1330     }
1331 
1332     /**
1333      * @dev Hook that is called before any token transfer. This includes minting
1334      * and burning.
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1342      * - `from` cannot be the zero address.
1343      * - `to` cannot be the zero address.
1344      *
1345      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1346      */
1347     function _beforeTokenTransfer(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) internal virtual override {
1352         super._beforeTokenTransfer(from, to, tokenId);
1353 
1354         if (from == address(0)) {
1355             _addTokenToAllTokensEnumeration(tokenId);
1356         } else if (from != to) {
1357             _removeTokenFromOwnerEnumeration(from, tokenId);
1358         }
1359         if (to == address(0)) {
1360             _removeTokenFromAllTokensEnumeration(tokenId);
1361         } else if (to != from) {
1362             _addTokenToOwnerEnumeration(to, tokenId);
1363         }
1364     }
1365 
1366     /**
1367      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1368      * @param to address representing the new owner of the given token ID
1369      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1370      */
1371     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1372         uint256 length = ERC721.balanceOf(to);
1373         _ownedTokens[to][length] = tokenId;
1374         _ownedTokensIndex[tokenId] = length;
1375     }
1376 
1377     /**
1378      * @dev Private function to add a token to this extension's token tracking data structures.
1379      * @param tokenId uint256 ID of the token to be added to the tokens list
1380      */
1381     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1382         _allTokensIndex[tokenId] = _allTokens.length;
1383         _allTokens.push(tokenId);
1384     }
1385 
1386     /**
1387      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1388      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1389      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1390      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1391      * @param from address representing the previous owner of the given token ID
1392      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1393      */
1394     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1395         private
1396     {
1397         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1398         // then delete the last slot (swap and pop).
1399 
1400         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1401         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1402 
1403         // When the token to delete is the last token, the swap operation is unnecessary
1404         if (tokenIndex != lastTokenIndex) {
1405             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1406 
1407             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1408             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1409         }
1410 
1411         // This also deletes the contents at the last position of the array
1412         delete _ownedTokensIndex[tokenId];
1413         delete _ownedTokens[from][lastTokenIndex];
1414     }
1415 
1416     /**
1417      * @dev Private function to remove a token from this extension's token tracking data structures.
1418      * This has O(1) time complexity, but alters the order of the _allTokens array.
1419      * @param tokenId uint256 ID of the token to be removed from the tokens list
1420      */
1421     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1422         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1423         // then delete the last slot (swap and pop).
1424 
1425         uint256 lastTokenIndex = _allTokens.length - 1;
1426         uint256 tokenIndex = _allTokensIndex[tokenId];
1427 
1428         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1429         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1430         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1431         uint256 lastTokenId = _allTokens[lastTokenIndex];
1432 
1433         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1434         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1435 
1436         // This also deletes the contents at the last position of the array
1437         delete _allTokensIndex[tokenId];
1438         _allTokens.pop();
1439     }
1440 }
1441 
1442 // File: TheYogi.sol
1443 
1444 pragma solidity ^0.8.0;
1445 
1446 /// @author Hammad Ghazi
1447 contract TheYogi is ERC721Enumerable, Ownable {
1448     using Counters for Counters.Counter;
1449     Counters.Counter private _tokenId;
1450 
1451     uint256 public constant MAX_YOGI = 3333;
1452     uint256 public price = 30000000000000000; //0.03 Ether
1453     string baseTokenURI;
1454     bool public saleOpen = false;
1455 
1456     event TheYogiMinted(uint256 totalMinted);
1457 
1458     constructor(string memory baseURI) ERC721("TheYogi", "YOGI") {
1459         setBaseURI(baseURI);
1460     }
1461 
1462     //Get token Ids of all tokens owned by _owner
1463     function walletOfOwner(address _owner)
1464         external
1465         view
1466         returns (uint256[] memory)
1467     {
1468         uint256 tokenCount = balanceOf(_owner);
1469 
1470         uint256[] memory tokensId = new uint256[](tokenCount);
1471         for (uint256 i = 0; i < tokenCount; i++) {
1472             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1473         }
1474 
1475         return tokensId;
1476     }
1477 
1478     function setBaseURI(string memory baseURI) public onlyOwner {
1479         baseTokenURI = baseURI;
1480     }
1481 
1482     function setPrice(uint256 _newPrice) external onlyOwner {
1483         price = _newPrice;
1484     }
1485 
1486     //Close sale if open, open sale if closed
1487     function flipSaleState() external onlyOwner {
1488         saleOpen = !saleOpen;
1489     }
1490 
1491     function withdrawAll() external onlyOwner {
1492         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1493         require(success, "Transfer failed.");
1494     }
1495 
1496     //mint TheYogi
1497     function mintTheYogi(address _to, uint256 _count) external payable {
1498         require(
1499             totalSupply() + _count <= MAX_YOGI,
1500             "Exceeds maximum supply of TheYogi"
1501         );
1502         require(
1503             _count > 0,
1504             "Minimum 1 TheYogi has to be minted per transaction"
1505         );
1506         if (msg.sender != owner()) {
1507             require(saleOpen, "Sale is not open yet");
1508             require(
1509                 _count <= 25,
1510                 "Maximum 25 TheYogi can be minted per transaction"
1511             );
1512             require(
1513                 msg.value >= price * _count,
1514                 "Ether sent with this transaction is not correct"
1515             );
1516         }
1517 
1518         for (uint256 i = 0; i < _count; i++) {
1519             _mint(_to);
1520         }
1521     }
1522 
1523     function _mint(address _to) private {
1524         _tokenId.increment();
1525         uint256 tokenId = _tokenId.current();
1526         _safeMint(_to, tokenId);
1527         emit TheYogiMinted(tokenId);
1528     }
1529 
1530     function _baseURI() internal view virtual override returns (string memory) {
1531         return baseTokenURI;
1532     }
1533 }