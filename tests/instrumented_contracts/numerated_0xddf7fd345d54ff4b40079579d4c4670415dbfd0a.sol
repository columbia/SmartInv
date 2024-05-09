1 pragma solidity 0.5.17;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see {ERC20Detailed}.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      *
144      * _Available since v2.4.0._
145      */
146     function sub(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      * - The divisor cannot be zero.
205      *
206      * _Available since v2.4.0._
207      */
208     function div(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         // Solidity only automatically asserts when dividing by 0
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      * - The divisor cannot be zero.
246      *
247      * _Available since v2.4.0._
248      */
249     function mod(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20Mintable}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is IERC20 {
284     using SafeMath for uint256;
285 
286     mapping(address => uint256) private _balances;
287 
288     mapping(address => mapping(address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     /**
293      * @dev See {IERC20-totalSupply}.
294      */
295     function totalSupply() public view returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See {IERC20-balanceOf}.
301      */
302     function balanceOf(address account) public view returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See {IERC20-transfer}.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public returns (bool) {
315         _transfer(msg.sender, recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender)
323         public
324         view
325         returns (uint256)
326     {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public returns (bool) {
338         _approve(msg.sender, spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20};
347      *
348      * Requirements:
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for `sender`'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) public returns (bool) {
359         _transfer(sender, recipient, amount);
360         _approve(
361             sender,
362             msg.sender,
363             _allowances[sender][msg.sender].sub(
364                 amount,
365                 "ERC20: transfer amount exceeds allowance"
366             )
367         );
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue)
384         public
385         returns (bool)
386     {
387         _approve(
388             msg.sender,
389             spender,
390             _allowances[msg.sender][spender].add(addedValue)
391         );
392         return true;
393     }
394 
395     /**
396      * @dev Atomically decreases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      * - `spender` must have allowance for the caller of at least
407      * `subtractedValue`.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue)
410         public
411         returns (bool)
412     {
413         _approve(
414             msg.sender,
415             spender,
416             _allowances[msg.sender][spender].sub(
417                 subtractedValue,
418                 "ERC20: decreased allowance below zero"
419             )
420         );
421         return true;
422     }
423 
424     /**
425      * @dev Moves tokens `amount` from `sender` to `recipient`.
426      *
427      * This is internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address sender,
440         address recipient,
441         uint256 amount
442     ) internal {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _balances[sender] = _balances[sender].sub(
447             amount,
448             "ERC20: transfer amount exceeds balance"
449         );
450         _balances[recipient] = _balances[recipient].add(amount);
451         emit Transfer(sender, recipient, amount);
452     }
453 
454     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
455      * the total supply.
456      *
457      * Emits a {Transfer} event with `from` set to the zero address.
458      *
459      * Requirements
460      *
461      * - `to` cannot be the zero address.
462      */
463     function _mint(address account, uint256 amount) internal {
464         require(account != address(0), "ERC20: mint to the zero address");
465 
466         _totalSupply = _totalSupply.add(amount);
467         _balances[account] = _balances[account].add(amount);
468         emit Transfer(address(0), account, amount);
469     }
470 
471     /**
472      * @dev Destroys `amount` tokens from `account`, reducing the
473      * total supply.
474      *
475      * Emits a {Transfer} event with `to` set to the zero address.
476      *
477      * Requirements
478      *
479      * - `account` cannot be the zero address.
480      * - `account` must have at least `amount` tokens.
481      */
482     function _burn(address account, uint256 amount) internal {
483         require(account != address(0), "ERC20: burn from the zero address");
484 
485         _balances[account] = _balances[account].sub(
486             amount,
487             "ERC20: burn amount exceeds balance"
488         );
489         _totalSupply = _totalSupply.sub(amount);
490         emit Transfer(account, address(0), amount);
491     }
492 
493     /**
494      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
495      *
496      * This is internal function is equivalent to `approve`, and can be used to
497      * e.g. set automatic allowances for certain subsystems, etc.
498      *
499      * Emits an {Approval} event.
500      *
501      * Requirements:
502      *
503      * - `owner` cannot be the zero address.
504      * - `spender` cannot be the zero address.
505      */
506     function _approve(
507         address owner,
508         address spender,
509         uint256 amount
510     ) internal {
511         require(owner != address(0), "ERC20: approve from the zero address");
512         require(spender != address(0), "ERC20: approve to the zero address");
513 
514         _allowances[owner][spender] = amount;
515         emit Approval(owner, spender, amount);
516     }
517 
518     /**
519      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
520      * from the caller's allowance.
521      *
522      * See {_burn} and {_approve}.
523      */
524     function _burnFrom(address account, uint256 amount) internal {
525         _burn(account, amount);
526         _approve(
527             account,
528             msg.sender,
529             _allowances[account][msg.sender].sub(
530                 amount,
531                 "ERC20: burn amount exceeds allowance"
532             )
533         );
534     }
535 }
536 
537 /**
538  * @dev Contract module which provides a basic access control mechanism, where
539  * there is an account (an owner) that can be granted exclusive access to
540  * specific functions.
541  *
542  * This module is used through inheritance. It will make available the modifier
543  * `onlyOwner`, which can be applied to your functions to restrict their use to
544  * the owner.
545  */
546 contract Ownable {
547     address private _owner;
548 
549     event OwnershipTransferred(
550         address indexed previousOwner,
551         address indexed newOwner
552     );
553 
554     /**
555      * @dev Initializes the contract setting the deployer as the initial owner.
556      */
557     constructor() internal {
558         _owner = msg.sender;
559         emit OwnershipTransferred(address(0), _owner);
560     }
561 
562     /**
563      * @dev Returns the address of the current owner.
564      */
565     function owner() public view returns (address) {
566         return _owner;
567     }
568 
569     /**
570      * @dev Throws if called by any account other than the owner.
571      */
572     modifier onlyOwner() {
573         require(isOwner(), "Ownable: caller is not the owner");
574         _;
575     }
576 
577     /**
578      * @dev Returns true if the caller is the current owner.
579      */
580     function isOwner() public view returns (bool) {
581         return msg.sender == _owner;
582     }
583 
584     /**
585      * @dev Leaves the contract without owner. It will not be possible to call
586      * `onlyOwner` functions anymore. Can only be called by the current owner.
587      *
588      * NOTE: Renouncing ownership will leave the contract without an owner,
589      * thereby removing any functionality that is only available to the owner.
590      */
591     function renounceOwnership() public onlyOwner {
592         emit OwnershipTransferred(_owner, address(0));
593         _owner = address(0);
594     }
595 
596     /**
597      * @dev Transfers ownership of the contract to a new account (`newOwner`).
598      * Can only be called by the current owner.
599      */
600     function transferOwnership(address newOwner) public onlyOwner {
601         _transferOwnership(newOwner);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      */
607     function _transferOwnership(address newOwner) internal {
608         require(
609             newOwner != address(0),
610             "Ownable: new owner is the zero address"
611         );
612         emit OwnershipTransferred(_owner, newOwner);
613         _owner = newOwner;
614     }
615 }
616 
617 /**
618  * @dev Contract module which allows children to implement an emergency stop
619  * mechanism that can be triggered by an authorized account.
620  *
621  * This module is used through inheritance. It will make available the
622  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
623  * the functions of your contract. Note that they will not be pausable by
624  * simply including this module, only once the modifiers are put in place.
625  */
626 contract Pausable is Ownable {
627     /**
628      * @dev Emitted when the pause is triggered by a pauser (`account`).
629      */
630     event Paused(address account);
631 
632     /**
633      * @dev Emitted when the pause is lifted by a pauser (`account`).
634      */
635     event Unpaused(address account);
636 
637     bool private _paused;
638 
639     /**
640      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
641      * to the deployer.
642      */
643     constructor() internal {
644         _paused = false;
645     }
646 
647     /**
648      * @dev Returns true if the contract is paused, and false otherwise.
649      */
650     function paused() public view returns (bool) {
651         return _paused;
652     }
653 
654     /**
655      * @dev Modifier to make a function callable only when the contract is not paused.
656      */
657     modifier whenNotPaused() {
658         require(!_paused, "Pausable: paused");
659         _;
660     }
661 
662     /**
663      * @dev Modifier to make a function callable only when the contract is paused.
664      */
665     modifier whenPaused() {
666         require(_paused, "Pausable: not paused");
667         _;
668     }
669 
670     /**
671      * @dev Called by a pauser to pause, triggers stopped state.
672      */
673     function pause() public onlyOwner whenNotPaused {
674         _paused = true;
675         emit Paused(msg.sender);
676     }
677 
678     /**
679      * @dev Called by a pauser to unpause, returns to normal state.
680      */
681     function unpause() public onlyOwner whenPaused {
682         _paused = false;
683         emit Unpaused(msg.sender);
684     }
685 }
686 
687 /**
688  * @title Pausable token
689  * @dev ERC20 with pausable transfers and allowances.
690  *
691  * Useful if you want to stop trades until the end of a crowdsale, or have
692  * an emergency switch for freezing all token transfers in the event of a large
693  * bug.
694  */
695 contract ERC20Pausable is ERC20, Pausable {
696     function transfer(address to, uint256 value)
697         public
698         whenNotPaused
699         returns (bool)
700     {
701         return super.transfer(to, value);
702     }
703 
704     function transferFrom(
705         address from,
706         address to,
707         uint256 value
708     ) public whenNotPaused returns (bool) {
709         return super.transferFrom(from, to, value);
710     }
711 
712     function approve(address spender, uint256 value)
713         public
714         whenNotPaused
715         returns (bool)
716     {
717         return super.approve(spender, value);
718     }
719 
720     function increaseAllowance(address spender, uint256 addedValue)
721         public
722         whenNotPaused
723         returns (bool)
724     {
725         return super.increaseAllowance(spender, addedValue);
726     }
727 
728     function decreaseAllowance(address spender, uint256 subtractedValue)
729         public
730         whenNotPaused
731         returns (bool)
732     {
733         return super.decreaseAllowance(spender, subtractedValue);
734     }
735 }
736 
737 /**
738  * @dev Extension of {ERC20} that allows token holders to destroy both their own
739  * tokens and those that they have an allowance for, in a way that can be
740  * recognized off-chain (via event analysis).
741  */
742 contract ERC20Burnable is ERC20 {
743     /**
744      * @dev Destroys `amount` tokens from the caller.
745      *
746      * See {ERC20-_burn}.
747      */
748     function burn(uint256 amount) public {
749         _burn(msg.sender, amount);
750     }
751 
752     /**
753      * @dev See {ERC20-_burnFrom}.
754      */
755     function burnFrom(address account, uint256 amount) public {
756         _burnFrom(account, amount);
757     }
758 }
759 
760 /**
761  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
762  * which have permission to mint (create) new tokens as they see fit.
763  *
764  * At construction, the deployer of the contract is the only minter.
765  */
766 contract ERC20Mintable is ERC20, Ownable {
767     /**
768      * @dev See {ERC20-_mint}.
769      *
770      * Requirements:
771      *
772      * - the caller must have the {MinterRole}.
773      */
774     function mint(address account, uint256 amount)
775         public
776         onlyOwner
777         returns (bool)
778     {
779         _mint(account, amount);
780         return true;
781     }
782 }
783 
784 /**
785  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
786  */
787 contract ERC20Capped is ERC20Mintable {
788     uint256 private _cap;
789     uint256 private _capUsed;
790 
791     uint256 private _airdropCap;
792     uint256 private _airdropCapUsed;
793 
794     /**
795      * @dev Sets the value of the `cap`. This value is immutable, it can only be
796      * set once during construction.
797      */
798     constructor(uint256 cap, uint256 airdropCap) public {
799         require(cap != 0, "ERC20Capped: cap is 0");
800         require(airdropCap != 0, "ERC20Capped: airdrop cap is 0");
801         _cap = cap;
802         _airdropCap = airdropCap;
803     }
804 
805     /**
806      * @dev Returns the normal cap.
807      */
808     function cap() public view returns (uint256) {
809         return _cap;
810     }
811 
812     /**
813      * @dev Returns the airdrop cap.
814      */
815     function airdropCap() public view returns (uint256) {
816         return _airdropCap;
817     }
818 
819     /**
820      * @dev Returns the normal cap used.
821      */
822     function capUsed() public view returns (uint256) {
823         return _capUsed;
824     }
825 
826     /**
827      * @dev Returns the airdrop cap used.
828      */
829     function airdropCapUsed() public view returns (uint256) {
830         return _airdropCapUsed;
831     }
832 
833     /**
834      * @dev See {ERC20Mintable-mint}.
835      *
836      * Requirements:
837      *
838      * - `value` must not cause the cap used to go over the cap.
839      */
840     function _mint(address account, uint256 value) internal {
841         uint256 newCapUsed = _capUsed.add(value);
842         require(newCapUsed <= _cap, "ERC20Capped: cap exceeded");
843         super._mint(account, value);
844         _capUsed = newCapUsed;
845     }
846 
847     /**
848      * @dev See {ERC20Mintable-mint}.
849      *
850      * Requirements:
851      *
852      * - `value` must not cause the airdrop cap used to go over the airdrop cap.
853      */
854     function _airdropMint(address account, uint256 value) internal {
855         super._mint(account, value);
856     }
857 
858     /**
859      * @dev Used for increasing the airdrop cap used when owner lockup the token.
860      *
861      * Requirements:
862      *
863      * - `value` must not cause the airdrop cap used to go over the cap.
864      */
865     function _incrementUsedAirdropCap(uint256 value) internal {
866         uint256 newAirdropCapUsed = _airdropCapUsed.add(value);
867         require(
868             newAirdropCapUsed <= _airdropCap,
869             "ERC20Capped: airdrop cap exceeded"
870         );
871         _airdropCapUsed = newAirdropCapUsed;
872     }
873 }
874 
875 /**
876  * @title Standard ERC20 token
877  *
878  * @dev Implementation of the basic standard token.
879  * @dev https://github.com/ethereum/EIPs/issues/20
880  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
881  */
882 contract SocialGoodToken is
883     ERC20Pausable,
884     ERC20Burnable,
885     ERC20Mintable,
886     ERC20Capped
887 {
888     string private constant _name = "SocialGood";
889     string private constant _symbol = "SG";
890     uint8 private constant _decimals = 18;
891 
892     // set maximum token normal hard cap
893     uint256 private constant NORMAL_HARD_CAP = 209250000e18; // 209,250,000 SG
894     // set maximum token airdrop hard cap
895     uint256 private constant AIRDROP_HARD_CAP = 750000e18; // 750,000 SG
896 
897     mapping(address => uint256) private _lockupAmounts;
898 
899     constructor() public ERC20Capped(NORMAL_HARD_CAP, AIRDROP_HARD_CAP) {}
900 
901     /**
902      * @dev Returns the name of the token.
903      */
904     function name() public pure returns (string memory) {
905         return _name;
906     }
907 
908     /**
909      * @dev Returns the symbol of the token, usually a shorter version of the
910      * name.
911      */
912     function symbol() public pure returns (string memory) {
913         return _symbol;
914     }
915 
916     /**
917      * @dev Returns the number of decimals used to get its user representation.
918      * For example, if `decimals` equals `2`, a balance of `505` tokens should
919      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
920      *
921      * Tokens usually opt for a value of 18, imitating the relationship between
922      * Ether and Wei.
923      *
924      * NOTE: This information is only used for _display_ purposes: it in
925      * no way affects any of the arithmetic of the contract, including
926      * {IERC20-balanceOf} and {IERC20-transfer}.
927      */
928     function decimals() public pure returns (uint8) {
929         return _decimals;
930     }
931 
932     function getAddressLockupAmount(address _account)
933         public
934         view
935         returns (uint256)
936     {
937         return _lockupAmounts[_account];
938     }
939 
940     /**
941      * @dev Destroys `amount` tokens from the caller.
942      *
943      * See {ERC20-_burn}.
944      */
945     function burn(uint256 amount) public onlyOwner {
946         _burn(msg.sender, amount);
947     }
948 
949     /**
950      * @dev See {ERC20-_burnFrom}.
951      */
952     function burnFrom(address account, uint256 amount) public onlyOwner {
953         _burnFrom(account, amount);
954     }
955 
956     /**
957      * @dev Used for validating inputs before execute lockup
958      */
959     function _preValidateAirdrop(address _account, uint256 _amount)
960         internal
961         pure
962     {
963         require(
964             _account != address(0),
965             "SocialGoodToken: airdrop target address is empty"
966         );
967         require(_amount != 0, "SocialGoodToken: amount is zero");
968     }
969 
970     /**
971      * @dev Used for migrating old SG token to new SG token.
972      * The token amount will be locked until the owner unlock it manually.
973      */
974     function airdropLockup(
975         address[] calldata _accounts,
976         uint256[] calldata _amounts
977     ) external onlyOwner whenNotPaused {
978         require(
979             _accounts.length == _amounts.length,
980             "SocialGoodToken: the length of accounts, amounts are not the same"
981         );
982         uint256 length = _accounts.length;
983         for (uint256 i = 0; i != length; i++) {
984             _preValidateAirdrop(_accounts[i], _amounts[i]);
985             _lockup(_accounts[i], _amounts[i]);
986         }
987     }
988 
989     /**
990      * @dev Used for locking up token amount of any address.
991      * This is an internal function, only called from the owner's airdropLockup function.
992      */
993     function _lockup(address _account, uint256 _amount) internal {
994         _lockupAmounts[_account] = _lockupAmounts[_account].add(_amount);
995         _incrementUsedAirdropCap(_amount);
996     }
997 
998     /**
999      * @dev Used for unlocking token when migrating from old SG token to new SG token.
1000      * The token amount will be minted to selected addresses up to the token issue limit.
1001      * Data will be read from _lockupAmounts and reset to zero after token is minted.
1002      */
1003     function unlocks(address[] calldata _accounts)
1004         external
1005         onlyOwner
1006         whenNotPaused
1007     {
1008         uint256 length = _accounts.length;
1009         for (uint256 i = 0; i != length; i++) {
1010             _unlock(_accounts[i]);
1011         }
1012     }
1013 
1014     function _unlock(address _account) internal {
1015         require(
1016             _lockupAmounts[_account] != 0,
1017             "SocialGoodToken: amount is zero"
1018         );
1019         _airdropMint(_account, _lockupAmounts[_account]);
1020         _lockupAmounts[_account] = 0;
1021     }
1022 }