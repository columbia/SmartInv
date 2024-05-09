1 pragma solidity ^0.8.0; 
2 // SPDX-License-Identifier: MIT
3 // Contract code designed by @EVMlord for https://linktr.ee/nftng on behalf of https://linktr.ee/harmonicstudioz
4 
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length)
57         internal
58         pure
59         returns (string memory)
60     {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * By default, the owner account will be the one that deploys the contract. This
100  * can later be changed with {transferOwnership}.
101  *
102  * written by EVMlord
103  *
104  * This module is used through inheritance. It will make available the modifier
105  * `onlyOwner`, which can be applied to your functions to restrict their use to
106  * the owner.
107  */
108 abstract contract Ownable is Context {
109     address private _owner;
110     mapping (address => bool) internal authorizations;
111 
112     event OwnershipTransferred(
113         address indexed previousOwner,
114         address indexed newOwner
115     );
116 
117     /**
118      * @dev Initializes the contract setting the deployer as the initial owner.
119      */
120     constructor() {
121         _setOwner(_msgSender());
122         authorizations[_owner] = true;
123     }
124 
125     modifier authorized() {
126         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
127     }
128 
129     function isAuthorized(address adr) public view returns (bool) {
130         return authorizations[adr];
131     }
132 
133     /**
134      * Authorize address. Owner only
135      */
136     function authorize(address adr) public onlyOwner {
137         authorizations[adr] = true;
138     }
139 
140     /**
141      * Remove address' authorization. Owner only
142      */
143     function unauthorize(address adr) public onlyOwner {
144         authorizations[adr] = false;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _setOwner(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(
179             newOwner != address(0),
180             "Ownable: new owner is the zero address"
181         );
182         _setOwner(newOwner);
183     }
184 
185     function _setOwner(address newOwner) private {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         authorizations[_owner] = true;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 
193 /**
194  * @dev Collection of functions related to the address type
195  */
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize, which returns 0 for contracts in
216         // construction, since the code is only stored at the end of the
217         // constructor execution.
218 
219         uint256 size;
220         assembly {
221             size := extcodesize(account)
222         }
223         return size > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(
244             address(this).balance >= amount,
245             "Address: insufficient balance"
246         );
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(
250             success,
251             "Address: unable to send value, recipient may have reverted"
252         );
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data)
274         internal
275         returns (bytes memory)
276     {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return
311             functionCallWithValue(
312                 target,
313                 data,
314                 value,
315                 "Address: low-level call with value failed"
316             );
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(
332             address(this).balance >= value,
333             "Address: insufficient balance for call"
334         );
335         require(isContract(target), "Address: call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.call{value: value}(
338             data
339         );
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data)
350         internal
351         view
352         returns (bytes memory)
353     {
354         return
355             functionStaticCall(
356                 target,
357                 data,
358                 "Address: low-level static call failed"
359             );
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data)
386         internal
387         returns (bytes memory)
388     {
389         return
390             functionDelegateCall(
391                 target,
392                 data,
393                 "Address: low-level delegate call failed"
394             );
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 /**
444  * @title ERC721 token receiver interface
445  * @dev Interface for any contract that wants to support safeTransfers
446  * from ERC721 asset contracts.
447  */
448 interface IERC721Receiver {
449     /**
450      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
451      * by `operator` from `from`, this function is called.
452      *
453      * It must return its Solidity selector to confirm the token transfer.
454      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
455      *
456      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
457      */
458     function onERC721Received(
459         address operator,
460         address from,
461         uint256 tokenId,
462         bytes calldata data
463     ) external returns (bytes4);
464 }
465 
466 /**
467  * @dev Interface of the ERC165 standard, as defined in the
468  * https://eips.ethereum.org/EIPS/eip-165[EIP].
469  *
470  * Implementers can declare support of contract interfaces, which can then be
471  * queried by others ({ERC165Checker}).
472  *
473  * For an implementation, see {ERC165}.
474  */
475 interface IERC165 {
476     /**
477      * @dev Returns true if this contract implements the interface defined by
478      * `interfaceId`. See the corresponding
479      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
480      * to learn more about how these ids are created.
481      *
482      * This function call must use less than 30 000 gas.
483      */
484     function supportsInterface(bytes4 interfaceId) external view returns (bool);
485 }
486 
487 /**
488  * @dev Implementation of the {IERC165} interface.
489  *
490  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
491  * for the additional interface id that will be supported. For example:
492  *
493  * ```solidity
494  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
496  * }
497  * ```
498  *
499  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
500  */
501 abstract contract ERC165 is IERC165 {
502     /**
503      * @dev See {IERC165-supportsInterface}.
504      */
505     function supportsInterface(bytes4 interfaceId)
506         public
507         view
508         virtual
509         override
510         returns (bool)
511     {
512         return interfaceId == type(IERC165).interfaceId;
513     }
514 }
515 
516 /**
517  * @dev Required interface of an ERC721 compliant contract.
518  */
519 interface IERC721 is IERC165 {
520     /**
521      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
522      */
523     event Transfer(
524         address indexed from,
525         address indexed to,
526         uint256 indexed tokenId
527     );
528 
529     /**
530      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
531      */
532     event Approval(
533         address indexed owner,
534         address indexed approved,
535         uint256 indexed tokenId
536     );
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(
542         address indexed owner,
543         address indexed operator,
544         bool approved
545     );
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Transfers `tokenId` token from `from` to `to`.
583      *
584      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
603      * The approval is cleared when the token is transferred.
604      *
605      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
606      *
607      * Requirements:
608      *
609      * - The caller must own the token or be an approved operator.
610      * - `tokenId` must exist.
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Returns the account approved for `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function getApproved(uint256 tokenId)
624         external
625         view
626         returns (address operator);
627 
628     /**
629      * @dev Approve or remove `operator` as an operator for the caller.
630      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
631      *
632      * Requirements:
633      *
634      * - The `operator` cannot be the caller.
635      *
636      * Emits an {ApprovalForAll} event.
637      */
638     function setApprovalForAll(address operator, bool _approved) external;
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}
644      */
645     function isApprovedForAll(address owner, address operator)
646         external
647         view
648         returns (bool);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes calldata data
668     ) external;
669 }
670 
671 /**
672  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
673  * @dev See https://eips.ethereum.org/EIPS/eip-721
674  */
675 interface IERC721Enumerable is IERC721 {
676     /**
677      * @dev Returns the total amount of tokens stored by the contract.
678      */
679     function totalSupply() external view returns (uint256);
680 
681     /**
682      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
683      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
684      */
685     function tokenOfOwnerByIndex(address owner, uint256 index)
686         external
687         view
688         returns (uint256 tokenId);
689 
690     /**
691      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
692      * Use along with {totalSupply} to enumerate all tokens.
693      */
694     function tokenByIndex(uint256 index) external view returns (uint256);
695 }
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Metadata is IERC721 {
702     /**
703      * @dev Returns the token collection name.
704      */
705     function name() external view returns (string memory);
706 
707     /**
708      * @dev Returns the token collection symbol.
709      */
710     function symbol() external view returns (string memory);
711 
712     /**
713      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
714      */
715     function tokenURI(uint256 tokenId) external view returns (string memory);
716 }
717 
718 /**
719  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
720  * the Metadata extension, but not including the Enumerable extension, which is available separately as
721  * {ERC721Enumerable}.
722  */
723 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     using Strings for uint256;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to owner address
734     mapping(uint256 => address) private _owners;
735 
736     // Mapping owner address to token count
737     mapping(address => uint256) private _balances;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     /**
746      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
747      */
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId)
757         public
758         view
759         virtual
760         override(ERC165, IERC165)
761         returns (bool)
762     {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner)
773         public
774         view
775         virtual
776         override
777         returns (uint256)
778     {
779         require(
780             owner != address(0),
781             "ERC721: balance query for the zero address"
782         );
783         return _balances[owner];
784     }
785 
786     /**
787      * @dev See {IERC721-ownerOf}.
788      */
789     function ownerOf(uint256 tokenId)
790         public
791         view
792         virtual
793         override
794         returns (address)
795     {
796         address owner = _owners[tokenId];
797         require(
798             owner != address(0),
799             "ERC721: owner query for nonexistent token"
800         );
801         return owner;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId)
822         public
823         view
824         virtual
825         override
826         returns (string memory)
827     {
828         require(
829             _exists(tokenId),
830             "ERC721Metadata: URI query for nonexistent token"
831         );
832 
833         string memory baseURI = _baseURI();
834         return
835             bytes(baseURI).length > 0
836                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
837                 : "";
838     }
839 
840     /**
841      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
842      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
843      * by default, can be overriden in child contracts.
844      */
845     function _baseURI() internal view virtual returns (string memory) {
846         return "";
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public virtual override {
853         address owner = ERC721.ownerOf(tokenId);
854         require(to != owner, "ERC721: approval to current owner");
855 
856         require(
857             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
858             "ERC721: approve caller is not owner nor approved for all"
859         );
860 
861         _approve(to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId)
868         public
869         view
870         virtual
871         override
872         returns (address)
873     {
874         require(
875             _exists(tokenId),
876             "ERC721: approved query for nonexistent token"
877         );
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     /**
883      * @dev See {IERC721-setApprovalForAll}.
884      */
885     function setApprovalForAll(address operator, bool approved)
886         public
887         virtual
888         override
889     {
890         require(operator != _msgSender(), "ERC721: approve to caller");
891 
892         _operatorApprovals[_msgSender()][operator] = approved;
893         emit ApprovalForAll(_msgSender(), operator, approved);
894     }
895 
896     /**
897      * @dev See {IERC721-isApprovedForAll}.
898      */
899     function isApprovedForAll(address owner, address operator)
900         public
901         view
902         virtual
903         override
904         returns (bool)
905     {
906         return _operatorApprovals[owner][operator];
907     }
908 
909     /**
910      * @dev See {IERC721-transferFrom}.
911      */
912     function transferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public virtual override {
917         //solhint-disable-next-line max-line-length
918         require(
919             _isApprovedOrOwner(_msgSender(), tokenId),
920             "ERC721: transfer caller is not owner nor approved"
921         );
922 
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         safeTransferFrom(from, to, tokenId, "");
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         require(
947             _isApprovedOrOwner(_msgSender(), tokenId),
948             "ERC721: transfer caller is not owner nor approved"
949         );
950         _safeTransfer(from, to, tokenId, _data);
951     }
952 
953     /**
954      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
955      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
956      *
957      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
958      *
959      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
960      * implement alternative mechanisms to perform token transfer, such as signature-based.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must exist and be owned by `from`.
967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _safeTransfer(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) internal virtual {
977         _transfer(from, to, tokenId);
978         require(
979             _checkOnERC721Received(from, to, tokenId, _data),
980             "ERC721: transfer to non ERC721Receiver implementer"
981         );
982     }
983 
984     /**
985      * @dev Returns whether `tokenId` exists.
986      *
987      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
988      *
989      * Tokens start existing when they are minted (`_mint`),
990      * and stop existing when they are burned (`_burn`).
991      */
992     function _exists(uint256 tokenId) internal view virtual returns (bool) {
993         return _owners[tokenId] != address(0);
994     }
995 
996     /**
997      * @dev Returns whether `spender` is allowed to manage `tokenId`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      * written by EVMlord
1003      */
1004     function _isApprovedOrOwner(address spender, uint256 tokenId)
1005         internal
1006         view
1007         virtual
1008         returns (bool)
1009     {
1010         require(
1011             _exists(tokenId),
1012             "ERC721: operator query for nonexistent token"
1013         );
1014         address owner = ERC721.ownerOf(tokenId);
1015         return (spender == owner ||
1016             getApproved(tokenId) == spender ||
1017             isApprovedForAll(owner, spender));
1018     }
1019 
1020     /**
1021      * @dev Safely mints `tokenId` and transfers it to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must not exist.
1026      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _safeMint(address to, uint256 tokenId) internal virtual {
1031         _safeMint(to, tokenId, "");
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1036      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1037      */
1038     function _safeMint(
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) internal virtual {
1043         _mint(to, tokenId);
1044         require(
1045             _checkOnERC721Received(address(0), to, tokenId, _data),
1046             "ERC721: transfer to non ERC721Receiver implementer"
1047         );
1048     }
1049 
1050     /**
1051      * @dev Mints `tokenId` and transfers it to `to`.
1052      *
1053      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1054      *
1055      * Requirements:
1056      *
1057      * - `tokenId` must not exist.
1058      * - `to` cannot be the zero address.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _mint(address to, uint256 tokenId) internal virtual {
1063         require(to != address(0), "ERC721: mint to the zero address");
1064         require(!_exists(tokenId), "ERC721: token already minted");
1065 
1066         _beforeTokenTransfer(address(0), to, tokenId);
1067 
1068         _balances[to] += 1;
1069         _owners[tokenId] = to;
1070 
1071         emit Transfer(address(0), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Destroys `tokenId`.
1076      * The approval is cleared when the token is burned.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _burn(uint256 tokenId) internal virtual {
1085         address owner = ERC721.ownerOf(tokenId);
1086 
1087         _beforeTokenTransfer(owner, address(0), tokenId);
1088 
1089         // Clear approvals
1090         _approve(address(0), tokenId);
1091 
1092         _balances[owner] -= 1;
1093         delete _owners[tokenId];
1094 
1095         emit Transfer(owner, address(0), tokenId);
1096     }
1097 
1098     /**
1099      * @dev Transfers `tokenId` from `from` to `to`.
1100      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must be owned by `from`.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _transfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {
1114         require(
1115             ERC721.ownerOf(tokenId) == from,
1116             "ERC721: transfer of token that is not own"
1117         );
1118         require(to != address(0), "ERC721: transfer to the zero address");
1119 
1120         _beforeTokenTransfer(from, to, tokenId);
1121 
1122         // Clear approvals from the previous owner
1123         _approve(address(0), tokenId);
1124 
1125         _balances[from] -= 1;
1126         _balances[to] += 1;
1127         _owners[tokenId] = to;
1128 
1129         emit Transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Approve `to` to operate on `tokenId`
1134      *
1135      * Emits a {Approval} event.
1136      */
1137     function _approve(address to, uint256 tokenId) internal virtual {
1138         _tokenApprovals[tokenId] = to;
1139         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1144      * The call is not executed if the target address is not a contract.
1145      *
1146      * @param from address representing the previous owner of the given token ID
1147      * @param to target address that will receive the tokens
1148      * @param tokenId uint256 ID of the token to be transferred
1149      * @param _data bytes optional data to send along with the call
1150      * @return bool whether the call correctly returned the expected magic value
1151      */
1152     function _checkOnERC721Received(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) private returns (bool) {
1158         if (to.isContract()) {
1159             try
1160                 IERC721Receiver(to).onERC721Received(
1161                     _msgSender(),
1162                     from,
1163                     tokenId,
1164                     _data
1165                 )
1166             returns (bytes4 retval) {
1167                 return retval == IERC721Receiver.onERC721Received.selector;
1168             } catch (bytes memory reason) {
1169                 if (reason.length == 0) {
1170                     revert(
1171                         "ERC721: transfer to non ERC721Receiver implementer"
1172                     );
1173                 } else {
1174                     assembly {
1175                         revert(add(32, reason), mload(reason))
1176                     }
1177                 }
1178             }
1179         } else {
1180             return true;
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before any token transfer. This includes minting
1186      * and burning.
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` will be minted for `to`.
1193      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1194      * - `from` and `to` are never both zero.
1195      *
1196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1197      */
1198     function _beforeTokenTransfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) internal virtual {}
1203 }
1204 
1205 /**
1206  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1207  * enumerability of all the token ids in the contract as well as all token ids owned by each
1208  * account.
1209  */
1210 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1211     // Mapping from owner to list of owned token IDs
1212     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1213 
1214     // Mapping from token ID to index of the owner tokens list
1215     mapping(uint256 => uint256) private _ownedTokensIndex;
1216 
1217     // Array with all token ids, used for enumeration
1218     uint256[] private _allTokens;
1219 
1220     // Mapping from token id to position in the allTokens array
1221     mapping(uint256 => uint256) private _allTokensIndex;
1222 
1223     /**
1224      * @dev See {IERC165-supportsInterface}.
1225      */
1226     function supportsInterface(bytes4 interfaceId)
1227         public
1228         view
1229         virtual
1230         override(IERC165, ERC721)
1231         returns (bool)
1232     {
1233         return
1234             interfaceId == type(IERC721Enumerable).interfaceId ||
1235             super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1240      */
1241     function tokenOfOwnerByIndex(address owner, uint256 index)
1242         public
1243         view
1244         virtual
1245         override
1246         returns (uint256)
1247     {
1248         require(
1249             index < ERC721.balanceOf(owner),
1250             "ERC721Enumerable: owner index out of bounds"
1251         );
1252         return _ownedTokens[owner][index];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-totalSupply}.
1257      */
1258     function totalSupply() public view virtual override returns (uint256) {
1259         return _allTokens.length;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Enumerable-tokenByIndex}.
1264      */
1265     function tokenByIndex(uint256 index)
1266         public
1267         view
1268         virtual
1269         override
1270         returns (uint256)
1271     {
1272         require(
1273             index < ERC721Enumerable.totalSupply(),
1274             "ERC721Enumerable: global index out of bounds"
1275         );
1276         return _allTokens[index];
1277     }
1278 
1279     /**
1280      * @dev Hook that is called before any token transfer. This includes minting
1281      * and burning.
1282      *
1283      * Calling conditions:
1284      *
1285      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1286      * transferred to `to`.
1287      * - When `from` is zero, `tokenId` will be minted for `to`.
1288      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1289      * - `from` cannot be the zero address.
1290      * - `to` cannot be the zero address.
1291      *
1292      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1293      */
1294     function _beforeTokenTransfer(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) internal virtual override {
1299         super._beforeTokenTransfer(from, to, tokenId);
1300 
1301         if (from == address(0)) {
1302             _addTokenToAllTokensEnumeration(tokenId);
1303         } else if (from != to) {
1304             _removeTokenFromOwnerEnumeration(from, tokenId);
1305         }
1306         if (to == address(0)) {
1307             _removeTokenFromAllTokensEnumeration(tokenId);
1308         } else if (to != from) {
1309             _addTokenToOwnerEnumeration(to, tokenId);
1310         }
1311     }
1312 
1313     /**
1314      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1315      * @param to address representing the new owner of the given token ID
1316      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1317      */
1318     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1319         uint256 length = ERC721.balanceOf(to);
1320         _ownedTokens[to][length] = tokenId;
1321         _ownedTokensIndex[tokenId] = length;
1322     }
1323 
1324     /**
1325      * @dev Private function to add a token to this extension's token tracking data structures.
1326      * @param tokenId uint256 ID of the token to be added to the tokens list
1327      */
1328     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1329         _allTokensIndex[tokenId] = _allTokens.length;
1330         _allTokens.push(tokenId);
1331     }
1332 
1333     /**
1334      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1335      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1336      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1337      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1338      * @param from address representing the previous owner of the given token ID
1339      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1340      */
1341     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1342         private
1343     {
1344         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1345         // then delete the last slot (swap and pop).
1346 
1347         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1348         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1349 
1350         // When the token to delete is the last token, the swap operation is unnecessary
1351         if (tokenIndex != lastTokenIndex) {
1352             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1353 
1354             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1355             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1356         }
1357 
1358         // This also deletes the contents at the last position of the array
1359         delete _ownedTokensIndex[tokenId];
1360         delete _ownedTokens[from][lastTokenIndex];
1361     }
1362 
1363     /**
1364      * @dev Private function to remove a token from this extension's token tracking data structures.
1365      * This has O(1) time complexity, but alters the order of the _allTokens array.
1366      * @param tokenId uint256 ID of the token to be removed from the tokens list
1367      */
1368     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1369         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1370         // then delete the last slot (swap and pop).
1371 
1372         uint256 lastTokenIndex = _allTokens.length - 1;
1373         uint256 tokenIndex = _allTokensIndex[tokenId];
1374 
1375         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1376         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1377         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1378         uint256 lastTokenId = _allTokens[lastTokenIndex];
1379 
1380         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1381         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1382 
1383         // This also deletes the contents at the last position of the array
1384         delete _allTokensIndex[tokenId];
1385         _allTokens.pop();
1386     }
1387 }
1388 
1389 interface IERC20 {
1390     function transferFrom(address from, address to, uint256 amount) external returns(bool);
1391     function balanceOf(address account) external view returns(uint256);
1392     function allowance(address owner, address spender) external view returns(uint256);
1393     function transfer(address to, uint256 value) external returns (bool);
1394     
1395 }
1396 
1397 contract NFTngPass is ERC721Enumerable, Ownable {
1398     using Strings for uint256;
1399 
1400     string public baseURI;
1401     string public baseExtension = ".json";
1402     uint256 public cost = 1 ether;
1403     uint256 public maxSupply = 999;
1404     uint256 public maxMintAmount = 5;
1405     address payable public treasury;
1406     bool public paused = false;
1407     bool public reveal =false;
1408     mapping(address => bool) public isBuzzlisted;
1409     mapping(address => bool) public hasRedeemed;
1410     uint256 public freeNFTAlreadyMinted = 0;
1411     uint256 public  NUM_FREE_MINTS = 999;
1412     bool public BLpaused = false;
1413     string public hiddenURI;
1414 
1415 
1416     constructor(
1417         string memory _name,
1418         string memory _symbol,
1419         address payable _treasury
1420     ) ERC721(_name, _symbol) {
1421         treasury = payable(_treasury);
1422     }
1423 
1424     // internal
1425     function _baseURI() internal view virtual override returns (string memory) {
1426         return baseURI;
1427     }
1428 
1429     // public
1430     function mint(address _to, uint256 _mintAmount) public payable {
1431         uint256 supply = totalSupply();
1432         require(!paused);
1433         require(_mintAmount > 0);
1434         require(_mintAmount <= maxMintAmount);
1435         require(supply + _mintAmount <= maxSupply);
1436 
1437         if (authorizations[msg.sender] != true) {
1438             //general public
1439             require(msg.value >= cost * _mintAmount);     
1440         }
1441 
1442         for (uint256 i = 1; i <= _mintAmount; i++) {
1443             _safeMint(_to, supply + i);
1444         }
1445     }
1446 
1447     function buzzlistMint() external {
1448         uint256 supply = totalSupply();
1449 
1450         require(!BLpaused, "buzzlist minting is over!");
1451         require(isBuzzlisted[msg.sender],  "You are not buzzlisted");
1452 
1453         require(supply + 1 <= maxSupply, "No more");
1454         require(freeNFTAlreadyMinted + 1 < NUM_FREE_MINTS);
1455         require(!hasRedeemed[msg.sender]);
1456 
1457         for (uint256 i = 1; i <= 1; i++) {
1458             _safeMint(msg.sender, supply + i); 
1459         } 
1460 
1461         freeNFTAlreadyMinted += 1;
1462         hasRedeemed[msg.sender] = true;
1463     }
1464 
1465     function setNUM_FREE_MINTS(uint8 _NUM_FREE_MINTS) external authorized{
1466         require(_NUM_FREE_MINTS <= maxSupply);
1467         NUM_FREE_MINTS = _NUM_FREE_MINTS;
1468         delete _NUM_FREE_MINTS;
1469     }
1470 
1471     function walletOfOwner(address _owner)
1472         public
1473         view
1474         returns (uint256[] memory)
1475     {
1476         uint256 ownerTokenCount = balanceOf(_owner);
1477         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1478         for (uint256 i; i < ownerTokenCount; i++) {
1479             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1480         }
1481         return tokenIds;
1482     }
1483 
1484     function tokenURI(uint256 tokenId)
1485         public
1486         view
1487         virtual
1488         override
1489         returns (string memory)
1490     {
1491         require(
1492             _exists(tokenId),
1493             "ERC721Metadata: URI query for nonexistent token"
1494         );
1495 
1496         if ( reveal == false) {
1497             return hiddenURI;
1498         } else {
1499         string memory currentBaseURI = _baseURI();
1500         return
1501             bytes(currentBaseURI).length > 0
1502                 ? string(
1503                     abi.encodePacked(
1504                         currentBaseURI,
1505                         tokenId.toString(),
1506                         baseExtension
1507                     )
1508                 )
1509                 : "";
1510 
1511         }
1512     }
1513 
1514     //only owner
1515     function setCost(uint256 _newCost) public authorized {
1516         cost = _newCost;
1517     }
1518 
1519     function setHiddenUri(string memory _hiddenURI) external authorized {
1520         hiddenURI = _hiddenURI;
1521     }
1522 
1523     function setmaxMintAmount(uint256 _newmaxMintAmount) public authorized {
1524         maxMintAmount = _newmaxMintAmount;
1525     }
1526 
1527     function setBaseURI(string memory _newBaseURI) public authorized {
1528         baseURI = _newBaseURI;
1529     }
1530 
1531     function setBaseExtension(string memory _newBaseExtension)
1532         public
1533         authorized
1534     {
1535         baseExtension = _newBaseExtension;
1536     }
1537 
1538     function pause() public authorized {
1539         paused = !paused;
1540         BLpaused = true;
1541     }
1542 
1543     function setBLPaused() external authorized {
1544     BLpaused = !BLpaused;
1545     }
1546 
1547     function setRevealed() external authorized {
1548         reveal = !reveal;
1549     }
1550 
1551     function addToBuzzlist(address[] memory _users) public authorized {
1552 		require(_users.length > 0,"No Users");
1553         for (uint256 i = 0; i < _users.length; i++) {
1554             isBuzzlisted[_users[i]] = true;
1555         }
1556     }
1557 
1558 	function removeFromBuzzlist(address[] memory _user) public authorized {
1559 		require(_user.length > 0,"No User");
1560 		for(uint256 i = 0;i < _user.length;i++)
1561         isBuzzlisted[_user[i]] = false;
1562     }
1563 
1564     /// @dev withdraw ETH
1565     function withdrawETH() public payable authorized {
1566         (bool success, ) = payable(treasury).call{
1567             value: address(this).balance
1568         }("");
1569         require(success);
1570     }
1571 
1572     function updateTreasury(address payable _newTreasury) public onlyOwner {
1573         treasury = payable(_newTreasury);
1574     }
1575 
1576     /// @dev withdraw ERC20 tokens
1577 	function withdrawTokens(address _tokenContract) external authorized {
1578         IERC20 tokenContract = IERC20(_tokenContract);
1579         uint256 _amount = tokenContract.balanceOf(address(this));
1580         tokenContract.transfer(msg.sender, _amount);
1581         emit WithdrawWrongTokens(msg.sender,_tokenContract,_amount);
1582     }
1583 
1584     /// @dev withdraw ERC721 tokens to the contract owner
1585     function withdrawNFT(address _tokenContract, uint256[] memory _id) external authorized {
1586         IERC721 tokenContract = IERC721(_tokenContract);
1587         for (uint256 i = 0; i < _id.length; i++) {
1588             tokenContract.safeTransferFrom(address(this), msg.sender, _id[i]);
1589             emit WithdrawWrongNfts(msg.sender,_tokenContract,_id[i]);
1590         }
1591     }
1592 
1593     event WithdrawWrongNfts(address indexed devAddress,address tokenAddress, uint256 tokenId);
1594 	event WithdrawWrongTokens(address indexed devAddress,address tokenAddress, uint256 amount);
1595 
1596 	receive() external payable {}
1597      
1598 }