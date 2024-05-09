1 // File: ../common.5/openzeppelin/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: ../common.5/openzeppelin/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: ../common.5/openzeppelin/GSN/Context.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: ../common.5/openzeppelin/token/ERC20/IERC20.sol
223 
224 pragma solidity ^0.5.0;
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
228  * the optional functions; to access them see {ERC20Detailed}.
229  */
230 interface IERC20 {
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `recipient`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `sender` to `recipient` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 // File: ../common.5/openzeppelin/token/ERC20/ERC20.sol
302 
303 pragma solidity ^0.5.0;
304 
305 
306 
307 
308 /**
309  * @dev Implementation of the {IERC20} interface.
310  *
311  * This implementation is agnostic to the way tokens are created. This means
312  * that a supply mechanism has to be added in a derived contract using {_mint}.
313  * For a generic mechanism see {ERC20Mintable}.
314  *
315  * TIP: For a detailed writeup see our guide
316  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
317  * to implement supply mechanisms].
318  *
319  * We have followed general OpenZeppelin guidelines: functions revert instead
320  * of returning `false` on failure. This behavior is nonetheless conventional
321  * and does not conflict with the expectations of ERC20 applications.
322  *
323  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
324  * This allows applications to reconstruct the allowance for all accounts just
325  * by listening to said events. Other implementations of the EIP may not emit
326  * these events, as it isn't required by the specification.
327  *
328  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
329  * functions have been added to mitigate the well-known issues around setting
330  * allowances. See {IERC20-approve}.
331  */
332 contract ERC20 is Context, IERC20 {
333     using SafeMath for uint256;
334 
335     mapping (address => uint256) private _balances;
336 
337     mapping (address => mapping (address => uint256)) private _allowances;
338 
339     uint256 private _totalSupply;
340 
341     /**
342      * @dev See {IERC20-totalSupply}.
343      */
344     function totalSupply() public view returns (uint256) {
345         return _totalSupply;
346     }
347 
348     /**
349      * @dev See {IERC20-balanceOf}.
350      */
351     function balanceOf(address account) public view returns (uint256) {
352         return _balances[account];
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `recipient` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address recipient, uint256 amount) public returns (bool) {
364         _transfer(_msgSender(), recipient, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender) public view returns (uint256) {
372         return _allowances[owner][spender];
373     }
374 
375     /**
376      * @dev See {IERC20-approve}.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function approve(address spender, uint256 amount) public returns (bool) {
383         _approve(_msgSender(), spender, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-transferFrom}.
389      *
390      * Emits an {Approval} event indicating the updated allowance. This is not
391      * required by the EIP. See the note at the beginning of {ERC20};
392      *
393      * Requirements:
394      * - `sender` and `recipient` cannot be the zero address.
395      * - `sender` must have a balance of at least `amount`.
396      * - the caller must have allowance for `sender`'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
400         _transfer(sender, recipient, amount);
401         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
438         return true;
439     }
440 
441     /**
442      * @dev Moves tokens `amount` from `sender` to `recipient`.
443      *
444      * This is internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(address sender, address recipient, uint256 amount) internal {
456         require(sender != address(0), "ERC20: transfer from the zero address");
457         require(recipient != address(0), "ERC20: transfer to the zero address");
458 
459         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
460         _balances[recipient] = _balances[recipient].add(amount);
461         emit Transfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements
470      *
471      * - `to` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _totalSupply = _totalSupply.add(amount);
477         _balances[account] = _balances[account].add(amount);
478         emit Transfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
496         _totalSupply = _totalSupply.sub(amount);
497         emit Transfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
502      *
503      * This is internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(address owner, address spender, uint256 amount) internal {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516 
517         _allowances[owner][spender] = amount;
518         emit Approval(owner, spender, amount);
519     }
520 
521     /**
522      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
523      * from the caller's allowance.
524      *
525      * See {_burn} and {_approve}.
526      */
527     function _burnFrom(address account, uint256 amount) internal {
528         _burn(account, amount);
529         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
530     }
531 }
532 
533 // File: ../common.5/openzeppelin/access/Roles.sol
534 
535 pragma solidity ^0.5.0;
536 
537 /**
538  * @title Roles
539  * @dev Library for managing addresses assigned to a Role.
540  */
541 library Roles {
542     struct Role {
543         mapping (address => bool) bearer;
544     }
545 
546     /**
547      * @dev Give an account access to this role.
548      */
549     function add(Role storage role, address account) internal {
550         require(!has(role, account), "Roles: account already has role");
551         role.bearer[account] = true;
552     }
553 
554     /**
555      * @dev Remove an account's access to this role.
556      */
557     function remove(Role storage role, address account) internal {
558         require(has(role, account), "Roles: account does not have role");
559         role.bearer[account] = false;
560     }
561 
562     /**
563      * @dev Check if an account has this role.
564      * @return bool
565      */
566     function has(Role storage role, address account) internal view returns (bool) {
567         require(account != address(0), "Roles: account is the zero address");
568         return role.bearer[account];
569     }
570 }
571 
572 // File: ../common.5/openzeppelin/access/roles/MinterRole.sol
573 
574 pragma solidity ^0.5.0;
575 
576 
577 
578 contract MinterRole is Context {
579     using Roles for Roles.Role;
580 
581     event MinterAdded(address indexed account);
582     event MinterRemoved(address indexed account);
583 
584     Roles.Role private _minters;
585 
586     constructor () internal {
587         _addMinter(_msgSender());
588     }
589 
590     modifier onlyMinter() {
591         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
592         _;
593     }
594 
595     function isMinter(address account) public view returns (bool) {
596         return _minters.has(account);
597     }
598 
599     function addMinter(address account) public onlyMinter {
600         _addMinter(account);
601     }
602 
603     function renounceMinter() public {
604         _removeMinter(_msgSender());
605     }
606 
607     function _addMinter(address account) internal {
608         _minters.add(account);
609         emit MinterAdded(account);
610     }
611 
612     function _removeMinter(address account) internal {
613         _minters.remove(account);
614         emit MinterRemoved(account);
615     }
616 }
617 
618 // File: ../common.5/openzeppelin/token/ERC20/ERC20Mintable.sol
619 
620 pragma solidity ^0.5.0;
621 
622 
623 
624 /**
625  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
626  * which have permission to mint (create) new tokens as they see fit.
627  *
628  * At construction, the deployer of the contract is the only minter.
629  */
630 contract ERC20Mintable is ERC20, MinterRole {
631     /**
632      * @dev See {ERC20-_mint}.
633      *
634      * Requirements:
635      *
636      * - the caller must have the {MinterRole}.
637      */
638     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
639         _mint(account, amount);
640         return true;
641     }
642 }
643 
644 // File: contracts/BucketSale.sol
645 
646 pragma solidity ^0.5.17;
647 
648 
649 
650 
651 contract IDecimals
652 {
653     function decimals()
654         public
655         view
656         returns (uint8);
657 }
658 
659 contract BucketSale
660 {
661     using SafeMath for uint256;
662 
663     string public termsAndConditions = "By interacting with this contract, I confirm I am not a US citizen. I agree to be bound by the terms found at https://foundrydao.com/sale/terms";
664 
665     // When passing around bonuses, we use 3 decimals of precision.
666     uint constant HUNDRED_PERC = 100000;
667     uint constant MAX_BONUS_PERC = 20000;
668     uint constant ONE_PERC = 1000;
669 
670     /*
671     Every pair of (uint bucketId, address buyer) identifies exactly one 'buy'.
672     This buy tracks how much tokenSoldFor the user has entered into the bucket,
673     and how much tokenOnSale the user has exited with.
674     */
675 
676     struct Buy
677     {
678         uint valueEntered;
679         uint buyerTokensExited;
680     }
681 
682     mapping (uint => mapping (address => Buy)) public buys;
683 
684     /*
685     Each Bucket tracks how much tokenSoldFor has been entered in total;
686     this is used to determine how much tokenOnSale the user can later exit with.
687     */
688 
689     struct Bucket
690     {
691         uint totalValueEntered;
692     }
693 
694     mapping (uint => Bucket) public buckets;
695 
696     // For each address, this tallies how much tokenSoldFor the address is responsible for referring.
697     mapping (address => uint) public referredTotal;
698 
699     address public treasury;
700     uint public startOfSale;
701     uint public bucketPeriod;
702     uint public bucketSupply;
703     uint public bucketCount;
704     uint public totalExitedTokens;
705     ERC20Mintable public tokenOnSale;       // we assume the bucket sale contract has minting rights for this contract
706     IERC20 public tokenSoldFor;
707 
708     constructor (
709             address _treasury,
710             uint _startOfSale,
711             uint _bucketPeriod,
712             uint _bucketSupply,
713             uint _bucketCount,
714             ERC20Mintable _tokenOnSale,    // FRY in our case
715             IERC20 _tokenSoldFor)    // typically DAI
716         public
717     {
718         require(_treasury != address(0), "treasury cannot be 0x0");
719         require(_bucketPeriod > 0, "bucket period cannot be 0");
720         require(_bucketSupply > 0, "bucket supply cannot be 0");
721         require(_bucketCount > 0, "bucket count cannot be 0");
722         require(address(_tokenOnSale) != address(0), "token on sale cannot be 0x0");
723         require(address(_tokenSoldFor) != address(0), "token sold for cannot be 0x0");
724 
725         treasury = _treasury;
726         startOfSale = _startOfSale;
727         bucketPeriod = _bucketPeriod;
728         bucketSupply = _bucketSupply;
729         bucketCount = _bucketCount;
730         tokenOnSale = _tokenOnSale;
731         tokenSoldFor = _tokenSoldFor;
732     }
733 
734     function currentBucket()
735         public
736         view
737         returns (uint)
738     {
739         return block.timestamp.sub(startOfSale).div(bucketPeriod);
740     }
741 
742     event Entered(
743         address _sender,
744         uint256 _bucketId,
745         address indexed _buyer,
746         uint _valueEntered,
747         uint _buyerReferralReward,
748         address indexed _referrer,
749         uint _referrerReferralReward);
750     function agreeToTermsAndConditionsListedInThisContractAndEnterSale(
751             address _buyer,
752             uint _bucketId,
753             uint _amount,
754             address _referrer)
755         public
756     {
757         require(_amount > 0, "no funds provided");
758 
759         bool transferSuccess = tokenSoldFor.transferFrom(msg.sender, treasury, _amount);
760         require(transferSuccess, "enter transfer failed");
761 
762         registerEnter(_bucketId, _buyer, _amount);
763         referredTotal[_referrer] = referredTotal[_referrer].add(_amount); // referredTotal[0x0] will track buys with no referral
764 
765         if (_referrer != address(0)) // If there is a referrer
766         {
767             uint buyerReferralReward = _amount.mul(buyerReferralRewardPerc()).div(HUNDRED_PERC);
768             uint referrerReferralReward = _amount.mul(referrerReferralRewardPerc(_referrer)).div(HUNDRED_PERC);
769 
770             // Both rewards are registered as buys in the next bucket
771             registerEnter(_bucketId.add(1), _buyer, buyerReferralReward);
772             registerEnter(_bucketId.add(1), _referrer, referrerReferralReward);
773 
774             emit Entered(
775                 msg.sender,
776                 _bucketId,
777                 _buyer,
778                 _amount,
779                 buyerReferralReward,
780                 _referrer,
781                 referrerReferralReward);
782         }
783         else
784         {
785             emit Entered(
786                 msg.sender,
787                 _bucketId,
788                 _buyer,
789                 _amount,
790                 0,
791                 address(0),
792                 0);
793         }
794     }
795 
796     function registerEnter(uint _bucketId, address _buyer, uint _amount)
797         internal
798     {
799         require(_bucketId >= currentBucket(), "cannot enter past buckets");
800         require(_bucketId < bucketCount, "invalid bucket id--past end of sale");
801 
802         Buy storage buy = buys[_bucketId][_buyer];
803         buy.valueEntered = buy.valueEntered.add(_amount);
804 
805         Bucket storage bucket = buckets[_bucketId];
806         bucket.totalValueEntered = bucket.totalValueEntered.add(_amount);
807     }
808 
809     event Exited(
810         uint256 _bucketId,
811         address indexed _buyer,
812         uint _tokensExited);
813     function exit(uint _bucketId, address _buyer)
814         public
815     {
816         require(
817             _bucketId < currentBucket(),
818             "can only exit from concluded buckets");
819 
820         Buy storage buyToWithdraw = buys[_bucketId][_buyer];
821         require(buyToWithdraw.valueEntered > 0, "can't exit if you didn't enter");
822         require(buyToWithdraw.buyerTokensExited == 0, "already exited");
823 
824         /*
825         Note that buyToWithdraw.buyerTokensExited serves a dual purpose:
826         First, it is always set to a non-zero value when a buy has been exited from,
827         and checked in the line above to guard against repeated exits.
828         Second, it's used as simple record-keeping for future analysis;
829         hence the use of uint rather than something like bool buyerTokensHaveExited.
830         */
831 
832         buyToWithdraw.buyerTokensExited = calculateExitableTokens(_bucketId, _buyer);
833         totalExitedTokens = totalExitedTokens.add(buyToWithdraw.buyerTokensExited);
834 
835         bool mintSuccess = tokenOnSale.mint(_buyer, buyToWithdraw.buyerTokensExited);
836         require(mintSuccess, "exit mint/transfer failed");
837 
838         emit Exited(
839             _bucketId,
840             _buyer,
841             buyToWithdraw.buyerTokensExited);
842     }
843 
844     function buyerReferralRewardPerc()
845         public
846         pure
847         returns(uint)
848     {
849         return ONE_PERC.mul(10);
850     }
851 
852     function referrerReferralRewardPerc(address _referrerAddress)
853         public
854         view
855         returns(uint)
856     {
857         if (_referrerAddress == address(0))
858         {
859             return 0;
860         }
861         else
862         {
863             // integer number of dai contributed
864             uint daiContributed = referredTotal[_referrerAddress].div(10 ** uint(IDecimals(address(tokenSoldFor)).decimals()));
865 
866             /*
867             A more explicit way to do the following 'uint multiplier' line would be something like:
868 
869             float bonusFromDaiContributed = daiContributed / 100000.0;
870             float multiplier = bonusFromDaiContributed + 0.1;
871 
872             However, because we are already using 3 digits of precision for bonus values,
873             the integer amount of Dai happens to exactly equal the bonusPercent value we want
874             (i.e. 10,000 Dai == 10000 == 10*ONE_PERC)
875 
876             So below, `multiplier = daiContributed + (10*ONE_PERC)`
877             increases the multiplier by 1% for every 1k Dai, which is what we want.
878             */
879             uint multiplier = daiContributed.add(ONE_PERC.mul(10)); // this guarentees every referrer gets at least 10% of what the buyer is buying
880 
881             uint result = Math.min(MAX_BONUS_PERC, multiplier); // Cap it at 20% bonus
882             return result;
883         }
884     }
885 
886     function calculateExitableTokens(uint _bucketId, address _buyer)
887         public
888         view
889         returns(uint)
890     {
891         Bucket storage bucket = buckets[_bucketId];
892         Buy storage buyToWithdraw = buys[_bucketId][_buyer];
893         return bucketSupply
894             .mul(buyToWithdraw.valueEntered)
895             .div(bucket.totalValueEntered);
896     }
897 }
898 
899 // File: contracts/Scripts.sol
900 
901 //
902 // Attention Auditor:
903 // We consider this contract outside of the audit scope, given that it
904 // interacts with the BucketSale contract as an external user and is
905 // fundamentally limited in the same ways.
906 //
907 
908 pragma solidity ^0.5.17;
909 
910 
911 contract Scripts {
912     using SafeMath for uint;
913 
914     function getExitInfo(BucketSale _bucketSale, address _buyer)
915         public
916         view
917         returns (uint[1201] memory)
918         // The structure here is that the first element contains the sum of exitable tokens and the rest are the indices of the
919         // buckets the buyer can exit from
920     {
921         // goal:
922         // 1. return the total FRY the buyer can extract
923         // 2. return the bucketIds of each bucket they can extract from
924 
925         // logic:
926         // *loop over all concluded buckets
927         //   *check the .buys for this _buyer
928         //   *if there is a buy
929         //      *add buy amount to the first array element
930         //      *append the bucketId to the array
931 
932         uint[1201] memory results; // some gas to allocate this memory * 1201
933         uint pointer = 0;
934 
935         // mutlipy the loop gas by at least _bucketSale.currentBucket()
936         for (uint bucketId = 0; bucketId < Math.min(_bucketSale.currentBucket(), _bucketSale.bucketCount()); bucketId = bucketId.add(1))
937         {
938             // mapping lookup cost
939             // does this differ for empty and non-empty values?
940             (uint valueEntered, uint buyerTokensExited) = _bucketSale.buys(bucketId, _buyer);
941 
942             if (valueEntered > 0 && buyerTokensExited == 0) {
943                 // some basic set of gas, all memory related.
944                 // is there any sort of optimization which may play a role here?
945 
946                 // update the running total for this buyer
947                 // this involves 2 mapping lookups again.
948                 results[0] = results[0]
949                     .add(_bucketSale.calculateExitableTokens(bucketId, _buyer));
950 
951                 // append the bucketId to the results array
952                 pointer = pointer.add(1);
953                 results[pointer] = bucketId;
954             }
955         }
956 
957         return results;
958     }
959 
960     function getGeneralInfo(BucketSale _bucketSale, address _buyer, uint _bucketId)
961         public
962         view
963         returns (
964             uint _totalExitedTokens,
965             uint _bucket_totalValueEntered,
966             uint _buy_valueEntered,
967             uint _buy_buyerTokensExited,
968             uint _tokenSoldForAllowance,
969             uint _tokenSoldForBalance,
970             uint _ethBalance,
971             uint _tokenOnSaleBalance,
972             uint[1201] memory _exitInfo)
973     {
974         _totalExitedTokens = _bucketSale.totalExitedTokens();
975         _bucket_totalValueEntered = _bucketSale.buckets(_bucketId);
976         (_buy_valueEntered, _buy_buyerTokensExited) = _bucketSale.buys(_bucketId, _buyer);
977         _tokenSoldForAllowance = _bucketSale.tokenSoldFor().allowance(_buyer, address(_bucketSale));
978         _tokenSoldForBalance = _bucketSale.tokenSoldFor().balanceOf(_buyer);
979         _ethBalance = _buyer.balance;
980         _tokenOnSaleBalance = _bucketSale.tokenOnSale().balanceOf(_buyer);
981         _exitInfo = getExitInfo(_bucketSale, _buyer);
982     }
983 
984     function exitMany(
985             BucketSale _bucketSale,
986             address _buyer,
987             uint[] memory bucketIds)
988         public
989     {
990         for (uint bucketIdIter = 0; bucketIdIter < bucketIds.length; bucketIdIter = bucketIdIter.add(1))
991         {
992             _bucketSale.exit(bucketIds[bucketIdIter], _buyer);
993         }
994     }
995 }