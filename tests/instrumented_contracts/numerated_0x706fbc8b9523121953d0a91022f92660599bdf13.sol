1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _setOwner(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _setOwner(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 library Strings {
70     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
74      */
75     function toString(uint256 value) internal pure returns (string memory) {
76         // Inspired by OraclizeAPI's implementation - MIT licence
77         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
78 
79         if (value == 0) {
80             return "0";
81         }
82         uint256 temp = value;
83         uint256 digits;
84         while (temp != 0) {
85             digits++;
86             temp /= 10;
87         }
88         bytes memory buffer = new bytes(digits);
89         while (value != 0) {
90             digits -= 1;
91             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
92             value /= 10;
93         }
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
99      */
100     function toHexString(uint256 value) internal pure returns (string memory) {
101         if (value == 0) {
102             return "0x00";
103         }
104         uint256 temp = value;
105         uint256 length = 0;
106         while (temp != 0) {
107             length++;
108             temp >>= 8;
109         }
110         return toHexString(value, length);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
115      */
116     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
117         bytes memory buffer = new bytes(2 * length + 2);
118         buffer[0] = "0";
119         buffer[1] = "x";
120         for (uint256 i = 2 * length + 1; i > 1; --i) {
121             buffer[i] = _HEX_SYMBOLS[value & 0xf];
122             value >>= 4;
123         }
124         require(value == 0, "Strings: hex length insufficient");
125         return string(buffer);
126     }
127 }
128 
129 abstract contract ReentrancyGuard {
130     // Booleans are more expensive than uint256 or any type that takes up a full
131     // word because each write operation emits an extra SLOAD to first read the
132     // slot's contents, replace the bits taken up by the boolean, and then write
133     // back. This is the compiler's defense against contract upgrades and
134     // pointer aliasing, and it cannot be disabled.
135 
136     // The values being non-zero value makes deployment a bit more expensive,
137     // but in exchange the refund on every call to nonReentrant will be lower in
138     // amount. Since refunds are capped to a percentage of the total
139     // transaction's gas, it is best to keep them low in cases like this one, to
140     // increase the likelihood of the full refund coming into effect.
141     uint256 private constant _NOT_ENTERED = 1;
142     uint256 private constant _ENTERED = 2;
143 
144     uint256 private _status;
145 
146     constructor() {
147         _status = _NOT_ENTERED;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and make it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         // On the first call to nonReentrant, _notEntered will be true
159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161         // Any calls to nonReentrant after this point will fail
162         _status = _ENTERED;
163 
164         _;
165 
166         // By storing the original value once again, a refund is triggered (see
167         // https://eips.ethereum.org/EIPS/eip-2200)
168         _status = _NOT_ENTERED;
169     }
170 }
171 
172 interface IERC165 {
173     /**
174      * @dev Returns true if this contract implements the interface defined by
175      * `interfaceId`. See the corresponding
176      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
177      * to learn more about how these ids are created.
178      *
179      * This function call must use less than 30 000 gas.
180      */
181     function supportsInterface(bytes4 interfaceId) external view returns (bool);
182 }
183 
184 interface IERC721 is IERC165 {
185     /**
186      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
189 
190     /**
191      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
192      */
193     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
197      */
198     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
199 
200     /**
201      * @dev Returns the number of tokens in ``owner``'s account.
202      */
203     function balanceOf(address owner) external view returns (uint256 balance);
204 
205     /**
206      * @dev Returns the owner of the `tokenId` token.
207      *
208      * Requirements:
209      *
210      * - `tokenId` must exist.
211      */
212     function ownerOf(uint256 tokenId) external view returns (address owner);
213 
214     /**
215      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
216      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
217      *
218      * Requirements:
219      *
220      * - `from` cannot be the zero address.
221      * - `to` cannot be the zero address.
222      * - `tokenId` token must exist and be owned by `from`.
223      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
225      *
226      * Emits a {Transfer} event.
227      */
228     function safeTransferFrom(
229         address from,
230         address to,
231         uint256 tokenId
232     ) external;
233 
234     /**
235      * @dev Transfers `tokenId` token from `from` to `to`.
236      *
237      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must be owned by `from`.
244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
256      * The approval is cleared when the token is transferred.
257      *
258      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
259      *
260      * Requirements:
261      *
262      * - The caller must own the token or be an approved operator.
263      * - `tokenId` must exist.
264      *
265      * Emits an {Approval} event.
266      */
267     function approve(address to, uint256 tokenId) external;
268 
269     /**
270      * @dev Returns the account approved for `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function getApproved(uint256 tokenId) external view returns (address operator);
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
281      *
282      * Requirements:
283      *
284      * - The `operator` cannot be the caller.
285      *
286      * Emits an {ApprovalForAll} event.
287      */
288     function setApprovalForAll(address operator, bool _approved) external;
289 
290     /**
291      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
292      *
293      * See {setApprovalForAll}
294      */
295     function isApprovedForAll(address owner, address operator) external view returns (bool);
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must exist and be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId,
314         bytes calldata data
315     ) external;
316 }
317 
318 interface IERC721Enumerable is IERC721 {
319     /**
320      * @dev Returns the total amount of tokens stored by the contract.
321      */
322     function totalSupply() external view returns (uint256);
323 
324     /**
325      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
326      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
327      */
328     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
329 
330     /**
331      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
332      * Use along with {totalSupply} to enumerate all tokens.
333      */
334     function tokenByIndex(uint256 index) external view returns (uint256);
335 }
336 
337 interface IERC721Receiver {
338     /**
339      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
340      * by `operator` from `from`, this function is called.
341      *
342      * It must return its Solidity selector to confirm the token transfer.
343      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
344      *
345      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
346      */
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 interface IERC721Metadata is IERC721 {
356     /**
357      * @dev Returns the token collection name.
358      */
359     function name() external view returns (string memory);
360 
361     /**
362      * @dev Returns the token collection symbol.
363      */
364     function symbol() external view returns (string memory);
365 
366     /**
367      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
368      */
369     function tokenURI(uint256 tokenId) external view returns (string memory);
370 }
371 
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize, which returns 0 for contracts in
392         // construction, since the code is only stored at the end of the
393         // constructor execution.
394 
395         uint256 size;
396         assembly {
397             size := extcodesize(account)
398         }
399         return size > 0;
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(address(this).balance >= amount, "Address: insufficient balance");
420 
421         (bool success, ) = recipient.call{value: amount}("");
422         require(success, "Address: unable to send value, recipient may have reverted");
423     }
424 
425     /**
426      * @dev Performs a Solidity function call using a low level `call`. A
427      * plain `call` is an unsafe replacement for a function call: use this
428      * function instead.
429      *
430      * If `target` reverts with a revert reason, it is bubbled up by this
431      * function (like regular Solidity function calls).
432      *
433      * Returns the raw returned data. To convert to the expected return value,
434      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
435      *
436      * Requirements:
437      *
438      * - `target` must be a contract.
439      * - calling `target` with `data` must not revert.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionCall(target, data, "Address: low-level call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
449      * `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(
473         address target,
474         bytes memory data,
475         uint256 value
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
482      * with `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(address(this).balance >= value, "Address: insufficient balance for call");
493         require(isContract(target), "Address: call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.call{value: value}(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a static call.
502      *
503      * _Available since v3.3._
504      */
505     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
506         return functionStaticCall(target, data, "Address: low-level static call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal view returns (bytes memory) {
520         require(isContract(target), "Address: static call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.staticcall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a delegate call.
529      *
530      * _Available since v3.4._
531      */
532     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
533         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(isContract(target), "Address: delegate call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.delegatecall(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
555      * revert reason using the provided one.
556      *
557      * _Available since v4.3._
558      */
559     function verifyCallResult(
560         bool success,
561         bytes memory returndata,
562         string memory errorMessage
563     ) internal pure returns (bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 assembly {
572                     let returndata_size := mload(returndata)
573                     revert(add(32, returndata), returndata_size)
574                 }
575             } else {
576                 revert(errorMessage);
577             }
578         }
579     }
580 }
581 
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     string private _name;
594     string private _symbol;
595     address[] internal _owners;
596     mapping(uint256 => address) private _tokenApprovals;
597     mapping(address => mapping(address => bool)) private _operatorApprovals;
598     constructor(string memory name_, string memory symbol_) {
599         _name = name_;
600         _symbol = symbol_;
601     }
602     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
603         return
604         interfaceId == type(IERC721).interfaceId ||
605         interfaceId == type(IERC721Metadata).interfaceId ||
606         super.supportsInterface(interfaceId);
607     }
608     function balanceOf(address owner) public view virtual override returns (uint256) {
609         require(owner != address(0), "ERC721: balance query for the zero address");
610         uint count = 0;
611         uint length = _owners.length;
612         for( uint i = 0; i < length; ++i ){
613             if( owner == _owners[i] ){
614                 ++count;
615             }
616         }
617         delete length;
618         return count;
619     }
620 
621 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         address owner = _owners[tokenId];
623         require(owner != address(0), "ERC721: owner query for nonexistent token");
624         return owner;
625     }
626 
627     function name() public view virtual override returns (string memory) {
628         return _name;
629     }
630     function symbol() public view virtual override returns (string memory) {
631         return _symbol;
632     }
633     function approve(address to, uint256 tokenId) public virtual override {
634         address owner = ERC721P.ownerOf(tokenId);
635         require(to != owner, "ERC721: approval to current owner");
636 
637         require(
638             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _approve(to, tokenId);
643     }
644     function getApproved(uint256 tokenId) public view virtual override returns (address) {
645         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
646 
647         return _tokenApprovals[tokenId];
648     }
649     function setApprovalForAll(address operator, bool approved) public virtual override {
650         require(operator != _msgSender(), "ERC721: approve to caller");
651 
652         _operatorApprovals[_msgSender()][operator] = approved;
653         emit ApprovalForAll(_msgSender(), operator, approved);
654     }
655     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
656         return _operatorApprovals[owner][operator];
657     }
658     function transferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) public virtual override {
663         //solhint-disable-next-line max-line-length
664         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
665 
666         _transfer(from, to, tokenId);
667     }
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes memory _data
680     ) public virtual override {
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
682         _safeTransfer(from, to, tokenId, _data);
683     }
684     function _safeTransfer(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes memory _data
689     ) internal virtual {
690         _transfer(from, to, tokenId);
691         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
692     }
693     function _exists(uint256 tokenId) internal view virtual returns (bool) {
694         return tokenId < _owners.length && _owners[tokenId] != address(0);
695     }
696     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
697         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
698         address owner = ERC721P.ownerOf(tokenId);
699         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
700     }
701     function _safeMint(address to, uint256 tokenId) internal virtual {
702         _safeMint(to, tokenId, "");
703     }
704     function _safeMint(
705         address to,
706         uint256 tokenId,
707         bytes memory _data
708     ) internal virtual {
709         _mint(to, tokenId);
710         require(
711             _checkOnERC721Received(address(0), to, tokenId, _data),
712             "ERC721: transfer to non ERC721Receiver implementer"
713         );
714     }
715     function _mint(address to, uint256 tokenId) internal virtual {
716         require(to != address(0), "ERC721: mint to the zero address");
717         require(!_exists(tokenId), "ERC721: token already minted");
718 
719         _beforeTokenTransfer(address(0), to, tokenId);
720         _owners.push(to);
721 
722         emit Transfer(address(0), to, tokenId);
723     }
724     function _burn(uint256 tokenId) internal virtual {
725         address owner = ERC721P.ownerOf(tokenId);
726 
727         _beforeTokenTransfer(owner, address(0), tokenId);
728 
729         // Clear approvals
730         _approve(address(0), tokenId);
731         _owners[tokenId] = address(0);
732 
733         emit Transfer(owner, address(0), tokenId);
734     }
735     function _transfer(
736         address from,
737         address to,
738         uint256 tokenId
739     ) internal virtual {
740         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
741         require(to != address(0), "ERC721: transfer to the zero address");
742 
743         _beforeTokenTransfer(from, to, tokenId);
744 
745         // Clear approvals from the previous owner
746         _approve(address(0), tokenId);
747         _owners[tokenId] = to;
748 
749         emit Transfer(from, to, tokenId);
750     }
751     function _approve(address to, uint256 tokenId) internal virtual {
752         _tokenApprovals[tokenId] = to;
753         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
754     }
755     function _checkOnERC721Received(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) private returns (bool) {
761         if (to.isContract()) {
762             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
763                 return retval == IERC721Receiver.onERC721Received.selector;
764             } catch (bytes memory reason) {
765                 if (reason.length == 0) {
766                     revert("ERC721: transfer to non ERC721Receiver implementer");
767                 } else {
768                     assembly {
769                         revert(add(32, reason), mload(reason))
770                     }
771                 }
772             }
773         } else {
774             return true;
775         }
776     }
777     function _beforeTokenTransfer(
778         address from,
779         address to,
780         uint256 tokenId
781     ) internal virtual {}
782 }
783 
784 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
785     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
786         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
787     }
788     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
789         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
790         uint count;
791         for( uint i; i < _owners.length; ++i ){
792             if( owner == _owners[i] ){
793                 if( count == index )
794                     return i;
795                 else
796                     ++count;
797             }
798         }
799         require(false, "ERC721Enum: owner ioob");
800     }
801     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
802         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
803         uint256 tokenCount = balanceOf(owner);
804         uint256[] memory tokenIds = new uint256[](tokenCount);
805         for (uint256 i = 0; i < tokenCount; i++) {
806             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
807         }
808         return tokenIds;
809     }
810     function totalSupply() public view virtual override returns (uint256) {
811         return _owners.length;
812     }
813     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
814         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
815         return index;
816     }
817 }
818 
819 abstract contract Tripsters {
820     function ownerOf(uint256 tokenId) external virtual view returns (address);
821 }
822 
823 contract Baggies is ERC721Enum, Ownable, ReentrancyGuard {
824     using Strings for uint256;
825 	uint256 public NFT_MINTED;
826 	address public tripRoomAddress;
827 
828 	Tripsters public tripsterContractInstance = Tripsters(0xc7457f480416e145093EDB355F626FaA0fc7F90E);
829 
830 	string private baseURI;
831     constructor() ERC721P('Baggies', 'Baggies') {}
832 
833     function _baseURI() internal view virtual returns (string memory) {
834         return baseURI;
835     }
836 
837 	function mint(uint256 _count, address _to) external onlyOwner nonReentrant{
838 		uint256 totalSupply = totalSupply();
839 		for (uint256 i = 0; i < _count; i++) {
840             _safeMint(_to, totalSupply + i);
841 			NFT_MINTED++;
842         }
843     }
844 
845 	function mint(uint256 _count) external onlyOwner nonReentrant{
846 		uint256 totalSupply = totalSupply();
847 		for (uint256 i = 0; i < _count; i++) {
848 		     address recipient = tripsterContractInstance.ownerOf(totalSupply+i);
849              if (recipient != address(0)) {
850                  _safeMint(recipient, totalSupply + i);
851 	             NFT_MINTED++;
852              }
853          }
854     }
855 	
856 	function burnFromTripRoom(uint256 tokenId) external {
857 	   require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
858 	   require(_msgSender() == tripRoomAddress, "Incorrect Request");
859 	   _burn(tokenId);
860 	}
861 
862 	function ownerOfToken(uint256 tokenId) external view returns (address) {
863         return ownerOf(tokenId);
864     }
865 
866     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
867         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
868         string memory currentBaseURI = _baseURI();
869         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
870     }
871 
872     function transferFrom(address _from, address _to, uint256 _tokenId) public override {
873         ERC721P.transferFrom(_from, _to, _tokenId);
874     }
875 
876     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public override {
877         ERC721P.safeTransferFrom(_from, _to, _tokenId, _data);
878     }
879 
880 	function setBaseURI(string memory newBaseURI) external onlyOwner {
881         require(bytes(newBaseURI).length != 0, "Invalid new URI");
882         baseURI = newBaseURI;
883     }
884 
885 	function setTripRoomAddress(address newAddress) external onlyOwner {
886         require(newAddress != address(0), "Invalid new address");
887         tripRoomAddress = newAddress;
888     }
889 }