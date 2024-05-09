1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/GSN/Context.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with GSN meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 contract Context {
48     // Empty internal constructor, to prevent people from mistakenly deploying
49     // an instance of this contract, which should be used via inheritance.
50     constructor () internal { }
51     // solhint-disable-previous-line no-empty-blocks
52 
53     function _msgSender() internal view returns (address payable) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view returns (bytes memory) {
58         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
59         return msg.data;
60     }
61 }
62 
63 // File: @openzeppelin/contracts/introspection/IERC165.sol
64 
65 pragma solidity ^0.5.0;
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
88 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
89 
90 pragma solidity ^0.5.0;
91 
92 
93 /**
94  * @dev Required interface of an ERC721 compliant contract.
95  */
96 contract IERC721 is IERC165 {
97     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
98     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
99     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
100 
101     /**
102      * @dev Returns the number of NFTs in `owner`'s account.
103      */
104     function balanceOf(address owner) public view returns (uint256 balance);
105 
106     /**
107      * @dev Returns the owner of the NFT specified by `tokenId`.
108      */
109     function ownerOf(uint256 tokenId) public view returns (address owner);
110 
111     /**
112      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
113      * another (`to`).
114      *
115      *
116      *
117      * Requirements:
118      * - `from`, `to` cannot be zero.
119      * - `tokenId` must be owned by `from`.
120      * - If the caller is not `from`, it must be have been allowed to move this
121      * NFT by either {approve} or {setApprovalForAll}.
122      */
123     function safeTransferFrom(address from, address to, uint256 tokenId) public;
124     /**
125      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
126      * another (`to`).
127      *
128      * Requirements:
129      * - If the caller is not `from`, it must be approved to move this NFT by
130      * either {approve} or {setApprovalForAll}.
131      */
132     function transferFrom(address from, address to, uint256 tokenId) public;
133     function approve(address to, uint256 tokenId) public;
134     function getApproved(uint256 tokenId) public view returns (address operator);
135 
136     function setApprovalForAll(address operator, bool _approved) public;
137     function isApprovedForAll(address owner, address operator) public view returns (bool);
138 
139 
140     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
144 
145 pragma solidity ^0.5.0;
146 
147 /**
148  * @title ERC721 token receiver interface
149  * @dev Interface for any contract that wants to support safeTransfers
150  * from ERC721 asset contracts.
151  */
152 contract IERC721Receiver {
153     /**
154      * @notice Handle the receipt of an NFT
155      * @dev The ERC721 smart contract calls this function on the recipient
156      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
157      * otherwise the caller will revert the transaction. The selector to be
158      * returned can be obtained as `this.onERC721Received.selector`. This
159      * function MAY throw to revert and reject the transfer.
160      * Note: the ERC721 contract address is always the message sender.
161      * @param operator The address which called `safeTransferFrom` function
162      * @param from The address which previously owned the token
163      * @param tokenId The NFT identifier which is being transferred
164      * @param data Additional data with no specified format
165      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
166      */
167     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
168     public returns (bytes4);
169 }
170 
171 // File: @openzeppelin/contracts/math/SafeMath.sol
172 
173 pragma solidity ^0.5.0;
174 
175 /**
176  * @dev Wrappers over Solidity's arithmetic operations with added overflow
177  * checks.
178  *
179  * Arithmetic operations in Solidity wrap on overflow. This can easily result
180  * in bugs, because programmers usually assume that an overflow raises an
181  * error, which is the standard behavior in high level programming languages.
182  * `SafeMath` restores this intuition by reverting the transaction when an
183  * operation overflows.
184  *
185  * Using this library instead of the unchecked operations eliminates an entire
186  * class of bugs, so it's recommended to use it always.
187  */
188 library SafeMath {
189     /**
190      * @dev Returns the addition of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `+` operator.
194      *
195      * Requirements:
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, reverting on
207      * overflow (when the result is negative).
208      *
209      * Counterpart to Solidity's `-` operator.
210      *
211      * Requirements:
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return sub(a, b, "SafeMath: subtraction overflow");
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      * - Subtraction cannot overflow.
226      *
227      * _Available since v2.4.0._
228      */
229     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b <= a, errorMessage);
231         uint256 c = a - b;
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return div(a, b, "SafeMath: division by zero");
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      * - The divisor cannot be zero.
284      *
285      * _Available since v2.4.0._
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         // Solidity only automatically asserts when dividing by 0
289         require(b > 0, errorMessage);
290         uint256 c = a / b;
291         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * Reverts when dividing by zero.
299      *
300      * Counterpart to Solidity's `%` operator. This function uses a `revert`
301      * opcode (which leaves remaining gas untouched) while Solidity uses an
302      * invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return mod(a, b, "SafeMath: modulo by zero");
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts with custom message when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      * - The divisor cannot be zero.
321      *
322      * _Available since v2.4.0._
323      */
324     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b != 0, errorMessage);
326         return a % b;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 pragma solidity ^0.5.5;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following 
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      */
355     function isContract(address account) internal view returns (bool) {
356         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
357         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
358         // for accounts without code, i.e. `keccak256('')`
359         bytes32 codehash;
360         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
361         // solhint-disable-next-line no-inline-assembly
362         assembly { codehash := extcodehash(account) }
363         return (codehash != accountHash && codehash != 0x0);
364     }
365 
366     /**
367      * @dev Converts an `address` into `address payable`. Note that this is
368      * simply a type cast: the actual underlying value is not changed.
369      *
370      * _Available since v2.4.0._
371      */
372     function toPayable(address account) internal pure returns (address payable) {
373         return address(uint160(account));
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      *
392      * _Available since v2.4.0._
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         // solhint-disable-next-line avoid-call-value
398         (bool success, ) = recipient.call.value(amount)("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 }
402 
403 // File: @openzeppelin/contracts/drafts/Counters.sol
404 
405 pragma solidity ^0.5.0;
406 
407 
408 /**
409  * @title Counters
410  * @author Matt Condon (@shrugs)
411  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
412  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
413  *
414  * Include with `using Counters for Counters.Counter;`
415  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
416  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
417  * directly accessed.
418  */
419 library Counters {
420     using SafeMath for uint256;
421 
422     struct Counter {
423         // This variable should never be directly accessed by users of the library: interactions must be restricted to
424         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
425         // this feature: see https://github.com/ethereum/solidity/issues/4637
426         uint256 _value; // default: 0
427     }
428 
429     function current(Counter storage counter) internal view returns (uint256) {
430         return counter._value;
431     }
432 
433     function increment(Counter storage counter) internal {
434         // The {SafeMath} overflow check can be skipped here, see the comment at the top
435         counter._value += 1;
436     }
437 
438     function decrement(Counter storage counter) internal {
439         counter._value = counter._value.sub(1);
440     }
441 }
442 
443 // File: @openzeppelin/contracts/introspection/ERC165.sol
444 
445 pragma solidity ^0.5.0;
446 
447 
448 /**
449  * @dev Implementation of the {IERC165} interface.
450  *
451  * Contracts may inherit from this and call {_registerInterface} to declare
452  * their support of an interface.
453  */
454 contract ERC165 is IERC165 {
455     /*
456      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
457      */
458     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
459 
460     /**
461      * @dev Mapping of interface ids to whether or not it's supported.
462      */
463     mapping(bytes4 => bool) private _supportedInterfaces;
464 
465     constructor () internal {
466         // Derived contracts need only register support for their own interfaces,
467         // we register support for ERC165 itself here
468         _registerInterface(_INTERFACE_ID_ERC165);
469     }
470 
471     /**
472      * @dev See {IERC165-supportsInterface}.
473      *
474      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
475      */
476     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
477         return _supportedInterfaces[interfaceId];
478     }
479 
480     /**
481      * @dev Registers the contract as an implementer of the interface defined by
482      * `interfaceId`. Support of the actual ERC165 interface is automatic and
483      * registering its interface id is not required.
484      *
485      * See {IERC165-supportsInterface}.
486      *
487      * Requirements:
488      *
489      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
490      */
491     function _registerInterface(bytes4 interfaceId) internal {
492         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
493         _supportedInterfaces[interfaceId] = true;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
498 
499 pragma solidity ^0.5.0;
500 
501 
502 
503 
504 
505 
506 
507 
508 /**
509  * @title ERC721 Non-Fungible Token Standard basic implementation
510  * @dev see https://eips.ethereum.org/EIPS/eip-721
511  */
512 contract ERC721 is Context, ERC165, IERC721 {
513     using SafeMath for uint256;
514     using Address for address;
515     using Counters for Counters.Counter;
516 
517     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
518     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
519     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
520 
521     // Mapping from token ID to owner
522     mapping (uint256 => address) private _tokenOwner;
523 
524     // Mapping from token ID to approved address
525     mapping (uint256 => address) private _tokenApprovals;
526 
527     // Mapping from owner to number of owned token
528     mapping (address => Counters.Counter) private _ownedTokensCount;
529 
530     // Mapping from owner to operator approvals
531     mapping (address => mapping (address => bool)) private _operatorApprovals;
532 
533     /*
534      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
535      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
536      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
537      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
538      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
539      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
540      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
541      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
542      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
543      *
544      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
545      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
546      */
547     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
548 
549     constructor () public {
550         // register the supported interfaces to conform to ERC721 via ERC165
551         _registerInterface(_INTERFACE_ID_ERC721);
552     }
553 
554     /**
555      * @dev Gets the balance of the specified address.
556      * @param owner address to query the balance of
557      * @return uint256 representing the amount owned by the passed address
558      */
559     function balanceOf(address owner) public view returns (uint256) {
560         require(owner != address(0), "ERC721: balance query for the zero address");
561 
562         return _ownedTokensCount[owner].current();
563     }
564 
565     /**
566      * @dev Gets the owner of the specified token ID.
567      * @param tokenId uint256 ID of the token to query the owner of
568      * @return address currently marked as the owner of the given token ID
569      */
570     function ownerOf(uint256 tokenId) public view returns (address) {
571         address owner = _tokenOwner[tokenId];
572         require(owner != address(0), "ERC721: owner query for nonexistent token");
573 
574         return owner;
575     }
576 
577     /**
578      * @dev Approves another address to transfer the given token ID
579      * The zero address indicates there is no approved address.
580      * There can only be one approved address per token at a given time.
581      * Can only be called by the token owner or an approved operator.
582      * @param to address to be approved for the given token ID
583      * @param tokenId uint256 ID of the token to be approved
584      */
585     function approve(address to, uint256 tokenId) public {
586         address owner = ownerOf(tokenId);
587         require(to != owner, "ERC721: approval to current owner");
588 
589         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
590             "ERC721: approve caller is not owner nor approved for all"
591         );
592 
593         _tokenApprovals[tokenId] = to;
594         emit Approval(owner, to, tokenId);
595     }
596 
597     /**
598      * @dev Gets the approved address for a token ID, or zero if no address set
599      * Reverts if the token ID does not exist.
600      * @param tokenId uint256 ID of the token to query the approval of
601      * @return address currently approved for the given token ID
602      */
603     function getApproved(uint256 tokenId) public view returns (address) {
604         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
605 
606         return _tokenApprovals[tokenId];
607     }
608 
609     /**
610      * @dev Sets or unsets the approval of a given operator
611      * An operator is allowed to transfer all tokens of the sender on their behalf.
612      * @param to operator address to set the approval
613      * @param approved representing the status of the approval to be set
614      */
615     function setApprovalForAll(address to, bool approved) public {
616         require(to != _msgSender(), "ERC721: approve to caller");
617 
618         _operatorApprovals[_msgSender()][to] = approved;
619         emit ApprovalForAll(_msgSender(), to, approved);
620     }
621 
622     /**
623      * @dev Tells whether an operator is approved by a given owner.
624      * @param owner owner address which you want to query the approval of
625      * @param operator operator address which you want to query the approval of
626      * @return bool whether the given operator is approved by the given owner
627      */
628     function isApprovedForAll(address owner, address operator) public view returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev Transfers the ownership of a given token ID to another address.
634      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
635      * Requires the msg.sender to be the owner, approved, or operator.
636      * @param from current owner of the token
637      * @param to address to receive the ownership of the given token ID
638      * @param tokenId uint256 ID of the token to be transferred
639      */
640     function transferFrom(address from, address to, uint256 tokenId) public {
641         //solhint-disable-next-line max-line-length
642         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
643 
644         _transferFrom(from, to, tokenId);
645     }
646 
647     /**
648      * @dev Safely transfers the ownership of a given token ID to another address
649      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
650      * which is called upon a safe transfer, and return the magic value
651      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
652      * the transfer is reverted.
653      * Requires the msg.sender to be the owner, approved, or operator
654      * @param from current owner of the token
655      * @param to address to receive the ownership of the given token ID
656      * @param tokenId uint256 ID of the token to be transferred
657      */
658     function safeTransferFrom(address from, address to, uint256 tokenId) public {
659         safeTransferFrom(from, to, tokenId, "");
660     }
661 
662     /**
663      * @dev Safely transfers the ownership of a given token ID to another address
664      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
665      * which is called upon a safe transfer, and return the magic value
666      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
667      * the transfer is reverted.
668      * Requires the _msgSender() to be the owner, approved, or operator
669      * @param from current owner of the token
670      * @param to address to receive the ownership of the given token ID
671      * @param tokenId uint256 ID of the token to be transferred
672      * @param _data bytes data to send along with a safe transfer check
673      */
674     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
675         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
676         _safeTransferFrom(from, to, tokenId, _data);
677     }
678 
679     /**
680      * @dev Safely transfers the ownership of a given token ID to another address
681      * If the target address is a contract, it must implement `onERC721Received`,
682      * which is called upon a safe transfer, and return the magic value
683      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
684      * the transfer is reverted.
685      * Requires the msg.sender to be the owner, approved, or operator
686      * @param from current owner of the token
687      * @param to address to receive the ownership of the given token ID
688      * @param tokenId uint256 ID of the token to be transferred
689      * @param _data bytes data to send along with a safe transfer check
690      */
691     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
692         _transferFrom(from, to, tokenId);
693         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
694     }
695 
696     /**
697      * @dev Returns whether the specified token exists.
698      * @param tokenId uint256 ID of the token to query the existence of
699      * @return bool whether the token exists
700      */
701     function _exists(uint256 tokenId) internal view returns (bool) {
702         address owner = _tokenOwner[tokenId];
703         return owner != address(0);
704     }
705 
706     /**
707      * @dev Returns whether the given spender can transfer a given token ID.
708      * @param spender address of the spender to query
709      * @param tokenId uint256 ID of the token to be transferred
710      * @return bool whether the msg.sender is approved for the given token ID,
711      * is an operator of the owner, or is the owner of the token
712      */
713     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
714         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
715         address owner = ownerOf(tokenId);
716         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
717     }
718 
719     /**
720      * @dev Internal function to safely mint a new token.
721      * Reverts if the given token ID already exists.
722      * If the target address is a contract, it must implement `onERC721Received`,
723      * which is called upon a safe transfer, and return the magic value
724      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
725      * the transfer is reverted.
726      * @param to The address that will own the minted token
727      * @param tokenId uint256 ID of the token to be minted
728      */
729     function _safeMint(address to, uint256 tokenId) internal {
730         _safeMint(to, tokenId, "");
731     }
732 
733     /**
734      * @dev Internal function to safely mint a new token.
735      * Reverts if the given token ID already exists.
736      * If the target address is a contract, it must implement `onERC721Received`,
737      * which is called upon a safe transfer, and return the magic value
738      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
739      * the transfer is reverted.
740      * @param to The address that will own the minted token
741      * @param tokenId uint256 ID of the token to be minted
742      * @param _data bytes data to send along with a safe transfer check
743      */
744     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
745         _mint(to, tokenId);
746         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
747     }
748 
749     /**
750      * @dev Internal function to mint a new token.
751      * Reverts if the given token ID already exists.
752      * @param to The address that will own the minted token
753      * @param tokenId uint256 ID of the token to be minted
754      */
755     function _mint(address to, uint256 tokenId) internal {
756         require(to != address(0), "ERC721: mint to the zero address");
757         require(!_exists(tokenId), "ERC721: token already minted");
758 
759         _tokenOwner[tokenId] = to;
760         _ownedTokensCount[to].increment();
761 
762         emit Transfer(address(0), to, tokenId);
763     }
764 
765     /**
766      * @dev Internal function to burn a specific token.
767      * Reverts if the token does not exist.
768      * Deprecated, use {_burn} instead.
769      * @param owner owner of the token to burn
770      * @param tokenId uint256 ID of the token being burned
771      */
772     function _burn(address owner, uint256 tokenId) internal {
773         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
774 
775         _clearApproval(tokenId);
776 
777         _ownedTokensCount[owner].decrement();
778         _tokenOwner[tokenId] = address(0);
779 
780         emit Transfer(owner, address(0), tokenId);
781     }
782 
783     /**
784      * @dev Internal function to burn a specific token.
785      * Reverts if the token does not exist.
786      * @param tokenId uint256 ID of the token being burned
787      */
788     function _burn(uint256 tokenId) internal {
789         _burn(ownerOf(tokenId), tokenId);
790     }
791 
792     /**
793      * @dev Internal function to transfer ownership of a given token ID to another address.
794      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
795      * @param from current owner of the token
796      * @param to address to receive the ownership of the given token ID
797      * @param tokenId uint256 ID of the token to be transferred
798      */
799     function _transferFrom(address from, address to, uint256 tokenId) internal {
800         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
801         require(to != address(0), "ERC721: transfer to the zero address");
802 
803         _clearApproval(tokenId);
804 
805         _ownedTokensCount[from].decrement();
806         _ownedTokensCount[to].increment();
807 
808         _tokenOwner[tokenId] = to;
809 
810         emit Transfer(from, to, tokenId);
811     }
812 
813     /**
814      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
815      * The call is not executed if the target address is not a contract.
816      *
817      * This is an internal detail of the `ERC721` contract and its use is deprecated.
818      * @param from address representing the previous owner of the given token ID
819      * @param to target address that will receive the tokens
820      * @param tokenId uint256 ID of the token to be transferred
821      * @param _data bytes optional data to send along with the call
822      * @return bool whether the call correctly returned the expected magic value
823      */
824     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
825         internal returns (bool)
826     {
827         if (!to.isContract()) {
828             return true;
829         }
830         // solhint-disable-next-line avoid-low-level-calls
831         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
832             IERC721Receiver(to).onERC721Received.selector,
833             _msgSender(),
834             from,
835             tokenId,
836             _data
837         ));
838         if (!success) {
839             if (returndata.length > 0) {
840                 // solhint-disable-next-line no-inline-assembly
841                 assembly {
842                     let returndata_size := mload(returndata)
843                     revert(add(32, returndata), returndata_size)
844                 }
845             } else {
846                 revert("ERC721: transfer to non ERC721Receiver implementer");
847             }
848         } else {
849             bytes4 retval = abi.decode(returndata, (bytes4));
850             return (retval == _ERC721_RECEIVED);
851         }
852     }
853 
854     /**
855      * @dev Private function to clear current approval of a given token ID.
856      * @param tokenId uint256 ID of the token to be transferred
857      */
858     function _clearApproval(uint256 tokenId) private {
859         if (_tokenApprovals[tokenId] != address(0)) {
860             _tokenApprovals[tokenId] = address(0);
861         }
862     }
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
866 
867 pragma solidity ^0.5.0;
868 
869 
870 /**
871  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
872  * @dev See https://eips.ethereum.org/EIPS/eip-721
873  */
874 contract IERC721Enumerable is IERC721 {
875     function totalSupply() public view returns (uint256);
876     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
877 
878     function tokenByIndex(uint256 index) public view returns (uint256);
879 }
880 
881 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
882 
883 pragma solidity ^0.5.0;
884 
885 
886 
887 
888 
889 /**
890  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
891  * @dev See https://eips.ethereum.org/EIPS/eip-721
892  */
893 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
894     // Mapping from owner to list of owned token IDs
895     mapping(address => uint256[]) private _ownedTokens;
896 
897     // Mapping from token ID to index of the owner tokens list
898     mapping(uint256 => uint256) private _ownedTokensIndex;
899 
900     // Array with all token ids, used for enumeration
901     uint256[] private _allTokens;
902 
903     // Mapping from token id to position in the allTokens array
904     mapping(uint256 => uint256) private _allTokensIndex;
905 
906     /*
907      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
908      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
909      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
910      *
911      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
912      */
913     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
914 
915     /**
916      * @dev Constructor function.
917      */
918     constructor () public {
919         // register the supported interface to conform to ERC721Enumerable via ERC165
920         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
921     }
922 
923     /**
924      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
925      * @param owner address owning the tokens list to be accessed
926      * @param index uint256 representing the index to be accessed of the requested tokens list
927      * @return uint256 token ID at the given index of the tokens list owned by the requested address
928      */
929     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
930         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
931         return _ownedTokens[owner][index];
932     }
933 
934     /**
935      * @dev Gets the total amount of tokens stored by the contract.
936      * @return uint256 representing the total amount of tokens
937      */
938     function totalSupply() public view returns (uint256) {
939         return _allTokens.length;
940     }
941 
942     /**
943      * @dev Gets the token ID at a given index of all the tokens in this contract
944      * Reverts if the index is greater or equal to the total number of tokens.
945      * @param index uint256 representing the index to be accessed of the tokens list
946      * @return uint256 token ID at the given index of the tokens list
947      */
948     function tokenByIndex(uint256 index) public view returns (uint256) {
949         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
950         return _allTokens[index];
951     }
952 
953     /**
954      * @dev Internal function to transfer ownership of a given token ID to another address.
955      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
956      * @param from current owner of the token
957      * @param to address to receive the ownership of the given token ID
958      * @param tokenId uint256 ID of the token to be transferred
959      */
960     function _transferFrom(address from, address to, uint256 tokenId) internal {
961         super._transferFrom(from, to, tokenId);
962 
963         _removeTokenFromOwnerEnumeration(from, tokenId);
964 
965         _addTokenToOwnerEnumeration(to, tokenId);
966     }
967 
968     /**
969      * @dev Internal function to mint a new token.
970      * Reverts if the given token ID already exists.
971      * @param to address the beneficiary that will own the minted token
972      * @param tokenId uint256 ID of the token to be minted
973      */
974     function _mint(address to, uint256 tokenId) internal {
975         super._mint(to, tokenId);
976 
977         _addTokenToOwnerEnumeration(to, tokenId);
978 
979         _addTokenToAllTokensEnumeration(tokenId);
980     }
981 
982     /**
983      * @dev Internal function to burn a specific token.
984      * Reverts if the token does not exist.
985      * Deprecated, use {ERC721-_burn} instead.
986      * @param owner owner of the token to burn
987      * @param tokenId uint256 ID of the token being burned
988      */
989     function _burn(address owner, uint256 tokenId) internal {
990         super._burn(owner, tokenId);
991 
992         _removeTokenFromOwnerEnumeration(owner, tokenId);
993         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
994         _ownedTokensIndex[tokenId] = 0;
995 
996         _removeTokenFromAllTokensEnumeration(tokenId);
997     }
998 
999     /**
1000      * @dev Gets the list of token IDs of the requested owner.
1001      * @param owner address owning the tokens
1002      * @return uint256[] List of token IDs owned by the requested address
1003      */
1004     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1005         return _ownedTokens[owner];
1006     }
1007 
1008     /**
1009      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1010      * @param to address representing the new owner of the given token ID
1011      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1012      */
1013     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1014         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1015         _ownedTokens[to].push(tokenId);
1016     }
1017 
1018     /**
1019      * @dev Private function to add a token to this extension's token tracking data structures.
1020      * @param tokenId uint256 ID of the token to be added to the tokens list
1021      */
1022     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1023         _allTokensIndex[tokenId] = _allTokens.length;
1024         _allTokens.push(tokenId);
1025     }
1026 
1027     /**
1028      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1029      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1030      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1031      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1032      * @param from address representing the previous owner of the given token ID
1033      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1034      */
1035     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1036         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1037         // then delete the last slot (swap and pop).
1038 
1039         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1040         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1041 
1042         // When the token to delete is the last token, the swap operation is unnecessary
1043         if (tokenIndex != lastTokenIndex) {
1044             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1045 
1046             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1047             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1048         }
1049 
1050         // This also deletes the contents at the last position of the array
1051         _ownedTokens[from].length--;
1052 
1053         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1054         // lastTokenId, or just over the end of the array if the token was the last one).
1055     }
1056 
1057     /**
1058      * @dev Private function to remove a token from this extension's token tracking data structures.
1059      * This has O(1) time complexity, but alters the order of the _allTokens array.
1060      * @param tokenId uint256 ID of the token to be removed from the tokens list
1061      */
1062     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1063         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1064         // then delete the last slot (swap and pop).
1065 
1066         uint256 lastTokenIndex = _allTokens.length.sub(1);
1067         uint256 tokenIndex = _allTokensIndex[tokenId];
1068 
1069         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1070         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1071         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1072         uint256 lastTokenId = _allTokens[lastTokenIndex];
1073 
1074         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1075         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1076 
1077         // This also deletes the contents at the last position of the array
1078         _allTokens.length--;
1079         _allTokensIndex[tokenId] = 0;
1080     }
1081 }
1082 
1083 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
1084 
1085 pragma solidity ^0.5.0;
1086 
1087 
1088 /**
1089  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1090  * @dev See https://eips.ethereum.org/EIPS/eip-721
1091  */
1092 contract IERC721Metadata is IERC721 {
1093     function name() external view returns (string memory);
1094     function symbol() external view returns (string memory);
1095     function tokenURI(uint256 tokenId) external view returns (string memory);
1096 }
1097 
1098 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
1099 
1100 pragma solidity ^0.5.0;
1101 
1102 
1103 
1104 
1105 
1106 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1107     // Token name
1108     string private _name;
1109 
1110     // Token symbol
1111     string private _symbol;
1112 
1113     // Base URI
1114     string private _baseURI;
1115 
1116     // Optional mapping for token URIs
1117     mapping(uint256 => string) private _tokenURIs;
1118 
1119     /*
1120      *     bytes4(keccak256('name()')) == 0x06fdde03
1121      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1122      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1123      *
1124      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1125      */
1126     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1127 
1128     /**
1129      * @dev Constructor function
1130      */
1131     constructor (string memory name, string memory symbol) public {
1132         _name = name;
1133         _symbol = symbol;
1134 
1135         // register the supported interfaces to conform to ERC721 via ERC165
1136         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1137     }
1138 
1139     /**
1140      * @dev Gets the token name.
1141      * @return string representing the token name
1142      */
1143     function name() external view returns (string memory) {
1144         return _name;
1145     }
1146 
1147     /**
1148      * @dev Gets the token symbol.
1149      * @return string representing the token symbol
1150      */
1151     function symbol() external view returns (string memory) {
1152         return _symbol;
1153     }
1154 
1155     /**
1156      * @dev Returns the URI for a given token ID. May return an empty string.
1157      *
1158      * If the token's URI is non-empty and a base URI was set (via
1159      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1160      *
1161      * Reverts if the token ID does not exist.
1162      */
1163     function tokenURI(uint256 tokenId) external view returns (string memory) {
1164         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1165 
1166         string memory _tokenURI = _tokenURIs[tokenId];
1167 
1168         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1169         if (bytes(_tokenURI).length == 0) {
1170             return "";
1171         } else {
1172             // abi.encodePacked is being used to concatenate strings
1173             return string(abi.encodePacked(_baseURI, _tokenURI));
1174         }
1175     }
1176 
1177     /**
1178      * @dev Internal function to set the token URI for a given token.
1179      *
1180      * Reverts if the token ID does not exist.
1181      *
1182      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1183      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1184      * it and save gas.
1185      */
1186     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1187         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1188         _tokenURIs[tokenId] = _tokenURI;
1189     }
1190 
1191     /**
1192      * @dev Internal function to set the base URI for all token IDs. It is
1193      * automatically added as a prefix to the value returned in {tokenURI}.
1194      *
1195      * _Available since v2.5.0._
1196      */
1197     function _setBaseURI(string memory baseURI) internal {
1198         _baseURI = baseURI;
1199     }
1200 
1201     /**
1202     * @dev Returns the base URI set via {_setBaseURI}. This will be
1203     * automatically added as a preffix in {tokenURI} to each token's URI, when
1204     * they are non-empty.
1205     *
1206     * _Available since v2.5.0._
1207     */
1208     function baseURI() external view returns (string memory) {
1209         return _baseURI;
1210     }
1211 
1212     /**
1213      * @dev Internal function to burn a specific token.
1214      * Reverts if the token does not exist.
1215      * Deprecated, use _burn(uint256) instead.
1216      * @param owner owner of the token to burn
1217      * @param tokenId uint256 ID of the token being burned by the msg.sender
1218      */
1219     function _burn(address owner, uint256 tokenId) internal {
1220         super._burn(owner, tokenId);
1221 
1222         // Clear metadata (if any)
1223         if (bytes(_tokenURIs[tokenId]).length != 0) {
1224             delete _tokenURIs[tokenId];
1225         }
1226     }
1227 }
1228 
1229 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1230 
1231 pragma solidity ^0.5.0;
1232 
1233 
1234 
1235 
1236 /**
1237  * @title Full ERC721 Token
1238  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1239  * Moreover, it includes approve all functionality using operator terminology.
1240  *
1241  * See https://eips.ethereum.org/EIPS/eip-721
1242  */
1243 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1244     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1245         // solhint-disable-previous-line no-empty-blocks
1246     }
1247 }
1248 
1249 // File: contracts/library/Governance.sol
1250 
1251 pragma solidity ^0.5.0;
1252 
1253 contract Governance {
1254 
1255     address public _governance;
1256 
1257     constructor() public {
1258         _governance = tx.origin;
1259     }
1260 
1261     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     modifier onlyGovernance {
1264         require(msg.sender == _governance, "not governance");
1265         _;
1266     }
1267 
1268     function setGovernance(address governance)  public  onlyGovernance
1269     {
1270         require(governance != address(0), "new governance the zero address");
1271         emit GovernanceTransferred(_governance, governance);
1272         _governance = governance;
1273     }
1274 
1275 
1276 }
1277 
1278 // File: contracts/library/DegoUtil.sol
1279 
1280 pragma solidity ^0.5.0;
1281 
1282 
1283 library DegoUtil {
1284     function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
1285         if (_i == 0) {
1286             return "0";
1287         }
1288         uint j = _i;
1289         uint len;
1290         while (j != 0) {
1291             len++;
1292             j /= 10;
1293         }
1294         bytes memory bstr = new bytes(len);
1295         uint k = len - 1;
1296         while (_i != 0) {
1297             bstr[k--] = byte(uint8(48 + _i % 10));
1298             _i /= 10;
1299         }
1300         return string(bstr);
1301     }
1302 }
1303 
1304 // File: contracts/nft/GegoToken.sol
1305 
1306 pragma solidity ^0.5.5;
1307 
1308 
1309 
1310 
1311 contract GegoToken is ERC721Full, Governance {
1312     // for minters
1313     mapping(address => bool) public _minters;
1314 
1315 
1316 
1317     constructor() public ERC721Full("gego.dego", "GEGO") {
1318         _setBaseURI("https://api.dego.finance/gego-token/");
1319     }
1320 
1321 
1322     function setURIPrefix(string memory baseURI) internal {
1323         _setBaseURI(baseURI);
1324     }
1325 
1326 
1327     /**
1328      * @dev Function to mint tokens.
1329      * @param to The address that will receive the minted token.
1330      * @param tokenId The token id to mint.
1331      * @return A boolean that indicates if the operation was successful.
1332      */
1333     function mint(address to, uint256 tokenId) external returns (bool) {
1334         require(_minters[msg.sender], "!minter");
1335         _mint(to, tokenId);
1336         _setTokenURI(tokenId, DegoUtil.uintToString(tokenId));
1337         return true;
1338     }
1339 
1340     /**
1341      * @dev Function to safely mint tokens.
1342      * @param to The address that will receive the minted token.
1343      * @param tokenId The token id to mint.
1344      * @return A boolean that indicates if the operation was successful.
1345      */
1346     function safeMint(address to, uint256 tokenId) public returns (bool) {
1347         require(_minters[msg.sender], "!minter");
1348         _safeMint(to, tokenId);
1349         _setTokenURI(tokenId, DegoUtil.uintToString(tokenId));
1350         return true;
1351     }
1352 
1353     /**
1354      * @dev Function to safely mint tokens.
1355      * @param to The address that will receive the minted token.
1356      * @param tokenId The token id to mint.
1357      * @param _data bytes data to send along with a safe transfer check.
1358      * @return A boolean that indicates if the operation was successful.
1359      */
1360     function safeMint(
1361         address to,
1362         uint256 tokenId,
1363         bytes memory _data
1364     ) public returns (bool) {
1365         _safeMint(to, tokenId, _data);
1366         _setTokenURI(tokenId, DegoUtil.uintToString(tokenId));
1367         return true;
1368     }
1369 
1370     function addMinter(address minter) public onlyGovernance {
1371         _minters[minter] = true;
1372     }
1373 
1374     function removeMinter(address minter) public onlyGovernance {
1375         _minters[minter] = false;
1376     }
1377 
1378     /**
1379      * @dev Burns a specific ERC721 token.
1380      * @param tokenId uint256 id of the ERC721 token to be burned.
1381      */
1382     function burn(uint256 tokenId) external {
1383         //solhint-disable-next-line max-line-length
1384         require(_minters[msg.sender], "!minter");
1385         require(
1386             _isApprovedOrOwner(_msgSender(), tokenId),
1387             "caller is not owner nor approved"
1388         );
1389         _burn(tokenId);
1390     }
1391 
1392 
1393     /**
1394      * @dev Gets the list of token IDs of the requested owner.
1395      * @param owner address owning the tokens
1396      * @return uint256[] List of token IDs owned by the requested address
1397      */
1398     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1399         return _tokensOfOwner(owner);
1400     }
1401 
1402 
1403 }
