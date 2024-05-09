1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @title Artifex Smart Contract
5  * @author GigLabs, Brian Burns <brian@giglabs.io>
6  */
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly {
39             size := extcodesize(account)
40         }
41         return size > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(
62             address(this).balance >= amount,
63             "Address: insufficient balance"
64         );
65 
66         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
67         (bool success, ) = recipient.call{value: amount}("");
68         require(
69             success,
70             "Address: unable to send value, recipient may have reverted"
71         );
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain`call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data)
93         internal
94         returns (bytes memory)
95     {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but also transferring `value` wei to `target`.
116      *
117      * Requirements:
118      *
119      * - the calling contract must have an ETH balance of at least `value`.
120      * - the called Solidity function must be `payable`.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value
128     ) internal returns (bytes memory) {
129         return
130             functionCallWithValue(
131                 target,
132                 data,
133                 value,
134                 "Address: low-level call with value failed"
135             );
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(
151             address(this).balance >= value,
152             "Address: insufficient balance for call"
153         );
154         require(isContract(target), "Address: call to non-contract");
155 
156         // solhint-disable-next-line avoid-low-level-calls
157         (bool success, bytes memory returndata) =
158             target.call{value: value}(data);
159         return _verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data)
169         internal
170         view
171         returns (bytes memory)
172     {
173         return
174             functionStaticCall(
175                 target,
176                 data,
177                 "Address: low-level static call failed"
178             );
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a static call.
184      *
185      * _Available since v3.3._
186      */
187     function functionStaticCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal view returns (bytes memory) {
192         require(isContract(target), "Address: static call to non-contract");
193 
194         // solhint-disable-next-line avoid-low-level-calls
195         (bool success, bytes memory returndata) = target.staticcall(data);
196         return _verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(address target, bytes memory data)
206         internal
207         returns (bytes memory)
208     {
209         return
210             functionDelegateCall(
211                 target,
212                 data,
213                 "Address: low-level delegate call failed"
214             );
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.4._
222      */
223     function functionDelegateCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(isContract(target), "Address: delegate call to non-contract");
229 
230         // solhint-disable-next-line avoid-low-level-calls
231         (bool success, bytes memory returndata) = target.delegatecall(data);
232         return _verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     function _verifyCallResult(
236         bool success,
237         bytes memory returndata,
238         string memory errorMessage
239     ) private pure returns (bytes memory) {
240         if (success) {
241             return returndata;
242         } else {
243             // Look for revert reason and bubble it up if present
244             if (returndata.length > 0) {
245                 // The easiest way to bubble the revert reason is using memory via assembly
246 
247                 // solhint-disable-next-line no-inline-assembly
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 /*
260  * @dev Provides information about the current execution context, including the
261  * sender of the transaction and its data. While these are generally available
262  * via msg.sender and msg.data, they should not be accessed in such a direct
263  * manner, since when dealing with meta-transactions the account sending and
264  * paying for execution may not be the actual sender (as far as an application
265  * is concerned).
266  *
267  * This contract is only required for intermediate, library-like contracts.
268  */
269 abstract contract Context {
270     function _msgSender() internal view virtual returns (address) {
271         return msg.sender;
272     }
273 
274     function _msgData() internal view virtual returns (bytes calldata) {
275         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
276         return msg.data;
277     }
278 }
279 
280 /**
281  * @dev String operations.
282  */
283 library Strings {
284     bytes16 private constant alphabet = "0123456789abcdef";
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
288      */
289     function toString(uint256 value) internal pure returns (string memory) {
290         // Inspired by OraclizeAPI's implementation - MIT licence
291         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
292 
293         if (value == 0) {
294             return "0";
295         }
296         uint256 temp = value;
297         uint256 digits;
298         while (temp != 0) {
299             digits++;
300             temp /= 10;
301         }
302         bytes memory buffer = new bytes(digits);
303         while (value != 0) {
304             digits -= 1;
305             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
306             value /= 10;
307         }
308         return string(buffer);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
313      */
314     function toHexString(uint256 value) internal pure returns (string memory) {
315         if (value == 0) {
316             return "0x00";
317         }
318         uint256 temp = value;
319         uint256 length = 0;
320         while (temp != 0) {
321             length++;
322             temp >>= 8;
323         }
324         return toHexString(value, length);
325     }
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
329      */
330     function toHexString(uint256 value, uint256 length)
331         internal
332         pure
333         returns (string memory)
334     {
335         bytes memory buffer = new bytes(2 * length + 2);
336         buffer[0] = "0";
337         buffer[1] = "x";
338         for (uint256 i = 2 * length + 1; i > 1; --i) {
339             buffer[i] = alphabet[value & 0xf];
340             value >>= 4;
341         }
342         require(value == 0, "Strings: hex length insufficient");
343         return string(buffer);
344     }
345 }
346 
347 /**
348  * @dev Contract module which provides a basic access control mechanism, where
349  * there is an account (an owner) that can be granted exclusive access to
350  * specific functions.
351  *
352  * By default, the owner account will be the one that deploys the contract. This
353  * can later be changed with {transferOwnership}.
354  *
355  * This module is used through inheritance. It will make available the modifier
356  * `onlyOwner`, which can be applied to your functions to restrict their use to
357  * the owner.
358  */
359 abstract contract Ownable is Context {
360     address private _owner;
361     mapping(address => uint8) private _otherOperators;
362 
363     event OwnershipTransferred(
364         address indexed previousOwner,
365         address indexed newOwner
366     );
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         address msgSender = _msgSender();
373         _owner = msgSender;
374         emit OwnershipTransferred(address(0), msgSender);
375     }
376 
377     /**
378      * @dev Returns the address of the current owner.
379      */
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Returns the operator state for an address. State
386      * of 1 means active operator of the contract. State of 0 means
387      * not an operator of the contract.
388      */
389     function otherOperator(address operatorAddress)
390         public
391         view
392         virtual
393         returns (uint8)
394     {
395         return _otherOperators[operatorAddress];
396     }
397 
398     /**
399      * @dev Throws if called by any account other than the owner.
400      */
401     modifier onlyOwner() {
402         require(owner() == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405 
406     /**
407      * @dev Throws if called by any account other than an operator.
408      */
409     modifier anyOperator() {
410         require(
411             owner() == _msgSender() || _otherOperators[msg.sender] == 1,
412             "Ownable: caller is not an operator"
413         );
414         _;
415     }
416 
417     /**
418      * @dev Leaves the contract without owner. It will not be possible to call
419      * `onlyOwner` functions anymore. Can only be called by the current owner.
420      *
421      * NOTE: Renouncing ownership will leave the contract without an owner,
422      * thereby removing any functionality that is only available to the owner.
423      */
424     function renounceOwnership() public virtual onlyOwner {
425         emit OwnershipTransferred(_owner, address(0));
426         _owner = address(0);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Can only be called by the current owner.
432      */
433     function transferOwnership(address newOwner) public virtual onlyOwner {
434         require(
435             newOwner != address(0),
436             "Ownable: new owner is the zero address"
437         );
438         emit OwnershipTransferred(_owner, newOwner);
439         _owner = newOwner;
440     }
441 
442     /**
443      * @dev Sets the state of other operators for performaing certain
444      * contract functions. Can only be called by the current owner.
445      */
446     function setOtherOperator(address _newOperator, uint8 _state)
447         public
448         virtual
449         onlyOwner
450     {
451         require(_newOperator != address(0));
452         _otherOperators[_newOperator] = _state;
453     }
454 }
455 
456 /**
457  * @title ERC721 token receiver interface
458  * @dev Interface for any contract that wants to support safeTransfers
459  * from ERC721 asset contracts.
460  */
461 interface IERC721Receiver {
462     /**
463      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
464      * by `operator` from `from`, this function is called.
465      *
466      * It must return its Solidity selector to confirm the token transfer.
467      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
468      *
469      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
470      */
471     function onERC721Received(
472         address operator,
473         address from,
474         uint256 tokenId,
475         bytes calldata data
476     ) external returns (bytes4);
477 }
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(
508         address indexed from,
509         address indexed to,
510         uint256 indexed tokenId
511     );
512 
513     /**
514      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
515      */
516     event Approval(
517         address indexed owner,
518         address indexed approved,
519         uint256 indexed tokenId
520     );
521 
522     /**
523      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
524      */
525     event ApprovalForAll(
526         address indexed owner,
527         address indexed operator,
528         bool approved
529     );
530 
531     /**
532      * @dev Returns the number of tokens in ``owner``'s account.
533      */
534     function balanceOf(address owner) external view returns (uint256 balance);
535 
536     /**
537      * @dev Returns the owner of the `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function ownerOf(uint256 tokenId) external view returns (address owner);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
547      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Transfers `tokenId` token from `from` to `to`.
567      *
568      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      *
577      * Emits a {Transfer} event.
578      */
579     function transferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
587      * The approval is cleared when the token is transferred.
588      *
589      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
590      *
591      * Requirements:
592      *
593      * - The caller must own the token or be an approved operator.
594      * - `tokenId` must exist.
595      *
596      * Emits an {Approval} event.
597      */
598     function approve(address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Returns the account approved for `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function getApproved(uint256 tokenId)
608         external
609         view
610         returns (address operator);
611 
612     /**
613      * @dev Approve or remove `operator` as an operator for the caller.
614      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
615      *
616      * Requirements:
617      *
618      * - The `operator` cannot be the caller.
619      *
620      * Emits an {ApprovalForAll} event.
621      */
622     function setApprovalForAll(address operator, bool _approved) external;
623 
624     /**
625      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
626      *
627      * See {setApprovalForAll}
628      */
629     function isApprovedForAll(address owner, address operator)
630         external
631         view
632         returns (bool);
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must exist and be owned by `from`.
642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId,
651         bytes calldata data
652     ) external;
653 }
654 
655 /**
656  * @dev Implementation of the {IERC165} interface.
657  *
658  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
659  * for the additional interface id that will be supported. For example:
660  *
661  * ```solidity
662  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
664  * }
665  * ```
666  *
667  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
668  */
669 abstract contract ERC165 is IERC165 {
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId)
674         public
675         view
676         virtual
677         override
678         returns (bool)
679     {
680         return interfaceId == type(IERC165).interfaceId;
681     }
682 }
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Metadata is IERC721 {
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external view returns (string memory);
703 }
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Enumerable is IERC721 {
710     /**
711      * @dev Returns the total amount of tokens stored by the contract.
712      */
713     function totalSupply() external view returns (uint256);
714 
715     /**
716      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
717      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
718      */
719     function tokenOfOwnerByIndex(address owner, uint256 index)
720         external
721         view
722         returns (uint256 tokenId);
723 
724     /**
725      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
726      * Use along with {totalSupply} to enumerate all tokens.
727      */
728     function tokenByIndex(uint256 index) external view returns (uint256);
729 }
730 
731 /**
732  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
733  * the Metadata extension, but not including the Enumerable extension, which is available separately as
734  * {ERC721Enumerable}.
735  */
736 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to owner address
747     mapping(uint256 => address) private _owners;
748 
749     // Mapping owner address to token count
750     mapping(address => uint256) private _balances;
751 
752     // Mapping from token ID to approved address
753     mapping(uint256 => address) private _tokenApprovals;
754 
755     // Mapping from owner to operator approvals
756     mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758     /**
759      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
760      */
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
764     }
765 
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId)
770         public
771         view
772         virtual
773         override(ERC165, IERC165)
774         returns (bool)
775     {
776         return
777             interfaceId == type(IERC721).interfaceId ||
778             interfaceId == type(IERC721Metadata).interfaceId ||
779             super.supportsInterface(interfaceId);
780     }
781 
782     /**
783      * @dev See {IERC721-balanceOf}.
784      */
785     function balanceOf(address owner)
786         public
787         view
788         virtual
789         override
790         returns (uint256)
791     {
792         require(
793             owner != address(0),
794             "ERC721: balance query for the zero address"
795         );
796         return _balances[owner];
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId)
803         public
804         view
805         virtual
806         override
807         returns (address)
808     {
809         address owner = _owners[tokenId];
810         require(
811             owner != address(0),
812             "ERC721: owner query for nonexistent token"
813         );
814         return owner;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-name}.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-symbol}.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-tokenURI}.
833      */
834     function tokenURI(uint256 tokenId)
835         public
836         view
837         virtual
838         override
839         returns (string memory)
840     {
841         require(
842             _exists(tokenId),
843             "ERC721Metadata: URI query for nonexistent token"
844         );
845 
846         string memory baseURI = _baseURI();
847         return
848             bytes(baseURI).length > 0
849                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
850                 : "";
851     }
852 
853     /**
854      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
855      * in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId)
880         public
881         view
882         virtual
883         override
884         returns (address)
885     {
886         require(
887             _exists(tokenId),
888             "ERC721: approved query for nonexistent token"
889         );
890 
891         return _tokenApprovals[tokenId];
892     }
893 
894     /**
895      * @dev See {IERC721-setApprovalForAll}.
896      */
897     function setApprovalForAll(address operator, bool approved)
898         public
899         virtual
900         override
901     {
902         require(operator != _msgSender(), "ERC721: approve to caller");
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator)
912         public
913         view
914         virtual
915         override
916         returns (bool)
917     {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         //solhint-disable-next-line max-line-length
930         require(
931             _isApprovedOrOwner(_msgSender(), tokenId),
932             "ERC721: transfer caller is not owner nor approved"
933         );
934 
935         _transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, "");
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         require(
959             _isApprovedOrOwner(_msgSender(), tokenId),
960             "ERC721: transfer caller is not owner nor approved"
961         );
962         _safeTransfer(from, to, tokenId, _data);
963     }
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
967      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
968      *
969      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
970      *
971      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
972      * implement alternative mechanisms to perform token transfer, such as signature-based.
973      *
974      * Requirements:
975      *
976      * - `from` cannot be the zero address.
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must exist and be owned by `from`.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeTransfer(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _transfer(from, to, tokenId);
990         require(
991             _checkOnERC721Received(from, to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      * and stop existing when they are burned (`_burn`).
1003      */
1004     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005         return _owners[tokenId] != address(0);
1006     }
1007 
1008     /**
1009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _isApprovedOrOwner(address spender, uint256 tokenId)
1016         internal
1017         view
1018         virtual
1019         returns (bool)
1020     {
1021         require(
1022             _exists(tokenId),
1023             "ERC721: operator query for nonexistent token"
1024         );
1025         address owner = ERC721.ownerOf(tokenId);
1026         return (spender == owner ||
1027             getApproved(tokenId) == spender ||
1028             isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075         require(!_exists(tokenId), "ERC721: token already minted");
1076 
1077         _beforeTokenTransfer(address(0), to, tokenId);
1078 
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107     }
1108 
1109     /**
1110      * @dev Transfers `tokenId` from `from` to `to`.
1111      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {
1125         require(
1126             ERC721.ownerOf(tokenId) == from,
1127             "ERC721: transfer of token that is not own"
1128         );
1129         require(to != address(0), "ERC721: transfer to the zero address");
1130 
1131         _beforeTokenTransfer(from, to, tokenId);
1132 
1133         // Clear approvals from the previous owner
1134         _approve(address(0), tokenId);
1135 
1136         _balances[from] -= 1;
1137         _balances[to] += 1;
1138         _owners[tokenId] = to;
1139 
1140         emit Transfer(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Approve `to` to operate on `tokenId`
1145      *
1146      * Emits a {Approval} event.
1147      */
1148     function _approve(address to, uint256 tokenId) internal virtual {
1149         _tokenApprovals[tokenId] = to;
1150         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1155      * The call is not executed if the target address is not a contract.
1156      *
1157      * @param from address representing the previous owner of the given token ID
1158      * @param to target address that will receive the tokens
1159      * @param tokenId uint256 ID of the token to be transferred
1160      * @param _data bytes optional data to send along with the call
1161      * @return bool whether the call correctly returned the expected magic value
1162      */
1163     function _checkOnERC721Received(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) private returns (bool) {
1169         if (to.isContract()) {
1170             try
1171                 IERC721Receiver(to).onERC721Received(
1172                     _msgSender(),
1173                     from,
1174                     tokenId,
1175                     _data
1176                 )
1177             returns (bytes4 retval) {
1178                 return retval == IERC721Receiver(to).onERC721Received.selector;
1179             } catch (bytes memory reason) {
1180                 if (reason.length == 0) {
1181                     revert(
1182                         "ERC721: transfer to non ERC721Receiver implementer"
1183                     );
1184                 } else {
1185                     // solhint-disable-next-line no-inline-assembly
1186                     assembly {
1187                         revert(add(32, reason), mload(reason))
1188                     }
1189                 }
1190             }
1191         } else {
1192             return true;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before any token transfer. This includes minting
1198      * and burning.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _beforeTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual {}
1216 }
1217 
1218 /**
1219  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1220  * enumerability of all the token ids in the contract as well as all token ids owned by each
1221  * account.
1222  */
1223 abstract contract ERC721Enumerable is
1224     Context,
1225     ERC165,
1226     ERC721,
1227     IERC721Enumerable
1228 {
1229     // Mapping from owner to list of owned token IDs
1230     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1231 
1232     // Mapping from token ID to index of the owner tokens list
1233     mapping(uint256 => uint256) private _ownedTokensIndex;
1234 
1235     // Array with all token ids, used for enumeration
1236     uint256[] private _allTokens;
1237 
1238     // Mapping from token id to position in the allTokens array
1239     mapping(uint256 => uint256) private _allTokensIndex;
1240 
1241     /**
1242      * @dev See {IERC165-supportsInterface}.
1243      */
1244     function supportsInterface(bytes4 interfaceId)
1245         public
1246         view
1247         virtual
1248         override(IERC165, ERC165, ERC721)
1249         returns (bool)
1250     {
1251         return
1252             interfaceId == type(IERC721Enumerable).interfaceId ||
1253             super.supportsInterface(interfaceId);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1258      */
1259     function tokenOfOwnerByIndex(address owner, uint256 index)
1260         public
1261         view
1262         virtual
1263         override
1264         returns (uint256)
1265     {
1266         require(
1267             index < ERC721.balanceOf(owner),
1268             "ERC721Enumerable: owner index out of bounds"
1269         );
1270         return _ownedTokens[owner][index];
1271     }
1272 
1273     /**
1274      * @dev See {IERC721Enumerable-totalSupply}.
1275      */
1276     function totalSupply() public view virtual override returns (uint256) {
1277         return _allTokens.length;
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Enumerable-tokenByIndex}.
1282      */
1283     function tokenByIndex(uint256 index)
1284         public
1285         view
1286         virtual
1287         override
1288         returns (uint256)
1289     {
1290         require(
1291             index < ERC721Enumerable.totalSupply(),
1292             "ERC721Enumerable: global index out of bounds"
1293         );
1294         return _allTokens[index];
1295     }
1296 
1297     /**
1298      * @dev Hook that is called before any token transfer. This includes minting
1299      * and burning.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1307      * - `from` cannot be the zero address.
1308      * - `to` cannot be the zero address.
1309      *
1310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1311      */
1312     function _beforeTokenTransfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) internal virtual override {
1317         super._beforeTokenTransfer(from, to, tokenId);
1318 
1319         if (from == address(0)) {
1320             _addTokenToAllTokensEnumeration(tokenId);
1321         } else if (from != to) {
1322             _removeTokenFromOwnerEnumeration(from, tokenId);
1323         }
1324         if (to == address(0)) {
1325             _removeTokenFromAllTokensEnumeration(tokenId);
1326         } else if (to != from) {
1327             _addTokenToOwnerEnumeration(to, tokenId);
1328         }
1329     }
1330 
1331     /**
1332      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1333      * @param to address representing the new owner of the given token ID
1334      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1335      */
1336     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1337         uint256 length = ERC721.balanceOf(to);
1338         _ownedTokens[to][length] = tokenId;
1339         _ownedTokensIndex[tokenId] = length;
1340     }
1341 
1342     /**
1343      * @dev Private function to add a token to this extension's token tracking data structures.
1344      * @param tokenId uint256 ID of the token to be added to the tokens list
1345      */
1346     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1347         _allTokensIndex[tokenId] = _allTokens.length;
1348         _allTokens.push(tokenId);
1349     }
1350 
1351     /**
1352      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1353      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1354      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1355      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1356      * @param from address representing the previous owner of the given token ID
1357      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1358      */
1359     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1360         private
1361     {
1362         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1366         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary
1369         if (tokenIndex != lastTokenIndex) {
1370             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1371 
1372             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374         }
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _ownedTokensIndex[tokenId];
1378         delete _ownedTokens[from][lastTokenIndex];
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's token tracking data structures.
1383      * This has O(1) time complexity, but alters the order of the _allTokens array.
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list
1385      */
1386     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1387         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = _allTokens.length - 1;
1391         uint256 tokenIndex = _allTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1394         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1395         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1396         uint256 lastTokenId = _allTokens[lastTokenIndex];
1397 
1398         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1399         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _allTokensIndex[tokenId];
1403         _allTokens.pop();
1404     }
1405 }
1406 
1407 /**
1408  * @dev The Artifex main contract.
1409  *
1410  * Each Artifex token implements full on-chain metadata
1411  * in standard JSON format for anyone to retreive using the
1412  * getMetadata() function in this contract. A mirrored copy of the
1413  * metadata JSON is also stored on IPFS.
1414  *
1415  * Each NFT 2D image is stored on both IPFS and Arweave
1416  * Each NFT 3D model is stored on both IPFS and Arweave
1417  *
1418  * The metadata on-chain in this contract (and mirrored on IPFS)
1419  * return the hashes / locations of all NFT images and 3D model files
1420  * stored on IPFS and Arweave.
1421  *
1422  * The metadata on-chain in this contract (and mirrored on IPFS)
1423  * also return SHA256 hashes of the NFT images and 3D model files
1424  * for verifying authenticity of the NFTs.
1425  *
1426  * Metadata is retreivable using the tokenURI() call as specified
1427  * in the ERC721-Metadata standard. tokenURI can't point to on-chain
1428  * locations directly - it points to an off-chain URI for
1429  * returning metadata.
1430  */
1431 contract Artifex is Ownable, ERC721Enumerable {
1432     // NOTE: `SafeMath` is no longer needed starting with Solidity 0.8.
1433     // The compiler now has built in overflow checking.
1434     //
1435     // using SafeMath for uint256;
1436     using Address for address;
1437     using Strings for uint256;
1438 
1439     // Core series metadata
1440     struct ArtistNFTSeriesInfo {
1441         uint256 totalEditions;
1442         string creatorName;
1443         string artistName;
1444         string artTitle;
1445         string description;
1446         string sha256ImageHash;
1447         string ipfsImageHash;
1448         string arweaveImageHash;
1449         string imageFileType;
1450     }
1451 
1452     // Extended series metadata
1453     struct ArtistNFTSeries3DModelInfo {
1454         string sha256ModelHash;
1455         string ipfs3DModelHash;
1456         string arweave3DModelHash;
1457         string modelFileType;
1458     }
1459 
1460     // Series ID => Core series metadata for NFT Type 1 (2D art piece)
1461     mapping(uint256 => ArtistNFTSeriesInfo) private artist2DSeriesInfo;
1462 
1463     // Series ID => Core series metadata for NFT Type 2 (3D art piece,
1464     // in 2D format)
1465     mapping(uint256 => ArtistNFTSeriesInfo) private artist3DSeriesInfo;
1466 
1467     // Series ID => Extended series metadata for NFT Type 2 (3D model
1468     // files for 3D art piece)
1469     mapping(uint256 => ArtistNFTSeries3DModelInfo)
1470         private artistSeries3DModelInfo;
1471 
1472     // Series ID => series locked state
1473     mapping(uint256 => bool) private artistSeriesLocked;
1474 
1475     // Token ID => token's IPFS Metadata hash
1476     mapping(uint256 => string) private tokenIdToIPFSMetadataHash;
1477 
1478     // Base token URI used as a prefix for all tokens to build
1479     // a full token URI string
1480     string private _baseTokenURI;
1481 
1482     // Base external token URI used as a prefix for all tokens
1483     // to build a full external token URI string
1484     string private _externalBaseTokenURI;
1485 
1486     // Multipliers for token Id calculations
1487     uint256 constant SERIES_MULTIPLIER = 100000000;
1488     uint256 constant NFT_TYPE_MULTIPLIER = 10000;
1489 
1490     /**
1491      * @notice Event emitted when the takenBaseUri is set after
1492      * contract deployment
1493      * @param tokenBaseUri the base URI for tokenURI calls
1494      */
1495     event TokenBaseUriSet(string tokenBaseUri);
1496 
1497     /**
1498      * @notice Event emitted when the externalBaseUri is set after
1499      * contract deployment.
1500      * @param externalBaseUri the new external base URI
1501      */
1502     event ExternalBaseUriSet(string externalBaseUri);
1503 
1504     /**
1505      * @notice Event emitted when a series is locked/sealed
1506      * @param seriesId the ID of the newly locked/sealed series
1507      */
1508     event SeriesLocked(uint256 seriesId);
1509 
1510     /**
1511      * @dev Constructor
1512      * @param name the token name
1513      * @param symbol the token symbol
1514      * @param base_uri the base URI for location of off-chain metadata
1515      * @param external_base_uri the base URI for viewing token on website
1516      */
1517     constructor(
1518         string memory name,
1519         string memory symbol,
1520         string memory base_uri,
1521         string memory external_base_uri
1522     ) ERC721(name, symbol) {
1523         _baseTokenURI = base_uri;
1524         _externalBaseTokenURI = external_base_uri;
1525     }
1526 
1527     /**
1528      * @notice Add core metadata for the 2D piece in an artist series.
1529      * NOTE: For Artifex, there will only be 100 artist series IDs (1-100).
1530      * Each series will have a 1 of 1 2D art piece (nftType 1) and a run
1531      * of 100 3D art pieces (nftType 2). Series ID 0 will be a gift
1532      * series and is not included in the 1-100 artist series IDs.
1533      * @param seriesId the ID of the series (0-100)
1534      * @param seriesInfo structure with series metadata
1535      */
1536     function addArtistSeries2dNftType(
1537         uint256 seriesId,
1538         ArtistNFTSeriesInfo calldata seriesInfo
1539     ) external anyOperator {
1540         // Series ID must be 0-100
1541         require(seriesId <= 100);
1542 
1543         // Once a series metadata is locked, it cannot be updated. The
1544         // information will live as permanent metadata in the contract.
1545         require(artistSeriesLocked[seriesId] == false, "Series is locked");
1546 
1547         artist2DSeriesInfo[seriesId] = seriesInfo;
1548     }
1549 
1550     /**
1551      * @notice Add core metadata for the 3D pieces in an artist series.
1552      * NOTE: For Artifex, there will only be 100 artist series IDs (1-100).
1553      * Each series will have a 1 of 1 2D art piece (nftType 1) and a run
1554      * of 100 3D art pieces (nftType 2). Series ID 0 will be a gift
1555      * series and is not included in the 1-100 artist series IDs.
1556      * @param seriesId the ID of the series (0-100)
1557      * @param seriesInfo structure with series metadata
1558      * @param series3DModelInfo structure with series 3D model metadata
1559      */
1560     function addArtistSeries3dNftType(
1561         uint256 seriesId,
1562         ArtistNFTSeriesInfo calldata seriesInfo,
1563         ArtistNFTSeries3DModelInfo calldata series3DModelInfo
1564     ) external anyOperator {
1565         // Series ID must be 0-100
1566         require(seriesId <= 100);
1567 
1568         // Once a series metadata is locked, it cannot be updated. The
1569         // information will live as permanent metadata in the contract and
1570         // on IFPS
1571         require(artistSeriesLocked[seriesId] == false, "Series is locked");
1572 
1573         artist3DSeriesInfo[seriesId] = seriesInfo;
1574         artistSeries3DModelInfo[seriesId] = series3DModelInfo;
1575     }
1576 
1577     /**
1578      * @dev Update the IPFS hash for a given token.
1579      * Series metadata must NOT be locked yet (must still be within
1580      * the series metadata update window)
1581      * Reverts if the token ID does not exist.
1582      * @param tokenId uint256 ID of the token to set its URI
1583      * @param ipfsHash string IPFS link to assign
1584      */
1585     function updateTokenIPFSMetadataHash(
1586         uint256 tokenId,
1587         string calldata ipfsHash
1588     ) external anyOperator {
1589         require(
1590             artistSeriesLocked[getSeriesId(tokenId)] == false,
1591             "Series is locked"
1592         );
1593         _setTokenIPFSMetadataHash(tokenId, ipfsHash);
1594     }
1595 
1596     /**
1597      * @notice This function permanently locks metadata updates for all NFTs
1598      * in a Series. For practical reasons, a short period of time is given
1599      * for updates following a series mint. For example, maybe an artist
1600      * notices incorrect info in the description of their art after it is
1601      * minted. In most projects, metadata updates would be possible by changning
1602      * the metadata on the web server hosting the metadata. However, for
1603      * Artifex once metadata is locked, no updates to the metadata will be
1604      * possible - the information is permanent and immutable.
1605      *
1606      * The metadata will be permanent on-chain here in the contract, retrievable
1607      * as a JSON string via the getMetadata() call. A mirror of the metadata will
1608      * also live permanently on IPFS at the location stored in the
1609      * tokenIdToIPFSMetadataHash mapping in this contract.
1610      *
1611      * @param seriesId the ID of the series (0-100)
1612      */
1613     function lockSeries(uint256 seriesId) external anyOperator {
1614         // Series ID must be 0-100
1615         require(seriesId <= 100);
1616 
1617         // Series must not have been previously locked
1618         require(artistSeriesLocked[seriesId] == false, "Series is locked");
1619 
1620         // Lock the series. Once a series information is set, it can no
1621         // longer be updated. The information will live as permanent
1622         // metadata in the contract.
1623         artistSeriesLocked[seriesId] = true;
1624 
1625         // Emit the event
1626         emit SeriesLocked(seriesId);
1627     }
1628 
1629     /**
1630      * @notice Sets a new base token URI for accessing off-chain metadata
1631      * location. If this is changed, an event gets emitted.
1632      * @param newBaseTokenURI the new base token URI
1633      */
1634     function setBaseURI(string calldata newBaseTokenURI) external anyOperator {
1635         _baseTokenURI = newBaseTokenURI;
1636 
1637         // Emit the event
1638         emit TokenBaseUriSet(newBaseTokenURI);
1639     }
1640 
1641     /**
1642      * @notice Sets a new base external URI for accessing the nft on a web site.
1643      * If this is changed, an event gets emitted
1644      * @param newExternalBaseTokenURI the new base external token URI
1645      */
1646     function setExternalBaseURI(string calldata newExternalBaseTokenURI)
1647         external
1648         anyOperator
1649     {
1650         _externalBaseTokenURI = newExternalBaseTokenURI;
1651 
1652         // Emit the event
1653         emit ExternalBaseUriSet(newExternalBaseTokenURI);
1654     }
1655 
1656     /**
1657      * @dev Batch transfer of Artifex NFTs from one address to another
1658      * @param _to The address of the recipient
1659      * @param _tokenIds List of token IDs to transfer
1660      */
1661     function batchTransfer(address _to, uint256[] calldata _tokenIds) public {
1662         require(_tokenIds.length > 0);
1663 
1664         for (uint256 i = 0; i < _tokenIds.length; i++) {
1665             safeTransferFrom(msg.sender, _to, _tokenIds[i], "");
1666         }
1667     }
1668 
1669     /**
1670      * @notice Given a series ID, return the locked state
1671      * @param seriesId the series ID
1672      * @return true if series is locked, otherwise returns false
1673      */
1674     function isSeriesLocked(uint256 seriesId) external view returns (bool) {
1675         return artistSeriesLocked[seriesId];
1676     }
1677 
1678     /**
1679      * @notice return the base URI used for accessing off-chain metadata
1680      * @return base URI for location of the off-chain metadata
1681      */
1682     function baseURI() external view returns (string memory) {
1683         return _baseURI();
1684     }
1685 
1686     /**
1687      * @notice return the base external URI used for accessing nft on a web site.
1688      * @return base external URI
1689      */
1690     function externalBaseURI() external view returns (string memory) {
1691         return _externalBaseTokenURI;
1692     }
1693 
1694     /**
1695      * @notice Given a token ID, return whether or not it exists
1696      * @param tokenId the token ID
1697      * @return a bool which is true of the token exists
1698      */
1699     function exists(uint256 tokenId) external view returns (bool) {
1700         return _exists(tokenId);
1701     }
1702 
1703     /**
1704      * @notice Given a token ID, return all on-chain metadata for the
1705      * token as JSON string
1706      *
1707      * For each NFT, the following on-chain metadata is returned:
1708      *    - Name: The title of the art piece (includes creator of the art piece)
1709      *    - Descriptiom: Details about the art piece (includes the artist represented)
1710      *    - Image URI: The off-chain URI location of the image
1711      *    - External URI: Website to view the NFT
1712      *    - SHA256 Image Hash: The actual image hash stored on-chain for anyone
1713      *      to validate authenticity of their art piece
1714      *    - IPFS Image Hash: IFPS storage hash of the image
1715      *    - Arweave Image Hash: Arweave storage hash of the image
1716      *    - Image File Type: File extension of the image, since file stores such
1717      *      as IPFS may not return the image file type
1718      *
1719      *    IF 3D MODEL INFO AVAILABLE, THEN INCLUDE THIS IN METADATA
1720      *    - SHA256 3D Model Hash: The actual 3D Model hash stored
1721      *      on-chain for anyone to validate authenticity of their
1722      *       3D model asset
1723      *    - IPFS 3D Model Hash: IFPS storage hash of the 3D model
1724      *    - Arweave Image Hash: Arweave storage hash of the 3D model
1725      *    - 3D Model File Type: File extension of the 3D model
1726      *
1727      *    ATTRIBUTES INCLUDED:
1728      *    - Creator name: The creator of the art piece
1729      *    - Artist name: The artist represented / honored by the creator
1730      *    - Edition Number: The edition number of the NFT
1731      *    - Total Editions: Total editions that can ever exist in the series
1732      *
1733      * @param tokenId the token ID
1734      * @return metadata a JSON string of the metadata
1735      */
1736     function getMetadata(uint256 tokenId)
1737         external
1738         view
1739         returns (string memory metadata)
1740     {
1741         require(_exists(tokenId), "Token does not exist");
1742 
1743         uint256 seriesId = getSeriesId(tokenId);
1744         uint256 nftType = getNftType(tokenId);
1745         uint256 editionNum = getNftNum(tokenId);
1746 
1747         string memory creatorName;
1748         ArtistNFTSeriesInfo memory seriesInfo;
1749         ArtistNFTSeries3DModelInfo memory series3DModelInfo;
1750         if (nftType == 1) {
1751             seriesInfo = artist2DSeriesInfo[seriesId];
1752             creatorName = seriesInfo.artistName;
1753         } else if (nftType == 2) {
1754             seriesInfo = artist3DSeriesInfo[seriesId];
1755             creatorName = seriesInfo.creatorName;
1756             series3DModelInfo = artistSeries3DModelInfo[seriesId];
1757         }
1758 
1759         // Name
1760         metadata = string(
1761             abi.encodePacked('{\n  "name": "', seriesInfo.artistName)
1762         );
1763         metadata = string(abi.encodePacked(metadata, " Artifex #"));
1764         metadata = string(abi.encodePacked(metadata, editionNum.toString()));
1765         metadata = string(abi.encodePacked(metadata, " of "));
1766         metadata = string(
1767             abi.encodePacked(metadata, seriesInfo.totalEditions.toString())
1768         );
1769         metadata = string(abi.encodePacked(metadata, '",\n'));
1770 
1771         // Description: Generation
1772         metadata = string(abi.encodePacked(metadata, '  "description": "'));
1773         metadata = string(abi.encodePacked(metadata, seriesInfo.description));
1774         metadata = string(abi.encodePacked(metadata, '",\n'));
1775 
1776         // Image URI
1777         metadata = string(abi.encodePacked(metadata, '  "image": "'));
1778         metadata = string(abi.encodePacked(metadata, _baseTokenURI));
1779         metadata = string(abi.encodePacked(metadata, seriesInfo.ipfsImageHash));
1780         metadata = string(abi.encodePacked(metadata, '",\n'));
1781 
1782         // External URI
1783         metadata = string(abi.encodePacked(metadata, '  "external_url": "'));
1784         metadata = string(abi.encodePacked(metadata, externalURI(tokenId)));
1785         metadata = string(abi.encodePacked(metadata, '",\n'));
1786 
1787         // SHA256 Image Hash
1788         metadata = string(
1789             abi.encodePacked(metadata, '  "sha256_image_hash": "')
1790         );
1791         metadata = string(
1792             abi.encodePacked(metadata, seriesInfo.sha256ImageHash)
1793         );
1794         metadata = string(abi.encodePacked(metadata, '",\n'));
1795 
1796         // IPFS Image Hash
1797         metadata = string(abi.encodePacked(metadata, '  "ipfs_image_hash": "'));
1798         metadata = string(abi.encodePacked(metadata, seriesInfo.ipfsImageHash));
1799         metadata = string(abi.encodePacked(metadata, '",\n'));
1800 
1801         // Arweave Image Hash
1802         metadata = string(
1803             abi.encodePacked(metadata, '  "arweave_image_hash": "')
1804         );
1805         metadata = string(
1806             abi.encodePacked(metadata, seriesInfo.arweaveImageHash)
1807         );
1808         metadata = string(abi.encodePacked(metadata, '",\n'));
1809 
1810         // Image file type
1811         metadata = string(abi.encodePacked(metadata, '  "image_file_type": "'));
1812         metadata = string(abi.encodePacked(metadata, seriesInfo.imageFileType));
1813         metadata = string(abi.encodePacked(metadata, '",\n'));
1814 
1815         // Optional 3D Model metadata
1816         if (nftType == 2) {
1817             // SHA256 3D Model Hash
1818             metadata = string(
1819                 abi.encodePacked(metadata, '  "sha256_3d_model_hash": "')
1820             );
1821             metadata = string(
1822                 abi.encodePacked(metadata, series3DModelInfo.sha256ModelHash)
1823             );
1824             metadata = string(abi.encodePacked(metadata, '",\n'));
1825 
1826             // IPFS 3D Model Hash
1827             metadata = string(
1828                 abi.encodePacked(metadata, '  "ipfs_3d_model_hash": "')
1829             );
1830             metadata = string(
1831                 abi.encodePacked(metadata, series3DModelInfo.ipfs3DModelHash)
1832             );
1833             metadata = string(abi.encodePacked(metadata, '",\n'));
1834 
1835             // Arweave 3D Model Hash
1836             metadata = string(
1837                 abi.encodePacked(metadata, '  "arweave_3d_model_hash": "')
1838             );
1839             metadata = string(
1840                 abi.encodePacked(metadata, series3DModelInfo.arweave3DModelHash)
1841             );
1842             metadata = string(abi.encodePacked(metadata, '",\n'));
1843 
1844             // 3D model file type
1845             metadata = string(
1846                 abi.encodePacked(metadata, '  "model_file_type": "')
1847             );
1848             metadata = string(
1849                 abi.encodePacked(metadata, series3DModelInfo.modelFileType)
1850             );
1851             metadata = string(abi.encodePacked(metadata, '",\n'));
1852         }
1853 
1854         // Atributes section
1855 
1856         // Artist Name
1857         metadata = string(
1858             abi.encodePacked(
1859                 metadata,
1860                 '  "attributes": [\n     {"trait_type": "Artist", "value": "'
1861             )
1862         );
1863         metadata = string(abi.encodePacked(metadata, seriesInfo.artistName));
1864         metadata = string(abi.encodePacked(metadata, '"},\n'));
1865 
1866         // Creator Name
1867         metadata = string(
1868             abi.encodePacked(
1869                 metadata,
1870                 '     {"trait_type": "Creator", "value": "'
1871             )
1872         );
1873         metadata = string(abi.encodePacked(metadata, creatorName));
1874         metadata = string(abi.encodePacked(metadata, '"},\n'));
1875 
1876         // Edition Number
1877         metadata = string(
1878             abi.encodePacked(
1879                 metadata,
1880                 '     {"trait_type": "Edition", "value": '
1881             )
1882         );
1883         metadata = string(abi.encodePacked(metadata, editionNum.toString()));
1884         metadata = string(abi.encodePacked(metadata, ","));
1885 
1886         // Total Editions
1887         metadata = string(abi.encodePacked(metadata, ' "max_value": '));
1888         metadata = string(
1889             abi.encodePacked(metadata, seriesInfo.totalEditions.toString())
1890         );
1891         metadata = string(abi.encodePacked(metadata, ","));
1892         metadata = string(
1893             abi.encodePacked(metadata, ' "display_type": "number"}\n ]')
1894         );
1895 
1896         // Finish JSON object
1897         metadata = string(abi.encodePacked(metadata, "\n}"));
1898     }
1899 
1900     /**
1901      * @notice Mints an Artifex NFT
1902      * @param to address of the recipient
1903      * @param seriesId series to mint
1904      * @param nftType the type of nft - 1 for 2D piece, 2 for 3D piece
1905      * @param nftNum the edition number of the nft
1906      * @param ipfsHash the ipfsHash of a copy of the token's Metadata on ipfs
1907      */
1908     function mintArtifexNft(
1909         address to,
1910         uint256 seriesId,
1911         uint256 nftType,
1912         uint256 nftNum,
1913         string memory ipfsHash
1914     ) public anyOperator {
1915         // Ensure the series is not locked yet. No more minting can
1916         // happen once the series is locked
1917         require(artistSeriesLocked[seriesId] == false, "Series is locked");
1918         // Series 0 is a gift series. Only enforce edition limits
1919         // for artist Series > 0.
1920         if (seriesId > 0) {
1921             if (nftType == 1) {
1922                 require(nftNum == 1, "Edition must be 1");
1923             } else if (nftType == 2) {
1924                 require(nftNum <= 100, "Edition must be <= 100");
1925             }
1926         }
1927         uint256 tokenId = encodeTokenId(seriesId, nftType, nftNum);
1928         _safeMint(to, tokenId);
1929         _setTokenIPFSMetadataHash(tokenId, ipfsHash);
1930     }
1931 
1932     /**
1933      * @notice Mints multiple Artifex NFTs for same series and nftType
1934      * @param to address of the recipient
1935      * @param seriesId series to mint
1936      * @param nftType the type of nft - 1 for 2D piece, 2 for 3D piece
1937      * @param nftStartingNum the starting edition number of the nft
1938      * @param numTokens the number of tokens to mint in the edition,
1939      * starting from nftStartingNum edition number
1940      * @param ipfsHashes an array of ipfsHashes of each token's Metadata on ipfs
1941      */
1942     function batchMintArtifexNft(
1943         address to,
1944         uint256 seriesId,
1945         uint256 nftType,
1946         uint256 nftStartingNum,
1947         uint256 numTokens,
1948         string[] memory ipfsHashes
1949     ) public anyOperator {
1950         require(
1951             numTokens == ipfsHashes.length,
1952             "numTokens and num ipfsHashes must match"
1953         );
1954         for (uint256 i = 0; i < numTokens; i++) {
1955             mintArtifexNft(
1956                 to,
1957                 seriesId,
1958                 nftType,
1959                 nftStartingNum + i,
1960                 ipfsHashes[i]
1961             );
1962         }
1963     }
1964 
1965     /**
1966      * @notice Given a token ID, return the series ID of the token
1967      * @param tokenId the token ID
1968      * @return the series ID of the token
1969      */
1970     function getSeriesId(uint256 tokenId) public pure returns (uint256) {
1971         return (uint256(tokenId / SERIES_MULTIPLIER));
1972     }
1973 
1974     /**
1975      * @notice Given a token ID, return the nft type of the token
1976      * @param tokenId the token ID
1977      * @return the nft type of the token
1978      */
1979     function getNftType(uint256 tokenId) public pure returns (uint256) {
1980         uint256 seriesId = getSeriesId(tokenId);
1981         return
1982             uint256(
1983                 (tokenId - (SERIES_MULTIPLIER * seriesId)) / NFT_TYPE_MULTIPLIER
1984             );
1985     }
1986 
1987     /**
1988      * @notice Given a token ID, return the nft edition number of the token
1989      * @param tokenId the token ID
1990      * @return the nft edition number of the token
1991      */
1992     function getNftNum(uint256 tokenId) public pure returns (uint256) {
1993         uint256 seriesId = getSeriesId(tokenId);
1994         uint256 nftType = getNftType(tokenId);
1995         return
1996             uint256(
1997                 tokenId -
1998                     (SERIES_MULTIPLIER * seriesId) -
1999                     (nftType * NFT_TYPE_MULTIPLIER)
2000             );
2001     }
2002 
2003     /**
2004      * @notice Generate a tokenId given the series ID, nft type,
2005      * and nft edition number
2006      * @param seriesId series to mint
2007      * @param nftType the type of nft - 1 for 2D piece, 2 for 3D piece
2008      * @param nftNum the edition number of the nft
2009      * @return the token ID
2010      */
2011     function encodeTokenId(
2012         uint256 seriesId,
2013         uint256 nftType,
2014         uint256 nftNum
2015     ) public pure returns (uint256) {
2016         return ((seriesId * SERIES_MULTIPLIER) +
2017             (nftType * NFT_TYPE_MULTIPLIER) +
2018             nftNum);
2019     }
2020 
2021     /**
2022      * @notice Given a token ID, return the name of the artist name
2023      * for the token
2024      * @param tokenId the token ID
2025      * @return artistName the name of the artist
2026      */
2027     function getArtistNameByTokenId(uint256 tokenId)
2028         public
2029         view
2030         returns (string memory artistName)
2031     {
2032         require(_exists(tokenId), "Token does not exist");
2033         if (getNftType(tokenId) == 1) {
2034             artistName = artist2DSeriesInfo[getSeriesId(tokenId)].artistName;
2035         } else if (getNftType(tokenId) == 2) {
2036             artistName = artist3DSeriesInfo[getSeriesId(tokenId)].artistName;
2037         }
2038     }
2039 
2040     /**
2041      * @notice Given a series ID and nft type, return information about the series
2042      * @param seriesId series to mint
2043      * @param nftType the type of nft - 1 for 2D piece, 2 for 3D piece
2044      * @return seriesInfo structure with series information
2045      */
2046     function getSeriesInfo(uint256 seriesId, uint256 nftType)
2047         public
2048         view
2049         returns (
2050             ArtistNFTSeriesInfo memory seriesInfo,
2051             ArtistNFTSeries3DModelInfo memory series3dModelInfo
2052         )
2053     {
2054         if (nftType == 1) {
2055             seriesInfo = artist2DSeriesInfo[seriesId];
2056         } else if (nftType == 2) {
2057             seriesInfo = artist3DSeriesInfo[seriesId];
2058             series3dModelInfo = artistSeries3DModelInfo[seriesId];
2059         }
2060     }
2061 
2062     /**
2063      * @notice Given a token ID, return information about the series
2064      * @param tokenId the token ID
2065      * @return seriesInfo structure with series information
2066      */
2067     function getSeriesInfoByTokenId(uint256 tokenId)
2068         public
2069         view
2070         returns (
2071             ArtistNFTSeriesInfo memory seriesInfo,
2072             ArtistNFTSeries3DModelInfo memory series3dModelInfo
2073         )
2074     {
2075         require(_exists(tokenId), "Token does not exist");
2076         (seriesInfo, series3dModelInfo) = getSeriesInfo(
2077             getSeriesId(tokenId),
2078             getNftType(tokenId)
2079         );
2080     }
2081 
2082     /**
2083      * @dev Returns an URI for a given token ID.
2084      * See {IERC721Metadata-tokenURI}.
2085      * @param tokenId uint256 ID of the token to query
2086      * @return URI for location of the off-chain metadata
2087      */
2088     function tokenURI(uint256 tokenId)
2089         public
2090         view
2091         virtual
2092         override
2093         returns (string memory)
2094     {
2095         require(
2096             _exists(tokenId),
2097             "ERC721Metadata: URI query for nonexistent token"
2098         );
2099 
2100         return
2101             bytes(_baseTokenURI).length > 0
2102                 ? string(
2103                     abi.encodePacked(
2104                         _baseTokenURI,
2105                         tokenIdToIPFSMetadataHash[tokenId]
2106                     )
2107                 )
2108                 : "";
2109     }
2110 
2111     /**
2112      * @dev Returns the actual CID hash pointing to the token's metadata on IPFS.
2113      * @param tokenId token ID of the token to query
2114      * @return the ipfs hash of the metadata
2115      */
2116     function tokenIPFSMetadataHash(uint256 tokenId)
2117         public
2118         view
2119         returns (string memory)
2120     {
2121         return tokenIdToIPFSMetadataHash[tokenId];
2122     }
2123 
2124     /**
2125      * @notice Given a token ID, return the external URI for viewing the nft on a
2126      * web site.
2127      * @param tokenId the token ID
2128      * @return external URI
2129      */
2130     function externalURI(uint256 tokenId) public view returns (string memory) {
2131         return
2132             string(abi.encodePacked(_externalBaseTokenURI, tokenId.toString()));
2133     }
2134 
2135     /**
2136      * @notice return the base URI used for accessing off-chain metadata
2137      * @return base URI for location of the off-chain metadata
2138      */
2139     function _baseURI() internal view virtual override returns (string memory) {
2140         return _baseTokenURI;
2141     }
2142 
2143     /**
2144      * @dev Private function to set the token IPFS hash for a given token.
2145      * Reverts if the token ID does not exist.
2146      * @param tokenId uint256 ID of the token to set its URI
2147      * @param ipfs_hash string IPFS link to assign
2148      */
2149     function _setTokenIPFSMetadataHash(uint256 tokenId, string memory ipfs_hash)
2150         private
2151     {
2152         require(
2153             _exists(tokenId),
2154             "ERC721Metadata: URI set of nonexistent token"
2155         );
2156         tokenIdToIPFSMetadataHash[tokenId] = ipfs_hash;
2157     }
2158 }