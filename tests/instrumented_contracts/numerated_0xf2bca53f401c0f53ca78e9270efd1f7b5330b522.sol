1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-31
3 */
4 
5 // Sources flattened with hardhat v2.5.0 https://hardhat.org
6  
7 // File contracts/utils/introspection/IERC165.sol
8  
9 // SPDX-License-Identifier: MIT
10  
11 pragma solidity ^0.8.0;
12  
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33  
34  
35 // File contracts/token/ERC721/IERC721.sol
36  
37  
38  
39 pragma solidity ^0.8.0;
40  
41 /**
42  * @dev Required interface of an ERC721 compliant contract.
43  */
44 interface IERC721 is IERC165 {
45     /**
46      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49  
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54  
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
59  
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64  
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73  
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(address from, address to, uint256 tokenId) external;
89  
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(address from, address to, uint256 tokenId) external;
105  
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120  
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129  
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141  
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148  
149     /**
150       * @dev Safely transfers `tokenId` token from `from` to `to`.
151       *
152       * Requirements:
153       *
154       * - `from` cannot be the zero address.
155       * - `to` cannot be the zero address.
156       * - `tokenId` token must exist and be owned by `from`.
157       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159       *
160       * Emits a {Transfer} event.
161       */
162     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
163 }
164  
165  
166 // File contracts/token/ERC721/IERC721Receiver.sol
167  
168  
169  
170 pragma solidity ^0.8.0;
171  
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
186      */
187     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
188 }
189  
190  
191 // File contracts/token/ERC721/extensions/IERC721Metadata.sol
192  
193  
194  
195 pragma solidity ^0.8.0;
196  
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202  
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207  
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212  
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218  
219  
220 // File contracts/utils/Address.sol
221  
222  
223  
224 pragma solidity ^0.8.0;
225  
226 /**
227  * @dev Collection of functions related to the address type
228  */
229 library Address {
230     /**
231      * @dev Returns true if `account` is a contract.
232      *
233      * [IMPORTANT]
234      * ====
235      * It is unsafe to assume that an address for which this function returns
236      * false is an externally-owned account (EOA) and not a contract.
237      *
238      * Among others, `isContract` will return false for the following
239      * types of addresses:
240      *
241      *  - an externally-owned account
242      *  - a contract in construction
243      *  - an address where a contract will be created
244      *  - an address where a contract lived, but was destroyed
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // This method relies on extcodesize, which returns 0 for contracts in
249         // construction, since the code is only stored at the end of the
250         // constructor execution.
251  
252         uint256 size;
253         // solhint-disable-next-line no-inline-assembly
254         assembly { size := extcodesize(account) }
255         return size > 0;
256     }
257  
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276  
277         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281  
282     /**
283      * @dev Performs a Solidity function call using a low level `call`. A
284      * plain`call` is an unsafe replacement for a function call: use this
285      * function instead.
286      *
287      * If `target` reverts with a revert reason, it is bubbled up by this
288      * function (like regular Solidity function calls).
289      *
290      * Returns the raw returned data. To convert to the expected return value,
291      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292      *
293      * Requirements:
294      *
295      * - `target` must be a contract.
296      * - calling `target` with `data` must not revert.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301       return functionCall(target, data, "Address: low-level call failed");
302     }
303  
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306      * `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313  
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328  
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338  
339         // solhint-disable-next-line avoid-low-level-calls
340         (bool success, bytes memory returndata) = target.call{ value: value }(data);
341         return _verifyCallResult(success, returndata, errorMessage);
342     }
343  
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
351         return functionStaticCall(target, data, "Address: low-level static call failed");
352     }
353  
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362  
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.staticcall(data);
365         return _verifyCallResult(success, returndata, errorMessage);
366     }
367  
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
376     }
377  
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386  
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.delegatecall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391  
392     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399  
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411  
412  
413 // File contracts/utils/Context.sol
414  
415  
416  
417 pragma solidity ^0.8.0;
418  
419 /*
420  * @dev Provides information about the current execution context, including the
421  * sender of the transaction and its data. While these are generally available
422  * via msg.sender and msg.data, they should not be accessed in such a direct
423  * manner, since when dealing with meta-transactions the account sending and
424  * paying for execution may not be the actual sender (as far as an application
425  * is concerned).
426  *
427  * This contract is only required for intermediate, library-like contracts.
428  */
429 abstract contract Context {
430     function _msgSender() internal view virtual returns (address) {
431         return msg.sender;
432     }
433  
434     function _msgData() internal view virtual returns (bytes calldata) {
435         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
436         return msg.data;
437     }
438 }
439  
440  
441 // File contracts/utils/Strings.sol
442  
443  
444  
445 pragma solidity ^0.8.0;
446  
447 /**
448  * @dev String operations.
449  */
450 library Strings {
451     bytes16 private constant alphabet = "0123456789abcdef";
452  
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
455      */
456     function toString(uint256 value) internal pure returns (string memory) {
457         // Inspired by OraclizeAPI's implementation - MIT licence
458         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
459  
460         if (value == 0) {
461             return "0";
462         }
463         uint256 temp = value;
464         uint256 digits;
465         while (temp != 0) {
466             digits++;
467             temp /= 10;
468         }
469         bytes memory buffer = new bytes(digits);
470         while (value != 0) {
471             digits -= 1;
472             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
473             value /= 10;
474         }
475         return string(buffer);
476     }
477  
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
480      */
481     function toHexString(uint256 value) internal pure returns (string memory) {
482         if (value == 0) {
483             return "0x00";
484         }
485         uint256 temp = value;
486         uint256 length = 0;
487         while (temp != 0) {
488             length++;
489             temp >>= 8;
490         }
491         return toHexString(value, length);
492     }
493  
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
496      */
497     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
498         bytes memory buffer = new bytes(2 * length + 2);
499         buffer[0] = "0";
500         buffer[1] = "x";
501         for (uint256 i = 2 * length + 1; i > 1; --i) {
502             buffer[i] = alphabet[value & 0xf];
503             value >>= 4;
504         }
505         require(value == 0, "Strings: hex length insufficient");
506         return string(buffer);
507     }
508  
509 }
510  
511  
512 // File contracts/utils/introspection/ERC165.sol
513  
514  
515  
516 pragma solidity ^0.8.0;
517  
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540  
541  
542 // File contracts/token/ERC721/ERC721.sol
543  
544  
545  
546 pragma solidity ^0.8.0;
547  
548  
549  
550  
551  
552  
553  
554 /**
555  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
556  * the Metadata extension, but not including the Enumerable extension, which is available separately as
557  * {ERC721Enumerable}.
558  */
559 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
560     using Address for address;
561     using Strings for uint256;
562  
563     // Token name
564     string private _name;
565  
566     // Token symbol
567     string private _symbol;
568  
569     // Mapping from token ID to owner address
570     mapping (uint256 => address) private _owners;
571  
572     // Mapping owner address to token count
573     mapping (address => uint256) private _balances;
574  
575     // Mapping from token ID to approved address
576     mapping (uint256 => address) private _tokenApprovals;
577  
578     // Mapping from owner to operator approvals
579     mapping (address => mapping (address => bool)) private _operatorApprovals;
580  
581     /**
582      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
583      */
584     constructor (string memory name_, string memory symbol_) {
585         _name = name_;
586         _symbol = symbol_;
587     }
588  
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
593         return interfaceId == type(IERC721).interfaceId
594             || interfaceId == type(IERC721Metadata).interfaceId
595             || super.supportsInterface(interfaceId);
596     }
597  
598     /**
599      * @dev See {IERC721-balanceOf}.
600      */
601     function balanceOf(address owner) public view virtual override returns (uint256) {
602         require(owner != address(0), "ERC721: balance query for the zero address");
603         return _balances[owner];
604     }
605  
606     /**
607      * @dev See {IERC721-ownerOf}.
608      */
609     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
610         address owner = _owners[tokenId];
611         require(owner != address(0), "ERC721: owner query for nonexistent token");
612         return owner;
613     }
614  
615     /**
616      * @dev See {IERC721Metadata-name}.
617      */
618     function name() public view virtual override returns (string memory) {
619         return _name;
620     }
621  
622     /**
623      * @dev See {IERC721Metadata-symbol}.
624      */
625     function symbol() public view virtual override returns (string memory) {
626         return _symbol;
627     }
628  
629     /**
630      * @dev See {IERC721Metadata-tokenURI}.
631      */
632     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
633         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
634  
635         string memory baseURI = _baseURI();
636         return bytes(baseURI).length > 0
637             ? string(abi.encodePacked(baseURI, tokenId.toString()))
638             : '';
639     }
640  
641     /**
642      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
643      * in child contracts.
644      */
645     function _baseURI() internal view virtual returns (string memory) {
646         return "";
647     }
648  
649     /**
650      * @dev See {IERC721-approve}.
651      */
652     function approve(address to, uint256 tokenId) public virtual override {
653         address owner = ERC721.ownerOf(tokenId);
654         require(to != owner, "ERC721: approval to current owner");
655  
656         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
657             "ERC721: approve caller is not owner nor approved for all"
658         );
659  
660         _approve(to, tokenId);
661     }
662  
663     /**
664      * @dev See {IERC721-getApproved}.
665      */
666     function getApproved(uint256 tokenId) public view virtual override returns (address) {
667         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
668  
669         return _tokenApprovals[tokenId];
670     }
671  
672     /**
673      * @dev See {IERC721-setApprovalForAll}.
674      */
675     function setApprovalForAll(address operator, bool approved) public virtual override {
676         require(operator != _msgSender(), "ERC721: approve to caller");
677  
678         _operatorApprovals[_msgSender()][operator] = approved;
679         emit ApprovalForAll(_msgSender(), operator, approved);
680     }
681  
682     /**
683      * @dev See {IERC721-isApprovedForAll}.
684      */
685     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
686         return _operatorApprovals[owner][operator];
687     }
688  
689     /**
690      * @dev See {IERC721-transferFrom}.
691      */
692     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
693         //solhint-disable-next-line max-line-length
694         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
695  
696         _transfer(from, to, tokenId);
697     }
698  
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
703         safeTransferFrom(from, to, tokenId, "");
704     }
705  
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
710         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
711         _safeTransfer(from, to, tokenId, _data);
712     }
713  
714     /**
715      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
716      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
717      *
718      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
719      *
720      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
721      * implement alternative mechanisms to perform token transfer, such as signature-based.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must exist and be owned by `from`.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
733         _transfer(from, to, tokenId);
734         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
735     }
736  
737     /**
738      * @dev Returns whether `tokenId` exists.
739      *
740      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
741      *
742      * Tokens start existing when they are minted (`_mint`),
743      * and stop existing when they are burned (`_burn`).
744      */
745     function _exists(uint256 tokenId) internal view virtual returns (bool) {
746         return _owners[tokenId] != address(0);
747     }
748  
749     /**
750      * @dev Returns whether `spender` is allowed to manage `tokenId`.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
757         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
758         address owner = ERC721.ownerOf(tokenId);
759         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
760     }
761  
762     /**
763      * @dev Safely mints `tokenId` and transfers it to `to`.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must not exist.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeMint(address to, uint256 tokenId) internal virtual {
773         _safeMint(to, tokenId, "");
774     }
775  
776     /**
777      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
778      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
779      */
780     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
781         _mint(to, tokenId);
782         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
783     }
784  
785     /**
786      * @dev Mints `tokenId` and transfers it to `to`.
787      *
788      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
789      *
790      * Requirements:
791      *
792      * - `tokenId` must not exist.
793      * - `to` cannot be the zero address.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _mint(address to, uint256 tokenId) internal virtual {
798         require(to != address(0), "ERC721: mint to the zero address");
799         require(!_exists(tokenId), "ERC721: token already minted");
800  
801         _beforeTokenTransfer(address(0), to, tokenId);
802  
803         _balances[to] += 1;
804         _owners[tokenId] = to;
805  
806         emit Transfer(address(0), to, tokenId);
807     }
808  
809     /**
810      * @dev Destroys `tokenId`.
811      * The approval is cleared when the token is burned.
812      *
813      * Requirements:
814      *
815      * - `tokenId` must exist.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _burn(uint256 tokenId) internal virtual {
820         address owner = ERC721.ownerOf(tokenId);
821  
822         _beforeTokenTransfer(owner, address(0), tokenId);
823  
824         // Clear approvals
825         _approve(address(0), tokenId);
826  
827         _balances[owner] -= 1;
828         delete _owners[tokenId];
829  
830         emit Transfer(owner, address(0), tokenId);
831     }
832  
833     /**
834      * @dev Transfers `tokenId` from `from` to `to`.
835      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must be owned by `from`.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _transfer(address from, address to, uint256 tokenId) internal virtual {
845         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
846         require(to != address(0), "ERC721: transfer to the zero address");
847  
848         _beforeTokenTransfer(from, to, tokenId);
849  
850         // Clear approvals from the previous owner
851         _approve(address(0), tokenId);
852  
853         _balances[from] -= 1;
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856  
857         emit Transfer(from, to, tokenId);
858     }
859  
860     /**
861      * @dev Approve `to` to operate on `tokenId`
862      *
863      * Emits a {Approval} event.
864      */
865     function _approve(address to, uint256 tokenId) internal virtual {
866         _tokenApprovals[tokenId] = to;
867         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
868     }
869  
870     /**
871      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
872      * The call is not executed if the target address is not a contract.
873      *
874      * @param from address representing the previous owner of the given token ID
875      * @param to target address that will receive the tokens
876      * @param tokenId uint256 ID of the token to be transferred
877      * @param _data bytes optional data to send along with the call
878      * @return bool whether the call correctly returned the expected magic value
879      */
880     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
881         private returns (bool)
882     {
883         if (to.isContract()) {
884             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
885                 return retval == IERC721Receiver(to).onERC721Received.selector;
886             } catch (bytes memory reason) {
887                 if (reason.length == 0) {
888                     revert("ERC721: transfer to non ERC721Receiver implementer");
889                 } else {
890                     // solhint-disable-next-line no-inline-assembly
891                     assembly {
892                         revert(add(32, reason), mload(reason))
893                     }
894                 }
895             }
896         } else {
897             return true;
898         }
899     }
900  
901     /**
902      * @dev Hook that is called before any token transfer. This includes minting
903      * and burning.
904      *
905      * Calling conditions:
906      *
907      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
908      * transferred to `to`.
909      * - When `from` is zero, `tokenId` will be minted for `to`.
910      * - When `to` is zero, ``from``'s `tokenId` will be burned.
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      *
914      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
915      */
916     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
917 }
918  
919  
920 // File contracts/token/ERC721/extensions/ERC721URIStorage.sol
921  
922  
923  
924 pragma solidity ^0.8.0;
925  
926 /**
927  * @dev ERC721 token with storage based token URI management.
928  */
929 abstract contract ERC721URIStorage is ERC721 {
930     using Strings for uint256;
931  
932     // Optional mapping for token URIs
933     mapping (uint256 => string) private _tokenURIs;
934  
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
940  
941         string memory _tokenURI = _tokenURIs[tokenId];
942         string memory base = _baseURI();
943  
944         // If there is no base URI, return the token URI.
945         if (bytes(base).length == 0) {
946             return _tokenURI;
947         }
948         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
949         if (bytes(_tokenURI).length > 0) {
950             return string(abi.encodePacked(base, _tokenURI));
951         }
952  
953         return super.tokenURI(tokenId);
954     }
955  
956     /**
957      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      */
963     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
964         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
965         _tokenURIs[tokenId] = _tokenURI;
966     }
967  
968     /**
969      * @dev Destroys `tokenId`.
970      * The approval is cleared when the token is burned.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must exist.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _burn(uint256 tokenId) internal virtual override {
979         super._burn(tokenId);
980  
981         if (bytes(_tokenURIs[tokenId]).length != 0) {
982             delete _tokenURIs[tokenId];
983         }
984     }
985 }
986  
987  
988 // File contracts/access/Ownable.sol
989  
990  
991  
992 pragma solidity ^0.8.0;
993  
994 /**
995  * @dev Contract module which provides a basic access control mechanism, where
996  * there is an account (an owner) that can be granted exclusive access to
997  * specific functions.
998  *
999  * By default, the owner account will be the one that deploys the contract. This
1000  * can later be changed with {transferOwnership}.
1001  *
1002  * This module is used through inheritance. It will make available the modifier
1003  * `onlyOwner`, which can be applied to your functions to restrict their use to
1004  * the owner.
1005  */
1006 abstract contract Ownable is Context {
1007     address private _owner;
1008  
1009     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1010  
1011     /**
1012      * @dev Initializes the contract setting the deployer as the initial owner.
1013      */
1014     constructor () {
1015         address msgSender = _msgSender();
1016         _owner = msgSender;
1017         emit OwnershipTransferred(address(0), msgSender);
1018     }
1019  
1020     /**
1021      * @dev Returns the address of the current owner.
1022      */
1023     function owner() public view virtual returns (address) {
1024         return _owner;
1025     }
1026  
1027     /**
1028      * @dev Throws if called by any account other than the owner.
1029      */
1030     modifier onlyOwner() {
1031         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1032         _;
1033     }
1034  
1035     /**
1036      * @dev Leaves the contract without owner. It will not be possible to call
1037      * `onlyOwner` functions anymore. Can only be called by the current owner.
1038      *
1039      * NOTE: Renouncing ownership will leave the contract without an owner,
1040      * thereby removing any functionality that is only available to the owner.
1041      */
1042     function renounceOwnership() public virtual onlyOwner {
1043         emit OwnershipTransferred(_owner, address(0));
1044         _owner = address(0);
1045     }
1046  
1047     /**
1048      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1049      * Can only be called by the current owner.
1050      */
1051     function transferOwnership(address newOwner) public virtual onlyOwner {
1052         require(newOwner != address(0), "Ownable: new owner is the zero address");
1053         emit OwnershipTransferred(_owner, newOwner);
1054         _owner = newOwner;
1055     }
1056 }
1057  
1058  
1059  
1060 pragma solidity ^0.8.0;
1061  
1062  
1063  
1064 contract GenAlcLab is ERC721URIStorage, Ownable{
1065 
1066     event MintGenApe (address indexed minter, uint256 startWith, uint256 times);
1067    
1068     
1069     uint256 public totalGenApe;
1070     uint256 public totalCount = 3500; //bruhTotal
1071     uint256 public presaleMax = 688; 
1072     uint256 public maxBatch = 10; // bruhBatch
1073     uint256 public price = 55000000000000000; // 0.055 eth
1074     string public baseURI;
1075     bool public started;
1076     bool public whiteListStart;
1077     mapping(address => uint256) whiteListMintCount;
1078     uint addressRegistryCount;
1079     
1080     constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
1081         baseURI = baseURI_;
1082     }
1083     
1084     modifier canWhitelistMint() {
1085         require(whiteListStart, "Hang on boys, youll get in soon");
1086         _; 
1087     }
1088 
1089     modifier mintEnabled() {
1090         require(started, "not started");
1091         _;
1092     }
1093  
1094     function totalSupply() public view virtual returns (uint256) {
1095         return totalGenApe;
1096        
1097     }
1098  
1099     function _baseURI() internal view virtual override returns (string memory){
1100         return baseURI;
1101     }
1102  
1103     function setBaseURI(string memory _newURI) public onlyOwner {
1104         baseURI = _newURI;
1105     }
1106  
1107     function changePrice(uint256 _newPrice) public onlyOwner {
1108         price = _newPrice;
1109     }
1110     
1111  
1112     function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
1113         _setTokenURI(_tokenId, _tokenURI);
1114     }
1115  
1116     function setNormalStart(bool _start) public onlyOwner {
1117         started = _start;
1118     }
1119     
1120     function setWhiteListStart(bool _start) public onlyOwner {
1121         whiteListStart = _start;
1122     }
1123     
1124     function getWhitelistMintAmount(address _addr) public view virtual returns (uint256) {
1125         return whiteListMintCount[_addr];
1126     }
1127  
1128     function mintGenApes(uint256 _times) payable public mintEnabled {
1129        
1130         require(_times >0 && _times <= maxBatch, "mint wrong number");
1131         require(totalGenApe + _times <= totalCount, "too much");
1132         require(msg.value == _times * price, "value error");
1133         payable(owner()).transfer(msg.value);
1134         emit MintGenApe(_msgSender(), totalGenApe+1, _times);
1135         for(uint256 i=0; i< _times; i++){
1136             _mint(_msgSender(), 1 + totalGenApe++);
1137         }
1138     } 
1139     
1140     function adminMint(uint256 _times) payable public onlyOwner {
1141         require(_times >0 && _times <= maxBatch, "mint wrong number");
1142         require(totalGenApe + _times <= totalCount, "too much");
1143         require(msg.value == _times * price, "value error");
1144         payable(owner()).transfer(msg.value);
1145         emit MintGenApe(_msgSender(), totalGenApe+1, _times);
1146         for(uint256 i=0; i< _times; i++){
1147             _mint(_msgSender(), 1 + totalGenApe++);
1148         }
1149     }
1150     
1151     
1152     function whitelistMint(uint _times) payable public canWhitelistMint {
1153         if (whiteListMintCount[msg.sender]==0)  {
1154             whiteListMintCount[msg.sender] = 4;
1155         }
1156         require(whiteListMintCount[msg.sender] - _times >= 1, "Over mint limit for address.");
1157         require(totalGenApe + _times <= presaleMax, "Mint amount will exceed total presale amount.");
1158         require(msg.value == _times * price, "Incorrect transaction value.");
1159         payable(owner()).transfer(msg.value);
1160         whiteListMintCount[_msgSender()] -= _times;
1161         emit MintGenApe(_msgSender(), totalGenApe+1, _times);
1162         for(uint256 i=0; i< _times; i++){
1163             _mint(_msgSender(), 1 + totalGenApe++);
1164         }
1165     }
1166     
1167     
1168     function adminMintGiveaways(address _addr) public onlyOwner {
1169         require(totalGenApe + 1 <= totalCount, "Mint amount will exceed total collection amount.");
1170         emit MintGenApe(_addr, totalGenApe+1, 1);
1171         _mint(_addr, 1 + totalGenApe++);
1172     } 
1173     
1174     
1175     
1176     
1177     
1178 }