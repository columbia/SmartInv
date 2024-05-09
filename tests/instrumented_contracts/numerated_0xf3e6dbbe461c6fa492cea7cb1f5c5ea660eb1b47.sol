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
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-165[EIP].
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others ({ERC165Checker}).
97  *
98  * For an implementation, see {ERC165}.
99  */
100 interface IERC165 {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 
113 /**
114  * @dev Implementation of the {IERC165} interface.
115  *
116  * Contracts may inherit from this and call {_registerInterface} to declare
117  * their support of an interface.
118  */
119 abstract contract ERC165 is IERC165 {
120     /*
121      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
122      */
123     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
124 
125     /**
126      * @dev Mapping of interface ids to whether or not it's supported.
127      */
128     mapping(bytes4 => bool) private _supportedInterfaces;
129 
130     constructor () internal {
131         // Derived contracts need only register support for their own interfaces,
132         // we register support for ERC165 itself here
133         _registerInterface(_INTERFACE_ID_ERC165);
134     }
135 
136     /**
137      * @dev See {IERC165-supportsInterface}.
138      *
139      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
142         return _supportedInterfaces[interfaceId];
143     }
144 
145     /**
146      * @dev Registers the contract as an implementer of the interface defined by
147      * `interfaceId`. Support of the actual ERC165 interface is automatic and
148      * registering its interface id is not required.
149      *
150      * See {IERC165-supportsInterface}.
151      *
152      * Requirements:
153      *
154      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
155      */
156     function _registerInterface(bytes4 interfaceId) internal virtual {
157         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
158         _supportedInterfaces[interfaceId] = true;
159     }
160 }
161 
162 /**
163  * @dev Wrappers over Solidity's arithmetic operations with added overflow
164  * checks.
165  *
166  * Arithmetic operations in Solidity wrap on overflow. This can easily result
167  * in bugs, because programmers usually assume that an overflow raises an
168  * error, which is the standard behavior in high level programming languages.
169  * `SafeMath` restores this intuition by reverting the transaction when an
170  * operation overflows.
171  *
172  * Using this library instead of the unchecked operations eliminates an entire
173  * class of bugs, so it's recommended to use it always.
174  */
175 library SafeMath {
176     /**
177      * @dev Returns the addition of two unsigned integers, with an overflow flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         uint256 c = a + b;
183         if (c < a) return (false, 0);
184         return (true, c);
185     }
186 
187     /**
188      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
189      *
190      * _Available since v3.4._
191      */
192     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
193         if (b > a) return (false, 0);
194         return (true, a - b);
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
199      *
200      * _Available since v3.4._
201      */
202     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) return (true, 0);
207         uint256 c = a * b;
208         if (c / a != b) return (false, 0);
209         return (true, c);
210     }
211 
212     /**
213      * @dev Returns the division of two unsigned integers, with a division by zero flag.
214      *
215      * _Available since v3.4._
216      */
217     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
218         if (b == 0) return (false, 0);
219         return (true, a / b);
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
224      *
225      * _Available since v3.4._
226      */
227     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
228         if (b == 0) return (false, 0);
229         return (true, a % b);
230     }
231 
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      *
240      * - Addition cannot overflow.
241      */
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         require(c >= a, "SafeMath: addition overflow");
245         return c;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      *
256      * - Subtraction cannot overflow.
257      */
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         require(b <= a, "SafeMath: subtraction overflow");
260         return a - b;
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `*` operator.
268      *
269      * Requirements:
270      *
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         if (a == 0) return 0;
275         uint256 c = a * b;
276         require(c / a == b, "SafeMath: multiplication overflow");
277         return c;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers, reverting on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b > 0, "SafeMath: division by zero");
294         return a / b;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting when dividing by zero.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
310         require(b > 0, "SafeMath: modulo by zero");
311         return a % b;
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
316      * overflow (when the result is negative).
317      *
318      * CAUTION: This function is deprecated because it requires allocating memory for the error
319      * message unnecessarily. For custom revert reasons use {trySub}.
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         return a - b;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
334      * division by zero. The result is rounded towards zero.
335      *
336      * CAUTION: This function is deprecated because it requires allocating memory for the error
337      * message unnecessarily. For custom revert reasons use {tryDiv}.
338      *
339      * Counterpart to Solidity's `/` operator. Note: this function uses a
340      * `revert` opcode (which leaves remaining gas untouched) while Solidity
341      * uses an invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b > 0, errorMessage);
349         return a / b;
350     }
351 
352     /**
353      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
354      * reverting with custom message when dividing by zero.
355      *
356      * CAUTION: This function is deprecated because it requires allocating memory for the error
357      * message unnecessarily. For custom revert reasons use {tryMod}.
358      *
359      * Counterpart to Solidity's `%` operator. This function uses a `revert`
360      * opcode (which leaves remaining gas untouched) while Solidity uses an
361      * invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
368         require(b > 0, errorMessage);
369         return a % b;
370     }
371 }
372 
373 
374 
375 /**
376  * @dev Required interface of an ERC721 compliant contract.
377  */
378 interface IERC721 is IERC165 {
379     /**
380      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
381      */
382     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
383 
384     /**
385      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
386      */
387     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
391      */
392     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
393 
394     /**
395      * @dev Returns the number of tokens in ``owner``'s account.
396      */
397     function balanceOf(address owner) external view returns (uint256 balance);
398 
399     /**
400      * @dev Returns the owner of the `tokenId` token.
401      *
402      * Requirements:
403      *
404      * - `tokenId` must exist.
405      */
406     function ownerOf(uint256 tokenId) external view returns (address owner);
407 
408     /**
409      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
410      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must exist and be owned by `from`.
417      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
418      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
419      *
420      * Emits a {Transfer} event.
421      */
422     function safeTransferFrom(address from, address to, uint256 tokenId) external;
423 
424     /**
425      * @dev Transfers `tokenId` token from `from` to `to`.
426      *
427      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(address from, address to, uint256 tokenId) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Returns the account approved for `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function getApproved(uint256 tokenId) external view returns (address operator);
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 
483     /**
484       * @dev Safely transfers `tokenId` token from `from` to `to`.
485       *
486       * Requirements:
487       *
488       * - `from` cannot be the zero address.
489       * - `to` cannot be the zero address.
490       * - `tokenId` token must exist and be owned by `from`.
491       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493       *
494       * Emits a {Transfer} event.
495       */
496     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
497 }
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Enumerable is IERC721 {
504 
505     /**
506      * @dev Returns the total amount of tokens stored by the contract.
507      */
508     function totalSupply() external view returns (uint256);
509 
510     /**
511      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
512      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
513      */
514     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
515 
516     /**
517      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
518      * Use along with {totalSupply} to enumerate all tokens.
519      */
520     function tokenByIndex(uint256 index) external view returns (uint256);
521 }
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Metadata is IERC721 {
528 
529     /**
530      * @dev Returns the token collection name.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the token collection symbol.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
541      */
542     function tokenURI(uint256 tokenId) external view returns (string memory);
543 }
544 
545 /**
546  * @title ERC721 Non-Fungible Token Standard basic implementation
547  * @dev see https://eips.ethereum.org/EIPS/eip-721
548  */
549 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
550     using SafeMath for uint256;
551     using Address for address;
552     using EnumerableSet for EnumerableSet.UintSet;
553     using EnumerableMap for EnumerableMap.UintToAddressMap;
554     using Strings for uint256;
555 
556     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
557     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
558     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
559 
560     // Mapping from holder address to their (enumerable) set of owned tokens
561     mapping (address => EnumerableSet.UintSet) private _holderTokens;
562 
563     // Enumerable mapping from token ids to their owners
564     EnumerableMap.UintToAddressMap private _tokenOwners;
565 
566     // Mapping from token ID to approved address
567     mapping (uint256 => address) private _tokenApprovals;
568 
569     // Mapping from owner to operator approvals
570     mapping (address => mapping (address => bool)) private _operatorApprovals;
571 
572     // Token name
573     string private _name;
574 
575     // Token symbol
576     string private _symbol;
577 
578     // Optional mapping for token URIs
579     mapping (uint256 => string) private _tokenURIs;
580 
581     // Base URI
582     string private _baseURI;
583 
584     /*
585      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
586      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
587      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
588      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
589      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
590      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
591      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
592      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
593      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
594      *
595      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
596      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
597      */
598     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
599 
600     /*
601      *     bytes4(keccak256('name()')) == 0x06fdde03
602      *     bytes4(keccak256('symbol()')) == 0x95d89b41
603      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
604      *
605      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
606      */
607     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
608 
609     /*
610      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
611      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
612      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
613      *
614      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
615      */
616     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
617 
618     /**
619      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
620      */
621     constructor (string memory name_, string memory symbol_) public {
622         _name = name_;
623         _symbol = symbol_;
624 
625         // register the supported interfaces to conform to ERC721 via ERC165
626         _registerInterface(_INTERFACE_ID_ERC721);
627         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
628         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _holderTokens[owner].length();
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-name}.
648      */
649     function name() public view virtual override returns (string memory) {
650         return _name;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-symbol}.
655      */
656     function symbol() public view virtual override returns (string memory) {
657         return _symbol;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-tokenURI}.
662      */
663     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
665 
666         string memory _tokenURI = _tokenURIs[tokenId];
667         string memory base = baseURI();
668 
669         // If there is no base URI, return the token URI.
670         if (bytes(base).length == 0) {
671             return _tokenURI;
672         }
673         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
674         if (bytes(_tokenURI).length > 0) {
675             return string(abi.encodePacked(base, _tokenURI));
676         }
677         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
678         return string(abi.encodePacked(base, tokenId.toString()));
679     }
680 
681     /**
682     * @dev Returns the base URI set via {_setBaseURI}. This will be
683     * automatically added as a prefix in {tokenURI} to each token's URI, or
684     * to the token ID if no specific URI is set for that token ID.
685     */
686     function baseURI() public view virtual returns (string memory) {
687         return _baseURI;
688     }
689 
690     /**
691      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
692      */
693     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
694         return _holderTokens[owner].at(index);
695     }
696 
697     /**
698      * @dev See {IERC721Enumerable-totalSupply}.
699      */
700     function totalSupply() public view virtual override returns (uint256) {
701         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
702         return _tokenOwners.length();
703     }
704 
705     /**
706      * @dev See {IERC721Enumerable-tokenByIndex}.
707      */
708     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
709         (uint256 tokenId, ) = _tokenOwners.at(index);
710         return tokenId;
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ERC721.ownerOf(tokenId);
718         require(to != owner, "ERC721: approval to current owner");
719 
720         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
721             "ERC721: approve caller is not owner nor approved for all"
722         );
723 
724         _approve(to, tokenId);
725     }
726 
727     /**
728      * @dev See {IERC721-getApproved}.
729      */
730     function getApproved(uint256 tokenId) public view virtual override returns (address) {
731         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
732 
733         return _tokenApprovals[tokenId];
734     }
735 
736     /**
737      * @dev See {IERC721-setApprovalForAll}.
738      */
739     function setApprovalForAll(address operator, bool approved) public virtual override {
740         require(operator != _msgSender(), "ERC721: approve to caller");
741 
742         _operatorApprovals[_msgSender()][operator] = approved;
743         emit ApprovalForAll(_msgSender(), operator, approved);
744     }
745 
746     /**
747      * @dev See {IERC721-isApprovedForAll}.
748      */
749     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
750         return _operatorApprovals[owner][operator];
751     }
752 
753     /**
754      * @dev See {IERC721-transferFrom}.
755      */
756     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
757         //solhint-disable-next-line max-line-length
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759 
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
767         safeTransferFrom(from, to, tokenId, "");
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
797         _transfer(from, to, tokenId);
798         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
799     }
800 
801     /**
802      * @dev Returns whether `tokenId` exists.
803      *
804      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
805      *
806      * Tokens start existing when they are minted (`_mint`),
807      * and stop existing when they are burned (`_burn`).
808      */
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return _tokenOwners.contains(tokenId);
811     }
812 
813     /**
814      * @dev Returns whether `spender` is allowed to manage `tokenId`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
821         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
822         address owner = ERC721.ownerOf(tokenId);
823         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
824     }
825 
826     /**
827      * @dev Safely mints `tokenId` and transfers it to `to`.
828      *
829      * Requirements:
830      d*
831      * - `tokenId` must not exist.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _safeMint(address to, uint256 tokenId) internal virtual {
837         _safeMint(to, tokenId, "");
838     }
839 
840     /**
841      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
842      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
843      */
844     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
845         _mint(to, tokenId);
846         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _holderTokens[to].add(tokenId);
868 
869         _tokenOwners.set(tokenId, to);
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721.ownerOf(tokenId); // internal owner
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         // Clear metadata (if any)
893         if (bytes(_tokenURIs[tokenId]).length != 0) {
894             delete _tokenURIs[tokenId];
895         }
896 
897         _holderTokens[owner].remove(tokenId);
898 
899         _tokenOwners.remove(tokenId);
900 
901         emit Transfer(owner, address(0), tokenId);
902     }
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _transfer(address from, address to, uint256 tokenId) internal virtual {
916         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
917         require(to != address(0), "ERC721: transfer to the zero address");
918 
919         _beforeTokenTransfer(from, to, tokenId);
920 
921         // Clear approvals from the previous owner
922         _approve(address(0), tokenId);
923 
924         _holderTokens[from].remove(tokenId);
925         _holderTokens[to].add(tokenId);
926 
927         _tokenOwners.set(tokenId, to);
928 
929         emit Transfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
940         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
941         _tokenURIs[tokenId] = _tokenURI;
942     }
943 
944     /**
945      * @dev Internal function to set the base URI for all token IDs. It is
946      * automatically added as a prefix to the value returned in {tokenURI},
947      * or to the token ID if {tokenURI} is empty.
948      */
949     function _setBaseURI(string memory baseURI_) internal virtual {
950         _baseURI = baseURI_;
951     }
952 
953     /**
954      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
955      * The call is not executed if the target address is not a contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
964         private returns (bool)
965     {
966         if (!to.isContract()) {
967             return true;
968         }
969         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
970             IERC721Receiver(to).onERC721Received.selector,
971             _msgSender(),
972             from,
973             tokenId,
974             _data
975         ), "ERC721: transfer to non ERC721Receiver implementer");
976         bytes4 retval = abi.decode(returndata, (bytes4));
977         return (retval == _ERC721_RECEIVED);
978     }
979 
980     function _approve(address to, uint256 tokenId) private {
981         _tokenApprovals[tokenId] = to;
982         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
983     }
984 
985     /**
986      * @dev Hook that is called before any token transfer. This includes minting
987      * and burning.
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` will be minted for `to`.
994      * - When `to` is zero, ``from``'s `tokenId` will be burned.
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      *
998      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
999      */
1000     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1001 }
1002 
1003 /**
1004  * @title ERC721 token receiver interface
1005  * @dev Interface for any contract that wants to support safeTransfers
1006  * from ERC721 asset contracts.
1007  */
1008 interface IERC721Receiver {
1009     /**
1010      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1011      * by `operator` from `from`, this function is called.
1012      *
1013      * It must return its Solidity selector to confirm the token transfer.
1014      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1015      *
1016      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1017      */
1018     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1019 }
1020 
1021 /**
1022  * @dev Collection of functions related to the address type
1023  */
1024 library Address {
1025     /**
1026      * @dev Returns true if `account` is a contract.
1027      *
1028      * [IMPORTANT]
1029      * ====
1030      * It is unsafe to assume that an address for which this function returns
1031      * false is an externally-owned account (EOA) and not a contract.
1032      *
1033      * Among others, `isContract` will return false for the following
1034      * types of addresses:
1035      *
1036      *  - an externally-owned account
1037      *  - a contract in construction
1038      *  - an address where a contract will be created
1039      *  - an address where a contract lived, but was destroyed
1040      * ====
1041      */
1042     function isContract(address account) internal view returns (bool) {
1043         // This method relies on extcodesize, which returns 0 for contracts in
1044         // construction, since the code is only stored at the end of the
1045         // constructor execution.
1046 
1047         uint256 size;
1048         // solhint-disable-next-line no-inline-assembly
1049         assembly { size := extcodesize(account) }
1050         return size > 0;
1051     }
1052 
1053     /**
1054      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1055      * `recipient`, forwarding all available gas and reverting on errors.
1056      *
1057      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1058      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1059      * imposed by `transfer`, making them unable to receive funds via
1060      * `transfer`. {sendValue} removes this limitation.
1061      *
1062      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1063      *
1064      * IMPORTANT: because control is transferred to `recipient`, care must be
1065      * taken to not create reentrancy vulnerabilities. Consider using
1066      * {ReentrancyGuard} or the
1067      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1068      */
1069     function sendValue(address payable recipient, uint256 amount) internal {
1070         require(address(this).balance >= amount, "Address: insufficient balance");
1071 
1072         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1073         (bool success, ) = recipient.call{ value: amount }("");
1074         require(success, "Address: unable to send value, recipient may have reverted");
1075     }
1076 
1077     /**
1078      * @dev Performs a Solidity function call using a low level `call`. A
1079      * plain`call` is an unsafe replacement for a function call: use this
1080      * function instead.
1081      *
1082      * If `target` reverts with a revert reason, it is bubbled up by this
1083      * function (like regular Solidity function calls).
1084      *
1085      * Returns the raw returned data. To convert to the expected return value,
1086      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1087      *
1088      * Requirements:
1089      *
1090      * - `target` must be a contract.
1091      * - calling `target` with `data` must not revert.
1092      *
1093      * _Available since v3.1._
1094      */
1095     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1096       return functionCall(target, data, "Address: low-level call failed");
1097     }
1098 
1099     /**
1100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1101      * `errorMessage` as a fallback revert reason when `target` reverts.
1102      *
1103      * _Available since v3.1._
1104      */
1105     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1106         return functionCallWithValue(target, data, 0, errorMessage);
1107     }
1108 
1109     /**
1110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1111      * but also transferring `value` wei to `target`.
1112      *
1113      * Requirements:
1114      *
1115      * - the calling contract must have an ETH balance of at least `value`.
1116      * - the called Solidity function must be `payable`.
1117      *
1118      * _Available since v3.1._
1119      */
1120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1122     }
1123 
1124     /**
1125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1126      * with `errorMessage` as a fallback revert reason when `target` reverts.
1127      *
1128      * _Available since v3.1._
1129      */
1130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1131         require(address(this).balance >= value, "Address: insufficient balance for call");
1132         require(isContract(target), "Address: call to non-contract");
1133 
1134         // solhint-disable-next-line avoid-low-level-calls
1135         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1136         return _verifyCallResult(success, returndata, errorMessage);
1137     }
1138 
1139     /**
1140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1141      * but performing a static call.
1142      *
1143      * _Available since v3.3._
1144      */
1145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1146         return functionStaticCall(target, data, "Address: low-level static call failed");
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1151      * but performing a static call.
1152      *
1153      * _Available since v3.3._
1154      */
1155     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1156         require(isContract(target), "Address: static call to non-contract");
1157 
1158         // solhint-disable-next-line avoid-low-level-calls
1159         (bool success, bytes memory returndata) = target.staticcall(data);
1160         return _verifyCallResult(success, returndata, errorMessage);
1161     }
1162 
1163     /**
1164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1165      * but performing a delegate call.
1166      *
1167      * _Available since v3.4._
1168      */
1169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1171     }
1172 
1173     /**
1174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1175      * but performing a delegate call.
1176      *
1177      * _Available since v3.4._
1178      */
1179     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1180         require(isContract(target), "Address: delegate call to non-contract");
1181 
1182         // solhint-disable-next-line avoid-low-level-calls
1183         (bool success, bytes memory returndata) = target.delegatecall(data);
1184         return _verifyCallResult(success, returndata, errorMessage);
1185     }
1186 
1187     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1188         if (success) {
1189             return returndata;
1190         } else {
1191             // Look for revert reason and bubble it up if present
1192             if (returndata.length > 0) {
1193                 // The easiest way to bubble the revert reason is using memory via assembly
1194 
1195                 // solhint-disable-next-line no-inline-assembly
1196                 assembly {
1197                     let returndata_size := mload(returndata)
1198                     revert(add(32, returndata), returndata_size)
1199                 }
1200             } else {
1201                 revert(errorMessage);
1202             }
1203         }
1204     }
1205 }
1206 
1207 /**
1208  * @dev Library for managing an enumerable variant of Solidity's
1209  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1210  * type.
1211  *
1212  * Maps have the following properties:
1213  *
1214  * - Entries are added, removed, and checked for existence in constant time
1215  * (O(1)).
1216  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1217  *
1218  * ```
1219  * contract Example {
1220  *     // Add the library methods
1221  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1222  *
1223  *     // Declare a set state variable
1224  *     EnumerableMap.UintToAddressMap private myMap;
1225  * }
1226  * ```
1227  *
1228  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1229  * supported.
1230  */
1231 library EnumerableMap {
1232     // To implement this library for multiple types with as little code
1233     // repetition as possible, we write it in terms of a generic Map type with
1234     // bytes32 keys and values.
1235     // The Map implementation uses private functions, and user-facing
1236     // implementations (such as Uint256ToAddressMap) are just wrappers around
1237     // the underlying Map.
1238     // This means that we can only create new EnumerableMaps for types that fit
1239     // in bytes32.
1240 
1241     struct MapEntry {
1242         bytes32 _key;
1243         bytes32 _value;
1244     }
1245 
1246     struct Map {
1247         // Storage of map keys and values
1248         MapEntry[] _entries;
1249 
1250         // Position of the entry defined by a key in the `entries` array, plus 1
1251         // because index 0 means a key is not in the map.
1252         mapping (bytes32 => uint256) _indexes;
1253     }
1254 
1255     /**
1256      * @dev Adds a key-value pair to a map, or updates the value for an existing
1257      * key. O(1).
1258      *
1259      * Returns true if the key was added to the map, that is if it was not
1260      * already present.
1261      */
1262     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1263         // We read and store the key's index to prevent multiple reads from the same storage slot
1264         uint256 keyIndex = map._indexes[key];
1265 
1266         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1267             map._entries.push(MapEntry({ _key: key, _value: value }));
1268             // The entry is stored at length-1, but we add 1 to all indexes
1269             // and use 0 as a sentinel value
1270             map._indexes[key] = map._entries.length;
1271             return true;
1272         } else {
1273             map._entries[keyIndex - 1]._value = value;
1274             return false;
1275         }
1276     }
1277 
1278     /**
1279      * @dev Removes a key-value pair from a map. O(1).
1280      *
1281      * Returns true if the key was removed from the map, that is if it was present.
1282      */
1283     function _remove(Map storage map, bytes32 key) private returns (bool) {
1284         // We read and store the key's index to prevent multiple reads from the same storage slot
1285         uint256 keyIndex = map._indexes[key];
1286 
1287         if (keyIndex != 0) { // Equivalent to contains(map, key)
1288             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1289             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1290             // This modifies the order of the array, as noted in {at}.
1291 
1292             uint256 toDeleteIndex = keyIndex - 1;
1293             uint256 lastIndex = map._entries.length - 1;
1294 
1295             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1296             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1297 
1298             MapEntry storage lastEntry = map._entries[lastIndex];
1299 
1300             // Move the last entry to the index where the entry to delete is
1301             map._entries[toDeleteIndex] = lastEntry;
1302             // Update the index for the moved entry
1303             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1304 
1305             // Delete the slot where the moved entry was stored
1306             map._entries.pop();
1307 
1308             // Delete the index for the deleted slot
1309             delete map._indexes[key];
1310 
1311             return true;
1312         } else {
1313             return false;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Returns true if the key is in the map. O(1).
1319      */
1320     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1321         return map._indexes[key] != 0;
1322     }
1323 
1324     /**
1325      * @dev Returns the number of key-value pairs in the map. O(1).
1326      */
1327     function _length(Map storage map) private view returns (uint256) {
1328         return map._entries.length;
1329     }
1330 
1331    /**
1332     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1333     *
1334     * Note that there are no guarantees on the ordering of entries inside the
1335     * array, and it may change when more entries are added or removed.
1336     *
1337     * Requirements:
1338     *
1339     * - `index` must be strictly less than {length}.
1340     */
1341     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1342         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1343 
1344         MapEntry storage entry = map._entries[index];
1345         return (entry._key, entry._value);
1346     }
1347 
1348     /**
1349      * @dev Tries to returns the value associated with `key`.  O(1).
1350      * Does not revert if `key` is not in the map.
1351      */
1352     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1353         uint256 keyIndex = map._indexes[key];
1354         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1355         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1356     }
1357 
1358     /**
1359      * @dev Returns the value associated with `key`.  O(1).
1360      *
1361      * Requirements:
1362      *
1363      * - `key` must be in the map.
1364      */
1365     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1366         uint256 keyIndex = map._indexes[key];
1367         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1368         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1369     }
1370 
1371     /**
1372      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1373      *
1374      * CAUTION: This function is deprecated because it requires allocating memory for the error
1375      * message unnecessarily. For custom revert reasons use {_tryGet}.
1376      */
1377     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1378         uint256 keyIndex = map._indexes[key];
1379         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1380         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1381     }
1382 
1383     // UintToAddressMap
1384 
1385     struct UintToAddressMap {
1386         Map _inner;
1387     }
1388 
1389     /**
1390      * @dev Adds a key-value pair to a map, or updates the value for an existing
1391      * key. O(1).
1392      *
1393      * Returns true if the key was added to the map, that is if it was not
1394      * already present.
1395      */
1396     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1397         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1398     }
1399 
1400     /**
1401      * @dev Removes a value from a set. O(1).
1402      *
1403      * Returns true if the key was removed from the map, that is if it was present.
1404      */
1405     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1406         return _remove(map._inner, bytes32(key));
1407     }
1408 
1409     /**
1410      * @dev Returns true if the key is in the map. O(1).
1411      */
1412     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1413         return _contains(map._inner, bytes32(key));
1414     }
1415 
1416     /**
1417      * @dev Returns the number of elements in the map. O(1).
1418      */
1419     function length(UintToAddressMap storage map) internal view returns (uint256) {
1420         return _length(map._inner);
1421     }
1422 
1423    /**
1424     * @dev Returns the element stored at position `index` in the set. O(1).
1425     * Note that there are no guarantees on the ordering of values inside the
1426     * array, and it may change when more values are added or removed.
1427     *
1428     * Requirements:
1429     *
1430     * - `index` must be strictly less than {length}.
1431     */
1432     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1433         (bytes32 key, bytes32 value) = _at(map._inner, index);
1434         return (uint256(key), address(uint160(uint256(value))));
1435     }
1436 
1437     /**
1438      * @dev Tries to returns the value associated with `key`.  O(1).
1439      * Does not revert if `key` is not in the map.
1440      *
1441      * _Available since v3.4._
1442      */
1443     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1444         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1445         return (success, address(uint160(uint256(value))));
1446     }
1447 
1448     /**
1449      * @dev Returns the value associated with `key`.  O(1).
1450      *
1451      * Requirements:
1452      *
1453      * - `key` must be in the map.
1454      */
1455     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1456         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1457     }
1458 
1459     /**
1460      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1461      *
1462      * CAUTION: This function is deprecated because it requires allocating memory for the error
1463      * message unnecessarily. For custom revert reasons use {tryGet}.
1464      */
1465     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1466         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1467     }
1468 }
1469 
1470 /**
1471  * @dev Library for managing
1472  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1473  * types.
1474  *
1475  * Sets have the following properties:
1476  *
1477  * - Elements are added, removed, and checked for existence in constant time
1478  * (O(1)).
1479  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1480  *
1481  * ```
1482  * contract Example {
1483  *     // Add the library methods
1484  *     using EnumerableSet for EnumerableSet.AddressSet;
1485  *
1486  *     // Declare a set state variable
1487  *     EnumerableSet.AddressSet private mySet;
1488  * }
1489  * ```
1490  *
1491  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1492  * and `uint256` (`UintSet`) are supported.
1493  */
1494 library EnumerableSet {
1495     // To implement this library for multiple types with as little code
1496     // repetition as possible, we write it in terms of a generic Set type with
1497     // bytes32 values.
1498     // The Set implementation uses private functions, and user-facing
1499     // implementations (such as AddressSet) are just wrappers around the
1500     // underlying Set.
1501     // This means that we can only create new EnumerableSets for types that fit
1502     // in bytes32.
1503 
1504     struct Set {
1505         // Storage of set values
1506         bytes32[] _values;
1507 
1508         // Position of the value in the `values` array, plus 1 because index 0
1509         // means a value is not in the set.
1510         mapping (bytes32 => uint256) _indexes;
1511     }
1512 
1513     /**
1514      * @dev Add a value to a set. O(1).
1515      *
1516      * Returns true if the value was added to the set, that is if it was not
1517      * already present.
1518      */
1519     function _add(Set storage set, bytes32 value) private returns (bool) {
1520         if (!_contains(set, value)) {
1521             set._values.push(value);
1522             // The value is stored at length-1, but we add 1 to all indexes
1523             // and use 0 as a sentinel value
1524             set._indexes[value] = set._values.length;
1525             return true;
1526         } else {
1527             return false;
1528         }
1529     }
1530 
1531     /**
1532      * @dev Removes a value from a set. O(1).
1533      *
1534      * Returns true if the value was removed from the set, that is if it was
1535      * present.
1536      */
1537     function _remove(Set storage set, bytes32 value) private returns (bool) {
1538         // We read and store the value's index to prevent multiple reads from the same storage slot
1539         uint256 valueIndex = set._indexes[value];
1540 
1541         if (valueIndex != 0) { // Equivalent to contains(set, value)
1542             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1543             // the array, and then remove the last element (sometimes called as 'swap and pop').
1544             // This modifies the order of the array, as noted in {at}.
1545 
1546             uint256 toDeleteIndex = valueIndex - 1;
1547             uint256 lastIndex = set._values.length - 1;
1548 
1549             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1550             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1551 
1552             bytes32 lastvalue = set._values[lastIndex];
1553 
1554             // Move the last value to the index where the value to delete is
1555             set._values[toDeleteIndex] = lastvalue;
1556             // Update the index for the moved value
1557             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1558 
1559             // Delete the slot where the moved value was stored
1560             set._values.pop();
1561 
1562             // Delete the index for the deleted slot
1563             delete set._indexes[value];
1564 
1565             return true;
1566         } else {
1567             return false;
1568         }
1569     }
1570 
1571     /**
1572      * @dev Returns true if the value is in the set. O(1).
1573      */
1574     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1575         return set._indexes[value] != 0;
1576     }
1577 
1578     /**
1579      * @dev Returns the number of values on the set. O(1).
1580      */
1581     function _length(Set storage set) private view returns (uint256) {
1582         return set._values.length;
1583     }
1584 
1585    /**
1586     * @dev Returns the value stored at position `index` in the set. O(1).
1587     *
1588     * Note that there are no guarantees on the ordering of values inside the
1589     * array, and it may change when more values are added or removed.
1590     *
1591     * Requirements:
1592     *
1593     * - `index` must be strictly less than {length}.
1594     */
1595     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1596         require(set._values.length > index, "EnumerableSet: index out of bounds");
1597         return set._values[index];
1598     }
1599 
1600     // Bytes32Set
1601 
1602     struct Bytes32Set {
1603         Set _inner;
1604     }
1605 
1606     /**
1607      * @dev Add a value to a set. O(1).
1608      *
1609      * Returns true if the value was added to the set, that is if it was not
1610      * already present.
1611      */
1612     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1613         return _add(set._inner, value);
1614     }
1615 
1616     /**
1617      * @dev Removes a value from a set. O(1).
1618      *
1619      * Returns true if the value was removed from the set, that is if it was
1620      * present.
1621      */
1622     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1623         return _remove(set._inner, value);
1624     }
1625 
1626     /**
1627      * @dev Returns true if the value is in the set. O(1).
1628      */
1629     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1630         return _contains(set._inner, value);
1631     }
1632 
1633     /**
1634      * @dev Returns the number of values in the set. O(1).
1635      */
1636     function length(Bytes32Set storage set) internal view returns (uint256) {
1637         return _length(set._inner);
1638     }
1639 
1640    /**
1641     * @dev Returns the value stored at position `index` in the set. O(1).
1642     *
1643     * Note that there are no guarantees on the ordering of values inside the
1644     * array, and it may change when more values are added or removed.
1645     *
1646     * Requirements:
1647     *
1648     * - `index` must be strictly less than {length}.
1649     */
1650     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1651         return _at(set._inner, index);
1652     }
1653 
1654     // AddressSet
1655 
1656     struct AddressSet {
1657         Set _inner;
1658     }
1659 
1660     /**
1661      * @dev Add a value to a set. O(1).
1662      *
1663      * Returns true if the value was added to the set, that is if it was not
1664      * already present.
1665      */
1666     function add(AddressSet storage set, address value) internal returns (bool) {
1667         return _add(set._inner, bytes32(uint256(uint160(value))));
1668     }
1669 
1670     /**
1671      * @dev Removes a value from a set. O(1).
1672      *
1673      * Returns true if the value was removed from the set, that is if it was
1674      * present.
1675      */
1676     function remove(AddressSet storage set, address value) internal returns (bool) {
1677         return _remove(set._inner, bytes32(uint256(uint160(value))));
1678     }
1679 
1680     /**
1681      * @dev Returns true if the value is in the set. O(1).
1682      */
1683     function contains(AddressSet storage set, address value) internal view returns (bool) {
1684         return _contains(set._inner, bytes32(uint256(uint160(value))));
1685     }
1686 
1687     /**
1688      * @dev Returns the number of values in the set. O(1).
1689      */
1690     function length(AddressSet storage set) internal view returns (uint256) {
1691         return _length(set._inner);
1692     }
1693 
1694    /**
1695     * @dev Returns the value stored at position `index` in the set. O(1).
1696     *
1697     * Note that there are no guarantees on the ordering of values inside the
1698     * array, and it may change when more values are added or removed.
1699     *
1700     * Requirements:
1701     *
1702     * - `index` must be strictly less than {length}.
1703     */
1704     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1705         return address(uint160(uint256(_at(set._inner, index))));
1706     }
1707 
1708 
1709     // UintSet
1710 
1711     struct UintSet {
1712         Set _inner;
1713     }
1714 
1715     /**
1716      * @dev Add a value to a set. O(1).
1717      *
1718      * Returns true if the value was added to the set, that is if it was not
1719      * already present.
1720      */
1721     function add(UintSet storage set, uint256 value) internal returns (bool) {
1722         return _add(set._inner, bytes32(value));
1723     }
1724 
1725     /**
1726      * @dev Removes a value from a set. O(1).
1727      *
1728      * Returns true if the value was removed from the set, that is if it was
1729      * present.
1730      */
1731     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1732         return _remove(set._inner, bytes32(value));
1733     }
1734 
1735     /**
1736      * @dev Returns true if the value is in the set. O(1).
1737      */
1738     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1739         return _contains(set._inner, bytes32(value));
1740     }
1741 
1742     /**
1743      * @dev Returns the number of values on the set. O(1).
1744      */
1745     function length(UintSet storage set) internal view returns (uint256) {
1746         return _length(set._inner);
1747     }
1748 
1749    /**
1750     * @dev Returns the value stored at position `index` in the set. O(1).
1751     *
1752     * Note that there are no guarantees on the ordering of values inside the
1753     * array, and it may change when more values are added or removed.
1754     *
1755     * Requirements:
1756     *
1757     * - `index` must be strictly less than {length}.
1758     */
1759     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1760         return uint256(_at(set._inner, index));
1761     }
1762 }
1763 
1764 /**
1765  * @dev String operations.
1766  */
1767 library Strings {
1768     /**
1769      * @dev Converts a `uint256` to its ASCII `string` representation.
1770      */
1771     function toString(uint256 value) internal pure returns (string memory) {
1772         // Inspired by OraclizeAPI's implementation - MIT licence
1773         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1774 
1775         if (value == 0) {
1776             return "0";
1777         }
1778         uint256 temp = value;
1779         uint256 digits;
1780         while (temp != 0) {
1781             digits++;
1782             temp /= 10;
1783         }
1784         bytes memory buffer = new bytes(digits);
1785         uint256 index = digits - 1;
1786         temp = value;
1787         while (temp != 0) {
1788             buffer[index--] = bytes1(uint8(48 + temp % 10));
1789             temp /= 10;
1790         }
1791         return string(buffer);
1792     }
1793 }
1794 
1795 contract FameLadySquad is ERC721, Ownable {
1796 
1797     using SafeMath for uint256;
1798     using Strings for uint256;
1799 
1800     // Time of when the sale starts.
1801     uint256 public SALE_START_TIMESTAMP = 1622556649;
1802 
1803     // Maximum amount of Ladys in existance. 
1804     uint256 public constant MAX_LADY_SUPPLY = 8888;
1805 
1806     constructor(string memory name, string memory symbol, string memory baseURI) ERC721(name, symbol) {
1807         _setBaseURI(baseURI);
1808 
1809         // Mint 30 Ladies for airdrop and gift purposes
1810         
1811         for (uint i = 0; i < 30; i++) {
1812             uint mintIndex = totalSupply();
1813             _safeMint(msg.sender, mintIndex);
1814         }
1815     }
1816 
1817     /**
1818     * @dev Gets current Lady price based on current supply.
1819     */
1820     function getNFTPrice(uint256 amount) public view returns (uint256) {
1821         //require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet so you can't get a price yet.");
1822         require(totalSupply() < MAX_LADY_SUPPLY, "Sale has already ended, no more Ladies left to sell.");
1823 
1824         return amount.mul(0.05 ether);
1825     }
1826 
1827 
1828     /**
1829     * @dev Mints yourself a Lady. Or more.
1830     */
1831     function mintLady(uint256 numberOfLadies) public payable {
1832         // Some exceptions that need to be handled.
1833         require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started yet so you can't get a price yet.");
1834         require(totalSupply() < MAX_LADY_SUPPLY, "Sale has already ended.");
1835         require(numberOfLadies > 0, "You cannot mint 0 Ladies.");
1836         require(numberOfLadies <= 20, "You are not allowed to buy this many Ladies at once in this price tier.");
1837         require(SafeMath.add(totalSupply(), numberOfLadies) <= MAX_LADY_SUPPLY, "Exceeds maximum Ladies supply. Please try to mint less Ladies.");
1838         require(getNFTPrice(numberOfLadies) == msg.value, "Amount of Ether sent is not correct.");
1839 
1840         // Mint the amount of provided Ladies.
1841         for (uint i = 0; i < numberOfLadies; i++) {
1842             uint mintIndex = totalSupply();
1843             _safeMint(msg.sender, mintIndex);
1844         }
1845     }
1846 
1847     /**
1848     * @dev Withdraw ether from this contract (Callable by owner only)
1849     */
1850     function withdraw(uint256 amount) onlyOwner public {
1851         msg.sender.transfer(amount);
1852     }
1853 
1854     /**
1855     * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
1856     */
1857     function changeBaseURI(string memory baseURI) onlyOwner public {
1858        _setBaseURI(baseURI);
1859     }
1860 
1861     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1862         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1863 
1864         return string(abi.encodePacked(baseURI(), tokenId.toString()));
1865     }
1866 
1867 }