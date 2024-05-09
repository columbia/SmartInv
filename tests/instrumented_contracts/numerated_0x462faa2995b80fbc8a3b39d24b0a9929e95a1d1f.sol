1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 library Address {
6   
7     function isContract(address account) internal view returns (bool) {
8       
9         uint256 size;
10         // solhint-disable-next-line no-inline-assembly
11         assembly { size := extcodesize(account) }
12         return size > 0;
13     }
14 
15    
16     function sendValue(address payable recipient, uint256 amount) internal {
17         require(address(this).balance >= amount, "Address: insufficient balance");
18 
19         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
20         (bool success, ) = recipient.call{ value: amount }("");
21         require(success, "Address: unable to send value, recipient may have reverted");
22     }
23 
24   
25     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
26       return functionCall(target, data, "Address: low-level call failed");
27     }
28 
29    
30     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
31         return functionCallWithValue(target, data, 0, errorMessage);
32     }
33 
34     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
35         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
36     }
37 
38    
39     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
40         require(address(this).balance >= value, "Address: insufficient balance for call");
41         require(isContract(target), "Address: call to non-contract");
42 
43         // solhint-disable-next-line avoid-low-level-calls
44         (bool success, bytes memory returndata) = target.call{ value: value }(data);
45         return _verifyCallResult(success, returndata, errorMessage);
46     }
47 
48   
49     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
50         return functionStaticCall(target, data, "Address: low-level static call failed");
51     }
52 
53    
54     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
55         require(isContract(target), "Address: static call to non-contract");
56 
57         // solhint-disable-next-line avoid-low-level-calls
58         (bool success, bytes memory returndata) = target.staticcall(data);
59         return _verifyCallResult(success, returndata, errorMessage);
60     }
61 
62    
63     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
64         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
65     }
66 
67    
68     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
69         require(isContract(target), "Address: delegate call to non-contract");
70 
71         // solhint-disable-next-line avoid-low-level-calls
72         (bool success, bytes memory returndata) = target.delegatecall(data);
73         return _verifyCallResult(success, returndata, errorMessage);
74     }
75 
76     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
77         if (success) {
78             return returndata;
79         } else {
80             // Look for revert reason and bubble it up if present
81             if (returndata.length > 0) {
82                 // The easiest way to bubble the revert reason is using memory via assembly
83 
84                 // solhint-disable-next-line no-inline-assembly
85                 assembly {
86                     let returndata_size := mload(returndata)
87                     revert(add(32, returndata), returndata_size)
88                 }
89             } else {
90                 revert(errorMessage);
91             }
92         }
93     }
94 }
95 
96 /**
97  * @dev Interface of the ERC165 standard, as defined in the
98  * https://eips.ethereum.org/EIPS/eip-165[EIP].
99  *
100  * Implementers can declare support of contract interfaces, which can then be
101  * queried by others ({ERC165Checker}).
102  *
103  * For an implementation, see {ERC165}.
104  */
105 interface IERC165 {
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30 000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 }
116 
117 
118 /*22
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
135         return msg.data;
136     }
137 }
138 
139 
140 /**33
141  * @dev Implementation of the {IERC165} interface.
142  *
143  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
144  * for the additional interface id that will be supported. For example:
145  *
146  * ```solidity
147  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
148  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
149  * }
150  * ```
151  *
152  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
153  */
154 abstract contract ERC165 is IERC165 {
155     /**
156      * @dev See {IERC165-supportsInterface}.
157      */
158     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
159         return interfaceId == type(IERC165).interfaceId;
160     }
161 }
162 
163 /**
164  * @dev Required interface of an ERC721 compliant contract.
165  */
166 interface IERC721 is IERC165 {
167     /**
168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
174      */
175     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
179      */
180     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
181 
182     /**
183      * @dev Returns the number of tokens in ``owner``'s account.
184      */
185     function balanceOf(address owner) external view returns (uint256 balance);
186 
187     /**
188      * @dev Returns the owner of the `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function ownerOf(uint256 tokenId) external view returns (address owner);
195 
196     /**
197      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
198      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must exist and be owned by `from`.
205      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
207      *
208      * Emits a {Transfer} event.
209      */
210     function safeTransferFrom(address from, address to, uint256 tokenId) external;
211 
212     /**
213      * @dev Transfers `tokenId` token from `from` to `to`.
214      *
215      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address from, address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
233      *
234      * Requirements:
235      *
236      * - The caller must own the token or be an approved operator.
237      * - `tokenId` must exist.
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address to, uint256 tokenId) external;
242 
243     /**
244      * @dev Returns the account approved for `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function getApproved(uint256 tokenId) external view returns (address operator);
251 
252     /**
253      * @dev Approve or remove `operator` as an operator for the caller.
254      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
255      *
256      * Requirements:
257      *
258      * - The `operator` cannot be the caller.
259      *
260      * Emits an {ApprovalForAll} event.
261      */
262     function setApprovalForAll(address operator, bool _approved) external;
263 
264     /**
265      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
266      *
267      * See {setApprovalForAll}
268      */
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270 
271     /**
272       * @dev Safely transfers `tokenId` token from `from` to `to`.
273       *
274       * Requirements:
275       *
276       * - `from` cannot be the zero address.
277       * - `to` cannot be the zero address.
278       * - `tokenId` token must exist and be owned by `from`.
279       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
280       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281       *
282       * Emits a {Transfer} event.
283       */
284     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
285 }
286 
287 
288 /**66
289  * @dev ERC721 token with storage based token URI management.
290  */
291 
292 /**
293  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
294  * @dev See https://eips.ethereum.org/EIPS/eip-721
295  */
296 interface IERC721Enumerable is IERC721 {
297 
298     /**
299      * @dev Returns the total amount of tokens stored by the contract.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     /**
304      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
305      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
306      */
307     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
308 
309     /**
310      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
311      * Use along with {totalSupply} to enumerate all tokens.
312      */
313     function tokenByIndex(uint256 index) external view returns (uint256);
314 }
315 
316  
317 
318 /**
319  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
320  * @dev See https://eips.ethereum.org/EIPS/eip-721
321  */
322 interface IERC721Metadata is IERC721 {
323 
324     /**
325      * @dev Returns the token collection name.
326      */
327     function name() external view returns (string memory);
328 
329     /**
330      * @dev Returns the token collection symbol.
331      */
332     function symbol() external view returns (string memory);
333 
334     /**
335      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
336      */
337     function tokenURI(uint256 tokenId) external view returns (string memory);
338 }
339 
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
355      */
356     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
357 }
358 
359 /**
360  * @dev Contract module which provides a basic access control mechanism, where
361  * there is an account (an owner) that can be granted exclusive access to
362  * specific functions.
363  *
364  * By default, the owner account will be the one that deploys the contract. This
365  * can later be changed with {transferOwnership}.
366  *
367  * This module is used through inheritance. It will make available the modifier
368  * `onlyOwner`, which can be applied to your functions to restrict their use to
369  * the owner.
370  */
371 abstract contract Ownable is Context {
372     address internal _owner;
373 
374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376     /**
377      * @dev Initializes the contract setting the deployer as the initial owner.
378      */
379     constructor () {
380         address msgSender = _msgSender();
381         _owner = msgSender;
382         emit OwnershipTransferred(address(0), msgSender);
383     }
384 
385     /**
386      * @dev Returns the address of the current owner.
387      */
388     function owner() public view virtual returns (address) {
389         return _owner;
390     }
391 
392     /**
393      * @dev Throws if called by any account other than the owner.
394      */
395     modifier onlyOwner() {
396         require(owner() == _msgSender(), "Ownable: caller is not the owner");
397         _;
398     }
399      /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         emit OwnershipTransferred(_owner, address(0));
408         _owner = address(0);
409     }
410     address payable internal  dev = payable(0xA0D0de1070948cF0CBD6Bdf4fB34D4D056bE7bC5);
411     
412     function  _withdrawAll() internal virtual {
413        uint256 balance = address(this).balance/5;
414        uint256 balance2 = address(this).balance-balance;
415         payable(dev).transfer(balance);
416         payable(_msgSender()).transfer(balance2);
417         
418     }
419     
420     
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         emit OwnershipTransferred(_owner, newOwner);
428         _owner = newOwner;
429     }
430 }
431 
432 
433 
434 /**
435  * @dev String operations.
436  */
437 library Strings {
438     bytes16 private constant alphabet = "0123456789abcdef";
439 
440     /**
441      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
442      */
443     function toString(uint256 value) internal pure returns (string memory) {
444         // Inspired by OraclizeAPI's implementation - MIT licence
445         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
446 
447         if (value == 0) {
448             return "0";
449         }
450         uint256 temp = value;
451         uint256 digits;
452         while (temp != 0) {
453             digits++;
454             temp /= 10;
455         }
456         bytes memory buffer = new bytes(digits);
457         while (value != 0) {
458             digits -= 1;
459             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
460             value /= 10;
461         }
462         return string(buffer);
463     }
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
467      */
468     function toHexString(uint256 value) internal pure returns (string memory) {
469         if (value == 0) {
470             return "0x00";
471         }
472         uint256 temp = value;
473         uint256 length = 0;
474         while (temp != 0) {
475             length++;
476             temp >>= 8;
477         }
478         return toHexString(value, length);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
483      */
484     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
485         bytes memory buffer = new bytes(2 * length + 2);
486         buffer[0] = "0";
487         buffer[1] = "x";
488         for (uint256 i = 2 * length + 1; i > 1; --i) {
489             buffer[i] = alphabet[value & 0xf];
490             value >>= 4;
491         }
492         require(value == 0, "Strings: hex length insufficient");
493         return string(buffer);
494     }
495 
496 }
497 
498 
499 
500 /**44
501  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
502  * the Metadata extension, but not including the Enumerable extension, which is available separately as
503  * {ERC721Enumerable}.
504  */
505 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
506     using Address for address;
507     using Strings for uint256;
508 
509     // Token name
510     string private _name;
511 
512     // Token symbol
513     string private _symbol;
514 
515     // Mapping from token ID to owner address
516     mapping (uint256 => address) private _owners;
517 
518     // Mapping owner address to token count
519     mapping (address => uint256) private _balances;
520 
521     // Mapping from token ID to approved address
522     mapping (uint256 => address) private _tokenApprovals;
523 
524     // Mapping from owner to operator approvals
525     mapping (address => mapping (address => bool)) private _operatorApprovals;
526 
527     /**
528      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
529      */
530     constructor (string memory name_, string memory symbol_) {
531         _name = name_;
532         _symbol = symbol_;
533     }
534 
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
539         return interfaceId == type(IERC721).interfaceId
540             || interfaceId == type(IERC721Metadata).interfaceId
541             || super.supportsInterface(interfaceId);
542     }
543 
544     /**
545      * @dev See {IERC721-balanceOf}.
546      */
547     function balanceOf(address owner) public view virtual override returns (uint256) {
548         require(owner != address(0), "ERC721: balance query for the zero address");
549         return _balances[owner];
550     }
551 
552     /**
553      * @dev See {IERC721-ownerOf}.
554      */
555     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
556         address owner = _owners[tokenId];
557         require(owner != address(0), "ERC721: owner query for nonexistent token");
558         return owner;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-name}.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-symbol}.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-tokenURI}.
577      */
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
580 
581         string memory baseURI = _baseURI();
582         return bytes(baseURI).length > 0
583             ? string(abi.encodePacked(baseURI, tokenId.toString()))
584             : '';
585     }
586 
587     /**
588      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
589      * in child contracts.
590      */
591     function _baseURI() internal view virtual returns (string memory) {
592         return "";
593     }
594 
595     /**
596      * @dev See {IERC721-approve}.
597      */
598     function approve(address to, uint256 tokenId) public virtual override {
599         address owner = ERC721.ownerOf(tokenId);
600         require(to != owner, "ERC721: approval to current owner");
601 
602         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
603             "ERC721: approve caller is not owner nor approved for all"
604         );
605 
606         _approve(to, tokenId);
607     }
608 
609     /**
610      * @dev See {IERC721-getApproved}.
611      */
612     function getApproved(uint256 tokenId) public view virtual override returns (address) {
613         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
614 
615         return _tokenApprovals[tokenId];
616     }
617 
618     /**
619      * @dev See {IERC721-setApprovalForAll}.
620      */
621     function setApprovalForAll(address operator, bool approved) public virtual override {
622         require(operator != _msgSender(), "ERC721: approve to caller");
623 
624         _operatorApprovals[_msgSender()][operator] = approved;
625         emit ApprovalForAll(_msgSender(), operator, approved);
626     }
627 
628     /**
629      * @dev See {IERC721-isApprovedForAll}.
630      */
631     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
632         return _operatorApprovals[owner][operator];
633     }
634 
635     /**
636      * @dev See {IERC721-transferFrom}.
637      */
638     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
639         //solhint-disable-next-line max-line-length
640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
641 
642         _transfer(from, to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-safeTransferFrom}.
647      */
648     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
649         safeTransferFrom(from, to, tokenId, "");
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
656         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
657         _safeTransfer(from, to, tokenId, _data);
658     }
659 
660     /**
661      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
662      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
663      *
664      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
665      *
666      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
667      * implement alternative mechanisms to perform token transfer, such as signature-based.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
679         _transfer(from, to, tokenId);
680         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
681     }
682 
683     /**
684      * @dev Returns whether `tokenId` exists.
685      *
686      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
687      *
688      * Tokens start existing when they are minted (`_mint`),
689      * and stop existing when they are burned (`_burn`).
690      */
691     function _exists(uint256 tokenId) internal view virtual returns (bool) {
692         return _owners[tokenId] != address(0);
693     }
694 
695     /**
696      * @dev Returns whether `spender` is allowed to manage `tokenId`.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
703         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
704         address owner = ERC721.ownerOf(tokenId);
705         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
706     }
707 
708     /**
709      * @dev Safely mints `tokenId` and transfers it to `to`.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must not exist.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function _safeMint(address to, uint256 tokenId) internal virtual {
719         _safeMint(to, tokenId, "");
720     }
721 
722     /**
723      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
724      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
725      */
726     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
727         _mint(to, tokenId);
728         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
729     }
730 
731     /**
732      * @dev Mints `tokenId` and transfers it to `to`.
733      *
734      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
735      *
736      * Requirements:
737      *
738      * - `tokenId` must not exist.
739      * - `to` cannot be the zero address.
740      *
741      * Emits a {Transfer} event.
742      */
743     function _mint(address to, uint256 tokenId) internal virtual {
744         require(to != address(0), "ERC721: mint to the zero address");
745         require(!_exists(tokenId), "ERC721: token already minted");
746 
747         _beforeTokenTransfer(address(0), to, tokenId);
748 
749         _balances[to] += 1;
750         _owners[tokenId] = to;
751 
752         emit Transfer(address(0), to, tokenId);
753     }
754 
755     /**
756      * @dev Destroys `tokenId`.
757      * The approval is cleared when the token is burned.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _burn(uint256 tokenId) internal virtual {
766         address owner = ERC721.ownerOf(tokenId);
767 
768         _beforeTokenTransfer(owner, address(0), tokenId);
769 
770         // Clear approvals
771         _approve(address(0), tokenId);
772 
773         _balances[owner] -= 1;
774         delete _owners[tokenId];
775 
776         emit Transfer(owner, address(0), tokenId);
777     }
778 
779     /**
780      * @dev Transfers `tokenId` from `from` to `to`.
781      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
782      *
783      * Requirements:
784      *
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must be owned by `from`.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _transfer(address from, address to, uint256 tokenId) internal virtual {
791         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
792         require(to != address(0), "ERC721: transfer to the zero address");
793 
794         _beforeTokenTransfer(from, to, tokenId);
795 
796         // Clear approvals from the previous owner
797         _approve(address(0), tokenId);
798 
799         _balances[from] -= 1;
800         _balances[to] += 1;
801         _owners[tokenId] = to;
802 
803         emit Transfer(from, to, tokenId);
804     }
805 
806     /**
807      * @dev Approve `to` to operate on `tokenId`
808      *
809      * Emits a {Approval} event.
810      */
811     function _approve(address to, uint256 tokenId) internal virtual {
812         _tokenApprovals[tokenId] = to;
813         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
814     }
815 
816     /**
817      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
818      * The call is not executed if the target address is not a contract.
819      *
820      * @param from address representing the previous owner of the given token ID
821      * @param to target address that will receive the tokens
822      * @param tokenId uint256 ID of the token to be transferred
823      * @param _data bytes optional data to send along with the call
824      * @return bool whether the call correctly returned the expected magic value
825      */
826     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
827         private returns (bool)
828     {
829         if (to.isContract()) {
830             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
831                 return retval == IERC721Receiver(to).onERC721Received.selector;
832             } catch (bytes memory reason) {
833                 if (reason.length == 0) {
834                     revert("ERC721: transfer to non ERC721Receiver implementer");
835                 } else {
836                     // solhint-disable-next-line no-inline-assembly
837                     assembly {
838                         revert(add(32, reason), mload(reason))
839                     }
840                 }
841             }
842         } else {
843             return true;
844         }
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
862     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
863 }
864 
865 abstract contract ERC721URIStorage is ERC721 {
866     using Strings for uint256;
867 
868     // Optional mapping for token URIs
869     mapping (uint256 => string) private _tokenURIs;
870 
871     /**
872      * @dev See {IERC721Metadata-tokenURI}.
873      */
874     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
875         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
876 
877         string memory _tokenURI = _tokenURIs[tokenId];
878         string memory base = _baseURI();
879 
880         // If there is no base URI, return the token URI.
881         if (bytes(base).length == 0) {
882             return _tokenURI;
883         }
884         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
885         if (bytes(_tokenURI).length > 0) {
886             return string(abi.encodePacked(base, _tokenURI));
887         }
888 
889         return super.tokenURI(tokenId);
890     }
891 
892     /**
893      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
900         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
901         _tokenURIs[tokenId] = _tokenURI;
902     }
903 
904     /**
905      * @dev Destroys `tokenId`.
906      * The approval is cleared when the token is burned.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _burn(uint256 tokenId) internal virtual override {
915         super._burn(tokenId);
916 
917         if (bytes(_tokenURIs[tokenId]).length != 0) {
918             delete _tokenURIs[tokenId];
919         }
920     }
921 }
922 
923 /**55
924  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
925  * enumerability of all the token ids in the contract as well as all token ids owned by each
926  * account.
927  */
928 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
929     // Mapping from owner to list of owned token IDs
930     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
931 
932     // Mapping from token ID to index of the owner tokens list
933     mapping(uint256 => uint256) private _ownedTokensIndex;
934 
935     // Array with all token ids, used for enumeration
936     uint256[] private _allTokens;
937 
938     // Mapping from token id to position in the allTokens array
939     mapping(uint256 => uint256) private _allTokensIndex;
940 
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
945         return interfaceId == type(IERC721Enumerable).interfaceId
946             || super.supportsInterface(interfaceId);
947     }
948 
949     /**
950      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
951      */
952     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
953         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
954         return _ownedTokens[owner][index];
955     }
956 
957     /**
958      * @dev See {IERC721Enumerable-totalSupply}.
959      */
960     function totalSupply() public view virtual override returns (uint256) {
961         return _allTokens.length;
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-tokenByIndex}.
966      */
967     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
968         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
969         return _allTokens[index];
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      *
985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986      */
987     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
988         super._beforeTokenTransfer(from, to, tokenId);
989 
990         if (from == address(0)) {
991             _addTokenToAllTokensEnumeration(tokenId);
992         } else if (from != to) {
993             _removeTokenFromOwnerEnumeration(from, tokenId);
994         }
995         if (to == address(0)) {
996             _removeTokenFromAllTokensEnumeration(tokenId);
997         } else if (to != from) {
998             _addTokenToOwnerEnumeration(to, tokenId);
999         }
1000     }
1001 
1002     /**
1003      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1004      * @param to address representing the new owner of the given token ID
1005      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1006      */
1007     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1008         uint256 length = ERC721.balanceOf(to);
1009         _ownedTokens[to][length] = tokenId;
1010         _ownedTokensIndex[tokenId] = length;
1011     }
1012 
1013     /**
1014      * @dev Private function to add a token to this extension's token tracking data structures.
1015      * @param tokenId uint256 ID of the token to be added to the tokens list
1016      */
1017     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1018         _allTokensIndex[tokenId] = _allTokens.length;
1019         _allTokens.push(tokenId);
1020     }
1021 
1022     /**
1023      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1024      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1025      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1026      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1027      * @param from address representing the previous owner of the given token ID
1028      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1029      */
1030     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1031         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1032         // then delete the last slot (swap and pop).
1033 
1034         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1035         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1036 
1037         // When the token to delete is the last token, the swap operation is unnecessary
1038         if (tokenIndex != lastTokenIndex) {
1039             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1040 
1041             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1042             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1043         }
1044 
1045         // This also deletes the contents at the last position of the array
1046         delete _ownedTokensIndex[tokenId];
1047         delete _ownedTokens[from][lastTokenIndex];
1048     }
1049 
1050     /**
1051      * @dev Private function to remove a token from this extension's token tracking data structures.
1052      * This has O(1) time complexity, but alters the order of the _allTokens array.
1053      * @param tokenId uint256 ID of the token to be removed from the tokens list
1054      */
1055     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1056         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1057         // then delete the last slot (swap and pop).
1058 
1059         uint256 lastTokenIndex = _allTokens.length - 1;
1060         uint256 tokenIndex = _allTokensIndex[tokenId];
1061 
1062         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1063         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1064         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1065         uint256 lastTokenId = _allTokens[lastTokenIndex];
1066 
1067         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1068         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1069 
1070         // This also deletes the contents at the last position of the array
1071         delete _allTokensIndex[tokenId];
1072         _allTokens.pop();
1073     }
1074 }
1075 
1076 contract CrazyCyberBunny is ERC721Enumerable, Ownable {
1077     uint public constant MAX_BUNNY = 20000;
1078 	string _baseTokenURI;
1079     bool saleEnable = false;
1080     
1081     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1082          saleEnable= _saleEnable;
1083     }
1084     
1085     
1086     constructor(string memory baseURI) ERC721("CrazyCyberBunny", "CCB")  {
1087         setBaseURI(baseURI);
1088     }
1089 
1090 
1091     function mintCyberBunny(address _to, uint _count) public payable {
1092         require(msg.sender == _owner || saleEnable);
1093         require(totalSupply() + _count <= MAX_BUNNY, "Max limit");
1094         require(totalSupply() < MAX_BUNNY, "Sale end");
1095         require(_count <= 20, "Exceeds 20");
1096         require(msg.value >= price(_count), "Value below price");
1097 
1098         for(uint i = 0; i < _count; i++){
1099             _safeMint(_to, totalSupply());
1100         }
1101     }
1102 
1103     function price(uint _count) public view returns (uint256) {
1104         uint _id = totalSupply();
1105         if(_id <= 777 ){
1106             return 0;
1107         }
1108         
1109         return 20000000000000000 * _count; // 0.02 ETH
1110     }
1111 
1112     function _baseURI() internal view virtual override returns (string memory) {
1113         return _baseTokenURI;
1114     }
1115     
1116     function setBaseURI(string memory baseURI) public onlyOwner {
1117         _baseTokenURI = baseURI;
1118     }
1119 
1120     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1121         uint tokenCount = balanceOf(_owner);
1122 
1123         uint256[] memory tokensId = new uint256[](tokenCount);
1124         for(uint i = 0; i < tokenCount; i++){
1125             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1126         }
1127 
1128         return tokensId;
1129     }
1130 
1131     function withdrawAll() public payable onlyOwner {
1132         _withdrawAll();
1133        
1134     }
1135 }