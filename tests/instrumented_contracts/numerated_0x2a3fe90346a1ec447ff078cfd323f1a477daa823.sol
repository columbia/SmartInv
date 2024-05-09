1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 // Sources flattened with hardhat v2.3.0 https://hardhat.org
10 
11 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
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
34 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://eips.ethereum.org/EIPS/eip-721
209  */
210 interface IERC721Metadata is IERC721 {
211     /**
212      * @dev Returns the token collection name.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the token collection symbol.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
223      */
224     function tokenURI(uint256 tokenId) external view returns (string memory);
225 }
226 
227 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         uint256 size;
258         // solhint-disable-next-line no-inline-assembly
259         assembly {
260             size := extcodesize(account)
261         }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, 'Address: insufficient balance');
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{value: amount}('');
286         require(success, 'Address: unable to send value, recipient may have reverted');
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, 'Address: low-level call failed');
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, 'Address: insufficient balance for call');
357         require(isContract(target), 'Address: call to non-contract');
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, 'Address: low-level static call failed');
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), 'Address: static call to non-contract');
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), 'Address: delegate call to non-contract');
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     function _verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) private pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 // solhint-disable-next-line no-inline-assembly
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
445 
446 pragma solidity ^0.8.0;
447 
448 /*
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
465         return msg.data;
466     }
467 }
468 
469 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev String operations.
475  */
476 library Strings {
477     bytes16 private constant alphabet = '0123456789abcdef';
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
481      */
482     function toString(uint256 value) internal pure returns (string memory) {
483         // Inspired by OraclizeAPI's implementation - MIT licence
484         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
485 
486         if (value == 0) {
487             return '0';
488         }
489         uint256 temp = value;
490         uint256 digits;
491         while (temp != 0) {
492             digits++;
493             temp /= 10;
494         }
495         bytes memory buffer = new bytes(digits);
496         while (value != 0) {
497             digits -= 1;
498             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
499             value /= 10;
500         }
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
506      */
507     function toHexString(uint256 value) internal pure returns (string memory) {
508         if (value == 0) {
509             return '0x00';
510         }
511         uint256 temp = value;
512         uint256 length = 0;
513         while (temp != 0) {
514             length++;
515             temp >>= 8;
516         }
517         return toHexString(value, length);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
522      */
523     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
524         bytes memory buffer = new bytes(2 * length + 2);
525         buffer[0] = '0';
526         buffer[1] = 'x';
527         for (uint256 i = 2 * length + 1; i > 1; --i) {
528             buffer[i] = alphabet[value & 0xf];
529             value >>= 4;
530         }
531         require(value == 0, 'Strings: hex length insufficient');
532         return string(buffer);
533     }
534 }
535 
536 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Implementation of the {IERC165} interface.
542  *
543  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
544  * for the additional interface id that will be supported. For example:
545  *
546  * ```solidity
547  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
549  * }
550  * ```
551  *
552  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
553  */
554 abstract contract ERC165 is IERC165 {
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         return interfaceId == type(IERC165).interfaceId;
560     }
561 }
562 
563 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
569  * the Metadata extension, but not including the Enumerable extension, which is available separately as
570  * {ERC721Enumerable}.
571  */
572 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
573     using Address for address;
574     using Strings for uint256;
575 
576     // Token name
577     string private _name;
578 
579     // Token symbol
580     string private _symbol;
581 
582     // Mapping from token ID to owner address
583     mapping(uint256 => address) private _owners;
584 
585     // Mapping owner address to token count
586     mapping(address => uint256) private _balances;
587 
588     // Mapping from token ID to approved address
589     mapping(uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     /**
595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
596      */
597     constructor(string memory name_, string memory symbol_) {
598         _name = name_;
599         _symbol = symbol_;
600     }
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
606         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view virtual override returns (uint256) {
613         require(owner != address(0), 'ERC721: balance query for the zero address');
614         return _balances[owner];
615     }
616 
617     /**
618      * @dev See {IERC721-ownerOf}.
619      */
620     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
621         address owner = _owners[tokenId];
622         require(owner != address(0), 'ERC721: owner query for nonexistent token');
623         return owner;
624     }
625 
626     /**
627      * @dev See {IERC721Metadata-name}.
628      */
629     function name() public view virtual override returns (string memory) {
630         return _name;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-symbol}.
635      */
636     function symbol() public view virtual override returns (string memory) {
637         return _symbol;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-tokenURI}.
642      */
643     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
644         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
645 
646         string memory baseURI = _baseURI();
647         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
648     }
649 
650     /**
651      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
652      * in child contracts.
653      */
654     function _baseURI() internal view virtual returns (string memory) {
655         return '';
656     }
657 
658     /**
659      * @dev See {IERC721-approve}.
660      */
661     function approve(address to, uint256 tokenId) public virtual override {
662         address owner = ERC721.ownerOf(tokenId);
663         require(to != owner, 'ERC721: approval to current owner');
664 
665         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
666 
667         _approve(to, tokenId);
668     }
669 
670     /**
671      * @dev See {IERC721-getApproved}.
672      */
673     function getApproved(uint256 tokenId) public view virtual override returns (address) {
674         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
675 
676         return _tokenApprovals[tokenId];
677     }
678 
679     /**
680      * @dev See {IERC721-setApprovalForAll}.
681      */
682     function setApprovalForAll(address operator, bool approved) public virtual override {
683         require(operator != _msgSender(), 'ERC721: approve to caller');
684 
685         _operatorApprovals[_msgSender()][operator] = approved;
686         emit ApprovalForAll(_msgSender(), operator, approved);
687     }
688 
689     /**
690      * @dev See {IERC721-isApprovedForAll}.
691      */
692     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
693         return _operatorApprovals[owner][operator];
694     }
695 
696     /**
697      * @dev See {IERC721-transferFrom}.
698      */
699     function transferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) public virtual override {
704         //solhint-disable-next-line max-line-length
705         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
706 
707         _transfer(from, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) public virtual override {
718         safeTransferFrom(from, to, tokenId, '');
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) public virtual override {
730         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
731         _safeTransfer(from, to, tokenId, _data);
732     }
733 
734     /**
735      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
736      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
737      *
738      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
739      *
740      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
741      * implement alternative mechanisms to perform token transfer, such as signature-based.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeTransfer(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) internal virtual {
758         _transfer(from, to, tokenId);
759         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
760     }
761 
762     /**
763      * @dev Returns whether `tokenId` exists.
764      *
765      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
766      *
767      * Tokens start existing when they are minted (`_mint`),
768      * and stop existing when they are burned (`_burn`).
769      */
770     function _exists(uint256 tokenId) internal view virtual returns (bool) {
771         return _owners[tokenId] != address(0);
772     }
773 
774     /**
775      * @dev Returns whether `spender` is allowed to manage `tokenId`.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      */
781     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
782         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
783         address owner = ERC721.ownerOf(tokenId);
784         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
785     }
786 
787     /**
788      * @dev Safely mints `tokenId` and transfers it to `to`.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must not exist.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _safeMint(address to, uint256 tokenId) internal virtual {
798         _safeMint(to, tokenId, '');
799     }
800 
801     /**
802      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
803      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
804      */
805     function _safeMint(
806         address to,
807         uint256 tokenId,
808         bytes memory _data
809     ) internal virtual {
810         _mint(to, tokenId);
811         require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
812     }
813 
814     /**
815      * @dev Mints `tokenId` and transfers it to `to`.
816      *
817      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
818      *
819      * Requirements:
820      *
821      * - `tokenId` must not exist.
822      * - `to` cannot be the zero address.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _mint(address to, uint256 tokenId) internal virtual {
827         require(to != address(0), 'ERC721: mint to the zero address');
828         require(!_exists(tokenId), 'ERC721: token already minted');
829 
830         _beforeTokenTransfer(address(0), to, tokenId);
831 
832         _balances[to] += 1;
833         _owners[tokenId] = to;
834 
835         emit Transfer(address(0), to, tokenId);
836     }
837 
838     /**
839      * @dev Destroys `tokenId`.
840      * The approval is cleared when the token is burned.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must exist.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _burn(uint256 tokenId) internal virtual {
849         address owner = ERC721.ownerOf(tokenId);
850 
851         _beforeTokenTransfer(owner, address(0), tokenId);
852 
853         // Clear approvals
854         _approve(address(0), tokenId);
855 
856         _balances[owner] -= 1;
857         delete _owners[tokenId];
858 
859         emit Transfer(owner, address(0), tokenId);
860     }
861 
862     /**
863      * @dev Transfers `tokenId` from `from` to `to`.
864      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
865      *
866      * Requirements:
867      *
868      * - `to` cannot be the zero address.
869      * - `tokenId` token must be owned by `from`.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _transfer(
874         address from,
875         address to,
876         uint256 tokenId
877     ) internal virtual {
878         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
879         require(to != address(0), 'ERC721: transfer to the zero address');
880 
881         _beforeTokenTransfer(from, to, tokenId);
882 
883         // Clear approvals from the previous owner
884         _approve(address(0), tokenId);
885 
886         _balances[from] -= 1;
887         _balances[to] += 1;
888         _owners[tokenId] = to;
889 
890         emit Transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev Approve `to` to operate on `tokenId`
895      *
896      * Emits a {Approval} event.
897      */
898     function _approve(address to, uint256 tokenId) internal virtual {
899         _tokenApprovals[tokenId] = to;
900         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
901     }
902 
903     /**
904      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
905      * The call is not executed if the target address is not a contract.
906      *
907      * @param from address representing the previous owner of the given token ID
908      * @param to target address that will receive the tokens
909      * @param tokenId uint256 ID of the token to be transferred
910      * @param _data bytes optional data to send along with the call
911      * @return bool whether the call correctly returned the expected magic value
912      */
913     function _checkOnERC721Received(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) private returns (bool) {
919         if (to.isContract()) {
920             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
921                 return retval == IERC721Receiver(to).onERC721Received.selector;
922             } catch (bytes memory reason) {
923                 if (reason.length == 0) {
924                     revert('ERC721: transfer to non ERC721Receiver implementer');
925                 } else {
926                     // solhint-disable-next-line no-inline-assembly
927                     assembly {
928                         revert(add(32, reason), mload(reason))
929                     }
930                 }
931             }
932         } else {
933             return true;
934         }
935     }
936 
937     /**
938      * @dev Hook that is called before any token transfer. This includes minting
939      * and burning.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, ``from``'s `tokenId` will be burned.
947      * - `from` cannot be the zero address.
948      * - `to` cannot be the zero address.
949      *
950      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
951      */
952     function _beforeTokenTransfer(
953         address from,
954         address to,
955         uint256 tokenId
956     ) internal virtual {}
957 }
958 
959 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
960 
961 pragma solidity ^0.8.0;
962 
963 /**
964  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
965  * @dev See https://eips.ethereum.org/EIPS/eip-721
966  */
967 interface IERC721Enumerable is IERC721 {
968     /**
969      * @dev Returns the total amount of tokens stored by the contract.
970      */
971     function totalSupply() external view returns (uint256);
972 
973     /**
974      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
975      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
976      */
977     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
978 
979     /**
980      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
981      * Use along with {totalSupply} to enumerate all tokens.
982      */
983     function tokenByIndex(uint256 index) external view returns (uint256);
984 }
985 
986 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
992  * enumerability of all the token ids in the contract as well as all token ids owned by each
993  * account.
994  */
995 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
996     // Mapping from owner to list of owned token IDs
997     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
998 
999     // Mapping from token ID to index of the owner tokens list
1000     mapping(uint256 => uint256) private _ownedTokensIndex;
1001 
1002     // Array with all token ids, used for enumeration
1003     uint256[] private _allTokens;
1004 
1005     // Mapping from token id to position in the allTokens array
1006     mapping(uint256 => uint256) private _allTokensIndex;
1007 
1008     /**
1009      * @dev See {IERC165-supportsInterface}.
1010      */
1011     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1012         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1017      */
1018     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1019         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1020         return _ownedTokens[owner][index];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-totalSupply}.
1025      */
1026     function totalSupply() public view virtual override returns (uint256) {
1027         return _allTokens.length;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenByIndex}.
1032      */
1033     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1034         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1035         return _allTokens[index];
1036     }
1037 
1038     /**
1039      * @dev Hook that is called before any token transfer. This includes minting
1040      * and burning.
1041      *
1042      * Calling conditions:
1043      *
1044      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1045      * transferred to `to`.
1046      * - When `from` is zero, `tokenId` will be minted for `to`.
1047      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      *
1051      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1052      */
1053     function _beforeTokenTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) internal virtual override {
1058         super._beforeTokenTransfer(from, to, tokenId);
1059 
1060         if (from == address(0)) {
1061             _addTokenToAllTokensEnumeration(tokenId);
1062         } else if (from != to) {
1063             _removeTokenFromOwnerEnumeration(from, tokenId);
1064         }
1065         if (to == address(0)) {
1066             _removeTokenFromAllTokensEnumeration(tokenId);
1067         } else if (to != from) {
1068             _addTokenToOwnerEnumeration(to, tokenId);
1069         }
1070     }
1071 
1072     /**
1073      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1074      * @param to address representing the new owner of the given token ID
1075      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1076      */
1077     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1078         uint256 length = ERC721.balanceOf(to);
1079         _ownedTokens[to][length] = tokenId;
1080         _ownedTokensIndex[tokenId] = length;
1081     }
1082 
1083     /**
1084      * @dev Private function to add a token to this extension's token tracking data structures.
1085      * @param tokenId uint256 ID of the token to be added to the tokens list
1086      */
1087     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1088         _allTokensIndex[tokenId] = _allTokens.length;
1089         _allTokens.push(tokenId);
1090     }
1091 
1092     /**
1093      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1094      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1095      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1096      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1097      * @param from address representing the previous owner of the given token ID
1098      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1099      */
1100     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1101         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1102         // then delete the last slot (swap and pop).
1103 
1104         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1105         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1106 
1107         // When the token to delete is the last token, the swap operation is unnecessary
1108         if (tokenIndex != lastTokenIndex) {
1109             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1110 
1111             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1112             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1113         }
1114 
1115         // This also deletes the contents at the last position of the array
1116         delete _ownedTokensIndex[tokenId];
1117         delete _ownedTokens[from][lastTokenIndex];
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's token tracking data structures.
1122      * This has O(1) time complexity, but alters the order of the _allTokens array.
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list
1124      */
1125     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1126         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = _allTokens.length - 1;
1130         uint256 tokenIndex = _allTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1133         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1134         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1135         uint256 lastTokenId = _allTokens[lastTokenIndex];
1136 
1137         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _allTokensIndex[tokenId];
1142         _allTokens.pop();
1143     }
1144 }
1145 
1146 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 /**
1151  * @dev ERC721 token with storage based token URI management.
1152  */
1153 abstract contract ERC721URIStorage is ERC721 {
1154     using Strings for uint256;
1155 
1156     // Optional mapping for token URIs
1157     mapping(uint256 => string) private _tokenURIs;
1158 
1159     /**
1160      * @dev See {IERC721Metadata-tokenURI}.
1161      */
1162     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1163         require(_exists(tokenId), 'ERC721URIStorage: URI query for nonexistent token');
1164 
1165         string memory _tokenURI = _tokenURIs[tokenId];
1166         string memory base = _baseURI();
1167 
1168         // If there is no base URI, return the token URI.
1169         if (bytes(base).length == 0) {
1170             return _tokenURI;
1171         }
1172         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1173         if (bytes(_tokenURI).length > 0) {
1174             return string(abi.encodePacked(base, _tokenURI));
1175         }
1176 
1177         return super.tokenURI(tokenId);
1178     }
1179 
1180     /**
1181      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must exist.
1186      */
1187     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1188         require(_exists(tokenId), 'ERC721URIStorage: URI set of nonexistent token');
1189         _tokenURIs[tokenId] = _tokenURI;
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId) internal virtual override {
1203         super._burn(tokenId);
1204 
1205         if (bytes(_tokenURIs[tokenId]).length != 0) {
1206             delete _tokenURIs[tokenId];
1207         }
1208     }
1209 }
1210 
1211 // File @openzeppelin/contracts/security/Pausable.sol@v4.1.0
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 /**
1216  * @dev Contract module which allows children to implement an emergency stop
1217  * mechanism that can be triggered by an authorized account.
1218  *
1219  * This module is used through inheritance. It will make available the
1220  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1221  * the functions of your contract. Note that they will not be pausable by
1222  * simply including this module, only once the modifiers are put in place.
1223  */
1224 abstract contract Pausable is Context {
1225     /**
1226      * @dev Emitted when the pause is triggered by `account`.
1227      */
1228     event Paused(address account);
1229 
1230     /**
1231      * @dev Emitted when the pause is lifted by `account`.
1232      */
1233     event Unpaused(address account);
1234 
1235     bool private _paused;
1236 
1237     /**
1238      * @dev Initializes the contract in unpaused state.
1239      */
1240     constructor() {
1241         _paused = false;
1242     }
1243 
1244     /**
1245      * @dev Returns true if the contract is paused, and false otherwise.
1246      */
1247     function paused() public view virtual returns (bool) {
1248         return _paused;
1249     }
1250 
1251     /**
1252      * @dev Modifier to make a function callable only when the contract is not paused.
1253      *
1254      * Requirements:
1255      *
1256      * - The contract must not be paused.
1257      */
1258     modifier whenNotPaused() {
1259         require(!paused(), 'Pausable: paused');
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Modifier to make a function callable only when the contract is paused.
1265      *
1266      * Requirements:
1267      *
1268      * - The contract must be paused.
1269      */
1270     modifier whenPaused() {
1271         require(paused(), 'Pausable: not paused');
1272         _;
1273     }
1274 
1275     /**
1276      * @dev Triggers stopped state.
1277      *
1278      * Requirements:
1279      *
1280      * - The contract must not be paused.
1281      */
1282     function _pause() internal virtual whenNotPaused {
1283         _paused = true;
1284         emit Paused(_msgSender());
1285     }
1286 
1287     /**
1288      * @dev Returns to normal state.
1289      *
1290      * Requirements:
1291      *
1292      * - The contract must be paused.
1293      */
1294     function _unpause() internal virtual whenPaused {
1295         _paused = false;
1296         emit Unpaused(_msgSender());
1297     }
1298 }
1299 
1300 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 /**
1305  * @dev Contract module which provides a basic access control mechanism, where
1306  * there is an account (an owner) that can be granted exclusive access to
1307  * specific functions.
1308  *
1309  * By default, the owner account will be the one that deploys the contract. This
1310  * can later be changed with {transferOwnership}.
1311  *
1312  * This module is used through inheritance. It will make available the modifier
1313  * `onlyOwner`, which can be applied to your functions to restrict their use to
1314  * the owner.
1315  */
1316 abstract contract Ownable is Context {
1317     address private _owner;
1318 
1319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1320 
1321     /**
1322      * @dev Initializes the contract setting the deployer as the initial owner.
1323      */
1324     constructor() {
1325         address msgSender = _msgSender();
1326         _owner = msgSender;
1327         emit OwnershipTransferred(address(0), msgSender);
1328     }
1329 
1330     /**
1331      * @dev Returns the address of the current owner.
1332      */
1333     function owner() public view virtual returns (address) {
1334         return _owner;
1335     }
1336 
1337     /**
1338      * @dev Throws if called by any account other than the owner.
1339      */
1340     modifier onlyOwner() {
1341         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1342         _;
1343     }
1344 
1345     /**
1346      * @dev Leaves the contract without owner. It will not be possible to call
1347      * `onlyOwner` functions anymore. Can only be called by the current owner.
1348      *
1349      * NOTE: Renouncing ownership will leave the contract without an owner,
1350      * thereby removing any functionality that is only available to the owner.
1351      */
1352     function renounceOwnership() public virtual onlyOwner {
1353         emit OwnershipTransferred(_owner, address(0));
1354         _owner = address(0);
1355     }
1356 
1357     /**
1358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1359      * Can only be called by the current owner.
1360      */
1361     function transferOwnership(address newOwner) public virtual onlyOwner {
1362         require(newOwner != address(0), 'Ownable: new owner is the zero address');
1363         emit OwnershipTransferred(_owner, newOwner);
1364         _owner = newOwner;
1365     }
1366 }
1367 
1368 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.1.0
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 /**
1373  * @title ERC721 Burnable Token
1374  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1375  */
1376 abstract contract ERC721Burnable is Context, ERC721 {
1377     /**
1378      * @dev Burns `tokenId`. See {ERC721-_burn}.
1379      *
1380      * Requirements:
1381      *
1382      * - The caller must own `tokenId` or be an approved operator.
1383      */
1384     function burn(uint256 tokenId) public virtual {
1385         //solhint-disable-next-line max-line-length
1386         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
1387         _burn(tokenId);
1388     }
1389 }
1390 
1391 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @title Counters
1397  * @author Matt Condon (@shrugs)
1398  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1399  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1400  *
1401  * Include with `using Counters for Counters.Counter;`
1402  */
1403 library Counters {
1404     struct Counter {
1405         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1406         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1407         // this feature: see https://github.com/ethereum/solidity/issues/4637
1408         uint256 _value; // default: 0
1409     }
1410 
1411     function current(Counter storage counter) internal view returns (uint256) {
1412         return counter._value;
1413     }
1414 
1415     function increment(Counter storage counter) internal {
1416         unchecked {
1417             counter._value += 1;
1418         }
1419     }
1420 
1421     function decrement(Counter storage counter) internal {
1422         uint256 value = counter._value;
1423         require(value > 0, 'Counter: decrement overflow');
1424         unchecked {
1425             counter._value = value - 1;
1426         }
1427     }
1428 }
1429 
1430 pragma solidity ^0.8.0;
1431 
1432 contract DivineWeapons is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1433     using Counters for Counters.Counter;
1434 
1435     Counters.Counter private _tokenIdCounter;
1436     uint256 public maxSupply = 4444;
1437     uint256 public price = 0;
1438     uint256 public maxMintAmount = 40;
1439     bool public saleOpen = false;
1440     bool public presaleOpen = false;
1441     string public baseURI;
1442 
1443     mapping(address => uint256) public allowlist;
1444 
1445     receive() external payable {}
1446 
1447     constructor() ERC721('Divine Weapons', 'WEAP') {}
1448 
1449     function reserveMints(address to) public onlyOwner {
1450         for (uint256 i = 0; i < 35; i++) internalMint(to);
1451     }
1452 
1453     function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1454     external
1455     onlyOwner
1456     {
1457         require(
1458             addresses.length == numSlots.length,
1459             "addresses does not match numSlots length"
1460         );
1461         for (uint256 i = 0; i < addresses.length; i++) {
1462             allowlist[addresses[i]] = numSlots[i];
1463         }
1464     }
1465 
1466     function withdraw() public onlyOwner {
1467         require(payable(_msgSender()).send(address(this).balance));
1468     }
1469 
1470     function pause() public onlyOwner {
1471         _pause();
1472     }
1473 
1474     function unpause() public onlyOwner {
1475         _unpause();
1476     }
1477 
1478     function toggleSale() public onlyOwner {
1479         saleOpen = !saleOpen;
1480     }
1481 
1482     function togglePresale() public onlyOwner {
1483         presaleOpen = !presaleOpen;
1484     }
1485 
1486     function setBaseURI(string memory newBaseURI) public onlyOwner {
1487         baseURI = newBaseURI;
1488     }
1489 
1490     function setPrice(uint256 newPrice) public onlyOwner {
1491         price = newPrice;
1492     }
1493 
1494     function _baseURI() internal view override returns (string memory) {
1495         return baseURI;
1496     }
1497 
1498     function internalMint(address to) internal {
1499         require(totalSupply() < maxSupply, 'supply depleted');
1500         _safeMint(to, _tokenIdCounter.current());
1501         _tokenIdCounter.increment();
1502     }
1503 
1504     function safeMint(address to) public onlyOwner {
1505         internalMint(to);
1506     }
1507 
1508     function mintReserved(
1509         address _to,
1510         uint256 _mintAmount
1511 
1512         ) public {
1513 
1514             uint256 supply = totalSupply();
1515             require(saleOpen, "Sale is not open ");
1516             require(_mintAmount > 0, "Mint amount must be greater than 0");
1517             require(_mintAmount <= maxMintAmount, "Mint amount exceeds max per transaction");
1518             require(supply + _mintAmount <= maxSupply, "Mint amount exceeds max supply");
1519 
1520             require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1521             require(allowlist[msg.sender] <= _mintAmount, "can't mint that many");
1522 
1523             for (uint256 i = 1; i <= _mintAmount; i++) {
1524                 allowlist[msg.sender]--;
1525                 // use one weapon per minted token
1526                 _safeMint(_to, supply + i);
1527             }
1528     }
1529     
1530     function _beforeTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1535         super._beforeTokenTransfer(from, to, tokenId);
1536     }
1537 
1538     // The following functions are overrides required by Solidity.
1539 
1540     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1541         super._burn(tokenId);
1542     }
1543 
1544     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1545         return super.tokenURI(tokenId);
1546     }
1547 
1548     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1549         return super.supportsInterface(interfaceId);
1550     }
1551 }