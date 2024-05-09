1 pragma solidity ^0.5.11;
2 
3 
4 
5 contract Context {
6     // Empty internal constructor, to prevent people from mistakenly deploying
7     // an instance of this contract, which should be used via inheritance.
8     constructor () internal { }
9     // solhint-disable-previous-line no-empty-blocks
10 
11     function _msgSender() internal view returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
25  * the optional functions; to access them see {ERC20Detailed}.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 pragma solidity ^0.5.11;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      *
153      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
154      * @dev Get it via `npm install @openzeppelin/contracts@next`.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
212      * @dev Get it via `npm install @openzeppelin/contracts@next`.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         // Solidity only automatically asserts when dividing by 0
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      * - The divisor cannot be zero.
248      *
249      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
250      * @dev Get it via `npm install @openzeppelin/contracts@next`.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 pragma solidity ^0.5.11;
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
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
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
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See {IERC20-approve}.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20};
343      *
344      * Requirements:
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for `sender`'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(address sender, address recipient, uint256 amount) internal {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply = _totalSupply.add(amount);
428         _balances[account] = _balances[account].add(amount);
429         emit Transfer(address(0), account, amount);
430     }
431 
432     /**
433      * @dev Destroys `amount` tokens from `account`, reducing the
434      * total supply.
435      *
436      * Emits a {Transfer} event with `to` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `account` cannot be the zero address.
441      * - `account` must have at least `amount` tokens.
442      */
443     function _burn(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: burn from the zero address");
445 
446         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
447         _totalSupply = _totalSupply.sub(amount);
448         emit Transfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
474      * from the caller's allowance.
475      *
476      * See {_burn} and {_approve}.
477      */
478     function _burnFrom(address account, uint256 amount) internal {
479         _burn(account, amount);
480         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
481     }
482 }
483 
484 
485 
486 pragma solidity ^0.5.11;
487 
488 
489 /**
490  * @dev Optional functions from the ERC20 standard.
491  */
492 contract ERC20Detailed is IERC20 {
493     string private _name;
494     string private _symbol;
495     uint8 private _decimals;
496 
497     /**
498      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
499      * these values are immutable: they can only be set once during
500      * construction.
501      */
502     constructor (string memory name, string memory symbol, uint8 decimals) public {
503         _name = name;
504         _symbol = symbol;
505         _decimals = decimals;
506     }
507 
508     /**
509      * @dev Returns the name of the token.
510      */
511     function name() public view returns (string memory) {
512         return _name;
513     }
514 
515     /**
516      * @dev Returns the symbol of the token, usually a shorter version of the
517      * name.
518      */
519     function symbol() public view returns (string memory) {
520         return _symbol;
521     }
522 
523     /**
524      * @dev Returns the number of decimals used to get its user representation.
525      * For example, if `decimals` equals `2`, a balance of `505` tokens should
526      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
527      *
528      * Tokens usually opt for a value of 18, imitating the relationship between
529      * Ether and Wei.
530      *
531      * NOTE: This information is only used for _display_ purposes: it in
532      * no way affects any of the arithmetic of the contract, including
533      * {IERC20-balanceOf} and {IERC20-transfer}.
534      */
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 }
539 
540 /**
541  * @dev Extension of {ERC20} that allows token holders to destroy both their own
542  * tokens and those that they have an allowance for, in a way that can be
543  * recognized off-chain (via event analysis).
544  */
545 contract ERC20Burnable is Context, ERC20 {
546     /**
547      * @dev Destroys `amount` tokens from the caller.
548      *
549      * See {ERC20-_burn}.
550      */
551     function burn(uint256 amount) public {
552         _burn(_msgSender(), amount);
553     }
554 
555     /**
556      * @dev See {ERC20-_burnFrom}.
557      */
558     function burnFrom(address account, uint256 amount) public {
559         _burnFrom(account, amount);
560     }
561 }
562 
563 pragma solidity ^0.5.11;
564 /**
565  * @title Roles
566  * @dev Library for managing addresses assigned to a Role.
567  */
568 library Roles {
569     struct Role {
570         mapping (address => bool) bearer;
571     }
572 
573     /**
574      * @dev Give an account access to this role.
575      */
576     function add(Role storage role, address account) internal {
577         require(!has(role, account), "Roles: account already has role");
578         role.bearer[account] = true;
579     }
580 
581     /**
582      * @dev Remove an account's access to this role.
583      */
584     function remove(Role storage role, address account) internal {
585         require(has(role, account), "Roles: account does not have role");
586         role.bearer[account] = false;
587     }
588 
589     /**
590      * @dev Check if an account has this role.
591      * @return bool
592      */
593     function has(Role storage role, address account) internal view returns (bool) {
594         require(account != address(0), "Roles: account is the zero address");
595         return role.bearer[account];
596     }
597 }
598 pragma solidity ^0.5.11;
599 
600 contract PauserRole is Context {
601     using Roles for Roles.Role;
602 
603     event PauserAdded(address indexed account);
604     event PauserRemoved(address indexed account);
605 
606     Roles.Role private _pausers;
607 
608     constructor () internal {
609         _addPauser(_msgSender());
610     }
611 
612     modifier onlyPauser() {
613         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
614         _;
615     }
616 
617     function isPauser(address account) public view returns (bool) {
618         return _pausers.has(account);
619     }
620 
621     function addPauser(address account) public onlyPauser {
622         _addPauser(account);
623     }
624     
625    function removePauser(address account) public onlyPauser {
626         _removePauser(account);
627     }
628 
629 
630     function renouncePauser() public {
631         _removePauser(_msgSender());
632     }
633 
634     function _addPauser(address account) internal {
635         _pausers.add(account);
636         emit PauserAdded(account);
637     }
638 
639     function _removePauser(address account) internal {
640         _pausers.remove(account);
641         emit PauserRemoved(account);
642     }
643 }
644 
645 pragma solidity ^0.5.11;
646 /**
647  * @dev Contract module which allows children to implement an emergency stop
648  * mechanism that can be triggered by an authorized account.
649  *
650  * This module is used through inheritance. It will make available the
651  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
652  * the functions of your contract. Note that they will not be pausable by
653  * simply including this module, only once the modifiers are put in place.
654  */
655 contract Pausable is Context, PauserRole {
656     /**
657      * @dev Emitted when the pause is triggered by a pauser (`account`).
658      */
659     event Paused(address account);
660 
661     /**
662      * @dev Emitted when the pause is lifted by a pauser (`account`).
663      */
664     event Unpaused(address account);
665 
666     bool private _paused;
667 
668     /**
669      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
670      * to the deployer.
671      */
672     constructor () internal {
673         _paused = false;
674     }
675 
676     /**
677      * @dev Returns true if the contract is paused, and false otherwise.
678      */
679     function paused() public view returns (bool) {
680         return _paused;
681     }
682 
683     /**
684      * @dev Modifier to make a function callable only when the contract is not paused.
685      */
686     modifier whenNotPaused() {
687         require(!_paused, "Pausable: paused");
688         _;
689     }
690 
691     /**
692      * @dev Modifier to make a function callable only when the contract is paused.
693      */
694     modifier whenPaused() {
695         require(_paused, "Pausable: not paused");
696         _;
697     }
698 
699     /**
700      * @dev Called by a pauser to pause, triggers stopped state.
701      */
702     function pause() public onlyPauser whenNotPaused {
703         _paused = true;
704         emit Paused(_msgSender());
705     }
706 
707     /**
708      * @dev Called by a pauser to unpause, returns to normal state.
709      */
710     function unpause() public onlyPauser whenPaused {
711         _paused = false;
712         emit Unpaused(_msgSender());
713     }
714 }
715 
716 pragma solidity ^0.5.11;
717 
718 /**
719  * @title Pausable token
720  * @dev ERC20 with pausable transfers and allowances.
721  *
722  * Useful if you want to stop trades until the end of a crowdsale, or have
723  * an emergency switch for freezing all token transfers in the event of a large
724  * bug.
725  */
726 contract ERC20Pausable is ERC20, Pausable {
727     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
728         return super.transfer(to, value);
729     }
730 
731     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
732         return super.transferFrom(from, to, value);
733     }
734 
735     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
736         return super.approve(spender, value);
737     }
738 
739     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
740         return super.increaseAllowance(spender, addedValue);
741     }
742 
743     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
744         return super.decreaseAllowance(spender, subtractedValue);
745     }
746 }
747 
748 pragma solidity ^0.5.11;
749 /**
750  * @title BPTCToken
751  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
752  * Note they can later distribute these tokens as they wish using `transfer` and other
753  * `ERC20` functions.
754  */
755 contract BPTCToken is Context, ERC20, ERC20Detailed , ERC20Burnable ,  ERC20Pausable {
756 
757     /**
758      * @dev Constructor that gives _msgSender() all of existing tokens.
759      */
760     constructor () public ERC20Detailed("Bizcodi Platform Tomato Coin", "BPTC", 8) {
761         _mint(_msgSender(), 9999999999  * (10 ** uint256(decimals())));
762     }
763 
764 }