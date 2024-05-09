1 pragma solidity ^0.8.0;
2 
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId
76     ) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 }
161 
162 /**
163  * @title ERC721 token receiver interface
164  * @dev Interface for any contract that wants to support safeTransfers
165  * from ERC721 asset contracts.
166  */
167 interface IERC721Receiver {
168     /**
169      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
170      * by `operator` from `from`, this function is called.
171      *
172      * It must return its Solidity selector to confirm the token transfer.
173      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
174      *
175      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
176      */
177     function onERC721Received(
178         address operator,
179         address from,
180         uint256 tokenId,
181         bytes calldata data
182     ) external returns (bytes4);
183 }
184 
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Metadata is IERC721 {
190     /**
191      * @dev Returns the token collection name.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the token collection symbol.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
202      */
203     function tokenURI(uint256 tokenId) external view returns (string memory);
204 }
205 
206 /**
207  * @dev Collection of functions related to the address type
208  */
209 library Address {
210     /**
211      * @dev Returns true if `account` is a contract.
212      *
213      * [IMPORTANT]
214      * ====
215      * It is unsafe to assume that an address for which this function returns
216      * false is an externally-owned account (EOA) and not a contract.
217      *
218      * Among others, `isContract` will return false for the following
219      * types of addresses:
220      *
221      *  - an externally-owned account
222      *  - a contract in construction
223      *  - an address where a contract will be created
224      *  - an address where a contract lived, but was destroyed
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize, which returns 0 for contracts in
229         // construction, since the code is only stored at the end of the
230         // constructor execution.
231 
232         uint256 size;
233         assembly {
234             size := extcodesize(account)
235         }
236         return size > 0;
237     }
238 
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         (bool success, ) = recipient.call{value: amount}("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261 
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain `call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionCall(target, data, "Address: low-level call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{value: value}(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 /**
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
435         return msg.data;
436     }
437 }
438 
439 /**
440  * @dev String operations.
441  */
442 library Strings {
443     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
447      */
448     function toString(uint256 value) internal pure returns (string memory) {
449         // Inspired by OraclizeAPI's implementation - MIT licence
450         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
451 
452         if (value == 0) {
453             return "0";
454         }
455         uint256 temp = value;
456         uint256 digits;
457         while (temp != 0) {
458             digits++;
459             temp /= 10;
460         }
461         bytes memory buffer = new bytes(digits);
462         while (value != 0) {
463             digits -= 1;
464             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
465             value /= 10;
466         }
467         return string(buffer);
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
472      */
473     function toHexString(uint256 value) internal pure returns (string memory) {
474         if (value == 0) {
475             return "0x00";
476         }
477         uint256 temp = value;
478         uint256 length = 0;
479         while (temp != 0) {
480             length++;
481             temp >>= 8;
482         }
483         return toHexString(value, length);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
488      */
489     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
490         bytes memory buffer = new bytes(2 * length + 2);
491         buffer[0] = "0";
492         buffer[1] = "x";
493         for (uint256 i = 2 * length + 1; i > 1; --i) {
494             buffer[i] = _HEX_SYMBOLS[value & 0xf];
495             value >>= 4;
496         }
497         require(value == 0, "Strings: hex length insufficient");
498         return string(buffer);
499     }
500 }
501 
502 /**
503  * @dev Implementation of the {IERC165} interface.
504  *
505  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
506  * for the additional interface id that will be supported. For example:
507  *
508  * ```solidity
509  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
511  * }
512  * ```
513  *
514  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
515  */
516 abstract contract ERC165 is IERC165 {
517     /**
518      * @dev See {IERC165-supportsInterface}.
519      */
520     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521         return interfaceId == type(IERC165).interfaceId;
522     }
523 }
524 
525 /**
526  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
527  * the Metadata extension, but not including the Enumerable extension, which is available separately as
528  * {ERC721Enumerable}.
529  */
530 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
531     using Address for address;
532     using Strings for uint256;
533 
534     // Token name
535     string private _name;
536 
537     // Token symbol
538     string private _symbol;
539 
540     // Mapping from token ID to owner address
541     mapping(uint256 => address) private _owners;
542 
543     // Mapping owner address to token count
544     mapping(address => uint256) private _balances;
545 
546     // Mapping from token ID to approved address
547     mapping(uint256 => address) private _tokenApprovals;
548 
549     // Mapping from owner to operator approvals
550     mapping(address => mapping(address => bool)) private _operatorApprovals;
551 
552     /**
553      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
554      */
555     constructor(string memory name_, string memory symbol_) {
556         _name = name_;
557         _symbol = symbol_;
558     }
559 
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
564         return
565             interfaceId == type(IERC721).interfaceId ||
566             interfaceId == type(IERC721Metadata).interfaceId ||
567             super.supportsInterface(interfaceId);
568     }
569 
570     /**
571      * @dev See {IERC721-balanceOf}.
572      */
573     function balanceOf(address owner) public view virtual override returns (uint256) {
574         require(owner != address(0), "ERC721: balance query for the zero address");
575         return _balances[owner];
576     }
577 
578     /**
579      * @dev See {IERC721-ownerOf}.
580      */
581     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
582         address owner = _owners[tokenId];
583         require(owner != address(0), "ERC721: owner query for nonexistent token");
584         return owner;
585     }
586 
587     /**
588      * @dev See {IERC721Metadata-name}.
589      */
590     function name() public view virtual override returns (string memory) {
591         return _name;
592     }
593 
594     /**
595      * @dev See {IERC721Metadata-symbol}.
596      */
597     function symbol() public view virtual override returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-tokenURI}.
603      */
604     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
605         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
606 
607         string memory baseURI = _baseURI();
608         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
609     }
610 
611     /**
612      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
613      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
614      * by default, can be overriden in child contracts.
615      */
616     function _baseURI() internal view virtual returns (string memory) {
617         return "";
618     }
619 
620     /**
621      * @dev See {IERC721-approve}.
622      */
623     function approve(address to, uint256 tokenId) public virtual override {
624         address owner = ERC721.ownerOf(tokenId);
625         require(to != owner, "ERC721: approval to current owner");
626 
627         require(
628             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
629             "ERC721: approve caller is not owner nor approved for all"
630         );
631 
632         _approve(to, tokenId);
633     }
634 
635     /**
636      * @dev See {IERC721-getApproved}.
637      */
638     function getApproved(uint256 tokenId) public view virtual override returns (address) {
639         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
640 
641         return _tokenApprovals[tokenId];
642     }
643 
644     /**
645      * @dev See {IERC721-setApprovalForAll}.
646      */
647     function setApprovalForAll(address operator, bool approved) public virtual override {
648         require(operator != _msgSender(), "ERC721: approve to caller");
649 
650         _operatorApprovals[_msgSender()][operator] = approved;
651         emit ApprovalForAll(_msgSender(), operator, approved);
652     }
653 
654     /**
655      * @dev See {IERC721-isApprovedForAll}.
656      */
657     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
658         return _operatorApprovals[owner][operator];
659     }
660 
661     /**
662      * @dev See {IERC721-transferFrom}.
663      */
664     function transferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) public virtual override {
669         //solhint-disable-next-line max-line-length
670         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
671 
672         _transfer(from, to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) public virtual override {
683         safeTransferFrom(from, to, tokenId, "");
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes memory _data
694     ) public virtual override {
695         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
696         _safeTransfer(from, to, tokenId, _data);
697     }
698 
699     /**
700      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
701      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
702      *
703      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
704      *
705      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
706      * implement alternative mechanisms to perform token transfer, such as signature-based.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must exist and be owned by `from`.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function _safeTransfer(
718         address from,
719         address to,
720         uint256 tokenId,
721         bytes memory _data
722     ) internal virtual {
723         _transfer(from, to, tokenId);
724         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
725     }
726 
727     /**
728      * @dev Returns whether `tokenId` exists.
729      *
730      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
731      *
732      * Tokens start existing when they are minted (`_mint`),
733      * and stop existing when they are burned (`_burn`).
734      */
735     function _exists(uint256 tokenId) internal view virtual returns (bool) {
736         return _owners[tokenId] != address(0);
737     }
738 
739     /**
740      * @dev Returns whether `spender` is allowed to manage `tokenId`.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
747         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
748         address owner = ERC721.ownerOf(tokenId);
749         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
750     }
751 
752     /**
753      * @dev Safely mints `tokenId` and transfers it to `to`.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must not exist.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _safeMint(address to, uint256 tokenId) internal virtual {
763         _safeMint(to, tokenId, "");
764     }
765 
766     /**
767      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
768      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
769      */
770     function _safeMint(
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) internal virtual {
775         _mint(to, tokenId);
776         require(
777             _checkOnERC721Received(address(0), to, tokenId, _data),
778             "ERC721: transfer to non ERC721Receiver implementer"
779         );
780     }
781 
782     /**
783      * @dev Mints `tokenId` and transfers it to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
786      *
787      * Requirements:
788      *
789      * - `tokenId` must not exist.
790      * - `to` cannot be the zero address.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _mint(address to, uint256 tokenId) internal virtual {
795         require(to != address(0), "ERC721: mint to the zero address");
796         require(!_exists(tokenId), "ERC721: token already minted");
797 
798         _beforeTokenTransfer(address(0), to, tokenId);
799 
800         _balances[to] += 1;
801         _owners[tokenId] = to;
802 
803         emit Transfer(address(0), to, tokenId);
804     }
805 
806     /**
807      * @dev Destroys `tokenId`.
808      * The approval is cleared when the token is burned.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _burn(uint256 tokenId) internal virtual {
817         address owner = ERC721.ownerOf(tokenId);
818 
819         _beforeTokenTransfer(owner, address(0), tokenId);
820 
821         // Clear approvals
822         _approve(address(0), tokenId);
823 
824         _balances[owner] -= 1;
825         delete _owners[tokenId];
826 
827         emit Transfer(owner, address(0), tokenId);
828     }
829 
830     /**
831      * @dev Transfers `tokenId` from `from` to `to`.
832      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
833      *
834      * Requirements:
835      *
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must be owned by `from`.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _transfer(
842         address from,
843         address to,
844         uint256 tokenId
845     ) internal virtual {
846         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
847         require(to != address(0), "ERC721: transfer to the zero address");
848 
849         _beforeTokenTransfer(from, to, tokenId);
850 
851         // Clear approvals from the previous owner
852         _approve(address(0), tokenId);
853 
854         _balances[from] -= 1;
855         _balances[to] += 1;
856         _owners[tokenId] = to;
857 
858         emit Transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev Approve `to` to operate on `tokenId`
863      *
864      * Emits a {Approval} event.
865      */
866     function _approve(address to, uint256 tokenId) internal virtual {
867         _tokenApprovals[tokenId] = to;
868         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
869     }
870 
871     /**
872      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
873      * The call is not executed if the target address is not a contract.
874      *
875      * @param from address representing the previous owner of the given token ID
876      * @param to target address that will receive the tokens
877      * @param tokenId uint256 ID of the token to be transferred
878      * @param _data bytes optional data to send along with the call
879      * @return bool whether the call correctly returned the expected magic value
880      */
881     function _checkOnERC721Received(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) private returns (bool) {
887         if (to.isContract()) {
888             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
889                 return retval == IERC721Receiver.onERC721Received.selector;
890             } catch (bytes memory reason) {
891                 if (reason.length == 0) {
892                     revert("ERC721: transfer to non ERC721Receiver implementer");
893                 } else {
894                     assembly {
895                         revert(add(32, reason), mload(reason))
896                     }
897                 }
898             }
899         } else {
900             return true;
901         }
902     }
903 
904     /**
905      * @dev Hook that is called before any token transfer. This includes minting
906      * and burning.
907      *
908      * Calling conditions:
909      *
910      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
911      * transferred to `to`.
912      * - When `from` is zero, `tokenId` will be minted for `to`.
913      * - When `to` is zero, ``from``'s `tokenId` will be burned.
914      * - `from` and `to` are never both zero.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) internal virtual {}
923 }
924 
925 /**
926  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
927  * @dev See https://eips.ethereum.org/EIPS/eip-721
928  */
929 interface IERC721Enumerable is IERC721 {
930     /**
931      * @dev Returns the total amount of tokens stored by the contract.
932      */
933     function totalSupply() external view returns (uint256);
934 
935     /**
936      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
937      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
938      */
939     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
940 
941     /**
942      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
943      * Use along with {totalSupply} to enumerate all tokens.
944      */
945     function tokenByIndex(uint256 index) external view returns (uint256);
946 }
947 
948 /**
949  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
950  * enumerability of all the token ids in the contract as well as all token ids owned by each
951  * account.
952  */
953 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
954     // Mapping from owner to list of owned token IDs
955     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
956 
957     // Mapping from token ID to index of the owner tokens list
958     mapping(uint256 => uint256) private _ownedTokensIndex;
959 
960     // Array with all token ids, used for enumeration
961     uint256[] private _allTokens;
962 
963     // Mapping from token id to position in the allTokens array
964     mapping(uint256 => uint256) private _allTokensIndex;
965 
966     /**
967      * @dev See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
970         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
975      */
976     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
977         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
978         return _ownedTokens[owner][index];
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-totalSupply}.
983      */
984     function totalSupply() public view virtual override returns (uint256) {
985         return _allTokens.length;
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-tokenByIndex}.
990      */
991     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
992         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
993         return _allTokens[index];
994     }
995 
996     /**
997      * @dev Hook that is called before any token transfer. This includes minting
998      * and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual override {
1016         super._beforeTokenTransfer(from, to, tokenId);
1017 
1018         if (from == address(0)) {
1019             _addTokenToAllTokensEnumeration(tokenId);
1020         } else if (from != to) {
1021             _removeTokenFromOwnerEnumeration(from, tokenId);
1022         }
1023         if (to == address(0)) {
1024             _removeTokenFromAllTokensEnumeration(tokenId);
1025         } else if (to != from) {
1026             _addTokenToOwnerEnumeration(to, tokenId);
1027         }
1028     }
1029 
1030     /**
1031      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1032      * @param to address representing the new owner of the given token ID
1033      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1034      */
1035     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1036         uint256 length = ERC721.balanceOf(to);
1037         _ownedTokens[to][length] = tokenId;
1038         _ownedTokensIndex[tokenId] = length;
1039     }
1040 
1041     /**
1042      * @dev Private function to add a token to this extension's token tracking data structures.
1043      * @param tokenId uint256 ID of the token to be added to the tokens list
1044      */
1045     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1046         _allTokensIndex[tokenId] = _allTokens.length;
1047         _allTokens.push(tokenId);
1048     }
1049 
1050     /**
1051      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1052      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1053      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1054      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1055      * @param from address representing the previous owner of the given token ID
1056      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1057      */
1058     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1059         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1060         // then delete the last slot (swap and pop).
1061 
1062         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1063         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1064 
1065         // When the token to delete is the last token, the swap operation is unnecessary
1066         if (tokenIndex != lastTokenIndex) {
1067             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1068 
1069             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1070             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1071         }
1072 
1073         // This also deletes the contents at the last position of the array
1074         delete _ownedTokensIndex[tokenId];
1075         delete _ownedTokens[from][lastTokenIndex];
1076     }
1077 
1078     /**
1079      * @dev Private function to remove a token from this extension's token tracking data structures.
1080      * This has O(1) time complexity, but alters the order of the _allTokens array.
1081      * @param tokenId uint256 ID of the token to be removed from the tokens list
1082      */
1083     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1084         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1085         // then delete the last slot (swap and pop).
1086 
1087         uint256 lastTokenIndex = _allTokens.length - 1;
1088         uint256 tokenIndex = _allTokensIndex[tokenId];
1089 
1090         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1091         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1092         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1093         uint256 lastTokenId = _allTokens[lastTokenIndex];
1094 
1095         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1096         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1097 
1098         // This also deletes the contents at the last position of the array
1099         delete _allTokensIndex[tokenId];
1100         _allTokens.pop();
1101     }
1102 }
1103 
1104 /**
1105  * @dev Contract module which provides a basic access control mechanism, where
1106  * there is an account (an owner) that can be granted exclusive access to
1107  * specific functions.
1108  *
1109  * By default, the owner account will be the one that deploys the contract. This
1110  * can later be changed with {transferOwnership}.
1111  *
1112  * This module is used through inheritance. It will make available the modifier
1113  * `onlyOwner`, which can be applied to your functions to restrict their use to
1114  * the owner.
1115  */
1116 abstract contract Ownable is Context {
1117     address private _owner;
1118 
1119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1120 
1121     /**
1122      * @dev Initializes the contract setting the deployer as the initial owner.
1123      */
1124     constructor() {
1125         _setOwner(_msgSender());
1126     }
1127 
1128     /**
1129      * @dev Returns the address of the current owner.
1130      */
1131     function owner() public view virtual returns (address) {
1132         return _owner;
1133     }
1134 
1135     /**
1136      * @dev Throws if called by any account other than the owner.
1137      */
1138     modifier onlyOwner() {
1139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1140         _;
1141     }
1142 
1143     /**
1144      * @dev Leaves the contract without owner. It will not be possible to call
1145      * `onlyOwner` functions anymore. Can only be called by the current owner.
1146      *
1147      * NOTE: Renouncing ownership will leave the contract without an owner,
1148      * thereby removing any functionality that is only available to the owner.
1149      */
1150     function renounceOwnership() public virtual onlyOwner {
1151         _setOwner(address(0));
1152     }
1153 
1154     /**
1155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1156      * Can only be called by the current owner.
1157      */
1158     function transferOwnership(address newOwner) public virtual onlyOwner {
1159         require(newOwner != address(0), "Ownable: new owner is the zero address");
1160         _setOwner(newOwner);
1161     }
1162 
1163     function _setOwner(address newOwner) private {
1164         address oldOwner = _owner;
1165         _owner = newOwner;
1166         emit OwnershipTransferred(oldOwner, newOwner);
1167     }
1168 }
1169 
1170 // SPDX-License-Identifier: MIT
1171 //   __  __                 _            ____
1172 //  |  \/  | ___  ___ _ __ | | ___  ___ / ___| __ _ _ __   __ _
1173 //  | |\/| |/ _ \/ _ \ '_ \| |/ _ \/ __| |  _ / _` | '_ \ / _` |
1174 //  | |  | |  __/  __/ |_) | |  __/\__ \ |_| | (_| | | | | (_| |
1175 //  |_|  |_|\___|\___| .__/|_|\___||___/\____|\__,_|_| |_|\__, |
1176 //                   |_|                                  |___/
1177 contract Meeples is ERC721Enumerable, Ownable
1178 {
1179     // Constants
1180     uint256 public constant MEEPLE_PRICE = 0.06 ether;
1181     uint256 public constant TOTAL_MEEPLES = 10000;
1182     uint public constant MAX_MINTS_PER_TRANSACTION = 10;
1183 
1184     uint256 public meepleReserve = 100; // Reserve 100 Meeples for the team - Giveaways/Prizes etc
1185     bool public saleIsActive = false;
1186 
1187     // Metadata
1188     string public baseURI;          // Base URI for metadata
1189     string public provenanceHash;   // Fills in before minting to ensure that medatata was not modified.
1190     
1191     // Presale
1192     mapping(address => uint) private presaleAccessList;     // Addresses that can participate in the presale
1193     mapping(address => uint) private presaleTokensClaimed;  // Balance of presale tokens by address
1194     
1195     constructor() ERC721("Meeples Gang", "MPLSG")
1196     {
1197     }
1198 
1199     function _baseURI() internal view override returns (string memory)
1200     {
1201         return baseURI;
1202     }
1203 
1204     function setBaseURI(string memory newBaseURI) external onlyOwner
1205     {
1206         baseURI = newBaseURI;
1207     }
1208 
1209     function setProvenanceHash(string memory hash) external onlyOwner
1210     {
1211         provenanceHash = hash;
1212     }
1213     
1214     function reserveMeeples(address _to, uint256 _amount) public onlyOwner
1215     {
1216         require(!saleIsActive, "Sale must not be active to reserve Meeples");
1217         require(0 < _amount && _amount < meepleReserve + 1, "Wrong amount");
1218         require(totalSupply() + _amount <= TOTAL_MEEPLES, "Requested amount exceedes max supply of Meeples");
1219         uint supply = totalSupply();
1220         for (uint i = 0; i < _amount; i++)
1221         {
1222             _safeMint(_to, supply + i);
1223         }
1224         meepleReserve -= _amount;
1225     }
1226 
1227     function _mintTokens(uint numberOfTokens) private
1228     {
1229         for (uint i = 0; i < numberOfTokens; i++)
1230         {
1231             _safeMint(msg.sender, totalSupply());
1232         }
1233     }
1234     
1235     function mintMeeple(uint amount) public payable
1236     {
1237         require(saleIsActive, "Sale must be active to mint Meeples");
1238         require(amount > 0 && amount <= MAX_MINTS_PER_TRANSACTION, "Exceeded the mint limit for one transaction");
1239         require(totalSupply() + amount <= TOTAL_MEEPLES, "Purchase would exceed max supply of Meeples");
1240         require(msg.value >= MEEPLE_PRICE * amount, "Ether value sent is not correct");
1241         
1242         _mintTokens(amount);
1243     }
1244 
1245     function withdraw() public payable onlyOwner
1246     {
1247         uint256 balance = address(this).balance;
1248         require(balance > 0, "There's nothing to withdraw.");
1249         payable(msg.sender).transfer(balance);
1250     }
1251 
1252     function toggleSaleState() public onlyOwner
1253     {
1254         saleIsActive = !saleIsActive;
1255     }
1256     
1257     function tokensOfOwner(address _owner) external view returns(uint256[] memory )
1258     {
1259         uint256 tokenCount = balanceOf(_owner);
1260         if (tokenCount == 0)
1261         {
1262             return new uint256[](0); // Return an empty array
1263         }
1264         else
1265         {
1266             uint256[] memory result = new uint256[](tokenCount);
1267             uint256 index;
1268             for (index = 0; index < tokenCount; index++)
1269             {
1270                 result[index] = tokenOfOwnerByIndex(_owner, index);
1271             }
1272             return result;
1273         }
1274     }
1275 
1276     // PRESALE
1277 
1278     // Manage addresses eligible for presale minting.
1279     // Even if we remove and re-add specific address multiple times, it will not change value in 'presaleTokensClaimed'
1280     // thus that specific address can mint only four tokens max.
1281     function setPresaleAddresses(uint numberOfTokens, address[] calldata addresses) external onlyOwner
1282     {
1283         require(numberOfTokens <= 4, "One presale address can only mint up to three tokens");
1284         for (uint256 i = 0; i < addresses.length; i++)
1285         {
1286             if (addresses[i] != address(0)) // Safety check
1287             {
1288                 presaleAccessList[addresses[i]] = numberOfTokens;
1289             }
1290         }
1291     }
1292 
1293     function mintMeeplePresale(uint numberOfTokens) public
1294     {
1295         require(!saleIsActive, "Presale is available only if sale is not active");
1296         require(numberOfTokens <= presaleTokensForAddress(msg.sender), "Trying to mint too many tokens");
1297         require(numberOfTokens > 0, "Number of tokens cannot be lower than, or equal to 0");
1298         require(totalSupply() + numberOfTokens <= TOTAL_MEEPLES, "Minting would exceed total number of available tokens");
1299 
1300         _mintTokens(numberOfTokens);
1301         presaleTokensClaimed[msg.sender] += numberOfTokens;
1302     }
1303 
1304     // Returns the number of available presale tokens for a specific address.
1305     function presaleTokensForAddress(address _address) public view returns (uint)
1306     {
1307         return (presaleTokensClaimed[_address] < presaleAccessList[_address]) ? (presaleAccessList[_address] - presaleTokensClaimed[_address]) : 0;
1308     }
1309 }