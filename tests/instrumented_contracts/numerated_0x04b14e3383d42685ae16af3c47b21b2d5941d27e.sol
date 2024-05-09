1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts/access/Ownable.sol
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(
88             newOwner != address(0),
89             "Ownable: new owner is the zero address"
90         );
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Required interface of an ERC721 compliant contract.
132  */
133 interface IERC721 is IERC165 {
134     /**
135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
136      */
137     event Transfer(
138         address indexed from,
139         address indexed to,
140         uint256 indexed tokenId
141     );
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(
147         address indexed owner,
148         address indexed approved,
149         uint256 indexed tokenId
150     );
151 
152     /**
153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(
156         address indexed owner,
157         address indexed operator,
158         bool approved
159     );
160 
161     /**
162      * @dev Returns the number of tokens in ``owner``'s account.
163      */
164     function balanceOf(address owner) external view returns (uint256 balance);
165 
166     /**
167      * @dev Returns the owner of the `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function ownerOf(uint256 tokenId) external view returns (address owner);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Returns the account approved for `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function getApproved(uint256 tokenId)
238         external
239         view
240         returns (address operator);
241 
242     /**
243      * @dev Approve or remove `operator` as an operator for the caller.
244      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
256      *
257      * See {setApprovalForAll}
258      */
259     function isApprovedForAll(address owner, address operator)
260         external
261         view
262         returns (bool);
263 
264     /**
265      * @dev Safely transfers `tokenId` token from `from` to `to`.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId,
281         bytes calldata data
282     ) external;
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
291  * @dev See https://eips.ethereum.org/EIPS/eip-721
292  */
293 interface IERC721Enumerable is IERC721 {
294     /**
295      * @dev Returns the total amount of tokens stored by the contract.
296      */
297     function totalSupply() external view returns (uint256);
298 
299     /**
300      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
301      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
302      */
303     function tokenOfOwnerByIndex(address owner, uint256 index)
304         external
305         view
306         returns (uint256 tokenId);
307 
308     /**
309      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
310      * Use along with {totalSupply} to enumerate all tokens.
311      */
312     function tokenByIndex(uint256 index) external view returns (uint256);
313 }
314 
315 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Implementation of the {IERC165} interface.
321  *
322  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
323  * for the additional interface id that will be supported. For example:
324  *
325  * ```solidity
326  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
328  * }
329  * ```
330  *
331  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
332  */
333 abstract contract ERC165 is IERC165 {
334     /**
335      * @dev See {IERC165-supportsInterface}.
336      */
337     function supportsInterface(bytes4 interfaceId)
338         public
339         view
340         virtual
341         override
342         returns (bool)
343     {
344         return interfaceId == type(IERC165).interfaceId;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/utils/Strings.sol
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev String operations.
354  */
355 library Strings {
356     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         // Inspired by OraclizeAPI's implementation - MIT licence
363         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364 
365         if (value == 0) {
366             return "0";
367         }
368         uint256 temp = value;
369         uint256 digits;
370         while (temp != 0) {
371             digits++;
372             temp /= 10;
373         }
374         bytes memory buffer = new bytes(digits);
375         while (value != 0) {
376             digits -= 1;
377             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
378             value /= 10;
379         }
380         return string(buffer);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         if (value == 0) {
388             return "0x00";
389         }
390         uint256 temp = value;
391         uint256 length = 0;
392         while (temp != 0) {
393             length++;
394             temp >>= 8;
395         }
396         return toHexString(value, length);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length)
403         internal
404         pure
405         returns (string memory)
406     {
407         bytes memory buffer = new bytes(2 * length + 2);
408         buffer[0] = "0";
409         buffer[1] = "x";
410         for (uint256 i = 2 * length + 1; i > 1; --i) {
411             buffer[i] = _HEX_SYMBOLS[value & 0xf];
412             value >>= 4;
413         }
414         require(value == 0, "Strings: hex length insufficient");
415         return string(buffer);
416     }
417 }
418 
419 // File: @openzeppelin/contracts/utils/Address.sol
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * [IMPORTANT]
431      * ====
432      * It is unsafe to assume that an address for which this function returns
433      * false is an externally-owned account (EOA) and not a contract.
434      *
435      * Among others, `isContract` will return false for the following
436      * types of addresses:
437      *
438      *  - an externally-owned account
439      *  - a contract in construction
440      *  - an address where a contract will be created
441      *  - an address where a contract lived, but was destroyed
442      * ====
443      */
444     function isContract(address account) internal view returns (bool) {
445         // This method relies on extcodesize, which returns 0 for contracts in
446         // construction, since the code is only stored at the end of the
447         // constructor execution.
448 
449         uint256 size;
450         assembly {
451             size := extcodesize(account)
452         }
453         return size > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(
474             address(this).balance >= amount,
475             "Address: insufficient balance"
476         );
477 
478         (bool success, ) = recipient.call{value: amount}("");
479         require(
480             success,
481             "Address: unable to send value, recipient may have reverted"
482         );
483     }
484 
485     /**
486      * @dev Performs a Solidity function call using a low level `call`. A
487      * plain `call` is an unsafe replacement for a function call: use this
488      * function instead.
489      *
490      * If `target` reverts with a revert reason, it is bubbled up by this
491      * function (like regular Solidity function calls).
492      *
493      * Returns the raw returned data. To convert to the expected return value,
494      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
495      *
496      * Requirements:
497      *
498      * - `target` must be a contract.
499      * - calling `target` with `data` must not revert.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(address target, bytes memory data)
504         internal
505         returns (bytes memory)
506     {
507         return functionCall(target, data, "Address: low-level call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
512      * `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         return functionCallWithValue(target, data, 0, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but also transferring `value` wei to `target`.
527      *
528      * Requirements:
529      *
530      * - the calling contract must have an ETH balance of at least `value`.
531      * - the called Solidity function must be `payable`.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value
539     ) internal returns (bytes memory) {
540         return
541             functionCallWithValue(
542                 target,
543                 data,
544                 value,
545                 "Address: low-level call with value failed"
546             );
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
551      * with `errorMessage` as a fallback revert reason when `target` reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(
562             address(this).balance >= value,
563             "Address: insufficient balance for call"
564         );
565         require(isContract(target), "Address: call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.call{value: value}(
568             data
569         );
570         return verifyCallResult(success, returndata, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but performing a static call.
576      *
577      * _Available since v3.3._
578      */
579     function functionStaticCall(address target, bytes memory data)
580         internal
581         view
582         returns (bytes memory)
583     {
584         return
585             functionStaticCall(
586                 target,
587                 data,
588                 "Address: low-level static call failed"
589             );
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.staticcall(data);
606         return verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(address target, bytes memory data)
616         internal
617         returns (bytes memory)
618     {
619         return
620             functionDelegateCall(
621                 target,
622                 data,
623                 "Address: low-level delegate call failed"
624             );
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(
634         address target,
635         bytes memory data,
636         string memory errorMessage
637     ) internal returns (bytes memory) {
638         require(isContract(target), "Address: delegate call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.delegatecall(data);
641         return verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
646      * revert reason using the provided one.
647      *
648      * _Available since v4.3._
649      */
650     function verifyCallResult(
651         bool success,
652         bytes memory returndata,
653         string memory errorMessage
654     ) internal pure returns (bytes memory) {
655         if (success) {
656             return returndata;
657         } else {
658             // Look for revert reason and bubble it up if present
659             if (returndata.length > 0) {
660                 // The easiest way to bubble the revert reason is using memory via assembly
661 
662                 assembly {
663                     let returndata_size := mload(returndata)
664                     revert(add(32, returndata), returndata_size)
665                 }
666             } else {
667                 revert(errorMessage);
668             }
669         }
670     }
671 }
672 
673 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
679  * @dev See https://eips.ethereum.org/EIPS/eip-721
680  */
681 interface IERC721Metadata is IERC721 {
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() external view returns (string memory);
686 
687     /**
688      * @dev Returns the token collection symbol.
689      */
690     function symbol() external view returns (string memory);
691 
692     /**
693      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
694      */
695     function tokenURI(uint256 tokenId) external view returns (string memory);
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
699 
700 pragma solidity ^0.8.0;
701 
702 /**
703  * @title ERC721 token receiver interface
704  * @dev Interface for any contract that wants to support safeTransfers
705  * from ERC721 asset contracts.
706  */
707 interface IERC721Receiver {
708     /**
709      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
710      * by `operator` from `from`, this function is called.
711      *
712      * It must return its Solidity selector to confirm the token transfer.
713      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
714      *
715      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
716      */
717     function onERC721Received(
718         address operator,
719         address from,
720         uint256 tokenId,
721         bytes calldata data
722     ) external returns (bytes4);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension, but not including the Enumerable extension, which is available separately as
732  * {ERC721Enumerable}.
733  */
734 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to owner address
745     mapping(uint256 => address) private _owners;
746 
747     // Mapping owner address to token count
748     mapping(address => uint256) private _balances;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     /**
757      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
758      */
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId)
768         public
769         view
770         virtual
771         override(ERC165, IERC165)
772         returns (bool)
773     {
774         return
775             interfaceId == type(IERC721).interfaceId ||
776             interfaceId == type(IERC721Metadata).interfaceId ||
777             super.supportsInterface(interfaceId);
778     }
779 
780     /**
781      * @dev See {IERC721-balanceOf}.
782      */
783     function balanceOf(address owner)
784         public
785         view
786         virtual
787         override
788         returns (uint256)
789     {
790         require(
791             owner != address(0),
792             "ERC721: balance query for the zero address"
793         );
794         return _balances[owner];
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId)
801         public
802         view
803         virtual
804         override
805         returns (address)
806     {
807         address owner = _owners[tokenId];
808         require(
809             owner != address(0),
810             "ERC721: owner query for nonexistent token"
811         );
812         return owner;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-name}.
817      */
818     function name() public view virtual override returns (string memory) {
819         return _name;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-symbol}.
824      */
825     function symbol() public view virtual override returns (string memory) {
826         return _symbol;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-tokenURI}.
831      */
832     function tokenURI(uint256 tokenId)
833         public
834         view
835         virtual
836         override
837         returns (string memory)
838     {
839         require(
840             _exists(tokenId),
841             "ERC721Metadata: URI query for nonexistent token"
842         );
843 
844         string memory baseURI = _baseURI();
845         return
846             bytes(baseURI).length > 0
847                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
848                 : "";
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return "";
858     }
859 
860     /**
861      * @dev See {IERC721-approve}.
862      */
863     function approve(address to, uint256 tokenId) public virtual override {
864         address owner = ERC721.ownerOf(tokenId);
865         require(to != owner, "ERC721: approval to current owner");
866 
867         require(
868             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
869             "ERC721: approve caller is not owner nor approved for all"
870         );
871 
872         _approve(to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId)
879         public
880         view
881         virtual
882         override
883         returns (address)
884     {
885         require(
886             _exists(tokenId),
887             "ERC721: approved query for nonexistent token"
888         );
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved)
897         public
898         virtual
899         override
900     {
901         require(operator != _msgSender(), "ERC721: approve to caller");
902 
903         _operatorApprovals[_msgSender()][operator] = approved;
904         emit ApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     /**
908      * @dev See {IERC721-isApprovedForAll}.
909      */
910     function isApprovedForAll(address owner, address operator)
911         public
912         view
913         virtual
914         override
915         returns (bool)
916     {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         //solhint-disable-next-line max-line-length
929         require(
930             _isApprovedOrOwner(_msgSender(), tokenId),
931             "ERC721: transfer caller is not owner nor approved"
932         );
933 
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, "");
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         require(
958             _isApprovedOrOwner(_msgSender(), tokenId),
959             "ERC721: transfer caller is not owner nor approved"
960         );
961         _safeTransfer(from, to, tokenId, _data);
962     }
963 
964     /**
965      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
966      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
967      *
968      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
969      *
970      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
971      * implement alternative mechanisms to perform token transfer, such as signature-based.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeTransfer(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) internal virtual {
988         _transfer(from, to, tokenId);
989         require(
990             _checkOnERC721Received(from, to, tokenId, _data),
991             "ERC721: transfer to non ERC721Receiver implementer"
992         );
993     }
994 
995     /**
996      * @dev Returns whether `tokenId` exists.
997      *
998      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
999      *
1000      * Tokens start existing when they are minted (`_mint`),
1001      * and stop existing when they are burned (`_burn`).
1002      */
1003     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1004         return _owners[tokenId] != address(0);
1005     }
1006 
1007     /**
1008      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      */
1014     function _isApprovedOrOwner(address spender, uint256 tokenId)
1015         internal
1016         view
1017         virtual
1018         returns (bool)
1019     {
1020         require(
1021             _exists(tokenId),
1022             "ERC721: operator query for nonexistent token"
1023         );
1024         address owner = ERC721.ownerOf(tokenId);
1025         return (spender == owner ||
1026             getApproved(tokenId) == spender ||
1027             isApprovedForAll(owner, spender));
1028     }
1029 
1030     /**
1031      * @dev Safely mints `tokenId` and transfers it to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _safeMint(address to, uint256 tokenId) internal virtual {
1041         _safeMint(to, tokenId, "");
1042     }
1043 
1044     /**
1045      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1046      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1047      */
1048     function _safeMint(
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _mint(to, tokenId);
1054         require(
1055             _checkOnERC721Received(address(0), to, tokenId, _data),
1056             "ERC721: transfer to non ERC721Receiver implementer"
1057         );
1058     }
1059 
1060     /**
1061      * @dev Mints `tokenId` and transfers it to `to`.
1062      *
1063      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must not exist.
1068      * - `to` cannot be the zero address.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(address to, uint256 tokenId) internal virtual {
1073         require(to != address(0), "ERC721: mint to the zero address");
1074         require(!_exists(tokenId), "ERC721: token already minted");
1075 
1076         _beforeTokenTransfer(address(0), to, tokenId);
1077 
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(address(0), to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId) internal virtual {
1095         address owner = ERC721.ownerOf(tokenId);
1096 
1097         _beforeTokenTransfer(owner, address(0), tokenId);
1098 
1099         // Clear approvals
1100         _approve(address(0), tokenId);
1101 
1102         _balances[owner] -= 1;
1103         delete _owners[tokenId];
1104 
1105         emit Transfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(
1125             ERC721.ownerOf(tokenId) == from,
1126             "ERC721: transfer of token that is not own"
1127         );
1128         require(to != address(0), "ERC721: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, tokenId);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId);
1134 
1135         _balances[from] -= 1;
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(from, to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(address to, uint256 tokenId) internal virtual {
1148         _tokenApprovals[tokenId] = to;
1149         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1154      * The call is not executed if the target address is not a contract.
1155      *
1156      * @param from address representing the previous owner of the given token ID
1157      * @param to target address that will receive the tokens
1158      * @param tokenId uint256 ID of the token to be transferred
1159      * @param _data bytes optional data to send along with the call
1160      * @return bool whether the call correctly returned the expected magic value
1161      */
1162     function _checkOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         if (to.isContract()) {
1169             try
1170                 IERC721Receiver(to).onERC721Received(
1171                     _msgSender(),
1172                     from,
1173                     tokenId,
1174                     _data
1175                 )
1176             returns (bytes4 retval) {
1177                 return retval == IERC721Receiver.onERC721Received.selector;
1178             } catch (bytes memory reason) {
1179                 if (reason.length == 0) {
1180                     revert(
1181                         "ERC721: transfer to non ERC721Receiver implementer"
1182                     );
1183                 } else {
1184                     assembly {
1185                         revert(add(32, reason), mload(reason))
1186                     }
1187                 }
1188             }
1189         } else {
1190             return true;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before any token transfer. This includes minting
1196      * and burning.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1204      * - `from` and `to` are never both zero.
1205      *
1206      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1207      */
1208     function _beforeTokenTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {}
1213 }
1214 
1215 // File: Animathereum.sol
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 /**
1224  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1225  * enumerability of all the token ids in the contract as well as all token ids owned by each
1226  * account.
1227  */
1228 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
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
1248         override(IERC165, ERC721)
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
1407 contract SAKURAToken is ERC721Enumerable, Ownable {
1408     uint256 public constant MAX_NFTS = 10000;
1409     uint256[MAX_NFTS] internal indices;
1410     bool public allPaused = true;
1411     string _baseTokenURI = "ipfs://QmTF6Q84j5THVncBdh2DsAHSTpNT1N9hgEHvCC8AorSu1f";
1412 
1413     uint256 public round = 0;
1414     uint256 public roundSalePerRound = 0;
1415     uint256 public startRoundBlock;
1416     uint256 public blockPerRound = 100;
1417 
1418     uint256 internal nonce = 0;
1419 
1420     enum MarketType {
1421         PreSale,
1422         TimeAttackSale,
1423         RoundSale
1424     }
1425 
1426     struct Market {
1427         bool paused;
1428         uint256 price;
1429         uint256 saleCount;
1430         uint256 maxAmount;
1431     }
1432 
1433     mapping(uint256 => Market) private marketList;
1434 
1435     constructor(address _to, uint256 _initialMint)
1436         ERC721("SakuraApe", "SAKURA")
1437     {
1438         for (uint256 i = 0; i < _initialMint; i++) {
1439             _safeMint(_to, _generateRandomIndex());
1440         }
1441         marketList[uint256(MarketType.PreSale)].saleCount += _initialMint;
1442         marketList[uint256(MarketType.PreSale)] = Market(
1443             true,
1444             50_000_000_000_000_000,
1445             _initialMint,
1446             1000
1447         ); // preSale: initial price 0.05 ether & initial max 1000
1448         marketList[uint256(MarketType.TimeAttackSale)] = Market(
1449             true,
1450             60_000_000_000_000_000,
1451             0,
1452             2000
1453         ); // timeAttackSale: initial price 0.06 ether & initial max 2000
1454         marketList[uint256(MarketType.RoundSale)] = Market(
1455             true,
1456             80_000_000_000_000_000,
1457             0,
1458             100
1459         ); // roundSale: initial price 0.08 ether & max 100 per round
1460     }
1461 
1462     function pauseAllMarket(bool _paused) public onlyOwner {
1463         allPaused = _paused;
1464     }
1465 
1466     function getMarketInfo(uint256 _marketType)
1467         public
1468         view
1469         returns (
1470             bool,
1471             uint256,
1472             uint256,
1473             uint256
1474         )
1475     {
1476         return (
1477             marketList[_marketType].paused,
1478             marketList[_marketType].price,
1479             marketList[_marketType].saleCount,
1480             marketList[_marketType].maxAmount
1481         );
1482     }
1483 
1484     function setMarketStatus(
1485         uint256 _marketType,
1486         bool _paused,
1487         uint256 _price,
1488         uint256 _saleCount,
1489         uint256 _maxAmount
1490     ) public onlyOwner {
1491         marketList[_marketType].paused = _paused;
1492         marketList[_marketType].price = _price;
1493         marketList[_marketType].saleCount = _saleCount;
1494         marketList[_marketType].maxAmount = _maxAmount;
1495     }
1496 
1497     function startRoundSale() public onlyOwner {
1498         marketList[uint256(MarketType.RoundSale)].paused = false;
1499         round = 1;
1500         startRoundBlock = block.number;
1501     }
1502 
1503     function getPredictRoundPrice() public view returns (uint256) {
1504         return
1505             (marketList[uint256(MarketType.RoundSale)].price *
1506                 (50 + roundSalePerRound)) / 100;
1507     }
1508 
1509     function setBlockPerRound(uint256 _blockPerRound) public onlyOwner {
1510         blockPerRound = _blockPerRound;
1511     }
1512 
1513     function setNextRound() internal {
1514         uint256 nextRoundPrice = getPredictRoundPrice();
1515 
1516         if (nextRoundPrice < 100_000_000_000_000_000) {
1517             marketList[uint256(MarketType.RoundSale)]
1518                 .price = 100_000_000_000_000_000;
1519         } else {
1520             marketList[uint256(MarketType.RoundSale)].price = nextRoundPrice;
1521         }
1522         round++;
1523         roundSalePerRound = 0;
1524         startRoundBlock += blockPerRound;
1525     }
1526 
1527     function setEmergencyNextRound() public onlyOwner {
1528         uint256 nextRoundPrice = getPredictRoundPrice();
1529 
1530         if (nextRoundPrice < 100_000_000_000_000_000) {
1531             marketList[uint256(MarketType.RoundSale)]
1532                 .price = 100_000_000_000_000_000;
1533         } else {
1534             marketList[uint256(MarketType.RoundSale)].price = nextRoundPrice;
1535         }
1536         round++;
1537         roundSalePerRound = 0;
1538         startRoundBlock += blockPerRound;
1539     }
1540 
1541     function preMint(address _to, uint256 _count) public payable {
1542         require(
1543             !marketList[uint256(MarketType.PreSale)].paused,
1544             "This is not pre-sale period"
1545         );
1546         require(
1547             marketList[uint256(MarketType.PreSale)].saleCount + _count <
1548                 marketList[uint256(MarketType.PreSale)].maxAmount,
1549             "max limit for preSale market"
1550         );
1551         require(
1552             msg.value >=
1553                 (marketList[uint256(MarketType.PreSale)].price * _count),
1554             "Value below price"
1555         );
1556 
1557         mulitpleMint(_to, _count);
1558         marketList[uint256(MarketType.PreSale)].saleCount += _count;
1559     }
1560 
1561     function timeAttackMint(address _to, uint256 _count) public payable {
1562         require(
1563             !marketList[uint256(MarketType.TimeAttackSale)].paused,
1564             "This is not timeattack-sale period"
1565         );
1566         require(
1567             marketList[uint256(MarketType.TimeAttackSale)].saleCount + _count <
1568                 marketList[uint256(MarketType.TimeAttackSale)].maxAmount,
1569             "max limit for timeAttackSale market"
1570         );
1571         require(
1572             msg.value >=
1573                 (marketList[uint256(MarketType.TimeAttackSale)].price * _count),
1574             "Value below price"
1575         );
1576         mulitpleMint(_to, _count);
1577         marketList[uint256(MarketType.TimeAttackSale)].saleCount += _count;
1578     }
1579 
1580     function roundMint(address _to, uint256 _count) public payable {
1581         require(
1582             !marketList[uint256(MarketType.RoundSale)].paused,
1583             "This is not round-sale period"
1584         );
1585         require(
1586             roundSalePerRound + _count <
1587                 marketList[uint256(MarketType.RoundSale)].maxAmount,
1588             "This round max limit"
1589         );
1590         require(
1591             msg.value >=
1592                 (marketList[uint256(MarketType.RoundSale)].price * _count),
1593             "Value below price"
1594         );
1595         // over 3 times no minting then stop
1596         if (startRoundBlock + (blockPerRound * 3) < block.number) {
1597             marketList[uint256(MarketType.RoundSale)].paused = true;
1598             return;
1599         }
1600         //check block number over this round
1601         if (startRoundBlock + blockPerRound < block.number) {
1602             setNextRound();
1603         }
1604 
1605         mulitpleMint(_to, _count);
1606         roundSalePerRound += _count;
1607         marketList[uint256(MarketType.RoundSale)].saleCount += _count;
1608     }
1609 
1610     function mulitpleMint(address _to, uint256 _count) internal {
1611         require(!allPaused, "all market paused");
1612         require(_count <= 30, "Exceeds 30");
1613         require(totalSupply() + _count <= MAX_NFTS, "Max limit");
1614         require(totalSupply() < MAX_NFTS, "Sale end");
1615         for (uint256 i = 0; i < _count; i++) {
1616             _safeMint(_to, _generateRandomIndex());
1617         }
1618     }
1619 
1620     function walletOfOwner(address _owner)
1621         external
1622         view
1623         returns (uint256[] memory)
1624     {
1625         uint256 tokenCount = balanceOf(_owner);
1626         uint256[] memory tokensId = new uint256[](tokenCount);
1627         for (uint256 i = 0; i < tokenCount; i++) {
1628             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1629         }
1630         return tokensId;
1631     }
1632 
1633     function withdrawAll() public payable onlyOwner {
1634         require(payable(msg.sender).send(address(this).balance));
1635     }
1636 
1637     function _baseURI() internal view virtual override returns (string memory) {
1638         return _baseTokenURI;
1639     }
1640 
1641     function setBaseURI(string memory baseURI) public onlyOwner {
1642         _baseTokenURI = baseURI;
1643     }
1644 
1645     function _generateRandomIndex() internal returns (uint256) {
1646         uint256 totalSize = MAX_NFTS - totalSupply();
1647         uint256 index = uint256(
1648             keccak256(
1649                 abi.encodePacked(
1650                     nonce,
1651                     msg.sender,
1652                     block.difficulty,
1653                     block.timestamp
1654                 )
1655             )
1656         ) % totalSize;
1657 
1658         uint256 value = 0;
1659         if (indices[index] != 0) {
1660             value = indices[index];
1661         } else {
1662             value = index;
1663         }
1664 
1665         // Move last value to selected position
1666         if (indices[totalSize - 1] == 0) {
1667             // Array position not initialized, so use position
1668             indices[index] = totalSize - 1;
1669         } else {
1670             // Array position holds a value so use that
1671             indices[index] = indices[totalSize - 1];
1672         }
1673         nonce++;
1674         // Don't allow a zero index, start counting at 1
1675         return value++;
1676     }
1677 }