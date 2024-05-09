1 pragma solidity ^0.8.0;
2 
3 interface IERC165 {
4     function supportsInterface(bytes4 interfaceId) external view returns (bool);
5 }
6 
7 pragma solidity ^0.8.0;
8 
9 interface IERC721 is IERC165 {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11 
12     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
13 
14     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
15 
16     function balanceOf(address owner) external view returns (uint256 balance);
17 
18     function ownerOf(uint256 tokenId) external view returns (address owner);
19 
20     function safeTransferFrom(address from, address to, uint256 tokenId) external;
21 
22     function transferFrom(address from, address to, uint256 tokenId) external;
23 
24     function approve(address to, uint256 tokenId) external;
25 
26     function getApproved(uint256 tokenId) external view returns (address operator);
27 
28     function setApprovalForAll(address operator, bool _approved) external;
29 
30     function isApprovedForAll(address owner, address operator) external view returns (bool);
31 
32     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
33 }
34 
35 pragma solidity ^0.8.0;
36 
37 interface IERC721Receiver {
38     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
39 }
40 
41 pragma solidity ^0.8.0;
42 
43 
44 interface IERC721Metadata is IERC721 {
45 
46     /**
47      * @dev Returns the token collection name.
48      */
49     function name() external view returns (string memory);
50 
51     /**
52      * @dev Returns the token collection symbol.
53      */
54     function symbol() external view returns (string memory);
55 
56     /**
57      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
58      */
59     function tokenURI(uint256 tokenId) external view returns (string memory);
60 }
61 
62 // File: @openzeppelin/contracts/utils/Address.sol
63 
64 
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Collection of functions related to the address type
70  */
71 library Address {
72     /**
73      * @dev Returns true if `account` is a contract.
74      *
75      * [IMPORTANT]
76      * ====
77      * It is unsafe to assume that an address for which this function returns
78      * false is an externally-owned account (EOA) and not a contract.
79      *
80      * Among others, `isContract` will return false for the following
81      * types of addresses:
82      *
83      *  - an externally-owned account
84      *  - a contract in construction
85      *  - an address where a contract will be created
86      *  - an address where a contract lived, but was destroyed
87      * ====
88      */
89     function isContract(address account) internal view returns (bool) {
90         // This method relies on extcodesize, which returns 0 for contracts in
91         // construction, since the code is only stored at the end of the
92         // constructor execution.
93 
94         uint256 size;
95         // solhint-disable-next-line no-inline-assembly
96         assembly { size := extcodesize(account) }
97         return size > 0;
98     }
99 
100     /**
101      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
102      * `recipient`, forwarding all available gas and reverting on errors.
103      *
104      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
105      * of certain opcodes, possibly making contracts go over the 2300 gas limit
106      * imposed by `transfer`, making them unable to receive funds via
107      * `transfer`. {sendValue} removes this limitation.
108      *
109      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
110      *
111      * IMPORTANT: because control is transferred to `recipient`, care must be
112      * taken to not create reentrancy vulnerabilities. Consider using
113      * {ReentrancyGuard} or the
114      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
115      */
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
120         (bool success, ) = recipient.call{ value: amount }("");
121         require(success, "Address: unable to send value, recipient may have reverted");
122     }
123 
124     /**
125      * @dev Performs a Solidity function call using a low level `call`. A
126      * plain`call` is an unsafe replacement for a function call: use this
127      * function instead.
128      *
129      * If `target` reverts with a revert reason, it is bubbled up by this
130      * function (like regular Solidity function calls).
131      *
132      * Returns the raw returned data. To convert to the expected return value,
133      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
134      *
135      * Requirements:
136      *
137      * - `target` must be a contract.
138      * - calling `target` with `data` must not revert.
139      *
140      * _Available since v3.1._
141      */
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143       return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
148      * `errorMessage` as a fallback revert reason when `target` reverts.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
153         return functionCallWithValue(target, data, 0, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but also transferring `value` wei to `target`.
159      *
160      * Requirements:
161      *
162      * - the calling contract must have an ETH balance of at least `value`.
163      * - the called Solidity function must be `payable`.
164      *
165      * _Available since v3.1._
166      */
167     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
173      * with `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
178         require(address(this).balance >= value, "Address: insufficient balance for call");
179         require(isContract(target), "Address: call to non-contract");
180 
181         // solhint-disable-next-line avoid-low-level-calls
182         (bool success, bytes memory returndata) = target.call{ value: value }(data);
183         return _verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
193         return functionStaticCall(target, data, "Address: low-level static call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
198      * but performing a static call.
199      *
200      * _Available since v3.3._
201      */
202     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
203         require(isContract(target), "Address: static call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.staticcall(data);
207         return _verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a delegate call.
213      *
214      * _Available since v3.4._
215      */
216     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
217         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a delegate call.
223      *
224      * _Available since v3.4._
225      */
226     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
227         require(isContract(target), "Address: delegate call to non-contract");
228 
229         // solhint-disable-next-line avoid-low-level-calls
230         (bool success, bytes memory returndata) = target.delegatecall(data);
231         return _verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241 
242                 // solhint-disable-next-line no-inline-assembly
243                 assembly {
244                     let returndata_size := mload(returndata)
245                     revert(add(32, returndata), returndata_size)
246                 }
247             } else {
248                 revert(errorMessage);
249             }
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Context.sol
255 
256 
257 
258 pragma solidity ^0.8.0;
259 
260 /*
261  * @dev Provides information about the current execution context, including the
262  * sender of the transaction and its data. While these are generally available
263  * via msg.sender and msg.data, they should not be accessed in such a direct
264  * manner, since when dealing with meta-transactions the account sending and
265  * paying for execution may not be the actual sender (as far as an application
266  * is concerned).
267  *
268  * This contract is only required for intermediate, library-like contracts.
269  */
270 abstract contract Context {
271     function _msgSender() internal view virtual returns (address) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal view virtual returns (bytes calldata) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/utils/Strings.sol
282 
283 
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev String operations.
289  */
290 library Strings {
291     bytes16 private constant alphabet = "0123456789abcdef";
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
295      */
296     function toString(uint256 value) internal pure returns (string memory) {
297         // Inspired by OraclizeAPI's implementation - MIT licence
298         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
299 
300         if (value == 0) {
301             return "0";
302         }
303         uint256 temp = value;
304         uint256 digits;
305         while (temp != 0) {
306             digits++;
307             temp /= 10;
308         }
309         bytes memory buffer = new bytes(digits);
310         while (value != 0) {
311             digits -= 1;
312             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
313             value /= 10;
314         }
315         return string(buffer);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
320      */
321     function toHexString(uint256 value) internal pure returns (string memory) {
322         if (value == 0) {
323             return "0x00";
324         }
325         uint256 temp = value;
326         uint256 length = 0;
327         while (temp != 0) {
328             length++;
329             temp >>= 8;
330         }
331         return toHexString(value, length);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
336      */
337     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
338         bytes memory buffer = new bytes(2 * length + 2);
339         buffer[0] = "0";
340         buffer[1] = "x";
341         for (uint256 i = 2 * length + 1; i > 1; --i) {
342             buffer[i] = alphabet[value & 0xf];
343             value >>= 4;
344         }
345         require(value == 0, "Strings: hex length insufficient");
346         return string(buffer);
347     }
348 
349 }
350 
351 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
352 
353 
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
382 
383 
384 
385 pragma solidity ^0.8.0;
386 
387 
388 
389 
390 
391 
392 
393 
394 /**
395  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
396  * the Metadata extension, but not including the Enumerable extension, which is available separately as
397  * {ERC721Enumerable}.
398  */
399 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
400     using Address for address;
401     using Strings for uint256;
402 
403     // Token name
404     string private _name;
405 
406     // Token symbol
407     string private _symbol;
408 
409     // Mapping from token ID to owner address
410     mapping (uint256 => address) private _owners;
411 
412     // Mapping owner address to token count
413     mapping (address => uint256) private _balances;
414 
415     // Mapping from token ID to approved address
416     mapping (uint256 => address) private _tokenApprovals;
417 
418     // Mapping from owner to operator approvals
419     mapping (address => mapping (address => bool)) private _operatorApprovals;
420 
421     /**
422      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
423      */
424     constructor (string memory name_, string memory symbol_) {
425         _name = name_;
426         _symbol = symbol_;
427     }
428 
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
433         return interfaceId == type(IERC721).interfaceId
434             || interfaceId == type(IERC721Metadata).interfaceId
435             || super.supportsInterface(interfaceId);
436     }
437 
438     /**
439      * @dev See {IERC721-balanceOf}.
440      */
441     function balanceOf(address owner) public view virtual override returns (uint256) {
442         require(owner != address(0), "ERC721: balance query for the zero address");
443         return _balances[owner];
444     }
445 
446     /**
447      * @dev See {IERC721-ownerOf}.
448      */
449     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
450         address owner = _owners[tokenId];
451         require(owner != address(0), "ERC721: owner query for nonexistent token");
452         return owner;
453     }
454 
455     /**
456      * @dev See {IERC721Metadata-name}.
457      */
458     function name() public view virtual override returns (string memory) {
459         return _name;
460     }
461 
462     /**
463      * @dev See {IERC721Metadata-symbol}.
464      */
465     function symbol() public view virtual override returns (string memory) {
466         return _symbol;
467     }
468 
469     /**
470      * @dev See {IERC721Metadata-tokenURI}.
471      */
472     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
473         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
474 
475         string memory baseURI = _baseURI();
476         return bytes(baseURI).length > 0
477             ? string(abi.encodePacked(baseURI, tokenId.toString()))
478             : '';
479     }
480 
481     /**
482      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
483      * in child contracts.
484      */
485     function _baseURI() internal view virtual returns (string memory) {
486         return "";
487     }
488 
489     /**
490      * @dev See {IERC721-approve}.
491      */
492     function approve(address to, uint256 tokenId) public virtual override {
493         address owner = ERC721.ownerOf(tokenId);
494         require(to != owner, "ERC721: approval to current owner");
495 
496         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
497             "ERC721: approve caller is not owner nor approved for all"
498         );
499 
500         _approve(to, tokenId);
501     }
502 
503     /**
504      * @dev See {IERC721-getApproved}.
505      */
506     function getApproved(uint256 tokenId) public view virtual override returns (address) {
507         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
508 
509         return _tokenApprovals[tokenId];
510     }
511 
512     /**
513      * @dev See {IERC721-setApprovalForAll}.
514      */
515     function setApprovalForAll(address operator, bool approved) public virtual override {
516         require(operator != _msgSender(), "ERC721: approve to caller");
517 
518         _operatorApprovals[_msgSender()][operator] = approved;
519         emit ApprovalForAll(_msgSender(), operator, approved);
520     }
521 
522     /**
523      * @dev See {IERC721-isApprovedForAll}.
524      */
525     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
526         return _operatorApprovals[owner][operator];
527     }
528 
529     /**
530      * @dev See {IERC721-transferFrom}.
531      */
532     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
533         //solhint-disable-next-line max-line-length
534         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
535 
536         _transfer(from, to, tokenId);
537     }
538 
539     /**
540      * @dev See {IERC721-safeTransferFrom}.
541      */
542     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
543         safeTransferFrom(from, to, tokenId, "");
544     }
545 
546     /**
547      * @dev See {IERC721-safeTransferFrom}.
548      */
549     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
550         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
551         _safeTransfer(from, to, tokenId, _data);
552     }
553 
554     /**
555      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
556      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
557      *
558      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
559      *
560      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
561      * implement alternative mechanisms to perform token transfer, such as signature-based.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
573         _transfer(from, to, tokenId);
574         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
575     }
576 
577     /**
578      * @dev Returns whether `tokenId` exists.
579      *
580      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
581      *
582      * Tokens start existing when they are minted (`_mint`),
583      * and stop existing when they are burned (`_burn`).
584      */
585     function _exists(uint256 tokenId) internal view virtual returns (bool) {
586         return _owners[tokenId] != address(0);
587     }
588 
589     /**
590      * @dev Returns whether `spender` is allowed to manage `tokenId`.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
597         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
598         address owner = ERC721.ownerOf(tokenId);
599         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
600     }
601 
602     /**
603      * @dev Safely mints `tokenId` and transfers it to `to`.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must not exist.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function _safeMint(address to, uint256 tokenId) internal virtual {
613         _safeMint(to, tokenId, "");
614     }
615 
616     /**
617      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
618      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
619      */
620     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
621         _mint(to, tokenId);
622         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
623     }
624 
625     /**
626      * @dev Mints `tokenId` and transfers it to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
629      *
630      * Requirements:
631      *
632      * - `tokenId` must not exist.
633      * - `to` cannot be the zero address.
634      *
635      * Emits a {Transfer} event.
636      */
637     function _mint(address to, uint256 tokenId) internal virtual {
638         require(to != address(0), "ERC721: mint to the zero address");
639         require(!_exists(tokenId), "ERC721: token already minted");
640 
641         _beforeTokenTransfer(address(0), to, tokenId);
642 
643         _balances[to] += 1;
644         _owners[tokenId] = to;
645 
646         emit Transfer(address(0), to, tokenId);
647     }
648 
649     /**
650      * @dev Destroys `tokenId`.
651      * The approval is cleared when the token is burned.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      *
657      * Emits a {Transfer} event.
658      */
659     function _burn(uint256 tokenId) internal virtual {
660         address owner = ERC721.ownerOf(tokenId);
661 
662         _beforeTokenTransfer(owner, address(0), tokenId);
663 
664         // Clear approvals
665         _approve(address(0), tokenId);
666 
667         _balances[owner] -= 1;
668         delete _owners[tokenId];
669 
670         emit Transfer(owner, address(0), tokenId);
671     }
672 
673     /**
674      * @dev Transfers `tokenId` from `from` to `to`.
675      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must be owned by `from`.
681      *
682      * Emits a {Transfer} event.
683      */
684     function _transfer(address from, address to, uint256 tokenId) internal virtual {
685         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
686         require(to != address(0), "ERC721: transfer to the zero address");
687 
688         _beforeTokenTransfer(from, to, tokenId);
689 
690         // Clear approvals from the previous owner
691         _approve(address(0), tokenId);
692 
693         _balances[from] -= 1;
694         _balances[to] += 1;
695         _owners[tokenId] = to;
696 
697         emit Transfer(from, to, tokenId);
698     }
699 
700     /**
701      * @dev Approve `to` to operate on `tokenId`
702      *
703      * Emits a {Approval} event.
704      */
705     function _approve(address to, uint256 tokenId) internal virtual {
706         _tokenApprovals[tokenId] = to;
707         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
708     }
709 
710     /**
711      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
712      * The call is not executed if the target address is not a contract.
713      *
714      * @param from address representing the previous owner of the given token ID
715      * @param to target address that will receive the tokens
716      * @param tokenId uint256 ID of the token to be transferred
717      * @param _data bytes optional data to send along with the call
718      * @return bool whether the call correctly returned the expected magic value
719      */
720     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
721         private returns (bool)
722     {
723         if (to.isContract()) {
724             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
725                 return retval == IERC721Receiver(to).onERC721Received.selector;
726             } catch (bytes memory reason) {
727                 if (reason.length == 0) {
728                     revert("ERC721: transfer to non ERC721Receiver implementer");
729                 } else {
730                     // solhint-disable-next-line no-inline-assembly
731                     assembly {
732                         revert(add(32, reason), mload(reason))
733                     }
734                 }
735             }
736         } else {
737             return true;
738         }
739     }
740 
741     /**
742      * @dev Hook that is called before any token transfer. This includes minting
743      * and burning.
744      *
745      * Calling conditions:
746      *
747      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
748      * transferred to `to`.
749      * - When `from` is zero, `tokenId` will be minted for `to`.
750      * - When `to` is zero, ``from``'s `tokenId` will be burned.
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      *
754      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
755      */
756     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
760 
761 
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
768  * @dev See https://eips.ethereum.org/EIPS/eip-721
769  */
770 interface IERC721Enumerable is IERC721 {
771 
772     /**
773      * @dev Returns the total amount of tokens stored by the contract.
774      */
775     function totalSupply() external view returns (uint256);
776 
777     /**
778      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
779      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
782 
783     /**
784      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
785      * Use along with {totalSupply} to enumerate all tokens.
786      */
787     function tokenByIndex(uint256 index) external view returns (uint256);
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
791 
792 
793 
794 pragma solidity ^0.8.0;
795 
796 
797 
798 /**
799  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
800  * enumerability of all the token ids in the contract as well as all token ids owned by each
801  * account.
802  */
803 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
804     // Mapping from owner to list of owned token IDs
805     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
806 
807     // Mapping from token ID to index of the owner tokens list
808     mapping(uint256 => uint256) private _ownedTokensIndex;
809 
810     // Array with all token ids, used for enumeration
811     uint256[] private _allTokens;
812 
813     // Mapping from token id to position in the allTokens array
814     mapping(uint256 => uint256) private _allTokensIndex;
815 
816     /**
817      * @dev See {IERC165-supportsInterface}.
818      */
819     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
820         return interfaceId == type(IERC721Enumerable).interfaceId
821             || super.supportsInterface(interfaceId);
822     }
823 
824     /**
825      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
826      */
827     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
828         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
829         return _ownedTokens[owner][index];
830     }
831 
832     /**
833      * @dev See {IERC721Enumerable-totalSupply}.
834      */
835     function totalSupply() public view virtual override returns (uint256) {
836         return _allTokens.length;
837     }
838 
839     /**
840      * @dev See {IERC721Enumerable-tokenByIndex}.
841      */
842     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
843         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
844         return _allTokens[index];
845     }
846 
847     /**
848      * @dev Hook that is called before any token transfer. This includes minting
849      * and burning.
850      *
851      * Calling conditions:
852      *
853      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
854      * transferred to `to`.
855      * - When `from` is zero, `tokenId` will be minted for `to`.
856      * - When `to` is zero, ``from``'s `tokenId` will be burned.
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      *
860      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
861      */
862     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
863         super._beforeTokenTransfer(from, to, tokenId);
864 
865         if (from == address(0)) {
866             _addTokenToAllTokensEnumeration(tokenId);
867         } else if (from != to) {
868             _removeTokenFromOwnerEnumeration(from, tokenId);
869         }
870         if (to == address(0)) {
871             _removeTokenFromAllTokensEnumeration(tokenId);
872         } else if (to != from) {
873             _addTokenToOwnerEnumeration(to, tokenId);
874         }
875     }
876 
877     /**
878      * @dev Private function to add a token to this extension's ownership-tracking data structures.
879      * @param to address representing the new owner of the given token ID
880      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
881      */
882     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
883         uint256 length = ERC721.balanceOf(to);
884         _ownedTokens[to][length] = tokenId;
885         _ownedTokensIndex[tokenId] = length;
886     }
887 
888     /**
889      * @dev Private function to add a token to this extension's token tracking data structures.
890      * @param tokenId uint256 ID of the token to be added to the tokens list
891      */
892     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
893         _allTokensIndex[tokenId] = _allTokens.length;
894         _allTokens.push(tokenId);
895     }
896 
897     /**
898      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
899      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
900      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
901      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
902      * @param from address representing the previous owner of the given token ID
903      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
904      */
905     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
906         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
907         // then delete the last slot (swap and pop).
908 
909         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
910         uint256 tokenIndex = _ownedTokensIndex[tokenId];
911 
912         // When the token to delete is the last token, the swap operation is unnecessary
913         if (tokenIndex != lastTokenIndex) {
914             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
915 
916             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
917             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
918         }
919 
920         // This also deletes the contents at the last position of the array
921         delete _ownedTokensIndex[tokenId];
922         delete _ownedTokens[from][lastTokenIndex];
923     }
924 
925     /**
926      * @dev Private function to remove a token from this extension's token tracking data structures.
927      * This has O(1) time complexity, but alters the order of the _allTokens array.
928      * @param tokenId uint256 ID of the token to be removed from the tokens list
929      */
930     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
931         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
932         // then delete the last slot (swap and pop).
933 
934         uint256 lastTokenIndex = _allTokens.length - 1;
935         uint256 tokenIndex = _allTokensIndex[tokenId];
936 
937         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
938         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
939         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
940         uint256 lastTokenId = _allTokens[lastTokenIndex];
941 
942         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
943         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
944 
945         // This also deletes the contents at the last position of the array
946         delete _allTokensIndex[tokenId];
947         _allTokens.pop();
948     }
949 }
950 
951 // File: @openzeppelin/contracts/access/Ownable.sol
952 
953 
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @dev Contract module which provides a basic access control mechanism, where
959  * there is an account (an owner) that can be granted exclusive access to
960  * specific functions.
961  *
962  * By default, the owner account will be the one that deploys the contract. This
963  * can later be changed with {transferOwnership}.
964  *
965  * This module is used through inheritance. It will make available the modifier
966  * `onlyOwner`, which can be applied to your functions to restrict their use to
967  * the owner.
968  */
969 abstract contract Ownable is Context {
970     address private _owner;
971 
972     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
973 
974     /**
975      * @dev Initializes the contract setting the deployer as the initial owner.
976      */
977     constructor () {
978         address msgSender = _msgSender();
979         _owner = msgSender;
980         emit OwnershipTransferred(address(0), msgSender);
981     }
982 
983     /**
984      * @dev Returns the address of the current owner.
985      */
986     function owner() public view virtual returns (address) {
987         return _owner;
988     }
989 
990     /**
991      * @dev Throws if called by any account other than the owner.
992      */
993     modifier onlyOwner() {
994         require(owner() == _msgSender(), "Ownable: caller is not the owner");
995         _;
996     }
997 
998     /**
999      * @dev Leaves the contract without owner. It will not be possible to call
1000      * `onlyOwner` functions anymore. Can only be called by the current owner.
1001      *
1002      * NOTE: Renouncing ownership will leave the contract without an owner,
1003      * thereby removing any functionality that is only available to the owner.
1004      */
1005     function renounceOwnership() public virtual onlyOwner {
1006         emit OwnershipTransferred(_owner, address(0));
1007         _owner = address(0);
1008     }
1009 
1010     /**
1011      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1012      * Can only be called by the current owner.
1013      */
1014     function transferOwnership(address newOwner) public virtual onlyOwner {
1015         require(newOwner != address(0), "Ownable: new owner is the zero address");
1016         emit OwnershipTransferred(_owner, newOwner);
1017         _owner = newOwner;
1018     }
1019 }
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 abstract contract CATS {
1024   function ownerOf(uint256 tokenId) public virtual view returns (address);
1025   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1026   function balanceOf(address owner) external virtual view returns (uint256 balance);
1027 }
1028 
1029 abstract contract APES {
1030   function ownerOf(uint256 tokenId) public virtual view returns (address);
1031   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1032   function balanceOf(address owner) external virtual view returns (uint256 balance);
1033 }
1034 
1035 abstract contract ALIEN {
1036   function ownerOf(uint256 tokenId) public virtual view returns (address);
1037   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1038   function balanceOf(address owner) external virtual view returns (uint256 balance);
1039 }
1040 
1041 contract FunnyLookingStrangers is ERC721Enumerable, Ownable {
1042   CATS private cats;
1043   APES private apes;
1044   ALIEN private alien;
1045 
1046   uint256 public saleIsActive;
1047   uint256 public preSaleIsActive;
1048   uint256 public prePreSaleIsActive;
1049   uint256 public maxStrangers;
1050   uint256 public maxPrePreSaleStrangers;
1051   uint256 public maxPreSaleStrangers;
1052   string private baseURI;
1053   address public catsAdress;
1054   address public apesAdress;
1055   address public alienAdress;
1056   uint256 public reservedCounter;
1057   uint256 public maxReserved;
1058   uint256 public strangerPrice;
1059   uint256 public preSaleCounter;
1060   uint256 public prePreSaleCounter;
1061   address[] public whitelist;
1062   mapping(address => bool) senderAllowed;
1063 
1064   constructor() ERC721("Funny Looking Strangers", "FLS") { 
1065     catsAdress = 0x568a1f8554Edcea5CB5F94E463ac69A9C49c0A2d;
1066     apesAdress = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
1067     alienAdress = 0x4581649aF66BCCAeE81eebaE3DDc0511FE4C5312;
1068     maxStrangers = 10555;
1069     cats = CATS(catsAdress);
1070     apes = APES(apesAdress);
1071     alien = ALIEN(alienAdress);
1072     saleIsActive = 0;
1073     preSaleIsActive = 0;
1074     prePreSaleIsActive = 0;
1075     reservedCounter = 1;
1076     maxReserved = 255;
1077     strangerPrice = 55500000000000000;
1078     preSaleCounter = 0;
1079     prePreSaleCounter = 0;
1080     baseURI = "https://funnylookingstrangers.com/json/stranger";
1081   }
1082 
1083   function isMinted(uint256 tokenId) external view returns (bool) {
1084     require(tokenId < maxStrangers, "tokenId outside collection bounds");
1085 
1086     return _exists(tokenId);
1087   }
1088 
1089   function _baseURI() internal view override returns (string memory) {
1090     return baseURI;
1091   }
1092 
1093   function setBaseURI(string memory uri) public onlyOwner {
1094     baseURI = uri;
1095   }
1096 
1097   function mintReservedStranger(uint256 numberOfTokens) public onlyOwner {
1098     require(numberOfTokens <= maxReserved, "Can only mint 255 strangers at a time");
1099     require((reservedCounter + numberOfTokens) <= maxReserved, "Purchase would exceed max supply of Strangers");
1100 
1101     for(uint i = 0; i < numberOfTokens; i++) {
1102       _safeMint(msg.sender, reservedCounter);
1103       
1104       reservedCounter = reservedCounter + 1;
1105     }
1106   }
1107 
1108   function mintStranger(uint256 numberOfTokens) public payable {
1109     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1110     require(saleIsActive == 1, "Sale must be active to mint a stranger");
1111     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1112     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1113 
1114     for(uint i = 0; i < numberOfTokens; i++) {
1115             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1116             mintIndex = mintIndex + 256;
1117             if (totalSupply() < maxStrangers) {
1118                 while(_exists(mintIndex)) {
1119                     if(mintIndex > 10555){
1120                         mintIndex = 255;
1121                     }
1122                     mintIndex = mintIndex + 1;
1123                 }
1124                 _safeMint(msg.sender, mintIndex);
1125                 
1126             }
1127         }
1128   }
1129 
1130     function mintStrangerPrePreSale(uint256 numberOfTokens) public payable {
1131     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1132     require(prePreSaleIsActive == 1, "Sale must be active to mint a stranger");
1133     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1134     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1135     require(senderAllowed[msg.sender], "sender is not on the whitelist");
1136     require((prePreSaleCounter + numberOfTokens) <= 1300, "Pre pre sale ended!");
1137 
1138     for(uint i = 0; i < numberOfTokens; i++) {
1139             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1140             mintIndex = mintIndex + 256;
1141             if (totalSupply() < maxStrangers) {
1142                 while(_exists(mintIndex)) {
1143                     if(mintIndex > 10555){
1144                         mintIndex = 255;
1145                     }
1146                     mintIndex = mintIndex + 1;
1147                 }
1148                 _safeMint(msg.sender, mintIndex);
1149                 
1150                 prePreSaleCounter = prePreSaleCounter + 1;
1151             }
1152         }
1153   }
1154 
1155   function mintStrangerPreSale(uint256 numberOfTokens) public payable {
1156     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1157     require(preSaleIsActive == 1, "Sale must be active to mint a stranger");
1158     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1159     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1160     require(senderAllowed[msg.sender], "sender is not on the whitelist");
1161     require((preSaleCounter + numberOfTokens) <= 5500, "Pre sale ended!");
1162 
1163     for(uint i = 0; i < numberOfTokens; i++) {
1164             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1165             mintIndex = mintIndex + 256;
1166             if (totalSupply() < maxStrangers) {
1167                 while(_exists(mintIndex)) {
1168                     if(mintIndex > 10555){
1169                         mintIndex = 255;
1170                     }
1171                     mintIndex = mintIndex + 1;
1172                 }
1173                 _safeMint(msg.sender, mintIndex);
1174                 
1175                 preSaleCounter = preSaleCounter + 1;
1176             }
1177         }
1178   }
1179 
1180   function mintStrangerPreSaleCats(uint256 numberOfTokens, uint256 id) public payable {
1181     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1182     require(preSaleIsActive == 1, "Sale must be active to mint a stranger");
1183     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1184     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1185     require(cats.ownerOf(id) == msg.sender, "Must own a Cat to mint a stranger");
1186     require((preSaleCounter + numberOfTokens) <= 5500, "Pre sale ended!");
1187 
1188     for(uint i = 0; i < numberOfTokens; i++) {
1189             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1190             mintIndex = mintIndex + 256;
1191             if (totalSupply() < maxStrangers) {
1192                 while(_exists(mintIndex)) {
1193                     if(mintIndex > 10555){
1194                         mintIndex = 255;
1195                     }
1196                     mintIndex = mintIndex + 1;
1197                 }
1198                 _safeMint(msg.sender, mintIndex);
1199                 
1200                 preSaleCounter = preSaleCounter + 1;
1201             }
1202         }
1203   }
1204   function mintStrangerPreSaleApes(uint256 numberOfTokens, uint256 id) public payable {
1205     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1206     require(preSaleIsActive == 1, "Sale must be active to mint a stranger");
1207     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1208     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1209     require(apes.ownerOf(id) == msg.sender, "Must own an ape to mint a stranger");
1210     require((preSaleCounter + numberOfTokens) <= 5500, "Pre sale ended!");
1211 
1212     for(uint i = 0; i < numberOfTokens; i++) {
1213             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1214             mintIndex = mintIndex + 256;
1215             if (totalSupply() < maxStrangers) {
1216                 while(_exists(mintIndex)) {
1217                     if(mintIndex > 10555){
1218                         mintIndex = 255;
1219                     }
1220                     mintIndex = mintIndex + 1;
1221                 }
1222                 _safeMint(msg.sender, mintIndex);
1223                 
1224                 preSaleCounter = preSaleCounter + 1;
1225             }
1226         }
1227   }
1228   function mintStrangerPreSaleAlien(uint256 numberOfTokens, uint256 id) public payable {
1229     require(numberOfTokens <= maxStrangers, "Can only mint 15 strangers at a time");
1230     require(preSaleIsActive == 1, "Sale must be active to mint a stranger");
1231     require((totalSupply() + numberOfTokens) <= maxStrangers, "Purchase would exceed max supply of Strangers");
1232     require((strangerPrice * numberOfTokens) <= msg.value, "Too little ETH send");
1233     require(alien.ownerOf(id) == msg.sender, "Must own an alienboy to mint a stranger");
1234     require((preSaleCounter + numberOfTokens) <= 5500, "Pre sale ended!");
1235 
1236     for(uint i = 0; i < numberOfTokens; i++) {
1237             uint mintIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10299;
1238             mintIndex = mintIndex + 256;
1239             if (totalSupply() < maxStrangers) {
1240                 while(_exists(mintIndex)) {
1241                     if(mintIndex > 10555){
1242                         mintIndex = 255;
1243                     }
1244                     mintIndex = mintIndex + 1;
1245                 }
1246                 _safeMint(msg.sender, mintIndex);
1247                 preSaleCounter = preSaleCounter + 1;
1248             }
1249         }
1250   }
1251 
1252     function flipSale(uint256 _saleState) public onlyOwner {
1253       saleIsActive = _saleState;
1254   }
1255     function flipPreSale(uint256 _saleState) public onlyOwner {
1256       preSaleIsActive = _saleState;
1257   }
1258     function flipPrePreSale(uint256 _saleState) public onlyOwner {
1259       prePreSaleIsActive = _saleState;
1260   }
1261 
1262     function withdraw() public payable onlyOwner{
1263         uint balance = address(this).balance;
1264         payable(msg.sender).transfer(balance);
1265     }
1266     function setPrice(uint256 _newprice) public onlyOwner{
1267         require(_newprice >= 10000000000000000, "The price cannot be lower then 0.01 eth");
1268         strangerPrice = _newprice;
1269     }
1270     function addWhitelist(address whitelistAddress) public onlyOwner {
1271       whitelist.push(whitelistAddress);
1272       senderAllowed[whitelistAddress] = true;
1273     }
1274 
1275   function burnStranger(uint256 id) public onlyOwner {
1276       _safeMint(0x0000000000000000000000000000000000000000, id);
1277       
1278   }    
1279 }