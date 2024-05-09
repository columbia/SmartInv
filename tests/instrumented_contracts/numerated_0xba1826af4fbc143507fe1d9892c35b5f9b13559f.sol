1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the number of decimals used to get its user representation.
46      * For example, if `decimals` equals `2`, a balance of `505` tokens should
47      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
48      *
49      * Tokens usually opt for a value of 18, imitating the relationship between
50      * Ether and Wei. This is the value {ERC20} uses, unless this function is
51      * overridden;
52      *
53      * NOTE: This information is only used for _display_ purposes: it in
54      * no way affects any of the arithmetic of the contract, including
55      * {IERC20-balanceOf} and {IERC20-transfer}.
56      */
57     function decimals() external view returns (uint8);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from the caller's account to `recipient`.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transfer(address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 }
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 // CAUTION
184 // This version of SafeMath should only be used with Solidity 0.8 or later,
185 // because it relies on the compiler's built in overflow checks.
186 
187 /**
188  * @dev Wrappers over Solidity's arithmetic operations.
189  *
190  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
191  * now has built in overflow checking.
192  */
193 library SafeMath {
194     /**
195      * @dev Returns the addition of two unsigned integers, with an overflow flag.
196      *
197      * _Available since v3.4._
198      */
199     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         unchecked {
201             uint256 c = a + b;
202             if (c < a) return (false, 0);
203             return (true, c);
204         }
205     }
206 
207     /**
208      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
209      *
210      * _Available since v3.4._
211      */
212     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b > a) return (false, 0);
215             return (true, a - b);
216         }
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
227             // benefit is lost if 'b' is also tested.
228             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
229             if (a == 0) return (true, 0);
230             uint256 c = a * b;
231             if (c / a != b) return (false, 0);
232             return (true, c);
233         }
234     }
235 
236     /**
237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             if (b == 0) return (false, 0);
244             return (true, a / b);
245         }
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b == 0) return (false, 0);
256             return (true, a % b);
257         }
258     }
259 
260     /**
261      * @dev Returns the addition of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `+` operator.
265      *
266      * Requirements:
267      *
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a + b;
272     }
273 
274     /**
275      * @dev Returns the subtraction of two unsigned integers, reverting on
276      * overflow (when the result is negative).
277      *
278      * Counterpart to Solidity's `-` operator.
279      *
280      * Requirements:
281      *
282      * - Subtraction cannot overflow.
283      */
284     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a - b;
286     }
287 
288     /**
289      * @dev Returns the multiplication of two unsigned integers, reverting on
290      * overflow.
291      *
292      * Counterpart to Solidity's `*` operator.
293      *
294      * Requirements:
295      *
296      * - Multiplication cannot overflow.
297      */
298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a * b;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers, reverting on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator.
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a / b;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         return a % b;
330     }
331 
332     /**
333      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
334      * overflow (when the result is negative).
335      *
336      * CAUTION: This function is deprecated because it requires allocating memory for the error
337      * message unnecessarily. For custom revert reasons use {trySub}.
338      *
339      * Counterpart to Solidity's `-` operator.
340      *
341      * Requirements:
342      *
343      * - Subtraction cannot overflow.
344      */
345     function sub(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         unchecked {
351             require(b <= a, errorMessage);
352             return a - b;
353         }
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * Counterpart to Solidity's `/` operator. Note: this function uses a
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362      * uses an invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function div(
369         uint256 a,
370         uint256 b,
371         string memory errorMessage
372     ) internal pure returns (uint256) {
373         unchecked {
374             require(b > 0, errorMessage);
375             return a / b;
376         }
377     }
378 
379     /**
380      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
381      * reverting with custom message when dividing by zero.
382      *
383      * CAUTION: This function is deprecated because it requires allocating memory for the error
384      * message unnecessarily. For custom revert reasons use {tryMod}.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function mod(
395         uint256 a,
396         uint256 b,
397         string memory errorMessage
398     ) internal pure returns (uint256) {
399         unchecked {
400             require(b > 0, errorMessage);
401             return a % b;
402         }
403     }
404 }
405 
406 /**
407  * @dev Interface of the ERC165 standard, as defined in the
408  * https://eips.ethereum.org/EIPS/eip-165[EIP].
409  *
410  * Implementers can declare support of contract interfaces, which can then be
411  * queried by others ({ERC165Checker}).
412  *
413  * For an implementation, see {ERC165}.
414  */
415 interface IERC165 {
416     /**
417      * @dev Returns true if this contract implements the interface defined by
418      * `interfaceId`. See the corresponding
419      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
420      * to learn more about how these ids are created.
421      *
422      * This function call must use less than 30 000 gas.
423      */
424     function supportsInterface(bytes4 interfaceId) external view returns (bool);
425 }
426 
427 
428 /**
429  * @dev Implementation of the {IERC165} interface.
430  *
431  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
432  * for the additional interface id that will be supported. For example:
433  *
434  * ```solidity
435  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
437  * }
438  * ```
439  *
440  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
441  */
442 abstract contract ERC165 is IERC165 {
443     /**
444      * @dev See {IERC165-supportsInterface}.
445      */
446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447         return interfaceId == type(IERC165).interfaceId;
448     }
449 }
450 
451 
452 /**
453  * @dev Required interface of an ERC721 compliant contract.
454  */
455 interface IERC721 is IERC165 {
456     /**
457      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
458      */
459     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
463      */
464     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
468      */
469     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
470 
471     /**
472      * @dev Returns the number of tokens in ``owner``'s account.
473      */
474     function balanceOf(address owner) external view returns (uint256 balance);
475 
476     /**
477      * @dev Returns the owner of the `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function ownerOf(uint256 tokenId) external view returns (address owner);
484 
485     /**
486      * @dev Safely transfers `tokenId` token from `from` to `to`.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must exist and be owned by `from`.
493      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes calldata data
503     ) external;
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
507      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Transfers `tokenId` token from `from` to `to`.
527      *
528      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
536      *
537      * Emits a {Transfer} event.
538      */
539     function transferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
547      * The approval is cleared when the token is transferred.
548      *
549      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
550      *
551      * Requirements:
552      *
553      * - The caller must own the token or be an approved operator.
554      * - `tokenId` must exist.
555      *
556      * Emits an {Approval} event.
557      */
558     function approve(address to, uint256 tokenId) external;
559 
560     /**
561      * @dev Approve or remove `operator` as an operator for the caller.
562      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
563      *
564      * Requirements:
565      *
566      * - The `operator` cannot be the caller.
567      *
568      * Emits an {ApprovalForAll} event.
569      */
570     function setApprovalForAll(address operator, bool _approved) external;
571 
572     /**
573      * @dev Returns the account approved for `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function getApproved(uint256 tokenId) external view returns (address operator);
580 
581     /**
582      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
583      *
584      * See {setApprovalForAll}
585      */
586     function isApprovedForAll(address owner, address operator) external view returns (bool);
587 }
588 
589 
590 /**
591  * @title ERC721 token receiver interface
592  * @dev Interface for any contract that wants to support safeTransfers
593  * from ERC721 asset contracts.
594  */
595 interface IERC721Receiver {
596     /**
597      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
598      * by `operator` from `from`, this function is called.
599      *
600      * It must return its Solidity selector to confirm the token transfer.
601      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
602      *
603      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
604      */
605     function onERC721Received(
606         address operator,
607         address from,
608         uint256 tokenId,
609         bytes calldata data
610     ) external returns (bytes4);
611 }
612 
613 /**
614  * @dev Implementation of the {IERC721Receiver} interface.
615  *
616  * Accepts all token transfers.
617  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
618  */
619 contract ERC721Holder is IERC721Receiver {
620     /**
621      * @dev See {IERC721Receiver-onERC721Received}.
622      *
623      * Always returns `IERC721Receiver.onERC721Received.selector`.
624      */
625     function onERC721Received(
626         address,
627         address,
628         uint256,
629         bytes memory
630     ) public virtual override returns (bytes4) {
631         return this.onERC721Received.selector;
632     }
633 }
634 
635 pragma solidity ^0.8.13;
636 
637 contract TerraformStaking is Ownable {
638     using SafeMath for uint256;
639 
640     struct Bracket {
641         uint256 lockedDays;
642         uint256 APYRewards;
643         bool enabled;
644     }
645 
646     struct DepositInfo {
647         uint256 amount;
648         uint256 timestamp;
649     }
650  
651     struct TruthStake {
652         uint256 tokenId;
653         uint256 amount;
654         uint256 timestamp;
655     }
656 
657     struct Deposit {
658         DepositInfo info;
659         Bracket bracket;
660         TruthStake truth;
661         uint256 claimed;
662         bool active;
663         bool truthcircle;
664     }
665    
666 
667     uint256 private PRECISION_FACTOR = 10000;
668     IERC20 public depositToken;
669     IERC20 public rewardsToken;
670     IERC721 public truthToken;
671     bool public terraFormInitiated = false;
672 
673     address[] public depositAddresses;
674     uint256[] public stakedTokenIds;
675     mapping (uint256 => Bracket) public brackets;
676     mapping (address => Deposit) public deposits;
677 
678     event UserDeposit(address wallet, uint256 amount);
679     event RewardsWithdraw(address wallet, uint256 rewardsAmount);
680     event FullWithdraw(address wallet, uint256 depositAmount, uint256 rewardsAmount, uint256 tokenId);
681     event ExtendLock(address wallet, uint256 duration);
682     event UserTruthStake(address wallet, uint256 tokenId);
683 
684     function calculateRewards(address wallet) public view returns (uint256) {
685         uint256 rewards = 0;
686         Deposit memory userDeposit = deposits[wallet];
687         if (userDeposit.active) {
688             uint256 depositSeconds = block.timestamp.sub(userDeposit.info.timestamp);
689             uint256 APYRate = userDeposit.bracket.APYRewards;
690             if (userDeposit.truthcircle) {
691                 APYRate = APYRate + APYRate.div(100).mul(5);   
692                 uint256 baseSeconds = userDeposit.truth.timestamp.sub(userDeposit.info.timestamp);
693                 uint256 truthSeconds = block.timestamp.sub(userDeposit.truth.timestamp);
694                 uint256 grossrewards = userDeposit.info.amount.mul(userDeposit.bracket.APYRewards).mul(baseSeconds) + userDeposit.info.amount.mul(APYRate).mul(truthSeconds);
695                 rewards = grossrewards.div(365).div(86400).div(PRECISION_FACTOR);
696             }
697             else {
698                 //figure out total tokens to earn
699                 uint256 calcdrewards = userDeposit.info.amount.mul(APYRate).mul(depositSeconds);
700                 //break rewards down to rewards per second
701                 rewards = calcdrewards.div(365).div(86400).div(PRECISION_FACTOR);
702             }
703         }
704         return rewards.sub(userDeposit.claimed);
705     }
706 
707     function deposit(uint256 tokenAmount, uint256 bracket) external {
708         require(!deposits[_msgSender()].active, "user has already deposited");
709         require(brackets[bracket].enabled, "bracket is not enabled");
710         require(terraFormInitiated, "Terraform Staking Not Live");
711 
712         // transfer tokens
713         uint256 previousBalance = depositToken.balanceOf(address(this));
714         depositToken.transferFrom(_msgSender(), address(this), tokenAmount);
715         uint256 deposited = depositToken.balanceOf(address(this)).sub(previousBalance);
716 
717         // deposit logic
718         DepositInfo memory info = DepositInfo(deposited, block.timestamp);
719         TruthStake memory truth = TruthStake(0,0,0);
720         deposits[_msgSender()] = Deposit(info, brackets[bracket], truth, 0, true, false);
721         depositAddresses.push(_msgSender());
722         emit UserDeposit(_msgSender(), deposited);
723     }
724 
725     function updateDeposit(address _wallet, uint256 _bracket, uint256 _lockedDays, uint256 _APYRewards) external onlyOwner {
726         require(deposits[_wallet].active, "user has no active deposits");
727         require(brackets[_bracket].enabled, "bracket is not enabled");
728         deposits[_wallet].bracket.lockedDays = _lockedDays;
729         deposits[_wallet].bracket.APYRewards = _APYRewards.mul(PRECISION_FACTOR);
730     }
731 
732     function currentTimstamp() external view returns (uint256) {
733         return block.timestamp;
734     }
735 
736     function checkCalculations(address wallet) external view returns (uint256,uint256,uint256,uint256,uint256,uint256,uint256) {
737         uint256 earnedrewards = 0;
738         uint256 grossrewards;
739         uint256 toclaim;
740         uint256 unlocktime;
741         uint256 locked;
742         Deposit memory userDeposit = deposits[wallet];
743         uint256 depositSeconds = block.timestamp.sub(userDeposit.info.timestamp);
744 
745         uint256 APYRate = userDeposit.bracket.APYRewards;
746         if (userDeposit.truthcircle) {
747             APYRate = APYRate + APYRate.div(100).mul(5);
748             uint256 baseSeconds = userDeposit.truth.timestamp.sub(userDeposit.info.timestamp);
749             uint256 truthSeconds = block.timestamp.sub(userDeposit.truth.timestamp);
750             grossrewards = userDeposit.info.amount.mul(userDeposit.bracket.APYRewards).mul(baseSeconds) + userDeposit.info.amount.mul(APYRate).mul(truthSeconds);
751             earnedrewards = grossrewards.div(365).div(86400).div(PRECISION_FACTOR);
752             toclaim = earnedrewards.sub(userDeposit.claimed);
753             unlocktime = userDeposit.info.timestamp + userDeposit.bracket.lockedDays * 1 days;
754             locked = userDeposit.info.timestamp;
755         }
756         else {
757             //figure out total tokens to earn
758             grossrewards = userDeposit.info.amount.mul(APYRate).mul(depositSeconds);
759             //break rewards down to rewards per second
760             earnedrewards = grossrewards.div(365).div(86400).div(PRECISION_FACTOR);
761             toclaim = earnedrewards.sub(userDeposit.claimed);
762             unlocktime = userDeposit.info.timestamp + userDeposit.bracket.lockedDays * 1 days;
763             locked = userDeposit.info.timestamp;
764         }
765         return (depositSeconds,APYRate,grossrewards,earnedrewards,toclaim,locked,unlocktime);
766     }
767 
768     function claimRewards() external {
769         Deposit memory userDeposit = deposits[_msgSender()];
770         require(userDeposit.active, "user has no active deposits");
771         uint256 rewardsAmount = calculateRewards(_msgSender());
772         require (rewardsToken.balanceOf(address(this)) >= rewardsAmount, "insufficient rewards balance");
773         deposits[_msgSender()].claimed += rewardsAmount;
774         rewardsToken.transfer(_msgSender(), rewardsAmount);
775         emit RewardsWithdraw(_msgSender(), rewardsAmount);
776     }
777 
778     function stakeTruth(uint256 _tokenId) external {
779         Deposit memory userDeposit = deposits[_msgSender()];
780         require(userDeposit.active, "user has no active deposits");
781         require(userDeposit.truth.amount == 0, "user has already staked their Truth");
782         // transfer NFT
783         truthToken.safeTransferFrom(_msgSender(), address(this), _tokenId);
784         deposits[_msgSender()].truth.tokenId = _tokenId;
785         deposits[_msgSender()].truth.amount = 1;
786         deposits[_msgSender()].truth.timestamp = block.timestamp;
787         deposits[_msgSender()].truthcircle = true;
788         stakedTokenIds.push(_tokenId);
789         emit UserTruthStake(_msgSender(), _tokenId);
790     }
791 
792     function extendStake(uint256 _bracket) external {
793         Deposit memory userDeposit = deposits[_msgSender()];
794         require(userDeposit.active, "user has no active deposits");
795         require(brackets[_bracket].enabled, "bracket is not enabled");
796 
797         uint256 oldDuration = userDeposit.info.timestamp + userDeposit.bracket.lockedDays * 1 days;
798         uint256 newDuration = block.timestamp + brackets[_bracket].lockedDays * 1 days;
799 
800         require(newDuration > oldDuration, "cannot reduce lock duration, ur trying to lock for a shorter time");
801 
802         uint256 rewardsAmount = calculateRewards(_msgSender());
803         require (rewardsToken.balanceOf(address(this)) >= rewardsAmount, "insufficient rewards balance");
804         deposits[_msgSender()].claimed = rewardsAmount;
805         rewardsToken.transfer(_msgSender(), rewardsAmount);
806 
807         deposits[_msgSender()].bracket.lockedDays = brackets[_bracket].lockedDays;
808         deposits[_msgSender()].bracket.APYRewards = brackets[_bracket].APYRewards;
809         deposits[_msgSender()].info.timestamp = block.timestamp;
810         deposits[_msgSender()].truth.timestamp = block.timestamp;
811         deposits[_msgSender()].claimed = 0;
812         emit ExtendLock(_msgSender(),newDuration);
813 
814     }
815 
816     function withdraw() external {
817         Deposit memory userDeposit = deposits[_msgSender()];
818         require(userDeposit.active, "user has no active deposits");
819         require(block.timestamp >= userDeposit.info.timestamp + userDeposit.bracket.lockedDays * 1 days, "Can't withdraw yet");
820         uint256 depositedAmount = userDeposit.info.amount;
821         uint256 rewardsAmount = calculateRewards(_msgSender());
822         uint256 tokenId = 0;
823         require (rewardsToken.balanceOf(address(this)) >= rewardsAmount, "insufficient rewards balance");
824 
825         deposits[_msgSender()].info.amount = 0;
826         deposits[_msgSender()].claimed = 0;
827         deposits[_msgSender()].active = false;
828         rewardsToken.transfer(_msgSender(), rewardsAmount);
829         depositToken.transfer(_msgSender(), depositedAmount);
830         if (deposits[_msgSender()].truthcircle) {
831             tokenId = deposits[_msgSender()].truth.tokenId;
832             truthToken.safeTransferFrom(address(this), _msgSender(), deposits[_msgSender()].truth.tokenId);
833             deposits[_msgSender()].truth.tokenId = 0;
834             deposits[_msgSender()].truthcircle = false;
835             deposits[_msgSender()].truth.amount = 0;
836             for (uint i=0;i<stakedTokenIds.length;i++) {
837                 if (stakedTokenIds[i] == deposits[_msgSender()].truth.tokenId) {
838                     delete stakedTokenIds[i];
839                 }
840             }
841         }
842 
843         emit FullWithdraw(_msgSender(), depositedAmount, rewardsAmount, tokenId);
844     }
845 
846     function addBracket(uint256 id, uint256 lockedDays, uint256 APYRewards) external onlyOwner {
847         // add rewards number based an an APY (ie 4000 is 4000% APY)
848         APYRewards = APYRewards.mul(PRECISION_FACTOR).div(100);
849         //later on in the code, we'll flip to rewards per second)
850         brackets[id] = Bracket(lockedDays, APYRewards, true);
851     }
852 
853     function addMultipleBrackets(uint256[] memory id, uint256[] memory lockedDays, uint256[] memory APYRewards) external onlyOwner {
854         uint256 i = 0;
855         require(id.length == lockedDays.length, "must be same length");
856         require(APYRewards.length == id.length, "must be same length");
857         while (i < id.length) {
858             uint256 _APYRewards = APYRewards[i].mul(PRECISION_FACTOR).div(100);
859             brackets[id[i]] = Bracket(lockedDays[i], _APYRewards, true);
860             i +=1;
861         }
862     }
863 
864     function setTokens(address depositAddress, address rewardsAddress, address truthAddress) external onlyOwner {
865         depositToken = IERC20(depositAddress);
866         truthToken = IERC721(truthAddress);
867         rewardsToken = IERC20(rewardsAddress);
868     }
869 
870     function beginTerraform(bool _terraformInitiated) external onlyOwner {
871         terraFormInitiated = _terraformInitiated;
872         
873     }
874 
875     function rescueTokens() external onlyOwner {
876         if (rewardsToken.balanceOf(address(this)) > 0) {
877             rewardsToken.transfer(_msgSender(), rewardsToken.balanceOf(address(this)));
878         }
879 
880         if (depositToken.balanceOf(address(this)) > 0) {
881             depositToken.transfer(_msgSender(), depositToken.balanceOf(address(this)));
882         }
883         for (uint i=0;i<stakedTokenIds.length;i++) {
884             if (stakedTokenIds[i] != 0) {
885                 truthToken.safeTransferFrom(address(this), _msgSender(), stakedTokenIds[i]);
886             }
887         }
888         delete stakedTokenIds;
889     }
890 
891      function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
892         return this.onERC721Received.selector;
893     }
894 }