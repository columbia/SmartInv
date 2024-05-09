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
33 // File: @openzeppelin/contracts/math/Math.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Standard math utilities missing in the Solidity language.
39  */
40 library Math {
41     /**
42      * @dev Returns the largest of two numbers.
43      */
44     function max(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a >= b ? a : b;
46     }
47 
48     /**
49      * @dev Returns the smallest of two numbers.
50      */
51     function min(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the average of two numbers. The result is rounded towards
57      * zero.
58      */
59     function average(uint256 a, uint256 b) internal pure returns (uint256) {
60         // (a + b) / 2 can overflow, so we distribute
61         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
62     }
63 }
64 
65 // File: @openzeppelin/contracts/math/SafeMath.sol
66 
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @dev Wrappers over Solidity's arithmetic operations with added overflow
71  * checks.
72  *
73  * Arithmetic operations in Solidity wrap on overflow. This can easily result
74  * in bugs, because programmers usually assume that an overflow raises an
75  * error, which is the standard behavior in high level programming languages.
76  * `SafeMath` restores this intuition by reverting the transaction when an
77  * operation overflows.
78  *
79  * Using this library instead of the unchecked operations eliminates an entire
80  * class of bugs, so it's recommended to use it always.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      *
121      * _Available since v2.4.0._
122      */
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         // Solidity only automatically asserts when dividing by 0
183         require(b > 0, errorMessage);
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         return mod(a, b, "SafeMath: modulo by zero");
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts with custom message when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b != 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/GSN/Context.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /*
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with GSN meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 contract Context {
239     // Empty internal constructor, to prevent people from mistakenly deploying
240     // an instance of this contract, which should be used via inheritance.
241     constructor () internal { }
242     // solhint-disable-previous-line no-empty-blocks
243 
244     function _msgSender() internal view returns (address payable) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view returns (bytes memory) {
249         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/ownership/Ownable.sol
255 
256 pragma solidity ^0.5.0;
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         address msgSender = _msgSender();
277         _owner = msgSender;
278         emit OwnershipTransferred(address(0), msgSender);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Returns true if the caller is the current owner.
298      */
299     function isOwner() public view returns (bool) {
300         return _msgSender() == _owner;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      */
326     function _transferOwnership(address newOwner) internal {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/introspection/IERC165.sol
334 
335 pragma solidity ^0.5.0;
336 
337 /**
338  * @dev Interface of the ERC165 standard, as defined in the
339  * https://eips.ethereum.org/EIPS/eip-165[EIP].
340  *
341  * Implementers can declare support of contract interfaces, which can then be
342  * queried by others ({ERC165Checker}).
343  *
344  * For an implementation, see {ERC165}.
345  */
346 interface IERC165 {
347     /**
348      * @dev Returns true if this contract implements the interface defined by
349      * `interfaceId`. See the corresponding
350      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
351      * to learn more about how these ids are created.
352      *
353      * This function call must use less than 30 000 gas.
354      */
355     function supportsInterface(bytes4 interfaceId) external view returns (bool);
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
359 
360 pragma solidity ^0.5.0;
361 
362 
363 /**
364  * @dev Required interface of an ERC721 compliant contract.
365  */
366 contract IERC721 is IERC165 {
367     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
368     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of NFTs in `owner`'s account.
373      */
374     function balanceOf(address owner) public view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the NFT specified by `tokenId`.
378      */
379     function ownerOf(uint256 tokenId) public view returns (address owner);
380 
381     /**
382      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
383      * another (`to`).
384      *
385      *
386      *
387      * Requirements:
388      * - `from`, `to` cannot be zero.
389      * - `tokenId` must be owned by `from`.
390      * - If the caller is not `from`, it must be have been allowed to move this
391      * NFT by either {approve} or {setApprovalForAll}.
392      */
393     function safeTransferFrom(address from, address to, uint256 tokenId) public;
394     /**
395      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
396      * another (`to`).
397      *
398      * Requirements:
399      * - If the caller is not `from`, it must be approved to move this NFT by
400      * either {approve} or {setApprovalForAll}.
401      */
402     function transferFrom(address from, address to, uint256 tokenId) public;
403     function approve(address to, uint256 tokenId) public;
404     function getApproved(uint256 tokenId) public view returns (address operator);
405 
406     function setApprovalForAll(address operator, bool _approved) public;
407     function isApprovedForAll(address owner, address operator) public view returns (bool);
408 
409 
410     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
414 
415 pragma solidity ^0.5.0;
416 
417 
418 /**
419  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
420  * @dev See https://eips.ethereum.org/EIPS/eip-721
421  */
422 contract IERC721Enumerable is IERC721 {
423     function totalSupply() public view returns (uint256);
424     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
425 
426     function tokenByIndex(uint256 index) public view returns (uint256);
427 }
428 
429 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
430 
431 pragma solidity ^0.5.0;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 contract IERC721Receiver {
439     /**
440      * @notice Handle the receipt of an NFT
441      * @dev The ERC721 smart contract calls this function on the recipient
442      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
443      * otherwise the caller will revert the transaction. The selector to be
444      * returned can be obtained as `this.onERC721Received.selector`. This
445      * function MAY throw to revert and reject the transfer.
446      * Note: the ERC721 contract address is always the message sender.
447      * @param operator The address which called `safeTransferFrom` function
448      * @param from The address which previously owned the token
449      * @param tokenId The NFT identifier which is being transferred
450      * @param data Additional data with no specified format
451      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
452      */
453     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
454     public returns (bytes4);
455 }
456 
457 // File: @openzeppelin/contracts/utils/Address.sol
458 
459 pragma solidity ^0.5.5;
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following 
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
484         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
485         // for accounts without code, i.e. `keccak256('')`
486         bytes32 codehash;
487         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
488         // solhint-disable-next-line no-inline-assembly
489         assembly { codehash := extcodehash(account) }
490         return (codehash != accountHash && codehash != 0x0);
491     }
492 
493     /**
494      * @dev Converts an `address` into `address payable`. Note that this is
495      * simply a type cast: the actual underlying value is not changed.
496      *
497      * _Available since v2.4.0._
498      */
499     function toPayable(address account) internal pure returns (address payable) {
500         return address(uint160(account));
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      *
519      * _Available since v2.4.0._
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-call-value
525         (bool success, ) = recipient.call.value(amount)("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 }
529 
530 // File: @openzeppelin/contracts/drafts/Counters.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 /**
536  * @title Counters
537  * @author Matt Condon (@shrugs)
538  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
539  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
540  *
541  * Include with `using Counters for Counters.Counter;`
542  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
543  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
544  * directly accessed.
545  */
546 library Counters {
547     using SafeMath for uint256;
548 
549     struct Counter {
550         // This variable should never be directly accessed by users of the library: interactions must be restricted to
551         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
552         // this feature: see https://github.com/ethereum/solidity/issues/4637
553         uint256 _value; // default: 0
554     }
555 
556     function current(Counter storage counter) internal view returns (uint256) {
557         return counter._value;
558     }
559 
560     function increment(Counter storage counter) internal {
561         // The {SafeMath} overflow check can be skipped here, see the comment at the top
562         counter._value += 1;
563     }
564 
565     function decrement(Counter storage counter) internal {
566         counter._value = counter._value.sub(1);
567     }
568 }
569 
570 // File: @openzeppelin/contracts/introspection/ERC165.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts may inherit from this and call {_registerInterface} to declare
579  * their support of an interface.
580  */
581 contract ERC165 is IERC165 {
582     /*
583      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
584      */
585     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
586 
587     /**
588      * @dev Mapping of interface ids to whether or not it's supported.
589      */
590     mapping(bytes4 => bool) private _supportedInterfaces;
591 
592     constructor () internal {
593         // Derived contracts need only register support for their own interfaces,
594         // we register support for ERC165 itself here
595         _registerInterface(_INTERFACE_ID_ERC165);
596     }
597 
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      *
601      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
604         return _supportedInterfaces[interfaceId];
605     }
606 
607     /**
608      * @dev Registers the contract as an implementer of the interface defined by
609      * `interfaceId`. Support of the actual ERC165 interface is automatic and
610      * registering its interface id is not required.
611      *
612      * See {IERC165-supportsInterface}.
613      *
614      * Requirements:
615      *
616      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
617      */
618     function _registerInterface(bytes4 interfaceId) internal {
619         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
620         _supportedInterfaces[interfaceId] = true;
621     }
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
625 
626 pragma solidity ^0.5.0;
627 
628 
629 
630 
631 
632 
633 
634 
635 /**
636  * @title ERC721 Non-Fungible Token Standard basic implementation
637  * @dev see https://eips.ethereum.org/EIPS/eip-721
638  */
639 contract ERC721 is Context, ERC165, IERC721 {
640     using SafeMath for uint256;
641     using Address for address;
642     using Counters for Counters.Counter;
643 
644     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
645     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
646     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
647 
648     // Mapping from token ID to owner
649     mapping (uint256 => address) private _tokenOwner;
650 
651     // Mapping from token ID to approved address
652     mapping (uint256 => address) private _tokenApprovals;
653 
654     // Mapping from owner to number of owned token
655     mapping (address => Counters.Counter) private _ownedTokensCount;
656 
657     // Mapping from owner to operator approvals
658     mapping (address => mapping (address => bool)) private _operatorApprovals;
659 
660     /*
661      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
662      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
663      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
664      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
665      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
666      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
667      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
668      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
669      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
670      *
671      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
672      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
673      */
674     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
675 
676     constructor () public {
677         // register the supported interfaces to conform to ERC721 via ERC165
678         _registerInterface(_INTERFACE_ID_ERC721);
679     }
680 
681     /**
682      * @dev Gets the balance of the specified address.
683      * @param owner address to query the balance of
684      * @return uint256 representing the amount owned by the passed address
685      */
686     function balanceOf(address owner) public view returns (uint256) {
687         require(owner != address(0), "ERC721: balance query for the zero address");
688 
689         return _ownedTokensCount[owner].current();
690     }
691 
692     /**
693      * @dev Gets the owner of the specified token ID.
694      * @param tokenId uint256 ID of the token to query the owner of
695      * @return address currently marked as the owner of the given token ID
696      */
697     function ownerOf(uint256 tokenId) public view returns (address) {
698         address owner = _tokenOwner[tokenId];
699         require(owner != address(0), "ERC721: owner query for nonexistent token");
700 
701         return owner;
702     }
703 
704     /**
705      * @dev Approves another address to transfer the given token ID
706      * The zero address indicates there is no approved address.
707      * There can only be one approved address per token at a given time.
708      * Can only be called by the token owner or an approved operator.
709      * @param to address to be approved for the given token ID
710      * @param tokenId uint256 ID of the token to be approved
711      */
712     function approve(address to, uint256 tokenId) public {
713         address owner = ownerOf(tokenId);
714         require(to != owner, "ERC721: approval to current owner");
715 
716         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
717             "ERC721: approve caller is not owner nor approved for all"
718         );
719 
720         _tokenApprovals[tokenId] = to;
721         emit Approval(owner, to, tokenId);
722     }
723 
724     /**
725      * @dev Gets the approved address for a token ID, or zero if no address set
726      * Reverts if the token ID does not exist.
727      * @param tokenId uint256 ID of the token to query the approval of
728      * @return address currently approved for the given token ID
729      */
730     function getApproved(uint256 tokenId) public view returns (address) {
731         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
732 
733         return _tokenApprovals[tokenId];
734     }
735 
736     /**
737      * @dev Sets or unsets the approval of a given operator
738      * An operator is allowed to transfer all tokens of the sender on their behalf.
739      * @param to operator address to set the approval
740      * @param approved representing the status of the approval to be set
741      */
742     function setApprovalForAll(address to, bool approved) public {
743         require(to != _msgSender(), "ERC721: approve to caller");
744 
745         _operatorApprovals[_msgSender()][to] = approved;
746         emit ApprovalForAll(_msgSender(), to, approved);
747     }
748 
749     /**
750      * @dev Tells whether an operator is approved by a given owner.
751      * @param owner owner address which you want to query the approval of
752      * @param operator operator address which you want to query the approval of
753      * @return bool whether the given operator is approved by the given owner
754      */
755     function isApprovedForAll(address owner, address operator) public view returns (bool) {
756         return _operatorApprovals[owner][operator];
757     }
758 
759     /**
760      * @dev Transfers the ownership of a given token ID to another address.
761      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
762      * Requires the msg.sender to be the owner, approved, or operator.
763      * @param from current owner of the token
764      * @param to address to receive the ownership of the given token ID
765      * @param tokenId uint256 ID of the token to be transferred
766      */
767     function transferFrom(address from, address to, uint256 tokenId) public {
768         //solhint-disable-next-line max-line-length
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770 
771         _transferFrom(from, to, tokenId);
772     }
773 
774     /**
775      * @dev Safely transfers the ownership of a given token ID to another address
776      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
777      * which is called upon a safe transfer, and return the magic value
778      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
779      * the transfer is reverted.
780      * Requires the msg.sender to be the owner, approved, or operator
781      * @param from current owner of the token
782      * @param to address to receive the ownership of the given token ID
783      * @param tokenId uint256 ID of the token to be transferred
784      */
785     function safeTransferFrom(address from, address to, uint256 tokenId) public {
786         safeTransferFrom(from, to, tokenId, "");
787     }
788 
789     /**
790      * @dev Safely transfers the ownership of a given token ID to another address
791      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
792      * which is called upon a safe transfer, and return the magic value
793      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
794      * the transfer is reverted.
795      * Requires the _msgSender() to be the owner, approved, or operator
796      * @param from current owner of the token
797      * @param to address to receive the ownership of the given token ID
798      * @param tokenId uint256 ID of the token to be transferred
799      * @param _data bytes data to send along with a safe transfer check
800      */
801     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803         _safeTransferFrom(from, to, tokenId, _data);
804     }
805 
806     /**
807      * @dev Safely transfers the ownership of a given token ID to another address
808      * If the target address is a contract, it must implement `onERC721Received`,
809      * which is called upon a safe transfer, and return the magic value
810      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
811      * the transfer is reverted.
812      * Requires the msg.sender to be the owner, approved, or operator
813      * @param from current owner of the token
814      * @param to address to receive the ownership of the given token ID
815      * @param tokenId uint256 ID of the token to be transferred
816      * @param _data bytes data to send along with a safe transfer check
817      */
818     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
819         _transferFrom(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether the specified token exists.
825      * @param tokenId uint256 ID of the token to query the existence of
826      * @return bool whether the token exists
827      */
828     function _exists(uint256 tokenId) internal view returns (bool) {
829         address owner = _tokenOwner[tokenId];
830         return owner != address(0);
831     }
832 
833     /**
834      * @dev Returns whether the given spender can transfer a given token ID.
835      * @param spender address of the spender to query
836      * @param tokenId uint256 ID of the token to be transferred
837      * @return bool whether the msg.sender is approved for the given token ID,
838      * is an operator of the owner, or is the owner of the token
839      */
840     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
841         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
842         address owner = ownerOf(tokenId);
843         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
844     }
845 
846     /**
847      * @dev Internal function to safely mint a new token.
848      * Reverts if the given token ID already exists.
849      * If the target address is a contract, it must implement `onERC721Received`,
850      * which is called upon a safe transfer, and return the magic value
851      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
852      * the transfer is reverted.
853      * @param to The address that will own the minted token
854      * @param tokenId uint256 ID of the token to be minted
855      */
856     function _safeMint(address to, uint256 tokenId) internal {
857         _safeMint(to, tokenId, "");
858     }
859 
860     /**
861      * @dev Internal function to safely mint a new token.
862      * Reverts if the given token ID already exists.
863      * If the target address is a contract, it must implement `onERC721Received`,
864      * which is called upon a safe transfer, and return the magic value
865      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
866      * the transfer is reverted.
867      * @param to The address that will own the minted token
868      * @param tokenId uint256 ID of the token to be minted
869      * @param _data bytes data to send along with a safe transfer check
870      */
871     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
872         _mint(to, tokenId);
873         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
874     }
875 
876     /**
877      * @dev Internal function to mint a new token.
878      * Reverts if the given token ID already exists.
879      * @param to The address that will own the minted token
880      * @param tokenId uint256 ID of the token to be minted
881      */
882     function _mint(address to, uint256 tokenId) internal {
883         require(to != address(0), "ERC721: mint to the zero address");
884         require(!_exists(tokenId), "ERC721: token already minted");
885 
886         _tokenOwner[tokenId] = to;
887         _ownedTokensCount[to].increment();
888 
889         emit Transfer(address(0), to, tokenId);
890     }
891 
892     /**
893      * @dev Internal function to burn a specific token.
894      * Reverts if the token does not exist.
895      * Deprecated, use {_burn} instead.
896      * @param owner owner of the token to burn
897      * @param tokenId uint256 ID of the token being burned
898      */
899     function _burn(address owner, uint256 tokenId) internal {
900         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
901 
902         _clearApproval(tokenId);
903 
904         _ownedTokensCount[owner].decrement();
905         _tokenOwner[tokenId] = address(0);
906 
907         emit Transfer(owner, address(0), tokenId);
908     }
909 
910     /**
911      * @dev Internal function to burn a specific token.
912      * Reverts if the token does not exist.
913      * @param tokenId uint256 ID of the token being burned
914      */
915     function _burn(uint256 tokenId) internal {
916         _burn(ownerOf(tokenId), tokenId);
917     }
918 
919     /**
920      * @dev Internal function to transfer ownership of a given token ID to another address.
921      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
922      * @param from current owner of the token
923      * @param to address to receive the ownership of the given token ID
924      * @param tokenId uint256 ID of the token to be transferred
925      */
926     function _transferFrom(address from, address to, uint256 tokenId) internal {
927         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
928         require(to != address(0), "ERC721: transfer to the zero address");
929 
930         _clearApproval(tokenId);
931 
932         _ownedTokensCount[from].decrement();
933         _ownedTokensCount[to].increment();
934 
935         _tokenOwner[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * This is an internal detail of the `ERC721` contract and its use is deprecated.
945      * @param from address representing the previous owner of the given token ID
946      * @param to target address that will receive the tokens
947      * @param tokenId uint256 ID of the token to be transferred
948      * @param _data bytes optional data to send along with the call
949      * @return bool whether the call correctly returned the expected magic value
950      */
951     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
952         internal returns (bool)
953     {
954         if (!to.isContract()) {
955             return true;
956         }
957         // solhint-disable-next-line avoid-low-level-calls
958         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
959             IERC721Receiver(to).onERC721Received.selector,
960             _msgSender(),
961             from,
962             tokenId,
963             _data
964         ));
965         if (!success) {
966             if (returndata.length > 0) {
967                 // solhint-disable-next-line no-inline-assembly
968                 assembly {
969                     let returndata_size := mload(returndata)
970                     revert(add(32, returndata), returndata_size)
971                 }
972             } else {
973                 revert("ERC721: transfer to non ERC721Receiver implementer");
974             }
975         } else {
976             bytes4 retval = abi.decode(returndata, (bytes4));
977             return (retval == _ERC721_RECEIVED);
978         }
979     }
980 
981     /**
982      * @dev Private function to clear current approval of a given token ID.
983      * @param tokenId uint256 ID of the token to be transferred
984      */
985     function _clearApproval(uint256 tokenId) private {
986         if (_tokenApprovals[tokenId] != address(0)) {
987             _tokenApprovals[tokenId] = address(0);
988         }
989     }
990 }
991 
992 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
993 
994 pragma solidity ^0.5.0;
995 
996 
997 
998 
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
1005     // Mapping from owner to list of owned token IDs
1006     mapping(address => uint256[]) private _ownedTokens;
1007 
1008     // Mapping from token ID to index of the owner tokens list
1009     mapping(uint256 => uint256) private _ownedTokensIndex;
1010 
1011     // Array with all token ids, used for enumeration
1012     uint256[] private _allTokens;
1013 
1014     // Mapping from token id to position in the allTokens array
1015     mapping(uint256 => uint256) private _allTokensIndex;
1016 
1017     /*
1018      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1019      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1020      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1021      *
1022      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1023      */
1024     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1025 
1026     /**
1027      * @dev Constructor function.
1028      */
1029     constructor () public {
1030         // register the supported interface to conform to ERC721Enumerable via ERC165
1031         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1032     }
1033 
1034     /**
1035      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1036      * @param owner address owning the tokens list to be accessed
1037      * @param index uint256 representing the index to be accessed of the requested tokens list
1038      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1039      */
1040     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1041         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1042         return _ownedTokens[owner][index];
1043     }
1044 
1045     /**
1046      * @dev Gets the total amount of tokens stored by the contract.
1047      * @return uint256 representing the total amount of tokens
1048      */
1049     function totalSupply() public view returns (uint256) {
1050         return _allTokens.length;
1051     }
1052 
1053     /**
1054      * @dev Gets the token ID at a given index of all the tokens in this contract
1055      * Reverts if the index is greater or equal to the total number of tokens.
1056      * @param index uint256 representing the index to be accessed of the tokens list
1057      * @return uint256 token ID at the given index of the tokens list
1058      */
1059     function tokenByIndex(uint256 index) public view returns (uint256) {
1060         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1061         return _allTokens[index];
1062     }
1063 
1064     /**
1065      * @dev Internal function to transfer ownership of a given token ID to another address.
1066      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1067      * @param from current owner of the token
1068      * @param to address to receive the ownership of the given token ID
1069      * @param tokenId uint256 ID of the token to be transferred
1070      */
1071     function _transferFrom(address from, address to, uint256 tokenId) internal {
1072         super._transferFrom(from, to, tokenId);
1073 
1074         _removeTokenFromOwnerEnumeration(from, tokenId);
1075 
1076         _addTokenToOwnerEnumeration(to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Internal function to mint a new token.
1081      * Reverts if the given token ID already exists.
1082      * @param to address the beneficiary that will own the minted token
1083      * @param tokenId uint256 ID of the token to be minted
1084      */
1085     function _mint(address to, uint256 tokenId) internal {
1086         super._mint(to, tokenId);
1087 
1088         _addTokenToOwnerEnumeration(to, tokenId);
1089 
1090         _addTokenToAllTokensEnumeration(tokenId);
1091     }
1092 
1093     /**
1094      * @dev Internal function to burn a specific token.
1095      * Reverts if the token does not exist.
1096      * Deprecated, use {ERC721-_burn} instead.
1097      * @param owner owner of the token to burn
1098      * @param tokenId uint256 ID of the token being burned
1099      */
1100     function _burn(address owner, uint256 tokenId) internal {
1101         super._burn(owner, tokenId);
1102 
1103         _removeTokenFromOwnerEnumeration(owner, tokenId);
1104         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1105         _ownedTokensIndex[tokenId] = 0;
1106 
1107         _removeTokenFromAllTokensEnumeration(tokenId);
1108     }
1109 
1110     /**
1111      * @dev Gets the list of token IDs of the requested owner.
1112      * @param owner address owning the tokens
1113      * @return uint256[] List of token IDs owned by the requested address
1114      */
1115     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1116         return _ownedTokens[owner];
1117     }
1118 
1119     /**
1120      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1121      * @param to address representing the new owner of the given token ID
1122      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1123      */
1124     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1125         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1126         _ownedTokens[to].push(tokenId);
1127     }
1128 
1129     /**
1130      * @dev Private function to add a token to this extension's token tracking data structures.
1131      * @param tokenId uint256 ID of the token to be added to the tokens list
1132      */
1133     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1134         _allTokensIndex[tokenId] = _allTokens.length;
1135         _allTokens.push(tokenId);
1136     }
1137 
1138     /**
1139      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1140      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1141      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1142      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1143      * @param from address representing the previous owner of the given token ID
1144      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1145      */
1146     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1147         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1148         // then delete the last slot (swap and pop).
1149 
1150         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1151         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1152 
1153         // When the token to delete is the last token, the swap operation is unnecessary
1154         if (tokenIndex != lastTokenIndex) {
1155             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1156 
1157             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1158             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1159         }
1160 
1161         // This also deletes the contents at the last position of the array
1162         _ownedTokens[from].length--;
1163 
1164         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1165         // lastTokenId, or just over the end of the array if the token was the last one).
1166     }
1167 
1168     /**
1169      * @dev Private function to remove a token from this extension's token tracking data structures.
1170      * This has O(1) time complexity, but alters the order of the _allTokens array.
1171      * @param tokenId uint256 ID of the token to be removed from the tokens list
1172      */
1173     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1174         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1175         // then delete the last slot (swap and pop).
1176 
1177         uint256 lastTokenIndex = _allTokens.length.sub(1);
1178         uint256 tokenIndex = _allTokensIndex[tokenId];
1179 
1180         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1181         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1182         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1183         uint256 lastTokenId = _allTokens[lastTokenIndex];
1184 
1185         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1186         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1187 
1188         // This also deletes the contents at the last position of the array
1189         _allTokens.length--;
1190         _allTokensIndex[tokenId] = 0;
1191     }
1192 }
1193 
1194 // File: contracts/interface/IERC20.sol
1195 
1196 pragma solidity ^0.5.0;
1197 
1198 /**
1199  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1200  * the optional functions; to access them see {ERC20Detailed}.
1201  */
1202 interface IERC20 {
1203     /**
1204      * @dev Returns the amount of tokens in existence.
1205      */
1206     function totalSupply() external view returns (uint256);
1207 
1208     /**
1209      * @dev Returns the amount of tokens owned by `account`.
1210      */
1211     function balanceOf(address account) external view returns (uint256);
1212 
1213     /**
1214      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1215      *
1216      * Returns a boolean value indicating whether the operation succeeded.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function transfer(address recipient, uint256 amount) external returns (bool);
1221     function mint(address account, uint amount) external;
1222     /**
1223      * @dev Returns the remaining number of tokens that `spender` will be
1224      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1225      * zero by default.
1226      *
1227      * This value changes when {approve} or {transferFrom} are called.
1228      */
1229     function allowance(address owner, address spender) external view returns (uint256);
1230 
1231     /**
1232      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1233      *
1234      * Returns a boolean value indicating whether the operation succeeded.
1235      *
1236      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1237      * that someone may use both the old and the new allowance by unfortunate
1238      * transaction ordering. One possible solution to mitigate this race
1239      * condition is to first reduce the spender's allowance to 0 and set the
1240      * desired value afterwards:
1241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1242      *
1243      * Emits an {Approval} event.
1244      */
1245     function approve(address spender, uint256 amount) external returns (bool);
1246 
1247     /**
1248      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1249      * allowance mechanism. `amount` is then deducted from the caller's
1250      * allowance.
1251      *
1252      * Returns a boolean value indicating whether the operation succeeded.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1257 
1258     /**
1259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1260      * another (`to`).
1261      *
1262      * Note that `value` may be zero.
1263      */
1264     event Transfer(address indexed from, address indexed to, uint256 value);
1265 
1266     /**
1267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1268      * a call to {approve}. `value` is the new allowance.
1269      */
1270     event Approval(address indexed owner, address indexed spender, uint256 value);
1271 }
1272 
1273 // File: contracts/library/SafeERC20.sol
1274 
1275 pragma solidity ^0.5.0;
1276 
1277 
1278 
1279 
1280 
1281 /**
1282  * @title SafeERC20
1283  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1284  * contract returns false). Tokens that return no value (and instead revert or
1285  * throw on failure) are also supported, non-reverting calls are assumed to be
1286  * successful.
1287  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1288  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1289  */
1290 library SafeERC20 {
1291     using SafeMath for uint256;
1292     using Address for address;
1293 
1294     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1295         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1296     }
1297 
1298     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1299         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1300     }
1301 
1302     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1303         // safeApprove should only be called when setting an initial allowance,
1304         // or when resetting it to zero. To increase and decrease it, use
1305         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1306         // solhint-disable-next-line max-line-length
1307         require((value == 0) || (token.allowance(address(this), spender) == 0),
1308             "SafeERC20: approve from non-zero to non-zero allowance"
1309         );
1310         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1311     }
1312 
1313     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1314         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1315         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1316     }
1317 
1318     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1319         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1320         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1321     }
1322 
1323     /**
1324      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1325      * on the return value: the return value is optional (but if data is returned, it must not be false).
1326      * @param token The token targeted by the call.
1327      * @param data The call data (encoded using abi.encode or one of its variants).
1328      */
1329     function callOptionalReturn(IERC20 token, bytes memory data) private {
1330         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1331         // we're implementing it ourselves.
1332 
1333         // A Solidity high level call has three parts:
1334         //  1. The target address is checked to verify it contains contract code
1335         //  2. The call itself is made, and success asserted
1336         //  3. The return value is decoded, which in turn checks the size of the returned data.
1337         // solhint-disable-next-line max-line-length
1338         require(address(token).isContract(), "SafeERC20: call to non-contract");
1339 
1340         // solhint-disable-next-line avoid-low-level-calls
1341         (bool success, bytes memory returndata) = address(token).call(data);
1342         require(success, "SafeERC20: low-level call failed");
1343 
1344         if (returndata.length > 0) { // Return data is optional
1345             // solhint-disable-next-line max-line-length
1346             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1347         }
1348     }
1349 }
1350 
1351 // File: contracts/library/Governance.sol
1352 
1353 pragma solidity ^0.5.0;
1354 
1355 contract Governance {
1356 
1357     address public _governance;
1358 
1359     constructor() public {
1360         _governance = tx.origin;
1361     }
1362 
1363     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
1364 
1365     modifier onlyGovernance {
1366         require(msg.sender == _governance, "not governance");
1367         _;
1368     }
1369 
1370     function setGovernance(address governance)  public  onlyGovernance
1371     {
1372         require(governance != address(0), "new governance the zero address");
1373         emit GovernanceTransferred(_governance, governance);
1374         _governance = governance;
1375     }
1376 
1377 
1378 }
1379 
1380 // File: contracts/interface/IPool.sol
1381 
1382 pragma solidity ^0.5.0;
1383 
1384 
1385 interface IPool {
1386     function totalSupply( ) external view returns (uint256);
1387     function balanceOf( address player ) external view returns (uint256);
1388 }
1389 
1390 // File: contracts/interface/IPlayerBook.sol
1391 
1392 pragma solidity ^0.5.0;
1393 
1394 
1395 interface IPlayerBook {
1396     function settleReward( address from,uint256 amount ) external returns (uint256);
1397     function bindRefer( address from,string calldata  affCode )  external returns (bool);
1398     function hasRefer(address from) external returns(bool);
1399 
1400 }
1401 
1402 // File: contracts/interface/IGegoFactory.sol
1403 
1404 pragma solidity ^0.5.0;
1405 
1406 interface IGegoFactory {
1407     function getGego(uint256 tokenId)
1408         external view
1409         returns (
1410             uint256 grade,
1411             uint256 quality,
1412             uint256 degoAmount,
1413             uint256 createdTime,
1414             uint256 blockNum,
1415             uint256 resId,
1416             address author
1417         );
1418 
1419 
1420     function getQualityBase() external view 
1421         returns (uint256 );
1422 }
1423 
1424 // File: contracts/interface/IGegoToken.sol
1425 
1426 pragma solidity ^0.5.0;
1427 
1428 
1429 
1430 contract IGegoToken is IERC721 {
1431     function mint(address to, uint256 tokenId) external returns (bool) ;
1432     function burn(uint256 tokenId) external;
1433 }
1434 
1435 // File: contracts/reward/NFTReward.sol
1436 
1437 pragma solidity ^0.5.0;
1438 
1439 
1440 
1441 
1442 
1443 // gego
1444 // import "../interface/IERC20.sol";
1445 
1446 
1447 
1448 
1449 
1450 
1451 
1452 
1453     
1454 contract NFTReward is IPool,Governance {
1455     using SafeERC20 for IERC20;
1456     using SafeMath for uint256;
1457 
1458     IERC20 public _dego = IERC20(0x0);
1459     IGegoFactory public _gegoFactory = IGegoFactory(0x0);
1460     IGegoToken public _gegoToken = IGegoToken(0x0);
1461     address public _playerBook = address(0x0);
1462 
1463     address public _teamWallet = 0x3D0a845C5ef9741De999FC068f70E2048A489F2b;
1464     address public _rewardPool = 0xEA6dEc98e137a87F78495a8386f7A137408f7722;
1465 
1466     uint256 public constant DURATION = 7 days;
1467     uint256 public _initReward = 52500 * 1e18;
1468     uint256 public _startTime =  now + 365 days;
1469     uint256 public _periodFinish = 0;
1470     uint256 public _rewardRate = 0;
1471     uint256 public _lastUpdateTime;
1472     uint256 public _rewardPerTokenStored;
1473 
1474     uint256 public _teamRewardRate = 500;
1475     uint256 public _poolRewardRate = 1000;
1476     uint256 public _baseRate = 10000;
1477     uint256 public _punishTime = 3 days;
1478 
1479     mapping(address => uint256) public _userRewardPerTokenPaid;
1480     mapping(address => uint256) public _rewards;
1481     mapping(address => uint256) public _lastStakedTime;
1482 
1483     bool public _hasStart = false;
1484     uint256 public _fixRateBase = 100000;
1485     
1486     uint256 public _totalWeight;
1487     mapping(address => uint256) public _weightBalances;
1488     mapping(uint256 => uint256) public _stakeWeightes;
1489     mapping(uint256 => uint256) public _stakeBalances;
1490 
1491     uint256 public _totalBalance;
1492     mapping(address => uint256) public _degoBalances;
1493     uint256 public _maxStakedDego = 200 * 1e18;
1494 
1495     mapping(address => uint256[]) public _playerGego;
1496     mapping(uint256 => uint256) public _gegoMapIndex;
1497     
1498 
1499 
1500     event RewardAdded(uint256 reward);
1501     event StakedGEGO(address indexed user, uint256 amount);
1502     event WithdrawnGego(address indexed user, uint256 amount);
1503     event RewardPaid(address indexed user, uint256 reward);
1504     event NFTReceived(address operator, address from, uint256 tokenId, bytes data);
1505 
1506     constructor(address dego, address gego, address gegoFactory,address playerBook) public {
1507         _dego = IERC20(dego);
1508         _gegoToken = IGegoToken(gego);
1509         _gegoFactory = IGegoFactory(gegoFactory);
1510         _playerBook = playerBook;
1511     }
1512     
1513 
1514     modifier updateReward(address account) {
1515         _rewardPerTokenStored = rewardPerToken();
1516         _lastUpdateTime = lastTimeRewardApplicable();
1517         if (account != address(0)) {
1518             _rewards[account] = earned(account);
1519             _userRewardPerTokenPaid[account] = _rewardPerTokenStored;
1520         }
1521         _;
1522     }
1523 
1524     function setMaxStakedDego(uint256 amount) external onlyGovernance{
1525         _maxStakedDego = amount;
1526     }
1527 
1528     /* Fee collection for any other token */
1529     function seize(IERC20 token, uint256 amount) external onlyGovernance{
1530         require(token != _dego, "reward");
1531         token.safeTransfer(_governance, amount);
1532     }
1533     
1534     /* Fee collection for any other token */
1535     function seizeErc721(IERC721 token, uint256 tokenId) external 
1536     {
1537         require(token != _gegoToken, "gego stake");
1538         token.safeTransferFrom(address(this), _governance, tokenId);
1539     }
1540 
1541     function lastTimeRewardApplicable() public view returns (uint256) {
1542         return Math.min(block.timestamp, _periodFinish);
1543     }
1544 
1545     function rewardPerToken() public view returns (uint256) {
1546         if (totalSupply() == 0) {
1547             return _rewardPerTokenStored;
1548         }
1549         return
1550             _rewardPerTokenStored.add(
1551                 lastTimeRewardApplicable()
1552                     .sub(_lastUpdateTime)
1553                     .mul(_rewardRate)
1554                     .mul(1e18)
1555                     .div(totalSupply())
1556             );
1557     }
1558 
1559     function earned(address account) public view returns (uint256) {
1560         return
1561             balanceOf(account)
1562                 .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))
1563                 .div(1e18)
1564                 .add(_rewards[account]);
1565     }
1566 
1567     
1568     //the grade is a number between 1-6
1569     //the quality is a number between 1-10000
1570     /*
1571     1   quality	1.1+ 0.1*quality/5000
1572     2	quality	1.2+ 0.1*(quality-5000)/3000
1573     3	quality	1.3+ 0.1*(quality-8000/1000
1574     4	quality	1.4+ 0.2*(quality-9000)/800
1575     5	quality	1.6+ 0.2*(quality-9800)/180
1576     6	quality	1.8+ 0.2*(quality-9980)/20
1577     */
1578 
1579     function getFixRate(uint256 grade,uint256 quality) public pure returns (uint256){
1580 
1581         require(grade > 0 && grade <7, "the gego not dego");
1582 
1583         uint256 unfold = 0;
1584 
1585         if( grade == 1 ){
1586             unfold = quality*10000/5000;
1587             return unfold.add(110000);
1588         }else if( grade == 2){
1589             unfold = quality.sub(5000)*10000/3000;
1590             return unfold.add(120000);
1591         }else if( grade == 3){
1592             unfold = quality.sub(8000)*10000/1000;
1593            return unfold.add(130000);
1594         }else if( grade == 4){
1595             unfold = quality.sub(9000)*20000/800;
1596            return unfold.add(140000);
1597         }else if( grade == 5){
1598             unfold = quality.sub(9800)*20000/180;
1599             return unfold.add(160000);
1600         }else{
1601             unfold = quality.sub(9980)*20000/20;
1602             return unfold.add(180000);
1603         }
1604     }
1605 
1606     function getStakeInfo( uint256 gegoId ) public view returns ( uint256 stakeRate, uint256 degoAmount){
1607 
1608         uint256 grade;
1609         uint256 quality;
1610         uint256 createdTime;
1611         uint256 blockNum;
1612         uint256 resId;
1613         address author;
1614 
1615         (grade, quality, degoAmount, createdTime,blockNum, resId, author) = _gegoFactory.getGego(gegoId);
1616 
1617         require(degoAmount > 0,"the gego not dego");
1618 
1619         stakeRate = getFixRate(grade,quality);
1620     }
1621 
1622     // stake GEGO 
1623     function stakeGego(uint256 gegoId, string memory affCode)
1624         public
1625         updateReward(msg.sender)
1626         checkHalve
1627         checkStart
1628     {
1629 
1630         uint256[] storage gegoIds = _playerGego[msg.sender];
1631         if (gegoIds.length == 0) {
1632             gegoIds.push(0);    
1633             _gegoMapIndex[0] = 0;
1634         }
1635         gegoIds.push(gegoId);
1636         _gegoMapIndex[gegoId] = gegoIds.length - 1;
1637 
1638         uint256 stakeRate;
1639         uint256 degoAmount;
1640         (stakeRate, degoAmount) = getStakeInfo(gegoId);
1641 
1642         uint256 stakedDegoAmount = _degoBalances[msg.sender];
1643         uint256 stakingDegoAmount = stakedDegoAmount.add(degoAmount) <= _maxStakedDego?degoAmount:_maxStakedDego.sub(stakedDegoAmount);
1644 
1645 
1646         if(stakingDegoAmount > 0){
1647             uint256 stakeWeight = stakeRate.mul(stakingDegoAmount).div(_fixRateBase);
1648             _degoBalances[msg.sender] = _degoBalances[msg.sender].add(stakingDegoAmount);
1649 
1650             _weightBalances[msg.sender] = _weightBalances[msg.sender].add(stakeWeight);
1651 
1652             _stakeBalances[gegoId] = stakingDegoAmount;
1653             _stakeWeightes[gegoId] = stakeWeight;
1654             
1655             _totalBalance = _totalBalance.add(stakingDegoAmount);
1656             _totalWeight = _totalWeight.add(stakeWeight);
1657         }
1658 
1659         _gegoToken.safeTransferFrom(msg.sender, address(this), gegoId);
1660 
1661         if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {
1662             IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);
1663         }
1664         _lastStakedTime[msg.sender] = now;
1665         emit StakedGEGO(msg.sender, gegoId);
1666         
1667     }
1668     
1669     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
1670         if(_hasStart == false) {
1671             return 0;
1672         }
1673 
1674         emit NFTReceived(operator, from, tokenId, data);
1675         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1676     }
1677 
1678     function withdrawGego(uint256 gegoId)
1679         public
1680         updateReward(msg.sender)
1681         checkHalve
1682         checkStart
1683     {
1684         require(gegoId > 0, "the gegoId error");
1685         
1686         uint256[] memory gegoIds = _playerGego[msg.sender];
1687         uint256 gegoIndex = _gegoMapIndex[gegoId];
1688         
1689         require(gegoIds[gegoIndex] == gegoId, "not gegoId owner");
1690 
1691         uint256 gegoArrayLength = gegoIds.length-1;
1692         uint256 tailId = gegoIds[gegoArrayLength];
1693 
1694         _playerGego[msg.sender][gegoIndex] = tailId;
1695         _playerGego[msg.sender][gegoArrayLength] = 0;
1696         _playerGego[msg.sender].length--;
1697         _gegoMapIndex[tailId] = gegoIndex;
1698         _gegoMapIndex[gegoId] = 0;
1699 
1700         uint256 stakeWeight = _stakeWeightes[gegoId];
1701         _weightBalances[msg.sender] = _weightBalances[msg.sender].sub(stakeWeight);
1702         _totalWeight = _totalWeight.sub(stakeWeight);
1703 
1704         uint256 stakeBalance = _stakeBalances[gegoId];
1705         _degoBalances[msg.sender] = _degoBalances[msg.sender].sub(stakeBalance);
1706         _totalBalance = _totalBalance.sub(stakeBalance);
1707 
1708 
1709 
1710         _gegoToken.safeTransferFrom(address(this), msg.sender, gegoId);
1711 
1712         _stakeBalances[gegoId] = 0;
1713         _stakeWeightes[gegoId] = 0;
1714 
1715         emit WithdrawnGego(msg.sender, gegoId);
1716     }
1717 
1718     function withdraw()
1719         public
1720         checkStart
1721     {
1722 
1723         uint256[] memory gegoId = _playerGego[msg.sender];
1724         for (uint8 index = 1; index < gegoId.length; index++) {
1725             if (gegoId[index] > 0) {
1726                 withdrawGego(gegoId[index]);
1727             }
1728         }
1729     }
1730 
1731     function getPlayerIds( address account ) public view returns( uint256[] memory gegoId )
1732     {
1733         gegoId = _playerGego[account];
1734     }
1735 
1736     function exit() external {
1737         withdraw();
1738         getReward();
1739     }
1740 
1741     function getReward() public updateReward(msg.sender) checkHalve checkStart {
1742         uint256 reward = earned(msg.sender);
1743         if (reward > 0) {
1744             _rewards[msg.sender] = 0;
1745 
1746             uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);
1747             if(fee > 0){
1748                 _dego.safeTransfer(_playerBook, fee);
1749             }
1750             
1751             uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);
1752             if(teamReward>0){
1753                 _dego.safeTransfer(_teamWallet, teamReward);
1754             }
1755             uint256 leftReward = reward.sub(fee).sub(teamReward);
1756             uint256 poolReward = 0;
1757 
1758             //withdraw time check
1759 
1760             if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){
1761                 poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);
1762             }
1763             if(poolReward>0){
1764                 _dego.safeTransfer(_rewardPool, poolReward);
1765                 leftReward = leftReward.sub(poolReward);
1766             }
1767 
1768             if(leftReward>0){
1769                 _dego.safeTransfer(msg.sender, leftReward );
1770             }
1771       
1772             emit RewardPaid(msg.sender, leftReward);
1773         }
1774     }
1775 
1776     modifier checkHalve() {
1777         if (block.timestamp >= _periodFinish) {
1778             _initReward = _initReward.mul(50).div(100);
1779 
1780             _dego.mint(address(this), _initReward);
1781 
1782             _rewardRate = _initReward.div(DURATION);
1783             _periodFinish = block.timestamp.add(DURATION);
1784             emit RewardAdded(_initReward);
1785         }
1786         _;
1787     }
1788     
1789     modifier checkStart() {
1790         require(block.timestamp > _startTime, "not start");
1791         _;
1792     }
1793 
1794     // set fix time to start reward
1795     function startNFTReward(uint256 startTime)
1796         external
1797         onlyGovernance
1798         updateReward(address(0))
1799     {
1800         require(_hasStart == false, "has started");
1801         _hasStart = true;
1802         
1803         _startTime = startTime;
1804 
1805         _rewardRate = _initReward.div(DURATION); 
1806         _dego.mint(address(this), _initReward);
1807 
1808         _lastUpdateTime = _startTime;
1809         _periodFinish = _startTime.add(DURATION);
1810 
1811         emit RewardAdded(_initReward);
1812     }
1813 
1814     //
1815 
1816     //for extra reward
1817     function notifyMintAmount(uint256 reward)
1818         external
1819         onlyGovernance
1820         updateReward(address(0))
1821     {
1822         // IERC20(_dego).safeTransferFrom(msg.sender, address(this), reward);
1823         _dego.mint(address(this), reward);
1824         if (block.timestamp >= _periodFinish) {
1825             _rewardRate = reward.div(DURATION);
1826         } else {
1827             uint256 remaining = _periodFinish.sub(block.timestamp);
1828             uint256 leftover = remaining.mul(_rewardRate);
1829             _rewardRate = reward.add(leftover).div(DURATION);
1830         }
1831         _lastUpdateTime = block.timestamp;
1832         _periodFinish = block.timestamp.add(DURATION);
1833         emit RewardAdded(reward);
1834     }
1835 
1836     function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance {
1837         _teamRewardRate = teamRewardRate;
1838     }
1839 
1840     function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{
1841         _poolRewardRate = poolRewardRate;
1842     }
1843 
1844     function totalSupply()  public view returns (uint256) {
1845         return _totalWeight;
1846     }
1847 
1848     function balanceOf(address account) public view returns (uint256) {
1849         return _weightBalances[account];
1850     }
1851     
1852     function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{
1853         _punishTime = punishTime;
1854     }
1855 
1856 }