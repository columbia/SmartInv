1 pragma solidity ^0.5.1;
2 
3 interface IERC165 {
4     /**
5      * @dev Returns true if this contract implements the interface defined by
6      * `interfaceId`. See the corresponding
7      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
8      * to learn more about how these ids are created.
9      *
10      * This function call must use less than 30 000 gas.
11      */
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 contract ERC165 is IERC165 {
15     /*
16      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
17      */
18     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
19 
20     /**
21      * @dev Mapping of interface ids to whether or not it's supported.
22      */
23     mapping(bytes4 => bool) private _supportedInterfaces;
24 
25     constructor () internal {
26         // Derived contracts need only register support for their own interfaces,
27         // we register support for ERC165 itself here
28         _registerInterface(_INTERFACE_ID_ERC165);
29     }
30 
31     /**
32      * @dev See {IERC165-supportsInterface}.
33      *
34      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
37         return _supportedInterfaces[interfaceId];
38     }
39 
40     /**
41      * @dev Registers the contract as an implementer of the interface defined by
42      * `interfaceId`. Support of the actual ERC165 interface is automatic and
43      * registering its interface id is not required.
44      *
45      * See {IERC165-supportsInterface}.
46      *
47      * Requirements:
48      *
49      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
50      */
51     function _registerInterface(bytes4 interfaceId) internal {
52         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
53         _supportedInterfaces[interfaceId] = true;
54     }
55 }
56 library Address {
57     /**
58      * @dev Returns true if `account` is a contract.
59      *
60      * This test is non-exhaustive, and there may be false-negatives: during the
61      * execution of a contract's constructor, its address will be reported as
62      * not containing a contract.
63      *
64      * IMPORTANT: It is unsafe to assume that an address for which this
65      * function returns false is an externally-owned account (EOA) and not a
66      * contract.
67      */
68     function isContract(address account) internal view returns (bool) {
69         // This method relies in extcodesize, which returns 0 for contracts in
70         // construction, since the code is only stored at the end of the
71         // constructor execution.
72 
73         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
74         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
75         // for accounts without code, i.e. `keccak256('')`
76         bytes32 codehash;
77         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
78         // solhint-disable-next-line no-inline-assembly
79         assembly { codehash := extcodehash(account) }
80         return (codehash != 0x0 && codehash != accountHash);
81     }
82 
83     /**
84      * @dev Converts an `address` into `address payable`. Note that this is
85      * simply a type cast: the actual underlying value is not changed.
86      *
87      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
88      * @dev Get it via `npm install @openzeppelin/contracts@next`.
89      */
90     function toPayable(address account) internal pure returns (address payable) {
91         return address(uint160(account));
92     }
93 }
94 
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      * - Subtraction cannot overflow.
133      *
134      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
135      * @dev Get it via `npm install @openzeppelin/contracts@next`.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
193      * @dev Get it via `npm install @openzeppelin/contracts@next`.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         // Solidity only automatically asserts when dividing by 0
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      * - The divisor cannot be zero.
229      *
230      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
231      * @dev Get it via `npm install @openzeppelin/contracts@next`.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 library Counters {
239     using SafeMath for uint256;
240 
241     struct Counter {
242         // This variable should never be directly accessed by users of the library: interactions must be restricted to
243         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
244         // this feature: see https://github.com/ethereum/solidity/issues/4637
245         uint256 _value; // default: 0
246     }
247 
248     function current(Counter storage counter) internal view returns (uint256) {
249         return counter._value;
250     }
251 
252     function increment(Counter storage counter) internal {
253         // The {SafeMath} overflow check can be skipped here, see the comment at the top
254         counter._value += 1;
255     }
256 
257     function decrement(Counter storage counter) internal {
258         counter._value = counter._value.sub(1);
259     }
260 }
261 contract Context {
262     // Empty internal constructor, to prevent people from mistakenly deploying
263     // an instance of this contract, which should be used via inheritance.
264     constructor () internal { }
265     // solhint-disable-previous-line no-empty-blocks
266 
267     function _msgSender() internal view returns (address payable) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view returns (bytes memory) {
272         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
273         return msg.data;
274     }
275 }
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor () internal {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(isOwner(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Returns true if the caller is the current owner.
316      */
317     function isOwner() public view returns (bool) {
318         return _msgSender() == _owner;
319     }
320 
321     /**
322      * @dev Leaves the contract without owner. It will not be possible to call
323      * `onlyOwner` functions anymore. Can only be called by the current owner.
324      *
325      * NOTE: Renouncing ownership will leave the contract without an owner,
326      * thereby removing any functionality that is only available to the owner.
327      */
328     function renounceOwnership() public onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public onlyOwner {
338         _transferOwnership(newOwner);
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      */
344     function _transferOwnership(address newOwner) internal {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         emit OwnershipTransferred(_owner, newOwner);
347         _owner = newOwner;
348     }
349 }
350 contract IERC721Receiver {
351     /**
352      * @notice Handle the receipt of an NFT
353      * @dev The ERC721 smart contract calls this function on the recipient
354      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
355      * otherwise the caller will revert the transaction. The selector to be
356      * returned can be obtained as `this.onERC721Received.selector`. This
357      * function MAY throw to revert and reject the transfer.
358      * Note: the ERC721 contract address is always the message sender.
359      * @param operator The address which called `safeTransferFrom` function
360      * @param from The address which previously owned the token
361      * @param tokenId The NFT identifier which is being transferred
362      * @param data Additional data with no specified format
363      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
364      */
365     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
366     public returns (bytes4);
367 }
368 contract IERC721 is IERC165 {
369     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
370     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of NFTs in `owner`'s account.
375      */
376     function balanceOf(address owner) public view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the NFT specified by `tokenId`.
380      */
381     function ownerOf(uint256 tokenId) public view returns (address owner);
382 
383     /**
384      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
385      * another (`to`).
386      *
387      *
388      *
389      * Requirements:
390      * - `from`, `to` cannot be zero.
391      * - `tokenId` must be owned by `from`.
392      * - If the caller is not `from`, it must be have been allowed to move this
393      * NFT by either {approve} or {setApprovalForAll}.
394      */
395     function safeTransferFrom(address from, address to, uint256 tokenId) public;
396     /**
397      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
398      * another (`to`).
399      *
400      * Requirements:
401      * - If the caller is not `from`, it must be approved to move this NFT by
402      * either {approve} or {setApprovalForAll}.
403      */
404     function transferFrom(address from, address to, uint256 tokenId) public;
405     function approve(address to, uint256 tokenId) public;
406     function getApproved(uint256 tokenId) public view returns (address operator);
407 
408     function setApprovalForAll(address operator, bool _approved) public;
409     function isApprovedForAll(address owner, address operator) public view returns (bool);
410 
411 
412     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
413 }
414 contract IERC721Metadata is IERC721 {
415     function name() external view returns (string memory);
416     function symbol() external view returns (string memory);
417     function tokenURI(uint256 tokenId) external view returns (string memory);
418 }
419 contract ERC721 is Context, ERC165, IERC721 {
420     using SafeMath for uint256;
421     using Address for address;
422     using Counters for Counters.Counter;
423 
424     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
425     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
426     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
427 
428     // Mapping from token ID to owner
429     mapping (uint256 => address) private _tokenOwner;
430 
431     // Mapping from token ID to approved address
432     mapping (uint256 => address) private _tokenApprovals;
433 
434     // Mapping from owner to number of owned token
435     mapping (address => Counters.Counter) private _ownedTokensCount;
436 
437     // Mapping from owner to operator approvals
438     mapping (address => mapping (address => bool)) private _operatorApprovals;
439 
440     /*
441      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
442      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
443      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
444      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
445      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
446      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
447      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
448      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
449      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
450      *
451      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
452      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
453      */
454     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
455 
456     constructor () public {
457         // register the supported interfaces to conform to ERC721 via ERC165
458         _registerInterface(_INTERFACE_ID_ERC721);
459     }
460 
461     /**
462      * @dev Gets the balance of the specified address.
463      * @param owner address to query the balance of
464      * @return uint256 representing the amount owned by the passed address
465      */
466     function balanceOf(address owner) public view returns (uint256) {
467         require(owner != address(0), "ERC721: balance query for the zero address");
468 
469         return _ownedTokensCount[owner].current();
470     }
471 
472     /**
473      * @dev Gets the owner of the specified token ID.
474      * @param tokenId uint256 ID of the token to query the owner of
475      * @return address currently marked as the owner of the given token ID
476      */
477     function ownerOf(uint256 tokenId) public view returns (address) {
478         address owner = _tokenOwner[tokenId];
479         require(owner != address(0), "ERC721: owner query for nonexistent token");
480 
481         return owner;
482     }
483 
484     /**
485      * @dev Approves another address to transfer the given token ID
486      * The zero address indicates there is no approved address.
487      * There can only be one approved address per token at a given time.
488      * Can only be called by the token owner or an approved operator.
489      * @param to address to be approved for the given token ID
490      * @param tokenId uint256 ID of the token to be approved
491      */
492     function approve(address to, uint256 tokenId) public {
493         address owner = ownerOf(tokenId);
494         require(to != owner, "ERC721: approval to current owner");
495 
496         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
497             "ERC721: approve caller is not owner nor approved for all"
498         );
499 
500         _tokenApprovals[tokenId] = to;
501         emit Approval(owner, to, tokenId);
502     }
503 
504     /**
505      * @dev Gets the approved address for a token ID, or zero if no address set
506      * Reverts if the token ID does not exist.
507      * @param tokenId uint256 ID of the token to query the approval of
508      * @return address currently approved for the given token ID
509      */
510     function getApproved(uint256 tokenId) public view returns (address) {
511         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
512 
513         return _tokenApprovals[tokenId];
514     }
515 
516     /**
517      * @dev Sets or unsets the approval of a given operator
518      * An operator is allowed to transfer all tokens of the sender on their behalf.
519      * @param to operator address to set the approval
520      * @param approved representing the status of the approval to be set
521      */
522     function setApprovalForAll(address to, bool approved) public {
523         require(to != _msgSender(), "ERC721: approve to caller");
524 
525         _operatorApprovals[_msgSender()][to] = approved;
526         emit ApprovalForAll(_msgSender(), to, approved);
527     }
528 
529     /**
530      * @dev Tells whether an operator is approved by a given owner.
531      * @param owner owner address which you want to query the approval of
532      * @param operator operator address which you want to query the approval of
533      * @return bool whether the given operator is approved by the given owner
534      */
535     function isApprovedForAll(address owner, address operator) public view returns (bool) {
536         return _operatorApprovals[owner][operator];
537     }
538 
539     /**
540      * @dev Transfers the ownership of a given token ID to another address.
541      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
542      * Requires the msg.sender to be the owner, approved, or operator.
543      * @param from current owner of the token
544      * @param to address to receive the ownership of the given token ID
545      * @param tokenId uint256 ID of the token to be transferred
546      */
547     function transferFrom(address from, address to, uint256 tokenId) public {
548         //solhint-disable-next-line max-line-length
549         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
550 
551         _transferFrom(from, to, tokenId);
552     }
553 
554     /**
555      * @dev Safely transfers the ownership of a given token ID to another address
556      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
557      * which is called upon a safe transfer, and return the magic value
558      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
559      * the transfer is reverted.
560      * Requires the msg.sender to be the owner, approved, or operator
561      * @param from current owner of the token
562      * @param to address to receive the ownership of the given token ID
563      * @param tokenId uint256 ID of the token to be transferred
564      */
565     function safeTransferFrom(address from, address to, uint256 tokenId) public {
566         safeTransferFrom(from, to, tokenId, "");
567     }
568 
569     /**
570      * @dev Safely transfers the ownership of a given token ID to another address
571      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
572      * which is called upon a safe transfer, and return the magic value
573      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
574      * the transfer is reverted.
575      * Requires the _msgSender() to be the owner, approved, or operator
576      * @param from current owner of the token
577      * @param to address to receive the ownership of the given token ID
578      * @param tokenId uint256 ID of the token to be transferred
579      * @param _data bytes data to send along with a safe transfer check
580      */
581     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
582         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
583         _safeTransferFrom(from, to, tokenId, _data);
584     }
585 
586     /**
587      * @dev Safely transfers the ownership of a given token ID to another address
588      * If the target address is a contract, it must implement `onERC721Received`,
589      * which is called upon a safe transfer, and return the magic value
590      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
591      * the transfer is reverted.
592      * Requires the msg.sender to be the owner, approved, or operator
593      * @param from current owner of the token
594      * @param to address to receive the ownership of the given token ID
595      * @param tokenId uint256 ID of the token to be transferred
596      * @param _data bytes data to send along with a safe transfer check
597      */
598     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
599         _transferFrom(from, to, tokenId);
600         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
601     }
602 
603     /**
604      * @dev Returns whether the specified token exists.
605      * @param tokenId uint256 ID of the token to query the existence of
606      * @return bool whether the token exists
607      */
608     function _exists(uint256 tokenId) internal view returns (bool) {
609         address owner = _tokenOwner[tokenId];
610         return owner != address(0);
611     }
612 
613     /**
614      * @dev Returns whether the given spender can transfer a given token ID.
615      * @param spender address of the spender to query
616      * @param tokenId uint256 ID of the token to be transferred
617      * @return bool whether the msg.sender is approved for the given token ID,
618      * is an operator of the owner, or is the owner of the token
619      */
620     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
621         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
622         address owner = ownerOf(tokenId);
623         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
624     }
625 
626     /**
627      * @dev Internal function to safely mint a new token.
628      * Reverts if the given token ID already exists.
629      * If the target address is a contract, it must implement `onERC721Received`,
630      * which is called upon a safe transfer, and return the magic value
631      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
632      * the transfer is reverted.
633      * @param to The address that will own the minted token
634      * @param tokenId uint256 ID of the token to be minted
635      */
636     function _safeMint(address to, uint256 tokenId) internal {
637         _safeMint(to, tokenId, "");
638     }
639 
640     /**
641      * @dev Internal function to safely mint a new token.
642      * Reverts if the given token ID already exists.
643      * If the target address is a contract, it must implement `onERC721Received`,
644      * which is called upon a safe transfer, and return the magic value
645      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
646      * the transfer is reverted.
647      * @param to The address that will own the minted token
648      * @param tokenId uint256 ID of the token to be minted
649      * @param _data bytes data to send along with a safe transfer check
650      */
651     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
652         _mint(to, tokenId);
653         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
654     }
655 
656     /**
657      * @dev Internal function to mint a new token.
658      * Reverts if the given token ID already exists.
659      * @param to The address that will own the minted token
660      * @param tokenId uint256 ID of the token to be minted
661      */
662     function _mint(address to, uint256 tokenId) internal {
663         require(to != address(0), "ERC721: mint to the zero address");
664         require(!_exists(tokenId), "ERC721: token already minted");
665 
666         _tokenOwner[tokenId] = to;
667         _ownedTokensCount[to].increment();
668 
669         emit Transfer(address(0), to, tokenId);
670     }
671 
672     /**
673      * @dev Internal function to burn a specific token.
674      * Reverts if the token does not exist.
675      * Deprecated, use {_burn} instead.
676      * @param owner owner of the token to burn
677      * @param tokenId uint256 ID of the token being burned
678      */
679     function _burn(address owner, uint256 tokenId) internal {
680         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
681 
682         _clearApproval(tokenId);
683 
684         _ownedTokensCount[owner].decrement();
685         _tokenOwner[tokenId] = address(0);
686 
687         emit Transfer(owner, address(0), tokenId);
688     }
689 
690     /**
691      * @dev Internal function to burn a specific token.
692      * Reverts if the token does not exist.
693      * @param tokenId uint256 ID of the token being burned
694      */
695     function _burn(uint256 tokenId) internal {
696         _burn(ownerOf(tokenId), tokenId);
697     }
698 
699     /**
700      * @dev Internal function to transfer ownership of a given token ID to another address.
701      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
702      * @param from current owner of the token
703      * @param to address to receive the ownership of the given token ID
704      * @param tokenId uint256 ID of the token to be transferred
705      */
706     function _transferFrom(address from, address to, uint256 tokenId) internal {
707         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
708         require(to != address(0), "ERC721: transfer to the zero address");
709 
710         _clearApproval(tokenId);
711 
712         _ownedTokensCount[from].decrement();
713         _ownedTokensCount[to].increment();
714 
715         _tokenOwner[tokenId] = to;
716 
717         emit Transfer(from, to, tokenId);
718     }
719 
720     /**
721      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
722      * The call is not executed if the target address is not a contract.
723      *
724      * This function is deprecated.
725      * @param from address representing the previous owner of the given token ID
726      * @param to target address that will receive the tokens
727      * @param tokenId uint256 ID of the token to be transferred
728      * @param _data bytes optional data to send along with the call
729      * @return bool whether the call correctly returned the expected magic value
730      */
731     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
732         internal returns (bool)
733     {
734         if (!to.isContract()) {
735             return true;
736         }
737 
738         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
739         return (retval == _ERC721_RECEIVED);
740     }
741 
742     /**
743      * @dev Private function to clear current approval of a given token ID.
744      * @param tokenId uint256 ID of the token to be transferred
745      */
746     function _clearApproval(uint256 tokenId) private {
747         if (_tokenApprovals[tokenId] != address(0)) {
748             _tokenApprovals[tokenId] = address(0);
749         }
750     }
751 }
752 contract ERC721Metadata is Context, ERC721, IERC721Metadata {
753     // Token name
754     string private _name;
755 
756     // Token symbol
757     string private _symbol;
758 
759     // Optional mapping for token URIs
760     mapping(uint256 => string) private _tokenURIs;
761 
762     /*
763      *     bytes4(keccak256('name()')) == 0x06fdde03
764      *     bytes4(keccak256('symbol()')) == 0x95d89b41
765      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
766      *
767      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
768      */
769     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
770 
771     /**
772      * @dev Constructor function
773      */
774     constructor (string memory name, string memory symbol) public {
775         _name = name;
776         _symbol = symbol;
777 
778         // register the supported interfaces to conform to ERC721 via ERC165
779         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
780     }
781 
782     /**
783      * @dev Gets the token name.
784      * @return string representing the token name
785      */
786     function name() external view returns (string memory) {
787         return _name;
788     }
789 
790     /**
791      * @dev Gets the token symbol.
792      * @return string representing the token symbol
793      */
794     function symbol() external view returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev Returns an URI for a given token ID.
800      * Throws if the token ID does not exist. May return an empty string.
801      * @param tokenId uint256 ID of the token to query
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory) {
804         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805         return _tokenURIs[tokenId];
806     }
807 
808     /**
809      * @dev Internal function to set the token URI for a given token.
810      * Reverts if the token ID does not exist.
811      * @param tokenId uint256 ID of the token to set its URI
812      * @param uri string URI to assign
813      */
814     function _setTokenURI(uint256 tokenId, string memory uri) internal {
815         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
816         _tokenURIs[tokenId] = uri;
817     }
818 
819     /**
820      * @dev Internal function to burn a specific token.
821      * Reverts if the token does not exist.
822      * Deprecated, use _burn(uint256) instead.
823      * @param owner owner of the token to burn
824      * @param tokenId uint256 ID of the token being burned by the msg.sender
825      */
826     function _burn(address owner, uint256 tokenId) internal {
827         super._burn(owner, tokenId);
828 
829         // Clear metadata (if any)
830         if (bytes(_tokenURIs[tokenId]).length != 0) {
831             delete _tokenURIs[tokenId];
832         }
833     }
834 }
835 /**
836  * @dev Required interface of an ERC721 compliant contract.
837  */
838 contract IERC721Enumerable is IERC721 {
839     function totalSupply() public view returns (uint256);
840     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
841 
842     function tokenByIndex(uint256 index) public view returns (uint256);
843 }
844 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
845     // Mapping from owner to list of owned token IDs
846     mapping(address => uint256[]) private _ownedTokens;
847 
848     // Mapping from token ID to index of the owner tokens list
849     mapping(uint256 => uint256) private _ownedTokensIndex;
850 
851     // Array with all token ids, used for enumeration
852     uint256[] private _allTokens;
853 
854     // Mapping from token id to position in the allTokens array
855     mapping(uint256 => uint256) private _allTokensIndex;
856 
857     /*
858      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
859      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
860      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
861      *
862      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
863      */
864     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
865 
866     /**
867      * @dev Constructor function.
868      */
869     constructor () public {
870         // register the supported interface to conform to ERC721Enumerable via ERC165
871         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
872     }
873 
874     /**
875      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
876      * @param owner address owning the tokens list to be accessed
877      * @param index uint256 representing the index to be accessed of the requested tokens list
878      * @return uint256 token ID at the given index of the tokens list owned by the requested address
879      */
880     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
881         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
882         return _ownedTokens[owner][index];
883     }
884 
885     /**
886      * @dev Gets the total amount of tokens stored by the contract.
887      * @return uint256 representing the total amount of tokens
888      */
889     function totalSupply() public view returns (uint256) {
890         return _allTokens.length;
891     }
892 
893     /**
894      * @dev Gets the token ID at a given index of all the tokens in this contract
895      * Reverts if the index is greater or equal to the total number of tokens.
896      * @param index uint256 representing the index to be accessed of the tokens list
897      * @return uint256 token ID at the given index of the tokens list
898      */
899     function tokenByIndex(uint256 index) public view returns (uint256) {
900         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
901         return _allTokens[index];
902     }
903 
904     /**
905      * @dev Internal function to transfer ownership of a given token ID to another address.
906      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
907      * @param from current owner of the token
908      * @param to address to receive the ownership of the given token ID
909      * @param tokenId uint256 ID of the token to be transferred
910      */
911     function _transferFrom(address from, address to, uint256 tokenId) internal {
912         super._transferFrom(from, to, tokenId);
913 
914         _removeTokenFromOwnerEnumeration(from, tokenId);
915 
916         _addTokenToOwnerEnumeration(to, tokenId);
917     }
918 
919     /**
920      * @dev Internal function to mint a new token.
921      * Reverts if the given token ID already exists.
922      * @param to address the beneficiary that will own the minted token
923      * @param tokenId uint256 ID of the token to be minted
924      */
925     function _mint(address to, uint256 tokenId) internal {
926         super._mint(to, tokenId);
927 
928         _addTokenToOwnerEnumeration(to, tokenId);
929 
930         _addTokenToAllTokensEnumeration(tokenId);
931     }
932 
933     /**
934      * @dev Internal function to burn a specific token.
935      * Reverts if the token does not exist.
936      * Deprecated, use {ERC721-_burn} instead.
937      * @param owner owner of the token to burn
938      * @param tokenId uint256 ID of the token being burned
939      */
940     function _burn(address owner, uint256 tokenId) internal {
941         super._burn(owner, tokenId);
942 
943         _removeTokenFromOwnerEnumeration(owner, tokenId);
944         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
945         _ownedTokensIndex[tokenId] = 0;
946 
947         _removeTokenFromAllTokensEnumeration(tokenId);
948     }
949 
950     /**
951      * @dev Gets the list of token IDs of the requested owner.
952      * @param owner address owning the tokens
953      * @return uint256[] List of token IDs owned by the requested address
954      */
955     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
956         return _ownedTokens[owner];
957     }
958 
959     /**
960      * @dev Private function to add a token to this extension's ownership-tracking data structures.
961      * @param to address representing the new owner of the given token ID
962      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
963      */
964     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
965         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
966         _ownedTokens[to].push(tokenId);
967     }
968 
969     /**
970      * @dev Private function to add a token to this extension's token tracking data structures.
971      * @param tokenId uint256 ID of the token to be added to the tokens list
972      */
973     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
974         _allTokensIndex[tokenId] = _allTokens.length;
975         _allTokens.push(tokenId);
976     }
977 
978     /**
979      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
980      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
981      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
982      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
983      * @param from address representing the previous owner of the given token ID
984      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
985      */
986     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
987         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
988         // then delete the last slot (swap and pop).
989 
990         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
991         uint256 tokenIndex = _ownedTokensIndex[tokenId];
992 
993         // When the token to delete is the last token, the swap operation is unnecessary
994         if (tokenIndex != lastTokenIndex) {
995             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
996 
997             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
998             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
999         }
1000 
1001         // This also deletes the contents at the last position of the array
1002         _ownedTokens[from].length--;
1003 
1004         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1005         // lastTokenId, or just over the end of the array if the token was the last one).
1006     }
1007 
1008     /**
1009      * @dev Private function to remove a token from this extension's token tracking data structures.
1010      * This has O(1) time complexity, but alters the order of the _allTokens array.
1011      * @param tokenId uint256 ID of the token to be removed from the tokens list
1012      */
1013     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1014         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1015         // then delete the last slot (swap and pop).
1016 
1017         uint256 lastTokenIndex = _allTokens.length.sub(1);
1018         uint256 tokenIndex = _allTokensIndex[tokenId];
1019 
1020         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1021         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1022         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1023         uint256 lastTokenId = _allTokens[lastTokenIndex];
1024 
1025         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1026         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1027 
1028         // This also deletes the contents at the last position of the array
1029         _allTokens.length--;
1030         _allTokensIndex[tokenId] = 0;
1031     }
1032 }
1033 
1034 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1035     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1036         // solhint-disable-previous-line no-empty-blocks
1037     }
1038 }
1039 
1040 contract Kachicard is ERC721Full("Kachiage", "KACHI Card"), Ownable {
1041     uint256 cNFTID = 0;
1042     string public tokenMetadataBaseURI = "https://api.nagemon.com/nft/";
1043     address public cNFT_ADDRESS = address(0xAE27068c648BA514BDA71D431a4d345DdF1767c4);
1044     
1045   constructor () public { }
1046   event _register(address user, uint256 _tokenId);
1047   event _burnItem(uint256 tokenId);
1048   event _burnArrItem(uint256[] tokenIds);
1049     modifier onlyManager() {
1050         require(msg.sender == owner() || msg.sender == cNFT_ADDRESS);
1051         _;
1052     }
1053     function burn(uint256 tokenId) external{
1054         _burn(ownerOf(tokenId), tokenId);
1055         emit _burnItem(tokenId);
1056     }
1057     function burnArr(uint256[] memory tokenIds) public onlyOwner {
1058         for(uint256 i = 0; i < tokenIds.length; i++) {
1059             _burn(tokenIds[i]);
1060         }
1061         emit _burnArrItem(tokenIds);
1062     }
1063     function setCNFTAdress(address _cnft) public onlyOwner {
1064         cNFT_ADDRESS = _cnft;
1065     }
1066   function register(address user, uint8 _numItems) public onlyManager {
1067     for (uint8 j = 0; j < _numItems ; j++) {
1068       create(user);
1069     }
1070   }
1071     function create(address user) private {
1072     uint256 tokenId = ++cNFTID;
1073     _mint(user, tokenId);
1074     emit _register(user, tokenId);
1075   }
1076   
1077 }