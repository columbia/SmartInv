1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-24
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-01
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-12-23
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2021-12-11
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.7;
20 
21 
22 // 
23 /**
24  * @dev Wrappers over Solidity's arithmetic operations with added overflow
25  * checks.
26  *
27  * Arithmetic operations in Solidity wrap on overflow. This can easily result
28  * in bugs, because programmers usually assume that an overflow raises an
29  * error, which is the standard behavior in high level programming languages.
30  * `SafeMath` restores this intuition by reverting the transaction when an
31  * operation overflows.
32  *
33  * Using this library instead of the unchecked operations eliminates an entire
34  * class of bugs, so it's recommended to use it always.
35  */
36 
37  
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      *
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, 'SafeMath: addition overflow');
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      *
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, 'SafeMath: subtraction overflow');
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      *
99      * - Multiplication cannot overflow.
100      */
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         uint256 c = a * b;
110         require(c / a == b, 'SafeMath: multiplication overflow');
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, 'SafeMath: division by zero');
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(
144         uint256 a,
145         uint256 b,
146         string memory errorMessage
147     ) internal pure returns (uint256) {
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, 'SafeMath: modulo by zero');
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function mod(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         require(b != 0, errorMessage);
189         return a % b;
190     }
191 
192     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
193         z = x < y ? x : y;
194     }
195 
196     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
197     function sqrt(uint256 y) internal pure returns (uint256 z) {
198         if (y > 3) {
199             z = y;
200             uint256 x = y / 2 + 1;
201             while (x < z) {
202                 z = x;
203                 x = (y / x + x) / 2;
204             }
205         } else if (y != 0) {
206             z = 1;
207         }
208     }
209 }
210 
211 // 
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      */
233     function isContract(address account) internal view returns (bool) {
234         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
235         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
236         // for accounts without code, i.e. `keccak256('')`
237         bytes32 codehash;
238         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
239         // solhint-disable-next-line no-inline-assembly
240         assembly {
241             codehash := extcodehash(account)
242         }
243         return (codehash != accountHash && codehash != 0x0);
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, 'Address: insufficient balance');
264 
265         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
266         (bool success, ) = recipient.call{value: amount}('');
267         require(success, 'Address: unable to send value, recipient may have reverted');
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain`call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionCall(target, data, 'Address: low-level call failed');
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         return _functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(address(this).balance >= value, 'Address: insufficient balance for call');
338         return _functionCallWithValue(target, data, value, errorMessage);
339     }
340 
341     function _functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 weiValue,
345         string memory errorMessage
346     ) private returns (bytes memory) {
347         require(isContract(target), 'Address: call to non-contract');
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
351         if (success) {
352             return returndata;
353         } else {
354             // Look for revert reason and bubble it up if present
355             if (returndata.length > 0) {
356                 // The easiest way to bubble the revert reason is using memory via assembly
357 
358                 // solhint-disable-next-line no-inline-assembly
359                 assembly {
360                     let returndata_size := mload(returndata)
361                     revert(add(32, returndata), returndata_size)
362                 }
363             } else {
364                 revert(errorMessage);
365             }
366         }
367     }
368 }
369 
370 // 
371 /*
372  * @dev Provides information about the current execution context, including the
373  * sender of the transaction and its data. While these are generally available
374  * via msg.sender and msg.data, they should not be accessed in such a direct
375  * manner, since when dealing with GSN meta-transactions the account sending and
376  * paying for execution may not be the actual sender (as far as an application
377  * is concerned).
378  *
379  * This contract is only required for intermediate, library-like contracts.
380  */
381 contract Context {
382     // Empty internal constructor, to prevent people from mistakenly deploying
383     // an instance of this contract, which should be used via inheritance.
384     constructor()  {}
385 
386     function _msgSender() internal view returns (address payable) {
387         return payable(msg.sender);
388     }
389 
390     function _msgData() internal view returns (bytes memory) {
391         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
392         return msg.data;
393     }
394 }
395 
396 // 
397 /**
398  * @dev Contract module which provides a basic access control mechanism, where
399  * there is an account (an owner) that can be granted exclusive access to
400  * specific functions.
401  *
402  * By default, the owner account will be the one that deploys the contract. This
403  * can later be changed with {transferOwnership}.
404  *
405  * This module is used through inheritance. It will make available the modifier
406  * `onlyOwner`, which can be applied to your functions to restrict their use to
407  * the owner.
408  */
409 contract Ownable is Context {
410     address private _owner;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor()  {
418         address msgSender = _msgSender();
419         _owner = msgSender;
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
435         _;
436     }
437 
438     /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public onlyOwner {
455         _transferOwnership(newOwner);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      */
461     function _transferOwnership(address newOwner) internal {
462         require(newOwner != address(0), 'Ownable: new owner is the zero address');
463         emit OwnershipTransferred(_owner, newOwner);
464         _owner = newOwner;
465     }
466 }
467 
468 interface IERC20 {
469 
470     function totalSupply() external view returns (uint256);
471 
472     /**
473      * @dev Returns the amount of tokens owned by `account`.
474      */
475     function balanceOf(address account) external view returns (uint256);
476 
477     /**
478      * @dev Moves `amount` tokens from the caller's account to `recipient`.
479      *
480      * Returns a boolean value indicating whether the operation succeeded.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transfer(address recipient, uint256 amount) external returns (bool);
485 
486     /**
487      * @dev Returns the remaining number of tokens that `spender` will be
488      * allowed to spend on behalf of `owner` through {transferFrom}. This is
489      * zero by default.
490      *
491      * This value changes when {approve} or {transferFrom} are called.
492      */
493     function allowance(address owner, address spender) external view returns (uint256);
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
497      *
498      * Returns a boolean value indicating whether the operation succeeded.
499      *
500      * IMPORTANT: Beware that changing an allowance with this method brings the risk
501      * that someone may use both the old and the new allowance by unfortunate
502      * transaction ordering. One possible solution to mitigate this race
503      * condition is to first reduce the spender's allowance to 0 and set the
504      * desired value afterwards:
505      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
506      *
507      * Emits an {Approval} event.
508      */
509     function approve(address spender, uint256 amount) external returns (bool);
510 
511     /**
512      * @dev Moves `amount` tokens from `sender` to `recipient` using the
513      * allowance mechanism. `amount` is then deducted from the caller's
514      * allowance.
515      *
516      * Returns a boolean value indicating whether the operation succeeded.
517      *
518      * Emits a {Transfer} event.
519      */
520     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
521 
522     /**
523      * @dev Emitted when `value` tokens are moved from one account (`from`) to
524      * another (`to`).
525      *
526      * Note that `value` may be zero.
527      */
528     event Transfer(address indexed from, address indexed to, uint256 value);
529 
530     /**
531      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
532      * a call to {approve}. `value` is the new allowance.
533      */
534     event Approval(address indexed owner, address indexed spender, uint256 value);
535 }
536 
537 interface IERC165 {
538     /**
539      * @dev Returns true if this contract implements the interface defined by
540      * `interfaceId`. See the corresponding
541      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
542      * to learn more about how these ids are created.
543      *
544      * This function call must use less than 30 000 gas.
545      */
546     function supportsInterface(bytes4 interfaceId) external view returns (bool);
547 }
548 
549 /**
550  * @dev Required interface of an ERC721 compliant contract.
551  */
552 interface IERC721 is IERC165 {
553     /**
554      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
560      */
561     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
565      */
566     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(address from, address to, uint256 tokenId) external;
597 
598     /**
599      * @dev Transfers `tokenId` token from `from` to `to`.
600      *
601      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(address from, address to, uint256 tokenId) external;
613 
614     /**
615      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
616      * The approval is cleared when the token is transferred.
617      *
618      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external;
628 
629     /**
630      * @dev Returns the account approved for `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function getApproved(uint256 tokenId) external view returns (address operator);
637 
638     /**
639      * @dev Approve or remove `operator` as an operator for the caller.
640      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
641      *
642      * Requirements:
643      *
644      * - The `operator` cannot be the caller.
645      *
646      * Emits an {ApprovalForAll} event.
647      */
648     function setApprovalForAll(address operator, bool _approved) external;
649 
650     /**
651      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
652      *
653      * See {setApprovalForAll}
654      */
655     function isApprovedForAll(address owner, address operator) external view returns (bool);
656 
657     /**
658       * @dev Safely transfers `tokenId` token from `from` to `to`.
659       *
660       * Requirements:
661       *
662       * - `from` cannot be the zero address.
663       * - `to` cannot be the zero address.
664       * - `tokenId` token must exist and be owned by `from`.
665       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667       *
668       * Emits a {Transfer} event.
669       */
670     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
671 }
672 
673 contract vVvNFTStakingContract is Ownable {
674     using SafeMath for uint256;
675 
676     address public nftAddress;
677     address public vVvS1RAddress;
678         
679     struct UserInfo {
680         uint256 tokenId;
681         uint startTime;
682         uint lockTime;
683     }
684 
685     mapping(address => UserInfo[]) public userInfo;
686     mapping(address => uint256) public stakingAmount;
687     mapping(uint256 => uint32) public nftRace;
688 
689     event Stake(address indexed user, uint256 amount);
690     event UnStake(address indexed user, uint256 amount);
691 
692     error tokenIsAlreadyStaked();
693     error stakeNotCalledByTokenOwner();
694     error tokenIsAlreadyUnstaked();
695     error lockTimeNotReached();
696     error stakingContractIsNotOwner();
697 
698     function onERC721Received(address, address, uint256, bytes calldata) pure external returns(bytes4) {
699         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
700     }
701     
702     function setNFTAddress(address _nftAddress) public onlyOwner {
703         nftAddress = _nftAddress;
704     }
705 
706     function setRewardAddress(address _vVvS1RAddress) public onlyOwner {
707         vVvS1RAddress = _vVvS1RAddress;
708     }
709 
710     function setSharkRaceByTokenIds(uint256[] memory _sharkTokenIds) external onlyOwner {
711         for(uint i = 0; i < _sharkTokenIds.length; i++) {
712             nftRace[_sharkTokenIds[i]] = 1;
713         }
714     }
715 
716     function setWhaleRaceByTokenIds(uint256[] memory _whaleTokenIds) external onlyOwner {
717         for(uint i = 0; i < _whaleTokenIds.length; i++) {
718             nftRace[_whaleTokenIds[i]] = 2;
719         }
720     }
721 
722     function setDolphinRaceByTokenIds(uint256[] memory _dolphinTokenIds) external onlyOwner {
723         for(uint i = 0; i < _dolphinTokenIds.length; i++) {
724             nftRace[_dolphinTokenIds[i]] = 0;
725         }
726     }
727 
728 
729 
730     constructor() {
731     }
732 
733 
734     function stake(uint256[] memory tokenIds, uint32[] memory _lockTime) external {
735         uint16 stakeCounter = 0;
736         for(uint256 i = 0; i < tokenIds.length; i++) {
737             (bool _isStaked,,) = getStakingItemInfo(msg.sender, tokenIds[i]);
738             if(_isStaked) { revert tokenIsAlreadyStaked(); }
739             if(IERC721(nftAddress).ownerOf(tokenIds[i]) != msg.sender) { revert stakeNotCalledByTokenOwner(); }
740             
741             IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenIds[i]);
742 
743             UserInfo memory info;
744             info.tokenId = tokenIds[i];
745             info.startTime = block.timestamp;
746             if(_lockTime[i] == 1) {
747                 info.lockTime = 26 weeks;
748             } else {
749                 info.lockTime = 52 weeks;
750             }
751 
752             IERC721(vVvS1RAddress).transferFrom(address(this), msg.sender, tokenIds[i]);
753             userInfo[msg.sender].push(info);
754             stakingAmount[msg.sender] = stakingAmount[msg.sender].add(1);
755             stakeCounter++;
756         }
757         emit Stake(msg.sender, stakeCounter);
758     }
759 
760     function unstake(uint256[] memory tokenIds) external {
761         uint16 unstakeCounter = 0;
762         for(uint256 i = 0; i < tokenIds.length; i++) {
763             (bool _isStaked, uint _startTime, uint _lockTime) = getStakingItemInfo(msg.sender, tokenIds[i]);
764             if(!_isStaked) { revert tokenIsAlreadyUnstaked(); }
765             if(block.timestamp <= (_startTime + _lockTime)) { revert lockTimeNotReached(); }
766             if(IERC721(nftAddress).ownerOf(tokenIds[i]) != address(this)) { revert stakingContractIsNotOwner(); }
767 
768             IERC721(vVvS1RAddress).transferFrom(msg.sender, address(this), tokenIds[i]);
769             removeFromUserInfo(tokenIds[i]);
770             stakingAmount[msg.sender] = stakingAmount[msg.sender].sub(1);
771             IERC721(nftAddress).transferFrom(address(this), msg.sender, tokenIds[i]);
772             unstakeCounter++;
773         }
774         emit UnStake(msg.sender, unstakeCounter);
775     }
776 
777     function getStakingItemInfo(address _user, uint256 _tokenId) public view returns(bool _isStaked, uint _startTime, uint _lockTime) {
778         for(uint256 i = 0; i < userInfo[_user].length; i++) {
779         UserInfo memory ui = userInfo[_user][i];
780             if(ui.tokenId == _tokenId) {
781                 _isStaked = true;
782                 _startTime = ui.startTime;
783                 _lockTime = ui.lockTime;
784                 break;
785             }
786         }
787     }
788 
789     function getAmountOfValidStaked(address _user) public view returns(uint256 dolphinStakingAmount, uint256 sharkStakingAmount, uint256 whaleStakingAmount){
790         uint32 race;
791         for(uint256 i = 0; i < userInfo[_user].length; i++) {
792             UserInfo memory ui = userInfo[_user][i];
793             race = nftRace[ui.tokenId];
794             if(race == 2){
795                 whaleStakingAmount++;
796             } else if(race == 1){
797                 sharkStakingAmount++;
798             } else {
799                 dolphinStakingAmount++;
800             }
801         }
802     }
803 
804     function getNFTRace(uint256 _tokenId) public view returns(uint32 race) {
805         return nftRace[_tokenId];
806     }
807 
808     function removeFromUserInfo(uint256 tokenId) private {        
809         for (uint256 i = 0; i < userInfo[msg.sender].length; i++) {
810             if (userInfo[msg.sender][i].tokenId == tokenId) {
811                 userInfo[msg.sender][i] = userInfo[msg.sender][userInfo[msg.sender].length.sub(1)];
812                 userInfo[msg.sender].pop();
813                 break;
814             }
815         }        
816     }
817 
818 }