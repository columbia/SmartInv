1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // This method relies on extcodesize, which returns 0 for contracts in
50         // construction, since the code is only stored at the end of the
51         // constructor execution.
52 
53         uint256 size;
54         assembly {
55             size := extcodesize(account)
56         }
57         return size > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62      * `recipient`, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by `transfer`, making them unable to receive funds via
67      * `transfer`. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to `recipient`, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level `call`. A
85      * plain `call` is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If `target` reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
93      *
94      * Requirements:
95      *
96      * - `target` must be a contract.
97      * - calling `target` with `data` must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
107      * `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Interface of the ERC165 standard, as defined in the
245  * https://eips.ethereum.org/EIPS/eip-165[EIP].
246  *
247  * Implementers can declare support of contract interfaces, which can then be
248  * queried by others ({ERC165Checker}).
249  *
250  * For an implementation, see {ERC165}.
251  */
252 interface IERC165 {
253     /**
254      * @dev Returns true if this contract implements the interface defined by
255      * `interfaceId`. See the corresponding
256      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
257      * to learn more about how these ids are created.
258      *
259      * This function call must use less than 30 000 gas.
260      */
261     function supportsInterface(bytes4 interfaceId) external view returns (bool);
262 }
263 
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Implementation of the {IERC165} interface.
269  *
270  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
271  * for the additional interface id that will be supported. For example:
272  *
273  * ```solidity
274  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
275  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
276  * }
277  * ```
278  *
279  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
280  */
281 abstract contract ERC165 is IERC165 {
282     /**
283      * @dev See {IERC165-supportsInterface}.
284      */
285     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
286         return interfaceId == type(IERC165).interfaceId;
287     }
288 }
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Required interface of an ERC721 compliant contract.
294  */
295 interface IERC721 is IERC165 {
296     /**
297      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
298      */
299     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
300 
301     /**
302      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
303      */
304     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
308      */
309     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
310 
311     /**
312      * @dev Returns the number of tokens in ``owner``'s account.
313      */
314     function balanceOf(address owner) external view returns (uint256 balance);
315 
316     /**
317      * @dev Returns the owner of the `tokenId` token.
318      *
319      * Requirements:
320      *
321      * - `tokenId` must exist.
322      */
323     function ownerOf(uint256 tokenId) external view returns (address owner);
324 
325     /**
326      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
327      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
328      *
329      * Requirements:
330      *
331      * - `from` cannot be the zero address.
332      * - `to` cannot be the zero address.
333      * - `tokenId` token must exist and be owned by `from`.
334      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
336      *
337      * Emits a {Transfer} event.
338      */
339     function safeTransferFrom(
340         address from,
341         address to,
342         uint256 tokenId
343     ) external;
344 
345     /**
346      * @dev Transfers `tokenId` token from `from` to `to`.
347      *
348      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `tokenId` token must be owned by `from`.
355      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transferFrom(
360         address from,
361         address to,
362         uint256 tokenId
363     ) external;
364 
365     /**
366      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
367      * The approval is cleared when the token is transferred.
368      *
369      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
370      *
371      * Requirements:
372      *
373      * - The caller must own the token or be an approved operator.
374      * - `tokenId` must exist.
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address to, uint256 tokenId) external;
379 
380     /**
381      * @dev Returns the account approved for `tokenId` token.
382      *
383      * Requirements:
384      *
385      * - `tokenId` must exist.
386      */
387     function getApproved(uint256 tokenId) external view returns (address operator);
388 
389     /**
390      * @dev Approve or remove `operator` as an operator for the caller.
391      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
392      *
393      * Requirements:
394      *
395      * - The `operator` cannot be the caller.
396      *
397      * Emits an {ApprovalForAll} event.
398      */
399     function setApprovalForAll(address operator, bool _approved) external;
400 
401     /**
402      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
403      *
404      * See {setApprovalForAll}
405      */
406     function isApprovedForAll(address owner, address operator) external view returns (bool);
407 
408     /**
409      * @dev Safely transfers `tokenId` token from `from` to `to`.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must exist and be owned by `from`.
416      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
418      *
419      * Emits a {Transfer} event.
420      */
421     function safeTransferFrom(
422         address from,
423         address to,
424         uint256 tokenId,
425         bytes calldata data
426     ) external;
427 }
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @title ERC721 token receiver interface
433  * @dev Interface for any contract that wants to support safeTransfers
434  * from ERC721 asset contracts.
435  */
436 interface IERC721Receiver {
437     /**
438      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
439      * by `operator` from `from`, this function is called.
440      *
441      * It must return its Solidity selector to confirm the token transfer.
442      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
443      *
444      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
445      */
446     function onERC721Received(
447         address operator,
448         address from,
449         uint256 tokenId,
450         bytes calldata data
451     ) external returns (bytes4);
452 }
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
458  * @dev See https://eips.ethereum.org/EIPS/eip-721
459  */
460 interface IERC721Metadata is IERC721 {
461     /**
462      * @dev Returns the token collection name.
463      */
464     function name() external view returns (string memory);
465 
466     /**
467      * @dev Returns the token collection symbol.
468      */
469     function symbol() external view returns (string memory);
470 
471     /**
472      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
473      */
474     function tokenURI(uint256 tokenId) external view returns (string memory);
475 }
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
481  * @dev See https://eips.ethereum.org/EIPS/eip-721
482  */
483 interface IERC721Enumerable is IERC721 {
484     /**
485      * @dev Returns the total amount of tokens stored by the contract.
486      */
487     function totalSupply() external view returns (uint256);
488 
489     /**
490      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
491      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
492      */
493     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
494 
495     /**
496      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
497      * Use along with {totalSupply} to enumerate all tokens.
498      */
499     function tokenByIndex(uint256 index) external view returns (uint256);
500 }
501 
502 pragma solidity ^0.8.10;
503 
504 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
505     using Address for address;
506     string private _name;
507     string private _symbol;
508     address[] internal _owners;
509     mapping(uint256 => address) private _tokenApprovals;
510     mapping(address => mapping(address => bool)) private _operatorApprovals;
511     constructor(string memory name_, string memory symbol_) {
512         _name = name_;
513         _symbol = symbol_;
514     }
515     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
516         return
517         interfaceId == type(IERC721).interfaceId ||
518         interfaceId == type(IERC721Metadata).interfaceId ||
519         super.supportsInterface(interfaceId);
520     }
521     function balanceOf(address owner) public view virtual override returns (uint256) {
522         require(owner != address(0), "ERC721: balance query for the zero address");
523         uint count = 0;
524         uint length = _owners.length;
525         for( uint i = 0; i < length; ++i ){
526             if( owner == _owners[i] ){
527                 ++count;
528             }
529         }
530         delete length;
531         return count;
532     }
533     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
534         address owner = _owners[tokenId];
535         require(owner != address(0), "ERC721: owner query for nonexistent token");
536         return owner;
537     }
538     function name() public view virtual override returns (string memory) {
539         return _name;
540     }
541     function symbol() public view virtual override returns (string memory) {
542         return _symbol;
543     }
544     function approve(address to, uint256 tokenId) public virtual override {
545         address owner = ERC721P.ownerOf(tokenId);
546         require(to != owner, "ERC721: approval to current owner");
547 
548         require(
549             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
550             "ERC721: approve caller is not owner nor approved for all"
551         );
552 
553         _approve(to, tokenId);
554     }
555     function getApproved(uint256 tokenId) public view virtual override returns (address) {
556         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
557 
558         return _tokenApprovals[tokenId];
559     }
560     function setApprovalForAll(address operator, bool approved) public virtual override {
561         require(operator != _msgSender(), "ERC721: approve to caller");
562 
563         _operatorApprovals[_msgSender()][operator] = approved;
564         emit ApprovalForAll(_msgSender(), operator, approved);
565     }
566     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
567         return _operatorApprovals[owner][operator];
568     }
569     function transferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) public virtual override {
574         //solhint-disable-next-line max-line-length
575         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
576 
577         _transfer(from, to, tokenId);
578     }
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) public virtual override {
584         safeTransferFrom(from, to, tokenId, "");
585     }
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes memory _data
591     ) public virtual override {
592         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
593         _safeTransfer(from, to, tokenId, _data);
594     }
595     function _safeTransfer(
596         address from,
597         address to,
598         uint256 tokenId,
599         bytes memory _data
600     ) internal virtual {
601         _transfer(from, to, tokenId);
602         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
603     }
604     function _exists(uint256 tokenId) internal view virtual returns (bool) {
605         return tokenId < _owners.length && _owners[tokenId] != address(0);
606     }
607     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
608         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
609         address owner = ERC721P.ownerOf(tokenId);
610         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
611     }
612     function _safeMint(address to, uint256 tokenId) internal virtual {
613         _safeMint(to, tokenId, "");
614     }
615     function _safeMint(
616         address to,
617         uint256 tokenId,
618         bytes memory _data
619     ) internal virtual {
620         _mint(to, tokenId);
621         require(
622             _checkOnERC721Received(address(0), to, tokenId, _data),
623             "ERC721: transfer to non ERC721Receiver implementer"
624         );
625     }
626     function _mint(address to, uint256 tokenId) internal virtual {
627         require(to != address(0), "ERC721: mint to the zero address");
628         require(!_exists(tokenId), "ERC721: token already minted");
629 
630         _beforeTokenTransfer(address(0), to, tokenId);
631         _owners.push(to);
632 
633         emit Transfer(address(0), to, tokenId);
634     }
635     function _burn(uint256 tokenId) internal virtual {
636         address owner = ERC721P.ownerOf(tokenId);
637 
638         _beforeTokenTransfer(owner, address(0), tokenId);
639 
640         // Clear approvals
641         _approve(address(0), tokenId);
642         _owners[tokenId] = address(0);
643 
644         emit Transfer(owner, address(0), tokenId);
645     }
646     function _transfer(
647         address from,
648         address to,
649         uint256 tokenId
650     ) internal virtual {
651         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
652         require(to != address(0), "ERC721: transfer to the zero address");
653 
654         _beforeTokenTransfer(from, to, tokenId);
655 
656         // Clear approvals from the previous owner
657         _approve(address(0), tokenId);
658         _owners[tokenId] = to;
659 
660         emit Transfer(from, to, tokenId);
661     }
662     function _approve(address to, uint256 tokenId) internal virtual {
663         _tokenApprovals[tokenId] = to;
664         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
665     }
666     function _checkOnERC721Received(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) private returns (bool) {
672         if (to.isContract()) {
673             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
674                 return retval == IERC721Receiver.onERC721Received.selector;
675             } catch (bytes memory reason) {
676                 if (reason.length == 0) {
677                     revert("ERC721: transfer to non ERC721Receiver implementer");
678                 } else {
679                     assembly {
680                         revert(add(32, reason), mload(reason))
681                     }
682                 }
683             }
684         } else {
685             return true;
686         }
687     }
688     function _beforeTokenTransfer(
689         address from,
690         address to,
691         uint256 tokenId
692     ) internal virtual {}
693 }
694 
695 pragma solidity ^0.8.10;
696 
697 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
698     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
699         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
700     }
701     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
702         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
703         uint count;
704         for( uint i; i < _owners.length; ++i ){
705             if( owner == _owners[i] ){
706                 if( count == index )
707                     return i;
708                 else
709                     ++count;
710             }
711         }
712         require(false, "ERC721Enum: owner ioob");
713     }
714     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
715         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
716         uint256 tokenCount = balanceOf(owner);
717         uint256[] memory tokenIds = new uint256[](tokenCount);
718         for (uint256 i = 0; i < tokenCount; i++) {
719             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
720         }
721         return tokenIds;
722     }
723     function totalSupply() public view virtual override returns (uint256) {
724         return _owners.length;
725     }
726     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
727         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
728         return index;
729     }
730 }
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Contract module which provides a basic access control mechanism, where
736  * there is an account (an owner) that can be granted exclusive access to
737  * specific functions.
738  *
739  * By default, the owner account will be the one that deploys the contract. This
740  * can later be changed with {transferOwnership}.
741  *
742  * This module is used through inheritance. It will make available the modifier
743  * `onlyOwner`, which can be applied to your functions to restrict their use to
744  * the owner.
745  */
746 abstract contract Ownable is Context {
747     address private _owner;
748 
749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
750 
751     /**
752      * @dev Initializes the contract setting the deployer as the initial owner.
753      */
754     constructor() {
755         _setOwner(_msgSender());
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view virtual returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         _setOwner(address(0));
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         _setOwner(newOwner);
791     }
792 
793     function _setOwner(address newOwner) private {
794         address oldOwner = _owner;
795         _owner = newOwner;
796         emit OwnershipTransferred(oldOwner, newOwner);
797     }
798 }
799 
800 pragma solidity ^0.8.0;
801 
802 /**
803  * @dev String operations.
804  */
805 library Strings {
806     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
807 
808     /**
809      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
810      */
811     function toString(uint256 value) internal pure returns (string memory) {
812         // Inspired by OraclizeAPI's implementation - MIT licence
813         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
814 
815         if (value == 0) {
816             return "0";
817         }
818         uint256 temp = value;
819         uint256 digits;
820         while (temp != 0) {
821             digits++;
822             temp /= 10;
823         }
824         bytes memory buffer = new bytes(digits);
825         while (value != 0) {
826             digits -= 1;
827             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
828             value /= 10;
829         }
830         return string(buffer);
831     }
832 
833     /**
834      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
835      */
836     function toHexString(uint256 value) internal pure returns (string memory) {
837         if (value == 0) {
838             return "0x00";
839         }
840         uint256 temp = value;
841         uint256 length = 0;
842         while (temp != 0) {
843             length++;
844             temp >>= 8;
845         }
846         return toHexString(value, length);
847     }
848 
849     /**
850      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
851      */
852     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
853         bytes memory buffer = new bytes(2 * length + 2);
854         buffer[0] = "0";
855         buffer[1] = "x";
856         for (uint256 i = 2 * length + 1; i > 1; --i) {
857             buffer[i] = _HEX_SYMBOLS[value & 0xf];
858             value >>= 4;
859         }
860         require(value == 0, "Strings: hex length insufficient");
861         return string(buffer);
862     }
863 }
864 
865 pragma solidity ^0.8.0;
866 
867 // CAUTION
868 // This version of SafeMath should only be used with Solidity 0.8 or later,
869 // because it relies on the compiler's built in overflow checks.
870 
871 /**
872  * @dev Wrappers over Solidity's arithmetic operations.
873  *
874  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
875  * now has built in overflow checking.
876  */
877 library SafeMath {
878     /**
879      * @dev Returns the addition of two unsigned integers, with an overflow flag.
880      *
881      * _Available since v3.4._
882      */
883     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
884     unchecked {
885         uint256 c = a + b;
886         if (c < a) return (false, 0);
887         return (true, c);
888     }
889     }
890 
891     /**
892      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
893      *
894      * _Available since v3.4._
895      */
896     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
897     unchecked {
898         if (b > a) return (false, 0);
899         return (true, a - b);
900     }
901     }
902 
903     /**
904      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
905      *
906      * _Available since v3.4._
907      */
908     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
909     unchecked {
910         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
911         // benefit is lost if 'b' is also tested.
912         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
913         if (a == 0) return (true, 0);
914         uint256 c = a * b;
915         if (c / a != b) return (false, 0);
916         return (true, c);
917     }
918     }
919 
920     /**
921      * @dev Returns the division of two unsigned integers, with a division by zero flag.
922      *
923      * _Available since v3.4._
924      */
925     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
926     unchecked {
927         if (b == 0) return (false, 0);
928         return (true, a / b);
929     }
930     }
931 
932     /**
933      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
934      *
935      * _Available since v3.4._
936      */
937     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
938     unchecked {
939         if (b == 0) return (false, 0);
940         return (true, a % b);
941     }
942     }
943 
944     /**
945      * @dev Returns the addition of two unsigned integers, reverting on
946      * overflow.
947      *
948      * Counterpart to Solidity's `+` operator.
949      *
950      * Requirements:
951      *
952      * - Addition cannot overflow.
953      */
954     function add(uint256 a, uint256 b) internal pure returns (uint256) {
955         return a + b;
956     }
957 
958     /**
959      * @dev Returns the subtraction of two unsigned integers, reverting on
960      * overflow (when the result is negative).
961      *
962      * Counterpart to Solidity's `-` operator.
963      *
964      * Requirements:
965      *
966      * - Subtraction cannot overflow.
967      */
968     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
969         return a - b;
970     }
971 
972     /**
973      * @dev Returns the multiplication of two unsigned integers, reverting on
974      * overflow.
975      *
976      * Counterpart to Solidity's `*` operator.
977      *
978      * Requirements:
979      *
980      * - Multiplication cannot overflow.
981      */
982     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
983         return a * b;
984     }
985 
986     /**
987      * @dev Returns the integer division of two unsigned integers, reverting on
988      * division by zero. The result is rounded towards zero.
989      *
990      * Counterpart to Solidity's `/` operator.
991      *
992      * Requirements:
993      *
994      * - The divisor cannot be zero.
995      */
996     function div(uint256 a, uint256 b) internal pure returns (uint256) {
997         return a / b;
998     }
999 
1000     /**
1001      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1002      * reverting when dividing by zero.
1003      *
1004      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1005      * opcode (which leaves remaining gas untouched) while Solidity uses an
1006      * invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1013         return a % b;
1014     }
1015 
1016     /**
1017      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1018      * overflow (when the result is negative).
1019      *
1020      * CAUTION: This function is deprecated because it requires allocating memory for the error
1021      * message unnecessarily. For custom revert reasons use {trySub}.
1022      *
1023      * Counterpart to Solidity's `-` operator.
1024      *
1025      * Requirements:
1026      *
1027      * - Subtraction cannot overflow.
1028      */
1029     function sub(
1030         uint256 a,
1031         uint256 b,
1032         string memory errorMessage
1033     ) internal pure returns (uint256) {
1034     unchecked {
1035         require(b <= a, errorMessage);
1036         return a - b;
1037     }
1038     }
1039 
1040     /**
1041      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1042      * division by zero. The result is rounded towards zero.
1043      *
1044      * Counterpart to Solidity's `/` operator. Note: this function uses a
1045      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1046      * uses an invalid opcode to revert (consuming all remaining gas).
1047      *
1048      * Requirements:
1049      *
1050      * - The divisor cannot be zero.
1051      */
1052     function div(
1053         uint256 a,
1054         uint256 b,
1055         string memory errorMessage
1056     ) internal pure returns (uint256) {
1057     unchecked {
1058         require(b > 0, errorMessage);
1059         return a / b;
1060     }
1061     }
1062 
1063     /**
1064      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1065      * reverting with custom message when dividing by zero.
1066      *
1067      * CAUTION: This function is deprecated because it requires allocating memory for the error
1068      * message unnecessarily. For custom revert reasons use {tryMod}.
1069      *
1070      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1071      * opcode (which leaves remaining gas untouched) while Solidity uses an
1072      * invalid opcode to revert (consuming all remaining gas).
1073      *
1074      * Requirements:
1075      *
1076      * - The divisor cannot be zero.
1077      */
1078     function mod(
1079         uint256 a,
1080         uint256 b,
1081         string memory errorMessage
1082     ) internal pure returns (uint256) {
1083     unchecked {
1084         require(b > 0, errorMessage);
1085         return a % b;
1086     }
1087     }
1088 }
1089 
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 /**
1094  * @dev Contract module that helps prevent reentrant calls to a function.
1095  *
1096  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1097  * available, which can be applied to functions to make sure there are no nested
1098  * (reentrant) calls to them.
1099  *
1100  * Note that because there is a single `nonReentrant` guard, functions marked as
1101  * `nonReentrant` may not call one another. This can be worked around by making
1102  * those functions `private`, and then adding `external` `nonReentrant` entry
1103  * points to them.
1104  *
1105  * TIP: If you would like to learn more about reentrancy and alternative ways
1106  * to protect against it, check out our blog post
1107  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1108  */
1109 abstract contract ReentrancyGuard {
1110     // Booleans are more expensive than uint256 or any type that takes up a full
1111     // word because each write operation emits an extra SLOAD to first read the
1112     // slot's contents, replace the bits taken up by the boolean, and then write
1113     // back. This is the compiler's defense against contract upgrades and
1114     // pointer aliasing, and it cannot be disabled.
1115 
1116     // The values being non-zero value makes deployment a bit more expensive,
1117     // but in exchange the refund on every call to nonReentrant will be lower in
1118     // amount. Since refunds are capped to a percentage of the total
1119     // transaction's gas, it is best to keep them low in cases like this one, to
1120     // increase the likelihood of the full refund coming into effect.
1121     uint256 private constant _NOT_ENTERED = 1;
1122     uint256 private constant _ENTERED = 2;
1123 
1124     uint256 private _status;
1125 
1126     constructor() {
1127         _status = _NOT_ENTERED;
1128     }
1129 
1130     /**
1131      * @dev Prevents a contract from calling itself, directly or indirectly.
1132      * Calling a `nonReentrant` function from another `nonReentrant`
1133      * function is not supported. It is possible to prevent this from happening
1134      * by making the `nonReentrant` function external, and make it call a
1135      * `private` function that does the actual work.
1136      */
1137     modifier nonReentrant() {
1138         // On the first call to nonReentrant, _notEntered will be true
1139         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1140 
1141         // Any calls to nonReentrant after this point will fail
1142         _status = _ENTERED;
1143 
1144         _;
1145 
1146         // By storing the original value once again, a refund is triggered (see
1147         // https://eips.ethereum.org/EIPS/eip-2200)
1148         _status = _NOT_ENTERED;
1149     }
1150 }
1151 
1152 pragma solidity ^0.8.10;
1153 
1154 contract CrazyMummiez is ERC721Enum, Ownable, ReentrancyGuard {
1155     using Strings for uint256;
1156     string public baseURI;
1157     //sale settings
1158     uint256 public cost = 0.1 ether;
1159     uint256 public maxSupply = 3333;
1160     uint256 public maxClaim = 3333;
1161     uint256 public maxMint = 3;
1162     uint256 public requiredParentTokensForClaim = 3;
1163     bool public status = false;
1164     ParentContractInterface parentContractInterface;
1165 
1166     mapping(uint256 => bool) _claimedParents;
1167 
1168     //presale settings
1169     constructor(
1170         string memory _name,
1171         string memory _symbol,
1172         string memory _initBaseURI,
1173         address _parentContractAddress
1174     ) ERC721P(_name, _symbol) {
1175         parentContractInterface = ParentContractInterface(_parentContractAddress);
1176         setBaseURI(_initBaseURI);
1177     }
1178     // internal
1179     function _baseURI() internal view virtual returns (string memory) {
1180         return baseURI;
1181     }
1182     // public minting
1183     function mint(uint256 _mintAmount) public payable nonReentrant{
1184         uint256 s = totalSupply();
1185         require(status, "Off" );
1186         require(_mintAmount > 0, "Duh" );
1187         require(_mintAmount <= maxMint, "Too many" );
1188         require(s + _mintAmount < maxSupply, "Sorry" );
1189         require(msg.value >= cost * _mintAmount);
1190         for (uint256 i = 0; i < _mintAmount; ++i) {
1191             _safeMint(msg.sender, s + i, "");
1192         }
1193         delete s;
1194     }
1195 
1196     // admin minting
1197     function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1198         require(quantity.length == recipient.length, "Provide quantities and recipients" );
1199         uint totalQuantity = 0;
1200         uint256 s = totalSupply();
1201         for(uint i = 0; i < quantity.length; ++i){
1202             totalQuantity += quantity[i];
1203         }
1204         require( s + totalQuantity <= maxSupply, "Too many" );
1205         delete totalQuantity;
1206         for(uint i = 0; i < recipient.length; ++i){
1207             for(uint j = 0; j < quantity[i]; ++j){
1208                 _safeMint( recipient[i], s++, "" );
1209             }
1210         }
1211         delete s;
1212     }
1213 
1214     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1215         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1216         string memory currentBaseURI = _baseURI();
1217         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), '.json')) : "";
1218     }
1219     function setCost(uint256 _newCost) public onlyOwner {
1220         cost = _newCost;
1221     }
1222     function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1223         maxMint = _newMaxMintAmount;
1224     }
1225     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1226         maxSupply = _newMaxSupply;
1227     }
1228     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1229         baseURI = _newBaseURI;
1230     }
1231     function setSaleStatus(bool _status) public onlyOwner {
1232         status = _status;
1233     }
1234     function withdraw() public onlyOwner {
1235         uint balance = address(this).balance;
1236         payable(msg.sender).transfer(balance);
1237     }
1238 
1239     function isClaimed (uint256 id) public view returns (bool) {
1240         return _claimedParents[id];
1241     }
1242 
1243     function claimByIds(uint256[] memory ids) public {
1244         require(status, "Claiming is not active at the moment");
1245         require(ids.length % requiredParentTokensForClaim == 0, "You require 3 tokens in order to claim a Mummy");
1246         for (uint256  i = 0; i < ids.length; i++) {
1247             address owner = parentContractInterface.ownerOf(ids[i]);
1248             require(owner == msg.sender, "You do not own the token with the provided id");
1249             require(!isClaimed(ids[i]), "The token has been already claimed");
1250         }
1251 
1252         for (uint256  i = 0; i < ids.length; i = i + requiredParentTokensForClaim) {
1253             _safeMint(msg.sender, totalSupply());
1254             _claimedParents[ids[i]] = true;
1255             _claimedParents[ids[i + 1]] = true;
1256             _claimedParents[ids[i + 2]] = true;
1257         }
1258     }
1259 
1260 }
1261 
1262 contract ParentContractInterface {
1263     function balanceOf(address owner) public returns (uint256) {}
1264     function ownerOf(uint256 tokenId) public returns (address) {}
1265     function tokenOfOwnerByIndex(address owner, uint256 index) public returns(uint256) {}
1266 }