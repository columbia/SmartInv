1 // File: TribePass.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @title Counters
8  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
9  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
10  *
11  * Include with `using Counters for Counters.Counter;`
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26     unchecked {
27         counter._value += 1;
28     }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34     unchecked {
35         counter._value = value - 1;
36     }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 
44 
45 pragma solidity ^0.8.0;
46 
47 /*
48  * @dev Provides information about the current execution context, including the
49  * sender of the transaction and its data. While these are generally available
50  * via msg.sender and msg.data, they should not be accessed in such a direct
51  * manner, since when dealing with meta-transactions the account sending and
52  * paying for execution may not be the actual sender (as far as an application
53  * is concerned).
54  *
55  * This contract is only required for intermediate, library-like contracts.
56  */
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         return msg.data;
64     }
65 }
66 
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev Interface of the ERC165 standard, as defined in the
72  * https://eips.ethereum.org/EIPS/eip-165[EIP].
73  *
74  * Implementers can declare support of contract interfaces, which can then be
75  * queried by others ({ERC165Checker}).
76  *
77  * For an implementation, see {ERC165}.
78  */
79 interface IERC165 {
80     /**
81      * @dev Returns true if this contract implements the interface defined by
82      * `interfaceId`. See the corresponding
83      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
84      * to learn more about how these ids are created.
85      *
86      * This function call must use less than 30 000 gas.
87      */
88     function supportsInterface(bytes4 interfaceId) external view returns (bool);
89 }
90 
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(
102         address indexed from,
103         address indexed to,
104         uint indexed tokenId
105     );
106 
107     /**
108      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
109      */
110     event Approval(
111         address indexed owner,
112         address indexed approved,
113         uint indexed tokenId
114     );
115 
116     /**
117      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
118      */
119     event ApprovalForAll(
120         address indexed owner,
121         address indexed operator,
122         bool approved
123     );
124 
125     /**
126      * @dev Returns the number of tokens in ``owner``'s account.
127      */
128     function balanceOf(address owner) external view returns (uint balance);
129 
130     /**
131      * @dev Returns the owner of the `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function ownerOf(uint tokenId) external view returns (address owner);
138 
139     /**
140      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
141      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint tokenId
157     ) external;
158 
159     /**
160      * @dev Transfers `tokenId` token from `from` to `to`.
161      *
162      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address from,
175         address to,
176         uint tokenId
177     ) external;
178 
179     /**
180      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
181      * The approval is cleared when the token is transferred.
182      *
183      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
184      *
185      * Requirements:
186      *
187      * - The caller must own the token or be an approved operator.
188      * - `tokenId` must exist.
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address to, uint tokenId) external;
193 
194     /**
195      * @dev Returns the account approved for `tokenId` token.
196      *
197      * Requirements:
198      *
199      * - `tokenId` must exist.
200      */
201     function getApproved(uint tokenId)
202     external
203     view
204     returns (address operator);
205 
206     /**
207      * @dev Approve or remove `operator` as an operator for the caller.
208      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
209      *
210      * Requirements:
211      *
212      * - The `operator` cannot be the caller.
213      *
214      * Emits an {ApprovalForAll} event.
215      */
216     function setApprovalForAll(address operator, bool _approved) external;
217 
218     /**
219      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
220      *
221      * See {setApprovalForAll}
222      */
223     function isApprovedForAll(address owner, address operator)
224     external
225     view
226     returns (bool);
227 
228     /**
229      * @dev Safely transfers `tokenId` token from `from` to `to`.
230      *
231      * Requirements:
232      *
233      * - `from` cannot be the zero address.
234      * - `to` cannot be the zero address.
235      * - `tokenId` token must exist and be owned by `from`.
236      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238      *
239      * Emits a {Transfer} event.
240      */
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint tokenId,
245         bytes calldata data
246     ) external;
247 }
248 
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Contract module which provides a basic access control mechanism, where
254  * there is an account (an owner) that can be granted exclusive access to
255  * specific functions.
256  *
257  * By default, the owner account will be the one that deploys the contract. This
258  * can later be changed with {transferOwnership}.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(
268         address indexed previousOwner,
269         address indexed newOwner
270     );
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _setOwner(_msgSender());
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         _setOwner(address(0));
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(
311             newOwner != address(0),
312             "Ownable: new owner is the zero address"
313         );
314         _setOwner(newOwner);
315     }
316 
317     function _setOwner(address newOwner) private {
318         address oldOwner = _owner;
319         _owner = newOwner;
320         emit OwnershipTransferred(oldOwner, newOwner);
321     }
322 }
323 
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
329  * @dev See https://eips.ethereum.org/EIPS/eip-721
330  */
331 interface IERC721Enumerable is IERC721 {
332     /**
333      * @dev Returns the total amount of tokens stored by the contract.
334      */
335     function totalSupply() external view returns (uint);
336 
337     /**
338      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
339      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
340      */
341     function tokenOfOwnerByIndex(address owner, uint index)
342     external
343     view
344     returns (uint tokenId);
345 
346     /**
347      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
348      * Use along with {totalSupply} to enumerate all tokens.
349      */
350     function tokenByIndex(uint index) external view returns (uint);
351 }
352 
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Implementation of the {IERC165} interface.
358  *
359  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
360  * for the additional interface id that will be supported. For example:
361  *
362  * ```solidity
363  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
364  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
365  * }
366  * ```
367  *
368  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
369  */
370 abstract contract ERC165 is IERC165 {
371     /**
372      * @dev See {IERC165-supportsInterface}.
373      */
374     function supportsInterface(bytes4 interfaceId)
375     public
376     view
377     virtual
378     override
379     returns (bool)
380     {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev String operations.
390  */
391 library Strings {
392     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
393 
394     /**
395      * @dev Converts a `uint` to its ASCII `string` decimal representation.
396      */
397     function toString(uint value) internal pure returns (string memory) {
398         // Inspired by OraclizeAPI's implementation - MIT licence
399         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
400 
401         if (value == 0) {
402             return "0";
403         }
404         uint temp = value;
405         uint digits;
406         while (temp != 0) {
407             digits++;
408             temp /= 10;
409         }
410         bytes memory buffer = new bytes(digits);
411         while (value != 0) {
412             digits -= 1;
413             buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
414             value /= 10;
415         }
416         return string(buffer);
417     }
418 
419     /**
420      * @dev Converts a `uint` to its ASCII `string` hexadecimal representation.
421      */
422     function toHexString(uint value) internal pure returns (string memory) {
423         if (value == 0) {
424             return "0x00";
425         }
426         uint temp = value;
427         uint length = 0;
428         while (temp != 0) {
429             length++;
430             temp >>= 8;
431         }
432         return toHexString(value, length);
433     }
434 
435     /**
436      * @dev Converts a `uint` to its ASCII `string` hexadecimal representation with fixed length.
437      */
438     function toHexString(uint value, uint length)
439     internal
440     pure
441     returns (string memory)
442     {
443         bytes memory buffer = new bytes(2 * length + 2);
444         buffer[0] = "0";
445         buffer[1] = "x";
446         for (uint i = 2 * length + 1; i > 1; --i) {
447             buffer[i] = _HEX_SYMBOLS[value & 0xf];
448             value >>= 4;
449         }
450         require(value == 0, "Strings: hex length insufficient");
451         return string(buffer);
452     }
453 }
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Collection of functions related to the address type
460  */
461 library Address {
462     /**
463      * @dev Returns true if `account` is a contract.
464      *
465      * [IMPORTANT]
466      * ====
467      * It is unsafe to assume that an address for which this function returns
468      * false is an externally-owned account (EOA) and not a contract.
469      *
470      * Among others, `isContract` will return false for the following
471      * types of addresses:
472      *
473      *  - an externally-owned account
474      *  - a contract in construction
475      *  - an address where a contract will be created
476      *  - an address where a contract lived, but was destroyed
477      * ====
478      */
479     function isContract(address account) internal view returns (bool) {
480         // This method relies on extcodesize, which returns 0 for contracts in
481         // construction, since the code is only stored at the end of the
482         // constructor execution.
483 
484         uint size;
485         assembly {
486             size := extcodesize(account)
487         }
488         return size > 0;
489     }
490 
491     /**
492      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
493      * `recipient`, forwarding all available gas and reverting on errors.
494      *
495      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
496      * of certain opcodes, possibly making contracts go over the 2300 gas limit
497      * imposed by `transfer`, making them unable to receive funds via
498      * `transfer`. {sendValue} removes this limitation.
499      *
500      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
501      *
502      * IMPORTANT: because control is transferred to `recipient`, care must be
503      * taken to not create reentrancy vulnerabilities. Consider using
504      * {ReentrancyGuard} or the
505      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
506      */
507     function sendValue(address payable recipient, uint amount) internal {
508         require(
509             address(this).balance >= amount,
510             "Address: insufficient balance"
511         );
512 
513         (bool success, ) = recipient.call{value: amount}("");
514         require(
515             success,
516             "Address: unable to send value, recipient may have reverted"
517         );
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data)
539     internal
540     returns (bytes memory)
541     {
542         return functionCall(target, data, "Address: low-level call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
547      * `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         return functionCallWithValue(target, data, 0, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but also transferring `value` wei to `target`.
562      *
563      * Requirements:
564      *
565      * - the calling contract must have an ETH balance of at least `value`.
566      * - the called Solidity function must be `payable`.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint value
574     ) internal returns (bytes memory) {
575         return
576         functionCallWithValue(
577             target,
578             data,
579             value,
580             "Address: low-level call with value failed"
581         );
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint-}[`functionCallWithValue`], but
586      * with `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCallWithValue(
591         address target,
592         bytes memory data,
593         uint value,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(
597             address(this).balance >= value,
598             "Address: insufficient balance for call"
599         );
600         require(isContract(target), "Address: call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.call{value: value}(
603             data
604         );
605         return _verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a static call.
611      *
612      * _Available since v3.3._
613      */
614     function functionStaticCall(address target, bytes memory data)
615     internal
616     view
617     returns (bytes memory)
618     {
619         return
620         functionStaticCall(
621             target,
622             data,
623             "Address: low-level static call failed"
624         );
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a static call.
630      *
631      * _Available since v3.3._
632      */
633     function functionStaticCall(
634         address target,
635         bytes memory data,
636         string memory errorMessage
637     ) internal view returns (bytes memory) {
638         require(isContract(target), "Address: static call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.staticcall(data);
641         return _verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but performing a delegate call.
647      *
648      * _Available since v3.4._
649      */
650     function functionDelegateCall(address target, bytes memory data)
651     internal
652     returns (bytes memory)
653     {
654         return
655         functionDelegateCall(
656             target,
657             data,
658             "Address: low-level delegate call failed"
659         );
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
664      * but performing a delegate call.
665      *
666      * _Available since v3.4._
667      */
668     function functionDelegateCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal returns (bytes memory) {
673         require(isContract(target), "Address: delegate call to non-contract");
674 
675         (bool success, bytes memory returndata) = target.delegatecall(data);
676         return _verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     function _verifyCallResult(
680         bool success,
681         bytes memory returndata,
682         string memory errorMessage
683     ) private pure returns (bytes memory) {
684         if (success) {
685             return returndata;
686         } else {
687             // Look for revert reason and bubble it up if present
688             if (returndata.length > 0) {
689                 // The easiest way to bubble the revert reason is using memory via assembly
690 
691                 assembly {
692                     let returndata_size := mload(returndata)
693                     revert(add(32, returndata), returndata_size)
694                 }
695             } else {
696                 revert(errorMessage);
697             }
698         }
699     }
700 }
701 
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint tokenId) external view returns (string memory);
724 }
725 
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @title ERC721 token receiver interface
731  * @dev Interface for any contract that wants to support safeTransfers
732  * from ERC721 asset contracts.
733  */
734 interface IERC721Receiver {
735     /**
736      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
737      * by `operator` from `from`, this function is called.
738      *
739      * It must return its Solidity selector to confirm the token transfer.
740      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
741      *
742      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
743      */
744     function onERC721Received(
745         address operator,
746         address from,
747         uint tokenId,
748         bytes calldata data
749     ) external returns (bytes4);
750 }
751 
752 
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId)
795     public
796     view
797     virtual
798     override(ERC165, IERC165)
799     returns (bool)
800     {
801         return
802         interfaceId == type(IERC721).interfaceId ||
803         interfaceId == type(IERC721Metadata).interfaceId ||
804         super.supportsInterface(interfaceId);
805     }
806 
807     /**
808      * @dev See {IERC721-balanceOf}.
809      */
810     function balanceOf(address owner)
811     public
812     view
813     virtual
814     override
815     returns (uint)
816     {
817         require(
818             owner != address(0),
819             "ERC721: balance query for the zero address"
820         );
821         return _balances[owner];
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint tokenId)
828     public
829     view
830     virtual
831     override
832     returns (address)
833     {
834         address owner = _owners[tokenId];
835         require(
836             owner != address(0),
837             "ERC721: owner query for nonexistent token"
838         );
839         return owner;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint tokenId)
860     public
861     view
862     virtual
863     override
864     returns (string memory)
865     {
866         require(
867             _exists(tokenId),
868             "ERC721Metadata: URI query for nonexistent token"
869         );
870 
871         string memory baseURI = _baseURI();
872         return
873         bytes(baseURI).length > 0
874         ? string(abi.encodePacked(baseURI, tokenId.toString()))
875         : "";
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overriden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return "";
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint tokenId) public virtual override {
891         address owner = ERC721.ownerOf(tokenId);
892         require(to != owner, "ERC721: approval to current owner");
893 
894         require(
895             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896             "ERC721: approve caller is not owner nor approved for all"
897         );
898 
899         _approve(to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint tokenId)
906     public
907     view
908     virtual
909     override
910     returns (address)
911     {
912         require(
913             _exists(tokenId),
914             "ERC721: approved query for nonexistent token"
915         );
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved)
924     public
925     virtual
926     override
927     {
928         require(operator != _msgSender(), "ERC721: approve to caller");
929 
930         _operatorApprovals[_msgSender()][operator] = approved;
931         emit ApprovalForAll(_msgSender(), operator, approved);
932     }
933 
934     /**
935      * @dev See {IERC721-isApprovedForAll}.
936      */
937     function isApprovedForAll(address owner, address operator)
938     public
939     view
940     virtual
941     override
942     returns (bool)
943     {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev See {IERC721-transferFrom}.
949      */
950     function transferFrom(
951         address from,
952         address to,
953         uint tokenId
954     ) public virtual override {
955         //solhint-disable-next-line max-line-length
956         require(
957             _isApprovedOrOwner(_msgSender(), tokenId),
958             "ERC721: transfer caller is not owner nor approved"
959         );
960 
961         _transfer(from, to, tokenId);
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint tokenId
971     ) public virtual override {
972         safeTransferFrom(from, to, tokenId, "");
973     }
974 
975     /**
976      * @dev See {IERC721-safeTransferFrom}.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint tokenId,
982         bytes memory _data
983     ) public virtual override {
984         require(
985             _isApprovedOrOwner(_msgSender(), tokenId),
986             "ERC721: transfer caller is not owner nor approved"
987         );
988         _safeTransfer(from, to, tokenId, _data);
989     }
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
993      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
994      *
995      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
996      *
997      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
998      * implement alternative mechanisms to perform token transfer, such as signature-based.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must exist and be owned by `from`.
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeTransfer(
1010         address from,
1011         address to,
1012         uint tokenId,
1013         bytes memory _data
1014     ) internal virtual {
1015         _transfer(from, to, tokenId);
1016         require(
1017             _checkOnERC721Received(from, to, tokenId, _data),
1018             "ERC721: transfer to non ERC721Receiver implementer"
1019         );
1020     }
1021 
1022     /**
1023      * @dev Returns whether `tokenId` exists.
1024      *
1025      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1026      *
1027      * Tokens start existing when they are minted (`_mint`),
1028      * and stop existing when they are burned (`_burn`).
1029      */
1030     function _exists(uint tokenId) internal view virtual returns (bool) {
1031         return _owners[tokenId] != address(0);
1032     }
1033 
1034     /**
1035      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1036      *
1037      * Requirements:
1038      *
1039      * - `tokenId` must exist.
1040      */
1041     function _isApprovedOrOwner(address spender, uint tokenId)
1042     internal
1043     view
1044     virtual
1045     returns (bool)
1046     {
1047         require(
1048             _exists(tokenId),
1049             "ERC721: operator query for nonexistent token"
1050         );
1051         address owner = ERC721.ownerOf(tokenId);
1052         return (spender == owner ||
1053         getApproved(tokenId) == spender ||
1054         isApprovedForAll(owner, spender));
1055     }
1056 
1057     /**
1058      * @dev Safely mints `tokenId` and transfers it to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must not exist.
1063      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(address to, uint tokenId) internal virtual {
1068         _safeMint(to, tokenId, "");
1069     }
1070 
1071     /**
1072      * @dev Same as {xref-ERC721-_safeMint-address-uint-}[`_safeMint`], with an additional `data` parameter which is
1073      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint tokenId,
1078         bytes memory _data
1079     ) internal virtual {
1080         _mint(to, tokenId);
1081         require(
1082             _checkOnERC721Received(address(0), to, tokenId, _data),
1083             "ERC721: transfer to non ERC721Receiver implementer"
1084         );
1085     }
1086 
1087     /**
1088      * @dev Mints `tokenId` and transfers it to `to`.
1089      *
1090      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must not exist.
1095      * - `to` cannot be the zero address.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _mint(address to, uint tokenId) internal virtual {
1100         require(to != address(0), "ERC721: mint to the zero address");
1101         require(!_exists(tokenId), "ERC721: token already minted");
1102 
1103         _beforeTokenTransfer(address(0), to, tokenId);
1104 
1105         _balances[to] += 1;
1106         _owners[tokenId] = to;
1107 
1108         emit Transfer(address(0), to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Destroys `tokenId`.
1113      * The approval is cleared when the token is burned.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must exist.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _burn(uint tokenId) internal virtual {
1122         address owner = ERC721.ownerOf(tokenId);
1123 
1124         _beforeTokenTransfer(owner, address(0), tokenId);
1125 
1126         // Clear approvals
1127         _approve(address(0), tokenId);
1128 
1129         _balances[owner] -= 1;
1130         delete _owners[tokenId];
1131 
1132         emit Transfer(owner, address(0), tokenId);
1133     }
1134 
1135     /**
1136      * @dev Transfers `tokenId` from `from` to `to`.
1137      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint tokenId
1150     ) internal virtual {
1151         require(
1152             ERC721.ownerOf(tokenId) == from,
1153             "ERC721: transfer of token that is not own"
1154         );
1155         require(to != address(0), "ERC721: transfer to the zero address");
1156 
1157         _beforeTokenTransfer(from, to, tokenId);
1158 
1159         // Clear approvals from the previous owner
1160         _approve(address(0), tokenId);
1161 
1162         _balances[from] -= 1;
1163         _balances[to] += 1;
1164         _owners[tokenId] = to;
1165 
1166         emit Transfer(from, to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(address to, uint tokenId) internal virtual {
1175         _tokenApprovals[tokenId] = to;
1176         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try
1197             IERC721Receiver(to).onERC721Received(
1198                 _msgSender(),
1199                 from,
1200                 tokenId,
1201                 _data
1202             )
1203             returns (bytes4 retval) {
1204                 return retval == IERC721Receiver(to).onERC721Received.selector;
1205             } catch (bytes memory reason) {
1206                 if (reason.length == 0) {
1207                     revert(
1208                     "ERC721: transfer to non ERC721Receiver implementer"
1209                     );
1210                 } else {
1211                     assembly {
1212                         revert(add(32, reason), mload(reason))
1213                     }
1214                 }
1215             }
1216         } else {
1217             return true;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before any token transfer. This includes minting
1223      * and burning.
1224      *
1225      * Calling conditions:
1226      *
1227      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1228      * transferred to `to`.
1229      * - When `from` is zero, `tokenId` will be minted for `to`.
1230      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _beforeTokenTransfer(
1236         address from,
1237         address to,
1238         uint tokenId
1239     ) internal virtual {}
1240 }
1241 
1242 
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1248  * enumerability of all the token ids in the contract as well as all token ids owned by each
1249  * account.
1250  */
1251 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1252     // Mapping from owner to list of owned token IDs
1253     mapping(address => mapping(uint => uint)) private _ownedTokens;
1254 
1255     // Mapping from token ID to index of the owner tokens list
1256     mapping(uint => uint) private _ownedTokensIndex;
1257 
1258     // Array with all token ids, used for enumeration
1259     uint[] private _allTokens;
1260 
1261     // Mapping from token id to position in the allTokens array
1262     mapping(uint => uint) private _allTokensIndex;
1263 
1264     /**
1265      * @dev See {IERC165-supportsInterface}.
1266      */
1267     function supportsInterface(bytes4 interfaceId)
1268     public
1269     view
1270     virtual
1271     override(IERC165, ERC721)
1272     returns (bool)
1273     {
1274         return
1275         interfaceId == type(IERC721Enumerable).interfaceId ||
1276         super.supportsInterface(interfaceId);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1281      */
1282     function tokenOfOwnerByIndex(address owner, uint index)
1283     public
1284     view
1285     virtual
1286     override
1287     returns (uint)
1288     {
1289         require(
1290             index < ERC721.balanceOf(owner),
1291             "ERC721Enumerable: owner index out of bounds"
1292         );
1293         return _ownedTokens[owner][index];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view virtual override returns (uint) {
1300         return _allTokens.length;
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenByIndex}.
1305      */
1306     function tokenByIndex(uint index)
1307     public
1308     view
1309     virtual
1310     override
1311     returns (uint)
1312     {
1313         require(
1314             index < ERC721Enumerable.totalSupply(),
1315             "ERC721Enumerable: global index out of bounds"
1316         );
1317         return _allTokens[index];
1318     }
1319 
1320     /**
1321      * @dev Hook that is called before any token transfer. This includes minting
1322      * and burning.
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1330      * - `from` cannot be the zero address.
1331      * - `to` cannot be the zero address.
1332      *
1333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1334      */
1335     function _beforeTokenTransfer(
1336         address from,
1337         address to,
1338         uint tokenId
1339     ) internal virtual override {
1340         super._beforeTokenTransfer(from, to, tokenId);
1341 
1342         if (from == address(0)) {
1343             _addTokenToAllTokensEnumeration(tokenId);
1344         } else if (from != to) {
1345             _removeTokenFromOwnerEnumeration(from, tokenId);
1346         }
1347         if (to == address(0)) {
1348             _removeTokenFromAllTokensEnumeration(tokenId);
1349         } else if (to != from) {
1350             _addTokenToOwnerEnumeration(to, tokenId);
1351         }
1352     }
1353 
1354     /**
1355      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1356      * @param to address representing the new owner of the given token ID
1357      * @param tokenId uint ID of the token to be added to the tokens list of the given address
1358      */
1359     function _addTokenToOwnerEnumeration(address to, uint tokenId) private {
1360         uint length = ERC721.balanceOf(to);
1361         _ownedTokens[to][length] = tokenId;
1362         _ownedTokensIndex[tokenId] = length;
1363     }
1364 
1365     /**
1366      * @dev Private function to add a token to this extension's token tracking data structures.
1367      * @param tokenId uint ID of the token to be added to the tokens list
1368      */
1369     function _addTokenToAllTokensEnumeration(uint tokenId) private {
1370         _allTokensIndex[tokenId] = _allTokens.length;
1371         _allTokens.push(tokenId);
1372     }
1373 
1374     /**
1375      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1376      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1377      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1378      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1379      * @param from address representing the previous owner of the given token ID
1380      * @param tokenId uint ID of the token to be removed from the tokens list of the given address
1381      */
1382     function _removeTokenFromOwnerEnumeration(address from, uint tokenId)
1383     private
1384     {
1385         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1386         // then delete the last slot (swap and pop).
1387 
1388         uint lastTokenIndex = ERC721.balanceOf(from) - 1;
1389         uint tokenIndex = _ownedTokensIndex[tokenId];
1390 
1391         // When the token to delete is the last token, the swap operation is unnecessary
1392         if (tokenIndex != lastTokenIndex) {
1393             uint lastTokenId = _ownedTokens[from][lastTokenIndex];
1394 
1395             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1396             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1397         }
1398 
1399         // This also deletes the contents at the last position of the array
1400         delete _ownedTokensIndex[tokenId];
1401         delete _ownedTokens[from][lastTokenIndex];
1402     }
1403 
1404     /**
1405      * @dev Private function to remove a token from this extension's token tracking data structures.
1406      * This has O(1) time complexity, but alters the order of the _allTokens array.
1407      * @param tokenId uint ID of the token to be removed from the tokens list
1408      */
1409     function _removeTokenFromAllTokensEnumeration(uint tokenId) private {
1410         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1411         // then delete the last slot (swap and pop).
1412 
1413         uint lastTokenIndex = _allTokens.length - 1;
1414         uint tokenIndex = _allTokensIndex[tokenId];
1415 
1416         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1417         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1418         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1419         uint lastTokenId = _allTokens[lastTokenIndex];
1420 
1421         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1422         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1423 
1424         // This also deletes the contents at the last position of the array
1425         delete _allTokensIndex[tokenId];
1426         _allTokens.pop();
1427     }
1428 }
1429 
1430 pragma solidity ^0.8.0;
1431 
1432 /**
1433  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1434  *
1435  * These functions can be used to verify that a message was signed by the holder
1436  * of the private keys of a given address.
1437  */
1438 library ECDSA {
1439     enum RecoverError {
1440         NoError,
1441         InvalidSignature,
1442         InvalidSignatureLength,
1443         InvalidSignatureS,
1444         InvalidSignatureV
1445     }
1446 
1447     function _throwError(RecoverError error) private pure {
1448         if (error == RecoverError.NoError) {
1449             return; // no error: do nothing
1450         } else if (error == RecoverError.InvalidSignature) {
1451             revert("ECDSA: invalid signature");
1452         } else if (error == RecoverError.InvalidSignatureLength) {
1453             revert("ECDSA: invalid signature length");
1454         } else if (error == RecoverError.InvalidSignatureS) {
1455             revert("ECDSA: invalid signature 's' value");
1456         } else if (error == RecoverError.InvalidSignatureV) {
1457             revert("ECDSA: invalid signature 'v' value");
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the address that signed a hashed message (`hash`) with
1463      * `signature` or error string. This address can then be used for verification purposes.
1464      *
1465      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1466      * this function rejects them by requiring the `s` value to be in the lower
1467      * half order, and the `v` value to be either 27 or 28.
1468      *
1469      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1470      * verification to be secure: it is possible to craft signatures that
1471      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1472      * this is by receiving a hash of the original message (which may otherwise
1473      * be too long), and then calling {toEthSignedMessageHash} on it.
1474      *
1475      * Documentation for signature generation:
1476      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1477      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1478      *
1479      * _Available since v4.3._
1480      */
1481     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1482         // Check the signature length
1483         // - case 65: r,s,v signature (standard)
1484         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1485         if (signature.length == 65) {
1486             bytes32 r;
1487             bytes32 s;
1488             uint8 v;
1489             // ecrecover takes the signature parameters, and the only way to get them
1490             // currently is to use assembly.
1491             assembly {
1492                 r := mload(add(signature, 0x20))
1493                 s := mload(add(signature, 0x40))
1494                 v := byte(0, mload(add(signature, 0x60)))
1495             }
1496             return tryRecover(hash, v, r, s);
1497         } else if (signature.length == 64) {
1498             bytes32 r;
1499             bytes32 vs;
1500             // ecrecover takes the signature parameters, and the only way to get them
1501             // currently is to use assembly.
1502             assembly {
1503                 r := mload(add(signature, 0x20))
1504                 vs := mload(add(signature, 0x40))
1505             }
1506             return tryRecover(hash, r, vs);
1507         } else {
1508             return (address(0), RecoverError.InvalidSignatureLength);
1509         }
1510     }
1511 
1512     /**
1513      * @dev Returns the address that signed a hashed message (`hash`) with
1514      * `signature`. This address can then be used for verification purposes.
1515      *
1516      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1517      * this function rejects them by requiring the `s` value to be in the lower
1518      * half order, and the `v` value to be either 27 or 28.
1519      *
1520      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1521      * verification to be secure: it is possible to craft signatures that
1522      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1523      * this is by receiving a hash of the original message (which may otherwise
1524      * be too long), and then calling {toEthSignedMessageHash} on it.
1525      */
1526     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1527         (address recovered, RecoverError error) = tryRecover(hash, signature);
1528         _throwError(error);
1529         return recovered;
1530     }
1531 
1532     /**
1533      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1534      *
1535      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1536      *
1537      * _Available since v4.3._
1538      */
1539     function tryRecover(
1540         bytes32 hash,
1541         bytes32 r,
1542         bytes32 vs
1543     ) internal pure returns (address, RecoverError) {
1544         bytes32 s;
1545         uint8 v;
1546         assembly {
1547             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1548             v := add(shr(255, vs), 27)
1549         }
1550         return tryRecover(hash, v, r, s);
1551     }
1552 
1553     /**
1554      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1555      *
1556      * _Available since v4.2._
1557      */
1558     function recover(
1559         bytes32 hash,
1560         bytes32 r,
1561         bytes32 vs
1562     ) internal pure returns (address) {
1563         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1564         _throwError(error);
1565         return recovered;
1566     }
1567 
1568 
1569     function tryRecover(
1570         bytes32 hash,
1571         uint8 v,
1572         bytes32 r,
1573         bytes32 s
1574     ) internal pure returns (address, RecoverError) {
1575 
1576         if (uint(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1577             return (address(0), RecoverError.InvalidSignatureS);
1578         }
1579         if (v != 27 && v != 28) {
1580             return (address(0), RecoverError.InvalidSignatureV);
1581         }
1582 
1583         // If the signature is valid (and not malleable), return the signer address
1584         address signer = ecrecover(hash, v, r, s);
1585         if (signer == address(0)) {
1586             return (address(0), RecoverError.InvalidSignature);
1587         }
1588 
1589         return (signer, RecoverError.NoError);
1590     }
1591 
1592 
1593     function recover(
1594         bytes32 hash,
1595         uint8 v,
1596         bytes32 r,
1597         bytes32 s
1598     ) internal pure returns (address) {
1599         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1600         _throwError(error);
1601         return recovered;
1602     }
1603 
1604     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1605 
1606         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1607     }
1608 
1609     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1610         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1611     }
1612 }
1613 
1614 pragma solidity ^0.8.0;
1615 
1616 /**
1617  * Authors: Saber Cuban and Dylan Massoud
1618  */
1619 
1620 contract tribepass is ERC721Enumerable, Ownable {
1621     using Strings for uint;
1622     using ECDSA for bytes32;
1623 
1624     uint public tribepass_PRESALE = 53; //presale
1625     uint public tribepass_WALLET_PRESALE_LIMIT = 2; //tribepassperwalletInWholeDuration
1626     uint public tribepass_WALLET_PUBLICSALE_LIMIT = 2; //tribepassperwalletInWholeDuration
1627     uint public tribepass_MAX_COUNT = 999; //maxSupply
1628     uint public totalTokensSoldInPresale;
1629     uint public preSaleAmountMinted;
1630 
1631     uint public tribepass_MAINSALE_PRICE = 0.1 ether; //priceInMainSale
1632     uint public tribepass_PRESALE_PRICE = 0.1 ether; //priceInPreSale
1633     mapping (address => uint) public saleListPurchase;
1634     mapping (address => uint) public presalerListPurchases;
1635 
1636     //todo : we need to change this baseURI once metadata is ready
1637     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/";
1638     string private constant Sig_WORD = "private";
1639     address private _signerAddress = 0x956231B802D9494296acdE7B3Ce3890c8b0438b8;
1640     bool public presaleLive;
1641     bool public saleLive;
1642     bool public locked;
1643 
1644     modifier notLocked {
1645         require(!locked, "Contract metadata methods are locked");
1646         _;
1647     }
1648 
1649     constructor() ERC721("TribePass", "TribePass") {}
1650 
1651 
1652     function settribepass_MAX_COUNT(uint _maxCount) external onlyOwner{
1653         tribepass_MAX_COUNT = _maxCount;
1654     }
1655 
1656     function settribepass_PRESALE(uint _presale) external onlyOwner{
1657         tribepass_PRESALE = _presale;
1658     }
1659 
1660     function settribepass_WALLET_PRESALE_LIMIT(uint _presaleLimit) external onlyOwner{
1661         tribepass_WALLET_PRESALE_LIMIT = _presaleLimit;
1662     }
1663 
1664     function settribepass_WALLET_PUBLICSALE_LIMIT(uint _publicSaleLimit) external onlyOwner{
1665         tribepass_WALLET_PUBLICSALE_LIMIT = _publicSaleLimit;
1666     }
1667 
1668     function settribepass_MAINSALE_PRICE(uint _mainSalePrice) external onlyOwner{
1669         tribepass_MAINSALE_PRICE = _mainSalePrice;
1670     }
1671 
1672     function settribepass_PRESALE_PRICE(uint _presalePrice) external onlyOwner{
1673         tribepass_PRESALE_PRICE = _presalePrice;
1674     }
1675 
1676 
1677     function matchAddresSigner(bytes memory signature) private view returns(bool) {
1678         bytes32 hash = keccak256(abi.encodePacked(
1679                 "\x19Ethereum Signed Message:\n32",
1680                 keccak256(abi.encodePacked(msg.sender, Sig_WORD)))
1681         );
1682         return _signerAddress == hash.recover(signature);
1683     }
1684 
1685     function gift(address[] calldata receivers) external onlyOwner {
1686         require(totalSupply() + receivers.length <= tribepass_MAX_COUNT, "EXCEED_MAX");
1687         for (uint i = 0; i < receivers.length; i++) {
1688             _safeMint(receivers[i], totalSupply() + 1);
1689         }
1690     }
1691 
1692     function buy(uint tokenQuantity) external payable {
1693         require (saleLive, "SALE_CLOSED");
1694         require (tokenQuantity <= tribepass_WALLET_PUBLICSALE_LIMIT);
1695         require (saleListPurchase[msg.sender] + tokenQuantity <= tribepass_WALLET_PUBLICSALE_LIMIT, "MAX MINT COMPLETE");
1696         require (totalSupply() + tokenQuantity <= (tribepass_MAX_COUNT - preSaleAmountMinted), "EXCEED_MAX");
1697         require (tribepass_MAINSALE_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1698         saleListPurchase[msg.sender] += tokenQuantity;
1699         for (uint i = 0; i < tokenQuantity; i++) {
1700             _safeMint(msg.sender, totalSupply() + 1);
1701         }
1702     }
1703 
1704     function founderMint(uint tokenQuantity) external onlyOwner {
1705         require(totalSupply() + tokenQuantity <= tribepass_MAX_COUNT, "EXCEED_MAX");
1706         for(uint i = 0; i < tokenQuantity; i++) {
1707         _safeMint(msg.sender, totalSupply() + 1);
1708         }
1709     }
1710 
1711     function tokensOfOwner(address _owner) public view returns (uint256[] memory){
1712         uint256 count = balanceOf(_owner);
1713         uint256[] memory result = new uint256[](count);
1714         for (uint256 index = 0; index < count; index++) {
1715             result[index] = tokenOfOwnerByIndex(_owner, index);
1716         }
1717         return result;
1718     }
1719 
1720     function presaleBuy( bytes memory signature, uint tokenQuantity) external payable{
1721         require (presaleLive, "PRESALE_CLOSED");//tribepass_WALLET_PRESALE_LIMIT
1722         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1723         require(preSaleAmountMinted + tokenQuantity <= tribepass_PRESALE, "EXCEED_PRIVATE");
1724         require(presalerListPurchases[msg.sender] + tokenQuantity <= tribepass_WALLET_PRESALE_LIMIT, "EXCEED_ALLOC");
1725         require(tribepass_MAINSALE_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1726         presalerListPurchases[msg.sender] += tokenQuantity;
1727         preSaleAmountMinted += tokenQuantity;
1728         for(uint i = 0; i < tokenQuantity; i++) {
1729             _safeMint(msg.sender, totalSupply() + 1);
1730         }
1731     }
1732 
1733     function withdraw() external {
1734         uint balance = address(this).balance;
1735         require(balance > 0);
1736         payable(owner()).transfer(address(this).balance);
1737     }
1738 
1739     function presalePurchasedCount(address addr) external view returns (uint) {
1740         return presalerListPurchases[addr];
1741     }
1742 
1743     function lockMetadata(bool _assertion) external onlyOwner {
1744         locked = _assertion;
1745     }
1746 
1747 
1748     function togglePresaleStatus() external onlyOwner {
1749         presaleLive = !presaleLive;
1750     }
1751 
1752     function toggleSaleStatus() external onlyOwner {
1753         saleLive = !saleLive;
1754     }
1755 
1756 
1757     function setSignerAddress(address addr) external onlyOwner {
1758         _signerAddress = addr;
1759     }
1760 
1761     function setBaseURI(string calldata URI) external onlyOwner notLocked {
1762         _tokenBaseURI = URI;
1763     }
1764 
1765     function tokenURI(uint tokenId) public view override(ERC721) returns (string memory) {
1766         require(_exists(tokenId), "Cannot query non-existent token");
1767 
1768         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1769     }
1770 
1771 }