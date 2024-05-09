1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
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
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
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
39   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41   /**
42    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43    */
44   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46   /**
47    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48    */
49   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51   /**
52    * @dev Returns the number of tokens in ``owner``'s account.
53    */
54   function balanceOf(address owner) external view returns (uint256 balance);
55 
56   /**
57    * @dev Returns the owner of the `tokenId` token.
58    *
59    * Requirements:
60    *
61    * - `tokenId` must exist.
62    */
63   function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65   /**
66    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68    *
69    * Requirements:
70    *
71    * - `from` cannot be the zero address.
72    * - `to` cannot be the zero address.
73    * - `tokenId` token must exist and be owned by `from`.
74    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76    *
77    * Emits a {Transfer} event.
78    */
79   function safeTransferFrom(
80     address from,
81     address to,
82     uint256 tokenId
83   ) external;
84 
85   /**
86    * @dev Transfers `tokenId` token from `from` to `to`.
87    *
88    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89    *
90    * Requirements:
91    *
92    * - `from` cannot be the zero address.
93    * - `to` cannot be the zero address.
94    * - `tokenId` token must be owned by `from`.
95    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96    *
97    * Emits a {Transfer} event.
98    */
99   function transferFrom(
100     address from,
101     address to,
102     uint256 tokenId
103   ) external;
104 
105   /**
106    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107    * The approval is cleared when the token is transferred.
108    *
109    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110    *
111    * Requirements:
112    *
113    * - The caller must own the token or be an approved operator.
114    * - `tokenId` must exist.
115    *
116    * Emits an {Approval} event.
117    */
118   function approve(address to, uint256 tokenId) external;
119 
120   /**
121    * @dev Returns the account approved for `tokenId` token.
122    *
123    * Requirements:
124    *
125    * - `tokenId` must exist.
126    */
127   function getApproved(uint256 tokenId) external view returns (address operator);
128 
129   /**
130    * @dev Approve or remove `operator` as an operator for the caller.
131    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132    *
133    * Requirements:
134    *
135    * - The `operator` cannot be the caller.
136    *
137    * Emits an {ApprovalForAll} event.
138    */
139   function setApprovalForAll(address operator, bool _approved) external;
140 
141   /**
142    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143    *
144    * See {setApprovalForAll}
145    */
146   function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148   /**
149    * @dev Safely transfers `tokenId` token from `from` to `to`.
150    *
151    * Requirements:
152    *
153    * - `from` cannot be the zero address.
154    * - `to` cannot be the zero address.
155    * - `tokenId` token must exist and be owned by `from`.
156    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158    *
159    * Emits a {Transfer} event.
160    */
161   function safeTransferFrom(
162     address from,
163     address to,
164     uint256 tokenId,
165     bytes calldata data
166   ) external;
167 }
168 
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 interface IERC721Receiver {
179   /**
180    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
181    * by `operator` from `from`, this function is called.
182    *
183    * It must return its Solidity selector to confirm the token transfer.
184    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
185    *
186    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
187    */
188   function onERC721Received(
189     address operator,
190     address from,
191     uint256 tokenId,
192     bytes calldata data
193   ) external returns (bytes4);
194 }
195 
196 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205   /**
206    * @dev Returns the token collection name.
207    */
208   function name() external view returns (string memory);
209 
210   /**
211    * @dev Returns the token collection symbol.
212    */
213   function symbol() external view returns (string memory);
214 
215   /**
216    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217    */
218   function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Collection of functions related to the address type
227  */
228 library Address {
229   /**
230    * @dev Returns true if `account` is a contract.
231    *
232    * [IMPORTANT]
233    * ====
234    * It is unsafe to assume that an address for which this function returns
235    * false is an externally-owned account (EOA) and not a contract.
236    *
237    * Among others, `isContract` will return false for the following
238    * types of addresses:
239    *
240    *  - an externally-owned account
241    *  - a contract in construction
242    *  - an address where a contract will be created
243    *  - an address where a contract lived, but was destroyed
244    * ====
245    */
246   function isContract(address account) internal view returns (bool) {
247     // This method relies on extcodesize, which returns 0 for contracts in
248     // construction, since the code is only stored at the end of the
249     // constructor execution.
250 
251     uint256 size;
252     assembly {
253       size := extcodesize(account)
254     }
255     return size > 0;
256   }
257 
258   /**
259    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260    * `recipient`, forwarding all available gas and reverting on errors.
261    *
262    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263    * of certain opcodes, possibly making contracts go over the 2300 gas limit
264    * imposed by `transfer`, making them unable to receive funds via
265    * `transfer`. {sendValue} removes this limitation.
266    *
267    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268    *
269    * IMPORTANT: because control is transferred to `recipient`, care must be
270    * taken to not create reentrancy vulnerabilities. Consider using
271    * {ReentrancyGuard} or the
272    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273    */
274   function sendValue(address payable recipient, uint256 amount) internal {
275     require(address(this).balance >= amount, 'Address: insufficient balance');
276 
277     (bool success, ) = recipient.call{value: amount}('');
278     require(success, 'Address: unable to send value, recipient may have reverted');
279   }
280 
281   /**
282    * @dev Performs a Solidity function call using a low level `call`. A
283    * plain `call` is an unsafe replacement for a function call: use this
284    * function instead.
285    *
286    * If `target` reverts with a revert reason, it is bubbled up by this
287    * function (like regular Solidity function calls).
288    *
289    * Returns the raw returned data. To convert to the expected return value,
290    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
291    *
292    * Requirements:
293    *
294    * - `target` must be a contract.
295    * - calling `target` with `data` must not revert.
296    *
297    * _Available since v3.1._
298    */
299   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
300     return functionCall(target, data, 'Address: low-level call failed');
301   }
302 
303   /**
304    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
305    * `errorMessage` as a fallback revert reason when `target` reverts.
306    *
307    * _Available since v3.1._
308    */
309   function functionCall(
310     address target,
311     bytes memory data,
312     string memory errorMessage
313   ) internal returns (bytes memory) {
314     return functionCallWithValue(target, data, 0, errorMessage);
315   }
316 
317   /**
318    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319    * but also transferring `value` wei to `target`.
320    *
321    * Requirements:
322    *
323    * - the calling contract must have an ETH balance of at least `value`.
324    * - the called Solidity function must be `payable`.
325    *
326    * _Available since v3.1._
327    */
328   function functionCallWithValue(
329     address target,
330     bytes memory data,
331     uint256 value
332   ) internal returns (bytes memory) {
333     return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
334   }
335 
336   /**
337    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338    * with `errorMessage` as a fallback revert reason when `target` reverts.
339    *
340    * _Available since v3.1._
341    */
342   function functionCallWithValue(
343     address target,
344     bytes memory data,
345     uint256 value,
346     string memory errorMessage
347   ) internal returns (bytes memory) {
348     require(address(this).balance >= value, 'Address: insufficient balance for call');
349     require(isContract(target), 'Address: call to non-contract');
350 
351     (bool success, bytes memory returndata) = target.call{value: value}(data);
352     return verifyCallResult(success, returndata, errorMessage);
353   }
354 
355   /**
356    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357    * but performing a static call.
358    *
359    * _Available since v3.3._
360    */
361   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
362     return functionStaticCall(target, data, 'Address: low-level static call failed');
363   }
364 
365   /**
366    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367    * but performing a static call.
368    *
369    * _Available since v3.3._
370    */
371   function functionStaticCall(
372     address target,
373     bytes memory data,
374     string memory errorMessage
375   ) internal view returns (bytes memory) {
376     require(isContract(target), 'Address: static call to non-contract');
377 
378     (bool success, bytes memory returndata) = target.staticcall(data);
379     return verifyCallResult(success, returndata, errorMessage);
380   }
381 
382   /**
383    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384    * but performing a delegate call.
385    *
386    * _Available since v3.4._
387    */
388   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
389     return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
390   }
391 
392   /**
393    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394    * but performing a delegate call.
395    *
396    * _Available since v3.4._
397    */
398   function functionDelegateCall(
399     address target,
400     bytes memory data,
401     string memory errorMessage
402   ) internal returns (bytes memory) {
403     require(isContract(target), 'Address: delegate call to non-contract');
404 
405     (bool success, bytes memory returndata) = target.delegatecall(data);
406     return verifyCallResult(success, returndata, errorMessage);
407   }
408 
409   /**
410    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
411    * revert reason using the provided one.
412    *
413    * _Available since v4.3._
414    */
415   function verifyCallResult(
416     bool success,
417     bytes memory returndata,
418     string memory errorMessage
419   ) internal pure returns (bytes memory) {
420     if (success) {
421       return returndata;
422     } else {
423       // Look for revert reason and bubble it up if present
424       if (returndata.length > 0) {
425         // The easiest way to bubble the revert reason is using memory via assembly
426 
427         assembly {
428           let returndata_size := mload(returndata)
429           revert(add(32, returndata), returndata_size)
430         }
431       } else {
432         revert(errorMessage);
433       }
434     }
435   }
436 }
437 
438 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453   function _msgSender() internal view virtual returns (address) {
454     return msg.sender;
455   }
456 
457   function _msgData() internal view virtual returns (bytes calldata) {
458     return msg.data;
459   }
460 }
461 
462 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev String operations.
468  */
469 library Strings {
470   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
471 
472   /**
473    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
474    */
475   function toString(uint256 value) internal pure returns (string memory) {
476     // Inspired by OraclizeAPI's implementation - MIT licence
477     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
478 
479     if (value == 0) {
480       return '0';
481     }
482     uint256 temp = value;
483     uint256 digits;
484     while (temp != 0) {
485       digits++;
486       temp /= 10;
487     }
488     bytes memory buffer = new bytes(digits);
489     while (value != 0) {
490       digits -= 1;
491       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
492       value /= 10;
493     }
494     return string(buffer);
495   }
496 
497   /**
498    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
499    */
500   function toHexString(uint256 value) internal pure returns (string memory) {
501     if (value == 0) {
502       return '0x00';
503     }
504     uint256 temp = value;
505     uint256 length = 0;
506     while (temp != 0) {
507       length++;
508       temp >>= 8;
509     }
510     return toHexString(value, length);
511   }
512 
513   /**
514    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
515    */
516   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
517     bytes memory buffer = new bytes(2 * length + 2);
518     buffer[0] = '0';
519     buffer[1] = 'x';
520     for (uint256 i = 2 * length + 1; i > 1; --i) {
521       buffer[i] = _HEX_SYMBOLS[value & 0xf];
522       value >>= 4;
523     }
524     require(value == 0, 'Strings: hex length insufficient');
525     return string(buffer);
526   }
527 }
528 
529 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548   /**
549    * @dev See {IERC165-supportsInterface}.
550    */
551   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552     return interfaceId == type(IERC165).interfaceId;
553   }
554 }
555 
556 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
562  * the Metadata extension, but not including the Enumerable extension, which is available separately as
563  * {ERC721Enumerable}.
564  */
565 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
566   using Address for address;
567   using Strings for uint256;
568 
569   // Token name
570   string private _name;
571 
572   // Token symbol
573   string private _symbol;
574 
575   // Mapping from token ID to owner address
576   mapping(uint256 => address) private _owners;
577 
578   // Mapping owner address to token count
579   mapping(address => uint256) private _balances;
580 
581   // Mapping from token ID to approved address
582   mapping(uint256 => address) private _tokenApprovals;
583 
584   // Mapping from owner to operator approvals
585   mapping(address => mapping(address => bool)) private _operatorApprovals;
586 
587   /**
588    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
589    */
590   constructor(string memory name_, string memory symbol_) {
591     _name = name_;
592     _symbol = symbol_;
593   }
594 
595   /**
596    * @dev See {IERC165-supportsInterface}.
597    */
598   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
599     return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
600   }
601 
602   /**
603    * @dev See {IERC721-balanceOf}.
604    */
605   function balanceOf(address owner) public view virtual override returns (uint256) {
606     require(owner != address(0), 'ERC721: balance query for the zero address');
607     return _balances[owner];
608   }
609 
610   /**
611    * @dev See {IERC721-ownerOf}.
612    */
613   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
614     address owner = _owners[tokenId];
615     require(owner != address(0), 'ERC721: owner query for nonexistent token');
616     return owner;
617   }
618 
619   /**
620    * @dev See {IERC721Metadata-name}.
621    */
622   function name() public view virtual override returns (string memory) {
623     return _name;
624   }
625 
626   /**
627    * @dev See {IERC721Metadata-symbol}.
628    */
629   function symbol() public view virtual override returns (string memory) {
630     return _symbol;
631   }
632 
633   /**
634    * @dev See {IERC721Metadata-tokenURI}.
635    */
636   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
637     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
638 
639     string memory baseURI = _baseURI();
640     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
641   }
642 
643   /**
644    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
645    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
646    * by default, can be overriden in child contracts.
647    */
648   function _baseURI() internal view virtual returns (string memory) {
649     return '';
650   }
651 
652   /**
653    * @dev See {IERC721-approve}.
654    */
655   function approve(address to, uint256 tokenId) public virtual override {
656     address owner = ERC721.ownerOf(tokenId);
657     require(to != owner, 'ERC721: approval to current owner');
658 
659     require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
660 
661     _approve(to, tokenId);
662   }
663 
664   /**
665    * @dev See {IERC721-getApproved}.
666    */
667   function getApproved(uint256 tokenId) public view virtual override returns (address) {
668     require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
669 
670     return _tokenApprovals[tokenId];
671   }
672 
673   /**
674    * @dev See {IERC721-setApprovalForAll}.
675    */
676   function setApprovalForAll(address operator, bool approved) public virtual override {
677     require(operator != _msgSender(), 'ERC721: approve to caller');
678 
679     _operatorApprovals[_msgSender()][operator] = approved;
680     emit ApprovalForAll(_msgSender(), operator, approved);
681   }
682 
683   /**
684    * @dev See {IERC721-isApprovedForAll}.
685    */
686   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
687     return _operatorApprovals[owner][operator];
688   }
689 
690   /**
691    * @dev See {IERC721-transferFrom}.
692    */
693   function transferFrom(
694     address from,
695     address to,
696     uint256 tokenId
697   ) public virtual override {
698     //solhint-disable-next-line max-line-length
699     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
700 
701     _transfer(from, to, tokenId);
702   }
703 
704   /**
705    * @dev See {IERC721-safeTransferFrom}.
706    */
707   function safeTransferFrom(
708     address from,
709     address to,
710     uint256 tokenId
711   ) public virtual override {
712     safeTransferFrom(from, to, tokenId, '');
713   }
714 
715   /**
716    * @dev See {IERC721-safeTransferFrom}.
717    */
718   function safeTransferFrom(
719     address from,
720     address to,
721     uint256 tokenId,
722     bytes memory _data
723   ) public virtual override {
724     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
725     _safeTransfer(from, to, tokenId, _data);
726   }
727 
728   /**
729    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731    *
732    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
733    *
734    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
735    * implement alternative mechanisms to perform token transfer, such as signature-based.
736    *
737    * Requirements:
738    *
739    * - `from` cannot be the zero address.
740    * - `to` cannot be the zero address.
741    * - `tokenId` token must exist and be owned by `from`.
742    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743    *
744    * Emits a {Transfer} event.
745    */
746   function _safeTransfer(
747     address from,
748     address to,
749     uint256 tokenId,
750     bytes memory _data
751   ) internal virtual {
752     _transfer(from, to, tokenId);
753     require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
754   }
755 
756   /**
757    * @dev Returns whether `tokenId` exists.
758    *
759    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
760    *
761    * Tokens start existing when they are minted (`_mint`),
762    * and stop existing when they are burned (`_burn`).
763    */
764   function _exists(uint256 tokenId) internal view virtual returns (bool) {
765     return _owners[tokenId] != address(0);
766   }
767 
768   /**
769    * @dev Returns whether `spender` is allowed to manage `tokenId`.
770    *
771    * Requirements:
772    *
773    * - `tokenId` must exist.
774    */
775   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
776     require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
777     address owner = ERC721.ownerOf(tokenId);
778     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
779   }
780 
781   /**
782    * @dev Safely mints `tokenId` and transfers it to `to`.
783    *
784    * Requirements:
785    *
786    * - `tokenId` must not exist.
787    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788    *
789    * Emits a {Transfer} event.
790    */
791   function _safeMint(address to, uint256 tokenId) internal virtual {
792     _safeMint(to, tokenId, '');
793   }
794 
795   /**
796    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
797    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
798    */
799   function _safeMint(
800     address to,
801     uint256 tokenId,
802     bytes memory _data
803   ) internal virtual {
804     _mint(to, tokenId);
805     require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
806   }
807 
808   /**
809    * @dev Mints `tokenId` and transfers it to `to`.
810    *
811    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
812    *
813    * Requirements:
814    *
815    * - `tokenId` must not exist.
816    * - `to` cannot be the zero address.
817    *
818    * Emits a {Transfer} event.
819    */
820   function _mint(address to, uint256 tokenId) internal virtual {
821     require(to != address(0), 'ERC721: mint to the zero address');
822     require(!_exists(tokenId), 'ERC721: token already minted');
823 
824     _beforeTokenTransfer(address(0), to, tokenId);
825 
826     _balances[to] += 1;
827     _owners[tokenId] = to;
828 
829     emit Transfer(address(0), to, tokenId);
830   }
831 
832   /**
833    * @dev Destroys `tokenId`.
834    * The approval is cleared when the token is burned.
835    *
836    * Requirements:
837    *
838    * - `tokenId` must exist.
839    *
840    * Emits a {Transfer} event.
841    */
842   function _burn(uint256 tokenId) internal virtual {
843     address owner = ERC721.ownerOf(tokenId);
844 
845     _beforeTokenTransfer(owner, address(0), tokenId);
846 
847     // Clear approvals
848     _approve(address(0), tokenId);
849 
850     _balances[owner] -= 1;
851     delete _owners[tokenId];
852 
853     emit Transfer(owner, address(0), tokenId);
854   }
855 
856   /**
857    * @dev Transfers `tokenId` from `from` to `to`.
858    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
859    *
860    * Requirements:
861    *
862    * - `to` cannot be the zero address.
863    * - `tokenId` token must be owned by `from`.
864    *
865    * Emits a {Transfer} event.
866    */
867   function _transfer(
868     address from,
869     address to,
870     uint256 tokenId
871   ) internal virtual {
872     require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
873     require(to != address(0), 'ERC721: transfer to the zero address');
874 
875     _beforeTokenTransfer(from, to, tokenId);
876 
877     // Clear approvals from the previous owner
878     _approve(address(0), tokenId);
879 
880     _balances[from] -= 1;
881     _balances[to] += 1;
882     _owners[tokenId] = to;
883 
884     emit Transfer(from, to, tokenId);
885   }
886 
887   /**
888    * @dev Approve `to` to operate on `tokenId`
889    *
890    * Emits a {Approval} event.
891    */
892   function _approve(address to, uint256 tokenId) internal virtual {
893     _tokenApprovals[tokenId] = to;
894     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
895   }
896 
897   /**
898    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
899    * The call is not executed if the target address is not a contract.
900    *
901    * @param from address representing the previous owner of the given token ID
902    * @param to target address that will receive the tokens
903    * @param tokenId uint256 ID of the token to be transferred
904    * @param _data bytes optional data to send along with the call
905    * @return bool whether the call correctly returned the expected magic value
906    */
907   function _checkOnERC721Received(
908     address from,
909     address to,
910     uint256 tokenId,
911     bytes memory _data
912   ) private returns (bool) {
913     if (to.isContract()) {
914       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
915         return retval == IERC721Receiver.onERC721Received.selector;
916       } catch (bytes memory reason) {
917         if (reason.length == 0) {
918           revert('ERC721: transfer to non ERC721Receiver implementer');
919         } else {
920           assembly {
921             revert(add(32, reason), mload(reason))
922           }
923         }
924       }
925     } else {
926       return true;
927     }
928   }
929 
930   /**
931    * @dev Hook that is called before any token transfer. This includes minting
932    * and burning.
933    *
934    * Calling conditions:
935    *
936    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
937    * transferred to `to`.
938    * - When `from` is zero, `tokenId` will be minted for `to`.
939    * - When `to` is zero, ``from``'s `tokenId` will be burned.
940    * - `from` and `to` are never both zero.
941    *
942    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
943    */
944   function _beforeTokenTransfer(
945     address from,
946     address to,
947     uint256 tokenId
948   ) internal virtual {}
949 }
950 
951 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
952 
953 pragma solidity ^0.8.0;
954 
955 /**
956  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
957  * @dev See https://eips.ethereum.org/EIPS/eip-721
958  */
959 interface IERC721Enumerable is IERC721 {
960   /**
961    * @dev Returns the total amount of tokens stored by the contract.
962    */
963   function totalSupply() external view returns (uint256);
964 
965   /**
966    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
967    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
968    */
969   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
970 
971   /**
972    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
973    * Use along with {totalSupply} to enumerate all tokens.
974    */
975   function tokenByIndex(uint256 index) external view returns (uint256);
976 }
977 
978 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
984  * enumerability of all the token ids in the contract as well as all token ids owned by each
985  * account.
986  */
987 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
988   // Mapping from owner to list of owned token IDs
989   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
990 
991   // Mapping from token ID to index of the owner tokens list
992   mapping(uint256 => uint256) private _ownedTokensIndex;
993 
994   // Array with all token ids, used for enumeration
995   uint256[] private _allTokens;
996 
997   // Mapping from token id to position in the allTokens array
998   mapping(uint256 => uint256) private _allTokensIndex;
999 
1000   /**
1001    * @dev See {IERC165-supportsInterface}.
1002    */
1003   function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1004     return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1005   }
1006 
1007   /**
1008    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1009    */
1010   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1011     require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1012     return _ownedTokens[owner][index];
1013   }
1014 
1015   /**
1016    * @dev See {IERC721Enumerable-totalSupply}.
1017    */
1018   function totalSupply() public view virtual override returns (uint256) {
1019     return _allTokens.length;
1020   }
1021 
1022   /**
1023    * @dev See {IERC721Enumerable-tokenByIndex}.
1024    */
1025   function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1026     require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1027     return _allTokens[index];
1028   }
1029 
1030   /**
1031    * @dev Hook that is called before any token transfer. This includes minting
1032    * and burning.
1033    *
1034    * Calling conditions:
1035    *
1036    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037    * transferred to `to`.
1038    * - When `from` is zero, `tokenId` will be minted for `to`.
1039    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040    * - `from` cannot be the zero address.
1041    * - `to` cannot be the zero address.
1042    *
1043    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1044    */
1045   function _beforeTokenTransfer(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) internal virtual override {
1050     super._beforeTokenTransfer(from, to, tokenId);
1051 
1052     if (from == address(0)) {
1053       _addTokenToAllTokensEnumeration(tokenId);
1054     } else if (from != to) {
1055       _removeTokenFromOwnerEnumeration(from, tokenId);
1056     }
1057     if (to == address(0)) {
1058       _removeTokenFromAllTokensEnumeration(tokenId);
1059     } else if (to != from) {
1060       _addTokenToOwnerEnumeration(to, tokenId);
1061     }
1062   }
1063 
1064   /**
1065    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1066    * @param to address representing the new owner of the given token ID
1067    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1068    */
1069   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1070     uint256 length = ERC721.balanceOf(to);
1071     _ownedTokens[to][length] = tokenId;
1072     _ownedTokensIndex[tokenId] = length;
1073   }
1074 
1075   /**
1076    * @dev Private function to add a token to this extension's token tracking data structures.
1077    * @param tokenId uint256 ID of the token to be added to the tokens list
1078    */
1079   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1080     _allTokensIndex[tokenId] = _allTokens.length;
1081     _allTokens.push(tokenId);
1082   }
1083 
1084   /**
1085    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1086    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1087    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1088    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1089    * @param from address representing the previous owner of the given token ID
1090    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1091    */
1092   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1093     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1094     // then delete the last slot (swap and pop).
1095 
1096     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1097     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1098 
1099     // When the token to delete is the last token, the swap operation is unnecessary
1100     if (tokenIndex != lastTokenIndex) {
1101       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1102 
1103       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1104       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1105     }
1106 
1107     // This also deletes the contents at the last position of the array
1108     delete _ownedTokensIndex[tokenId];
1109     delete _ownedTokens[from][lastTokenIndex];
1110   }
1111 
1112   /**
1113    * @dev Private function to remove a token from this extension's token tracking data structures.
1114    * This has O(1) time complexity, but alters the order of the _allTokens array.
1115    * @param tokenId uint256 ID of the token to be removed from the tokens list
1116    */
1117   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1118     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1119     // then delete the last slot (swap and pop).
1120 
1121     uint256 lastTokenIndex = _allTokens.length - 1;
1122     uint256 tokenIndex = _allTokensIndex[tokenId];
1123 
1124     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1125     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1126     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1127     uint256 lastTokenId = _allTokens[lastTokenIndex];
1128 
1129     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1130     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1131 
1132     // This also deletes the contents at the last position of the array
1133     delete _allTokensIndex[tokenId];
1134     _allTokens.pop();
1135   }
1136 }
1137 
1138 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1139 
1140 pragma solidity ^0.8.0;
1141 
1142 /**
1143  * @dev Contract module which provides a basic access control mechanism, where
1144  * there is an account (an owner) that can be granted exclusive access to
1145  * specific functions.
1146  *
1147  * By default, the owner account will be the one that deploys the contract. This
1148  * can later be changed with {transferOwnership}.
1149  *
1150  * This module is used through inheritance. It will make available the modifier
1151  * `onlyOwner`, which can be applied to your functions to restrict their use to
1152  * the owner.
1153  */
1154 abstract contract Ownable is Context {
1155   address private _owner;
1156 
1157   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1158 
1159   /**
1160    * @dev Initializes the contract setting the deployer as the initial owner.
1161    */
1162   constructor() {
1163     _setOwner(_msgSender());
1164   }
1165 
1166   /**
1167    * @dev Returns the address of the current owner.
1168    */
1169   function owner() public view virtual returns (address) {
1170     return _owner;
1171   }
1172 
1173   /**
1174    * @dev Throws if called by any account other than the owner.
1175    */
1176   modifier onlyOwner() {
1177     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1178     _;
1179   }
1180 
1181   /**
1182    * @dev Leaves the contract without owner. It will not be possible to call
1183    * `onlyOwner` functions anymore. Can only be called by the current owner.
1184    *
1185    * NOTE: Renouncing ownership will leave the contract without an owner,
1186    * thereby removing any functionality that is only available to the owner.
1187    */
1188   function renounceOwnership() public virtual onlyOwner {
1189     _setOwner(address(0));
1190   }
1191 
1192   /**
1193    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1194    * Can only be called by the current owner.
1195    */
1196   function transferOwnership(address newOwner) public virtual onlyOwner {
1197     require(newOwner != address(0), 'Ownable: new owner is the zero address');
1198     _setOwner(newOwner);
1199   }
1200 
1201   function _setOwner(address newOwner) private {
1202     address oldOwner = _owner;
1203     _owner = newOwner;
1204     emit OwnershipTransferred(oldOwner, newOwner);
1205   }
1206 }
1207 
1208 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 /**
1213  * @dev Contract module that helps prevent reentrant calls to a function.
1214  *
1215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1216  * available, which can be applied to functions to make sure there are no nested
1217  * (reentrant) calls to them.
1218  *
1219  * Note that because there is a single `nonReentrant` guard, functions marked as
1220  * `nonReentrant` may not call one another. This can be worked around by making
1221  * those functions `private`, and then adding `external` `nonReentrant` entry
1222  * points to them.
1223  *
1224  * TIP: If you would like to learn more about reentrancy and alternative ways
1225  * to protect against it, check out our blog post
1226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1227  */
1228 abstract contract ReentrancyGuard {
1229   // Booleans are more expensive than uint256 or any type that takes up a full
1230   // word because each write operation emits an extra SLOAD to first read the
1231   // slot's contents, replace the bits taken up by the boolean, and then write
1232   // back. This is the compiler's defense against contract upgrades and
1233   // pointer aliasing, and it cannot be disabled.
1234 
1235   // The values being non-zero value makes deployment a bit more expensive,
1236   // but in exchange the refund on every call to nonReentrant will be lower in
1237   // amount. Since refunds are capped to a percentage of the total
1238   // transaction's gas, it is best to keep them low in cases like this one, to
1239   // increase the likelihood of the full refund coming into effect.
1240   uint256 private constant _NOT_ENTERED = 1;
1241   uint256 private constant _ENTERED = 2;
1242 
1243   uint256 private _status;
1244 
1245   constructor() {
1246     _status = _NOT_ENTERED;
1247   }
1248 
1249   /**
1250    * @dev Prevents a contract from calling itself, directly or indirectly.
1251    * Calling a `nonReentrant` function from another `nonReentrant`
1252    * function is not supported. It is possible to prevent this from happening
1253    * by making the `nonReentrant` function external, and make it call a
1254    * `private` function that does the actual work.
1255    */
1256   modifier nonReentrant() {
1257     // On the first call to nonReentrant, _notEntered will be true
1258     require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
1259 
1260     // Any calls to nonReentrant after this point will fail
1261     _status = _ENTERED;
1262 
1263     _;
1264 
1265     // By storing the original value once again, a refund is triggered (see
1266     // https://eips.ethereum.org/EIPS/eip-2200)
1267     _status = _NOT_ENTERED;
1268   }
1269 }
1270 
1271 // File contracts/ArtForN.sol
1272 
1273 pragma solidity ^0.8.4;
1274 
1275 interface NInterface {
1276   function ownerOf(uint256 tokenId) external view returns (address owner);
1277 }
1278 
1279 contract ArtForN is ERC721Enumerable, Ownable, ReentrancyGuard {
1280   using Address for address;
1281 
1282   address public nAddress = 0x05a46f1E545526FB803FF974C790aCeA34D1f2D6;
1283   NInterface nContract = NInterface(nAddress);
1284 
1285   bool public presaleActive = false;
1286   bool public publicSaleActive = false;
1287 
1288   uint256 public presalePrice = 0.015 ether;
1289   uint256 public publicPrice = 0.05 ether;
1290 
1291   string public baseTokenURI;
1292 
1293   constructor(string memory _newBaseURI) ERC721('Art For N', 'ARTN') {
1294     setBaseURI(_newBaseURI);
1295   }
1296 
1297   // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
1298   function _baseURI() internal view virtual override returns (string memory) {
1299     return baseTokenURI;
1300   }
1301 
1302   // See which address owns which tokens
1303   function tokensOfOwner(address _ownerAddress) public view returns (uint256[] memory) {
1304     uint256 tokenCount = balanceOf(_ownerAddress);
1305     uint256[] memory tokenIds = new uint256[](tokenCount);
1306     for (uint256 i; i < tokenCount; i++) {
1307       tokenIds[i] = tokenOfOwnerByIndex(_ownerAddress, i);
1308     }
1309     return tokenIds;
1310   }
1311 
1312   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1313     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1314 
1315     return super.tokenURI(tokenId);
1316   }
1317 
1318   // Exclusive presale minting with N
1319   function mintWithN(uint256 _nId) public payable nonReentrant {
1320     require(presaleActive, 'Presale not started');
1321     require(msg.value == presalePrice, 'Wrong amount of ETH sent');
1322     require(nContract.ownerOf(_nId) == msg.sender, 'Not the owner of this N');
1323 
1324     _safeMint(msg.sender, _nId);
1325   }
1326 
1327   // Standard mint function
1328   function mint(uint256 _nId) public payable {
1329     require(publicSaleActive, 'Public sale not started');
1330     require(msg.value == publicPrice, 'Ether value sent is not correct');
1331     require(_nId > 0 && _nId <= 8888, 'Token ID invalid');
1332 
1333     _safeMint(msg.sender, _nId);
1334   }
1335 
1336   // Start and stop presale
1337   function setPresaleActive(bool _presaleActive) public onlyOwner {
1338     presaleActive = _presaleActive;
1339   }
1340 
1341   // Start and stop public sale
1342   function setPublicSaleActive(bool _publicSaleActive) public onlyOwner {
1343     publicSaleActive = _publicSaleActive;
1344   }
1345 
1346   // Set new baseURI
1347   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1348     baseTokenURI = _newBaseURI;
1349   }
1350 
1351   function withdraw(uint256 _amount) public onlyOwner {
1352     (bool success, ) = msg.sender.call{value: _amount}('');
1353     require(success, 'Transfer failed.');
1354   }
1355 }