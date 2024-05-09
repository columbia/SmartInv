1 /**
2  *
3  * ██╗  ██╗ █████╗ ███████╗██╗  ██╗██████╗ ██╗   ██╗███╗   ██╗███████╗███████╗
4  * ██║  ██║██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║████╗  ██║██╔════╝██╔════╝
5  * ███████║███████║███████╗███████║██████╔╝██║   ██║██╔██╗ ██║█████╗  ███████╗
6  * ██╔══██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝  ╚════██║
7  * ██║  ██║██║  ██║███████║██║  ██║██║  ██║╚██████╔╝██║ ╚████║███████╗███████║
8  * ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
9  *
10  * personalized generative art on the blockchain                  by Joshua Wu
11  *
12  *
13  * Hashrunes are on-chain generative art created by you.
14  * A Hashrune's design is based on its unique name. Anyone can mint a Hashrune by naming it and paying a fee.
15  * The price to mint a Hashrune starts at 0.05 ETH. For each Hashrune minted, the price will increase by 1%.
16  *
17  * Functions specific to Hashrunes:
18  *   `mint(string name)`: Mint a Hashrune.
19  *   `getName(uint256 tokenId) -> string`: Look up the name corresponding to a token id.
20  *   `getTokenId(string name) -> uint256`: Look up the token id corresponding to a name.
21  *   `getRune(string name) -> string`: Get the design of a Hashrune.
22  *   `getCharacters(string name) -> string`: Get the list of characters used for a Hashrune.
23  *   `getColors(string name) -> uint256[]`: Get a Hashrune's RGB24 colors. Each color corresponds to each character in `getCharacters(name)`,
24  *                                          with an extra color for the background at the end of the list.
25  *
26  */
27 
28 
29 
30 
31 // File: openzeppelin-solidity/contracts/GSN/Context.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /*
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with GSN meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 contract Context {
46     // Empty internal constructor, to prevent people from mistakenly deploying
47     // an instance of this contract, which should be used via inheritance.
48     constructor () internal { }
49     // solhint-disable-previous-line no-empty-blocks
50 
51     function _msgSender() internal view returns (address payable) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view returns (bytes memory) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
62 
63 pragma solidity ^0.5.0;
64 
65 /**
66  * @dev Interface of the ERC165 standard, as defined in the
67  * https://eips.ethereum.org/EIPS/eip-165[EIP].
68  *
69  * Implementers can declare support of contract interfaces, which can then be
70  * queried by others ({ERC165Checker}).
71  *
72  * For an implementation, see {ERC165}.
73  */
74 interface IERC165 {
75     /**
76      * @dev Returns true if this contract implements the interface defined by
77      * `interfaceId`. See the corresponding
78      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
79      * to learn more about how these ids are created.
80      *
81      * This function call must use less than 30 000 gas.
82      */
83     function supportsInterface(bytes4 interfaceId) external view returns (bool);
84 }
85 
86 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
87 
88 pragma solidity ^0.5.0;
89 
90 
91 /**
92  * @dev Required interface of an ERC721 compliant contract.
93  */
94 contract IERC721 is IERC165 {
95     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
96     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
97     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
98 
99     /**
100      * @dev Returns the number of NFTs in `owner`'s account.
101      */
102     function balanceOf(address owner) public view returns (uint256 balance);
103 
104     /**
105      * @dev Returns the owner of the NFT specified by `tokenId`.
106      */
107     function ownerOf(uint256 tokenId) public view returns (address owner);
108 
109     /**
110      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
111      * another (`to`).
112      *
113      *
114      *
115      * Requirements:
116      * - `from`, `to` cannot be zero.
117      * - `tokenId` must be owned by `from`.
118      * - If the caller is not `from`, it must be have been allowed to move this
119      * NFT by either {approve} or {setApprovalForAll}.
120      */
121     function safeTransferFrom(address from, address to, uint256 tokenId) public;
122     /**
123      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
124      * another (`to`).
125      *
126      * Requirements:
127      * - If the caller is not `from`, it must be approved to move this NFT by
128      * either {approve} or {setApprovalForAll}.
129      */
130     function transferFrom(address from, address to, uint256 tokenId) public;
131     function approve(address to, uint256 tokenId) public;
132     function getApproved(uint256 tokenId) public view returns (address operator);
133 
134     function setApprovalForAll(address operator, bool _approved) public;
135     function isApprovedForAll(address owner, address operator) public view returns (bool);
136 
137 
138     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
142 
143 pragma solidity ^0.5.0;
144 
145 /**
146  * @title ERC721 token receiver interface
147  * @dev Interface for any contract that wants to support safeTransfers
148  * from ERC721 asset contracts.
149  */
150 contract IERC721Receiver {
151     /**
152      * @notice Handle the receipt of an NFT
153      * @dev The ERC721 smart contract calls this function on the recipient
154      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
155      * otherwise the caller will revert the transaction. The selector to be
156      * returned can be obtained as `this.onERC721Received.selector`. This
157      * function MAY throw to revert and reject the transfer.
158      * Note: the ERC721 contract address is always the message sender.
159      * @param operator The address which called `safeTransferFrom` function
160      * @param from The address which previously owned the token
161      * @param tokenId The NFT identifier which is being transferred
162      * @param data Additional data with no specified format
163      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
164      */
165     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
166     public returns (bytes4);
167 }
168 
169 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
170 
171 pragma solidity ^0.5.0;
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         return sub(a, b, "SafeMath: subtraction overflow");
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      * - Subtraction cannot overflow.
224      *
225      * _Available since v2.4.0._
226      */
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245         // benefit is lost if 'b' is also tested.
246         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
247         if (a == 0) {
248             return 0;
249         }
250 
251         uint256 c = a * b;
252         require(c / a == b, "SafeMath: multiplication overflow");
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers. Reverts on
259      * division by zero. The result is rounded towards zero.
260      *
261      * Counterpart to Solidity's `/` operator. Note: this function uses a
262      * `revert` opcode (which leaves remaining gas untouched) while Solidity
263      * uses an invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         return div(a, b, "SafeMath: division by zero");
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator. Note: this function uses a
277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
278      * uses an invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      * - The divisor cannot be zero.
282      *
283      * _Available since v2.4.0._
284      */
285     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         // Solidity only automatically asserts when dividing by 0
287         require(b > 0, errorMessage);
288         uint256 c = a / b;
289         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290 
291         return c;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * Reverts when dividing by zero.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      * - The divisor cannot be zero.
304      */
305     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
306         return mod(a, b, "SafeMath: modulo by zero");
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
311      * Reverts with custom message when dividing by zero.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      * - The divisor cannot be zero.
319      *
320      * _Available since v2.4.0._
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b != 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 // File: openzeppelin-solidity/contracts/utils/Address.sol
329 
330 pragma solidity ^0.5.5;
331 
332 /**
333  * @dev Collection of functions related to the address type
334  */
335 library Address {
336     /**
337      * @dev Returns true if `account` is a contract.
338      *
339      * [IMPORTANT]
340      * ====
341      * It is unsafe to assume that an address for which this function returns
342      * false is an externally-owned account (EOA) and not a contract.
343      *
344      * Among others, `isContract` will return false for the following 
345      * types of addresses:
346      *
347      *  - an externally-owned account
348      *  - a contract in construction
349      *  - an address where a contract will be created
350      *  - an address where a contract lived, but was destroyed
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
355         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
356         // for accounts without code, i.e. `keccak256('')`
357         bytes32 codehash;
358         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
359         // solhint-disable-next-line no-inline-assembly
360         assembly { codehash := extcodehash(account) }
361         return (codehash != accountHash && codehash != 0x0);
362     }
363 
364     /**
365      * @dev Converts an `address` into `address payable`. Note that this is
366      * simply a type cast: the actual underlying value is not changed.
367      *
368      * _Available since v2.4.0._
369      */
370     function toPayable(address account) internal pure returns (address payable) {
371         return address(uint160(account));
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      *
390      * _Available since v2.4.0._
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         // solhint-disable-next-line avoid-call-value
396         (bool success, ) = recipient.call.value(amount)("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 }
400 
401 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
402 
403 pragma solidity ^0.5.0;
404 
405 
406 /**
407  * @title Counters
408  * @author Matt Condon (@shrugs)
409  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
410  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
411  *
412  * Include with `using Counters for Counters.Counter;`
413  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
414  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
415  * directly accessed.
416  */
417 library Counters {
418     using SafeMath for uint256;
419 
420     struct Counter {
421         // This variable should never be directly accessed by users of the library: interactions must be restricted to
422         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
423         // this feature: see https://github.com/ethereum/solidity/issues/4637
424         uint256 _value; // default: 0
425     }
426 
427     function current(Counter storage counter) internal view returns (uint256) {
428         return counter._value;
429     }
430 
431     function increment(Counter storage counter) internal {
432         // The {SafeMath} overflow check can be skipped here, see the comment at the top
433         counter._value += 1;
434     }
435 
436     function decrement(Counter storage counter) internal {
437         counter._value = counter._value.sub(1);
438     }
439 }
440 
441 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
442 
443 pragma solidity ^0.5.0;
444 
445 
446 /**
447  * @dev Implementation of the {IERC165} interface.
448  *
449  * Contracts may inherit from this and call {_registerInterface} to declare
450  * their support of an interface.
451  */
452 contract ERC165 is IERC165 {
453     /*
454      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
455      */
456     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
457 
458     /**
459      * @dev Mapping of interface ids to whether or not it's supported.
460      */
461     mapping(bytes4 => bool) private _supportedInterfaces;
462 
463     constructor () internal {
464         // Derived contracts need only register support for their own interfaces,
465         // we register support for ERC165 itself here
466         _registerInterface(_INTERFACE_ID_ERC165);
467     }
468 
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      *
472      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
473      */
474     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
475         return _supportedInterfaces[interfaceId];
476     }
477 
478     /**
479      * @dev Registers the contract as an implementer of the interface defined by
480      * `interfaceId`. Support of the actual ERC165 interface is automatic and
481      * registering its interface id is not required.
482      *
483      * See {IERC165-supportsInterface}.
484      *
485      * Requirements:
486      *
487      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
488      */
489     function _registerInterface(bytes4 interfaceId) internal {
490         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
491         _supportedInterfaces[interfaceId] = true;
492     }
493 }
494 
495 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
496 
497 pragma solidity ^0.5.0;
498 
499 
500 
501 
502 
503 
504 
505 
506 /**
507  * @title ERC721 Non-Fungible Token Standard basic implementation
508  * @dev see https://eips.ethereum.org/EIPS/eip-721
509  */
510 contract ERC721 is Context, ERC165, IERC721 {
511     using SafeMath for uint256;
512     using Address for address;
513     using Counters for Counters.Counter;
514 
515     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
516     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
517     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
518 
519     // Mapping from token ID to owner
520     mapping (uint256 => address) private _tokenOwner;
521 
522     // Mapping from token ID to approved address
523     mapping (uint256 => address) private _tokenApprovals;
524 
525     // Mapping from owner to number of owned token
526     mapping (address => Counters.Counter) private _ownedTokensCount;
527 
528     // Mapping from owner to operator approvals
529     mapping (address => mapping (address => bool)) private _operatorApprovals;
530 
531     /*
532      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
533      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
534      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
535      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
536      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
537      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
538      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
539      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
540      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
541      *
542      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
543      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
544      */
545     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
546 
547     constructor () public {
548         // register the supported interfaces to conform to ERC721 via ERC165
549         _registerInterface(_INTERFACE_ID_ERC721);
550     }
551 
552     /**
553      * @dev Gets the balance of the specified address.
554      * @param owner address to query the balance of
555      * @return uint256 representing the amount owned by the passed address
556      */
557     function balanceOf(address owner) public view returns (uint256) {
558         require(owner != address(0), "ERC721: balance query for the zero address");
559 
560         return _ownedTokensCount[owner].current();
561     }
562 
563     /**
564      * @dev Gets the owner of the specified token ID.
565      * @param tokenId uint256 ID of the token to query the owner of
566      * @return address currently marked as the owner of the given token ID
567      */
568     function ownerOf(uint256 tokenId) public view returns (address) {
569         address owner = _tokenOwner[tokenId];
570         require(owner != address(0), "ERC721: owner query for nonexistent token");
571 
572         return owner;
573     }
574 
575     /**
576      * @dev Approves another address to transfer the given token ID
577      * The zero address indicates there is no approved address.
578      * There can only be one approved address per token at a given time.
579      * Can only be called by the token owner or an approved operator.
580      * @param to address to be approved for the given token ID
581      * @param tokenId uint256 ID of the token to be approved
582      */
583     function approve(address to, uint256 tokenId) public {
584         address owner = ownerOf(tokenId);
585         require(to != owner, "ERC721: approval to current owner");
586 
587         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
588             "ERC721: approve caller is not owner nor approved for all"
589         );
590 
591         _tokenApprovals[tokenId] = to;
592         emit Approval(owner, to, tokenId);
593     }
594 
595     /**
596      * @dev Gets the approved address for a token ID, or zero if no address set
597      * Reverts if the token ID does not exist.
598      * @param tokenId uint256 ID of the token to query the approval of
599      * @return address currently approved for the given token ID
600      */
601     function getApproved(uint256 tokenId) public view returns (address) {
602         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
603 
604         return _tokenApprovals[tokenId];
605     }
606 
607     /**
608      * @dev Sets or unsets the approval of a given operator
609      * An operator is allowed to transfer all tokens of the sender on their behalf.
610      * @param to operator address to set the approval
611      * @param approved representing the status of the approval to be set
612      */
613     function setApprovalForAll(address to, bool approved) public {
614         require(to != _msgSender(), "ERC721: approve to caller");
615 
616         _operatorApprovals[_msgSender()][to] = approved;
617         emit ApprovalForAll(_msgSender(), to, approved);
618     }
619 
620     /**
621      * @dev Tells whether an operator is approved by a given owner.
622      * @param owner owner address which you want to query the approval of
623      * @param operator operator address which you want to query the approval of
624      * @return bool whether the given operator is approved by the given owner
625      */
626     function isApprovedForAll(address owner, address operator) public view returns (bool) {
627         return _operatorApprovals[owner][operator];
628     }
629 
630     /**
631      * @dev Transfers the ownership of a given token ID to another address.
632      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      * Requires the msg.sender to be the owner, approved, or operator.
634      * @param from current owner of the token
635      * @param to address to receive the ownership of the given token ID
636      * @param tokenId uint256 ID of the token to be transferred
637      */
638     function transferFrom(address from, address to, uint256 tokenId) public {
639         //solhint-disable-next-line max-line-length
640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
641 
642         _transferFrom(from, to, tokenId);
643     }
644 
645     /**
646      * @dev Safely transfers the ownership of a given token ID to another address
647      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
648      * which is called upon a safe transfer, and return the magic value
649      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
650      * the transfer is reverted.
651      * Requires the msg.sender to be the owner, approved, or operator
652      * @param from current owner of the token
653      * @param to address to receive the ownership of the given token ID
654      * @param tokenId uint256 ID of the token to be transferred
655      */
656     function safeTransferFrom(address from, address to, uint256 tokenId) public {
657         safeTransferFrom(from, to, tokenId, "");
658     }
659 
660     /**
661      * @dev Safely transfers the ownership of a given token ID to another address
662      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
663      * which is called upon a safe transfer, and return the magic value
664      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
665      * the transfer is reverted.
666      * Requires the _msgSender() to be the owner, approved, or operator
667      * @param from current owner of the token
668      * @param to address to receive the ownership of the given token ID
669      * @param tokenId uint256 ID of the token to be transferred
670      * @param _data bytes data to send along with a safe transfer check
671      */
672     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
673         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
674         _safeTransferFrom(from, to, tokenId, _data);
675     }
676 
677     /**
678      * @dev Safely transfers the ownership of a given token ID to another address
679      * If the target address is a contract, it must implement `onERC721Received`,
680      * which is called upon a safe transfer, and return the magic value
681      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
682      * the transfer is reverted.
683      * Requires the msg.sender to be the owner, approved, or operator
684      * @param from current owner of the token
685      * @param to address to receive the ownership of the given token ID
686      * @param tokenId uint256 ID of the token to be transferred
687      * @param _data bytes data to send along with a safe transfer check
688      */
689     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
690         _transferFrom(from, to, tokenId);
691         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
692     }
693 
694     /**
695      * @dev Returns whether the specified token exists.
696      * @param tokenId uint256 ID of the token to query the existence of
697      * @return bool whether the token exists
698      */
699     function _exists(uint256 tokenId) internal view returns (bool) {
700         address owner = _tokenOwner[tokenId];
701         return owner != address(0);
702     }
703 
704     /**
705      * @dev Returns whether the given spender can transfer a given token ID.
706      * @param spender address of the spender to query
707      * @param tokenId uint256 ID of the token to be transferred
708      * @return bool whether the msg.sender is approved for the given token ID,
709      * is an operator of the owner, or is the owner of the token
710      */
711     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
712         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
713         address owner = ownerOf(tokenId);
714         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
715     }
716 
717     /**
718      * @dev Internal function to safely mint a new token.
719      * Reverts if the given token ID already exists.
720      * If the target address is a contract, it must implement `onERC721Received`,
721      * which is called upon a safe transfer, and return the magic value
722      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
723      * the transfer is reverted.
724      * @param to The address that will own the minted token
725      * @param tokenId uint256 ID of the token to be minted
726      */
727     function _safeMint(address to, uint256 tokenId) internal {
728         _safeMint(to, tokenId, "");
729     }
730 
731     /**
732      * @dev Internal function to safely mint a new token.
733      * Reverts if the given token ID already exists.
734      * If the target address is a contract, it must implement `onERC721Received`,
735      * which is called upon a safe transfer, and return the magic value
736      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
737      * the transfer is reverted.
738      * @param to The address that will own the minted token
739      * @param tokenId uint256 ID of the token to be minted
740      * @param _data bytes data to send along with a safe transfer check
741      */
742     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
743         _mint(to, tokenId);
744         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
745     }
746 
747     /**
748      * @dev Internal function to mint a new token.
749      * Reverts if the given token ID already exists.
750      * @param to The address that will own the minted token
751      * @param tokenId uint256 ID of the token to be minted
752      */
753     function _mint(address to, uint256 tokenId) internal {
754         require(to != address(0), "ERC721: mint to the zero address");
755         require(!_exists(tokenId), "ERC721: token already minted");
756 
757         _tokenOwner[tokenId] = to;
758         _ownedTokensCount[to].increment();
759 
760         emit Transfer(address(0), to, tokenId);
761     }
762 
763     /**
764      * @dev Internal function to burn a specific token.
765      * Reverts if the token does not exist.
766      * Deprecated, use {_burn} instead.
767      * @param owner owner of the token to burn
768      * @param tokenId uint256 ID of the token being burned
769      */
770     function _burn(address owner, uint256 tokenId) internal {
771         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
772 
773         _clearApproval(tokenId);
774 
775         _ownedTokensCount[owner].decrement();
776         _tokenOwner[tokenId] = address(0);
777 
778         emit Transfer(owner, address(0), tokenId);
779     }
780 
781     /**
782      * @dev Internal function to burn a specific token.
783      * Reverts if the token does not exist.
784      * @param tokenId uint256 ID of the token being burned
785      */
786     function _burn(uint256 tokenId) internal {
787         _burn(ownerOf(tokenId), tokenId);
788     }
789 
790     /**
791      * @dev Internal function to transfer ownership of a given token ID to another address.
792      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
793      * @param from current owner of the token
794      * @param to address to receive the ownership of the given token ID
795      * @param tokenId uint256 ID of the token to be transferred
796      */
797     function _transferFrom(address from, address to, uint256 tokenId) internal {
798         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
799         require(to != address(0), "ERC721: transfer to the zero address");
800 
801         _clearApproval(tokenId);
802 
803         _ownedTokensCount[from].decrement();
804         _ownedTokensCount[to].increment();
805 
806         _tokenOwner[tokenId] = to;
807 
808         emit Transfer(from, to, tokenId);
809     }
810 
811     /**
812      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
813      * The call is not executed if the target address is not a contract.
814      *
815      * This is an internal detail of the `ERC721` contract and its use is deprecated.
816      * @param from address representing the previous owner of the given token ID
817      * @param to target address that will receive the tokens
818      * @param tokenId uint256 ID of the token to be transferred
819      * @param _data bytes optional data to send along with the call
820      * @return bool whether the call correctly returned the expected magic value
821      */
822     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
823         internal returns (bool)
824     {
825         if (!to.isContract()) {
826             return true;
827         }
828         // solhint-disable-next-line avoid-low-level-calls
829         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
830             IERC721Receiver(to).onERC721Received.selector,
831             _msgSender(),
832             from,
833             tokenId,
834             _data
835         ));
836         if (!success) {
837             if (returndata.length > 0) {
838                 // solhint-disable-next-line no-inline-assembly
839                 assembly {
840                     let returndata_size := mload(returndata)
841                     revert(add(32, returndata), returndata_size)
842                 }
843             } else {
844                 revert("ERC721: transfer to non ERC721Receiver implementer");
845             }
846         } else {
847             bytes4 retval = abi.decode(returndata, (bytes4));
848             return (retval == _ERC721_RECEIVED);
849         }
850     }
851 
852     /**
853      * @dev Private function to clear current approval of a given token ID.
854      * @param tokenId uint256 ID of the token to be transferred
855      */
856     function _clearApproval(uint256 tokenId) private {
857         if (_tokenApprovals[tokenId] != address(0)) {
858             _tokenApprovals[tokenId] = address(0);
859         }
860     }
861 }
862 
863 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
864 
865 pragma solidity ^0.5.0;
866 
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-721
871  */
872 contract IERC721Enumerable is IERC721 {
873     function totalSupply() public view returns (uint256);
874     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
875 
876     function tokenByIndex(uint256 index) public view returns (uint256);
877 }
878 
879 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
880 
881 pragma solidity ^0.5.0;
882 
883 
884 
885 
886 
887 /**
888  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
889  * @dev See https://eips.ethereum.org/EIPS/eip-721
890  */
891 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
892     // Mapping from owner to list of owned token IDs
893     mapping(address => uint256[]) private _ownedTokens;
894 
895     // Mapping from token ID to index of the owner tokens list
896     mapping(uint256 => uint256) private _ownedTokensIndex;
897 
898     // Array with all token ids, used for enumeration
899     uint256[] private _allTokens;
900 
901     // Mapping from token id to position in the allTokens array
902     mapping(uint256 => uint256) private _allTokensIndex;
903 
904     /*
905      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
906      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
907      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
908      *
909      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
910      */
911     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
912 
913     /**
914      * @dev Constructor function.
915      */
916     constructor () public {
917         // register the supported interface to conform to ERC721Enumerable via ERC165
918         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
919     }
920 
921     /**
922      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
923      * @param owner address owning the tokens list to be accessed
924      * @param index uint256 representing the index to be accessed of the requested tokens list
925      * @return uint256 token ID at the given index of the tokens list owned by the requested address
926      */
927     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
928         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
929         return _ownedTokens[owner][index];
930     }
931 
932     /**
933      * @dev Gets the total amount of tokens stored by the contract.
934      * @return uint256 representing the total amount of tokens
935      */
936     function totalSupply() public view returns (uint256) {
937         return _allTokens.length;
938     }
939 
940     /**
941      * @dev Gets the token ID at a given index of all the tokens in this contract
942      * Reverts if the index is greater or equal to the total number of tokens.
943      * @param index uint256 representing the index to be accessed of the tokens list
944      * @return uint256 token ID at the given index of the tokens list
945      */
946     function tokenByIndex(uint256 index) public view returns (uint256) {
947         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
948         return _allTokens[index];
949     }
950 
951     /**
952      * @dev Internal function to transfer ownership of a given token ID to another address.
953      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
954      * @param from current owner of the token
955      * @param to address to receive the ownership of the given token ID
956      * @param tokenId uint256 ID of the token to be transferred
957      */
958     function _transferFrom(address from, address to, uint256 tokenId) internal {
959         super._transferFrom(from, to, tokenId);
960 
961         _removeTokenFromOwnerEnumeration(from, tokenId);
962 
963         _addTokenToOwnerEnumeration(to, tokenId);
964     }
965 
966     /**
967      * @dev Internal function to mint a new token.
968      * Reverts if the given token ID already exists.
969      * @param to address the beneficiary that will own the minted token
970      * @param tokenId uint256 ID of the token to be minted
971      */
972     function _mint(address to, uint256 tokenId) internal {
973         super._mint(to, tokenId);
974 
975         _addTokenToOwnerEnumeration(to, tokenId);
976 
977         _addTokenToAllTokensEnumeration(tokenId);
978     }
979 
980     /**
981      * @dev Internal function to burn a specific token.
982      * Reverts if the token does not exist.
983      * Deprecated, use {ERC721-_burn} instead.
984      * @param owner owner of the token to burn
985      * @param tokenId uint256 ID of the token being burned
986      */
987     function _burn(address owner, uint256 tokenId) internal {
988         super._burn(owner, tokenId);
989 
990         _removeTokenFromOwnerEnumeration(owner, tokenId);
991         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
992         _ownedTokensIndex[tokenId] = 0;
993 
994         _removeTokenFromAllTokensEnumeration(tokenId);
995     }
996 
997     /**
998      * @dev Gets the list of token IDs of the requested owner.
999      * @param owner address owning the tokens
1000      * @return uint256[] List of token IDs owned by the requested address
1001      */
1002     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1003         return _ownedTokens[owner];
1004     }
1005 
1006     /**
1007      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1008      * @param to address representing the new owner of the given token ID
1009      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1010      */
1011     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1012         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1013         _ownedTokens[to].push(tokenId);
1014     }
1015 
1016     /**
1017      * @dev Private function to add a token to this extension's token tracking data structures.
1018      * @param tokenId uint256 ID of the token to be added to the tokens list
1019      */
1020     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1021         _allTokensIndex[tokenId] = _allTokens.length;
1022         _allTokens.push(tokenId);
1023     }
1024 
1025     /**
1026      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1027      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1028      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1029      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1030      * @param from address representing the previous owner of the given token ID
1031      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1032      */
1033     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1034         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1035         // then delete the last slot (swap and pop).
1036 
1037         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1038         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1039 
1040         // When the token to delete is the last token, the swap operation is unnecessary
1041         if (tokenIndex != lastTokenIndex) {
1042             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1043 
1044             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1045             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1046         }
1047 
1048         // This also deletes the contents at the last position of the array
1049         _ownedTokens[from].length--;
1050 
1051         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1052         // lastTokenId, or just over the end of the array if the token was the last one).
1053     }
1054 
1055     /**
1056      * @dev Private function to remove a token from this extension's token tracking data structures.
1057      * This has O(1) time complexity, but alters the order of the _allTokens array.
1058      * @param tokenId uint256 ID of the token to be removed from the tokens list
1059      */
1060     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1061         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1062         // then delete the last slot (swap and pop).
1063 
1064         uint256 lastTokenIndex = _allTokens.length.sub(1);
1065         uint256 tokenIndex = _allTokensIndex[tokenId];
1066 
1067         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1068         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1069         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1070         uint256 lastTokenId = _allTokens[lastTokenIndex];
1071 
1072         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1073         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1074 
1075         // This also deletes the contents at the last position of the array
1076         _allTokens.length--;
1077         _allTokensIndex[tokenId] = 0;
1078     }
1079 }
1080 
1081 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
1082 
1083 pragma solidity ^0.5.0;
1084 
1085 
1086 /**
1087  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1088  * @dev See https://eips.ethereum.org/EIPS/eip-721
1089  */
1090 contract IERC721Metadata is IERC721 {
1091     function name() external view returns (string memory);
1092     function symbol() external view returns (string memory);
1093     function tokenURI(uint256 tokenId) external view returns (string memory);
1094 }
1095 
1096 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
1097 
1098 pragma solidity ^0.5.0;
1099 
1100 
1101 
1102 
1103 
1104 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1105     // Token name
1106     string private _name;
1107 
1108     // Token symbol
1109     string private _symbol;
1110 
1111     // Base URI
1112     string private _baseURI;
1113 
1114     // Optional mapping for token URIs
1115     mapping(uint256 => string) private _tokenURIs;
1116 
1117     /*
1118      *     bytes4(keccak256('name()')) == 0x06fdde03
1119      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1120      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1121      *
1122      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1123      */
1124     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1125 
1126     /**
1127      * @dev Constructor function
1128      */
1129     constructor (string memory name, string memory symbol) public {
1130         _name = name;
1131         _symbol = symbol;
1132 
1133         // register the supported interfaces to conform to ERC721 via ERC165
1134         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1135     }
1136 
1137     /**
1138      * @dev Gets the token name.
1139      * @return string representing the token name
1140      */
1141     function name() external view returns (string memory) {
1142         return _name;
1143     }
1144 
1145     /**
1146      * @dev Gets the token symbol.
1147      * @return string representing the token symbol
1148      */
1149     function symbol() external view returns (string memory) {
1150         return _symbol;
1151     }
1152 
1153     /**
1154      * @dev Returns the URI for a given token ID. May return an empty string.
1155      *
1156      * If the token's URI is non-empty and a base URI was set (via
1157      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1158      *
1159      * Reverts if the token ID does not exist.
1160      */
1161     function tokenURI(uint256 tokenId) external view returns (string memory) {
1162         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1163 
1164         string memory _tokenURI = _tokenURIs[tokenId];
1165 
1166         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1167         if (bytes(_tokenURI).length == 0) {
1168             return "";
1169         } else {
1170             // abi.encodePacked is being used to concatenate strings
1171             return string(abi.encodePacked(_baseURI, _tokenURI));
1172         }
1173     }
1174 
1175     /**
1176      * @dev Internal function to set the token URI for a given token.
1177      *
1178      * Reverts if the token ID does not exist.
1179      *
1180      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1181      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1182      * it and save gas.
1183      */
1184     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1185         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1186         _tokenURIs[tokenId] = _tokenURI;
1187     }
1188 
1189     /**
1190      * @dev Internal function to set the base URI for all token IDs. It is
1191      * automatically added as a prefix to the value returned in {tokenURI}.
1192      *
1193      * _Available since v2.5.0._
1194      */
1195     function _setBaseURI(string memory baseURI) internal {
1196         _baseURI = baseURI;
1197     }
1198 
1199     /**
1200     * @dev Returns the base URI set via {_setBaseURI}. This will be
1201     * automatically added as a preffix in {tokenURI} to each token's URI, when
1202     * they are non-empty.
1203     *
1204     * _Available since v2.5.0._
1205     */
1206     function baseURI() external view returns (string memory) {
1207         return _baseURI;
1208     }
1209 
1210     /**
1211      * @dev Internal function to burn a specific token.
1212      * Reverts if the token does not exist.
1213      * Deprecated, use _burn(uint256) instead.
1214      * @param owner owner of the token to burn
1215      * @param tokenId uint256 ID of the token being burned by the msg.sender
1216      */
1217     function _burn(address owner, uint256 tokenId) internal {
1218         super._burn(owner, tokenId);
1219 
1220         // Clear metadata (if any)
1221         if (bytes(_tokenURIs[tokenId]).length != 0) {
1222             delete _tokenURIs[tokenId];
1223         }
1224     }
1225 }
1226 
1227 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1228 
1229 pragma solidity ^0.5.0;
1230 
1231 
1232 
1233 
1234 /**
1235  * @title Full ERC721 Token
1236  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1237  * Moreover, it includes approve all functionality using operator terminology.
1238  *
1239  * See https://eips.ethereum.org/EIPS/eip-721
1240  */
1241 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1242     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1243         // solhint-disable-previous-line no-empty-blocks
1244     }
1245 }
1246 
1247 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1248 
1249 pragma solidity ^0.5.0;
1250 
1251 /**
1252  * @dev Contract module which provides a basic access control mechanism, where
1253  * there is an account (an owner) that can be granted exclusive access to
1254  * specific functions.
1255  *
1256  * This module is used through inheritance. It will make available the modifier
1257  * `onlyOwner`, which can be applied to your functions to restrict their use to
1258  * the owner.
1259  */
1260 contract Ownable is Context {
1261     address private _owner;
1262 
1263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1264 
1265     /**
1266      * @dev Initializes the contract setting the deployer as the initial owner.
1267      */
1268     constructor () internal {
1269         address msgSender = _msgSender();
1270         _owner = msgSender;
1271         emit OwnershipTransferred(address(0), msgSender);
1272     }
1273 
1274     /**
1275      * @dev Returns the address of the current owner.
1276      */
1277     function owner() public view returns (address) {
1278         return _owner;
1279     }
1280 
1281     /**
1282      * @dev Throws if called by any account other than the owner.
1283      */
1284     modifier onlyOwner() {
1285         require(isOwner(), "Ownable: caller is not the owner");
1286         _;
1287     }
1288 
1289     /**
1290      * @dev Returns true if the caller is the current owner.
1291      */
1292     function isOwner() public view returns (bool) {
1293         return _msgSender() == _owner;
1294     }
1295 
1296     /**
1297      * @dev Leaves the contract without owner. It will not be possible to call
1298      * `onlyOwner` functions anymore. Can only be called by the current owner.
1299      *
1300      * NOTE: Renouncing ownership will leave the contract without an owner,
1301      * thereby removing any functionality that is only available to the owner.
1302      */
1303     function renounceOwnership() public onlyOwner {
1304         emit OwnershipTransferred(_owner, address(0));
1305         _owner = address(0);
1306     }
1307 
1308     /**
1309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1310      * Can only be called by the current owner.
1311      */
1312     function transferOwnership(address newOwner) public onlyOwner {
1313         _transferOwnership(newOwner);
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      */
1319     function _transferOwnership(address newOwner) internal {
1320         require(newOwner != address(0), "Ownable: new owner is the zero address");
1321         emit OwnershipTransferred(_owner, newOwner);
1322         _owner = newOwner;
1323     }
1324 }
1325 
1326 // File: contracts/String.sol
1327 
1328 pragma solidity ^0.5.2;
1329 
1330 library String {
1331     function concat(string memory _a, string memory _b)
1332         internal
1333         pure
1334         returns (string memory)
1335     {
1336         bytes memory _aBytes = bytes(_a);
1337         bytes memory _bBytes = bytes(_b);
1338         bytes memory _result = new bytes(_aBytes.length + _bBytes.length);
1339         uint256 _k = 0;
1340         for (uint256 _i = 0; _i < _aBytes.length; _i++)
1341             _result[_k++] = _aBytes[_i];
1342         for (uint256 _i = 0; _i < _bBytes.length; _i++)
1343             _result[_k++] = _bBytes[_i];
1344         return string(_result);
1345     }
1346 
1347     function fromUint(uint256 _n) internal pure returns (string memory) {
1348         if (_n == 0) {
1349             return "0";
1350         }
1351         uint256 _len;
1352         for (uint256 _i = _n; _i != 0; _i /= 10) _len++;
1353         bytes memory _result = new bytes(_len);
1354         uint256 _k = _len - 1;
1355         while (_n != 0) {
1356             _result[_k--] = bytes1(uint8(48 + (_n % 10)));
1357             _n /= 10;
1358         }
1359         return string(_result);
1360     }
1361 
1362     function hash(string memory str) internal pure returns (uint256) {
1363         return uint256(keccak256(bytes(str)));
1364     }
1365 }
1366 
1367 // File: contracts/ERC721Tradable.sol
1368 
1369 pragma solidity ^0.5.2;
1370 
1371 
1372 
1373 
1374 contract OwnableDelegateProxy {}
1375 
1376 contract ProxyRegistry {
1377     mapping(address => OwnableDelegateProxy) public proxies;
1378 }
1379 
1380 /**
1381  * @title ERC721Tradable
1382  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1383  */
1384 contract ERC721Tradable is ERC721Full, Ownable {
1385     using String for string;
1386 
1387     address private proxyRegistryAddress;
1388 
1389     constructor(
1390         string memory _name,
1391         string memory _symbol,
1392         address _proxyRegistryAddress
1393     ) public ERC721Full(_name, _symbol) {
1394         proxyRegistryAddress = _proxyRegistryAddress;
1395     }
1396 
1397     function baseTokenURI() public pure returns (string memory) {
1398         return "";
1399     }
1400 
1401     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1402         return String.concat(baseTokenURI(), String.fromUint(_tokenId));
1403     }
1404 
1405     /**
1406      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1407      */
1408     function isApprovedForAll(address _owner, address _operator)
1409         public
1410         view
1411         returns (bool)
1412     {
1413         // Whitelist OpenSea proxy contract for easy trading.
1414         ProxyRegistry _proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1415         if (address(_proxyRegistry.proxies(_owner)) == _operator) {
1416             return true;
1417         }
1418         return super.isApprovedForAll(_owner, _operator);
1419     }
1420 }
1421 
1422 // File: contracts/Hashrunes.sol
1423 
1424 pragma solidity ^0.5.2;
1425 
1426 
1427 
1428 /**
1429  *
1430  * ██╗  ██╗ █████╗ ███████╗██╗  ██╗██████╗ ██╗   ██╗███╗   ██╗███████╗███████╗
1431  * ██║  ██║██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║████╗  ██║██╔════╝██╔════╝
1432  * ███████║███████║███████╗███████║██████╔╝██║   ██║██╔██╗ ██║█████╗  ███████╗
1433  * ██╔══██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝  ╚════██║
1434  * ██║  ██║██║  ██║███████║██║  ██║██║  ██║╚██████╔╝██║ ╚████║███████╗███████║
1435  * ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
1436  *
1437  * personalized generative art on the blockchain                  by Joshua Wu
1438  *
1439  *
1440  * Hashrunes are on-chain generative art created by you.
1441  * A Hashrune's design is based on its unique name. Anyone can mint a Hashrune by naming it and paying a fee.
1442  * The price to mint a Hashrune starts at 0.05 ETH. For each Hashrune minted, the price will increase by 1%.
1443  *
1444  * Functions specific to Hashrunes:
1445  *   `mint(string name)`: Mint a Hashrune.
1446  *   `getName(uint256 tokenId) -> string`: Look up the name corresponding to a token id.
1447  *   `getTokenId(string name) -> uint256`: Look up the token id corresponding to a name.
1448  *   `getRune(string name) -> string`: Get the design of a Hashrune.
1449  *   `getCharacters(string name) -> string`: Get the list of characters used for a Hashrune.
1450  *   `getColors(string name) -> uint256[]`: Get a Hashrune's RGB24 colors. Each color corresponds to each character in `getCharacters(name)`,
1451  *                                          with an extra color for the background at the end of the list.
1452  *
1453  */
1454 contract Hashrunes is ERC721Tradable {
1455     uint256 internal constant COLOR_SIZE = 24;
1456     uint256 internal constant ENTROPY_A =
1457         0x900428c2467a0c0d3a050ece653c11188d27fd971bbabc35d72c1d7387e4b9e7;
1458     uint256 internal constant ENTROPY_B =
1459         0xe9895d0dd732fb1e36d48703827f74a69f0e3a4eff4cd90812967b46516f35cf;
1460     uint256 internal constant PRICE_INCREASE_DENOMINATOR = 100;
1461     uint256 internal constant SIDE_LENGTH = 64;
1462     uint256 internal constant HALF_SIDE_LENGTH = SIDE_LENGTH / 2;
1463     uint256 internal constant RUNE_SIZE = SIDE_LENGTH * (3 * SIDE_LENGTH + 1);
1464     uint256 internal constant VALUE_SHIFT = 16;
1465 
1466     uint256 public price = 0.05 ether;
1467     mapping(string => uint256) private tokenIds;
1468     mapping(uint256 => string) private names;
1469     uint256 private supply = 0;
1470 
1471     constructor(address _proxyRegistryAddress)
1472         public
1473         ERC721Tradable("Hashrunes", "RUNE", _proxyRegistryAddress)
1474     {}
1475 
1476     function mint(string memory _name) public payable {
1477         require(tokenIds[_name] == 0, "Name is already taken.");
1478         require(bytes(_name).length > 0, "Name cannot be empty.");
1479         uint256 _currentPrice = price;
1480         price += price / PRICE_INCREASE_DENOMINATOR;
1481         require(price > _currentPrice);
1482         require(msg.value >= _currentPrice);
1483         address payable _wallet = address(uint160(owner()));
1484         _wallet.transfer(_currentPrice);
1485         _mint(_msgSender(), ++supply);
1486         tokenIds[_name] = supply;
1487         names[supply] = _name;
1488         if (msg.value > _currentPrice) {
1489             msg.sender.transfer(msg.value - _currentPrice);
1490         }
1491     }
1492 
1493     function getName(uint256 _tokenId) public view returns (string memory) {
1494         return names[_tokenId];
1495     }
1496 
1497     function getTokenId(string memory _name) public view returns (uint256) {
1498         return tokenIds[_name];
1499     }
1500 
1501     function _getCharacters(uint256 _seed)
1502         internal
1503         pure
1504         returns (string memory)
1505     {
1506         uint256 _themeSeed = _seed % 5;
1507         if (_themeSeed == 0) return "■▬▮▰▲▶▼◀◆●◖◗◢◣◤◥";
1508         if (_themeSeed == 1) return "■▬▮▰";
1509         if (_themeSeed == 2) return "▲▶▼◀";
1510         if (_themeSeed == 3) return "◆●◖◗";
1511         return "◢◣◤◥";
1512     }
1513 
1514     function getCharacters(string memory _name)
1515         public
1516         pure
1517         returns (string memory)
1518     {
1519         return _getCharacters(String.hash(_name));
1520     }
1521 
1522     function getColors(string memory _name)
1523         public
1524         pure
1525         returns (uint256[] memory)
1526     {
1527         uint256 _seed = String.hash(_name);
1528         bytes memory _characters = bytes(_getCharacters(_seed));
1529         uint256 _oddSeed = 2 * _seed + 1;
1530         uint256 _resultSize = _characters.length / 3 + 1;
1531         uint256[] memory _result = new uint256[](_resultSize);
1532         uint256 _i = 0;
1533         uint256 _colorSeed = (_oddSeed * ENTROPY_A) >> 1;
1534         if (_resultSize > 8) {
1535             while (_i < 8) {
1536                 _result[_i++] = _colorSeed & 0xffffff;
1537                 _colorSeed >>= COLOR_SIZE;
1538             }
1539             _colorSeed = (_oddSeed * ENTROPY_B) >> 1;
1540         }
1541         while (_i < _result.length) {
1542             _result[_i++] = _colorSeed & 0xffffff;
1543             _colorSeed >>= COLOR_SIZE;
1544         }
1545         return _result;
1546     }
1547 
1548     function getRune(string memory _name) public pure returns (string memory) {
1549         uint256 _seed = String.hash(_name);
1550         bytes memory _characters = bytes(_getCharacters(_seed));
1551         uint256 _charactersLength = _characters.length / 3;
1552         bytes memory _result = new bytes(RUNE_SIZE);
1553         uint256 _oddSeed = 2 * _seed + 1;
1554         uint256 _modulus =
1555             (_seed % (_charactersLength * ((_seed % 3) + 1))) +
1556                 _charactersLength;
1557         uint256 _index = 0;
1558         for (uint256 _y = 0; _y < SIDE_LENGTH; ++_y) {
1559             uint256 _b =
1560                 _y < HALF_SIDE_LENGTH ? 2 * (SIDE_LENGTH - _y) - 1 : 2 * _y + 1;
1561             for (uint256 _x = 0; _x < SIDE_LENGTH; ++_x) {
1562                 uint256 _a =
1563                     _x < HALF_SIDE_LENGTH
1564                         ? 2 * (SIDE_LENGTH - _x) - 1
1565                         : 2 * _x + 1;
1566                 uint256 _residue =
1567                     ((_a * _b * (_a + _b + 1) * _oddSeed * ENTROPY_A) >>
1568                         VALUE_SHIFT) % _modulus;
1569                 if (_residue < _charactersLength) {
1570                     _residue *= 3;
1571                     _result[_index++] = _characters[_residue];
1572                     _result[_index++] = _characters[_residue + 1];
1573                     _result[_index++] = _characters[_residue + 2];
1574                 } else {
1575                     _result[_index++] = " ";
1576                 }
1577             }
1578             _result[_index++] = "\n";
1579         }
1580         --_index;
1581         assembly {
1582             mstore(_result, _index)
1583         }
1584         return string(_result);
1585     }
1586 
1587     function contractURI() public pure returns (string memory) {
1588         return "https://api.hashrunes.com/v1/contract";
1589     }
1590 
1591     function baseTokenURI() public pure returns (string memory) {
1592         return "https://api.hashrunes.com/v1/runes/";
1593     }
1594 }