1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 
8 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22   /**
23    * @dev Returns true if this contract implements the interface defined by
24    * `interfaceId`. See the corresponding
25    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26    * to learn more about how these ids are created.
27    *
28    * This function call must use less than 30 000 gas.
29    */
30   function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41   /**
42    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43    */
44   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46   /**
47    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48    */
49   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51   /**
52    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53    */
54   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56   /**
57    * @dev Returns the number of tokens in ``owner``'s account.
58    */
59   function balanceOf(address owner) external view returns (uint256 balance);
60 
61   /**
62    * @dev Returns the owner of the `tokenId` token.
63    *
64    * Requirements:
65    *
66    * - `tokenId` must exist.
67    */
68   function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70   /**
71    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73    *
74    * Requirements:
75    *
76    * - `from` cannot be the zero address.
77    * - `to` cannot be the zero address.
78    * - `tokenId` token must exist and be owned by `from`.
79    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81    *
82    * Emits a {Transfer} event.
83    */
84   function safeTransferFrom(
85     address from,
86     address to,
87     uint256 tokenId
88   ) external;
89 
90   /**
91    * @dev Transfers `tokenId` token from `from` to `to`.
92    *
93    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94    *
95    * Requirements:
96    *
97    * - `from` cannot be the zero address.
98    * - `to` cannot be the zero address.
99    * - `tokenId` token must be owned by `from`.
100    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101    *
102    * Emits a {Transfer} event.
103    */
104   function transferFrom(
105     address from,
106     address to,
107     uint256 tokenId
108   ) external;
109 
110   /**
111    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112    * The approval is cleared when the token is transferred.
113    *
114    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115    *
116    * Requirements:
117    *
118    * - The caller must own the token or be an approved operator.
119    * - `tokenId` must exist.
120    *
121    * Emits an {Approval} event.
122    */
123   function approve(address to, uint256 tokenId) external;
124 
125   /**
126    * @dev Returns the account approved for `tokenId` token.
127    *
128    * Requirements:
129    *
130    * - `tokenId` must exist.
131    */
132   function getApproved(uint256 tokenId) external view returns (address operator);
133 
134   /**
135    * @dev Approve or remove `operator` as an operator for the caller.
136    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137    *
138    * Requirements:
139    *
140    * - The `operator` cannot be the caller.
141    *
142    * Emits an {ApprovalForAll} event.
143    */
144   function setApprovalForAll(address operator, bool _approved) external;
145 
146   /**
147    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148    *
149    * See {setApprovalForAll}
150    */
151   function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153   /**
154    * @dev Safely transfers `tokenId` token from `from` to `to`.
155    *
156    * Requirements:
157    *
158    * - `from` cannot be the zero address.
159    * - `to` cannot be the zero address.
160    * - `tokenId` token must exist and be owned by `from`.
161    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163    *
164    * Emits a {Transfer} event.
165    */
166   function safeTransferFrom(
167     address from,
168     address to,
169     uint256 tokenId,
170     bytes calldata data
171   ) external;
172 }
173 
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 interface IERC721Receiver {
184   /**
185    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
186    * by `operator` from `from`, this function is called.
187    *
188    * It must return its Solidity selector to confirm the token transfer.
189    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
190    *
191    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
192    */
193   function onERC721Received(
194     address operator,
195     address from,
196     uint256 tokenId,
197     bytes calldata data
198   ) external returns (bytes4);
199 }
200 
201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210   /**
211    * @dev Returns the token collection name.
212    */
213   function name() external view returns (string memory);
214 
215   /**
216    * @dev Returns the token collection symbol.
217    */
218   function symbol() external view returns (string memory);
219 
220   /**
221    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222    */
223   function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234   /**
235    * @dev Returns true if `account` is a contract.
236    *
237    * [IMPORTANT]
238    * ====
239    * It is unsafe to assume that an address for which this function returns
240    * false is an externally-owned account (EOA) and not a contract.
241    *
242    * Among others, `isContract` will return false for the following
243    * types of addresses:
244    *
245    *  - an externally-owned account
246    *  - a contract in construction
247    *  - an address where a contract will be created
248    *  - an address where a contract lived, but was destroyed
249    * ====
250    */
251   function isContract(address account) internal view returns (bool) {
252     // This method relies on extcodesize, which returns 0 for contracts in
253     // construction, since the code is only stored at the end of the
254     // constructor execution.
255 
256     uint256 size;
257     assembly {
258       size := extcodesize(account)
259     }
260     return size > 0;
261   }
262 
263   /**
264    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265    * `recipient`, forwarding all available gas and reverting on errors.
266    *
267    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268    * of certain opcodes, possibly making contracts go over the 2300 gas limit
269    * imposed by `transfer`, making them unable to receive funds via
270    * `transfer`. {sendValue} removes this limitation.
271    *
272    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273    *
274    * IMPORTANT: because control is transferred to `recipient`, care must be
275    * taken to not create reentrancy vulnerabilities. Consider using
276    * {ReentrancyGuard} or the
277    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278    */
279   function sendValue(address payable recipient, uint256 amount) internal {
280     require(address(this).balance >= amount, 'Address: insufficient balance');
281 
282     (bool success, ) = recipient.call{value: amount}('');
283     require(success, 'Address: unable to send value, recipient may have reverted');
284   }
285 
286   /**
287    * @dev Performs a Solidity function call using a low level `call`. A
288    * plain `call` is an unsafe replacement for a function call: use this
289    * function instead.
290    *
291    * If `target` reverts with a revert reason, it is bubbled up by this
292    * function (like regular Solidity function calls).
293    *
294    * Returns the raw returned data. To convert to the expected return value,
295    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296    *
297    * Requirements:
298    *
299    * - `target` must be a contract.
300    * - calling `target` with `data` must not revert.
301    *
302    * _Available since v3.1._
303    */
304   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305     return functionCall(target, data, 'Address: low-level call failed');
306   }
307 
308   /**
309    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310    * `errorMessage` as a fallback revert reason when `target` reverts.
311    *
312    * _Available since v3.1._
313    */
314   function functionCall(
315     address target,
316     bytes memory data,
317     string memory errorMessage
318   ) internal returns (bytes memory) {
319     return functionCallWithValue(target, data, 0, errorMessage);
320   }
321 
322   /**
323    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324    * but also transferring `value` wei to `target`.
325    *
326    * Requirements:
327    *
328    * - the calling contract must have an ETH balance of at least `value`.
329    * - the called Solidity function must be `payable`.
330    *
331    * _Available since v3.1._
332    */
333   function functionCallWithValue(
334     address target,
335     bytes memory data,
336     uint256 value
337   ) internal returns (bytes memory) {
338     return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
339   }
340 
341   /**
342    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343    * with `errorMessage` as a fallback revert reason when `target` reverts.
344    *
345    * _Available since v3.1._
346    */
347   function functionCallWithValue(
348     address target,
349     bytes memory data,
350     uint256 value,
351     string memory errorMessage
352   ) internal returns (bytes memory) {
353     require(address(this).balance >= value, 'Address: insufficient balance for call');
354     require(isContract(target), 'Address: call to non-contract');
355 
356     (bool success, bytes memory returndata) = target.call{value: value}(data);
357     return verifyCallResult(success, returndata, errorMessage);
358   }
359 
360   /**
361    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362    * but performing a static call.
363    *
364    * _Available since v3.3._
365    */
366   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367     return functionStaticCall(target, data, 'Address: low-level static call failed');
368   }
369 
370   /**
371    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372    * but performing a static call.
373    *
374    * _Available since v3.3._
375    */
376   function functionStaticCall(
377     address target,
378     bytes memory data,
379     string memory errorMessage
380   ) internal view returns (bytes memory) {
381     require(isContract(target), 'Address: static call to non-contract');
382 
383     (bool success, bytes memory returndata) = target.staticcall(data);
384     return verifyCallResult(success, returndata, errorMessage);
385   }
386 
387   /**
388    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389    * but performing a delegate call.
390    *
391    * _Available since v3.4._
392    */
393   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394     return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
395   }
396 
397   /**
398    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399    * but performing a delegate call.
400    *
401    * _Available since v3.4._
402    */
403   function functionDelegateCall(
404     address target,
405     bytes memory data,
406     string memory errorMessage
407   ) internal returns (bytes memory) {
408     require(isContract(target), 'Address: delegate call to non-contract');
409 
410     (bool success, bytes memory returndata) = target.delegatecall(data);
411     return verifyCallResult(success, returndata, errorMessage);
412   }
413 
414   /**
415    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416    * revert reason using the provided one.
417    *
418    * _Available since v4.3._
419    */
420   function verifyCallResult(
421     bool success,
422     bytes memory returndata,
423     string memory errorMessage
424   ) internal pure returns (bytes memory) {
425     if (success) {
426       return returndata;
427     } else {
428       // Look for revert reason and bubble it up if present
429       if (returndata.length > 0) {
430         // The easiest way to bubble the revert reason is using memory via assembly
431 
432         assembly {
433           let returndata_size := mload(returndata)
434           revert(add(32, returndata), returndata_size)
435         }
436       } else {
437         revert(errorMessage);
438       }
439     }
440   }
441 }
442 
443 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Provides information about the current execution context, including the
449  * sender of the transaction and its data. While these are generally available
450  * via msg.sender and msg.data, they should not be accessed in such a direct
451  * manner, since when dealing with meta-transactions the account sending and
452  * paying for execution may not be the actual sender (as far as an application
453  * is concerned).
454  *
455  * This contract is only required for intermediate, library-like contracts.
456  */
457 abstract contract Context {
458   function _msgSender() internal view virtual returns (address) {
459     return msg.sender;
460   }
461 
462   function _msgData() internal view virtual returns (bytes calldata) {
463     return msg.data;
464   }
465 }
466 
467 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev String operations.
473  */
474 library Strings {
475   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
476 
477   /**
478    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
479    */
480   function toString(uint256 value) internal pure returns (string memory) {
481     // Inspired by OraclizeAPI's implementation - MIT licence
482     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
483 
484     if (value == 0) {
485       return '0';
486     }
487     uint256 temp = value;
488     uint256 digits;
489     while (temp != 0) {
490       digits++;
491       temp /= 10;
492     }
493     bytes memory buffer = new bytes(digits);
494     while (value != 0) {
495       digits -= 1;
496       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
497       value /= 10;
498     }
499     return string(buffer);
500   }
501 
502   /**
503    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
504    */
505   function toHexString(uint256 value) internal pure returns (string memory) {
506     if (value == 0) {
507       return '0x00';
508     }
509     uint256 temp = value;
510     uint256 length = 0;
511     while (temp != 0) {
512       length++;
513       temp >>= 8;
514     }
515     return toHexString(value, length);
516   }
517 
518   /**
519    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
520    */
521   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
522     bytes memory buffer = new bytes(2 * length + 2);
523     buffer[0] = '0';
524     buffer[1] = 'x';
525     for (uint256 i = 2 * length + 1; i > 1; --i) {
526       buffer[i] = _HEX_SYMBOLS[value & 0xf];
527       value >>= 4;
528     }
529     require(value == 0, 'Strings: hex length insufficient');
530     return string(buffer);
531   }
532 }
533 
534 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * ```solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * ```
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553   /**
554    * @dev See {IERC165-supportsInterface}.
555    */
556   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557     return interfaceId == type(IERC165).interfaceId;
558   }
559 }
560 
561 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
567  * the Metadata extension, but not including the Enumerable extension, which is available separately as
568  * {ERC721Enumerable}.
569  */
570 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
571   using Address for address;
572   using Strings for uint256;
573 
574   // Token name
575   string private _name;
576 
577   // Token symbol
578   string private _symbol;
579 
580   // Mapping from token ID to owner address
581   mapping(uint256 => address) private _owners;
582 
583   // Mapping owner address to token count
584   mapping(address => uint256) private _balances;
585 
586   // Mapping from token ID to approved address
587   mapping(uint256 => address) private _tokenApprovals;
588 
589   // Mapping from owner to operator approvals
590   mapping(address => mapping(address => bool)) private _operatorApprovals;
591 
592   /**
593    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
594    */
595   constructor(string memory name_, string memory symbol_) {
596     _name = name_;
597     _symbol = symbol_;
598   }
599 
600   /**
601    * @dev See {IERC165-supportsInterface}.
602    */
603   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
604     return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
605   }
606 
607   /**
608    * @dev See {IERC721-balanceOf}.
609    */
610   function balanceOf(address owner) public view virtual override returns (uint256) {
611     require(owner != address(0), 'ERC721: balance query for the zero address');
612     return _balances[owner];
613   }
614 
615   /**
616    * @dev See {IERC721-ownerOf}.
617    */
618   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
619     address owner = _owners[tokenId];
620     require(owner != address(0), 'ERC721: owner query for nonexistent token');
621     return owner;
622   }
623 
624   /**
625    * @dev See {IERC721Metadata-name}.
626    */
627   function name() public view virtual override returns (string memory) {
628     return _name;
629   }
630 
631   /**
632    * @dev See {IERC721Metadata-symbol}.
633    */
634   function symbol() public view virtual override returns (string memory) {
635     return _symbol;
636   }
637 
638   /**
639    * @dev See {IERC721Metadata-tokenURI}.
640    */
641   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
642     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
643 
644     string memory baseURI = _baseURI();
645     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
646   }
647 
648   /**
649    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
650    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
651    * by default, can be overriden in child contracts.
652    */
653   function _baseURI() internal view virtual returns (string memory) {
654     return '';
655   }
656 
657   /**
658    * @dev See {IERC721-approve}.
659    */
660   function approve(address to, uint256 tokenId) public virtual override {
661     address owner = ERC721.ownerOf(tokenId);
662     require(to != owner, 'ERC721: approval to current owner');
663 
664     require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
665 
666     _approve(to, tokenId);
667   }
668 
669   /**
670    * @dev See {IERC721-getApproved}.
671    */
672   function getApproved(uint256 tokenId) public view virtual override returns (address) {
673     require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
674 
675     return _tokenApprovals[tokenId];
676   }
677 
678   /**
679    * @dev See {IERC721-setApprovalForAll}.
680    */
681   function setApprovalForAll(address operator, bool approved) public virtual override {
682     require(operator != _msgSender(), 'ERC721: approve to caller');
683 
684     _operatorApprovals[_msgSender()][operator] = approved;
685     emit ApprovalForAll(_msgSender(), operator, approved);
686   }
687 
688   /**
689    * @dev See {IERC721-isApprovedForAll}.
690    */
691   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
692     return _operatorApprovals[owner][operator];
693   }
694 
695   /**
696    * @dev See {IERC721-transferFrom}.
697    */
698   function transferFrom(
699     address from,
700     address to,
701     uint256 tokenId
702   ) public virtual override {
703     //solhint-disable-next-line max-line-length
704     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
705 
706     _transfer(from, to, tokenId);
707   }
708 
709   /**
710    * @dev See {IERC721-safeTransferFrom}.
711    */
712   function safeTransferFrom(
713     address from,
714     address to,
715     uint256 tokenId
716   ) public virtual override {
717     safeTransferFrom(from, to, tokenId, '');
718   }
719 
720   /**
721    * @dev See {IERC721-safeTransferFrom}.
722    */
723   function safeTransferFrom(
724     address from,
725     address to,
726     uint256 tokenId,
727     bytes memory _data
728   ) public virtual override {
729     require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
730     _safeTransfer(from, to, tokenId, _data);
731   }
732 
733   /**
734    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
735    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
736    *
737    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
738    *
739    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
740    * implement alternative mechanisms to perform token transfer, such as signature-based.
741    *
742    * Requirements:
743    *
744    * - `from` cannot be the zero address.
745    * - `to` cannot be the zero address.
746    * - `tokenId` token must exist and be owned by `from`.
747    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748    *
749    * Emits a {Transfer} event.
750    */
751   function _safeTransfer(
752     address from,
753     address to,
754     uint256 tokenId,
755     bytes memory _data
756   ) internal virtual {
757     _transfer(from, to, tokenId);
758     require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
759   }
760 
761   /**
762    * @dev Returns whether `tokenId` exists.
763    *
764    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765    *
766    * Tokens start existing when they are minted (`_mint`),
767    * and stop existing when they are burned (`_burn`).
768    */
769   function _exists(uint256 tokenId) internal view virtual returns (bool) {
770     return _owners[tokenId] != address(0);
771   }
772 
773   /**
774    * @dev Returns whether `spender` is allowed to manage `tokenId`.
775    *
776    * Requirements:
777    *
778    * - `tokenId` must exist.
779    */
780   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
781     require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
782     address owner = ERC721.ownerOf(tokenId);
783     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
784   }
785 
786   /**
787    * @dev Safely mints `tokenId` and transfers it to `to`.
788    *
789    * Requirements:
790    *
791    * - `tokenId` must not exist.
792    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793    *
794    * Emits a {Transfer} event.
795    */
796   function _safeMint(address to, uint256 tokenId) internal virtual {
797     _safeMint(to, tokenId, '');
798   }
799 
800   /**
801    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
802    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
803    */
804   function _safeMint(
805     address to,
806     uint256 tokenId,
807     bytes memory _data
808   ) internal virtual {
809     _mint(to, tokenId);
810     require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
811   }
812 
813   /**
814    * @dev Mints `tokenId` and transfers it to `to`.
815    *
816    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
817    *
818    * Requirements:
819    *
820    * - `tokenId` must not exist.
821    * - `to` cannot be the zero address.
822    *
823    * Emits a {Transfer} event.
824    */
825   function _mint(address to, uint256 tokenId) internal virtual {
826     require(to != address(0), 'ERC721: mint to the zero address');
827     require(!_exists(tokenId), 'ERC721: token already minted');
828 
829     _beforeTokenTransfer(address(0), to, tokenId);
830 
831     _balances[to] += 1;
832     _owners[tokenId] = to;
833 
834     emit Transfer(address(0), to, tokenId);
835   }
836 
837   /**
838    * @dev Destroys `tokenId`.
839    * The approval is cleared when the token is burned.
840    *
841    * Requirements:
842    *
843    * - `tokenId` must exist.
844    *
845    * Emits a {Transfer} event.
846    */
847   function _burn(uint256 tokenId) internal virtual {
848     address owner = ERC721.ownerOf(tokenId);
849 
850     _beforeTokenTransfer(owner, address(0), tokenId);
851 
852     // Clear approvals
853     _approve(address(0), tokenId);
854 
855     _balances[owner] -= 1;
856     delete _owners[tokenId];
857 
858     emit Transfer(owner, address(0), tokenId);
859   }
860 
861   /**
862    * @dev Transfers `tokenId` from `from` to `to`.
863    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
864    *
865    * Requirements:
866    *
867    * - `to` cannot be the zero address.
868    * - `tokenId` token must be owned by `from`.
869    *
870    * Emits a {Transfer} event.
871    */
872   function _transfer(
873     address from,
874     address to,
875     uint256 tokenId
876   ) internal virtual {
877     require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
878     require(to != address(0), 'ERC721: transfer to the zero address');
879 
880     _beforeTokenTransfer(from, to, tokenId);
881 
882     // Clear approvals from the previous owner
883     _approve(address(0), tokenId);
884 
885     _balances[from] -= 1;
886     _balances[to] += 1;
887     _owners[tokenId] = to;
888 
889     emit Transfer(from, to, tokenId);
890   }
891 
892   /**
893    * @dev Approve `to` to operate on `tokenId`
894    *
895    * Emits a {Approval} event.
896    */
897   function _approve(address to, uint256 tokenId) internal virtual {
898     _tokenApprovals[tokenId] = to;
899     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
900   }
901 
902   /**
903    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
904    * The call is not executed if the target address is not a contract.
905    *
906    * @param from address representing the previous owner of the given token ID
907    * @param to target address that will receive the tokens
908    * @param tokenId uint256 ID of the token to be transferred
909    * @param _data bytes optional data to send along with the call
910    * @return bool whether the call correctly returned the expected magic value
911    */
912   function _checkOnERC721Received(
913     address from,
914     address to,
915     uint256 tokenId,
916     bytes memory _data
917   ) private returns (bool) {
918     if (to.isContract()) {
919       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
920         return retval == IERC721Receiver.onERC721Received.selector;
921       } catch (bytes memory reason) {
922         if (reason.length == 0) {
923           revert('ERC721: transfer to non ERC721Receiver implementer');
924         } else {
925           assembly {
926             revert(add(32, reason), mload(reason))
927           }
928         }
929       }
930     } else {
931       return true;
932     }
933   }
934 
935   /**
936    * @dev Hook that is called before any token transfer. This includes minting
937    * and burning.
938    *
939    * Calling conditions:
940    *
941    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
942    * transferred to `to`.
943    * - When `from` is zero, `tokenId` will be minted for `to`.
944    * - When `to` is zero, ``from``'s `tokenId` will be burned.
945    * - `from` and `to` are never both zero.
946    *
947    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
948    */
949   function _beforeTokenTransfer(
950     address from,
951     address to,
952     uint256 tokenId
953   ) internal virtual {}
954 }
955 
956 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
962  * @dev See https://eips.ethereum.org/EIPS/eip-721
963  */
964 interface IERC721Enumerable is IERC721 {
965   /**
966    * @dev Returns the total amount of tokens stored by the contract.
967    */
968   function totalSupply() external view returns (uint256);
969 
970   /**
971    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
972    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
973    */
974   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
975 
976   /**
977    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
978    * Use along with {totalSupply} to enumerate all tokens.
979    */
980   function tokenByIndex(uint256 index) external view returns (uint256);
981 }
982 
983 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
984 
985 pragma solidity ^0.8.0;
986 
987 /**
988  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
989  * enumerability of all the token ids in the contract as well as all token ids owned by each
990  * account.
991  */
992 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
993   // Mapping from owner to list of owned token IDs
994   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
995 
996   // Mapping from token ID to index of the owner tokens list
997   mapping(uint256 => uint256) private _ownedTokensIndex;
998 
999   // Array with all token ids, used for enumeration
1000   uint256[] private _allTokens;
1001 
1002   // Mapping from token id to position in the allTokens array
1003   mapping(uint256 => uint256) private _allTokensIndex;
1004 
1005   /**
1006    * @dev See {IERC165-supportsInterface}.
1007    */
1008   function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1009     return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1010   }
1011 
1012   /**
1013    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1014    */
1015   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1016     require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1017     return _ownedTokens[owner][index];
1018   }
1019 
1020   /**
1021    * @dev See {IERC721Enumerable-totalSupply}.
1022    */
1023   function totalSupply() public view virtual override returns (uint256) {
1024     return _allTokens.length;
1025   }
1026 
1027   /**
1028    * @dev See {IERC721Enumerable-tokenByIndex}.
1029    */
1030   function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1031     require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1032     return _allTokens[index];
1033   }
1034 
1035   /**
1036    * @dev Hook that is called before any token transfer. This includes minting
1037    * and burning.
1038    *
1039    * Calling conditions:
1040    *
1041    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1042    * transferred to `to`.
1043    * - When `from` is zero, `tokenId` will be minted for `to`.
1044    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1045    * - `from` cannot be the zero address.
1046    * - `to` cannot be the zero address.
1047    *
1048    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049    */
1050   function _beforeTokenTransfer(
1051     address from,
1052     address to,
1053     uint256 tokenId
1054   ) internal virtual override {
1055     super._beforeTokenTransfer(from, to, tokenId);
1056 
1057     if (from == address(0)) {
1058       _addTokenToAllTokensEnumeration(tokenId);
1059     } else if (from != to) {
1060       _removeTokenFromOwnerEnumeration(from, tokenId);
1061     }
1062     if (to == address(0)) {
1063       _removeTokenFromAllTokensEnumeration(tokenId);
1064     } else if (to != from) {
1065       _addTokenToOwnerEnumeration(to, tokenId);
1066     }
1067   }
1068 
1069   /**
1070    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1071    * @param to address representing the new owner of the given token ID
1072    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1073    */
1074   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1075     uint256 length = ERC721.balanceOf(to);
1076     _ownedTokens[to][length] = tokenId;
1077     _ownedTokensIndex[tokenId] = length;
1078   }
1079 
1080   /**
1081    * @dev Private function to add a token to this extension's token tracking data structures.
1082    * @param tokenId uint256 ID of the token to be added to the tokens list
1083    */
1084   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1085     _allTokensIndex[tokenId] = _allTokens.length;
1086     _allTokens.push(tokenId);
1087   }
1088 
1089   /**
1090    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1091    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1092    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1093    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1094    * @param from address representing the previous owner of the given token ID
1095    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1096    */
1097   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1098     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1099     // then delete the last slot (swap and pop).
1100 
1101     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1102     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1103 
1104     // When the token to delete is the last token, the swap operation is unnecessary
1105     if (tokenIndex != lastTokenIndex) {
1106       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1107 
1108       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1109       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1110     }
1111 
1112     // This also deletes the contents at the last position of the array
1113     delete _ownedTokensIndex[tokenId];
1114     delete _ownedTokens[from][lastTokenIndex];
1115   }
1116 
1117   /**
1118    * @dev Private function to remove a token from this extension's token tracking data structures.
1119    * This has O(1) time complexity, but alters the order of the _allTokens array.
1120    * @param tokenId uint256 ID of the token to be removed from the tokens list
1121    */
1122   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1123     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1124     // then delete the last slot (swap and pop).
1125 
1126     uint256 lastTokenIndex = _allTokens.length - 1;
1127     uint256 tokenIndex = _allTokensIndex[tokenId];
1128 
1129     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1130     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1131     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1132     uint256 lastTokenId = _allTokens[lastTokenIndex];
1133 
1134     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1135     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1136 
1137     // This also deletes the contents at the last position of the array
1138     delete _allTokensIndex[tokenId];
1139     _allTokens.pop();
1140   }
1141 }
1142 
1143 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 /**
1148  * @dev Contract module which provides a basic access control mechanism, where
1149  * there is an account (an owner) that can be granted exclusive access to
1150  * specific functions.
1151  *
1152  * By default, the owner account will be the one that deploys the contract. This
1153  * can later be changed with {transferOwnership}.
1154  *
1155  * This module is used through inheritance. It will make available the modifier
1156  * `onlyOwner`, which can be applied to your functions to restrict their use to
1157  * the owner.
1158  */
1159 abstract contract Ownable is Context {
1160   address private _owner;
1161 
1162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1163 
1164   /**
1165    * @dev Initializes the contract setting the deployer as the initial owner.
1166    */
1167   constructor() {
1168     _setOwner(_msgSender());
1169   }
1170 
1171   /**
1172    * @dev Returns the address of the current owner.
1173    */
1174   function owner() public view virtual returns (address) {
1175     return _owner;
1176   }
1177 
1178   /**
1179    * @dev Throws if called by any account other than the owner.
1180    */
1181   modifier onlyOwner() {
1182     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1183     _;
1184   }
1185 
1186   /**
1187    * @dev Leaves the contract without owner. It will not be possible to call
1188    * `onlyOwner` functions anymore. Can only be called by the current owner.
1189    *
1190    * NOTE: Renouncing ownership will leave the contract without an owner,
1191    * thereby removing any functionality that is only available to the owner.
1192    */
1193   function renounceOwnership() public virtual onlyOwner {
1194     _setOwner(address(0));
1195   }
1196 
1197   /**
1198    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1199    * Can only be called by the current owner.
1200    */
1201   function transferOwnership(address newOwner) public virtual onlyOwner {
1202     require(newOwner != address(0), 'Ownable: new owner is the zero address');
1203     _setOwner(newOwner);
1204   }
1205 
1206   function _setOwner(address newOwner) private {
1207     address oldOwner = _owner;
1208     _owner = newOwner;
1209     emit OwnershipTransferred(oldOwner, newOwner);
1210   }
1211 }
1212 
1213 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @dev Contract module that helps prevent reentrant calls to a function.
1219  *
1220  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1221  * available, which can be applied to functions to make sure there are no nested
1222  * (reentrant) calls to them.
1223  *
1224  * Note that because there is a single `nonReentrant` guard, functions marked as
1225  * `nonReentrant` may not call one another. This can be worked around by making
1226  * those functions `private`, and then adding `external` `nonReentrant` entry
1227  * points to them.
1228  *
1229  * TIP: If you would like to learn more about reentrancy and alternative ways
1230  * to protect against it, check out our blog post
1231  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1232  */
1233 abstract contract ReentrancyGuard {
1234   // Booleans are more expensive than uint256 or any type that takes up a full
1235   // word because each write operation emits an extra SLOAD to first read the
1236   // slot's contents, replace the bits taken up by the boolean, and then write
1237   // back. This is the compiler's defense against contract upgrades and
1238   // pointer aliasing, and it cannot be disabled.
1239 
1240   // The values being non-zero value makes deployment a bit more expensive,
1241   // but in exchange the refund on every call to nonReentrant will be lower in
1242   // amount. Since refunds are capped to a percentage of the total
1243   // transaction's gas, it is best to keep them low in cases like this one, to
1244   // increase the likelihood of the full refund coming into effect.
1245   uint256 private constant _NOT_ENTERED = 1;
1246   uint256 private constant _ENTERED = 2;
1247 
1248   uint256 private _status;
1249 
1250   constructor() {
1251     _status = _NOT_ENTERED;
1252   }
1253 
1254   /**
1255    * @dev Prevents a contract from calling itself, directly or indirectly.
1256    * Calling a `nonReentrant` function from another `nonReentrant`
1257    * function is not supported. It is possible to prevent this from happening
1258    * by making the `nonReentrant` function external, and make it call a
1259    * `private` function that does the actual work.
1260    */
1261   modifier nonReentrant() {
1262     // On the first call to nonReentrant, _notEntered will be true
1263     require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
1264 
1265     // Any calls to nonReentrant after this point will fail
1266     _status = _ENTERED;
1267 
1268     _;
1269 
1270     // By storing the original value once again, a refund is triggered (see
1271     // https://eips.ethereum.org/EIPS/eip-2200)
1272     _status = _NOT_ENTERED;
1273   }
1274 }
1275 
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 interface CyberKongzInterface {
1280         function balanceOf(address owner) external view  returns (uint256 qty);
1281 
1282 }
1283 
1284 interface CyberKongzVXInterface {
1285             function balanceOf(address owner) external view  returns (uint256 qty);
1286 
1287 }
1288 
1289 
1290 contract Squareka is ERC721Enumerable, Ownable, ReentrancyGuard {
1291 
1292   bool public saleActive = false;
1293   uint256 public constant maxSupply = 4444;
1294   uint256 public PulicSaleTime=1634680800;
1295   uint256 public PreSaleTime=1634594400;
1296 
1297   uint256 public mintPrice = 0.044 * 10**18;
1298   string public baseTokenURI;
1299   uint256 public mintedTokens;
1300   
1301 
1302   address public CyberKongz = 0x57a204AA1042f6E66DD7730813f4024114d74f37;
1303   address public CyberKongzVX = 0x7EA3Cca10668B8346aeC0bf1844A49e995527c8B;
1304 
1305    mapping(address => bool) public whitelisted;
1306 
1307 constructor(string memory _newBaseURI )
1308        public ERC721("Squareka", "SKA")
1309    {     setBaseURI(_newBaseURI);}
1310 
1311 
1312   CyberKongzInterface ContractOfKongz = CyberKongzInterface(CyberKongz);
1313   CyberKongzVXInterface ContractOfKongzVX = CyberKongzVXInterface(CyberKongzVX);
1314  
1315  
1316   // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
1317   function _baseURI() internal view virtual override returns (string memory) {
1318     return baseTokenURI;
1319   }
1320 
1321 
1322 
1323   // See which address owns which tokens
1324   function tokensOfOwner(address _ownerAddress) public view returns (uint256[] memory) {
1325     uint256 tokenCount = balanceOf(_ownerAddress);
1326     uint256[] memory tokenIds = new uint256[](tokenCount);
1327     for (uint256 i; i < tokenCount; i++) {
1328       tokenIds[i] = tokenOfOwnerByIndex(_ownerAddress, i);
1329     }
1330     return tokenIds;
1331   }
1332 
1333   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1334     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1335     return super.tokenURI(tokenId);
1336   }
1337 
1338 
1339 
1340   // Standard mint function, with qty , check supply and eth supplied 
1341 
1342   function mint(uint256 mintQty) public payable {
1343     uint256 curTime=block.timestamp;
1344     require(saleActive, "Sale not started");
1345     require(curTime >= PulicSaleTime, "Public sale is not active yet");
1346     require(mintQty <= 10, "Only Max 10 Mint per transaction");
1347     require(msg.value == mintQty * mintPrice, "Ether value sent is not correct");
1348     require(mintedTokens + mintQty <= maxSupply, "Exceeding max supply.");
1349      for (uint256 i; i < mintQty; i++) {
1350                 uint mintIndex = mintedTokens + 1;
1351                     mintedTokens += 1;
1352                     _safeMint(msg.sender, mintIndex);
1353             }
1354     
1355       }
1356       
1357       
1358         function mintPreSale(uint256 mintQty) public payable {
1359     bool eligible = checkEligible(msg.sender);
1360     uint256 curTime=block.timestamp;
1361     uint256 ubal = balanceOf(msg.sender);
1362     uint256 allowedMint = 5-ubal;
1363     require(eligible, "Mint is open for whitelisted members.");
1364     require(saleActive, "Sale not started");
1365     require(curTime >= PreSaleTime, "Pre sale is not active yet");
1366     require(curTime < PulicSaleTime, "Pre sale is now closed");
1367     require(mintQty <= allowedMint, "Only Max 5 Mint Per Wallet In Presale");
1368     require(msg.value == mintQty * mintPrice, "Ether value sent is not correct");
1369     require(mintedTokens + mintQty <= maxSupply, "Exceeding max supply.");
1370      for (uint256 i; i < mintQty; i++) {
1371                 uint mintIndex = mintedTokens + 1;
1372                     mintedTokens += 1;
1373                     _safeMint(msg.sender, mintIndex);
1374                 
1375             }
1376     
1377       }
1378 
1379       function mintForGiveaway(uint256 mintQty) public onlyOwner{
1380          require(mintedTokens + mintQty <= maxSupply, "Exceeding max supply.");
1381             for (uint256 i; i < mintQty; i++) {
1382                 uint mintIndex = mintedTokens + 1;
1383                     mintedTokens += 1;
1384                     _safeMint(msg.sender, mintIndex);
1385                 
1386             }
1387           
1388       }
1389       
1390       function checkEligible(address addy) public view returns( bool ){
1391           bool reply=false;
1392 
1393           if(ContractOfKongz.balanceOf(addy) >= 1){
1394               reply=true;
1395           } else if(ContractOfKongzVX.balanceOf(addy) >= 1){
1396               reply=true; }
1397           else if(whitelisted[addy]){
1398              reply=true;
1399          }
1400           return reply;
1401       }
1402 
1403 
1404 function addListOfUsersToWhiteList(address [] calldata _user) external onlyOwner{
1405             for(uint256 i; i <_user.length; i++ ){
1406                 if(whitelisted[_user[i]]){
1407                     continue;
1408                 }
1409                 whitelisted[_user[i]] = true;
1410             }
1411         }
1412         
1413         
1414   // Set start and close time
1415   function setPublicSaleStartTime(uint256 _startTime) public onlyOwner {
1416     PulicSaleTime = _startTime;
1417   }
1418   
1419     function setPreSaleStartTime(uint256 _startTime) public onlyOwner {
1420     PreSaleTime = _startTime;
1421   }
1422 
1423   
1424   function getContractBalance() public view returns(uint256){
1425       return address(this).balance;
1426   }
1427   
1428   
1429   
1430   // Start and stop sale
1431   function setSaleActive(bool _saleActive) public onlyOwner {
1432     saleActive = _saleActive;
1433   }
1434   
1435 
1436 
1437   // Set new baseURI
1438   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1439     baseTokenURI = _newBaseURI;
1440   }
1441   
1442   
1443     
1444     
1445     
1446 function withdraw(uint256 _amount) public onlyOwner {
1447     (bool success, ) = msg.sender.call{value: _amount}('');
1448     require(success, 'Transfer failed.');
1449   }
1450 
1451 
1452 
1453 }