1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.5.12;
3 
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
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Returns true if the caller is the current owner.
71      */
72     function isOwner() public view returns (bool) {
73         return _msgSender() == _owner;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 contract IERC721 is IERC165 {
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
134 
135     /**
136      * @dev Returns the number of NFTs in `owner`'s account.
137      */
138     function balanceOf(address owner) public view returns (uint256 balance);
139 
140     /**
141      * @dev Returns the owner of the NFT specified by `tokenId`.
142      */
143     function ownerOf(uint256 tokenId) public view returns (address owner);
144 
145     /**
146      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
147      * another (`to`).
148      *
149      *
150      *
151      * Requirements:
152      * - `from`, `to` cannot be zero.
153      * - `tokenId` must be owned by `from`.
154      * - If the caller is not `from`, it must be have been allowed to move this
155      * NFT by either {approve} or {setApprovalForAll}.
156      */
157     function safeTransferFrom(address from, address to, uint256 tokenId) public;
158     /**
159      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
160      * another (`to`).
161      *
162      * Requirements:
163      * - If the caller is not `from`, it must be approved to move this NFT by
164      * either {approve} or {setApprovalForAll}.
165      */
166     function transferFrom(address from, address to, uint256 tokenId) public;
167     function approve(address to, uint256 tokenId) public;
168     function getApproved(uint256 tokenId) public view returns (address operator);
169 
170     function setApprovalForAll(address operator, bool _approved) public;
171     function isApprovedForAll(address owner, address operator) public view returns (bool);
172 
173 
174     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
175 }
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 contract IERC721Receiver {
183     /**
184      * @notice Handle the receipt of an NFT
185      * @dev The ERC721 smart contract calls this function on the recipient
186      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
187      * otherwise the caller will revert the transaction. The selector to be
188      * returned can be obtained as `this.onERC721Received.selector`. This
189      * function MAY throw to revert and reject the transfer.
190      * Note: the ERC721 contract address is always the message sender.
191      * @param operator The address which called `safeTransferFrom` function
192      * @param from The address which previously owned the token
193      * @param tokenId The NFT identifier which is being transferred
194      * @param data Additional data with no specified format
195      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
196      */
197     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
198     public returns (bytes4);
199 }
200 
201 /**
202  * @dev Wrappers over Solidity's arithmetic operations with added overflow
203  * checks.
204  *
205  * Arithmetic operations in Solidity wrap on overflow. This can easily result
206  * in bugs, because programmers usually assume that an overflow raises an
207  * error, which is the standard behavior in high level programming languages.
208  * `SafeMath` restores this intuition by reverting the transaction when an
209  * operation overflows.
210  *
211  * Using this library instead of the unchecked operations eliminates an entire
212  * class of bugs, so it's recommended to use it always.
213  */
214 library SafeMath {
215     /**
216      * @dev Returns the addition of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `+` operator.
220      *
221      * Requirements:
222      * - Addition cannot overflow.
223      */
224     function add(uint256 a, uint256 b) internal pure returns (uint256) {
225         uint256 c = a + b;
226         require(c >= a, "SafeMath: addition overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the subtraction of two unsigned integers, reverting on
233      * overflow (when the result is negative).
234      *
235      * Counterpart to Solidity's `-` operator.
236      *
237      * Requirements:
238      * - Subtraction cannot overflow.
239      */
240     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
241         return sub(a, b, "SafeMath: subtraction overflow");
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      * - Subtraction cannot overflow.
252      *
253      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
254      * @dev Get it via `npm install @openzeppelin/contracts@next`.
255      */
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `*` operator.
268      *
269      * Requirements:
270      * - Multiplication cannot overflow.
271      */
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
274         // benefit is lost if 'b' is also tested.
275         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
276         if (a == 0) {
277             return 0;
278         }
279 
280         uint256 c = a * b;
281         require(c / a == b, "SafeMath: multiplication overflow");
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return div(a, b, "SafeMath: division by zero");
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311 
312      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
313      * @dev Get it via `npm install @openzeppelin/contracts@next`.
314      */
315     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         // Solidity only automatically asserts when dividing by 0
317         require(b > 0, errorMessage);
318         uint256 c = a / b;
319         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
351      * @dev Get it via `npm install @openzeppelin/contracts@next`.
352      */
353     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b != 0, errorMessage);
355         return a % b;
356     }
357 }
358 
359 /**
360  * @dev Collection of functions related to the address type
361  */
362 library Address {
363     /**
364      * @dev Returns true if `account` is a contract.
365      *
366      * This test is non-exhaustive, and there may be false-negatives: during the
367      * execution of a contract's constructor, its address will be reported as
368      * not containing a contract.
369      *
370      * IMPORTANT: It is unsafe to assume that an address for which this
371      * function returns false is an externally-owned account (EOA) and not a
372      * contract.
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies in extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
380         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
381         // for accounts without code, i.e. `keccak256('')`
382         bytes32 codehash;
383         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
384         // solhint-disable-next-line no-inline-assembly
385         assembly { codehash := extcodehash(account) }
386         return (codehash != 0x0 && codehash != accountHash);
387     }
388 
389     /**
390      * @dev Converts an `address` into `address payable`. Note that this is
391      * simply a type cast: the actual underlying value is not changed.
392      *
393      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
394      * @dev Get it via `npm install @openzeppelin/contracts@next`.
395      */
396     function toPayable(address account) internal pure returns (address payable) {
397         return address(uint160(account));
398     }
399 }
400 
401 /**
402  * @title Counters
403  * @author Matt Condon (@shrugs)
404  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
405  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
406  *
407  * Include with `using Counters for Counters.Counter;`
408  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
409  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
410  * directly accessed.
411  */
412 library Counters {
413     using SafeMath for uint256;
414 
415     struct Counter {
416         // This variable should never be directly accessed by users of the library: interactions must be restricted to
417         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
418         // this feature: see https://github.com/ethereum/solidity/issues/4637
419         uint256 _value; // default: 0
420     }
421 
422     function current(Counter storage counter) internal view returns (uint256) {
423         return counter._value;
424     }
425 
426     function increment(Counter storage counter) internal {
427         // The {SafeMath} overflow check can be skipped here, see the comment at the top
428         counter._value += 1;
429     }
430 
431     function decrement(Counter storage counter) internal {
432         counter._value = counter._value.sub(1);
433     }
434 }
435 
436 /**
437  * @dev Implementation of the {IERC165} interface.
438  *
439  * Contracts may inherit from this and call {_registerInterface} to declare
440  * their support of an interface.
441  */
442 contract ERC165 is IERC165 {
443     /*
444      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
445      */
446     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
447 
448     /**
449      * @dev Mapping of interface ids to whether or not it's supported.
450      */
451     mapping(bytes4 => bool) private _supportedInterfaces;
452 
453     constructor () internal {
454         // Derived contracts need only register support for their own interfaces,
455         // we register support for ERC165 itself here
456         _registerInterface(_INTERFACE_ID_ERC165);
457     }
458 
459     /**
460      * @dev See {IERC165-supportsInterface}.
461      *
462      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
465         return _supportedInterfaces[interfaceId];
466     }
467 
468     /**
469      * @dev Registers the contract as an implementer of the interface defined by
470      * `interfaceId`. Support of the actual ERC165 interface is automatic and
471      * registering its interface id is not required.
472      *
473      * See {IERC165-supportsInterface}.
474      *
475      * Requirements:
476      *
477      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
478      */
479     function _registerInterface(bytes4 interfaceId) internal {
480         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
481         _supportedInterfaces[interfaceId] = true;
482     }
483 }
484 
485 /**
486  * @title ERC721 Non-Fungible Token Standard basic implementation
487  * @dev see https://eips.ethereum.org/EIPS/eip-721
488  */
489 contract ERC721 is Context, ERC165, IERC721 {
490     using SafeMath for uint256;
491     using Address for address;
492     using Counters for Counters.Counter;
493 
494     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
495     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
496     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
497 
498     // Mapping from token ID to owner
499     mapping (uint256 => address) private _tokenOwner;
500 
501     // Mapping from token ID to approved address
502     mapping (uint256 => address) private _tokenApprovals;
503 
504     // Mapping from owner to number of owned token
505     mapping (address => Counters.Counter) private _ownedTokensCount;
506 
507     // Mapping from owner to operator approvals
508     mapping (address => mapping (address => bool)) private _operatorApprovals;
509 
510     /*
511      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
512      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
513      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
514      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
515      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
516      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
517      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
518      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
519      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
520      *
521      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
522      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
523      */
524     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
525 
526     constructor () public {
527         // register the supported interfaces to conform to ERC721 via ERC165
528         _registerInterface(_INTERFACE_ID_ERC721);
529     }
530 
531     /**
532      * @dev Gets the balance of the specified address.
533      * @param owner address to query the balance of
534      * @return uint256 representing the amount owned by the passed address
535      */
536     function balanceOf(address owner) public view returns (uint256) {
537         require(owner != address(0), "ERC721: balance query for the zero address");
538 
539         return _ownedTokensCount[owner].current();
540     }
541 
542     /**
543      * @dev Gets the owner of the specified token ID.
544      * @param tokenId uint256 ID of the token to query the owner of
545      * @return address currently marked as the owner of the given token ID
546      */
547     function ownerOf(uint256 tokenId) public view returns (address) {
548         address owner = _tokenOwner[tokenId];
549         // require(owner != address(0), "ERC721: owner query for nonexistent token");
550 
551         return owner;
552     }
553 
554     /**
555      * @dev Approves another address to transfer the given token ID
556      * The zero address indicates there is no approved address.
557      * There can only be one approved address per token at a given time.
558      * Can only be called by the token owner or an approved operator.
559      * @param to address to be approved for the given token ID
560      * @param tokenId uint256 ID of the token to be approved
561      */
562     function approve(address to, uint256 tokenId) public {
563         address owner = ownerOf(tokenId);
564         require(to != owner, "ERC721: approval to current owner");
565 
566         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
567             "ERC721: approve caller is not owner nor approved for all"
568         );
569 
570         _tokenApprovals[tokenId] = to;
571         emit Approval(owner, to, tokenId);
572     }
573 
574     /**
575      * @dev Gets the approved address for a token ID, or zero if no address set
576      * Reverts if the token ID does not exist.
577      * @param tokenId uint256 ID of the token to query the approval of
578      * @return address currently approved for the given token ID
579      */
580     function getApproved(uint256 tokenId) public view returns (address) {
581         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
582 
583         return _tokenApprovals[tokenId];
584     }
585 
586     /**
587      * @dev Sets or unsets the approval of a given operator
588      * An operator is allowed to transfer all tokens of the sender on their behalf.
589      * @param to operator address to set the approval
590      * @param approved representing the status of the approval to be set
591      */
592     function setApprovalForAll(address to, bool approved) public {
593         require(to != _msgSender(), "ERC721: approve to caller");
594 
595         _operatorApprovals[_msgSender()][to] = approved;
596         emit ApprovalForAll(_msgSender(), to, approved);
597     }
598 
599     /**
600      * @dev Tells whether an operator is approved by a given owner.
601      * @param owner owner address which you want to query the approval of
602      * @param operator operator address which you want to query the approval of
603      * @return bool whether the given operator is approved by the given owner
604      */
605     function isApprovedForAll(address owner, address operator) public view returns (bool) {
606         return _operatorApprovals[owner][operator];
607     }
608 
609     /**
610      * @dev Transfers the ownership of a given token ID to another address.
611      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
612      * Requires the msg.sender to be the owner, approved, or operator.
613      * @param from current owner of the token
614      * @param to address to receive the ownership of the given token ID
615      * @param tokenId uint256 ID of the token to be transferred
616      */
617     function transferFrom(address from, address to, uint256 tokenId) public {
618         //solhint-disable-next-line max-line-length
619         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
620 
621         _transferFrom(from, to, tokenId);
622     }
623 
624     /**
625      * @dev Safely transfers the ownership of a given token ID to another address
626      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
627      * which is called upon a safe transfer, and return the magic value
628      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
629      * the transfer is reverted.
630      * Requires the msg.sender to be the owner, approved, or operator
631      * @param from current owner of the token
632      * @param to address to receive the ownership of the given token ID
633      * @param tokenId uint256 ID of the token to be transferred
634      */
635     function safeTransferFrom(address from, address to, uint256 tokenId) public {
636         safeTransferFrom(from, to, tokenId, "");
637     }
638 
639     /**
640      * @dev Safely transfers the ownership of a given token ID to another address
641      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
642      * which is called upon a safe transfer, and return the magic value
643      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
644      * the transfer is reverted.
645      * Requires the _msgSender() to be the owner, approved, or operator
646      * @param from current owner of the token
647      * @param to address to receive the ownership of the given token ID
648      * @param tokenId uint256 ID of the token to be transferred
649      * @param _data bytes data to send along with a safe transfer check
650      */
651     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
652         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
653         _safeTransferFrom(from, to, tokenId, _data);
654     }
655 
656     /**
657      * @dev Safely transfers the ownership of a given token ID to another address
658      * If the target address is a contract, it must implement `onERC721Received`,
659      * which is called upon a safe transfer, and return the magic value
660      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
661      * the transfer is reverted.
662      * Requires the msg.sender to be the owner, approved, or operator
663      * @param from current owner of the token
664      * @param to address to receive the ownership of the given token ID
665      * @param tokenId uint256 ID of the token to be transferred
666      * @param _data bytes data to send along with a safe transfer check
667      */
668     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
669         _transferFrom(from, to, tokenId);
670         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
671     }
672 
673     /**
674      * @dev Returns whether the specified token exists.
675      * @param tokenId uint256 ID of the token to query the existence of
676      * @return bool whether the token exists
677      */
678     function _exists(uint256 tokenId) internal view returns (bool) {
679         address owner = _tokenOwner[tokenId];
680         return owner != address(0);
681     }
682 
683     /**
684      * @dev Returns whether the given spender can transfer a given token ID.
685      * @param spender address of the spender to query
686      * @param tokenId uint256 ID of the token to be transferred
687      * @return bool whether the msg.sender is approved for the given token ID,
688      * is an operator of the owner, or is the owner of the token
689      */
690     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
691         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
692         address owner = ownerOf(tokenId);
693         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
694     }
695 
696     /**
697      * @dev Internal function to safely mint a new token.
698      * Reverts if the given token ID already exists.
699      * If the target address is a contract, it must implement `onERC721Received`,
700      * which is called upon a safe transfer, and return the magic value
701      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
702      * the transfer is reverted.
703      * @param to The address that will own the minted token
704      * @param tokenId uint256 ID of the token to be minted
705      */
706     function _safeMint(address to, uint256 tokenId) internal {
707         _safeMint(to, tokenId, "");
708     }
709 
710     /**
711      * @dev Internal function to safely mint a new token.
712      * Reverts if the given token ID already exists.
713      * If the target address is a contract, it must implement `onERC721Received`,
714      * which is called upon a safe transfer, and return the magic value
715      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
716      * the transfer is reverted.
717      * @param to The address that will own the minted token
718      * @param tokenId uint256 ID of the token to be minted
719      * @param _data bytes data to send along with a safe transfer check
720      */
721     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
722         _mint(to, tokenId);
723         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
724     }
725 
726     /**
727      * @dev Internal function to mint a new token.
728      * Reverts if the given token ID already exists.
729      * @param to The address that will own the minted token
730      * @param tokenId uint256 ID of the token to be minted
731      */
732     function _mint(address to, uint256 tokenId) internal {
733         require(to != address(0), "ERC721: mint to the zero address");
734         require(!_exists(tokenId), "ERC721: token already minted");
735 
736         _tokenOwner[tokenId] = to;
737         _ownedTokensCount[to].increment();
738 
739         emit Transfer(address(0), to, tokenId);
740     }
741 
742     /**
743      * @dev Internal function to burn a specific token.
744      * Reverts if the token does not exist.
745      * Deprecated, use {_burn} instead.
746      * @param owner owner of the token to burn
747      * @param tokenId uint256 ID of the token being burned
748      */
749     function _burn(address owner, uint256 tokenId) internal {
750         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
751 
752         _clearApproval(tokenId);
753 
754         _ownedTokensCount[owner].decrement();
755         _tokenOwner[tokenId] = address(0);
756 
757         emit Transfer(owner, address(0), tokenId);
758     }
759 
760     /**
761      * @dev Internal function to burn a specific token.
762      * Reverts if the token does not exist.
763      * @param tokenId uint256 ID of the token being burned
764      */
765     function _burn(uint256 tokenId) internal {
766         _burn(ownerOf(tokenId), tokenId);
767     }
768 
769     /**
770      * @dev Internal function to transfer ownership of a given token ID to another address.
771      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
772      * @param from current owner of the token
773      * @param to address to receive the ownership of the given token ID
774      * @param tokenId uint256 ID of the token to be transferred
775      */
776     function _transferFrom(address from, address to, uint256 tokenId) internal {
777         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
778         require(to != address(0), "ERC721: transfer to the zero address");
779 
780         _clearApproval(tokenId);
781 
782         _ownedTokensCount[from].decrement();
783         _ownedTokensCount[to].increment();
784 
785         _tokenOwner[tokenId] = to;
786 
787         emit Transfer(from, to, tokenId);
788     }
789 
790     /**
791      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
792      * The call is not executed if the target address is not a contract.
793      *
794      * This function is deprecated.
795      * @param from address representing the previous owner of the given token ID
796      * @param to target address that will receive the tokens
797      * @param tokenId uint256 ID of the token to be transferred
798      * @param _data bytes optional data to send along with the call
799      * @return bool whether the call correctly returned the expected magic value
800      */
801     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
802         internal returns (bool)
803     {
804         if (!to.isContract()) {
805             return true;
806         }
807 
808         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
809         return (retval == _ERC721_RECEIVED);
810     }
811 
812     /**
813      * @dev Private function to clear current approval of a given token ID.
814      * @param tokenId uint256 ID of the token to be transferred
815      */
816     function _clearApproval(uint256 tokenId) private {
817         if (_tokenApprovals[tokenId] != address(0)) {
818             _tokenApprovals[tokenId] = address(0);
819         }
820     }
821 }
822 
823 /**
824  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
825  * @dev See https://eips.ethereum.org/EIPS/eip-721
826  */
827 contract IERC721Enumerable is IERC721 {
828     function totalSupply() public view returns (uint256);
829     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
830 
831     function tokenByIndex(uint256 index) public view returns (uint256);
832 }
833 
834 /**
835  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
836  * @dev See https://eips.ethereum.org/EIPS/eip-721
837  */
838 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
839     // Mapping from owner to list of owned token IDs
840     mapping(address => uint256[]) internal _ownedTokens;
841 
842     // Mapping from token ID to index of the owner tokens list
843     mapping(uint256 => uint256) internal _ownedTokensIndex;
844 
845     // Array with all token ids, used for enumeration
846     uint256[] internal _allTokens;
847 
848     // Mapping from token id to position in the allTokens array
849     mapping(uint256 => uint256) internal _allTokensIndex;
850 
851     /*
852      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
853      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
854      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
855      *
856      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
857      */
858     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
859 
860     /**
861      * @dev Constructor function.
862      */
863     constructor () public {
864         // register the supported interface to conform to ERC721Enumerable via ERC165
865         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
866     }
867 
868     /**
869      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
870      * @param owner address owning the tokens list to be accessed
871      * @param index uint256 representing the index to be accessed of the requested tokens list
872      * @return uint256 token ID at the given index of the tokens list owned by the requested address
873      */
874     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
875         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
876         return _ownedTokens[owner][index];
877     }
878 
879     /**
880      * @dev Gets the total amount of tokens stored by the contract.
881      * @return uint256 representing the total amount of tokens
882      */
883     function totalSupply() public view returns (uint256) {
884         return _allTokens.length;
885     }
886 
887     /**
888      * @dev Gets the token ID at a given index of all the tokens in this contract
889      * Reverts if the index is greater or equal to the total number of tokens.
890      * @param index uint256 representing the index to be accessed of the tokens list
891      * @return uint256 token ID at the given index of the tokens list
892      */
893     function tokenByIndex(uint256 index) public view returns (uint256) {
894         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
895         return _allTokens[index];
896     }
897 
898     /**
899      * @dev Internal function to transfer ownership of a given token ID to another address.
900      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
901      * @param from current owner of the token
902      * @param to address to receive the ownership of the given token ID
903      * @param tokenId uint256 ID of the token to be transferred
904      */
905     function _transferFrom(address from, address to, uint256 tokenId) internal {
906         super._transferFrom(from, to, tokenId);
907 
908         _removeTokenFromOwnerEnumeration(from, tokenId);
909 
910         _addTokenToOwnerEnumeration(to, tokenId);
911     }
912 
913     /**
914      * @dev Internal function to mint a new token.
915      * Reverts if the given token ID already exists.
916      * @param to address the beneficiary that will own the minted token
917      * @param tokenId uint256 ID of the token to be minted
918      */
919     function _mint(address to, uint256 tokenId) internal {
920         super._mint(to, tokenId);
921 
922         _addTokenToOwnerEnumeration(to, tokenId);
923 
924         _addTokenToAllTokensEnumeration(tokenId);
925     }
926 
927     /**
928      * @dev Internal function to burn a specific token.
929      * Reverts if the token does not exist.
930      * Deprecated, use {ERC721-_burn} instead.
931      * @param owner owner of the token to burn
932      * @param tokenId uint256 ID of the token being burned
933      */
934     function _burn(address owner, uint256 tokenId) internal {
935         super._burn(owner, tokenId);
936 
937         _removeTokenFromOwnerEnumeration(owner, tokenId);
938         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
939         _ownedTokensIndex[tokenId] = 0;
940 
941         _removeTokenFromAllTokensEnumeration(tokenId);
942     }
943 
944     /**
945      * @dev Gets the list of token IDs of the requested owner.
946      * @param owner address owning the tokens
947      * @return uint256[] List of token IDs owned by the requested address
948      */
949     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
950         return _ownedTokens[owner];
951     }
952 
953     /**
954      * @dev Private function to add a token to this extension's ownership-tracking data structures.
955      * @param to address representing the new owner of the given token ID
956      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
957      */
958     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
959         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
960         _ownedTokens[to].push(tokenId);
961     }
962 
963     /**
964      * @dev Private function to add a token to this extension's token tracking data structures.
965      * @param tokenId uint256 ID of the token to be added to the tokens list
966      */
967     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
968         _allTokensIndex[tokenId] = _allTokens.length;
969         _allTokens.push(tokenId);
970     }
971 
972     /**
973      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
974      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
975      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
976      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
977      * @param from address representing the previous owner of the given token ID
978      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
979      */
980     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
981         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
982         // then delete the last slot (swap and pop).
983 
984         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
985         uint256 tokenIndex = _ownedTokensIndex[tokenId];
986 
987         // When the token to delete is the last token, the swap operation is unnecessary
988         if (tokenIndex != lastTokenIndex) {
989             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
990 
991             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
992             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
993         }
994 
995         // This also deletes the contents at the last position of the array
996         _ownedTokens[from].length--;
997 
998         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
999         // lastTokenId, or just over the end of the array if the token was the last one).
1000     }
1001 
1002     /**
1003      * @dev Private function to remove a token from this extension's token tracking data structures.
1004      * This has O(1) time complexity, but alters the order of the _allTokens array.
1005      * @param tokenId uint256 ID of the token to be removed from the tokens list
1006      */
1007     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1008         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1009         // then delete the last slot (swap and pop).
1010 
1011         uint256 lastTokenIndex = _allTokens.length.sub(1);
1012         uint256 tokenIndex = _allTokensIndex[tokenId];
1013 
1014         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1015         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1016         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1017         uint256 lastTokenId = _allTokens[lastTokenIndex];
1018 
1019         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1020         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1021 
1022         // This also deletes the contents at the last position of the array
1023         _allTokens.length--;
1024         _allTokensIndex[tokenId] = 0;
1025     }
1026 }
1027 
1028 /**
1029  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1030  * @dev See https://eips.ethereum.org/EIPS/eip-721
1031  */
1032 contract IERC721Metadata is IERC721 {
1033     function name() external view returns (string memory);
1034     function symbol() external view returns (string memory);
1035     function tokenURI(uint256 tokenId) external view returns (string memory);
1036 }
1037 
1038 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1039     // Token name
1040     string private _name;
1041 
1042     // Token symbol
1043     string private _symbol;
1044 
1045     /*
1046      *     bytes4(keccak256('name()')) == 0x06fdde03
1047      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1048      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1049      *
1050      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1051      */
1052     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1053 
1054     /**
1055      * @dev Constructor function
1056      */
1057     constructor (string memory name, string memory symbol) public {
1058         _name = name;
1059         _symbol = symbol;
1060 
1061         // register the supported interfaces to conform to ERC721 via ERC165
1062         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1063     }
1064 
1065     /**
1066      * @dev Gets the token name.
1067      * @return string representing the token name
1068      */
1069     function name() external view returns (string memory) {
1070         return _name;
1071     }
1072 
1073     /**
1074      * @dev Gets the token symbol.
1075      * @return string representing the token symbol
1076      */
1077     function symbol() external view returns (string memory) {
1078         return _symbol;
1079     }
1080 }
1081 
1082 /**
1083  * @title Full ERC721 Token
1084  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1085  * Moreover, it includes approve all functionality using operator terminology.
1086  *
1087  * See https://eips.ethereum.org/EIPS/eip-721
1088  */
1089 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1090     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1091         // solhint-disable-previous-line no-empty-blocks
1092     }
1093 }
1094 
1095 contract Ownership is Ownable {
1096     event OwnershipChanged(address indexed owner, uint256 level);
1097     
1098     mapping(address => uint256) internal ownership;
1099 
1100     constructor () internal {
1101         setOwnership(_msgSender(), 1);
1102     }
1103     
1104     function transferOwnership(address newOwner) public onlyOwner {
1105         _transferOwnership(newOwner);
1106         setOwnership(newOwner, 1);
1107     }
1108 
1109     function setOwnership(address key, uint256 level) public onlyOwner {
1110         ownership[key] = level;
1111         emit OwnershipChanged(key, level);
1112     }
1113 
1114     modifier onlyMinter() {
1115         require(isMinter(), "Ownerhsip : caller is not the minter");
1116         _;
1117     }
1118 
1119     function isMinter() public view returns (bool) {
1120         return ownership[_msgSender()] > 0;
1121     }
1122     
1123 }
1124 
1125 library Strings {
1126   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1127   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
1128       bytes memory _ba = bytes(_a);
1129       bytes memory _bb = bytes(_b);
1130       bytes memory _bc = bytes(_c);
1131       bytes memory _bd = bytes(_d);
1132       bytes memory _be = bytes(_e);
1133       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1134       bytes memory babcde = bytes(abcde);
1135       uint k = 0;
1136       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1137       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1138       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1139       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1140       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1141       return string(babcde);
1142     }
1143 
1144     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
1145         return strConcat(_a, _b, _c, _d, "");
1146     }
1147 
1148     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1149         return strConcat(_a, _b, _c, "", "");
1150     }
1151 
1152     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1153         return strConcat(_a, _b, "", "", "");
1154     }
1155 
1156     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1157         if (_i == 0) {
1158             return "0";
1159         }
1160         uint j = _i;
1161         uint len;
1162         while (j != 0) {
1163             len++;
1164             j /= 10;
1165         }
1166         bytes memory bstr = new bytes(len);
1167         uint k = len - 1;
1168         while (_i != 0) {
1169             bstr[k--] = byte(uint8(48 + _i % 10));
1170             _i /= 10;
1171         }
1172         return string(bstr);
1173     }
1174 }
1175 
1176 contract Metadata {
1177     using Strings for string;
1178 
1179     string public baseUri;
1180 
1181     function tokenURI(uint256 _id) external view returns (string memory) {
1182         return Strings.strConcat(baseUri, Strings.uint2str(_id));
1183     }
1184 
1185     function uri(uint256 _id) external view returns (string memory) {
1186         return Strings.strConcat(baseUri, Strings.uint2str(_id));
1187     }
1188 
1189 }
1190 
1191 contract OwnableDelegateProxy {
1192   
1193 }
1194 
1195 contract ProxyRegistry {
1196     mapping(address => OwnableDelegateProxy) public proxies;
1197 }
1198 
1199 contract KingdomLand is ERC721Full, Ownership, Metadata {
1200   ProxyRegistry public proxyRegistry;
1201 
1202   constructor(ProxyRegistry proxy, string memory uri, string memory name, string memory symbol) public ERC721Full(name, symbol) {
1203     proxyRegistry = proxy;
1204     baseUri = uri;
1205   }
1206 
1207   function setBaseURI(string memory uri) public onlyOwner {
1208     baseUri = uri;
1209   }
1210 
1211   function mint(address to, uint256 tokenId) public onlyMinter {
1212     _mint(to, tokenId);
1213   }
1214 
1215   function isApprovedForAll(address owner, address operator) public view returns (bool){
1216     if (address(proxyRegistry.proxies(owner)) == operator)
1217         return true;
1218     return super.isApprovedForAll(owner, operator);
1219   }
1220 
1221   function allTokens() public view returns (uint256[] memory){
1222     return _allTokens;
1223   }
1224 
1225   function getTokens(uint256 start, uint256 end) public view returns (uint256[] memory) {
1226     if(end <= start || _allTokens.length <= start)
1227       return new uint256[](0);
1228     uint256 length = end-start;
1229     if(end > _allTokens.length)
1230       length = _allTokens.length-start;
1231     uint256[] memory outputs = new uint256[](length);
1232     for (uint256 i = 0; i < length; ++i) {
1233         outputs[i] = _allTokens[start+i];
1234     }
1235     return outputs;
1236   }
1237   
1238   function ownedTokens(address owner) public view returns (uint256[] memory){
1239     return _ownedTokens[owner];
1240   }
1241 }
1242 
1243 // https://github.com/ethereum/EIPs/issues/20
1244 interface IERC20 {
1245     function transfer(address _to, uint _value) external returns (bool success);
1246     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
1247     function approve(address _spender, uint _value) external returns (bool success);
1248     function totalSupply() external view returns (uint supply);
1249     function balanceOf(address _owner) external view returns (uint balance);
1250     function allowance(address _owner, address _spender) external view returns (uint remaining);
1251     function decimals() external view returns(uint digits);
1252     event Approval(address indexed _owner, address indexed _spender, uint _value);
1253 }
1254 
1255 contract LOKLandSaleSecond is Ownable {
1256     struct Range {
1257         uint256 min;
1258         uint256 max;
1259     }
1260     struct Dutch {
1261         uint256 min;
1262         uint256 max;
1263         uint256 discount;
1264         uint256 term;
1265     }
1266 
1267     IERC20 private loka;
1268     KingdomLand private land;
1269 
1270     mapping(address => uint256) private lokas;
1271     mapping(address => uint256) private whitelist;
1272 
1273     uint256[] internal prices; //dollar
1274     uint256[] internal counts;
1275     uint256[] internal limits;
1276 
1277     uint256 internal ethExchange;
1278     uint256 internal lokaExchange;
1279 
1280     Range private duration;
1281     Range private guild;
1282     Dutch private dutch;
1283     address payable private receiver;
1284     address private tokenReceiver;
1285 
1286     constructor(KingdomLand _land, IERC20 _loka, uint256 start, uint256[] memory ls, uint256[] memory cs, uint256[] memory ps) public {
1287         setLand(_land);
1288         setLoka(_loka);
1289         uint256 DAY = 86400;
1290         setDuration(start, start + DAY * 7);
1291         setGuildRound(start + DAY * 2, start + DAY * 3);
1292         setDutch(1000, 7000, 125, 3600);
1293         setLimits(ls);
1294         setCounts(cs);
1295         setPrices(ps);
1296 
1297         setReceiver(_msgSender());
1298         setTokenReceiver(_msgSender());
1299     }
1300 
1301     function() external payable {}
1302 
1303 function setWhitelist(address[] memory addrs, uint256[] memory values) public onlyOwner
1304     {
1305         for (uint256 i = 0; i < addrs.length; ++i) {
1306             whitelist[addrs[i]] = values[i];
1307         }
1308     }
1309 
1310 function getWhitelist(address addr) public view returns (uint256 count) {
1311         return whitelist[addr];
1312     }
1313 
1314 function setLand(KingdomLand _land) public onlyOwner {
1315         land = _land;
1316     }
1317 
1318 function setDutch(uint256 min, uint256 max, uint256 discount, uint256 term) public onlyOwner {
1319         dutch.min = min;
1320         dutch.max = max;
1321         dutch.discount = discount;
1322         dutch.term = term;
1323     }
1324 
1325 function setDuration(uint256 min, uint256 max) public onlyOwner {
1326         duration.min = min;
1327         duration.max = max;
1328     }
1329 
1330 function setGuildRound(uint256 min, uint256 max) public onlyOwner {
1331         guild.min = min;
1332         guild.max = max;
1333     }
1334 
1335 function setLimits(uint256[] memory values) public onlyOwner {
1336         limits = values;
1337     }
1338 
1339 function setCounts(uint256[] memory values) public onlyOwner {
1340         counts = values;
1341     }
1342 
1343 function setPrices(uint256[] memory values) public onlyOwner {
1344         prices = values;
1345     }
1346 
1347 function setEthExchange(uint256 ex) public onlyOwner {
1348         ethExchange = ex;
1349     }
1350 
1351 function setLokaExchange(uint256 ex) public onlyOwner {
1352         lokaExchange = ex;
1353     }
1354 
1355 function setLoka(IERC20 addr) public onlyOwner {
1356         loka = addr;
1357     }
1358 
1359 function inDurationRange() public view returns (bool) {
1360         uint256 value = getTimestamp();
1361         return value > duration.min && value < duration.max;
1362     }
1363 
1364 function inGuildRound() public view returns (bool) {
1365         uint256 value = getTimestamp();
1366         return value > guild.min && value < guild.max;
1367     }
1368 
1369 function getCounts() public view returns (uint256[] memory) {
1370         return counts;
1371     }
1372 
1373 function getLimits() public view returns (uint256[] memory) {
1374         return limits;
1375     }
1376 
1377 function getRemains() public view returns (uint256[] memory) {
1378         uint256[] memory outputs = new uint256[](limits.length);
1379         for (uint256 i = 0; i < limits.length; ++i) {
1380             outputs[i] = limits[i] - counts[i];
1381         }
1382         return outputs;
1383     }
1384 
1385 function getLokaExchange() public view returns (uint256) {
1386         return lokaExchange;
1387     }
1388 
1389 function getEthExchange() public view returns (uint256) {
1390         return ethExchange;
1391     }
1392 
1393 function rate() public view returns (uint256) {
1394         uint256 time = getTimestamp();
1395         if (duration.min >= time) return 0;
1396         uint256 step = (time - duration.min) / dutch.term;
1397         uint256 discount = step * dutch.discount;
1398         if ((dutch.min + discount) >= dutch.max) return dutch.min;
1399         return dutch.max - discount;
1400     }
1401 
1402 function distance(uint256 px, uint256 py, uint256 c) internal pure returns (uint256) {
1403         return max(round(px, c), round(py, c));
1404     }
1405 
1406 function max(uint256 a, uint256 b) internal pure returns (uint256) {
1407         return a >= b ? a : b;
1408     }
1409 
1410 function round(uint256 a, uint256 b) internal pure returns (uint256) {
1411         return a < b ? (b - a - 1) : (a - b);
1412     }
1413 
1414 function rankByDistance(uint256 dc) internal pure returns (uint256) {
1415         if (dc >= 98) return 1;
1416         if (dc >= 68) return 2;
1417         if (dc >= 38) return 3;
1418         if (dc >= 24) return 4;
1419         if (dc >= 12) return 5;
1420         return 6;
1421     }
1422 
1423 function rankByShrine(uint256 px, uint256 py, uint256 dc) internal pure returns (uint256) {
1424         uint256 pros = 5 - dc / 32;
1425         if (pros <= 2) return 1;
1426         uint256 m = 2 * distance(px % 32, py % 32, 16) + 1;
1427         return pros - (m / 2 / (pros + 6));
1428     }
1429 
1430 function rankByPos(uint256 px, uint256 py) internal pure returns (uint256) {
1431         uint256 dc = distance(px, py, 128);
1432         return max(rankByDistance(dc), rankByShrine(px, py, dc));
1433     }
1434 
1435 function getRank(uint256 id) public pure returns (uint256) {
1436         if (id < 100000 || id > 165535)
1437             return 0;
1438         uint256 index = id % 100000;
1439         uint256 px = index % 256;
1440         uint256 py = index / 256;
1441         if (py < 128)
1442             return 0;
1443         return rankByPos(px, py);
1444     }
1445 
1446 function mint(address to, uint256 tokenId) internal {
1447         land.mint(to, tokenId);
1448         uint256 rank = getRank(tokenId);
1449         counts[rank]++;
1450     }
1451 
1452 function computePrice(uint256[] memory landIds) public view returns (uint256)
1453     {
1454         uint256 price = 0;
1455         uint256[] memory rankCounts = new uint256[](10);
1456         for (uint256 i = 0; i < landIds.length; ++i) {
1457             uint256 landId = landIds[i];
1458             require(land.ownerOf(landId) == address(0), "This land is already sold");
1459             uint256 rank = getRank(landId);
1460             require(rank > 0, "This land is unavailable");
1461             price += prices[rank];
1462             rankCounts[rank]++;
1463         }
1464         for (uint256 i = 0; i < rankCounts.length; ++i) {
1465             if (rankCounts[i] > 0) {
1466                 require(counts[i] + rankCounts[i] <= limits[i], "No more of the land available");
1467             }
1468         }
1469         return price * rate() / dutch.min;
1470     }
1471 
1472 function buyLandsByLOKA(uint256[] memory landIds, uint256 value) public {
1473         checkCondition(landIds.length);
1474 
1475         uint256 usd = computePrice(landIds);
1476         uint256 price = usd * lokaExchange;
1477         require(usd > 0, "Incorrect amount paid");
1478         require(price > 0, "Incorrect amount paid");
1479         require(value >= price, "Incorrect amount paid");
1480         require(loka.balanceOf(_msgSender())>=price, "Incorrect amount paid");
1481         require(loka.allowance(_msgSender(), address(this))>=price, "Incorrect amount paid");
1482         loka.transferFrom(_msgSender(), tokenReceiver, price);
1483         mintLands(landIds);
1484         lokas[_msgSender()] += usd;
1485     }
1486 
1487 function buyLands(uint256[] memory landIds) public payable {
1488         checkCondition(landIds.length);
1489 
1490         uint256 price = computePrice(landIds) * ethExchange;
1491         require(msg.value >= price, "Incorrect amount paid");
1492         mintLands(landIds);
1493     }
1494 
1495 function checkCondition(uint256 count) internal {
1496         require(count > 0, "Please select land");
1497         require(inDurationRange(), "Only available during sales period");
1498         //길드 라운드이면 길드 화이트 리스트만
1499         if (inGuildRound()) {
1500             require(whitelist[_msgSender()] >= count, "No more of the land available");
1501             whitelist[_msgSender()] -= count;
1502         }
1503     }
1504 
1505 function mintLands(uint256[] memory landIds) internal {
1506         for (uint256 i = 0; i < landIds.length; ++i) {
1507             mint(_msgSender(), landIds[i]);
1508         }
1509     }
1510 
1511 function setReceiver(address payable r) public onlyOwner {
1512         receiver = r;
1513     }
1514 
1515 function setTokenReceiver(address r) public onlyOwner {
1516         tokenReceiver = r;
1517     }
1518 
1519 function withdraw() public {
1520         require(_msgSender() == receiver || _msgSender() == owner(), "Incorrect address");
1521         receiver.transfer(address(this).balance);
1522     }
1523 
1524 function ownersOf(uint256[] memory landIds) public view returns (address[] memory)
1525     {
1526         address[] memory owners = new address[](landIds.length);
1527         for (uint256 i = 0; i < landIds.length; ++i) {
1528             owners[i] = land.ownerOf(landIds[i]);
1529         }
1530         return owners;
1531     }
1532 
1533 function ownersOfRange(uint256 start, uint256 end) public view returns (address[] memory)
1534     {
1535         address[] memory owners = new address[](end - start);
1536         for (uint256 i = start; i < end; ++i) {
1537             owners[i - start] = land.ownerOf(i);
1538         }
1539         return owners;
1540     }
1541 
1542 function getRanks(uint256[] memory landIds) public pure returns (uint256[] memory)
1543     {
1544         uint256[] memory outputs = new uint256[](landIds.length);
1545         for (uint256 i = 0; i < landIds.length; ++i) {
1546             outputs[i] = getRank(landIds[i]);
1547         }
1548         return outputs;
1549     }
1550 
1551 function getRankRange(uint256 start, uint256 end) public pure returns (uint256[] memory)
1552     {
1553         uint256 length = end - start;
1554         uint256[] memory outputs = new uint256[](length + 1);
1555         for (uint256 i = 0; i <= length; ++i) {
1556             outputs[i] = getRank(i + start);
1557         }
1558         return outputs;
1559     }
1560 
1561 function getLokaSpent(address addr) public view returns (uint256 amount) {
1562         return lokas[addr];
1563     }
1564 
1565 function getTimestamp() public view returns (uint256 amount) {
1566         return block.timestamp;
1567     }
1568 }