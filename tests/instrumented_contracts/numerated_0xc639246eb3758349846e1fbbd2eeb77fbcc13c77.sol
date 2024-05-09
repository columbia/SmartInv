1 pragma solidity ^0.5.11;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 contract IERC721 is IERC165 {
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
35     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
36 
37     /**
38      * @dev Returns the number of NFTs in `owner`'s account.
39      */
40     function balanceOf(address owner) public view returns (uint256 balance);
41 
42     /**
43      * @dev Returns the owner of the NFT specified by `tokenId`.
44      */
45     function ownerOf(uint256 tokenId) public view returns (address owner);
46 
47     /**
48      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
49      * another (`to`).
50      *
51      *
52      *
53      * Requirements:
54      * - `from`, `to` cannot be zero.
55      * - `tokenId` must be owned by `from`.
56      * - If the caller is not `from`, it must be have been allowed to move this
57      * NFT by either {approve} or {setApprovalForAll}.
58      */
59     function safeTransferFrom(address from, address to, uint256 tokenId) public;
60     /**
61      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
62      * another (`to`).
63      *
64      * Requirements:
65      * - If the caller is not `from`, it must be approved to move this NFT by
66      * either {approve} or {setApprovalForAll}.
67      */
68     function transferFrom(address from, address to, uint256 tokenId) public;
69     function approve(address to, uint256 tokenId) public;
70     function getApproved(uint256 tokenId) public view returns (address operator);
71 
72     function setApprovalForAll(address operator, bool _approved) public;
73     function isApprovedForAll(address owner, address operator) public view returns (bool);
74 
75 
76     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
77 }
78 
79 contract IERC721Receiver {
80     /**
81      * @notice Handle the receipt of an NFT
82      * @dev The ERC721 smart contract calls this function on the recipient
83      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
84      * otherwise the caller will revert the transaction. The selector to be
85      * returned can be obtained as `this.onERC721Received.selector`. This
86      * function MAY throw to revert and reject the transfer.
87      * Note: the ERC721 contract address is always the message sender.
88      * @param operator The address which called `safeTransferFrom` function
89      * @param from The address which previously owned the token
90      * @param tokenId The NFT identifier which is being transferred
91      * @param data Additional data with no specified format
92      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
93      */
94     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
95     public returns (bytes4);
96 }
97 
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      * - Subtraction cannot overflow.
136      *
137      * _Available since v2.4.0._
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      *
195      * _Available since v2.4.0._
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         // Solidity only automatically asserts when dividing by 0
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      *
232      * _Available since v2.4.0._
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * This test is non-exhaustive, and there may be false-negatives: during the
245      * execution of a contract's constructor, its address will be reported as
246      * not containing a contract.
247      *
248      * IMPORTANT: It is unsafe to assume that an address for which this
249      * function returns false is an externally-owned account (EOA) and not a
250      * contract.
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies in extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != 0x0 && codehash != accountHash);
265     }
266 
267     /**
268      * @dev Converts an `address` into `address payable`. Note that this is
269      * simply a type cast: the actual underlying value is not changed.
270      *
271      * _Available since v2.4.0._
272      */
273     function toPayable(address account) internal pure returns (address payable) {
274         return address(uint160(account));
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      *
293      * _Available since v2.4.0._
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-call-value
299         (bool success, ) = recipient.call.value(amount)("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 }
303 
304 library Counters {
305     using SafeMath for uint256;
306 
307     struct Counter {
308         // This variable should never be directly accessed by users of the library: interactions must be restricted to
309         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
310         // this feature: see https://github.com/ethereum/solidity/issues/4637
311         uint256 _value; // default: 0
312     }
313 
314     function current(Counter storage counter) internal view returns (uint256) {
315         return counter._value;
316     }
317 
318     function increment(Counter storage counter) internal {
319         counter._value += 1;
320     }
321 
322     function decrement(Counter storage counter) internal {
323         counter._value = counter._value.sub(1);
324     }
325 }
326 
327 contract ERC165 is IERC165 {
328     /*
329      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
330      */
331     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
332 
333     /**
334      * @dev Mapping of interface ids to whether or not it's supported.
335      */
336     mapping(bytes4 => bool) private _supportedInterfaces;
337 
338     constructor () internal {
339         // Derived contracts need only register support for their own interfaces,
340         // we register support for ERC165 itself here
341         _registerInterface(_INTERFACE_ID_ERC165);
342     }
343 
344     /**
345      * @dev See {IERC165-supportsInterface}.
346      *
347      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
350         return _supportedInterfaces[interfaceId];
351     }
352 
353     /**
354      * @dev Registers the contract as an implementer of the interface defined by
355      * `interfaceId`. Support of the actual ERC165 interface is automatic and
356      * registering its interface id is not required.
357      *
358      * See {IERC165-supportsInterface}.
359      *
360      * Requirements:
361      *
362      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
363      */
364     function _registerInterface(bytes4 interfaceId) internal {
365         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
366         _supportedInterfaces[interfaceId] = true;
367     }
368 }
369 
370 contract ERC721 is Context, ERC165, IERC721 {
371     using SafeMath for uint256;
372     using Address for address;
373     using Counters for Counters.Counter;
374 
375     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
376     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
377     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
378 
379     // Mapping from token ID to owner
380     mapping (uint256 => address) private _tokenOwner;
381 
382     // Mapping from token ID to approved address
383     mapping (uint256 => address) private _tokenApprovals;
384 
385     // Mapping from owner to number of owned token
386     mapping (address => Counters.Counter) private _ownedTokensCount;
387 
388     // Mapping from owner to operator approvals
389     mapping (address => mapping (address => bool)) private _operatorApprovals;
390 
391     /*
392      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
393      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
394      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
395      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
396      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
397      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
398      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
399      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
400      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
401      *
402      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
403      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
404      */
405     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
406 
407     constructor () public {
408         // register the supported interfaces to conform to ERC721 via ERC165
409         _registerInterface(_INTERFACE_ID_ERC721);
410     }
411 
412     /**
413      * @dev Gets the balance of the specified address.
414      * @param owner address to query the balance of
415      * @return uint256 representing the amount owned by the passed address
416      */
417     function balanceOf(address owner) public view returns (uint256) {
418         require(owner != address(0), "ERC721: balance query for the zero address");
419 
420         return _ownedTokensCount[owner].current();
421     }
422 
423     /**
424      * @dev Gets the owner of the specified token ID.
425      * @param tokenId uint256 ID of the token to query the owner of
426      * @return address currently marked as the owner of the given token ID
427      */
428     function ownerOf(uint256 tokenId) public view returns (address) {
429         address owner = _tokenOwner[tokenId];
430         require(owner != address(0), "ERC721: owner query for nonexistent token");
431 
432         return owner;
433     }
434 
435     /**
436      * @dev Approves another address to transfer the given token ID
437      * The zero address indicates there is no approved address.
438      * There can only be one approved address per token at a given time.
439      * Can only be called by the token owner or an approved operator.
440      * @param to address to be approved for the given token ID
441      * @param tokenId uint256 ID of the token to be approved
442      */
443     function approve(address to, uint256 tokenId) public {
444         address owner = ownerOf(tokenId);
445         require(to != owner, "ERC721: approval to current owner");
446 
447         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
448             "ERC721: approve caller is not owner nor approved for all"
449         );
450 
451         _tokenApprovals[tokenId] = to;
452         emit Approval(owner, to, tokenId);
453     }
454 
455     /**
456      * @dev Gets the approved address for a token ID, or zero if no address set
457      * Reverts if the token ID does not exist.
458      * @param tokenId uint256 ID of the token to query the approval of
459      * @return address currently approved for the given token ID
460      */
461     function getApproved(uint256 tokenId) public view returns (address) {
462         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
463 
464         return _tokenApprovals[tokenId];
465     }
466 
467     /**
468      * @dev Sets or unsets the approval of a given operator
469      * An operator is allowed to transfer all tokens of the sender on their behalf.
470      * @param to operator address to set the approval
471      * @param approved representing the status of the approval to be set
472      */
473     function setApprovalForAll(address to, bool approved) public {
474         require(to != _msgSender(), "ERC721: approve to caller");
475 
476         _operatorApprovals[_msgSender()][to] = approved;
477         emit ApprovalForAll(_msgSender(), to, approved);
478     }
479 
480     /**
481      * @dev Tells whether an operator is approved by a given owner.
482      * @param owner owner address which you want to query the approval of
483      * @param operator operator address which you want to query the approval of
484      * @return bool whether the given operator is approved by the given owner
485      */
486     function isApprovedForAll(address owner, address operator) public view returns (bool) {
487         return _operatorApprovals[owner][operator];
488     }
489 
490     /**
491      * @dev Transfers the ownership of a given token ID to another address.
492      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
493      * Requires the msg.sender to be the owner, approved, or operator.
494      * @param from current owner of the token
495      * @param to address to receive the ownership of the given token ID
496      * @param tokenId uint256 ID of the token to be transferred
497      */
498     function transferFrom(address from, address to, uint256 tokenId) public {
499         //solhint-disable-next-line max-line-length
500         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
501 
502         _transferFrom(from, to, tokenId);
503     }
504 
505     /**
506      * @dev Safely transfers the ownership of a given token ID to another address
507      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
508      * which is called upon a safe transfer, and return the magic value
509      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
510      * the transfer is reverted.
511      * Requires the msg.sender to be the owner, approved, or operator
512      * @param from current owner of the token
513      * @param to address to receive the ownership of the given token ID
514      * @param tokenId uint256 ID of the token to be transferred
515      */
516     function safeTransferFrom(address from, address to, uint256 tokenId) public {
517         safeTransferFrom(from, to, tokenId, "");
518     }
519 
520     /**
521      * @dev Safely transfers the ownership of a given token ID to another address
522      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
523      * which is called upon a safe transfer, and return the magic value
524      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
525      * the transfer is reverted.
526      * Requires the _msgSender() to be the owner, approved, or operator
527      * @param from current owner of the token
528      * @param to address to receive the ownership of the given token ID
529      * @param tokenId uint256 ID of the token to be transferred
530      * @param _data bytes data to send along with a safe transfer check
531      */
532     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
533         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
534         _safeTransferFrom(from, to, tokenId, _data);
535     }
536 
537     /**
538      * @dev Safely transfers the ownership of a given token ID to another address
539      * If the target address is a contract, it must implement `onERC721Received`,
540      * which is called upon a safe transfer, and return the magic value
541      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
542      * the transfer is reverted.
543      * Requires the msg.sender to be the owner, approved, or operator
544      * @param from current owner of the token
545      * @param to address to receive the ownership of the given token ID
546      * @param tokenId uint256 ID of the token to be transferred
547      * @param _data bytes data to send along with a safe transfer check
548      */
549     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
550         _transferFrom(from, to, tokenId);
551         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
552     }
553 
554     /**
555      * @dev Returns whether the specified token exists.
556      * @param tokenId uint256 ID of the token to query the existence of
557      * @return bool whether the token exists
558      */
559     function _exists(uint256 tokenId) internal view returns (bool) {
560         address owner = _tokenOwner[tokenId];
561         return owner != address(0);
562     }
563 
564     /**
565      * @dev Returns whether the given spender can transfer a given token ID.
566      * @param spender address of the spender to query
567      * @param tokenId uint256 ID of the token to be transferred
568      * @return bool whether the msg.sender is approved for the given token ID,
569      * is an operator of the owner, or is the owner of the token
570      */
571     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
572         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
573         address owner = ownerOf(tokenId);
574         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
575     }
576 
577     /**
578      * @dev Internal function to safely mint a new token.
579      * Reverts if the given token ID already exists.
580      * If the target address is a contract, it must implement `onERC721Received`,
581      * which is called upon a safe transfer, and return the magic value
582      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
583      * the transfer is reverted.
584      * @param to The address that will own the minted token
585      * @param tokenId uint256 ID of the token to be minted
586      */
587     function _safeMint(address to, uint256 tokenId) internal {
588         _safeMint(to, tokenId, "");
589     }
590 
591     /**
592      * @dev Internal function to safely mint a new token.
593      * Reverts if the given token ID already exists.
594      * If the target address is a contract, it must implement `onERC721Received`,
595      * which is called upon a safe transfer, and return the magic value
596      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
597      * the transfer is reverted.
598      * @param to The address that will own the minted token
599      * @param tokenId uint256 ID of the token to be minted
600      * @param _data bytes data to send along with a safe transfer check
601      */
602     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
603         _mint(to, tokenId);
604         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
605     }
606 
607     /**
608      * @dev Internal function to mint a new token.
609      * Reverts if the given token ID already exists.
610      * @param to The address that will own the minted token
611      * @param tokenId uint256 ID of the token to be minted
612      */
613     function _mint(address to, uint256 tokenId) internal {
614         require(to != address(0), "ERC721: mint to the zero address");
615         require(!_exists(tokenId), "ERC721: token already minted");
616 
617         _tokenOwner[tokenId] = to;
618         _ownedTokensCount[to].increment();
619 
620         emit Transfer(address(0), to, tokenId);
621     }
622 
623     /**
624      * @dev Internal function to burn a specific token.
625      * Reverts if the token does not exist.
626      * Deprecated, use {_burn} instead.
627      * @param owner owner of the token to burn
628      * @param tokenId uint256 ID of the token being burned
629      */
630     function _burn(address owner, uint256 tokenId) internal {
631         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
632 
633         _clearApproval(tokenId);
634 
635         _ownedTokensCount[owner].decrement();
636         _tokenOwner[tokenId] = address(0);
637 
638         emit Transfer(owner, address(0), tokenId);
639     }
640 
641     /**
642      * @dev Internal function to burn a specific token.
643      * Reverts if the token does not exist.
644      * @param tokenId uint256 ID of the token being burned
645      */
646     function _burn(uint256 tokenId) internal {
647         _burn(ownerOf(tokenId), tokenId);
648     }
649 
650     /**
651      * @dev Internal function to transfer ownership of a given token ID to another address.
652      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
653      * @param from current owner of the token
654      * @param to address to receive the ownership of the given token ID
655      * @param tokenId uint256 ID of the token to be transferred
656      */
657     function _transferFrom(address from, address to, uint256 tokenId) internal {
658         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
659         require(to != address(0), "ERC721: transfer to the zero address");
660 
661         _clearApproval(tokenId);
662 
663         _ownedTokensCount[from].decrement();
664         _ownedTokensCount[to].increment();
665 
666         _tokenOwner[tokenId] = to;
667 
668         emit Transfer(from, to, tokenId);
669     }
670 
671     /**
672      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
673      * The call is not executed if the target address is not a contract.
674      *
675      * This function is deprecated.
676      * @param from address representing the previous owner of the given token ID
677      * @param to target address that will receive the tokens
678      * @param tokenId uint256 ID of the token to be transferred
679      * @param _data bytes optional data to send along with the call
680      * @return bool whether the call correctly returned the expected magic value
681      */
682     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
683         internal returns (bool)
684     {
685         if (!to.isContract()) {
686             return true;
687         }
688 
689         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
690         return (retval == _ERC721_RECEIVED);
691     }
692 
693     /**
694      * @dev Private function to clear current approval of a given token ID.
695      * @param tokenId uint256 ID of the token to be transferred
696      */
697     function _clearApproval(uint256 tokenId) private {
698         if (_tokenApprovals[tokenId] != address(0)) {
699             _tokenApprovals[tokenId] = address(0);
700         }
701     }
702 }
703 
704 contract IERC721Enumerable is IERC721 {
705     function totalSupply() public view returns (uint256);
706     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
707 
708     function tokenByIndex(uint256 index) public view returns (uint256);
709 }
710 
711 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
712     // Mapping from owner to list of owned token IDs
713     mapping(address => uint256[]) private _ownedTokens;
714 
715     // Mapping from token ID to index of the owner tokens list
716     mapping(uint256 => uint256) private _ownedTokensIndex;
717 
718     // Array with all token ids, used for enumeration
719     uint256[] private _allTokens;
720 
721     // Mapping from token id to position in the allTokens array
722     mapping(uint256 => uint256) private _allTokensIndex;
723 
724     /*
725      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
726      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
727      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
728      *
729      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
730      */
731     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
732 
733     /**
734      * @dev Constructor function.
735      */
736     constructor () public {
737         // register the supported interface to conform to ERC721Enumerable via ERC165
738         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
739     }
740 
741     /**
742      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
743      * @param owner address owning the tokens list to be accessed
744      * @param index uint256 representing the index to be accessed of the requested tokens list
745      * @return uint256 token ID at the given index of the tokens list owned by the requested address
746      */
747     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
748         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
749         return _ownedTokens[owner][index];
750     }
751 
752     /**
753      * @dev Gets the total amount of tokens stored by the contract.
754      * @return uint256 representing the total amount of tokens
755      */
756     function totalSupply() public view returns (uint256) {
757         return _allTokens.length;
758     }
759 
760     /**
761      * @dev Gets the token ID at a given index of all the tokens in this contract
762      * Reverts if the index is greater or equal to the total number of tokens.
763      * @param index uint256 representing the index to be accessed of the tokens list
764      * @return uint256 token ID at the given index of the tokens list
765      */
766     function tokenByIndex(uint256 index) public view returns (uint256) {
767         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
768         return _allTokens[index];
769     }
770 
771     /**
772      * @dev Internal function to transfer ownership of a given token ID to another address.
773      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
774      * @param from current owner of the token
775      * @param to address to receive the ownership of the given token ID
776      * @param tokenId uint256 ID of the token to be transferred
777      */
778     function _transferFrom(address from, address to, uint256 tokenId) internal {
779         super._transferFrom(from, to, tokenId);
780 
781         _removeTokenFromOwnerEnumeration(from, tokenId);
782 
783         _addTokenToOwnerEnumeration(to, tokenId);
784     }
785 
786     /**
787      * @dev Internal function to mint a new token.
788      * Reverts if the given token ID already exists.
789      * @param to address the beneficiary that will own the minted token
790      * @param tokenId uint256 ID of the token to be minted
791      */
792     function _mint(address to, uint256 tokenId) internal {
793         super._mint(to, tokenId);
794 
795         _addTokenToOwnerEnumeration(to, tokenId);
796 
797         _addTokenToAllTokensEnumeration(tokenId);
798     }
799 
800     /**
801      * @dev Internal function to burn a specific token.
802      * Reverts if the token does not exist.
803      * Deprecated, use {ERC721-_burn} instead.
804      * @param owner owner of the token to burn
805      * @param tokenId uint256 ID of the token being burned
806      */
807     function _burn(address owner, uint256 tokenId) internal {
808         super._burn(owner, tokenId);
809 
810         _removeTokenFromOwnerEnumeration(owner, tokenId);
811         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
812         _ownedTokensIndex[tokenId] = 0;
813 
814         _removeTokenFromAllTokensEnumeration(tokenId);
815     }
816 
817     /**
818      * @dev Gets the list of token IDs of the requested owner.
819      * @param owner address owning the tokens
820      * @return uint256[] List of token IDs owned by the requested address
821      */
822     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
823         return _ownedTokens[owner];
824     }
825 
826     /**
827      * @dev Private function to add a token to this extension's ownership-tracking data structures.
828      * @param to address representing the new owner of the given token ID
829      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
830      */
831     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
832         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
833         _ownedTokens[to].push(tokenId);
834     }
835 
836     /**
837      * @dev Private function to add a token to this extension's token tracking data structures.
838      * @param tokenId uint256 ID of the token to be added to the tokens list
839      */
840     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
841         _allTokensIndex[tokenId] = _allTokens.length;
842         _allTokens.push(tokenId);
843     }
844 
845     /**
846      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
847      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
848      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
849      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
850      * @param from address representing the previous owner of the given token ID
851      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
852      */
853     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
854         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
855         // then delete the last slot (swap and pop).
856 
857         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
858         uint256 tokenIndex = _ownedTokensIndex[tokenId];
859 
860         // When the token to delete is the last token, the swap operation is unnecessary
861         if (tokenIndex != lastTokenIndex) {
862             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
863 
864             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
865             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
866         }
867 
868         // This also deletes the contents at the last position of the array
869         _ownedTokens[from].length--;
870 
871         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
872         // lastTokenId, or just over the end of the array if the token was the last one).
873     }
874 
875     /**
876      * @dev Private function to remove a token from this extension's token tracking data structures.
877      * This has O(1) time complexity, but alters the order of the _allTokens array.
878      * @param tokenId uint256 ID of the token to be removed from the tokens list
879      */
880     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
881         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
882         // then delete the last slot (swap and pop).
883 
884         uint256 lastTokenIndex = _allTokens.length.sub(1);
885         uint256 tokenIndex = _allTokensIndex[tokenId];
886 
887         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
888         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
889         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
890         uint256 lastTokenId = _allTokens[lastTokenIndex];
891 
892         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
893         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
894 
895         // This also deletes the contents at the last position of the array
896         _allTokens.length--;
897         _allTokensIndex[tokenId] = 0;
898     }
899 }
900 
901 contract IERC721Metadata is IERC721 {
902     function name() external view returns (string memory);
903     function symbol() external view returns (string memory);
904     function tokenURI(uint256 tokenId) external view returns (string memory);
905 }
906 
907 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
908     // Token name
909     string private _name;
910 
911     // Token symbol
912     string private _symbol;
913 
914     // Optional mapping for token URIs
915     mapping(uint256 => string) private _tokenURIs;
916 
917     /*
918      *     bytes4(keccak256('name()')) == 0x06fdde03
919      *     bytes4(keccak256('symbol()')) == 0x95d89b41
920      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
921      *
922      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
923      */
924     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
925 
926     /**
927      * @dev Constructor function
928      */
929     constructor (string memory name, string memory symbol) public {
930         _name = name;
931         _symbol = symbol;
932 
933         // register the supported interfaces to conform to ERC721 via ERC165
934         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
935     }
936 
937     /**
938      * @dev Gets the token name.
939      * @return string representing the token name
940      */
941     function name() external view returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev Gets the token symbol.
947      * @return string representing the token symbol
948      */
949     function symbol() external view returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev Returns an URI for a given token ID.
955      * Throws if the token ID does not exist. May return an empty string.
956      * @param tokenId uint256 ID of the token to query
957      */
958     function tokenURI(uint256 tokenId) external view returns (string memory) {
959         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
960         return _tokenURIs[tokenId];
961     }
962 
963     /**
964      * @dev Internal function to set the token URI for a given token.
965      * Reverts if the token ID does not exist.
966      * @param tokenId uint256 ID of the token to set its URI
967      * @param uri string URI to assign
968      */
969     function _setTokenURI(uint256 tokenId, string memory uri) internal {
970         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
971         _tokenURIs[tokenId] = uri;
972     }
973 
974     /**
975      * @dev Internal function to burn a specific token.
976      * Reverts if the token does not exist.
977      * Deprecated, use _burn(uint256) instead.
978      * @param owner owner of the token to burn
979      * @param tokenId uint256 ID of the token being burned by the msg.sender
980      */
981     function _burn(address owner, uint256 tokenId) internal {
982         super._burn(owner, tokenId);
983 
984         // Clear metadata (if any)
985         if (bytes(_tokenURIs[tokenId]).length != 0) {
986             delete _tokenURIs[tokenId];
987         }
988     }
989 }
990 
991 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
992     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
993         // solhint-disable-previous-line no-empty-blocks
994     }
995 }
996 
997 contract Ownable is Context {
998     address private _owner;
999 
1000     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1001 
1002     /**
1003      * @dev Initializes the contract setting the deployer as the initial owner.
1004      */
1005     constructor () internal {
1006         _owner = _msgSender();
1007         emit OwnershipTransferred(address(0), _owner);
1008     }
1009 
1010     /**
1011      * @dev Returns the address of the current owner.
1012      */
1013     function owner() public view returns (address) {
1014         return _owner;
1015     }
1016 
1017     /**
1018      * @dev Throws if called by any account other than the owner.
1019      */
1020     modifier onlyOwner() {
1021         require(isOwner(), "Ownable: caller is not the owner");
1022         _;
1023     }
1024 
1025     /**
1026      * @dev Returns true if the caller is the current owner.
1027      */
1028     function isOwner() public view returns (bool) {
1029         return _msgSender() == _owner;
1030     }
1031 
1032     /**
1033      * @dev Leaves the contract without owner. It will not be possible to call
1034      * `onlyOwner` functions anymore. Can only be called by the current owner.
1035      *
1036      * NOTE: Renouncing ownership will leave the contract without an owner,
1037      * thereby removing any functionality that is only available to the owner.
1038      */
1039     function renounceOwnership() public onlyOwner {
1040         emit OwnershipTransferred(_owner, address(0));
1041         _owner = address(0);
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1046      * Can only be called by the current owner.
1047      */
1048     function transferOwnership(address newOwner) public onlyOwner {
1049         _transferOwnership(newOwner);
1050     }
1051 
1052     /**
1053      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1054      */
1055     function _transferOwnership(address newOwner) internal {
1056         require(newOwner != address(0), "Ownable: new owner is the zero address");
1057         emit OwnershipTransferred(_owner, newOwner);
1058         _owner = newOwner;
1059     }
1060 }
1061 
1062 library String {
1063 
1064     /**
1065      * @dev Converts a `uint256` to a `string`.
1066      * via OraclizeAPI - MIT licence
1067      * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1068      */
1069     function fromUint(uint256 value) internal pure returns (string memory) {
1070         if (value == 0) {
1071             return "0";
1072         }
1073         uint256 temp = value;
1074         uint256 digits;
1075         while (temp != 0) {
1076             digits++;
1077             temp /= 10;
1078         }
1079         bytes memory buffer = new bytes(digits);
1080         uint256 index = digits - 1;
1081         temp = value;
1082         while (temp != 0) {
1083             buffer[index--] = byte(uint8(48 + temp % 10));
1084             temp /= 10;
1085         }
1086         return string(buffer);
1087     }
1088 
1089     bytes constant alphabet = "0123456789abcdef";
1090 
1091     function fromAddress(address _addr) internal pure returns(string memory) {
1092         bytes32 value = bytes32(uint256(_addr));
1093         bytes memory str = new bytes(42);
1094         str[0] = '0';
1095         str[1] = 'x';
1096         for (uint i = 0; i < 20; i++) {
1097             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
1098             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0F))];
1099         }
1100         return string(str);
1101     }
1102 
1103 }
1104 
1105 contract GenericAsset is ERC721Full, Ownable {
1106 
1107     bool public isTradable;
1108 
1109     Counters.Counter public _tokenIds;
1110 
1111     mapping (address => bool) public approvedMinters;
1112 
1113     string public constant baseURI = "https://api.immutable.com/asset/";
1114 
1115     constructor(
1116         string memory _name,
1117         string memory _ticker
1118     )
1119         ERC721Full(_name, _ticker) 
1120         public 
1121     {
1122         setMinterStatus(msg.sender, true);
1123     }
1124 
1125     event MinterStatusChanged(
1126         address minter,
1127         bool status
1128     );
1129 
1130     event TradabilityStatusChanged(
1131         bool status
1132     );
1133 
1134     modifier onlyMinters(address _minter) {
1135         require(
1136             approvedMinters[_minter] == true,
1137             "Generic Asset: not an approved minter"
1138         );
1139         _;
1140     }
1141 
1142     /**
1143      * @dev Set the status of a minter
1144      *
1145      * @param _minter Address of the minter
1146      * @param _status Boolean whether they can or cannot mint assets
1147      */
1148     function setMinterStatus(
1149         address _minter,
1150         bool _status
1151     ) 
1152         public
1153         onlyOwner
1154     {
1155         approvedMinters[_minter] = _status;
1156 
1157         emit MinterStatusChanged(_minter, _status);
1158     }
1159 
1160     /**
1161      * @dev Set trading to be enabled or disabled.
1162      *
1163      * @param _status Pass true or false to enable/disable trading
1164      */
1165     function setTradabilityStatus(
1166         bool _status
1167     )  
1168         public
1169         onlyOwner
1170     {
1171         isTradable = _status;
1172 
1173         emit TradabilityStatusChanged(_status);
1174     }
1175 
1176     /**
1177      * @dev Transfer cards to another address. Trading must be unlocked to transfer.
1178      * Can be called by the owner or an approved spender.
1179      * 
1180      * @param from The owner of the card
1181      * @param to The recipient of the card to send to
1182      * @param tokenId The id of the card you'd like to transfer
1183      */
1184     function _transferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     )
1189         internal
1190 
1191     {
1192         require(
1193             isTradable == true,
1194             "Generic Asset: not yet tradable"
1195         );
1196 
1197         super._transferFrom(from, to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev Get the URI scheme of the token
1202      *
1203      * @param _tokenId is the ID of the token to get the URI for
1204      */
1205     function tokenURI(
1206         uint256 _tokenId
1207     ) 
1208         external 
1209         view 
1210         returns (string memory) 
1211     {
1212         return string(abi.encodePacked(
1213             baseURI,
1214             String.fromAddress(address(this)),
1215             "/",
1216             String.fromUint(_tokenId)
1217         ));
1218     }
1219 
1220     function totalSupply() 
1221         public 
1222         view 
1223         returns (uint256) 
1224     {
1225         return _tokenIds.current();
1226     }
1227 }
1228 
1229 contract RaffleItem is GenericAsset {
1230 
1231     event RaffleItemMinted(
1232         uint256 tokenId,
1233         address owner
1234     );
1235 
1236     constructor(
1237         string memory _name,
1238         string memory _ticker
1239     )
1240         GenericAsset(_name, _ticker) 
1241         public 
1242     {
1243         setMinterStatus(msg.sender, true);
1244     }
1245 
1246     /**
1247      * @dev Mint multiple items
1248      *
1249      * @param _to The owners to receive the assets
1250      */
1251     function mintMultiple(
1252         address[] memory _to
1253     )
1254         public
1255         onlyMinters(msg.sender)
1256     {
1257         for (uint i = 0; i < _to.length; i++) {
1258             mint(_to[i]);
1259         }
1260     }
1261 
1262     /**
1263      * @dev Mint a single item
1264      *
1265      * @param _to The owner to receive the asset
1266      */
1267     function mint(
1268         address _to
1269     )
1270         public
1271         onlyMinters(msg.sender)
1272         returns (uint256 tokenId)
1273     {
1274         _tokenIds.increment();
1275 
1276         uint256 newItemId = _tokenIds.current();
1277         _mint(_to, newItemId);
1278 
1279         emit RaffleItemMinted(newItemId, _to);
1280 
1281         return newItemId;
1282     }
1283 }