1 pragma solidity ^0.8.0;
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  */
14 library MerkleProof {
15   /**
16    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17    * defined by `root`. For this, a `proof` must be provided, containing
18    * sibling hashes on the branch from the leaf to the root of the tree. Each
19    * pair of leaves and each pair of pre-images are assumed to be sorted.
20    */
21   function verify(
22     bytes32[] memory proof,
23     bytes32 root,
24     bytes32 leaf
25   ) internal pure returns (bool) {
26     bytes32 computedHash = leaf;
27 
28     for (uint256 i = 0; i < proof.length; i++) {
29       bytes32 proofElement = proof[i];
30 
31       if (computedHash <= proofElement) {
32         // Hash(current computed hash + current element of the proof)
33         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
34       } else {
35         // Hash(current element of the proof + current computed hash)
36         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
37       }
38     }
39 
40     // Check if the computed hash (root) is equal to the provided root
41     return computedHash == root;
42   }
43 }
44 
45 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
46 
47 /**
48  * @dev Interface of the ERC165 standard, as defined in the
49  * https://eips.ethereum.org/EIPS/eip-165[EIP].
50  *
51  * Implementers can declare support of contract interfaces, which can then be
52  * queried by others ({ERC165Checker}).
53  *
54  * For an implementation, see {ERC165}.
55  */
56 interface IERC165 {
57   /**
58    * @dev Returns true if this contract implements the interface defined by
59    * `interfaceId`. See the corresponding
60    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
61    * to learn more about how these ids are created.
62    *
63    * This function call must use less than 30 000 gas.
64    */
65   function supportsInterface(bytes4 interfaceId) external view returns (bool);
66 }
67 
68 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
69 
70 /**
71  * @dev Required interface of an ERC721 compliant contract.
72  */
73 interface IERC721 is IERC165 {
74   /**
75    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
76    */
77   event Transfer(
78     address indexed from,
79     address indexed to,
80     uint256 indexed tokenId
81   );
82 
83   /**
84    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
85    */
86   event Approval(
87     address indexed owner,
88     address indexed approved,
89     uint256 indexed tokenId
90   );
91 
92   /**
93    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
94    */
95   event ApprovalForAll(
96     address indexed owner,
97     address indexed operator,
98     bool approved
99   );
100 
101   /**
102    * @dev Returns the number of tokens in ``owner``'s account.
103    */
104   function balanceOf(address owner) external view returns (uint256 balance);
105 
106   /**
107    * @dev Returns the owner of the `tokenId` token.
108    *
109    * Requirements:
110    *
111    * - `tokenId` must exist.
112    */
113   function ownerOf(uint256 tokenId) external view returns (address owner);
114 
115   /**
116    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
117    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
118    *
119    * Requirements:
120    *
121    * - `from` cannot be the zero address.
122    * - `to` cannot be the zero address.
123    * - `tokenId` token must exist and be owned by `from`.
124    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
125    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
126    *
127    * Emits a {Transfer} event.
128    */
129   function safeTransferFrom(
130     address from,
131     address to,
132     uint256 tokenId
133   ) external;
134 
135   /**
136    * @dev Transfers `tokenId` token from `from` to `to`.
137    *
138    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
139    *
140    * Requirements:
141    *
142    * - `from` cannot be the zero address.
143    * - `to` cannot be the zero address.
144    * - `tokenId` token must be owned by `from`.
145    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146    *
147    * Emits a {Transfer} event.
148    */
149   function transferFrom(
150     address from,
151     address to,
152     uint256 tokenId
153   ) external;
154 
155   /**
156    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
157    * The approval is cleared when the token is transferred.
158    *
159    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
160    *
161    * Requirements:
162    *
163    * - The caller must own the token or be an approved operator.
164    * - `tokenId` must exist.
165    *
166    * Emits an {Approval} event.
167    */
168   function approve(address to, uint256 tokenId) external;
169 
170   /**
171    * @dev Returns the account approved for `tokenId` token.
172    *
173    * Requirements:
174    *
175    * - `tokenId` must exist.
176    */
177   function getApproved(uint256 tokenId)
178     external
179     view
180     returns (address operator);
181 
182   /**
183    * @dev Approve or remove `operator` as an operator for the caller.
184    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
185    *
186    * Requirements:
187    *
188    * - The `operator` cannot be the caller.
189    *
190    * Emits an {ApprovalForAll} event.
191    */
192   function setApprovalForAll(address operator, bool _approved) external;
193 
194   /**
195    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
196    *
197    * See {setApprovalForAll}
198    */
199   function isApprovedForAll(address owner, address operator)
200     external
201     view
202     returns (bool);
203 
204   /**
205    * @dev Safely transfers `tokenId` token from `from` to `to`.
206    *
207    * Requirements:
208    *
209    * - `from` cannot be the zero address.
210    * - `to` cannot be the zero address.
211    * - `tokenId` token must exist and be owned by `from`.
212    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214    *
215    * Emits a {Transfer} event.
216    */
217   function safeTransferFrom(
218     address from,
219     address to,
220     uint256 tokenId,
221     bytes calldata data
222   ) external;
223 }
224 
225 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
226 
227 /**
228  * @title ERC721 token receiver interface
229  * @dev Interface for any contract that wants to support safeTransfers
230  * from ERC721 asset contracts.
231  */
232 interface IERC721Receiver {
233   /**
234    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
235    * by `operator` from `from`, this function is called.
236    *
237    * It must return its Solidity selector to confirm the token transfer.
238    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
239    *
240    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
241    */
242   function onERC721Received(
243     address operator,
244     address from,
245     uint256 tokenId,
246     bytes calldata data
247   ) external returns (bytes4);
248 }
249 
250 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
254  * @dev See https://eips.ethereum.org/EIPS/eip-721
255  */
256 interface IERC721Metadata is IERC721 {
257   /**
258    * @dev Returns the token collection name.
259    */
260   function name() external view returns (string memory);
261 
262   /**
263    * @dev Returns the token collection symbol.
264    */
265   function symbol() external view returns (string memory);
266 
267   /**
268    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269    */
270   function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279   /**
280    * @dev Returns true if `account` is a contract.
281    *
282    * [IMPORTANT]
283    * ====
284    * It is unsafe to assume that an address for which this function returns
285    * false is an externally-owned account (EOA) and not a contract.
286    *
287    * Among others, `isContract` will return false for the following
288    * types of addresses:
289    *
290    *  - an externally-owned account
291    *  - a contract in construction
292    *  - an address where a contract will be created
293    *  - an address where a contract lived, but was destroyed
294    * ====
295    */
296   function isContract(address account) internal view returns (bool) {
297     // This method relies on extcodesize, which returns 0 for contracts in
298     // construction, since the code is only stored at the end of the
299     // constructor execution.
300 
301     uint256 size;
302     assembly {
303       size := extcodesize(account)
304     }
305     return size > 0;
306   }
307 
308   /**
309    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310    * `recipient`, forwarding all available gas and reverting on errors.
311    *
312    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313    * of certain opcodes, possibly making contracts go over the 2300 gas limit
314    * imposed by `transfer`, making them unable to receive funds via
315    * `transfer`. {sendValue} removes this limitation.
316    *
317    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318    *
319    * IMPORTANT: because control is transferred to `recipient`, care must be
320    * taken to not create reentrancy vulnerabilities. Consider using
321    * {ReentrancyGuard} or the
322    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323    */
324   function sendValue(address payable recipient, uint256 amount) internal {
325     require(address(this).balance >= amount, "Address: insufficient balance");
326 
327     (bool success, ) = recipient.call{ value: amount }("");
328     require(
329       success,
330       "Address: unable to send value, recipient may have reverted"
331     );
332   }
333 
334   /**
335    * @dev Performs a Solidity function call using a low level `call`. A
336    * plain `call` is an unsafe replacement for a function call: use this
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
416     (bool success, bytes memory returndata) = target.call{ value: value }(data);
417     return verifyCallResult(success, returndata, errorMessage);
418   }
419 
420   /**
421    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422    * but performing a static call.
423    *
424    * _Available since v3.3._
425    */
426   function functionStaticCall(address target, bytes memory data)
427     internal
428     view
429     returns (bytes memory)
430   {
431     return
432       functionStaticCall(target, data, "Address: low-level static call failed");
433   }
434 
435   /**
436    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437    * but performing a static call.
438    *
439    * _Available since v3.3._
440    */
441   function functionStaticCall(
442     address target,
443     bytes memory data,
444     string memory errorMessage
445   ) internal view returns (bytes memory) {
446     require(isContract(target), "Address: static call to non-contract");
447 
448     (bool success, bytes memory returndata) = target.staticcall(data);
449     return verifyCallResult(success, returndata, errorMessage);
450   }
451 
452   /**
453    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454    * but performing a delegate call.
455    *
456    * _Available since v3.4._
457    */
458   function functionDelegateCall(address target, bytes memory data)
459     internal
460     returns (bytes memory)
461   {
462     return
463       functionDelegateCall(
464         target,
465         data,
466         "Address: low-level delegate call failed"
467       );
468   }
469 
470   /**
471    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472    * but performing a delegate call.
473    *
474    * _Available since v3.4._
475    */
476   function functionDelegateCall(
477     address target,
478     bytes memory data,
479     string memory errorMessage
480   ) internal returns (bytes memory) {
481     require(isContract(target), "Address: delegate call to non-contract");
482 
483     (bool success, bytes memory returndata) = target.delegatecall(data);
484     return verifyCallResult(success, returndata, errorMessage);
485   }
486 
487   /**
488    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
489    * revert reason using the provided one.
490    *
491    * _Available since v4.3._
492    */
493   function verifyCallResult(
494     bool success,
495     bytes memory returndata,
496     string memory errorMessage
497   ) internal pure returns (bytes memory) {
498     if (success) {
499       return returndata;
500     } else {
501       // Look for revert reason and bubble it up if present
502       if (returndata.length > 0) {
503         // The easiest way to bubble the revert reason is using memory via assembly
504 
505         assembly {
506           let returndata_size := mload(returndata)
507           revert(add(32, returndata), returndata_size)
508         }
509       } else {
510         revert(errorMessage);
511       }
512     }
513   }
514 }
515 
516 // File: @openzeppelin/contracts/utils/Context.sol
517 
518 /**
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
534     return msg.data;
535   }
536 }
537 
538 // File: @openzeppelin/contracts/utils/Strings.sol
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
545 
546   /**
547    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
548    */
549   function toString(uint256 value) internal pure returns (string memory) {
550     // Inspired by OraclizeAPI's implementation - MIT licence
551     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
552 
553     if (value == 0) {
554       return "0";
555     }
556     uint256 temp = value;
557     uint256 digits;
558     while (temp != 0) {
559       digits++;
560       temp /= 10;
561     }
562     bytes memory buffer = new bytes(digits);
563     while (value != 0) {
564       digits -= 1;
565       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
566       value /= 10;
567     }
568     return string(buffer);
569   }
570 
571   /**
572    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
573    */
574   function toHexString(uint256 value) internal pure returns (string memory) {
575     if (value == 0) {
576       return "0x00";
577     }
578     uint256 temp = value;
579     uint256 length = 0;
580     while (temp != 0) {
581       length++;
582       temp >>= 8;
583     }
584     return toHexString(value, length);
585   }
586 
587   /**
588    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
589    */
590   function toHexString(uint256 value, uint256 length)
591     internal
592     pure
593     returns (string memory)
594   {
595     bytes memory buffer = new bytes(2 * length + 2);
596     buffer[0] = "0";
597     buffer[1] = "x";
598     for (uint256 i = 2 * length + 1; i > 1; --i) {
599       buffer[i] = _HEX_SYMBOLS[value & 0xf];
600       value >>= 4;
601     }
602     require(value == 0, "Strings: hex length insufficient");
603     return string(buffer);
604   }
605 }
606 
607 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
608 
609 /**
610  * @dev Implementation of the {IERC165} interface.
611  *
612  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
613  * for the additional interface id that will be supported. For example:
614  *
615  * ```solidity
616  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
618  * }
619  * ```
620  *
621  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
622  */
623 abstract contract ERC165 is IERC165 {
624   /**
625    * @dev See {IERC165-supportsInterface}.
626    */
627   function supportsInterface(bytes4 interfaceId)
628     public
629     view
630     virtual
631     override
632     returns (bool)
633   {
634     return interfaceId == type(IERC165).interfaceId;
635   }
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata extension, but not including the Enumerable extension, which is available separately as
643  * {ERC721Enumerable}.
644  */
645 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
646   using Address for address;
647   using Strings for uint256;
648 
649   // Token name
650   string private _name;
651 
652   // Token symbol
653   string private _symbol;
654 
655   // Mapping from token ID to owner address
656   mapping(uint256 => address) private _owners;
657 
658   // Mapping owner address to token count
659   mapping(address => uint256) private _balances;
660 
661   // Mapping from token ID to approved address
662   mapping(uint256 => address) private _tokenApprovals;
663 
664   // Mapping from owner to operator approvals
665   mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667   /**
668    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
669    */
670   constructor(string memory name_, string memory symbol_) {
671     _name = name_;
672     _symbol = symbol_;
673   }
674 
675   /**
676    * @dev See {IERC165-supportsInterface}.
677    */
678   function supportsInterface(bytes4 interfaceId)
679     public
680     view
681     virtual
682     override(ERC165, IERC165)
683     returns (bool)
684   {
685     return
686       interfaceId == type(IERC721).interfaceId ||
687       interfaceId == type(IERC721Metadata).interfaceId ||
688       super.supportsInterface(interfaceId);
689   }
690 
691   /**
692    * @dev See {IERC721-balanceOf}.
693    */
694   function balanceOf(address owner)
695     public
696     view
697     virtual
698     override
699     returns (uint256)
700   {
701     require(owner != address(0), "ERC721: balance query for the zero address");
702     return _balances[owner];
703   }
704 
705   /**
706    * @dev See {IERC721-ownerOf}.
707    */
708   function ownerOf(uint256 tokenId)
709     public
710     view
711     virtual
712     override
713     returns (address)
714   {
715     address owner = _owners[tokenId];
716     require(owner != address(0), "ERC721: owner query for nonexistent token");
717     return owner;
718   }
719 
720   /**
721    * @dev See {IERC721Metadata-name}.
722    */
723   function name() public view virtual override returns (string memory) {
724     return _name;
725   }
726 
727   /**
728    * @dev See {IERC721Metadata-symbol}.
729    */
730   function symbol() public view virtual override returns (string memory) {
731     return _symbol;
732   }
733 
734   /**
735    * @dev See {IERC721Metadata-tokenURI}.
736    */
737   function tokenURI(uint256 tokenId)
738     public
739     view
740     virtual
741     override
742     returns (string memory)
743   {
744     require(
745       _exists(tokenId),
746       "ERC721Metadata: URI query for nonexistent token"
747     );
748 
749     string memory baseURI = _baseURI();
750     return
751       bytes(baseURI).length > 0
752         ? string(abi.encodePacked(baseURI, tokenId.toString()))
753         : "";
754   }
755 
756   /**
757    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
758    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
759    * by default, can be overriden in child contracts.
760    */
761   function _baseURI() internal view virtual returns (string memory) {
762     return "";
763   }
764 
765   /**
766    * @dev See {IERC721-approve}.
767    */
768   function approve(address to, uint256 tokenId) public virtual override {
769     address owner = ERC721.ownerOf(tokenId);
770     require(to != owner, "ERC721: approval to current owner");
771 
772     require(
773       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
774       "ERC721: approve caller is not owner nor approved for all"
775     );
776 
777     _approve(to, tokenId);
778   }
779 
780   /**
781    * @dev See {IERC721-getApproved}.
782    */
783   function getApproved(uint256 tokenId)
784     public
785     view
786     virtual
787     override
788     returns (address)
789   {
790     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
791 
792     return _tokenApprovals[tokenId];
793   }
794 
795   /**
796    * @dev See {IERC721-setApprovalForAll}.
797    */
798   function setApprovalForAll(address operator, bool approved)
799     public
800     virtual
801     override
802   {
803     require(operator != _msgSender(), "ERC721: approve to caller");
804 
805     _operatorApprovals[_msgSender()][operator] = approved;
806     emit ApprovalForAll(_msgSender(), operator, approved);
807   }
808 
809   /**
810    * @dev See {IERC721-isApprovedForAll}.
811    */
812   function isApprovedForAll(address owner, address operator)
813     public
814     view
815     virtual
816     override
817     returns (bool)
818   {
819     return _operatorApprovals[owner][operator];
820   }
821 
822   /**
823    * @dev See {IERC721-transferFrom}.
824    */
825   function transferFrom(
826     address from,
827     address to,
828     uint256 tokenId
829   ) public virtual override {
830     //solhint-disable-next-line max-line-length
831     require(
832       _isApprovedOrOwner(_msgSender(), tokenId),
833       "ERC721: transfer caller is not owner nor approved"
834     );
835 
836     _transfer(from, to, tokenId);
837   }
838 
839   /**
840    * @dev See {IERC721-safeTransferFrom}.
841    */
842   function safeTransferFrom(
843     address from,
844     address to,
845     uint256 tokenId
846   ) public virtual override {
847     safeTransferFrom(from, to, tokenId, "");
848   }
849 
850   /**
851    * @dev See {IERC721-safeTransferFrom}.
852    */
853   function safeTransferFrom(
854     address from,
855     address to,
856     uint256 tokenId,
857     bytes memory _data
858   ) public virtual override {
859     require(
860       _isApprovedOrOwner(_msgSender(), tokenId),
861       "ERC721: transfer caller is not owner nor approved"
862     );
863     _safeTransfer(from, to, tokenId, _data);
864   }
865 
866   /**
867    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
868    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
869    *
870    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
871    *
872    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
873    * implement alternative mechanisms to perform token transfer, such as signature-based.
874    *
875    * Requirements:
876    *
877    * - `from` cannot be the zero address.
878    * - `to` cannot be the zero address.
879    * - `tokenId` token must exist and be owned by `from`.
880    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881    *
882    * Emits a {Transfer} event.
883    */
884   function _safeTransfer(
885     address from,
886     address to,
887     uint256 tokenId,
888     bytes memory _data
889   ) internal virtual {
890     _transfer(from, to, tokenId);
891     require(
892       _checkOnERC721Received(from, to, tokenId, _data),
893       "ERC721: transfer to non ERC721Receiver implementer"
894     );
895   }
896 
897   /**
898    * @dev Returns whether `tokenId` exists.
899    *
900    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901    *
902    * Tokens start existing when they are minted (`_mint`),
903    * and stop existing when they are burned (`_burn`).
904    */
905   function _exists(uint256 tokenId) internal view virtual returns (bool) {
906     return _owners[tokenId] != address(0);
907   }
908 
909   /**
910    * @dev Returns whether `spender` is allowed to manage `tokenId`.
911    *
912    * Requirements:
913    *
914    * - `tokenId` must exist.
915    */
916   function _isApprovedOrOwner(address spender, uint256 tokenId)
917     internal
918     view
919     virtual
920     returns (bool)
921   {
922     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
923     address owner = ERC721.ownerOf(tokenId);
924     return (spender == owner ||
925       getApproved(tokenId) == spender ||
926       isApprovedForAll(owner, spender));
927   }
928 
929   /**
930    * @dev Safely mints `tokenId` and transfers it to `to`.
931    *
932    * Requirements:
933    *
934    * - `tokenId` must not exist.
935    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936    *
937    * Emits a {Transfer} event.
938    */
939   function _safeMint(address to, uint256 tokenId) internal virtual {
940     _safeMint(to, tokenId, "");
941   }
942 
943   /**
944    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
945    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
946    */
947   function _safeMint(
948     address to,
949     uint256 tokenId,
950     bytes memory _data
951   ) internal virtual {
952     _mint(to, tokenId);
953     require(
954       _checkOnERC721Received(address(0), to, tokenId, _data),
955       "ERC721: transfer to non ERC721Receiver implementer"
956     );
957   }
958 
959   /**
960    * @dev Mints `tokenId` and transfers it to `to`.
961    *
962    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
963    *
964    * Requirements:
965    *
966    * - `tokenId` must not exist.
967    * - `to` cannot be the zero address.
968    *
969    * Emits a {Transfer} event.
970    */
971   function _mint(address to, uint256 tokenId) internal virtual {
972     require(to != address(0), "ERC721: mint to the zero address");
973     require(!_exists(tokenId), "ERC721: token already minted");
974 
975     _beforeTokenTransfer(address(0), to, tokenId);
976 
977     _balances[to] += 1;
978     _owners[tokenId] = to;
979 
980     emit Transfer(address(0), to, tokenId);
981   }
982 
983   /**
984    * @dev Destroys `tokenId`.
985    * The approval is cleared when the token is burned.
986    *
987    * Requirements:
988    *
989    * - `tokenId` must exist.
990    *
991    * Emits a {Transfer} event.
992    */
993   function _burn(uint256 tokenId) internal virtual {
994     address owner = ERC721.ownerOf(tokenId);
995 
996     _beforeTokenTransfer(owner, address(0), tokenId);
997 
998     // Clear approvals
999     _approve(address(0), tokenId);
1000 
1001     _balances[owner] -= 1;
1002     delete _owners[tokenId];
1003 
1004     emit Transfer(owner, address(0), tokenId);
1005   }
1006 
1007   /**
1008    * @dev Transfers `tokenId` from `from` to `to`.
1009    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1010    *
1011    * Requirements:
1012    *
1013    * - `to` cannot be the zero address.
1014    * - `tokenId` token must be owned by `from`.
1015    *
1016    * Emits a {Transfer} event.
1017    */
1018   function _transfer(
1019     address from,
1020     address to,
1021     uint256 tokenId
1022   ) internal virtual {
1023     require(
1024       ERC721.ownerOf(tokenId) == from,
1025       "ERC721: transfer of token that is not own"
1026     );
1027     require(to != address(0), "ERC721: transfer to the zero address");
1028 
1029     _beforeTokenTransfer(from, to, tokenId);
1030 
1031     // Clear approvals from the previous owner
1032     _approve(address(0), tokenId);
1033 
1034     _balances[from] -= 1;
1035     _balances[to] += 1;
1036     _owners[tokenId] = to;
1037 
1038     emit Transfer(from, to, tokenId);
1039   }
1040 
1041   /**
1042    * @dev Approve `to` to operate on `tokenId`
1043    *
1044    * Emits a {Approval} event.
1045    */
1046   function _approve(address to, uint256 tokenId) internal virtual {
1047     _tokenApprovals[tokenId] = to;
1048     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1049   }
1050 
1051   /**
1052    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1053    * The call is not executed if the target address is not a contract.
1054    *
1055    * @param from address representing the previous owner of the given token ID
1056    * @param to target address that will receive the tokens
1057    * @param tokenId uint256 ID of the token to be transferred
1058    * @param _data bytes optional data to send along with the call
1059    * @return bool whether the call correctly returned the expected magic value
1060    */
1061   function _checkOnERC721Received(
1062     address from,
1063     address to,
1064     uint256 tokenId,
1065     bytes memory _data
1066   ) private returns (bool) {
1067     if (to.isContract()) {
1068       try
1069         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1070       returns (bytes4 retval) {
1071         return retval == IERC721Receiver.onERC721Received.selector;
1072       } catch (bytes memory reason) {
1073         if (reason.length == 0) {
1074           revert("ERC721: transfer to non ERC721Receiver implementer");
1075         } else {
1076           assembly {
1077             revert(add(32, reason), mload(reason))
1078           }
1079         }
1080       }
1081     } else {
1082       return true;
1083     }
1084   }
1085 
1086   /**
1087    * @dev Hook that is called before any token transfer. This includes minting
1088    * and burning.
1089    *
1090    * Calling conditions:
1091    *
1092    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093    * transferred to `to`.
1094    * - When `from` is zero, `tokenId` will be minted for `to`.
1095    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096    * - `from` and `to` are never both zero.
1097    *
1098    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099    */
1100   function _beforeTokenTransfer(
1101     address from,
1102     address to,
1103     uint256 tokenId
1104   ) internal virtual {}
1105 }
1106 
1107 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1108 
1109 /**
1110  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1111  * @dev See https://eips.ethereum.org/EIPS/eip-721
1112  */
1113 interface IERC721Enumerable is IERC721 {
1114   /**
1115    * @dev Returns the total amount of tokens stored by the contract.
1116    */
1117   function totalSupply() external view returns (uint256);
1118 
1119   /**
1120    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1121    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1122    */
1123   function tokenOfOwnerByIndex(address owner, uint256 index)
1124     external
1125     view
1126     returns (uint256 tokenId);
1127 
1128   /**
1129    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1130    * Use along with {totalSupply} to enumerate all tokens.
1131    */
1132   function tokenByIndex(uint256 index) external view returns (uint256);
1133 }
1134 
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1136 
1137 /**
1138  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1139  * enumerability of all the token ids in the contract as well as all token ids owned by each
1140  * account.
1141  */
1142 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1143   // Mapping from owner to list of owned token IDs
1144   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1145 
1146   // Mapping from token ID to index of the owner tokens list
1147   mapping(uint256 => uint256) private _ownedTokensIndex;
1148 
1149   // Array with all token ids, used for enumeration
1150   uint256[] private _allTokens;
1151 
1152   // Mapping from token id to position in the allTokens array
1153   mapping(uint256 => uint256) private _allTokensIndex;
1154 
1155   /**
1156    * @dev See {IERC165-supportsInterface}.
1157    */
1158   function supportsInterface(bytes4 interfaceId)
1159     public
1160     view
1161     virtual
1162     override(IERC165, ERC721)
1163     returns (bool)
1164   {
1165     return
1166       interfaceId == type(IERC721Enumerable).interfaceId ||
1167       super.supportsInterface(interfaceId);
1168   }
1169 
1170   /**
1171    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1172    */
1173   function tokenOfOwnerByIndex(address owner, uint256 index)
1174     public
1175     view
1176     virtual
1177     override
1178     returns (uint256)
1179   {
1180     require(
1181       index < ERC721.balanceOf(owner),
1182       "ERC721Enumerable: owner index out of bounds"
1183     );
1184     return _ownedTokens[owner][index];
1185   }
1186 
1187   /**
1188    * @dev See {IERC721Enumerable-totalSupply}.
1189    */
1190   function totalSupply() public view virtual override returns (uint256) {
1191     return _allTokens.length;
1192   }
1193 
1194   /**
1195    * @dev See {IERC721Enumerable-tokenByIndex}.
1196    */
1197   function tokenByIndex(uint256 index)
1198     public
1199     view
1200     virtual
1201     override
1202     returns (uint256)
1203   {
1204     require(
1205       index < ERC721Enumerable.totalSupply(),
1206       "ERC721Enumerable: global index out of bounds"
1207     );
1208     return _allTokens[index];
1209   }
1210 
1211   /**
1212    * @dev Hook that is called before any token transfer. This includes minting
1213    * and burning.
1214    *
1215    * Calling conditions:
1216    *
1217    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1218    * transferred to `to`.
1219    * - When `from` is zero, `tokenId` will be minted for `to`.
1220    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1221    * - `from` cannot be the zero address.
1222    * - `to` cannot be the zero address.
1223    *
1224    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1225    */
1226   function _beforeTokenTransfer(
1227     address from,
1228     address to,
1229     uint256 tokenId
1230   ) internal virtual override {
1231     super._beforeTokenTransfer(from, to, tokenId);
1232 
1233     if (from == address(0)) {
1234       _addTokenToAllTokensEnumeration(tokenId);
1235     } else if (from != to) {
1236       _removeTokenFromOwnerEnumeration(from, tokenId);
1237     }
1238     if (to == address(0)) {
1239       _removeTokenFromAllTokensEnumeration(tokenId);
1240     } else if (to != from) {
1241       _addTokenToOwnerEnumeration(to, tokenId);
1242     }
1243   }
1244 
1245   /**
1246    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1247    * @param to address representing the new owner of the given token ID
1248    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1249    */
1250   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1251     uint256 length = ERC721.balanceOf(to);
1252     _ownedTokens[to][length] = tokenId;
1253     _ownedTokensIndex[tokenId] = length;
1254   }
1255 
1256   /**
1257    * @dev Private function to add a token to this extension's token tracking data structures.
1258    * @param tokenId uint256 ID of the token to be added to the tokens list
1259    */
1260   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1261     _allTokensIndex[tokenId] = _allTokens.length;
1262     _allTokens.push(tokenId);
1263   }
1264 
1265   /**
1266    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1267    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1268    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1269    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1270    * @param from address representing the previous owner of the given token ID
1271    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1272    */
1273   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1274     private
1275   {
1276     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1277     // then delete the last slot (swap and pop).
1278 
1279     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1280     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1281 
1282     // When the token to delete is the last token, the swap operation is unnecessary
1283     if (tokenIndex != lastTokenIndex) {
1284       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1285 
1286       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1287       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1288     }
1289 
1290     // This also deletes the contents at the last position of the array
1291     delete _ownedTokensIndex[tokenId];
1292     delete _ownedTokens[from][lastTokenIndex];
1293   }
1294 
1295   /**
1296    * @dev Private function to remove a token from this extension's token tracking data structures.
1297    * This has O(1) time complexity, but alters the order of the _allTokens array.
1298    * @param tokenId uint256 ID of the token to be removed from the tokens list
1299    */
1300   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1301     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1302     // then delete the last slot (swap and pop).
1303 
1304     uint256 lastTokenIndex = _allTokens.length - 1;
1305     uint256 tokenIndex = _allTokensIndex[tokenId];
1306 
1307     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1308     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1309     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1310     uint256 lastTokenId = _allTokens[lastTokenIndex];
1311 
1312     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1313     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1314 
1315     // This also deletes the contents at the last position of the array
1316     delete _allTokensIndex[tokenId];
1317     _allTokens.pop();
1318   }
1319 }
1320 
1321 // File: @openzeppelin/contracts/access/Ownable.sol
1322 
1323 /**
1324  * @dev Contract module which provides a basic access control mechanism, where
1325  * there is an account (an owner) that can be granted exclusive access to
1326  * specific functions.
1327  *
1328  * By default, the owner account will be the one that deploys the contract. This
1329  * can later be changed with {transferOwnership}.
1330  *
1331  * This module is used through inheritance. It will make available the modifier
1332  * `onlyOwner`, which can be applied to your functions to restrict their use to
1333  * the owner.
1334  */
1335 abstract contract Ownable is Context {
1336   address private _owner;
1337 
1338   event OwnershipTransferred(
1339     address indexed previousOwner,
1340     address indexed newOwner
1341   );
1342 
1343   /**
1344    * @dev Initializes the contract setting the deployer as the initial owner.
1345    */
1346   constructor() {
1347     _setOwner(_msgSender());
1348   }
1349 
1350   /**
1351    * @dev Returns the address of the current owner.
1352    */
1353   function owner() public view virtual returns (address) {
1354     return _owner;
1355   }
1356 
1357   /**
1358    * @dev Throws if called by any account other than the owner.
1359    */
1360   modifier onlyOwner() {
1361     require(owner() == _msgSender(), "Ownable: caller is not the owner");
1362     _;
1363   }
1364 
1365   /**
1366    * @dev Leaves the contract without owner. It will not be possible to call
1367    * `onlyOwner` functions anymore. Can only be called by the current owner.
1368    *
1369    * NOTE: Renouncing ownership will leave the contract without an owner,
1370    * thereby removing any functionality that is only available to the owner.
1371    */
1372   function renounceOwnership() public virtual onlyOwner {
1373     _setOwner(address(0));
1374   }
1375 
1376   /**
1377    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1378    * Can only be called by the current owner.
1379    */
1380   function transferOwnership(address newOwner) public virtual onlyOwner {
1381     require(newOwner != address(0), "Ownable: new owner is the zero address");
1382     _setOwner(newOwner);
1383   }
1384 
1385   function _setOwner(address newOwner) private {
1386     address oldOwner = _owner;
1387     _owner = newOwner;
1388     emit OwnershipTransferred(oldOwner, newOwner);
1389   }
1390 }
1391 
1392 // File: contracts/LilGlyphs.sol
1393 
1394 pragma solidity >=0.4.22 <0.9.0;
1395 
1396 contract LilGlyphs is ERC721Enumerable, Ownable {
1397   ERC721 pxg;
1398   bytes32 public root;
1399 
1400   constructor(address pixelglyphs) ERC721("Lil' Glyphs", "LxG") {
1401     pxg = ERC721(pixelglyphs);
1402   }
1403 
1404   function toString(uint256 value) internal pure returns (string memory) {
1405     // Inspired by OraclizeAPI's implementation - MIT licence
1406     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1407 
1408     if (value == 0) {
1409       return "0";
1410     }
1411     uint256 temp = value;
1412     uint256 digits;
1413     while (temp != 0) {
1414       digits++;
1415       temp /= 10;
1416     }
1417     bytes memory buffer = new bytes(digits);
1418     while (value != 0) {
1419       digits -= 1;
1420       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1421       value /= 10;
1422     }
1423     return string(buffer);
1424   }
1425 
1426   function verify(bytes32[] memory proof, bytes32 leaf)
1427     public
1428     view
1429     returns (bool)
1430   {
1431     return MerkleProof.verify(proof, root, leaf);
1432   }
1433 
1434   function setRoot(bytes32 _root) public onlyOwner {
1435     root = _root;
1436   }
1437 
1438   function setBoolean(
1439     uint256 _packedBools,
1440     uint256 _boolNumber,
1441     uint256 _value
1442   ) public pure returns (uint256) {
1443     if (_value == 1) return _packedBools | (uint256(1) << _boolNumber);
1444     else return _packedBools & ~(uint256(1) << _boolNumber);
1445   }
1446 
1447   function getBoolean(uint256 _packedBools, uint256 _boolNumber)
1448     public
1449     pure
1450     returns (uint256)
1451   {
1452     uint256 flag = (_packedBools >> _boolNumber) & uint256(1);
1453     return flag;
1454   }
1455 
1456   mapping(uint256 => uint256) public bigGlyphToLilGlyph;
1457 
1458   function mint(
1459     uint256 bigGlyph,
1460     uint256 lilGlyph,
1461     bytes32[] memory proof
1462   ) public {
1463     require(pxg.ownerOf(bigGlyph) == msg.sender, "2");
1464     require(bigGlyphToLilGlyph[bigGlyph] == 0, "3");
1465     require(
1466       verify(proof, keccak256(abi.encodePacked(bigGlyph, lilGlyph))),
1467       "4"
1468     );
1469     bigGlyphToLilGlyph[bigGlyph] = lilGlyph;
1470     _safeMint(msg.sender, lilGlyph);
1471   }
1472 
1473   function countNeighbors(
1474     uint256 id,
1475     uint256 idx,
1476     uint256 index
1477   ) internal pure returns (uint256) {
1478     uint256 top = idx >= 5 ? getBoolean(id, idx - 5) : 0;
1479     uint256 bottom = idx <= 44 ? getBoolean(id, idx + 5) : 0;
1480     uint256 left = idx > 0 && index != 0 ? getBoolean(id, idx - 1) : 0;
1481     uint256 right = idx < 49 && index != 4 ? getBoolean(id, idx + 1) : 0;
1482     return top + bottom + left + right;
1483   }
1484 
1485   function getSvg(uint256 tokenId) public view returns (string memory) {
1486     require(_exists(tokenId), "1");
1487     uint256 ppd = 5;
1488     string memory svg;
1489     for (uint256 i = 0; i < 50; i++) {
1490       uint256 x = (i - ((i / 5) * 5));
1491       if (getBoolean(tokenId, i) == 1) {
1492         string memory rect = string(
1493           abi.encodePacked(
1494             '<rect x="',
1495             toString(x * ppd),
1496             '" y="',
1497             toString((i / 5) * ppd),
1498             '" width="5" height="5" style="fill: #FFF"></rect>'
1499           )
1500         );
1501         svg = string(abi.encodePacked(svg, rect));
1502       } else if (countNeighbors(tokenId, i, x) > 0) {
1503         string memory rect = string(
1504           abi.encodePacked(
1505             '<rect x="',
1506             toString(x * ppd),
1507             '" y="',
1508             toString((i / 5) * ppd),
1509             '" width="5" height="5" style="fill: #000"></rect>'
1510           )
1511         );
1512         string memory rectFlip = string(
1513           abi.encodePacked(
1514             '<rect data-id="',
1515             toString(i),
1516             '" x="',
1517             toString((10 - x - 1) * ppd),
1518             '" y="',
1519             toString((i / 5) * ppd),
1520             '" width="5" height="5" style="fill: #000"></rect>'
1521           )
1522         );
1523 
1524         svg = string(abi.encodePacked(svg, rect, rectFlip));
1525       } else {
1526         continue;
1527       }
1528     }
1529     return
1530       string(
1531         abi.encodePacked(
1532           '<svg version="1.1" width="500" height="500" xmlns="http://www.w3.org/2000/svg"><g transform="translate(225 225)">',
1533           svg,
1534           "</g></svg>"
1535         )
1536       );
1537   }
1538 
1539   function tokenURI(uint256 tokenId)
1540     public
1541     view
1542     override
1543     returns (string memory)
1544   {
1545     require(_exists(tokenId), "1");
1546     string memory json = Base64.encode(
1547       bytes(
1548         string(
1549           abi.encodePacked(
1550             '{"name": "Lil\' Glyph #',
1551             toString(tokenId),
1552             '", "description": "Fully on-chain little Pixelglyphs.", "image": "data:image/svg+xml;base64,',
1553             Base64.encode(bytes(getSvg(tokenId))),
1554             '"}'
1555           )
1556         )
1557       )
1558     );
1559     return string(abi.encodePacked("data:application/json;base64,", json));
1560   }
1561 
1562   function getMatrixFromTokenId(uint256 tokenId)
1563     public
1564     view
1565     returns (uint256[5][10] memory output)
1566   {
1567     require(_exists(tokenId), "1");
1568     for (uint256 i = 0; i < 50; i++) {
1569       output[i / 5][(i - ((i / 5) * 5))] = getBoolean(tokenId, i);
1570     }
1571   }
1572 
1573   function getTokenIdFromMatrix(uint256[5][10] calldata matrix)
1574     public
1575     pure
1576     returns (uint256)
1577   {
1578     uint256 tokenId;
1579     for (uint256 i = 0; i < matrix.length; i++) {
1580       for (uint256 j = 0; j < matrix[i].length; j++) {
1581         tokenId = setBoolean(tokenId, j + i * 5, matrix[i][j]);
1582       }
1583     }
1584     return tokenId;
1585   }
1586 }
1587 
1588 /*
1589   Error codes:
1590   ------------
1591   1: Token ID does not exist
1592   2: Sender does not own Pixelglyph to be claimed
1593   3: Glyph already claimed
1594   4: Leaf not part of tree
1595 */
1596 
1597 library Base64 {
1598   bytes internal constant TABLE =
1599     "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1600 
1601   /// @notice Encodes some bytes to the base64 representation
1602   function encode(bytes memory data) internal pure returns (string memory) {
1603     uint256 len = data.length;
1604     if (len == 0) return "";
1605 
1606     // multiply by 4/3 rounded up
1607     uint256 encodedLen = 4 * ((len + 2) / 3);
1608 
1609     // Add some extra buffer at the end
1610     bytes memory result = new bytes(encodedLen + 32);
1611 
1612     bytes memory table = TABLE;
1613 
1614     assembly {
1615       let tablePtr := add(table, 1)
1616       let resultPtr := add(result, 32)
1617 
1618       for {
1619         let i := 0
1620       } lt(i, len) {
1621 
1622       } {
1623         i := add(i, 3)
1624         let input := and(mload(add(data, i)), 0xffffff)
1625 
1626         let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1627         out := shl(8, out)
1628         out := add(
1629           out,
1630           and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1631         )
1632         out := shl(8, out)
1633         out := add(
1634           out,
1635           and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1636         )
1637         out := shl(8, out)
1638         out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1639         out := shl(224, out)
1640 
1641         mstore(resultPtr, out)
1642 
1643         resultPtr := add(resultPtr, 4)
1644       }
1645 
1646       switch mod(len, 3)
1647       case 1 {
1648         mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1649       }
1650       case 2 {
1651         mstore(sub(resultPtr, 1), shl(248, 0x3d))
1652       }
1653 
1654       mstore(result, encodedLen)
1655     }
1656 
1657     return string(result);
1658   }
1659 }