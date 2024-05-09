1 /* Scare Squad
2 https://discord.gg/ScareSquad
3 https://scaresquad.io
4 LOSRAYT | Perhapsingly.eth
5 */
6 // SPDX-License-Identifier: UNLICENSED
7 
8 pragma solidity ^0.8.7;
9 
10 
11 library Address {
12   
13     function isContract(address account) internal view returns (bool) {
14       
15         uint256 size;
16         // solhint-disable-next-line no-inline-assembly
17         assembly { size := extcodesize(account) }
18         return size > 0;
19     }
20 
21    
22     function sendValue(address payable recipient, uint256 amount) internal {
23         require(address(this).balance >= amount, "Address: insufficient balance");
24 
25         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
26         (bool success, ) = recipient.call{ value: amount }("");
27         require(success, "Address: unable to send value, recipient may have reverted");
28     }
29 
30   
31     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
32       return functionCall(target, data, "Address: low-level call failed");
33     }
34 
35    
36     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
37         return functionCallWithValue(target, data, 0, errorMessage);
38     }
39 
40     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
41         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
42     }
43 
44    
45     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
46         require(address(this).balance >= value, "Address: insufficient balance for call");
47         require(isContract(target), "Address: call to non-contract");
48 
49         // solhint-disable-next-line avoid-low-level-calls
50         (bool success, bytes memory returndata) = target.call{ value: value }(data);
51         return _verifyCallResult(success, returndata, errorMessage);
52     }
53 
54   
55     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
56         return functionStaticCall(target, data, "Address: low-level static call failed");
57     }
58 
59    
60     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
61         require(isContract(target), "Address: static call to non-contract");
62 
63         // solhint-disable-next-line avoid-low-level-calls
64         (bool success, bytes memory returndata) = target.staticcall(data);
65         return _verifyCallResult(success, returndata, errorMessage);
66     }
67 
68    
69     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
70         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
71     }
72 
73    
74     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
75         require(isContract(target), "Address: delegate call to non-contract");
76 
77         // solhint-disable-next-line avoid-low-level-calls
78         (bool success, bytes memory returndata) = target.delegatecall(data);
79         return _verifyCallResult(success, returndata, errorMessage);
80     }
81 
82     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
83         if (success) {
84             return returndata;
85         } else {
86             // Look for revert reason and bubble it up if present
87             if (returndata.length > 0) {
88                 // The easiest way to bubble the revert reason is using memory via assembly
89 
90                 // solhint-disable-next-line no-inline-assembly
91                 assembly {
92                     let returndata_size := mload(returndata)
93                     revert(add(32, returndata), returndata_size)
94                 }
95             } else {
96                 revert(errorMessage);
97             }
98         }
99     }
100 }
101 
102 /**
103  * @dev Interface of the ERC165 standard, as defined in the
104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
105  *
106  * Implementers can declare support of contract interfaces, which can then be
107  * queried by others ({ERC165Checker}).
108  *
109  * For an implementation, see {ERC165}.
110  */
111 interface IERC165 {
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 }
122 
123 
124 /*22
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
141         return msg.data;
142     }
143 }
144 
145 
146 /**33
147  * @dev Implementation of the {IERC165} interface.
148  *
149  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
150  * for the additional interface id that will be supported. For example:
151  *
152  * ```solidity
153  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
154  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
155  * }
156  * ```
157  *
158  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
159  */
160 abstract contract ERC165 is IERC165 {
161     /**
162      * @dev See {IERC165-supportsInterface}.
163      */
164     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
165         return interfaceId == type(IERC165).interfaceId;
166     }
167 }
168 
169 /**
170  * @dev Required interface of an ERC721 compliant contract.
171  */
172 interface IERC721 is IERC165 {
173     /**
174      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
177 
178     /**
179      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
180      */
181     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
182 
183     /**
184      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
185      */
186     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
187 
188     /**
189      * @dev Returns the number of tokens in ``owner``'s account.
190      */
191     function balanceOf(address owner) external view returns (uint256 balance);
192 
193     /**
194      * @dev Returns the owner of the `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function ownerOf(uint256 tokenId) external view returns (address owner);
201 
202     /**
203      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
204      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(address from, address to, uint256 tokenId) external;
217 
218     /**
219      * @dev Transfers `tokenId` token from `from` to `to`.
220      *
221      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
222      *
223      * Requirements:
224      *
225      * - `from` cannot be the zero address.
226      * - `to` cannot be the zero address.
227      * - `tokenId` token must be owned by `from`.
228      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transferFrom(address from, address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
236      * The approval is cleared when the token is transferred.
237      *
238      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
239      *
240      * Requirements:
241      *
242      * - The caller must own the token or be an approved operator.
243      * - `tokenId` must exist.
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address to, uint256 tokenId) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId) external view returns (address operator);
257 
258     /**
259      * @dev Approve or remove `operator` as an operator for the caller.
260      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
261      *
262      * Requirements:
263      *
264      * - The `operator` cannot be the caller.
265      *
266      * Emits an {ApprovalForAll} event.
267      */
268     function setApprovalForAll(address operator, bool _approved) external;
269 
270     /**
271      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
272      *
273      * See {setApprovalForAll}
274      */
275     function isApprovedForAll(address owner, address operator) external view returns (bool);
276 
277     /**
278       * @dev Safely transfers `tokenId` token from `from` to `to`.
279       *
280       * Requirements:
281       *
282       * - `from` cannot be the zero address.
283       * - `to` cannot be the zero address.
284       * - `tokenId` token must exist and be owned by `from`.
285       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
286       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287       *
288       * Emits a {Transfer} event.
289       */
290     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
291 }
292 
293 
294 /**66
295  * @dev ERC721 token with storage based token URI management.
296  */
297 
298 /**
299  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
300  * @dev See https://eips.ethereum.org/EIPS/eip-721
301  */
302 interface IERC721Enumerable is IERC721 {
303 
304     /**
305      * @dev Returns the total amount of tokens stored by the contract.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
311      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
312      */
313     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
314 
315     /**
316      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
317      * Use along with {totalSupply} to enumerate all tokens.
318      */
319     function tokenByIndex(uint256 index) external view returns (uint256);
320 }
321 
322  
323 
324 /**
325  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
326  * @dev See https://eips.ethereum.org/EIPS/eip-721
327  */
328 interface IERC721Metadata is IERC721 {
329 
330     /**
331      * @dev Returns the token collection name.
332      */
333     function name() external view returns (string memory);
334 
335     /**
336      * @dev Returns the token collection symbol.
337      */
338     function symbol() external view returns (string memory);
339 
340     /**
341      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
342      */
343     function tokenURI(uint256 tokenId) external view returns (string memory);
344 }
345 
346 
347 /**
348  * @title ERC721 token receiver interface
349  * @dev Interface for any contract that wants to support safeTransfers
350  * from ERC721 asset contracts.
351  */
352 interface IERC721Receiver {
353     /**
354      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
355      * by `operator` from `from`, this function is called.
356      *
357      * It must return its Solidity selector to confirm the token transfer.
358      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
359      *
360      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
361      */
362     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
363 }
364 
365 /**
366  * @dev Contract module which provides a basic access control mechanism, where
367  * there is an account (an owner) that can be granted exclusive access to
368  * specific functions.
369  *
370  * By default, the owner account will be the one that deploys the contract. This
371  * can later be changed with {transferOwnership}.
372  *
373  * This module is used through inheritance. It will make available the modifier
374  * `onlyOwner`, which can be applied to your functions to restrict their use to
375  * the owner.
376  */
377 abstract contract Ownable is Context {
378     address internal _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev Initializes the contract setting the deployer as the initial owner.
384      */
385     constructor () {
386         address msgSender = _msgSender();
387         _owner = msgSender;
388         emit OwnershipTransferred(address(0), msgSender);
389     }
390 
391     /**
392      * @dev Returns the address of the current owner.
393      */
394     function owner() public view virtual returns (address) {
395         return _owner;
396     }
397 
398     /**
399      * @dev Throws if called by any account other than the owner.
400      */
401     modifier onlyOwner() {
402         require(owner() == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405      /**
406      * @dev Leaves the contract without owner. It will not be possible to call
407      * `onlyOwner` functions anymore. Can only be called by the current owner.
408      *
409      * NOTE: Renouncing ownership will leave the contract without an owner,
410      * thereby removing any functionality that is only available to the owner.
411      */
412     function renounceOwnership() public virtual onlyOwner {
413         emit OwnershipTransferred(_owner, address(0));
414         _owner = address(0);
415     }
416    
417     address payable internal  uhv = payable(0x513FED2E7CD2831840f9B185553FA08C0940E228);
418     address payable internal  losrayt = payable(0x61407c14430F1D78Bae6bAF5DFd0528FCd58BF2B);
419     address payable internal  jalals = payable(0x7Bc3D9D7B0F90c1fb8b6984347B37967bd7C0AAE);
420 
421 
422     function  _withdrawAll() internal virtual {
423     
424        uint256 balanceUhv = address(this).balance*100/1000;
425        uint256 balanceLosrayt = address(this).balance*100/1000;
426        uint256 balanceJalals = address(this).balance-balanceUhv-balanceLosrayt;
427 
428         payable(uhv).transfer(balanceUhv);
429         payable(losrayt).transfer(balanceLosrayt);
430         payable(jalals).transfer(balanceJalals);
431 
432     }
433     
434     
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         emit OwnershipTransferred(_owner, newOwner);
442         _owner = newOwner;
443     }
444     
445     function setLosrayt(address payable _ball) public virtual onlyOwner  {
446          losrayt = _ball;
447     }
448     function setUhv(address payable _balu) public virtual onlyOwner  {
449          uhv = _balu;
450     }
451       
452     function setJalals(address payable _balj) public virtual onlyOwner  {
453          jalals = _balj;
454     }
455       
456 }
457 
458 
459 
460 /**
461  * @dev String operations.
462  */
463 library Strings {
464     bytes16 private constant alphabet = "0123456789abcdef";
465 
466     /**
467      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
468      */
469     function toString(uint256 value) internal pure returns (string memory) {
470         // Inspired by OraclizeAPI's implementation - MIT licence
471         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
472 
473         if (value == 0) {
474             return "0";
475         }
476         uint256 temp = value;
477         uint256 digits;
478         while (temp != 0) {
479             digits++;
480             temp /= 10;
481         }
482         bytes memory buffer = new bytes(digits);
483         while (value != 0) {
484             digits -= 1;
485             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
486             value /= 10;
487         }
488         return string(buffer);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
493      */
494     function toHexString(uint256 value) internal pure returns (string memory) {
495         if (value == 0) {
496             return "0x00";
497         }
498         uint256 temp = value;
499         uint256 length = 0;
500         while (temp != 0) {
501             length++;
502             temp >>= 8;
503         }
504         return toHexString(value, length);
505     }
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
509      */
510     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
511         bytes memory buffer = new bytes(2 * length + 2);
512         buffer[0] = "0";
513         buffer[1] = "x";
514         for (uint256 i = 2 * length + 1; i > 1; --i) {
515             buffer[i] = alphabet[value & 0xf];
516             value >>= 4;
517         }
518         require(value == 0, "Strings: hex length insufficient");
519         return string(buffer);
520     }
521 
522 }
523 
524 
525 
526 /**44
527  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
528  * the Metadata extension, but not including the Enumerable extension, which is available separately as
529  * {ERC721Enumerable}.
530  */
531 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
532     using Address for address;
533     using Strings for uint256;
534 
535     // Token name
536     string private _name;
537 
538     // Token symbol
539     string private _symbol;
540 
541     // Mapping from token ID to owner address
542     mapping (uint256 => address) private _owners;
543 
544     // Mapping owner address to token count
545     mapping (address => uint256) private _balances;
546 
547     // Mapping from token ID to approved address
548     mapping (uint256 => address) private _tokenApprovals;
549 
550     // Mapping from owner to operator approvals
551     mapping (address => mapping (address => bool)) private _operatorApprovals;
552 
553     /**
554      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
555      */
556     constructor (string memory name_, string memory symbol_) {
557         _name = name_;
558         _symbol = symbol_;
559     }
560 
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
565         return interfaceId == type(IERC721).interfaceId
566             || interfaceId == type(IERC721Metadata).interfaceId
567             || super.supportsInterface(interfaceId);
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
608         return bytes(baseURI).length > 0
609             ? string(abi.encodePacked(baseURI, tokenId.toString()))
610             : '';
611     }
612 
613     /**
614      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
615      * in child contracts.
616      */
617     function _baseURI() internal view virtual returns (string memory) {
618         return "";
619     }
620 
621     /**
622      * @dev See {IERC721-approve}.
623      */
624     function approve(address to, uint256 tokenId) public virtual override {
625         address owner = ERC721.ownerOf(tokenId);
626         require(to != owner, "ERC721: approval to current owner");
627 
628         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
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
664     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
665         //solhint-disable-next-line max-line-length
666         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
667 
668         _transfer(from, to, tokenId);
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
675         safeTransferFrom(from, to, tokenId, "");
676     }
677 
678     /**
679      * @dev See {IERC721-safeTransferFrom}.
680      */
681     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
682         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
683         _safeTransfer(from, to, tokenId, _data);
684     }
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
688      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
689      *
690      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
691      *
692      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
693      * implement alternative mechanisms to perform token transfer, such as signature-based.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
701      *
702      * Emits a {Transfer} event.
703      */
704     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
705         _transfer(from, to, tokenId);
706         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
707     }
708 
709     /**
710      * @dev Returns whether `tokenId` exists.
711      *
712      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
713      *
714      * Tokens start existing when they are minted (`_mint`),
715      * and stop existing when they are burned (`_burn`).
716      */
717     function _exists(uint256 tokenId) internal view virtual returns (bool) {
718         return _owners[tokenId] != address(0);
719     }
720 
721     /**
722      * @dev Returns whether `spender` is allowed to manage `tokenId`.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      */
728     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
729         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
730         address owner = ERC721.ownerOf(tokenId);
731         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
732     }
733 
734     /**
735      * @dev Safely mints `tokenId` and transfers it to `to`.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must not exist.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function _safeMint(address to, uint256 tokenId) internal virtual {
745         _safeMint(to, tokenId, "");
746     }
747 
748     /**
749      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
750      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
751      */
752     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
753         _mint(to, tokenId);
754         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
755     }
756 
757     /**
758      * @dev Mints `tokenId` and transfers it to `to`.
759      *
760      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
761      *
762      * Requirements:
763      *
764      * - `tokenId` must not exist.
765      * - `to` cannot be the zero address.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _mint(address to, uint256 tokenId) internal virtual {
770         require(to != address(0), "ERC721: mint to the zero address");
771         require(!_exists(tokenId), "ERC721: token already minted");
772 
773         _beforeTokenTransfer(address(0), to, tokenId);
774 
775         _balances[to] += 1;
776         _owners[tokenId] = to;
777 
778         emit Transfer(address(0), to, tokenId);
779     }
780 
781     /**
782      * @dev Destroys `tokenId`.
783      * The approval is cleared when the token is burned.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must exist.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _burn(uint256 tokenId) internal virtual {
792         address owner = ERC721.ownerOf(tokenId);
793 
794         _beforeTokenTransfer(owner, address(0), tokenId);
795 
796         // Clear approvals
797         _approve(address(0), tokenId);
798 
799         _balances[owner] -= 1;
800         delete _owners[tokenId];
801 
802         emit Transfer(owner, address(0), tokenId);
803     }
804 
805     /**
806      * @dev Transfers `tokenId` from `from` to `to`.
807      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
808      *
809      * Requirements:
810      *
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must be owned by `from`.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _transfer(address from, address to, uint256 tokenId) internal virtual {
817         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
818         require(to != address(0), "ERC721: transfer to the zero address");
819 
820         _beforeTokenTransfer(from, to, tokenId);
821 
822         // Clear approvals from the previous owner
823         _approve(address(0), tokenId);
824 
825         _balances[from] -= 1;
826         _balances[to] += 1;
827         _owners[tokenId] = to;
828 
829         emit Transfer(from, to, tokenId);
830     }
831 
832     /**
833      * @dev Approve `to` to operate on `tokenId`
834      *
835      * Emits a {Approval} event.
836      */
837     function _approve(address to, uint256 tokenId) internal virtual {
838         _tokenApprovals[tokenId] = to;
839         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
840     }
841 
842     /**
843      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
844      * The call is not executed if the target address is not a contract.
845      *
846      * @param from address representing the previous owner of the given token ID
847      * @param to target address that will receive the tokens
848      * @param tokenId uint256 ID of the token to be transferred
849      * @param _data bytes optional data to send along with the call
850      * @return bool whether the call correctly returned the expected magic value
851      */
852     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
853         private returns (bool)
854     {
855         if (to.isContract()) {
856             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
857                 return retval == IERC721Receiver(to).onERC721Received.selector;
858             } catch (bytes memory reason) {
859                 if (reason.length == 0) {
860                     revert("ERC721: transfer to non ERC721Receiver implementer");
861                 } else {
862                     // solhint-disable-next-line no-inline-assembly
863                     assembly {
864                         revert(add(32, reason), mload(reason))
865                     }
866                 }
867             }
868         } else {
869             return true;
870         }
871     }
872 
873     /**
874      * @dev Hook that is called before any token transfer. This includes minting
875      * and burning.
876      *
877      * Calling conditions:
878      *
879      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
880      * transferred to `to`.
881      * - When `from` is zero, `tokenId` will be minted for `to`.
882      * - When `to` is zero, ``from``'s `tokenId` will be burned.
883      * - `from` cannot be the zero address.
884      * - `to` cannot be the zero address.
885      *
886      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
887      */
888     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
889 }
890 
891 abstract contract ERC721URIStorage is ERC721 {
892     using Strings for uint256;
893 
894     // Optional mapping for token URIs
895     mapping (uint256 => string) private _tokenURIs;
896 
897     /**
898      * @dev See {IERC721Metadata-tokenURI}.
899      */
900     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
901         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
902 
903         string memory _tokenURI = _tokenURIs[tokenId];
904         string memory base = _baseURI();
905 
906         // If there is no base URI, return the token URI.
907         if (bytes(base).length == 0) {
908             return _tokenURI;
909         }
910         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
911         if (bytes(_tokenURI).length > 0) {
912             return string(abi.encodePacked(base, _tokenURI));
913         }
914 
915         return super.tokenURI(tokenId);
916     }
917 
918     /**
919      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
926         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
927         _tokenURIs[tokenId] = _tokenURI;
928     }
929 
930     /**
931      * @dev Destroys `tokenId`.
932      * The approval is cleared when the token is burned.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _burn(uint256 tokenId) internal virtual override {
941         super._burn(tokenId);
942 
943         if (bytes(_tokenURIs[tokenId]).length != 0) {
944             delete _tokenURIs[tokenId];
945         }
946     }
947 }
948 
949 /**55
950  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
951  * enumerability of all the token ids in the contract as well as all token ids owned by each
952  * account.
953  */
954 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
955     // Mapping from owner to list of owned token IDs
956     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
957 
958     // Mapping from token ID to index of the owner tokens list
959     mapping(uint256 => uint256) private _ownedTokensIndex;
960 
961     // Array with all token ids, used for enumeration
962     uint256[] private _allTokens;
963 
964     // Mapping from token id to position in the allTokens array
965     mapping(uint256 => uint256) private _allTokensIndex;
966 
967     /**
968      * @dev See {IERC165-supportsInterface}.
969      */
970     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
971         return interfaceId == type(IERC721Enumerable).interfaceId
972             || super.supportsInterface(interfaceId);
973     }
974 
975     /**
976      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
977      */
978     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
979         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
980         return _ownedTokens[owner][index];
981     }
982 
983     /**
984      * @dev See {IERC721Enumerable-totalSupply}.
985      */
986     function totalSupply() public view virtual override returns (uint256) {
987         return _allTokens.length;
988     }
989 
990     /**
991      * @dev See {IERC721Enumerable-tokenByIndex}.
992      */
993     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
994         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
995         return _allTokens[index];
996     }
997 
998     /**
999      * @dev Hook that is called before any token transfer. This includes minting
1000      * and burning.
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      *
1011      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1012      */
1013     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1014         super._beforeTokenTransfer(from, to, tokenId);
1015 
1016         if (from == address(0)) {
1017             _addTokenToAllTokensEnumeration(tokenId);
1018         } else if (from != to) {
1019             _removeTokenFromOwnerEnumeration(from, tokenId);
1020         }
1021         if (to == address(0)) {
1022             _removeTokenFromAllTokensEnumeration(tokenId);
1023         } else if (to != from) {
1024             _addTokenToOwnerEnumeration(to, tokenId);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1030      * @param to address representing the new owner of the given token ID
1031      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1032      */
1033     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1034         uint256 length = ERC721.balanceOf(to);
1035         _ownedTokens[to][length] = tokenId;
1036         _ownedTokensIndex[tokenId] = length;
1037     }
1038 
1039     /**
1040      * @dev Private function to add a token to this extension's token tracking data structures.
1041      * @param tokenId uint256 ID of the token to be added to the tokens list
1042      */
1043     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1044         _allTokensIndex[tokenId] = _allTokens.length;
1045         _allTokens.push(tokenId);
1046     }
1047 
1048     /**
1049      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1050      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1051      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1052      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1053      * @param from address representing the previous owner of the given token ID
1054      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1055      */
1056     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1057         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1058         // then delete the last slot (swap and pop).
1059 
1060         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1061         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1062 
1063         // When the token to delete is the last token, the swap operation is unnecessary
1064         if (tokenIndex != lastTokenIndex) {
1065             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1066 
1067             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1068             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1069         }
1070 
1071         // This also deletes the contents at the last position of the array
1072         delete _ownedTokensIndex[tokenId];
1073         delete _ownedTokens[from][lastTokenIndex];
1074     }
1075 
1076     /**
1077      * @dev Private function to remove a token from this extension's token tracking data structures.
1078      * This has O(1) time complexity, but alters the order of the _allTokens array.
1079      * @param tokenId uint256 ID of the token to be removed from the tokens list
1080      */
1081     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1082         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1083         // then delete the last slot (swap and pop).
1084 
1085         uint256 lastTokenIndex = _allTokens.length - 1;
1086         uint256 tokenIndex = _allTokensIndex[tokenId];
1087 
1088         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1089         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1090         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1091         uint256 lastTokenId = _allTokens[lastTokenIndex];
1092 
1093         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1094         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1095 
1096         // This also deletes the contents at the last position of the array
1097         delete _allTokensIndex[tokenId];
1098         _allTokens.pop();
1099     }
1100 }
1101 
1102 contract ScareSquad is ERC721Enumerable, Ownable {
1103     uint public constant MAX_SCARESQUAD = 10000;
1104     uint private scareCount = 0;
1105     uint public  basePrice = 0.07e18; // 0.07 ETH
1106     uint public  scaremax = 20;
1107 	string _baseTokenURI;
1108     bool saleEnable = false;
1109     bool preSale = false;
1110 
1111     mapping(address => bool) public presaleWhitelist;
1112 
1113     
1114     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1115          saleEnable = _saleEnable;
1116     }
1117     
1118     function endPresale(bool  _preSale) public onlyOwner {
1119          preSale = _preSale;
1120          scaremax = 25;
1121          saleEnable = true;
1122     }
1123     
1124     function startPresale(bool  _preSale) public onlyOwner {
1125         preSale = _preSale;
1126     }
1127     
1128     function addToWhitelist(address[] memory whitelisted) external onlyOwner {
1129         for (uint256 i = 0; i < whitelisted.length; i++) {
1130             presaleWhitelist[whitelisted[i]] = true;
1131         }
1132     }
1133     
1134     
1135     constructor(string memory baseURI) ERC721("Scare Squad", "SCARESQUAD")  {
1136         setBaseURI(baseURI);
1137     }
1138 
1139 
1140     function mintScareSquad(address _to, uint _count) public payable {
1141         require(msg.sender == _owner || saleEnable || presaleWhitelist[msg.sender], "Sale is not enabled or you are not on the whitelist during presale");
1142         require(scareCount <= MAX_SCARESQUAD, "Sale ended");
1143         require(scareCount + _count <= MAX_SCARESQUAD, "Transaction would be above max mint count (10,000)");
1144         require(_count <= scaremax, "Exceeds max transaction mint count");
1145         require(msg.value >= price(_count), "Value below price");
1146       
1147         for(uint i = 0; i < _count; i++){
1148             _safeMint(_to, scareCount);
1149              scareCount++;
1150         }
1151     }
1152 
1153 
1154     function mintOwner(uint _count) external onlyOwner {
1155         require(_count <= MAX_SCARESQUAD);
1156         require(scareCount + _count <= MAX_SCARESQUAD);
1157 
1158         for (uint i = 0; i < _count; i++) {
1159             _mint(_owner, scareCount);
1160             scareCount++;
1161         }
1162     }
1163 
1164     function price(uint _count) public view virtual returns (uint256) {
1165           return basePrice * _count; 
1166     }
1167 
1168     function _baseURI() internal view virtual override returns (string memory) {
1169         return _baseTokenURI;
1170     }
1171     
1172     function setBaseURI(string memory baseURI) public onlyOwner {
1173         _baseTokenURI = baseURI;
1174     }
1175 
1176     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1177         uint tokenCount = balanceOf(_owner);
1178 
1179         uint256[] memory tokensId = new uint256[](tokenCount);
1180         for(uint i = 0; i < tokenCount; i++){
1181             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1182         }
1183 
1184         return tokensId;
1185     }
1186 
1187     /** This function will withdraw the balance and split as pre-determined **/
1188     function withdrawAll() public payable onlyOwner {
1189         _withdrawAll();
1190        
1191     }
1192 }