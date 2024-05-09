1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Contract module which provides a basic access control mechanism, where
5  * there is an account (an owner) that can be granted exclusive access to
6  * specific functions.
7  *
8  * This module is used through inheritance. It will make available the modifier
9  * `onlyOwner`, which can be aplied to your functions to restrict their use to
10  * the owner.
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Initializes the contract setting the deployer as the initial owner.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Returns true if the caller is the current owner.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * > Note: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 /**
78  * @dev Interface of the ERC165 standard, as defined in the
79  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
80  *
81  * Implementers can declare support of contract interfaces, which can then be
82  * queried by others (`ERC165Checker`).
83  *
84  * For an implementation, see `ERC165`.
85  */
86 interface IERC165 {
87     /**
88      * @dev Returns true if this contract implements the interface defined by
89      * `interfaceId`. See the corresponding
90      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
91      * to learn more about how these ids are created.
92      *
93      * This function call must use less than 30 000 gas.
94      */
95     function supportsInterface(bytes4 interfaceId) external view returns (bool);
96 }
97 
98 /**
99  * @dev Required interface of an ERC721 compliant contract.
100  */
101 contract IERC721 is IERC165 {
102     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
103     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
104     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
105 
106     /**
107      * @dev Returns the number of NFTs in `owner`'s account.
108      */
109     function balanceOf(address owner) public view returns (uint256 balance);
110 
111     /**
112      * @dev Returns the owner of the NFT specified by `tokenId`.
113      */
114     function ownerOf(uint256 tokenId) public view returns (address owner);
115 
116     /**
117      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
118      * another (`to`).
119      *
120      * 
121      *
122      * Requirements:
123      * - `from`, `to` cannot be zero.
124      * - `tokenId` must be owned by `from`.
125      * - If the caller is not `from`, it must be have been allowed to move this
126      * NFT by either `approve` or `setApproveForAll`.
127      */
128     function safeTransferFrom(address from, address to, uint256 tokenId) public;
129     /**
130      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
131      * another (`to`).
132      *
133      * Requirements:
134      * - If the caller is not `from`, it must be approved to move this NFT by
135      * either `approve` or `setApproveForAll`.
136      */
137     function transferFrom(address from, address to, uint256 tokenId) public;
138     function approve(address to, uint256 tokenId) public;
139     function getApproved(uint256 tokenId) public view returns (address operator);
140 
141     function setApprovalForAll(address operator, bool _approved) public;
142     function isApprovedForAll(address owner, address operator) public view returns (bool);
143 
144 
145     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
146 }
147 
148 /**
149  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
150  * @dev See https://eips.ethereum.org/EIPS/eip-721
151  */
152 contract IERC721Metadata is IERC721 {
153     function name() external view returns (string memory);
154     function symbol() external view returns (string memory);
155     function tokenURI(uint256 tokenId) external view returns (string memory);
156 }
157 
158 /**
159  * @title ERC721 token receiver interface
160  * @dev Interface for any contract that wants to support safeTransfers
161  * from ERC721 asset contracts.
162  */
163 contract IERC721Receiver {
164     /**
165      * @notice Handle the receipt of an NFT
166      * @dev The ERC721 smart contract calls this function on the recipient
167      * after a `safeTransfer`. This function MUST return the function selector,
168      * otherwise the caller will revert the transaction. The selector to be
169      * returned can be obtained as `this.onERC721Received.selector`. This
170      * function MAY throw to revert and reject the transfer.
171      * Note: the ERC721 contract address is always the message sender.
172      * @param operator The address which called `safeTransferFrom` function
173      * @param from The address which previously owned the token
174      * @param tokenId The NFT identifier which is being transferred
175      * @param data Additional data with no specified format
176      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
177      */
178     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
179     public returns (bytes4);
180 }
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
222         require(b <= a, "SafeMath: subtraction overflow");
223         uint256 c = a - b;
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the multiplication of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `*` operator.
233      *
234      * Requirements:
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239         // benefit is lost if 'b' is also tested.
240         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
241         if (a == 0) {
242             return 0;
243         }
244 
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         // Solidity only automatically asserts when dividing by 0
264         require(b > 0, "SafeMath: division by zero");
265         uint256 c = a / b;
266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b != 0, "SafeMath: modulo by zero");
284         return a % b;
285     }
286 }
287 
288 /**
289  * @dev Collection of functions related to the address type,
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * This test is non-exhaustive, and there may be false-negatives: during the
296      * execution of a contract's constructor, its address will be reported as
297      * not containing a contract.
298      *
299      * > It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies in extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { size := extcodesize(account) }
310         return size > 0;
311     }
312 }
313 
314 /**
315  * @title Counters
316  * @author Matt Condon (@shrugs)
317  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
318  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
319  *
320  * Include with `using Counters for Counters.Counter;`
321  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
322  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
323  * directly accessed.
324  */
325 library Counters {
326     using SafeMath for uint256;
327 
328     struct Counter {
329         // This variable should never be directly accessed by users of the library: interactions must be restricted to
330         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
331         // this feature: see https://github.com/ethereum/solidity/issues/4637
332         uint256 _value; // default: 0
333     }
334 
335     function current(Counter storage counter) internal view returns (uint256) {
336         return counter._value;
337     }
338 
339     function increment(Counter storage counter) internal {
340         counter._value += 1;
341     }
342 
343     function decrement(Counter storage counter) internal {
344         counter._value = counter._value.sub(1);
345     }
346 }
347 
348 /**
349  * @dev Implementation of the `IERC165` interface.
350  *
351  * Contracts may inherit from this and call `_registerInterface` to declare
352  * their support of an interface.
353  */
354 contract ERC165 is IERC165 {
355     /*
356      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
357      */
358     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
359 
360     /**
361      * @dev Mapping of interface ids to whether or not it's supported.
362      */
363     mapping(bytes4 => bool) private _supportedInterfaces;
364 
365     constructor () internal {
366         // Derived contracts need only register support for their own interfaces,
367         // we register support for ERC165 itself here
368         _registerInterface(_INTERFACE_ID_ERC165);
369     }
370 
371     /**
372      * @dev See `IERC165.supportsInterface`.
373      *
374      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
375      */
376     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
377         return _supportedInterfaces[interfaceId];
378     }
379 
380     /**
381      * @dev Registers the contract as an implementer of the interface defined by
382      * `interfaceId`. Support of the actual ERC165 interface is automatic and
383      * registering its interface id is not required.
384      *
385      * See `IERC165.supportsInterface`.
386      *
387      * Requirements:
388      *
389      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
390      */
391     function _registerInterface(bytes4 interfaceId) internal {
392         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
393         _supportedInterfaces[interfaceId] = true;
394     }
395 }
396 
397 /**
398  * @title ERC721 Non-Fungible Token Standard basic implementation
399  * @dev see https://eips.ethereum.org/EIPS/eip-721
400  */
401 contract ERC721 is ERC165, IERC721 {
402     using SafeMath for uint256;
403     using Address for address;
404     using Counters for Counters.Counter;
405 
406     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
407     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
408     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
409 
410     // Mapping from token ID to owner
411     mapping (uint256 => address) private _tokenOwner;
412 
413     // Mapping from token ID to approved address
414     mapping (uint256 => address) private _tokenApprovals;
415 
416     // Mapping from owner to number of owned token
417     mapping (address => Counters.Counter) private _ownedTokensCount;
418 
419     // Mapping from owner to operator approvals
420     mapping (address => mapping (address => bool)) private _operatorApprovals;
421 
422     /*
423      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
424      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
425      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
426      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
427      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
428      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
429      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
430      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
431      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
432      *
433      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
434      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
435      */
436     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
437 
438     constructor () public {
439         // register the supported interfaces to conform to ERC721 via ERC165
440         _registerInterface(_INTERFACE_ID_ERC721);
441     }
442 
443     /**
444      * @dev Gets the balance of the specified address.
445      * @param owner address to query the balance of
446      * @return uint256 representing the amount owned by the passed address
447      */
448     function balanceOf(address owner) public view returns (uint256) {
449         require(owner != address(0), "ERC721: balance query for the zero address");
450 
451         return _ownedTokensCount[owner].current();
452     }
453 
454     /**
455      * @dev Gets the owner of the specified token ID.
456      * @param tokenId uint256 ID of the token to query the owner of
457      * @return address currently marked as the owner of the given token ID
458      */
459     function ownerOf(uint256 tokenId) public view returns (address) {
460         address owner = _tokenOwner[tokenId];
461         require(owner != address(0), "ERC721: owner query for nonexistent token");
462 
463         return owner;
464     }
465 
466     /**
467      * @dev Approves another address to transfer the given token ID
468      * The zero address indicates there is no approved address.
469      * There can only be one approved address per token at a given time.
470      * Can only be called by the token owner or an approved operator.
471      * @param to address to be approved for the given token ID
472      * @param tokenId uint256 ID of the token to be approved
473      */
474     function approve(address to, uint256 tokenId) public {
475         address owner = ownerOf(tokenId);
476         require(to != owner, "ERC721: approval to current owner");
477 
478         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
479             "ERC721: approve caller is not owner nor approved for all"
480         );
481 
482         _tokenApprovals[tokenId] = to;
483         emit Approval(owner, to, tokenId);
484     }
485 
486     /**
487      * @dev Gets the approved address for a token ID, or zero if no address set
488      * Reverts if the token ID does not exist.
489      * @param tokenId uint256 ID of the token to query the approval of
490      * @return address currently approved for the given token ID
491      */
492     function getApproved(uint256 tokenId) public view returns (address) {
493         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
494 
495         return _tokenApprovals[tokenId];
496     }
497 
498     /**
499      * @dev Sets or unsets the approval of a given operator
500      * An operator is allowed to transfer all tokens of the sender on their behalf.
501      * @param to operator address to set the approval
502      * @param approved representing the status of the approval to be set
503      */
504     function setApprovalForAll(address to, bool approved) public {
505         require(to != msg.sender, "ERC721: approve to caller");
506 
507         _operatorApprovals[msg.sender][to] = approved;
508         emit ApprovalForAll(msg.sender, to, approved);
509     }
510 
511     /**
512      * @dev Tells whether an operator is approved by a given owner.
513      * @param owner owner address which you want to query the approval of
514      * @param operator operator address which you want to query the approval of
515      * @return bool whether the given operator is approved by the given owner
516      */
517     function isApprovedForAll(address owner, address operator) public view returns (bool) {
518         return _operatorApprovals[owner][operator];
519     }
520 
521     /**
522      * @dev Transfers the ownership of a given token ID to another address.
523      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
524      * Requires the msg.sender to be the owner, approved, or operator.
525      * @param from current owner of the token
526      * @param to address to receive the ownership of the given token ID
527      * @param tokenId uint256 ID of the token to be transferred
528      */
529     function transferFrom(address from, address to, uint256 tokenId) public {
530         //solhint-disable-next-line max-line-length
531         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
532 
533         _transferFrom(from, to, tokenId);
534     }
535 
536     /**
537      * @dev Safely transfers the ownership of a given token ID to another address
538      * If the target address is a contract, it must implement `onERC721Received`,
539      * which is called upon a safe transfer, and return the magic value
540      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
541      * the transfer is reverted.
542      * Requires the msg.sender to be the owner, approved, or operator
543      * @param from current owner of the token
544      * @param to address to receive the ownership of the given token ID
545      * @param tokenId uint256 ID of the token to be transferred
546      */
547     function safeTransferFrom(address from, address to, uint256 tokenId) public {
548         safeTransferFrom(from, to, tokenId, "");
549     }
550 
551     /**
552      * @dev Safely transfers the ownership of a given token ID to another address
553      * If the target address is a contract, it must implement `onERC721Received`,
554      * which is called upon a safe transfer, and return the magic value
555      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
556      * the transfer is reverted.
557      * Requires the msg.sender to be the owner, approved, or operator
558      * @param from current owner of the token
559      * @param to address to receive the ownership of the given token ID
560      * @param tokenId uint256 ID of the token to be transferred
561      * @param _data bytes data to send along with a safe transfer check
562      */
563     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
564         transferFrom(from, to, tokenId);
565         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
566     }
567 
568     /**
569      * @dev Returns whether the specified token exists.
570      * @param tokenId uint256 ID of the token to query the existence of
571      * @return bool whether the token exists
572      */
573     function _exists(uint256 tokenId) internal view returns (bool) {
574         address owner = _tokenOwner[tokenId];
575         return owner != address(0);
576     }
577 
578     /**
579      * @dev Returns whether the given spender can transfer a given token ID.
580      * @param spender address of the spender to query
581      * @param tokenId uint256 ID of the token to be transferred
582      * @return bool whether the msg.sender is approved for the given token ID,
583      * is an operator of the owner, or is the owner of the token
584      */
585     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
586         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
587         address owner = ownerOf(tokenId);
588         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
589     }
590 
591     /**
592      * @dev Internal function to mint a new token.
593      * Reverts if the given token ID already exists.
594      * @param to The address that will own the minted token
595      * @param tokenId uint256 ID of the token to be minted
596      */
597     function _mint(address to, uint256 tokenId) internal {
598         require(to != address(0), "ERC721: mint to the zero address");
599         require(!_exists(tokenId), "ERC721: token already minted");
600 
601         _tokenOwner[tokenId] = to;
602         _ownedTokensCount[to].increment();
603 
604         emit Transfer(address(0), to, tokenId);
605     }
606 
607     /**
608      * @dev Internal function to burn a specific token.
609      * Reverts if the token does not exist.
610      * Deprecated, use _burn(uint256) instead.
611      * @param owner owner of the token to burn
612      * @param tokenId uint256 ID of the token being burned
613      */
614     function _burn(address owner, uint256 tokenId) internal {
615         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
616 
617         _clearApproval(tokenId);
618 
619         _ownedTokensCount[owner].decrement();
620         _tokenOwner[tokenId] = address(0);
621 
622         emit Transfer(owner, address(0), tokenId);
623     }
624 
625     /**
626      * @dev Internal function to burn a specific token.
627      * Reverts if the token does not exist.
628      * @param tokenId uint256 ID of the token being burned
629      */
630     function _burn(uint256 tokenId) internal {
631         _burn(ownerOf(tokenId), tokenId);
632     }
633 
634     /**
635      * @dev Internal function to transfer ownership of a given token ID to another address.
636      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
637      * @param from current owner of the token
638      * @param to address to receive the ownership of the given token ID
639      * @param tokenId uint256 ID of the token to be transferred
640      */
641     function _transferFrom(address from, address to, uint256 tokenId) internal {
642         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
643         require(to != address(0), "ERC721: transfer to the zero address");
644 
645         _clearApproval(tokenId);
646 
647         _ownedTokensCount[from].decrement();
648         _ownedTokensCount[to].increment();
649 
650         _tokenOwner[tokenId] = to;
651 
652         emit Transfer(from, to, tokenId);
653     }
654 
655     /**
656      * @dev Internal function to invoke `onERC721Received` on a target address.
657      * The call is not executed if the target address is not a contract.
658      *
659      * This function is deprecated.
660      * @param from address representing the previous owner of the given token ID
661      * @param to target address that will receive the tokens
662      * @param tokenId uint256 ID of the token to be transferred
663      * @param _data bytes optional data to send along with the call
664      * @return bool whether the call correctly returned the expected magic value
665      */
666     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
667         internal returns (bool)
668     {
669         if (!to.isContract()) {
670             return true;
671         }
672 
673         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
674         return (retval == _ERC721_RECEIVED);
675     }
676 
677     /**
678      * @dev Private function to clear current approval of a given token ID.
679      * @param tokenId uint256 ID of the token to be transferred
680      */
681     function _clearApproval(uint256 tokenId) private {
682         if (_tokenApprovals[tokenId] != address(0)) {
683             _tokenApprovals[tokenId] = address(0);
684         }
685     }
686 }
687 
688 /**
689  * @title ERC721 Burnable Token
690  * @dev ERC721 Token that can be irreversibly burned (destroyed).
691  */
692 contract ERC721Burnable is ERC721 {
693     /**
694      * @dev Burns a specific ERC721 token.
695      * @param tokenId uint256 id of the ERC721 token to be burned.
696      */
697     function burn(uint256 tokenId) public {
698         //solhint-disable-next-line max-line-length
699         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
700         _burn(tokenId);
701     }
702 }
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 contract IERC721Enumerable is IERC721 {
709     function totalSupply() public view returns (uint256);
710     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
711 
712     function tokenByIndex(uint256 index) public view returns (uint256);
713 }
714 
715 /**
716  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
720     // Mapping from owner to list of owned token IDs
721     mapping(address => uint256[]) private _ownedTokens;
722 
723     // Mapping from token ID to index of the owner tokens list
724     mapping(uint256 => uint256) private _ownedTokensIndex;
725 
726     // Array with all token ids, used for enumeration
727     uint256[] private _allTokens;
728 
729     // Mapping from token id to position in the allTokens array
730     mapping(uint256 => uint256) private _allTokensIndex;
731 
732     /*
733      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
734      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
735      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
736      *
737      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
738      */
739     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
740 
741     /**
742      * @dev Constructor function.
743      */
744     constructor () public {
745         // register the supported interface to conform to ERC721Enumerable via ERC165
746         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
747     }
748 
749     /**
750      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
751      * @param owner address owning the tokens list to be accessed
752      * @param index uint256 representing the index to be accessed of the requested tokens list
753      * @return uint256 token ID at the given index of the tokens list owned by the requested address
754      */
755     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
756         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
757         return _ownedTokens[owner][index];
758     }
759 
760     /**
761      * @dev Gets the total amount of tokens stored by the contract.
762      * @return uint256 representing the total amount of tokens
763      */
764     function totalSupply() public view returns (uint256) {
765         return _allTokens.length;
766     }
767 
768     /**
769      * @dev Gets the token ID at a given index of all the tokens in this contract
770      * Reverts if the index is greater or equal to the total number of tokens.
771      * @param index uint256 representing the index to be accessed of the tokens list
772      * @return uint256 token ID at the given index of the tokens list
773      */
774     function tokenByIndex(uint256 index) public view returns (uint256) {
775         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
776         return _allTokens[index];
777     }
778 
779     /**
780      * @dev Internal function to transfer ownership of a given token ID to another address.
781      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
782      * @param from current owner of the token
783      * @param to address to receive the ownership of the given token ID
784      * @param tokenId uint256 ID of the token to be transferred
785      */
786     function _transferFrom(address from, address to, uint256 tokenId) internal {
787         super._transferFrom(from, to, tokenId);
788 
789         _removeTokenFromOwnerEnumeration(from, tokenId);
790 
791         _addTokenToOwnerEnumeration(to, tokenId);
792     }
793 
794     /**
795      * @dev Internal function to mint a new token.
796      * Reverts if the given token ID already exists.
797      * @param to address the beneficiary that will own the minted token
798      * @param tokenId uint256 ID of the token to be minted
799      */
800     function _mint(address to, uint256 tokenId) internal {
801         super._mint(to, tokenId);
802 
803         _addTokenToOwnerEnumeration(to, tokenId);
804 
805         _addTokenToAllTokensEnumeration(tokenId);
806     }
807 
808     /**
809      * @dev Internal function to burn a specific token.
810      * Reverts if the token does not exist.
811      * Deprecated, use _burn(uint256) instead.
812      * @param owner owner of the token to burn
813      * @param tokenId uint256 ID of the token being burned
814      */
815     function _burn(address owner, uint256 tokenId) internal {
816         super._burn(owner, tokenId);
817 
818         _removeTokenFromOwnerEnumeration(owner, tokenId);
819         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
820         _ownedTokensIndex[tokenId] = 0;
821 
822         _removeTokenFromAllTokensEnumeration(tokenId);
823     }
824 
825     /**
826      * @dev Gets the list of token IDs of the requested owner.
827      * @param owner address owning the tokens
828      * @return uint256[] List of token IDs owned by the requested address
829      */
830     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
831         return _ownedTokens[owner];
832     }
833 
834     /**
835      * @dev Private function to add a token to this extension's ownership-tracking data structures.
836      * @param to address representing the new owner of the given token ID
837      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
838      */
839     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
840         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
841         _ownedTokens[to].push(tokenId);
842     }
843 
844     /**
845      * @dev Private function to add a token to this extension's token tracking data structures.
846      * @param tokenId uint256 ID of the token to be added to the tokens list
847      */
848     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
849         _allTokensIndex[tokenId] = _allTokens.length;
850         _allTokens.push(tokenId);
851     }
852 
853     /**
854      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
855      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
856      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
857      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
858      * @param from address representing the previous owner of the given token ID
859      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
860      */
861     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
862         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
863         // then delete the last slot (swap and pop).
864 
865         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
866         uint256 tokenIndex = _ownedTokensIndex[tokenId];
867 
868         // When the token to delete is the last token, the swap operation is unnecessary
869         if (tokenIndex != lastTokenIndex) {
870             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
871 
872             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
873             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
874         }
875 
876         // This also deletes the contents at the last position of the array
877         _ownedTokens[from].length--;
878 
879         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
880         // lastTokenId, or just over the end of the array if the token was the last one).
881     }
882 
883     /**
884      * @dev Private function to remove a token from this extension's token tracking data structures.
885      * This has O(1) time complexity, but alters the order of the _allTokens array.
886      * @param tokenId uint256 ID of the token to be removed from the tokens list
887      */
888     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
889         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
890         // then delete the last slot (swap and pop).
891 
892         uint256 lastTokenIndex = _allTokens.length.sub(1);
893         uint256 tokenIndex = _allTokensIndex[tokenId];
894 
895         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
896         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
897         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
898         uint256 lastTokenId = _allTokens[lastTokenIndex];
899 
900         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
901         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
902 
903         // This also deletes the contents at the last position of the array
904         _allTokens.length--;
905         _allTokensIndex[tokenId] = 0;
906     }
907 }
908 
909 /**
910  * @title Full ERC721 Token with support for tokenURIPrefix
911  * This implementation includes all the required and some optional functionality of the ERC721 standard
912  * Moreover, it includes approve all functionality using operator terminology
913  * @dev see https://eips.ethereum.org/EIPS/eip-721
914  */
915 contract ERC721Base is ERC721, ERC721Enumerable {
916     // Token name
917     string public name;
918 
919     // Token symbol
920     string public symbol;
921 
922     //Token URI prefix
923     string public tokenURIPrefix;
924 
925     // Optional mapping for token URIs
926     mapping(uint256 => string) private _tokenURIs;
927 
928     /*
929      *     bytes4(keccak256('name()')) == 0x06fdde03
930      *     bytes4(keccak256('symbol()')) == 0x95d89b41
931      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
932      *
933      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
934      */
935     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
936 
937     /**
938      * @dev Constructor function
939      */
940     constructor (string memory _name, string memory _symbol, string memory _tokenURIPrefix) public {
941         name = _name;
942         symbol = _symbol;
943         tokenURIPrefix = _tokenURIPrefix;
944 
945         // register the supported interfaces to conform to ERC721 via ERC165
946         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
947     }
948 
949     /**
950      * @dev Internal function to set the token URI prefix.
951      * @param _tokenURIPrefix string URI prefix to assign
952      */
953     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
954         tokenURIPrefix = _tokenURIPrefix;
955     }
956 
957     /**
958      * @dev Returns an URI for a given token ID.
959      * Throws if the token ID does not exist. May return an empty string.
960      * @param tokenId uint256 ID of the token to query
961      */
962     function tokenURI(uint256 tokenId) external view returns (string memory) {
963         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
964         return strConcat(tokenURIPrefix, _tokenURIs[tokenId]);
965     }
966 
967     /**
968      * @dev Internal function to set the token URI for a given token.
969      * Reverts if the token ID does not exist.
970      * @param tokenId uint256 ID of the token to set its URI
971      * @param uri string URI to assign
972      */
973     function _setTokenURI(uint256 tokenId, string memory uri) internal {
974         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
975         _tokenURIs[tokenId] = uri;
976     }
977 
978     /**
979      * @dev Internal function to burn a specific token.
980      * Reverts if the token does not exist.
981      * Deprecated, use _burn(uint256) instead.
982      * @param owner owner of the token to burn
983      * @param tokenId uint256 ID of the token being burned by the msg.sender
984      */
985     function _burn(address owner, uint256 tokenId) internal {
986         super._burn(owner, tokenId);
987 
988         // Clear metadata (if any)
989         if (bytes(_tokenURIs[tokenId]).length != 0) {
990             delete _tokenURIs[tokenId];
991         }
992     }
993 
994     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
995         bytes memory _ba = bytes(_a);
996         bytes memory _bb = bytes(_b);
997         bytes memory bab = new bytes(_ba.length + _bb.length);
998         uint k = 0;
999         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1000         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1001         return string(bab);
1002     }
1003 }
1004 
1005 /**
1006  * @title MintableToken
1007  * @dev anyone can mint token.
1008  */
1009 contract MintableToken is Ownable, IERC721, IERC721Metadata, ERC721Burnable, ERC721Base {
1010 
1011     constructor (string memory name, string memory symbol, string memory tokenURIPrefix) public ERC721Base(name, symbol, tokenURIPrefix) {
1012 
1013     }
1014 
1015     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, string memory tokenURI) public {
1016         require(owner() == ecrecover(keccak256(abi.encodePacked(tokenId)), v, r, s), "owner should sign tokenId");
1017         _mint(msg.sender, tokenId);
1018         _setTokenURI(tokenId, tokenURI);
1019     }
1020 
1021     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1022         _setTokenURIPrefix(tokenURIPrefix);
1023     }
1024 }