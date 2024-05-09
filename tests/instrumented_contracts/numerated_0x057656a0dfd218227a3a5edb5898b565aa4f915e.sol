1 /**
2 Copyright (C) 2020 Asynchronous Art, Inc.
3 GNU General Public License v3.0
4 Full notice https://github.com/asyncart/async-contracts/blob/master/LICENSE
5 */
6 
7 pragma solidity ^0.5.12;
8 
9 
10 interface IERC165 {
11     /**
12      * @dev Returns true if this contract implements the interface defined by
13      * `interfaceId`. See the corresponding
14      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
15      * to learn more about how these ids are created.
16      *
17      * This function call must use less than 30 000 gas.
18      */
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 
22 contract IERC721 is IERC165 {
23     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
24     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26 
27     /**
28      * @dev Returns the number of NFTs in `owner`'s account.
29      */
30     function balanceOf(address owner) public view returns (uint256 balance);
31 
32     /**
33      * @dev Returns the owner of the NFT specified by `tokenId`.
34      */
35     function ownerOf(uint256 tokenId) public view returns (address owner);
36 
37     /**
38      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
39      * another (`to`).
40      *
41      *
42      *
43      * Requirements:
44      * - `from`, `to` cannot be zero.
45      * - `tokenId` must be owned by `from`.
46      * - If the caller is not `from`, it must be have been allowed to move this
47      * NFT by either {approve} or {setApprovalForAll}.
48      */
49     function safeTransferFrom(address from, address to, uint256 tokenId) public;
50     /**
51      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
52      * another (`to`).
53      *
54      * Requirements:
55      * - If the caller is not `from`, it must be approved to move this NFT by
56      * either {approve} or {setApprovalForAll}.
57      */
58     function transferFrom(address from, address to, uint256 tokenId) public;
59     function approve(address to, uint256 tokenId) public;
60     function getApproved(uint256 tokenId) public view returns (address operator);
61 
62     function setApprovalForAll(address operator, bool _approved) public;
63     function isApprovedForAll(address owner, address operator) public view returns (bool);
64 
65 
66     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
67 }
68 
69 contract IERC721Receiver {
70     /**
71      * @notice Handle the receipt of an NFT
72      * @dev The ERC721 smart contract calls this function on the recipient
73      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
74      * otherwise the caller will revert the transaction. The selector to be
75      * returned can be obtained as `this.onERC721Received.selector`. This
76      * function MAY throw to revert and reject the transfer.
77      * Note: the ERC721 contract address is always the message sender.
78      * @param operator The address which called `safeTransferFrom` function
79      * @param from The address which previously owned the token
80      * @param tokenId The NFT identifier which is being transferred
81      * @param data Additional data with no specified format
82      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
83      */
84     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
85     public returns (bytes4);
86 }
87 
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      *
127      * _Available since v2.4.0._
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      *
185      * _Available since v2.4.0._
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      *
222      * _Available since v2.4.0._
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * This test is non-exhaustive, and there may be false-negatives: during the
235      * execution of a contract's constructor, its address will be reported as
236      * not containing a contract.
237      *
238      * IMPORTANT: It is unsafe to assume that an address for which this
239      * function returns false is an externally-owned account (EOA) and not a
240      * contract.
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies in extcodesize, which returns 0 for contracts in
244         // construction, since the code is only stored at the end of the
245         // constructor execution.
246 
247         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
248         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
249         // for accounts without code, i.e. `keccak256('')`
250         bytes32 codehash;
251         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
252         // solhint-disable-next-line no-inline-assembly
253         assembly { codehash := extcodehash(account) }
254         return (codehash != 0x0 && codehash != accountHash);
255     }
256 
257     /**
258      * @dev Converts an `address` into `address payable`. Note that this is
259      * simply a type cast: the actual underlying value is not changed.
260      *
261      * _Available since v2.4.0._
262      */
263     function toPayable(address account) internal pure returns (address payable) {
264         return address(uint160(account));
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      *
283      * _Available since v2.4.0._
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-call-value
289         (bool success, ) = recipient.call.value(amount)("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 }
293 
294 library Counters {
295     using SafeMath for uint256;
296 
297     struct Counter {
298         // This variable should never be directly accessed by users of the library: interactions must be restricted to
299         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
300         // this feature: see https://github.com/ethereum/solidity/issues/4637
301         uint256 _value; // default: 0
302     }
303 
304     function current(Counter storage counter) internal view returns (uint256) {
305         return counter._value;
306     }
307 
308     function increment(Counter storage counter) internal {
309         counter._value += 1;
310     }
311 
312     function decrement(Counter storage counter) internal {
313         counter._value = counter._value.sub(1);
314     }
315 }
316 
317 contract ERC165 is IERC165 {
318     /*
319      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
320      */
321     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
322 
323     /**
324      * @dev Mapping of interface ids to whether or not it's supported.
325      */
326     mapping(bytes4 => bool) private _supportedInterfaces;
327 
328     constructor () internal {
329         // Derived contracts need only register support for their own interfaces,
330         // we register support for ERC165 itself here
331         _registerInterface(_INTERFACE_ID_ERC165);
332     }
333 
334     /**
335      * @dev See {IERC165-supportsInterface}.
336      *
337      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
340         return _supportedInterfaces[interfaceId];
341     }
342 
343     /**
344      * @dev Registers the contract as an implementer of the interface defined by
345      * `interfaceId`. Support of the actual ERC165 interface is automatic and
346      * registering its interface id is not required.
347      *
348      * See {IERC165-supportsInterface}.
349      *
350      * Requirements:
351      *
352      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
353      */
354     function _registerInterface(bytes4 interfaceId) internal {
355         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
356         _supportedInterfaces[interfaceId] = true;
357     }
358 }
359 
360 contract ERC721 is ERC165, IERC721 {
361     using SafeMath for uint256;
362     using Address for address;
363     using Counters for Counters.Counter;
364 
365     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
366     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
367     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
368 
369     // Mapping from token ID to owner
370     mapping (uint256 => address) private _tokenOwner;
371 
372     // Mapping from token ID to approved address
373     mapping (uint256 => address) private _tokenApprovals;
374 
375     // Mapping from owner to number of owned token
376     mapping (address => Counters.Counter) private _ownedTokensCount;
377 
378     // Mapping from owner to operator approvals
379     mapping (address => mapping (address => bool)) private _operatorApprovals;
380 
381     /*
382      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
383      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
384      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
385      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
386      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
387      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
388      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
389      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
390      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
391      *
392      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
393      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
394      */
395     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
396 
397     constructor () public {
398         // register the supported interfaces to conform to ERC721 via ERC165
399         _registerInterface(_INTERFACE_ID_ERC721);
400     }
401 
402     /**
403      * @dev Gets the balance of the specified address.
404      * @param owner address to query the balance of
405      * @return uint256 representing the amount owned by the passed address
406      */
407     function balanceOf(address owner) public view returns (uint256) {
408         require(owner != address(0));
409 
410         return _ownedTokensCount[owner].current();
411     }
412 
413     /**
414      * @dev Gets the owner of the specified token ID.
415      * @param tokenId uint256 ID of the token to query the owner of
416      * @return address currently marked as the owner of the given token ID
417      */
418     function ownerOf(uint256 tokenId) public view returns (address) {
419         address owner = _tokenOwner[tokenId];
420         require(owner != address(0));
421 
422         return owner;
423     }
424 
425     /**
426      * @dev Approves another address to transfer the given token ID
427      * The zero address indicates there is no approved address.
428      * There can only be one approved address per token at a given time.
429      * Can only be called by the token owner or an approved operator.
430      * @param to address to be approved for the given token ID
431      * @param tokenId uint256 ID of the token to be approved
432      */
433     function approve(address to, uint256 tokenId) public {
434         address owner = ownerOf(tokenId);
435         require(to != owner);
436 
437         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
438 
439         _tokenApprovals[tokenId] = to;
440         emit Approval(owner, to, tokenId);
441     }
442 
443     /**
444      * @dev Gets the approved address for a token ID, or zero if no address set
445      * Reverts if the token ID does not exist.
446      * @param tokenId uint256 ID of the token to query the approval of
447      * @return address currently approved for the given token ID
448      */
449     function getApproved(uint256 tokenId) public view returns (address) {
450         // require(_exists(tokenId), "ERC721: approved query for nonexistent token");
451 
452         return _tokenApprovals[tokenId];
453     }
454 
455     /**
456      * @dev Sets or unsets the approval of a given operator
457      * An operator is allowed to transfer all tokens of the sender on their behalf.
458      * @param to operator address to set the approval
459      * @param approved representing the status of the approval to be set
460      */
461     function setApprovalForAll(address to, bool approved) public {
462         require(to != msg.sender);
463 
464         _operatorApprovals[msg.sender][to] = approved;
465         emit ApprovalForAll(msg.sender, to, approved);
466     }
467 
468     /**
469      * @dev Tells whether an operator is approved by a given owner.
470      * @param owner owner address which you want to query the approval of
471      * @param operator operator address which you want to query the approval of
472      * @return bool whether the given operator is approved by the given owner
473      */
474     function isApprovedForAll(address owner, address operator) public view returns (bool) {
475         return _operatorApprovals[owner][operator];
476     }
477 
478     /**
479      * @dev Transfers the ownership of a given token ID to another address.
480      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
481      * Requires the msg.sender to be the owner, approved, or operator.
482      * @param from current owner of the token
483      * @param to address to receive the ownership of the given token ID
484      * @param tokenId uint256 ID of the token to be transferred
485      */
486     function transferFrom(address from, address to, uint256 tokenId) public {
487         //solhint-disable-next-line max-line-length
488         require(_isApprovedOrOwner(msg.sender, tokenId));
489 
490         _transferFrom(from, to, tokenId);
491     }
492 
493     /**
494      * @dev Safely transfers the ownership of a given token ID to another address
495      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
496      * which is called upon a safe transfer, and return the magic value
497      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
498      * the transfer is reverted.
499      * Requires the msg.sender to be the owner, approved, or operator
500      * @param from current owner of the token
501      * @param to address to receive the ownership of the given token ID
502      * @param tokenId uint256 ID of the token to be transferred
503      */
504     function safeTransferFrom(address from, address to, uint256 tokenId) public {
505         safeTransferFrom(from, to, tokenId, "");
506     }
507 
508     /**
509      * @dev Safely transfers the ownership of a given token ID to another address
510      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
511      * which is called upon a safe transfer, and return the magic value
512      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
513      * the transfer is reverted.
514      * Requires the _msgSender() to be the owner, approved, or operator
515      * @param from current owner of the token
516      * @param to address to receive the ownership of the given token ID
517      * @param tokenId uint256 ID of the token to be transferred
518      * @param _data bytes data to send along with a safe transfer check
519      */
520     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
521         require(_isApprovedOrOwner(msg.sender, tokenId));
522         _safeTransferFrom(from, to, tokenId, _data);
523     }
524 
525     /**
526      * @dev Safely transfers the ownership of a given token ID to another address
527      * If the target address is a contract, it must implement `onERC721Received`,
528      * which is called upon a safe transfer, and return the magic value
529      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
530      * the transfer is reverted.
531      * Requires the msg.sender to be the owner, approved, or operator
532      * @param from current owner of the token
533      * @param to address to receive the ownership of the given token ID
534      * @param tokenId uint256 ID of the token to be transferred
535      * @param _data bytes data to send along with a safe transfer check
536      */
537     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
538         _transferFrom(from, to, tokenId);
539         require(_checkOnERC721Received(from, to, tokenId, _data));
540     }
541 
542     /**
543      * @dev Returns whether the specified token exists.
544      * @param tokenId uint256 ID of the token to query the existence of
545      * @return bool whether the token exists
546      */
547     function _exists(uint256 tokenId) internal view returns (bool) {
548         address owner = _tokenOwner[tokenId];
549         return owner != address(0);
550     }
551 
552     /**
553      * @dev Returns whether the given spender can transfer a given token ID.
554      * @param spender address of the spender to query
555      * @param tokenId uint256 ID of the token to be transferred
556      * @return bool whether the msg.sender is approved for the given token ID,
557      * is an operator of the owner, or is the owner of the token
558      */
559     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {        
560         address owner = ownerOf(tokenId);
561         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
562     }
563 
564     /**
565      * @dev Internal function to safely mint a new token.
566      * Reverts if the given token ID already exists.
567      * If the target address is a contract, it must implement `onERC721Received`,
568      * which is called upon a safe transfer, and return the magic value
569      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
570      * the transfer is reverted.
571      * @param to The address that will own the minted token
572      * @param tokenId uint256 ID of the token to be minted
573      */
574     function _safeMint(address to, uint256 tokenId) internal {
575         _safeMint(to, tokenId, "");
576     }
577 
578     /**
579      * @dev Internal function to safely mint a new token.
580      * Reverts if the given token ID already exists.
581      * If the target address is a contract, it must implement `onERC721Received`,
582      * which is called upon a safe transfer, and return the magic value
583      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
584      * the transfer is reverted.
585      * @param to The address that will own the minted token
586      * @param tokenId uint256 ID of the token to be minted
587      * @param _data bytes data to send along with a safe transfer check
588      */
589     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
590         _mint(to, tokenId);
591         require(_checkOnERC721Received(address(0), to, tokenId, _data));
592     }
593 
594     /**
595      * @dev Internal function to mint a new token.
596      * Reverts if the given token ID already exists.
597      * @param to The address that will own the minted token
598      * @param tokenId uint256 ID of the token to be minted
599      */
600     function _mint(address to, uint256 tokenId) internal {
601         require(to != address(0));
602         require(!_exists(tokenId), "token already minted");
603 
604         _tokenOwner[tokenId] = to;
605         _ownedTokensCount[to].increment();
606 
607         emit Transfer(address(0), to, tokenId);
608     }
609 
610     /**
611      * @dev Internal function to burn a specific token.
612      * Reverts if the token does not exist.
613      * Deprecated, use {_burn} instead.
614      * @param owner owner of the token to burn
615      * @param tokenId uint256 ID of the token being burned
616      */
617     function _burn(address owner, uint256 tokenId) internal {
618         require(ownerOf(tokenId) == owner);
619 
620         _clearApproval(tokenId);
621 
622         _ownedTokensCount[owner].decrement();
623         _tokenOwner[tokenId] = address(0);
624 
625         emit Transfer(owner, address(0), tokenId);
626     }
627 
628     /**
629      * @dev Internal function to burn a specific token.
630      * Reverts if the token does not exist.
631      * @param tokenId uint256 ID of the token being burned
632      */
633     function _burn(uint256 tokenId) internal {
634         _burn(ownerOf(tokenId), tokenId);
635     }
636 
637     /**
638      * @dev Internal function to transfer ownership of a given token ID to another address.
639      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
640      * @param from current owner of the token
641      * @param to address to receive the ownership of the given token ID
642      * @param tokenId uint256 ID of the token to be transferred
643      */
644     function _transferFrom(address from, address to, uint256 tokenId) internal {
645         require(ownerOf(tokenId) == from, "not owner");
646         require(to != address(0));
647 
648         _clearApproval(tokenId);
649 
650         _ownedTokensCount[from].decrement();
651         _ownedTokensCount[to].increment();
652 
653         _tokenOwner[tokenId] = to;
654 
655         emit Transfer(from, to, tokenId);
656     }
657 
658     /**
659      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
660      * The call is not executed if the target address is not a contract.
661      *
662      * This function is deprecated.
663      * @param from address representing the previous owner of the given token ID
664      * @param to target address that will receive the tokens
665      * @param tokenId uint256 ID of the token to be transferred
666      * @param _data bytes optional data to send along with the call
667      * @return bool whether the call correctly returned the expected magic value
668      */
669     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
670         internal returns (bool)
671     {
672         if (!to.isContract()) {
673             return true;
674         }
675 
676         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
677         return (retval == _ERC721_RECEIVED);
678     }
679 
680     /**
681      * @dev Private function to clear current approval of a given token ID.
682      * @param tokenId uint256 ID of the token to be transferred
683      */
684     function _clearApproval(uint256 tokenId) private {
685         if (_tokenApprovals[tokenId] != address(0)) {
686             _tokenApprovals[tokenId] = address(0);
687         }
688     }
689 }
690 
691 contract IERC721Enumerable is IERC721 {
692     function totalSupply() public view returns (uint256);
693     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
694 
695     function tokenByIndex(uint256 index) public view returns (uint256);
696 }
697 
698 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
699     // Mapping from owner to list of owned token IDs
700     mapping(address => uint256[]) private _ownedTokens;
701 
702     // Mapping from token ID to index of the owner tokens list
703     mapping(uint256 => uint256) private _ownedTokensIndex;
704 
705     // Array with all token ids, used for enumeration
706     uint256[] private _allTokens;
707 
708     // Mapping from token id to position in the allTokens array
709     mapping(uint256 => uint256) private _allTokensIndex;
710 
711     /*
712      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
713      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
714      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
715      *
716      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
717      */
718     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
719 
720     /**
721      * @dev Constructor function.
722      */
723     constructor () public {
724         // register the supported interface to conform to ERC721Enumerable via ERC165
725         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
726     }
727 
728     /**
729      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
730      * @param owner address owning the tokens list to be accessed
731      * @param index uint256 representing the index to be accessed of the requested tokens list
732      * @return uint256 token ID at the given index of the tokens list owned by the requested address
733      */
734     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
735         // require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
736         return _ownedTokens[owner][index];
737     }
738 
739     /**
740      * @dev Gets the total amount of tokens stored by the contract.
741      * @return uint256 representing the total amount of tokens
742      */
743     function totalSupply() public view returns (uint256) {
744         return _allTokens.length;
745     }
746 
747     /**
748      * @dev Gets the token ID at a given index of all the tokens in this contract
749      * Reverts if the index is greater or equal to the total number of tokens.
750      * @param index uint256 representing the index to be accessed of the tokens list
751      * @return uint256 token ID at the given index of the tokens list
752      */
753     function tokenByIndex(uint256 index) public view returns (uint256) {
754         // require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
755         return _allTokens[index];
756     }
757 
758     /**
759      * @dev Internal function to transfer ownership of a given token ID to another address.
760      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
761      * @param from current owner of the token
762      * @param to address to receive the ownership of the given token ID
763      * @param tokenId uint256 ID of the token to be transferred
764      */
765     function _transferFrom(address from, address to, uint256 tokenId) internal {
766         super._transferFrom(from, to, tokenId);
767 
768         _removeTokenFromOwnerEnumeration(from, tokenId);
769 
770         _addTokenToOwnerEnumeration(to, tokenId);
771     }
772 
773     /**
774      * @dev Internal function to mint a new token.
775      * Reverts if the given token ID already exists.
776      * @param to address the beneficiary that will own the minted token
777      * @param tokenId uint256 ID of the token to be minted
778      */
779     function _mint(address to, uint256 tokenId) internal {
780         super._mint(to, tokenId);
781 
782         _addTokenToOwnerEnumeration(to, tokenId);
783 
784         _addTokenToAllTokensEnumeration(tokenId);
785     }
786 
787     /**
788      * @dev Internal function to burn a specific token.
789      * Reverts if the token does not exist.
790      * Deprecated, use {ERC721-_burn} instead.
791      * @param owner owner of the token to burn
792      * @param tokenId uint256 ID of the token being burned
793      */
794     function _burn(address owner, uint256 tokenId) internal {
795         super._burn(owner, tokenId);
796 
797         _removeTokenFromOwnerEnumeration(owner, tokenId);
798         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
799         _ownedTokensIndex[tokenId] = 0;
800 
801         _removeTokenFromAllTokensEnumeration(tokenId);
802     }
803 
804     /**
805      * @dev Gets the list of token IDs of the requested owner.
806      * @param owner address owning the tokens
807      * @return uint256[] List of token IDs owned by the requested address
808      */
809     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
810         return _ownedTokens[owner];
811     }
812 
813     /**
814      * @dev Private function to add a token to this extension's ownership-tracking data structures.
815      * @param to address representing the new owner of the given token ID
816      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
817      */
818     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
819         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
820         _ownedTokens[to].push(tokenId);
821     }
822 
823     /**
824      * @dev Private function to add a token to this extension's token tracking data structures.
825      * @param tokenId uint256 ID of the token to be added to the tokens list
826      */
827     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
828         _allTokensIndex[tokenId] = _allTokens.length;
829         _allTokens.push(tokenId);
830     }
831 
832     /**
833      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
834      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
835      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
836      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
837      * @param from address representing the previous owner of the given token ID
838      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
839      */
840     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
841         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
842         // then delete the last slot (swap and pop).
843 
844         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
845         uint256 tokenIndex = _ownedTokensIndex[tokenId];
846 
847         // When the token to delete is the last token, the swap operation is unnecessary
848         if (tokenIndex != lastTokenIndex) {
849             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
850 
851             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
852             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
853         }
854 
855         // This also deletes the contents at the last position of the array
856         _ownedTokens[from].length--;
857 
858         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
859         // lastTokenId, or just over the end of the array if the token was the last one).
860     }
861 
862     /**
863      * @dev Private function to remove a token from this extension's token tracking data structures.
864      * This has O(1) time complexity, but alters the order of the _allTokens array.
865      * @param tokenId uint256 ID of the token to be removed from the tokens list
866      */
867     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
868         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
869         // then delete the last slot (swap and pop).
870 
871         uint256 lastTokenIndex = _allTokens.length.sub(1);
872         uint256 tokenIndex = _allTokensIndex[tokenId];
873 
874         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
875         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
876         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
877         uint256 lastTokenId = _allTokens[lastTokenIndex];
878 
879         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
880         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
881 
882         // This also deletes the contents at the last position of the array
883         _allTokens.length--;
884         _allTokensIndex[tokenId] = 0;
885     }
886 }
887 
888 contract IERC721Metadata is IERC721 {
889     function name() external view returns (string memory);
890     function symbol() external view returns (string memory);
891     function tokenURI(uint256 tokenId) external view returns (string memory);
892 }
893 
894 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
895     // Token name
896     string private _name;
897 
898     // Token symbol
899     string private _symbol;
900 
901     // Optional mapping for token URIs
902     mapping(uint256 => string) private _tokenURIs;
903 
904     /*
905      *     bytes4(keccak256('name()')) == 0x06fdde03
906      *     bytes4(keccak256('symbol()')) == 0x95d89b41
907      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
908      *
909      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
910      */
911     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
912 
913     /**
914      * @dev Constructor function
915      */
916     constructor (string memory name, string memory symbol) public {
917         _name = name;
918         _symbol = symbol;
919 
920         // register the supported interfaces to conform to ERC721 via ERC165
921         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
922     }
923 
924     /**
925      * @dev Gets the token name.
926      * @return string representing the token name
927      */
928     function name() external view returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev Gets the token symbol.
934      * @return string representing the token symbol
935      */
936     function symbol() external view returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev Returns an URI for a given token ID.
942      * Throws if the token ID does not exist. May return an empty string.
943      * @param tokenId uint256 ID of the token to query
944      */
945     function tokenURI(uint256 tokenId) external view returns (string memory) {
946         // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
947         return _tokenURIs[tokenId];
948     }
949 
950     /**
951      * @dev Internal function to set the token URI for a given token.
952      * Reverts if the token ID does not exist.
953      * @param tokenId uint256 ID of the token to set its URI
954      * @param uri string URI to assign
955      */
956     function _setTokenURI(uint256 tokenId, string memory uri) internal {
957         require(_exists(tokenId), "URI set of nonexistent token");
958         _tokenURIs[tokenId] = uri;
959     }
960 
961     /**
962      * @dev Internal function to burn a specific token.
963      * Reverts if the token does not exist.
964      * Deprecated, use _burn(uint256) instead.
965      * @param owner owner of the token to burn
966      * @param tokenId uint256 ID of the token being burned by the msg.sender
967      */
968     function _burn(address owner, uint256 tokenId) internal {
969         super._burn(owner, tokenId);
970 
971         // Clear metadata (if any)
972         if (bytes(_tokenURIs[tokenId]).length != 0) {
973             delete _tokenURIs[tokenId];
974         }
975     }
976 }
977 
978 contract AsyncArtwork is ERC721, ERC721Enumerable, ERC721Metadata {
979     // An event whenever the platform address is updated
980     event PlatformAddressUpdated (
981         address platformAddress
982     );
983 
984     // An event whenever royalty amounts are updated
985     event RoyaltyAmountUpdated (
986         uint256 platformFirstPercentage,
987         uint256 platformSecondPercentage,
988         uint256 artistSecondPercentage
989     );
990 
991 	// An event whenever a bid is proposed
992 	event BidProposed (
993 		uint256 tokenId,
994         uint256 bidAmount,
995         address bidder
996     );
997 
998 	// An event whenever an bid is withdrawn
999     event BidWithdrawn (
1000     	uint256 tokenId
1001     );
1002 
1003     // An event whenever a buy now price has been set
1004     event BuyPriceSet (
1005     	uint256 tokenId,
1006     	uint256 price
1007     );
1008 
1009     // An event when a token has been sold 
1010     event TokenSale (
1011         // the id of the token
1012         uint256 tokenId,
1013         // the price that the token was sold for
1014         uint256 salePrice,
1015     	// the address of the buyer
1016     	address buyer  	
1017     );
1018 
1019     // An event whenever a control token has been updated
1020     event ControlLeverUpdated (
1021     	// the id of the token
1022     	uint256 tokenId,
1023     	// an optional amount that the updater sent to boost priority of the rendering
1024     	uint256 priorityTip,
1025         // the ids of the levers that were updated
1026         uint256[] leverIds,
1027     	// the previous values that the levers had before this update (for clients who want to animate the change)
1028     	int256[] previousValues,
1029     	// the new updated value
1030     	int256[] updatedValues
1031 	);
1032 
1033     // struct for a token that controls part of the artwork
1034     struct ControlToken {        
1035         // number that tracks how many levers there are
1036         uint256 numControlLevers;
1037         // false by default, true once instantiated
1038         bool exists;
1039         // false by default, true once setup by the artist
1040         bool isSetup;
1041         // the levers that this control token can use
1042         mapping (uint256 => ControlLever) levers;
1043     }
1044 
1045     // struct for a lever on a control token that can be changed
1046     struct ControlLever {
1047         // // The minimum value this token can have (inclusive)
1048         int256 minValue;
1049         // The maximum value this token can have (inclusive)
1050         int256 maxValue;
1051         // The current value for this token
1052         int256 currentValue;
1053         // false by default, true once instantiated
1054         bool exists;
1055     } 
1056 
1057 	// struct for a pending bid 
1058 	struct PendingBid {
1059 		// the address of the bidder
1060 		address payable bidder;
1061 		// the amount that they bid
1062 		uint256 amount;
1063 		// false by default, true once instantiated
1064 		bool exists;
1065 	}
1066 
1067     // creators who are allowed to mint on this contract
1068 	mapping (address => bool) public whitelistedCreators;
1069     // for each token, holds an array of the creator collaborators. For layer tokens it will likely just be [artist], for master tokens it may hold multiples
1070     mapping (uint256 => address payable[]) public uniqueTokenCreators;
1071     // map a control token id to a control token struct
1072     mapping (uint256 => ControlToken) controlTokenMapping;
1073     // map control token ID to its buy price
1074 	mapping (uint256 => uint256) public buyPrices;	
1075     // map a control token ID to its highest bid
1076 	mapping (uint256 => PendingBid) public pendingBids;
1077     // track whether this token was sold the first time or not (used for determining whether to use first or secondary sale percentage)
1078     mapping (uint256 => bool) public tokenDidHaveFirstSale;    
1079     // mapping of addresses that are allowed to control tokens on your behalf
1080     mapping (address => address) public permissionedControllers;
1081     // the percentage of sale that the platform gets on first sales
1082     uint256 public platformFirstSalePercentage;
1083     // the percentage of sale that the platform gets on secondary sales
1084     uint256 public platformSecondSalePercentage;
1085     // the percentage of sale that an artist gets on secondary sales
1086     uint256 public artistSecondSalePercentage;
1087     // gets incremented to placehold for tokens not minted yet
1088     uint256 public expectedTokenSupply;
1089     // the address of the platform (for receving commissions and royalties)
1090     address payable public platformAddress;
1091 
1092 	constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1093 		// starting royalty amounts
1094         platformFirstSalePercentage = 10;
1095         platformSecondSalePercentage = 1;
1096         artistSecondSalePercentage = 4;
1097 
1098         // by default, the platformAddress is the address that mints this contract
1099         platformAddress = msg.sender;
1100 
1101         // by default, platform is whitelisted
1102         updateWhitelist(platformAddress, true);
1103   	}
1104 
1105     // modifier for only allowing the platform to make a call
1106     modifier onlyPlatform() {
1107         require(msg.sender == platformAddress);
1108         _;    
1109     }
1110 
1111     modifier onlyWhitelistedCreator() { 
1112     	require(whitelistedCreators[msg.sender] == true);
1113     	_; 
1114     }
1115     
1116     function updateWhitelist(address creator, bool state) public onlyPlatform {
1117     	whitelistedCreators[creator] = state;
1118     }
1119 
1120     // Allows the current platform address to update to something different
1121     function updatePlatformAddress(address payable newPlatformAddress) public onlyPlatform {
1122         platformAddress = newPlatformAddress;
1123 
1124         emit PlatformAddressUpdated(newPlatformAddress);
1125     }
1126 
1127     // Update the royalty percentages that platform and artists receive on first or secondary sales
1128     function updateRoyaltyPercentages(uint256 _platformFirstSalePercentage, uint256 _platformSecondSalePercentage, 
1129         uint256 _artistSecondSalePercentage) public onlyPlatform {
1130     	// don't let the platform take all of a first sale
1131     	require (_platformFirstSalePercentage < 100);
1132     	// don't let secondary percentages take all of a sale either
1133     	require (_platformSecondSalePercentage.add(_artistSecondSalePercentage) < 100);
1134         // update the percentage that the platform gets on first sale
1135         platformFirstSalePercentage = _platformFirstSalePercentage;
1136         // update the percentage that the platform gets on secondary sales
1137         platformSecondSalePercentage = _platformSecondSalePercentage;
1138         // update the percentage that artists get on secondary sales
1139         artistSecondSalePercentage = _artistSecondSalePercentage;
1140         // emit an event that contains the new royalty percentage values
1141         emit RoyaltyAmountUpdated(platformFirstSalePercentage, platformSecondSalePercentage, artistSecondSalePercentage);
1142     }
1143     function setupControlToken(uint256 controlTokenId, string memory controlTokenURI,
1144             int256[] memory leverMinValues, 
1145             int256[] memory leverMaxValues,
1146             int256[] memory leverStartValues,
1147             address payable[] memory additionalCollaborators
1148         ) public {
1149         // check that a control token exists for this token id
1150         require (controlTokenMapping[controlTokenId].exists, "No control token found");
1151         // ensure that this token is not setup yet
1152         require (controlTokenMapping[controlTokenId].isSetup == false, "Already setup");        
1153         // ensure that only the control token artist is attempting this mint
1154         require(uniqueTokenCreators[controlTokenId][0] == msg.sender, "Must be control token artist");        
1155         // enforce that the length of all the array lengths are equal
1156         require((leverMinValues.length == leverMaxValues.length) && (leverMaxValues.length == leverStartValues.length), "Values array mismatch");
1157         // mint the control token here
1158         super._safeMint(msg.sender, controlTokenId);
1159         // set token URI
1160         super._setTokenURI(controlTokenId, controlTokenURI);        
1161         // create the control token
1162         controlTokenMapping[controlTokenId] = ControlToken(leverStartValues.length, true, true);
1163         // create the control token levers now
1164         for (uint256 k = 0; k < leverStartValues.length; k++) {
1165             // enforce that maxValue is greater than or equal to minValue
1166             require (leverMaxValues[k] >= leverMinValues[k], "Max val must >= min");
1167             // enforce that currentValue is valid
1168             require((leverStartValues[k] >= leverMinValues[k]) && (leverStartValues[k] <= leverMaxValues[k]), "Invalid start val");
1169             // add the lever to this token
1170             controlTokenMapping[controlTokenId].levers[k] = ControlLever(leverMinValues[k],
1171                 leverMaxValues[k], leverStartValues[k], true);
1172         }
1173         // the control token artist can optionally specify additional collaborators on this layer
1174         for (uint256 i = 0; i < additionalCollaborators.length; i++) {
1175             // can't provide burn address as collaborator
1176             require(additionalCollaborators[i] != address(0));
1177 
1178             uniqueTokenCreators[controlTokenId].push(additionalCollaborators[i]);
1179         }
1180     }
1181 
1182     function mintArtwork(uint256 artworkTokenId, string memory artworkTokenURI, address payable[] memory controlTokenArtists
1183     ) public onlyWhitelistedCreator {
1184         require (artworkTokenId == expectedTokenSupply, "ExpectedTokenSupply different");
1185         // Mint the token that represents ownership of the entire artwork    
1186         super._safeMint(msg.sender, artworkTokenId);
1187         expectedTokenSupply++;
1188 
1189         super._setTokenURI(artworkTokenId, artworkTokenURI);        
1190         // track the msg.sender address as the artist address for future royalties
1191         uniqueTokenCreators[artworkTokenId].push(msg.sender);
1192 
1193         // iterate through all control token URIs (1 for each control token)
1194         for (uint256 i = 0; i < controlTokenArtists.length; i++) {
1195             // can't provide burn address as artist
1196             require(controlTokenArtists[i] != address(0));
1197 
1198             // use the curren token supply as the next token id
1199             uint256 controlTokenId = expectedTokenSupply;
1200             expectedTokenSupply++;
1201 
1202             uniqueTokenCreators[controlTokenId].push(controlTokenArtists[i]);
1203             // stub in an existing control token so exists is true
1204             controlTokenMapping[controlTokenId] = ControlToken(0, true, false);
1205 
1206             if (controlTokenArtists[i] != msg.sender) {
1207                 bool containsControlTokenArtist = false;
1208 
1209                 for (uint256 k = 0; k < uniqueTokenCreators[artworkTokenId].length; k++) {
1210                     if (uniqueTokenCreators[artworkTokenId][k] == controlTokenArtists[i]) {
1211                         containsControlTokenArtist = true;
1212                         break;
1213                     }
1214                 }
1215                 if (containsControlTokenArtist == false) {
1216                     uniqueTokenCreators[artworkTokenId].push(controlTokenArtists[i]);
1217                 }
1218             }
1219         }
1220     }
1221     // Bidder functions
1222     function bid(uint256 tokenId) public payable {
1223     	// don't let owners/approved bid on their own tokens
1224         require(_isApprovedOrOwner(msg.sender, tokenId) == false);        
1225     	// check if there's a high bid
1226     	if (pendingBids[tokenId].exists) {
1227     		// enforce that this bid is higher
1228     		require(msg.value > pendingBids[tokenId].amount, "Bid must be > than current bid");
1229             // Return bid amount back to bidder
1230             pendingBids[tokenId].bidder.transfer(pendingBids[tokenId].amount);
1231     	}
1232     	// set the new highest bid
1233     	pendingBids[tokenId] = PendingBid(msg.sender, msg.value, true);
1234     	// Emit event for the bid proposal
1235     	emit BidProposed(tokenId, msg.value, msg.sender);
1236     }
1237     // allows an address with a pending bid to withdraw it
1238     function withdrawBid(uint256 tokenId) public {
1239         // check that there is a bid from the sender to withdraw
1240         require (pendingBids[tokenId].exists && (pendingBids[tokenId].bidder == msg.sender));
1241     	// Return bid amount back to bidder
1242         pendingBids[tokenId].bidder.transfer(pendingBids[tokenId].amount);
1243 		// clear highest bid
1244 		pendingBids[tokenId] = PendingBid(address(0), 0, false);
1245 		// emit an event when the highest bid is withdrawn
1246 		emit BidWithdrawn(tokenId);
1247     }
1248     // Buy the artwork for the currently set price
1249     function takeBuyPrice(uint256 tokenId) public payable {
1250         // don't let owners/approved buy their own tokens
1251         require(_isApprovedOrOwner(msg.sender, tokenId) == false);
1252         // get the sale amount
1253         uint256 saleAmount = buyPrices[tokenId];
1254         // check that there is a buy price
1255         require(saleAmount > 0);
1256         // check that the buyer sent enough to purchase
1257         require (msg.value >= saleAmount);
1258     	// Return all highest bidder's money
1259         if (pendingBids[tokenId].exists) {
1260             // Return bid amount back to bidder
1261             pendingBids[tokenId].bidder.transfer(pendingBids[tokenId].amount);
1262             // clear highest bid
1263             pendingBids[tokenId] = PendingBid(address(0), 0, false);
1264         }        
1265         onTokenSold(tokenId, saleAmount, msg.sender);
1266     }
1267 
1268     function distributeFundsToCreators(uint256 amount, address payable[] memory creators) private {
1269         uint256 creatorShare = amount.div(creators.length);
1270 
1271         for (uint256 i = 0; i < creators.length; i++) {
1272             creators[i].transfer(creatorShare);
1273         }
1274     }
1275 
1276     function onTokenSold(uint256 tokenId, uint256 saleAmount, address to) private {
1277         // if the first sale already happened, then give the artist + platform the secondary royalty percentage
1278         if (tokenDidHaveFirstSale[tokenId]) {
1279         	// give platform its secondary sale percentage
1280         	uint256 platformAmount = saleAmount.mul(platformSecondSalePercentage).div(100);
1281         	platformAddress.transfer(platformAmount);
1282         	// distribute the creator royalty amongst the creators (all artists involved for a base token, sole artist creator for layer )
1283         	uint256 creatorAmount = saleAmount.mul(artistSecondSalePercentage).div(100);
1284         	distributeFundsToCreators(creatorAmount, uniqueTokenCreators[tokenId]);            
1285             // cast the owner to a payable address
1286             address payable payableOwner = address(uint160(ownerOf(tokenId)));
1287             // transfer the remaining amount to the owner of the token
1288             payableOwner.transfer(saleAmount.sub(platformAmount).sub(creatorAmount));
1289         } else {
1290         	tokenDidHaveFirstSale[tokenId] = true;
1291         	// give platform its first sale percentage
1292         	uint256 platformAmount = saleAmount.mul(platformFirstSalePercentage).div(100);
1293         	platformAddress.transfer(platformAmount);
1294         	// this is a token first sale, so distribute the remaining funds to the unique token creators of this token
1295         	// (if it's a base token it will be all the unique creators, if it's a control token it will be that single artist)                      
1296             distributeFundsToCreators(saleAmount.sub(platformAmount), uniqueTokenCreators[tokenId]);
1297         }            
1298         // Transfer token to msg.sender
1299         _safeTransferFrom(ownerOf(tokenId), to, tokenId, "");
1300         // clear highest bid
1301         pendingBids[tokenId] = PendingBid(address(0), 0, false);
1302         // Emit event
1303         emit TokenSale(tokenId, saleAmount, to);
1304     }
1305 
1306     // Owner functions
1307     // Allow owner to accept the highest bid for a token
1308     function acceptBid(uint256 tokenId) public {
1309     	// check if sender is owner/approved of token        
1310         require(_isApprovedOrOwner(msg.sender, tokenId));
1311     	// check if there's a bid to accept
1312     	require (pendingBids[tokenId].exists);
1313         // process the sale
1314         onTokenSold(tokenId, pendingBids[tokenId].amount, pendingBids[tokenId].bidder);
1315     }
1316 
1317     // Allows owner of a control token to set an immediate buy price. Set to 0 to reset.
1318     function makeBuyPrice(uint256 tokenId, uint256 amount) public {
1319     	// check if sender is owner/approved of token        
1320     	require(_isApprovedOrOwner(msg.sender, tokenId));        
1321     	// set the buy price
1322     	buyPrices[tokenId] = amount;
1323     	// emit event
1324     	emit BuyPriceSet(tokenId, amount);
1325     }
1326 
1327     // return the min, max, and current value of a control lever
1328     function getControlToken(uint256 controlTokenId) public view returns (int256[] memory) {
1329         require(controlTokenMapping[controlTokenId].exists);
1330         
1331         ControlToken storage controlToken = controlTokenMapping[controlTokenId];
1332 
1333         int256[] memory returnValues = new int256[](controlToken.numControlLevers.mul(3));
1334         uint256 returnValIndex = 0;
1335 
1336         // iterate through all the control levers for this control token
1337         for (uint256 i = 0; i < controlToken.numControlLevers; i++) {        
1338             returnValues[returnValIndex] = controlToken.levers[i].minValue;
1339             returnValIndex = returnValIndex.add(1);
1340 
1341             returnValues[returnValIndex] = controlToken.levers[i].maxValue;
1342             returnValIndex = returnValIndex.add(1);
1343 
1344             returnValues[returnValIndex] = controlToken.levers[i].currentValue; 
1345             returnValIndex = returnValIndex.add(1);
1346         }        
1347 
1348         return returnValues;
1349     }
1350     // anyone can grant permission to another address to control tokens on their behalf. Set to Address(0) to reset.
1351     function grantControlPermission(address permissioned) public {
1352         permissionedControllers[msg.sender] = permissioned;
1353     }
1354 
1355     // Allows owner (or permissioned user) of a control token to update its lever values
1356     // Optionally accept a payment to increase speed of rendering priority
1357     function useControlToken(uint256 controlTokenId, uint256[] memory leverIds, int256[] memory newValues) public payable {
1358     	// check if sender is owner/approved of token OR if they're a permissioned controller for the token owner      
1359         require(_isApprovedOrOwner(msg.sender, controlTokenId) || (permissionedControllers[ownerOf(controlTokenId)] == msg.sender),
1360             "Owner or permissioned only"); 
1361         // collect the previous lever values for the event emit below
1362         int256[] memory previousValues = new int256[](newValues.length);
1363 
1364         for (uint256 i = 0; i < leverIds.length; i++) {
1365             // get the control lever
1366             ControlLever storage lever = controlTokenMapping[controlTokenId].levers[leverIds[i]];
1367 
1368             // Enforce that the new value is valid        
1369             require((newValues[i] >= lever.minValue) && (newValues[i] <= lever.maxValue), "Invalid val");
1370 
1371             // Enforce that the new value is different
1372             require(newValues[i] != lever.currentValue, "Must provide different val");
1373 
1374             // grab previous value for the event emit
1375             int256 previousValue = lever.currentValue;
1376             
1377             // Update token current value
1378             lever.currentValue = newValues[i];
1379 
1380             // collect the previous lever values for the event emit below
1381             previousValues[i] = previousValue;
1382         }
1383 
1384         // if there's a payment then send it to the platform (for higher priority updates)
1385         if (msg.value > 0) {
1386         	platformAddress.transfer(msg.value);
1387         }
1388         
1389     	// emit event
1390     	emit ControlLeverUpdated(controlTokenId, msg.value, leverIds, previousValues, newValues);
1391     }
1392 
1393     // override the default transfer
1394     function _transferFrom(address from, address to, uint256 tokenId) internal {        
1395         super._transferFrom(from, to, tokenId);        
1396         // clear a buy now price after being transferred
1397         buyPrices[tokenId] = 0;
1398     }
1399 }