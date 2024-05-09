1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.0;
8 
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12    */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the token decimals.
17    */
18     function decimals() external view returns (uint8);
19 
20     /**
21      * @dev Returns the token symbol.
22    */
23     function symbol() external view returns (string memory);
24 
25     /**
26     * @dev Returns the token name.
27   */
28     function name() external view returns (string memory);
29 
30     /**
31      * @dev Returns the bep token owner.
32    */
33     function getOwner() external view returns (address);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37    */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42    *
43    * Returns a boolean value indicating whether the operation succeeded.
44    *
45    * Emits a {Transfer} event.
46    */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51    * allowed to spend on behalf of `owner` through {transferFrom}. This is
52    * zero by default.
53    *
54    * This value changes when {approve} or {transferFrom} are called.
55    */
56     function allowance(address _owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60    *
61    * Returns a boolean value indicating whether the operation succeeded.
62    *
63    * IMPORTANT: Beware that changing an allowance with this method brings the risk
64    * that someone may use both the old and the new allowance by unfortunate
65    * transaction ordering. One possible solution to mitigate this race
66    * condition is to first reduce the spender's allowance to 0 and set the
67    * desired value afterwards:
68    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69    *
70    * Emits an {Approval} event.
71    */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76    * allowance mechanism. `amount` is then deducted from the caller's
77    * allowance.
78    *
79    * Returns a boolean value indicating whether the operation succeeded.
80    *
81    * Emits a {Transfer} event.
82    */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87    * another (`to`).
88    *
89    * Note that `value` may be zero.
90    */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95    * a call to {approve}. `value` is the new allowance.
96    */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /*
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with GSN meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 contract Context {
111     // Empty internal constructor, to prevent people from mistakenly deploying
112     // an instance of this contract, which should be used via inheritance.
113     constructor ()  {}
114 
115     function _msgSender() internal view returns (address payable) {
116         return payable (msg.sender);
117     }
118 
119     function _msgData() internal view returns (bytes memory) {
120         this;
121         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
122         return msg.data;
123     }
124 }
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations with added overflow
128  * checks.
129  *
130  * Arithmetic operations in Solidity wrap on overflow. This can easily result
131  * in bugs, because programmers usually assume that an overflow raises an
132  * error, which is the standard behavior in high level programming languages.
133  * `SafeMath` restores this intuition by reverting the transaction when an
134  * operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142    * overflow.
143    *
144    * Counterpart to Solidity's `+` operator.
145    *
146    * Requirements:
147    * - Addition cannot overflow.
148    */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158    * overflow (when the result is negative).
159    *
160    * Counterpart to Solidity's `-` operator.
161    *
162    * Requirements:
163    * - Subtraction cannot overflow.
164    */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171    * overflow (when the result is negative).
172    *
173    * Counterpart to Solidity's `-` operator.
174    *
175    * Requirements:
176    * - Subtraction cannot overflow.
177    */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187    * overflow.
188    *
189    * Counterpart to Solidity's `*` operator.
190    *
191    * Requirements:
192    * - Multiplication cannot overflow.
193    */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210    * division by zero. The result is rounded towards zero.
211    *
212    * Counterpart to Solidity's `/` operator. Note: this function uses a
213    * `revert` opcode (which leaves remaining gas untouched) while Solidity
214    * uses an invalid opcode to revert (consuming all remaining gas).
215    *
216    * Requirements:
217    * - The divisor cannot be zero.
218    */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225    * division by zero. The result is rounded towards zero.
226    *
227    * Counterpart to Solidity's `/` operator. Note: this function uses a
228    * `revert` opcode (which leaves remaining gas untouched) while Solidity
229    * uses an invalid opcode to revert (consuming all remaining gas).
230    *
231    * Requirements:
232    * - The divisor cannot be zero.
233    */
234     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         // Solidity only automatically asserts when dividing by 0
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245    * Reverts when dividing by zero.
246    *
247    * Counterpart to Solidity's `%` operator. This function uses a `revert`
248    * opcode (which leaves remaining gas untouched) while Solidity uses an
249    * invalid opcode to revert (consuming all remaining gas).
250    *
251    * Requirements:
252    * - The divisor cannot be zero.
253    */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return mod(a, b, "SafeMath: modulo by zero");
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260    * Reverts with custom message when dividing by zero.
261    *
262    * Counterpart to Solidity's `%` operator. This function uses a `revert`
263    * opcode (which leaves remaining gas untouched) while Solidity uses an
264    * invalid opcode to revert (consuming all remaining gas).
265    *
266    * Requirements:
267    * - The divisor cannot be zero.
268    */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 /**
276  * @dev Contract module which provides a basic access control mechanism, where
277  * there is an account (an owner) that can be granted exclusive access to
278  * specific functions.
279  *
280  * By default, the owner account will be the one that deploys the contract. This
281  * can later be changed with {transferOwnership}.
282  *
283  * This module is used through inheritance. It will make available the modifier
284  * `onlyOwner`, which can be applied to your functions to restrict their use to
285  * the owner.
286  */
287 contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
291 
292     /**
293      * @dev Initializes the contract setting the deployer as the initial owner.
294    */
295     constructor ()  {
296         address msgSender = _msgSender();
297         _owner = msgSender;
298         emit OwnershipTransferred(address(0), msgSender);
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303    */
304     function owner() public view returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310    */
311     modifier onlyOwner() {
312         require(_owner == _msgSender(), "Ownable: caller is not the owner");
313         _;
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318    * Can only be called by the current owner.
319    */
320     function transferOwnership(address newOwner) public onlyOwner {
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326    */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
354         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
355         // for accounts without code, i.e. `keccak256('')`
356         bytes32 codehash;
357         bytes32 accountHash =
358         0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
359         // solhint-disable-next-line no-inline-assembly
360         assembly {
361             codehash := extcodehash(account)
362         }
363         return (codehash != accountHash && codehash != 0x0);
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(
384             address(this).balance >= amount,
385             "Address: insufficient balance"
386         );
387 
388         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
389         (bool success,) = recipient.call{value : amount}("");
390         require(
391             success,
392             "Address: unable to send value, recipient may have reverted"
393         );
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain`call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data)
415     internal
416     returns (bytes memory)
417     {
418         return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         return _functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 value
450     ) internal returns (bytes memory) {
451         return
452         functionCallWithValue(
453             target,
454             data,
455             value,
456             "Address: low-level call with value failed"
457         );
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
462      * with `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(
473             address(this).balance >= value,
474             "Address: insufficient balance for call"
475         );
476         return _functionCallWithValue(target, data, value, errorMessage);
477     }
478 
479     function _functionCallWithValue(
480         address target,
481         bytes memory data,
482         uint256 weiValue,
483         string memory errorMessage
484     ) private returns (bytes memory) {
485         require(isContract(target), "Address: call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) =
489         target.call{value : weiValue}(data);
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 // solhint-disable-next-line no-inline-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 interface IERC721 is IERC165 {
522     /**
523      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
529      */
530     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in ``owner``'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Transfers `tokenId` token from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
593      * The approval is cleared when the token is transferred.
594      *
595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
596      *
597      * Requirements:
598      *
599      * - The caller must own the token or be an approved operator.
600      * - `tokenId` must exist.
601      *
602      * Emits an {Approval} event.
603      */
604     function approve(address to, uint256 tokenId) external;
605 
606     /**
607      * @dev Returns the account approved for `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function getApproved(uint256 tokenId) external view returns (address operator);
614 
615     /**
616      * @dev Approve or remove `operator` as an operator for the caller.
617      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
618      *
619      * Requirements:
620      *
621      * - The `operator` cannot be the caller.
622      *
623      * Emits an {ApprovalForAll} event.
624      */
625     function setApprovalForAll(address operator, bool _approved) external;
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must exist and be owned by `from`.
642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId,
651         bytes calldata data
652     ) external;
653 }
654 
655 contract WYVERNSBREATH is Context, IERC20, Ownable {
656     using Address for address;
657     using SafeMath for uint256;
658 
659     mapping(uint => uint) public lastUpdate;
660     mapping(address => uint256) private _balances;
661     mapping(address => mapping(address => uint256)) private _allowances;
662     mapping(uint => uint) public wyvernTypeToEarningsPerDay;
663     mapping(uint => uint) public wyvernTokenToWyvernType;
664     uint deployedTime = 1637427600; //epoch time deployed at 20th Nov 2021 ETC
665     uint public timeInSecsInADay = 24*60*60; 
666     event mintOverflown (uint amountGiven, uint notgiven, string message);
667 
668     //todo : write a setter for maxSupply
669     uint private maxSupply = 10000000 * (10 ** 18); // 10 million Breath tokens
670     uint256 private _totalSupply;
671     uint8 public _decimals;
672     string public _symbol;
673     string public _name;
674     IERC721 private nft;
675     
676 
677     constructor()  {
678         _name = "Wyverns Breath";
679         _symbol = "$BREATH";
680         _decimals = 18;
681         _totalSupply = 0;
682 
683         nft = IERC721(0x01fE2358CC2CA3379cb5eD11442e85881997F22C);
684 
685         // 1 means Genesis
686         wyvernTypeToEarningsPerDay[1] = 5;
687         // 2 means Ascension
688         wyvernTypeToEarningsPerDay[2] = 25;
689     }
690 
691     // function setWyvernTokenToWyvernType(uint _fromId, uint _tillId, uint wyvernType) external onlyOwner{
692     //     for (uint i = _fromId; i <= _tillId; i++) {
693     //         wyvernTokenToWyvernType[i] = wyvernType;
694     //         //  code 1  means Genesis
695     //         //  code 2  means Ascension
696     //     }
697     // }
698 
699     /**
700      * @dev Returns the bep token owner.
701    */
702     function getOwner() external override view returns (address) {
703         return owner();
704     }
705 
706     /**
707      * @dev Returns the token decimals.
708    */
709     function decimals() external override view returns (uint8) {
710         return _decimals;
711     }
712 
713     /**
714      * @dev Returns the token symbol.
715    */
716     function symbol() external override view returns (string memory) {
717         return _symbol;
718     }
719 
720     /**
721     * @dev Returns the token name.
722   */
723     function name() external override view returns (string memory) {
724         return _name;
725     }
726 
727     /**
728      * @dev See {ERC20-totalSupply}.
729    */
730     function totalSupply() public override view returns (uint256) {
731         return _totalSupply;
732     }
733 
734     /**
735      * @dev See {ERC20-balanceOf}.
736    */
737     function balanceOf(address account) external override view returns (uint256) {
738         return _balances[account];
739     }
740 
741     //private setter
742     function setWyvernTypeCodeAndEarnings(uint wyvernTypeCode, uint _amount) external onlyOwner {
743         wyvernTypeToEarningsPerDay[wyvernTypeCode] = _amount;
744     }
745     //private setter
746     function addTokenWyvernType(uint[] memory tokenIds, uint[] memory wyvernTypeCodes) external onlyOwner {
747         require(tokenIds.length == wyvernTypeCodes.length, "Inputs provided with different no of values, should be EQUAL.");
748         for (uint i = 0; i < tokenIds.length; i++) {
749             wyvernTokenToWyvernType[tokenIds[i]] = wyvernTypeCodes[i];
750         }
751     }
752 
753     function setMaxSupply(uint newMaxSupply) external onlyOwner{
754         maxSupply = newMaxSupply;
755     }
756     // public getter//trait1=>25
757     function showWyvernTypeEarningsPerDay(uint wyvernTypeCode) external view returns (uint) {
758         return wyvernTypeToEarningsPerDay[wyvernTypeCode];
759     }
760 
761     /**
762      * @dev See {ERC20-transfer}.
763    *
764    * Requirements:
765    *
766    * - `recipient` cannot be the zero address.
767    * - the caller must have a balance of at least `amount`.
768    */
769     function transfer(address recipient, uint256 amount) external override returns (bool) {
770         _transfer(_msgSender(), recipient, amount);
771         return true;
772     }
773 
774     /**
775      * @dev See {ERC20-allowance}.
776    */
777     function allowance(address owner, address spender) external override view returns (uint256) {
778         return _allowances[owner][spender];
779     }
780 
781     /**
782      * @dev See {ERC20-approve}.
783    *
784    * Requirements:
785    *
786    * - `spender` cannot be the zero address.
787    */
788     function approve(address spender, uint256 amount) external override returns (bool) {
789         _approve(_msgSender(), spender, amount);
790         return true;
791     }
792 
793     /**
794      * @dev See {ERC20-transferFrom}.
795    *
796    * Emits an {Approval} event indicating the updated allowance. This is not
797    * required by the EIP. See the note at the beginning of {ERC20};
798    *
799    * Requirements:
800    * - `sender` and `recipient` cannot be the zero address.
801    * - `sender` must have a balance of at least `amount`.
802    * - the caller must have allowance for `sender`'s tokens of at least
803    * `amount`.
804    */
805     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
806         _transfer(sender, recipient, amount);
807         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
808         return true;
809     }
810 
811     /**
812      * @dev Atomically increases the allowance granted to `spender` by the caller.
813    *
814    * This is an alternative to {approve} that can be used as a mitigation for
815    * problems described in {ERC20-approve}.
816    *
817    * Emits an {Approval} event indicating the updated allowance.
818    *
819    * Requirements:
820    *
821    * - `spender` cannot be the zero address.
822    */
823     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
825         return true;
826     }
827 
828     /**
829      * @dev Atomically decreases the allowance granted to `spender` by the caller.
830    *
831    * This is an alternative to {approve} that can be used as a mitigation for
832    * problems described in {ERC20-approve}.
833    *
834    * Emits an {Approval} event indicating the updated allowance.
835    *
836    * Requirements:
837    *
838    * - `spender` cannot be the zero address.
839    * - `spender` must have allowance for the caller of at least
840    * `subtractedValue`.
841    */
842     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
843         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
844         return true;
845     }
846 
847     /**
848      * @dev Burn `amount` tokens and decreasing the total supply.
849    */
850     function burn(uint256 amount) public returns (bool) {
851         _burn(_msgSender(), amount);
852         return true;
853     }
854 
855     /**
856      * @dev Moves tokens `amount` from `sender` to `recipient`.
857    *
858    * This is internal function is equivalent to {transfer}, and can be used to
859    * e.g. implement automatic token fees, slashing mechanisms, etc.
860    *
861    * Emits a {Transfer} event.
862    *
863    * Requirements:
864    *
865    * - `sender` cannot be the zero address.
866    * - `recipient` cannot be the zero address.
867    * - `sender` must have a balance of at least `amount`.
868    */
869     function _transfer(address sender, address recipient, uint256 amount) internal {
870         require(sender != address(0), "ERC20: transfer from the zero address");
871         require(recipient != address(0), "ERC20: transfer to the zero address");
872 
873         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
874         _balances[recipient] = _balances[recipient].add(amount);
875         emit Transfer(sender, recipient, amount);
876     }
877 
878     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
879    * the total supply.
880    *
881    * Emits a {Transfer} event with `from` set to the zero address.
882    *
883    * Requirements
884    *
885    * - `to` cannot be the zero address.
886    */
887     function _mint(address account, uint256 amount) internal {
888         require(account != address(0), "ERC20: mint to the zero address");
889 
890         _totalSupply = _totalSupply.add(amount);
891         _balances[account] = _balances[account].add(amount);
892         emit Transfer(address(0), account, amount);
893     }
894 
895     /**
896      * @dev Destroys `amount` tokens from `account`, reducing the
897    * total supply.
898    *
899    * Emits a {Transfer} event with `to` set to the zero address.
900    *
901    * Requirements
902    *
903    * - `account` cannot be the zero address.
904    * - `account` must have at least `amount` tokens.
905    */
906     function _burn(address account, uint256 amount) internal {
907         require(account != address(0), "ERC20: burn from the zero address");
908 
909         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
910         _totalSupply = _totalSupply.sub(amount);
911         emit Transfer(account, address(0), amount);
912     }
913 
914     /**
915      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
916    *
917    * This is internal function is equivalent to `approve`, and can be used to
918    * e.g. set aumatic allowances for certain subsystems, etc.
919    *
920    * Emits an {Approval} event.
921    *
922    * Requirements:
923    *
924    * - `owner` cannot be the zero address.
925    * - `spender` cannot be the zero address.
926    */
927     function _approve(address owner, address spender, uint256 amount) internal {
928         require(owner != address(0), "ERC20: approve fromm the zero address");
929         require(spender != address(0), "ERC20: approvee to the zero address");
930 
931         _allowances[owner][spender] = amount;
932         emit Approval(owner, spender, amount);
933     }
934 
935     /**
936      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
937    * from the caller's allowance.
938    *
939    * See {_burn} and {_approve}.
940    */
941     function _burnFrom(address account, uint256 amount) internal {
942         _burn(account, amount);
943         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
944     }
945 
946     function modifytimeInSec(uint _timeInSec) external onlyOwner {
947         timeInSecsInADay = _timeInSec;
948     }
949 
950     function getTypeOfToken(uint tokenId) internal view returns(uint) {
951         if (tokenId >= 1 && tokenId <= 3500) {
952             return 1;
953         }
954         else {
955             return wyvernTokenToWyvernType[tokenId];
956             }
957     }
958 
959     function claimToken(uint[] memory tokenIds) external {
960         uint amount = 0;
961         uint today_count = block.timestamp / timeInSecsInADay;
962         for (uint i = 0; i < tokenIds.length; i++) {
963             if (nft.ownerOf(tokenIds[i]) == msg.sender) {
964                 uint tokenAccumulation = getPendingReward(tokenIds[i], today_count, getTypeOfToken(tokenIds[i]));
965                 if (tokenAccumulation > 0) {
966                     if (maxSupply < _totalSupply + amount + tokenAccumulation) {
967                         emit mintOverflown(amount, tokenAccumulation, "Minting Limit Reached");
968                         break;
969                     }
970                     amount += tokenAccumulation;
971                     lastUpdate[tokenIds[i]] = today_count;
972                 }
973             }
974         }
975         require (amount > 0,"NO positive number of $BREATH tokens are available to mint");
976         _mint(msg.sender, amount);
977     }
978 
979     function getPendingReward(uint tokenId, uint todayCount, uint wyvernTypeCode) internal view  returns (uint){
980         uint wyvernEarningsPerDay;
981         if (lastUpdate[tokenId] == 0) {
982             if (wyvernTypeCode == 1) {// 1 means Genesis
983                 wyvernEarningsPerDay = wyvernTypeToEarningsPerDay[wyvernTypeCode];
984                 uint daysPassedSinceNFTMinted = block.timestamp - deployedTime;
985                 daysPassedSinceNFTMinted = (daysPassedSinceNFTMinted / timeInSecsInADay);
986                 return (daysPassedSinceNFTMinted * wyvernEarningsPerDay * (10 ** _decimals));
987             } else if(wyvernTypeCode == 2){  // 2 means Ascension
988                 return 25 * (10 ** _decimals);
989             }else{
990                 return 0;
991             }
992         } else {
993             if (todayCount - lastUpdate[tokenId] >= 1) {
994                 uint daysElapsedSinceLastUpdate = todayCount - lastUpdate[tokenId];
995                 wyvernEarningsPerDay = wyvernTypeToEarningsPerDay[wyvernTypeCode];
996                 return daysElapsedSinceLastUpdate * (wyvernEarningsPerDay * (10 ** _decimals));
997             } else {
998                 return 0;
999             }
1000         }
1001     }
1002 }