1 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
32 
33 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
59 
60 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId) external view returns (address operator);
161 
162     /**
163      * @dev Approve or remove `operator` as an operator for the caller.
164      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
165      *
166      * Requirements:
167      *
168      * - The `operator` cannot be the caller.
169      *
170      * Emits an {ApprovalForAll} event.
171      */
172     function setApprovalForAll(address operator, bool _approved) external;
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191      *
192      * Emits a {Transfer} event.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId,
198         bytes calldata data
199     ) external;
200 }
201 
202 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
203 
204 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin\contracts\access\Ownable.sol
229 
230 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
306 
307 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 // CAUTION
312 // This version of SafeMath should only be used with Solidity 0.8 or later,
313 // because it relies on the compiler's built in overflow checks.
314 
315 /**
316  * @dev Wrappers over Solidity's arithmetic operations.
317  *
318  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
319  * now has built in overflow checking.
320  */
321 library SafeMath {
322     /**
323      * @dev Returns the addition of two unsigned integers, with an overflow flag.
324      *
325      * _Available since v3.4._
326      */
327     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
328         unchecked {
329             uint256 c = a + b;
330             if (c < a) return (false, 0);
331             return (true, c);
332         }
333     }
334 
335     /**
336      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         unchecked {
342             if (b > a) return (false, 0);
343             return (true, a - b);
344         }
345     }
346 
347     /**
348      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
349      *
350      * _Available since v3.4._
351      */
352     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
353         unchecked {
354             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355             // benefit is lost if 'b' is also tested.
356             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357             if (a == 0) return (true, 0);
358             uint256 c = a * b;
359             if (c / a != b) return (false, 0);
360             return (true, c);
361         }
362     }
363 
364     /**
365      * @dev Returns the division of two unsigned integers, with a division by zero flag.
366      *
367      * _Available since v3.4._
368      */
369     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         unchecked {
371             if (b == 0) return (false, 0);
372             return (true, a / b);
373         }
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
378      *
379      * _Available since v3.4._
380      */
381     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
382         unchecked {
383             if (b == 0) return (false, 0);
384             return (true, a % b);
385         }
386     }
387 
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
399         return a + b;
400     }
401 
402     /**
403      * @dev Returns the subtraction of two unsigned integers, reverting on
404      * overflow (when the result is negative).
405      *
406      * Counterpart to Solidity's `-` operator.
407      *
408      * Requirements:
409      *
410      * - Subtraction cannot overflow.
411      */
412     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a - b;
414     }
415 
416     /**
417      * @dev Returns the multiplication of two unsigned integers, reverting on
418      * overflow.
419      *
420      * Counterpart to Solidity's `*` operator.
421      *
422      * Requirements:
423      *
424      * - Multiplication cannot overflow.
425      */
426     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
427         return a * b;
428     }
429 
430     /**
431      * @dev Returns the integer division of two unsigned integers, reverting on
432      * division by zero. The result is rounded towards zero.
433      *
434      * Counterpart to Solidity's `/` operator.
435      *
436      * Requirements:
437      *
438      * - The divisor cannot be zero.
439      */
440     function div(uint256 a, uint256 b) internal pure returns (uint256) {
441         return a / b;
442     }
443 
444     /**
445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
446      * reverting when dividing by zero.
447      *
448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
449      * opcode (which leaves remaining gas untouched) while Solidity uses an
450      * invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      *
454      * - The divisor cannot be zero.
455      */
456     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
457         return a % b;
458     }
459 
460     /**
461      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
462      * overflow (when the result is negative).
463      *
464      * CAUTION: This function is deprecated because it requires allocating memory for the error
465      * message unnecessarily. For custom revert reasons use {trySub}.
466      *
467      * Counterpart to Solidity's `-` operator.
468      *
469      * Requirements:
470      *
471      * - Subtraction cannot overflow.
472      */
473     function sub(
474         uint256 a,
475         uint256 b,
476         string memory errorMessage
477     ) internal pure returns (uint256) {
478         unchecked {
479             require(b <= a, errorMessage);
480             return a - b;
481         }
482     }
483 
484     /**
485      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
486      * division by zero. The result is rounded towards zero.
487      *
488      * Counterpart to Solidity's `/` operator. Note: this function uses a
489      * `revert` opcode (which leaves remaining gas untouched) while Solidity
490      * uses an invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function div(
497         uint256 a,
498         uint256 b,
499         string memory errorMessage
500     ) internal pure returns (uint256) {
501         unchecked {
502             require(b > 0, errorMessage);
503             return a / b;
504         }
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * reverting with custom message when dividing by zero.
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {tryMod}.
513      *
514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
515      * opcode (which leaves remaining gas untouched) while Solidity uses an
516      * invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function mod(
523         uint256 a,
524         uint256 b,
525         string memory errorMessage
526     ) internal pure returns (uint256) {
527         unchecked {
528             require(b > 0, errorMessage);
529             return a % b;
530         }
531     }
532 }
533 
534 // File: contracts\lib\IMintableERC20.sol
535 
536 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Interface of the ERC20 standard as defined in the EIP.
542  */
543 interface IMintableERC20 {
544     function mint(address to, uint256 amount) external;
545     /**
546      * @dev Returns the amount of tokens in existence.
547      */
548     function totalSupply() external view returns (uint256);
549 
550     /**
551      * @dev Returns the amount of tokens owned by `account`.
552      */
553     function balanceOf(address account) external view returns (uint256);
554 
555     /**
556      * @dev Moves `amount` tokens from the caller's account to `recipient`.
557      *
558      * Returns a boolean value indicating whether the operation succeeded.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transfer(address recipient, uint256 amount) external returns (bool);
563 
564     /**
565      * @dev Returns the remaining number of tokens that `spender` will be
566      * allowed to spend on behalf of `owner` through {transferFrom}. This is
567      * zero by default.
568      *
569      * This value changes when {approve} or {transferFrom} are called.
570      */
571     function allowance(address owner, address spender) external view returns (uint256);
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
575      *
576      * Returns a boolean value indicating whether the operation succeeded.
577      *
578      * IMPORTANT: Beware that changing an allowance with this method brings the risk
579      * that someone may use both the old and the new allowance by unfortunate
580      * transaction ordering. One possible solution to mitigate this race
581      * condition is to first reduce the spender's allowance to 0 and set the
582      * desired value afterwards:
583      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address spender, uint256 amount) external returns (bool);
588 
589     /**
590      * @dev Moves `amount` tokens from `sender` to `recipient` using the
591      * allowance mechanism. `amount` is then deducted from the caller's
592      * allowance.
593      *
594      * Returns a boolean value indicating whether the operation succeeded.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transferFrom(
599         address sender,
600         address recipient,
601         uint256 amount
602     ) external returns (bool);
603 
604     /**
605      * @dev Emitted when `value` tokens are moved from one account (`from`) to
606      * another (`to`).
607      *
608      * Note that `value` may be zero.
609      */
610     event Transfer(address indexed from, address indexed to, uint256 value);
611 
612     /**
613      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
614      * a call to {approve}. `value` is the new allowance.
615      */
616     event Approval(address indexed owner, address indexed spender, uint256 value);
617 }
618 
619 // File: contracts\consoleStake.sol
620 
621 
622 pragma solidity ^0.8.0;
623 
624 
625 
626 
627 
628 
629 contract ConsoleStake is IERC721Receiver, Ownable {
630   using SafeMath for uint256;
631 
632   uint256 constant SECINDAY = 86400;
633   
634   IMintableERC20 public gameToken;
635   IERC721 public consoleToken;
636 
637   // struct to store a stake's token, owner, and earning values
638   struct Stake {
639     uint256 lastClaim;
640     address owner;
641   }
642 
643   // maps tokenId to stake
644   mapping(uint256 => Stake) public stakes; 
645 
646   event TokenStaked(address owner, uint256 tokenId);
647   event TokenUnStaked(address owner, uint256 tokenId);
648   event GameClaimed(uint256 tokenId, uint256 earned);
649   
650   constructor(IMintableERC20 _gameToken, IERC721 _consoleToken) { 
651     gameToken = _gameToken;
652     consoleToken = _consoleToken;
653   }
654 
655   function stakeConsoles(uint16[] calldata tokenIds) external {
656     for (uint i = 0; i < tokenIds.length; i++) {
657       require(consoleToken.ownerOf(tokenIds[i]) == _msgSender(), "not_token_owner");
658       consoleToken.transferFrom(_msgSender(), address(this), tokenIds[i]);
659       _stakeConsole(_msgSender(), tokenIds[i]);
660     }
661   }
662 
663   function unstakeConsoles(uint16[] calldata tokenIds) external {
664     for (uint i = 0; i < tokenIds.length; i++) { 
665       require(stakes[tokenIds[i]].owner == _msgSender(), "not_token_owner");
666       consoleToken.transferFrom(address(this), _msgSender(), tokenIds[i]);
667       _unstakeConsole(_msgSender(), tokenIds[i]);
668     }
669   }
670 
671   function claim(uint16[] calldata tokenIds) external {
672     uint256 amount = 0;
673     for (uint i = 0; i < tokenIds.length; i++) {
674       require(stakes[tokenIds[i]].owner == _msgSender(), "not_token_owner");
675       amount = amount.add(_claim(tokenIds[i]));
676     }
677 
678     // transfer Game token reward
679     if (amount > 0) {
680       gameToken.mint(msg.sender, amount * 10 ** 18);
681     }
682   }
683 
684   function onERC721Received(
685     address,
686     address from,
687     uint256,
688     bytes calldata
689   ) external pure override returns (bytes4) {
690     require(from == address(0x0), "Cannot send tokens to Barn directly");
691     return IERC721Receiver.onERC721Received.selector;
692   }
693 
694   function _stakeConsole(address account, uint256 tokenId) internal {
695     stakes[tokenId] = Stake({
696       lastClaim: block.timestamp,
697       owner: account
698     });
699     emit TokenStaked(account, tokenId);
700   }
701 
702   function _unstakeConsole(address account, uint256 tokenId) internal {
703     delete stakes[tokenId];
704     emit TokenUnStaked(account, tokenId);
705   }
706 
707   /**
708     update last claim time for stake, returns amount of Game token be rewarded
709    */
710   function _claim(uint16 tokenId) internal returns (uint256){
711     Stake storage stake = stakes[tokenId];
712     uint256 amount = block.timestamp.sub(stake.lastClaim).div(SECINDAY);
713     if (amount > 0) {
714       stake.lastClaim = stake.lastClaim.add(amount.mul(SECINDAY));
715       emit GameClaimed(tokenId, amount);
716     }
717     return amount;
718   }
719 }
720 
721 // File: contracts\ConsoleStakeV2.sol
722 
723 
724 pragma solidity ^0.8.0;
725 
726 
727 
728 
729 
730 
731 
732 contract ConsoleStakeV2 is Ownable {
733   using SafeMath for uint256;
734 
735   uint256 constant SECINDAY = 86400;
736   uint256 constant DECADE_PERIOD = 50; // IN DAYS
737   uint256 constant INIT_TIME = 1639584000; // GAME TOKEN DEPLOYMENT TIMESTAMP Wed Dec 15 2021 16:00:00 GMT+0000
738   uint256 constant LPREWARD_SEC = 0.003472 ether; // GAME EMISSION RATE FOR LP STAKING IN A SEC => 300 GAME PER DAY
739 
740   IMintableERC20 public gameToken;
741   ConsoleStake public oldStake;
742 
743   IMintableERC20 public LPToken; // game-eth or game-frax
744   uint256 public lastLPRewardTime;  // Last block timestamp that Games distribution occurs.
745   uint256 public accGAMEPerShare;   // Accumulated Games per share, times 1e12. See below.
746 
747   // struct to store a stake's token, owner, and earning values
748   struct Stake {
749     uint256 lastClaim;
750     address owner;
751   }
752 
753   struct UserInfo {
754     uint256 amount;         // How many LP tokens the user has provided.
755     uint256 rewardDebt;     // Reward debt.
756   }
757 
758   event DepositLP(address indexed user, uint256 amount);
759   event WithdrawLP(address indexed user, uint256 amount);
760   event EmergencyWithdrawLP(address indexed user, uint256 amount);
761 
762   // maps tokenId to stake
763   mapping(uint256 => Stake) public stakes; 
764   mapping(address => UserInfo) public userInfo;
765 
766   constructor(IMintableERC20 _gameToken, IMintableERC20 _lpToken, ConsoleStake _oldStake) { 
767     gameToken = _gameToken;
768     LPToken = _lpToken;
769     oldStake = _oldStake;
770   }
771 
772   // Return reward multiplier over the given _from to _to block.
773   function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
774     return _to.sub(_from);
775   }
776 
777   // View function to see pending AMCs on frontend.
778   function pendingGAME(address _user) external view returns (uint256) {
779     UserInfo storage user = userInfo[_user];
780     uint256 lpSupply = LPToken.balanceOf(address(this));
781     uint256 _accGAMEPerShare = accGAMEPerShare;
782     if (block.timestamp > lastLPRewardTime && lpSupply != 0) {
783         uint256 multiplier = getMultiplier(lastLPRewardTime, block.timestamp);
784         uint256 gameReward = multiplier.mul(emissionRateLPReward());
785         _accGAMEPerShare = _accGAMEPerShare.add(gameReward.mul(1e12).div(lpSupply));
786     }
787     return user.amount.mul(_accGAMEPerShare).div(1e12).sub(user.rewardDebt);
788   }
789 
790   // Update reward variables of the given pool to be up-to-date.
791   function updatePool() public {
792     if (block.timestamp <= lastLPRewardTime) {
793         return;
794     }
795     uint256 lpSupply = LPToken.balanceOf(address(this));
796     if (lpSupply == 0) {
797         lastLPRewardTime = block.timestamp;
798         return;
799     }
800     uint256 multiplier = getMultiplier(lastLPRewardTime, block.timestamp);
801     uint256 gameReward = multiplier.mul(emissionRateLPReward());
802     gameToken.mint(address(this), gameReward);
803     accGAMEPerShare = accGAMEPerShare.add(gameReward.mul(1e12).div(lpSupply));
804     lastLPRewardTime = block.timestamp;
805   }
806 
807   // Withdraw without caring about rewards. EMERGENCY ONLY.
808   function emergencyWithdraw() public  {
809     UserInfo storage user = userInfo[msg.sender];
810     uint256 amount = user.amount;
811     user.amount = 0;
812     user.rewardDebt = 0;
813     LPToken.transfer(address(msg.sender), amount);
814     emit EmergencyWithdrawLP(msg.sender, amount);
815   }
816 
817   function enterStaking(uint256 _amount) public {
818     UserInfo storage user = userInfo[msg.sender];
819     updatePool();
820     if (user.amount > 0) {
821         uint256 pending = user.amount.mul(accGAMEPerShare).div(1e12).sub(user.rewardDebt);
822         if(pending > 0) {
823             gameToken.transfer(msg.sender, pending);
824         }
825     }
826     if(_amount > 0) {
827         require(LPToken.transferFrom(address(msg.sender), address(this), _amount));
828         user.amount = user.amount.add(_amount);
829     }
830     user.rewardDebt = user.amount.mul(accGAMEPerShare).div(1e12);
831     emit DepositLP(msg.sender, _amount);
832   }
833 
834   function leaveStaking(uint256 _amount) public {
835     UserInfo storage user = userInfo[msg.sender];
836     require(user.amount >= _amount, "withdraw: not good");
837     updatePool();
838     uint256 pending = user.amount.mul(accGAMEPerShare).div(1e12).sub(user.rewardDebt);
839     if(pending > 0) {
840         gameToken.transfer(msg.sender, pending);
841     }
842     if(_amount > 0) {
843         user.amount = user.amount.sub(_amount);
844         LPToken.transfer(address(msg.sender), _amount);
845     }
846     user.rewardDebt = user.amount.mul(accGAMEPerShare).div(1e12);
847     emit WithdrawLP(msg.sender, _amount);
848   }
849 
850   function emissionRate() public view returns (uint256) {
851     uint256 periods = block.timestamp.sub(INIT_TIME).div(SECINDAY * DECADE_PERIOD);
852 
853     return (10 ** 18) / (2 ** periods) ;
854   }
855 
856   function emissionRateLPReward() public view returns (uint256) {
857     uint256 periods = block.timestamp.sub(INIT_TIME).div(SECINDAY * DECADE_PERIOD);
858 
859     return LPREWARD_SEC / (2 ** periods) ;
860   }
861 
862   function calcReward(uint256 _tokenId) public view returns (uint256, uint256) {
863     uint256 rate = emissionRate();
864     uint256 lastClaim;
865     address creator;
866     
867     (lastClaim, creator) = oldStake.stakes(_tokenId);
868     if (creator == address(0)) return (0, 0);
869     Stake storage stake = stakes[_tokenId];
870     if (stake.lastClaim > lastClaim) {
871       lastClaim = stake.lastClaim;
872     }
873 
874     uint256 slots = block.timestamp.sub(lastClaim).div(SECINDAY);
875     uint256 amount = slots.mul(rate);
876     return (amount, slots);
877   }
878 
879   function claim(uint16[] calldata tokenIds) external {
880     uint256 amount = 0;
881     for (uint i = 0; i < tokenIds.length; i++) {
882       amount = amount.add(_claim(tokenIds[i]));
883     }
884 
885     // transfer Game token reward
886     if (amount > 0) {
887       gameToken.mint(msg.sender, amount);
888     }
889   }
890 
891   /**
892     update last claim time for stake, returns amount of Game token be rewarded
893    */
894   function _claim(uint16 _tokenId) internal returns (uint256){
895     uint256 lastClaim;
896     address creator;
897     (lastClaim, creator) = oldStake.stakes(_tokenId);
898 
899     require(creator ==  _msgSender(), "not_stake_owner");
900     uint256 amount;
901     uint256 slots;
902     (amount, slots) = calcReward(_tokenId);
903 
904     // update stake stroage for next reward
905     Stake storage stake = stakes[_tokenId];
906     if (stake.lastClaim > lastClaim) {
907       stake.lastClaim = stake.lastClaim.add(slots.mul(SECINDAY));
908     } else  {
909       stake.lastClaim = lastClaim.add(slots.mul(SECINDAY));
910     }
911 
912     return amount;
913   }
914 }