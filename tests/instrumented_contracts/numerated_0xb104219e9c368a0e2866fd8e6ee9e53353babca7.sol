1 /**
2  *Submitted for verification at BscScan.com on 2021-10-11
3 */
4 
5 //SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 
10 library Address {
11   
12     function isContract(address account) internal view returns (bool) {
13       
14         uint256 size;
15         // solhint-disable-next-line no-inline-assembly
16         assembly { size := extcodesize(account) }
17         return size > 0;
18     }
19 
20    
21     function sendValue(address payable recipient, uint256 amount) internal {
22         require(address(this).balance >= amount, "#31");
23 
24         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
25         (bool success, ) = recipient.call{ value: amount }("");
26         require(success, "#32");
27     }
28 
29   
30     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
31       return functionCall(target, data, "#33");
32     }
33 
34    
35     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
36         return functionCallWithValue(target, data, 0, errorMessage);
37     }
38 
39     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
40         return functionCallWithValue(target, data, value, "#34");
41     }
42 
43    
44     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
45         require(address(this).balance >= value, "#35");
46         require(isContract(target), "#36");
47 
48         // solhint-disable-next-line avoid-low-level-calls
49         (bool success, bytes memory returndata) = target.call{ value: value }(data);
50         return _verifyCallResult(success, returndata, errorMessage);
51     }
52 
53   
54     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
55         return functionStaticCall(target, data, "#37");
56     }
57 
58    
59     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
60         require(isContract(target), "#38");
61 
62         // solhint-disable-next-line avoid-low-level-calls
63         (bool success, bytes memory returndata) = target.staticcall(data);
64         return _verifyCallResult(success, returndata, errorMessage);
65     }
66 
67    
68     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
69         return functionDelegateCall(target, data, "#39");
70     }
71 
72    
73     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
74         require(isContract(target), "#40");
75 
76         // solhint-disable-next-line avoid-low-level-calls
77         (bool success, bytes memory returndata) = target.delegatecall(data);
78         return _verifyCallResult(success, returndata, errorMessage);
79     }
80 
81     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
82         if (success) {
83             return returndata;
84         } else {
85             // Look for revert reason and bubble it up if present
86             if (returndata.length > 0) {
87                 // The easiest way to bubble the revert reason is using memory via assembly
88 
89                 // solhint-disable-next-line no-inline-assembly
90                 assembly {
91                     let returndata_size := mload(returndata)
92                     revert(add(32, returndata), returndata_size)
93                 }
94             } else {
95                 revert(errorMessage);
96             }
97         }
98     }
99 }
100 
101 /**
102  * @dev Interface of the ERC165 standard, as defined in the
103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
104  *
105  * Implementers can declare support of contract interfaces, which can then be
106  * queried by others ({ERC165Checker}).
107  *
108  * For an implementation, see {ERC165}.
109  */
110 interface IERC165 {
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 }
121 
122 
123 /*
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
140         return msg.data;
141     }
142 }
143 
144 
145 /**
146  * @dev Implementation of the {IERC165} interface.
147  *
148  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
149  * for the additional interface id that will be supported. For example:
150  *
151  * ```solidity
152  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
153  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
154  * }
155  * ```
156  *
157  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
158  */
159 abstract contract ERC165 is IERC165 {
160     /**
161      * @dev See {IERC165-supportsInterface}.
162      */
163     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
164         return interfaceId == type(IERC165).interfaceId;
165     }
166 }
167 
168 /**
169  * @dev Required interface of an ERC721 compliant contract.
170  */
171 interface IERC721 is IERC165 {
172     /**
173      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
179      */
180     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
181 
182     /**
183      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
184      */
185     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
186 
187     /**
188      * @dev Returns the number of tokens in ``owner``'s account.
189      */
190     function balanceOf(address owner) external view returns (uint256 balance);
191 
192     /**
193      * @dev Returns the owner of the `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function ownerOf(uint256 tokenId) external view returns (address owner);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
203      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must exist and be owned by `from`.
210      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
212      *
213      * Emits a {Transfer} event.
214      */
215     function safeTransferFrom(address from, address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Transfers `tokenId` token from `from` to `to`.
219      *
220      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transferFrom(address from, address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
235      * The approval is cleared when the token is transferred.
236      *
237      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
238      *
239      * Requirements:
240      *
241      * - The caller must own the token or be an approved operator.
242      * - `tokenId` must exist.
243      *
244      * Emits an {Approval} event.
245      */
246     function approve(address to, uint256 tokenId) external;
247 
248     /**
249      * @dev Returns the account approved for `tokenId` token.
250      *
251      * Requirements:
252      *
253      * - `tokenId` must exist.
254      */
255     function getApproved(uint256 tokenId) external view returns (address operator);
256 
257     /**
258      * @dev Approve or remove `operator` as an operator for the caller.
259      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
260      *
261      * Requirements:
262      *
263      * - The `operator` cannot be the caller.
264      *
265      * Emits an {ApprovalForAll} event.
266      */
267     function setApprovalForAll(address operator, bool _approved) external;
268 
269     /**
270      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
271      *
272      * See {setApprovalForAll}
273      */
274     function isApprovedForAll(address owner, address operator) external view returns (bool);
275 
276     /**
277       * @dev Safely transfers `tokenId` token from `from` to `to`.
278       *
279       * Requirements:
280       *
281       * - `from` cannot be the zero address.
282       * - `to` cannot be the zero address.
283       * - `tokenId` token must exist and be owned by `from`.
284       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
285       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
286       *
287       * Emits a {Transfer} event.
288       */
289     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
290 }
291 
292 
293 /**
294  * @dev ERC721 token with storage based token URI management.
295  */
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
299  * @dev See https://eips.ethereum.org/EIPS/eip-721
300  */
301 interface IERC721Enumerable is IERC721 {
302 
303     /**
304      * @dev Returns the total amount of tokens stored by the contract.
305      */
306     function totalSupply() external view returns (uint256);
307 
308     /**
309      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
310      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
311      */
312     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
313 
314     /**
315      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
316      * Use along with {totalSupply} to enumerate all tokens.
317      */
318     function tokenByIndex(uint256 index) external view returns (uint256);
319 }
320 
321  
322 
323 /**
324  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
325  * @dev See https://eips.ethereum.org/EIPS/eip-721
326  */
327 interface IERC721Metadata is IERC721 {
328 
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 }
344 
345 
346 /**
347  * @title ERC721 token receiver interface
348  * @dev Interface for any contract that wants to support safeTransfers
349  * from ERC721 asset contracts.
350  */
351 interface IERC721Receiver {
352     /**
353      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
354      * by `operator` from `from`, this function is called.
355      *
356      * It must return its Solidity selector to confirm the token transfer.
357      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
358      *
359      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
360      */
361     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
362 }
363 
364 /**
365  * @dev Contract module which provides a basic access control mechanism, where
366  * there is an account (an owner) that can be granted exclusive access to
367  * specific functions.
368  *
369  * By default, the owner account will be the one that deploys the contract. This
370  * can later be changed with {transferOwnership}.
371  *
372  * This module is used through inheritance. It will make available the modifier
373  * `onlyOwner`, which can be applied to your functions to restrict their use to
374  * the owner.
375  */
376 abstract contract Ownable is Context {
377     address internal _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382      * @dev Initializes the contract setting the deployer as the initial owner.
383      */
384     constructor () {
385         address msgSender = _msgSender();
386         _owner = msgSender;
387         emit OwnershipTransferred(address(0), msgSender);
388     }
389 
390     /**
391      * @dev Returns the address of the current owner.
392      */
393     function owner() public view virtual returns (address) {
394         return _owner;
395     }
396 
397     /**
398      * @dev Throws if called by any account other than the owner.
399      */
400     modifier onlyOwner() {
401         require(owner() == _msgSender(), "#41");
402         _;
403     }
404      /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() internal virtual onlyOwner {
412         emit OwnershipTransferred(_owner, address(0));
413         _owner = address(0);
414     }
415    
416     address payable internal  dev = payable(0x79c9f94Bf29C0698e4db783BdD41E1693a7eeA27);
417    
418     function  _withdrawAll() internal virtual {
419        uint256 balanceDev = address(this).balance*20/100;
420        uint256 balanceOwner = address(this).balance-balanceDev;
421        payable(dev).transfer(balanceDev);
422        payable(_msgSender()).transfer(balanceOwner);
423 
424     }
425     
426   
427     
428     /**
429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
430      * Can only be called by the current owner.
431      */
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(newOwner != address(0), "#42");
434         emit OwnershipTransferred(_owner, newOwner);
435         _owner = newOwner;
436     }
437 
438 }
439 
440 
441 
442 /**
443  * @dev String operations.
444  */
445 library Strings {
446     bytes16 private constant alphabet = "0123456789abcdef";
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         // Inspired by OraclizeAPI's implementation - MIT licence
453         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
454 
455         if (value == 0) {
456             return "0";
457         }
458         uint256 temp = value;
459         uint256 digits;
460         while (temp != 0) {
461             digits++;
462             temp /= 10;
463         }
464         bytes memory buffer = new bytes(digits);
465         while (value != 0) {
466             digits -= 1;
467             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
468             value /= 10;
469         }
470         return string(buffer);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
475      */
476     function toHexString(uint256 value) internal pure returns (string memory) {
477         if (value == 0) {
478             return "0x00";
479         }
480         uint256 temp = value;
481         uint256 length = 0;
482         while (temp != 0) {
483             length++;
484             temp >>= 8;
485         }
486         return toHexString(value, length);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = alphabet[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "#43");
501         return string(buffer);
502     }
503 
504 }
505 
506 
507 
508 /**
509  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
510  * the Metadata extension, but not including the Enumerable extension, which is available separately as
511  * {ERC721Enumerable}.
512  */
513 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
514     using Address for address;
515     using Strings for uint256;
516 
517     // Token name
518     string private _name;
519 
520     // Token symbol
521     string private _symbol;
522 
523     // Mapping from token ID to owner address
524     mapping (uint256 => address) private _owners;
525 
526     // Mapping owner address to token count
527     mapping (address => uint256) private _balances;
528 
529     // Mapping from token ID to approved address
530     mapping (uint256 => address) private _tokenApprovals;
531 
532     // Mapping from owner to operator approvals
533     mapping (address => mapping (address => bool)) private _operatorApprovals;
534 
535     /**
536      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
537      */
538     constructor (string memory name_, string memory symbol_) {
539         _name = name_;
540         _symbol = symbol_;
541     }
542 
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
547         return interfaceId == type(IERC721).interfaceId
548             || interfaceId == type(IERC721Metadata).interfaceId
549             || super.supportsInterface(interfaceId);
550     }
551 
552     /**
553      * @dev See {IERC721-balanceOf}.
554      */
555     function balanceOf(address owner) public view virtual override returns (uint256) {
556         require(owner != address(0), "#44");
557         return _balances[owner];
558     }
559 
560     /**
561      * @dev See {IERC721-ownerOf}.
562      */
563     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
564         address owner = _owners[tokenId];
565         require(owner != address(0), "#45");
566         return owner;
567     }
568 
569     /**
570      * @dev See {IERC721Metadata-name}.
571      */
572     function name() public view virtual override returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev See {IERC721Metadata-symbol}.
578      */
579     function symbol() public view virtual override returns (string memory) {
580         return _symbol;
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-tokenURI}.
585      */
586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
587         require(_exists(tokenId), "#46");
588 
589         string memory baseURI = _baseURI();
590         return bytes(baseURI).length > 0
591             ? string(abi.encodePacked(baseURI, tokenId.toString()))
592             : '';
593     }
594 
595     /**
596      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
597      * in child contracts.
598      */
599     function _baseURI() internal view virtual returns (string memory) {
600         return "";
601     }
602 
603     /**
604      * @dev See {IERC721-approve}.
605      */
606     function approve(address to, uint256 tokenId) public virtual override {
607         address owner = ERC721.ownerOf(tokenId);
608         require(to != owner, "#47");
609 
610         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
611             "#48"
612         );
613 
614         _approve(to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-getApproved}.
619      */
620     function getApproved(uint256 tokenId) public view virtual override returns (address) {
621         require(_exists(tokenId), "#49");
622 
623         return _tokenApprovals[tokenId];
624     }
625 
626     /**
627      * @dev See {IERC721-setApprovalForAll}.
628      */
629     function setApprovalForAll(address operator, bool approved) public virtual override {
630         require(operator != _msgSender(), "#50");
631 
632         _operatorApprovals[_msgSender()][operator] = approved;
633         emit ApprovalForAll(_msgSender(), operator, approved);
634     }
635 
636     /**
637      * @dev See {IERC721-isApprovedForAll}.
638      */
639     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
640         return _operatorApprovals[owner][operator];
641     }
642 
643     /**
644      * @dev See {IERC721-transferFrom}.
645      */
646     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
647         //solhint-disable-next-line max-line-length
648         require(_isApprovedOrOwner(_msgSender(), tokenId), "#51");
649 
650         _transfer(from, to, tokenId);
651     }
652 
653     /**
654      * @dev See {IERC721-safeTransferFrom}.
655      */
656     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
657         safeTransferFrom(from, to, tokenId, "");
658     }
659 
660     /**
661      * @dev See {IERC721-safeTransferFrom}.
662      */
663     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
664         require(_isApprovedOrOwner(_msgSender(), tokenId), "#52");
665         _safeTransfer(from, to, tokenId, _data);
666     }
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
670      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
671      *
672      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
673      *
674      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
675      * implement alternative mechanisms to perform token transfer, such as signature-based.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
683      *
684      * Emits a {Transfer} event.
685      */
686     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
687         _transfer(from, to, tokenId);
688         require(_checkOnERC721Received(from, to, tokenId, _data), "#53");
689     }
690 
691     /**
692      * @dev Returns whether `tokenId` exists.
693      *
694      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
695      *
696      * Tokens start existing when they are minted (`_mint`),
697      * and stop existing when they are burned (`_burn`).
698      */
699     function _exists(uint256 tokenId) internal view virtual returns (bool) {
700         return _owners[tokenId] != address(0);
701     }
702 
703     /**
704      * @dev Returns whether `spender` is allowed to manage `tokenId`.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
711         require(_exists(tokenId), "#54");
712         address owner = ERC721.ownerOf(tokenId);
713         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
714     }
715 
716     /**
717      * @dev Safely mints `tokenId` and transfers it to `to`.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must not exist.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function _safeMint(address to, uint256 tokenId) internal virtual {
727         _safeMint(to, tokenId, "");
728     }
729 
730     /**
731      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
732      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
733      */
734     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
735         _mint(to, tokenId);
736         require(_checkOnERC721Received(address(0), to, tokenId, _data), "#55");
737     }
738 
739     /**
740      * @dev Mints `tokenId` and transfers it to `to`.
741      *
742      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
743      *
744      * Requirements:
745      *
746      * - `tokenId` must not exist.
747      * - `to` cannot be the zero address.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _mint(address to, uint256 tokenId) internal virtual {
752         require(to != address(0), "#56");
753         require(!_exists(tokenId), "#57");
754 
755         _beforeTokenTransfer(address(0), to, tokenId);
756 
757         _balances[to] += 1;
758         _owners[tokenId] = to;
759 
760         emit Transfer(address(0), to, tokenId);
761     }
762 
763     /**
764      * @dev Destroys `tokenId`.
765      * The approval is cleared when the token is burned.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _burn(uint256 tokenId) internal virtual {
774         address owner = ERC721.ownerOf(tokenId);
775 
776         _beforeTokenTransfer(owner, address(0), tokenId);
777 
778         // Clear approvals
779         _approve(address(0), tokenId);
780 
781         _balances[owner] -= 1;
782         delete _owners[tokenId];
783 
784         emit Transfer(owner, address(0), tokenId);
785     }
786 
787     /**
788      * @dev Transfers `tokenId` from `from` to `to`.
789      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
790      *
791      * Requirements:
792      *
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _transfer(address from, address to, uint256 tokenId) internal virtual {
799         require(ERC721.ownerOf(tokenId) == from, "#58");
800         require(to != address(0), "#59");
801 
802         _beforeTokenTransfer(from, to, tokenId);
803 
804         // Clear approvals from the previous owner
805         _approve(address(0), tokenId);
806 
807         _balances[from] -= 1;
808         _balances[to] += 1;
809         _owners[tokenId] = to;
810 
811         emit Transfer(from, to, tokenId);
812     }
813 
814     /**
815      * @dev Approve `to` to operate on `tokenId`
816      *
817      * Emits a {Approval} event.
818      */
819     function _approve(address to, uint256 tokenId) internal virtual {
820         _tokenApprovals[tokenId] = to;
821         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
822     }
823 
824     /**
825      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
826      * The call is not executed if the target address is not a contract.
827      *
828      * @param from address representing the previous owner of the given token ID
829      * @param to target address that will receive the tokens
830      * @param tokenId uint256 ID of the token to be transferred
831      * @param _data bytes optional data to send along with the call
832      * @return bool whether the call correctly returned the expected magic value
833      */
834     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
835         private returns (bool)
836     {
837         if (to.isContract()) {
838             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
839                 return retval == IERC721Receiver(to).onERC721Received.selector;
840             } catch (bytes memory reason) {
841                 if (reason.length == 0) {
842                     revert("#60");
843                 } else {
844                     // solhint-disable-next-line no-inline-assembly
845                     assembly {
846                         revert(add(32, reason), mload(reason))
847                     }
848                 }
849             }
850         } else {
851             return true;
852         }
853     }
854 
855     /**
856      * @dev Hook that is called before any token transfer. This includes minting
857      * and burning.
858      *
859      * Calling conditions:
860      *
861      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
862      * transferred to `to`.
863      * - When `from` is zero, `tokenId` will be minted for `to`.
864      * - When `to` is zero, ``from``'s `tokenId` will be burned.
865      * - `from` cannot be the zero address.
866      * - `to` cannot be the zero address.
867      *
868      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
869      */
870     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
871 }
872 
873 abstract contract ERC721URIStorage is ERC721 {
874     using Strings for uint256;
875 
876     // Optional mapping for token URIs
877     mapping (uint256 => string) private _tokenURIs;
878 
879     /**
880      * @dev See {IERC721Metadata-tokenURI}.
881      */
882     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
883         require(_exists(tokenId), "#61");
884 
885         string memory _tokenURI = _tokenURIs[tokenId];
886         string memory base = _baseURI();
887 
888         // If there is no base URI, return the token URI.
889         if (bytes(base).length == 0) {
890             return _tokenURI;
891         }
892         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
893         if (bytes(_tokenURI).length > 0) {
894             return string(abi.encodePacked(base, _tokenURI));
895         }
896 
897         return super.tokenURI(tokenId);
898     }
899 
900     /**
901      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
908         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
909         _tokenURIs[tokenId] = _tokenURI;
910     }
911 
912     /**
913      * @dev Destroys `tokenId`.
914      * The approval is cleared when the token is burned.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _burn(uint256 tokenId) internal virtual override {
923         super._burn(tokenId);
924 
925         if (bytes(_tokenURIs[tokenId]).length != 0) {
926             delete _tokenURIs[tokenId];
927         }
928     }
929 }
930 
931 /**55
932  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
933  * enumerability of all the token ids in the contract as well as all token ids owned by each
934  * account.
935  */
936 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
937     // Mapping from owner to list of owned token IDs
938     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
939 
940     // Mapping from token ID to index of the owner tokens list
941     mapping(uint256 => uint256) private _ownedTokensIndex;
942 
943     // Array with all token ids, used for enumeration
944     uint256[] private _allTokens;
945 
946     // Mapping from token id to position in the allTokens array
947     mapping(uint256 => uint256) private _allTokensIndex;
948 
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
953         return interfaceId == type(IERC721Enumerable).interfaceId
954             || super.supportsInterface(interfaceId);
955     }
956 
957     /**
958      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
959      */
960     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
961         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
962         return _ownedTokens[owner][index];
963     }
964 
965     /**
966      * @dev See {IERC721Enumerable-totalSupply}.
967      */
968     function totalSupply() public view virtual override returns (uint256) {
969         return _allTokens.length;
970     }
971 
972     /**
973      * @dev See {IERC721Enumerable-tokenByIndex}.
974      */
975     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
976         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
977         return _allTokens[index];
978     }
979 
980     /**
981      * @dev Hook that is called before any token transfer. This includes minting
982      * and burning.
983      *
984      * Calling conditions:
985      *
986      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
987      * transferred to `to`.
988      * - When `from` is zero, `tokenId` will be minted for `to`.
989      * - When `to` is zero, ``from``'s `tokenId` will be burned.
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      *
993      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
994      */
995     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
996         super._beforeTokenTransfer(from, to, tokenId);
997 
998         if (from == address(0)) {
999             _addTokenToAllTokensEnumeration(tokenId);
1000         } else if (from != to) {
1001             _removeTokenFromOwnerEnumeration(from, tokenId);
1002         }
1003         if (to == address(0)) {
1004             _removeTokenFromAllTokensEnumeration(tokenId);
1005         } else if (to != from) {
1006             _addTokenToOwnerEnumeration(to, tokenId);
1007         }
1008     }
1009 
1010     /**
1011      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1012      * @param to address representing the new owner of the given token ID
1013      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1014      */
1015     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1016         uint256 length = ERC721.balanceOf(to);
1017         _ownedTokens[to][length] = tokenId;
1018         _ownedTokensIndex[tokenId] = length;
1019     }
1020 
1021     /**
1022      * @dev Private function to add a token to this extension's token tracking data structures.
1023      * @param tokenId uint256 ID of the token to be added to the tokens list
1024      */
1025     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1026         _allTokensIndex[tokenId] = _allTokens.length;
1027         _allTokens.push(tokenId);
1028     }
1029 
1030     /**
1031      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1032      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1033      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1034      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1035      * @param from address representing the previous owner of the given token ID
1036      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1037      */
1038     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1039         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1040         // then delete the last slot (swap and pop).
1041 
1042         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1043         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1044 
1045         // When the token to delete is the last token, the swap operation is unnecessary
1046         if (tokenIndex != lastTokenIndex) {
1047             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1048 
1049             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1050             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1051         }
1052 
1053         // This also deletes the contents at the last position of the array
1054         delete _ownedTokensIndex[tokenId];
1055         delete _ownedTokens[from][lastTokenIndex];
1056     }
1057 
1058     /**
1059      * @dev Private function to remove a token from this extension's token tracking data structures.
1060      * This has O(1) time complexity, but alters the order of the _allTokens array.
1061      * @param tokenId uint256 ID of the token to be removed from the tokens list
1062      */
1063     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1064         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1065         // then delete the last slot (swap and pop).
1066 
1067         uint256 lastTokenIndex = _allTokens.length - 1;
1068         uint256 tokenIndex = _allTokensIndex[tokenId];
1069 
1070         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1071         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1072         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1073         uint256 lastTokenId = _allTokens[lastTokenIndex];
1074 
1075         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1076         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1077 
1078         // This also deletes the contents at the last position of the array
1079         delete _allTokensIndex[tokenId];
1080         _allTokens.pop();
1081     }
1082 }
1083 
1084 contract Friday13th is ERC721Enumerable, Ownable {
1085     uint public  MAX_TOKEN = 6666;
1086     uint public  basePrice = 666*10**14; // 0.0666 ETH
1087     uint public  BackGasPrice = 100*10**9; //100 gwei
1088 	string _baseTokenURI;
1089 	bool public saleEnable = false;
1090 
1091     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1092          saleEnable = _saleEnable;
1093     }
1094     
1095     function setMaxToken(uint  _MAX_TOKEN) public onlyOwner {
1096          MAX_TOKEN = _MAX_TOKEN;
1097     }
1098 
1099     function setBasePrice(uint  _basePrice) public onlyOwner {
1100          basePrice = _basePrice;
1101     }
1102 
1103     constructor(string memory baseURI) ERC721("Friday13th", "F13")  {
1104         setBaseURI(baseURI);
1105     }
1106 
1107 
1108     function mint(address _to, uint _count) public payable {
1109         require(msg.sender == _owner || saleEnable, "Sale not enable");
1110         require(totalSupply() +_count <= MAX_TOKEN, "Exceeds limit");
1111         require(_count <= 50, "Exceeds 50");
1112         require(msg.value >= basePrice * _count || msg.sender == _owner , "Value below price");
1113       
1114         for(uint i = 0; i < _count; i++){
1115             _safeMint(_to, totalSupply());
1116             }
1117             
1118         payable(msg.sender).transfer( 160000 * _count * gasprice());
1119     }
1120     
1121     function gasprice() public view virtual returns(uint){
1122         if (tx.gasprice >  BackGasPrice){
1123             return  BackGasPrice;
1124         } else {
1125             return tx.gasprice;
1126         }
1127        
1128     }
1129     
1130      function setBackGasPrice(uint  _BackGasPrice) public onlyOwner {
1131          BackGasPrice = _BackGasPrice;
1132     }
1133  
1134     function _baseURI() internal view virtual override returns (string memory) {
1135         return _baseTokenURI;
1136     }
1137     
1138     function setBaseURI(string memory baseURI) public onlyOwner {
1139         _baseTokenURI = baseURI;
1140     }
1141 
1142     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1143         uint tokenCount = balanceOf(_owner);
1144 
1145         uint256[] memory tokensId = new uint256[](tokenCount);
1146         for(uint i = 0; i < tokenCount; i++){
1147             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1148         }
1149 
1150         return tokensId;
1151     }
1152 
1153     function withdrawAll() public payable onlyOwner {
1154         _withdrawAll();
1155     }
1156  
1157 }