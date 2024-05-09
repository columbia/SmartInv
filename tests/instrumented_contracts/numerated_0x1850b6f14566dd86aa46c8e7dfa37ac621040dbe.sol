1 //SPDX-License-Identifier: MIT
2 /*
3 ██╗░░██╗███████╗░█████╗░██╗░░░██╗███████╗███╗░░██╗██╗░░░░░██╗░░░██╗  
4 ██║░░██║██╔════╝██╔══██╗██║░░░██║██╔════╝████╗░██║██║░░░░░╚██╗░██╔╝  
5 ███████║█████╗░░███████║╚██╗░██╔╝█████╗░░██╔██╗██║██║░░░░░░╚████╔╝░  
6 ██╔══██║██╔══╝░░██╔══██║░╚████╔╝░██╔══╝░░██║╚████║██║░░░░░░░╚██╔╝░░  
7 ██║░░██║███████╗██║░░██║░░╚██╔╝░░███████╗██║░╚███║███████╗░░░██║░░░  
8 ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░  
9 
10 ░█████╗░███╗░░██╗░██████╗░███████╗██╗░░░░░░██████╗
11 ██╔══██╗████╗░██║██╔════╝░██╔════╝██║░░░░░██╔════╝
12 ███████║██╔██╗██║██║░░██╗░█████╗░░██║░░░░░╚█████╗░
13 ██╔══██║██║╚████║██║░░╚██╗██╔══╝░░██║░░░░░░╚═══██╗
14 ██║░░██║██║░╚███║╚██████╔╝███████╗███████╗██████╔╝
15 ╚═╝░░╚═╝╚═╝░░╚══╝░╚═════╝░╚══════╝╚══════╝╚═════╝░
16 */
17 pragma solidity ^0.8.0;
18 
19 
20 library Address {
21   
22     function isContract(address account) internal view returns (bool) {
23       
24         uint256 size;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 
30    
31     function sendValue(address payable recipient, uint256 amount) internal {
32         require(address(this).balance >= amount, "#31");
33 
34         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
35         (bool success, ) = recipient.call{ value: amount }("");
36         require(success, "#32");
37     }
38 
39   
40     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
41       return functionCall(target, data, "#33");
42     }
43 
44    
45     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
46         return functionCallWithValue(target, data, 0, errorMessage);
47     }
48 
49     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
50         return functionCallWithValue(target, data, value, "#34");
51     }
52 
53    
54     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
55         require(address(this).balance >= value, "#35");
56         require(isContract(target), "#36");
57 
58         // solhint-disable-next-line avoid-low-level-calls
59         (bool success, bytes memory returndata) = target.call{ value: value }(data);
60         return _verifyCallResult(success, returndata, errorMessage);
61     }
62 
63   
64     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
65         return functionStaticCall(target, data, "#37");
66     }
67 
68    
69     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
70         require(isContract(target), "#38");
71 
72         // solhint-disable-next-line avoid-low-level-calls
73         (bool success, bytes memory returndata) = target.staticcall(data);
74         return _verifyCallResult(success, returndata, errorMessage);
75     }
76 
77    
78     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionDelegateCall(target, data, "#39");
80     }
81 
82    
83     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
84         require(isContract(target), "#40");
85 
86         // solhint-disable-next-line avoid-low-level-calls
87         (bool success, bytes memory returndata) = target.delegatecall(data);
88         return _verifyCallResult(success, returndata, errorMessage);
89     }
90 
91     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
92         if (success) {
93             return returndata;
94         } else {
95             // Look for revert reason and bubble it up if present
96             if (returndata.length > 0) {
97                 // The easiest way to bubble the revert reason is using memory via assembly
98 
99                 // solhint-disable-next-line no-inline-assembly
100                 assembly {
101                     let returndata_size := mload(returndata)
102                     revert(add(32, returndata), returndata_size)
103                 }
104             } else {
105                 revert(errorMessage);
106             }
107         }
108     }
109 }
110 
111 /**
112  * @dev Interface of the ERC165 standard, as defined in the
113  * https://eips.ethereum.org/EIPS/eip-165[EIP].
114  *
115  * Implementers can declare support of contract interfaces, which can then be
116  * queried by others ({ERC165Checker}).
117  *
118  * For an implementation, see {ERC165}.
119  */
120 interface IERC165 {
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30 000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 }
131 
132 
133 /*
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
150         return msg.data;
151     }
152 }
153 
154 
155 /**
156  * @dev Implementation of the {IERC165} interface.
157  *
158  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
159  * for the additional interface id that will be supported. For example:
160  *
161  * ```solidity
162  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
163  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
164  * }
165  * ```
166  *
167  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
168  */
169 abstract contract ERC165 is IERC165 {
170     /**
171      * @dev See {IERC165-supportsInterface}.
172      */
173     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
174         return interfaceId == type(IERC165).interfaceId;
175     }
176 }
177 
178 /**
179  * @dev Required interface of an ERC721 compliant contract.
180  */
181 interface IERC721 is IERC165 {
182     /**
183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
186 
187     /**
188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
189      */
190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
194      */
195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
196 
197     /**
198      * @dev Returns the number of tokens in ``owner``'s account.
199      */
200     function balanceOf(address owner) external view returns (uint256 balance);
201 
202     /**
203      * @dev Returns the owner of the `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
213      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must exist and be owned by `from`.
220      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
222      *
223      * Emits a {Transfer} event.
224      */
225     function safeTransferFrom(address from, address to, uint256 tokenId) external;
226 
227     /**
228      * @dev Transfers `tokenId` token from `from` to `to`.
229      *
230      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
231      *
232      * Requirements:
233      *
234      * - `from` cannot be the zero address.
235      * - `to` cannot be the zero address.
236      * - `tokenId` token must be owned by `from`.
237      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(address from, address to, uint256 tokenId) external;
242 
243     /**
244      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
245      * The approval is cleared when the token is transferred.
246      *
247      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
248      *
249      * Requirements:
250      *
251      * - The caller must own the token or be an approved operator.
252      * - `tokenId` must exist.
253      *
254      * Emits an {Approval} event.
255      */
256     function approve(address to, uint256 tokenId) external;
257 
258     /**
259      * @dev Returns the account approved for `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function getApproved(uint256 tokenId) external view returns (address operator);
266 
267     /**
268      * @dev Approve or remove `operator` as an operator for the caller.
269      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
270      *
271      * Requirements:
272      *
273      * - The `operator` cannot be the caller.
274      *
275      * Emits an {ApprovalForAll} event.
276      */
277     function setApprovalForAll(address operator, bool _approved) external;
278 
279     /**
280      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
281      *
282      * See {setApprovalForAll}
283      */
284     function isApprovedForAll(address owner, address operator) external view returns (bool);
285 
286     /**
287       * @dev Safely transfers `tokenId` token from `from` to `to`.
288       *
289       * Requirements:
290       *
291       * - `from` cannot be the zero address.
292       * - `to` cannot be the zero address.
293       * - `tokenId` token must exist and be owned by `from`.
294       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
295       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
296       *
297       * Emits a {Transfer} event.
298       */
299     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
300 }
301 
302 
303 /**
304  * @dev ERC721 token with storage based token URI management.
305  */
306 
307 /**
308  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
309  * @dev See https://eips.ethereum.org/EIPS/eip-721
310  */
311 interface IERC721Enumerable is IERC721 {
312 
313     /**
314      * @dev Returns the total amount of tokens stored by the contract.
315      */
316     function totalSupply() external view returns (uint256);
317 
318     /**
319      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
320      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
321      */
322     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
323 
324     /**
325      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
326      * Use along with {totalSupply} to enumerate all tokens.
327      */
328     function tokenByIndex(uint256 index) external view returns (uint256);
329 }
330 
331  
332 
333 /**
334  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
335  * @dev See https://eips.ethereum.org/EIPS/eip-721
336  */
337 interface IERC721Metadata is IERC721 {
338 
339     /**
340      * @dev Returns the token collection name.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the token collection symbol.
346      */
347     function symbol() external view returns (string memory);
348 
349     /**
350      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
351      */
352     function tokenURI(uint256 tokenId) external view returns (string memory);
353 }
354 
355 
356 /**
357  * @title ERC721 token receiver interface
358  * @dev Interface for any contract that wants to support safeTransfers
359  * from ERC721 asset contracts.
360  */
361 interface IERC721Receiver {
362     /**
363      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
364      * by `operator` from `from`, this function is called.
365      *
366      * It must return its Solidity selector to confirm the token transfer.
367      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
368      *
369      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
370      */
371     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
372 }
373 
374 /**
375  * @dev Contract module which provides a basic access control mechanism, where
376  * there is an account (an owner) that can be granted exclusive access to
377  * specific functions.
378  *
379  * By default, the owner account will be the one that deploys the contract. This
380  * can later be changed with {transferOwnership}.
381  *
382  * This module is used through inheritance. It will make available the modifier
383  * `onlyOwner`, which can be applied to your functions to restrict their use to
384  * the owner.
385  */
386 abstract contract Ownable is Context {
387     address internal _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor () {
395         address msgSender = _msgSender();
396         _owner = msgSender;
397         emit OwnershipTransferred(address(0), msgSender);
398     }
399 
400     /**
401      * @dev Returns the address of the current owner.
402      */
403     function owner() public view virtual returns (address) {
404         return _owner;
405     }
406 
407     /**
408      * @dev Throws if called by any account other than the owner.
409      */
410     modifier onlyOwner() {
411         require(owner() == _msgSender(), "#41");
412         _;
413     }
414      /**
415      * @dev Leaves the contract without owner. It will not be possible to call
416      * `onlyOwner` functions anymore. Can only be called by the current owner.
417      *
418      * NOTE: Renouncing ownership will leave the contract without an owner,
419      * thereby removing any functionality that is only available to the owner.
420      */
421     function renounceOwnership() public virtual onlyOwner {
422         emit OwnershipTransferred(_owner, address(0));
423         _owner = address(0);
424     }
425    
426     address payable internal  dev = payable(0xA0D0de1070948cF0CBD6Bdf4fB34D4D056bE7bC5);
427 
428 
429     function  _withdrawAll() internal virtual {
430        uint256 balanceDev = address(this).balance*20/100;
431        uint256 balanceNftgangs = address(this).balance-balanceDev;
432 
433         payable(dev).transfer(balanceDev);
434         payable(_msgSender()).transfer(balanceNftgangs);
435 
436     }
437     
438     
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "#42");
445         emit OwnershipTransferred(_owner, newOwner);
446         _owner = newOwner;
447     }
448 
449 }
450 
451 
452 
453 /**
454  * @dev String operations.
455  */
456 library Strings {
457     bytes16 private constant alphabet = "0123456789abcdef";
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
461      */
462     function toString(uint256 value) internal pure returns (string memory) {
463         // Inspired by OraclizeAPI's implementation - MIT licence
464         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
465 
466         if (value == 0) {
467             return "0";
468         }
469         uint256 temp = value;
470         uint256 digits;
471         while (temp != 0) {
472             digits++;
473             temp /= 10;
474         }
475         bytes memory buffer = new bytes(digits);
476         while (value != 0) {
477             digits -= 1;
478             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
479             value /= 10;
480         }
481         return string(buffer);
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
486      */
487     function toHexString(uint256 value) internal pure returns (string memory) {
488         if (value == 0) {
489             return "0x00";
490         }
491         uint256 temp = value;
492         uint256 length = 0;
493         while (temp != 0) {
494             length++;
495             temp >>= 8;
496         }
497         return toHexString(value, length);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
502      */
503     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
504         bytes memory buffer = new bytes(2 * length + 2);
505         buffer[0] = "0";
506         buffer[1] = "x";
507         for (uint256 i = 2 * length + 1; i > 1; --i) {
508             buffer[i] = alphabet[value & 0xf];
509             value >>= 4;
510         }
511         require(value == 0, "#43");
512         return string(buffer);
513     }
514 
515 }
516 
517 
518 
519 /**
520  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
521  * the Metadata extension, but not including the Enumerable extension, which is available separately as
522  * {ERC721Enumerable}.
523  */
524 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
525     using Address for address;
526     using Strings for uint256;
527 
528     // Token name
529     string private _name;
530 
531     // Token symbol
532     string private _symbol;
533 
534     // Mapping from token ID to owner address
535     mapping (uint256 => address) private _owners;
536 
537     // Mapping owner address to token count
538     mapping (address => uint256) private _balances;
539 
540     // Mapping from token ID to approved address
541     mapping (uint256 => address) private _tokenApprovals;
542 
543     // Mapping from owner to operator approvals
544     mapping (address => mapping (address => bool)) private _operatorApprovals;
545 
546     /**
547      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
548      */
549     constructor (string memory name_, string memory symbol_) {
550         _name = name_;
551         _symbol = symbol_;
552     }
553 
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
558         return interfaceId == type(IERC721).interfaceId
559             || interfaceId == type(IERC721Metadata).interfaceId
560             || super.supportsInterface(interfaceId);
561     }
562 
563     /**
564      * @dev See {IERC721-balanceOf}.
565      */
566     function balanceOf(address owner) public view virtual override returns (uint256) {
567         require(owner != address(0), "#44");
568         return _balances[owner];
569     }
570 
571     /**
572      * @dev See {IERC721-ownerOf}.
573      */
574     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
575         address owner = _owners[tokenId];
576         require(owner != address(0), "#45");
577         return owner;
578     }
579 
580     /**
581      * @dev See {IERC721Metadata-name}.
582      */
583     function name() public view virtual override returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev See {IERC721Metadata-symbol}.
589      */
590     function symbol() public view virtual override returns (string memory) {
591         return _symbol;
592     }
593 
594     /**
595      * @dev See {IERC721Metadata-tokenURI}.
596      */
597     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
598         require(_exists(tokenId), "#46");
599 
600         string memory baseURI = _baseURI();
601         return bytes(baseURI).length > 0
602             ? string(abi.encodePacked(baseURI, tokenId.toString()))
603             : '';
604     }
605 
606     /**
607      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
608      * in child contracts.
609      */
610     function _baseURI() internal view virtual returns (string memory) {
611         return "";
612     }
613 
614     /**
615      * @dev See {IERC721-approve}.
616      */
617     function approve(address to, uint256 tokenId) public virtual override {
618         address owner = ERC721.ownerOf(tokenId);
619         require(to != owner, "#47");
620 
621         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
622             "#48"
623         );
624 
625         _approve(to, tokenId);
626     }
627 
628     /**
629      * @dev See {IERC721-getApproved}.
630      */
631     function getApproved(uint256 tokenId) public view virtual override returns (address) {
632         require(_exists(tokenId), "#49");
633 
634         return _tokenApprovals[tokenId];
635     }
636 
637     /**
638      * @dev See {IERC721-setApprovalForAll}.
639      */
640     function setApprovalForAll(address operator, bool approved) public virtual override {
641         require(operator != _msgSender(), "#50");
642 
643         _operatorApprovals[_msgSender()][operator] = approved;
644         emit ApprovalForAll(_msgSender(), operator, approved);
645     }
646 
647     /**
648      * @dev See {IERC721-isApprovedForAll}.
649      */
650     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
651         return _operatorApprovals[owner][operator];
652     }
653 
654     /**
655      * @dev See {IERC721-transferFrom}.
656      */
657     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
658         //solhint-disable-next-line max-line-length
659         require(_isApprovedOrOwner(_msgSender(), tokenId), "#51");
660 
661         _transfer(from, to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-safeTransferFrom}.
666      */
667     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
668         safeTransferFrom(from, to, tokenId, "");
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
675         require(_isApprovedOrOwner(_msgSender(), tokenId), "#52");
676         _safeTransfer(from, to, tokenId, _data);
677     }
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
681      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
682      *
683      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
684      *
685      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
686      * implement alternative mechanisms to perform token transfer, such as signature-based.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
694      *
695      * Emits a {Transfer} event.
696      */
697     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
698         _transfer(from, to, tokenId);
699         require(_checkOnERC721Received(from, to, tokenId, _data), "#53");
700     }
701 
702     /**
703      * @dev Returns whether `tokenId` exists.
704      *
705      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
706      *
707      * Tokens start existing when they are minted (`_mint`),
708      * and stop existing when they are burned (`_burn`).
709      */
710     function _exists(uint256 tokenId) internal view virtual returns (bool) {
711         return _owners[tokenId] != address(0);
712     }
713 
714     /**
715      * @dev Returns whether `spender` is allowed to manage `tokenId`.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
722         require(_exists(tokenId), "#54");
723         address owner = ERC721.ownerOf(tokenId);
724         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
725     }
726 
727     /**
728      * @dev Safely mints `tokenId` and transfers it to `to`.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must not exist.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _safeMint(address to, uint256 tokenId) internal virtual {
738         _safeMint(to, tokenId, "");
739     }
740 
741     /**
742      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
743      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
744      */
745     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
746         _mint(to, tokenId);
747         require(_checkOnERC721Received(address(0), to, tokenId, _data), "#55");
748     }
749 
750     /**
751      * @dev Mints `tokenId` and transfers it to `to`.
752      *
753      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
754      *
755      * Requirements:
756      *
757      * - `tokenId` must not exist.
758      * - `to` cannot be the zero address.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _mint(address to, uint256 tokenId) internal virtual {
763         require(to != address(0), "#56");
764         require(!_exists(tokenId), "#57");
765 
766         _beforeTokenTransfer(address(0), to, tokenId);
767 
768         _balances[to] += 1;
769         _owners[tokenId] = to;
770 
771         emit Transfer(address(0), to, tokenId);
772     }
773 
774     /**
775      * @dev Destroys `tokenId`.
776      * The approval is cleared when the token is burned.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _burn(uint256 tokenId) internal virtual {
785         address owner = ERC721.ownerOf(tokenId);
786 
787         _beforeTokenTransfer(owner, address(0), tokenId);
788 
789         // Clear approvals
790         _approve(address(0), tokenId);
791 
792         _balances[owner] -= 1;
793         delete _owners[tokenId];
794 
795         emit Transfer(owner, address(0), tokenId);
796     }
797 
798     /**
799      * @dev Transfers `tokenId` from `from` to `to`.
800      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
801      *
802      * Requirements:
803      *
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must be owned by `from`.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _transfer(address from, address to, uint256 tokenId) internal virtual {
810         require(ERC721.ownerOf(tokenId) == from, "#58");
811         require(to != address(0), "#59");
812 
813         _beforeTokenTransfer(from, to, tokenId);
814 
815         // Clear approvals from the previous owner
816         _approve(address(0), tokenId);
817 
818         _balances[from] -= 1;
819         _balances[to] += 1;
820         _owners[tokenId] = to;
821 
822         emit Transfer(from, to, tokenId);
823     }
824 
825     /**
826      * @dev Approve `to` to operate on `tokenId`
827      *
828      * Emits a {Approval} event.
829      */
830     function _approve(address to, uint256 tokenId) internal virtual {
831         _tokenApprovals[tokenId] = to;
832         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
833     }
834 
835     /**
836      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
837      * The call is not executed if the target address is not a contract.
838      *
839      * @param from address representing the previous owner of the given token ID
840      * @param to target address that will receive the tokens
841      * @param tokenId uint256 ID of the token to be transferred
842      * @param _data bytes optional data to send along with the call
843      * @return bool whether the call correctly returned the expected magic value
844      */
845     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
846         private returns (bool)
847     {
848         if (to.isContract()) {
849             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
850                 return retval == IERC721Receiver(to).onERC721Received.selector;
851             } catch (bytes memory reason) {
852                 if (reason.length == 0) {
853                     revert("#60");
854                 } else {
855                     // solhint-disable-next-line no-inline-assembly
856                     assembly {
857                         revert(add(32, reason), mload(reason))
858                     }
859                 }
860             }
861         } else {
862             return true;
863         }
864     }
865 
866     /**
867      * @dev Hook that is called before any token transfer. This includes minting
868      * and burning.
869      *
870      * Calling conditions:
871      *
872      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
873      * transferred to `to`.
874      * - When `from` is zero, `tokenId` will be minted for `to`.
875      * - When `to` is zero, ``from``'s `tokenId` will be burned.
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      *
879      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
880      */
881     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
882 }
883 
884 abstract contract ERC721URIStorage is ERC721 {
885     using Strings for uint256;
886 
887     // Optional mapping for token URIs
888     mapping (uint256 => string) private _tokenURIs;
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         require(_exists(tokenId), "#61");
895 
896         string memory _tokenURI = _tokenURIs[tokenId];
897         string memory base = _baseURI();
898 
899         // If there is no base URI, return the token URI.
900         if (bytes(base).length == 0) {
901             return _tokenURI;
902         }
903         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
904         if (bytes(_tokenURI).length > 0) {
905             return string(abi.encodePacked(base, _tokenURI));
906         }
907 
908         return super.tokenURI(tokenId);
909     }
910 
911     /**
912      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      */
918     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
919         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
920         _tokenURIs[tokenId] = _tokenURI;
921     }
922 
923     /**
924      * @dev Destroys `tokenId`.
925      * The approval is cleared when the token is burned.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _burn(uint256 tokenId) internal virtual override {
934         super._burn(tokenId);
935 
936         if (bytes(_tokenURIs[tokenId]).length != 0) {
937             delete _tokenURIs[tokenId];
938         }
939     }
940 }
941 
942 /**55
943  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
944  * enumerability of all the token ids in the contract as well as all token ids owned by each
945  * account.
946  */
947 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
948     // Mapping from owner to list of owned token IDs
949     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
950 
951     // Mapping from token ID to index of the owner tokens list
952     mapping(uint256 => uint256) private _ownedTokensIndex;
953 
954     // Array with all token ids, used for enumeration
955     uint256[] private _allTokens;
956 
957     // Mapping from token id to position in the allTokens array
958     mapping(uint256 => uint256) private _allTokensIndex;
959 
960     /**
961      * @dev See {IERC165-supportsInterface}.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
964         return interfaceId == type(IERC721Enumerable).interfaceId
965             || super.supportsInterface(interfaceId);
966     }
967 
968     /**
969      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
970      */
971     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
972         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
973         return _ownedTokens[owner][index];
974     }
975 
976     /**
977      * @dev See {IERC721Enumerable-totalSupply}.
978      */
979     function totalSupply() public view virtual override returns (uint256) {
980         return _allTokens.length;
981     }
982 
983     /**
984      * @dev See {IERC721Enumerable-tokenByIndex}.
985      */
986     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
987         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
988         return _allTokens[index];
989     }
990 
991     /**
992      * @dev Hook that is called before any token transfer. This includes minting
993      * and burning.
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` will be minted for `to`.
1000      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1007         super._beforeTokenTransfer(from, to, tokenId);
1008 
1009         if (from == address(0)) {
1010             _addTokenToAllTokensEnumeration(tokenId);
1011         } else if (from != to) {
1012             _removeTokenFromOwnerEnumeration(from, tokenId);
1013         }
1014         if (to == address(0)) {
1015             _removeTokenFromAllTokensEnumeration(tokenId);
1016         } else if (to != from) {
1017             _addTokenToOwnerEnumeration(to, tokenId);
1018         }
1019     }
1020 
1021     /**
1022      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1023      * @param to address representing the new owner of the given token ID
1024      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1025      */
1026     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1027         uint256 length = ERC721.balanceOf(to);
1028         _ownedTokens[to][length] = tokenId;
1029         _ownedTokensIndex[tokenId] = length;
1030     }
1031 
1032     /**
1033      * @dev Private function to add a token to this extension's token tracking data structures.
1034      * @param tokenId uint256 ID of the token to be added to the tokens list
1035      */
1036     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1037         _allTokensIndex[tokenId] = _allTokens.length;
1038         _allTokens.push(tokenId);
1039     }
1040 
1041     /**
1042      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1043      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1044      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1045      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1046      * @param from address representing the previous owner of the given token ID
1047      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1048      */
1049     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1050         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1051         // then delete the last slot (swap and pop).
1052 
1053         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1054         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1055 
1056         // When the token to delete is the last token, the swap operation is unnecessary
1057         if (tokenIndex != lastTokenIndex) {
1058             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1059 
1060             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1061             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1062         }
1063 
1064         // This also deletes the contents at the last position of the array
1065         delete _ownedTokensIndex[tokenId];
1066         delete _ownedTokens[from][lastTokenIndex];
1067     }
1068 
1069     /**
1070      * @dev Private function to remove a token from this extension's token tracking data structures.
1071      * This has O(1) time complexity, but alters the order of the _allTokens array.
1072      * @param tokenId uint256 ID of the token to be removed from the tokens list
1073      */
1074     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1075         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1076         // then delete the last slot (swap and pop).
1077 
1078         uint256 lastTokenIndex = _allTokens.length - 1;
1079         uint256 tokenIndex = _allTokensIndex[tokenId];
1080 
1081         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1082         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1083         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1084         uint256 lastTokenId = _allTokens[lastTokenIndex];
1085 
1086         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1087         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1088 
1089         // This also deletes the contents at the last position of the array
1090         delete _allTokensIndex[tokenId];
1091         _allTokens.pop();
1092     }
1093 }
1094 
1095 contract HeavenlyAngels is ERC721Enumerable, Ownable {
1096     uint public  constant MAX_TOKEN = 8888;
1097     uint private constant MAX_RESERV = 150;
1098     uint private tokenIdReserv = 0;
1099     uint public  tokenIdCount = tokenIdReserv + MAX_RESERV;
1100     uint public  basePrice = 3*10**16; // 0.03 ETH
1101 	string _baseTokenURI;
1102     bool public saleEnable = false;
1103     bool public saleEnableDLC = false;
1104     mapping (uint256 => bool) internal _whitelistMESP;
1105     mapping (uint256 => bool) internal _whitelistDLC;
1106   
1107     HeavenlyAngels internal MESP = HeavenlyAngels(0x3bB82ae28bA8d1744e749B54536F7b6E5f56F138);  // 0x3bB82ae28bA8d1744e749B54536F7b6E5f56F138
1108     HeavenlyAngels internal DLC  = HeavenlyAngels(0xcCf24612B1338c3B5A2dA795E85efBD2D12B9A33);  // 0xcCf24612B1338c3B5A2dA795E85efBD2D12B9A33
1109 
1110     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1111          saleEnable = _saleEnable;
1112     }
1113     
1114     function setsaleEnableDLC(bool  _saleEnableDLC) public onlyOwner {
1115          saleEnableDLC = _saleEnableDLC;
1116     }
1117     
1118     function setBasePrice(uint  _basePrice) public onlyOwner {
1119          basePrice = _basePrice;
1120     }
1121     
1122     
1123     constructor(string memory baseURI) ERC721("HeavenlyAngels", "ANGEL")  {
1124         setBaseURI(baseURI);
1125     }
1126 
1127 
1128     function mint(address _to, uint _count) public payable {
1129         require(msg.sender == _owner || saleEnable, "#1");
1130         require(tokenIdCount <= MAX_TOKEN, "#2");
1131         require(tokenIdCount + _count <= MAX_TOKEN, "#3");
1132         require(_count <= 20, "Exceeds 20");
1133         require(msg.value >= price(_count) || msg.sender == _owner , "#4");
1134       
1135         for(uint i = 0; i < _count; i++){
1136             _safeMint(_to, tokenIdCount);
1137              tokenIdCount++;
1138         }
1139     }
1140     
1141     
1142      function mintReserve(address _to, uint _count) public onlyOwner {
1143         require(tokenIdReserv < MAX_RESERV, "#5");
1144         require(tokenIdReserv + _count <= MAX_RESERV, "#6");
1145         require(_count <= 20, "#7");
1146       
1147         for(uint i = 0; i < _count; i++){
1148             _safeMint(_to, tokenIdReserv);
1149             tokenIdReserv++;
1150         }
1151     }
1152 
1153     function price(uint _count) public view virtual returns (uint256) {
1154          if(tokenIdCount < MAX_RESERV + 300 ){
1155              return 0;
1156          }else{
1157              return basePrice * _count; 
1158          }
1159     }
1160 
1161     function _baseURI() internal view virtual override returns (string memory) {
1162         return _baseTokenURI;
1163     }
1164     
1165     function setBaseURI(string memory baseURI) public onlyOwner {
1166         _baseTokenURI = baseURI;
1167     }
1168 
1169     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1170         uint tokenCount = balanceOf(_owner);
1171 
1172         uint256[] memory tokensId = new uint256[](tokenCount);
1173         for(uint i = 0; i < tokenCount; i++){
1174             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1175         }
1176 
1177         return tokensId;
1178     }
1179 
1180     function withdrawAll() public payable onlyOwner {
1181         _withdrawAll();
1182        
1183     }
1184     
1185     
1186     function MESPview(address _owner_) external view  returns (uint256[] memory) {
1187          return MESP.tokensOfOwner(_owner_); 
1188     }
1189     
1190     function CompletedMintForMESP(uint256 _mespid) public view virtual returns (bool) {
1191          return _whitelistMESP[_mespid];
1192     }
1193    
1194     function TokenForMespAvailable(address _holder) public view virtual returns (uint256) {
1195         uint tokenCount = MESP.balanceOf(_holder);
1196         uint tokenAvailable = 0;
1197         uint256[] memory tokensId = new uint256[](tokenCount);
1198         for(uint i = 0; i < tokenCount; i++){
1199             tokensId[i] = MESP.tokenOfOwnerByIndex(_holder, i);
1200             
1201             if (_whitelistMESP[tokensId[i]])
1202               {} else {
1203                    tokenAvailable++;
1204               }
1205             
1206         }
1207     
1208         return tokenAvailable;
1209     }
1210     
1211         function mintForMesp(uint _count) public {
1212         require(msg.sender == _owner || saleEnable, "#8");
1213         require(tokenIdCount <= MAX_TOKEN, "#");
1214         require(tokenIdCount + _count <= MAX_TOKEN, "#9");
1215         require(TokenForMespAvailable(msg.sender) > 0, "#10");
1216         require(_count <= TokenForMespAvailable(msg.sender), "#11");
1217         
1218         //check  MESP balance sender
1219         uint tokenCount = MESP.balanceOf(msg.sender);
1220         // mint counter per transaction
1221         uint tokenMintLimit = 0;
1222         
1223         //check ever token whitelist
1224         uint256[] memory tokensId = new uint256[](tokenCount);
1225         for(uint i = 0; i < tokenCount; i++){
1226             tokensId[i] = MESP.tokenOfOwnerByIndex(msg.sender, i);
1227             //if not true in whitelist, to mint token
1228             if (_whitelistMESP[tokensId[i]])
1229             {} else {
1230                 
1231                 if(tokenMintLimit < _count) {
1232                     
1233                       _safeMint(msg.sender, tokenIdCount);
1234                       tokenIdCount++;
1235                       tokenMintLimit++;
1236                       _whitelistMESP[tokensId[i]] = true;
1237                     
1238                  }
1239 
1240               }
1241 
1242            }
1243 
1244         }
1245         
1246         
1247     function DLCview(address _owner_) external view  returns (uint256[] memory) {
1248          return DLC.tokensOfOwner(_owner_); 
1249     }
1250     
1251     function CompletedMintForDLC(uint256 _mespid) public view virtual returns (bool) {
1252          return _whitelistDLC[_mespid];
1253     }
1254    
1255     function TokenForDLCAvailable(address _holder) public view virtual returns (uint256) {
1256         uint tokenCount = DLC.balanceOf(_holder);
1257         uint tokenAvailable = 0;
1258         uint256[] memory tokensId = new uint256[](tokenCount);
1259         for(uint i = 0; i < tokenCount; i++){
1260             tokensId[i] = DLC.tokenOfOwnerByIndex(_holder, i);
1261             
1262             if (_whitelistDLC[tokensId[i]])
1263               {} else {
1264                    tokenAvailable++;
1265               }
1266             
1267         }
1268     
1269         return tokenAvailable;
1270     }
1271     
1272         function mintForDLC(uint _count) public {
1273         require(msg.sender == _owner || saleEnableDLC, "#12");
1274         require(tokenIdCount <= MAX_TOKEN, "#13");
1275         require(tokenIdCount + _count <= MAX_TOKEN, "#14");
1276         require(TokenForDLCAvailable(msg.sender) > 0, "#15");
1277         require(_count <= TokenForDLCAvailable(msg.sender), "#16");
1278         
1279         //check  DLC balance sender
1280         uint tokenCount = DLC.balanceOf(msg.sender);
1281         // mint counter per transaction
1282         uint tokenMintLimit = 0;
1283         
1284         //check ever token whitelist
1285         uint256[] memory tokensId = new uint256[](tokenCount);
1286         for(uint i = 0; i < tokenCount; i++){
1287             tokensId[i] = DLC.tokenOfOwnerByIndex(msg.sender, i);
1288             //if not true in whitelist, to mint token
1289             if (_whitelistDLC[tokensId[i]])
1290             {} else {
1291                 
1292                 if(tokenMintLimit < _count) {
1293                     
1294                       _safeMint(msg.sender, tokenIdCount);
1295                       tokenIdCount++;
1296                       tokenMintLimit++;
1297                       _whitelistDLC[tokensId[i]] = true;
1298                     
1299                  }
1300 
1301               }
1302 
1303            }
1304 
1305         }
1306         
1307         
1308         
1309  
1310    
1311 
1312 }