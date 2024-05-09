1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Implementation of the {IERC165} interface.
27  *
28  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
29  * for the additional interface id that will be supported. For example:
30  *
31  * ```solidity
32  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
33  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
34  * }
35  * ```
36  *
37  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
38  */
39 abstract contract ERC165 is IERC165 {
40     /**
41      * @dev See {IERC165-supportsInterface}.
42      */
43     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44         return interfaceId == type(IERC165).interfaceId;
45     }
46 }
47 
48 /**
49  * @dev Required interface of an ERC721 compliant contract.
50  */
51 interface IERC721 is IERC165 {
52     /**
53      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
59      */
60     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
64      */
65     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
66 
67     /**
68      * @dev Returns the number of tokens in ``owner``'s account.
69      */
70     function balanceOf(address owner) external view returns (uint256 balance);
71 
72     /**
73      * @dev Returns the owner of the `tokenId` token.
74      *
75      * Requirements:
76      *
77      * - `tokenId` must exist.
78      */
79     function ownerOf(uint256 tokenId) external view returns (address owner);
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
83      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must be owned by `from`.
111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
123      * The approval is cleared when the token is transferred.
124      *
125      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
126      *
127      * Requirements:
128      *
129      * - The caller must own the token or be an approved operator.
130      * - `tokenId` must exist.
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Returns the account approved for `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function getApproved(uint256 tokenId) external view returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator) external view returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 library Address {
231 
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      */
249     function isContract(address account) internal view returns (bool) {
250         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
251         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
252         // for accounts without code, i.e. `keccak256('')`
253         bytes32 codehash;
254         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
255         // solhint-disable-next-line no-inline-assembly
256         assembly { codehash := extcodehash(account) }
257         return (codehash != accountHash && codehash != 0x0);
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
280         (bool success, ) = recipient.call{ value: amount }("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain`call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
313         return _functionCallWithValue(target, data, 0, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but also transferring `value` wei to `target`.
319      *
320      * Requirements:
321      *
322      * - the calling contract must have an ETH balance of at least `value`.
323      * - the called Solidity function must be `payable`.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         return _functionCallWithValue(target, data, value, errorMessage);
340     }
341 
342     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
343         require(isContract(target), "Address: call to non-contract");
344 
345         // solhint-disable-next-line avoid-low-level-calls
346         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
347         if (success) {
348             return returndata;
349         } else {
350             // Look for revert reason and bubble it up if present
351             if (returndata.length > 0) {
352                 // The easiest way to bubble the revert reason is using memory via assembly
353 
354                 // solhint-disable-next-line no-inline-assembly
355                 assembly {
356                     let returndata_size := mload(returndata)
357                     revert(add(32, returndata), returndata_size)
358                 }
359             } else {
360                 revert(errorMessage);
361             }
362         }
363     }
364 
365 }
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 library SafeMath {
388     /**
389      * @dev Returns the addition of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `+` operator.
393      *
394      * Requirements:
395      *
396      * - Addition cannot overflow.
397      */
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         require(c >= a, "SafeMath: addition overflow");
401 
402         return c;
403     }
404 
405     /**
406      * @dev Returns the subtraction of two unsigned integers, reverting on
407      * overflow (when the result is negative).
408      *
409      * Counterpart to Solidity's `-` operator.
410      *
411      * Requirements:
412      *
413      * - Subtraction cannot overflow.
414      */
415     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
416         return sub(a, b, "SafeMath: subtraction overflow");
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
421      * overflow (when the result is negative).
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      *
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
430         require(b <= a, errorMessage);
431         uint256 c = a - b;
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the multiplication of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `*` operator.
441      *
442      * Requirements:
443      *
444      * - Multiplication cannot overflow.
445      */
446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
448         // benefit is lost if 'b' is also tested.
449         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
450         if (a == 0) {
451             return 0;
452         }
453 
454         uint256 c = a * b;
455         require(c / a == b, "SafeMath: multiplication overflow");
456 
457         return c;
458     }
459 
460     /**
461      * @dev Returns the integer division of two unsigned integers. Reverts on
462      * division by zero. The result is rounded towards zero.
463      *
464      * Counterpart to Solidity's `/` operator. Note: this function uses a
465      * `revert` opcode (which leaves remaining gas untouched) while Solidity
466      * uses an invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         return div(a, b, "SafeMath: division by zero");
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
478      * division by zero. The result is rounded towards zero.
479      *
480      * Counterpart to Solidity's `/` operator. Note: this function uses a
481      * `revert` opcode (which leaves remaining gas untouched) while Solidity
482      * uses an invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
489         require(b > 0, errorMessage);
490         uint256 c = a / b;
491         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
492 
493         return c;
494     }
495 
496     /**
497      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
498      * Reverts when dividing by zero.
499      *
500      * Counterpart to Solidity's `%` operator. This function uses a `revert`
501      * opcode (which leaves remaining gas untouched) while Solidity uses an
502      * invalid opcode to revert (consuming all remaining gas).
503      *
504      * Requirements:
505      *
506      * - The divisor cannot be zero.
507      */
508     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
509         return mod(a, b, "SafeMath: modulo by zero");
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * Reverts with custom message when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b != 0, errorMessage);
526         return a % b;
527     }
528 }
529 
530 interface IERC20 {
531 
532     function totalSupply() external view returns (uint256);
533     
534     function symbol() external view returns(string memory);
535     
536     function name() external view returns(string memory);
537 
538     /**
539      * @dev Returns the amount of tokens owned by `account`.
540      */
541     function balanceOf(address account) external view returns (uint256);
542     
543     /**
544      * @dev Returns the number of decimal places
545      */
546     function decimals() external view returns (uint8);
547 
548     /**
549      * @dev Moves `amount` tokens from the caller's account to `recipient`.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transfer(address recipient, uint256 amount) external returns (bool);
556 
557     /**
558      * @dev Returns the remaining number of tokens that `spender` will be
559      * allowed to spend on behalf of `owner` through {transferFrom}. This is
560      * zero by default.
561      *
562      * This value changes when {approve} or {transferFrom} are called.
563      */
564     function allowance(address owner, address spender) external view returns (uint256);
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
568      *
569      * Returns a boolean value indicating whether the operation succeeded.
570      *
571      * IMPORTANT: Beware that changing an allowance with this method brings the risk
572      * that someone may use both the old and the new allowance by unfortunate
573      * transaction ordering. One possible solution to mitigate this race
574      * condition is to first reduce the spender's allowance to 0 and set the
575      * desired value afterwards:
576      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address spender, uint256 amount) external returns (bool);
581 
582     /**
583      * @dev Moves `amount` tokens from `sender` to `recipient` using the
584      * allowance mechanism. `amount` is then deducted from the caller's
585      * allowance.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
592 
593     /**
594      * @dev Emitted when `value` tokens are moved from one account (`from`) to
595      * another (`to`).
596      *
597      * Note that `value` may be zero.
598      */
599     event Transfer(address indexed from, address indexed to, uint256 value);
600 
601     /**
602      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
603      * a call to {approve}. `value` is the new allowance.
604      */
605     event Approval(address indexed owner, address indexed spender, uint256 value);
606 }
607 
608 contract Ownable {
609 
610     address private owner;
611     
612     // event for EVM logging
613     event OwnerSet(address indexed oldOwner, address indexed newOwner);
614     
615     // modifier to check if caller is owner
616     modifier onlyOwner() {
617         // If the first argument of 'require' evaluates to 'false', execution terminates and all
618         // changes to the state and to Ether balances are reverted.
619         // This used to consume all gas in old EVM versions, but not anymore.
620         // It is often a good idea to use 'require' to check if functions are called correctly.
621         // As a second argument, you can also provide an explanation about what went wrong.
622         require(msg.sender == owner, "Caller is not owner");
623         _;
624     }
625     
626     /**
627      * @dev Set contract deployer as owner
628      */
629     constructor() {
630         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
631         emit OwnerSet(address(0), owner);
632     }
633 
634     /**
635      * @dev Change owner
636      * @param newOwner address of new owner
637      */
638     function changeOwner(address newOwner) public onlyOwner {
639         emit OwnerSet(owner, newOwner);
640         owner = newOwner;
641     }
642 
643     /**
644      * @dev Return owner address 
645      * @return address of owner
646      */
647     function getOwner() external view returns (address) {
648         return owner;
649     }
650 }
651 
652 contract FoundersCard is Context, ERC165, IERC721, IERC721Metadata, Ownable {
653 
654     using Address for address;
655     using SafeMath for uint256;
656 
657     // Token name
658     string private constant _name = "Founders Card";
659 
660     // Token symbol
661     string private constant _symbol = "FOUNDERS";
662 
663     // total number of NFTs Minted
664     uint256 private _totalSupply;
665 
666     // max supply cap
667     uint256 public constant MAX_SUPPLY = 1_000;
668 
669     // Mapping from token ID to owner address
670     mapping(uint256 => address) private _owners;
671 
672     // Mapping owner address to token count
673     mapping(address => uint256) private _balances;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     // USDC Mint Token
682     IERC20 public immutable USDC;
683 
684     // max holdings per wallet post mint
685     uint256 private constant MAX_HOLDINGS = 5;
686 
687     // cost for minting NFT
688     uint256 public cost = 500 * 10**6;
689 
690     // base URI
691     string private _tokenURI = "Enter_Base_URI_Here.json";
692 
693     // Enable Trading
694     bool public whitelistEnabled = true;
695 
696     // User Structure
697     struct User {
698         bool isWhitelisted;
699         bool isGuaranteedWhitelisted;
700         uint256 whitelistSlots;
701         uint256 guaranteedSlots;
702     }
703     mapping ( address => User ) public userInfo;
704 
705     constructor (IERC20 usdc_) {
706         USDC = usdc_;
707     }
708 
709     ////////////////////////////////////////////////
710     ///////////   RESTRICTED FUNCTIONS   ///////////
711     ////////////////////////////////////////////////
712 
713     function disableWhitelist() external onlyOwner {
714         whitelistEnabled = false;
715     }
716 
717     function enableWhitelist() external onlyOwner {
718         whitelistEnabled = true;
719     }
720 
721     function withdraw() external onlyOwner {
722         (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
723         require(s);
724     }
725 
726     function withdrawToken(address token) external onlyOwner {
727         require(token != address(0), 'Zero Address');
728         IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
729     }
730 
731     function withdrawUSDC() external onlyOwner {
732         USDC.transfer(msg.sender, USDC.balanceOf(address(this)));
733     }
734 
735     function setCost(uint256 newCost) external onlyOwner {
736         cost = newCost;
737     }
738 
739     function setTokenURI(string calldata newURI) external onlyOwner {
740         _tokenURI = newURI;
741     }
742 
743     function whitelistUsers(address[] calldata users) external onlyOwner {
744         uint len = users.length;
745         for (uint i = 0; i < len; i++) {
746             userInfo[users[i]].isWhitelisted = true;
747         }
748     }
749 
750     function guaranteeWhitelistUsers(address[] calldata users) external onlyOwner {
751         uint len = users.length;
752         for (uint i = 0; i < len; i++) {
753             userInfo[users[i]].isGuaranteedWhitelisted = true;
754         }
755     }
756 
757     ////////////////////////////////////////////////
758     ///////////     PUBLIC FUNCTIONS     ///////////
759     ////////////////////////////////////////////////
760 
761     /** 
762      * Mints `nMints` NFTs To Caller
763      */
764     function mint(uint256 nMints) external {
765         require(
766             !whitelistEnabled, 
767             'White list is enabled'
768         );
769         require(
770             nMints > 0 && nMints <= 3, 
771             'Invalid Input'
772         );
773 
774         // transfer in USDC
775         uint256 received = _transferIn(nMints * cost);
776         require(cost * nMints <= received, 'Incorrect Value Sent');
777 
778         for (uint i = 0; i < nMints; i++) {
779             _safeMint(msg.sender, _totalSupply);
780         }
781 
782         require(
783             _balances[msg.sender] <= MAX_HOLDINGS,
784             'Max Holdings Exceeded'
785         );
786     }
787 
788     /** 
789      * Mints `nMints` NFTs To Caller
790      */
791     function mintWhitelist(uint256 nMints) external {
792         require(
793             whitelistEnabled,
794             'White list is not enabled'
795         );
796         require(
797             userInfo[msg.sender].isWhitelisted,
798             'Not Whitelisted'
799         );
800         require(
801             nMints > 0,
802             'Zero Mints'
803         );
804 
805         userInfo[msg.sender].whitelistSlots += nMints;
806         require(
807             userInfo[msg.sender].whitelistSlots <= 3,
808             'Too Many Mints'
809         );
810 
811         // transfer in USDC
812         uint256 received = _transferIn(nMints * cost);
813         require(cost * nMints <= received, 'Incorrect Value Sent');
814 
815         for (uint i = 0; i < nMints; i++) {
816             _safeMint(msg.sender, _totalSupply);
817         }
818 
819         require(
820             _balances[msg.sender] <= MAX_HOLDINGS,
821             'Max Holdings Exceeded'
822         );
823     }
824 
825     /** 
826      * Mints `nMints` NFTs To Caller
827      */
828     function mintGuaranteed(uint256 nMints) external {
829         require(
830             whitelistEnabled,
831             'White list is not enabled'
832         );
833         require(
834             userInfo[msg.sender].isGuaranteedWhitelisted,
835             'Not Guaranteed Whitelisted'
836         );
837         require(
838             nMints > 0,
839             'Zero Mints'
840         );
841 
842         userInfo[msg.sender].guaranteedSlots += nMints;
843         require(
844             userInfo[msg.sender].guaranteedSlots <= 2,
845             'Too Many Mints'
846         );
847 
848         // transfer in USDC
849         uint256 received = _transferIn(nMints * cost);
850         require(cost * nMints <= received, 'Incorrect Value Sent');
851 
852         for (uint i = 0; i < nMints; i++) {
853             _safeMint(msg.sender, _totalSupply);
854         }
855 
856         require(
857             _balances[msg.sender] <= MAX_HOLDINGS,
858             'Max Holdings Exceeded'
859         );
860     }
861 
862     receive() external payable {}
863 
864     /**
865      * @dev See {IERC721-approve}.
866      */
867     function approve(address to, uint256 tokenId) public override {
868         address wpowner = ownerOf(tokenId);
869         require(to != wpowner, "ERC721: approval to current owner");
870 
871         require(
872             _msgSender() == wpowner || isApprovedForAll(wpowner, _msgSender()),
873             "ERC721: not approved or owner"
874         );
875 
876         _approve(to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-setApprovalForAll}.
881      */
882     function setApprovalForAll(address _operator, bool approved) public override {
883         _setApprovalForAll(_msgSender(), _operator, approved);
884     }
885 
886     /**
887      * @dev See {IERC721-transferFrom}.
888      */
889     function transferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public override {
894         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public override {
906         safeTransferFrom(from, to, tokenId, "");
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public override {
918         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
919         _safeTransfer(from, to, tokenId, _data);
920     }
921 
922 
923     ////////////////////////////////////////////////
924     ///////////     READ FUNCTIONS       ///////////
925     ////////////////////////////////////////////////
926 
927     function totalSupply() external view returns (uint256) {
928         return _totalSupply;
929     }
930 
931     function getIDsByOwner(address owner) external view returns (uint256[] memory) {
932         uint256[] memory ids = new uint256[](balanceOf(owner));
933         if (balanceOf(owner) == 0) return ids;
934         uint256 count = 0;
935         for (uint i = 0; i < MAX_SUPPLY; i++) {
936             if (ownerOf(i) == owner) {
937                 ids[count] = i;
938                 count++;
939             }
940         }
941         return ids;
942     }
943 
944     /**
945      * @dev See {IERC165-supportsInterface}.
946      */
947     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
948         return
949             interfaceId == type(IERC721).interfaceId ||
950             interfaceId == type(IERC721Metadata).interfaceId ||
951             super.supportsInterface(interfaceId);
952     }
953 
954     /**
955      * @dev See {IERC721-balanceOf}.
956      */
957     function balanceOf(address wpowner) public view override returns (uint256) {
958         require(wpowner != address(0), "query for the zero address");
959         return _balances[wpowner];
960     }
961 
962     /**
963      * @dev See {IERC721-ownerOf}.
964      */
965     function ownerOf(uint256 tokenId) public view override returns (address) {
966         address wpowner = _owners[tokenId];
967         require(wpowner != address(0), "query for nonexistent token");
968         return wpowner;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-name}.
973      */
974     function name() public pure override returns (string memory) {
975         return _name;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-symbol}.
980      */
981     function symbol() public pure override returns (string memory) {
982         return _symbol;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-tokenURI}.
987      */
988     function tokenURI(uint256) public view override returns (string memory) {
989         return _tokenURI;
990     }
991 
992     /**
993         Converts A Uint Into a String
994     */
995     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
996         if (_i == 0) {
997             return "0";
998         }
999         uint j = _i;
1000         uint len;
1001         while (j != 0) {
1002             len++;
1003             j /= 10;
1004         }
1005         bytes memory bstr = new bytes(len);
1006         uint k = len;
1007         while (_i != 0) {
1008             k = k-1;
1009             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1010             bytes1 b1 = bytes1(temp);
1011             bstr[k] = b1;
1012             _i /= 10;
1013         }
1014         return string(bstr);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-getApproved}.
1019      */
1020     function getApproved(uint256 tokenId) public view override returns (address) {
1021         require(_exists(tokenId), "ERC721: query for nonexistent token");
1022 
1023         return _tokenApprovals[tokenId];
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address wpowner, address _operator) public view override returns (bool) {
1030         return _operatorApprovals[wpowner][_operator];
1031     }
1032 
1033     /**
1034      * @dev Returns whether `tokenId` exists.
1035      *
1036      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1037      *
1038      * Tokens start existing when they are minted
1039      */
1040     function _exists(uint256 tokenId) internal view returns (bool) {
1041         return _owners[tokenId] != address(0);
1042     }
1043 
1044     /**
1045      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      */
1051     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1052         require(_exists(tokenId), "ERC721: nonexistent token");
1053         address wpowner = ownerOf(tokenId);
1054         return (spender == wpowner || getApproved(tokenId) == spender || isApprovedForAll(wpowner, spender));
1055     }
1056 
1057     ////////////////////////////////////////////////
1058     ///////////    INTERNAL FUNCTIONS    ///////////
1059     ////////////////////////////////////////////////
1060 
1061 
1062     /**
1063      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1064      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 tokenId
1069     ) internal {
1070         _mint(to, tokenId);
1071         require(
1072             _checkOnERC721Received(address(0), to, tokenId, ""),
1073             "ERC721: transfer to non ERC721Receiver implementer"
1074         );
1075     }
1076 
1077     /**
1078      * @dev Mints `tokenId` and transfers it to `to`.
1079      *
1080      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must not exist.
1085      * - `to` cannot be the zero address.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(address to, uint256 tokenId) internal {
1090         require(!_exists(tokenId), "ERC721: token already minted");
1091         require(_totalSupply < MAX_SUPPLY, 'All NFTs Have Been Minted');
1092 
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095         _totalSupply++;
1096 
1097         emit Transfer(address(0), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1103      *
1104      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1105      *
1106      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1107      * implement alternative mechanisms to perform token transfer, such as signature-based.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must exist and be owned by `from`.
1114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _safeTransfer(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) internal {
1124         _transfer(from, to, tokenId);
1125         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: non ERC721Receiver implementer");
1126     }
1127 
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must be owned by `from`.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) internal {
1145         require(ownerOf(tokenId) == from, "Incorrect owner");
1146         require(to != address(0), "zero address");
1147         require(balanceOf(from) > 0, 'Zero Balance');
1148 
1149         // Clear approvals from the previous owner
1150         _approve(address(0), tokenId);
1151 
1152         // Allocate balances
1153         _balances[from] -= 1;
1154         _balances[to] += 1;
1155         _owners[tokenId] = to;
1156 
1157         // emit transfer
1158         emit Transfer(from, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Approve `to` to operate on `tokenId`
1163      *
1164      * Emits a {Approval} event.
1165      */
1166     function _approve(address to, uint256 tokenId) internal {
1167         _tokenApprovals[tokenId] = to;
1168         emit Approval(ownerOf(tokenId), to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Approve `operator` to operate on all of `owner` tokens
1173      *
1174      * Emits a {ApprovalForAll} event.
1175      */
1176     function _setApprovalForAll(
1177         address wpowner,
1178         address _operator,
1179         bool approved
1180     ) internal {
1181         require(wpowner != _operator, "ERC721: approve to caller");
1182         _operatorApprovals[wpowner][_operator] = approved;
1183         emit ApprovalForAll(wpowner, _operator, approved);
1184     }
1185 
1186     function onReceivedRetval() public pure returns (bytes4) {
1187         return IERC721Receiver.onERC721Received.selector;
1188     }
1189 
1190     function _transferIn(uint256 amount) internal returns (uint256) {
1191         uint before = USDC.balanceOf(address(this));
1192         require(
1193             USDC.transferFrom(
1194                 msg.sender,
1195                 address(this),
1196                 amount
1197             ),
1198             'ERR Transfer From'
1199         );
1200         uint After = USDC.balanceOf(address(this));
1201         require(
1202             After > before,
1203             'Zero Received'
1204         );
1205         return After - before;
1206     }
1207 
1208     /**
1209      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1210      * The call is not executed if the target address is not a contract.
1211      *
1212      * @param from address representing the previous owner of the given token ID
1213      * @param to target address that will receive the tokens
1214      * @param tokenId uint256 ID of the token to be transferred
1215      * @param _data bytes optional data to send along with the call
1216      * @return bool whether the call correctly returned the expected magic value
1217      */
1218     function _checkOnERC721Received(
1219         address from,
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) private returns (bool) {
1224         if (to.isContract()) {
1225             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1226                 return retval == IERC721Receiver.onERC721Received.selector;
1227             } catch (bytes memory reason) {
1228                 if (reason.length == 0) {
1229                     revert("ERC721: non ERC721Receiver implementer");
1230                 } else {
1231                     assembly {
1232                         revert(add(32, reason), mload(reason))
1233                     }
1234                 }
1235             }
1236         } else {
1237             return true;
1238         }
1239     }
1240 }