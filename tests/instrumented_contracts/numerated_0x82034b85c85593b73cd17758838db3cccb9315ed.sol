1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor () internal {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         emit OwnershipTransferred(_owner, newOwner);
62         _owner = newOwner;
63     }
64 }
65 
66 
67 /**
68  * @dev Interface of the ERC165 standard, as defined in the
69  * https://eips.ethereum.org/EIPS/eip-165[EIP].
70  *
71  * Implementers can declare support of contract interfaces, which can then be
72  * queried by others ({ERC165Checker}).
73  *
74  * For an implementation, see {ERC165}.
75  */
76 interface IERC165 {
77     /**
78      * @dev Returns true if this contract implements the interface defined by
79      * `interfaceId`. See the corresponding
80      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
81      * to learn more about how these ids are created.
82      *
83      * This function call must use less than 30 000 gas.
84      */
85     function supportsInterface(bytes4 interfaceId) external view returns (bool);
86 }
87 
88 
89 /**
90  * @dev Implementation of the {IERC165} interface.
91  *
92  * Contracts may inherit from this and call {_registerInterface} to declare
93  * their support of an interface.
94  */
95 abstract contract ERC165 is IERC165 {
96     /*
97      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
98      */
99     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
100 
101     /**
102      * @dev Mapping of interface ids to whether or not it's supported.
103      */
104     mapping(bytes4 => bool) private _supportedInterfaces;
105 
106     constructor () internal {
107         // Derived contracts need only register support for their own interfaces,
108         // we register support for ERC165 itself here
109         _registerInterface(_INTERFACE_ID_ERC165);
110     }
111 
112     /**
113      * @dev See {IERC165-supportsInterface}.
114      *
115      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
118         return _supportedInterfaces[interfaceId];
119     }
120 
121     /**
122      * @dev Registers the contract as an implementer of the interface defined by
123      * `interfaceId`. Support of the actual ERC165 interface is automatic and
124      * registering its interface id is not required.
125      *
126      * See {IERC165-supportsInterface}.
127      *
128      * Requirements:
129      *
130      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
131      */
132     function _registerInterface(bytes4 interfaceId) internal virtual {
133         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
134         _supportedInterfaces[interfaceId] = true;
135     }
136 }
137 
138 /**
139  * @dev Wrappers over Solidity's arithmetic operations with added overflow
140  * checks.
141  *
142  * Arithmetic operations in Solidity wrap on overflow. This can easily result
143  * in bugs, because programmers usually assume that an overflow raises an
144  * error, which is the standard behavior in high level programming languages.
145  * `SafeMath` restores this intuition by reverting the transaction when an
146  * operation overflows.
147  *
148  * Using this library instead of the unchecked operations eliminates an entire
149  * class of bugs, so it's recommended to use it always.
150  */
151 library SafeMath {
152     /**
153      * @dev Returns the addition of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         uint256 c = a + b;
159         if (c < a) return (false, 0);
160         return (true, c);
161     }
162 
163     /**
164      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
165      *
166      * _Available since v3.4._
167      */
168     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         if (b > a) return (false, 0);
170         return (true, a - b);
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) return (true, 0);
183         uint256 c = a * b;
184         if (c / a != b) return (false, 0);
185         return (true, c);
186     }
187 
188     /**
189      * @dev Returns the division of two unsigned integers, with a division by zero flag.
190      *
191      * _Available since v3.4._
192      */
193     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
194         if (b == 0) return (false, 0);
195         return (true, a / b);
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
200      *
201      * _Available since v3.4._
202      */
203     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204         if (b == 0) return (false, 0);
205         return (true, a % b);
206     }
207 
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      *
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         require(c >= a, "SafeMath: addition overflow");
221         return c;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b <= a, "SafeMath: subtraction overflow");
236         return a - b;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         if (a == 0) return 0;
251         uint256 c = a * b;
252         require(c / a == b, "SafeMath: multiplication overflow");
253         return c;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers, reverting on
258      * division by zero. The result is rounded towards zero.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         require(b > 0, "SafeMath: division by zero");
270         return a / b;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         require(b > 0, "SafeMath: modulo by zero");
287         return a % b;
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
292      * overflow (when the result is negative).
293      *
294      * CAUTION: This function is deprecated because it requires allocating memory for the error
295      * message unnecessarily. For custom revert reasons use {trySub}.
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      *
301      * - Subtraction cannot overflow.
302      */
303     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b <= a, errorMessage);
305         return a - b;
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
310      * division by zero. The result is rounded towards zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryDiv}.
314      *
315      * Counterpart to Solidity's `/` operator. Note: this function uses a
316      * `revert` opcode (which leaves remaining gas untouched) while Solidity
317      * uses an invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         return a / b;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * reverting with custom message when dividing by zero.
331      *
332      * CAUTION: This function is deprecated because it requires allocating memory for the error
333      * message unnecessarily. For custom revert reasons use {tryMod}.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
344         require(b > 0, errorMessage);
345         return a % b;
346     }
347 }
348 
349 
350 
351 /**
352  * @dev Required interface of an ERC721 compliant contract.
353  */
354 interface IERC721 is IERC165 {
355     /**
356      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359 
360     /**
361      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
362      */
363     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
367      */
368     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
369 
370     /**
371      * @dev Returns the number of tokens in ``owner``'s account.
372      */
373     function balanceOf(address owner) external view returns (uint256 balance);
374 
375     /**
376      * @dev Returns the owner of the `tokenId` token.
377      *
378      * Requirements:
379      *
380      * - `tokenId` must exist.
381      */
382     function ownerOf(uint256 tokenId) external view returns (address owner);
383 
384     /**
385      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
386      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must exist and be owned by `from`.
393      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395      *
396      * Emits a {Transfer} event.
397      */
398     function safeTransferFrom(address from, address to, uint256 tokenId) external;
399 
400     /**
401      * @dev Transfers `tokenId` token from `from` to `to`.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must be owned by `from`.
410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(address from, address to, uint256 tokenId) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Returns the account approved for `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function getApproved(uint256 tokenId) external view returns (address operator);
439 
440     /**
441      * @dev Approve or remove `operator` as an operator for the caller.
442      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The `operator` cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     /**
460       * @dev Safely transfers `tokenId` token from `from` to `to`.
461       *
462       * Requirements:
463       *
464       * - `from` cannot be the zero address.
465       * - `to` cannot be the zero address.
466       * - `tokenId` token must exist and be owned by `from`.
467       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469       *
470       * Emits a {Transfer} event.
471       */
472     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
473 }
474 
475 /**
476  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
477  * @dev See https://eips.ethereum.org/EIPS/eip-721
478  */
479 interface IERC721Enumerable is IERC721 {
480 
481     /**
482      * @dev Returns the total amount of tokens stored by the contract.
483      */
484     function totalSupply() external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
488      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
489      */
490     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
491 
492     /**
493      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
494      * Use along with {totalSupply} to enumerate all tokens.
495      */
496     function tokenByIndex(uint256 index) external view returns (uint256);
497 }
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504 
505     /**
506      * @dev Returns the token collection name.
507      */
508     function name() external view returns (string memory);
509 
510     /**
511      * @dev Returns the token collection symbol.
512      */
513     function symbol() external view returns (string memory);
514 
515     /**
516      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
517      */
518     function tokenURI(uint256 tokenId) external view returns (string memory);
519 }
520 
521 /**
522  * @title ERC721 Non-Fungible Token Standard basic implementation
523  * @dev see https://eips.ethereum.org/EIPS/eip-721
524  */
525 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
526     using SafeMath for uint256;
527     using Address for address;
528     using EnumerableSet for EnumerableSet.UintSet;
529     using EnumerableMap for EnumerableMap.UintToAddressMap;
530     using Strings for uint256;
531 
532     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
533     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
534     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
535 
536     // Mapping from holder address to their (enumerable) set of owned tokens
537     mapping (address => EnumerableSet.UintSet) private _holderTokens;
538 
539     // Enumerable mapping from token ids to their owners
540     EnumerableMap.UintToAddressMap private _tokenOwners;
541 
542     // Mapping from token ID to approved address
543     mapping (uint256 => address) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping (address => mapping (address => bool)) private _operatorApprovals;
547 
548     // Token name
549     string private _name;
550 
551     // Token symbol
552     string private _symbol;
553 
554     // Optional mapping for token URIs
555     mapping (uint256 => string) private _tokenURIs;
556 
557     // Base URI
558     string private _baseURI;
559 
560     /*
561      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
562      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
563      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
564      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
565      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
566      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
567      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
568      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
569      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
570      *
571      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
572      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
573      */
574     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
575 
576     /*
577      *     bytes4(keccak256('name()')) == 0x06fdde03
578      *     bytes4(keccak256('symbol()')) == 0x95d89b41
579      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
580      *
581      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
582      */
583     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
584 
585     /*
586      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
587      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
588      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
589      *
590      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
591      */
592     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
593 
594     /**
595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
596      */
597     constructor (string memory name_, string memory symbol_) public {
598         _name = name_;
599         _symbol = symbol_;
600 
601         // register the supported interfaces to conform to ERC721 via ERC165
602         _registerInterface(_INTERFACE_ID_ERC721);
603         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
604         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
605     }
606 
607     /**
608      * @dev See {IERC721-balanceOf}.
609      */
610     function balanceOf(address owner) public view virtual override returns (uint256) {
611         require(owner != address(0), "ERC721: balance query for the zero address");
612         return _holderTokens[owner].length();
613     }
614 
615     /**
616      * @dev See {IERC721-ownerOf}.
617      */
618     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
619         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-name}.
624      */
625     function name() public view virtual override returns (string memory) {
626         return _name;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-symbol}.
631      */
632     function symbol() public view virtual override returns (string memory) {
633         return _symbol;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-tokenURI}.
638      */
639     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
640         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
641 
642         string memory _tokenURI = _tokenURIs[tokenId];
643         string memory base = baseURI();
644 
645         // If there is no base URI, return the token URI.
646         if (bytes(base).length == 0) {
647             return _tokenURI;
648         }
649         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
650         if (bytes(_tokenURI).length > 0) {
651             return string(abi.encodePacked(base, _tokenURI));
652         }
653         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
654         return string(abi.encodePacked(base, tokenId.toString()));
655     }
656 
657     /**
658     * @dev Returns the base URI set via {_setBaseURI}. This will be
659     * automatically added as a prefix in {tokenURI} to each token's URI, or
660     * to the token ID if no specific URI is set for that token ID.
661     */
662     function baseURI() public view virtual returns (string memory) {
663         return _baseURI;
664     }
665 
666     /**
667      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
668      */
669     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
670         return _holderTokens[owner].at(index);
671     }
672 
673     /**
674      * @dev See {IERC721Enumerable-totalSupply}.
675      */
676     function totalSupply() public view virtual override returns (uint256) {
677         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
678         return _tokenOwners.length();
679     }
680 
681     /**
682      * @dev See {IERC721Enumerable-tokenByIndex}.
683      */
684     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
685         (uint256 tokenId, ) = _tokenOwners.at(index);
686         return tokenId;
687     }
688 
689     /**
690      * @dev See {IERC721-approve}.
691      */
692     function approve(address to, uint256 tokenId) public virtual override {
693         address owner = ERC721.ownerOf(tokenId);
694         require(to != owner, "ERC721: approval to current owner");
695 
696         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         require(operator != _msgSender(), "ERC721: approve to caller");
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
733         //solhint-disable-next-line max-line-length
734         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
735 
736         _transfer(from, to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
743         safeTransferFrom(from, to, tokenId, "");
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransfer(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
759      *
760      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
761      * implement alternative mechanisms to perform token transfer, such as signature-based.
762      *
763      * Requirements:
764      *
765      * - `from` cannot be the zero address.
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must exist and be owned by `from`.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
773         _transfer(from, to, tokenId);
774         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
775     }
776 
777     /**
778      * @dev Returns whether `tokenId` exists.
779      *
780      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
781      *
782      * Tokens start existing when they are minted (`_mint`),
783      * and stop existing when they are burned (`_burn`).
784      */
785     function _exists(uint256 tokenId) internal view virtual returns (bool) {
786         return _tokenOwners.contains(tokenId);
787     }
788 
789     /**
790      * @dev Returns whether `spender` is allowed to manage `tokenId`.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
797         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
798         address owner = ERC721.ownerOf(tokenId);
799         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
800     }
801 
802     /**
803      * @dev Safely mints `tokenId` and transfers it to `to`.
804      *
805      * Requirements:
806      d*
807      * - `tokenId` must not exist.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _safeMint(address to, uint256 tokenId) internal virtual {
813         _safeMint(to, tokenId, "");
814     }
815 
816     /**
817      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
818      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
819      */
820     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
821         _mint(to, tokenId);
822         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
823     }
824 
825     /**
826      * @dev Mints `tokenId` and transfers it to `to`.
827      *
828      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - `to` cannot be the zero address.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _mint(address to, uint256 tokenId) internal virtual {
838         require(to != address(0), "ERC721: mint to the zero address");
839         require(!_exists(tokenId), "ERC721: token already minted");
840 
841         _beforeTokenTransfer(address(0), to, tokenId);
842 
843         _holderTokens[to].add(tokenId);
844 
845         _tokenOwners.set(tokenId, to);
846 
847         emit Transfer(address(0), to, tokenId);
848     }
849 
850     /**
851      * @dev Destroys `tokenId`.
852      * The approval is cleared when the token is burned.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _burn(uint256 tokenId) internal virtual {
861         address owner = ERC721.ownerOf(tokenId); // internal owner
862 
863         _beforeTokenTransfer(owner, address(0), tokenId);
864 
865         // Clear approvals
866         _approve(address(0), tokenId);
867 
868         // Clear metadata (if any)
869         if (bytes(_tokenURIs[tokenId]).length != 0) {
870             delete _tokenURIs[tokenId];
871         }
872 
873         _holderTokens[owner].remove(tokenId);
874 
875         _tokenOwners.remove(tokenId);
876 
877         emit Transfer(owner, address(0), tokenId);
878     }
879 
880     /**
881      * @dev Transfers `tokenId` from `from` to `to`.
882      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
883      *
884      * Requirements:
885      *
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must be owned by `from`.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _transfer(address from, address to, uint256 tokenId) internal virtual {
892         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
893         require(to != address(0), "ERC721: transfer to the zero address");
894 
895         _beforeTokenTransfer(from, to, tokenId);
896 
897         // Clear approvals from the previous owner
898         _approve(address(0), tokenId);
899 
900         _holderTokens[from].remove(tokenId);
901         _holderTokens[to].add(tokenId);
902 
903         _tokenOwners.set(tokenId, to);
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
916         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
917         _tokenURIs[tokenId] = _tokenURI;
918     }
919 
920     /**
921      * @dev Internal function to set the base URI for all token IDs. It is
922      * automatically added as a prefix to the value returned in {tokenURI},
923      * or to the token ID if {tokenURI} is empty.
924      */
925     function _setBaseURI(string memory baseURI_) internal virtual {
926         _baseURI = baseURI_;
927     }
928 
929     /**
930      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
931      * The call is not executed if the target address is not a contract.
932      *
933      * @param from address representing the previous owner of the given token ID
934      * @param to target address that will receive the tokens
935      * @param tokenId uint256 ID of the token to be transferred
936      * @param _data bytes optional data to send along with the call
937      * @return bool whether the call correctly returned the expected magic value
938      */
939     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
940         private returns (bool)
941     {
942         if (!to.isContract()) {
943             return true;
944         }
945         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
946             IERC721Receiver(to).onERC721Received.selector,
947             _msgSender(),
948             from,
949             tokenId,
950             _data
951         ), "ERC721: transfer to non ERC721Receiver implementer");
952         bytes4 retval = abi.decode(returndata, (bytes4));
953         return (retval == _ERC721_RECEIVED);
954     }
955 
956     function _approve(address to, uint256 tokenId) private {
957         _tokenApprovals[tokenId] = to;
958         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
959     }
960 
961     /**
962      * @dev Hook that is called before any token transfer. This includes minting
963      * and burning.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` will be minted for `to`.
970      * - When `to` is zero, ``from``'s `tokenId` will be burned.
971      * - `from` cannot be the zero address.
972      * - `to` cannot be the zero address.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
977 }
978 
979 /**
980  * @title ERC721 token receiver interface
981  * @dev Interface for any contract that wants to support safeTransfers
982  * from ERC721 asset contracts.
983  */
984 interface IERC721Receiver {
985     /**
986      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
987      * by `operator` from `from`, this function is called.
988      *
989      * It must return its Solidity selector to confirm the token transfer.
990      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
991      *
992      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
993      */
994     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
995 }
996 
997 /**
998  * @dev Collection of functions related to the address type
999  */
1000 library Address {
1001     /**
1002      * @dev Returns true if `account` is a contract.
1003      *
1004      * [IMPORTANT]
1005      * ====
1006      * It is unsafe to assume that an address for which this function returns
1007      * false is an externally-owned account (EOA) and not a contract.
1008      *
1009      * Among others, `isContract` will return false for the following
1010      * types of addresses:
1011      *
1012      *  - an externally-owned account
1013      *  - a contract in construction
1014      *  - an address where a contract will be created
1015      *  - an address where a contract lived, but was destroyed
1016      * ====
1017      */
1018     function isContract(address account) internal view returns (bool) {
1019         // This method relies on extcodesize, which returns 0 for contracts in
1020         // construction, since the code is only stored at the end of the
1021         // constructor execution.
1022 
1023         uint256 size;
1024         // solhint-disable-next-line no-inline-assembly
1025         assembly { size := extcodesize(account) }
1026         return size > 0;
1027     }
1028 
1029     /**
1030      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1031      * `recipient`, forwarding all available gas and reverting on errors.
1032      *
1033      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1034      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1035      * imposed by `transfer`, making them unable to receive funds via
1036      * `transfer`. {sendValue} removes this limitation.
1037      *
1038      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1039      *
1040      * IMPORTANT: because control is transferred to `recipient`, care must be
1041      * taken to not create reentrancy vulnerabilities. Consider using
1042      * {ReentrancyGuard} or the
1043      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1044      */
1045     function sendValue(address payable recipient, uint256 amount) internal {
1046         require(address(this).balance >= amount, "Address: insufficient balance");
1047 
1048         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1049         (bool success, ) = recipient.call{ value: amount }("");
1050         require(success, "Address: unable to send value, recipient may have reverted");
1051     }
1052 
1053     /**
1054      * @dev Performs a Solidity function call using a low level `call`. A
1055      * plain`call` is an unsafe replacement for a function call: use this
1056      * function instead.
1057      *
1058      * If `target` reverts with a revert reason, it is bubbled up by this
1059      * function (like regular Solidity function calls).
1060      *
1061      * Returns the raw returned data. To convert to the expected return value,
1062      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1063      *
1064      * Requirements:
1065      *
1066      * - `target` must be a contract.
1067      * - calling `target` with `data` must not revert.
1068      *
1069      * _Available since v3.1._
1070      */
1071     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1072       return functionCall(target, data, "Address: low-level call failed");
1073     }
1074 
1075     /**
1076      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1077      * `errorMessage` as a fallback revert reason when `target` reverts.
1078      *
1079      * _Available since v3.1._
1080      */
1081     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1082         return functionCallWithValue(target, data, 0, errorMessage);
1083     }
1084 
1085     /**
1086      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1087      * but also transferring `value` wei to `target`.
1088      *
1089      * Requirements:
1090      *
1091      * - the calling contract must have an ETH balance of at least `value`.
1092      * - the called Solidity function must be `payable`.
1093      *
1094      * _Available since v3.1._
1095      */
1096     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1097         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1098     }
1099 
1100     /**
1101      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1102      * with `errorMessage` as a fallback revert reason when `target` reverts.
1103      *
1104      * _Available since v3.1._
1105      */
1106     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1107         require(address(this).balance >= value, "Address: insufficient balance for call");
1108         require(isContract(target), "Address: call to non-contract");
1109 
1110         // solhint-disable-next-line avoid-low-level-calls
1111         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1112         return _verifyCallResult(success, returndata, errorMessage);
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1117      * but performing a static call.
1118      *
1119      * _Available since v3.3._
1120      */
1121     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1122         return functionStaticCall(target, data, "Address: low-level static call failed");
1123     }
1124 
1125     /**
1126      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1127      * but performing a static call.
1128      *
1129      * _Available since v3.3._
1130      */
1131     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1132         require(isContract(target), "Address: static call to non-contract");
1133 
1134         // solhint-disable-next-line avoid-low-level-calls
1135         (bool success, bytes memory returndata) = target.staticcall(data);
1136         return _verifyCallResult(success, returndata, errorMessage);
1137     }
1138 
1139     /**
1140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1141      * but performing a delegate call.
1142      *
1143      * _Available since v3.4._
1144      */
1145     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1146         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1151      * but performing a delegate call.
1152      *
1153      * _Available since v3.4._
1154      */
1155     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1156         require(isContract(target), "Address: delegate call to non-contract");
1157 
1158         // solhint-disable-next-line avoid-low-level-calls
1159         (bool success, bytes memory returndata) = target.delegatecall(data);
1160         return _verifyCallResult(success, returndata, errorMessage);
1161     }
1162 
1163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1164         if (success) {
1165             return returndata;
1166         } else {
1167             // Look for revert reason and bubble it up if present
1168             if (returndata.length > 0) {
1169                 // The easiest way to bubble the revert reason is using memory via assembly
1170 
1171                 // solhint-disable-next-line no-inline-assembly
1172                 assembly {
1173                     let returndata_size := mload(returndata)
1174                     revert(add(32, returndata), returndata_size)
1175                 }
1176             } else {
1177                 revert(errorMessage);
1178             }
1179         }
1180     }
1181 }
1182 
1183 /**
1184  * @dev Library for managing an enumerable variant of Solidity's
1185  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1186  * type.
1187  *
1188  * Maps have the following properties:
1189  *
1190  * - Entries are added, removed, and checked for existence in constant time
1191  * (O(1)).
1192  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1193  *
1194  * ```
1195  * contract Example {
1196  *     // Add the library methods
1197  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1198  *
1199  *     // Declare a set state variable
1200  *     EnumerableMap.UintToAddressMap private myMap;
1201  * }
1202  * ```
1203  *
1204  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1205  * supported.
1206  */
1207 library EnumerableMap {
1208     // To implement this library for multiple types with as little code
1209     // repetition as possible, we write it in terms of a generic Map type with
1210     // bytes32 keys and values.
1211     // The Map implementation uses private functions, and user-facing
1212     // implementations (such as Uint256ToAddressMap) are just wrappers around
1213     // the underlying Map.
1214     // This means that we can only create new EnumerableMaps for types that fit
1215     // in bytes32.
1216 
1217     struct MapEntry {
1218         bytes32 _key;
1219         bytes32 _value;
1220     }
1221 
1222     struct Map {
1223         // Storage of map keys and values
1224         MapEntry[] _entries;
1225 
1226         // Position of the entry defined by a key in the `entries` array, plus 1
1227         // because index 0 means a key is not in the map.
1228         mapping (bytes32 => uint256) _indexes;
1229     }
1230 
1231     /**
1232      * @dev Adds a key-value pair to a map, or updates the value for an existing
1233      * key. O(1).
1234      *
1235      * Returns true if the key was added to the map, that is if it was not
1236      * already present.
1237      */
1238     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1239         // We read and store the key's index to prevent multiple reads from the same storage slot
1240         uint256 keyIndex = map._indexes[key];
1241 
1242         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1243             map._entries.push(MapEntry({ _key: key, _value: value }));
1244             // The entry is stored at length-1, but we add 1 to all indexes
1245             // and use 0 as a sentinel value
1246             map._indexes[key] = map._entries.length;
1247             return true;
1248         } else {
1249             map._entries[keyIndex - 1]._value = value;
1250             return false;
1251         }
1252     }
1253 
1254     /**
1255      * @dev Removes a key-value pair from a map. O(1).
1256      *
1257      * Returns true if the key was removed from the map, that is if it was present.
1258      */
1259     function _remove(Map storage map, bytes32 key) private returns (bool) {
1260         // We read and store the key's index to prevent multiple reads from the same storage slot
1261         uint256 keyIndex = map._indexes[key];
1262 
1263         if (keyIndex != 0) { // Equivalent to contains(map, key)
1264             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1265             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1266             // This modifies the order of the array, as noted in {at}.
1267 
1268             uint256 toDeleteIndex = keyIndex - 1;
1269             uint256 lastIndex = map._entries.length - 1;
1270 
1271             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1272             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1273 
1274             MapEntry storage lastEntry = map._entries[lastIndex];
1275 
1276             // Move the last entry to the index where the entry to delete is
1277             map._entries[toDeleteIndex] = lastEntry;
1278             // Update the index for the moved entry
1279             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1280 
1281             // Delete the slot where the moved entry was stored
1282             map._entries.pop();
1283 
1284             // Delete the index for the deleted slot
1285             delete map._indexes[key];
1286 
1287             return true;
1288         } else {
1289             return false;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns true if the key is in the map. O(1).
1295      */
1296     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1297         return map._indexes[key] != 0;
1298     }
1299 
1300     /**
1301      * @dev Returns the number of key-value pairs in the map. O(1).
1302      */
1303     function _length(Map storage map) private view returns (uint256) {
1304         return map._entries.length;
1305     }
1306 
1307    /**
1308     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1309     *
1310     * Note that there are no guarantees on the ordering of entries inside the
1311     * array, and it may change when more entries are added or removed.
1312     *
1313     * Requirements:
1314     *
1315     * - `index` must be strictly less than {length}.
1316     */
1317     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1318         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1319 
1320         MapEntry storage entry = map._entries[index];
1321         return (entry._key, entry._value);
1322     }
1323 
1324     /**
1325      * @dev Tries to returns the value associated with `key`.  O(1).
1326      * Does not revert if `key` is not in the map.
1327      */
1328     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1329         uint256 keyIndex = map._indexes[key];
1330         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1331         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1332     }
1333 
1334     /**
1335      * @dev Returns the value associated with `key`.  O(1).
1336      *
1337      * Requirements:
1338      *
1339      * - `key` must be in the map.
1340      */
1341     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1342         uint256 keyIndex = map._indexes[key];
1343         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1344         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1345     }
1346 
1347     /**
1348      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1349      *
1350      * CAUTION: This function is deprecated because it requires allocating memory for the error
1351      * message unnecessarily. For custom revert reasons use {_tryGet}.
1352      */
1353     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1354         uint256 keyIndex = map._indexes[key];
1355         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1356         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1357     }
1358 
1359     // UintToAddressMap
1360 
1361     struct UintToAddressMap {
1362         Map _inner;
1363     }
1364 
1365     /**
1366      * @dev Adds a key-value pair to a map, or updates the value for an existing
1367      * key. O(1).
1368      *
1369      * Returns true if the key was added to the map, that is if it was not
1370      * already present.
1371      */
1372     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1373         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1374     }
1375 
1376     /**
1377      * @dev Removes a value from a set. O(1).
1378      *
1379      * Returns true if the key was removed from the map, that is if it was present.
1380      */
1381     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1382         return _remove(map._inner, bytes32(key));
1383     }
1384 
1385     /**
1386      * @dev Returns true if the key is in the map. O(1).
1387      */
1388     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1389         return _contains(map._inner, bytes32(key));
1390     }
1391 
1392     /**
1393      * @dev Returns the number of elements in the map. O(1).
1394      */
1395     function length(UintToAddressMap storage map) internal view returns (uint256) {
1396         return _length(map._inner);
1397     }
1398 
1399    /**
1400     * @dev Returns the element stored at position `index` in the set. O(1).
1401     * Note that there are no guarantees on the ordering of values inside the
1402     * array, and it may change when more values are added or removed.
1403     *
1404     * Requirements:
1405     *
1406     * - `index` must be strictly less than {length}.
1407     */
1408     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1409         (bytes32 key, bytes32 value) = _at(map._inner, index);
1410         return (uint256(key), address(uint160(uint256(value))));
1411     }
1412 
1413     /**
1414      * @dev Tries to returns the value associated with `key`.  O(1).
1415      * Does not revert if `key` is not in the map.
1416      *
1417      * _Available since v3.4._
1418      */
1419     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1420         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1421         return (success, address(uint160(uint256(value))));
1422     }
1423 
1424     /**
1425      * @dev Returns the value associated with `key`.  O(1).
1426      *
1427      * Requirements:
1428      *
1429      * - `key` must be in the map.
1430      */
1431     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1432         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1433     }
1434 
1435     /**
1436      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1437      *
1438      * CAUTION: This function is deprecated because it requires allocating memory for the error
1439      * message unnecessarily. For custom revert reasons use {tryGet}.
1440      */
1441     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1442         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1443     }
1444 }
1445 
1446 /**
1447  * @dev Library for managing
1448  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1449  * types.
1450  *
1451  * Sets have the following properties:
1452  *
1453  * - Elements are added, removed, and checked for existence in constant time
1454  * (O(1)).
1455  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1456  *
1457  * ```
1458  * contract Example {
1459  *     // Add the library methods
1460  *     using EnumerableSet for EnumerableSet.AddressSet;
1461  *
1462  *     // Declare a set state variable
1463  *     EnumerableSet.AddressSet private mySet;
1464  * }
1465  * ```
1466  *
1467  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1468  * and `uint256` (`UintSet`) are supported.
1469  */
1470 library EnumerableSet {
1471     // To implement this library for multiple types with as little code
1472     // repetition as possible, we write it in terms of a generic Set type with
1473     // bytes32 values.
1474     // The Set implementation uses private functions, and user-facing
1475     // implementations (such as AddressSet) are just wrappers around the
1476     // underlying Set.
1477     // This means that we can only create new EnumerableSets for types that fit
1478     // in bytes32.
1479 
1480     struct Set {
1481         // Storage of set values
1482         bytes32[] _values;
1483 
1484         // Position of the value in the `values` array, plus 1 because index 0
1485         // means a value is not in the set.
1486         mapping (bytes32 => uint256) _indexes;
1487     }
1488 
1489     /**
1490      * @dev Add a value to a set. O(1).
1491      *
1492      * Returns true if the value was added to the set, that is if it was not
1493      * already present.
1494      */
1495     function _add(Set storage set, bytes32 value) private returns (bool) {
1496         if (!_contains(set, value)) {
1497             set._values.push(value);
1498             // The value is stored at length-1, but we add 1 to all indexes
1499             // and use 0 as a sentinel value
1500             set._indexes[value] = set._values.length;
1501             return true;
1502         } else {
1503             return false;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Removes a value from a set. O(1).
1509      *
1510      * Returns true if the value was removed from the set, that is if it was
1511      * present.
1512      */
1513     function _remove(Set storage set, bytes32 value) private returns (bool) {
1514         // We read and store the value's index to prevent multiple reads from the same storage slot
1515         uint256 valueIndex = set._indexes[value];
1516 
1517         if (valueIndex != 0) { // Equivalent to contains(set, value)
1518             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1519             // the array, and then remove the last element (sometimes called as 'swap and pop').
1520             // This modifies the order of the array, as noted in {at}.
1521 
1522             uint256 toDeleteIndex = valueIndex - 1;
1523             uint256 lastIndex = set._values.length - 1;
1524 
1525             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1526             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1527 
1528             bytes32 lastvalue = set._values[lastIndex];
1529 
1530             // Move the last value to the index where the value to delete is
1531             set._values[toDeleteIndex] = lastvalue;
1532             // Update the index for the moved value
1533             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1534 
1535             // Delete the slot where the moved value was stored
1536             set._values.pop();
1537 
1538             // Delete the index for the deleted slot
1539             delete set._indexes[value];
1540 
1541             return true;
1542         } else {
1543             return false;
1544         }
1545     }
1546 
1547     /**
1548      * @dev Returns true if the value is in the set. O(1).
1549      */
1550     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1551         return set._indexes[value] != 0;
1552     }
1553 
1554     /**
1555      * @dev Returns the number of values on the set. O(1).
1556      */
1557     function _length(Set storage set) private view returns (uint256) {
1558         return set._values.length;
1559     }
1560 
1561    /**
1562     * @dev Returns the value stored at position `index` in the set. O(1).
1563     *
1564     * Note that there are no guarantees on the ordering of values inside the
1565     * array, and it may change when more values are added or removed.
1566     *
1567     * Requirements:
1568     *
1569     * - `index` must be strictly less than {length}.
1570     */
1571     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1572         require(set._values.length > index, "EnumerableSet: index out of bounds");
1573         return set._values[index];
1574     }
1575 
1576     // Bytes32Set
1577 
1578     struct Bytes32Set {
1579         Set _inner;
1580     }
1581 
1582     /**
1583      * @dev Add a value to a set. O(1).
1584      *
1585      * Returns true if the value was added to the set, that is if it was not
1586      * already present.
1587      */
1588     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1589         return _add(set._inner, value);
1590     }
1591 
1592     /**
1593      * @dev Removes a value from a set. O(1).
1594      *
1595      * Returns true if the value was removed from the set, that is if it was
1596      * present.
1597      */
1598     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1599         return _remove(set._inner, value);
1600     }
1601 
1602     /**
1603      * @dev Returns true if the value is in the set. O(1).
1604      */
1605     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1606         return _contains(set._inner, value);
1607     }
1608 
1609     /**
1610      * @dev Returns the number of values in the set. O(1).
1611      */
1612     function length(Bytes32Set storage set) internal view returns (uint256) {
1613         return _length(set._inner);
1614     }
1615 
1616    /**
1617     * @dev Returns the value stored at position `index` in the set. O(1).
1618     *
1619     * Note that there are no guarantees on the ordering of values inside the
1620     * array, and it may change when more values are added or removed.
1621     *
1622     * Requirements:
1623     *
1624     * - `index` must be strictly less than {length}.
1625     */
1626     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1627         return _at(set._inner, index);
1628     }
1629 
1630     // AddressSet
1631 
1632     struct AddressSet {
1633         Set _inner;
1634     }
1635 
1636     /**
1637      * @dev Add a value to a set. O(1).
1638      *
1639      * Returns true if the value was added to the set, that is if it was not
1640      * already present.
1641      */
1642     function add(AddressSet storage set, address value) internal returns (bool) {
1643         return _add(set._inner, bytes32(uint256(uint160(value))));
1644     }
1645 
1646     /**
1647      * @dev Removes a value from a set. O(1).
1648      *
1649      * Returns true if the value was removed from the set, that is if it was
1650      * present.
1651      */
1652     function remove(AddressSet storage set, address value) internal returns (bool) {
1653         return _remove(set._inner, bytes32(uint256(uint160(value))));
1654     }
1655 
1656     /**
1657      * @dev Returns true if the value is in the set. O(1).
1658      */
1659     function contains(AddressSet storage set, address value) internal view returns (bool) {
1660         return _contains(set._inner, bytes32(uint256(uint160(value))));
1661     }
1662 
1663     /**
1664      * @dev Returns the number of values in the set. O(1).
1665      */
1666     function length(AddressSet storage set) internal view returns (uint256) {
1667         return _length(set._inner);
1668     }
1669 
1670    /**
1671     * @dev Returns the value stored at position `index` in the set. O(1).
1672     *
1673     * Note that there are no guarantees on the ordering of values inside the
1674     * array, and it may change when more values are added or removed.
1675     *
1676     * Requirements:
1677     *
1678     * - `index` must be strictly less than {length}.
1679     */
1680     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1681         return address(uint160(uint256(_at(set._inner, index))));
1682     }
1683 
1684 
1685     // UintSet
1686 
1687     struct UintSet {
1688         Set _inner;
1689     }
1690 
1691     /**
1692      * @dev Add a value to a set. O(1).
1693      *
1694      * Returns true if the value was added to the set, that is if it was not
1695      * already present.
1696      */
1697     function add(UintSet storage set, uint256 value) internal returns (bool) {
1698         return _add(set._inner, bytes32(value));
1699     }
1700 
1701     /**
1702      * @dev Removes a value from a set. O(1).
1703      *
1704      * Returns true if the value was removed from the set, that is if it was
1705      * present.
1706      */
1707     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1708         return _remove(set._inner, bytes32(value));
1709     }
1710 
1711     /**
1712      * @dev Returns true if the value is in the set. O(1).
1713      */
1714     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1715         return _contains(set._inner, bytes32(value));
1716     }
1717 
1718     /**
1719      * @dev Returns the number of values on the set. O(1).
1720      */
1721     function length(UintSet storage set) internal view returns (uint256) {
1722         return _length(set._inner);
1723     }
1724 
1725    /**
1726     * @dev Returns the value stored at position `index` in the set. O(1).
1727     *
1728     * Note that there are no guarantees on the ordering of values inside the
1729     * array, and it may change when more values are added or removed.
1730     *
1731     * Requirements:
1732     *
1733     * - `index` must be strictly less than {length}.
1734     */
1735     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1736         return uint256(_at(set._inner, index));
1737     }
1738 }
1739 
1740 /**
1741  * @dev String operations.
1742  */
1743 library Strings {
1744     /**
1745      * @dev Converts a `uint256` to its ASCII `string` representation.
1746      */
1747     function toString(uint256 value) internal pure returns (string memory) {
1748         // Inspired by OraclizeAPI's implementation - MIT licence
1749         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1750 
1751         if (value == 0) {
1752             return "0";
1753         }
1754         uint256 temp = value;
1755         uint256 digits;
1756         while (temp != 0) {
1757             digits++;
1758             temp /= 10;
1759         }
1760         bytes memory buffer = new bytes(digits);
1761         uint256 index = digits - 1;
1762         temp = value;
1763         while (temp != 0) {
1764             buffer[index--] = bytes1(uint8(48 + temp % 10));
1765             temp /= 10;
1766         }
1767         return string(buffer);
1768     }
1769 }
1770 
1771 contract BarnOwlzDinoPalz is ERC721, Ownable {
1772     
1773     using SafeMath for uint256;
1774 
1775     string public DINO_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN DINOS ARE ALL SOLD OUT
1776     
1777     string public LICENSE_TEXT = ""; 
1778     
1779     bool licenseLocked = false; 
1780 
1781     bool public saleIsActive = false;
1782     
1783     mapping(uint => string) public dinoNames;
1784     
1785     address public constant BARNOWLZ = 0x2a281305a50627a22eC3e7d82aE656AdFee6D964;
1786     
1787     event dinoNameChange(address _by, uint _tokenId, string _name);
1788     
1789     event licenseisLocked(string _licenseText);
1790 
1791     constructor() ERC721("Barn Owlz Dino Palz", "BODP") { }
1792     
1793     function withdraw() public onlyOwner {
1794         uint balance = address(this).balance;
1795         msg.sender.transfer(balance);
1796     }
1797 
1798     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1799         DINO_PROVENANCE = provenanceHash;
1800     }
1801 
1802     function setBaseURI(string memory baseURI) public onlyOwner {
1803         _setBaseURI(baseURI);
1804     }
1805 
1806     function flipSaleState() public onlyOwner {
1807         saleIsActive = !saleIsActive;
1808     }
1809     
1810     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1811         uint256 tokenCount = balanceOf(_owner);
1812         if (tokenCount == 0) {
1813             // Return an empty array
1814             return new uint256[](0);
1815         } else {
1816             uint256[] memory result = new uint256[](tokenCount);
1817             uint256 index;
1818             for (index = 0; index < tokenCount; index++) {
1819                 result[index] = tokenOfOwnerByIndex(_owner, index);
1820             }
1821             return result;
1822         }
1823     }
1824     
1825     // Returns the license for tokens
1826     function tokenLicense(uint _id) public view returns(string memory) {
1827         require(_id < totalSupply(), "CHOOSE A TOKEN WITHIN RANGE");
1828         return LICENSE_TEXT;
1829     }
1830     
1831     // Locks the license to prevent further changes 
1832     function lockLicense() public onlyOwner {
1833         licenseLocked =  true;
1834         emit licenseisLocked(LICENSE_TEXT);
1835     }
1836     
1837     // Change the license
1838     function changeLicense(string memory _license) public onlyOwner {
1839         require(licenseLocked == false, "License already locked");
1840         LICENSE_TEXT = _license;
1841     }
1842 
1843     function numberOfMintableTokens(address user) view public returns (uint256 mintableTokenNumber) {
1844         uint256 mintableTokens = 0;
1845         for (uint256 i = 0; i < IERC721Enumerable(BARNOWLZ).balanceOf(user); i++) {
1846             uint256 tokenId = IERC721Enumerable(BARNOWLZ).tokenOfOwnerByIndex(user, i);
1847             if (!isDinoClaimed(tokenId))
1848                 mintableTokens++;
1849         }
1850         return mintableTokens;
1851     }
1852                               
1853     function claimDino(uint256 numberOfTokens) public {
1854         require(saleIsActive, "Claim has not started yet");
1855         require(numberOfTokens <= 10, "You can't claim more than 10 companions in one transaction");
1856         require(numberOfTokens > 0, "You can't claim 0 companions");
1857 
1858         uint256 j = 0;
1859         for (uint256 i = 0; i < IERC721Enumerable(BARNOWLZ).balanceOf(msg.sender); i++) {
1860             uint256 tokenId = IERC721Enumerable(BARNOWLZ).tokenOfOwnerByIndex(msg.sender, i);
1861             if (!isDinoClaimed(tokenId)) {
1862                 _safeMint(msg.sender, tokenId);
1863                 j++;
1864             }
1865             if (j == numberOfTokens) {
1866                 break;
1867             }
1868         }
1869     }
1870 
1871     function isDinoClaimed(uint256 tokenId) view public returns (bool) {
1872         return _exists(tokenId);
1873     }
1874      
1875     function changeDinoName(uint _tokenId, string memory _name) public {
1876         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this dino!");
1877         require(sha256(bytes(_name)) != sha256(bytes(dinoNames[_tokenId])), "New name is same as the current one");
1878         dinoNames[_tokenId] = _name;
1879         
1880         emit dinoNameChange(msg.sender, _tokenId, _name);
1881     }
1882     
1883     function viewDinoName(uint _tokenId) public view returns( string memory ){
1884         require( _tokenId < totalSupply(), "Choose a dino within range" );
1885         return dinoNames[_tokenId];
1886     }
1887     
1888 }