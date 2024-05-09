1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Context.sol
8 
9 pragma solidity ^0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
66      */
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 indexed tokenId
71     );
72 
73     /**
74      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
75      */
76     event Approval(
77         address indexed owner,
78         address indexed approved,
79         uint256 indexed tokenId
80     );
81 
82     /**
83      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
84      */
85     event ApprovalForAll(
86         address indexed owner,
87         address indexed operator,
88         bool approved
89     );
90 
91     /**
92      * @dev Returns the number of tokens in ``owner``'s account.
93      */
94     function balanceOf(address owner) external view returns (uint256 balance);
95 
96     /**
97      * @dev Returns the owner of the `tokenId` token.
98      *
99      * Requirements:
100      *
101      * - `tokenId` must exist.
102      */
103     function ownerOf(uint256 tokenId) external view returns (address owner);
104 
105     /**
106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must exist and be owned by `from`.
114      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
116      *
117      * Emits a {Transfer} event.
118      */
119     function safeTransferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Transfers `tokenId` token from `from` to `to`.
127      *
128      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
147      * The approval is cleared when the token is transferred.
148      *
149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
150      *
151      * Requirements:
152      *
153      * - The caller must own the token or be an approved operator.
154      * - `tokenId` must exist.
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address to, uint256 tokenId) external;
159 
160     /**
161      * @dev Returns the account approved for `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function getApproved(uint256 tokenId)
168         external
169         view
170         returns (address operator);
171 
172     /**
173      * @dev Approve or remove `operator` as an operator for the caller.
174      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
175      *
176      * Requirements:
177      *
178      * - The `operator` cannot be the caller.
179      *
180      * Emits an {ApprovalForAll} event.
181      */
182     function setApprovalForAll(address operator, bool _approved) external;
183 
184     /**
185      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
186      *
187      * See {setApprovalForAll}
188      */
189     function isApprovedForAll(address owner, address operator)
190         external
191         view
192         returns (bool);
193 
194     /**
195      * @dev Safely transfers `tokenId` token from `from` to `to`.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must exist and be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
203      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
204      *
205      * Emits a {Transfer} event.
206      */
207     function safeTransferFrom(
208         address from,
209         address to,
210         uint256 tokenId,
211         bytes calldata data
212     ) external;
213 }
214 
215 // File: @openzeppelin/contracts/access/Ownable.sol
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(
235         address indexed previousOwner,
236         address indexed newOwner
237     );
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor() {
243         _setOwner(_msgSender());
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view virtual returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Leaves the contract without owner. It will not be possible to call
263      * `onlyOwner` functions anymore. Can only be called by the current owner.
264      *
265      * NOTE: Renouncing ownership will leave the contract without an owner,
266      * thereby removing any functionality that is only available to the owner.
267      */
268     function renounceOwnership() public virtual onlyOwner {
269         _setOwner(address(0));
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      * Can only be called by the current owner.
275      */
276     function transferOwnership(address newOwner) public virtual onlyOwner {
277         require(
278             newOwner != address(0),
279             "Ownable: new owner is the zero address"
280         );
281         _setOwner(newOwner);
282     }
283 
284     function _setOwner(address newOwner) private {
285         address oldOwner = _owner;
286         _owner = newOwner;
287         emit OwnershipTransferred(oldOwner, newOwner);
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Implementation of the {IERC165} interface.
297  *
298  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
299  * for the additional interface id that will be supported. For example:
300  *
301  * ```solidity
302  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
304  * }
305  * ```
306  *
307  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
308  */
309 abstract contract ERC165 is IERC165 {
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId)
314         public
315         view
316         virtual
317         override
318         returns (bool)
319     {
320         return interfaceId == type(IERC165).interfaceId;
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/Strings.sol
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev String operations.
330  */
331 library Strings {
332     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
336      */
337     function toString(uint256 value) internal pure returns (string memory) {
338         // Inspired by OraclizeAPI's implementation - MIT licence
339         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
340 
341         if (value == 0) {
342             return "0";
343         }
344         uint256 temp = value;
345         uint256 digits;
346         while (temp != 0) {
347             digits++;
348             temp /= 10;
349         }
350         bytes memory buffer = new bytes(digits);
351         while (value != 0) {
352             digits -= 1;
353             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
354             value /= 10;
355         }
356         return string(buffer);
357     }
358 
359     /**
360      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
361      */
362     function toHexString(uint256 value) internal pure returns (string memory) {
363         if (value == 0) {
364             return "0x00";
365         }
366         uint256 temp = value;
367         uint256 length = 0;
368         while (temp != 0) {
369             length++;
370             temp >>= 8;
371         }
372         return toHexString(value, length);
373     }
374 
375     /**
376      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
377      */
378     function toHexString(uint256 value, uint256 length)
379         internal
380         pure
381         returns (string memory)
382     {
383         bytes memory buffer = new bytes(2 * length + 2);
384         buffer[0] = "0";
385         buffer[1] = "x";
386         for (uint256 i = 2 * length + 1; i > 1; --i) {
387             buffer[i] = _HEX_SYMBOLS[value & 0xf];
388             value >>= 4;
389         }
390         require(value == 0, "Strings: hex length insufficient");
391         return string(buffer);
392     }
393 }
394 
395 // File: @openzeppelin/contracts/utils/Address.sol
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Collection of functions related to the address type
401  */
402 library Address {
403     /**
404      * @dev Returns true if `account` is a contract.
405      *
406      * [IMPORTANT]
407      * ====
408      * It is unsafe to assume that an address for which this function returns
409      * false is an externally-owned account (EOA) and not a contract.
410      *
411      * Among others, `isContract` will return false for the following
412      * types of addresses:
413      *
414      *  - an externally-owned account
415      *  - a contract in construction
416      *  - an address where a contract will be created
417      *  - an address where a contract lived, but was destroyed
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize, which returns 0 for contracts in
422         // construction, since the code is only stored at the end of the
423         // constructor execution.
424 
425         uint256 size;
426         assembly {
427             size := extcodesize(account)
428         }
429         return size > 0;
430     }
431 
432     /**
433      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
434      * `recipient`, forwarding all available gas and reverting on errors.
435      *
436      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
437      * of certain opcodes, possibly making contracts go over the 2300 gas limit
438      * imposed by `transfer`, making them unable to receive funds via
439      * `transfer`. {sendValue} removes this limitation.
440      *
441      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
442      *
443      * IMPORTANT: because control is transferred to `recipient`, care must be
444      * taken to not create reentrancy vulnerabilities. Consider using
445      * {ReentrancyGuard} or the
446      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
447      */
448     function sendValue(address payable recipient, uint256 amount) internal {
449         require(
450             address(this).balance >= amount,
451             "Address: insufficient balance"
452         );
453 
454         (bool success, ) = recipient.call{value: amount}("");
455         require(
456             success,
457             "Address: unable to send value, recipient may have reverted"
458         );
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain `call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data)
480         internal
481         returns (bytes memory)
482     {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return
517             functionCallWithValue(
518                 target,
519                 data,
520                 value,
521                 "Address: low-level call with value failed"
522             );
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         require(
538             address(this).balance >= value,
539             "Address: insufficient balance for call"
540         );
541         require(isContract(target), "Address: call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.call{value: value}(
544             data
545         );
546         return _verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data)
556         internal
557         view
558         returns (bytes memory)
559     {
560         return
561             functionStaticCall(
562                 target,
563                 data,
564                 "Address: low-level static call failed"
565             );
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal view returns (bytes memory) {
579         require(isContract(target), "Address: static call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.staticcall(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(address target, bytes memory data)
592         internal
593         returns (bytes memory)
594     {
595         return
596             functionDelegateCall(
597                 target,
598                 data,
599                 "Address: low-level delegate call failed"
600             );
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
605      * but performing a delegate call.
606      *
607      * _Available since v3.4._
608      */
609     function functionDelegateCall(
610         address target,
611         bytes memory data,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         require(isContract(target), "Address: delegate call to non-contract");
615 
616         (bool success, bytes memory returndata) = target.delegatecall(data);
617         return _verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     function _verifyCallResult(
621         bool success,
622         bytes memory returndata,
623         string memory errorMessage
624     ) private pure returns (bytes memory) {
625         if (success) {
626             return returndata;
627         } else {
628             // Look for revert reason and bubble it up if present
629             if (returndata.length > 0) {
630                 // The easiest way to bubble the revert reason is using memory via assembly
631 
632                 assembly {
633                     let returndata_size := mload(returndata)
634                     revert(add(32, returndata), returndata_size)
635                 }
636             } else {
637                 revert(errorMessage);
638             }
639         }
640     }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Metadata is IERC721 {
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @title ERC721 token receiver interface
674  * @dev Interface for any contract that wants to support safeTransfers
675  * from ERC721 asset contracts.
676  */
677 interface IERC721Receiver {
678     /**
679      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
680      * by `operator` from `from`, this function is called.
681      *
682      * It must return its Solidity selector to confirm the token transfer.
683      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
684      *
685      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
686      */
687     function onERC721Received(
688         address operator,
689         address from,
690         uint256 tokenId,
691         bytes calldata data
692     ) external returns (bytes4);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata extension, but not including the Enumerable extension, which is available separately as
702  * {ERC721Enumerable}.
703  */
704 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
705     using Address for address;
706     using Strings for uint256;
707 
708     // Token name
709     string private _name;
710 
711     // Token symbol
712     string private _symbol;
713 
714     // Mapping from token ID to owner address
715     mapping(uint256 => address) private _owners;
716 
717     // Mapping owner address to token count
718     mapping(address => uint256) private _balances;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     /**
727      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
728      */
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId)
738         public
739         view
740         virtual
741         override(ERC165, IERC165)
742         returns (bool)
743     {
744         return
745             interfaceId == type(IERC721).interfaceId ||
746             interfaceId == type(IERC721Metadata).interfaceId ||
747             super.supportsInterface(interfaceId);
748     }
749 
750     /**
751      * @dev See {IERC721-balanceOf}.
752      */
753     function balanceOf(address owner)
754         public
755         view
756         virtual
757         override
758         returns (uint256)
759     {
760         require(
761             owner != address(0),
762             "ERC721: balance query for the zero address"
763         );
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId)
771         public
772         view
773         virtual
774         override
775         returns (address)
776     {
777         address owner = _owners[tokenId];
778         require(
779             owner != address(0),
780             "ERC721: owner query for nonexistent token"
781         );
782         return owner;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-name}.
787      */
788     function name() public view virtual override returns (string memory) {
789         return _name;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-symbol}.
794      */
795     function symbol() public view virtual override returns (string memory) {
796         return _symbol;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-tokenURI}.
801      */
802     function tokenURI(uint256 tokenId)
803         public
804         view
805         virtual
806         override
807         returns (string memory)
808     {
809         require(
810             _exists(tokenId),
811             "ERC721Metadata: URI query for nonexistent token"
812         );
813 
814         string memory baseURI = _baseURI();
815         return
816             bytes(baseURI).length > 0
817                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
818                 : "";
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return "";
828     }
829 
830     /**
831      * @dev See {IERC721-approve}.
832      */
833     function approve(address to, uint256 tokenId) public virtual override {
834         address owner = ERC721.ownerOf(tokenId);
835         require(to != owner, "ERC721: approval to current owner");
836 
837         require(
838             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
839             "ERC721: approve caller is not owner nor approved for all"
840         );
841 
842         _approve(to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-getApproved}.
847      */
848     function getApproved(uint256 tokenId)
849         public
850         view
851         virtual
852         override
853         returns (address)
854     {
855         require(
856             _exists(tokenId),
857             "ERC721: approved query for nonexistent token"
858         );
859 
860         return _tokenApprovals[tokenId];
861     }
862 
863     /**
864      * @dev See {IERC721-setApprovalForAll}.
865      */
866     function setApprovalForAll(address operator, bool approved)
867         public
868         virtual
869         override
870     {
871         require(operator != _msgSender(), "ERC721: approve to caller");
872 
873         _operatorApprovals[_msgSender()][operator] = approved;
874         emit ApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator)
881         public
882         view
883         virtual
884         override
885         returns (bool)
886     {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         //solhint-disable-next-line max-line-length
899         require(
900             _isApprovedOrOwner(_msgSender(), tokenId),
901             "ERC721: transfer caller is not owner nor approved"
902         );
903 
904         _transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, "");
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public virtual override {
927         require(
928             _isApprovedOrOwner(_msgSender(), tokenId),
929             "ERC721: transfer caller is not owner nor approved"
930         );
931         _safeTransfer(from, to, tokenId, _data);
932     }
933 
934     /**
935      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
936      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
937      *
938      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
939      *
940      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
941      * implement alternative mechanisms to perform token transfer, such as signature-based.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeTransfer(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) internal virtual {
958         _transfer(from, to, tokenId);
959         require(
960             _checkOnERC721Received(from, to, tokenId, _data),
961             "ERC721: transfer to non ERC721Receiver implementer"
962         );
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      * and stop existing when they are burned (`_burn`).
972      */
973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
974         return _owners[tokenId] != address(0);
975     }
976 
977     /**
978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function _isApprovedOrOwner(address spender, uint256 tokenId)
985         internal
986         view
987         virtual
988         returns (bool)
989     {
990         require(
991             _exists(tokenId),
992             "ERC721: operator query for nonexistent token"
993         );
994         address owner = ERC721.ownerOf(tokenId);
995         return (spender == owner ||
996             getApproved(tokenId) == spender ||
997             isApprovedForAll(owner, spender));
998     }
999 
1000     /**
1001      * @dev Safely mints `tokenId` and transfers it to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must not exist.
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _safeMint(address to, uint256 tokenId) internal virtual {
1011         _safeMint(to, tokenId, "");
1012     }
1013 
1014     /**
1015      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1016      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1017      */
1018     function _safeMint(
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) internal virtual {
1023         _mint(to, tokenId);
1024         require(
1025             _checkOnERC721Received(address(0), to, tokenId, _data),
1026             "ERC721: transfer to non ERC721Receiver implementer"
1027         );
1028     }
1029 
1030     /**
1031      * @dev Mints `tokenId` and transfers it to `to`.
1032      *
1033      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must not exist.
1038      * - `to` cannot be the zero address.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _mint(address to, uint256 tokenId) internal virtual {
1043         require(to != address(0), "ERC721: mint to the zero address");
1044         require(!_exists(tokenId), "ERC721: token already minted");
1045 
1046         _beforeTokenTransfer(address(0), to, tokenId);
1047 
1048         _balances[to] += 1;
1049         _owners[tokenId] = to;
1050 
1051         emit Transfer(address(0), to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Destroys `tokenId`.
1056      * The approval is cleared when the token is burned.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _burn(uint256 tokenId) internal virtual {
1065         address owner = ERC721.ownerOf(tokenId);
1066 
1067         _beforeTokenTransfer(owner, address(0), tokenId);
1068 
1069         // Clear approvals
1070         _approve(address(0), tokenId);
1071 
1072         _balances[owner] -= 1;
1073         delete _owners[tokenId];
1074 
1075         emit Transfer(owner, address(0), tokenId);
1076     }
1077 
1078     /**
1079      * @dev Transfers `tokenId` from `from` to `to`.
1080      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must be owned by `from`.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {
1094         require(
1095             ERC721.ownerOf(tokenId) == from,
1096             "ERC721: transfer of token that is not own"
1097         );
1098         require(to != address(0), "ERC721: transfer to the zero address");
1099 
1100         _beforeTokenTransfer(from, to, tokenId);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId);
1104 
1105         _balances[from] -= 1;
1106         _balances[to] += 1;
1107         _owners[tokenId] = to;
1108 
1109         emit Transfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Approve `to` to operate on `tokenId`
1114      *
1115      * Emits a {Approval} event.
1116      */
1117     function _approve(address to, uint256 tokenId) internal virtual {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try
1140                 IERC721Receiver(to).onERC721Received(
1141                     _msgSender(),
1142                     from,
1143                     tokenId,
1144                     _data
1145                 )
1146             returns (bytes4 retval) {
1147                 return retval == IERC721Receiver(to).onERC721Received.selector;
1148             } catch (bytes memory reason) {
1149                 if (reason.length == 0) {
1150                     revert(
1151                         "ERC721: transfer to non ERC721Receiver implementer"
1152                     );
1153                 } else {
1154                     assembly {
1155                         revert(add(32, reason), mload(reason))
1156                     }
1157                 }
1158             }
1159         } else {
1160             return true;
1161         }
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before any token transfer. This includes minting
1166      * and burning.
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1174      * - `from` and `to` are never both zero.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _beforeTokenTransfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual {}
1183 }
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 contract MutantKongz is ERC721, Ownable {
1188     uint256 public constant MAX_SUPPLY = 650;
1189     uint16 private mintCount = 0;
1190 
1191     uint256 public price = 80000000000000000;
1192     string baseTokenURI;
1193     bool public saleOpen = false;
1194 
1195     event Minted(uint256 totalMinted);
1196 
1197     constructor(string memory baseURI) ERC721("Mutant Kongz", "KONGZ") {
1198         setBaseURI(baseURI);
1199     }
1200 
1201     function totalSupply() public view returns (uint16) {
1202         return mintCount;
1203     }
1204 
1205     function setBaseURI(string memory baseURI) public onlyOwner {
1206         baseTokenURI = baseURI;
1207     }
1208 
1209     function changePrice(uint256 _newPrice) external onlyOwner {
1210         price = _newPrice;
1211     }
1212 
1213     function toggleSale() external onlyOwner {
1214         saleOpen = !saleOpen;
1215     }
1216 
1217     function withdraw() external onlyOwner {
1218         (bool success, ) = payable(msg.sender).call{
1219             value: address(this).balance
1220         }("");
1221         require(success, "Transfer failed.");
1222     }
1223 
1224     function mint(address _to,uint16 _count) external payable {
1225         uint16 supply = totalSupply();
1226 
1227         require(supply + _count <= MAX_SUPPLY, "Exceeds maximum supply");
1228         require(_count > 0, "Minimum 1 NFT has to be minted per transaction");
1229 
1230         if (msg.sender != owner()) {
1231             require(saleOpen, "Sale is not open yet");
1232             require(
1233                 _count <= 6,
1234                 "Maximum 6 NFTs can be minted per transaction"
1235             );
1236             require(
1237                 msg.value >= price * _count,
1238                 "Ether sent with this transaction is not correct"
1239             );
1240         }
1241 
1242         mintCount += _count;
1243 
1244         for (uint256 i = 0; i < _count; i++) {
1245             _safeMint(_to, ++supply);
1246             emit Minted(supply);
1247         }
1248     }
1249 
1250     function _baseURI() internal view virtual override returns (string memory) {
1251         return baseTokenURI;
1252     }
1253 }