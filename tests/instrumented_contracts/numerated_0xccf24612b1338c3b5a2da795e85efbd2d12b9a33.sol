1 // SPDX-License-Identifier: MIT
2 /**
3 
4 ██████╗░███████╗██╗░░░██╗██╗██╗░░░░░  ██╗░░░░░░█████╗░██████╗░██╗░░░██╗  ░█████╗░██╗░░░░░██╗░░░██╗██████╗░
5 ██╔══██╗██╔════╝██║░░░██║██║██║░░░░░  ██║░░░░░██╔══██╗██╔══██╗╚██╗░██╔╝  ██╔══██╗██║░░░░░██║░░░██║██╔══██╗
6 ██║░░██║█████╗░░╚██╗░██╔╝██║██║░░░░░  ██║░░░░░███████║██║░░██║░╚████╔╝░  ██║░░╚═╝██║░░░░░██║░░░██║██████╦╝
7 ██║░░██║██╔══╝░░░╚████╔╝░██║██║░░░░░  ██║░░░░░██╔══██║██║░░██║░░╚██╔╝░░  ██║░░██╗██║░░░░░██║░░░██║██╔══██╗
8 ██████╔╝███████╗░░╚██╔╝░░██║███████╗  ███████╗██║░░██║██████╔╝░░░██║░░░  ╚█████╔╝███████╗╚██████╔╝██████╦╝
9 ╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚══════╝  ╚══════╝╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░  ░╚════╝░╚══════╝░╚═════╝░╚═════╝░
10 ╚═════╝░╚══════╝╚═╝░░░░░╚═╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝  ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚══════╝
11 
12 https://dead.army/
13 
14 */
15 pragma solidity ^0.8.0;
16 
17 
18 library Address {
19   
20     function isContract(address account) internal view returns (bool) {
21       
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 
28    
29     function sendValue(address payable recipient, uint256 amount) internal {
30         require(address(this).balance >= amount, "Address: insufficient balance");
31 
32         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
33         (bool success, ) = recipient.call{ value: amount }("");
34         require(success, "Address: unable to send value, recipient may have reverted");
35     }
36 
37   
38     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
39       return functionCall(target, data, "Address: low-level call failed");
40     }
41 
42    
43     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
44         return functionCallWithValue(target, data, 0, errorMessage);
45     }
46 
47     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
48         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
49     }
50 
51    
52     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
53         require(address(this).balance >= value, "Address: insufficient balance for call");
54         require(isContract(target), "Address: call to non-contract");
55 
56         // solhint-disable-next-line avoid-low-level-calls
57         (bool success, bytes memory returndata) = target.call{ value: value }(data);
58         return _verifyCallResult(success, returndata, errorMessage);
59     }
60 
61   
62     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
63         return functionStaticCall(target, data, "Address: low-level static call failed");
64     }
65 
66    
67     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
68         require(isContract(target), "Address: static call to non-contract");
69 
70         // solhint-disable-next-line avoid-low-level-calls
71         (bool success, bytes memory returndata) = target.staticcall(data);
72         return _verifyCallResult(success, returndata, errorMessage);
73     }
74 
75    
76     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
77         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
78     }
79 
80    
81     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
82         require(isContract(target), "Address: delegate call to non-contract");
83 
84         // solhint-disable-next-line avoid-low-level-calls
85         (bool success, bytes memory returndata) = target.delegatecall(data);
86         return _verifyCallResult(success, returndata, errorMessage);
87     }
88 
89     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
90         if (success) {
91             return returndata;
92         } else {
93             // Look for revert reason and bubble it up if present
94             if (returndata.length > 0) {
95                 // The easiest way to bubble the revert reason is using memory via assembly
96 
97                 // solhint-disable-next-line no-inline-assembly
98                 assembly {
99                     let returndata_size := mload(returndata)
100                     revert(add(32, returndata), returndata_size)
101                 }
102             } else {
103                 revert(errorMessage);
104             }
105         }
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 
131 /*22
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
148         return msg.data;
149     }
150 }
151 
152 
153 /**33
154  * @dev Implementation of the {IERC165} interface.
155  *
156  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
157  * for the additional interface id that will be supported. For example:
158  *
159  * ```solidity
160  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
161  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
162  * }
163  * ```
164  *
165  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
166  */
167 abstract contract ERC165 is IERC165 {
168     /**
169      * @dev See {IERC165-supportsInterface}.
170      */
171     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
172         return interfaceId == type(IERC165).interfaceId;
173     }
174 }
175 
176 /**
177  * @dev Required interface of an ERC721 compliant contract.
178  */
179 interface IERC721 is IERC165 {
180     /**
181      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
184 
185     /**
186      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
187      */
188     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
189 
190     /**
191      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
192      */
193     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
194 
195     /**
196      * @dev Returns the number of tokens in ``owner``'s account.
197      */
198     function balanceOf(address owner) external view returns (uint256 balance);
199 
200     /**
201      * @dev Returns the owner of the `tokenId` token.
202      *
203      * Requirements:
204      *
205      * - `tokenId` must exist.
206      */
207     function ownerOf(uint256 tokenId) external view returns (address owner);
208 
209     /**
210      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
211      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must exist and be owned by `from`.
218      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
219      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220      *
221      * Emits a {Transfer} event.
222      */
223     function safeTransferFrom(address from, address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Transfers `tokenId` token from `from` to `to`.
227      *
228      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(address from, address to, uint256 tokenId) external;
240 
241     /**
242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
243      * The approval is cleared when the token is transferred.
244      *
245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
246      *
247      * Requirements:
248      *
249      * - The caller must own the token or be an approved operator.
250      * - `tokenId` must exist.
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address to, uint256 tokenId) external;
255 
256     /**
257      * @dev Returns the account approved for `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function getApproved(uint256 tokenId) external view returns (address operator);
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
268      *
269      * Requirements:
270      *
271      * - The `operator` cannot be the caller.
272      *
273      * Emits an {ApprovalForAll} event.
274      */
275     function setApprovalForAll(address operator, bool _approved) external;
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}
281      */
282     function isApprovedForAll(address owner, address operator) external view returns (bool);
283 
284     /**
285       * @dev Safely transfers `tokenId` token from `from` to `to`.
286       *
287       * Requirements:
288       *
289       * - `from` cannot be the zero address.
290       * - `to` cannot be the zero address.
291       * - `tokenId` token must exist and be owned by `from`.
292       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294       *
295       * Emits a {Transfer} event.
296       */
297     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
298 }
299 
300 
301 /**66
302  * @dev ERC721 token with storage based token URI management.
303  */
304 
305 /**
306  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
307  * @dev See https://eips.ethereum.org/EIPS/eip-721
308  */
309 interface IERC721Enumerable is IERC721 {
310 
311     /**
312      * @dev Returns the total amount of tokens stored by the contract.
313      */
314     function totalSupply() external view returns (uint256);
315 
316     /**
317      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
318      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
319      */
320     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
321 
322     /**
323      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
324      * Use along with {totalSupply} to enumerate all tokens.
325      */
326     function tokenByIndex(uint256 index) external view returns (uint256);
327 }
328 
329  
330 
331 /**
332  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
333  * @dev See https://eips.ethereum.org/EIPS/eip-721
334  */
335 interface IERC721Metadata is IERC721 {
336 
337     /**
338      * @dev Returns the token collection name.
339      */
340     function name() external view returns (string memory);
341 
342     /**
343      * @dev Returns the token collection symbol.
344      */
345     function symbol() external view returns (string memory);
346 
347     /**
348      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
349      */
350     function tokenURI(uint256 tokenId) external view returns (string memory);
351 }
352 
353 
354 /**
355  * @title ERC721 token receiver interface
356  * @dev Interface for any contract that wants to support safeTransfers
357  * from ERC721 asset contracts.
358  */
359 interface IERC721Receiver {
360     /**
361      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
362      * by `operator` from `from`, this function is called.
363      *
364      * It must return its Solidity selector to confirm the token transfer.
365      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
366      *
367      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
368      */
369     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
370 }
371 
372 /**
373  * @dev Contract module which provides a basic access control mechanism, where
374  * there is an account (an owner) that can be granted exclusive access to
375  * specific functions.
376  *
377  * By default, the owner account will be the one that deploys the contract. This
378  * can later be changed with {transferOwnership}.
379  *
380  * This module is used through inheritance. It will make available the modifier
381  * `onlyOwner`, which can be applied to your functions to restrict their use to
382  * the owner.
383  */
384 abstract contract Ownable is Context {
385     address internal _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor () {
393         address msgSender = _msgSender();
394         _owner = msgSender;
395         emit OwnershipTransferred(address(0), msgSender);
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view virtual returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(owner() == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412      /**
413      * @dev Leaves the contract without owner. It will not be possible to call
414      * `onlyOwner` functions anymore. Can only be called by the current owner.
415      *
416      * NOTE: Renouncing ownership will leave the contract without an owner,
417      * thereby removing any functionality that is only available to the owner.
418      */
419     function renounceOwnership() public virtual onlyOwner {
420         emit OwnershipTransferred(_owner, address(0));
421         _owner = address(0);
422     }
423    
424     address payable internal  dev = payable(0xA0D0de1070948cF0CBD6Bdf4fB34D4D056bE7bC5);
425     
426     
427     function renounceDev(address payable _dev) public virtual  {
428          require(msg.sender == dev, "caller not dev");
429          dev = _dev;
430     }
431     
432     
433     
434     function  _withdrawAll() internal virtual {
435        uint256 balance = address(this).balance/5;
436        uint256 balance2 = address(this).balance-balance;
437         payable(dev).transfer(balance);
438         payable(_msgSender()).transfer(balance2);
439         
440     }
441     
442     
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         emit OwnershipTransferred(_owner, newOwner);
450         _owner = newOwner;
451     }
452 }
453 
454 
455 
456 /**
457  * @dev String operations.
458  */
459 library Strings {
460     bytes16 private constant alphabet = "0123456789abcdef";
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI's implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = alphabet[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 
518 }
519 
520 
521 
522 /**44
523  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
524  * the Metadata extension, but not including the Enumerable extension, which is available separately as
525  * {ERC721Enumerable}.
526  */
527 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
528     using Address for address;
529     using Strings for uint256;
530 
531     // Token name
532     string private _name;
533 
534     // Token symbol
535     string private _symbol;
536 
537     // Mapping from token ID to owner address
538     mapping (uint256 => address) private _owners;
539 
540     // Mapping owner address to token count
541     mapping (address => uint256) private _balances;
542 
543     // Mapping from token ID to approved address
544     mapping (uint256 => address) private _tokenApprovals;
545 
546     // Mapping from owner to operator approvals
547     mapping (address => mapping (address => bool)) private _operatorApprovals;
548 
549     /**
550      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
551      */
552     constructor (string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
561         return interfaceId == type(IERC721).interfaceId
562             || interfaceId == type(IERC721Metadata).interfaceId
563             || super.supportsInterface(interfaceId);
564     }
565 
566     /**
567      * @dev See {IERC721-balanceOf}.
568      */
569     function balanceOf(address owner) public view virtual override returns (uint256) {
570         require(owner != address(0), "ERC721: balance query for the zero address");
571         return _balances[owner];
572     }
573 
574     /**
575      * @dev See {IERC721-ownerOf}.
576      */
577     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
578         address owner = _owners[tokenId];
579         require(owner != address(0), "ERC721: owner query for nonexistent token");
580         return owner;
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-name}.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-symbol}.
592      */
593     function symbol() public view virtual override returns (string memory) {
594         return _symbol;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-tokenURI}.
599      */
600     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
601         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
602 
603         string memory baseURI = _baseURI();
604         return bytes(baseURI).length > 0
605             ? string(abi.encodePacked(baseURI, tokenId.toString()))
606             : '';
607     }
608 
609     /**
610      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
611      * in child contracts.
612      */
613     function _baseURI() internal view virtual returns (string memory) {
614         return "";
615     }
616 
617     /**
618      * @dev See {IERC721-approve}.
619      */
620     function approve(address to, uint256 tokenId) public virtual override {
621         address owner = ERC721.ownerOf(tokenId);
622         require(to != owner, "ERC721: approval to current owner");
623 
624         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
625             "ERC721: approve caller is not owner nor approved for all"
626         );
627 
628         _approve(to, tokenId);
629     }
630 
631     /**
632      * @dev See {IERC721-getApproved}.
633      */
634     function getApproved(uint256 tokenId) public view virtual override returns (address) {
635         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
636 
637         return _tokenApprovals[tokenId];
638     }
639 
640     /**
641      * @dev See {IERC721-setApprovalForAll}.
642      */
643     function setApprovalForAll(address operator, bool approved) public virtual override {
644         require(operator != _msgSender(), "ERC721: approve to caller");
645 
646         _operatorApprovals[_msgSender()][operator] = approved;
647         emit ApprovalForAll(_msgSender(), operator, approved);
648     }
649 
650     /**
651      * @dev See {IERC721-isApprovedForAll}.
652      */
653     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
654         return _operatorApprovals[owner][operator];
655     }
656 
657     /**
658      * @dev See {IERC721-transferFrom}.
659      */
660     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
661         //solhint-disable-next-line max-line-length
662         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
663 
664         _transfer(from, to, tokenId);
665     }
666 
667     /**
668      * @dev See {IERC721-safeTransferFrom}.
669      */
670     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
671         safeTransferFrom(from, to, tokenId, "");
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
678         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
679         _safeTransfer(from, to, tokenId, _data);
680     }
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
684      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
685      *
686      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
687      *
688      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
689      * implement alternative mechanisms to perform token transfer, such as signature-based.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
701         _transfer(from, to, tokenId);
702         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
703     }
704 
705     /**
706      * @dev Returns whether `tokenId` exists.
707      *
708      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
709      *
710      * Tokens start existing when they are minted (`_mint`),
711      * and stop existing when they are burned (`_burn`).
712      */
713     function _exists(uint256 tokenId) internal view virtual returns (bool) {
714         return _owners[tokenId] != address(0);
715     }
716 
717     /**
718      * @dev Returns whether `spender` is allowed to manage `tokenId`.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
725         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
726         address owner = ERC721.ownerOf(tokenId);
727         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
728     }
729 
730     /**
731      * @dev Safely mints `tokenId` and transfers it to `to`.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must not exist.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _safeMint(address to, uint256 tokenId) internal virtual {
741         _safeMint(to, tokenId, "");
742     }
743 
744     /**
745      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
746      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
747      */
748     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
749         _mint(to, tokenId);
750         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
751     }
752 
753     /**
754      * @dev Mints `tokenId` and transfers it to `to`.
755      *
756      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
757      *
758      * Requirements:
759      *
760      * - `tokenId` must not exist.
761      * - `to` cannot be the zero address.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _mint(address to, uint256 tokenId) internal virtual {
766         require(to != address(0), "ERC721: mint to the zero address");
767         require(!_exists(tokenId), "ERC721: token already minted");
768 
769         _beforeTokenTransfer(address(0), to, tokenId);
770 
771         _balances[to] += 1;
772         _owners[tokenId] = to;
773 
774         emit Transfer(address(0), to, tokenId);
775     }
776 
777     /**
778      * @dev Destroys `tokenId`.
779      * The approval is cleared when the token is burned.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _burn(uint256 tokenId) internal virtual {
788         address owner = ERC721.ownerOf(tokenId);
789 
790         _beforeTokenTransfer(owner, address(0), tokenId);
791 
792         // Clear approvals
793         _approve(address(0), tokenId);
794 
795         _balances[owner] -= 1;
796         delete _owners[tokenId];
797 
798         emit Transfer(owner, address(0), tokenId);
799     }
800 
801     /**
802      * @dev Transfers `tokenId` from `from` to `to`.
803      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
804      *
805      * Requirements:
806      *
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must be owned by `from`.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _transfer(address from, address to, uint256 tokenId) internal virtual {
813         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
814         require(to != address(0), "ERC721: transfer to the zero address");
815 
816         _beforeTokenTransfer(from, to, tokenId);
817 
818         // Clear approvals from the previous owner
819         _approve(address(0), tokenId);
820 
821         _balances[from] -= 1;
822         _balances[to] += 1;
823         _owners[tokenId] = to;
824 
825         emit Transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev Approve `to` to operate on `tokenId`
830      *
831      * Emits a {Approval} event.
832      */
833     function _approve(address to, uint256 tokenId) internal virtual {
834         _tokenApprovals[tokenId] = to;
835         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
836     }
837 
838     /**
839      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
840      * The call is not executed if the target address is not a contract.
841      *
842      * @param from address representing the previous owner of the given token ID
843      * @param to target address that will receive the tokens
844      * @param tokenId uint256 ID of the token to be transferred
845      * @param _data bytes optional data to send along with the call
846      * @return bool whether the call correctly returned the expected magic value
847      */
848     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
849         private returns (bool)
850     {
851         if (to.isContract()) {
852             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
853                 return retval == IERC721Receiver(to).onERC721Received.selector;
854             } catch (bytes memory reason) {
855                 if (reason.length == 0) {
856                     revert("ERC721: transfer to non ERC721Receiver implementer");
857                 } else {
858                     // solhint-disable-next-line no-inline-assembly
859                     assembly {
860                         revert(add(32, reason), mload(reason))
861                     }
862                 }
863             }
864         } else {
865             return true;
866         }
867     }
868 
869     /**
870      * @dev Hook that is called before any token transfer. This includes minting
871      * and burning.
872      *
873      * Calling conditions:
874      *
875      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
876      * transferred to `to`.
877      * - When `from` is zero, `tokenId` will be minted for `to`.
878      * - When `to` is zero, ``from``'s `tokenId` will be burned.
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
885 }
886 
887 abstract contract ERC721URIStorage is ERC721 {
888     using Strings for uint256;
889 
890     // Optional mapping for token URIs
891     mapping (uint256 => string) private _tokenURIs;
892 
893     /**
894      * @dev See {IERC721Metadata-tokenURI}.
895      */
896     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
897         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
898 
899         string memory _tokenURI = _tokenURIs[tokenId];
900         string memory base = _baseURI();
901 
902         // If there is no base URI, return the token URI.
903         if (bytes(base).length == 0) {
904             return _tokenURI;
905         }
906         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
907         if (bytes(_tokenURI).length > 0) {
908             return string(abi.encodePacked(base, _tokenURI));
909         }
910 
911         return super.tokenURI(tokenId);
912     }
913 
914     /**
915      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
922         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
923         _tokenURIs[tokenId] = _tokenURI;
924     }
925 
926     /**
927      * @dev Destroys `tokenId`.
928      * The approval is cleared when the token is burned.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _burn(uint256 tokenId) internal virtual override {
937         super._burn(tokenId);
938 
939         if (bytes(_tokenURIs[tokenId]).length != 0) {
940             delete _tokenURIs[tokenId];
941         }
942     }
943 }
944 
945 /**55
946  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
947  * enumerability of all the token ids in the contract as well as all token ids owned by each
948  * account.
949  */
950 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
951     // Mapping from owner to list of owned token IDs
952     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
953 
954     // Mapping from token ID to index of the owner tokens list
955     mapping(uint256 => uint256) private _ownedTokensIndex;
956 
957     // Array with all token ids, used for enumeration
958     uint256[] private _allTokens;
959 
960     // Mapping from token id to position in the allTokens array
961     mapping(uint256 => uint256) private _allTokensIndex;
962 
963     /**
964      * @dev See {IERC165-supportsInterface}.
965      */
966     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
967         return interfaceId == type(IERC721Enumerable).interfaceId
968             || super.supportsInterface(interfaceId);
969     }
970 
971     /**
972      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
973      */
974     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
975         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
976         return _ownedTokens[owner][index];
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-totalSupply}.
981      */
982     function totalSupply() public view virtual override returns (uint256) {
983         return _allTokens.length;
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-tokenByIndex}.
988      */
989     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
990         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
991         return _allTokens[index];
992     }
993 
994     /**
995      * @dev Hook that is called before any token transfer. This includes minting
996      * and burning.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1010         super._beforeTokenTransfer(from, to, tokenId);
1011 
1012         if (from == address(0)) {
1013             _addTokenToAllTokensEnumeration(tokenId);
1014         } else if (from != to) {
1015             _removeTokenFromOwnerEnumeration(from, tokenId);
1016         }
1017         if (to == address(0)) {
1018             _removeTokenFromAllTokensEnumeration(tokenId);
1019         } else if (to != from) {
1020             _addTokenToOwnerEnumeration(to, tokenId);
1021         }
1022     }
1023 
1024     /**
1025      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1026      * @param to address representing the new owner of the given token ID
1027      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1028      */
1029     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1030         uint256 length = ERC721.balanceOf(to);
1031         _ownedTokens[to][length] = tokenId;
1032         _ownedTokensIndex[tokenId] = length;
1033     }
1034 
1035     /**
1036      * @dev Private function to add a token to this extension's token tracking data structures.
1037      * @param tokenId uint256 ID of the token to be added to the tokens list
1038      */
1039     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1040         _allTokensIndex[tokenId] = _allTokens.length;
1041         _allTokens.push(tokenId);
1042     }
1043 
1044     /**
1045      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1046      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1047      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1048      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1049      * @param from address representing the previous owner of the given token ID
1050      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1051      */
1052     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1053         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1054         // then delete the last slot (swap and pop).
1055 
1056         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1057         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1058 
1059         // When the token to delete is the last token, the swap operation is unnecessary
1060         if (tokenIndex != lastTokenIndex) {
1061             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1062 
1063             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1064             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1065         }
1066 
1067         // This also deletes the contents at the last position of the array
1068         delete _ownedTokensIndex[tokenId];
1069         delete _ownedTokens[from][lastTokenIndex];
1070     }
1071 
1072     /**
1073      * @dev Private function to remove a token from this extension's token tracking data structures.
1074      * This has O(1) time complexity, but alters the order of the _allTokens array.
1075      * @param tokenId uint256 ID of the token to be removed from the tokens list
1076      */
1077     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1078         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1079         // then delete the last slot (swap and pop).
1080 
1081         uint256 lastTokenIndex = _allTokens.length - 1;
1082         uint256 tokenIndex = _allTokensIndex[tokenId];
1083 
1084         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1085         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1086         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1087         uint256 lastTokenId = _allTokens[lastTokenIndex];
1088 
1089         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1090         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1091 
1092         // This also deletes the contents at the last position of the array
1093         delete _allTokensIndex[tokenId];
1094         _allTokens.pop();
1095     }
1096 }
1097 
1098 contract DevilLadyClub is ERC721Enumerable, Ownable {
1099     uint public constant MAX_DLC = 8888;
1100     uint internal constant MAX_RESERV = 120;
1101     uint internal tokenIdReserv = 0;
1102     uint public tokenIdCount = tokenIdReserv + MAX_RESERV;
1103     uint public constant basePrice = 16000000000000000; // 0.016 ETH
1104 	string _baseTokenURI;
1105     bool saleEnable = false;
1106     mapping (uint256 => bool) internal _whitelist;
1107     DevilLadyClub public MESP =  DevilLadyClub(0x3bB82ae28bA8d1744e749B54536F7b6E5f56F138);
1108     
1109     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1110          saleEnable = _saleEnable;
1111     }
1112     
1113     
1114     constructor(string memory baseURI) ERC721("DevilLadyClub", "DLC")  {
1115         setBaseURI(baseURI);
1116     }
1117 
1118 
1119     function mintDevilLadyClub(address _to, uint _count) public payable {
1120         require(msg.sender == _owner || saleEnable);
1121         require(tokenIdCount + MAX_RESERV + _count <= MAX_DLC, "Max limit");
1122         require(tokenIdCount + MAX_RESERV < MAX_DLC, "Sale end");
1123         require(_count <= 20, "Exceeds 20");
1124         require(msg.value >= price(_count), "Value below price");
1125       
1126         for(uint i = 0; i < _count; i++){
1127             _safeMint(_to, tokenIdCount);
1128              tokenIdCount++;
1129         }
1130     }
1131     
1132     
1133     function mintReserve(address _to, uint _count) public onlyOwner {
1134         require(tokenIdReserv + _count <= MAX_RESERV, "Max limit");
1135         require(tokenIdReserv < MAX_RESERV, "Sale end");
1136         require(_count <= 20, "Exceeds 20");
1137       
1138         for(uint i = 0; i < _count; i++){
1139             _safeMint(_to, tokenIdReserv);
1140             tokenIdReserv++;
1141         }
1142     }
1143 
1144     function price(uint _count) public view virtual returns (uint256) {
1145          if(tokenIdCount < MAX_RESERV + 600 ){
1146              return 0;
1147          }else{
1148              return basePrice * _count; 
1149          }
1150           
1151     }
1152 
1153     function _baseURI() internal view virtual override returns (string memory) {
1154         return _baseTokenURI;
1155     }
1156     
1157     function setBaseURI(string memory baseURI) public onlyOwner {
1158         _baseTokenURI = baseURI;
1159     }
1160 
1161     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1162         uint tokenCount = balanceOf(_owner);
1163 
1164         uint256[] memory tokensId = new uint256[](tokenCount);
1165         for(uint i = 0; i < tokenCount; i++){
1166             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1167         }
1168 
1169         return tokensId;
1170     }
1171 
1172     function withdrawAll() public payable onlyOwner {
1173         _withdrawAll();
1174        
1175     }
1176     
1177     function MESPview(address _owner_) external view  returns (uint256[] memory) {
1178          return MESP.tokensOfOwner(_owner_); 
1179     }
1180     
1181     function CompletedMintMESP(uint256 _mespid) public view virtual returns (bool) {
1182          return _whitelist[_mespid];
1183     }
1184    
1185     function LadyForMespAvailable(address _holder) public view virtual returns (uint256) {
1186         //check  MESP balance sender
1187         uint tokenCount = MESP.balanceOf(_holder);
1188         uint tokenAvailable = 0;
1189         //check ever token whitelist
1190         uint256[] memory tokensId = new uint256[](tokenCount);
1191         for(uint i = 0; i < tokenCount; i++){
1192             tokensId[i] = MESP.tokenOfOwnerByIndex(_owner, i);
1193             
1194             if (_whitelist[tokensId[i]] != true  )
1195               {
1196              tokenAvailable++;
1197               }
1198             
1199         }
1200         
1201         return tokenAvailable;
1202    
1203     }
1204     
1205     function mintForMespOwner(address _to, uint _count) public  {
1206         require(msg.sender == _owner || saleEnable);
1207         require(tokenIdCount + MAX_RESERV + _count <= MAX_DLC, "Max limit");
1208         require(tokenIdCount + MAX_RESERV < MAX_DLC, "Sale end");
1209         require(_count <= 20, "Exceeds 20");
1210         //check  MESP balance sender
1211         uint tokenCount = MESP.balanceOf(_owner);
1212         // mint counter per transaction
1213         uint tokenMintLimit = 0;
1214         
1215         //check ever token whitelist
1216         uint256[] memory tokensId = new uint256[](tokenCount);
1217         for(uint i = 0; i < tokenCount; i++){
1218             tokensId[i] = MESP.tokenOfOwnerByIndex(_owner, i);
1219             
1220             if (_whitelist[tokensId[i]] != true && tokenMintLimit < _count )
1221             {
1222              _safeMint(_to, tokenIdCount);
1223               tokenIdCount++;
1224               tokenMintLimit++;
1225              _whitelist[tokensId[i]] = true;
1226                             
1227             }
1228 
1229         }
1230 
1231     }
1232 }