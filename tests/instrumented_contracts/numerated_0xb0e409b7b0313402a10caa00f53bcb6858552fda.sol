1 /**
2  *
3  * ██╗  ██╗ █████╗ ███████╗██╗  ██╗██████╗ ██╗   ██╗███╗   ██╗███████╗███████╗
4  * ██║  ██║██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║████╗  ██║██╔════╝██╔════╝
5  * ███████║███████║███████╗███████║██████╔╝██║   ██║██╔██╗ ██║█████╗  ███████╗
6  * ██╔══██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝  ╚════██║
7  * ██║  ██║██║  ██║███████║██║  ██║██║  ██║╚██████╔╝██║ ╚████║███████╗███████║
8  * ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
9  * First Edition
10  *
11  * personalized generative art on the blockchain                  by Joshua Wu
12  *
13  *
14  * Hashrunes are on-chain generative art created by you.
15  * A Hashrune's design is based on its unique name. Anyone can mint a Hashrune by naming it and paying a fee.
16  *
17  * This is the First Edition, made for those in the community who wanted but missed out on summoning a Genesis Hashrune.
18  * The design of the First Edition Hashrunes have corner markings to distinguish them from Genesis Hashrunes.
19  *
20  * The price to mint a First Edition Hashrune starts at 0.05 ETH. For each Hashrune minted, the price will increase by at least 0.0002 ETH.
21  * If you own the Genesis version of a Hashrune, you can mint the First Edition version for free. (The price does not increase in this case.)
22  *
23  * There is a max supply of 10,000 First Edition Hashrunes. Additionally, we are able to decrease the max supply (but not increase it).
24  * We are also able to increase the price increment (but not decrease it).
25  *
26  * Functions specific to Hashrunes:
27  *   `mint(string name)`: Mint a Hashrune.
28  *   `getName(uint256 tokenId) -> string`: Look up the name corresponding to a token id.
29  *   `getTokenId(string name) -> uint256`: Look up the token id corresponding to a name.
30  *   `getRune(string name) -> string`: Get the design of a Hashrune.
31  *   `getCharacters(string name) -> string`: Get the list of characters used for a Hashrune.
32  *   `getColors(string name) -> uint256[]`: Get a Hashrune's RGB24 colors. Each color corresponds to each character in `getCharacters(name)`,
33  *                                          with an extra color for the background at the end of the list.
34  *
35  */
36 
37 
38 
39 
40 // File: openzeppelin-solidity/contracts/GSN/Context.sol
41 
42 pragma solidity ^0.5.0;
43 
44 /*
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with GSN meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 contract Context {
55     // Empty internal constructor, to prevent people from mistakenly deploying
56     // an instance of this contract, which should be used via inheritance.
57     constructor () internal { }
58     // solhint-disable-previous-line no-empty-blocks
59 
60     function _msgSender() internal view returns (address payable) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view returns (bytes memory) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69 
70 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
71 
72 pragma solidity ^0.5.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 /**
101  * @dev Required interface of an ERC721 compliant contract.
102  */
103 contract IERC721 is IERC165 {
104     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
105     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
106     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
107 
108     /**
109      * @dev Returns the number of NFTs in `owner`'s account.
110      */
111     function balanceOf(address owner) public view returns (uint256 balance);
112 
113     /**
114      * @dev Returns the owner of the NFT specified by `tokenId`.
115      */
116     function ownerOf(uint256 tokenId) public view returns (address owner);
117 
118     /**
119      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
120      * another (`to`).
121      *
122      *
123      *
124      * Requirements:
125      * - `from`, `to` cannot be zero.
126      * - `tokenId` must be owned by `from`.
127      * - If the caller is not `from`, it must be have been allowed to move this
128      * NFT by either {approve} or {setApprovalForAll}.
129      */
130     function safeTransferFrom(address from, address to, uint256 tokenId) public;
131     /**
132      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
133      * another (`to`).
134      *
135      * Requirements:
136      * - If the caller is not `from`, it must be approved to move this NFT by
137      * either {approve} or {setApprovalForAll}.
138      */
139     function transferFrom(address from, address to, uint256 tokenId) public;
140     function approve(address to, uint256 tokenId) public;
141     function getApproved(uint256 tokenId) public view returns (address operator);
142 
143     function setApprovalForAll(address operator, bool _approved) public;
144     function isApprovedForAll(address owner, address operator) public view returns (bool);
145 
146 
147     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
151 
152 pragma solidity ^0.5.0;
153 
154 /**
155  * @title ERC721 token receiver interface
156  * @dev Interface for any contract that wants to support safeTransfers
157  * from ERC721 asset contracts.
158  */
159 contract IERC721Receiver {
160     /**
161      * @notice Handle the receipt of an NFT
162      * @dev The ERC721 smart contract calls this function on the recipient
163      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
164      * otherwise the caller will revert the transaction. The selector to be
165      * returned can be obtained as `this.onERC721Received.selector`. This
166      * function MAY throw to revert and reject the transfer.
167      * Note: the ERC721 contract address is always the message sender.
168      * @param operator The address which called `safeTransferFrom` function
169      * @param from The address which previously owned the token
170      * @param tokenId The NFT identifier which is being transferred
171      * @param data Additional data with no specified format
172      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173      */
174     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
175     public returns (bytes4);
176 }
177 
178 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
179 
180 pragma solidity ^0.5.0;
181 
182 /**
183  * @dev Wrappers over Solidity's arithmetic operations with added overflow
184  * checks.
185  *
186  * Arithmetic operations in Solidity wrap on overflow. This can easily result
187  * in bugs, because programmers usually assume that an overflow raises an
188  * error, which is the standard behavior in high level programming languages.
189  * `SafeMath` restores this intuition by reverting the transaction when an
190  * operation overflows.
191  *
192  * Using this library instead of the unchecked operations eliminates an entire
193  * class of bugs, so it's recommended to use it always.
194  */
195 library SafeMath {
196     /**
197      * @dev Returns the addition of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `+` operator.
201      *
202      * Requirements:
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a, "SafeMath: addition overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         return sub(a, b, "SafeMath: subtraction overflow");
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      * - Subtraction cannot overflow.
233      *
234      * _Available since v2.4.0._
235      */
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the multiplication of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `*` operator.
248      *
249      * Requirements:
250      * - Multiplication cannot overflow.
251      */
252     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
254         // benefit is lost if 'b' is also tested.
255         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
256         if (a == 0) {
257             return 0;
258         }
259 
260         uint256 c = a * b;
261         require(c / a == b, "SafeMath: multiplication overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
278         return div(a, b, "SafeMath: division by zero");
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
283      * division by zero. The result is rounded towards zero.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      *
292      * _Available since v2.4.0._
293      */
294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         // Solidity only automatically asserts when dividing by 0
296         require(b > 0, errorMessage);
297         uint256 c = a / b;
298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return mod(a, b, "SafeMath: modulo by zero");
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
320      * Reverts with custom message when dividing by zero.
321      *
322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
323      * opcode (which leaves remaining gas untouched) while Solidity uses an
324      * invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      * - The divisor cannot be zero.
328      *
329      * _Available since v2.4.0._
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File: openzeppelin-solidity/contracts/utils/Address.sol
338 
339 pragma solidity ^0.5.5;
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following 
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
364         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
365         // for accounts without code, i.e. `keccak256('')`
366         bytes32 codehash;
367         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
368         // solhint-disable-next-line no-inline-assembly
369         assembly { codehash := extcodehash(account) }
370         return (codehash != accountHash && codehash != 0x0);
371     }
372 
373     /**
374      * @dev Converts an `address` into `address payable`. Note that this is
375      * simply a type cast: the actual underlying value is not changed.
376      *
377      * _Available since v2.4.0._
378      */
379     function toPayable(address account) internal pure returns (address payable) {
380         return address(uint160(account));
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      *
399      * _Available since v2.4.0._
400      */
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         // solhint-disable-next-line avoid-call-value
405         (bool success, ) = recipient.call.value(amount)("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 }
409 
410 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
411 
412 pragma solidity ^0.5.0;
413 
414 
415 /**
416  * @title Counters
417  * @author Matt Condon (@shrugs)
418  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
419  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
420  *
421  * Include with `using Counters for Counters.Counter;`
422  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
423  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
424  * directly accessed.
425  */
426 library Counters {
427     using SafeMath for uint256;
428 
429     struct Counter {
430         // This variable should never be directly accessed by users of the library: interactions must be restricted to
431         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
432         // this feature: see https://github.com/ethereum/solidity/issues/4637
433         uint256 _value; // default: 0
434     }
435 
436     function current(Counter storage counter) internal view returns (uint256) {
437         return counter._value;
438     }
439 
440     function increment(Counter storage counter) internal {
441         // The {SafeMath} overflow check can be skipped here, see the comment at the top
442         counter._value += 1;
443     }
444 
445     function decrement(Counter storage counter) internal {
446         counter._value = counter._value.sub(1);
447     }
448 }
449 
450 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 /**
456  * @dev Implementation of the {IERC165} interface.
457  *
458  * Contracts may inherit from this and call {_registerInterface} to declare
459  * their support of an interface.
460  */
461 contract ERC165 is IERC165 {
462     /*
463      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
464      */
465     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
466 
467     /**
468      * @dev Mapping of interface ids to whether or not it's supported.
469      */
470     mapping(bytes4 => bool) private _supportedInterfaces;
471 
472     constructor () internal {
473         // Derived contracts need only register support for their own interfaces,
474         // we register support for ERC165 itself here
475         _registerInterface(_INTERFACE_ID_ERC165);
476     }
477 
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      *
481      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
482      */
483     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
484         return _supportedInterfaces[interfaceId];
485     }
486 
487     /**
488      * @dev Registers the contract as an implementer of the interface defined by
489      * `interfaceId`. Support of the actual ERC165 interface is automatic and
490      * registering its interface id is not required.
491      *
492      * See {IERC165-supportsInterface}.
493      *
494      * Requirements:
495      *
496      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
497      */
498     function _registerInterface(bytes4 interfaceId) internal {
499         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
500         _supportedInterfaces[interfaceId] = true;
501     }
502 }
503 
504 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 
511 
512 
513 
514 
515 /**
516  * @title ERC721 Non-Fungible Token Standard basic implementation
517  * @dev see https://eips.ethereum.org/EIPS/eip-721
518  */
519 contract ERC721 is Context, ERC165, IERC721 {
520     using SafeMath for uint256;
521     using Address for address;
522     using Counters for Counters.Counter;
523 
524     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
525     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
526     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
527 
528     // Mapping from token ID to owner
529     mapping (uint256 => address) private _tokenOwner;
530 
531     // Mapping from token ID to approved address
532     mapping (uint256 => address) private _tokenApprovals;
533 
534     // Mapping from owner to number of owned token
535     mapping (address => Counters.Counter) private _ownedTokensCount;
536 
537     // Mapping from owner to operator approvals
538     mapping (address => mapping (address => bool)) private _operatorApprovals;
539 
540     /*
541      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
542      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
543      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
544      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
545      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
546      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
547      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
548      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
549      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
550      *
551      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
552      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
553      */
554     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
555 
556     constructor () public {
557         // register the supported interfaces to conform to ERC721 via ERC165
558         _registerInterface(_INTERFACE_ID_ERC721);
559     }
560 
561     /**
562      * @dev Gets the balance of the specified address.
563      * @param owner address to query the balance of
564      * @return uint256 representing the amount owned by the passed address
565      */
566     function balanceOf(address owner) public view returns (uint256) {
567         require(owner != address(0), "ERC721: balance query for the zero address");
568 
569         return _ownedTokensCount[owner].current();
570     }
571 
572     /**
573      * @dev Gets the owner of the specified token ID.
574      * @param tokenId uint256 ID of the token to query the owner of
575      * @return address currently marked as the owner of the given token ID
576      */
577     function ownerOf(uint256 tokenId) public view returns (address) {
578         address owner = _tokenOwner[tokenId];
579         require(owner != address(0), "ERC721: owner query for nonexistent token");
580 
581         return owner;
582     }
583 
584     /**
585      * @dev Approves another address to transfer the given token ID
586      * The zero address indicates there is no approved address.
587      * There can only be one approved address per token at a given time.
588      * Can only be called by the token owner or an approved operator.
589      * @param to address to be approved for the given token ID
590      * @param tokenId uint256 ID of the token to be approved
591      */
592     function approve(address to, uint256 tokenId) public {
593         address owner = ownerOf(tokenId);
594         require(to != owner, "ERC721: approval to current owner");
595 
596         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
597             "ERC721: approve caller is not owner nor approved for all"
598         );
599 
600         _tokenApprovals[tokenId] = to;
601         emit Approval(owner, to, tokenId);
602     }
603 
604     /**
605      * @dev Gets the approved address for a token ID, or zero if no address set
606      * Reverts if the token ID does not exist.
607      * @param tokenId uint256 ID of the token to query the approval of
608      * @return address currently approved for the given token ID
609      */
610     function getApproved(uint256 tokenId) public view returns (address) {
611         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
612 
613         return _tokenApprovals[tokenId];
614     }
615 
616     /**
617      * @dev Sets or unsets the approval of a given operator
618      * An operator is allowed to transfer all tokens of the sender on their behalf.
619      * @param to operator address to set the approval
620      * @param approved representing the status of the approval to be set
621      */
622     function setApprovalForAll(address to, bool approved) public {
623         require(to != _msgSender(), "ERC721: approve to caller");
624 
625         _operatorApprovals[_msgSender()][to] = approved;
626         emit ApprovalForAll(_msgSender(), to, approved);
627     }
628 
629     /**
630      * @dev Tells whether an operator is approved by a given owner.
631      * @param owner owner address which you want to query the approval of
632      * @param operator operator address which you want to query the approval of
633      * @return bool whether the given operator is approved by the given owner
634      */
635     function isApprovedForAll(address owner, address operator) public view returns (bool) {
636         return _operatorApprovals[owner][operator];
637     }
638 
639     /**
640      * @dev Transfers the ownership of a given token ID to another address.
641      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
642      * Requires the msg.sender to be the owner, approved, or operator.
643      * @param from current owner of the token
644      * @param to address to receive the ownership of the given token ID
645      * @param tokenId uint256 ID of the token to be transferred
646      */
647     function transferFrom(address from, address to, uint256 tokenId) public {
648         //solhint-disable-next-line max-line-length
649         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
650 
651         _transferFrom(from, to, tokenId);
652     }
653 
654     /**
655      * @dev Safely transfers the ownership of a given token ID to another address
656      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
657      * which is called upon a safe transfer, and return the magic value
658      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
659      * the transfer is reverted.
660      * Requires the msg.sender to be the owner, approved, or operator
661      * @param from current owner of the token
662      * @param to address to receive the ownership of the given token ID
663      * @param tokenId uint256 ID of the token to be transferred
664      */
665     function safeTransferFrom(address from, address to, uint256 tokenId) public {
666         safeTransferFrom(from, to, tokenId, "");
667     }
668 
669     /**
670      * @dev Safely transfers the ownership of a given token ID to another address
671      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
672      * which is called upon a safe transfer, and return the magic value
673      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
674      * the transfer is reverted.
675      * Requires the _msgSender() to be the owner, approved, or operator
676      * @param from current owner of the token
677      * @param to address to receive the ownership of the given token ID
678      * @param tokenId uint256 ID of the token to be transferred
679      * @param _data bytes data to send along with a safe transfer check
680      */
681     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
682         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
683         _safeTransferFrom(from, to, tokenId, _data);
684     }
685 
686     /**
687      * @dev Safely transfers the ownership of a given token ID to another address
688      * If the target address is a contract, it must implement `onERC721Received`,
689      * which is called upon a safe transfer, and return the magic value
690      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
691      * the transfer is reverted.
692      * Requires the msg.sender to be the owner, approved, or operator
693      * @param from current owner of the token
694      * @param to address to receive the ownership of the given token ID
695      * @param tokenId uint256 ID of the token to be transferred
696      * @param _data bytes data to send along with a safe transfer check
697      */
698     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
699         _transferFrom(from, to, tokenId);
700         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
701     }
702 
703     /**
704      * @dev Returns whether the specified token exists.
705      * @param tokenId uint256 ID of the token to query the existence of
706      * @return bool whether the token exists
707      */
708     function _exists(uint256 tokenId) internal view returns (bool) {
709         address owner = _tokenOwner[tokenId];
710         return owner != address(0);
711     }
712 
713     /**
714      * @dev Returns whether the given spender can transfer a given token ID.
715      * @param spender address of the spender to query
716      * @param tokenId uint256 ID of the token to be transferred
717      * @return bool whether the msg.sender is approved for the given token ID,
718      * is an operator of the owner, or is the owner of the token
719      */
720     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
721         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
722         address owner = ownerOf(tokenId);
723         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
724     }
725 
726     /**
727      * @dev Internal function to safely mint a new token.
728      * Reverts if the given token ID already exists.
729      * If the target address is a contract, it must implement `onERC721Received`,
730      * which is called upon a safe transfer, and return the magic value
731      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
732      * the transfer is reverted.
733      * @param to The address that will own the minted token
734      * @param tokenId uint256 ID of the token to be minted
735      */
736     function _safeMint(address to, uint256 tokenId) internal {
737         _safeMint(to, tokenId, "");
738     }
739 
740     /**
741      * @dev Internal function to safely mint a new token.
742      * Reverts if the given token ID already exists.
743      * If the target address is a contract, it must implement `onERC721Received`,
744      * which is called upon a safe transfer, and return the magic value
745      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
746      * the transfer is reverted.
747      * @param to The address that will own the minted token
748      * @param tokenId uint256 ID of the token to be minted
749      * @param _data bytes data to send along with a safe transfer check
750      */
751     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
752         _mint(to, tokenId);
753         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
754     }
755 
756     /**
757      * @dev Internal function to mint a new token.
758      * Reverts if the given token ID already exists.
759      * @param to The address that will own the minted token
760      * @param tokenId uint256 ID of the token to be minted
761      */
762     function _mint(address to, uint256 tokenId) internal {
763         require(to != address(0), "ERC721: mint to the zero address");
764         require(!_exists(tokenId), "ERC721: token already minted");
765 
766         _tokenOwner[tokenId] = to;
767         _ownedTokensCount[to].increment();
768 
769         emit Transfer(address(0), to, tokenId);
770     }
771 
772     /**
773      * @dev Internal function to burn a specific token.
774      * Reverts if the token does not exist.
775      * Deprecated, use {_burn} instead.
776      * @param owner owner of the token to burn
777      * @param tokenId uint256 ID of the token being burned
778      */
779     function _burn(address owner, uint256 tokenId) internal {
780         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
781 
782         _clearApproval(tokenId);
783 
784         _ownedTokensCount[owner].decrement();
785         _tokenOwner[tokenId] = address(0);
786 
787         emit Transfer(owner, address(0), tokenId);
788     }
789 
790     /**
791      * @dev Internal function to burn a specific token.
792      * Reverts if the token does not exist.
793      * @param tokenId uint256 ID of the token being burned
794      */
795     function _burn(uint256 tokenId) internal {
796         _burn(ownerOf(tokenId), tokenId);
797     }
798 
799     /**
800      * @dev Internal function to transfer ownership of a given token ID to another address.
801      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
802      * @param from current owner of the token
803      * @param to address to receive the ownership of the given token ID
804      * @param tokenId uint256 ID of the token to be transferred
805      */
806     function _transferFrom(address from, address to, uint256 tokenId) internal {
807         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
808         require(to != address(0), "ERC721: transfer to the zero address");
809 
810         _clearApproval(tokenId);
811 
812         _ownedTokensCount[from].decrement();
813         _ownedTokensCount[to].increment();
814 
815         _tokenOwner[tokenId] = to;
816 
817         emit Transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
822      * The call is not executed if the target address is not a contract.
823      *
824      * This is an internal detail of the `ERC721` contract and its use is deprecated.
825      * @param from address representing the previous owner of the given token ID
826      * @param to target address that will receive the tokens
827      * @param tokenId uint256 ID of the token to be transferred
828      * @param _data bytes optional data to send along with the call
829      * @return bool whether the call correctly returned the expected magic value
830      */
831     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
832         internal returns (bool)
833     {
834         if (!to.isContract()) {
835             return true;
836         }
837         // solhint-disable-next-line avoid-low-level-calls
838         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
839             IERC721Receiver(to).onERC721Received.selector,
840             _msgSender(),
841             from,
842             tokenId,
843             _data
844         ));
845         if (!success) {
846             if (returndata.length > 0) {
847                 // solhint-disable-next-line no-inline-assembly
848                 assembly {
849                     let returndata_size := mload(returndata)
850                     revert(add(32, returndata), returndata_size)
851                 }
852             } else {
853                 revert("ERC721: transfer to non ERC721Receiver implementer");
854             }
855         } else {
856             bytes4 retval = abi.decode(returndata, (bytes4));
857             return (retval == _ERC721_RECEIVED);
858         }
859     }
860 
861     /**
862      * @dev Private function to clear current approval of a given token ID.
863      * @param tokenId uint256 ID of the token to be transferred
864      */
865     function _clearApproval(uint256 tokenId) private {
866         if (_tokenApprovals[tokenId] != address(0)) {
867             _tokenApprovals[tokenId] = address(0);
868         }
869     }
870 }
871 
872 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
873 
874 pragma solidity ^0.5.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 contract IERC721Enumerable is IERC721 {
882     function totalSupply() public view returns (uint256);
883     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
884 
885     function tokenByIndex(uint256 index) public view returns (uint256);
886 }
887 
888 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
889 
890 pragma solidity ^0.5.0;
891 
892 
893 
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
901     // Mapping from owner to list of owned token IDs
902     mapping(address => uint256[]) private _ownedTokens;
903 
904     // Mapping from token ID to index of the owner tokens list
905     mapping(uint256 => uint256) private _ownedTokensIndex;
906 
907     // Array with all token ids, used for enumeration
908     uint256[] private _allTokens;
909 
910     // Mapping from token id to position in the allTokens array
911     mapping(uint256 => uint256) private _allTokensIndex;
912 
913     /*
914      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
915      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
916      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
917      *
918      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
919      */
920     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
921 
922     /**
923      * @dev Constructor function.
924      */
925     constructor () public {
926         // register the supported interface to conform to ERC721Enumerable via ERC165
927         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
928     }
929 
930     /**
931      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
932      * @param owner address owning the tokens list to be accessed
933      * @param index uint256 representing the index to be accessed of the requested tokens list
934      * @return uint256 token ID at the given index of the tokens list owned by the requested address
935      */
936     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
937         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
938         return _ownedTokens[owner][index];
939     }
940 
941     /**
942      * @dev Gets the total amount of tokens stored by the contract.
943      * @return uint256 representing the total amount of tokens
944      */
945     function totalSupply() public view returns (uint256) {
946         return _allTokens.length;
947     }
948 
949     /**
950      * @dev Gets the token ID at a given index of all the tokens in this contract
951      * Reverts if the index is greater or equal to the total number of tokens.
952      * @param index uint256 representing the index to be accessed of the tokens list
953      * @return uint256 token ID at the given index of the tokens list
954      */
955     function tokenByIndex(uint256 index) public view returns (uint256) {
956         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
957         return _allTokens[index];
958     }
959 
960     /**
961      * @dev Internal function to transfer ownership of a given token ID to another address.
962      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
963      * @param from current owner of the token
964      * @param to address to receive the ownership of the given token ID
965      * @param tokenId uint256 ID of the token to be transferred
966      */
967     function _transferFrom(address from, address to, uint256 tokenId) internal {
968         super._transferFrom(from, to, tokenId);
969 
970         _removeTokenFromOwnerEnumeration(from, tokenId);
971 
972         _addTokenToOwnerEnumeration(to, tokenId);
973     }
974 
975     /**
976      * @dev Internal function to mint a new token.
977      * Reverts if the given token ID already exists.
978      * @param to address the beneficiary that will own the minted token
979      * @param tokenId uint256 ID of the token to be minted
980      */
981     function _mint(address to, uint256 tokenId) internal {
982         super._mint(to, tokenId);
983 
984         _addTokenToOwnerEnumeration(to, tokenId);
985 
986         _addTokenToAllTokensEnumeration(tokenId);
987     }
988 
989     /**
990      * @dev Internal function to burn a specific token.
991      * Reverts if the token does not exist.
992      * Deprecated, use {ERC721-_burn} instead.
993      * @param owner owner of the token to burn
994      * @param tokenId uint256 ID of the token being burned
995      */
996     function _burn(address owner, uint256 tokenId) internal {
997         super._burn(owner, tokenId);
998 
999         _removeTokenFromOwnerEnumeration(owner, tokenId);
1000         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1001         _ownedTokensIndex[tokenId] = 0;
1002 
1003         _removeTokenFromAllTokensEnumeration(tokenId);
1004     }
1005 
1006     /**
1007      * @dev Gets the list of token IDs of the requested owner.
1008      * @param owner address owning the tokens
1009      * @return uint256[] List of token IDs owned by the requested address
1010      */
1011     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1012         return _ownedTokens[owner];
1013     }
1014 
1015     /**
1016      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1017      * @param to address representing the new owner of the given token ID
1018      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1019      */
1020     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1021         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1022         _ownedTokens[to].push(tokenId);
1023     }
1024 
1025     /**
1026      * @dev Private function to add a token to this extension's token tracking data structures.
1027      * @param tokenId uint256 ID of the token to be added to the tokens list
1028      */
1029     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1030         _allTokensIndex[tokenId] = _allTokens.length;
1031         _allTokens.push(tokenId);
1032     }
1033 
1034     /**
1035      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1036      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1037      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1038      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1039      * @param from address representing the previous owner of the given token ID
1040      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1041      */
1042     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1043         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1044         // then delete the last slot (swap and pop).
1045 
1046         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1047         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1048 
1049         // When the token to delete is the last token, the swap operation is unnecessary
1050         if (tokenIndex != lastTokenIndex) {
1051             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1052 
1053             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1054             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1055         }
1056 
1057         // This also deletes the contents at the last position of the array
1058         _ownedTokens[from].length--;
1059 
1060         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1061         // lastTokenId, or just over the end of the array if the token was the last one).
1062     }
1063 
1064     /**
1065      * @dev Private function to remove a token from this extension's token tracking data structures.
1066      * This has O(1) time complexity, but alters the order of the _allTokens array.
1067      * @param tokenId uint256 ID of the token to be removed from the tokens list
1068      */
1069     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1070         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1071         // then delete the last slot (swap and pop).
1072 
1073         uint256 lastTokenIndex = _allTokens.length.sub(1);
1074         uint256 tokenIndex = _allTokensIndex[tokenId];
1075 
1076         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1077         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1078         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1079         uint256 lastTokenId = _allTokens[lastTokenIndex];
1080 
1081         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1082         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1083 
1084         // This also deletes the contents at the last position of the array
1085         _allTokens.length--;
1086         _allTokensIndex[tokenId] = 0;
1087     }
1088 }
1089 
1090 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
1091 
1092 pragma solidity ^0.5.0;
1093 
1094 
1095 /**
1096  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1097  * @dev See https://eips.ethereum.org/EIPS/eip-721
1098  */
1099 contract IERC721Metadata is IERC721 {
1100     function name() external view returns (string memory);
1101     function symbol() external view returns (string memory);
1102     function tokenURI(uint256 tokenId) external view returns (string memory);
1103 }
1104 
1105 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
1106 
1107 pragma solidity ^0.5.0;
1108 
1109 
1110 
1111 
1112 
1113 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1114     // Token name
1115     string private _name;
1116 
1117     // Token symbol
1118     string private _symbol;
1119 
1120     // Base URI
1121     string private _baseURI;
1122 
1123     // Optional mapping for token URIs
1124     mapping(uint256 => string) private _tokenURIs;
1125 
1126     /*
1127      *     bytes4(keccak256('name()')) == 0x06fdde03
1128      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1129      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1130      *
1131      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1132      */
1133     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1134 
1135     /**
1136      * @dev Constructor function
1137      */
1138     constructor (string memory name, string memory symbol) public {
1139         _name = name;
1140         _symbol = symbol;
1141 
1142         // register the supported interfaces to conform to ERC721 via ERC165
1143         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1144     }
1145 
1146     /**
1147      * @dev Gets the token name.
1148      * @return string representing the token name
1149      */
1150     function name() external view returns (string memory) {
1151         return _name;
1152     }
1153 
1154     /**
1155      * @dev Gets the token symbol.
1156      * @return string representing the token symbol
1157      */
1158     function symbol() external view returns (string memory) {
1159         return _symbol;
1160     }
1161 
1162     /**
1163      * @dev Returns the URI for a given token ID. May return an empty string.
1164      *
1165      * If the token's URI is non-empty and a base URI was set (via
1166      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1167      *
1168      * Reverts if the token ID does not exist.
1169      */
1170     function tokenURI(uint256 tokenId) external view returns (string memory) {
1171         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1172 
1173         string memory _tokenURI = _tokenURIs[tokenId];
1174 
1175         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1176         if (bytes(_tokenURI).length == 0) {
1177             return "";
1178         } else {
1179             // abi.encodePacked is being used to concatenate strings
1180             return string(abi.encodePacked(_baseURI, _tokenURI));
1181         }
1182     }
1183 
1184     /**
1185      * @dev Internal function to set the token URI for a given token.
1186      *
1187      * Reverts if the token ID does not exist.
1188      *
1189      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1190      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1191      * it and save gas.
1192      */
1193     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1194         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1195         _tokenURIs[tokenId] = _tokenURI;
1196     }
1197 
1198     /**
1199      * @dev Internal function to set the base URI for all token IDs. It is
1200      * automatically added as a prefix to the value returned in {tokenURI}.
1201      *
1202      * _Available since v2.5.0._
1203      */
1204     function _setBaseURI(string memory baseURI) internal {
1205         _baseURI = baseURI;
1206     }
1207 
1208     /**
1209     * @dev Returns the base URI set via {_setBaseURI}. This will be
1210     * automatically added as a preffix in {tokenURI} to each token's URI, when
1211     * they are non-empty.
1212     *
1213     * _Available since v2.5.0._
1214     */
1215     function baseURI() external view returns (string memory) {
1216         return _baseURI;
1217     }
1218 
1219     /**
1220      * @dev Internal function to burn a specific token.
1221      * Reverts if the token does not exist.
1222      * Deprecated, use _burn(uint256) instead.
1223      * @param owner owner of the token to burn
1224      * @param tokenId uint256 ID of the token being burned by the msg.sender
1225      */
1226     function _burn(address owner, uint256 tokenId) internal {
1227         super._burn(owner, tokenId);
1228 
1229         // Clear metadata (if any)
1230         if (bytes(_tokenURIs[tokenId]).length != 0) {
1231             delete _tokenURIs[tokenId];
1232         }
1233     }
1234 }
1235 
1236 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1237 
1238 pragma solidity ^0.5.0;
1239 
1240 
1241 
1242 
1243 /**
1244  * @title Full ERC721 Token
1245  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1246  * Moreover, it includes approve all functionality using operator terminology.
1247  *
1248  * See https://eips.ethereum.org/EIPS/eip-721
1249  */
1250 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1251     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1252         // solhint-disable-previous-line no-empty-blocks
1253     }
1254 }
1255 
1256 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1257 
1258 pragma solidity ^0.5.0;
1259 
1260 /**
1261  * @dev Contract module which provides a basic access control mechanism, where
1262  * there is an account (an owner) that can be granted exclusive access to
1263  * specific functions.
1264  *
1265  * This module is used through inheritance. It will make available the modifier
1266  * `onlyOwner`, which can be applied to your functions to restrict their use to
1267  * the owner.
1268  */
1269 contract Ownable is Context {
1270     address private _owner;
1271 
1272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1273 
1274     /**
1275      * @dev Initializes the contract setting the deployer as the initial owner.
1276      */
1277     constructor () internal {
1278         address msgSender = _msgSender();
1279         _owner = msgSender;
1280         emit OwnershipTransferred(address(0), msgSender);
1281     }
1282 
1283     /**
1284      * @dev Returns the address of the current owner.
1285      */
1286     function owner() public view returns (address) {
1287         return _owner;
1288     }
1289 
1290     /**
1291      * @dev Throws if called by any account other than the owner.
1292      */
1293     modifier onlyOwner() {
1294         require(isOwner(), "Ownable: caller is not the owner");
1295         _;
1296     }
1297 
1298     /**
1299      * @dev Returns true if the caller is the current owner.
1300      */
1301     function isOwner() public view returns (bool) {
1302         return _msgSender() == _owner;
1303     }
1304 
1305     /**
1306      * @dev Leaves the contract without owner. It will not be possible to call
1307      * `onlyOwner` functions anymore. Can only be called by the current owner.
1308      *
1309      * NOTE: Renouncing ownership will leave the contract without an owner,
1310      * thereby removing any functionality that is only available to the owner.
1311      */
1312     function renounceOwnership() public onlyOwner {
1313         emit OwnershipTransferred(_owner, address(0));
1314         _owner = address(0);
1315     }
1316 
1317     /**
1318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1319      * Can only be called by the current owner.
1320      */
1321     function transferOwnership(address newOwner) public onlyOwner {
1322         _transferOwnership(newOwner);
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      */
1328     function _transferOwnership(address newOwner) internal {
1329         require(newOwner != address(0), "Ownable: new owner is the zero address");
1330         emit OwnershipTransferred(_owner, newOwner);
1331         _owner = newOwner;
1332     }
1333 }
1334 
1335 // File: contracts/String.sol
1336 
1337 pragma solidity ^0.5.2;
1338 
1339 library String {
1340     function concat(string memory _a, string memory _b)
1341         internal
1342         pure
1343         returns (string memory)
1344     {
1345         bytes memory _aBytes = bytes(_a);
1346         bytes memory _bBytes = bytes(_b);
1347         bytes memory _result = new bytes(_aBytes.length + _bBytes.length);
1348         uint256 _k = 0;
1349         for (uint256 _i = 0; _i < _aBytes.length; _i++)
1350             _result[_k++] = _aBytes[_i];
1351         for (uint256 _i = 0; _i < _bBytes.length; _i++)
1352             _result[_k++] = _bBytes[_i];
1353         return string(_result);
1354     }
1355 
1356     function fromUint(uint256 _n) internal pure returns (string memory) {
1357         if (_n == 0) {
1358             return "0";
1359         }
1360         uint256 _len;
1361         for (uint256 _i = _n; _i != 0; _i /= 10) _len++;
1362         bytes memory _result = new bytes(_len);
1363         uint256 _k = _len - 1;
1364         while (_n != 0) {
1365             _result[_k--] = bytes1(uint8(48 + (_n % 10)));
1366             _n /= 10;
1367         }
1368         return string(_result);
1369     }
1370 
1371     function hash(string memory str) internal pure returns (uint256) {
1372         return uint256(keccak256(bytes(str)));
1373     }
1374 }
1375 
1376 // File: contracts/ERC721Tradable.sol
1377 
1378 pragma solidity ^0.5.2;
1379 
1380 
1381 
1382 
1383 contract OwnableDelegateProxy {}
1384 
1385 contract ProxyRegistry {
1386     mapping(address => OwnableDelegateProxy) public proxies;
1387 }
1388 
1389 /**
1390  * @title ERC721Tradable
1391  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1392  */
1393 contract ERC721Tradable is ERC721Full, Ownable {
1394     using String for string;
1395 
1396     address private proxyRegistryAddress;
1397 
1398     constructor(
1399         string memory _name,
1400         string memory _symbol,
1401         address _proxyRegistryAddress
1402     ) public ERC721Full(_name, _symbol) {
1403         proxyRegistryAddress = _proxyRegistryAddress;
1404     }
1405 
1406     function baseTokenURI() public pure returns (string memory) {
1407         return "";
1408     }
1409 
1410     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1411         return String.concat(baseTokenURI(), String.fromUint(_tokenId));
1412     }
1413 
1414     /**
1415      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1416      */
1417     function isApprovedForAll(address _owner, address _operator)
1418         public
1419         view
1420         returns (bool)
1421     {
1422         // Whitelist OpenSea proxy contract for easy trading.
1423         ProxyRegistry _proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1424         if (address(_proxyRegistry.proxies(_owner)) == _operator) {
1425             return true;
1426         }
1427         return super.isApprovedForAll(_owner, _operator);
1428     }
1429 }
1430 
1431 // File: contracts/FirstEditionHashrunes.sol
1432 
1433 pragma solidity ^0.5.2;
1434 
1435 
1436 
1437 /**
1438  *
1439  * ██╗  ██╗ █████╗ ███████╗██╗  ██╗██████╗ ██╗   ██╗███╗   ██╗███████╗███████╗
1440  * ██║  ██║██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║████╗  ██║██╔════╝██╔════╝
1441  * ███████║███████║███████╗███████║██████╔╝██║   ██║██╔██╗ ██║█████╗  ███████╗
1442  * ██╔══██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝  ╚════██║
1443  * ██║  ██║██║  ██║███████║██║  ██║██║  ██║╚██████╔╝██║ ╚████║███████╗███████║
1444  * ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
1445  * First Edition
1446  *
1447  * personalized generative art on the blockchain                  by Joshua Wu
1448  *
1449  *
1450  * Hashrunes are on-chain generative art created by you.
1451  * A Hashrune's design is based on its unique name. Anyone can mint a Hashrune by naming it and paying a fee.
1452  *
1453  * This is the First Edition, made for those in the community who wanted but missed out on summoning a Genesis Hashrune.
1454  * The design of the First Edition Hashrunes have corner markings to distinguish them from Genesis Hashrunes.
1455  *
1456  * The price to mint a First Edition Hashrune starts at 0.05 ETH. For each Hashrune minted, the price will increase by at least 0.0002 ETH.
1457  * If you own the Genesis version of a Hashrune, you can mint the First Edition version for free. (The price does not increase in this case.)
1458  *
1459  * There is a max supply of 10,000 First Edition Hashrunes. Additionally, we are able to decrease the max supply (but not increase it).
1460  * We are also able to increase the price increment (but not decrease it).
1461  *
1462  * Functions specific to Hashrunes:
1463  *   `mint(string name)`: Mint a Hashrune.
1464  *   `getName(uint256 tokenId) -> string`: Look up the name corresponding to a token id.
1465  *   `getTokenId(string name) -> uint256`: Look up the token id corresponding to a name.
1466  *   `getRune(string name) -> string`: Get the design of a Hashrune.
1467  *   `getCharacters(string name) -> string`: Get the list of characters used for a Hashrune.
1468  *   `getColors(string name) -> uint256[]`: Get a Hashrune's RGB24 colors. Each color corresponds to each character in `getCharacters(name)`,
1469  *                                          with an extra color for the background at the end of the list.
1470  *
1471  */
1472 contract GenesisHashrunes {
1473     function getTokenId(string memory _name) public view returns (uint256) {}
1474 
1475     function ownerOf(uint256 tokenId) public view returns (address) {}
1476 }
1477 
1478 contract FirstEditionHashrunes is ERC721Tradable {
1479     uint256 internal constant COLOR_SIZE = 24;
1480     uint256 internal constant ENTROPY_A =
1481         0x24eb1994b22999a9428330e650231f69ba716f811bef7dde3f7a73b0c1548151;
1482     uint256 internal constant ENTROPY_B =
1483         0xbace2a3d7089d722f901582121989045c3584e9093a44faebf23dd37040fe689;
1484     uint256 internal constant SIDE_LENGTH = 64;
1485     uint256 internal constant HALF_SIDE_LENGTH = SIDE_LENGTH / 2;
1486     uint256 internal constant RUNE_SIZE = SIDE_LENGTH * (3 * SIDE_LENGTH + 1);
1487     uint256 internal constant CORNER_THRESHOLD = 4 * SIDE_LENGTH - 17;
1488     uint256 internal constant VALUE_SHIFT = 16;
1489 
1490     GenesisHashrunes genesisHashrunes;
1491     uint256 public priceIncrement = 0.0002 ether;
1492     uint256 public maxSupply = 10000;
1493     uint256 public price = 0.05 ether;
1494     mapping(string => uint256) private tokenIds;
1495     mapping(uint256 => string) private names;
1496     uint256 private supply = 0;
1497 
1498     constructor(address _proxyRegistryAddress, address _genesisContractAddress)
1499         public
1500         ERC721Tradable("Hashrunes", "RUNE", _proxyRegistryAddress)
1501     {
1502         genesisHashrunes = GenesisHashrunes(_genesisContractAddress);
1503     }
1504 
1505     function mint(string memory _name) public payable {
1506         require(tokenIds[_name] == 0, "Name is already taken.");
1507         require(bytes(_name).length > 0, "Name cannot be empty.");
1508         require(
1509             supply < maxSupply,
1510             "Tokens at max supply; cannot mint any more."
1511         );
1512         uint256 genesisTokenId = genesisHashrunes.getTokenId(_name);
1513         uint256 _currentPrice;
1514         if (genesisTokenId > 0) {
1515             require(
1516                 _msgSender() == genesisHashrunes.ownerOf(genesisTokenId),
1517                 "The Genesis Hashrune exists for this name. Only its owner can mint this First Edition."
1518             );
1519             _currentPrice = 0;
1520         } else {
1521             _currentPrice = price;
1522             price += priceIncrement;
1523             require(price > _currentPrice);
1524             require(
1525                 msg.value >= _currentPrice,
1526                 "Price is greater than amount sent."
1527             );
1528             address payable _wallet = address(uint160(owner()));
1529             _wallet.transfer(_currentPrice);
1530         }
1531         _mint(_msgSender(), ++supply);
1532         tokenIds[_name] = supply;
1533         names[supply] = _name;
1534         if (msg.value > _currentPrice) {
1535             msg.sender.transfer(msg.value - _currentPrice);
1536         }
1537     }
1538 
1539     function getName(uint256 _tokenId) public view returns (string memory) {
1540         return names[_tokenId];
1541     }
1542 
1543     function getTokenId(string memory _name) public view returns (uint256) {
1544         return tokenIds[_name];
1545     }
1546 
1547     function _getCharacters(uint256 _seed)
1548         internal
1549         pure
1550         returns (string memory)
1551     {
1552         uint256 _themeSeed = _seed % 5;
1553         if (_themeSeed == 0) return "■▬▮▰▲▶▼◀◆●◖◗◢◣◤◥";
1554         if (_themeSeed == 1) return "■▬▮▰";
1555         if (_themeSeed == 2) return "▲▶▼◀";
1556         if (_themeSeed == 3) return "◆●◖◗";
1557         return "◢◣◤◥";
1558     }
1559 
1560     function getCharacters(string memory _name)
1561         public
1562         pure
1563         returns (string memory)
1564     {
1565         return _getCharacters(String.hash(_name));
1566     }
1567 
1568     function getColors(string memory _name)
1569         public
1570         pure
1571         returns (uint256[] memory)
1572     {
1573         uint256 _seed = String.hash(_name);
1574         bytes memory _characters = bytes(_getCharacters(_seed));
1575         uint256 _oddSeed = 2 * _seed + 1;
1576         uint256 _resultSize = _characters.length / 3 + 1;
1577         uint256[] memory _result = new uint256[](_resultSize);
1578         uint256 _i = 0;
1579         uint256 _colorSeed = (_oddSeed * ENTROPY_A) >> 1;
1580         if (_resultSize > 8) {
1581             while (_i < 8) {
1582                 _result[_i++] = _colorSeed & 0xffffff;
1583                 _colorSeed >>= COLOR_SIZE;
1584             }
1585             _colorSeed = (_oddSeed * ENTROPY_B) >> 1;
1586         }
1587         while (_i < _result.length) {
1588             _result[_i++] = _colorSeed & 0xffffff;
1589             _colorSeed >>= COLOR_SIZE;
1590         }
1591         return _result;
1592     }
1593 
1594     function getRune(string memory _name) public pure returns (string memory) {
1595         uint256 _seed = String.hash(_name);
1596         bytes memory _characters = bytes(_getCharacters(_seed));
1597         uint256 _charactersLength = _characters.length / 3;
1598         bytes memory _result = new bytes(RUNE_SIZE);
1599         uint256 _oddSeed = 2 * _seed + 1;
1600         uint256 _modulus =
1601             (_seed % (_charactersLength * ((_seed % 3) + 1))) +
1602                 _charactersLength;
1603         uint256 _index = 0;
1604         for (uint256 _y = 0; _y < SIDE_LENGTH; ++_y) {
1605             uint256 _b =
1606                 _y < HALF_SIDE_LENGTH ? 2 * (SIDE_LENGTH - _y) - 1 : 2 * _y + 1;
1607             for (uint256 _x = 0; _x < SIDE_LENGTH; ++_x) {
1608                 uint256 _a =
1609                     _x < HALF_SIDE_LENGTH
1610                         ? 2 * (SIDE_LENGTH - _x) - 1
1611                         : 2 * _x + 1;
1612                 uint256 _residue =
1613                     _a + _b > CORNER_THRESHOLD
1614                         ? _seed % _charactersLength
1615                         : ((_a * _b * (_a + _b + 1) * _oddSeed * ENTROPY_A) >>
1616                             VALUE_SHIFT) % _modulus;
1617                 if (_residue < _charactersLength) {
1618                     _residue *= 3;
1619                     _result[_index++] = _characters[_residue];
1620                     _result[_index++] = _characters[_residue + 1];
1621                     _result[_index++] = _characters[_residue + 2];
1622                 } else {
1623                     _result[_index++] = " ";
1624                 }
1625             }
1626             _result[_index++] = "\n";
1627         }
1628         --_index;
1629         assembly {
1630             mstore(_result, _index)
1631         }
1632         return string(_result);
1633     }
1634 
1635     function contractURI() public pure returns (string memory) {
1636         return "https://api.hashrunes.com/v1/contract/1";
1637     }
1638 
1639     function baseTokenURI() public pure returns (string memory) {
1640         return "https://api.hashrunes.com/v1/runes/1/";
1641     }
1642 
1643     function decreaseMaxSupply(uint256 _amount) public onlyOwner() {
1644         uint256 _newMaxSupply = maxSupply - _amount;
1645         require(_newMaxSupply < maxSupply);
1646         if (_newMaxSupply > supply) {
1647             maxSupply = _newMaxSupply;
1648         } else if (maxSupply > supply) {
1649             maxSupply = supply;
1650         }
1651     }
1652 
1653     function increasePriceIncrement(uint256 _amount) public onlyOwner() {
1654         uint256 _newPriceIncrement = priceIncrement + _amount;
1655         require(_newPriceIncrement > priceIncrement);
1656         priceIncrement = _newPriceIncrement;
1657     }
1658 }