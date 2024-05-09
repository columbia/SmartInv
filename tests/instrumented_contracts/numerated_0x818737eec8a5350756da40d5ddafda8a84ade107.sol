1 /*
2  * Crypto stamp 2 Pre-sale
3  * On-chain reservation token (ERC 1155) to be redeemed later for
4  * actual digital-physical collectible postage stamps
5  *
6  * Developed by Capacity Blockchain Solutions GmbH <capacity.at>
7  * for Österreichische Post AG <post.at>
8  */
9 
10 // File: @openzeppelin/contracts/math/SafeMath.sol
11 
12 pragma solidity ^0.6.0;
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations with added overflow
16  * checks.
17  *
18  * Arithmetic operations in Solidity wrap on overflow. This can easily result
19  * in bugs, because programmers usually assume that an overflow raises an
20  * error, which is the standard behavior in high level programming languages.
21  * `SafeMath` restores this intuition by reverting the transaction when an
22  * operation overflows.
23  *
24  * Using this library instead of the unchecked operations eliminates an entire
25  * class of bugs, so it's recommended to use it always.
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `*` operator.
78      *
79      * Requirements:
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         // Solidity only automatically asserts when dividing by 0
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/introspection/IERC165.sol
164 
165 pragma solidity ^0.6.0;
166 
167 /**
168  * @dev Interface of the ERC165 standard, as defined in the
169  * https://eips.ethereum.org/EIPS/eip-165[EIP].
170  *
171  * Implementers can declare support of contract interfaces, which can then be
172  * queried by others ({ERC165Checker}).
173  *
174  * For an implementation, see {ERC165}.
175  */
176 interface IERC165 {
177     /**
178      * @dev Returns true if this contract implements the interface defined by
179      * `interfaceId`. See the corresponding
180      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
181      * to learn more about how these ids are created.
182      *
183      * This function call must use less than 30 000 gas.
184      */
185     function supportsInterface(bytes4 interfaceId) external view returns (bool);
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
189 
190 pragma solidity ^0.6.2;
191 
192 
193 /**
194  * @dev Required interface of an ERC721 compliant contract.
195  */
196 interface IERC721 is IERC165 {
197     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     /**
202      * @dev Returns the number of NFTs in ``owner``'s account.
203      */
204     function balanceOf(address owner) external view returns (uint256 balance);
205 
206     /**
207      * @dev Returns the owner of the NFT specified by `tokenId`.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
213      * another (`to`).
214      *
215      *
216      *
217      * Requirements:
218      * - `from`, `to` cannot be zero.
219      * - `tokenId` must be owned by `from`.
220      * - If the caller is not `from`, it must be have been allowed to move this
221      * NFT by either {approve} or {setApprovalForAll}.
222      */
223     function safeTransferFrom(address from, address to, uint256 tokenId) external;
224     /**
225      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
226      * another (`to`).
227      *
228      * Requirements:
229      * - If the caller is not `from`, it must be approved to move this NFT by
230      * either {approve} or {setApprovalForAll}.
231      */
232     function transferFrom(address from, address to, uint256 tokenId) external;
233     function approve(address to, uint256 tokenId) external;
234     function getApproved(uint256 tokenId) external view returns (address operator);
235 
236     function setApprovalForAll(address operator, bool _approved) external;
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239 
240     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
244 
245 pragma solidity ^0.6.0;
246 
247 /**
248  * @dev Interface of the ERC20 standard as defined in the EIP.
249  */
250 interface IERC20 {
251     /**
252      * @dev Returns the amount of tokens in existence.
253      */
254     function totalSupply() external view returns (uint256);
255 
256     /**
257      * @dev Returns the amount of tokens owned by `account`.
258      */
259     function balanceOf(address account) external view returns (uint256);
260 
261     /**
262      * @dev Moves `amount` tokens from the caller's account to `recipient`.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transfer(address recipient, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Returns the remaining number of tokens that `spender` will be
272      * allowed to spend on behalf of `owner` through {transferFrom}. This is
273      * zero by default.
274      *
275      * This value changes when {approve} or {transferFrom} are called.
276      */
277     function allowance(address owner, address spender) external view returns (uint256);
278 
279     /**
280      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * IMPORTANT: Beware that changing an allowance with this method brings the risk
285      * that someone may use both the old and the new allowance by unfortunate
286      * transaction ordering. One possible solution to mitigate this race
287      * condition is to first reduce the spender's allowance to 0 and set the
288      * desired value afterwards:
289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address spender, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Moves `amount` tokens from `sender` to `recipient` using the
297      * allowance mechanism. `amount` is then deducted from the caller's
298      * allowance.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Emitted when `value` tokens are moved from one account (`from`) to
308      * another (`to`).
309      *
310      * Note that `value` may be zero.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 value);
313 
314     /**
315      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
316      * a call to {approve}. `value` is the new allowance.
317      */
318     event Approval(address indexed owner, address indexed spender, uint256 value);
319 }
320 
321 // File: contracts/OZ_ERC1155/IERC1155.sol
322 
323 pragma solidity ^0.6.0;
324 
325 
326 /**
327     @title ERC-1155 Multi Token Standard basic interface
328     @dev See https://eips.ethereum.org/EIPS/eip-1155
329  */
330 abstract contract IERC1155 is IERC165 {
331     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
332 
333     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
334 
335     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
336 
337     event URI(string value, uint256 indexed id);
338 
339     function balanceOf(address account, uint256 id) public view virtual returns (uint256);
340 
341     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view virtual returns (uint256[] memory);
342 
343     function setApprovalForAll(address operator, bool approved) external virtual;
344 
345     function isApprovedForAll(address account, address operator) external view virtual returns (bool);
346 
347     function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external virtual;
348 
349     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external virtual;
350 }
351 
352 // File: contracts/OZ_ERC1155/IERC1155Receiver.sol
353 
354 pragma solidity ^0.6.0;
355 
356 
357 /**
358     @title ERC-1155 Multi Token Receiver Interface
359     @dev See https://eips.ethereum.org/EIPS/eip-1155
360 */
361 interface IERC1155Receiver is IERC165 {
362 
363     /**
364         @dev Handles the receipt of a single ERC1155 token type. This function is
365         called at the end of a `safeTransferFrom` after the balance has been updated.
366         To accept the transfer, this must return
367         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
368         (i.e. 0xf23a6e61, or its own function selector).
369         @param operator The address which initiated the transfer (i.e. msg.sender)
370         @param from The address which previously owned the token
371         @param id The ID of the token being transferred
372         @param value The amount of tokens being transferred
373         @param data Additional data with no specified format
374         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
375     */
376     function onERC1155Received(
377         address operator,
378         address from,
379         uint256 id,
380         uint256 value,
381         bytes calldata data
382     )
383         external
384         returns(bytes4);
385 
386     /**
387         @dev Handles the receipt of a multiple ERC1155 token types. This function
388         is called at the end of a `safeBatchTransferFrom` after the balances have
389         been updated. To accept the transfer(s), this must return
390         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
391         (i.e. 0xbc197c81, or its own function selector).
392         @param operator The address which initiated the batch transfer (i.e. msg.sender)
393         @param from The address which previously owned the token
394         @param ids An array containing ids of each token being transferred (order and length must match values array)
395         @param values An array containing amounts of each token being transferred (order and length must match ids array)
396         @param data Additional data with no specified format
397         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
398     */
399     function onERC1155BatchReceived(
400         address operator,
401         address from,
402         uint256[] calldata ids,
403         uint256[] calldata values,
404         bytes calldata data
405     )
406         external
407         returns(bytes4);
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 pragma solidity ^0.6.2;
413 
414 /**
415  * @dev Collection of functions related to the address type
416  */
417 library Address {
418     /**
419      * @dev Returns true if `account` is a contract.
420      *
421      * [IMPORTANT]
422      * ====
423      * It is unsafe to assume that an address for which this function returns
424      * false is an externally-owned account (EOA) and not a contract.
425      *
426      * Among others, `isContract` will return false for the following
427      * types of addresses:
428      *
429      *  - an externally-owned account
430      *  - a contract in construction
431      *  - an address where a contract will be created
432      *  - an address where a contract lived, but was destroyed
433      * ====
434      */
435     function isContract(address account) internal view returns (bool) {
436         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
437         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
438         // for accounts without code, i.e. `keccak256('')`
439         bytes32 codehash;
440         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
441         // solhint-disable-next-line no-inline-assembly
442         assembly { codehash := extcodehash(account) }
443         return (codehash != accountHash && codehash != 0x0);
444     }
445 
446     /**
447      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
448      * `recipient`, forwarding all available gas and reverting on errors.
449      *
450      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
451      * of certain opcodes, possibly making contracts go over the 2300 gas limit
452      * imposed by `transfer`, making them unable to receive funds via
453      * `transfer`. {sendValue} removes this limitation.
454      *
455      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
456      *
457      * IMPORTANT: because control is transferred to `recipient`, care must be
458      * taken to not create reentrancy vulnerabilities. Consider using
459      * {ReentrancyGuard} or the
460      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
461      */
462     function sendValue(address payable recipient, uint256 amount) internal {
463         require(address(this).balance >= amount, "Address: insufficient balance");
464 
465         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
466         (bool success, ) = recipient.call{ value: amount }("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 }
470 
471 // File: @openzeppelin/contracts/introspection/ERC165.sol
472 
473 pragma solidity ^0.6.0;
474 
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts may inherit from this and call {_registerInterface} to declare
480  * their support of an interface.
481  */
482 contract ERC165 is IERC165 {
483     /*
484      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
485      */
486     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
487 
488     /**
489      * @dev Mapping of interface ids to whether or not it's supported.
490      */
491     mapping(bytes4 => bool) private _supportedInterfaces;
492 
493     constructor () internal {
494         // Derived contracts need only register support for their own interfaces,
495         // we register support for ERC165 itself here
496         _registerInterface(_INTERFACE_ID_ERC165);
497     }
498 
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      *
502      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
503      */
504     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
505         return _supportedInterfaces[interfaceId];
506     }
507 
508     /**
509      * @dev Registers the contract as an implementer of the interface defined by
510      * `interfaceId`. Support of the actual ERC165 interface is automatic and
511      * registering its interface id is not required.
512      *
513      * See {IERC165-supportsInterface}.
514      *
515      * Requirements:
516      *
517      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
518      */
519     function _registerInterface(bytes4 interfaceId) internal virtual {
520         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
521         _supportedInterfaces[interfaceId] = true;
522     }
523 }
524 
525 // File: contracts/OZ_ERC1155/ERC1155.sol
526 
527 pragma solidity ^0.6.0;
528 
529 
530 
531 
532 
533 
534 /**
535  * @title Standard ERC1155 token
536  *
537  * @dev Implementation of the basic standard multi-token.
538  * See https://eips.ethereum.org/EIPS/eip-1155
539  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
540  */
541 contract ERC1155 is ERC165, IERC1155
542 {
543     using SafeMath for uint256;
544     using Address for address;
545 
546     // Mapping from token ID to account balances
547     mapping (uint256 => mapping(address => uint256)) private _balances;
548 
549     // Mapping from account to operator approvals
550     mapping (address => mapping(address => bool)) private _operatorApprovals;
551 
552     // Mapping token ID to that token being registered as existing
553     mapping (uint256 => bool) private _tokenExists;
554 
555     /*
556      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
557      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
558      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
559      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
560      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
561      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
562      *
563      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
564      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
565      */
566     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
567 
568     constructor() public {
569         // register the supported interfaces to conform to ERC1155 via ERC165
570         _registerInterface(_INTERFACE_ID_ERC1155);
571     }
572 
573     /**
574         @dev Get the specified address' balance for token with specified ID.
575 
576         Attempting to query the zero account for a balance will result in a revert.
577 
578         @param account The address of the token holder
579         @param id ID of the token
580         @return The account's balance of the token type requested
581      */
582     function balanceOf(address account, uint256 id) public view override returns (uint256) {
583         require(account != address(0), "ERC1155: balance query for the zero address");
584         require(_exists(id), "ERC1155: balance query for nonexistent token");
585         return _balances[id][account];
586     }
587 
588     /**
589         @dev Get the balance of multiple account/token pairs.
590 
591         If any of the query accounts is the zero account, this query will revert.
592 
593         @param accounts The addresses of the token holders
594         @param ids IDs of the tokens
595         @return Balances for each account and token id pair
596      */
597     function balanceOfBatch(
598         address[] memory accounts,
599         uint256[] memory ids
600     )
601         public
602         view
603         override
604         returns (uint256[] memory)
605     {
606         require(accounts.length == ids.length, "ERC1155: accounts and IDs must have same lengths");
607 
608         uint256[] memory batchBalances = new uint256[](accounts.length);
609 
610         for (uint256 i = 0; i < accounts.length; ++i) {
611             require(accounts[i] != address(0), "ERC1155: some address in batch balance query is zero");
612             require(_exists(ids[i]), "ERC1155: some token in batch balance query does not exist");
613             batchBalances[i] = _balances[ids[i]][accounts[i]];
614         }
615 
616         return batchBalances;
617     }
618 
619     /**
620      * @dev Sets or unsets the approval of a given operator.
621      *
622      * An operator is allowed to transfer all tokens of the sender on their behalf.
623      *
624      * Because an account already has operator privileges for itself, this function will revert
625      * if the account attempts to set the approval status for itself.
626      *
627      * @param operator address to set the approval
628      * @param approved representing the status of the approval to be set
629      */
630     function setApprovalForAll(address operator, bool approved) external override virtual {
631         require(msg.sender != operator, "ERC1155: cannot set approval status for self");
632         _operatorApprovals[msg.sender][operator] = approved;
633         emit ApprovalForAll(msg.sender, operator, approved);
634     }
635 
636     /**
637         @notice Queries the approval status of an operator for a given account.
638         @param account   The account of the Tokens
639         @param operator  Address of authorized operator
640         @return           True if the operator is approved, false if not
641     */
642     function isApprovedForAll(address account, address operator) public view override returns (bool) {
643         return _operatorApprovals[account][operator];
644     }
645 
646     /**
647         @dev Transfers `value` amount of an `id` from the `from` address to the `to` address specified.
648         Caller must be approved to manage the tokens being transferred out of the `from` account.
649         If `to` is a smart contract, will call `onERC1155Received` on `to` and act appropriately.
650         @param from Source address
651         @param to Target address
652         @param id ID of the token type
653         @param value Transfer amount
654         @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
655     */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 id,
660         uint256 value,
661         bytes calldata data
662     )
663         external
664         override
665         virtual
666     {
667         require(to != address(0), "ERC1155: target address must be non-zero");
668         require(
669             from == msg.sender || isApprovedForAll(from, msg.sender) == true,
670             "ERC1155: need operator approval for 3rd party transfers"
671         );
672 
673         _balances[id][from] = _balances[id][from].sub(value, "ERC1155: insufficient balance for transfer");
674         _balances[id][to] = _balances[id][to].add(value);
675 
676         emit TransferSingle(msg.sender, from, to, id, value);
677 
678         _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, value, data);
679     }
680 
681     /**
682         @dev Transfers `values` amount(s) of `ids` from the `from` address to the
683         `to` address specified. Caller must be approved to manage the tokens being
684         transferred out of the `from` account. If `to` is a smart contract, will
685         call `onERC1155BatchReceived` on `to` and act appropriately.
686         @param from Source address
687         @param to Target address
688         @param ids IDs of each token type
689         @param values Transfer amounts per token type
690         @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
691     */
692     function safeBatchTransferFrom(
693         address from,
694         address to,
695         uint256[] calldata ids,
696         uint256[] calldata values,
697         bytes calldata data
698     )
699         external
700         override
701         virtual
702     {
703         require(ids.length == values.length, "ERC1155: IDs and values must have same lengths");
704         require(to != address(0), "ERC1155: target address must be non-zero");
705         require(
706             from == msg.sender || isApprovedForAll(from, msg.sender) == true,
707             "ERC1155: need operator approval for 3rd party transfers"
708         );
709 
710         for (uint256 i = 0; i < ids.length; ++i) {
711             uint256 id = ids[i];
712             uint256 value = values[i];
713 
714             _balances[id][from] = _balances[id][from].sub(
715                 value,
716                 "ERC1155: insufficient balance of some token type for transfer"
717             );
718             _balances[id][to] = _balances[id][to].add(value);
719         }
720 
721         emit TransferBatch(msg.sender, from, to, ids, values);
722 
723         _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, values, data);
724     }
725 
726     /**
727      * @dev Register a token ID so other contract functionality knows this token
728      * actually exists and this ID is valid. Minting will automatically call this.
729      * @param id uint256 ID of the token to register
730      */
731     function _registerToken(uint256 id) internal virtual {
732         _tokenExists[id] = true;
733     }
734 
735     /**
736      * @dev Returns whether the specified token exists. Use {_registerTokenID} to set this flag.
737      * @param id uint256 ID of the token to query the existence of
738      * @return bool whether the token exists
739      */
740     function _exists(uint256 id) internal view returns (bool) {
741         return _tokenExists[id];
742     }
743 
744     /**
745      * @dev Internal function to mint an amount of a token with the given ID
746      * @param to The address that will own the minted token
747      * @param id ID of the token to be minted
748      * @param value Amount of the token to be minted
749      * @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
750      */
751     function _mint(address to, uint256 id, uint256 value, bytes memory data) internal virtual {
752         require(to != address(0), "ERC1155: mint to the zero address");
753 
754         if (!_exists(id)) {
755             _registerToken(id);
756         }
757         _balances[id][to] = _balances[id][to].add(value);
758         emit TransferSingle(msg.sender, address(0), to, id, value);
759 
760         _doSafeTransferAcceptanceCheck(msg.sender, address(0), to, id, value, data);
761     }
762 
763     /**
764      * @dev Internal function to batch mint amounts of tokens with the given IDs
765      * @param to The address that will own the minted token
766      * @param ids IDs of the tokens to be minted
767      * @param values Amounts of the tokens to be minted
768      * @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
769      */
770     function _mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal virtual {
771         require(to != address(0), "ERC1155: batch mint to the zero address");
772         require(ids.length == values.length, "ERC1155: minted IDs and values must have same lengths");
773 
774         for(uint i = 0; i < ids.length; i++) {
775             if (!_exists(ids[i])) {
776                 _registerToken(ids[i]);
777             }
778             _balances[ids[i]][to] = values[i].add(_balances[ids[i]][to]);
779         }
780 
781         emit TransferBatch(msg.sender, address(0), to, ids, values);
782 
783         _doSafeBatchTransferAcceptanceCheck(msg.sender, address(0), to, ids, values, data);
784     }
785 
786     /**
787      * @dev Internal function to burn an amount of a token with the given ID
788      * @param account Account which owns the token to be burnt
789      * @param id ID of the token to be burnt
790      * @param value Amount of the token to be burnt
791      */
792     function _burn(address account, uint256 id, uint256 value) internal virtual {
793         require(account != address(0), "ERC1155: attempting to burn tokens on zero account");
794 
795         _balances[id][account] = _balances[id][account].sub(
796             value,
797             "ERC1155: attempting to burn more than balance"
798         );
799         emit TransferSingle(msg.sender, account, address(0), id, value);
800     }
801 
802     /**
803      * @dev Internal function to batch burn an amounts of tokens with the given IDs
804      * @param account Account which owns the token to be burnt
805      * @param ids IDs of the tokens to be burnt
806      * @param values Amounts of the tokens to be burnt
807      */
808     function _burnBatch(address account, uint256[] memory ids, uint256[] memory values) internal virtual {
809         require(account != address(0), "ERC1155: attempting to burn batch of tokens on zero account");
810         require(ids.length == values.length, "ERC1155: burnt IDs and values must have same lengths");
811 
812         for(uint i = 0; i < ids.length; i++) {
813             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
814                 values[i],
815                 "ERC1155: attempting to burn more than balance for some token"
816             );
817         }
818 
819         emit TransferBatch(msg.sender, account, address(0), ids, values);
820     }
821 
822     function _doSafeTransferAcceptanceCheck(
823         address operator,
824         address from,
825         address to,
826         uint256 id,
827         uint256 value,
828         bytes memory data
829     )
830         internal
831         virtual
832     {
833         if(to.isContract()) {
834             require(
835                 IERC1155Receiver(to).onERC1155Received(operator, from, id, value, data) ==
836                     IERC1155Receiver(to).onERC1155Received.selector,
837                 "ERC1155: got unknown value from onERC1155Received"
838             );
839         }
840     }
841 
842     function _doSafeBatchTransferAcceptanceCheck(
843         address operator,
844         address from,
845         address to,
846         uint256[] memory ids,
847         uint256[] memory values,
848         bytes memory data
849     )
850         internal
851         virtual
852     {
853         if(to.isContract()) {
854             require(
855                 IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, values, data) ==
856                     IERC1155Receiver(to).onERC1155BatchReceived.selector,
857                 "ERC1155: got unknown value from onERC1155BatchReceived"
858             );
859         }
860     }
861 }
862 
863 // File: contracts/OZ_ERC1155/IERC1155MetadataURI.sol
864 
865 pragma solidity ^0.6.0;
866 
867 
868 /**
869  * @title ERC-1155 Multi Token Standard basic interface, optional metadata URI extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-1155
871  */
872 abstract contract IERC1155MetadataURI is IERC1155 {
873     function uri(uint256 id) external view virtual returns (string memory);
874 }
875 
876 // File: contracts/OZ_ERC1155/ERC1155MetadataURICatchAll.sol
877 
878 pragma solidity ^0.6.0;
879 
880 
881 
882 
883 contract ERC1155MetadataURICatchAll is ERC165, ERC1155, IERC1155MetadataURI {
884     // Catch-all URI with placeholders, e.g. https://example.com/{locale}/{id}.json
885     string private _uri;
886 
887      /*
888      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
889      */
890     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
891 
892     /**
893      * @dev Constructor function
894      */
895     constructor (string memory uri) public {
896         _setURI(uri);
897 
898         // register the supported interfaces to conform to ERC1155 via ERC165
899         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
900     }
901 
902     /**
903      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
904      * @dev URIs are defined in RFC 3986.
905      * The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
906      * param id uint256 ID of the token to query (ignored in this particular implementation,
907      * as an {id} parameter in the string is expected)
908      * @return URI string
909     */
910     function uri(uint256 id) external view override returns (string memory) {
911         require(_exists(id), "ERC1155MetadataURI: URI query for nonexistent token");
912         return _uri;
913     }
914 
915     /**
916      * @dev Internal function to set a new URI
917      * @param newuri New URI to be set
918      */
919     function _setURI(string memory newuri) internal virtual {
920         _uri = newuri;
921         emit URI(_uri, 0);
922     }
923 }
924 
925 // File: contracts/ENSReverseRegistrarI.sol
926 
927 /*
928  * Interfaces for ENS Reverse Registrar
929  * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
930  * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
931  *
932  * Use this as follows (registryAddress is the address of the ENS registry to use):
933  * -----
934  * // This hex value is caclulated by namehash('addr.reverse')
935  * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
936  * function registerReverseENS(address registryAddress, string memory calldata) external {
937  *     require(registryAddress != address(0), "need a valid registry");
938  *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
939  *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
940  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
941  * }
942  * -----
943  * or
944  * -----
945  * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
946  *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
947  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
948  * }
949  * -----
950  * ENS deployments can be found at https://docs.ens.domains/ens-deployments
951  * For Mainnet, 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069 is the reverseRegistrarAddress,
952  * for Ropsten, it is at 0x67d5418a000534a8F1f5FF4229cC2f439e63BBe2.
953  */
954 pragma solidity ^0.6.0;
955 
956 interface ENSRegistryOwnerI {
957     function owner(bytes32 node) external view returns (address);
958 }
959 
960 interface ENSReverseRegistrarI {
961     function setName(string calldata name) external returns (bytes32 node);
962 }
963 
964 // File: contracts/OracleRequest.sol
965 
966 /*
967 Interface for requests to the rate oracle (for EUR/ETH)
968 Copy this to projects that need to access the oracle.
969 See rate-oracle project for implementation.
970 */
971 pragma solidity ^0.6.0;
972 
973 
974 abstract contract OracleRequest {
975 
976     uint256 public EUR_WEI; //number of wei per EUR
977 
978     uint256 public lastUpdate; //timestamp of when the last update occurred
979 
980     function ETH_EUR() public view virtual returns (uint256); //number of EUR per ETH (rounded down!)
981 
982     function ETH_EURCENT() public view virtual returns (uint256); //number of EUR cent per ETH (rounded down!)
983 
984 }
985 
986 // File: contracts/CS2PresaleIBuyDP.sol
987 
988 /*
989 Interfacte for CS2 on-chain presale for usage with DirectPay contracts.
990 */
991 pragma solidity ^0.6.0;
992 
993 abstract contract CS2PresaleIBuyDP {
994     enum AssetType {
995         Honeybadger,
996         Llama,
997         Panda,
998         Doge
999     }
1000 
1001     // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.
1002     // This variant will be used externally from the CS2PresaleDirectPay contracts, which need to buy for _their_ msg.sender.
1003     function buy(AssetType _type, address payable _recipient) public payable virtual;
1004 
1005 }
1006 
1007 // File: contracts/CS2PresaleDirectPay.sol
1008 
1009 /*
1010 Implements an on-chain presale for Crypto stamp Edition 2
1011 */
1012 pragma solidity ^0.6.0;
1013 
1014 
1015 
1016 
1017 
1018 
1019 contract CS2PresaleDirectPay {
1020     using SafeMath for uint256;
1021 
1022     address public tokenAssignmentControl;
1023 
1024     CS2PresaleIBuyDP public presale;
1025     CS2PresaleIBuyDP.AssetType public assetType;
1026 
1027     event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);
1028 
1029     constructor(CS2PresaleIBuyDP _presale,
1030         CS2PresaleIBuyDP.AssetType _assetType,
1031         address _tokenAssignmentControl)
1032     public
1033     {
1034         presale = _presale;
1035         require(address(presale) != address(0x0), "You need to provide an actual presale contract.");
1036         assetType = _assetType;
1037         tokenAssignmentControl = _tokenAssignmentControl;
1038         require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
1039     }
1040 
1041     modifier onlyTokenAssignmentControl() {
1042         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
1043         _;
1044     }
1045 
1046     /*** Enable adjusting variables after deployment ***/
1047 
1048     function transferTokenAssignmentControl(address _newTokenAssignmentControl)
1049     public
1050     onlyTokenAssignmentControl
1051     {
1052         require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");
1053         emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);
1054         tokenAssignmentControl = _newTokenAssignmentControl;
1055     }
1056 
1057     /*** Actual presale functionality ***/
1058 
1059     // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.
1060     receive()
1061     external payable
1062     {
1063         presale.buy{value: msg.value}(assetType, msg.sender);
1064     }
1065 
1066     /*** Enable reverse ENS registration ***/
1067 
1068     // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
1069     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
1070     // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
1071     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
1072     external
1073     onlyTokenAssignmentControl
1074     {
1075         require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
1076         ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
1077     }
1078 
1079     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
1080 
1081     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
1082     function rescueToken(IERC20 _foreignToken, address _to)
1083     external
1084     onlyTokenAssignmentControl
1085     {
1086         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
1087     }
1088 
1089     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
1090     function approveNFTrescue(IERC721 _foreignNFT, address _to)
1091     external
1092     onlyTokenAssignmentControl
1093     {
1094         _foreignNFT.setApprovalForAll(_to, true);
1095     }
1096 
1097 }
1098 
1099 // File: contracts/CS2Presale.sol
1100 
1101 /*
1102 Implements an on-chain presale for Crypto stamp Edition 2
1103 */
1104 pragma solidity ^0.6.0;
1105 
1106 
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 contract CS2Presale is ERC1155MetadataURICatchAll, CS2PresaleIBuyDP {
1115     using SafeMath for uint256;
1116 
1117     OracleRequest internal oracle;
1118 
1119     address payable public beneficiary;
1120     address public tokenAssignmentControl;
1121     address public redeemer;
1122 
1123     uint256 public priceEurCent;
1124 
1125     uint256 public limitPerType;
1126 
1127     // Keep those sizes in sync with the length of the AssetType enum.
1128     uint256[4] public assetSupply;
1129     uint256[4] public assetSold;
1130     CS2PresaleDirectPay[4] public directPay;
1131 
1132     bool internal _isOpen = true;
1133 
1134     event DirectPayDeployed(address directPayContract);
1135     event PriceChanged(uint256 previousPriceEurCent, uint256 newPriceEurCent);
1136     event LimitChanged(uint256 previousLimitPerType, uint256 newLimitPerType);
1137     event OracleChanged(address indexed previousOracle, address indexed newOracle);
1138     event BeneficiaryTransferred(address indexed previousBeneficiary, address indexed newBeneficiary);
1139     event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);
1140     event RedeemerTransferred(address indexed previousRedeemer, address indexed newRedeemer);
1141     event ShopOpened();
1142     event ShopClosed();
1143 
1144     constructor(OracleRequest _oracle,
1145         uint256 _priceEurCent,
1146         uint256 _limitPerType,
1147         address payable _beneficiary,
1148         address _tokenAssignmentControl)
1149     ERC1155MetadataURICatchAll("https://test.crypto.post.at/CS2PS/meta/{id}")
1150     public
1151     {
1152         oracle = _oracle;
1153         require(address(oracle) != address(0x0), "You need to provide an actual Oracle contract.");
1154         beneficiary = _beneficiary;
1155         require(address(beneficiary) != address(0x0), "You need to provide an actual beneficiary address.");
1156         tokenAssignmentControl = _tokenAssignmentControl;
1157         require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
1158         redeemer = tokenAssignmentControl;
1159         priceEurCent = _priceEurCent;
1160         require(priceEurCent > 0, "You need to provide a non-zero price.");
1161         limitPerType = _limitPerType;
1162         // Register the token IDs we'll be using.
1163         uint256 typesNum = assetSupply.length;
1164         for (uint256 i = 0; i < typesNum; i++) {
1165             _registerToken(i);
1166         }
1167     }
1168 
1169     modifier onlyBeneficiary() {
1170         require(msg.sender == beneficiary, "Only the current benefinicary can call this function.");
1171         _;
1172     }
1173 
1174     modifier onlyTokenAssignmentControl() {
1175         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
1176         _;
1177     }
1178 
1179     modifier onlyRedeemer() {
1180         require(msg.sender == redeemer, "Only the current redeemer can call this function.");
1181         _;
1182     }
1183 
1184     modifier requireOpen() {
1185         require(isOpen() == true, "This call only works when the presale is open.");
1186         _;
1187     }
1188 
1189     /*** Deploy DirectPay contracts ***/
1190 
1191     // This is its own function as it takes about 2M gas in addition to the 4M+ gas the main contract needs,
1192     // so it's probably better not to do this right in the constructor.
1193     // As it can only be done once and the caller cannot influence it, no restrictions are made on who can call it.
1194     function deployDP()
1195     public
1196     {
1197         uint256 typesNum = directPay.length;
1198         for (uint256 i = 0; i < typesNum; i++) {
1199             require(address(directPay[i]) == address(0x0), "direct-pay contracts have already been deployed.");
1200             directPay[i] = new CS2PresaleDirectPay(this, AssetType(i), tokenAssignmentControl);
1201             emit DirectPayDeployed(address(directPay[i]));
1202         }
1203     }
1204 
1205     /*** Enable adjusting variables after deployment ***/
1206 
1207     function setPrice(uint256 _newPriceEurCent)
1208     public
1209     onlyBeneficiary
1210     {
1211         require(_newPriceEurCent > 0, "You need to provide a non-zero price.");
1212         emit PriceChanged(priceEurCent, _newPriceEurCent);
1213         priceEurCent = _newPriceEurCent;
1214     }
1215 
1216     function setLimit(uint256 _newLimitPerType)
1217     public
1218     onlyBeneficiary
1219     {
1220         uint256 typesNum = assetSold.length;
1221         for (uint256 i = 0; i < typesNum; i++) {
1222             require(assetSold[i] <= _newLimitPerType, "At least one requested asset is already over the requested limit.");
1223         }
1224         emit LimitChanged(limitPerType, _newLimitPerType);
1225         limitPerType = _newLimitPerType;
1226     }
1227 
1228     function setOracle(OracleRequest _newOracle)
1229     public
1230     onlyBeneficiary
1231     {
1232         require(address(_newOracle) != address(0x0), "You need to provide an actual Oracle contract.");
1233         emit OracleChanged(address(oracle), address(_newOracle));
1234         oracle = _newOracle;
1235     }
1236 
1237     function setMetadataURI(string memory _newURI)
1238     public
1239     onlyBeneficiary
1240     {
1241         _setURI(_newURI);
1242     }
1243 
1244     function transferBeneficiary(address payable _newBeneficiary)
1245     public
1246     onlyBeneficiary
1247     {
1248         require(_newBeneficiary != address(0), "beneficiary cannot be the zero address.");
1249         emit BeneficiaryTransferred(beneficiary, _newBeneficiary);
1250         beneficiary = _newBeneficiary;
1251     }
1252 
1253     function transferTokenAssignmentControl(address _newTokenAssignmentControl)
1254     public
1255     onlyTokenAssignmentControl
1256     {
1257         require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");
1258         emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);
1259         tokenAssignmentControl = _newTokenAssignmentControl;
1260     }
1261 
1262     function transferRedeemer(address _newRedeemer)
1263     public
1264     onlyRedeemer
1265     {
1266         require(_newRedeemer != address(0), "redeemer cannot be the zero address.");
1267         emit RedeemerTransferred(redeemer, _newRedeemer);
1268         redeemer = _newRedeemer;
1269     }
1270 
1271     function openShop()
1272     public
1273     onlyBeneficiary
1274     {
1275         _isOpen = true;
1276         emit ShopOpened();
1277     }
1278 
1279     function closeShop()
1280     public
1281     onlyBeneficiary
1282     {
1283         _isOpen = false;
1284         emit ShopClosed();
1285     }
1286 
1287     /*** Actual presale functionality ***/
1288 
1289     // Return true if presale is currently open for purchases.
1290     // This can have additional conditions to just the variable, e.g. actually having items to sell.
1291     function isOpen()
1292     public view
1293     returns (bool)
1294     {
1295         return _isOpen;
1296     }
1297 
1298     // Calculate current asset price in wei.
1299     // Note: Price in EUR cent is available from public var getter priceEurCent().
1300     function priceWei()
1301     public view
1302     returns (uint256)
1303     {
1304         return priceEurCent.mul(oracle.EUR_WEI()).div(100);
1305     }
1306 
1307     // This returns the total amount of all assets currently existing.
1308     function totalSupply()
1309     public view
1310     returns (uint256)
1311     {
1312         uint256 _totalSupply = 0;
1313         uint256 typesNum = assetSupply.length;
1314         for (uint256 i = 0; i < typesNum; i++) {
1315             _totalSupply = _totalSupply.add(assetSupply[i]);
1316         }
1317         return _totalSupply;
1318     }
1319 
1320     // This returns the total amount of all assets created/sold.
1321     function totalSold()
1322     public view
1323     returns (uint256)
1324     {
1325         uint256 _totalSold = 0;
1326         uint256 typesNum = assetSold.length;
1327         for (uint256 i = 0; i < typesNum; i++) {
1328             _totalSold = _totalSold.add(assetSold[i]);
1329         }
1330         return _totalSold;
1331     }
1332 
1333     // Returns the amount of assets of that type still available for sale.
1334     function availableForSale(AssetType _type)
1335     public view
1336     returns (uint256)
1337     {
1338         return limitPerType.sub(assetSold[uint256(_type)]);
1339     }
1340 
1341     // Returns true if the asset of the given type is sold out.
1342     function isSoldOut(AssetType _type)
1343     public view
1344     returns (bool)
1345     {
1346         return assetSold[uint256(_type)] >= limitPerType;
1347     }
1348 
1349     // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.
1350     function buy(AssetType _type)
1351     external payable
1352     requireOpen
1353     {
1354         buy(_type, msg.sender);
1355     }
1356 
1357     // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.
1358     // This variant will be used externally from the CS2PresaleDirectPay contracts, which need to buy for _their_ msg.sender.
1359     function buy(AssetType _type, address payable _recipient)
1360     public payable override
1361     requireOpen
1362     {
1363         uint256 curPriceWei = priceWei();
1364         require(msg.value >= curPriceWei, "You need to send enough currency to actually pay at least one item.");
1365         uint256 maxToSell = limitPerType.sub(assetSold[uint256(_type)]);
1366         require(maxToSell > 0, "The requested asset is sold out.");
1367         // Determine amount of assets to buy from payment value (algorithm rounds down).
1368         uint256 assetCount = msg.value.div(curPriceWei);
1369         // Don't allow buying more assets than available of this type.
1370         if (assetCount > maxToSell) {
1371             assetCount = maxToSell;
1372         }
1373         // Determine actual price of rounded-down count.
1374         uint256 payAmount = assetCount.mul(curPriceWei);
1375         // Transfer the actual payment amount to the beneficiary.
1376         beneficiary.transfer(payAmount);
1377         // Generate and assign the actual assets.
1378         _mint(_recipient, uint256(_type), assetCount, bytes(""));
1379         assetSupply[uint256(_type)] = assetSupply[uint256(_type)].add(assetCount);
1380         assetSold[uint256(_type)] = assetSold[uint256(_type)].add(assetCount);
1381         // Send back change money. Do this last.
1382         if (msg.value > payAmount) {
1383             _recipient.transfer(msg.value.sub(payAmount));
1384         }
1385     }
1386 
1387     // Buy assets of a multiple types/animals at once.
1388     function buyBatch(AssetType[] calldata _type, uint256[] calldata _count)
1389     external payable
1390     requireOpen
1391     {
1392         uint256 inputlines = _type.length;
1393         require(inputlines == _count.length, "Both input arrays need to be the same length.");
1394         uint256 curPriceWei = priceWei();
1395         require(msg.value >= curPriceWei, "You need to send enough currency to actually pay at least one item.");
1396         // Determine actual price of items to buy.
1397         uint256 payAmount = 0;
1398         uint256[] memory ids = new uint256[](inputlines);
1399         for (uint256 i = 0; i < inputlines; i++) {
1400             payAmount = payAmount.add(_count[i].mul(curPriceWei));
1401             ids[i] = uint256(_type[i]);
1402             assetSupply[ids[i]] = assetSupply[ids[i]].add(_count[i]);
1403             assetSold[ids[i]] = assetSold[ids[i]].add(_count[i]);
1404             // If any asset in the batch would go over the limit, fail the whole transaction.
1405             require(assetSold[ids[i]] <= limitPerType, "At least one requested asset is sold out.");
1406         }
1407         require(msg.value >= payAmount, "You need to send enough currency to actually pay all specified items.");
1408         // Transfer the actual payment amount to the beneficiary.
1409         beneficiary.transfer(payAmount);
1410         // Generate and assign the actual assets.
1411         _mintBatch(msg.sender, ids, _count, bytes(""));
1412         // Send back change money. Do this last.
1413         if (msg.value > payAmount) {
1414             msg.sender.transfer(msg.value.sub(payAmount));
1415         }
1416     }
1417 
1418     // Redeem assets of a multiple types/animals at once.
1419     // This burns them in this contract, but should be called by a contract that assigns/creates the final assets in turn.
1420     function redeemBatch(address owner, AssetType[] calldata _type, uint256[] calldata _count)
1421     external
1422     onlyRedeemer
1423     {
1424         uint256 inputlines = _type.length;
1425         require(inputlines == _count.length, "Both input arrays need to be the same length.");
1426         uint256[] memory ids = new uint256[](inputlines);
1427         for (uint256 i = 0; i < inputlines; i++) {
1428             ids[i] = uint256(_type[i]);
1429             assetSupply[ids[i]] = assetSupply[ids[i]].sub(_count[i]);
1430         }
1431         _burnBatch(owner, ids, _count);
1432     }
1433 
1434     // Returns whether the specified token exists.
1435     function exists(uint256 id) public view returns (bool) {
1436         return _exists(id);
1437     }
1438 
1439     /*** Enable reverse ENS registration ***/
1440 
1441     // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
1442     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
1443     // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
1444     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
1445     external
1446     onlyTokenAssignmentControl
1447     {
1448         require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
1449         ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
1450     }
1451 
1452     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
1453 
1454     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
1455     function rescueToken(IERC20 _foreignToken, address _to)
1456     external
1457     onlyTokenAssignmentControl
1458     {
1459         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
1460     }
1461 
1462     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
1463     function approveNFTrescue(IERC721 _foreignNFT, address _to)
1464     external
1465     onlyTokenAssignmentControl
1466     {
1467         _foreignNFT.setApprovalForAll(_to, true);
1468     }
1469 
1470 }