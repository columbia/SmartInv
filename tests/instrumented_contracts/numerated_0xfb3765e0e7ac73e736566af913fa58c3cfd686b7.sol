1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15   /**
16    * @dev Returns true if this contract implements the interface defined by
17    * `interfaceId`. See the corresponding
18    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19    * to learn more about how these ids are created.
20    *
21    * This function call must use less than 30 000 gas.
22    */
23   function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34   /**
35    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36    */
37   event Transfer(
38     address indexed from,
39     address indexed to,
40     uint256 indexed tokenId
41   );
42 
43   /**
44    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45    */
46   event Approval(
47     address indexed owner,
48     address indexed approved,
49     uint256 indexed tokenId
50   );
51 
52   /**
53    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54    */
55   event ApprovalForAll(
56     address indexed owner,
57     address indexed operator,
58     bool approved
59   );
60 
61   /**
62    * @dev Returns the number of tokens in ``owner``'s account.
63    */
64   function balanceOf(address owner) external view returns (uint256 balance);
65 
66   /**
67    * @dev Returns the owner of the `tokenId` token.
68    *
69    * Requirements:
70    *
71    * - `tokenId` must exist.
72    */
73   function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75   /**
76    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78    *
79    * Requirements:
80    *
81    * - `from` cannot be the zero address.
82    * - `to` cannot be the zero address.
83    * - `tokenId` token must exist and be owned by `from`.
84    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86    *
87    * Emits a {Transfer} event.
88    */
89   function safeTransferFrom(
90     address from,
91     address to,
92     uint256 tokenId
93   ) external;
94 
95   /**
96    * @dev Transfers `tokenId` token from `from` to `to`.
97    *
98    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99    *
100    * Requirements:
101    *
102    * - `from` cannot be the zero address.
103    * - `to` cannot be the zero address.
104    * - `tokenId` token must be owned by `from`.
105    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106    *
107    * Emits a {Transfer} event.
108    */
109   function transferFrom(
110     address from,
111     address to,
112     uint256 tokenId
113   ) external;
114 
115   /**
116    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117    * The approval is cleared when the token is transferred.
118    *
119    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120    *
121    * Requirements:
122    *
123    * - The caller must own the token or be an approved operator.
124    * - `tokenId` must exist.
125    *
126    * Emits an {Approval} event.
127    */
128   function approve(address to, uint256 tokenId) external;
129 
130   /**
131    * @dev Returns the account approved for `tokenId` token.
132    *
133    * Requirements:
134    *
135    * - `tokenId` must exist.
136    */
137   function getApproved(uint256 tokenId)
138     external
139     view
140     returns (address operator);
141 
142   /**
143    * @dev Approve or remove `operator` as an operator for the caller.
144    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145    *
146    * Requirements:
147    *
148    * - The `operator` cannot be the caller.
149    *
150    * Emits an {ApprovalForAll} event.
151    */
152   function setApprovalForAll(address operator, bool _approved) external;
153 
154   /**
155    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156    *
157    * See {setApprovalForAll}
158    */
159   function isApprovedForAll(address owner, address operator)
160     external
161     view
162     returns (bool);
163 
164   /**
165    * @dev Safely transfers `tokenId` token from `from` to `to`.
166    *
167    * Requirements:
168    *
169    * - `from` cannot be the zero address.
170    * - `to` cannot be the zero address.
171    * - `tokenId` token must exist and be owned by `from`.
172    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174    *
175    * Emits a {Transfer} event.
176    */
177   function safeTransferFrom(
178     address from,
179     address to,
180     uint256 tokenId,
181     bytes calldata data
182   ) external;
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @title ERC721 token receiver interface
191  * @dev Interface for any contract that wants to support safeTransfers
192  * from ERC721 asset contracts.
193  */
194 interface IERC721Receiver {
195   /**
196    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197    * by `operator` from `from`, this function is called.
198    *
199    * It must return its Solidity selector to confirm the token transfer.
200    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201    *
202    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203    */
204   function onERC721Received(
205     address operator,
206     address from,
207     uint256 tokenId,
208     bytes calldata data
209   ) external returns (bytes4);
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221   /**
222    * @dev Returns the token collection name.
223    */
224   function name() external view returns (string memory);
225 
226   /**
227    * @dev Returns the token collection symbol.
228    */
229   function symbol() external view returns (string memory);
230 
231   /**
232    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233    */
234   function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245   /**
246    * @dev Returns true if `account` is a contract.
247    *
248    * [IMPORTANT]
249    * ====
250    * It is unsafe to assume that an address for which this function returns
251    * false is an externally-owned account (EOA) and not a contract.
252    *
253    * Among others, `isContract` will return false for the following
254    * types of addresses:
255    *
256    *  - an externally-owned account
257    *  - a contract in construction
258    *  - an address where a contract will be created
259    *  - an address where a contract lived, but was destroyed
260    * ====
261    */
262   function isContract(address account) internal view returns (bool) {
263     // This method relies on extcodesize, which returns 0 for contracts in
264     // construction, since the code is only stored at the end of the
265     // constructor execution.
266 
267     uint256 size;
268     assembly {
269       size := extcodesize(account)
270     }
271     return size > 0;
272   }
273 
274   /**
275    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276    * `recipient`, forwarding all available gas and reverting on errors.
277    *
278    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279    * of certain opcodes, possibly making contracts go over the 2300 gas limit
280    * imposed by `transfer`, making them unable to receive funds via
281    * `transfer`. {sendValue} removes this limitation.
282    *
283    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284    *
285    * IMPORTANT: because control is transferred to `recipient`, care must be
286    * taken to not create reentrancy vulnerabilities. Consider using
287    * {ReentrancyGuard} or the
288    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289    */
290   function sendValue(address payable recipient, uint256 amount) internal {
291     require(address(this).balance >= amount, "Address: insufficient balance");
292 
293     (bool success, ) = recipient.call{ value: amount }("");
294     require(
295       success,
296       "Address: unable to send value, recipient may have reverted"
297     );
298   }
299 
300   /**
301    * @dev Performs a Solidity function call using a low level `call`. A
302    * plain `call` is an unsafe replacement for a function call: use this
303    * function instead.
304    *
305    * If `target` reverts with a revert reason, it is bubbled up by this
306    * function (like regular Solidity function calls).
307    *
308    * Returns the raw returned data. To convert to the expected return value,
309    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310    *
311    * Requirements:
312    *
313    * - `target` must be a contract.
314    * - calling `target` with `data` must not revert.
315    *
316    * _Available since v3.1._
317    */
318   function functionCall(address target, bytes memory data)
319     internal
320     returns (bytes memory)
321   {
322     return functionCall(target, data, "Address: low-level call failed");
323   }
324 
325   /**
326    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327    * `errorMessage` as a fallback revert reason when `target` reverts.
328    *
329    * _Available since v3.1._
330    */
331   function functionCall(
332     address target,
333     bytes memory data,
334     string memory errorMessage
335   ) internal returns (bytes memory) {
336     return functionCallWithValue(target, data, 0, errorMessage);
337   }
338 
339   /**
340    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341    * but also transferring `value` wei to `target`.
342    *
343    * Requirements:
344    *
345    * - the calling contract must have an ETH balance of at least `value`.
346    * - the called Solidity function must be `payable`.
347    *
348    * _Available since v3.1._
349    */
350   function functionCallWithValue(
351     address target,
352     bytes memory data,
353     uint256 value
354   ) internal returns (bytes memory) {
355     return
356       functionCallWithValue(
357         target,
358         data,
359         value,
360         "Address: low-level call with value failed"
361       );
362   }
363 
364   /**
365    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366    * with `errorMessage` as a fallback revert reason when `target` reverts.
367    *
368    * _Available since v3.1._
369    */
370   function functionCallWithValue(
371     address target,
372     bytes memory data,
373     uint256 value,
374     string memory errorMessage
375   ) internal returns (bytes memory) {
376     require(
377       address(this).balance >= value,
378       "Address: insufficient balance for call"
379     );
380     require(isContract(target), "Address: call to non-contract");
381 
382     (bool success, bytes memory returndata) = target.call{ value: value }(data);
383     return _verifyCallResult(success, returndata, errorMessage);
384   }
385 
386   /**
387    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388    * but performing a static call.
389    *
390    * _Available since v3.3._
391    */
392   function functionStaticCall(address target, bytes memory data)
393     internal
394     view
395     returns (bytes memory)
396   {
397     return
398       functionStaticCall(target, data, "Address: low-level static call failed");
399   }
400 
401   /**
402    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403    * but performing a static call.
404    *
405    * _Available since v3.3._
406    */
407   function functionStaticCall(
408     address target,
409     bytes memory data,
410     string memory errorMessage
411   ) internal view returns (bytes memory) {
412     require(isContract(target), "Address: static call to non-contract");
413 
414     (bool success, bytes memory returndata) = target.staticcall(data);
415     return _verifyCallResult(success, returndata, errorMessage);
416   }
417 
418   /**
419    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420    * but performing a delegate call.
421    *
422    * _Available since v3.4._
423    */
424   function functionDelegateCall(address target, bytes memory data)
425     internal
426     returns (bytes memory)
427   {
428     return
429       functionDelegateCall(
430         target,
431         data,
432         "Address: low-level delegate call failed"
433       );
434   }
435 
436   /**
437    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438    * but performing a delegate call.
439    *
440    * _Available since v3.4._
441    */
442   function functionDelegateCall(
443     address target,
444     bytes memory data,
445     string memory errorMessage
446   ) internal returns (bytes memory) {
447     require(isContract(target), "Address: delegate call to non-contract");
448 
449     (bool success, bytes memory returndata) = target.delegatecall(data);
450     return _verifyCallResult(success, returndata, errorMessage);
451   }
452 
453   function _verifyCallResult(
454     bool success,
455     bytes memory returndata,
456     string memory errorMessage
457   ) private pure returns (bytes memory) {
458     if (success) {
459       return returndata;
460     } else {
461       // Look for revert reason and bubble it up if present
462       if (returndata.length > 0) {
463         // The easiest way to bubble the revert reason is using memory via assembly
464 
465         assembly {
466           let returndata_size := mload(returndata)
467           revert(add(32, returndata), returndata_size)
468         }
469       } else {
470         revert(errorMessage);
471       }
472     }
473   }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Context.sol
477 
478 pragma solidity ^0.8.0;
479 
480 /*
481  * @dev Provides information about the current execution context, including the
482  * sender of the transaction and its data. While these are generally available
483  * via msg.sender and msg.data, they should not be accessed in such a direct
484  * manner, since when dealing with meta-transactions the account sending and
485  * paying for execution may not be the actual sender (as far as an application
486  * is concerned).
487  *
488  * This contract is only required for intermediate, library-like contracts.
489  */
490 abstract contract Context {
491   function _msgSender() internal view virtual returns (address) {
492     return msg.sender;
493   }
494 
495   function _msgData() internal view virtual returns (bytes calldata) {
496     return msg.data;
497   }
498 }
499 
500 // File: @openzeppelin/contracts/utils/Strings.sol
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev String operations.
506  */
507 library Strings {
508   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
509 
510   /**
511    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
512    */
513   function toString(uint256 value) internal pure returns (string memory) {
514     // Inspired by OraclizeAPI's implementation - MIT licence
515     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
516 
517     if (value == 0) {
518       return "0";
519     }
520     uint256 temp = value;
521     uint256 digits;
522     while (temp != 0) {
523       digits++;
524       temp /= 10;
525     }
526     bytes memory buffer = new bytes(digits);
527     while (value != 0) {
528       digits -= 1;
529       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
530       value /= 10;
531     }
532     return string(buffer);
533   }
534 
535   /**
536    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
537    */
538   function toHexString(uint256 value) internal pure returns (string memory) {
539     if (value == 0) {
540       return "0x00";
541     }
542     uint256 temp = value;
543     uint256 length = 0;
544     while (temp != 0) {
545       length++;
546       temp >>= 8;
547     }
548     return toHexString(value, length);
549   }
550 
551   /**
552    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
553    */
554   function toHexString(uint256 value, uint256 length)
555     internal
556     pure
557     returns (string memory)
558   {
559     bytes memory buffer = new bytes(2 * length + 2);
560     buffer[0] = "0";
561     buffer[1] = "x";
562     for (uint256 i = 2 * length + 1; i > 1; --i) {
563       buffer[i] = _HEX_SYMBOLS[value & 0xf];
564       value >>= 4;
565     }
566     require(value == 0, "Strings: hex length insufficient");
567     return string(buffer);
568   }
569 }
570 
571 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
579  * for the additional interface id that will be supported. For example:
580  *
581  * ```solidity
582  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
584  * }
585  * ```
586  *
587  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
588  */
589 abstract contract ERC165 is IERC165 {
590   /**
591    * @dev See {IERC165-supportsInterface}.
592    */
593   function supportsInterface(bytes4 interfaceId)
594     public
595     view
596     virtual
597     override
598     returns (bool)
599   {
600     return interfaceId == type(IERC165).interfaceId;
601   }
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension, but not including the Enumerable extension, which is available separately as
611  * {ERC721Enumerable}.
612  */
613 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
614   using Address for address;
615   using Strings for uint256;
616 
617   // Token name
618   string private _name;
619 
620   // Token symbol
621   string private _symbol;
622 
623   // Mapping from token ID to owner address
624   mapping(uint256 => address) private _owners;
625 
626   // Mapping owner address to token count
627   mapping(address => uint256) private _balances;
628 
629   // Mapping from token ID to approved address
630   mapping(uint256 => address) private _tokenApprovals;
631 
632   // Mapping from owner to operator approvals
633   mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635   /**
636    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
637    */
638   constructor(string memory name_, string memory symbol_) {
639     _name = name_;
640     _symbol = symbol_;
641   }
642 
643   /**
644    * @dev See {IERC165-supportsInterface}.
645    */
646   function supportsInterface(bytes4 interfaceId)
647     public
648     view
649     virtual
650     override(ERC165, IERC165)
651     returns (bool)
652   {
653     return
654       interfaceId == type(IERC721).interfaceId ||
655       interfaceId == type(IERC721Metadata).interfaceId ||
656       super.supportsInterface(interfaceId);
657   }
658 
659   /**
660    * @dev See {IERC721-balanceOf}.
661    */
662   function balanceOf(address owner)
663     public
664     view
665     virtual
666     override
667     returns (uint256)
668   {
669     require(owner != address(0), "ERC721: balance query for the zero address");
670     return _balances[owner];
671   }
672 
673   /**
674    * @dev See {IERC721-ownerOf}.
675    */
676   function ownerOf(uint256 tokenId)
677     public
678     view
679     virtual
680     override
681     returns (address)
682   {
683     address owner = _owners[tokenId];
684     require(owner != address(0), "ERC721: owner query for nonexistent token");
685     return owner;
686   }
687 
688   /**
689    * @dev See {IERC721Metadata-name}.
690    */
691   function name() public view virtual override returns (string memory) {
692     return _name;
693   }
694 
695   /**
696    * @dev See {IERC721Metadata-symbol}.
697    */
698   function symbol() public view virtual override returns (string memory) {
699     return _symbol;
700   }
701 
702   /**
703    * @dev See {IERC721Metadata-tokenURI}.
704    */
705   function tokenURI(uint256 tokenId)
706     public
707     view
708     virtual
709     override
710     returns (string memory)
711   {
712     require(
713       _exists(tokenId),
714       "ERC721Metadata: URI query for nonexistent token"
715     );
716 
717     string memory baseURI = _baseURI();
718     return
719       bytes(baseURI).length > 0
720         ? string(abi.encodePacked(baseURI, tokenId.toString()))
721         : "";
722   }
723 
724   /**
725    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
726    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
727    * by default, can be overriden in child contracts.
728    */
729   function _baseURI() internal view virtual returns (string memory) {
730     return "";
731   }
732 
733   /**
734    * @dev See {IERC721-approve}.
735    */
736   function approve(address to, uint256 tokenId) public virtual override {
737     address owner = ERC721.ownerOf(tokenId);
738     require(to != owner, "ERC721: approval to current owner");
739 
740     require(
741       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
742       "ERC721: approve caller is not owner nor approved for all"
743     );
744 
745     _approve(to, tokenId);
746   }
747 
748   /**
749    * @dev See {IERC721-getApproved}.
750    */
751   function getApproved(uint256 tokenId)
752     public
753     view
754     virtual
755     override
756     returns (address)
757   {
758     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
759 
760     return _tokenApprovals[tokenId];
761   }
762 
763   /**
764    * @dev See {IERC721-setApprovalForAll}.
765    */
766   function setApprovalForAll(address operator, bool approved)
767     public
768     virtual
769     override
770   {
771     require(operator != _msgSender(), "ERC721: approve to caller");
772 
773     _operatorApprovals[_msgSender()][operator] = approved;
774     emit ApprovalForAll(_msgSender(), operator, approved);
775   }
776 
777   /**
778    * @dev See {IERC721-isApprovedForAll}.
779    */
780   function isApprovedForAll(address owner, address operator)
781     public
782     view
783     virtual
784     override
785     returns (bool)
786   {
787     return _operatorApprovals[owner][operator];
788   }
789 
790   /**
791    * @dev See {IERC721-transferFrom}.
792    */
793   function transferFrom(
794     address from,
795     address to,
796     uint256 tokenId
797   ) public virtual override {
798     //solhint-disable-next-line max-line-length
799     require(
800       _isApprovedOrOwner(_msgSender(), tokenId),
801       "ERC721: transfer caller is not owner nor approved"
802     );
803 
804     _transfer(from, to, tokenId);
805   }
806 
807   /**
808    * @dev See {IERC721-safeTransferFrom}.
809    */
810   function safeTransferFrom(
811     address from,
812     address to,
813     uint256 tokenId
814   ) public virtual override {
815     safeTransferFrom(from, to, tokenId, "");
816   }
817 
818   /**
819    * @dev See {IERC721-safeTransferFrom}.
820    */
821   function safeTransferFrom(
822     address from,
823     address to,
824     uint256 tokenId,
825     bytes memory _data
826   ) public virtual override {
827     require(
828       _isApprovedOrOwner(_msgSender(), tokenId),
829       "ERC721: transfer caller is not owner nor approved"
830     );
831     _safeTransfer(from, to, tokenId, _data);
832   }
833 
834   /**
835    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
836    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
837    *
838    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
839    *
840    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
841    * implement alternative mechanisms to perform token transfer, such as signature-based.
842    *
843    * Requirements:
844    *
845    * - `from` cannot be the zero address.
846    * - `to` cannot be the zero address.
847    * - `tokenId` token must exist and be owned by `from`.
848    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849    *
850    * Emits a {Transfer} event.
851    */
852   function _safeTransfer(
853     address from,
854     address to,
855     uint256 tokenId,
856     bytes memory _data
857   ) internal virtual {
858     _transfer(from, to, tokenId);
859     require(
860       _checkOnERC721Received(from, to, tokenId, _data),
861       "ERC721: transfer to non ERC721Receiver implementer"
862     );
863   }
864 
865   /**
866    * @dev Returns whether `tokenId` exists.
867    *
868    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
869    *
870    * Tokens start existing when they are minted (`_mint`),
871    * and stop existing when they are burned (`_burn`).
872    */
873   function _exists(uint256 tokenId) internal view virtual returns (bool) {
874     return _owners[tokenId] != address(0);
875   }
876 
877   /**
878    * @dev Returns whether `spender` is allowed to manage `tokenId`.
879    *
880    * Requirements:
881    *
882    * - `tokenId` must exist.
883    */
884   function _isApprovedOrOwner(address spender, uint256 tokenId)
885     internal
886     view
887     virtual
888     returns (bool)
889   {
890     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
891     address owner = ERC721.ownerOf(tokenId);
892     return (spender == owner ||
893       getApproved(tokenId) == spender ||
894       isApprovedForAll(owner, spender));
895   }
896 
897   /**
898    * @dev Safely mints `tokenId` and transfers it to `to`.
899    *
900    * Requirements:
901    *
902    * - `tokenId` must not exist.
903    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904    *
905    * Emits a {Transfer} event.
906    */
907   function _safeMint(address to, uint256 tokenId) internal virtual {
908     _safeMint(to, tokenId, "");
909   }
910 
911   /**
912    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914    */
915   function _safeMint(
916     address to,
917     uint256 tokenId,
918     bytes memory _data
919   ) internal virtual {
920     _mint(to, tokenId);
921     require(
922       _checkOnERC721Received(address(0), to, tokenId, _data),
923       "ERC721: transfer to non ERC721Receiver implementer"
924     );
925   }
926 
927   /**
928    * @dev Mints `tokenId` and transfers it to `to`.
929    *
930    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931    *
932    * Requirements:
933    *
934    * - `tokenId` must not exist.
935    * - `to` cannot be the zero address.
936    *
937    * Emits a {Transfer} event.
938    */
939   function _mint(address to, uint256 tokenId) internal virtual {
940     require(to != address(0), "ERC721: mint to the zero address");
941     require(!_exists(tokenId), "ERC721: token already minted");
942 
943     _beforeTokenTransfer(address(0), to, tokenId);
944 
945     _balances[to] += 1;
946     _owners[tokenId] = to;
947 
948     emit Transfer(address(0), to, tokenId);
949   }
950 
951   /**
952    * @dev Destroys `tokenId`.
953    * The approval is cleared when the token is burned.
954    *
955    * Requirements:
956    *
957    * - `tokenId` must exist.
958    *
959    * Emits a {Transfer} event.
960    */
961   function _burn(uint256 tokenId) internal virtual {
962     address owner = ERC721.ownerOf(tokenId);
963 
964     _beforeTokenTransfer(owner, address(0), tokenId);
965 
966     // Clear approvals
967     _approve(address(0), tokenId);
968 
969     _balances[owner] -= 1;
970     delete _owners[tokenId];
971 
972     emit Transfer(owner, address(0), tokenId);
973   }
974 
975   /**
976    * @dev Transfers `tokenId` from `from` to `to`.
977    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
978    *
979    * Requirements:
980    *
981    * - `to` cannot be the zero address.
982    * - `tokenId` token must be owned by `from`.
983    *
984    * Emits a {Transfer} event.
985    */
986   function _transfer(
987     address from,
988     address to,
989     uint256 tokenId
990   ) internal virtual {
991     require(
992       ERC721.ownerOf(tokenId) == from,
993       "ERC721: transfer of token that is not own"
994     );
995     require(to != address(0), "ERC721: transfer to the zero address");
996 
997     _beforeTokenTransfer(from, to, tokenId);
998 
999     // Clear approvals from the previous owner
1000     _approve(address(0), tokenId);
1001 
1002     _balances[from] -= 1;
1003     _balances[to] += 1;
1004     _owners[tokenId] = to;
1005 
1006     emit Transfer(from, to, tokenId);
1007   }
1008 
1009   /**
1010    * @dev Approve `to` to operate on `tokenId`
1011    *
1012    * Emits a {Approval} event.
1013    */
1014   function _approve(address to, uint256 tokenId) internal virtual {
1015     _tokenApprovals[tokenId] = to;
1016     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1017   }
1018 
1019   /**
1020    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1021    * The call is not executed if the target address is not a contract.
1022    *
1023    * @param from address representing the previous owner of the given token ID
1024    * @param to target address that will receive the tokens
1025    * @param tokenId uint256 ID of the token to be transferred
1026    * @param _data bytes optional data to send along with the call
1027    * @return bool whether the call correctly returned the expected magic value
1028    */
1029   function _checkOnERC721Received(
1030     address from,
1031     address to,
1032     uint256 tokenId,
1033     bytes memory _data
1034   ) private returns (bool) {
1035     if (to.isContract()) {
1036       try
1037         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1038       returns (bytes4 retval) {
1039         return retval == IERC721Receiver(to).onERC721Received.selector;
1040       } catch (bytes memory reason) {
1041         if (reason.length == 0) {
1042           revert("ERC721: transfer to non ERC721Receiver implementer");
1043         } else {
1044           assembly {
1045             revert(add(32, reason), mload(reason))
1046           }
1047         }
1048       }
1049     } else {
1050       return true;
1051     }
1052   }
1053 
1054   /**
1055    * @dev Hook that is called before any token transfer. This includes minting
1056    * and burning.
1057    *
1058    * Calling conditions:
1059    *
1060    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1061    * transferred to `to`.
1062    * - When `from` is zero, `tokenId` will be minted for `to`.
1063    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1064    * - `from` and `to` are never both zero.
1065    *
1066    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1067    */
1068   function _beforeTokenTransfer(
1069     address from,
1070     address to,
1071     uint256 tokenId
1072   ) internal virtual {}
1073 }
1074 
1075 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1076 
1077 pragma solidity ^0.8.0;
1078 
1079 /**
1080  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1081  * @dev See https://eips.ethereum.org/EIPS/eip-721
1082  */
1083 interface IERC721Enumerable is IERC721 {
1084   /**
1085    * @dev Returns the total amount of tokens stored by the contract.
1086    */
1087   function totalSupply() external view returns (uint256);
1088 
1089   /**
1090    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1091    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1092    */
1093   function tokenOfOwnerByIndex(address owner, uint256 index)
1094     external
1095     view
1096     returns (uint256 tokenId);
1097 
1098   /**
1099    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1100    * Use along with {totalSupply} to enumerate all tokens.
1101    */
1102   function tokenByIndex(uint256 index) external view returns (uint256);
1103 }
1104 
1105 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 /**
1110  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1111  * enumerability of all the token ids in the contract as well as all token ids owned by each
1112  * account.
1113  */
1114 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1115   // Mapping from owner to list of owned token IDs
1116   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1117 
1118   // Mapping from token ID to index of the owner tokens list
1119   mapping(uint256 => uint256) private _ownedTokensIndex;
1120 
1121   // Array with all token ids, used for enumeration
1122   uint256[] private _allTokens;
1123 
1124   // Mapping from token id to position in the allTokens array
1125   mapping(uint256 => uint256) private _allTokensIndex;
1126 
1127   /**
1128    * @dev See {IERC165-supportsInterface}.
1129    */
1130   function supportsInterface(bytes4 interfaceId)
1131     public
1132     view
1133     virtual
1134     override(IERC165, ERC721)
1135     returns (bool)
1136   {
1137     return
1138       interfaceId == type(IERC721Enumerable).interfaceId ||
1139       super.supportsInterface(interfaceId);
1140   }
1141 
1142   /**
1143    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1144    */
1145   function tokenOfOwnerByIndex(address owner, uint256 index)
1146     public
1147     view
1148     virtual
1149     override
1150     returns (uint256)
1151   {
1152     require(
1153       index < ERC721.balanceOf(owner),
1154       "ERC721Enumerable: owner index out of bounds"
1155     );
1156     return _ownedTokens[owner][index];
1157   }
1158 
1159   /**
1160    * @dev See {IERC721Enumerable-totalSupply}.
1161    */
1162   function totalSupply() public view virtual override returns (uint256) {
1163     return _allTokens.length;
1164   }
1165 
1166   /**
1167    * @dev See {IERC721Enumerable-tokenByIndex}.
1168    */
1169   function tokenByIndex(uint256 index)
1170     public
1171     view
1172     virtual
1173     override
1174     returns (uint256)
1175   {
1176     require(
1177       index < ERC721Enumerable.totalSupply(),
1178       "ERC721Enumerable: global index out of bounds"
1179     );
1180     return _allTokens[index];
1181   }
1182 
1183   /**
1184    * @dev Hook that is called before any token transfer. This includes minting
1185    * and burning.
1186    *
1187    * Calling conditions:
1188    *
1189    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1190    * transferred to `to`.
1191    * - When `from` is zero, `tokenId` will be minted for `to`.
1192    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1193    * - `from` cannot be the zero address.
1194    * - `to` cannot be the zero address.
1195    *
1196    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1197    */
1198   function _beforeTokenTransfer(
1199     address from,
1200     address to,
1201     uint256 tokenId
1202   ) internal virtual override {
1203     super._beforeTokenTransfer(from, to, tokenId);
1204 
1205     if (from == address(0)) {
1206       _addTokenToAllTokensEnumeration(tokenId);
1207     } else if (from != to) {
1208       _removeTokenFromOwnerEnumeration(from, tokenId);
1209     }
1210     if (to == address(0)) {
1211       _removeTokenFromAllTokensEnumeration(tokenId);
1212     } else if (to != from) {
1213       _addTokenToOwnerEnumeration(to, tokenId);
1214     }
1215   }
1216 
1217   /**
1218    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1219    * @param to address representing the new owner of the given token ID
1220    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1221    */
1222   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1223     uint256 length = ERC721.balanceOf(to);
1224     _ownedTokens[to][length] = tokenId;
1225     _ownedTokensIndex[tokenId] = length;
1226   }
1227 
1228   /**
1229    * @dev Private function to add a token to this extension's token tracking data structures.
1230    * @param tokenId uint256 ID of the token to be added to the tokens list
1231    */
1232   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1233     _allTokensIndex[tokenId] = _allTokens.length;
1234     _allTokens.push(tokenId);
1235   }
1236 
1237   /**
1238    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1239    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1240    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1241    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1242    * @param from address representing the previous owner of the given token ID
1243    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1244    */
1245   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1246     private
1247   {
1248     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1249     // then delete the last slot (swap and pop).
1250 
1251     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1252     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1253 
1254     // When the token to delete is the last token, the swap operation is unnecessary
1255     if (tokenIndex != lastTokenIndex) {
1256       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1257 
1258       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1259       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1260     }
1261 
1262     // This also deletes the contents at the last position of the array
1263     delete _ownedTokensIndex[tokenId];
1264     delete _ownedTokens[from][lastTokenIndex];
1265   }
1266 
1267   /**
1268    * @dev Private function to remove a token from this extension's token tracking data structures.
1269    * This has O(1) time complexity, but alters the order of the _allTokens array.
1270    * @param tokenId uint256 ID of the token to be removed from the tokens list
1271    */
1272   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1273     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1274     // then delete the last slot (swap and pop).
1275 
1276     uint256 lastTokenIndex = _allTokens.length - 1;
1277     uint256 tokenIndex = _allTokensIndex[tokenId];
1278 
1279     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1280     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1281     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1282     uint256 lastTokenId = _allTokens[lastTokenIndex];
1283 
1284     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1285     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1286 
1287     // This also deletes the contents at the last position of the array
1288     delete _allTokensIndex[tokenId];
1289     _allTokens.pop();
1290   }
1291 }
1292 
1293 // File: @openzeppelin/contracts/access/Ownable.sol
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @dev Contract module which provides a basic access control mechanism, where
1299  * there is an account (an owner) that can be granted exclusive access to
1300  * specific functions.
1301  *
1302  * By default, the owner account will be the one that deploys the contract. This
1303  * can later be changed with {transferOwnership}.
1304  *
1305  * This module is used through inheritance. It will make available the modifier
1306  * `onlyOwner`, which can be applied to your functions to restrict their use to
1307  * the owner.
1308  */
1309 abstract contract Ownable is Context {
1310   address private _owner;
1311 
1312   event OwnershipTransferred(
1313     address indexed previousOwner,
1314     address indexed newOwner
1315   );
1316 
1317   /**
1318    * @dev Initializes the contract setting the deployer as the initial owner.
1319    */
1320   constructor() {
1321     _setOwner(_msgSender());
1322   }
1323 
1324   /**
1325    * @dev Returns the address of the current owner.
1326    */
1327   function owner() public view virtual returns (address) {
1328     return _owner;
1329   }
1330 
1331   /**
1332    * @dev Throws if called by any account other than the owner.
1333    */
1334   modifier onlyOwner() {
1335     require(owner() == _msgSender(), "Ownable: caller is not the owner");
1336     _;
1337   }
1338 
1339   /**
1340    * @dev Leaves the contract without owner. It will not be possible to call
1341    * `onlyOwner` functions anymore. Can only be called by the current owner.
1342    *
1343    * NOTE: Renouncing ownership will leave the contract without an owner,
1344    * thereby removing any functionality that is only available to the owner.
1345    */
1346   function renounceOwnership() public virtual onlyOwner {
1347     _setOwner(address(0));
1348   }
1349 
1350   /**
1351    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1352    * Can only be called by the current owner.
1353    */
1354   function transferOwnership(address newOwner) public virtual onlyOwner {
1355     require(newOwner != address(0), "Ownable: new owner is the zero address");
1356     _setOwner(newOwner);
1357   }
1358 
1359   function _setOwner(address newOwner) private {
1360     address oldOwner = _owner;
1361     _owner = newOwner;
1362     emit OwnershipTransferred(oldOwner, newOwner);
1363   }
1364 }
1365 
1366 // File: contracts/Audioglyphs.sol
1367 
1368 pragma solidity >=0.4.22 <0.9.0;
1369 
1370 /**
1371                    ___             __            __        
1372   ____ ___  ______/ (_)___  ____ _/ /_  ______  / /_  _____
1373  / __ `/ / / / __  / / __ \/ __ `/ / / / / __ \/ __ \/ ___/
1374 / /_/ / /_/ / /_/ / / /_/ / /_/ / / /_/ / /_/ / / / (__  ) 
1375 \__,_/\__,_/\__,_/_/\____/\__, /_/\__, / .___/_/ /_/____/  
1376                          /____/  /____/_/                  
1377 
1378 10,000 randomly generated, infinite audio NFTs derived from on-chain Pixelglyph data.
1379 
1380 Each Audioglyph synthesizes a unique, infinite stream of music directly in your browser at lossless quality.
1381 
1382 by nftboi, tr666, and background cook
1383 
1384 
1385  */
1386 
1387 contract Audioglyphs is ERC721Enumerable, Ownable {
1388   string BASE_URI;
1389   address public pixelglyphs;
1390   uint256 regularPrice = 0.06 ether;
1391   bool public openToPublic;
1392 
1393   constructor(address pixelglyphsAddr, string memory baseUri)
1394     ERC721("Audioglyphs", "AG")
1395   {
1396     pixelglyphs = pixelglyphsAddr;
1397     BASE_URI = baseUri;
1398   }
1399 
1400   event Minted(uint256 indexed tokenId);
1401 
1402   uint256 globalId;
1403 
1404   function _mintInternal(uint256 amount, address to) internal {
1405     for (uint256 i = 0; i < amount; i++) {
1406       uint256 tokenId = ++globalId;
1407       _safeMint(to, tokenId);
1408       emit Minted(tokenId);
1409     }
1410   }
1411 
1412   function mint(uint256 amount) public payable {
1413     require(openToPublic, "AG: Not open to public yet");
1414     require(globalId < 10000, "AG: All minted");
1415     require(msg.value == amount * regularPrice, "AG: Incorrect value sent");
1416     require(globalId + amount <= 10000, "AG: Cannot mint amount");
1417     require(amount > 0 && amount <= 20, "AG: Max 20 per transaction");
1418     _mintInternal(amount, msg.sender);
1419   }
1420 
1421   uint256 teamMintCount;
1422 
1423   function teamMint(uint256 amount, address to) public onlyOwner {
1424     require(teamMintCount < 100, "AG: Team mint max 100");
1425     require(
1426       teamMintCount + amount <= 100,
1427       "AG: Amount + team mint count invalid"
1428     );
1429     teamMintCount += amount;
1430     _mintInternal(amount, to);
1431   }
1432 
1433   function open() public onlyOwner {
1434     openToPublic = true;
1435   }
1436 
1437   function setBaseUri(string memory baseUri) public onlyOwner {
1438     BASE_URI = baseUri;
1439   }
1440 
1441   function _baseURI() internal view virtual override returns (string memory) {
1442     return BASE_URI;
1443   }
1444 
1445   function withdraw(address sendTo) public onlyOwner {
1446     uint256 balance = address(this).balance;
1447     payable(sendTo).transfer(balance);
1448   }
1449 }