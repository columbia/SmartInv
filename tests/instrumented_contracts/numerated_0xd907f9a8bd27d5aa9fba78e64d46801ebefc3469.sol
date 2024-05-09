1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-01
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-31
7 */
8 
9 // Sources flattened with hardhat v2.5.0 https://hardhat.org
10  
11 // File contracts/utils/introspection/IERC165.sol
12  
13 // SPDX-License-Identifier: MIT
14  
15 pragma solidity ^0.8.0;
16  
17 /**
18  * @dev Interface of the ERC165 standard, as defined in the
19  * https://eips.ethereum.org/EIPS/eip-165[EIP].
20  *
21  * Implementers can declare support of contract interfaces, which can then be
22  * queried by others ({ERC165Checker}).
23  *
24  * For an implementation, see {ERC165}.
25  */
26 interface IERC165 {
27     /**
28      * @dev Returns true if this contract implements the interface defined by
29      * `interfaceId`. See the corresponding
30      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
31      * to learn more about how these ids are created.
32      *
33      * This function call must use less than 30 000 gas.
34      */
35     function supportsInterface(bytes4 interfaceId) external view returns (bool);
36 }
37  
38  
39 // File contracts/token/ERC721/IERC721.sol
40  
41  
42  
43 pragma solidity ^0.8.0;
44  
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53  
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58  
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63  
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68  
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77  
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(address from, address to, uint256 tokenId) external;
93  
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(address from, address to, uint256 tokenId) external;
109  
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124  
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133  
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145  
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152  
153     /**
154       * @dev Safely transfers `tokenId` token from `from` to `to`.
155       *
156       * Requirements:
157       *
158       * - `from` cannot be the zero address.
159       * - `to` cannot be the zero address.
160       * - `tokenId` token must exist and be owned by `from`.
161       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163       *
164       * Emits a {Transfer} event.
165       */
166     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
167 }
168  
169  
170 // File contracts/token/ERC721/IERC721Receiver.sol
171  
172  
173  
174 pragma solidity ^0.8.0;
175  
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
192 }
193  
194  
195 // File contracts/token/ERC721/extensions/IERC721Metadata.sol
196  
197  
198  
199 pragma solidity ^0.8.0;
200  
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Metadata is IERC721 {
206  
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211  
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216  
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222  
223  
224 // File contracts/utils/Address.sol
225  
226  
227  
228 pragma solidity ^0.8.0;
229  
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255  
256         uint256 size;
257         // solhint-disable-next-line no-inline-assembly
258         assembly { size := extcodesize(account) }
259         return size > 0;
260     }
261  
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280  
281         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282         (bool success, ) = recipient.call{ value: amount }("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285  
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain`call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305       return functionCall(target, data, "Address: low-level call failed");
306     }
307  
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, 0, errorMessage);
316     }
317  
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but also transferring `value` wei to `target`.
321      *
322      * Requirements:
323      *
324      * - the calling contract must have an ETH balance of at least `value`.
325      * - the called Solidity function must be `payable`.
326      *
327      * _Available since v3.1._
328      */
329     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332  
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342  
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.call{ value: value }(data);
345         return _verifyCallResult(success, returndata, errorMessage);
346     }
347  
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357  
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
365         require(isContract(target), "Address: static call to non-contract");
366  
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371  
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
380     }
381  
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         require(isContract(target), "Address: delegate call to non-contract");
390  
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.delegatecall(data);
393         return _verifyCallResult(success, returndata, errorMessage);
394     }
395  
396     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403  
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415  
416  
417 // File contracts/utils/Context.sol
418  
419  
420  
421 pragma solidity ^0.8.0;
422  
423 /*
424  * @dev Provides information about the current execution context, including the
425  * sender of the transaction and its data. While these are generally available
426  * via msg.sender and msg.data, they should not be accessed in such a direct
427  * manner, since when dealing with meta-transactions the account sending and
428  * paying for execution may not be the actual sender (as far as an application
429  * is concerned).
430  *
431  * This contract is only required for intermediate, library-like contracts.
432  */
433 abstract contract Context {
434     function _msgSender() internal view virtual returns (address) {
435         return msg.sender;
436     }
437  
438     function _msgData() internal view virtual returns (bytes calldata) {
439         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
440         return msg.data;
441     }
442 }
443  
444  
445 // File contracts/utils/Strings.sol
446  
447  
448  
449 pragma solidity ^0.8.0;
450  
451 /**
452  * @dev String operations.
453  */
454 library Strings {
455     bytes16 private constant alphabet = "0123456789abcdef";
456  
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
459      */
460     function toString(uint256 value) internal pure returns (string memory) {
461         // Inspired by OraclizeAPI's implementation - MIT licence
462         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
463  
464         if (value == 0) {
465             return "0";
466         }
467         uint256 temp = value;
468         uint256 digits;
469         while (temp != 0) {
470             digits++;
471             temp /= 10;
472         }
473         bytes memory buffer = new bytes(digits);
474         while (value != 0) {
475             digits -= 1;
476             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
477             value /= 10;
478         }
479         return string(buffer);
480     }
481  
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
484      */
485     function toHexString(uint256 value) internal pure returns (string memory) {
486         if (value == 0) {
487             return "0x00";
488         }
489         uint256 temp = value;
490         uint256 length = 0;
491         while (temp != 0) {
492             length++;
493             temp >>= 8;
494         }
495         return toHexString(value, length);
496     }
497  
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
500      */
501     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
502         bytes memory buffer = new bytes(2 * length + 2);
503         buffer[0] = "0";
504         buffer[1] = "x";
505         for (uint256 i = 2 * length + 1; i > 1; --i) {
506             buffer[i] = alphabet[value & 0xf];
507             value >>= 4;
508         }
509         require(value == 0, "Strings: hex length insufficient");
510         return string(buffer);
511     }
512  
513 }
514  
515  
516 // File contracts/utils/introspection/ERC165.sol
517  
518  
519  
520 pragma solidity ^0.8.0;
521  
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544  
545  
546 // File contracts/token/ERC721/ERC721.sol
547  
548  
549  
550 pragma solidity ^0.8.0;
551  
552  
553  
554  
555  
556  
557  
558 /**
559  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
560  * the Metadata extension, but not including the Enumerable extension, which is available separately as
561  * {ERC721Enumerable}.
562  */
563 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
564     using Address for address;
565     using Strings for uint256;
566  
567     // Token name
568     string private _name;
569  
570     // Token symbol
571     string private _symbol;
572  
573     // Mapping from token ID to owner address
574     mapping (uint256 => address) private _owners;
575  
576     // Mapping owner address to token count
577     mapping (address => uint256) private _balances;
578  
579     // Mapping from token ID to approved address
580     mapping (uint256 => address) private _tokenApprovals;
581  
582     // Mapping from owner to operator approvals
583     mapping (address => mapping (address => bool)) private _operatorApprovals;
584  
585     /**
586      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
587      */
588     constructor (string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591     }
592  
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
597         return interfaceId == type(IERC721).interfaceId
598             || interfaceId == type(IERC721Metadata).interfaceId
599             || super.supportsInterface(interfaceId);
600     }
601  
602     /**
603      * @dev See {IERC721-balanceOf}.
604      */
605     function balanceOf(address owner) public view virtual override returns (uint256) {
606         require(owner != address(0), "ERC721: balance query for the zero address");
607         return _balances[owner];
608     }
609  
610     /**
611      * @dev See {IERC721-ownerOf}.
612      */
613     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
614         address owner = _owners[tokenId];
615         require(owner != address(0), "ERC721: owner query for nonexistent token");
616         return owner;
617     }
618  
619     /**
620      * @dev See {IERC721Metadata-name}.
621      */
622     function name() public view virtual override returns (string memory) {
623         return _name;
624     }
625  
626     /**
627      * @dev See {IERC721Metadata-symbol}.
628      */
629     function symbol() public view virtual override returns (string memory) {
630         return _symbol;
631     }
632  
633     /**
634      * @dev See {IERC721Metadata-tokenURI}.
635      */
636     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
637         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
638  
639         string memory baseURI = _baseURI();
640         return bytes(baseURI).length > 0
641             ? string(abi.encodePacked(baseURI, tokenId.toString()))
642             : '';
643     }
644  
645     /**
646      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
647      * in child contracts.
648      */
649     function _baseURI() internal view virtual returns (string memory) {
650         return "";
651     }
652  
653     /**
654      * @dev See {IERC721-approve}.
655      */
656     function approve(address to, uint256 tokenId) public virtual override {
657         address owner = ERC721.ownerOf(tokenId);
658         require(to != owner, "ERC721: approval to current owner");
659  
660         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
661             "ERC721: approve caller is not owner nor approved for all"
662         );
663  
664         _approve(to, tokenId);
665     }
666  
667     /**
668      * @dev See {IERC721-getApproved}.
669      */
670     function getApproved(uint256 tokenId) public view virtual override returns (address) {
671         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
672  
673         return _tokenApprovals[tokenId];
674     }
675  
676     /**
677      * @dev See {IERC721-setApprovalForAll}.
678      */
679     function setApprovalForAll(address operator, bool approved) public virtual override {
680         require(operator != _msgSender(), "ERC721: approve to caller");
681  
682         _operatorApprovals[_msgSender()][operator] = approved;
683         emit ApprovalForAll(_msgSender(), operator, approved);
684     }
685  
686     /**
687      * @dev See {IERC721-isApprovedForAll}.
688      */
689     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
690         return _operatorApprovals[owner][operator];
691     }
692  
693     /**
694      * @dev See {IERC721-transferFrom}.
695      */
696     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
697         //solhint-disable-next-line max-line-length
698         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
699  
700         _transfer(from, to, tokenId);
701     }
702  
703     /**
704      * @dev See {IERC721-safeTransferFrom}.
705      */
706     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
707         safeTransferFrom(from, to, tokenId, "");
708     }
709  
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
714         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
715         _safeTransfer(from, to, tokenId, _data);
716     }
717  
718     /**
719      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
720      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
721      *
722      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
723      *
724      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
725      * implement alternative mechanisms to perform token transfer, such as signature-based.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
737         _transfer(from, to, tokenId);
738         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
739     }
740  
741     /**
742      * @dev Returns whether `tokenId` exists.
743      *
744      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
745      *
746      * Tokens start existing when they are minted (`_mint`),
747      * and stop existing when they are burned (`_burn`).
748      */
749     function _exists(uint256 tokenId) internal view virtual returns (bool) {
750         return _owners[tokenId] != address(0);
751     }
752  
753     /**
754      * @dev Returns whether `spender` is allowed to manage `tokenId`.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
761         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
762         address owner = ERC721.ownerOf(tokenId);
763         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
764     }
765  
766     /**
767      * @dev Safely mints `tokenId` and transfers it to `to`.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must not exist.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _safeMint(address to, uint256 tokenId) internal virtual {
777         _safeMint(to, tokenId, "");
778     }
779  
780     /**
781      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
782      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
783      */
784     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
785         _mint(to, tokenId);
786         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
787     }
788  
789     /**
790      * @dev Mints `tokenId` and transfers it to `to`.
791      *
792      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
793      *
794      * Requirements:
795      *
796      * - `tokenId` must not exist.
797      * - `to` cannot be the zero address.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _mint(address to, uint256 tokenId) internal virtual {
802         require(to != address(0), "ERC721: mint to the zero address");
803         require(!_exists(tokenId), "ERC721: token already minted");
804  
805         _beforeTokenTransfer(address(0), to, tokenId);
806  
807         _balances[to] += 1;
808         _owners[tokenId] = to;
809  
810         emit Transfer(address(0), to, tokenId);
811     }
812  
813     /**
814      * @dev Destroys `tokenId`.
815      * The approval is cleared when the token is burned.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _burn(uint256 tokenId) internal virtual {
824         address owner = ERC721.ownerOf(tokenId);
825  
826         _beforeTokenTransfer(owner, address(0), tokenId);
827  
828         // Clear approvals
829         _approve(address(0), tokenId);
830  
831         _balances[owner] -= 1;
832         delete _owners[tokenId];
833  
834         emit Transfer(owner, address(0), tokenId);
835     }
836  
837     /**
838      * @dev Transfers `tokenId` from `from` to `to`.
839      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must be owned by `from`.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _transfer(address from, address to, uint256 tokenId) internal virtual {
849         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
850         require(to != address(0), "ERC721: transfer to the zero address");
851  
852         _beforeTokenTransfer(from, to, tokenId);
853  
854         // Clear approvals from the previous owner
855         _approve(address(0), tokenId);
856  
857         _balances[from] -= 1;
858         _balances[to] += 1;
859         _owners[tokenId] = to;
860  
861         emit Transfer(from, to, tokenId);
862     }
863  
864     /**
865      * @dev Approve `to` to operate on `tokenId`
866      *
867      * Emits a {Approval} event.
868      */
869     function _approve(address to, uint256 tokenId) internal virtual {
870         _tokenApprovals[tokenId] = to;
871         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
872     }
873  
874     /**
875      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
876      * The call is not executed if the target address is not a contract.
877      *
878      * @param from address representing the previous owner of the given token ID
879      * @param to target address that will receive the tokens
880      * @param tokenId uint256 ID of the token to be transferred
881      * @param _data bytes optional data to send along with the call
882      * @return bool whether the call correctly returned the expected magic value
883      */
884     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
885         private returns (bool)
886     {
887         if (to.isContract()) {
888             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
889                 return retval == IERC721Receiver(to).onERC721Received.selector;
890             } catch (bytes memory reason) {
891                 if (reason.length == 0) {
892                     revert("ERC721: transfer to non ERC721Receiver implementer");
893                 } else {
894                     // solhint-disable-next-line no-inline-assembly
895                     assembly {
896                         revert(add(32, reason), mload(reason))
897                     }
898                 }
899             }
900         } else {
901             return true;
902         }
903     }
904  
905     /**
906      * @dev Hook that is called before any token transfer. This includes minting
907      * and burning.
908      *
909      * Calling conditions:
910      *
911      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
912      * transferred to `to`.
913      * - When `from` is zero, `tokenId` will be minted for `to`.
914      * - When `to` is zero, ``from``'s `tokenId` will be burned.
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      *
918      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
919      */
920     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
921 }
922  
923  
924 // File contracts/token/ERC721/extensions/ERC721URIStorage.sol
925  
926  
927  
928 pragma solidity ^0.8.0;
929  
930 /**
931  * @dev ERC721 token with storage based token URI management.
932  */
933 abstract contract ERC721URIStorage is ERC721 {
934     using Strings for uint256;
935  
936     // Optional mapping for token URIs
937     mapping (uint256 => string) private _tokenURIs;
938  
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
944  
945         string memory _tokenURI = _tokenURIs[tokenId];
946         string memory base = _baseURI();
947  
948         // If there is no base URI, return the token URI.
949         if (bytes(base).length == 0) {
950             return _tokenURI;
951         }
952         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
953         if (bytes(_tokenURI).length > 0) {
954             return string(abi.encodePacked(base, _tokenURI));
955         }
956  
957         return super.tokenURI(tokenId);
958     }
959  
960     /**
961      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
968         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
969         _tokenURIs[tokenId] = _tokenURI;
970     }
971  
972     /**
973      * @dev Destroys `tokenId`.
974      * The approval is cleared when the token is burned.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _burn(uint256 tokenId) internal virtual override {
983         super._burn(tokenId);
984  
985         if (bytes(_tokenURIs[tokenId]).length != 0) {
986             delete _tokenURIs[tokenId];
987         }
988     }
989 }
990  
991  
992 // File contracts/access/Ownable.sol
993  
994  
995  
996 pragma solidity ^0.8.0;
997  
998 /**
999  * @dev Contract module which provides a basic access control mechanism, where
1000  * there is an account (an owner) that can be granted exclusive access to
1001  * specific functions.
1002  *
1003  * By default, the owner account will be the one that deploys the contract. This
1004  * can later be changed with {transferOwnership}.
1005  *
1006  * This module is used through inheritance. It will make available the modifier
1007  * `onlyOwner`, which can be applied to your functions to restrict their use to
1008  * the owner.
1009  */
1010 abstract contract Ownable is Context {
1011     address private _owner;
1012  
1013     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1014  
1015     /**
1016      * @dev Initializes the contract setting the deployer as the initial owner.
1017      */
1018     constructor () {
1019         address msgSender = _msgSender();
1020         _owner = msgSender;
1021         emit OwnershipTransferred(address(0), msgSender);
1022     }
1023  
1024     /**
1025      * @dev Returns the address of the current owner.
1026      */
1027     function owner() public view virtual returns (address) {
1028         return _owner;
1029     }
1030  
1031     /**
1032      * @dev Throws if called by any account other than the owner.
1033      */
1034     modifier onlyOwner() {
1035         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1036         _;
1037     }
1038  
1039     /**
1040      * @dev Leaves the contract without owner. It will not be possible to call
1041      * `onlyOwner` functions anymore. Can only be called by the current owner.
1042      *
1043      * NOTE: Renouncing ownership will leave the contract without an owner,
1044      * thereby removing any functionality that is only available to the owner.
1045      */
1046     function renounceOwnership() public virtual onlyOwner {
1047         emit OwnershipTransferred(_owner, address(0));
1048         _owner = address(0);
1049     }
1050  
1051     /**
1052      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1053      * Can only be called by the current owner.
1054      */
1055     function transferOwnership(address newOwner) public virtual onlyOwner {
1056         require(newOwner != address(0), "Ownable: new owner is the zero address");
1057         emit OwnershipTransferred(_owner, newOwner);
1058         _owner = newOwner;
1059     }
1060 }
1061  
1062  
1063  
1064 pragma solidity ^0.8.0;
1065  
1066  
1067  
1068 contract DirtyDevils is ERC721URIStorage, Ownable{
1069  
1070     event MintDevils (address indexed minter, uint256 startWith, uint256 times);
1071     
1072     
1073     uint256 public totalDevils;
1074     uint256 public totalCount = 8888; //bruhTotal
1075     uint256 public maxBatch = 20; // bruhBatch
1076     uint256 public price = 70000000000000000; // 0.07 eth
1077     string public baseURI;
1078     bool public started;
1079     bool public whiteListStart;
1080     mapping(address => bool) whiteList;
1081     mapping(address => uint256) whiteListMintCount;
1082     uint addressRegistryCount;
1083     
1084     constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
1085         baseURI = baseURI_;
1086     }
1087     
1088     modifier canWhitelistMint() {
1089         require(whiteListStart, "Hang on boys, youll get in soon");
1090         require(whiteList[msg.sender] == true, "Not whitelisted.");
1091         _; 
1092     }
1093 
1094     modifier mintEnabled() {
1095         require(started, "not started");
1096         _;
1097     }
1098  
1099     function totalSupply() public view virtual returns (uint256) {
1100         return totalDevils;
1101     }
1102  
1103     function _baseURI() internal view virtual override returns (string memory){
1104         return baseURI;
1105     }
1106  
1107     function setBaseURI(string memory _newURI) public onlyOwner {
1108         baseURI = _newURI;
1109     }
1110  
1111     function changePrice(uint256 _newPrice) public onlyOwner {
1112         price = _newPrice;
1113     }
1114  
1115     function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
1116         _setTokenURI(_tokenId, _tokenURI);
1117     }
1118  
1119     function setNormalStart(bool _start) public onlyOwner {
1120         started = _start;
1121     }
1122     
1123     function setWhiteListStart(bool _start) public onlyOwner {
1124         whiteListStart = _start;
1125     }
1126     
1127     function getWhitelistMintAmount(address _addr) public view virtual returns (uint256) {
1128         return whiteListMintCount[_addr];
1129     }
1130  
1131     function mintDevil(uint256 _times) payable public mintEnabled {
1132         require(_times >0 && _times <= maxBatch, "mint wrong number");
1133         require(totalDevils + _times <= totalCount, "too much");
1134         require(msg.value == _times * price, "value error");
1135         payable(owner()).transfer(msg.value);
1136         emit MintDevils(_msgSender(), totalDevils+1, _times);
1137         for(uint256 i=0; i< _times; i++){
1138             _mint(_msgSender(), 1 + totalDevils++);
1139         }
1140     } 
1141     
1142     function adminMint(uint256 _times) payable public onlyOwner {
1143         require(_times >0 && _times <= maxBatch, "mint wrong number");
1144         require(totalDevils + _times <= totalCount, "too much");
1145         require(msg.value == _times * price, "value error");
1146         payable(owner()).transfer(msg.value);
1147         emit MintDevils(_msgSender(), totalDevils+1, _times);
1148         for(uint256 i=0; i< _times; i++){
1149             _mint(_msgSender(), 1 + totalDevils++);
1150         }
1151     }
1152     
1153     
1154     function whitelistMint(uint _times) payable public canWhitelistMint {
1155         require(whiteListMintCount[msg.sender] - _times >= 0, "Over mint limit for address.");
1156         require(totalDevils + _times <= totalCount, "Mint amount will exceed total collection amount.");
1157         require(msg.value == _times * price, "Incorrect transaction value.");
1158         payable(owner()).transfer(msg.value);
1159         whiteListMintCount[_msgSender()] -= _times;
1160         emit MintDevils(_msgSender(), totalDevils+1, _times);
1161         for(uint256 i=0; i< _times; i++){
1162             _mint(_msgSender(), 1 + totalDevils++);
1163         }
1164     }
1165     
1166     
1167     function adminMintGiveaways(address _addr) public onlyOwner {
1168         require(totalDevils + 1 <= totalCount, "Mint amount will exceed total collection amount.");
1169         emit MintDevils(_addr, totalDevils+1, 1);
1170         _mint(_addr, 1 + totalDevils++);
1171     } 
1172     
1173     
1174     function addToWhitelist(address _addr, uint numberOfMints) public onlyOwner {
1175         whiteList[_addr] = true;
1176         whiteListMintCount[_addr] = numberOfMints;
1177         addressRegistryCount++;
1178     }
1179     
1180     function addToWhitelistBulk(address[] memory _addr,uint[] memory _numberOfMints) public onlyOwner {
1181         for(uint256 i = 0; i < _addr.length; i++){
1182             whiteList[_addr[i]] = true;
1183             whiteListMintCount[_addr[i]] = _numberOfMints[i];
1184         }
1185     }
1186     
1187     //Check address is in whiteList 
1188     function isAddressInWhitelist(address _addr) public view virtual returns(bool) {
1189             return whiteList[_addr] == true;
1190     }
1191     
1192 }