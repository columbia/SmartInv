1 // SPDX-License-Identifier: MIT
2 // File: contracts/utils/introspection/IERC165.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17   /**
18    * @dev Returns true if this contract implements the interface defined by
19    * `interfaceId`. See the corresponding
20    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21    * to learn more about how these ids are created.
22    *
23    * This function call must use less than 30 000 gas.
24    */
25   function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: ../token/IERC721.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39   /**
40    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41    */
42   event Transfer(
43     address indexed from,
44     address indexed to,
45     uint256 indexed tokenId
46   );
47 
48   /**
49    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50    */
51   event Approval(
52     address indexed owner,
53     address indexed approved,
54     uint256 indexed tokenId
55   );
56 
57   /**
58    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59    */
60   event ApprovalForAll(
61     address indexed owner,
62     address indexed operator,
63     bool approved
64   );
65 
66   /**
67    * @dev Returns the number of tokens in ``owner``'s account.
68    */
69   function balanceOf(address owner) external view returns (uint256 balance);
70 
71   /**
72    * @dev Returns the owner of the `tokenId` token.
73    *
74    * Requirements:
75    *
76    * - `tokenId` must exist.
77    */
78   function ownerOf(uint256 tokenId) external view returns (address owner);
79 
80   /**
81    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83    *
84    * Requirements:
85    *
86    * - `from` cannot be the zero address.
87    * - `to` cannot be the zero address.
88    * - `tokenId` token must exist and be owned by `from`.
89    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91    *
92    * Emits a {Transfer} event.
93    */
94   function safeTransferFrom(
95     address from,
96     address to,
97     uint256 tokenId
98   ) external;
99 
100   /**
101    * @dev Transfers `tokenId` token from `from` to `to`.
102    *
103    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104    *
105    * Requirements:
106    *
107    * - `from` cannot be the zero address.
108    * - `to` cannot be the zero address.
109    * - `tokenId` token must be owned by `from`.
110    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111    *
112    * Emits a {Transfer} event.
113    */
114   function transferFrom(
115     address from,
116     address to,
117     uint256 tokenId
118   ) external;
119 
120   /**
121    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122    * The approval is cleared when the token is transferred.
123    *
124    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125    *
126    * Requirements:
127    *
128    * - The caller must own the token or be an approved operator.
129    * - `tokenId` must exist.
130    *
131    * Emits an {Approval} event.
132    */
133   function approve(address to, uint256 tokenId) external;
134 
135   /**
136    * @dev Returns the account approved for `tokenId` token.
137    *
138    * Requirements:
139    *
140    * - `tokenId` must exist.
141    */
142   function getApproved(uint256 tokenId)
143     external
144     view
145     returns (address operator);
146 
147   /**
148    * @dev Approve or remove `operator` as an operator for the caller.
149    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150    *
151    * Requirements:
152    *
153    * - The `operator` cannot be the caller.
154    *
155    * Emits an {ApprovalForAll} event.
156    */
157   function setApprovalForAll(address operator, bool _approved) external;
158 
159   /**
160    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161    *
162    * See {setApprovalForAll}
163    */
164   function isApprovedForAll(address owner, address operator)
165     external
166     view
167     returns (bool);
168 
169   /**
170    * @dev Safely transfers `tokenId` token from `from` to `to`.
171    *
172    * Requirements:
173    *
174    * - `from` cannot be the zero address.
175    * - `to` cannot be the zero address.
176    * - `tokenId` token must exist and be owned by `from`.
177    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179    *
180    * Emits a {Transfer} event.
181    */
182   function safeTransferFrom(
183     address from,
184     address to,
185     uint256 tokenId,
186     bytes calldata data
187   ) external;
188 }
189 
190 // File: ../token/IERC721Receiver.sol
191 
192 
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @title ERC721 token receiver interface
198  * @dev Interface for any contract that wants to support safeTransfers
199  * from ERC721 asset contracts.
200  */
201 interface IERC721Receiver {
202   /**
203    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
204    * by `operator` from `from`, this function is called.
205    *
206    * It must return its Solidity selector to confirm the token transfer.
207    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
208    *
209    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
210    */
211   function onERC721Received(
212     address operator,
213     address from,
214     uint256 tokenId,
215     bytes calldata data
216   ) external returns (bytes4);
217 }
218 
219 // File: ../token/extensions/IERC721Metadata.sol
220 
221 
222 
223 pragma solidity ^0.8.0;
224 
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Metadata is IERC721 {
231   /**
232    * @dev Returns the token collection name.
233    */
234   function name() external view returns (string memory);
235 
236   /**
237    * @dev Returns the token collection symbol.
238    */
239   function symbol() external view returns (string memory);
240 
241   /**
242    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
243    */
244   function tokenURI(uint256 tokenId) external view returns (string memory);
245 }
246 
247 // File: contracts/utils/Address.sol
248 
249 
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257   /**
258    * @dev Returns true if `account` is a contract.
259    *
260    * [IMPORTANT]
261    * ====
262    * It is unsafe to assume that an address for which this function returns
263    * false is an externally-owned account (EOA) and not a contract.
264    *
265    * Among others, `isContract` will return false for the following
266    * types of addresses:
267    *
268    *  - an externally-owned account
269    *  - a contract in construction
270    *  - an address where a contract will be created
271    *  - an address where a contract lived, but was destroyed
272    * ====
273    */
274   function isContract(address account) internal view returns (bool) {
275     // This method relies on extcodesize, which returns 0 for contracts in
276     // construction, since the code is only stored at the end of the
277     // constructor execution.
278 
279     uint256 size;
280     assembly {
281       size := extcodesize(account)
282     }
283     return size > 0;
284   }
285 
286   /**
287    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288    * `recipient`, forwarding all available gas and reverting on errors.
289    *
290    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291    * of certain opcodes, possibly making contracts go over the 2300 gas limit
292    * imposed by `transfer`, making them unable to receive funds via
293    * `transfer`. {sendValue} removes this limitation.
294    *
295    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296    *
297    * IMPORTANT: because control is transferred to `recipient`, care must be
298    * taken to not create reentrancy vulnerabilities. Consider using
299    * {ReentrancyGuard} or the
300    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301    */
302   function sendValue(address payable recipient, uint256 amount) internal {
303     require(address(this).balance >= amount, 'Address: insufficient balance');
304 
305     (bool success, ) = recipient.call{ value: amount }('');
306     require(
307       success,
308       'Address: unable to send value, recipient may have reverted'
309     );
310   }
311 
312   /**
313    * @dev Performs a Solidity function call using a low level `call`. A
314    * plain `call` is an unsafe replacement for a function call: use this
315    * function instead.
316    *
317    * If `target` reverts with a revert reason, it is bubbled up by this
318    * function (like regular Solidity function calls).
319    *
320    * Returns the raw returned data. To convert to the expected return value,
321    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322    *
323    * Requirements:
324    *
325    * - `target` must be a contract.
326    * - calling `target` with `data` must not revert.
327    *
328    * _Available since v3.1._
329    */
330   function functionCall(address target, bytes memory data)
331     internal
332     returns (bytes memory)
333   {
334     return functionCall(target, data, 'Address: low-level call failed');
335   }
336 
337   /**
338    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339    * `errorMessage` as a fallback revert reason when `target` reverts.
340    *
341    * _Available since v3.1._
342    */
343   function functionCall(
344     address target,
345     bytes memory data,
346     string memory errorMessage
347   ) internal returns (bytes memory) {
348     return functionCallWithValue(target, data, 0, errorMessage);
349   }
350 
351   /**
352    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353    * but also transferring `value` wei to `target`.
354    *
355    * Requirements:
356    *
357    * - the calling contract must have an ETH balance of at least `value`.
358    * - the called Solidity function must be `payable`.
359    *
360    * _Available since v3.1._
361    */
362   function functionCallWithValue(
363     address target,
364     bytes memory data,
365     uint256 value
366   ) internal returns (bytes memory) {
367     return
368       functionCallWithValue(
369         target,
370         data,
371         value,
372         'Address: low-level call with value failed'
373       );
374   }
375 
376   /**
377    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378    * with `errorMessage` as a fallback revert reason when `target` reverts.
379    *
380    * _Available since v3.1._
381    */
382   function functionCallWithValue(
383     address target,
384     bytes memory data,
385     uint256 value,
386     string memory errorMessage
387   ) internal returns (bytes memory) {
388     require(
389       address(this).balance >= value,
390       'Address: insufficient balance for call'
391     );
392     require(isContract(target), 'Address: call to non-contract');
393 
394     (bool success, bytes memory returndata) = target.call{ value: value }(data);
395     return _verifyCallResult(success, returndata, errorMessage);
396   }
397 
398   /**
399    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400    * but performing a static call.
401    *
402    * _Available since v3.3._
403    */
404   function functionStaticCall(address target, bytes memory data)
405     internal
406     view
407     returns (bytes memory)
408   {
409     return
410       functionStaticCall(target, data, 'Address: low-level static call failed');
411   }
412 
413   /**
414    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415    * but performing a static call.
416    *
417    * _Available since v3.3._
418    */
419   function functionStaticCall(
420     address target,
421     bytes memory data,
422     string memory errorMessage
423   ) internal view returns (bytes memory) {
424     require(isContract(target), 'Address: static call to non-contract');
425 
426     (bool success, bytes memory returndata) = target.staticcall(data);
427     return _verifyCallResult(success, returndata, errorMessage);
428   }
429 
430   /**
431    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432    * but performing a delegate call.
433    *
434    * _Available since v3.4._
435    */
436   function functionDelegateCall(address target, bytes memory data)
437     internal
438     returns (bytes memory)
439   {
440     return
441       functionDelegateCall(
442         target,
443         data,
444         'Address: low-level delegate call failed'
445       );
446   }
447 
448   /**
449    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450    * but performing a delegate call.
451    *
452    * _Available since v3.4._
453    */
454   function functionDelegateCall(
455     address target,
456     bytes memory data,
457     string memory errorMessage
458   ) internal returns (bytes memory) {
459     require(isContract(target), 'Address: delegate call to non-contract');
460 
461     (bool success, bytes memory returndata) = target.delegatecall(data);
462     return _verifyCallResult(success, returndata, errorMessage);
463   }
464 
465   function _verifyCallResult(
466     bool success,
467     bytes memory returndata,
468     string memory errorMessage
469   ) private pure returns (bytes memory) {
470     if (success) {
471       return returndata;
472     } else {
473       // Look for revert reason and bubble it up if present
474       if (returndata.length > 0) {
475         // The easiest way to bubble the revert reason is using memory via assembly
476 
477         assembly {
478           let returndata_size := mload(returndata)
479           revert(add(32, returndata), returndata_size)
480         }
481       } else {
482         revert(errorMessage);
483       }
484     }
485   }
486 }
487 
488 // File: contracts/utils/Context.sol
489 
490 
491 
492 pragma solidity ^0.8.0;
493 
494 /*
495  * @dev Provides information about the current execution context, including the
496  * sender of the transaction and its data. While these are generally available
497  * via msg.sender and msg.data, they should not be accessed in such a direct
498  * manner, since when dealing with meta-transactions the account sending and
499  * paying for execution may not be the actual sender (as far as an application
500  * is concerned).
501  *
502  * This contract is only required for intermediate, library-like contracts.
503  */
504 abstract contract Context {
505   function _msgSender() internal view virtual returns (address) {
506     return msg.sender;
507   }
508 
509   function _msgData() internal view virtual returns (bytes calldata) {
510     return msg.data;
511   }
512 }
513 
514 // File: contracts/utils/Strings.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
525 
526   /**
527    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528    */
529   function toString(uint256 value) internal pure returns (string memory) {
530     // Inspired by OraclizeAPI's implementation - MIT licence
531     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533     if (value == 0) {
534       return '0';
535     }
536     uint256 temp = value;
537     uint256 digits;
538     while (temp != 0) {
539       digits++;
540       temp /= 10;
541     }
542     bytes memory buffer = new bytes(digits);
543     while (value != 0) {
544       digits -= 1;
545       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546       value /= 10;
547     }
548     return string(buffer);
549   }
550 
551   /**
552    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553    */
554   function toHexString(uint256 value) internal pure returns (string memory) {
555     if (value == 0) {
556       return '0x00';
557     }
558     uint256 temp = value;
559     uint256 length = 0;
560     while (temp != 0) {
561       length++;
562       temp >>= 8;
563     }
564     return toHexString(value, length);
565   }
566 
567   /**
568    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569    */
570   function toHexString(uint256 value, uint256 length)
571     internal
572     pure
573     returns (string memory)
574   {
575     bytes memory buffer = new bytes(2 * length + 2);
576     buffer[0] = '0';
577     buffer[1] = 'x';
578     for (uint256 i = 2 * length + 1; i > 1; --i) {
579       buffer[i] = _HEX_SYMBOLS[value & 0xf];
580       value >>= 4;
581     }
582     require(value == 0, 'Strings: hex length insufficient');
583     return string(buffer);
584   }
585 }
586 
587 // File: contracts/utils/introspection/ERC165.sol
588 
589 
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609   /**
610    * @dev See {IERC165-supportsInterface}.
611    */
612   function supportsInterface(bytes4 interfaceId)
613     public
614     view
615     virtual
616     override
617     returns (bool)
618   {
619     return interfaceId == type(IERC165).interfaceId;
620   }
621 }
622 
623 // File: ../token/ERC721.sol
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 
630 
631 
632 
633 
634 
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
638  * the Metadata extension, but not including the Enumerable extension, which is available separately as
639  * {ERC721Enumerable}.
640  */
641 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
642   using Address for address;
643   using Strings for uint256;
644 
645   // Token name
646   string private _name;
647 
648   // Token symbol
649   string private _symbol;
650 
651   // Mapping from token ID to owner address
652   mapping(uint256 => address) private _owners;
653 
654   // Mapping owner address to token count
655   mapping(address => uint256) private _balances;
656 
657   // Mapping from token ID to approved address
658   mapping(uint256 => address) private _tokenApprovals;
659 
660   // Mapping from owner to operator approvals
661   mapping(address => mapping(address => bool)) private _operatorApprovals;
662 
663   /**
664    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
665    */
666   constructor(string memory name_, string memory symbol_) {
667     _name = name_;
668     _symbol = symbol_;
669   }
670 
671   /**
672    * @dev See {IERC165-supportsInterface}.
673    */
674   function supportsInterface(bytes4 interfaceId)
675     public
676     view
677     virtual
678     override(ERC165, IERC165)
679     returns (bool)
680   {
681     return
682       interfaceId == type(IERC721).interfaceId ||
683       interfaceId == type(IERC721Metadata).interfaceId ||
684       super.supportsInterface(interfaceId);
685   }
686 
687   /**
688    * @dev See {IERC721-balanceOf}.
689    */
690   function balanceOf(address owner)
691     public
692     view
693     virtual
694     override
695     returns (uint256)
696   {
697     require(owner != address(0), 'ERC721: balance query for the zero address');
698     return _balances[owner];
699   }
700 
701   /**
702    * @dev See {IERC721-ownerOf}.
703    */
704   function ownerOf(uint256 tokenId)
705     public
706     view
707     virtual
708     override
709     returns (address)
710   {
711     address owner = _owners[tokenId];
712     require(owner != address(0), 'ERC721: owner query for nonexistent token');
713     return owner;
714   }
715 
716   /**
717    * @dev See {IERC721Metadata-name}.
718    */
719   function name() public view virtual override returns (string memory) {
720     return _name;
721   }
722 
723   /**
724    * @dev See {IERC721Metadata-symbol}.
725    */
726   function symbol() public view virtual override returns (string memory) {
727     return _symbol;
728   }
729 
730   /**
731    * @dev See {IERC721Metadata-tokenURI}.
732    */
733   function tokenURI(uint256 tokenId)
734     public
735     view
736     virtual
737     override
738     returns (string memory)
739   {
740     require(
741       _exists(tokenId),
742       'ERC721Metadata: URI query for nonexistent token'
743     );
744 
745     string memory baseURI = _baseURI();
746     return
747       bytes(baseURI).length > 0
748         ? string(abi.encodePacked(baseURI, tokenId.toString()))
749         : '';
750   }
751 
752   /**
753    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
754    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
755    * by default, can be overriden in child contracts.
756    */
757   function _baseURI() internal view virtual returns (string memory) {
758     return '';
759   }
760 
761   /**
762    * @dev See {IERC721-approve}.
763    */
764   function approve(address to, uint256 tokenId) public virtual override {
765     address owner = ERC721.ownerOf(tokenId);
766     require(to != owner, 'ERC721: approval to current owner');
767 
768     require(
769       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
770       'ERC721: approve caller is not owner nor approved for all'
771     );
772 
773     _approve(to, tokenId);
774   }
775 
776   /**
777    * @dev See {IERC721-getApproved}.
778    */
779   function getApproved(uint256 tokenId)
780     public
781     view
782     virtual
783     override
784     returns (address)
785   {
786     require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
787 
788     return _tokenApprovals[tokenId];
789   }
790 
791   /**
792    * @dev See {IERC721-setApprovalForAll}.
793    */
794   function setApprovalForAll(address operator, bool approved)
795     public
796     virtual
797     override
798   {
799     require(operator != _msgSender(), 'ERC721: approve to caller');
800 
801     _operatorApprovals[_msgSender()][operator] = approved;
802     emit ApprovalForAll(_msgSender(), operator, approved);
803   }
804 
805   /**
806    * @dev See {IERC721-isApprovedForAll}.
807    */
808   function isApprovedForAll(address owner, address operator)
809     public
810     view
811     virtual
812     override
813     returns (bool)
814   {
815     return _operatorApprovals[owner][operator];
816   }
817 
818   /**
819    * @dev See {IERC721-transferFrom}.
820    */
821   function transferFrom(
822     address from,
823     address to,
824     uint256 tokenId
825   ) public virtual override {
826     //solhint-disable-next-line max-line-length
827     require(
828       _isApprovedOrOwner(_msgSender(), tokenId),
829       'ERC721: transfer caller is not owner nor approved'
830     );
831 
832     _transfer(from, to, tokenId);
833   }
834 
835   /**
836    * @dev See {IERC721-safeTransferFrom}.
837    */
838   function safeTransferFrom(
839     address from,
840     address to,
841     uint256 tokenId
842   ) public virtual override {
843     safeTransferFrom(from, to, tokenId, '');
844   }
845 
846   /**
847    * @dev See {IERC721-safeTransferFrom}.
848    */
849   function safeTransferFrom(
850     address from,
851     address to,
852     uint256 tokenId,
853     bytes memory _data
854   ) public virtual override {
855     require(
856       _isApprovedOrOwner(_msgSender(), tokenId),
857       'ERC721: transfer caller is not owner nor approved'
858     );
859     _safeTransfer(from, to, tokenId, _data);
860   }
861 
862   /**
863    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
864    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
865    *
866    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
867    *
868    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
869    * implement alternative mechanisms to perform token transfer, such as signature-based.
870    *
871    * Requirements:
872    *
873    * - `from` cannot be the zero address.
874    * - `to` cannot be the zero address.
875    * - `tokenId` token must exist and be owned by `from`.
876    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877    *
878    * Emits a {Transfer} event.
879    */
880   function _safeTransfer(
881     address from,
882     address to,
883     uint256 tokenId,
884     bytes memory _data
885   ) internal virtual {
886     _transfer(from, to, tokenId);
887     require(
888       _checkOnERC721Received(from, to, tokenId, _data),
889       'ERC721: transfer to non ERC721Receiver implementer'
890     );
891   }
892 
893   /**
894    * @dev Returns whether `tokenId` exists.
895    *
896    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
897    *
898    * Tokens start existing when they are minted (`_mint`),
899    * and stop existing when they are burned (`_burn`).
900    */
901   function _exists(uint256 tokenId) internal view virtual returns (bool) {
902     return _owners[tokenId] != address(0);
903   }
904 
905   /**
906    * @dev Returns whether `spender` is allowed to manage `tokenId`.
907    *
908    * Requirements:
909    *
910    * - `tokenId` must exist.
911    */
912   function _isApprovedOrOwner(address spender, uint256 tokenId)
913     internal
914     view
915     virtual
916     returns (bool)
917   {
918     require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
919     address owner = ERC721.ownerOf(tokenId);
920     return (spender == owner ||
921       getApproved(tokenId) == spender ||
922       isApprovedForAll(owner, spender));
923   }
924 
925   /**
926    * @dev Safely mints `tokenId` and transfers it to `to`.
927    *
928    * Requirements:
929    *
930    * - `tokenId` must not exist.
931    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932    *
933    * Emits a {Transfer} event.
934    */
935   function _safeMint(address to, uint256 tokenId) internal virtual {
936     _safeMint(to, tokenId, '');
937   }
938 
939   /**
940    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
941    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
942    */
943   function _safeMint(
944     address to,
945     uint256 tokenId,
946     bytes memory _data
947   ) internal virtual {
948     _mint(to, tokenId);
949     require(
950       _checkOnERC721Received(address(0), to, tokenId, _data),
951       'ERC721: transfer to non ERC721Receiver implementer'
952     );
953   }
954 
955   /**
956    * @dev Mints `tokenId` and transfers it to `to`.
957    *
958    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
959    *
960    * Requirements:
961    *
962    * - `tokenId` must not exist.
963    * - `to` cannot be the zero address.
964    *
965    * Emits a {Transfer} event.
966    */
967   function _mint(address to, uint256 tokenId) internal virtual {
968     require(to != address(0), 'ERC721: mint to the zero address');
969     require(!_exists(tokenId), 'ERC721: token already minted');
970 
971     _beforeTokenTransfer(address(0), to, tokenId);
972 
973     _balances[to] += 1;
974     _owners[tokenId] = to;
975 
976     emit Transfer(address(0), to, tokenId);
977   }
978 
979   /**
980    * @dev Destroys `tokenId`.
981    * The approval is cleared when the token is burned.
982    *
983    * Requirements:
984    *
985    * - `tokenId` must exist.
986    *
987    * Emits a {Transfer} event.
988    */
989   function _burn(uint256 tokenId) internal virtual {
990     address owner = ERC721.ownerOf(tokenId);
991 
992     _beforeTokenTransfer(owner, address(0), tokenId);
993 
994     // Clear approvals
995     _approve(address(0), tokenId);
996 
997     _balances[owner] -= 1;
998     delete _owners[tokenId];
999 
1000     emit Transfer(owner, address(0), tokenId);
1001   }
1002 
1003   /**
1004    * @dev Transfers `tokenId` from `from` to `to`.
1005    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1006    *
1007    * Requirements:
1008    *
1009    * - `to` cannot be the zero address.
1010    * - `tokenId` token must be owned by `from`.
1011    *
1012    * Emits a {Transfer} event.
1013    */
1014   function _transfer(
1015     address from,
1016     address to,
1017     uint256 tokenId
1018   ) internal virtual {
1019     require(
1020       ERC721.ownerOf(tokenId) == from,
1021       'ERC721: transfer of token that is not own'
1022     );
1023     require(to != address(0), 'ERC721: transfer to the zero address');
1024 
1025     _beforeTokenTransfer(from, to, tokenId);
1026 
1027     // Clear approvals from the previous owner
1028     _approve(address(0), tokenId);
1029 
1030     _balances[from] -= 1;
1031     _balances[to] += 1;
1032     _owners[tokenId] = to;
1033 
1034     emit Transfer(from, to, tokenId);
1035   }
1036 
1037   /**
1038    * @dev Approve `to` to operate on `tokenId`
1039    *
1040    * Emits a {Approval} event.
1041    */
1042   function _approve(address to, uint256 tokenId) internal virtual {
1043     _tokenApprovals[tokenId] = to;
1044     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1045   }
1046 
1047   /**
1048    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1049    * The call is not executed if the target address is not a contract.
1050    *
1051    * @param from address representing the previous owner of the given token ID
1052    * @param to target address that will receive the tokens
1053    * @param tokenId uint256 ID of the token to be transferred
1054    * @param _data bytes optional data to send along with the call
1055    * @return bool whether the call correctly returned the expected magic value
1056    */
1057   function _checkOnERC721Received(
1058     address from,
1059     address to,
1060     uint256 tokenId,
1061     bytes memory _data
1062   ) private returns (bool) {
1063     if (to.isContract()) {
1064       try
1065         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1066       returns (bytes4 retval) {
1067         return retval == IERC721Receiver(to).onERC721Received.selector;
1068       } catch (bytes memory reason) {
1069         if (reason.length == 0) {
1070           revert('ERC721: transfer to non ERC721Receiver implementer');
1071         } else {
1072           assembly {
1073             revert(add(32, reason), mload(reason))
1074           }
1075         }
1076       }
1077     } else {
1078       return true;
1079     }
1080   }
1081 
1082   /**
1083    * @dev Hook that is called before any token transfer. This includes minting
1084    * and burning.
1085    *
1086    * Calling conditions:
1087    *
1088    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089    * transferred to `to`.
1090    * - When `from` is zero, `tokenId` will be minted for `to`.
1091    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1092    * - `from` and `to` are never both zero.
1093    *
1094    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1095    */
1096   function _beforeTokenTransfer(
1097     address from,
1098     address to,
1099     uint256 tokenId
1100   ) internal virtual {}
1101 }
1102 
1103 // File: ../token/extensions/IERC721Enumerable.sol
1104 
1105 
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115   /**
1116    * @dev Returns the total amount of tokens stored by the contract.
1117    */
1118   function totalSupply() external view returns (uint256);
1119 
1120   /**
1121    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1122    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1123    */
1124   function tokenOfOwnerByIndex(address owner, uint256 index)
1125     external
1126     view
1127     returns (uint256 tokenId);
1128 
1129   /**
1130    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1131    * Use along with {totalSupply} to enumerate all tokens.
1132    */
1133   function tokenByIndex(uint256 index) external view returns (uint256);
1134 }
1135 
1136 // File: ../token/extensions/ERC721Enumerable.sol
1137 
1138 
1139 
1140 pragma solidity ^0.8.0;
1141 
1142 
1143 
1144 /**
1145  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1146  * enumerability of all the token ids in the contract as well as all token ids owned by each
1147  * account.
1148  */
1149 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1150   // Mapping from owner to list of owned token IDs
1151   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1152 
1153   // Mapping from token ID to index of the owner tokens list
1154   mapping(uint256 => uint256) private _ownedTokensIndex;
1155 
1156   // Array with all token ids, used for enumeration
1157   uint256[] private _allTokens;
1158 
1159   // Mapping from token id to position in the allTokens array
1160   mapping(uint256 => uint256) private _allTokensIndex;
1161 
1162   /**
1163    * @dev See {IERC165-supportsInterface}.
1164    */
1165   function supportsInterface(bytes4 interfaceId)
1166     public
1167     view
1168     virtual
1169     override(IERC165, ERC721)
1170     returns (bool)
1171   {
1172     return
1173       interfaceId == type(IERC721Enumerable).interfaceId ||
1174       super.supportsInterface(interfaceId);
1175   }
1176 
1177   /**
1178    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1179    */
1180   function tokenOfOwnerByIndex(address owner, uint256 index)
1181     public
1182     view
1183     virtual
1184     override
1185     returns (uint256)
1186   {
1187     require(
1188       index < ERC721.balanceOf(owner),
1189       'ERC721Enumerable: owner index out of bounds'
1190     );
1191     return _ownedTokens[owner][index];
1192   }
1193 
1194   /**
1195    * @dev See {IERC721Enumerable-totalSupply}.
1196    */
1197   function totalSupply() public view virtual override returns (uint256) {
1198     return _allTokens.length;
1199   }
1200 
1201   /**
1202    * @dev See {IERC721Enumerable-tokenByIndex}.
1203    */
1204   function tokenByIndex(uint256 index)
1205     public
1206     view
1207     virtual
1208     override
1209     returns (uint256)
1210   {
1211     require(
1212       index < ERC721Enumerable.totalSupply(),
1213       'ERC721Enumerable: global index out of bounds'
1214     );
1215     return _allTokens[index];
1216   }
1217 
1218   /**
1219    * @dev Hook that is called before any token transfer. This includes minting
1220    * and burning.
1221    *
1222    * Calling conditions:
1223    *
1224    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225    * transferred to `to`.
1226    * - When `from` is zero, `tokenId` will be minted for `to`.
1227    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1228    * - `from` cannot be the zero address.
1229    * - `to` cannot be the zero address.
1230    *
1231    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1232    */
1233   function _beforeTokenTransfer(
1234     address from,
1235     address to,
1236     uint256 tokenId
1237   ) internal virtual override {
1238     super._beforeTokenTransfer(from, to, tokenId);
1239 
1240     if (from == address(0)) {
1241       _addTokenToAllTokensEnumeration(tokenId);
1242     } else if (from != to) {
1243       _removeTokenFromOwnerEnumeration(from, tokenId);
1244     }
1245     if (to == address(0)) {
1246       _removeTokenFromAllTokensEnumeration(tokenId);
1247     } else if (to != from) {
1248       _addTokenToOwnerEnumeration(to, tokenId);
1249     }
1250   }
1251 
1252   /**
1253    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1254    * @param to address representing the new owner of the given token ID
1255    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1256    */
1257   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1258     uint256 length = ERC721.balanceOf(to);
1259     _ownedTokens[to][length] = tokenId;
1260     _ownedTokensIndex[tokenId] = length;
1261   }
1262 
1263   /**
1264    * @dev Private function to add a token to this extension's token tracking data structures.
1265    * @param tokenId uint256 ID of the token to be added to the tokens list
1266    */
1267   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1268     _allTokensIndex[tokenId] = _allTokens.length;
1269     _allTokens.push(tokenId);
1270   }
1271 
1272   /**
1273    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1274    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1275    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1276    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1277    * @param from address representing the previous owner of the given token ID
1278    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1279    */
1280   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1281     private
1282   {
1283     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1284     // then delete the last slot (swap and pop).
1285 
1286     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1287     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1288 
1289     // When the token to delete is the last token, the swap operation is unnecessary
1290     if (tokenIndex != lastTokenIndex) {
1291       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1292 
1293       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1294       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1295     }
1296 
1297     // This also deletes the contents at the last position of the array
1298     delete _ownedTokensIndex[tokenId];
1299     delete _ownedTokens[from][lastTokenIndex];
1300   }
1301 
1302   /**
1303    * @dev Private function to remove a token from this extension's token tracking data structures.
1304    * This has O(1) time complexity, but alters the order of the _allTokens array.
1305    * @param tokenId uint256 ID of the token to be removed from the tokens list
1306    */
1307   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1308     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1309     // then delete the last slot (swap and pop).
1310 
1311     uint256 lastTokenIndex = _allTokens.length - 1;
1312     uint256 tokenIndex = _allTokensIndex[tokenId];
1313 
1314     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1315     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1316     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1317     uint256 lastTokenId = _allTokens[lastTokenIndex];
1318 
1319     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1320     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1321 
1322     // This also deletes the contents at the last position of the array
1323     delete _allTokensIndex[tokenId];
1324     _allTokens.pop();
1325   }
1326 }
1327 
1328 // File: ../Ownable.sol
1329 
1330 
1331 
1332 pragma solidity ^0.8.0;
1333 
1334 
1335 /**
1336  * @dev Contract module which provides a basic access control mechanism, where
1337  * there is an account (an owner) that can be granted exclusive access to
1338  * specific functions.
1339  *
1340  * By default, the owner account will be the one that deploys the contract. This
1341  * can later be changed with {transferOwnership}.
1342  *
1343  * This module is used through inheritance. It will make available the modifier
1344  * `onlyOwner`, which can be applied to your functions to restrict their use to
1345  * the owner.
1346  */
1347 abstract contract Ownable is Context {
1348   address private _owner;
1349 
1350   event OwnershipTransferred(
1351     address indexed previousOwner,
1352     address indexed newOwner
1353   );
1354 
1355   /**
1356    * @dev Initializes the contract setting the deployer as the initial owner.
1357    */
1358   constructor() {
1359     _setOwner(_msgSender());
1360   }
1361 
1362   /**
1363    * @dev Returns the address of the current owner.
1364    */
1365   function owner() public view virtual returns (address) {
1366     return _owner;
1367   }
1368 
1369   /**
1370    * @dev Throws if called by any account other than the owner.
1371    */
1372   modifier onlyOwner() {
1373     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1374     _;
1375   }
1376 
1377   /**
1378    * @dev Leaves the contract without owner. It will not be possible to call
1379    * `onlyOwner` functions anymore. Can only be called by the current owner.
1380    *
1381    * NOTE: Renouncing ownership will leave the contract without an owner,
1382    * thereby removing any functionality that is only available to the owner.
1383    */
1384   function renounceOwnership() public virtual onlyOwner {
1385     _setOwner(address(0));
1386   }
1387 
1388   /**
1389    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1390    * Can only be called by the current owner.
1391    */
1392   function transferOwnership(address newOwner) public virtual onlyOwner {
1393     require(newOwner != address(0), 'Ownable: new owner is the zero address');
1394     _setOwner(newOwner);
1395   }
1396 
1397   function _setOwner(address newOwner) private {
1398     address oldOwner = _owner;
1399     _owner = newOwner;
1400     emit OwnershipTransferred(oldOwner, newOwner);
1401   }
1402 }
1403 
1404 // File: contracts/interfaces/ITwentyFiveFF.sol
1405 
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 interface ITwentyFiveFF {
1410   function addToAllowList(address[] calldata addresses) external;
1411 
1412   function onAllowList(address addr) external returns (bool);
1413 
1414   function removeFromAllowList(address[] calldata addresses) external;
1415 
1416   function allowListClaimedBy(address owner) external returns (uint256);
1417 
1418   function purchase(uint256 numberOfTokens) external payable;
1419 
1420   function purchaseWhitelist(uint256 numberOfTokens) external payable;
1421 
1422   function gift(address[] calldata to) external;
1423 
1424   function setIsActive(bool isActive) external;
1425 
1426   function setIsAllowListActive(bool isAllowListActive) external;
1427 
1428   function setAllowListMaxMint(uint256 maxMint) external;
1429 
1430   function setProof(string memory proofString) external;
1431 
1432   function withdraw() external;
1433 }
1434 
1435 // File: contracts/interfaces/ITwentyFiveFFMetadata.sol
1436 
1437 
1438 pragma solidity ^0.8.0;
1439 
1440 interface ITwentyFiveFFMetadata {
1441   function setContractURI(string calldata URI) external;
1442 
1443   function setBaseURI(string calldata URI) external;
1444 
1445   function setRevealedBaseURI(string calldata revealedBaseURI) external;
1446 
1447   function contractURI() external view returns (string memory);
1448 }
1449 
1450 // File: ../TwentyFiveFF.sol
1451 
1452 
1453 pragma solidity ^0.8.0;
1454 
1455 
1456 
1457 
1458 
1459 
1460 contract TwentyFiveFF is ERC721Enumerable, Ownable, ITwentyFiveFF, ITwentyFiveFFMetadata {
1461   using Strings for uint256;
1462 
1463   uint256 public constant PURCHASE_LIMIT = 12;
1464   uint256 public constant PRICE = 0.075 ether;
1465   uint256 public constant TwentyFiveFF_GIFT = 99;
1466   uint256 public constant TwentyFiveFF_PUBLIC = 9900;
1467   uint256 public constant TwentyFiveFF_MAX = TwentyFiveFF_GIFT + TwentyFiveFF_PUBLIC;
1468 
1469   bool public isActive = false;
1470   bool public isAllowListActive = false;
1471   string public proof;
1472 
1473   uint256 public allowListMaxMint = 3;
1474 
1475   /// @dev We will use these to be able to calculate remaining correctly.
1476   uint256 public totalGiftSupply;
1477   uint256 public totalPublicSupply;
1478 
1479   mapping(address => bool) private _allowList;
1480   mapping(address => uint256) private _allowListClaimed;
1481 
1482   string private _contractURI = '';
1483   string private _tokenBaseURI = '';
1484   string private _tokenRevealedBaseURI = '';
1485 
1486   constructor(string memory name, string memory symbol) ERC721(name, symbol) {}
1487 
1488   function addToAllowList(address[] calldata addresses)
1489     external
1490     override
1491     onlyOwner
1492   {
1493     for (uint256 i = 0; i < addresses.length; i++) {
1494       require(addresses[i] != address(0), "Can't add zero address");
1495 
1496       _allowList[addresses[i]] = true;
1497       /**
1498        * @dev We don't want to reset _allowListClaimed count
1499        * if we try to add someone more than once.
1500        */
1501       _allowListClaimed[addresses[i]] > 0 ? _allowListClaimed[addresses[i]] : 0;
1502     }
1503   }
1504 
1505   function onAllowList(address addr) external view override returns (bool) {
1506     return _allowList[addr];
1507   }
1508 
1509   function removeFromAllowList(address[] calldata addresses)
1510     external
1511     override
1512     onlyOwner
1513   {
1514     for (uint256 i = 0; i < addresses.length; i++) {
1515       require(addresses[i] != address(0), "Can't add zero address");
1516 
1517       /// @dev We don't want to reset possible _allowListClaimed numbers.
1518       _allowList[addresses[i]] = false;
1519     }
1520   }
1521 
1522   /**
1523    * @dev We want to be able to distinguish tokens bought during isAllowListActive
1524    * and tokens bought outside of isAllowListActive
1525    */
1526   function allowListClaimedBy(address owner)
1527     external
1528     view
1529     override
1530     returns (uint256)
1531   {
1532     require(owner != address(0), 'Zero address not on Allow List');
1533 
1534     return _allowListClaimed[owner];
1535   }
1536 
1537   function purchase(uint256 numberOfTokens) external payable override {
1538     require(isActive, 'Contract is not active');
1539     require(!isAllowListActive, 'Only allowing from Allow List');
1540     require(totalSupply() < TwentyFiveFF_MAX, 'All tokens have been minted');
1541     require(numberOfTokens <= PURCHASE_LIMIT, 'Would exceed PURCHASE_LIMIT');
1542     /**
1543      * @dev The last person to purchase might pay too much.
1544      * This way however they can't get sniped.
1545      * If this happens, we'll refund the Eth for the unavailable tokens.
1546      */
1547     require(totalPublicSupply < TwentyFiveFF_PUBLIC, 'Purchase would exceed TwentyFiveFF_PUBLIC');
1548     require(
1549       PRICE * numberOfTokens <= msg.value,
1550       'ETH amount insufficient'
1551     );
1552 
1553     for (uint256 i = 0; i < numberOfTokens; i++) {
1554       /**
1555        * @dev Since they can get here while exceeding the TwentyFiveFF_MAX,
1556        * we have to make sure to not mint any additional tokens.
1557        */
1558       if (totalPublicSupply < TwentyFiveFF_PUBLIC) {
1559         /**
1560          * @dev Public token numbering starts after TwentyFiveFF_GIFT.
1561          * And we don't want our tokens to start at 0 but at 1.
1562          */
1563         uint256 tokenId = TwentyFiveFF_GIFT + totalPublicSupply + 1;
1564 
1565         totalPublicSupply += 1;
1566         _safeMint(msg.sender, tokenId);
1567       }
1568     }
1569   }
1570 
1571   function purchaseWhitelist(uint256 numberOfTokens) external payable override {
1572     require(isActive, 'Contract is not active');
1573     require(isAllowListActive, 'Whitelist minting is not active');
1574     require(_allowList[msg.sender], 'You are not on the whitelist');
1575     require(totalSupply() < TwentyFiveFF_MAX, 'All tokens have been minted');
1576     require(
1577       numberOfTokens <= allowListMaxMint,
1578       'Cannot purchase this many tokens'
1579     );
1580     require(
1581       totalPublicSupply + numberOfTokens <= TwentyFiveFF_PUBLIC,
1582       'Purchase would exceed TwentyFiveFF_PUBLIC'
1583     );
1584     require(
1585       _allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint,
1586       'Purchase exceeds max allowed'
1587     );
1588     require(
1589       PRICE * numberOfTokens <= msg.value,
1590       'ETH amount insufficient'
1591     );
1592 
1593     for (uint256 i = 0; i < numberOfTokens; i++) {
1594       /**
1595        * @dev Public token numbering starts after TwentyFiveFF_GIFT.
1596        * We don't want our tokens to start at 0 but at 1.
1597        */
1598       uint256 tokenId = TwentyFiveFF_GIFT + totalPublicSupply + 1;
1599 
1600       totalPublicSupply += 1;
1601       _allowListClaimed[msg.sender] += 1;
1602       _safeMint(msg.sender, tokenId);
1603     }
1604   }
1605 
1606   function gift(address[] calldata to) external override onlyOwner {
1607     require(totalSupply() < TwentyFiveFF_MAX, 'All tokens have been minted');
1608     require(
1609       totalGiftSupply + to.length <= TwentyFiveFF_GIFT,
1610       'Not enough tokens left to gift'
1611     );
1612 
1613     for (uint256 i = 0; i < to.length; i++) {
1614       /// @dev We don't want our tokens to start at 0 but at 1.
1615       uint256 tokenId = totalGiftSupply + 1;
1616 
1617       totalGiftSupply += 1;
1618       _safeMint(to[i], tokenId);
1619     }
1620   }
1621 
1622   function setIsActive(bool _isActive) external override onlyOwner {
1623     isActive = _isActive;
1624   }
1625 
1626   function setIsAllowListActive(bool _isAllowListActive)
1627     external
1628     override
1629     onlyOwner
1630   {
1631     isAllowListActive = _isAllowListActive;
1632   }
1633 
1634   function setAllowListMaxMint(uint256 maxMint) external override onlyOwner {
1635     allowListMaxMint = maxMint;
1636   }
1637 
1638   function setProof(string calldata proofString) external override onlyOwner {
1639     proof = proofString;
1640   }
1641 
1642   function withdraw() external override onlyOwner {
1643     uint256 balance = address(this).balance;
1644 
1645     payable(msg.sender).transfer(balance);
1646   }
1647 
1648   function setContractURI(string calldata URI) external override onlyOwner {
1649     _contractURI = URI;
1650   }
1651 
1652   function setBaseURI(string calldata URI) external override onlyOwner {
1653     _tokenBaseURI = URI;
1654   }
1655 
1656   function setRevealedBaseURI(string calldata revealedBaseURI)
1657     external
1658     override
1659     onlyOwner
1660   {
1661     _tokenRevealedBaseURI = revealedBaseURI;
1662   }
1663 
1664   function contractURI() public view override returns (string memory) {
1665     return _contractURI;
1666   }
1667 
1668   function tokenURI(uint256 tokenId)
1669     public
1670     view
1671     override(ERC721)
1672     returns (string memory)
1673   {
1674     require(_exists(tokenId), 'Token does not exist');
1675 
1676     /// @dev Convert string to bytes so we can check if it's empty or not.
1677     string memory revealedBaseURI = _tokenRevealedBaseURI;
1678     return
1679       bytes(revealedBaseURI).length > 0
1680         ? string(abi.encodePacked(revealedBaseURI, tokenId.toString()))
1681         : _tokenBaseURI;
1682   }
1683 }