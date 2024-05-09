1 // SPDX-License-Identifier: MIT
2 // Author : iblockchainer (Telegram)
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
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
46 
47 // File: @openzeppelin/contracts/utils/Context.sol
48 
49 pragma solidity ^0.8.0;
50 
51 /*
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Interface of the ERC165 standard, as defined in the
77  * https://eips.ethereum.org/EIPS/eip-165[EIP].
78  *
79  * Implementers can declare support of contract interfaces, which can then be
80  * queried by others ({ERC165Checker}).
81  *
82  * For an implementation, see {ERC165}.
83  */
84 interface IERC165 {
85     /**
86      * @dev Returns true if this contract implements the interface defined by
87      * `interfaceId`. See the corresponding
88      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
89      * to learn more about how these ids are created.
90      *
91      * This function call must use less than 30 000 gas.
92      */
93     function supportsInterface(bytes4 interfaceId) external view returns (bool);
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Required interface of an ERC721 compliant contract.
102  */
103 interface IERC721 is IERC165 {
104     /**
105      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
106      */
107     event Transfer(
108         address indexed from,
109         address indexed to,
110         uint256 indexed tokenId
111     );
112 
113     /**
114      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
115      */
116     event Approval(
117         address indexed owner,
118         address indexed approved,
119         uint256 indexed tokenId
120     );
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(
126         address indexed owner,
127         address indexed operator,
128         bool approved
129     );
130 
131     /**
132      * @dev Returns the number of tokens in ``owner``'s account.
133      */
134     function balanceOf(address owner) external view returns (uint256 balance);
135 
136     /**
137      * @dev Returns the owner of the `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function ownerOf(uint256 tokenId) external view returns (address owner);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
147      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId
163     ) external;
164 
165     /**
166      * @dev Transfers `tokenId` token from `from` to `to`.
167      *
168      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
187      * The approval is cleared when the token is transferred.
188      *
189      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
190      *
191      * Requirements:
192      *
193      * - The caller must own the token or be an approved operator.
194      * - `tokenId` must exist.
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address to, uint256 tokenId) external;
199 
200     /**
201      * @dev Returns the account approved for `tokenId` token.
202      *
203      * Requirements:
204      *
205      * - `tokenId` must exist.
206      */
207     function getApproved(uint256 tokenId)
208         external
209         view
210         returns (address operator);
211 
212     /**
213      * @dev Approve or remove `operator` as an operator for the caller.
214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
215      *
216      * Requirements:
217      *
218      * - The `operator` cannot be the caller.
219      *
220      * Emits an {ApprovalForAll} event.
221      */
222     function setApprovalForAll(address operator, bool _approved) external;
223 
224     /**
225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
226      *
227      * See {setApprovalForAll}
228      */
229     function isApprovedForAll(address owner, address operator)
230         external
231         view
232         returns (bool);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId,
251         bytes calldata data
252     ) external;
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(
275         address indexed previousOwner,
276         address indexed newOwner
277     );
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _setOwner(_msgSender());
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _setOwner(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(
318             newOwner != address(0),
319             "Ownable: new owner is the zero address"
320         );
321         _setOwner(newOwner);
322     }
323 
324     function _setOwner(address newOwner) private {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
337  * @dev See https://eips.ethereum.org/EIPS/eip-721
338  */
339 interface IERC721Enumerable is IERC721 {
340     /**
341      * @dev Returns the total amount of tokens stored by the contract.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     /**
346      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
347      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
348      */
349     function tokenOfOwnerByIndex(address owner, uint256 index)
350         external
351         view
352         returns (uint256 tokenId);
353 
354     /**
355      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
356      * Use along with {totalSupply} to enumerate all tokens.
357      */
358     function tokenByIndex(uint256 index) external view returns (uint256);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Implementation of the {IERC165} interface.
367  *
368  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
369  * for the additional interface id that will be supported. For example:
370  *
371  * ```solidity
372  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
373  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
374  * }
375  * ```
376  *
377  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
378  */
379 abstract contract ERC165 is IERC165 {
380     /**
381      * @dev See {IERC165-supportsInterface}.
382      */
383     function supportsInterface(bytes4 interfaceId)
384         public
385         view
386         virtual
387         override
388         returns (bool)
389     {
390         return interfaceId == type(IERC165).interfaceId;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/utils/Strings.sol
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev String operations.
400  */
401 library Strings {
402     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
403 
404     /**
405      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
406      */
407     function toString(uint256 value) internal pure returns (string memory) {
408         // Inspired by OraclizeAPI's implementation - MIT licence
409         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
410 
411         if (value == 0) {
412             return "0";
413         }
414         uint256 temp = value;
415         uint256 digits;
416         while (temp != 0) {
417             digits++;
418             temp /= 10;
419         }
420         bytes memory buffer = new bytes(digits);
421         while (value != 0) {
422             digits -= 1;
423             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
424             value /= 10;
425         }
426         return string(buffer);
427     }
428 
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
431      */
432     function toHexString(uint256 value) internal pure returns (string memory) {
433         if (value == 0) {
434             return "0x00";
435         }
436         uint256 temp = value;
437         uint256 length = 0;
438         while (temp != 0) {
439             length++;
440             temp >>= 8;
441         }
442         return toHexString(value, length);
443     }
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
447      */
448     function toHexString(uint256 value, uint256 length)
449         internal
450         pure
451         returns (string memory)
452     {
453         bytes memory buffer = new bytes(2 * length + 2);
454         buffer[0] = "0";
455         buffer[1] = "x";
456         for (uint256 i = 2 * length + 1; i > 1; --i) {
457             buffer[i] = _HEX_SYMBOLS[value & 0xf];
458             value >>= 4;
459         }
460         require(value == 0, "Strings: hex length insufficient");
461         return string(buffer);
462     }
463 }
464 
465 // File: @openzeppelin/contracts/utils/Address.sol
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Collection of functions related to the address type
471  */
472 library Address {
473     /**
474      * @dev Returns true if `account` is a contract.
475      *
476      * [IMPORTANT]
477      * ====
478      * It is unsafe to assume that an address for which this function returns
479      * false is an externally-owned account (EOA) and not a contract.
480      *
481      * Among others, `isContract` will return false for the following
482      * types of addresses:
483      *
484      *  - an externally-owned account
485      *  - a contract in construction
486      *  - an address where a contract will be created
487      *  - an address where a contract lived, but was destroyed
488      * ====
489      */
490     function isContract(address account) internal view returns (bool) {
491         // This method relies on extcodesize, which returns 0 for contracts in
492         // construction, since the code is only stored at the end of the
493         // constructor execution.
494 
495         uint256 size;
496         assembly {
497             size := extcodesize(account)
498         }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * IMPORTANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(
520             address(this).balance >= amount,
521             "Address: insufficient balance"
522         );
523 
524         (bool success, ) = recipient.call{value: amount}("");
525         require(
526             success,
527             "Address: unable to send value, recipient may have reverted"
528         );
529     }
530 
531     /**
532      * @dev Performs a Solidity function call using a low level `call`. A
533      * plain `call` is an unsafe replacement for a function call: use this
534      * function instead.
535      *
536      * If `target` reverts with a revert reason, it is bubbled up by this
537      * function (like regular Solidity function calls).
538      *
539      * Returns the raw returned data. To convert to the expected return value,
540      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
541      *
542      * Requirements:
543      *
544      * - `target` must be a contract.
545      * - calling `target` with `data` must not revert.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data)
550         internal
551         returns (bytes memory)
552     {
553         return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, 0, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but also transferring `value` wei to `target`.
573      *
574      * Requirements:
575      *
576      * - the calling contract must have an ETH balance of at least `value`.
577      * - the called Solidity function must be `payable`.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value
585     ) internal returns (bytes memory) {
586         return
587             functionCallWithValue(
588                 target,
589                 data,
590                 value,
591                 "Address: low-level call with value failed"
592             );
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(
608             address(this).balance >= value,
609             "Address: insufficient balance for call"
610         );
611         require(isContract(target), "Address: call to non-contract");
612 
613         (bool success, bytes memory returndata) = target.call{value: value}(
614             data
615         );
616         return _verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a static call.
622      *
623      * _Available since v3.3._
624      */
625     function functionStaticCall(address target, bytes memory data)
626         internal
627         view
628         returns (bytes memory)
629     {
630         return
631             functionStaticCall(
632                 target,
633                 data,
634                 "Address: low-level static call failed"
635             );
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.staticcall(data);
652         return _verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(address target, bytes memory data)
662         internal
663         returns (bytes memory)
664     {
665         return
666             functionDelegateCall(
667                 target,
668                 data,
669                 "Address: low-level delegate call failed"
670             );
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(
680         address target,
681         bytes memory data,
682         string memory errorMessage
683     ) internal returns (bytes memory) {
684         require(isContract(target), "Address: delegate call to non-contract");
685 
686         (bool success, bytes memory returndata) = target.delegatecall(data);
687         return _verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     function _verifyCallResult(
691         bool success,
692         bytes memory returndata,
693         string memory errorMessage
694     ) private pure returns (bytes memory) {
695         if (success) {
696             return returndata;
697         } else {
698             // Look for revert reason and bubble it up if present
699             if (returndata.length > 0) {
700                 // The easiest way to bubble the revert reason is using memory via assembly
701 
702                 assembly {
703                     let returndata_size := mload(returndata)
704                     revert(add(32, returndata), returndata_size)
705                 }
706             } else {
707                 revert(errorMessage);
708             }
709         }
710     }
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 pragma solidity ^0.8.0;
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @title ERC721 token receiver interface
744  * @dev Interface for any contract that wants to support safeTransfers
745  * from ERC721 asset contracts.
746  */
747 interface IERC721Receiver {
748     /**
749      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
750      * by `operator` from `from`, this function is called.
751      *
752      * It must return its Solidity selector to confirm the token transfer.
753      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
754      *
755      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
756      */
757     function onERC721Received(
758         address operator,
759         address from,
760         uint256 tokenId,
761         bytes calldata data
762     ) external returns (bytes4);
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
771  * the Metadata extension, but not including the Enumerable extension, which is available separately as
772  * {ERC721Enumerable}.
773  */
774 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
775     using Address for address;
776     using Strings for uint256;
777 
778     // Token name
779     string private _name;
780 
781     // Token symbol
782     string private _symbol;
783 
784     // Mapping from token ID to owner address
785     mapping(uint256 => address) private _owners;
786 
787     // Mapping owner address to token count
788     mapping(address => uint256) private _balances;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     /**
797      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
798      */
799     constructor(string memory name_, string memory symbol_) {
800         _name = name_;
801         _symbol = symbol_;
802     }
803 
804     /**
805      * @dev See {IERC165-supportsInterface}.
806      */
807     function supportsInterface(bytes4 interfaceId)
808         public
809         view
810         virtual
811         override(ERC165, IERC165)
812         returns (bool)
813     {
814         return
815             interfaceId == type(IERC721).interfaceId ||
816             interfaceId == type(IERC721Metadata).interfaceId ||
817             super.supportsInterface(interfaceId);
818     }
819 
820     /**
821      * @dev See {IERC721-balanceOf}.
822      */
823     function balanceOf(address owner)
824         public
825         view
826         virtual
827         override
828         returns (uint256)
829     {
830         require(
831             owner != address(0),
832             "ERC721: balance query for the zero address"
833         );
834         return _balances[owner];
835     }
836 
837     /**
838      * @dev See {IERC721-ownerOf}.
839      */
840     function ownerOf(uint256 tokenId)
841         public
842         view
843         virtual
844         override
845         returns (address)
846     {
847         address owner = _owners[tokenId];
848         require(
849             owner != address(0),
850             "ERC721: owner query for nonexistent token"
851         );
852         return owner;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId)
873         public
874         view
875         virtual
876         override
877         returns (string memory)
878     {
879         require(
880             _exists(tokenId),
881             "ERC721Metadata: URI query for nonexistent token"
882         );
883 
884         string memory baseURI = _baseURI();
885         return
886             bytes(baseURI).length > 0
887                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
888                 : "";
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, can be overriden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return "";
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public virtual override {
904         address owner = ERC721.ownerOf(tokenId);
905         require(to != owner, "ERC721: approval to current owner");
906 
907         require(
908             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
909             "ERC721: approve caller is not owner nor approved for all"
910         );
911 
912         _approve(to, tokenId);
913     }
914 
915     /**
916      * @dev See {IERC721-getApproved}.
917      */
918     function getApproved(uint256 tokenId)
919         public
920         view
921         virtual
922         override
923         returns (address)
924     {
925         require(
926             _exists(tokenId),
927             "ERC721: approved query for nonexistent token"
928         );
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     /**
934      * @dev See {IERC721-setApprovalForAll}.
935      */
936     function setApprovalForAll(address operator, bool approved)
937         public
938         virtual
939         override
940     {
941         require(operator != _msgSender(), "ERC721: approve to caller");
942 
943         _operatorApprovals[_msgSender()][operator] = approved;
944         emit ApprovalForAll(_msgSender(), operator, approved);
945     }
946 
947     /**
948      * @dev See {IERC721-isApprovedForAll}.
949      */
950     function isApprovedForAll(address owner, address operator)
951         public
952         view
953         virtual
954         override
955         returns (bool)
956     {
957         return _operatorApprovals[owner][operator];
958     }
959 
960     /**
961      * @dev See {IERC721-transferFrom}.
962      */
963     function transferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         //solhint-disable-next-line max-line-length
969         require(
970             _isApprovedOrOwner(_msgSender(), tokenId),
971             "ERC721: transfer caller is not owner nor approved"
972         );
973 
974         _transfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId
984     ) public virtual override {
985         safeTransferFrom(from, to, tokenId, "");
986     }
987 
988     /**
989      * @dev See {IERC721-safeTransferFrom}.
990      */
991     function safeTransferFrom(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) public virtual override {
997         require(
998             _isApprovedOrOwner(_msgSender(), tokenId),
999             "ERC721: transfer caller is not owner nor approved"
1000         );
1001         _safeTransfer(from, to, tokenId, _data);
1002     }
1003 
1004     /**
1005      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1006      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1007      *
1008      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1009      *
1010      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1011      * implement alternative mechanisms to perform token transfer, such as signature-based.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must exist and be owned by `from`.
1018      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _safeTransfer(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) internal virtual {
1028         _transfer(from, to, tokenId);
1029         require(
1030             _checkOnERC721Received(from, to, tokenId, _data),
1031             "ERC721: transfer to non ERC721Receiver implementer"
1032         );
1033     }
1034 
1035     /**
1036      * @dev Returns whether `tokenId` exists.
1037      *
1038      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1039      *
1040      * Tokens start existing when they are minted (`_mint`),
1041      * and stop existing when they are burned (`_burn`).
1042      */
1043     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1044         return _owners[tokenId] != address(0);
1045     }
1046 
1047     /**
1048      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function _isApprovedOrOwner(address spender, uint256 tokenId)
1055         internal
1056         view
1057         virtual
1058         returns (bool)
1059     {
1060         require(
1061             _exists(tokenId),
1062             "ERC721: operator query for nonexistent token"
1063         );
1064         address owner = ERC721.ownerOf(tokenId);
1065         return (spender == owner ||
1066             getApproved(tokenId) == spender ||
1067             isApprovedForAll(owner, spender));
1068     }
1069 
1070     /**
1071      * @dev Safely mints `tokenId` and transfers it to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must not exist.
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(address to, uint256 tokenId) internal virtual {
1081         _safeMint(to, tokenId, "");
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1086      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) internal virtual {
1093         _mint(to, tokenId);
1094         require(
1095             _checkOnERC721Received(address(0), to, tokenId, _data),
1096             "ERC721: transfer to non ERC721Receiver implementer"
1097         );
1098     }
1099 
1100     /**
1101      * @dev Mints `tokenId` and transfers it to `to`.
1102      *
1103      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must not exist.
1108      * - `to` cannot be the zero address.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _mint(address to, uint256 tokenId) internal virtual {
1113         require(to != address(0), "ERC721: mint to the zero address");
1114         require(!_exists(tokenId), "ERC721: token already minted");
1115 
1116         _beforeTokenTransfer(address(0), to, tokenId);
1117 
1118         _balances[to] += 1;
1119         _owners[tokenId] = to;
1120 
1121         emit Transfer(address(0), to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev Destroys `tokenId`.
1126      * The approval is cleared when the token is burned.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         address owner = ERC721.ownerOf(tokenId);
1136 
1137         _beforeTokenTransfer(owner, address(0), tokenId);
1138 
1139         // Clear approvals
1140         _approve(address(0), tokenId);
1141 
1142         _balances[owner] -= 1;
1143         delete _owners[tokenId];
1144 
1145         emit Transfer(owner, address(0), tokenId);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1151      *
1152      * Requirements:
1153      *
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must be owned by `from`.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _transfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {
1164         require(
1165             ERC721.ownerOf(tokenId) == from,
1166             "ERC721: transfer of token that is not own"
1167         );
1168         require(to != address(0), "ERC721: transfer to the zero address");
1169 
1170         _beforeTokenTransfer(from, to, tokenId);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId);
1174 
1175         _balances[from] -= 1;
1176         _balances[to] += 1;
1177         _owners[tokenId] = to;
1178 
1179         emit Transfer(from, to, tokenId);
1180     }
1181 
1182     /**
1183      * @dev Approve `to` to operate on `tokenId`
1184      *
1185      * Emits a {Approval} event.
1186      */
1187     function _approve(address to, uint256 tokenId) internal virtual {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try
1210                 IERC721Receiver(to).onERC721Received(
1211                     _msgSender(),
1212                     from,
1213                     tokenId,
1214                     _data
1215                 )
1216             returns (bytes4 retval) {
1217                 return retval == IERC721Receiver(to).onERC721Received.selector;
1218             } catch (bytes memory reason) {
1219                 if (reason.length == 0) {
1220                     revert(
1221                         "ERC721: transfer to non ERC721Receiver implementer"
1222                     );
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1261  * enumerability of all the token ids in the contract as well as all token ids owned by each
1262  * account.
1263  */
1264 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1265     // Mapping from owner to list of owned token IDs
1266     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1267 
1268     // Mapping from token ID to index of the owner tokens list
1269     mapping(uint256 => uint256) private _ownedTokensIndex;
1270 
1271     // Array with all token ids, used for enumeration
1272     uint256[] private _allTokens;
1273 
1274     // Mapping from token id to position in the allTokens array
1275     mapping(uint256 => uint256) private _allTokensIndex;
1276 
1277     /**
1278      * @dev See {IERC165-supportsInterface}.
1279      */
1280     function supportsInterface(bytes4 interfaceId)
1281         public
1282         view
1283         virtual
1284         override(IERC165, ERC721)
1285         returns (bool)
1286     {
1287         return
1288             interfaceId == type(IERC721Enumerable).interfaceId ||
1289             super.supportsInterface(interfaceId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index)
1296         public
1297         view
1298         virtual
1299         override
1300         returns (uint256)
1301     {
1302         require(
1303             index < ERC721.balanceOf(owner),
1304             "ERC721Enumerable: owner index out of bounds"
1305         );
1306         return _ownedTokens[owner][index];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Enumerable-totalSupply}.
1311      */
1312     function totalSupply() public view virtual override returns (uint256) {
1313         return _allTokens.length;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Enumerable-tokenByIndex}.
1318      */
1319     function tokenByIndex(uint256 index)
1320         public
1321         view
1322         virtual
1323         override
1324         returns (uint256)
1325     {
1326         require(
1327             index < ERC721Enumerable.totalSupply(),
1328             "ERC721Enumerable: global index out of bounds"
1329         );
1330         return _allTokens[index];
1331     }
1332 
1333     /**
1334      * @dev Hook that is called before any token transfer. This includes minting
1335      * and burning.
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1343      * - `from` cannot be the zero address.
1344      * - `to` cannot be the zero address.
1345      *
1346      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1347      */
1348     function _beforeTokenTransfer(
1349         address from,
1350         address to,
1351         uint256 tokenId
1352     ) internal virtual override {
1353         super._beforeTokenTransfer(from, to, tokenId);
1354 
1355         if (from == address(0)) {
1356             _addTokenToAllTokensEnumeration(tokenId);
1357         } else if (from != to) {
1358             _removeTokenFromOwnerEnumeration(from, tokenId);
1359         }
1360         if (to == address(0)) {
1361             _removeTokenFromAllTokensEnumeration(tokenId);
1362         } else if (to != from) {
1363             _addTokenToOwnerEnumeration(to, tokenId);
1364         }
1365     }
1366 
1367     /**
1368      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1369      * @param to address representing the new owner of the given token ID
1370      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1371      */
1372     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1373         uint256 length = ERC721.balanceOf(to);
1374         _ownedTokens[to][length] = tokenId;
1375         _ownedTokensIndex[tokenId] = length;
1376     }
1377 
1378     /**
1379      * @dev Private function to add a token to this extension's token tracking data structures.
1380      * @param tokenId uint256 ID of the token to be added to the tokens list
1381      */
1382     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1383         _allTokensIndex[tokenId] = _allTokens.length;
1384         _allTokens.push(tokenId);
1385     }
1386 
1387     /**
1388      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1389      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1390      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1391      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1392      * @param from address representing the previous owner of the given token ID
1393      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1394      */
1395     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1396         private
1397     {
1398         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1399         // then delete the last slot (swap and pop).
1400 
1401         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1402         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1403 
1404         // When the token to delete is the last token, the swap operation is unnecessary
1405         if (tokenIndex != lastTokenIndex) {
1406             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1407 
1408             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1409             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1410         }
1411 
1412         // This also deletes the contents at the last position of the array
1413         delete _ownedTokensIndex[tokenId];
1414         delete _ownedTokens[from][lastTokenIndex];
1415     }
1416 
1417     /**
1418      * @dev Private function to remove a token from this extension's token tracking data structures.
1419      * This has O(1) time complexity, but alters the order of the _allTokens array.
1420      * @param tokenId uint256 ID of the token to be removed from the tokens list
1421      */
1422     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1423         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1424         // then delete the last slot (swap and pop).
1425 
1426         uint256 lastTokenIndex = _allTokens.length - 1;
1427         uint256 tokenIndex = _allTokensIndex[tokenId];
1428 
1429         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1430         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1431         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1432         uint256 lastTokenId = _allTokens[lastTokenIndex];
1433 
1434         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1435         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1436 
1437         // This also deletes the contents at the last position of the array
1438         delete _allTokensIndex[tokenId];
1439         _allTokens.pop();
1440     }
1441 }
1442 
1443 // File: AngryBunnies.sol
1444 
1445 pragma solidity ^0.8.0;
1446 
1447 contract AngryBunnies is ERC721Enumerable, Ownable {
1448     using Counters for Counters.Counter;
1449     Counters.Counter private _tokenId;
1450 
1451     uint256 public constant MAX_AGBN = 7777;
1452     uint256 public price = 60000000000000000; //0.06 Ether
1453     string baseTokenURI;
1454     bool public saleOpen = false;
1455 
1456     event AngryBunniesMinted(uint256 totalMinted);
1457 
1458     constructor(string memory baseURI) ERC721("Angry Bunnies", "AGBN") {
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
1482     function setPrice(uint256 _newPrice) public onlyOwner {
1483         price = _newPrice;
1484     }
1485 
1486     //Close sale if open, open sale if closed
1487     function flipSaleState() public onlyOwner {
1488         saleOpen = !saleOpen;
1489     }
1490 
1491     function withdrawAll() public onlyOwner {
1492         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1493         require(success, "Transfer failed.");
1494     }
1495 
1496     //mint AngryBunnies
1497     function mintAngryBunnies(uint256 _count) public payable {
1498         if (msg.sender != owner()) {
1499             require(saleOpen, "Sale is not open yet");
1500         }
1501         require(
1502             _count > 0 && _count <= 20,
1503             "Min 1 & Max 20 AngryBunnies can be minted per transaction"
1504         );
1505         require(
1506             totalSupply() + _count <= MAX_AGBN,
1507             "Transaction will exceed maximum supply of AngryBunnies"
1508         );
1509         require(
1510             msg.value >= price * _count,
1511             "Ether sent with this transaction is not correct"
1512         );
1513 
1514         address _to = msg.sender;
1515 
1516         for (uint256 i = 0; i < _count; i++) {
1517             _mint(_to);
1518         }
1519     }
1520 
1521     function _mint(address _to) private {
1522         uint256 tokenId = totalSupply();
1523         _safeMint(_to, tokenId);
1524         emit AngryBunniesMinted(tokenId + 1);
1525     }
1526 
1527     function _baseURI() internal view virtual override returns (string memory) {
1528         return baseTokenURI;
1529     }
1530 }