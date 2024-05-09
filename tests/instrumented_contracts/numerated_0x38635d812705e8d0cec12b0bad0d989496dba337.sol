1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
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
26 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
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
37   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39   /**
40    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41    */
42   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44   /**
45    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46    */
47   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49   /**
50    * @dev Returns the number of tokens in ``owner``'s account.
51    */
52   function balanceOf(address owner) external view returns (uint256 balance);
53 
54   /**
55    * @dev Returns the owner of the `tokenId` token.
56    *
57    * Requirements:
58    *
59    * - `tokenId` must exist.
60    */
61   function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63   /**
64    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66    *
67    * Requirements:
68    *
69    * - `from` cannot be the zero address.
70    * - `to` cannot be the zero address.
71    * - `tokenId` token must exist and be owned by `from`.
72    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74    *
75    * Emits a {Transfer} event.
76    */
77   function safeTransferFrom(
78     address from,
79     address to,
80     uint256 tokenId
81   ) external;
82 
83   /**
84    * @dev Transfers `tokenId` token from `from` to `to`.
85    *
86    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87    *
88    * Requirements:
89    *
90    * - `from` cannot be the zero address.
91    * - `to` cannot be the zero address.
92    * - `tokenId` token must be owned by `from`.
93    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94    *
95    * Emits a {Transfer} event.
96    */
97   function transferFrom(
98     address from,
99     address to,
100     uint256 tokenId
101   ) external;
102 
103   /**
104    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105    * The approval is cleared when the token is transferred.
106    *
107    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108    *
109    * Requirements:
110    *
111    * - The caller must own the token or be an approved operator.
112    * - `tokenId` must exist.
113    *
114    * Emits an {Approval} event.
115    */
116   function approve(address to, uint256 tokenId) external;
117 
118   /**
119    * @dev Returns the account approved for `tokenId` token.
120    *
121    * Requirements:
122    *
123    * - `tokenId` must exist.
124    */
125   function getApproved(uint256 tokenId) external view returns (address operator);
126 
127   /**
128    * @dev Approve or remove `operator` as an operator for the caller.
129    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130    *
131    * Requirements:
132    *
133    * - The `operator` cannot be the caller.
134    *
135    * Emits an {ApprovalForAll} event.
136    */
137   function setApprovalForAll(address operator, bool _approved) external;
138 
139   /**
140    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141    *
142    * See {setApprovalForAll}
143    */
144   function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146   /**
147    * @dev Safely transfers `tokenId` token from `from` to `to`.
148    *
149    * Requirements:
150    *
151    * - `from` cannot be the zero address.
152    * - `to` cannot be the zero address.
153    * - `tokenId` token must exist and be owned by `from`.
154    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156    *
157    * Emits a {Transfer} event.
158    */
159   function safeTransferFrom(
160     address from,
161     address to,
162     uint256 tokenId,
163     bytes calldata data
164   ) external;
165 }
166 
167 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  * from ERC721 asset contracts.
175  */
176 interface IERC721Receiver {
177   /**
178    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
179    * by `operator` from `from`, this function is called.
180    *
181    * It must return its Solidity selector to confirm the token transfer.
182    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
183    *
184    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
185    */
186   function onERC721Received(
187     address operator,
188     address from,
189     uint256 tokenId,
190     bytes calldata data
191   ) external returns (bytes4);
192 }
193 
194 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203   /**
204    * @dev Returns the token collection name.
205    */
206   function name() external view returns (string memory);
207 
208   /**
209    * @dev Returns the token collection symbol.
210    */
211   function symbol() external view returns (string memory);
212 
213   /**
214    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215    */
216   function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227   /**
228    * @dev Returns true if `account` is a contract.
229    *
230    * [IMPORTANT]
231    * ====
232    * It is unsafe to assume that an address for which this function returns
233    * false is an externally-owned account (EOA) and not a contract.
234    *
235    * Among others, `isContract` will return false for the following
236    * types of addresses:
237    *
238    *  - an externally-owned account
239    *  - a contract in construction
240    *  - an address where a contract will be created
241    *  - an address where a contract lived, but was destroyed
242    * ====
243    */
244   function isContract(address account) internal view returns (bool) {
245     // This method relies on extcodesize, which returns 0 for contracts in
246     // construction, since the code is only stored at the end of the
247     // constructor execution.
248 
249     uint256 size;
250     assembly {
251       size := extcodesize(account)
252     }
253     return size > 0;
254   }
255 
256   /**
257    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258    * `recipient`, forwarding all available gas and reverting on errors.
259    *
260    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261    * of certain opcodes, possibly making contracts go over the 2300 gas limit
262    * imposed by `transfer`, making them unable to receive funds via
263    * `transfer`. {sendValue} removes this limitation.
264    *
265    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266    *
267    * IMPORTANT: because control is transferred to `recipient`, care must be
268    * taken to not create reentrancy vulnerabilities. Consider using
269    * {ReentrancyGuard} or the
270    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271    */
272   function sendValue(address payable recipient, uint256 amount) internal {
273     require(address(this).balance >= amount, 'Address: insufficient balance');
274 
275     (bool success, ) = recipient.call{value: amount}('');
276     require(success, 'Address: unable to send value, recipient may have reverted');
277   }
278 
279   /**
280    * @dev Performs a Solidity function call using a low level `call`. A
281    * plain `call` is an unsafe replacement for a function call: use this
282    * function instead.
283    *
284    * If `target` reverts with a revert reason, it is bubbled up by this
285    * function (like regular Solidity function calls).
286    *
287    * Returns the raw returned data. To convert to the expected return value,
288    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289    *
290    * Requirements:
291    *
292    * - `target` must be a contract.
293    * - calling `target` with `data` must not revert.
294    *
295    * _Available since v3.1._
296    */
297   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298     return functionCall(target, data, 'Address: low-level call failed');
299   }
300 
301   /**
302    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303    * `errorMessage` as a fallback revert reason when `target` reverts.
304    *
305    * _Available since v3.1._
306    */
307   function functionCall(
308     address target,
309     bytes memory data,
310     string memory errorMessage
311   ) internal returns (bytes memory) {
312     return functionCallWithValue(target, data, 0, errorMessage);
313   }
314 
315   /**
316    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317    * but also transferring `value` wei to `target`.
318    *
319    * Requirements:
320    *
321    * - the calling contract must have an ETH balance of at least `value`.
322    * - the called Solidity function must be `payable`.
323    *
324    * _Available since v3.1._
325    */
326   function functionCallWithValue(
327     address target,
328     bytes memory data,
329     uint256 value
330   ) internal returns (bytes memory) {
331     return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
332   }
333 
334   /**
335    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336    * with `errorMessage` as a fallback revert reason when `target` reverts.
337    *
338    * _Available since v3.1._
339    */
340   function functionCallWithValue(
341     address target,
342     bytes memory data,
343     uint256 value,
344     string memory errorMessage
345   ) internal returns (bytes memory) {
346     require(address(this).balance >= value, 'Address: insufficient balance for call');
347     require(isContract(target), 'Address: call to non-contract');
348 
349     (bool success, bytes memory returndata) = target.call{value: value}(data);
350     return verifyCallResult(success, returndata, errorMessage);
351   }
352 
353   /**
354    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355    * but performing a static call.
356    *
357    * _Available since v3.3._
358    */
359   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360     return functionStaticCall(target, data, 'Address: low-level static call failed');
361   }
362 
363   /**
364    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365    * but performing a static call.
366    *
367    * _Available since v3.3._
368    */
369   function functionStaticCall(
370     address target,
371     bytes memory data,
372     string memory errorMessage
373   ) internal view returns (bytes memory) {
374     require(isContract(target), 'Address: static call to non-contract');
375 
376     (bool success, bytes memory returndata) = target.staticcall(data);
377     return verifyCallResult(success, returndata, errorMessage);
378   }
379 
380   /**
381    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382    * but performing a delegate call.
383    *
384    * _Available since v3.4._
385    */
386   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387     return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
388   }
389 
390   /**
391    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392    * but performing a delegate call.
393    *
394    * _Available since v3.4._
395    */
396   function functionDelegateCall(
397     address target,
398     bytes memory data,
399     string memory errorMessage
400   ) internal returns (bytes memory) {
401     require(isContract(target), 'Address: delegate call to non-contract');
402 
403     (bool success, bytes memory returndata) = target.delegatecall(data);
404     return verifyCallResult(success, returndata, errorMessage);
405   }
406 
407   /**
408    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
409    * revert reason using the provided one.
410    *
411    * _Available since v4.3._
412    */
413   function verifyCallResult(
414     bool success,
415     bytes memory returndata,
416     string memory errorMessage
417   ) internal pure returns (bytes memory) {
418     if (success) {
419       return returndata;
420     } else {
421       // Look for revert reason and bubble it up if present
422       if (returndata.length > 0) {
423         // The easiest way to bubble the revert reason is using memory via assembly
424 
425         assembly {
426           let returndata_size := mload(returndata)
427           revert(add(32, returndata), returndata_size)
428         }
429       } else {
430         revert(errorMessage);
431       }
432     }
433   }
434 }
435 
436 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451   function _msgSender() internal view virtual returns (address) {
452     return msg.sender;
453   }
454 
455   function _msgData() internal view virtual returns (bytes calldata) {
456     return msg.data;
457   }
458 }
459 
460 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev String operations.
466  */
467 library Strings {
468   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
469 
470   /**
471    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
472    */
473   function toString(uint256 value) internal pure returns (string memory) {
474     // Inspired by OraclizeAPI's implementation - MIT licence
475     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
476 
477     if (value == 0) {
478       return '0';
479     }
480     uint256 temp = value;
481     uint256 digits;
482     while (temp != 0) {
483       digits++;
484       temp /= 10;
485     }
486     bytes memory buffer = new bytes(digits);
487     while (value != 0) {
488       digits -= 1;
489       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
490       value /= 10;
491     }
492     return string(buffer);
493   }
494 
495   /**
496    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
497    */
498   function toHexString(uint256 value) internal pure returns (string memory) {
499     if (value == 0) {
500       return '0x00';
501     }
502     uint256 temp = value;
503     uint256 length = 0;
504     while (temp != 0) {
505       length++;
506       temp >>= 8;
507     }
508     return toHexString(value, length);
509   }
510 
511   /**
512    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
513    */
514   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
515     bytes memory buffer = new bytes(2 * length + 2);
516     buffer[0] = '0';
517     buffer[1] = 'x';
518     for (uint256 i = 2 * length + 1; i > 1; --i) {
519       buffer[i] = _HEX_SYMBOLS[value & 0xf];
520       value >>= 4;
521     }
522     require(value == 0, 'Strings: hex length insufficient');
523     return string(buffer);
524   }
525 }
526 
527 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546   /**
547    * @dev See {IERC165-supportsInterface}.
548    */
549   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550     return interfaceId == type(IERC165).interfaceId;
551   }
552 }
553 
554 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
560  * the Metadata extension, but not including the Enumerable extension, which is available separately as
561  * {ERC721Enumerable}.
562  */
563 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
564   using Address for address;
565   using Strings for uint256;
566 
567   // Token name
568   string private _name;
569 
570   // Token symbol
571   string private _symbol;
572 
573   // Mapping from token ID to owner address
574   mapping(uint256 => address) private _owners;
575 
576   // Mapping owner address to token count
577   mapping(address => uint256) private _balances;
578 
579   // Mapping from token ID to approved address
580   mapping(uint256 => address) private _tokenApprovals;
581 
582   // Mapping from owner to operator approvals
583   mapping(address => mapping(address => bool)) private _operatorApprovals;
584 
585   /**
586    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
587    */
588   constructor(string memory name_, string memory symbol_) {
589     _name = name_;
590     _symbol = symbol_;
591   }
592 
593   /**
594    * @dev See {IERC165-supportsInterface}.
595    */
596   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
597     return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
598   }
599 
600   /**
601    * @dev See {IERC721-balanceOf}.
602    */
603   function balanceOf(address owner) public view virtual override returns (uint256) {
604     require(owner != address(0), 'ERC721: balance query for the zero address');
605     return _balances[owner];
606   }
607 
608   /**
609    * @dev See {IERC721-ownerOf}.
610    */
611   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
612     address owner = _owners[tokenId];
613     require(owner != address(0), 'ERC721: owner query for nonexistent token');
614     return owner;
615   }
616 
617   /**
618    * @dev See {IERC721Metadata-name}.
619    */
620   function name() public view virtual override returns (string memory) {
621     return _name;
622   }
623 
624   /**
625    * @dev See {IERC721Metadata-symbol}.
626    */
627   function symbol() public view virtual override returns (string memory) {
628     return _symbol;
629   }
630 
631   /**
632    * @dev See {IERC721Metadata-tokenURI}.
633    */
634   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
635     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
636 
637     string memory baseURI = _baseURI();
638     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
639   }
640 
641   /**
642    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
643    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
644    * by default, can be overriden in child contracts.
645    */
646   function _baseURI() internal view virtual returns (string memory) {
647     return '';
648   }
649 
650   /**
651    * @dev See {IERC721-approve}.
652    */
653   function approve(address to, uint256 tokenId) public virtual override {
654     address owner = ERC721.ownerOf(tokenId);
655     require(to != owner, 'ERC721: approval to current owner');
656 
657     require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
658 
659     _approve(to, tokenId);
660   }
661 
662   /**
663    * @dev See {IERC721-getApproved}.
664    */
665   function getApproved(uint256 tokenId) public view virtual override returns (address) {
666     require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
667 
668     return _tokenApprovals[tokenId];
669   }
670 
671   /**
672    * @dev See {IERC721-setApprovalForAll}.
673    */
674   function setApprovalForAll(address operator, bool approved) public virtual override {
675     require(operator != _msgSender(), 'ERC721: approve to caller');
676 
677     _operatorApprovals[_msgSender()][operator] = approved;
678     emit ApprovalForAll(_msgSender(), operator, approved);
679   }
680 
681   /**
682    * @dev See {IERC721-isApprovedForAll}.
683    */
684   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685     return _operatorApprovals[owner][operator];
686   }
687 
688   /**
689    * @dev See {IERC721-transferFrom}.
690    */
691   function transferFrom(
692     address from,
693     address to,
694     uint256 tokenId
695   ) public virtual override {
696     //solhint-disable-next-line max-line-length
697     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
698 
699     _transfer(from, to, tokenId);
700   }
701 
702   /**
703    * @dev See {IERC721-safeTransferFrom}.
704    */
705   function safeTransferFrom(
706     address from,
707     address to,
708     uint256 tokenId
709   ) public virtual override {
710     safeTransferFrom(from, to, tokenId, '');
711   }
712 
713   /**
714    * @dev See {IERC721-safeTransferFrom}.
715    */
716   function safeTransferFrom(
717     address from,
718     address to,
719     uint256 tokenId,
720     bytes memory _data
721   ) public virtual override {
722     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
723     _safeTransfer(from, to, tokenId, _data);
724   }
725 
726   /**
727    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729    *
730    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
731    *
732    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
733    * implement alternative mechanisms to perform token transfer, such as signature-based.
734    *
735    * Requirements:
736    *
737    * - `from` cannot be the zero address.
738    * - `to` cannot be the zero address.
739    * - `tokenId` token must exist and be owned by `from`.
740    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741    *
742    * Emits a {Transfer} event.
743    */
744   function _safeTransfer(
745     address from,
746     address to,
747     uint256 tokenId,
748     bytes memory _data
749   ) internal virtual {
750     _transfer(from, to, tokenId);
751     require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
752   }
753 
754   /**
755    * @dev Returns whether `tokenId` exists.
756    *
757    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
758    *
759    * Tokens start existing when they are minted (`_mint`),
760    * and stop existing when they are burned (`_burn`).
761    */
762   function _exists(uint256 tokenId) internal view virtual returns (bool) {
763     return _owners[tokenId] != address(0);
764   }
765 
766   /**
767    * @dev Returns whether `spender` is allowed to manage `tokenId`.
768    *
769    * Requirements:
770    *
771    * - `tokenId` must exist.
772    */
773   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
774     require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
775     address owner = ERC721.ownerOf(tokenId);
776     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
777   }
778 
779   /**
780    * @dev Safely mints `tokenId` and transfers it to `to`.
781    *
782    * Requirements:
783    *
784    * - `tokenId` must not exist.
785    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786    *
787    * Emits a {Transfer} event.
788    */
789   function _safeMint(address to, uint256 tokenId) internal virtual {
790     _safeMint(to, tokenId, '');
791   }
792 
793   /**
794    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
795    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
796    */
797   function _safeMint(
798     address to,
799     uint256 tokenId,
800     bytes memory _data
801   ) internal virtual {
802     _mint(to, tokenId);
803     require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
804   }
805 
806   /**
807    * @dev Mints `tokenId` and transfers it to `to`.
808    *
809    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
810    *
811    * Requirements:
812    *
813    * - `tokenId` must not exist.
814    * - `to` cannot be the zero address.
815    *
816    * Emits a {Transfer} event.
817    */
818   function _mint(address to, uint256 tokenId) internal virtual {
819     require(to != address(0), 'ERC721: mint to the zero address');
820     require(!_exists(tokenId), 'ERC721: token already minted');
821 
822     _beforeTokenTransfer(address(0), to, tokenId);
823 
824     _balances[to] += 1;
825     _owners[tokenId] = to;
826 
827     emit Transfer(address(0), to, tokenId);
828   }
829 
830   /**
831    * @dev Destroys `tokenId`.
832    * The approval is cleared when the token is burned.
833    *
834    * Requirements:
835    *
836    * - `tokenId` must exist.
837    *
838    * Emits a {Transfer} event.
839    */
840   function _burn(uint256 tokenId) internal virtual {
841     address owner = ERC721.ownerOf(tokenId);
842 
843     _beforeTokenTransfer(owner, address(0), tokenId);
844 
845     // Clear approvals
846     _approve(address(0), tokenId);
847 
848     _balances[owner] -= 1;
849     delete _owners[tokenId];
850 
851     emit Transfer(owner, address(0), tokenId);
852   }
853 
854   /**
855    * @dev Transfers `tokenId` from `from` to `to`.
856    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
857    *
858    * Requirements:
859    *
860    * - `to` cannot be the zero address.
861    * - `tokenId` token must be owned by `from`.
862    *
863    * Emits a {Transfer} event.
864    */
865   function _transfer(
866     address from,
867     address to,
868     uint256 tokenId
869   ) internal virtual {
870     require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
871     require(to != address(0), 'ERC721: transfer to the zero address');
872 
873     _beforeTokenTransfer(from, to, tokenId);
874 
875     // Clear approvals from the previous owner
876     _approve(address(0), tokenId);
877 
878     _balances[from] -= 1;
879     _balances[to] += 1;
880     _owners[tokenId] = to;
881 
882     emit Transfer(from, to, tokenId);
883   }
884 
885   /**
886    * @dev Approve `to` to operate on `tokenId`
887    *
888    * Emits a {Approval} event.
889    */
890   function _approve(address to, uint256 tokenId) internal virtual {
891     _tokenApprovals[tokenId] = to;
892     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
893   }
894 
895   /**
896    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
897    * The call is not executed if the target address is not a contract.
898    *
899    * @param from address representing the previous owner of the given token ID
900    * @param to target address that will receive the tokens
901    * @param tokenId uint256 ID of the token to be transferred
902    * @param _data bytes optional data to send along with the call
903    * @return bool whether the call correctly returned the expected magic value
904    */
905   function _checkOnERC721Received(
906     address from,
907     address to,
908     uint256 tokenId,
909     bytes memory _data
910   ) private returns (bool) {
911     if (to.isContract()) {
912       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
913         return retval == IERC721Receiver.onERC721Received.selector;
914       } catch (bytes memory reason) {
915         if (reason.length == 0) {
916           revert('ERC721: transfer to non ERC721Receiver implementer');
917         } else {
918           assembly {
919             revert(add(32, reason), mload(reason))
920           }
921         }
922       }
923     } else {
924       return true;
925     }
926   }
927 
928   /**
929    * @dev Hook that is called before any token transfer. This includes minting
930    * and burning.
931    *
932    * Calling conditions:
933    *
934    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
935    * transferred to `to`.
936    * - When `from` is zero, `tokenId` will be minted for `to`.
937    * - When `to` is zero, ``from``'s `tokenId` will be burned.
938    * - `from` and `to` are never both zero.
939    *
940    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
941    */
942   function _beforeTokenTransfer(
943     address from,
944     address to,
945     uint256 tokenId
946   ) internal virtual {}
947 }
948 
949 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
950 
951 pragma solidity ^0.8.0;
952 
953 /**
954  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
955  * @dev See https://eips.ethereum.org/EIPS/eip-721
956  */
957 interface IERC721Enumerable is IERC721 {
958   /**
959    * @dev Returns the total amount of tokens stored by the contract.
960    */
961   function totalSupply() external view returns (uint256);
962 
963   /**
964    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
965    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
966    */
967   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
968 
969   /**
970    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
971    * Use along with {totalSupply} to enumerate all tokens.
972    */
973   function tokenByIndex(uint256 index) external view returns (uint256);
974 }
975 
976 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
977 
978 pragma solidity ^0.8.0;
979 
980 /**
981  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
982  * enumerability of all the token ids in the contract as well as all token ids owned by each
983  * account.
984  */
985 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
986   // Mapping from owner to list of owned token IDs
987   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
988 
989   // Mapping from token ID to index of the owner tokens list
990   mapping(uint256 => uint256) private _ownedTokensIndex;
991 
992   // Array with all token ids, used for enumeration
993   uint256[] private _allTokens;
994 
995   // Mapping from token id to position in the allTokens array
996   mapping(uint256 => uint256) private _allTokensIndex;
997 
998   /**
999    * @dev See {IERC165-supportsInterface}.
1000    */
1001   function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1002     return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1003   }
1004 
1005   /**
1006    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1007    */
1008   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1009     require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1010     return _ownedTokens[owner][index];
1011   }
1012 
1013   /**
1014    * @dev See {IERC721Enumerable-totalSupply}.
1015    */
1016   function totalSupply() public view virtual override returns (uint256) {
1017     return _allTokens.length;
1018   }
1019 
1020   /**
1021    * @dev See {IERC721Enumerable-tokenByIndex}.
1022    */
1023   function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1024     require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1025     return _allTokens[index];
1026   }
1027 
1028   /**
1029    * @dev Hook that is called before any token transfer. This includes minting
1030    * and burning.
1031    *
1032    * Calling conditions:
1033    *
1034    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1035    * transferred to `to`.
1036    * - When `from` is zero, `tokenId` will be minted for `to`.
1037    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1038    * - `from` cannot be the zero address.
1039    * - `to` cannot be the zero address.
1040    *
1041    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1042    */
1043   function _beforeTokenTransfer(
1044     address from,
1045     address to,
1046     uint256 tokenId
1047   ) internal virtual override {
1048     super._beforeTokenTransfer(from, to, tokenId);
1049 
1050     if (from == address(0)) {
1051       _addTokenToAllTokensEnumeration(tokenId);
1052     } else if (from != to) {
1053       _removeTokenFromOwnerEnumeration(from, tokenId);
1054     }
1055     if (to == address(0)) {
1056       _removeTokenFromAllTokensEnumeration(tokenId);
1057     } else if (to != from) {
1058       _addTokenToOwnerEnumeration(to, tokenId);
1059     }
1060   }
1061 
1062   /**
1063    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1064    * @param to address representing the new owner of the given token ID
1065    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1066    */
1067   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1068     uint256 length = ERC721.balanceOf(to);
1069     _ownedTokens[to][length] = tokenId;
1070     _ownedTokensIndex[tokenId] = length;
1071   }
1072 
1073   /**
1074    * @dev Private function to add a token to this extension's token tracking data structures.
1075    * @param tokenId uint256 ID of the token to be added to the tokens list
1076    */
1077   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1078     _allTokensIndex[tokenId] = _allTokens.length;
1079     _allTokens.push(tokenId);
1080   }
1081 
1082   /**
1083    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1084    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1085    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1086    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1087    * @param from address representing the previous owner of the given token ID
1088    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1089    */
1090   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1091     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1092     // then delete the last slot (swap and pop).
1093 
1094     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1095     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1096 
1097     // When the token to delete is the last token, the swap operation is unnecessary
1098     if (tokenIndex != lastTokenIndex) {
1099       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1100 
1101       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1102       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1103     }
1104 
1105     // This also deletes the contents at the last position of the array
1106     delete _ownedTokensIndex[tokenId];
1107     delete _ownedTokens[from][lastTokenIndex];
1108   }
1109 
1110   /**
1111    * @dev Private function to remove a token from this extension's token tracking data structures.
1112    * This has O(1) time complexity, but alters the order of the _allTokens array.
1113    * @param tokenId uint256 ID of the token to be removed from the tokens list
1114    */
1115   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1116     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1117     // then delete the last slot (swap and pop).
1118 
1119     uint256 lastTokenIndex = _allTokens.length - 1;
1120     uint256 tokenIndex = _allTokensIndex[tokenId];
1121 
1122     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1123     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1124     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1125     uint256 lastTokenId = _allTokens[lastTokenIndex];
1126 
1127     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1128     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1129 
1130     // This also deletes the contents at the last position of the array
1131     delete _allTokensIndex[tokenId];
1132     _allTokens.pop();
1133   }
1134 }
1135 
1136 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 /**
1141  * @dev Contract module which provides a basic access control mechanism, where
1142  * there is an account (an owner) that can be granted exclusive access to
1143  * specific functions.
1144  *
1145  * By default, the owner account will be the one that deploys the contract. This
1146  * can later be changed with {transferOwnership}.
1147  *
1148  * This module is used through inheritance. It will make available the modifier
1149  * `onlyOwner`, which can be applied to your functions to restrict their use to
1150  * the owner.
1151  */
1152 abstract contract Ownable is Context {
1153   address private _owner;
1154 
1155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1156 
1157   /**
1158    * @dev Initializes the contract setting the deployer as the initial owner.
1159    */
1160   constructor() {
1161     _setOwner(_msgSender());
1162   }
1163 
1164   /**
1165    * @dev Returns the address of the current owner.
1166    */
1167   function owner() public view virtual returns (address) {
1168     return _owner;
1169   }
1170 
1171   /**
1172    * @dev Throws if called by any account other than the owner.
1173    */
1174   modifier onlyOwner() {
1175     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1176     _;
1177   }
1178 
1179   /**
1180    * @dev Leaves the contract without owner. It will not be possible to call
1181    * `onlyOwner` functions anymore. Can only be called by the current owner.
1182    *
1183    * NOTE: Renouncing ownership will leave the contract without an owner,
1184    * thereby removing any functionality that is only available to the owner.
1185    */
1186   function renounceOwnership() public virtual onlyOwner {
1187     _setOwner(address(0));
1188   }
1189 
1190   /**
1191    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1192    * Can only be called by the current owner.
1193    */
1194   function transferOwnership(address newOwner) public virtual onlyOwner {
1195     require(newOwner != address(0), 'Ownable: new owner is the zero address');
1196     _setOwner(newOwner);
1197   }
1198 
1199   function _setOwner(address newOwner) private {
1200     address oldOwner = _owner;
1201     _owner = newOwner;
1202     emit OwnershipTransferred(oldOwner, newOwner);
1203   }
1204 }
1205 
1206 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Contract module that helps prevent reentrant calls to a function.
1212  *
1213  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1214  * available, which can be applied to functions to make sure there are no nested
1215  * (reentrant) calls to them.
1216  *
1217  * Note that because there is a single `nonReentrant` guard, functions marked as
1218  * `nonReentrant` may not call one another. This can be worked around by making
1219  * those functions `private`, and then adding `external` `nonReentrant` entry
1220  * points to them.
1221  *
1222  * TIP: If you would like to learn more about reentrancy and alternative ways
1223  * to protect against it, check out our blog post
1224  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1225  */
1226 abstract contract ReentrancyGuard {
1227   // Booleans are more expensive than uint256 or any type that takes up a full
1228   // word because each write operation emits an extra SLOAD to first read the
1229   // slot's contents, replace the bits taken up by the boolean, and then write
1230   // back. This is the compiler's defense against contract upgrades and
1231   // pointer aliasing, and it cannot be disabled.
1232 
1233   // The values being non-zero value makes deployment a bit more expensive,
1234   // but in exchange the refund on every call to nonReentrant will be lower in
1235   // amount. Since refunds are capped to a percentage of the total
1236   // transaction's gas, it is best to keep them low in cases like this one, to
1237   // increase the likelihood of the full refund coming into effect.
1238   uint256 private constant _NOT_ENTERED = 1;
1239   uint256 private constant _ENTERED = 2;
1240 
1241   uint256 private _status;
1242 
1243   constructor() {
1244     _status = _NOT_ENTERED;
1245   }
1246 
1247   /**
1248    * @dev Prevents a contract from calling itself, directly or indirectly.
1249    * Calling a `nonReentrant` function from another `nonReentrant`
1250    * function is not supported. It is possible to prevent this from happening
1251    * by making the `nonReentrant` function external, and make it call a
1252    * `private` function that does the actual work.
1253    */
1254   modifier nonReentrant() {
1255     // On the first call to nonReentrant, _notEntered will be true
1256     require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
1257 
1258     // Any calls to nonReentrant after this point will fail
1259     _status = _ENTERED;
1260 
1261     _;
1262 
1263     // By storing the original value once again, a refund is triggered (see
1264     // https://eips.ethereum.org/EIPS/eip-2200)
1265     _status = _NOT_ENTERED;
1266   }
1267 }
1268 
1269 
1270 pragma solidity ^0.8.4;
1271 
1272 interface NInterface {
1273   function ownerOf(uint256 tokenId) external view returns (address owner);
1274 }
1275 
1276 contract CuratedByN is ERC721Enumerable, Ownable, ReentrancyGuard {
1277   using Address for address;
1278 
1279   address public nAddress = 0x05a46f1E545526FB803FF974C790aCeA34D1f2D6;
1280   NInterface ContractOfn = NInterface(nAddress);
1281 
1282   bool public saleActive = false;
1283 
1284   uint256 public PriceForN = 0.015 ether;
1285   uint256 public publicPrice = 0.04 ether;
1286 
1287   string public baseTokenURI;
1288 
1289   constructor(string memory _newBaseURI) ERC721('Curated By N', 'CBN') {
1290     setBaseURI(_newBaseURI);
1291   }
1292 
1293   // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
1294   function _baseURI() internal view virtual override returns (string memory) {
1295     return baseTokenURI;
1296   }
1297 
1298   // See which address owns which tokens
1299   function tokensOfOwner(address _ownerAddress) public view returns (uint256[] memory) {
1300     uint256 tokenCount = balanceOf(_ownerAddress);
1301     uint256[] memory tokenIds = new uint256[](tokenCount);
1302     for (uint256 i; i < tokenCount; i++) {
1303       tokenIds[i] = tokenOfOwnerByIndex(_ownerAddress, i);
1304     }
1305     return tokenIds;
1306   }
1307 
1308   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1309     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1310     return super.tokenURI(tokenId);
1311   }
1312 
1313   // minting for N holders
1314   function mintWithN(uint256 nTokenId) public payable nonReentrant {
1315     require(saleActive, 'Sale not started');
1316     require(msg.value == PriceForN, 'insufficient ETH Value');
1317     require(ContractOfn.ownerOf(nTokenId) == msg.sender, 'Not the owner of this N');
1318 
1319     _safeMint(msg.sender, nTokenId);
1320   }
1321 
1322   // Standard mint function
1323   function mint(uint256 TokenId) public payable {
1324     require(saleActive, 'Sale not started');
1325     require(msg.value == publicPrice, 'Ether value sent is not correct');
1326     require(TokenId > 0 && TokenId <= 8888, 'Token ID out of bounds');
1327 
1328     _safeMint(msg.sender, TokenId);
1329   }
1330 
1331   // Start and stop presale
1332   function setSaleActive(bool _saleActive) public onlyOwner {
1333     saleActive = _saleActive;
1334   }
1335 
1336   // Start and stop public sale
1337 
1338   // Set new baseURI
1339   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1340     baseTokenURI = _newBaseURI;
1341   }
1342 
1343   function withdraw(uint256 _amount) public onlyOwner {
1344     (bool success, ) = msg.sender.call{value: _amount}('');
1345     require(success, 'Transfer failed.');
1346   }
1347 }