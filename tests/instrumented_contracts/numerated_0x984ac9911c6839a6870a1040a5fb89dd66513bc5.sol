1 // Sources flattened with hardhat v2.4.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.7.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 
221 // File contracts/SaleManager.sol
222 
223 
224 contract SaleManager{
225     using SafeMath for uint;
226     struct User{
227         bool claimed;
228         uint share; //all addresses shares start as zero
229     }
230 
231     mapping(address => User) public shareLedger;
232     address public owner;
233     address public nft;
234     uint public balance;
235     uint public allocatedShare;
236     bool public claimsStarted;
237 
238     constructor(address _owner, address _nft){
239         owner = _owner;
240         nft = _nft;
241     }
242 
243     receive() external payable{}
244 
245     /**
246     * @dev biggest point of power for the owner bc they could choose to not call this function, but doing so means they don't get paid
247     * if malicous owner sent 1 eth to contract, then called balance, then claimed their share, then everyones share would be based off 1 Eth instead of actual conctract balance
248     * ^^^^^ mitigated by making the NFT in charge of calling this function when withdraw is called on the NFT
249     **/
250     function logEther() external {//could maybe have the nft contract call this to remove owner power to not call it?
251         require(msg.sender == nft, 'Only the nft can log ether');
252         require(!claimsStarted, 'Users have already started claiming Eth from the contract');
253         balance = address(this).balance;
254     }
255 
256     function resetManager() external{
257         require(msg.sender == owner, 'Only the owner can reset the contract');
258         require(balance > 0 && address(this).balance == 0, 'Can not reset when users still need to claim');
259         balance = 0;
260         claimsStarted = false;
261         allocatedShare = 0;//Owner must reallocate share once this function is called
262     }
263 
264     /**
265     * @dev only deploy nft contract once shareLedger is finalized, then set the SalesManager in the nft equal to this address
266     **/
267     function createUser(address _address, uint _share) external{
268         require(msg.sender == owner, 'Only the owner can create users');
269         require(_share > 0, 'Share must be greater than zero');//makes it so that owner can not zero out shares after allocated shares is equal to 100
270         require(allocatedShare.add(_share) <= 100, 'Total share allocation greater than 100');
271         shareLedger[_address] = User({
272         claimed: false,
273         share: _share
274         });
275         allocatedShare = allocatedShare.add(_share);
276     }
277 
278     function claimEther() external{
279         require(balance > 0, 'Balance has not been set');
280         require(shareLedger[msg.sender].share > 0, 'Caller has no share to claim');
281         require(!shareLedger[msg.sender].claimed, 'Caller already claimed Ether');
282         shareLedger[msg.sender].claimed = true;
283         uint etherOwed = shareLedger[msg.sender].share.mul(balance).div(100);
284         if(etherOwed > address(this).balance){//safety check for rounding errors
285             etherOwed = address(this).balance;
286         }
287         claimsStarted = true;
288         msg.sender.transfer(etherOwed);
289     }
290 
291     function adminWithdraw() external{
292         require(msg.sender == owner, 'Only the owner can use this function');
293         msg.sender.transfer(address(this).balance);
294     }
295 }
296 
297 
298 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
299 
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with GSN meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address payable) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes memory) {
317         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
318         return msg.data;
319     }
320 }
321 
322 
323 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
324 
325 
326 /**
327  * @dev Interface of the ERC165 standard, as defined in the
328  * https://eips.ethereum.org/EIPS/eip-165[EIP].
329  *
330  * Implementers can declare support of contract interfaces, which can then be
331  * queried by others ({ERC165Checker}).
332  *
333  * For an implementation, see {ERC165}.
334  */
335 interface IERC165 {
336     /**
337      * @dev Returns true if this contract implements the interface defined by
338      * `interfaceId`. See the corresponding
339      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
340      * to learn more about how these ids are created.
341      *
342      * This function call must use less than 30 000 gas.
343      */
344     function supportsInterface(bytes4 interfaceId) external view returns (bool);
345 }
346 
347 
348 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
349 
350 
351 /**
352  * @dev Required interface of an ERC721 compliant contract.
353  */
354 interface IERC721 is IERC165 {
355     /**
356      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359 
360     /**
361      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
362      */
363     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
367      */
368     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
369 
370     /**
371      * @dev Returns the number of tokens in ``owner``'s account.
372      */
373     function balanceOf(address owner) external view returns (uint256 balance);
374 
375     /**
376      * @dev Returns the owner of the `tokenId` token.
377      *
378      * Requirements:
379      *
380      * - `tokenId` must exist.
381      */
382     function ownerOf(uint256 tokenId) external view returns (address owner);
383 
384     /**
385      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
386      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must exist and be owned by `from`.
393      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395      *
396      * Emits a {Transfer} event.
397      */
398     function safeTransferFrom(address from, address to, uint256 tokenId) external;
399 
400     /**
401      * @dev Transfers `tokenId` token from `from` to `to`.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must be owned by `from`.
410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(address from, address to, uint256 tokenId) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Returns the account approved for `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function getApproved(uint256 tokenId) external view returns (address operator);
439 
440     /**
441      * @dev Approve or remove `operator` as an operator for the caller.
442      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The `operator` cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     /**
460       * @dev Safely transfers `tokenId` token from `from` to `to`.
461       *
462       * Requirements:
463       *
464       * - `from` cannot be the zero address.
465       * - `to` cannot be the zero address.
466       * - `tokenId` token must exist and be owned by `from`.
467       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469       *
470       * Emits a {Transfer} event.
471       */
472     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
473 }
474 
475 
476 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.0
477 
478 
479 /**
480  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
481  * @dev See https://eips.ethereum.org/EIPS/eip-721
482  */
483 interface IERC721Metadata is IERC721 {
484 
485     /**
486      * @dev Returns the token collection name.
487      */
488     function name() external view returns (string memory);
489 
490     /**
491      * @dev Returns the token collection symbol.
492      */
493     function symbol() external view returns (string memory);
494 
495     /**
496      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
497      */
498     function tokenURI(uint256 tokenId) external view returns (string memory);
499 }
500 
501 
502 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.0
503 
504 
505 /**
506  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
507  * @dev See https://eips.ethereum.org/EIPS/eip-721
508  */
509 interface IERC721Enumerable is IERC721 {
510 
511     /**
512      * @dev Returns the total amount of tokens stored by the contract.
513      */
514     function totalSupply() external view returns (uint256);
515 
516     /**
517      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
518      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
519      */
520     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
521 
522     /**
523      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
524      * Use along with {totalSupply} to enumerate all tokens.
525      */
526     function tokenByIndex(uint256 index) external view returns (uint256);
527 }
528 
529 
530 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.0
531 
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
547      */
548     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
549 }
550 
551 
552 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.0
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts may inherit from this and call {_registerInterface} to declare
559  * their support of an interface.
560  */
561 abstract contract ERC165 is IERC165 {
562     /*
563      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
564      */
565     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
566 
567     /**
568      * @dev Mapping of interface ids to whether or not it's supported.
569      */
570     mapping(bytes4 => bool) private _supportedInterfaces;
571 
572     constructor () internal {
573         // Derived contracts need only register support for their own interfaces,
574         // we register support for ERC165 itself here
575         _registerInterface(_INTERFACE_ID_ERC165);
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      *
581      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         return _supportedInterfaces[interfaceId];
585     }
586 
587     /**
588      * @dev Registers the contract as an implementer of the interface defined by
589      * `interfaceId`. Support of the actual ERC165 interface is automatic and
590      * registering its interface id is not required.
591      *
592      * See {IERC165-supportsInterface}.
593      *
594      * Requirements:
595      *
596      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
597      */
598     function _registerInterface(bytes4 interfaceId) internal virtual {
599         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
600         _supportedInterfaces[interfaceId] = true;
601     }
602 }
603 
604 
605 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
606 
607 
608 /**
609  * @dev Collection of functions related to the address type
610  */
611 library Address {
612     /**
613      * @dev Returns true if `account` is a contract.
614      *
615      * [IMPORTANT]
616      * ====
617      * It is unsafe to assume that an address for which this function returns
618      * false is an externally-owned account (EOA) and not a contract.
619      *
620      * Among others, `isContract` will return false for the following
621      * types of addresses:
622      *
623      *  - an externally-owned account
624      *  - a contract in construction
625      *  - an address where a contract will be created
626      *  - an address where a contract lived, but was destroyed
627      * ====
628      */
629     function isContract(address account) internal view returns (bool) {
630         // This method relies on extcodesize, which returns 0 for contracts in
631         // construction, since the code is only stored at the end of the
632         // constructor execution.
633 
634         uint256 size;
635         // solhint-disable-next-line no-inline-assembly
636         assembly { size := extcodesize(account) }
637         return size > 0;
638     }
639 
640     /**
641      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
642      * `recipient`, forwarding all available gas and reverting on errors.
643      *
644      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
645      * of certain opcodes, possibly making contracts go over the 2300 gas limit
646      * imposed by `transfer`, making them unable to receive funds via
647      * `transfer`. {sendValue} removes this limitation.
648      *
649      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
650      *
651      * IMPORTANT: because control is transferred to `recipient`, care must be
652      * taken to not create reentrancy vulnerabilities. Consider using
653      * {ReentrancyGuard} or the
654      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
655      */
656     function sendValue(address payable recipient, uint256 amount) internal {
657         require(address(this).balance >= amount, "Address: insufficient balance");
658 
659         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
660         (bool success, ) = recipient.call{ value: amount }("");
661         require(success, "Address: unable to send value, recipient may have reverted");
662     }
663 
664     /**
665      * @dev Performs a Solidity function call using a low level `call`. A
666      * plain`call` is an unsafe replacement for a function call: use this
667      * function instead.
668      *
669      * If `target` reverts with a revert reason, it is bubbled up by this
670      * function (like regular Solidity function calls).
671      *
672      * Returns the raw returned data. To convert to the expected return value,
673      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
674      *
675      * Requirements:
676      *
677      * - `target` must be a contract.
678      * - calling `target` with `data` must not revert.
679      *
680      * _Available since v3.1._
681      */
682     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
683         return functionCall(target, data, "Address: low-level call failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
688      * `errorMessage` as a fallback revert reason when `target` reverts.
689      *
690      * _Available since v3.1._
691      */
692     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, 0, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but also transferring `value` wei to `target`.
699      *
700      * Requirements:
701      *
702      * - the calling contract must have an ETH balance of at least `value`.
703      * - the called Solidity function must be `payable`.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
713      * with `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
718         require(address(this).balance >= value, "Address: insufficient balance for call");
719         require(isContract(target), "Address: call to non-contract");
720 
721         // solhint-disable-next-line avoid-low-level-calls
722         (bool success, bytes memory returndata) = target.call{ value: value }(data);
723         return _verifyCallResult(success, returndata, errorMessage);
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
728      * but performing a static call.
729      *
730      * _Available since v3.3._
731      */
732     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
733         return functionStaticCall(target, data, "Address: low-level static call failed");
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
738      * but performing a static call.
739      *
740      * _Available since v3.3._
741      */
742     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
743         require(isContract(target), "Address: static call to non-contract");
744 
745         // solhint-disable-next-line avoid-low-level-calls
746         (bool success, bytes memory returndata) = target.staticcall(data);
747         return _verifyCallResult(success, returndata, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but performing a delegate call.
753      *
754      * _Available since v3.4._
755      */
756     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
757         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
762      * but performing a delegate call.
763      *
764      * _Available since v3.4._
765      */
766     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
767         require(isContract(target), "Address: delegate call to non-contract");
768 
769         // solhint-disable-next-line avoid-low-level-calls
770         (bool success, bytes memory returndata) = target.delegatecall(data);
771         return _verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 // solhint-disable-next-line no-inline-assembly
783                 assembly {
784                     let returndata_size := mload(returndata)
785                     revert(add(32, returndata), returndata_size)
786                 }
787             } else {
788                 revert(errorMessage);
789             }
790         }
791     }
792 }
793 
794 
795 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.0
796 
797 
798 /**
799  * @dev Library for managing
800  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
801  * types.
802  *
803  * Sets have the following properties:
804  *
805  * - Elements are added, removed, and checked for existence in constant time
806  * (O(1)).
807  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
808  *
809  * ```
810  * contract Example {
811  *     // Add the library methods
812  *     using EnumerableSet for EnumerableSet.AddressSet;
813  *
814  *     // Declare a set state variable
815  *     EnumerableSet.AddressSet private mySet;
816  * }
817  * ```
818  *
819  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
820  * and `uint256` (`UintSet`) are supported.
821  */
822 library EnumerableSet {
823     // To implement this library for multiple types with as little code
824     // repetition as possible, we write it in terms of a generic Set type with
825     // bytes32 values.
826     // The Set implementation uses private functions, and user-facing
827     // implementations (such as AddressSet) are just wrappers around the
828     // underlying Set.
829     // This means that we can only create new EnumerableSets for types that fit
830     // in bytes32.
831 
832     struct Set {
833         // Storage of set values
834         bytes32[] _values;
835 
836         // Position of the value in the `values` array, plus 1 because index 0
837         // means a value is not in the set.
838         mapping (bytes32 => uint256) _indexes;
839     }
840 
841     /**
842      * @dev Add a value to a set. O(1).
843      *
844      * Returns true if the value was added to the set, that is if it was not
845      * already present.
846      */
847     function _add(Set storage set, bytes32 value) private returns (bool) {
848         if (!_contains(set, value)) {
849             set._values.push(value);
850             // The value is stored at length-1, but we add 1 to all indexes
851             // and use 0 as a sentinel value
852             set._indexes[value] = set._values.length;
853             return true;
854         } else {
855             return false;
856         }
857     }
858 
859     /**
860      * @dev Removes a value from a set. O(1).
861      *
862      * Returns true if the value was removed from the set, that is if it was
863      * present.
864      */
865     function _remove(Set storage set, bytes32 value) private returns (bool) {
866         // We read and store the value's index to prevent multiple reads from the same storage slot
867         uint256 valueIndex = set._indexes[value];
868 
869         if (valueIndex != 0) { // Equivalent to contains(set, value)
870             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
871             // the array, and then remove the last element (sometimes called as 'swap and pop').
872             // This modifies the order of the array, as noted in {at}.
873 
874             uint256 toDeleteIndex = valueIndex - 1;
875             uint256 lastIndex = set._values.length - 1;
876 
877             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
878             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
879 
880             bytes32 lastvalue = set._values[lastIndex];
881 
882             // Move the last value to the index where the value to delete is
883             set._values[toDeleteIndex] = lastvalue;
884             // Update the index for the moved value
885             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
886 
887             // Delete the slot where the moved value was stored
888             set._values.pop();
889 
890             // Delete the index for the deleted slot
891             delete set._indexes[value];
892 
893             return true;
894         } else {
895             return false;
896         }
897     }
898 
899     /**
900      * @dev Returns true if the value is in the set. O(1).
901      */
902     function _contains(Set storage set, bytes32 value) private view returns (bool) {
903         return set._indexes[value] != 0;
904     }
905 
906     /**
907      * @dev Returns the number of values on the set. O(1).
908      */
909     function _length(Set storage set) private view returns (uint256) {
910         return set._values.length;
911     }
912 
913     /**
914      * @dev Returns the value stored at position `index` in the set. O(1).
915      *
916      * Note that there are no guarantees on the ordering of values inside the
917      * array, and it may change when more values are added or removed.
918      *
919      * Requirements:
920      *
921      * - `index` must be strictly less than {length}.
922      */
923     function _at(Set storage set, uint256 index) private view returns (bytes32) {
924         require(set._values.length > index, "EnumerableSet: index out of bounds");
925         return set._values[index];
926     }
927 
928     // Bytes32Set
929 
930     struct Bytes32Set {
931         Set _inner;
932     }
933 
934     /**
935      * @dev Add a value to a set. O(1).
936      *
937      * Returns true if the value was added to the set, that is if it was not
938      * already present.
939      */
940     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
941         return _add(set._inner, value);
942     }
943 
944     /**
945      * @dev Removes a value from a set. O(1).
946      *
947      * Returns true if the value was removed from the set, that is if it was
948      * present.
949      */
950     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
951         return _remove(set._inner, value);
952     }
953 
954     /**
955      * @dev Returns true if the value is in the set. O(1).
956      */
957     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
958         return _contains(set._inner, value);
959     }
960 
961     /**
962      * @dev Returns the number of values in the set. O(1).
963      */
964     function length(Bytes32Set storage set) internal view returns (uint256) {
965         return _length(set._inner);
966     }
967 
968     /**
969      * @dev Returns the value stored at position `index` in the set. O(1).
970      *
971      * Note that there are no guarantees on the ordering of values inside the
972      * array, and it may change when more values are added or removed.
973      *
974      * Requirements:
975      *
976      * - `index` must be strictly less than {length}.
977      */
978     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
979         return _at(set._inner, index);
980     }
981 
982     // AddressSet
983 
984     struct AddressSet {
985         Set _inner;
986     }
987 
988     /**
989      * @dev Add a value to a set. O(1).
990      *
991      * Returns true if the value was added to the set, that is if it was not
992      * already present.
993      */
994     function add(AddressSet storage set, address value) internal returns (bool) {
995         return _add(set._inner, bytes32(uint256(uint160(value))));
996     }
997 
998     /**
999      * @dev Removes a value from a set. O(1).
1000      *
1001      * Returns true if the value was removed from the set, that is if it was
1002      * present.
1003      */
1004     function remove(AddressSet storage set, address value) internal returns (bool) {
1005         return _remove(set._inner, bytes32(uint256(uint160(value))));
1006     }
1007 
1008     /**
1009      * @dev Returns true if the value is in the set. O(1).
1010      */
1011     function contains(AddressSet storage set, address value) internal view returns (bool) {
1012         return _contains(set._inner, bytes32(uint256(uint160(value))));
1013     }
1014 
1015     /**
1016      * @dev Returns the number of values in the set. O(1).
1017      */
1018     function length(AddressSet storage set) internal view returns (uint256) {
1019         return _length(set._inner);
1020     }
1021 
1022     /**
1023      * @dev Returns the value stored at position `index` in the set. O(1).
1024      *
1025      * Note that there are no guarantees on the ordering of values inside the
1026      * array, and it may change when more values are added or removed.
1027      *
1028      * Requirements:
1029      *
1030      * - `index` must be strictly less than {length}.
1031      */
1032     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1033         return address(uint160(uint256(_at(set._inner, index))));
1034     }
1035 
1036 
1037     // UintSet
1038 
1039     struct UintSet {
1040         Set _inner;
1041     }
1042 
1043     /**
1044      * @dev Add a value to a set. O(1).
1045      *
1046      * Returns true if the value was added to the set, that is if it was not
1047      * already present.
1048      */
1049     function add(UintSet storage set, uint256 value) internal returns (bool) {
1050         return _add(set._inner, bytes32(value));
1051     }
1052 
1053     /**
1054      * @dev Removes a value from a set. O(1).
1055      *
1056      * Returns true if the value was removed from the set, that is if it was
1057      * present.
1058      */
1059     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1060         return _remove(set._inner, bytes32(value));
1061     }
1062 
1063     /**
1064      * @dev Returns true if the value is in the set. O(1).
1065      */
1066     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1067         return _contains(set._inner, bytes32(value));
1068     }
1069 
1070     /**
1071      * @dev Returns the number of values on the set. O(1).
1072      */
1073     function length(UintSet storage set) internal view returns (uint256) {
1074         return _length(set._inner);
1075     }
1076 
1077     /**
1078      * @dev Returns the value stored at position `index` in the set. O(1).
1079      *
1080      * Note that there are no guarantees on the ordering of values inside the
1081      * array, and it may change when more values are added or removed.
1082      *
1083      * Requirements:
1084      *
1085      * - `index` must be strictly less than {length}.
1086      */
1087     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1088         return uint256(_at(set._inner, index));
1089     }
1090 }
1091 
1092 
1093 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.0
1094 
1095 
1096 /**
1097  * @dev Library for managing an enumerable variant of Solidity's
1098  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1099  * type.
1100  *
1101  * Maps have the following properties:
1102  *
1103  * - Entries are added, removed, and checked for existence in constant time
1104  * (O(1)).
1105  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1106  *
1107  * ```
1108  * contract Example {
1109  *     // Add the library methods
1110  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1111  *
1112  *     // Declare a set state variable
1113  *     EnumerableMap.UintToAddressMap private myMap;
1114  * }
1115  * ```
1116  *
1117  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1118  * supported.
1119  */
1120 library EnumerableMap {
1121     // To implement this library for multiple types with as little code
1122     // repetition as possible, we write it in terms of a generic Map type with
1123     // bytes32 keys and values.
1124     // The Map implementation uses private functions, and user-facing
1125     // implementations (such as Uint256ToAddressMap) are just wrappers around
1126     // the underlying Map.
1127     // This means that we can only create new EnumerableMaps for types that fit
1128     // in bytes32.
1129 
1130     struct MapEntry {
1131         bytes32 _key;
1132         bytes32 _value;
1133     }
1134 
1135     struct Map {
1136         // Storage of map keys and values
1137         MapEntry[] _entries;
1138 
1139         // Position of the entry defined by a key in the `entries` array, plus 1
1140         // because index 0 means a key is not in the map.
1141         mapping (bytes32 => uint256) _indexes;
1142     }
1143 
1144     /**
1145      * @dev Adds a key-value pair to a map, or updates the value for an existing
1146      * key. O(1).
1147      *
1148      * Returns true if the key was added to the map, that is if it was not
1149      * already present.
1150      */
1151     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1152         // We read and store the key's index to prevent multiple reads from the same storage slot
1153         uint256 keyIndex = map._indexes[key];
1154 
1155         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1156             map._entries.push(MapEntry({ _key: key, _value: value }));
1157             // The entry is stored at length-1, but we add 1 to all indexes
1158             // and use 0 as a sentinel value
1159             map._indexes[key] = map._entries.length;
1160             return true;
1161         } else {
1162             map._entries[keyIndex - 1]._value = value;
1163             return false;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Removes a key-value pair from a map. O(1).
1169      *
1170      * Returns true if the key was removed from the map, that is if it was present.
1171      */
1172     function _remove(Map storage map, bytes32 key) private returns (bool) {
1173         // We read and store the key's index to prevent multiple reads from the same storage slot
1174         uint256 keyIndex = map._indexes[key];
1175 
1176         if (keyIndex != 0) { // Equivalent to contains(map, key)
1177             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1178             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1179             // This modifies the order of the array, as noted in {at}.
1180 
1181             uint256 toDeleteIndex = keyIndex - 1;
1182             uint256 lastIndex = map._entries.length - 1;
1183 
1184             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1185             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1186 
1187             MapEntry storage lastEntry = map._entries[lastIndex];
1188 
1189             // Move the last entry to the index where the entry to delete is
1190             map._entries[toDeleteIndex] = lastEntry;
1191             // Update the index for the moved entry
1192             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1193 
1194             // Delete the slot where the moved entry was stored
1195             map._entries.pop();
1196 
1197             // Delete the index for the deleted slot
1198             delete map._indexes[key];
1199 
1200             return true;
1201         } else {
1202             return false;
1203         }
1204     }
1205 
1206     /**
1207      * @dev Returns true if the key is in the map. O(1).
1208      */
1209     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1210         return map._indexes[key] != 0;
1211     }
1212 
1213     /**
1214      * @dev Returns the number of key-value pairs in the map. O(1).
1215      */
1216     function _length(Map storage map) private view returns (uint256) {
1217         return map._entries.length;
1218     }
1219 
1220     /**
1221      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1222      *
1223      * Note that there are no guarantees on the ordering of entries inside the
1224      * array, and it may change when more entries are added or removed.
1225      *
1226      * Requirements:
1227      *
1228      * - `index` must be strictly less than {length}.
1229      */
1230     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1231         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1232 
1233         MapEntry storage entry = map._entries[index];
1234         return (entry._key, entry._value);
1235     }
1236 
1237     /**
1238      * @dev Tries to returns the value associated with `key`.  O(1).
1239      * Does not revert if `key` is not in the map.
1240      */
1241     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1242         uint256 keyIndex = map._indexes[key];
1243         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1244         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1245     }
1246 
1247     /**
1248      * @dev Returns the value associated with `key`.  O(1).
1249      *
1250      * Requirements:
1251      *
1252      * - `key` must be in the map.
1253      */
1254     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1255         uint256 keyIndex = map._indexes[key];
1256         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1257         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1258     }
1259 
1260     /**
1261      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1262      *
1263      * CAUTION: This function is deprecated because it requires allocating memory for the error
1264      * message unnecessarily. For custom revert reasons use {_tryGet}.
1265      */
1266     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1267         uint256 keyIndex = map._indexes[key];
1268         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1269         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1270     }
1271 
1272     // UintToAddressMap
1273 
1274     struct UintToAddressMap {
1275         Map _inner;
1276     }
1277 
1278     /**
1279      * @dev Adds a key-value pair to a map, or updates the value for an existing
1280      * key. O(1).
1281      *
1282      * Returns true if the key was added to the map, that is if it was not
1283      * already present.
1284      */
1285     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1286         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1287     }
1288 
1289     /**
1290      * @dev Removes a value from a set. O(1).
1291      *
1292      * Returns true if the key was removed from the map, that is if it was present.
1293      */
1294     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1295         return _remove(map._inner, bytes32(key));
1296     }
1297 
1298     /**
1299      * @dev Returns true if the key is in the map. O(1).
1300      */
1301     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1302         return _contains(map._inner, bytes32(key));
1303     }
1304 
1305     /**
1306      * @dev Returns the number of elements in the map. O(1).
1307      */
1308     function length(UintToAddressMap storage map) internal view returns (uint256) {
1309         return _length(map._inner);
1310     }
1311 
1312     /**
1313      * @dev Returns the element stored at position `index` in the set. O(1).
1314      * Note that there are no guarantees on the ordering of values inside the
1315      * array, and it may change when more values are added or removed.
1316      *
1317      * Requirements:
1318      *
1319      * - `index` must be strictly less than {length}.
1320      */
1321     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1322         (bytes32 key, bytes32 value) = _at(map._inner, index);
1323         return (uint256(key), address(uint160(uint256(value))));
1324     }
1325 
1326     /**
1327      * @dev Tries to returns the value associated with `key`.  O(1).
1328      * Does not revert if `key` is not in the map.
1329      *
1330      * _Available since v3.4._
1331      */
1332     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1333         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1334         return (success, address(uint160(uint256(value))));
1335     }
1336 
1337     /**
1338      * @dev Returns the value associated with `key`.  O(1).
1339      *
1340      * Requirements:
1341      *
1342      * - `key` must be in the map.
1343      */
1344     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1345         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1346     }
1347 
1348     /**
1349      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1350      *
1351      * CAUTION: This function is deprecated because it requires allocating memory for the error
1352      * message unnecessarily. For custom revert reasons use {tryGet}.
1353      */
1354     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1355         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1356     }
1357 }
1358 
1359 
1360 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.0
1361 
1362 
1363 /**
1364  * @dev String operations.
1365  */
1366 library Strings {
1367     /**
1368      * @dev Converts a `uint256` to its ASCII `string` representation.
1369      */
1370     function toString(uint256 value) internal pure returns (string memory) {
1371         // Inspired by OraclizeAPI's implementation - MIT licence
1372         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1373 
1374         if (value == 0) {
1375             return "0";
1376         }
1377         uint256 temp = value;
1378         uint256 digits;
1379         while (temp != 0) {
1380             digits++;
1381             temp /= 10;
1382         }
1383         bytes memory buffer = new bytes(digits);
1384         uint256 index = digits - 1;
1385         temp = value;
1386         while (temp != 0) {
1387             buffer[index--] = bytes1(uint8(48 + temp % 10));
1388             temp /= 10;
1389         }
1390         return string(buffer);
1391     }
1392 }
1393 
1394 
1395 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.0
1396 
1397 
1398 
1399 
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 /**
1409  * @title ERC721 Non-Fungible Token Standard basic implementation
1410  * @dev see https://eips.ethereum.org/EIPS/eip-721
1411  */
1412 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1413     using SafeMath for uint256;
1414     using Address for address;
1415     using EnumerableSet for EnumerableSet.UintSet;
1416     using EnumerableMap for EnumerableMap.UintToAddressMap;
1417     using Strings for uint256;
1418 
1419     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1420     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1421     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1422 
1423     // Mapping from holder address to their (enumerable) set of owned tokens
1424     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1425 
1426     // Enumerable mapping from token ids to their owners
1427     EnumerableMap.UintToAddressMap private _tokenOwners;
1428 
1429     // Mapping from token ID to approved address
1430     mapping (uint256 => address) private _tokenApprovals;
1431 
1432     // Mapping from owner to operator approvals
1433     mapping (address => mapping (address => bool)) private _operatorApprovals;
1434 
1435     // Token name
1436     string private _name;
1437 
1438     // Token symbol
1439     string private _symbol;
1440 
1441     // Optional mapping for token URIs
1442     mapping (uint256 => string) private _tokenURIs;
1443 
1444     // Base URI
1445     string private _baseURI;
1446 
1447     /*
1448      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1449      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1450      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1451      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1452      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1453      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1454      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1455      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1456      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1457      *
1458      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1459      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1460      */
1461     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1462 
1463     /*
1464      *     bytes4(keccak256('name()')) == 0x06fdde03
1465      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1466      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1467      *
1468      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1469      */
1470     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1471 
1472     /*
1473      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1474      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1475      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1476      *
1477      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1478      */
1479     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1480 
1481     /**
1482      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1483      */
1484     constructor (string memory name_, string memory symbol_) public {
1485         _name = name_;
1486         _symbol = symbol_;
1487 
1488         // register the supported interfaces to conform to ERC721 via ERC165
1489         _registerInterface(_INTERFACE_ID_ERC721);
1490         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1491         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-balanceOf}.
1496      */
1497     function balanceOf(address owner) public view virtual override returns (uint256) {
1498         require(owner != address(0), "ERC721: balance query for the zero address");
1499         return _holderTokens[owner].length();
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-ownerOf}.
1504      */
1505     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1506         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1507     }
1508 
1509     /**
1510      * @dev See {IERC721Metadata-name}.
1511      */
1512     function name() public view virtual override returns (string memory) {
1513         return _name;
1514     }
1515 
1516     /**
1517      * @dev See {IERC721Metadata-symbol}.
1518      */
1519     function symbol() public view virtual override returns (string memory) {
1520         return _symbol;
1521     }
1522 
1523     /**
1524      * @dev See {IERC721Metadata-tokenURI}.
1525      */
1526     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1527         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1528 
1529         string memory _tokenURI = _tokenURIs[tokenId];
1530         string memory base = baseURI();
1531 
1532         // If there is no base URI, return the token URI.
1533         if (bytes(base).length == 0) {
1534             return _tokenURI;
1535         }
1536         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1537         if (bytes(_tokenURI).length > 0) {
1538             return string(abi.encodePacked(base, _tokenURI));
1539         }
1540         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1541         return string(abi.encodePacked(base, tokenId.toString()));
1542     }
1543 
1544     /**
1545     * @dev Returns the base URI set via {_setBaseURI}. This will be
1546     * automatically added as a prefix in {tokenURI} to each token's URI, or
1547     * to the token ID if no specific URI is set for that token ID.
1548     */
1549     function baseURI() public view virtual returns (string memory) {
1550         return _baseURI;
1551     }
1552 
1553     /**
1554      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1555      */
1556     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1557         return _holderTokens[owner].at(index);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721Enumerable-totalSupply}.
1562      */
1563     function totalSupply() public view virtual override returns (uint256) {
1564         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1565         return _tokenOwners.length();
1566     }
1567 
1568     /**
1569      * @dev See {IERC721Enumerable-tokenByIndex}.
1570      */
1571     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1572         (uint256 tokenId, ) = _tokenOwners.at(index);
1573         return tokenId;
1574     }
1575 
1576     /**
1577      * @dev See {IERC721-approve}.
1578      */
1579     function approve(address to, uint256 tokenId) public virtual override {
1580         address owner = ERC721.ownerOf(tokenId);
1581         require(to != owner, "ERC721: approval to current owner");
1582 
1583         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1584             "ERC721: approve caller is not owner nor approved for all"
1585         );
1586 
1587         _approve(to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-getApproved}.
1592      */
1593     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1594         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1595 
1596         return _tokenApprovals[tokenId];
1597     }
1598 
1599     /**
1600      * @dev See {IERC721-setApprovalForAll}.
1601      */
1602     function setApprovalForAll(address operator, bool approved) public virtual override {
1603         require(operator != _msgSender(), "ERC721: approve to caller");
1604 
1605         _operatorApprovals[_msgSender()][operator] = approved;
1606         emit ApprovalForAll(_msgSender(), operator, approved);
1607     }
1608 
1609     /**
1610      * @dev See {IERC721-isApprovedForAll}.
1611      */
1612     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1613         return _operatorApprovals[owner][operator];
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-transferFrom}.
1618      */
1619     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1620         //solhint-disable-next-line max-line-length
1621         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1622 
1623         _transfer(from, to, tokenId);
1624     }
1625 
1626     /**
1627      * @dev See {IERC721-safeTransferFrom}.
1628      */
1629     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1630         safeTransferFrom(from, to, tokenId, "");
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-safeTransferFrom}.
1635      */
1636     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1637         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1638         _safeTransfer(from, to, tokenId, _data);
1639     }
1640 
1641     /**
1642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1644      *
1645      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1646      *
1647      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1648      * implement alternative mechanisms to perform token transfer, such as signature-based.
1649      *
1650      * Requirements:
1651      *
1652      * - `from` cannot be the zero address.
1653      * - `to` cannot be the zero address.
1654      * - `tokenId` token must exist and be owned by `from`.
1655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1660         _transfer(from, to, tokenId);
1661         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1662     }
1663 
1664     /**
1665      * @dev Returns whether `tokenId` exists.
1666      *
1667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1668      *
1669      * Tokens start existing when they are minted (`_mint`),
1670      * and stop existing when they are burned (`_burn`).
1671      */
1672     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1673         return _tokenOwners.contains(tokenId);
1674     }
1675 
1676     /**
1677      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1678      *
1679      * Requirements:
1680      *
1681      * - `tokenId` must exist.
1682      */
1683     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1684         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1685         address owner = ERC721.ownerOf(tokenId);
1686         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1687     }
1688 
1689     /**
1690      * @dev Safely mints `tokenId` and transfers it to `to`.
1691      *
1692      * Requirements:
1693      d*
1694      * - `tokenId` must not exist.
1695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _safeMint(address to, uint256 tokenId) internal virtual {
1700         _safeMint(to, tokenId, "");
1701     }
1702 
1703     /**
1704      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1705      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1706      */
1707     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1708         _mint(to, tokenId);
1709         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1710     }
1711 
1712     /**
1713      * @dev Mints `tokenId` and transfers it to `to`.
1714      *
1715      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1716      *
1717      * Requirements:
1718      *
1719      * - `tokenId` must not exist.
1720      * - `to` cannot be the zero address.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _mint(address to, uint256 tokenId) internal virtual {
1725         require(to != address(0), "ERC721: mint to the zero address");
1726         require(!_exists(tokenId), "ERC721: token already minted");
1727 
1728         _beforeTokenTransfer(address(0), to, tokenId);
1729 
1730         _holderTokens[to].add(tokenId);
1731 
1732         _tokenOwners.set(tokenId, to);
1733 
1734         emit Transfer(address(0), to, tokenId);
1735     }
1736 
1737     /**
1738      * @dev Destroys `tokenId`.
1739      * The approval is cleared when the token is burned.
1740      *
1741      * Requirements:
1742      *
1743      * - `tokenId` must exist.
1744      *
1745      * Emits a {Transfer} event.
1746      */
1747     function _burn(uint256 tokenId) internal virtual {
1748         address owner = ERC721.ownerOf(tokenId); // internal owner
1749 
1750         _beforeTokenTransfer(owner, address(0), tokenId);
1751 
1752         // Clear approvals
1753         _approve(address(0), tokenId);
1754 
1755         // Clear metadata (if any)
1756         if (bytes(_tokenURIs[tokenId]).length != 0) {
1757             delete _tokenURIs[tokenId];
1758         }
1759 
1760         _holderTokens[owner].remove(tokenId);
1761 
1762         _tokenOwners.remove(tokenId);
1763 
1764         emit Transfer(owner, address(0), tokenId);
1765     }
1766 
1767     /**
1768      * @dev Transfers `tokenId` from `from` to `to`.
1769      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1770      *
1771      * Requirements:
1772      *
1773      * - `to` cannot be the zero address.
1774      * - `tokenId` token must be owned by `from`.
1775      *
1776      * Emits a {Transfer} event.
1777      */
1778     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1779         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1780         require(to != address(0), "ERC721: transfer to the zero address");
1781 
1782         _beforeTokenTransfer(from, to, tokenId);
1783 
1784         // Clear approvals from the previous owner
1785         _approve(address(0), tokenId);
1786 
1787         _holderTokens[from].remove(tokenId);
1788         _holderTokens[to].add(tokenId);
1789 
1790         _tokenOwners.set(tokenId, to);
1791 
1792         emit Transfer(from, to, tokenId);
1793     }
1794 
1795     /**
1796      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1797      *
1798      * Requirements:
1799      *
1800      * - `tokenId` must exist.
1801      */
1802     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1803         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1804         _tokenURIs[tokenId] = _tokenURI;
1805     }
1806 
1807     /**
1808      * @dev Internal function to set the base URI for all token IDs. It is
1809      * automatically added as a prefix to the value returned in {tokenURI},
1810      * or to the token ID if {tokenURI} is empty.
1811      */
1812     function _setBaseURI(string memory baseURI_) internal virtual {
1813         _baseURI = baseURI_;
1814     }
1815 
1816     /**
1817      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1818      * The call is not executed if the target address is not a contract.
1819      *
1820      * @param from address representing the previous owner of the given token ID
1821      * @param to target address that will receive the tokens
1822      * @param tokenId uint256 ID of the token to be transferred
1823      * @param _data bytes optional data to send along with the call
1824      * @return bool whether the call correctly returned the expected magic value
1825      */
1826     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1827     private returns (bool)
1828     {
1829         if (!to.isContract()) {
1830             return true;
1831         }
1832         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1833                 IERC721Receiver(to).onERC721Received.selector,
1834                 _msgSender(),
1835                 from,
1836                 tokenId,
1837                 _data
1838             ), "ERC721: transfer to non ERC721Receiver implementer");
1839         bytes4 retval = abi.decode(returndata, (bytes4));
1840         return (retval == _ERC721_RECEIVED);
1841     }
1842 
1843     function _approve(address to, uint256 tokenId) private {
1844         _tokenApprovals[tokenId] = to;
1845         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1846     }
1847 
1848     /**
1849      * @dev Hook that is called before any token transfer. This includes minting
1850      * and burning.
1851      *
1852      * Calling conditions:
1853      *
1854      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1855      * transferred to `to`.
1856      * - When `from` is zero, `tokenId` will be minted for `to`.
1857      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1858      * - `from` cannot be the zero address.
1859      * - `to` cannot be the zero address.
1860      *
1861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1862      */
1863     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1864 }
1865 
1866 
1867 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
1868 
1869 
1870 /**
1871  * @dev Contract module which provides a basic access control mechanism, where
1872  * there is an account (an owner) that can be granted exclusive access to
1873  * specific functions.
1874  *
1875  * By default, the owner account will be the one that deploys the contract. This
1876  * can later be changed with {transferOwnership}.
1877  *
1878  * This module is used through inheritance. It will make available the modifier
1879  * `onlyOwner`, which can be applied to your functions to restrict their use to
1880  * the owner.
1881  */
1882 abstract contract Ownable is Context {
1883     address private _owner;
1884 
1885     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1886 
1887     /**
1888      * @dev Initializes the contract setting the deployer as the initial owner.
1889      */
1890     constructor () internal {
1891         address msgSender = _msgSender();
1892         _owner = msgSender;
1893         emit OwnershipTransferred(address(0), msgSender);
1894     }
1895 
1896     /**
1897      * @dev Returns the address of the current owner.
1898      */
1899     function owner() public view virtual returns (address) {
1900         return _owner;
1901     }
1902 
1903     /**
1904      * @dev Throws if called by any account other than the owner.
1905      */
1906     modifier onlyOwner() {
1907         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1908         _;
1909     }
1910 
1911     /**
1912      * @dev Leaves the contract without owner. It will not be possible to call
1913      * `onlyOwner` functions anymore. Can only be called by the current owner.
1914      *
1915      * NOTE: Renouncing ownership will leave the contract without an owner,
1916      * thereby removing any functionality that is only available to the owner.
1917      */
1918     function renounceOwnership() public virtual onlyOwner {
1919         emit OwnershipTransferred(_owner, address(0));
1920         _owner = address(0);
1921     }
1922 
1923     /**
1924      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1925      * Can only be called by the current owner.
1926      */
1927     function transferOwnership(address newOwner) public virtual onlyOwner {
1928         require(newOwner != address(0), "Ownable: new owner is the zero address");
1929         emit OwnershipTransferred(_owner, newOwner);
1930         _owner = newOwner;
1931     }
1932 }
1933 
1934 
1935 
1936 
1937 
1938 /**
1939  * @title Mighty Manatee contract
1940  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1941  */
1942 contract MightyManatees is ERC721, Ownable {
1943     using SafeMath for uint256;
1944 
1945     uint256 public ManateePrice = 28000000000000000; // 0.028 ETH
1946     uint256 public MAX_MANATEES = 10000;
1947     uint256 public startBlockNumber;
1948     address payable public saleManager;
1949     uint256 public teamTokenCount = 0;
1950     uint256 public marketingTokenCount = 0;
1951     uint public claimWindow = 1600;
1952     uint public constant maxManateePurchase = 20;
1953 
1954     address public KZK;
1955     address public CROW;
1956     address public DF;
1957 
1958     mapping(address => uint) public freeManateeCount;
1959     mapping(address => mapping(uint => bool)) public NFTAlreadyUsedForClaim; // NFT address => tokenID => bool
1960     mapping(address => mapping(address => bool)) public userAlreadyMintedWithNFTCollection; //user => NFT address => bool
1961 
1962 
1963     event PROVupdated(string newProv);
1964 
1965 
1966     constructor(uint _start, address _KZK, address _CRZ, address _DF) ERC721("Mighty Manateez", "MM") {
1967         SaleManager manager = new SaleManager(owner(), address(this));//Make owner of NFT owner of sale manager too
1968         saleManager = address(manager);
1969         startBlockNumber = _start;
1970         KZK = _KZK;
1971         CROW = _CRZ;
1972         DF = _DF;
1973     }
1974 
1975 
1976     function setStartBlock(uint newStart) external onlyOwner{
1977         startBlockNumber = newStart;
1978     }
1979 
1980     function withdraw() public onlyOwner {
1981         uint256 balance = address(this).balance;
1982         saleManager.transfer(balance);
1983         ISaleManager(saleManager).logEther();
1984     }
1985 
1986     function claimFreeManatee(address NFT, uint tokenID) external{
1987         require(block.number < startBlockNumber, "Can not claim manatees after the sale has started");
1988         require(block.number >= (startBlockNumber.sub(claimWindow)), 'Mighty Manatee: Can not claim manatees until claim window starts');
1989         require(NFT == CROW || NFT == KZK || NFT == DF, 'Mighty Manatee: NFT collection not eligible for free claim');
1990         require(!userAlreadyMintedWithNFTCollection[msg.sender][NFT], 'Mighty Manatee: Caller already used NFT collection to claim');
1991         require(!NFTAlreadyUsedForClaim[NFT][tokenID], 'Mighty Manatee: tokenID in NFT collection already used to claim');
1992         IERC721 nft = IERC721(NFT);
1993         require(nft.ownerOf(tokenID) == msg.sender, 'Mighty Manatee: Caller does not own tokenID in NFT collection');
1994         require(freeManateeCount[NFT].add(1) <= 100, 'Mighty Manatee: Max amount of free manatees minted for NFT collection');
1995         userAlreadyMintedWithNFTCollection[msg.sender][NFT] = true;
1996         NFTAlreadyUsedForClaim[NFT][tokenID] = true;
1997         freeManateeCount[NFT] = freeManateeCount[NFT].add(1);
1998         _safeMint(msg.sender, totalSupply());
1999     }
2000 
2001     function reserveManateesForTeam(uint amount, address to) public onlyOwner {
2002         require(block.number < startBlockNumber, "Can not reserve manatees after the sale has started");
2003         require(teamTokenCount.add(amount) <= 60, "Can not mint more than 60 tokens for the team");
2004         teamTokenCount = teamTokenCount.add(amount);
2005         uint supply = totalSupply();
2006         uint i;
2007         for (i = 0; i < amount; i++) {
2008             _safeMint(to, supply + i);
2009         }
2010     }
2011 
2012     function reserveManateesForMarketing(uint amount, address to) public onlyOwner {
2013         require(block.number < startBlockNumber, "Can not reserve manatees after the sale has started");
2014         require(marketingTokenCount.add(amount) <= 100, "Can not mint more than 75 tokens for the team");
2015         marketingTokenCount = marketingTokenCount.add(amount);
2016         uint supply = totalSupply();
2017         uint i;
2018         for (i = 0; i < amount; i++) {
2019             _safeMint(to, supply + i);
2020         }
2021     }
2022 
2023     function changeNftPrice(uint256 price) public onlyOwner {
2024         ManateePrice = price;
2025     }
2026 
2027 
2028     function setBaseURI(string memory baseURI) public onlyOwner {
2029         _setBaseURI(baseURI);
2030     }
2031 
2032     function mintManatees(uint numberOfTokens) public payable {
2033         //want to add something to turn the sale off?
2034         require(block.number >= startBlockNumber, "Can not mint manatees before the sale has started");
2035         require(numberOfTokens <= maxManateePurchase, "Can only mint 20 tokens at a time");
2036         require(totalSupply().add(numberOfTokens) <= MAX_MANATEES, "Purchase would exceed max supply of Manatees");
2037         require(ManateePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2038 
2039 
2040         for(uint i = 0; i < numberOfTokens; i++) {
2041             uint mintIndex = totalSupply();
2042             if (totalSupply() < MAX_MANATEES) {
2043                 _safeMint(msg.sender, mintIndex);
2044             }
2045         }
2046     }
2047 
2048 }
2049 
2050 interface ISaleManager{
2051     function logEther() external;
2052 }