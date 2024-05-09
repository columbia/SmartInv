1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-22
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 
8 contract Context {
9     // Empty internal constructor, to prevent people from mistakenly deploying
10     // an instance of this contract, which should be used via inheritance.
11     constructor () internal { }
12     // solhint-disable-previous-line no-empty-blocks
13 
14     function _msgSender() internal view returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      * - Subtraction cannot overflow.
133      *
134      * _Available since v2.4.0._
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         // Solidity only automatically asserts when dividing by 0
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      *
229      * _Available since v2.4.0._
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 contract ERC20 is Context, IERC20 {
238     using SafeMath for uint256;
239 
240     mapping (address => uint256) private _balances;
241 
242     mapping (address => mapping (address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address account) public view returns (uint256) {
257         return _balances[account];
258     }
259 
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `recipient` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address recipient, uint256 amount) public returns (bool) {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public returns (bool) {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     /**
293      * @dev See {IERC20-transferFrom}.
294      *
295      * Emits an {Approval} event indicating the updated allowance. This is not
296      * required by the EIP. See the note at the beginning of {ERC20};
297      *
298      * Requirements:
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      * - the caller must have allowance for `sender`'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
343         return true;
344     }
345 
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(address sender, address recipient, uint256 amount) internal {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
365         _balances[recipient] = _balances[recipient].add(amount);
366         emit Transfer(sender, recipient, amount);
367     }
368 
369     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
370      * the total supply.
371      *
372      * Emits a {Transfer} event with `from` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `to` cannot be the zero address.
377      */
378     function _mint(address account, uint256 amount) internal {
379         require(account != address(0), "ERC20: mint to the zero address");
380 
381         _totalSupply = _totalSupply.add(amount);
382         _balances[account] = _balances[account].add(amount);
383         emit Transfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
401         _totalSupply = _totalSupply.sub(amount);
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
407      *
408      * This is internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
428      * from the caller's allowance.
429      *
430      * See {_burn} and {_approve}.
431      */
432     function _burnFrom(address account, uint256 amount) internal {
433         _burn(account, amount);
434         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
435     }
436 }
437 
438 library Roles {
439     struct Role {
440         mapping (address => bool) bearer;
441     }
442 
443     /**
444      * @dev Give an account access to this role.
445      */
446     function add(Role storage role, address account) internal {
447         require(!has(role, account), "Roles: account already has role");
448         role.bearer[account] = true;
449     }
450 
451     /**
452      * @dev Remove an account's access to this role.
453      */
454     function remove(Role storage role, address account) internal {
455         require(has(role, account), "Roles: account does not have role");
456         role.bearer[account] = false;
457     }
458 
459     /**
460      * @dev Check if an account has this role.
461      * @return bool
462      */
463     function has(Role storage role, address account) internal view returns (bool) {
464         require(account != address(0), "Roles: account is the zero address");
465         return role.bearer[account];
466     }
467 }
468 
469 contract MinterRole is Context {
470     using Roles for Roles.Role;
471 
472     event MinterAdded(address indexed account);
473     event MinterRemoved(address indexed account);
474 
475     Roles.Role private _minters;
476 
477     constructor () internal {
478         _addMinter(_msgSender());
479     }
480 
481     modifier onlyMinter() {
482         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
483         _;
484     }
485 
486     function isMinter(address account) public view returns (bool) {
487         return _minters.has(account);
488     }
489 
490     function addMinter(address account) public onlyMinter {
491         _addMinter(account);
492     }
493 
494     function renounceMinter() public {
495         _removeMinter(_msgSender());
496     }
497 
498     function _addMinter(address account) internal {
499         _minters.add(account);
500         emit MinterAdded(account);
501     }
502 
503     function _removeMinter(address account) internal {
504         _minters.remove(account);
505         emit MinterRemoved(account);
506     }
507 }
508 
509 contract ERC20Mintable is ERC20, MinterRole {
510     /**
511      * @dev See {ERC20-_mint}.
512      *
513      * Requirements:
514      *
515      * - the caller must have the {MinterRole}.
516      */
517     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
518         _mint(account, amount);
519         return true;
520     }
521 }
522 
523 contract ERC20Capped is ERC20Mintable {
524     uint256 private _cap;
525 
526     /**
527      * @dev Sets the value of the `cap`. This value is immutable, it can only be
528      * set once during construction.
529      */
530     constructor (uint256 cap) public {
531         require(cap > 0, "ERC20Capped: cap is 0");
532         _cap = cap;
533     }
534 
535     /**
536      * @dev Returns the cap on the token's total supply.
537      */
538     function cap() public view returns (uint256) {
539         return _cap;
540     }
541 
542     /**
543      * @dev See {ERC20Mintable-mint}.
544      *
545      * Requirements:
546      *
547      * - `value` must not cause the total supply to go over the cap.
548      */
549     function _mint(address account, uint256 value) internal {
550         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
551         super._mint(account, value);
552     }
553 }
554 
555 contract ERC20Detailed is IERC20 {
556     string private _name;
557     string private _symbol;
558     uint8 private _decimals;
559 
560     /**
561      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
562      * these values are immutable: they can only be set once during
563      * construction.
564      */
565     constructor (string memory name, string memory symbol, uint8 decimals) public {
566         _name = name;
567         _symbol = symbol;
568         _decimals = decimals;
569     }
570 
571     /**
572      * @dev Returns the name of the token.
573      */
574     function name() public view returns (string memory) {
575         return _name;
576     }
577 
578     /**
579      * @dev Returns the symbol of the token, usually a shorter version of the
580      * name.
581      */
582     function symbol() public view returns (string memory) {
583         return _symbol;
584     }
585 
586     /**
587      * @dev Returns the number of decimals used to get its user representation.
588      * For example, if `decimals` equals `2`, a balance of `505` tokens should
589      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
590      *
591      * Tokens usually opt for a value of 18, imitating the relationship between
592      * Ether and Wei.
593      *
594      * NOTE: This information is only used for _display_ purposes: it in
595      * no way affects any of the arithmetic of the contract, including
596      * {IERC20-balanceOf} and {IERC20-transfer}.
597      */
598     function decimals() public view returns (uint8) {
599         return _decimals;
600     }
601 }
602 
603 contract PauserRole is Context {
604     using Roles for Roles.Role;
605 
606     event PauserAdded(address indexed account);
607     event PauserRemoved(address indexed account);
608 
609     Roles.Role private _pausers;
610 
611     constructor () internal {
612         _addPauser(_msgSender());
613     }
614 
615     modifier onlyPauser() {
616         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
617         _;
618     }
619 
620     function isPauser(address account) public view returns (bool) {
621         return _pausers.has(account);
622     }
623 
624     function addPauser(address account) public onlyPauser {
625         _addPauser(account);
626     }
627 
628     function renouncePauser() public {
629         _removePauser(_msgSender());
630     }
631 
632     function _addPauser(address account) internal {
633         _pausers.add(account);
634         emit PauserAdded(account);
635     }
636 
637     function _removePauser(address account) internal {
638         _pausers.remove(account);
639         emit PauserRemoved(account);
640     }
641 }
642 
643 contract Pausable is Context, PauserRole {
644     /**
645      * @dev Emitted when the pause is triggered by a pauser (`account`).
646      */
647     event Paused(address account);
648 
649     /**
650      * @dev Emitted when the pause is lifted by a pauser (`account`).
651      */
652     event Unpaused(address account);
653 
654     bool private _paused;
655 
656     /**
657      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
658      * to the deployer.
659      */
660     constructor () internal {
661         _paused = false;
662     }
663 
664     /**
665      * @dev Returns true if the contract is paused, and false otherwise.
666      */
667     function paused() public view returns (bool) {
668         return _paused;
669     }
670 
671     /**
672      * @dev Modifier to make a function callable only when the contract is not paused.
673      */
674     modifier whenNotPaused() {
675         require(!_paused, "Pausable: paused");
676         _;
677     }
678 
679     /**
680      * @dev Modifier to make a function callable only when the contract is paused.
681      */
682     modifier whenPaused() {
683         require(_paused, "Pausable: not paused");
684         _;
685     }
686 
687     /**
688      * @dev Called by a pauser to pause, triggers stopped state.
689      */
690     function pause() public onlyPauser whenNotPaused {
691         _paused = true;
692         emit Paused(_msgSender());
693     }
694 
695     /**
696      * @dev Called by a pauser to unpause, returns to normal state.
697      */
698     function unpause() public onlyPauser whenPaused {
699         _paused = false;
700         emit Unpaused(_msgSender());
701     }
702 }
703 
704 contract ERC20Pausable is ERC20, Pausable {
705     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
706         return super.transfer(to, value);
707     }
708 
709     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
710         return super.transferFrom(from, to, value);
711     }
712 
713     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
714         return super.approve(spender, value);
715     }
716 
717     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
718         return super.increaseAllowance(spender, addedValue);
719     }
720 
721     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
722         return super.decreaseAllowance(spender, subtractedValue);
723     }
724 }
725 
726 contract TycoonToken is ERC20Capped, ERC20Detailed, ERC20Pausable  {
727 
728     /////
729     // Constants:
730     /////
731 
732     string private constant DESCRIPTION = "Tycoon Token";
733     string private constant SYMBOL = "TYC";
734     uint8 private constant DECIMALS = 18;
735 
736     uint256 private constant SALE_TOTAL = 84000000*10**18;     // 60%
737     uint256 private constant TEAM_TOTAL = 25200000*10**18;     // 18%
738     uint256 private constant PARTNER_TOTAL = 19600000*10**18;  // 14%
739     uint256 private constant BOUNTY_TOTAL = 7000000*10**18;    // 5%
740     uint256 private constant ADVISOR_TOTAL = 4200000*10**18;   // 3%
741 
742     uint256 private constant SALE_PREMINT = 15145135*10**18;
743 
744     uint256 private constant CAP = 140000000*10**18;           // 100&
745 
746     /////
747     // Modifiers:
748     /////
749 
750     modifier notZero(address adr) {
751         require(adr != address(0), "TycoonToken::notZero::is-zero");
752         _;
753     }
754 
755 
756     // /////
757     // Constructor:
758     // /////
759 
760     /**
761      * @dev Deploy the token contract, set the cap and allocate some tokens to the sender.
762      */
763     constructor(
764         address team,
765         address partner,
766         address bounty,
767         address advisor,
768         address sale
769     )
770         public
771         ERC20Capped(CAP)
772         ERC20Detailed(DESCRIPTION, SYMBOL, DECIMALS)
773         notZero(team)
774         notZero(partner)
775         notZero(bounty)
776         notZero(advisor)
777         notZero(sale)
778     {
779         require(
780             SALE_TOTAL + TEAM_TOTAL + PARTNER_TOTAL + BOUNTY_TOTAL + ADVISOR_TOTAL == CAP,
781             "TycoonToken::constructor::invalid-alloc"
782         );
783 
784         _mint(team, TEAM_TOTAL);
785         _mint(partner, PARTNER_TOTAL);
786         _mint(bounty, BOUNTY_TOTAL);
787         _mint(advisor, ADVISOR_TOTAL);
788         _mint(sale, SALE_PREMINT);
789 
790         addMinter(sale);
791         addPauser(sale);
792 
793         renounceMinter();
794         renouncePauser();
795     }
796 }