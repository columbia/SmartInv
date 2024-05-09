1 pragma solidity ^0.8.0;
2 
3 /**
4  * @title Counters
5  * @author Matt Condon (@shrugs)
6  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
7  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
8  *
9  * Include with `using Counters for Counters.Counter;`
10  */
11 library Counters {
12     struct Counter {
13         // This variable should never be directly accessed by users of the library: interactions must be restricted to
14         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
15         // this feature: see https://github.com/ethereum/solidity/issues/4637
16         uint256 _value; // default: 0
17     }
18 
19     function current(Counter storage counter) internal view returns (uint256) {
20         return counter._value;
21     }
22 
23     function increment(Counter storage counter) internal {
24         unchecked {
25             counter._value += 1;
26         }
27     }
28 
29     function decrement(Counter storage counter) internal {
30         uint256 value = counter._value;
31         require(value > 0, "Counter: decrement overflow");
32         unchecked {
33             counter._value = value - 1;
34         }
35     }
36 
37     function reset(Counter storage counter) internal {
38         counter._value = 0;
39     }
40 }
41 
42 
43 pragma solidity ^0.8.0;
44 
45 /*
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Interface of the ERC165 standard, as defined in the
70  * https://eips.ethereum.org/EIPS/eip-165[EIP].
71  *
72  * Implementers can declare support of contract interfaces, which can then be
73  * queried by others ({ERC165Checker}).
74  *
75  * For an implementation, see {ERC165}.
76  */
77 interface IERC165 {
78     /**
79      * @dev Returns true if this contract implements the interface defined by
80      * `interfaceId`. See the corresponding
81      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
82      * to learn more about how these ids are created.
83      *
84      * This function call must use less than 30 000 gas.
85      */
86     function supportsInterface(bytes4 interfaceId) external view returns (bool);
87 }
88 
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Required interface of an ERC721 compliant contract.
94  */
95 interface IERC721 is IERC165 {
96     /**
97      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
98      */
99     event Transfer(
100         address indexed from,
101         address indexed to,
102         uint256 indexed tokenId
103     );
104 
105     /**
106      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
107      */
108     event Approval(
109         address indexed owner,
110         address indexed approved,
111         uint256 indexed tokenId
112     );
113 
114     /**
115      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
116      */
117     event ApprovalForAll(
118         address indexed owner,
119         address indexed operator,
120         bool approved
121     );
122 
123     /**
124      * @dev Returns the number of tokens in ``owner``'s account.
125      */
126     function balanceOf(address owner) external view returns (uint256 balance);
127 
128     /**
129      * @dev Returns the owner of the `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function ownerOf(uint256 tokenId) external view returns (address owner);
136 
137     /**
138      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
139      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
140      *
141      * Requirements:
142      *
143      * - `from` cannot be the zero address.
144      * - `to` cannot be the zero address.
145      * - `tokenId` token must exist and be owned by `from`.
146      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148      *
149      * Emits a {Transfer} event.
150      */
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 tokenId
155     ) external;
156 
157     /**
158      * @dev Transfers `tokenId` token from `from` to `to`.
159      *
160      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     /**
178      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
179      * The approval is cleared when the token is transferred.
180      *
181      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
182      *
183      * Requirements:
184      *
185      * - The caller must own the token or be an approved operator.
186      * - `tokenId` must exist.
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address to, uint256 tokenId) external;
191 
192     /**
193      * @dev Returns the account approved for `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function getApproved(uint256 tokenId)
200         external
201         view
202         returns (address operator);
203 
204     /**
205      * @dev Approve or remove `operator` as an operator for the caller.
206      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
207      *
208      * Requirements:
209      *
210      * - The `operator` cannot be the caller.
211      *
212      * Emits an {ApprovalForAll} event.
213      */
214     function setApprovalForAll(address operator, bool _approved) external;
215 
216     /**
217      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
218      *
219      * See {setApprovalForAll}
220      */
221     function isApprovedForAll(address owner, address operator)
222         external
223         view
224         returns (bool);
225 
226     /**
227      * @dev Safely transfers `tokenId` token from `from` to `to`.
228      *
229      * Requirements:
230      *
231      * - `from` cannot be the zero address.
232      * - `to` cannot be the zero address.
233      * - `tokenId` token must exist and be owned by `from`.
234      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
235      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
236      *
237      * Emits a {Transfer} event.
238      */
239     function safeTransferFrom(
240         address from,
241         address to,
242         uint256 tokenId,
243         bytes calldata data
244     ) external;
245 }
246 
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Contract module which provides a basic access control mechanism, where
252  * there is an account (an owner) that can be granted exclusive access to
253  * specific functions.
254  *
255  * By default, the owner account will be the one that deploys the contract. This
256  * can later be changed with {transferOwnership}.
257  *
258  * This module is used through inheritance. It will make available the modifier
259  * `onlyOwner`, which can be applied to your functions to restrict their use to
260  * the owner.
261  */
262 abstract contract Ownable is Context {
263     address private _owner;
264 
265     event OwnershipTransferred(
266         address indexed previousOwner,
267         address indexed newOwner
268     );
269 
270     /**
271      * @dev Initializes the contract setting the deployer as the initial owner.
272      */
273     constructor() {
274         _setOwner(_msgSender());
275     }
276 
277     /**
278      * @dev Returns the address of the current owner.
279      */
280     function owner() public view virtual returns (address) {
281         return _owner;
282     }
283 
284     /**
285      * @dev Throws if called by any account other than the owner.
286      */
287     modifier onlyOwner() {
288         require(owner() == _msgSender(), "Ownable: caller is not the owner");
289         _;
290     }
291 
292     /**
293      * @dev Leaves the contract without owner. It will not be possible to call
294      * `onlyOwner` functions anymore. Can only be called by the current owner.
295      *
296      * NOTE: Renouncing ownership will leave the contract without an owner,
297      * thereby removing any functionality that is only available to the owner.
298      */
299     function renounceOwnership() public virtual onlyOwner {
300         _setOwner(address(0));
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      * Can only be called by the current owner.
306      */
307     function transferOwnership(address newOwner) public virtual onlyOwner {
308         require(
309             newOwner != address(0),
310             "Ownable: new owner is the zero address"
311         );
312         _setOwner(newOwner);
313     }
314 
315     function _setOwner(address newOwner) private {
316         address oldOwner = _owner;
317         _owner = newOwner;
318         emit OwnershipTransferred(oldOwner, newOwner);
319     }
320 }
321 
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
327  * @dev See https://eips.ethereum.org/EIPS/eip-721
328  */
329 interface IERC721Enumerable is IERC721 {
330     /**
331      * @dev Returns the total amount of tokens stored by the contract.
332      */
333     function totalSupply() external view returns (uint256);
334 
335     /**
336      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
337      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
338      */
339     function tokenOfOwnerByIndex(address owner, uint256 index)
340         external
341         view
342         returns (uint256 tokenId);
343 
344     /**
345      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
346      * Use along with {totalSupply} to enumerate all tokens.
347      */
348     function tokenByIndex(uint256 index) external view returns (uint256);
349 }
350 
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Implementation of the {IERC165} interface.
356  *
357  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
358  * for the additional interface id that will be supported. For example:
359  *
360  * ```solidity
361  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
362  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
363  * }
364  * ```
365  *
366  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
367  */
368 abstract contract ERC165 is IERC165 {
369     /**
370      * @dev See {IERC165-supportsInterface}.
371      */
372     function supportsInterface(bytes4 interfaceId)
373         public
374         view
375         virtual
376         override
377         returns (bool)
378     {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev String operations.
388  */
389 library Strings {
390     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
391 
392     /**
393      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
394      */
395     function toString(uint256 value) internal pure returns (string memory) {
396         // Inspired by OraclizeAPI's implementation - MIT licence
397         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
398 
399         if (value == 0) {
400             return "0";
401         }
402         uint256 temp = value;
403         uint256 digits;
404         while (temp != 0) {
405             digits++;
406             temp /= 10;
407         }
408         bytes memory buffer = new bytes(digits);
409         while (value != 0) {
410             digits -= 1;
411             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
412             value /= 10;
413         }
414         return string(buffer);
415     }
416 
417     /**
418      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
419      */
420     function toHexString(uint256 value) internal pure returns (string memory) {
421         if (value == 0) {
422             return "0x00";
423         }
424         uint256 temp = value;
425         uint256 length = 0;
426         while (temp != 0) {
427             length++;
428             temp >>= 8;
429         }
430         return toHexString(value, length);
431     }
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
435      */
436     function toHexString(uint256 value, uint256 length)
437         internal
438         pure
439         returns (string memory)
440     {
441         bytes memory buffer = new bytes(2 * length + 2);
442         buffer[0] = "0";
443         buffer[1] = "x";
444         for (uint256 i = 2 * length + 1; i > 1; --i) {
445             buffer[i] = _HEX_SYMBOLS[value & 0xf];
446             value >>= 4;
447         }
448         require(value == 0, "Strings: hex length insufficient");
449         return string(buffer);
450     }
451 }
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Collection of functions related to the address type
458  */
459 library Address {
460     /**
461      * @dev Returns true if `account` is a contract.
462      *
463      * [IMPORTANT]
464      * ====
465      * It is unsafe to assume that an address for which this function returns
466      * false is an externally-owned account (EOA) and not a contract.
467      *
468      * Among others, `isContract` will return false for the following
469      * types of addresses:
470      *
471      *  - an externally-owned account
472      *  - a contract in construction
473      *  - an address where a contract will be created
474      *  - an address where a contract lived, but was destroyed
475      * ====
476      */
477     function isContract(address account) internal view returns (bool) {
478         // This method relies on extcodesize, which returns 0 for contracts in
479         // construction, since the code is only stored at the end of the
480         // constructor execution.
481 
482         uint256 size;
483         assembly {
484             size := extcodesize(account)
485         }
486         return size > 0;
487     }
488 
489     /**
490      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
491      * `recipient`, forwarding all available gas and reverting on errors.
492      *
493      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
494      * of certain opcodes, possibly making contracts go over the 2300 gas limit
495      * imposed by `transfer`, making them unable to receive funds via
496      * `transfer`. {sendValue} removes this limitation.
497      *
498      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
499      *
500      * IMPORTANT: because control is transferred to `recipient`, care must be
501      * taken to not create reentrancy vulnerabilities. Consider using
502      * {ReentrancyGuard} or the
503      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
504      */
505     function sendValue(address payable recipient, uint256 amount) internal {
506         require(
507             address(this).balance >= amount,
508             "Address: insufficient balance"
509         );
510 
511         (bool success, ) = recipient.call{value: amount}("");
512         require(
513             success,
514             "Address: unable to send value, recipient may have reverted"
515         );
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data)
537         internal
538         returns (bytes memory)
539     {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return
574             functionCallWithValue(
575                 target,
576                 data,
577                 value,
578                 "Address: low-level call with value failed"
579             );
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
584      * with `errorMessage` as a fallback revert reason when `target` reverts.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         require(
595             address(this).balance >= value,
596             "Address: insufficient balance for call"
597         );
598         require(isContract(target), "Address: call to non-contract");
599 
600         (bool success, bytes memory returndata) = target.call{value: value}(
601             data
602         );
603         return _verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(address target, bytes memory data)
613         internal
614         view
615         returns (bytes memory)
616     {
617         return
618             functionStaticCall(
619                 target,
620                 data,
621                 "Address: low-level static call failed"
622             );
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal view returns (bytes memory) {
636         require(isContract(target), "Address: static call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.staticcall(data);
639         return _verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(address target, bytes memory data)
649         internal
650         returns (bytes memory)
651     {
652         return
653             functionDelegateCall(
654                 target,
655                 data,
656                 "Address: low-level delegate call failed"
657             );
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
662      * but performing a delegate call.
663      *
664      * _Available since v3.4._
665      */
666     function functionDelegateCall(
667         address target,
668         bytes memory data,
669         string memory errorMessage
670     ) internal returns (bytes memory) {
671         require(isContract(target), "Address: delegate call to non-contract");
672 
673         (bool success, bytes memory returndata) = target.delegatecall(data);
674         return _verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     function _verifyCallResult(
678         bool success,
679         bytes memory returndata,
680         string memory errorMessage
681     ) private pure returns (bytes memory) {
682         if (success) {
683             return returndata;
684         } else {
685             // Look for revert reason and bubble it up if present
686             if (returndata.length > 0) {
687                 // The easiest way to bubble the revert reason is using memory via assembly
688 
689                 assembly {
690                     let returndata_size := mload(returndata)
691                     revert(add(32, returndata), returndata_size)
692                 }
693             } else {
694                 revert(errorMessage);
695             }
696         }
697     }
698 }
699 
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
705  * @dev See https://eips.ethereum.org/EIPS/eip-721
706  */
707 interface IERC721Metadata is IERC721 {
708     /**
709      * @dev Returns the token collection name.
710      */
711     function name() external view returns (string memory);
712 
713     /**
714      * @dev Returns the token collection symbol.
715      */
716     function symbol() external view returns (string memory);
717 
718     /**
719      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
720      */
721     function tokenURI(uint256 tokenId) external view returns (string memory);
722 }
723 
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @title ERC721 token receiver interface
729  * @dev Interface for any contract that wants to support safeTransfers
730  * from ERC721 asset contracts.
731  */
732 interface IERC721Receiver {
733     /**
734      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
735      * by `operator` from `from`, this function is called.
736      *
737      * It must return its Solidity selector to confirm the token transfer.
738      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
739      *
740      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
741      */
742     function onERC721Received(
743         address operator,
744         address from,
745         uint256 tokenId,
746         bytes calldata data
747     ) external returns (bytes4);
748 }
749 
750 
751 
752 pragma solidity ^0.8.0;
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension, but not including the Enumerable extension, which is available separately as
757  * {ERC721Enumerable}.
758  */
759 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
760     using Address for address;
761     using Strings for uint256;
762 
763     // Token name
764     string private _name;
765 
766     // Token symbol
767     string private _symbol;
768 
769     // Mapping from token ID to owner address
770     mapping(uint256 => address) private _owners;
771 
772     // Mapping owner address to token count
773     mapping(address => uint256) private _balances;
774 
775     // Mapping from token ID to approved address
776     mapping(uint256 => address) private _tokenApprovals;
777 
778     // Mapping from owner to operator approvals
779     mapping(address => mapping(address => bool)) private _operatorApprovals;
780 
781     /**
782      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
783      */
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId)
793         public
794         view
795         virtual
796         override(ERC165, IERC165)
797         returns (bool)
798     {
799         return
800             interfaceId == type(IERC721).interfaceId ||
801             interfaceId == type(IERC721Metadata).interfaceId ||
802             super.supportsInterface(interfaceId);
803     }
804 
805     /**
806      * @dev See {IERC721-balanceOf}.
807      */
808     function balanceOf(address owner)
809         public
810         view
811         virtual
812         override
813         returns (uint256)
814     {
815         require(
816             owner != address(0),
817             "ERC721: balance query for the zero address"
818         );
819         return _balances[owner];
820     }
821 
822     /**
823      * @dev See {IERC721-ownerOf}.
824      */
825     function ownerOf(uint256 tokenId)
826         public
827         view
828         virtual
829         override
830         returns (address)
831     {
832         address owner = _owners[tokenId];
833         require(
834             owner != address(0),
835             "ERC721: owner query for nonexistent token"
836         );
837         return owner;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-name}.
842      */
843     function name() public view virtual override returns (string memory) {
844         return _name;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-symbol}.
849      */
850     function symbol() public view virtual override returns (string memory) {
851         return _symbol;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-tokenURI}.
856      */
857     function tokenURI(uint256 tokenId)
858         public
859         view
860         virtual
861         override
862         returns (string memory)
863     {
864         require(
865             _exists(tokenId),
866             "ERC721Metadata: URI query for nonexistent token"
867         );
868 
869         string memory baseURI = _baseURI();
870         return
871             bytes(baseURI).length > 0
872                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
873                 : "";
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, can be overriden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return "";
883     }
884 
885     /**
886      * @dev See {IERC721-approve}.
887      */
888     function approve(address to, uint256 tokenId) public virtual override {
889         address owner = ERC721.ownerOf(tokenId);
890         require(to != owner, "ERC721: approval to current owner");
891 
892         require(
893             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
894             "ERC721: approve caller is not owner nor approved for all"
895         );
896 
897         _approve(to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-getApproved}.
902      */
903     function getApproved(uint256 tokenId)
904         public
905         view
906         virtual
907         override
908         returns (address)
909     {
910         require(
911             _exists(tokenId),
912             "ERC721: approved query for nonexistent token"
913         );
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved)
922         public
923         virtual
924         override
925     {
926         require(operator != _msgSender(), "ERC721: approve to caller");
927 
928         _operatorApprovals[_msgSender()][operator] = approved;
929         emit ApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator)
936         public
937         view
938         virtual
939         override
940         returns (bool)
941     {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev See {IERC721-transferFrom}.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         //solhint-disable-next-line max-line-length
954         require(
955             _isApprovedOrOwner(_msgSender(), tokenId),
956             "ERC721: transfer caller is not owner nor approved"
957         );
958 
959         _transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, "");
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) public virtual override {
982         require(
983             _isApprovedOrOwner(_msgSender(), tokenId),
984             "ERC721: transfer caller is not owner nor approved"
985         );
986         _safeTransfer(from, to, tokenId, _data);
987     }
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
994      *
995      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
996      * implement alternative mechanisms to perform token transfer, such as signature-based.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _transfer(from, to, tokenId);
1014         require(
1015             _checkOnERC721Received(from, to, tokenId, _data),
1016             "ERC721: transfer to non ERC721Receiver implementer"
1017         );
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted (`_mint`),
1026      * and stop existing when they are burned (`_burn`).
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return _owners[tokenId] != address(0);
1030     }
1031 
1032     /**
1033      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function _isApprovedOrOwner(address spender, uint256 tokenId)
1040         internal
1041         view
1042         virtual
1043         returns (bool)
1044     {
1045         require(
1046             _exists(tokenId),
1047             "ERC721: operator query for nonexistent token"
1048         );
1049         address owner = ERC721.ownerOf(tokenId);
1050         return (spender == owner ||
1051             getApproved(tokenId) == spender ||
1052             isApprovedForAll(owner, spender));
1053     }
1054 
1055     /**
1056      * @dev Safely mints `tokenId` and transfers it to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(address to, uint256 tokenId) internal virtual {
1066         _safeMint(to, tokenId, "");
1067     }
1068 
1069     /**
1070      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1071      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) internal virtual {
1078         _mint(to, tokenId);
1079         require(
1080             _checkOnERC721Received(address(0), to, tokenId, _data),
1081             "ERC721: transfer to non ERC721Receiver implementer"
1082         );
1083     }
1084 
1085     /**
1086      * @dev Mints `tokenId` and transfers it to `to`.
1087      *
1088      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must not exist.
1093      * - `to` cannot be the zero address.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(address to, uint256 tokenId) internal virtual {
1098         require(to != address(0), "ERC721: mint to the zero address");
1099         require(!_exists(tokenId), "ERC721: token already minted");
1100 
1101         _beforeTokenTransfer(address(0), to, tokenId);
1102 
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(address(0), to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Destroys `tokenId`.
1111      * The approval is cleared when the token is burned.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _burn(uint256 tokenId) internal virtual {
1120         address owner = ERC721.ownerOf(tokenId);
1121 
1122         _beforeTokenTransfer(owner, address(0), tokenId);
1123 
1124         // Clear approvals
1125         _approve(address(0), tokenId);
1126 
1127         _balances[owner] -= 1;
1128         delete _owners[tokenId];
1129 
1130         emit Transfer(owner, address(0), tokenId);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must be owned by `from`.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {
1149         require(
1150             ERC721.ownerOf(tokenId) == from,
1151             "ERC721: transfer of token that is not own"
1152         );
1153         require(to != address(0), "ERC721: transfer to the zero address");
1154 
1155         _beforeTokenTransfer(from, to, tokenId);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId);
1159 
1160         _balances[from] -= 1;
1161         _balances[to] += 1;
1162         _owners[tokenId] = to;
1163 
1164         emit Transfer(from, to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev Approve `to` to operate on `tokenId`
1169      *
1170      * Emits a {Approval} event.
1171      */
1172     function _approve(address to, uint256 tokenId) internal virtual {
1173         _tokenApprovals[tokenId] = to;
1174         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1179      * The call is not executed if the target address is not a contract.
1180      *
1181      * @param from address representing the previous owner of the given token ID
1182      * @param to target address that will receive the tokens
1183      * @param tokenId uint256 ID of the token to be transferred
1184      * @param _data bytes optional data to send along with the call
1185      * @return bool whether the call correctly returned the expected magic value
1186      */
1187     function _checkOnERC721Received(
1188         address from,
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) private returns (bool) {
1193         if (to.isContract()) {
1194             try
1195                 IERC721Receiver(to).onERC721Received(
1196                     _msgSender(),
1197                     from,
1198                     tokenId,
1199                     _data
1200                 )
1201             returns (bytes4 retval) {
1202                 return retval == IERC721Receiver(to).onERC721Received.selector;
1203             } catch (bytes memory reason) {
1204                 if (reason.length == 0) {
1205                     revert(
1206                         "ERC721: transfer to non ERC721Receiver implementer"
1207                     );
1208                 } else {
1209                     assembly {
1210                         revert(add(32, reason), mload(reason))
1211                     }
1212                 }
1213             }
1214         } else {
1215             return true;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before any token transfer. This includes minting
1221      * and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1229      * - `from` and `to` are never both zero.
1230      *
1231      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1232      */
1233     function _beforeTokenTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) internal virtual {}
1238 }
1239 
1240 
1241 
1242 pragma solidity ^0.8.0;
1243 
1244 /**
1245  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1246  * enumerability of all the token ids in the contract as well as all token ids owned by each
1247  * account.
1248  */
1249 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1250     // Mapping from owner to list of owned token IDs
1251     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1252 
1253     // Mapping from token ID to index of the owner tokens list
1254     mapping(uint256 => uint256) private _ownedTokensIndex;
1255 
1256     // Array with all token ids, used for enumeration
1257     uint256[] private _allTokens;
1258 
1259     // Mapping from token id to position in the allTokens array
1260     mapping(uint256 => uint256) private _allTokensIndex;
1261 
1262     /**
1263      * @dev See {IERC165-supportsInterface}.
1264      */
1265     function supportsInterface(bytes4 interfaceId)
1266         public
1267         view
1268         virtual
1269         override(IERC165, ERC721)
1270         returns (bool)
1271     {
1272         return
1273             interfaceId == type(IERC721Enumerable).interfaceId ||
1274             super.supportsInterface(interfaceId);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1279      */
1280     function tokenOfOwnerByIndex(address owner, uint256 index)
1281         public
1282         view
1283         virtual
1284         override
1285         returns (uint256)
1286     {
1287         require(
1288             index < ERC721.balanceOf(owner),
1289             "ERC721Enumerable: owner index out of bounds"
1290         );
1291         return _ownedTokens[owner][index];
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-totalSupply}.
1296      */
1297     function totalSupply() public view virtual override returns (uint256) {
1298         return _allTokens.length;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-tokenByIndex}.
1303      */
1304     function tokenByIndex(uint256 index)
1305         public
1306         view
1307         virtual
1308         override
1309         returns (uint256)
1310     {
1311         require(
1312             index < ERC721Enumerable.totalSupply(),
1313             "ERC721Enumerable: global index out of bounds"
1314         );
1315         return _allTokens[index];
1316     }
1317 
1318     /**
1319      * @dev Hook that is called before any token transfer. This includes minting
1320      * and burning.
1321      *
1322      * Calling conditions:
1323      *
1324      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1325      * transferred to `to`.
1326      * - When `from` is zero, `tokenId` will be minted for `to`.
1327      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1328      * - `from` cannot be the zero address.
1329      * - `to` cannot be the zero address.
1330      *
1331      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1332      */
1333     function _beforeTokenTransfer(
1334         address from,
1335         address to,
1336         uint256 tokenId
1337     ) internal virtual override {
1338         super._beforeTokenTransfer(from, to, tokenId);
1339 
1340         if (from == address(0)) {
1341             _addTokenToAllTokensEnumeration(tokenId);
1342         } else if (from != to) {
1343             _removeTokenFromOwnerEnumeration(from, tokenId);
1344         }
1345         if (to == address(0)) {
1346             _removeTokenFromAllTokensEnumeration(tokenId);
1347         } else if (to != from) {
1348             _addTokenToOwnerEnumeration(to, tokenId);
1349         }
1350     }
1351 
1352     /**
1353      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1354      * @param to address representing the new owner of the given token ID
1355      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1356      */
1357     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1358         uint256 length = ERC721.balanceOf(to);
1359         _ownedTokens[to][length] = tokenId;
1360         _ownedTokensIndex[tokenId] = length;
1361     }
1362 
1363     /**
1364      * @dev Private function to add a token to this extension's token tracking data structures.
1365      * @param tokenId uint256 ID of the token to be added to the tokens list
1366      */
1367     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1368         _allTokensIndex[tokenId] = _allTokens.length;
1369         _allTokens.push(tokenId);
1370     }
1371 
1372     /**
1373      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1374      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1375      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1376      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1377      * @param from address representing the previous owner of the given token ID
1378      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1379      */
1380     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1381         private
1382     {
1383         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1384         // then delete the last slot (swap and pop).
1385 
1386         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1387         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1388 
1389         // When the token to delete is the last token, the swap operation is unnecessary
1390         if (tokenIndex != lastTokenIndex) {
1391             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1392 
1393             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1394             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1395         }
1396 
1397         // This also deletes the contents at the last position of the array
1398         delete _ownedTokensIndex[tokenId];
1399         delete _ownedTokens[from][lastTokenIndex];
1400     }
1401 
1402     /**
1403      * @dev Private function to remove a token from this extension's token tracking data structures.
1404      * This has O(1) time complexity, but alters the order of the _allTokens array.
1405      * @param tokenId uint256 ID of the token to be removed from the tokens list
1406      */
1407     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1408         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1409         // then delete the last slot (swap and pop).
1410 
1411         uint256 lastTokenIndex = _allTokens.length - 1;
1412         uint256 tokenIndex = _allTokensIndex[tokenId];
1413 
1414         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1415         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1416         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1417         uint256 lastTokenId = _allTokens[lastTokenIndex];
1418 
1419         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1420         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1421 
1422         // This also deletes the contents at the last position of the array
1423         delete _allTokensIndex[tokenId];
1424         _allTokens.pop();
1425     }
1426 }
1427 
1428 pragma solidity ^0.8.0;
1429 
1430 /**
1431  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1432  *
1433  * These functions can be used to verify that a message was signed by the holder
1434  * of the private keys of a given address.
1435  */
1436 library ECDSA {
1437     enum RecoverError {
1438         NoError,
1439         InvalidSignature,
1440         InvalidSignatureLength,
1441         InvalidSignatureS,
1442         InvalidSignatureV
1443     }
1444 
1445     function _throwError(RecoverError error) private pure {
1446         if (error == RecoverError.NoError) {
1447             return; // no error: do nothing
1448         } else if (error == RecoverError.InvalidSignature) {
1449             revert("ECDSA: invalid signature");
1450         } else if (error == RecoverError.InvalidSignatureLength) {
1451             revert("ECDSA: invalid signature length");
1452         } else if (error == RecoverError.InvalidSignatureS) {
1453             revert("ECDSA: invalid signature 's' value");
1454         } else if (error == RecoverError.InvalidSignatureV) {
1455             revert("ECDSA: invalid signature 'v' value");
1456         }
1457     }
1458 
1459     /**
1460      * @dev Returns the address that signed a hashed message (`hash`) with
1461      * `signature` or error string. This address can then be used for verification purposes.
1462      *
1463      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1464      * this function rejects them by requiring the `s` value to be in the lower
1465      * half order, and the `v` value to be either 27 or 28.
1466      *
1467      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1468      * verification to be secure: it is possible to craft signatures that
1469      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1470      * this is by receiving a hash of the original message (which may otherwise
1471      * be too long), and then calling {toEthSignedMessageHash} on it.
1472      *
1473      * Documentation for signature generation:
1474      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1475      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1476      *
1477      * _Available since v4.3._
1478      */
1479     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1480         // Check the signature length
1481         // - case 65: r,s,v signature (standard)
1482         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1483         if (signature.length == 65) {
1484             bytes32 r;
1485             bytes32 s;
1486             uint8 v;
1487             // ecrecover takes the signature parameters, and the only way to get them
1488             // currently is to use assembly.
1489             assembly {
1490                 r := mload(add(signature, 0x20))
1491                 s := mload(add(signature, 0x40))
1492                 v := byte(0, mload(add(signature, 0x60)))
1493             }
1494             return tryRecover(hash, v, r, s);
1495         } else if (signature.length == 64) {
1496             bytes32 r;
1497             bytes32 vs;
1498             // ecrecover takes the signature parameters, and the only way to get them
1499             // currently is to use assembly.
1500             assembly {
1501                 r := mload(add(signature, 0x20))
1502                 vs := mload(add(signature, 0x40))
1503             }
1504             return tryRecover(hash, r, vs);
1505         } else {
1506             return (address(0), RecoverError.InvalidSignatureLength);
1507         }
1508     }
1509 
1510     /**
1511      * @dev Returns the address that signed a hashed message (`hash`) with
1512      * `signature`. This address can then be used for verification purposes.
1513      *
1514      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1515      * this function rejects them by requiring the `s` value to be in the lower
1516      * half order, and the `v` value to be either 27 or 28.
1517      *
1518      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1519      * verification to be secure: it is possible to craft signatures that
1520      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1521      * this is by receiving a hash of the original message (which may otherwise
1522      * be too long), and then calling {toEthSignedMessageHash} on it.
1523      */
1524     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1525         (address recovered, RecoverError error) = tryRecover(hash, signature);
1526         _throwError(error);
1527         return recovered;
1528     }
1529 
1530     /**
1531      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1532      *
1533      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1534      *
1535      * _Available since v4.3._
1536      */
1537     function tryRecover(
1538         bytes32 hash,
1539         bytes32 r,
1540         bytes32 vs
1541     ) internal pure returns (address, RecoverError) {
1542         bytes32 s;
1543         uint8 v;
1544         assembly {
1545             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1546             v := add(shr(255, vs), 27)
1547         }
1548         return tryRecover(hash, v, r, s);
1549     }
1550 
1551     /**
1552      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1553      *
1554      * _Available since v4.2._
1555      */
1556     function recover(
1557         bytes32 hash,
1558         bytes32 r,
1559         bytes32 vs
1560     ) internal pure returns (address) {
1561         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1562         _throwError(error);
1563         return recovered;
1564     }
1565 
1566     /**
1567      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1568      * `r` and `s` signature fields separately.
1569      *
1570      * _Available since v4.3._
1571      */
1572     function tryRecover(
1573         bytes32 hash,
1574         uint8 v,
1575         bytes32 r,
1576         bytes32 s
1577     ) internal pure returns (address, RecoverError) {
1578         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1579         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1580         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1581         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1582         //
1583         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1584         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1585         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1586         // these malleable signatures as well.
1587         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1588             return (address(0), RecoverError.InvalidSignatureS);
1589         }
1590         if (v != 27 && v != 28) {
1591             return (address(0), RecoverError.InvalidSignatureV);
1592         }
1593 
1594         // If the signature is valid (and not malleable), return the signer address
1595         address signer = ecrecover(hash, v, r, s);
1596         if (signer == address(0)) {
1597             return (address(0), RecoverError.InvalidSignature);
1598         }
1599 
1600         return (signer, RecoverError.NoError);
1601     }
1602 
1603     /**
1604      * @dev Overload of {ECDSA-recover} that receives the `v`,
1605      * `r` and `s` signature fields separately.
1606      */
1607     function recover(
1608         bytes32 hash,
1609         uint8 v,
1610         bytes32 r,
1611         bytes32 s
1612     ) internal pure returns (address) {
1613         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1614         _throwError(error);
1615         return recovered;
1616     }
1617 
1618     /**
1619      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1620      * produces hash corresponding to the one signed with the
1621      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1622      * JSON-RPC method as part of EIP-191.
1623      *
1624      * See {recover}.
1625      */
1626     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1627         // 32 is the length in bytes of hash,
1628         // enforced by the type signature above
1629         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1630     }
1631 
1632     /**
1633      * @dev Returns an Ethereum Signed Typed Data, created from a
1634      * `domainSeparator` and a `structHash`. This produces hash corresponding
1635      * to the one signed with the
1636      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1637      * JSON-RPC method as part of EIP-712.
1638      *
1639      * See {recover}.
1640      */
1641     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1642         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1643     }
1644 }
1645 
1646 pragma solidity ^0.8.4;
1647 
1648 /*
1649 ________  .___  ________
1650 \______ \ |   |/  _____/
1651  |    |  \|   /   \  ___
1652  |    `   \   \    \_\  \
1653 /_______  /___|\______  /
1654         \/            \/
1655 .________________________
1656 |   \__    ___/\____    /
1657 |   | |    |     /     /
1658 |   | |    |    /     /_
1659 |___| |____|   /_______ \
1660                        \/
1661                                         By Dylan Massoud and Arthur Wolfe.
1662 */
1663 
1664 
1665 contract Digitz is ERC721Enumerable, Ownable {
1666     using Strings for uint256;
1667     using ECDSA for bytes32;
1668     uint256 public constant DIGITZ_PRIVATE = 9999;
1669     uint256 public constant DIGITZ_MAX =  9999;
1670     uint256 public constant DIGITZ_PRICE = 0.069 ether;
1671     uint256 public constant DIGITZ_PER_PUBLIC_MINT = 10;
1672     mapping(address => uint256) public presalerListPurchases;
1673     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmNNmN2JGayxRk3hwEWw5gMCUyfmikgosrAQuCWnc9tDdN/";
1674     string private constant Sig_WORD = "private";
1675     address private _signerAddress = 0x956231B802D9494296acdE7B3Ce3890c8b0438b8;
1676     address private a1 = 0x5799f96991DeDECD1200ddFbe5197f64725a24c7;
1677     uint256 public privateAmountMinted;
1678     uint256 public presalePurchaseLimit = 10;
1679     bool public presaleLive;
1680     bool public saleLive;
1681     bool public locked;
1682 
1683     constructor() ERC721("DIGITZ", "DIGITZ") {}
1684 
1685     modifier notLocked {
1686         require(!locked, "Contract metadata methods are locked");
1687         _;
1688     }
1689 
1690 
1691     function matchAddresSigner(bytes memory signature) private view returns(bool) {
1692          bytes32 hash = keccak256(abi.encodePacked(
1693             "\x19Ethereum Signed Message:\n32",
1694             keccak256(abi.encodePacked(msg.sender, Sig_WORD)))
1695           );
1696         return _signerAddress == hash.recover(signature);
1697     }
1698 
1699     function founderMint(uint256 tokenQuantity) external onlyOwner {
1700         require(totalSupply() + tokenQuantity <= DIGITZ_MAX, "EXCEED_MAX");
1701         for(uint256 i = 0; i < tokenQuantity; i++) {
1702             _safeMint(msg.sender, totalSupply() + 1);
1703         }
1704     }
1705 
1706     function gift(address[] calldata receivers) external onlyOwner {
1707         require(totalSupply() + receivers.length <= DIGITZ_MAX, "EXCEED_MAX");
1708         for (uint256 i = 0; i < receivers.length; i++) {
1709             _safeMint(receivers[i], totalSupply() + 1);
1710         }
1711     }
1712 
1713     function buy(uint256 tokenQuantity) external payable {
1714         require(saleLive, "SALE_CLOSED");
1715         require(!presaleLive, "ONLY_PRESALE");
1716         require(totalSupply() + tokenQuantity <= DIGITZ_MAX, "EXCEED_MAX");
1717         require(tokenQuantity <= DIGITZ_PER_PUBLIC_MINT, "EXCEED_DIGITZ_PER_PUBLIC_MINT");
1718         require(DIGITZ_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1719 
1720         for(uint256 i = 0; i < tokenQuantity; i++) {
1721             _safeMint(msg.sender, totalSupply() + 1);
1722         }
1723     }
1724 
1725     function presaleBuy(bytes memory signature, uint256 tokenQuantity) external payable {
1726         require(!saleLive && presaleLive, "PRESALE_CLOSED");
1727         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1728         require(privateAmountMinted + tokenQuantity <= DIGITZ_PRIVATE, "EXCEED_PRIVATE");
1729         require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "EXCEED_ALLOC");
1730         require(DIGITZ_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1731 
1732         for(uint256 i = 0; i < tokenQuantity; i++) {
1733             privateAmountMinted++;
1734             presalerListPurchases[msg.sender]++;
1735             _safeMint(msg.sender, totalSupply() + 1);
1736         }
1737     }
1738 
1739     function withdraw() external {
1740         uint256 balance = address(this).balance;
1741         require(balance > 0);
1742         payable(a1).transfer(address(this).balance);
1743     }
1744 
1745     function presalePurchasedCount(address addr) external view returns (uint256) {
1746         return presalerListPurchases[addr];
1747     }
1748 
1749     function lockMetadata() external onlyOwner {
1750         locked = true;
1751     }
1752 
1753     function togglePresaleStatus() external onlyOwner {
1754         presaleLive = !presaleLive;
1755     }
1756 
1757     function toggleSaleStatus() external onlyOwner {
1758         saleLive = !saleLive;
1759     }
1760 
1761     function setSignerAddress(address addr) external onlyOwner {
1762         _signerAddress = addr;
1763     }
1764 
1765     function setBaseURI(string calldata URI) external onlyOwner notLocked {
1766         _tokenBaseURI = URI;
1767     }
1768 
1769     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1770         require(_exists(tokenId), "Cannot query non-existent token");
1771 
1772         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1773     }
1774 }