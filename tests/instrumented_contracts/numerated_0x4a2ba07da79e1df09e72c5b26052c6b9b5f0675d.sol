1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
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
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36   /**
37    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38    */
39   event Transfer(
40     address indexed from,
41     address indexed to,
42     uint256 indexed tokenId
43   );
44 
45   /**
46    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47    */
48   event Approval(
49     address indexed owner,
50     address indexed approved,
51     uint256 indexed tokenId
52   );
53 
54   /**
55    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56    */
57   event ApprovalForAll(
58     address indexed owner,
59     address indexed operator,
60     bool approved
61   );
62 
63   /**
64    * @dev Returns the number of tokens in ``owner``'s account.
65    */
66   function balanceOf(address owner) external view returns (uint256 balance);
67 
68   /**
69    * @dev Returns the owner of the `tokenId` token.
70    *
71    * Requirements:
72    *
73    * - `tokenId` must exist.
74    */
75   function ownerOf(uint256 tokenId) external view returns (address owner);
76 
77   /**
78    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80    *
81    * Requirements:
82    *
83    * - `from` cannot be the zero address.
84    * - `to` cannot be the zero address.
85    * - `tokenId` token must exist and be owned by `from`.
86    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88    *
89    * Emits a {Transfer} event.
90    */
91   function safeTransferFrom(
92     address from,
93     address to,
94     uint256 tokenId
95   ) external;
96 
97   /**
98    * @dev Transfers `tokenId` token from `from` to `to`.
99    *
100    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101    *
102    * Requirements:
103    *
104    * - `from` cannot be the zero address.
105    * - `to` cannot be the zero address.
106    * - `tokenId` token must be owned by `from`.
107    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108    *
109    * Emits a {Transfer} event.
110    */
111   function transferFrom(
112     address from,
113     address to,
114     uint256 tokenId
115   ) external;
116 
117   /**
118    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119    * The approval is cleared when the token is transferred.
120    *
121    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122    *
123    * Requirements:
124    *
125    * - The caller must own the token or be an approved operator.
126    * - `tokenId` must exist.
127    *
128    * Emits an {Approval} event.
129    */
130   function approve(address to, uint256 tokenId) external;
131 
132   /**
133    * @dev Returns the account approved for `tokenId` token.
134    *
135    * Requirements:
136    *
137    * - `tokenId` must exist.
138    */
139   function getApproved(uint256 tokenId)
140     external
141     view
142     returns (address operator);
143 
144   /**
145    * @dev Approve or remove `operator` as an operator for the caller.
146    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147    *
148    * Requirements:
149    *
150    * - The `operator` cannot be the caller.
151    *
152    * Emits an {ApprovalForAll} event.
153    */
154   function setApprovalForAll(address operator, bool _approved) external;
155 
156   /**
157    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158    *
159    * See {setApprovalForAll}
160    */
161   function isApprovedForAll(address owner, address operator)
162     external
163     view
164     returns (bool);
165 
166   /**
167    * @dev Safely transfers `tokenId` token from `from` to `to`.
168    *
169    * Requirements:
170    *
171    * - `from` cannot be the zero address.
172    * - `to` cannot be the zero address.
173    * - `tokenId` token must exist and be owned by `from`.
174    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176    *
177    * Emits a {Transfer} event.
178    */
179   function safeTransferFrom(
180     address from,
181     address to,
182     uint256 tokenId,
183     bytes calldata data
184   ) external;
185 }
186 
187 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197   /**
198    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199    * by `operator` from `from`, this function is called.
200    *
201    * It must return its Solidity selector to confirm the token transfer.
202    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203    *
204    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205    */
206   function onERC721Received(
207     address operator,
208     address from,
209     uint256 tokenId,
210     bytes calldata data
211   ) external returns (bytes4);
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Metadata is IERC721 {
223   /**
224    * @dev Returns the token collection name.
225    */
226   function name() external view returns (string memory);
227 
228   /**
229    * @dev Returns the token collection symbol.
230    */
231   function symbol() external view returns (string memory);
232 
233   /**
234    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
235    */
236   function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Enumerable is IERC721 {
248   /**
249    * @dev Returns the total amount of tokens stored by the contract.
250    */
251   function totalSupply() external view returns (uint256);
252 
253   /**
254    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256    */
257   function tokenOfOwnerByIndex(address owner, uint256 index)
258     external
259     view
260     returns (uint256 tokenId);
261 
262   /**
263    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
264    * Use along with {totalSupply} to enumerate all tokens.
265    */
266   function tokenByIndex(uint256 index) external view returns (uint256);
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277   /**
278    * @dev Returns true if `account` is a contract.
279    *
280    * [IMPORTANT]
281    * ====
282    * It is unsafe to assume that an address for which this function returns
283    * false is an externally-owned account (EOA) and not a contract.
284    *
285    * Among others, `isContract` will return false for the following
286    * types of addresses:
287    *
288    *  - an externally-owned account
289    *  - a contract in construction
290    *  - an address where a contract will be created
291    *  - an address where a contract lived, but was destroyed
292    * ====
293    */
294   function isContract(address account) internal view returns (bool) {
295     // This method relies on extcodesize, which returns 0 for contracts in
296     // construction, since the code is only stored at the end of the
297     // constructor execution.
298 
299     uint256 size;
300     // solhint-disable-next-line no-inline-assembly
301     assembly {
302       size := extcodesize(account)
303     }
304     return size > 0;
305   }
306 
307   /**
308    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309    * `recipient`, forwarding all available gas and reverting on errors.
310    *
311    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312    * of certain opcodes, possibly making contracts go over the 2300 gas limit
313    * imposed by `transfer`, making them unable to receive funds via
314    * `transfer`. {sendValue} removes this limitation.
315    *
316    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317    *
318    * IMPORTANT: because control is transferred to `recipient`, care must be
319    * taken to not create reentrancy vulnerabilities. Consider using
320    * {ReentrancyGuard} or the
321    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322    */
323   function sendValue(address payable recipient, uint256 amount) internal {
324     require(address(this).balance >= amount, "Address: insufficient balance");
325 
326     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327     (bool success, ) = recipient.call{value: amount}("");
328     require(
329       success,
330       "Address: unable to send value, recipient may have reverted"
331     );
332   }
333 
334   /**
335    * @dev Performs a Solidity function call using a low level `call`. A
336    * plain`call` is an unsafe replacement for a function call: use this
337    * function instead.
338    *
339    * If `target` reverts with a revert reason, it is bubbled up by this
340    * function (like regular Solidity function calls).
341    *
342    * Returns the raw returned data. To convert to the expected return value,
343    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344    *
345    * Requirements:
346    *
347    * - `target` must be a contract.
348    * - calling `target` with `data` must not revert.
349    *
350    * _Available since v3.1._
351    */
352   function functionCall(address target, bytes memory data)
353     internal
354     returns (bytes memory)
355   {
356     return functionCall(target, data, "Address: low-level call failed");
357   }
358 
359   /**
360    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361    * `errorMessage` as a fallback revert reason when `target` reverts.
362    *
363    * _Available since v3.1._
364    */
365   function functionCall(
366     address target,
367     bytes memory data,
368     string memory errorMessage
369   ) internal returns (bytes memory) {
370     return functionCallWithValue(target, data, 0, errorMessage);
371   }
372 
373   /**
374    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375    * but also transferring `value` wei to `target`.
376    *
377    * Requirements:
378    *
379    * - the calling contract must have an ETH balance of at least `value`.
380    * - the called Solidity function must be `payable`.
381    *
382    * _Available since v3.1._
383    */
384   function functionCallWithValue(
385     address target,
386     bytes memory data,
387     uint256 value
388   ) internal returns (bytes memory) {
389     return
390       functionCallWithValue(
391         target,
392         data,
393         value,
394         "Address: low-level call with value failed"
395       );
396   }
397 
398   /**
399    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400    * with `errorMessage` as a fallback revert reason when `target` reverts.
401    *
402    * _Available since v3.1._
403    */
404   function functionCallWithValue(
405     address target,
406     bytes memory data,
407     uint256 value,
408     string memory errorMessage
409   ) internal returns (bytes memory) {
410     require(
411       address(this).balance >= value,
412       "Address: insufficient balance for call"
413     );
414     require(isContract(target), "Address: call to non-contract");
415 
416     // solhint-disable-next-line avoid-low-level-calls
417     (bool success, bytes memory returndata) = target.call{value: value}(data);
418     return _verifyCallResult(success, returndata, errorMessage);
419   }
420 
421   /**
422    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423    * but performing a static call.
424    *
425    * _Available since v3.3._
426    */
427   function functionStaticCall(address target, bytes memory data)
428     internal
429     view
430     returns (bytes memory)
431   {
432     return
433       functionStaticCall(target, data, "Address: low-level static call failed");
434   }
435 
436   /**
437    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438    * but performing a static call.
439    *
440    * _Available since v3.3._
441    */
442   function functionStaticCall(
443     address target,
444     bytes memory data,
445     string memory errorMessage
446   ) internal view returns (bytes memory) {
447     require(isContract(target), "Address: static call to non-contract");
448 
449     // solhint-disable-next-line avoid-low-level-calls
450     (bool success, bytes memory returndata) = target.staticcall(data);
451     return _verifyCallResult(success, returndata, errorMessage);
452   }
453 
454   /**
455    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456    * but performing a delegate call.
457    *
458    * _Available since v3.4._
459    */
460   function functionDelegateCall(address target, bytes memory data)
461     internal
462     returns (bytes memory)
463   {
464     return
465       functionDelegateCall(
466         target,
467         data,
468         "Address: low-level delegate call failed"
469       );
470   }
471 
472   /**
473    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474    * but performing a delegate call.
475    *
476    * _Available since v3.4._
477    */
478   function functionDelegateCall(
479     address target,
480     bytes memory data,
481     string memory errorMessage
482   ) internal returns (bytes memory) {
483     require(isContract(target), "Address: delegate call to non-contract");
484 
485     // solhint-disable-next-line avoid-low-level-calls
486     (bool success, bytes memory returndata) = target.delegatecall(data);
487     return _verifyCallResult(success, returndata, errorMessage);
488   }
489 
490   function _verifyCallResult(
491     bool success,
492     bytes memory returndata,
493     string memory errorMessage
494   ) private pure returns (bytes memory) {
495     if (success) {
496       return returndata;
497     } else {
498       // Look for revert reason and bubble it up if present
499       if (returndata.length > 0) {
500         // The easiest way to bubble the revert reason is using memory via assembly
501 
502         // solhint-disable-next-line no-inline-assembly
503         assembly {
504           let returndata_size := mload(returndata)
505           revert(add(32, returndata), returndata_size)
506         }
507       } else {
508         revert(errorMessage);
509       }
510     }
511   }
512 }
513 
514 // File: @openzeppelin/contracts/utils/Context.sol
515 
516 pragma solidity ^0.8.0;
517 
518 /*
519  * @dev Provides information about the current execution context, including the
520  * sender of the transaction and its data. While these are generally available
521  * via msg.sender and msg.data, they should not be accessed in such a direct
522  * manner, since when dealing with meta-transactions the account sending and
523  * paying for execution may not be the actual sender (as far as an application
524  * is concerned).
525  *
526  * This contract is only required for intermediate, library-like contracts.
527  */
528 abstract contract Context {
529   function _msgSender() internal view virtual returns (address) {
530     return msg.sender;
531   }
532 
533   function _msgData() internal view virtual returns (bytes calldata) {
534     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
535     return msg.data;
536   }
537 }
538 
539 // File: @openzeppelin/contracts/utils/Strings.sol
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev String operations.
545  */
546 library Strings {
547   bytes16 private constant alphabet = "0123456789abcdef";
548 
549   /**
550    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
551    */
552   function toString(uint256 value) internal pure returns (string memory) {
553     // Inspired by OraclizeAPI's implementation - MIT licence
554     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
555 
556     if (value == 0) {
557       return "0";
558     }
559     uint256 temp = value;
560     uint256 digits;
561     while (temp != 0) {
562       digits++;
563       temp /= 10;
564     }
565     bytes memory buffer = new bytes(digits);
566     while (value != 0) {
567       digits -= 1;
568       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
569       value /= 10;
570     }
571     return string(buffer);
572   }
573 
574   /**
575    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
576    */
577   function toHexString(uint256 value) internal pure returns (string memory) {
578     if (value == 0) {
579       return "0x00";
580     }
581     uint256 temp = value;
582     uint256 length = 0;
583     while (temp != 0) {
584       length++;
585       temp >>= 8;
586     }
587     return toHexString(value, length);
588   }
589 
590   /**
591    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
592    */
593   function toHexString(uint256 value, uint256 length)
594     internal
595     pure
596     returns (string memory)
597   {
598     bytes memory buffer = new bytes(2 * length + 2);
599     buffer[0] = "0";
600     buffer[1] = "x";
601     for (uint256 i = 2 * length + 1; i > 1; --i) {
602       buffer[i] = alphabet[value & 0xf];
603       value >>= 4;
604     }
605     require(value == 0, "Strings: hex length insufficient");
606     return string(buffer);
607   }
608 }
609 
610 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629   /**
630    * @dev See {IERC165-supportsInterface}.
631    */
632   function supportsInterface(bytes4 interfaceId)
633     public
634     view
635     virtual
636     override
637     returns (bool)
638   {
639     return interfaceId == type(IERC165).interfaceId;
640   }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
649  * the Metadata extension, but not including the Enumerable extension, which is available separately as
650  * {ERC721Enumerable}.
651  */
652 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
653   using Address for address;
654   using Strings for uint256;
655 
656   // Token name
657   string private _name;
658 
659   // Token symbol
660   string private _symbol;
661 
662   // Mapping from token ID to owner address
663   mapping(uint256 => address) private _owners;
664 
665   // Mapping owner address to token count
666   mapping(address => uint256) private _balances;
667 
668   // Mapping from token ID to approved address
669   mapping(uint256 => address) private _tokenApprovals;
670 
671   // Mapping from owner to operator approvals
672   mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674   /**
675    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
676    */
677   constructor(string memory name_, string memory symbol_) {
678     _name = name_;
679     _symbol = symbol_;
680   }
681 
682   /**
683    * @dev See {IERC165-supportsInterface}.
684    */
685   function supportsInterface(bytes4 interfaceId)
686     public
687     view
688     virtual
689     override(ERC165, IERC165)
690     returns (bool)
691   {
692     return
693       interfaceId == type(IERC721).interfaceId ||
694       interfaceId == type(IERC721Metadata).interfaceId ||
695       super.supportsInterface(interfaceId);
696   }
697 
698   /**
699    * @dev See {IERC721-balanceOf}.
700    */
701   function balanceOf(address owner)
702     public
703     view
704     virtual
705     override
706     returns (uint256)
707   {
708     require(owner != address(0), "ERC721: balance query for the zero address");
709     return _balances[owner];
710   }
711 
712   /**
713    * @dev See {IERC721-ownerOf}.
714    */
715   function ownerOf(uint256 tokenId)
716     public
717     view
718     virtual
719     override
720     returns (address)
721   {
722     address owner = _owners[tokenId];
723     require(owner != address(0), "ERC721: owner query for nonexistent token");
724     return owner;
725   }
726 
727   /**
728    * @dev See {IERC721Metadata-name}.
729    */
730   function name() public view virtual override returns (string memory) {
731     return _name;
732   }
733 
734   /**
735    * @dev See {IERC721Metadata-symbol}.
736    */
737   function symbol() public view virtual override returns (string memory) {
738     return _symbol;
739   }
740 
741   /**
742    * @dev See {IERC721Metadata-tokenURI}.
743    */
744   function tokenURI(uint256 tokenId)
745     public
746     view
747     virtual
748     override
749     returns (string memory)
750   {
751     require(
752       _exists(tokenId),
753       "ERC721Metadata: URI query for nonexistent token"
754     );
755 
756     string memory baseURI = _baseURI();
757     return
758       bytes(baseURI).length > 0
759         ? string(abi.encodePacked(baseURI, tokenId.toString()))
760         : "";
761   }
762 
763   /**
764    * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
765    * in child contracts.
766    */
767   function _baseURI() internal view virtual returns (string memory) {
768     return "";
769   }
770 
771   /**
772    * @dev See {IERC721-approve}.
773    */
774   function approve(address to, uint256 tokenId) public virtual override {
775     address owner = ERC721.ownerOf(tokenId);
776     require(to != owner, "ERC721: approval to current owner");
777 
778     require(
779       _msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
780       "ERC721: approve caller is not owner nor approved for all"
781     );
782 
783     _approve(to, tokenId);
784   }
785 
786   /**
787    * @dev See {IERC721-getApproved}.
788    */
789   function getApproved(uint256 tokenId)
790     public
791     view
792     virtual
793     override
794     returns (address)
795   {
796     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
797 
798     return _tokenApprovals[tokenId];
799   }
800 
801   /**
802    * @dev See {IERC721-setApprovalForAll}.
803    */
804   function setApprovalForAll(address operator, bool approved)
805     public
806     virtual
807     override
808   {
809     require(operator != _msgSender(), "ERC721: approve to caller");
810 
811     _operatorApprovals[_msgSender()][operator] = approved;
812     emit ApprovalForAll(_msgSender(), operator, approved);
813   }
814 
815   /**
816    * @dev See {IERC721-isApprovedForAll}.
817    */
818   function isApprovedForAll(address owner, address operator)
819     public
820     view
821     virtual
822     override
823     returns (bool)
824   {
825     return _operatorApprovals[owner][operator];
826   }
827 
828   /**
829    * @dev See {IERC721-transferFrom}.
830    */
831   function transferFrom(
832     address from,
833     address to,
834     uint256 tokenId
835   ) public virtual override {
836     //solhint-disable-next-line max-line-length
837     require(
838       _isApprovedOrOwner(_msgSender(), tokenId),
839       "ERC721: transfer caller is not owner nor approved"
840     );
841 
842     _transfer(from, to, tokenId);
843   }
844 
845   /**
846    * @dev See {IERC721-safeTransferFrom}.
847    */
848   function safeTransferFrom(
849     address from,
850     address to,
851     uint256 tokenId
852   ) public virtual override {
853     safeTransferFrom(from, to, tokenId, "");
854   }
855 
856   /**
857    * @dev See {IERC721-safeTransferFrom}.
858    */
859   function safeTransferFrom(
860     address from,
861     address to,
862     uint256 tokenId,
863     bytes memory _data
864   ) public virtual override {
865     require(
866       _isApprovedOrOwner(_msgSender(), tokenId),
867       "ERC721: transfer caller is not owner nor approved"
868     );
869     _safeTransfer(from, to, tokenId, _data);
870   }
871 
872   /**
873    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
874    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
875    *
876    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
877    *
878    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
879    * implement alternative mechanisms to perform token transfer, such as signature-based.
880    *
881    * Requirements:
882    *
883    * - `from` cannot be the zero address.
884    * - `to` cannot be the zero address.
885    * - `tokenId` token must exist and be owned by `from`.
886    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887    *
888    * Emits a {Transfer} event.
889    */
890   function _safeTransfer(
891     address from,
892     address to,
893     uint256 tokenId,
894     bytes memory _data
895   ) internal virtual {
896     _transfer(from, to, tokenId);
897     require(
898       _checkOnERC721Received(from, to, tokenId, _data),
899       "ERC721: transfer to non ERC721Receiver implementer"
900     );
901   }
902 
903   /**
904    * @dev Returns whether `tokenId` exists.
905    *
906    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907    *
908    * Tokens start existing when they are minted (`_mint`),
909    * and stop existing when they are burned (`_burn`).
910    */
911   function _exists(uint256 tokenId) internal view virtual returns (bool) {
912     return _owners[tokenId] != address(0);
913   }
914 
915   /**
916    * @dev Returns whether `spender` is allowed to manage `tokenId`.
917    *
918    * Requirements:
919    *
920    * - `tokenId` must exist.
921    */
922   function _isApprovedOrOwner(address spender, uint256 tokenId)
923     internal
924     view
925     virtual
926     returns (bool)
927   {
928     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
929     address owner = ERC721.ownerOf(tokenId);
930     return (spender == owner ||
931       getApproved(tokenId) == spender ||
932       ERC721.isApprovedForAll(owner, spender));
933   }
934 
935   /**
936    * @dev Safely mints `tokenId` and transfers it to `to`.
937    *
938    * Requirements:
939    *
940    * - `tokenId` must not exist.
941    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942    *
943    * Emits a {Transfer} event.
944    */
945   function _safeMint(address to, uint256 tokenId) internal virtual {
946     _safeMint(to, tokenId, "");
947   }
948 
949   /**
950    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
951    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
952    */
953   function _safeMint(
954     address to,
955     uint256 tokenId,
956     bytes memory _data
957   ) internal virtual {
958     _mint(to, tokenId);
959     require(
960       _checkOnERC721Received(address(0), to, tokenId, _data),
961       "ERC721: transfer to non ERC721Receiver implementer"
962     );
963   }
964 
965   /**
966    * @dev Mints `tokenId` and transfers it to `to`.
967    *
968    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
969    *
970    * Requirements:
971    *
972    * - `tokenId` must not exist.
973    * - `to` cannot be the zero address.
974    *
975    * Emits a {Transfer} event.
976    */
977   function _mint(address to, uint256 tokenId) internal virtual {
978     require(to != address(0), "ERC721: mint to the zero address");
979     require(!_exists(tokenId), "ERC721: token already minted");
980 
981     _beforeTokenTransfer(address(0), to, tokenId);
982 
983     _balances[to] += 1;
984     _owners[tokenId] = to;
985 
986     emit Transfer(address(0), to, tokenId);
987   }
988 
989   /**
990    * @dev Destroys `tokenId`.
991    * The approval is cleared when the token is burned.
992    *
993    * Requirements:
994    *
995    * - `tokenId` must exist.
996    *
997    * Emits a {Transfer} event.
998    */
999   function _burn(uint256 tokenId) internal virtual {
1000     address owner = ERC721.ownerOf(tokenId);
1001 
1002     _beforeTokenTransfer(owner, address(0), tokenId);
1003 
1004     // Clear approvals
1005     _approve(address(0), tokenId);
1006 
1007     _balances[owner] -= 1;
1008     delete _owners[tokenId];
1009 
1010     emit Transfer(owner, address(0), tokenId);
1011   }
1012 
1013   /**
1014    * @dev Transfers `tokenId` from `from` to `to`.
1015    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1016    *
1017    * Requirements:
1018    *
1019    * - `to` cannot be the zero address.
1020    * - `tokenId` token must be owned by `from`.
1021    *
1022    * Emits a {Transfer} event.
1023    */
1024   function _transfer(
1025     address from,
1026     address to,
1027     uint256 tokenId
1028   ) internal virtual {
1029     require(
1030       ERC721.ownerOf(tokenId) == from,
1031       "ERC721: transfer of token that is not own"
1032     );
1033     require(to != address(0), "ERC721: transfer to the zero address");
1034 
1035     _beforeTokenTransfer(from, to, tokenId);
1036 
1037     // Clear approvals from the previous owner
1038     _approve(address(0), tokenId);
1039 
1040     _balances[from] -= 1;
1041     _balances[to] += 1;
1042     _owners[tokenId] = to;
1043 
1044     emit Transfer(from, to, tokenId);
1045   }
1046 
1047   /**
1048    * @dev Approve `to` to operate on `tokenId`
1049    *
1050    * Emits a {Approval} event.
1051    */
1052   function _approve(address to, uint256 tokenId) internal virtual {
1053     _tokenApprovals[tokenId] = to;
1054     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1055   }
1056 
1057   /**
1058    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1059    * The call is not executed if the target address is not a contract.
1060    *
1061    * @param from address representing the previous owner of the given token ID
1062    * @param to target address that will receive the tokens
1063    * @param tokenId uint256 ID of the token to be transferred
1064    * @param _data bytes optional data to send along with the call
1065    * @return bool whether the call correctly returned the expected magic value
1066    */
1067   function _checkOnERC721Received(
1068     address from,
1069     address to,
1070     uint256 tokenId,
1071     bytes memory _data
1072   ) private returns (bool) {
1073     if (to.isContract()) {
1074       try
1075         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1076       returns (bytes4 retval) {
1077         return retval == IERC721Receiver(to).onERC721Received.selector;
1078       } catch (bytes memory reason) {
1079         if (reason.length == 0) {
1080           revert("ERC721: transfer to non ERC721Receiver implementer");
1081         } else {
1082           // solhint-disable-next-line no-inline-assembly
1083           assembly {
1084             revert(add(32, reason), mload(reason))
1085           }
1086         }
1087       }
1088     } else {
1089       return true;
1090     }
1091   }
1092 
1093   /**
1094    * @dev Hook that is called before any token transfer. This includes minting
1095    * and burning.
1096    *
1097    * Calling conditions:
1098    *
1099    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1100    * transferred to `to`.
1101    * - When `from` is zero, `tokenId` will be minted for `to`.
1102    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1103    * - `from` cannot be the zero address.
1104    * - `to` cannot be the zero address.
1105    *
1106    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1107    */
1108   function _beforeTokenTransfer(
1109     address from,
1110     address to,
1111     uint256 tokenId
1112   ) internal virtual {}
1113 }
1114 
1115 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1121  * enumerability of all the token ids in the contract as well as all token ids owned by each
1122  * account.
1123  */
1124 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1125   // Mapping from owner to list of owned token IDs
1126   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1127 
1128   // Mapping from token ID to index of the owner tokens list
1129   mapping(uint256 => uint256) private _ownedTokensIndex;
1130 
1131   // Array with all token ids, used for enumeration
1132   uint256[] private _allTokens;
1133 
1134   // Mapping from token id to position in the allTokens array
1135   mapping(uint256 => uint256) private _allTokensIndex;
1136 
1137   /**
1138    * @dev See {IERC165-supportsInterface}.
1139    */
1140   function supportsInterface(bytes4 interfaceId)
1141     public
1142     view
1143     virtual
1144     override(IERC165, ERC721)
1145     returns (bool)
1146   {
1147     return
1148       interfaceId == type(IERC721Enumerable).interfaceId ||
1149       super.supportsInterface(interfaceId);
1150   }
1151 
1152   /**
1153    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1154    */
1155   function tokenOfOwnerByIndex(address owner, uint256 index)
1156     public
1157     view
1158     virtual
1159     override
1160     returns (uint256)
1161   {
1162     require(
1163       index < ERC721.balanceOf(owner),
1164       "ERC721Enumerable: owner index out of bounds"
1165     );
1166     return _ownedTokens[owner][index];
1167   }
1168 
1169   /**
1170    * @dev See {IERC721Enumerable-totalSupply}.
1171    */
1172   function totalSupply() public view virtual override returns (uint256) {
1173     return _allTokens.length;
1174   }
1175 
1176   /**
1177    * @dev See {IERC721Enumerable-tokenByIndex}.
1178    */
1179   function tokenByIndex(uint256 index)
1180     public
1181     view
1182     virtual
1183     override
1184     returns (uint256)
1185   {
1186     require(
1187       index < ERC721Enumerable.totalSupply(),
1188       "ERC721Enumerable: global index out of bounds"
1189     );
1190     return _allTokens[index];
1191   }
1192 
1193   /**
1194    * @dev Hook that is called before any token transfer. This includes minting
1195    * and burning.
1196    *
1197    * Calling conditions:
1198    *
1199    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1200    * transferred to `to`.
1201    * - When `from` is zero, `tokenId` will be minted for `to`.
1202    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1203    * - `from` cannot be the zero address.
1204    * - `to` cannot be the zero address.
1205    *
1206    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1207    */
1208   function _beforeTokenTransfer(
1209     address from,
1210     address to,
1211     uint256 tokenId
1212   ) internal virtual override {
1213     super._beforeTokenTransfer(from, to, tokenId);
1214 
1215     if (from == address(0)) {
1216       _addTokenToAllTokensEnumeration(tokenId);
1217     } else if (from != to) {
1218       _removeTokenFromOwnerEnumeration(from, tokenId);
1219     }
1220     if (to == address(0)) {
1221       _removeTokenFromAllTokensEnumeration(tokenId);
1222     } else if (to != from) {
1223       _addTokenToOwnerEnumeration(to, tokenId);
1224     }
1225   }
1226 
1227   /**
1228    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1229    * @param to address representing the new owner of the given token ID
1230    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1231    */
1232   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1233     uint256 length = ERC721.balanceOf(to);
1234     _ownedTokens[to][length] = tokenId;
1235     _ownedTokensIndex[tokenId] = length;
1236   }
1237 
1238   /**
1239    * @dev Private function to add a token to this extension's token tracking data structures.
1240    * @param tokenId uint256 ID of the token to be added to the tokens list
1241    */
1242   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1243     _allTokensIndex[tokenId] = _allTokens.length;
1244     _allTokens.push(tokenId);
1245   }
1246 
1247   /**
1248    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1249    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1250    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1251    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1252    * @param from address representing the previous owner of the given token ID
1253    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1254    */
1255   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1256     private
1257   {
1258     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1259     // then delete the last slot (swap and pop).
1260 
1261     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1262     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1263 
1264     // When the token to delete is the last token, the swap operation is unnecessary
1265     if (tokenIndex != lastTokenIndex) {
1266       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1267 
1268       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1269       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1270     }
1271 
1272     // This also deletes the contents at the last position of the array
1273     delete _ownedTokensIndex[tokenId];
1274     delete _ownedTokens[from][lastTokenIndex];
1275   }
1276 
1277   /**
1278    * @dev Private function to remove a token from this extension's token tracking data structures.
1279    * This has O(1) time complexity, but alters the order of the _allTokens array.
1280    * @param tokenId uint256 ID of the token to be removed from the tokens list
1281    */
1282   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1283     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1284     // then delete the last slot (swap and pop).
1285 
1286     uint256 lastTokenIndex = _allTokens.length - 1;
1287     uint256 tokenIndex = _allTokensIndex[tokenId];
1288 
1289     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1290     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1291     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1292     uint256 lastTokenId = _allTokens[lastTokenIndex];
1293 
1294     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1295     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1296 
1297     // This also deletes the contents at the last position of the array
1298     delete _allTokensIndex[tokenId];
1299     _allTokens.pop();
1300   }
1301 }
1302 
1303 // File: @openzeppelin/contracts/access/Ownable.sol
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 /**
1308  * @dev Contract module which provides a basic access control mechanism, where
1309  * there is an account (an owner) that can be granted exclusive access to
1310  * specific functions.
1311  *
1312  * By default, the owner account will be the one that deploys the contract. This
1313  * can later be changed with {transferOwnership}.
1314  *
1315  * This module is used through inheritance. It will make available the modifier
1316  * `onlyOwner`, which can be applied to your functions to restrict their use to
1317  * the owner.
1318  */
1319 abstract contract Ownable is Context {
1320   address private _owner;
1321 
1322   event OwnershipTransferred(
1323     address indexed previousOwner,
1324     address indexed newOwner
1325   );
1326 
1327   /**
1328    * @dev Initializes the contract setting the deployer as the initial owner.
1329    */
1330   constructor() {
1331     address msgSender = _msgSender();
1332     _owner = msgSender;
1333     emit OwnershipTransferred(address(0), msgSender);
1334   }
1335 
1336   /**
1337    * @dev Returns the address of the current owner.
1338    */
1339   function owner() public view virtual returns (address) {
1340     return _owner;
1341   }
1342 
1343   /**
1344    * @dev Throws if called by any account other than the owner.
1345    */
1346   modifier onlyOwner() {
1347     require(owner() == _msgSender(), "Ownable: caller is not the owner");
1348     _;
1349   }
1350 
1351   /**
1352    * @dev Leaves the contract without owner. It will not be possible to call
1353    * `onlyOwner` functions anymore. Can only be called by the current owner.
1354    *
1355    * NOTE: Renouncing ownership will leave the contract without an owner,
1356    * thereby removing any functionality that is only available to the owner.
1357    */
1358   function renounceOwnership() public virtual onlyOwner {
1359     emit OwnershipTransferred(_owner, address(0));
1360     _owner = address(0);
1361   }
1362 
1363   /**
1364    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1365    * Can only be called by the current owner.
1366    */
1367   function transferOwnership(address newOwner) public virtual onlyOwner {
1368     require(newOwner != address(0), "Ownable: new owner is the zero address");
1369     emit OwnershipTransferred(_owner, newOwner);
1370     _owner = newOwner;
1371   }
1372 }
1373 
1374 // File: contracts/CryptoGunz.sol
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 contract CryptoGunz is ERC721Enumerable, Ownable {
1379   uint256 public constant MAX_NFT_SUPPLY = 7500;
1380   bool public saleStarted = false;
1381 
1382   constructor() ERC721("CryptoGunz", "GUNZ") {
1383     transferOwnership(0xec83dED4578FB8C5e14851D9F942A9871E295ad6);
1384   }
1385 
1386   function _baseURI() internal view virtual override returns (string memory) {
1387     return "https://api.cryptogunz.io/";
1388   }
1389 
1390   function getCryptogunzPrice() public view returns (uint256) {
1391     require(saleStarted == true, "Sale has not started.");
1392     require(totalSupply() < MAX_NFT_SUPPLY, "Sale has ended.");
1393 
1394     uint256 currentSupply = totalSupply();
1395 
1396     if (currentSupply == 7499) {
1397       return 3800000000000000000; // 7499 3.8 ETH
1398     } else if (currentSupply >= 7496) {
1399       return 2200000000000000000; // 7496 - 7498 2.2 ETH
1400     } else if (currentSupply >= 7475) {
1401       return 1400000000000000000; // 7475 - 7495 1.4 ETH
1402     } else if (currentSupply >= 7400) {
1403       return 1000000000000000000; // 7400 - 7474 1 ETH
1404     } else if (currentSupply >= 7300) {
1405       return 800000000000000000; // 7300 - 7399 0.8 ETH
1406     } else if (currentSupply >= 7200) {
1407       return 700000000000000000; // 7200 - 7299 0.7 ETH
1408     } else if (currentSupply >= 7100) {
1409       return 600000000000000000; // 7100 - 7199 0.6 ETH
1410     } else if (currentSupply >= 6650) {
1411       return 500000000000000000; // 6650 - 7099 0.5 ETH
1412     } else if (currentSupply >= 6200) {
1413       return 400000000000000000; // 6200 - 6649 0.4 ETH
1414     } else if (currentSupply >= 5600) {
1415       return 300000000000000000; // 5600 - 6199 0.3 ETH
1416     } else if (currentSupply >= 5000) {
1417       return 250000000000000000; // 5000 - 5599 0.25 ETH
1418     } else if (currentSupply >= 4500) {
1419       return 200000000000000000; // 4500 - 4999 0.2 ETH
1420     } else if (currentSupply >= 4000) {
1421       return 175000000000000000; // 4000 - 4999 0.175 ETH
1422     } else if (currentSupply >= 3500) {
1423       return 150000000000000000; // 3500 - 3999 0.15 ETH
1424     } else if (currentSupply >= 3000) {
1425       return 125000000000000000; // 3000 - 3499 0.125 ETH
1426     } else if (currentSupply >= 2500) {
1427       return 100000000000000000; // 2500 - 2999 0.1 ETH
1428     } else if (currentSupply >= 2000) {
1429       return 90000000000000000; // 2000 - 2499 0.09 ETH
1430     } else if (currentSupply >= 1500) {
1431       return 80000000000000000; // 1500 - 1999 0.08 ETH
1432     } else if (currentSupply >= 1000) {
1433       return 70000000000000000; // 1000 - 1499 0.07 ETH
1434     } else if (currentSupply >= 500) {
1435       return 60000000000000000; // 500 - 999 0.06 ETH
1436     } else {
1437       return 50000000000000000; // 0 - 499 0.05 ETH
1438     }
1439   }
1440 
1441   function purchaseCryptogun(uint256 amountToMint) public payable {
1442     require(totalSupply() < MAX_NFT_SUPPLY, "Sale has ended.");
1443     require(amountToMint > 0, "You must purchase at least one Cryptogun.");
1444     require(
1445       amountToMint <= 100,
1446       "You can only purchase max 100 Cryptogunz at a time."
1447     );
1448     require(
1449       totalSupply() + amountToMint <= MAX_NFT_SUPPLY,
1450       "The amount you are trying to purchase exceeds MAX_NFT_SUPPLY."
1451     );
1452     require(
1453       getCryptogunzPrice() * amountToMint == msg.value,
1454       "Incorrect Ether value."
1455     );
1456 
1457     for (uint256 i = 0; i < amountToMint; i++) {
1458       uint256 mintIndex = totalSupply();
1459       _safeMint(msg.sender, mintIndex);
1460     }
1461   }
1462 
1463   function withdraw() public payable onlyOwner {
1464     require(payable(msg.sender).send(address(this).balance));
1465   }
1466 
1467   function startDrop() public onlyOwner {
1468     saleStarted = true;
1469   }
1470 
1471   function pauseDrop() public onlyOwner {
1472     saleStarted = false;
1473   }
1474 }