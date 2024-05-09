1 /*
2   _   _ ______ _______ ______          __  __   ______ _    _ 
3  | \ | |  ____|__   __|  ____|   /\   |  \/  | |  ____| |  | |
4  |  \| | |__     | |  | |__     /  \  | \  / | | |__  | |  | |
5  | . ` |  __|    | |  |  __|   / /\ \ | |\/| | |  __| | |  | |
6  | |\  | |       | |  | |____ / ____ \| |  | |_| |____| |__| |
7  |_| \_|_|       |_|  |______/_/    \_\_|  |_(_)______|\____/ 
8  
9 */
10 
11 
12 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
13 
14 // SPDX-License-Identifier: BSD-3-Clause
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 
40 
41 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
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
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @title ERC721 token receiver interface
188  * @dev Interface for any contract that wants to support safeTransfers
189  * from ERC721 asset contracts.
190  */
191 interface IERC721Receiver {
192     /**
193      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
194      * by `operator` from `from`, this function is called.
195      *
196      * It must return its Solidity selector to confirm the token transfer.
197      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
198      *
199      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
200      */
201     function onERC721Received(
202         address operator,
203         address from,
204         uint256 tokenId,
205         bytes calldata data
206     ) external returns (bytes4);
207 }
208 
209 
210 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
211 
212 
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Enumerable is IERC721 {
244     /**
245      * @dev Returns the total amount of tokens stored by the contract.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
251      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
252      */
253     function tokenOfOwnerByIndex(address owner, uint256 index)
254         external
255         view
256         returns (uint256 tokenId);
257 
258     /**
259      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
260      * Use along with {totalSupply} to enumerate all tokens.
261      */
262     function tokenByIndex(uint256 index) external view returns (uint256);
263 }
264 
265 
266 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
267 
268 
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies on extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         assembly {
300             size := extcodesize(account)
301         }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         (bool success, ) = recipient.call{value: amount}("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain `call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
487 
488 
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Provides information about the current execution context, including the
494  * sender of the transaction and its data. While these are generally available
495  * via msg.sender and msg.data, they should not be accessed in such a direct
496  * manner, since when dealing with meta-transactions the account sending and
497  * paying for execution may not be the actual sender (as far as an application
498  * is concerned).
499  *
500  * This contract is only required for intermediate, library-like contracts.
501  */
502 abstract contract Context {
503     function _msgSender() internal view virtual returns (address) {
504         return msg.sender;
505     }
506 
507     function _msgData() internal view virtual returns (bytes calldata) {
508         return msg.data;
509     }
510 }
511 
512 
513 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 
543 // File contracts/Blimpie/ERC721B.sol
544 
545 
546 pragma solidity ^0.8.0;
547 
548 /********************
549 * @author: Squeebo *
550 ********************/
551 
552 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
553     using Address for address;
554 
555     // Token name
556     string private _name;
557 
558     // Token symbol
559     string private _symbol;
560 
561     // Mapping from token ID to owner address
562     address[] internal _owners;
563 
564     // Mapping from token ID to approved address
565     mapping(uint256 => address) private _tokenApprovals;
566 
567     // Mapping from owner to operator approvals
568     mapping(address => mapping(address => bool)) private _operatorApprovals;
569 
570     /**
571      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
572      */
573     constructor(string memory name_, string memory symbol_) {
574         _name = name_;
575         _symbol = symbol_;
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
582         return
583             interfaceId == type(IERC721).interfaceId ||
584             interfaceId == type(IERC721Metadata).interfaceId ||
585             super.supportsInterface(interfaceId);
586     }
587 
588     /**
589      * @dev See {IERC721-balanceOf}.
590      */
591     function balanceOf(address owner) public view virtual override returns (uint256) {
592         require(owner != address(0), "ERC721: balance query for the zero address");
593 
594         uint count = 0;
595         uint length = _owners.length;
596         for( uint i = 0; i < length; ++i ){
597           if( owner == _owners[i] ){
598             ++count;
599           }
600         }
601 
602         delete length;
603         return count;
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
630      * @dev See {IERC721-approve}.
631      */
632     function approve(address to, uint256 tokenId) public virtual override {
633         address owner = ERC721B.ownerOf(tokenId);
634         require(to != owner, "ERC721: approval to current owner");
635 
636         require(
637             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
638             "ERC721: approve caller is not owner nor approved for all"
639         );
640 
641         _approve(to, tokenId);
642     }
643 
644     /**
645      * @dev See {IERC721-getApproved}.
646      */
647     function getApproved(uint256 tokenId) public view virtual override returns (address) {
648         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
649 
650         return _tokenApprovals[tokenId];
651     }
652 
653     /**
654      * @dev See {IERC721-setApprovalForAll}.
655      */
656     function setApprovalForAll(address operator, bool approved) public virtual override {
657         require(operator != _msgSender(), "ERC721: approve to caller");
658 
659         _operatorApprovals[_msgSender()][operator] = approved;
660         emit ApprovalForAll(_msgSender(), operator, approved);
661     }
662 
663     /**
664      * @dev See {IERC721-isApprovedForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
667         return _operatorApprovals[owner][operator];
668     }
669 
670 
671     /**
672      * @dev See {IERC721-transferFrom}.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         //solhint-disable-next-line max-line-length
680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
681 
682         _transfer(from, to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) public virtual override {
693         safeTransferFrom(from, to, tokenId, "");
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) public virtual override {
705         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
706         _safeTransfer(from, to, tokenId, _data);
707     }
708 
709     /**
710      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
711      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
712      *
713      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
714      *
715      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
716      * implement alternative mechanisms to perform token transfer, such as signature-based.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must exist and be owned by `from`.
723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
724      *
725      * Emits a {Transfer} event.
726      */
727     function _safeTransfer(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) internal virtual {
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
746         return tokenId < _owners.length && _owners[tokenId] != address(0);
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
758         address owner = ERC721B.ownerOf(tokenId);
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
776 
777     /**
778      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
779      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
780      */
781     function _safeMint(
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _mint(to, tokenId);
787         require(
788             _checkOnERC721Received(address(0), to, tokenId, _data),
789             "ERC721: transfer to non ERC721Receiver implementer"
790         );
791     }
792 
793     /**
794      * @dev Mints `tokenId` and transfers it to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
797      *
798      * Requirements:
799      *
800      * - `tokenId` must not exist.
801      * - `to` cannot be the zero address.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _mint(address to, uint256 tokenId) internal virtual {
806         require(to != address(0), "ERC721: mint to the zero address");
807         require(!_exists(tokenId), "ERC721: token already minted");
808 
809         _beforeTokenTransfer(address(0), to, tokenId);
810         _owners.push(to);
811 
812         emit Transfer(address(0), to, tokenId);
813     }
814 
815     /**
816      * @dev Destroys `tokenId`.
817      * The approval is cleared when the token is burned.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _burn(uint256 tokenId) internal virtual {
826         address owner = ERC721B.ownerOf(tokenId);
827 
828         _beforeTokenTransfer(owner, address(0), tokenId);
829 
830         // Clear approvals
831         _approve(address(0), tokenId);
832         _owners[tokenId] = address(0);
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
848     function _transfer(
849         address from,
850         address to,
851         uint256 tokenId
852     ) internal virtual {
853         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
854         require(to != address(0), "ERC721: transfer to the zero address");
855 
856         _beforeTokenTransfer(from, to, tokenId);
857 
858         // Clear approvals from the previous owner
859         _approve(address(0), tokenId);
860         _owners[tokenId] = to;
861 
862         emit Transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev Approve `to` to operate on `tokenId`
867      *
868      * Emits a {Approval} event.
869      */
870     function _approve(address to, uint256 tokenId) internal virtual {
871         _tokenApprovals[tokenId] = to;
872         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
873     }
874 
875 
876     /**
877      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
878      * The call is not executed if the target address is not a contract.
879      *
880      * @param from address representing the previous owner of the given token ID
881      * @param to target address that will receive the tokens
882      * @param tokenId uint256 ID of the token to be transferred
883      * @param _data bytes optional data to send along with the call
884      * @return bool whether the call correctly returned the expected magic value
885      */
886     function _checkOnERC721Received(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) private returns (bool) {
892         if (to.isContract()) {
893             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
894                 return retval == IERC721Receiver.onERC721Received.selector;
895             } catch (bytes memory reason) {
896                 if (reason.length == 0) {
897                     revert("ERC721: transfer to non ERC721Receiver implementer");
898                 } else {
899                     assembly {
900                         revert(add(32, reason), mload(reason))
901                     }
902                 }
903             }
904         } else {
905             return true;
906         }
907     }
908 
909     /**
910      * @dev Hook that is called before any token transfer. This includes minting
911      * and burning.
912      *
913      * Calling conditions:
914      *
915      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
916      * transferred to `to`.
917      * - When `from` is zero, `tokenId` will be minted for `to`.
918      * - When `to` is zero, ``from``'s `tokenId` will be burned.
919      * - `from` and `to` are never both zero.
920      *
921      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
922      */
923     function _beforeTokenTransfer(
924         address from,
925         address to,
926         uint256 tokenId
927     ) internal virtual {}
928 }
929 
930 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
931 
932 
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev String operations.
938  */
939 library Strings {
940     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
941 
942     /**
943      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
944      */
945     function toString(uint256 value) internal pure returns (string memory) {
946         // Inspired by OraclizeAPI's implementation - MIT licence
947         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
948 
949         if (value == 0) {
950             return "0";
951         }
952         uint256 temp = value;
953         uint256 digits;
954         while (temp != 0) {
955             digits++;
956             temp /= 10;
957         }
958         bytes memory buffer = new bytes(digits);
959         while (value != 0) {
960             digits -= 1;
961             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
962             value /= 10;
963         }
964         return string(buffer);
965     }
966 
967     /**
968      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
969      */
970     function toHexString(uint256 value) internal pure returns (string memory) {
971         if (value == 0) {
972             return "0x00";
973         }
974         uint256 temp = value;
975         uint256 length = 0;
976         while (temp != 0) {
977             length++;
978             temp >>= 8;
979         }
980         return toHexString(value, length);
981     }
982 
983     /**
984      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
985      */
986     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
987         bytes memory buffer = new bytes(2 * length + 2);
988         buffer[0] = "0";
989         buffer[1] = "x";
990         for (uint256 i = 2 * length + 1; i > 1; --i) {
991             buffer[i] = _HEX_SYMBOLS[value & 0xf];
992             value >>= 4;
993         }
994         require(value == 0, "Strings: hex length insufficient");
995         return string(buffer);
996     }
997 }
998 
999 
1000 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1001 
1002 
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @dev Contract module which provides a basic access control mechanism, where
1008  * there is an account (an owner) that can be granted exclusive access to
1009  * specific functions.
1010  *
1011  * By default, the owner account will be the one that deploys the contract. This
1012  * can later be changed with {transferOwnership}.
1013  *
1014  * This module is used through inheritance. It will make available the modifier
1015  * `onlyOwner`, which can be applied to your functions to restrict their use to
1016  * the owner.
1017  */
1018 abstract contract Ownable is Context {
1019     address private _owner;
1020 
1021     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1022 
1023     /**
1024      * @dev Initializes the contract setting the deployer as the initial owner.
1025      */
1026     constructor() {
1027         _setOwner(_msgSender());
1028     }
1029 
1030     /**
1031      * @dev Returns the address of the current owner.
1032      */
1033     function owner() public view virtual returns (address) {
1034         return _owner;
1035     }
1036 
1037     /**
1038      * @dev Throws if called by any account other than the owner.
1039      */
1040     modifier onlyOwner() {
1041         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1042         _;
1043     }
1044 
1045     /**
1046      * @dev Leaves the contract without owner. It will not be possible to call
1047      * `onlyOwner` functions anymore. Can only be called by the current owner.
1048      *
1049      * NOTE: Renouncing ownership will leave the contract without an owner,
1050      * thereby removing any functionality that is only available to the owner.
1051      */
1052     function renounceOwnership() public virtual onlyOwner {
1053         _setOwner(address(0));
1054     }
1055 
1056     /**
1057      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1058      * Can only be called by the current owner.
1059      */
1060     function transferOwnership(address newOwner) public virtual onlyOwner {
1061         require(newOwner != address(0), "Ownable: new owner is the zero address");
1062         _setOwner(newOwner);
1063     }
1064 
1065     function _setOwner(address newOwner) private {
1066         address oldOwner = _owner;
1067         _owner = newOwner;
1068         emit OwnershipTransferred(oldOwner, newOwner);
1069     }
1070 }
1071 
1072 pragma solidity ^0.8.7;
1073 
1074 library ECDSA {
1075     enum RecoverError {
1076         NoError,
1077         InvalidSignature,
1078         InvalidSignatureLength,
1079         InvalidSignatureS,
1080         InvalidSignatureV
1081     }
1082 
1083     function _throwError(RecoverError error) private pure {
1084         if (error == RecoverError.NoError) {
1085             return; // no error: do nothing
1086         } else if (error == RecoverError.InvalidSignature) {
1087             revert("ECDSA: invalid signature");
1088         } else if (error == RecoverError.InvalidSignatureLength) {
1089             revert("ECDSA: invalid signature length");
1090         } else if (error == RecoverError.InvalidSignatureS) {
1091             revert("ECDSA: invalid signature 's' value");
1092         } else if (error == RecoverError.InvalidSignatureV) {
1093             revert("ECDSA: invalid signature 'v' value");
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns the address that signed a hashed message (`hash`) with
1099      * `signature` or error string. This address can then be used for verification purposes.
1100      *
1101      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1102      * this function rejects them by requiring the `s` value to be in the lower
1103      * half order, and the `v` value to be either 27 or 28.
1104      *
1105      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1106      * verification to be secure: it is possible to craft signatures that
1107      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1108      * this is by receiving a hash of the original message (which may otherwise
1109      * be too long), and then calling {toEthSignedMessageHash} on it.
1110      *
1111      * Documentation for signature generation:
1112      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1113      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1114      *
1115      * _Available since v4.3._
1116      */
1117     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1118         // Check the signature length
1119         // - case 65: r,s,v signature (standard)
1120         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1121         if (signature.length == 65) {
1122             bytes32 r;
1123             bytes32 s;
1124             uint8 v;
1125             // ecrecover takes the signature parameters, and the only way to get them
1126             // currently is to use assembly.
1127             assembly {
1128                 r := mload(add(signature, 0x20))
1129                 s := mload(add(signature, 0x40))
1130                 v := byte(0, mload(add(signature, 0x60)))
1131             }
1132             return tryRecover(hash, v, r, s);
1133         } else if (signature.length == 64) {
1134             bytes32 r;
1135             bytes32 vs;
1136             // ecrecover takes the signature parameters, and the only way to get them
1137             // currently is to use assembly.
1138             assembly {
1139                 r := mload(add(signature, 0x20))
1140                 vs := mload(add(signature, 0x40))
1141             }
1142             return tryRecover(hash, r, vs);
1143         } else {
1144             return (address(0), RecoverError.InvalidSignatureLength);
1145         }
1146     }
1147 
1148     /**
1149      * @dev Returns the address that signed a hashed message (`hash`) with
1150      * `signature`. This address can then be used for verification purposes.
1151      *
1152      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1153      * this function rejects them by requiring the `s` value to be in the lower
1154      * half order, and the `v` value to be either 27 or 28.
1155      *
1156      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1157      * verification to be secure: it is possible to craft signatures that
1158      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1159      * this is by receiving a hash of the original message (which may otherwise
1160      * be too long), and then calling {toEthSignedMessageHash} on it.
1161      */
1162     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1163         (address recovered, RecoverError error) = tryRecover(hash, signature);
1164         _throwError(error);
1165         return recovered;
1166     }
1167 
1168     /**
1169      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1170      *
1171      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1172      *
1173      * _Available since v4.3._
1174      */
1175     function tryRecover(
1176         bytes32 hash,
1177         bytes32 r,
1178         bytes32 vs
1179     ) internal pure returns (address, RecoverError) {
1180         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1181         uint8 v = uint8((uint256(vs) >> 255) + 27);
1182         return tryRecover(hash, v, r, s);
1183     }
1184 
1185     /**
1186      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1187      *
1188      * _Available since v4.2._
1189      */
1190     function recover(
1191         bytes32 hash,
1192         bytes32 r,
1193         bytes32 vs
1194     ) internal pure returns (address) {
1195         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1196         _throwError(error);
1197         return recovered;
1198     }
1199 
1200     /**
1201      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1202      * `r` and `s` signature fields separately.
1203      *
1204      * _Available since v4.3._
1205      */
1206     function tryRecover(
1207         bytes32 hash,
1208         uint8 v,
1209         bytes32 r,
1210         bytes32 s
1211     ) internal pure returns (address, RecoverError) {
1212         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1213         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1214         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1215         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1216         //
1217         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1218         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1219         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1220         // these malleable signatures as well.
1221         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1222             return (address(0), RecoverError.InvalidSignatureS);
1223         }
1224         if (v != 27 && v != 28) {
1225             return (address(0), RecoverError.InvalidSignatureV);
1226         }
1227 
1228         // If the signature is valid (and not malleable), return the signer address
1229         address signer = ecrecover(hash, v, r, s);
1230         if (signer == address(0)) {
1231             return (address(0), RecoverError.InvalidSignature);
1232         }
1233 
1234         return (signer, RecoverError.NoError);
1235     }
1236 
1237     /**
1238      * @dev Overload of {ECDSA-recover} that receives the `v`,
1239      * `r` and `s` signature fields separately.
1240      */
1241     function recover(
1242         bytes32 hash,
1243         uint8 v,
1244         bytes32 r,
1245         bytes32 s
1246     ) internal pure returns (address) {
1247         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1248         _throwError(error);
1249         return recovered;
1250     }
1251 
1252     /**
1253      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1254      * produces hash corresponding to the one signed with the
1255      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1256      * JSON-RPC method as part of EIP-191.
1257      *
1258      * See {recover}.
1259      */
1260     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1261         // 32 is the length in bytes of hash,
1262         // enforced by the type signature above
1263         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1264     }
1265 
1266     /**
1267      * @dev Returns an Ethereum Signed Message, created from `s`. This
1268      * produces hash corresponding to the one signed with the
1269      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1270      * JSON-RPC method as part of EIP-191.
1271      *
1272      * See {recover}.
1273      */
1274     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1275         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1276     }
1277 
1278     /**
1279      * @dev Returns an Ethereum Signed Typed Data, created from a
1280      * `domainSeparator` and a `structHash`. This produces hash corresponding
1281      * to the one signed with the
1282      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1283      * JSON-RPC method as part of EIP-712.
1284      *
1285      * See {recover}.
1286      */
1287     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1288         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1289     }
1290 }
1291 
1292 pragma solidity ^0.8.7;
1293 
1294 contract SKREAMAZ is Ownable, ERC721B {
1295 
1296     using ECDSA for bytes32;
1297     using Strings for uint256;
1298 
1299     uint256 public constant maxSupply = 4444;
1300     uint256 public constant giftSupply = 300;
1301 
1302     uint256 public constant ogPurchaseLimit = 8;
1303     uint256 public constant wlPurchaseLimit = 6;
1304     uint256 public constant purchaseLimit = 4;
1305 
1306     uint256 public giftedAmount;
1307 
1308     string public provenance;
1309 
1310     string private _tokenBaseURI;
1311 
1312     address private signerAddress = 0xA9D6F77337827c4Cb6bc91d6E8891173a62A8862;
1313 
1314     bool public ogSaleLive;
1315     bool public presaleLive;
1316     bool public saleLive;
1317 
1318     mapping(address => uint256) private ogPurchases;
1319     mapping(address => uint256) private wlPurchases;
1320     mapping(address => uint256) private purchases;
1321     
1322     constructor(
1323         string memory baseUri
1324     ) ERC721B("SKREAMAZ", "SKREAMAZ") { 
1325         _tokenBaseURI = baseUri;
1326     }
1327 
1328     /* ---- Functions ---- */
1329 
1330     function ogMint(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s, uint256 tokenQuantity) external payable {
1331         require(ogSaleLive, "OG_SALE_CLOSED");
1332         require(tokenQuantity <= ogPurchaseLimit, "EXCEED_SKREAMAZ_PER_MINT");
1333         require(totalSupply() + tokenQuantity < maxSupply, "EXCEED_MAX_SALE_SUPPLY");
1334         require(ogPurchases[msg.sender] + tokenQuantity <= ogPurchaseLimit, "EXCEED_ALLOC");
1335         require(verifyMessage(_hashedMessage, _v, _r, _s) == signerAddress, "NO_DIRECT_MINT");
1336 
1337         ogPurchases[msg.sender] += tokenQuantity;
1338 
1339         for(uint256 i = 0; i < tokenQuantity; i++) {
1340             uint mintIndex = totalSupply();
1341            _mint( msg.sender, mintIndex );
1342         }
1343     }
1344 
1345     function wlMint(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s, uint256 tokenQuantity) external payable {
1346         require(presaleLive, "PRESALE_CLOSED");
1347         require(tokenQuantity <= wlPurchaseLimit, "EXCEED_SKREAMAZ_PER_MINT");
1348         require(totalSupply() + tokenQuantity < maxSupply, "EXCEED_MAX_SALE_SUPPLY");
1349         require(wlPurchases[msg.sender] + tokenQuantity <= wlPurchaseLimit, "EXCEED_ALLOC");
1350         require(verifyMessage(_hashedMessage, _v, _r, _s) == signerAddress, "NO_DIRECT_MINT");
1351 
1352         wlPurchases[msg.sender] += tokenQuantity;
1353 
1354         for (uint256 i = 0; i < tokenQuantity; i++) {
1355             uint mintIndex = totalSupply();
1356             _mint( msg.sender, mintIndex );
1357         }
1358     } 
1359 
1360     function mint(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s, uint256 tokenQuantity) external payable {
1361         require(saleLive, "SALE_CLOSED");
1362         require(tokenQuantity <= purchaseLimit, "EXCEED_SKREAMAZ_PER_MINT");
1363         require(totalSupply() + tokenQuantity < maxSupply, "EXCEED_MAX_SALE_SUPPLY");
1364         require(purchases[msg.sender] + tokenQuantity <= purchaseLimit, "EXCEED_ALLOC");
1365         require(verifyMessage(_hashedMessage, _v, _r, _s) == signerAddress, "NO_DIRECT_MINT");
1366 
1367         purchases[msg.sender] += tokenQuantity;
1368 
1369         for (uint256 i = 0; i < tokenQuantity; i++) {
1370             uint mintIndex = totalSupply();
1371             _mint( msg.sender, mintIndex );
1372         }
1373     } 
1374 
1375     function withdraw() external onlyOwner {
1376         uint balance = address(this).balance;
1377         _withdraw(msg.sender, balance);
1378     }
1379 
1380     function _withdraw(address _address, uint256 _amount) private {
1381         (bool success, ) = _address.call{value: _amount}("");
1382         require(success, "Transfer failed.");
1383     }
1384 
1385     function gift(address _to, uint256 _reserveAmount) external onlyOwner {
1386         require(totalSupply() + _reserveAmount <= maxSupply, "MAX_MINT");
1387         require(giftedAmount + _reserveAmount <= giftSupply, "NO_GIFTS");
1388         
1389         giftedAmount += _reserveAmount;
1390 
1391         for (uint256 i = 0; i < _reserveAmount; i++) {
1392             uint mintIndex = totalSupply();
1393             _safeMint( _to, mintIndex );
1394         }
1395     }
1396     
1397     /* ---- Setters ---- */
1398 
1399     function togglePresaleStatus() external onlyOwner {
1400         presaleLive = !presaleLive;
1401     } 
1402 
1403     function toggleSaleStatus() external onlyOwner {
1404         saleLive = !saleLive;
1405     }
1406 
1407     function toggleOGSaleStatus() external onlyOwner {
1408         ogSaleLive = !ogSaleLive;
1409     }
1410 
1411     function setBaseURI(string calldata URI) external onlyOwner {
1412         _tokenBaseURI = URI;
1413     }
1414     
1415     function setProvenanceHash(string calldata hash) external onlyOwner {
1416         provenance = hash;
1417     } 
1418 
1419     function setSignerAddress(address _signerAddress) external onlyOwner {
1420         signerAddress = _signerAddress;
1421     } 
1422 
1423     /* ---- Misc ---- */
1424 
1425     function totalSupply() public view virtual returns (uint256) {
1426         return _owners.length;
1427     }
1428 
1429     function verifyMessage(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
1430         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1431         bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _hashedMessage));
1432         address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
1433         return signer;
1434     }
1435 
1436     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1437         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1438         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1439     }
1440 }