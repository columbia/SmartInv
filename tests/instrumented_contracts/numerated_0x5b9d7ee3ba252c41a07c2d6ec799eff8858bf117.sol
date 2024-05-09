1 // File: contracts/Flattened-NFTMatcha-v0.5.7.sol
2 
3 /**
4 
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKKKXXXXKKKKKKXXNWWMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMWNXKKKKXXNWWWWMMWWWWMWWWWNXXXKKKXNWMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMWNXKKKXNWMMMMMMMMMNOdxKWMMMMMMMMWNXKKKXNWMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMWXKKKNWMMMMMMMMMMMMNx:;;l0WMMMMMMMMMMMWNK0KXWMMMMMMMMMMMM
11 MMMMMMMMMMMWXKKXWMMMMMMMMMMMMMMXd:;;;;cOWMMMMMMMMMMMMMWXKKXWMMMMMMMMMM
12 MMMMMMMMMWNKKXWMMMMMMMMMMMMMMWKo;;col:;:kNMMMMMMMMMMMMMMWX0KNWMMMMMMMM
13 MMMMMMMMWX0XWMMMMMMMMMMMMMMMWOl;;oKWXkc;:dXMMMMMMMMMMMMMMMWX0XWMMMMMMM
14 MMMMMMMNKKNWMMMMMMMMMMMMMMMNkc;:dXMMMWOc;;oKWMMMMMMMMMMMMMMWNKKNMMMMMM
15 MMMMMMNKKNMMMMMMMMMMMMMMMMNx:;:xNMMMMMW0l;;l0WMMMMMMMWMMMMMMMNKKNMMMMM
16 MMMMMNKKNMMMMMMMMMMMMMMMMXd:;ckNMMMMMMMMKo:;cOWMMMMXkxkXWMMMMMNKKNMMMM
17 MMMMWK0NMMMMMMMMMMMMMMMWKo;;l0WMMMMMMMMMMXx:;:xNMMW0lccxXMMMMMMN0KWMMM
18 MMMMX0XWMMMMMMWWMMMMMMWOl;;oKWMMMMMMMMMMMMNkc;:dXMMNklcoKMMMMMMMX0XMMM
19 MMMWKKNMMWK0OkkkkkkKWNkc;:dXMMMMMMMMMMMMMMMWOl;;oKWMXdcxNMMMMMMMNKKWMM
20 MMMN0XWMMWNXX0OdlccdKOc;:xNMMMWXKKXNWNNNNWWMW0o;;l0WNkdKWMMMMMMMWX0NMM
21 MMMX0XMMMMMMMMMN0dlcdOxoONMMMMW0xdddddodxk0KNWXd:;l0Kx0WMMMMMMMMMX0XMM
22 MMMX0NMMMMMMMMMMWXxlcoOXWMMMMWKkolclodkKNNNNWWMNxcxOkKWMMMMMMMMMMX0XMM
23 MMMX0XMMMMMMMMMMMMNklclkNMMWXklccodxdodKWMMMMMMMNKOkKWMMMMMMMMMMMX0XMM
24 MMMN0XWMMMMMMMMMMMMNOoclxXN0occcdKX0xlco0WMMMMMMNOOXMMMMMMMMMMMMMX0NMM
25 MMMWKKWMMMMMMMMMMMMMW0dccoxocccdKWMWNklclONMMMMXOONMMMMMMMMMMMMMWKKWMM
26 MMMMX0XMMMMMMMMMMMMMMWKdcccccco0WMMMMNOoclkNWWKk0NMMMMMMMMMMMMMMX0XWMM
27 MMMMWKKNMMMMMMMMMMMMMMMXxlcccckNMMMMMMW0oclxK0kKWMMMMMMMMMMMMMMNKKWMMM
28 MMMMMN0KWMMMMMMMMMMMMMMMNklccoKWMMMMMMMWKdlcoxKWMMMMMMMMMMMMMMWK0NMMMM
29 MMMMMMN0KWMMMMMMMMMMMMMMMNOod0KXWMMMMMMNK0xoxXWMMMMMMMMMMMMMMWK0NMMMMM
30 MMMMMMMN0KNMMMMMMMMMMMMMMMWXKkll0WMMMMXdcoOKNMMMMMMMMMMMMMMMNK0NMMMMMM
31 MMMMMMMMNK0XWMMMMMMMMMMMMMMMNd:;cOWMWKo:;c0WMMMMMMMMMMMMMMWX0KNMMMMMMM
32 MMMMMMMMMWXKKNWMMMMMMMMMMMMMMXd:;cx0kl;;l0WMMMMMMMMMMMMMWNKKXWMMMMMMMM
33 MMMMMMMMMMMWX0KNWMMMMMMMMMMMMMNkc;;::;:oKWMMMMMMMMMMMMWNK0XWMMMMMMMMMM
34 MMMMMMMMMMMMMNXKKXNWMMMMMMMMMMMWOc;;;:dXMMMMMMMMMMMWNXKKXWMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMWNKKKXNWMMMMMMMMMW0l:ckNMMMMMMMMMWNXKKKNWMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMWNXKKKXXNWWWMMMMX0KWMMMWWWNXXKKKXNWMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKXXXXXXXXXXKKKKXXNWWMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNNNNNNNNNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 
41 
42 ---------------------- [ WPSmartContracts.com ] ----------------------
43 
44                        [ Blockchain Made Easy ]
45 
46 
47     |
48     |  ERC-721 NFT Marketplace
49     |
50     |----------------------------
51     |
52     |  Flavors
53     |
54     |  >  Matcha: Fully featured ERC-721 Token, with Buy, 
55     |     Sell and Auction NFT Marketplace
56     |
57 
58 
59 */
60 
61 pragma solidity ^0.5.7;
62 
63 /**
64  * @dev Interface of the ERC165 standard, as defined in the
65  * https://eips.ethereum.org/EIPS/eip-165[EIP].
66  *
67  * Implementers can declare support of contract interfaces, which can then be
68  * queried by others ({ERC165Checker}).
69  *
70  * For an implementation, see {ERC165}.
71  */
72 interface IERC165 {
73     /**
74      * @dev Returns true if this contract implements the interface defined by
75      * `interfaceId`. See the corresponding
76      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
77      * to learn more about how these ids are created.
78      *
79      * This function call must use less than 30 000 gas.
80      */
81     function supportsInterface(bytes4 interfaceId) external view returns (bool);
82 }
83 
84 /**
85  * @dev Required interface of an ERC721 compliant contract.
86  */
87 contract IERC721 is IERC165 {
88     event Transfer(
89         address indexed from,
90         address indexed to,
91         uint256 indexed tokenId
92     );
93     event Approval(
94         address indexed owner,
95         address indexed approved,
96         uint256 indexed tokenId
97     );
98     event ApprovalForAll(
99         address indexed owner,
100         address indexed operator,
101         bool approved
102     );
103 
104     /**
105      * @dev Returns the number of NFTs in `owner`'s account.
106      */
107     function balanceOf(address owner) public view returns (uint256 balance);
108 
109     /**
110      * @dev Returns the owner of the NFT specified by `tokenId`.
111      */
112     function ownerOf(uint256 tokenId) public view returns (address owner);
113 
114     /**
115      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
116      * another (`to`).
117      *
118      *
119      *
120      * Requirements:
121      * - `from`, `to` cannot be zero.
122      * - `tokenId` must be owned by `from`.
123      * - If the caller is not `from`, it must be have been allowed to move this
124      * NFT by either {approve} or {setApproveForAll}.
125      */
126     function safeTransferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) public;
131 
132     /**
133      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
134      * another (`to`).
135      *
136      * Requirements:
137      * - If the caller is not `from`, it must be approved to move this NFT by
138      * either {approve} or {setApproveForAll}.
139      */
140     function transferFrom(
141         address from,
142         address to,
143         uint256 tokenId
144     ) public;
145 
146     function approve(address to, uint256 tokenId) public;
147 
148     function getApproved(uint256 tokenId)
149         public
150         view
151         returns (address operator);
152 
153     function setApprovalForAll(address operator, bool _approved) public;
154 
155     function isApprovedForAll(address owner, address operator)
156         public
157         view
158         returns (bool);
159 
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes memory data
165     ) public;
166 }
167 
168 /**
169  * @title ERC721 token receiver interface
170  * @dev Interface for any contract that wants to support safeTransfers
171  * from ERC721 asset contracts.
172  */
173 contract IERC721Receiver {
174     /**
175      * @notice Handle the receipt of an NFT
176      * @dev The ERC721 smart contract calls this function on the recipient
177      * after a {IERC721-safeTransfer}. This function MUST return the function selector,
178      * otherwise the caller will revert the transaction. The selector to be
179      * returned can be obtained as `this.onERC721Received.selector`. This
180      * function MAY throw to revert and reject the transfer.
181      * Note: the ERC721 contract address is always the message sender.
182      * @param operator The address which called `safeTransferFrom` function
183      * @param from The address which previously owned the token
184      * @param tokenId The NFT identifier which is being transferred
185      * @param data Additional data with no specified format
186      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
187      */
188     function onERC721Received(
189         address operator,
190         address from,
191         uint256 tokenId,
192         bytes memory data
193     ) public returns (bytes4);
194 }
195 
196 /**
197  * @dev Wrappers over Solidity's arithmetic operations with added overflow
198  * checks.
199  *
200  * Arithmetic operations in Solidity wrap on overflow. This can easily result
201  * in bugs, because programmers usually assume that an overflow raises an
202  * error, which is the standard behavior in high level programming languages.
203  * `SafeMath` restores this intuition by reverting the transaction when an
204  * operation overflows.
205  *
206  * Using this library instead of the unchecked operations eliminates an entire
207  * class of bugs, so it's recommended to use it always.
208  */
209 library SafeMath {
210     /**
211      * @dev Returns the addition of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `+` operator.
215      *
216      * Requirements:
217      * - Addition cannot overflow.
218      */
219     function add(uint256 a, uint256 b) internal pure returns (uint256) {
220         uint256 c = a + b;
221         require(c >= a, "SafeMath: addition overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b <= a, "SafeMath: subtraction overflow");
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `*` operator.
247      *
248      * Requirements:
249      * - Multiplication cannot overflow.
250      */
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
253         // benefit is lost if 'b' is also tested.
254         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
255         if (a == 0) {
256             return 0;
257         }
258 
259         uint256 c = a * b;
260         require(c / a == b, "SafeMath: multiplication overflow");
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         // Solidity only automatically asserts when dividing by 0
278         require(b > 0, "SafeMath: division by zero");
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         require(b != 0, "SafeMath: modulo by zero");
298         return a % b;
299     }
300 }
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * This test is non-exhaustive, and there may be false-negatives: during the
310      * execution of a contract's constructor, its address will be reported as
311      * not containing a contract.
312      *
313      * IMPORTANT: It is unsafe to assume that an address for which this
314      * function returns false is an externally-owned account (EOA) and not a
315      * contract.
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies in extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
323         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
324         // for accounts without code, i.e. `keccak256('')`
325         bytes32 codehash;
326         bytes32 accountHash =
327             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
328         // solhint-disable-next-line no-inline-assembly
329         assembly {
330             codehash := extcodehash(account)
331         }
332         return (codehash != 0x0 && codehash != accountHash);
333     }
334 
335     /**
336      * @dev Converts an `address` into `address payable`. Note that this is
337      * simply a type cast: the actual underlying value is not changed.
338      */
339     function toPayable(address account)
340         internal
341         pure
342         returns (address payable)
343     {
344         return address(uint160(account));
345     }
346 }
347 
348 /**
349  * @title Counters
350  * @author Matt Condon (@shrugs)
351  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
352  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
353  *
354  * Include with `using Counters for Counters.Counter;`
355  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
356  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
357  * directly accessed.
358  */
359 library Counters {
360     using SafeMath for uint256;
361 
362     struct Counter {
363         // This variable should never be directly accessed by users of the library: interactions must be restricted to
364         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
365         // this feature: see https://github.com/ethereum/solidity/issues/4637
366         uint256 _value; // default: 0
367     }
368 
369     function current(Counter storage counter) internal view returns (uint256) {
370         return counter._value;
371     }
372 
373     function increment(Counter storage counter) internal {
374         counter._value += 1;
375     }
376 
377     function decrement(Counter storage counter) internal {
378         counter._value = counter._value.sub(1);
379     }
380 }
381 
382 /**
383  * @dev Implementation of the {IERC165} interface.
384  *
385  * Contracts may inherit from this and call {_registerInterface} to declare
386  * their support of an interface.
387  */
388 contract ERC165 is IERC165 {
389     /*
390      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
391      */
392     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
393 
394     /**
395      * @dev Mapping of interface ids to whether or not it's supported.
396      */
397     mapping(bytes4 => bool) private _supportedInterfaces;
398 
399     constructor() internal {
400         // Derived contracts need only register support for their own interfaces,
401         // we register support for ERC165 itself here
402         _registerInterface(_INTERFACE_ID_ERC165);
403     }
404 
405     /**
406      * @dev See {IERC165-supportsInterface}.
407      *
408      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
409      */
410     function supportsInterface(bytes4 interfaceId)
411         external
412         view
413         returns (bool)
414     {
415         return _supportedInterfaces[interfaceId];
416     }
417 
418     /**
419      * @dev Registers the contract as an implementer of the interface defined by
420      * `interfaceId`. Support of the actual ERC165 interface is automatic and
421      * registering its interface id is not required.
422      *
423      * See {IERC165-supportsInterface}.
424      *
425      * Requirements:
426      *
427      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
428      */
429     function _registerInterface(bytes4 interfaceId) internal {
430         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
431         _supportedInterfaces[interfaceId] = true;
432     }
433 }
434 
435 /**
436  * @title ERC721 Non-Fungible Token Standard basic implementation
437  * @dev see https://eips.ethereum.org/EIPS/eip-721
438  */
439 contract ERC721 is ERC165, IERC721 {
440     using SafeMath for uint256;
441     using Address for address;
442     using Counters for Counters.Counter;
443 
444     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
445     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
446     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
447 
448     // Mapping from token ID to owner
449     mapping(uint256 => address) private _tokenOwner;
450 
451     // Mapping from token ID to approved address
452     mapping(uint256 => address) private _tokenApprovals;
453 
454     // Mapping from owner to number of owned token
455     mapping(address => Counters.Counter) private _ownedTokensCount;
456 
457     // Mapping from owner to operator approvals
458     mapping(address => mapping(address => bool)) private _operatorApprovals;
459 
460     /*
461      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
462      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
463      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
464      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
465      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
466      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
467      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
468      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
469      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
470      *
471      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
472      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
473      */
474     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
475 
476     constructor() public {
477         // register the supported interfaces to conform to ERC721 via ERC165
478         _registerInterface(_INTERFACE_ID_ERC721);
479     }
480 
481     /**
482      * @dev Gets the balance of the specified address.
483      * @param owner address to query the balance of
484      * @return uint256 representing the amount owned by the passed address
485      */
486     function balanceOf(address owner) public view returns (uint256) {
487         require(
488             owner != address(0),
489             "ERC721: balance query for the zero address"
490         );
491 
492         return _ownedTokensCount[owner].current();
493     }
494 
495     /**
496      * @dev Gets the owner of the specified token ID.
497      * @param tokenId uint256 ID of the token to query the owner of
498      * @return address currently marked as the owner of the given token ID
499      */
500     function ownerOf(uint256 tokenId) public view returns (address) {
501         address owner = _tokenOwner[tokenId];
502         require(
503             owner != address(0),
504             "ERC721: owner query for nonexistent token"
505         );
506 
507         return owner;
508     }
509 
510     /**
511      * @dev Approves another address to transfer the given token ID
512      * The zero address indicates there is no approved address.
513      * There can only be one approved address per token at a given time.
514      * Can only be called by the token owner or an approved operator.
515      * @param to address to be approved for the given token ID
516      * @param tokenId uint256 ID of the token to be approved
517      */
518     function approve(address to, uint256 tokenId) public {
519         address owner = ownerOf(tokenId);
520         require(to != owner, "ERC721: approval to current owner");
521 
522         require(
523             msg.sender == owner || isApprovedForAll(owner, msg.sender),
524             "ERC721: approve caller is not owner nor approved for all"
525         );
526 
527         _tokenApprovals[tokenId] = to;
528         emit Approval(owner, to, tokenId);
529     }
530 
531     /**
532      * @dev Gets the approved address for a token ID, or zero if no address set
533      * Reverts if the token ID does not exist.
534      * @param tokenId uint256 ID of the token to query the approval of
535      * @return address currently approved for the given token ID
536      */
537     function getApproved(uint256 tokenId) public view returns (address) {
538         require(
539             _exists(tokenId),
540             "ERC721: approved query for nonexistent token"
541         );
542 
543         return _tokenApprovals[tokenId];
544     }
545 
546     /**
547      * @dev Sets or unsets the approval of a given operator
548      * An operator is allowed to transfer all tokens of the sender on their behalf.
549      * @param to operator address to set the approval
550      * @param approved representing the status of the approval to be set
551      */
552     function setApprovalForAll(address to, bool approved) public {
553         require(to != msg.sender, "ERC721: approve to caller");
554 
555         _operatorApprovals[msg.sender][to] = approved;
556         emit ApprovalForAll(msg.sender, to, approved);
557     }
558 
559     /**
560      * @dev Tells whether an operator is approved by a given owner.
561      * @param owner owner address which you want to query the approval of
562      * @param operator operator address which you want to query the approval of
563      * @return bool whether the given operator is approved by the given owner
564      */
565     function isApprovedForAll(address owner, address operator)
566         public
567         view
568         returns (bool)
569     {
570         return _operatorApprovals[owner][operator];
571     }
572 
573     /**
574      * @dev Transfers the ownership of a given token ID to another address.
575      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
576      * Requires the msg.sender to be the owner, approved, or operator.
577      * @param from current owner of the token
578      * @param to address to receive the ownership of the given token ID
579      * @param tokenId uint256 ID of the token to be transferred
580      */
581     function transferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) public {
586         //solhint-disable-next-line max-line-length
587         require(
588             _isApprovedOrOwner(msg.sender, tokenId),
589             "ERC721: transfer caller is not owner nor approved"
590         );
591 
592         _transferFrom(from, to, tokenId);
593     }
594 
595     /**
596      * @dev Safely transfers the ownership of a given token ID to another address
597      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
598      * which is called upon a safe transfer, and return the magic value
599      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
600      * the transfer is reverted.
601      * Requires the msg.sender to be the owner, approved, or operator
602      * @param from current owner of the token
603      * @param to address to receive the ownership of the given token ID
604      * @param tokenId uint256 ID of the token to be transferred
605      */
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) public {
611         safeTransferFrom(from, to, tokenId, "");
612     }
613 
614     /**
615      * @dev Safely transfers the ownership of a given token ID to another address
616      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
617      * which is called upon a safe transfer, and return the magic value
618      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
619      * the transfer is reverted.
620      * Requires the msg.sender to be the owner, approved, or operator
621      * @param from current owner of the token
622      * @param to address to receive the ownership of the given token ID
623      * @param tokenId uint256 ID of the token to be transferred
624      * @param _data bytes data to send along with a safe transfer check
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes memory _data
631     ) public {
632         transferFrom(from, to, tokenId);
633         require(
634             _checkOnERC721Received(from, to, tokenId, _data),
635             "ERC721: transfer to non ERC721Receiver implementer"
636         );
637     }
638 
639     /**
640      * @dev Returns whether the specified token exists.
641      * @param tokenId uint256 ID of the token to query the existence of
642      * @return bool whether the token exists
643      */
644     function _exists(uint256 tokenId) internal view returns (bool) {
645         address owner = _tokenOwner[tokenId];
646         return owner != address(0);
647     }
648 
649     /**
650      * @dev Returns whether the given spender can transfer a given token ID.
651      * @param spender address of the spender to query
652      * @param tokenId uint256 ID of the token to be transferred
653      * @return bool whether the msg.sender is approved for the given token ID,
654      * is an operator of the owner, or is the owner of the token
655      */
656     function _isApprovedOrOwner(address spender, uint256 tokenId)
657         internal
658         view
659         returns (bool)
660     {
661         require(
662             _exists(tokenId),
663             "ERC721: operator query for nonexistent token"
664         );
665         address owner = ownerOf(tokenId);
666         return (spender == owner ||
667             getApproved(tokenId) == spender ||
668             isApprovedForAll(owner, spender));
669     }
670 
671     /**
672      * @dev Internal function to mint a new token.
673      * Reverts if the given token ID already exists.
674      * @param to The address that will own the minted token
675      * @param tokenId uint256 ID of the token to be minted
676      */
677     function _mint(address to, uint256 tokenId) internal {
678         require(to != address(0), "ERC721: mint to the zero address");
679         require(!_exists(tokenId), "ERC721: token already minted");
680 
681         _tokenOwner[tokenId] = to;
682         _ownedTokensCount[to].increment();
683 
684         emit Transfer(address(0), to, tokenId);
685     }
686 
687     /**
688      * @dev Internal function to transfer ownership of a given token ID to another address.
689      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
690      * @param from current owner of the token
691      * @param to address to receive the ownership of the given token ID
692      * @param tokenId uint256 ID of the token to be transferred
693      */
694     function _transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) internal {
699         require(
700             ownerOf(tokenId) == from,
701             "ERC721: transfer of token that is not own"
702         );
703         require(to != address(0), "ERC721: transfer to the zero address");
704 
705         _clearApproval(tokenId);
706 
707         _ownedTokensCount[from].decrement();
708         _ownedTokensCount[to].increment();
709 
710         _tokenOwner[tokenId] = to;
711 
712         emit Transfer(from, to, tokenId);
713     }
714 
715     /**
716      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
717      * The call is not executed if the target address is not a contract.
718      *
719      * This function is deprecated.
720      * @param from address representing the previous owner of the given token ID
721      * @param to target address that will receive the tokens
722      * @param tokenId uint256 ID of the token to be transferred
723      * @param _data bytes optional data to send along with the call
724      * @return bool whether the call correctly returned the expected magic value
725      */
726     function _checkOnERC721Received(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) internal returns (bool) {
732         if (!to.isContract()) {
733             return true;
734         }
735 
736         bytes4 retval =
737             IERC721Receiver(to).onERC721Received(
738                 msg.sender,
739                 from,
740                 tokenId,
741                 _data
742             );
743         return (retval == _ERC721_RECEIVED);
744     }
745 
746     /**
747      * @dev Private function to clear current approval of a given token ID.
748      * @param tokenId uint256 ID of the token to be transferred
749      */
750     function _clearApproval(uint256 tokenId) private {
751         if (_tokenApprovals[tokenId] != address(0)) {
752             _tokenApprovals[tokenId] = address(0);
753         }
754     }
755 }
756 
757 /**
758  * @title Roles
759  * @dev Library for managing addresses assigned to a Role.
760  */
761 library Roles {
762     struct Role {
763         mapping(address => bool) bearer;
764     }
765 
766     /**
767      * @dev Give an account access to this role.
768      */
769     function add(Role storage role, address account) internal {
770         require(!has(role, account), "Roles: account already has role");
771         role.bearer[account] = true;
772     }
773 
774     /**
775      * @dev Remove an account's access to this role.
776      */
777     function remove(Role storage role, address account) internal {
778         require(has(role, account), "Roles: account does not have role");
779         role.bearer[account] = false;
780     }
781 
782     /**
783      * @dev Check if an account has this role.
784      * @return bool
785      */
786     function has(Role storage role, address account)
787         internal
788         view
789         returns (bool)
790     {
791         require(account != address(0), "Roles: account is the zero address");
792         return role.bearer[account];
793     }
794 }
795 
796 contract MinterRole {
797     using Roles for Roles.Role;
798 
799     event MinterAdded(address indexed account);
800     event MinterRemoved(address indexed account);
801 
802     Roles.Role private _minters;
803 
804     constructor() internal {
805         _addMinter(msg.sender);
806     }
807 
808     modifier onlyMinter() {
809         require(
810             isMinter(msg.sender),
811             "MinterRole: caller does not have the Minter role"
812         );
813         _;
814     }
815 
816     function isMinter(address account) public view returns (bool) {
817         return _minters.has(account);
818     }
819 
820     function addMinter(address account) public onlyMinter {
821         _addMinter(account);
822     }
823 
824     function renounceMinter() public {
825         _removeMinter(msg.sender);
826     }
827 
828     function _addMinter(address account) internal {
829         _minters.add(account);
830         emit MinterAdded(account);
831     }
832 
833     function _removeMinter(address account) internal {
834         _minters.remove(account);
835         emit MinterRemoved(account);
836     }
837 }
838 
839 /**
840  * @title ERC721Mintable
841  * @dev ERC721 minting logic.
842  */
843 contract ERC721Mintable is ERC721, MinterRole {
844 
845     bool public anyoneCanMint;
846     
847     /**
848      * @dev Options to activate or deactivate mint ability
849      */
850 
851     function _setMintableOption(bool _anyoneCanMint) internal {
852         anyoneCanMint = _anyoneCanMint;
853     }
854 
855     /**
856      * @dev Function to mint tokens.
857      * @param to The address that will receive the minted tokens.
858      * @param tokenId The token id to mint.
859      * @return A boolean that indicates if the operation was successful.
860      */
861     function mint(address to, uint256 tokenId)
862         public
863         onlyMinter
864         returns (bool)
865     {
866         _mint(to, tokenId);
867         return true;
868     }
869 
870     function canIMint() public view returns (bool) {
871         return anyoneCanMint || isMinter(msg.sender);
872     }
873 
874     /**
875      * Open modifier to anyone can mint possibility
876      */
877     modifier onlyMinter() {
878         string memory mensaje;
879         require(
880             canIMint(),
881             "MinterRole: caller does not have the Minter role"
882         );
883         _;
884     }
885 
886 }
887 
888 /**
889  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
890  * @dev See https://eips.ethereum.org/EIPS/eip-721
891  */
892 contract IERC721Enumerable is IERC721 {
893     function totalSupply() public view returns (uint256);
894     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
895     function tokenByIndex(uint256 index) public view returns (uint256);
896 }
897 
898 /**
899  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
900  * @dev See https://eips.ethereum.org/EIPS/eip-721
901  */
902 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
903     // Mapping from owner to list of owned token IDs
904     mapping(address => uint256[]) private _ownedTokens;
905 
906     // Mapping from token ID to index of the owner tokens list
907     mapping(uint256 => uint256) private _ownedTokensIndex;
908 
909     // Array with all token ids, used for enumeration
910     uint256[] private _allTokens;
911 
912     // Mapping from token id to position in the allTokens array
913     mapping(uint256 => uint256) private _allTokensIndex;
914 
915     /*
916      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
917      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
918      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
919      *
920      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
921      */
922     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
923 
924     /**
925      * @dev Constructor function.
926      */
927     constructor () public {
928         // register the supported interface to conform to ERC721Enumerable via ERC165
929         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
930     }
931 
932     /**
933      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
934      * @param owner address owning the tokens list to be accessed
935      * @param index uint256 representing the index to be accessed of the requested tokens list
936      * @return uint256 token ID at the given index of the tokens list owned by the requested address
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
939         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
940         return _ownedTokens[owner][index];
941     }
942 
943     /**
944      * @dev Gets the total amount of tokens stored by the contract.
945      * @return uint256 representing the total amount of tokens
946      */
947     function totalSupply() public view returns (uint256) {
948         return _allTokens.length;
949     }
950 
951     /**
952      * @dev Gets the token ID at a given index of all the tokens in this contract
953      * Reverts if the index is greater or equal to the total number of tokens.
954      * @param index uint256 representing the index to be accessed of the tokens list
955      * @return uint256 token ID at the given index of the tokens list
956      */
957     function tokenByIndex(uint256 index) public view returns (uint256) {
958         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
959         return _allTokens[index];
960     }
961 
962     /**
963      * @dev Internal function to transfer ownership of a given token ID to another address.
964      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
965      * @param from current owner of the token
966      * @param to address to receive the ownership of the given token ID
967      * @param tokenId uint256 ID of the token to be transferred
968      */
969     function _transferFrom(address from, address to, uint256 tokenId) internal {
970         super._transferFrom(from, to, tokenId);
971 
972         _removeTokenFromOwnerEnumeration(from, tokenId);
973 
974         _addTokenToOwnerEnumeration(to, tokenId);
975     }
976 
977     /**
978      * @dev Internal function to mint a new token.
979      * Reverts if the given token ID already exists.
980      * @param to address the beneficiary that will own the minted token
981      * @param tokenId uint256 ID of the token to be minted
982      */
983     function _mint(address to, uint256 tokenId) internal {
984         super._mint(to, tokenId);
985 
986         _addTokenToOwnerEnumeration(to, tokenId);
987 
988         _addTokenToAllTokensEnumeration(tokenId);
989     }
990 
991     /**
992      * @dev Gets the list of token IDs of the requested owner.
993      * @param owner address owning the tokens
994      * @return uint256[] List of token IDs owned by the requested address
995      */
996     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
997         return _ownedTokens[owner];
998     }
999 
1000     /**
1001      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1002      * @param to address representing the new owner of the given token ID
1003      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1004      */
1005     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1006         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1007         _ownedTokens[to].push(tokenId);
1008     }
1009 
1010     /**
1011      * @dev Private function to add a token to this extension's token tracking data structures.
1012      * @param tokenId uint256 ID of the token to be added to the tokens list
1013      */
1014     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1015         _allTokensIndex[tokenId] = _allTokens.length;
1016         _allTokens.push(tokenId);
1017     }
1018 
1019     /**
1020      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1021      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1022      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1023      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1024      * @param from address representing the previous owner of the given token ID
1025      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1026      */
1027     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1028         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1029         // then delete the last slot (swap and pop).
1030 
1031         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1032         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1033 
1034         // When the token to delete is the last token, the swap operation is unnecessary
1035         if (tokenIndex != lastTokenIndex) {
1036             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1037 
1038             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1039             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1040         }
1041 
1042         // This also deletes the contents at the last position of the array
1043         _ownedTokens[from].length--;
1044 
1045         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1046         // lastTokenId, or just over the end of the array if the token was the last one).
1047     }
1048 
1049 }
1050 
1051 /**
1052  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1053  * @dev See https://eips.ethereum.org/EIPS/eip-721
1054  */
1055 contract IERC721Metadata is IERC721 {
1056     function name() external view returns (string memory);
1057     function symbol() external view returns (string memory);
1058     function tokenURI(uint256 tokenId) external view returns (string memory);
1059 }
1060 
1061 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1062     // Token name
1063     string private _name;
1064 
1065     // Token symbol
1066     string private _symbol;
1067 
1068     // Whether to display the real token URI
1069     bool public opened;
1070 
1071     // Optional mapping for token URIs
1072     mapping(uint256 => string) private _tokenURIs;
1073 
1074     /*
1075      *     bytes4(keccak256('name()')) == 0x06fdde03
1076      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1077      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1078      *
1079      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1080      */
1081     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1082 
1083     /**
1084      * @dev Constructor function
1085      */
1086     constructor (string memory name, string memory symbol) public {
1087         _name = name;
1088         _symbol = symbol;
1089 
1090         // register the supported interfaces to conform to ERC721 via ERC165
1091         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1092     }
1093 
1094     /**
1095      * @dev Gets the token name.
1096      * @return string representing the token name
1097      */
1098     function name() external view returns (string memory) {
1099         return _name;
1100     }
1101 
1102     /**
1103      * @dev Gets the token symbol.
1104      * @return string representing the token symbol
1105      */
1106     function symbol() external view returns (string memory) {
1107         return _symbol;
1108     }
1109 
1110     /**
1111      * @dev Returns an URI for a given token ID.
1112      * Throws if the token ID does not exist. May return an empty string.
1113      * @param tokenId uint256 ID of the token to query
1114      */
1115     function tokenURI(uint256 tokenId) external view returns (string memory) {
1116         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1117         if (opened) {
1118             return _tokenURIs[tokenId];
1119         } else {
1120             return "https://nftstorage.link/ipfs/bafkreibtcne3eh64i2qggvmwded2o3hn42xch34fwed5awxkkmd7a6vu24";
1121         }
1122     }
1123 
1124     /**
1125      * @dev Internal function to set the token URI for a given token.
1126      * Reverts if the token ID does not exist.
1127      * @param tokenId uint256 ID of the token to set its URI
1128      * @param uri string URI to assign
1129      */
1130     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1131         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1132         _tokenURIs[tokenId] = uri;
1133     }
1134 }
1135 
1136 /**
1137  * @title ERC721MetadataMintable
1138  * @dev ERC721 minting logic with metadata.
1139  */
1140 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
1141     /**
1142      * @dev Function to mint tokens.
1143      * @param to The address that will receive the minted tokens.
1144      * @param tokenId The token id to mint.
1145      * @param tokenURI The token URI of the minted token.
1146      * @return A boolean that indicates if the operation was successful.
1147      */
1148     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
1149         return _mintWithTokenURI(to, tokenId, tokenURI);
1150     }
1151 
1152     function _mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) internal returns (bool) {
1153         _mint(to, tokenId);
1154         _setTokenURI(tokenId, tokenURI);
1155         return true;
1156     } 
1157 }
1158 
1159 /**
1160  * @title ERC721
1161  * Full ERC-721 Token with automint function
1162  */
1163 
1164 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata, ERC721Mintable, ERC721MetadataMintable {
1165 
1166     uint256 autoTokenId;
1167     constructor (string memory name, string memory symbol, bool _anyoneCanMint) public 
1168         ERC721Mintable() 
1169         ERC721Metadata(name, symbol) {
1170         // solhint-disable-previous-line no-empty-blocks
1171 
1172         _setMintableOption(_anyoneCanMint);
1173 
1174     }
1175 
1176     function exists(uint256 tokenId) public view returns (bool) {
1177         return _exists(tokenId);
1178     }
1179 
1180     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1181         return _tokensOfOwner(owner);
1182     }
1183 
1184     function setTokenURI(uint256 tokenId, string memory uri) public {
1185         _setTokenURI(tokenId, uri);
1186     }
1187 
1188     /**
1189      * @dev Function to mint tokens with automatic ID
1190      * @param to The address that will receive the minted tokens.
1191      * @return A boolean that indicates if the operation was successful.
1192      */
1193     function autoMint(string memory tokenURI, address to) public onlyMinter returns (uint256) {
1194         do {
1195             autoTokenId++;
1196         } while(_exists(autoTokenId));
1197         _mint(to, autoTokenId);
1198         _setTokenURI(autoTokenId, tokenURI);
1199         return autoTokenId;
1200     }
1201 
1202     /**
1203      * @dev Function to transfer tokens
1204      * @param to The address that will receive the minted tokens.
1205      * @param tokenId the token ID
1206      */
1207     function transfer(
1208         address to,
1209         uint256 tokenId
1210     ) public {
1211         _transferFrom(msg.sender, to, tokenId);
1212     }
1213 
1214 }
1215 
1216 /**
1217  * @dev Contract module that helps prevent reentrant calls to a function.
1218  *
1219  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1220  * available, which can be aplied to functions to make sure there are no nested
1221  * (reentrant) calls to them.
1222  *
1223  * Note that because there is a single `nonReentrant` guard, functions marked as
1224  * `nonReentrant` may not call one another. This can be worked around by making
1225  * those functions `private`, and then adding `external` `nonReentrant` entry
1226  * points to them.
1227  */
1228 contract ReentrancyGuard {
1229     // counter to allow mutex lock with only one SSTORE operation
1230     uint256 private _guardCounter;
1231 
1232     constructor () internal {
1233         // The counter starts at one to prevent changing it from zero to a non-zero
1234         // value, which is a more expensive operation.
1235         _guardCounter = 1;
1236     }
1237 
1238     /**
1239      * @dev Prevents a contract from calling itself, directly or indirectly.
1240      * Calling a `nonReentrant` function from another `nonReentrant`
1241      * function is not supported. It is possible to prevent this from happening
1242      * by making the `nonReentrant` function external, and make it call a
1243      * `private` function that does the actual work.
1244      */
1245     modifier nonReentrant() {
1246         _guardCounter += 1;
1247         uint256 localCounter = _guardCounter;
1248         _;
1249         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
1250     }
1251 }
1252 
1253 /**
1254  * @title ERC721Matcha
1255  * ERC-721 Marketplace
1256  */
1257 
1258 contract BananaTaskForceApeNft is ERC721Full, ReentrancyGuard {
1259 
1260     using SafeMath for uint256;
1261 
1262     using Address for address payable;
1263 
1264     // admin address, the owner of the marketplace
1265     address payable admin;
1266 
1267     address public contract_owner;
1268 
1269     // commission rate is a value from 0 to 100
1270     uint256 commissionRate;
1271 
1272     // last price sold or auctioned
1273     mapping(uint256 => uint256) public soldFor;
1274     
1275     // Mapping from token ID to sell price in Ether or to bid price, depending if it is an auction or not
1276     mapping(uint256 => uint256) public sellBidPrice;
1277 
1278     // Mapping payment address for tokenId 
1279     mapping(uint256 => address payable) private _wallets;
1280 
1281     event Sale(uint256 indexed tokenId, address indexed from, address indexed to, uint256 value);
1282     event Commission(uint256 indexed tokenId, address indexed to, uint256 value, uint256 rate, uint256 total);
1283 
1284     /*
1285 
1286     index   _isAuction  _sellBidPrice   Meaning
1287     0       true        0               Item 0 is on auction and no bids so far
1288     1       true        10              Item 1 is on auction and the last bid is for 10 Ethers
1289     2       false       0               Item 2 is not on auction nor for sell
1290     3       false       10              Item 3 is on sale for 10 Ethers
1291 
1292     */
1293 
1294     // Auction data
1295     struct Auction {
1296 
1297         // Parameters of the auction. Times are either
1298         // absolute unix timestamps (seconds since 1970-01-01)
1299         // or time periods in seconds.
1300         address payable beneficiary;
1301         uint auctionEnd;
1302 
1303         // Current state of the auction.
1304         address payable highestBidder;
1305         uint highestBid;
1306 
1307         // Set to true at the end, disallows any change
1308         bool open;
1309 
1310         // minimum reserve price in wei
1311         uint256 reserve;
1312 
1313     }
1314 
1315     // mapping auctions for each tokenId
1316     mapping(uint256 => Auction) public auctions;
1317 
1318     // Events that will be fired on changes.
1319     event Refund(address bidder, uint amount);
1320     event HighestBidIncreased(address indexed bidder, uint amount, uint256 tokenId);
1321     event AuctionEnded(address winner, uint amount);
1322 
1323     event LimitSell(address indexed from, address indexed to, uint256 amount);
1324     event LimitBuy(address indexed from, address indexed to, uint256 amount);
1325     event MarketSell(address indexed from, address indexed to, uint256 amount);
1326     event MarketBuy(address indexed from, address indexed to, uint256 amount);
1327 
1328 
1329     constructor() public 
1330         ERC721Full("Banana Task Force Ape", "BTFA", false) {
1331         admin = 0x024cd9a40a7f780d9F3582496A5f3c00bb22c3C6;
1332         contract_owner = msg.sender;
1333         commissionRate = 15;
1334 
1335         onlyWhitelist = true;
1336         whitelistLimit = 10;
1337         buyLimit = 5;
1338         reserveLimit = 500;
1339 
1340         cost = 99 * 10 ** 15;
1341         total = 10000;
1342         remaining = 10000;
1343     }
1344 
1345     function canSell(uint256 tokenId) public view returns (bool) {
1346         return (ownerOf(tokenId)==msg.sender && !auctions[tokenId].open);
1347     }
1348 
1349     // Sell option for a fixed price
1350     function sell(uint256 tokenId, uint256 price, address payable wallet) public {
1351 
1352         // onlyOwner
1353         require(ownerOf(tokenId)==msg.sender, "ERC721Matcha: Only owner can sell this item");
1354 
1355         // cannot set a price if auction is activated
1356         require(!auctions[tokenId].open, "ERC721Matcha: Cannot sell an item which has an active auction");
1357 
1358         // set sell price for index
1359         sellBidPrice[tokenId] = price;
1360 
1361         // If price is zero, means not for sale
1362         if (price>0) {
1363 
1364             // approve the Index to the current contract
1365             approve(address(this), tokenId);
1366             
1367             // set wallet payment
1368             _wallets[tokenId] = wallet;
1369             
1370         }
1371 
1372     }
1373 
1374     // simple function to return the price of a tokenId
1375     // returns: sell price, bid price, sold price, only one can be non zero
1376     function getPrice(uint256 tokenId) public view returns (uint256, uint256, uint256) {
1377         if (sellBidPrice[tokenId]>0) return (sellBidPrice[tokenId], 0, 0);
1378         if (auctions[tokenId].highestBid>0) return (0, auctions[tokenId].highestBid, 0);
1379         return (0, 0, soldFor[tokenId]);
1380     }
1381 
1382     function canBuy(uint256 tokenId) public view returns (uint256) {
1383         if (!auctions[tokenId].open && sellBidPrice[tokenId]>0 && sellBidPrice[tokenId]>0 && getApproved(tokenId) == address(this)) {
1384             return sellBidPrice[tokenId];
1385         } else {
1386             return 0;
1387         }
1388     }
1389 
1390     // Buy option
1391     function buy(uint256 tokenId) public payable nonReentrant {
1392 
1393         // is on sale
1394         require(!auctions[tokenId].open && sellBidPrice[tokenId]>0, "ERC721Matcha: The collectible is not for sale");
1395 
1396         // transfer funds
1397         require(msg.value >= sellBidPrice[tokenId], "ERC721Matcha: Not enough funds");
1398 
1399         // transfer ownership
1400         address owner = ownerOf(tokenId);
1401 
1402         require(msg.sender!=owner, "ERC721Matcha: The seller cannot buy his own collectible");
1403 
1404         // we need to call a transferFrom from this contract, which is the one with permission to sell the NFT
1405         callOptionalReturn(this, abi.encodeWithSelector(this.transferFrom.selector, owner, msg.sender, tokenId));
1406 
1407         // calculate amounts
1408         uint256 amount4admin = msg.value.mul(commissionRate).div(100);
1409         uint256 amount4owner = msg.value.sub(amount4admin);
1410 
1411         // to owner
1412         (bool success, ) = _wallets[tokenId].call.value(amount4owner)("");
1413         require(success, "Transfer failed.");
1414 
1415         // to admin
1416         (bool success2, ) = admin.call.value(amount4admin)("");
1417         require(success2, "Transfer failed.");
1418 
1419         // close the sell
1420         sellBidPrice[tokenId] = 0;
1421         _wallets[tokenId] = address(0);
1422 
1423         soldFor[tokenId] = msg.value;
1424 
1425         emit Sale(tokenId, owner, msg.sender, msg.value);
1426         emit Commission(tokenId, owner, msg.value, commissionRate, amount4admin);
1427 
1428     }
1429 
1430     function canAuction(uint256 tokenId) public view returns (bool) {
1431         return (ownerOf(tokenId)==msg.sender && !auctions[tokenId].open && sellBidPrice[tokenId]==0);
1432     }
1433 
1434     // Instantiate an auction contract for a tokenId
1435     function createAuction(uint256 tokenId, uint _closingTime, address payable _beneficiary, uint256 _reservePrice) public {
1436 
1437         require(sellBidPrice[tokenId]==0, "ERC721Matcha: The selected NFT is open for sale, cannot be auctioned");
1438         require(!auctions[tokenId].open, "ERC721Matcha: The selected NFT already has an auction");
1439         require(ownerOf(tokenId)==msg.sender, "ERC721Matcha: Only owner can auction this item");
1440 
1441         auctions[tokenId].beneficiary = _beneficiary;
1442         auctions[tokenId].auctionEnd = _closingTime;
1443         auctions[tokenId].reserve = _reservePrice;
1444         auctions[tokenId].open = true;
1445 
1446         // approve the Index to the current contract
1447         approve(address(this), tokenId);
1448 
1449     }
1450 
1451     function canBid(uint256 tokenId) public view returns (bool) {
1452         if (!msg.sender.isContract() &&
1453             auctions[tokenId].open &&
1454             now <= auctions[tokenId].auctionEnd &&
1455             msg.sender != ownerOf(tokenId) &&
1456             getApproved(tokenId) == address(this)
1457         ) {
1458             return true;
1459         } else {
1460             return false;
1461         }
1462     }
1463 
1464     /// Bid on the auction with the value sent
1465     /// together with this transaction.
1466     /// The value will only be refunded if the
1467     /// auction is not won.
1468     function bid(uint256 tokenId) public payable nonReentrant {
1469         // No arguments are necessary, all
1470         // information is already part of
1471         // the transaction. The keyword payable
1472         // is required for the function to
1473         // be able to receive Ether.
1474 
1475         // Contracts cannot bid, because they can block the auction with a reentrant attack
1476         require(!msg.sender.isContract(), "No script kiddies");
1477 
1478         // auction has to be opened
1479         require(auctions[tokenId].open, "No opened auction found");
1480 
1481         // approve was lost
1482         require(getApproved(tokenId) == address(this), "Cannot complete the auction");
1483 
1484         // Revert the call if the bidding
1485         // period is over.
1486         require(
1487             now <= auctions[tokenId].auctionEnd,
1488             "Auction already ended."
1489         );
1490 
1491         // If the bid is not higher, send the
1492         // money back.
1493         require(
1494             msg.value > auctions[tokenId].highestBid,
1495             "There already is a higher bid."
1496         );
1497 
1498         address owner = ownerOf(tokenId);
1499         require(msg.sender!=owner, "ERC721Matcha: The owner cannot bid his own collectible");
1500 
1501         // return the funds to the previous bidder, if there is one
1502         if (auctions[tokenId].highestBid>0) {
1503             (bool success, ) = auctions[tokenId].highestBidder.call.value(auctions[tokenId].highestBid)("");
1504             require(success, "Transfer failed.");
1505             emit Refund(auctions[tokenId].highestBidder, auctions[tokenId].highestBid);
1506         }
1507 
1508         // now store the bid data
1509         auctions[tokenId].highestBidder = msg.sender;
1510         auctions[tokenId].highestBid = msg.value;
1511         emit HighestBidIncreased(msg.sender, msg.value, tokenId);
1512 
1513     }
1514 
1515     // anyone can execute withdraw if auction is opened and 
1516     // the bid time expired and the reserve was not met
1517     // or
1518     // the auction is openen but the contract is unable to transfer
1519     function canWithdraw(uint256 tokenId) public view returns (bool) {
1520         if (auctions[tokenId].open && 
1521             (
1522                 (
1523                     now >= auctions[tokenId].auctionEnd &&
1524                     auctions[tokenId].highestBid > 0 &&
1525                     auctions[tokenId].highestBid<auctions[tokenId].reserve
1526                 ) || 
1527                 getApproved(tokenId) != address(this)
1528             )
1529         ) {
1530             return true;
1531         } else {
1532             return false;
1533         }
1534     }
1535 
1536     /// Withdraw a bid when the auction is not finalized
1537     function withdraw(uint256 tokenId) public nonReentrant returns (bool) {
1538 
1539         require(canWithdraw(tokenId), "Conditions to withdraw are not met");
1540 
1541         // transfer funds to highest bidder always
1542         if (auctions[tokenId].highestBid > 0) {
1543             (bool success, ) = auctions[tokenId].highestBidder.call.value(auctions[tokenId].highestBid)("");
1544             require(success, "Transfer failed.");
1545         }
1546 
1547         // finalize the auction
1548         delete auctions[tokenId];
1549 
1550     }
1551 
1552     function canFinalize(uint256 tokenId) public view returns (bool) {
1553         if (auctions[tokenId].open && 
1554             now >= auctions[tokenId].auctionEnd &&
1555             (
1556                 auctions[tokenId].highestBid>=auctions[tokenId].reserve || 
1557                 auctions[tokenId].highestBid==0
1558             )
1559         ) {
1560             return true;
1561         } else {
1562             return false;
1563         }
1564     }
1565 
1566     // implement the auctionFinalize including the NFT transfer logic
1567     function auctionFinalize(uint256 tokenId) public nonReentrant {
1568 
1569         require(canFinalize(tokenId), "Cannot finalize");
1570 
1571         if (auctions[tokenId].highestBid>0) {
1572 
1573             // transfer the ownership of token to the highest bidder
1574             address payable highestBidder = auctions[tokenId].highestBidder;
1575 
1576             // calculate payment amounts
1577             uint256 amount4admin = auctions[tokenId].highestBid.mul(commissionRate).div(100);
1578             uint256 amount4owner = auctions[tokenId].highestBid.sub(amount4admin);
1579 
1580             // to owner
1581             (bool success, ) = auctions[tokenId].beneficiary.call.value(amount4owner)("");
1582             require(success, "Transfer failed.");
1583 
1584             // to admin
1585             (bool success2, ) = admin.call.value(amount4admin)("");
1586             require(success2, "Transfer failed.");
1587 
1588             emit Sale(tokenId, auctions[tokenId].beneficiary, highestBidder, auctions[tokenId].highestBid);
1589             emit Commission(tokenId, auctions[tokenId].beneficiary, auctions[tokenId].highestBid, commissionRate, amount4admin);
1590 
1591             // transfer ownership
1592             address owner = ownerOf(tokenId);
1593 
1594             // we need to call a transferFrom from this contract, which is the one with permission to sell the NFT
1595             // transfer the NFT to the auction's highest bidder
1596             callOptionalReturn(this, abi.encodeWithSelector(this.transferFrom.selector, owner, highestBidder, tokenId));
1597 
1598             soldFor[tokenId] = auctions[tokenId].highestBid;
1599 
1600         }
1601 
1602         emit AuctionEnded(auctions[tokenId].highestBidder, auctions[tokenId].highestBid);
1603 
1604         // finalize the auction
1605         delete auctions[tokenId];
1606 
1607     }
1608 
1609     // Bid query functions
1610     function highestBidder(uint256 tokenId) public view returns (address payable) {
1611         return auctions[tokenId].highestBidder;
1612     }
1613 
1614     function highestBid(uint256 tokenId) public view returns (uint256) {
1615         return auctions[tokenId].highestBid;
1616     }
1617 
1618     /**
1619      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1620      * on the return value: the return value is optional (but if data is returned, it must not be false).
1621      * @param token The token targeted by the call.
1622      * @param data The call data (encoded using abi.encode or one of its variants).
1623      */
1624     function callOptionalReturn(IERC721 token, bytes memory data) private {
1625         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1626         // we're implementing it ourselves.
1627 
1628         // A Solidity high level call has three parts:
1629         //  1. The target address is checked to verify it contains contract code
1630         //  2. The call itself is made, and success asserted
1631         //  3. The return value is decoded, which in turn checks the size of the returned data.
1632         // solhint-disable-next-line max-line-length
1633         require(address(token).isContract(), "SafeERC721: call to non-contract");
1634 
1635         // solhint-disable-next-line avoid-low-level-calls
1636         (bool success, bytes memory returndata) = address(token).call(data);
1637         require(success, "SafeERC721: low-level call failed");
1638 
1639         if (returndata.length > 0) { // Return data is optional
1640             // solhint-disable-next-line max-line-length
1641             require(abi.decode(returndata, (bool)), "SafeERC721: ERC20 operation did not succeed");
1642         }
1643     }
1644 
1645     // Blindbox Sales
1646 
1647     bool public enabled;
1648     uint256 public reserved;
1649     uint256 public reserveLimit;
1650     bool public onlyWhitelist;
1651     uint256 public whitelistLimit;
1652     uint256 public buyLimit;
1653 
1654     uint256 public totalCreated;
1655     mapping(address => uint256[]) private ownerBoxes;
1656     mapping(address => bool) public whitelist;
1657 
1658     uint private nonce = 0;
1659 
1660     uint256 cost;
1661     uint256 total;
1662     uint256 remaining;
1663 
1664     struct Blindbox {
1665         uint256 id;
1666         address purchaser;
1667         uint256 tokenID;
1668     }
1669 
1670     modifier onlyOwner() {
1671         require(msg.sender == contract_owner, "can only be called by the contract owner");
1672         _;
1673     }
1674 
1675     modifier isEnabled() {
1676         require(enabled, "Contract is currently disabled");
1677         _;
1678     }
1679 
1680     function status() public view returns (bool canPurchase, uint256 boxCost, uint256 boxRemaining, uint256 hasPurchased, uint256 purchaseLimit) {
1681         canPurchase = enabled && ((onlyWhitelist == false && ownerBoxes[msg.sender].length < buyLimit) || (whitelist[msg.sender] && ownerBoxes[msg.sender].length < whitelistLimit));
1682         boxCost = cost;
1683         boxRemaining = remaining;
1684         hasPurchased = ownerBoxes[msg.sender].length;
1685         purchaseLimit = whitelistLimit;
1686     }
1687 
1688     function purchaseBlindbox() public payable isEnabled {
1689         require (remaining > 0, "No more blindboxes available");
1690         require((onlyWhitelist == false && ownerBoxes[msg.sender].length < buyLimit) || (whitelist[msg.sender] && ownerBoxes[msg.sender].length < whitelistLimit), "You are not on the whitelist");
1691         require (msg.value == cost, "Incorrect BNB value.");
1692 
1693         admin.transfer(cost);
1694 
1695         mint(msg.sender);
1696     }
1697 
1698 
1699     // Private methods
1700 
1701     function mint(address who) private {
1702         uint256 request = requestRandomWords();
1703         uint256 roll = request.mod(total).add(1);
1704 
1705         while (exists(roll)) {
1706             roll++;
1707 
1708             if (roll > total) {
1709                 roll = 1;
1710             }
1711         }
1712 
1713         string memory uri = string(abi.encodePacked("https://nftstorage.link/ipfs/bafybeic2hzyfaxo7gvezfnllsgxusjpb6rj6s77vru34yhbnghdjkxv3xe/", uint2str(roll), ".json"));
1714         remaining--;
1715         require(_mintWithTokenURI(who, roll, uri), "Minting error");
1716         ownerBoxes[who].push(roll);
1717     }
1718 
1719     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1720         if (_i == 0) {
1721             return "0";
1722         }
1723         uint j = _i;
1724         uint len;
1725         while (j != 0) {
1726             len++;
1727             j /= 10;
1728         }
1729         bytes memory bstr = new bytes(len);
1730         uint k = len - 1;
1731         while (_i != 0) {
1732             bstr[k--] = byte(uint8(48 + _i % 10));
1733             _i /= 10;
1734         }
1735         return string(bstr);
1736     }
1737 
1738     function requestRandomWords() private returns (uint256) {
1739         nonce += 1;
1740         return uint(keccak256(abi.encodePacked(nonce, msg.sender, blockhash(block.number - 1))));
1741     }
1742 
1743 
1744     // Admin Only
1745 
1746     // update contract fields
1747     function updateAdmin(address payable _admin, uint256 _commissionRate, bool _anyoneCanMint) public onlyOwner {
1748         admin=_admin;
1749         commissionRate=_commissionRate;
1750         anyoneCanMint=_anyoneCanMint;
1751     }
1752 
1753     function changeOwner(address who) external onlyOwner {
1754         contract_owner = who;
1755     } 
1756 
1757     function openBoxes() external onlyOwner {
1758         opened = true;
1759     } 
1760 
1761     function setPrice(uint256 price) external onlyOwner {
1762         cost = price;
1763     }
1764 
1765     function setEnabled(bool canPurchase) external onlyOwner {
1766         enabled = canPurchase;
1767     }
1768 
1769     function enableWhitelist(bool on) external onlyOwner {
1770         onlyWhitelist = on;
1771     }
1772 
1773     function setWhitelist(address who, bool whitelisted) external onlyOwner {
1774         whitelist[who] = whitelisted;
1775     }
1776 
1777     function setWhitelisted(address[] calldata who, bool whitelisted) external onlyOwner {
1778         for (uint256 i = 0; i < who.length; i++) {
1779             whitelist[who[i]] = whitelisted;
1780         }
1781     }
1782 
1783     function setBuyLimits(uint256 white, uint256 normal) external onlyOwner {
1784         whitelistLimit = white;
1785         buyLimit = normal;
1786     }
1787 
1788     function reserveNfts(address who, uint256 amount) external onlyOwner {
1789         require(reserved + amount <= reserveLimit, "NFTS have already been reserved");
1790 
1791         for (uint256 i = 0; i < amount; i++) {
1792             mint(who);
1793         }
1794 
1795         reserved += amount;
1796     }
1797 
1798 }