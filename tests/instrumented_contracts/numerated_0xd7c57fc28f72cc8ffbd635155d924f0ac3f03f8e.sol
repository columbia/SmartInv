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
930 pragma solidity ^0.8.0;
931 
932 /**************************
933  * @author: Squeebo       *
934  * @license: BSD-3-Clause *
935  **************************/
936 
937 /**
938  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
939  * enumerability of all the token ids in the contract as well as all token ids owned by each
940  * account.
941  */
942 abstract contract ERC721EnumerableB is ERC721B, IERC721Enumerable {    
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      */
946     function supportsInterface(bytes4 interfaceId)
947         public
948         view
949         virtual
950         override(IERC165, ERC721B)
951         returns (bool)
952     {
953         return
954             interfaceId == type(IERC721Enumerable).interfaceId ||
955             super.supportsInterface(interfaceId);
956     }
957 
958     /**
959      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
960      */
961     function tokenOfOwnerByIndex(address owner, uint256 index)
962         public
963         view
964         virtual
965         override
966         returns (uint256 tokenId)
967     {
968         require(
969             index < this.balanceOf(owner),
970             "ERC721Enumerable: owner index out of bounds"
971         );
972 
973         uint256 count;
974         uint256 length = _owners.length;
975         for (uint256 i; i < length; ++i) {
976             if (owner == _owners[i]) {
977                 if (count == index) {
978                     delete count;
979                     delete length;
980                     return i;
981                 } else ++count;
982             }
983         }
984 
985         delete count;
986         delete length;
987         require(false, "ERC721Enumerable: owner index out of bounds");
988     }
989 
990     /**
991      * @dev See {IERC721Enumerable-totalSupply}.
992      */
993     function totalSupply() public view virtual override returns (uint256) {
994         return _owners.length;
995     }
996 
997     /**
998      * @dev See {IERC721Enumerable-tokenByIndex}.
999      */
1000     function tokenByIndex(uint256 index)
1001         public
1002         view
1003         virtual
1004         override
1005         returns (uint256)
1006     {
1007         require(
1008             index < _owners.length,
1009             "ERC721Enumerable: global index out of bounds"
1010         );
1011         return index;
1012     }
1013 }
1014 
1015 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
1016 
1017 
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev String operations.
1023  */
1024 library Strings {
1025     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1026 
1027     /**
1028      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1029      */
1030     function toString(uint256 value) internal pure returns (string memory) {
1031         // Inspired by OraclizeAPI's implementation - MIT licence
1032         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1033 
1034         if (value == 0) {
1035             return "0";
1036         }
1037         uint256 temp = value;
1038         uint256 digits;
1039         while (temp != 0) {
1040             digits++;
1041             temp /= 10;
1042         }
1043         bytes memory buffer = new bytes(digits);
1044         while (value != 0) {
1045             digits -= 1;
1046             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1047             value /= 10;
1048         }
1049         return string(buffer);
1050     }
1051 
1052     /**
1053      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1054      */
1055     function toHexString(uint256 value) internal pure returns (string memory) {
1056         if (value == 0) {
1057             return "0x00";
1058         }
1059         uint256 temp = value;
1060         uint256 length = 0;
1061         while (temp != 0) {
1062             length++;
1063             temp >>= 8;
1064         }
1065         return toHexString(value, length);
1066     }
1067 
1068     /**
1069      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1070      */
1071     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1072         bytes memory buffer = new bytes(2 * length + 2);
1073         buffer[0] = "0";
1074         buffer[1] = "x";
1075         for (uint256 i = 2 * length + 1; i > 1; --i) {
1076             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1077             value >>= 4;
1078         }
1079         require(value == 0, "Strings: hex length insufficient");
1080         return string(buffer);
1081     }
1082 }
1083 
1084 
1085 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1086 
1087 
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 /**
1092  * @dev Contract module which provides a basic access control mechanism, where
1093  * there is an account (an owner) that can be granted exclusive access to
1094  * specific functions.
1095  *
1096  * By default, the owner account will be the one that deploys the contract. This
1097  * can later be changed with {transferOwnership}.
1098  *
1099  * This module is used through inheritance. It will make available the modifier
1100  * `onlyOwner`, which can be applied to your functions to restrict their use to
1101  * the owner.
1102  */
1103 abstract contract Ownable is Context {
1104     address private _owner;
1105 
1106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1107 
1108     /**
1109      * @dev Initializes the contract setting the deployer as the initial owner.
1110      */
1111     constructor() {
1112         _setOwner(_msgSender());
1113     }
1114 
1115     /**
1116      * @dev Returns the address of the current owner.
1117      */
1118     function owner() public view virtual returns (address) {
1119         return _owner;
1120     }
1121 
1122     /**
1123      * @dev Throws if called by any account other than the owner.
1124      */
1125     modifier onlyOwner() {
1126         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1127         _;
1128     }
1129 
1130     /**
1131      * @dev Leaves the contract without owner. It will not be possible to call
1132      * `onlyOwner` functions anymore. Can only be called by the current owner.
1133      *
1134      * NOTE: Renouncing ownership will leave the contract without an owner,
1135      * thereby removing any functionality that is only available to the owner.
1136      */
1137     function renounceOwnership() public virtual onlyOwner {
1138         _setOwner(address(0));
1139     }
1140 
1141     /**
1142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1143      * Can only be called by the current owner.
1144      */
1145     function transferOwnership(address newOwner) public virtual onlyOwner {
1146         require(newOwner != address(0), "Ownable: new owner is the zero address");
1147         _setOwner(newOwner);
1148     }
1149 
1150     function _setOwner(address newOwner) private {
1151         address oldOwner = _owner;
1152         _owner = newOwner;
1153         emit OwnershipTransferred(oldOwner, newOwner);
1154     }
1155 }
1156 
1157 pragma solidity ^0.8.7;
1158 
1159 library ECDSA {
1160     enum RecoverError {
1161         NoError,
1162         InvalidSignature,
1163         InvalidSignatureLength,
1164         InvalidSignatureS,
1165         InvalidSignatureV
1166     }
1167 
1168     function _throwError(RecoverError error) private pure {
1169         if (error == RecoverError.NoError) {
1170             return; // no error: do nothing
1171         } else if (error == RecoverError.InvalidSignature) {
1172             revert("ECDSA: invalid signature");
1173         } else if (error == RecoverError.InvalidSignatureLength) {
1174             revert("ECDSA: invalid signature length");
1175         } else if (error == RecoverError.InvalidSignatureS) {
1176             revert("ECDSA: invalid signature 's' value");
1177         } else if (error == RecoverError.InvalidSignatureV) {
1178             revert("ECDSA: invalid signature 'v' value");
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the address that signed a hashed message (`hash`) with
1184      * `signature` or error string. This address can then be used for verification purposes.
1185      *
1186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1187      * this function rejects them by requiring the `s` value to be in the lower
1188      * half order, and the `v` value to be either 27 or 28.
1189      *
1190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1191      * verification to be secure: it is possible to craft signatures that
1192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1193      * this is by receiving a hash of the original message (which may otherwise
1194      * be too long), and then calling {toEthSignedMessageHash} on it.
1195      *
1196      * Documentation for signature generation:
1197      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1198      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1199      *
1200      * _Available since v4.3._
1201      */
1202     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1203         // Check the signature length
1204         // - case 65: r,s,v signature (standard)
1205         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1206         if (signature.length == 65) {
1207             bytes32 r;
1208             bytes32 s;
1209             uint8 v;
1210             // ecrecover takes the signature parameters, and the only way to get them
1211             // currently is to use assembly.
1212             assembly {
1213                 r := mload(add(signature, 0x20))
1214                 s := mload(add(signature, 0x40))
1215                 v := byte(0, mload(add(signature, 0x60)))
1216             }
1217             return tryRecover(hash, v, r, s);
1218         } else if (signature.length == 64) {
1219             bytes32 r;
1220             bytes32 vs;
1221             // ecrecover takes the signature parameters, and the only way to get them
1222             // currently is to use assembly.
1223             assembly {
1224                 r := mload(add(signature, 0x20))
1225                 vs := mload(add(signature, 0x40))
1226             }
1227             return tryRecover(hash, r, vs);
1228         } else {
1229             return (address(0), RecoverError.InvalidSignatureLength);
1230         }
1231     }
1232 
1233     /**
1234      * @dev Returns the address that signed a hashed message (`hash`) with
1235      * `signature`. This address can then be used for verification purposes.
1236      *
1237      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1238      * this function rejects them by requiring the `s` value to be in the lower
1239      * half order, and the `v` value to be either 27 or 28.
1240      *
1241      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1242      * verification to be secure: it is possible to craft signatures that
1243      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1244      * this is by receiving a hash of the original message (which may otherwise
1245      * be too long), and then calling {toEthSignedMessageHash} on it.
1246      */
1247     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1248         (address recovered, RecoverError error) = tryRecover(hash, signature);
1249         _throwError(error);
1250         return recovered;
1251     }
1252 
1253     /**
1254      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1255      *
1256      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1257      *
1258      * _Available since v4.3._
1259      */
1260     function tryRecover(
1261         bytes32 hash,
1262         bytes32 r,
1263         bytes32 vs
1264     ) internal pure returns (address, RecoverError) {
1265         bytes32 s;
1266         uint8 v;
1267         assembly {
1268             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1269             v := add(shr(255, vs), 27)
1270         }
1271         return tryRecover(hash, v, r, s);
1272     }
1273 
1274     /**
1275      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1276      * `r` and `s` signature fields separately.
1277      *
1278      * _Available since v4.3._
1279      */
1280     function tryRecover(
1281         bytes32 hash,
1282         uint8 v,
1283         bytes32 r,
1284         bytes32 s
1285     ) internal pure returns (address, RecoverError) {
1286         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1287         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1288         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1289         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1290         //
1291         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1292         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1293         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1294         // these malleable signatures as well.
1295         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1296             return (address(0), RecoverError.InvalidSignatureS);
1297         }
1298         if (v != 27 && v != 28) {
1299             return (address(0), RecoverError.InvalidSignatureV);
1300         }
1301 
1302         // If the signature is valid (and not malleable), return the signer address
1303         address signer = ecrecover(hash, v, r, s);
1304         if (signer == address(0)) {
1305             return (address(0), RecoverError.InvalidSignature);
1306         }
1307 
1308         return (signer, RecoverError.NoError);
1309     }
1310 }
1311 
1312 pragma solidity ^0.8.7;
1313 
1314 contract MetaScyra is Ownable, ERC721EnumerableB {
1315 
1316     using ECDSA for bytes32;
1317     using Strings for uint256;
1318 
1319     struct Stake {
1320         uint256 tokenId;
1321         uint256 timestamp;
1322     }
1323 
1324     uint256 public constant SCYRA_MAX = 6667;
1325     uint256 public constant SCYRA_GENESIS_MAX = 667;
1326 
1327     uint256 public constant SCYRA_GIFT = 53;
1328 
1329     uint256 public constant SCYRA_PER_MINT = 2;
1330 
1331     uint256 public constant SCYRA_PURCHASE_LIMIT = 2;
1332     uint256 public constant SCYRA_PRESALE_PURCHASE_LIMIT = 2;
1333 
1334     uint256 public constant SCYRA_GENESIS_PRICE = 0.15 ether;
1335     uint256 public constant SCYRA_PRICE = 0.088 ether;
1336 
1337     uint256 public giftedAmount;
1338 
1339     string public provenance;
1340 
1341     string private _tokenBaseURI;
1342 
1343     address private scyra1 = 0x5243891d7641C0b87695437494ae23A17aB582eB;
1344     address private scyra2 = 0x9DB6dDabe3d8b6181d36367a00D56666cf5c0e97;
1345     address private scyra3 = 0xb8fc44EB23fc325356198818D0Ef2fec7aC0b6D7;
1346     address private scyra4 = 0xE35ff894bDf9B92d02f118717385aB1337A4b6df;
1347     address private scyra5 = 0xea1c9C2152b77835B06f4aD5dF84f6964A1d2117;
1348     address private scyra6 = 0x39B4fb38391D3Df364894C3fc9166832Bf52ba81;
1349     address private scyra7 = 0xb550adB2e2d39D02e9f3A4B85237AB303666230d;
1350     address private scyra8 = 0x4A5056FC80494023E53b2238aE0DE60Cd106E9d9;
1351     address private scyra9 = 0xb032Cc4bD2295b51b07ea0AA43C3465c8F3ABe2b;
1352     address private scyra10 = 0x8a907097c89d76766EdEC06Bd3B38917B94Ef9dE;
1353     address private scyra11 = 0xB8A9021C9c054a0e7A1e7cC9ac8fD21bc8974Bd3;
1354     address private scyra12 = 0x5F69C83e97B4e410b2f5eAC172854900c72b7927;
1355 
1356     address private signerAddress = 0x6f65E7A2bd16fA95D5f99d3Bc82594304670a118;
1357 
1358     bool public presaleLive;
1359     bool public saleLive;
1360     bool public genesisPresaleLive;
1361     bool public genesisLive;
1362 
1363     mapping(address => uint256) private presalerListPurchases;
1364     mapping(address => uint256) private purchases;
1365 
1366     mapping(address => uint256) private genesisPresalePurchases;
1367     mapping(address => uint256) private genesisPurchases;
1368 
1369     mapping(uint256 => Stake) public stakes;
1370     mapping(uint256 => address) private isStaking;
1371     mapping(uint256 => uint256) public stakingTime;
1372     
1373     constructor(
1374         string memory baseUri
1375     ) ERC721B("MetaScyra", "SCYRA") { 
1376         _tokenBaseURI = baseUri;
1377         // zero id
1378         _mint( msg.sender, 0 );
1379         // auction
1380         _mint( msg.sender, 1 );
1381         _mint( msg.sender, 2 );
1382         _mint( msg.sender, 3 );
1383         _mint( msg.sender, 4 );
1384         _mint( msg.sender, 5 );
1385         _mint( msg.sender, 6 );
1386         // team genesis
1387         _mint( scyra1, 7 );
1388         _mint( scyra1, 8 );
1389         _mint( scyra2, 9 );
1390         _mint( scyra3, 10 );
1391         _mint( scyra4, 11 );
1392         _mint( scyra5, 12 );
1393         _mint( scyra6, 13 );
1394         _mint( scyra7, 14 );
1395         _mint( scyra8, 15 );
1396         _mint( scyra9, 16 );
1397         _mint( scyra12, 17 );
1398     }
1399 
1400     /* ---- Functions ---- */
1401 
1402     function stake(uint256 _tokenId) public {
1403         _transfer(msg.sender, address(this), _tokenId);
1404         stakingTime[_tokenId] = 0;
1405         stakes[_tokenId] = Stake(_tokenId, block.timestamp);
1406         _setStaking(msg.sender, _tokenId);
1407     }
1408 
1409     function unstake(uint256 _tokenId) public {
1410         require(isStaking[_tokenId] == msg.sender, "NO_PERMISSION");
1411         stakingTime[_tokenId] += (block.timestamp - stakes[_tokenId].timestamp);
1412         _unStake(_tokenId);
1413         _transfer(address(this), msg.sender, _tokenId);
1414         delete stakes[_tokenId];
1415     }
1416 
1417     function buy(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1418         require(saleLive, "SALE_CLOSED");
1419         require(!presaleLive, "ONLY_PRESALE");
1420         require(tokenQuantity <= SCYRA_PER_MINT, "EXCEED_SCYRA_PER_MINT");
1421         require(SCYRA_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1422         require(totalSupply() + tokenQuantity <= SCYRA_MAX, "EXCEED_MAX_SALE_SUPPLY");
1423         require(purchases[msg.sender] + tokenQuantity <= SCYRA_PURCHASE_LIMIT, "EXCEED_ALLOC");
1424         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1425 
1426         purchases[msg.sender] += tokenQuantity;
1427 
1428         for(uint256 i = 0; i < tokenQuantity; i++) {
1429             uint mintIndex = totalSupply();
1430            _mint( msg.sender, mintIndex );
1431         }
1432     }
1433 
1434     function presaleBuy(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1435         require(!saleLive && presaleLive, "PRESALE_CLOSED");
1436         require(tokenQuantity <= SCYRA_PER_MINT, "EXCEED_SCYRA_PER_MINT");
1437         require(SCYRA_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1438         require(totalSupply() + tokenQuantity <= SCYRA_MAX, "EXCEED_MAX_SALE_SUPPLY");
1439         require(presalerListPurchases[msg.sender] + tokenQuantity <= SCYRA_PRESALE_PURCHASE_LIMIT, "EXCEED_ALLOC");
1440         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1441 
1442         presalerListPurchases[msg.sender] += tokenQuantity;
1443 
1444         for (uint256 i = 0; i < tokenQuantity; i++) {
1445             uint mintIndex = totalSupply();
1446             _mint( msg.sender, mintIndex );
1447         }
1448     } 
1449 
1450     function buyGenesis(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1451         require(genesisLive, "SALE_CLOSED");
1452         require(!genesisPresaleLive, "ONLY_PRESALE");
1453         require(tokenQuantity <= SCYRA_PER_MINT, "EXCEED_SCYRA_PER_MINT");
1454         require(SCYRA_GENESIS_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1455         require(totalSupply() + tokenQuantity <= SCYRA_GENESIS_MAX, "EXCEED_MAX_SALE_SUPPLY");
1456         require(genesisPurchases[msg.sender] + tokenQuantity <= SCYRA_PURCHASE_LIMIT, "EXCEED_ALLOC");
1457         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1458 
1459         genesisPurchases[msg.sender] += tokenQuantity;
1460 
1461         for(uint256 i = 0; i < tokenQuantity; i++) {
1462             uint mintIndex = totalSupply();
1463            _mint( msg.sender, mintIndex );
1464         }
1465     }
1466 
1467     function presaleBuyGenesis(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1468         require(!genesisLive && genesisPresaleLive, "PRESALE_CLOSED");
1469         require(tokenQuantity <= SCYRA_PER_MINT, "EXCEED_SCYRA_PER_MINT");
1470         require(SCYRA_GENESIS_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1471         require(totalSupply() + tokenQuantity <= SCYRA_GENESIS_MAX, "EXCEED_MAX_SALE_SUPPLY");
1472         require(genesisPresalePurchases[msg.sender] + tokenQuantity <= SCYRA_PRESALE_PURCHASE_LIMIT, "EXCEED_ALLOC");
1473         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1474 
1475         genesisPresalePurchases[msg.sender] += tokenQuantity;
1476 
1477         for (uint256 i = 0; i < tokenQuantity; i++) {
1478             uint mintIndex = totalSupply();
1479             _mint( msg.sender, mintIndex );
1480         }
1481     } 
1482 
1483     function withdraw() external onlyOwner {
1484         uint balance = address(this).balance;
1485 
1486         _withdraw(scyra1, balance * 29 / 100);
1487         _withdraw(scyra2, balance * 15 / 100);
1488         _withdraw(scyra3, balance * 20 / 100);
1489         _withdraw(scyra4, balance * 5 / 100);
1490         _withdraw(scyra5, balance * 5 / 100);
1491         _withdraw(scyra6, balance * 1 / 100);
1492         _withdraw(scyra7, balance * 12 / 1000);
1493         _withdraw(scyra8, balance * 5 / 100);
1494         _withdraw(scyra9, balance * 8 / 1000);
1495         _withdraw(scyra10, balance * 3 / 100);
1496         _withdraw(scyra11, balance * 12 / 100);
1497         _withdraw(scyra12, balance * 3 / 100);
1498     }
1499 
1500     function _withdraw(address _address, uint256 _amount) private {
1501         (bool success, ) = _address.call{value: _amount}("");
1502         require(success, "Transfer failed.");
1503     }
1504 
1505     function gift(address _to, uint256 _reserveAmount) external onlyOwner {
1506         require(totalSupply() + _reserveAmount <= SCYRA_MAX, "MAX_MINT");
1507         require(giftedAmount + _reserveAmount <= SCYRA_GIFT, "NO_GIFTS");
1508         
1509         giftedAmount += _reserveAmount;
1510 
1511         for (uint256 i = 0; i < _reserveAmount; i++) {
1512             uint mintIndex = totalSupply();
1513             _safeMint( _to, mintIndex );
1514         }
1515     }
1516     
1517     /* ---- Setters ---- */
1518 
1519     function togglePresaleStatus() external onlyOwner {
1520         presaleLive = !presaleLive;
1521     } 
1522 
1523     function toggleSaleStatus() external onlyOwner {
1524         saleLive = !saleLive;
1525     }
1526 
1527     function toggleGenesisPresaleStatus() external onlyOwner {
1528         genesisPresaleLive = !genesisPresaleLive;
1529     } 
1530 
1531     function toggleGenesisSaleStatus() external onlyOwner {
1532         genesisLive = !genesisLive;
1533     }
1534 
1535     function setBaseURI(string calldata URI) external onlyOwner {
1536         _tokenBaseURI = URI;
1537     }
1538     
1539     function setProvenanceHash(string calldata hash) external onlyOwner {
1540         provenance = hash;
1541     } 
1542 
1543     function setSignerAddress(address _signerAddress) external onlyOwner {
1544         signerAddress = _signerAddress;
1545     } 
1546 
1547     /* ---- Misc ---- */
1548 
1549     function _setStaking(address _owner, uint256 _tokenId) internal {
1550         isStaking[_tokenId] = _owner;
1551     }
1552 
1553     function _unStake(uint256 _tokenId) internal {
1554         require(isStaking[_tokenId] == msg.sender, "NOT_AUTHORIZED");
1555         isStaking[_tokenId] = address(0);
1556     }
1557 
1558     function matchAddressSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
1559         return signerAddress == hash.recover(signature);
1560     }
1561 
1562     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1563         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1564         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1565     } 
1566 
1567     function tokensOfOwner(address addr) external view returns(uint256[] memory) {
1568         uint256 tokenCount = balanceOf(addr);
1569         uint256[] memory tokensId = new uint256[](tokenCount);
1570         for(uint256 i; i < tokenCount; i++){
1571             tokensId[i] = tokenOfOwnerByIndex(addr, i);
1572         }
1573         return tokensId;
1574     }  
1575 }