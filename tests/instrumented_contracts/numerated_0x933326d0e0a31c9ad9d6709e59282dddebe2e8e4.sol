1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/access/Roles.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @title Roles
37  * @dev Library for managing addresses assigned to a Role.
38  */
39 library Roles {
40     struct Role {
41         mapping (address => bool) bearer;
42     }
43 
44     /**
45      * @dev Give an account access to this role.
46      */
47     function add(Role storage role, address account) internal {
48         require(!has(role, account), "Roles: account already has role");
49         role.bearer[account] = true;
50     }
51 
52     /**
53      * @dev Remove an account's access to this role.
54      */
55     function remove(Role storage role, address account) internal {
56         require(has(role, account), "Roles: account does not have role");
57         role.bearer[account] = false;
58     }
59 
60     /**
61      * @dev Check if an account has this role.
62      * @return bool
63      */
64     function has(Role storage role, address account) internal view returns (bool) {
65         require(account != address(0), "Roles: account is the zero address");
66         return role.bearer[account];
67     }
68 }
69 
70 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
71 
72 pragma solidity ^0.5.0;
73 
74 
75 
76 /**
77  * @title WhitelistAdminRole
78  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
79  */
80 contract WhitelistAdminRole is Context {
81     using Roles for Roles.Role;
82 
83     event WhitelistAdminAdded(address indexed account);
84     event WhitelistAdminRemoved(address indexed account);
85 
86     Roles.Role private _whitelistAdmins;
87 
88     constructor () internal {
89         _addWhitelistAdmin(_msgSender());
90     }
91 
92     modifier onlyWhitelistAdmin() {
93         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
94         _;
95     }
96 
97     function isWhitelistAdmin(address account) public view returns (bool) {
98         return _whitelistAdmins.has(account);
99     }
100 
101     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
102         _addWhitelistAdmin(account);
103     }
104 
105     function renounceWhitelistAdmin() public {
106         _removeWhitelistAdmin(_msgSender());
107     }
108 
109     function _addWhitelistAdmin(address account) internal {
110         _whitelistAdmins.add(account);
111         emit WhitelistAdminAdded(account);
112     }
113 
114     function _removeWhitelistAdmin(address account) internal {
115         _whitelistAdmins.remove(account);
116         emit WhitelistAdminRemoved(account);
117     }
118 }
119 
120 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
121 
122 pragma solidity ^0.5.0;
123 
124 
125 
126 
127 /**
128  * @title WhitelistedRole
129  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
130  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
131  * it), and not Whitelisteds themselves.
132  */
133 contract WhitelistedRole is Context, WhitelistAdminRole {
134     using Roles for Roles.Role;
135 
136     event WhitelistedAdded(address indexed account);
137     event WhitelistedRemoved(address indexed account);
138 
139     Roles.Role private _whitelisteds;
140 
141     modifier onlyWhitelisted() {
142         require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
143         _;
144     }
145 
146     function isWhitelisted(address account) public view returns (bool) {
147         return _whitelisteds.has(account);
148     }
149 
150     function addWhitelisted(address account) public onlyWhitelistAdmin {
151         _addWhitelisted(account);
152     }
153 
154     function removeWhitelisted(address account) public onlyWhitelistAdmin {
155         _removeWhitelisted(account);
156     }
157 
158     function renounceWhitelisted() public {
159         _removeWhitelisted(_msgSender());
160     }
161 
162     function _addWhitelisted(address account) internal {
163         _whitelisteds.add(account);
164         emit WhitelistedAdded(account);
165     }
166 
167     function _removeWhitelisted(address account) internal {
168         _whitelisteds.remove(account);
169         emit WhitelistedRemoved(account);
170     }
171 }
172 
173 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
174 
175 pragma solidity ^0.5.0;
176 
177 /**
178  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
179  * the optional functions; to access them see {ERC20Detailed}.
180  */
181 interface IERC20 {
182     /**
183      * @dev Returns the amount of tokens in existence.
184      */
185     function totalSupply() external view returns (uint256);
186 
187     /**
188      * @dev Returns the amount of tokens owned by `account`.
189      */
190     function balanceOf(address account) external view returns (uint256);
191 
192     /**
193      * @dev Moves `amount` tokens from the caller's account to `recipient`.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transfer(address recipient, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Returns the remaining number of tokens that `spender` will be
203      * allowed to spend on behalf of `owner` through {transferFrom}. This is
204      * zero by default.
205      *
206      * This value changes when {approve} or {transferFrom} are called.
207      */
208     function allowance(address owner, address spender) external view returns (uint256);
209 
210     /**
211      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * IMPORTANT: Beware that changing an allowance with this method brings the risk
216      * that someone may use both the old and the new allowance by unfortunate
217      * transaction ordering. One possible solution to mitigate this race
218      * condition is to first reduce the spender's allowance to 0 and set the
219      * desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address spender, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Moves `amount` tokens from `sender` to `recipient` using the
228      * allowance mechanism. `amount` is then deducted from the caller's
229      * allowance.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Emitted when `value` tokens are moved from one account (`from`) to
239      * another (`to`).
240      *
241      * Note that `value` may be zero.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 value);
244 
245     /**
246      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
247      * a call to {approve}. `value` is the new allowance.
248      */
249     event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
253 
254 pragma solidity ^0.5.0;
255 
256 /**
257  * @dev Wrappers over Solidity's arithmetic operations with added overflow
258  * checks.
259  *
260  * Arithmetic operations in Solidity wrap on overflow. This can easily result
261  * in bugs, because programmers usually assume that an overflow raises an
262  * error, which is the standard behavior in high level programming languages.
263  * `SafeMath` restores this intuition by reverting the transaction when an
264  * operation overflows.
265  *
266  * Using this library instead of the unchecked operations eliminates an entire
267  * class of bugs, so it's recommended to use it always.
268  */
269 library SafeMath {
270     /**
271      * @dev Returns the addition of two unsigned integers, reverting on
272      * overflow.
273      *
274      * Counterpart to Solidity's `+` operator.
275      *
276      * Requirements:
277      * - Addition cannot overflow.
278      */
279     function add(uint256 a, uint256 b) internal pure returns (uint256) {
280         uint256 c = a + b;
281         require(c >= a, "SafeMath: addition overflow");
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting on
288      * overflow (when the result is negative).
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      * - Subtraction cannot overflow.
294      */
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         return sub(a, b, "SafeMath: subtraction overflow");
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      * - Subtraction cannot overflow.
307      *
308      * _Available since v2.4.0._
309      */
310     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b <= a, errorMessage);
312         uint256 c = a - b;
313 
314         return c;
315     }
316 
317     /**
318      * @dev Returns the multiplication of two unsigned integers, reverting on
319      * overflow.
320      *
321      * Counterpart to Solidity's `*` operator.
322      *
323      * Requirements:
324      * - Multiplication cannot overflow.
325      */
326     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
327         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
328         // benefit is lost if 'b' is also tested.
329         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
330         if (a == 0) {
331             return 0;
332         }
333 
334         uint256 c = a * b;
335         require(c / a == b, "SafeMath: multiplication overflow");
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the integer division of two unsigned integers. Reverts on
342      * division by zero. The result is rounded towards zero.
343      *
344      * Counterpart to Solidity's `/` operator. Note: this function uses a
345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
346      * uses an invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      * - The divisor cannot be zero.
350      */
351     function div(uint256 a, uint256 b) internal pure returns (uint256) {
352         return div(a, b, "SafeMath: division by zero");
353     }
354 
355     /**
356      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
357      * division by zero. The result is rounded towards zero.
358      *
359      * Counterpart to Solidity's `/` operator. Note: this function uses a
360      * `revert` opcode (which leaves remaining gas untouched) while Solidity
361      * uses an invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      * - The divisor cannot be zero.
365      *
366      * _Available since v2.4.0._
367      */
368     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         // Solidity only automatically asserts when dividing by 0
370         require(b > 0, errorMessage);
371         uint256 c = a / b;
372         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * Reverts when dividing by zero.
380      *
381      * Counterpart to Solidity's `%` operator. This function uses a `revert`
382      * opcode (which leaves remaining gas untouched) while Solidity uses an
383      * invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      * - The divisor cannot be zero.
387      */
388     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
389         return mod(a, b, "SafeMath: modulo by zero");
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394      * Reverts with custom message when dividing by zero.
395      *
396      * Counterpart to Solidity's `%` operator. This function uses a `revert`
397      * opcode (which leaves remaining gas untouched) while Solidity uses an
398      * invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      * - The divisor cannot be zero.
402      *
403      * _Available since v2.4.0._
404      */
405     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
406         require(b != 0, errorMessage);
407         return a % b;
408     }
409 }
410 
411 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
412 
413 pragma solidity ^0.5.0;
414 
415 
416 
417 
418 /**
419  * @dev Implementation of the {IERC20} interface.
420  *
421  * This implementation is agnostic to the way tokens are created. This means
422  * that a supply mechanism has to be added in a derived contract using {_mint}.
423  * For a generic mechanism see {ERC20Mintable}.
424  *
425  * TIP: For a detailed writeup see our guide
426  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
427  * to implement supply mechanisms].
428  *
429  * We have followed general OpenZeppelin guidelines: functions revert instead
430  * of returning `false` on failure. This behavior is nonetheless conventional
431  * and does not conflict with the expectations of ERC20 applications.
432  *
433  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
434  * This allows applications to reconstruct the allowance for all accounts just
435  * by listening to said events. Other implementations of the EIP may not emit
436  * these events, as it isn't required by the specification.
437  *
438  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
439  * functions have been added to mitigate the well-known issues around setting
440  * allowances. See {IERC20-approve}.
441  */
442 contract ERC20 is Context, IERC20 {
443     using SafeMath for uint256;
444 
445     mapping (address => uint256) private _balances;
446 
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     uint256 private _totalSupply;
450 
451     /**
452      * @dev See {IERC20-totalSupply}.
453      */
454     function totalSupply() public view returns (uint256) {
455         return _totalSupply;
456     }
457 
458     /**
459      * @dev See {IERC20-balanceOf}.
460      */
461     function balanceOf(address account) public view returns (uint256) {
462         return _balances[account];
463     }
464 
465     /**
466      * @dev See {IERC20-transfer}.
467      *
468      * Requirements:
469      *
470      * - `recipient` cannot be the zero address.
471      * - the caller must have a balance of at least `amount`.
472      */
473     function transfer(address recipient, uint256 amount) public returns (bool) {
474         _transfer(_msgSender(), recipient, amount);
475         return true;
476     }
477 
478     /**
479      * @dev See {IERC20-allowance}.
480      */
481     function allowance(address owner, address spender) public view returns (uint256) {
482         return _allowances[owner][spender];
483     }
484 
485     /**
486      * @dev See {IERC20-approve}.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function approve(address spender, uint256 amount) public returns (bool) {
493         _approve(_msgSender(), spender, amount);
494         return true;
495     }
496 
497     /**
498      * @dev See {IERC20-transferFrom}.
499      *
500      * Emits an {Approval} event indicating the updated allowance. This is not
501      * required by the EIP. See the note at the beginning of {ERC20};
502      *
503      * Requirements:
504      * - `sender` and `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      * - the caller must have allowance for `sender`'s tokens of at least
507      * `amount`.
508      */
509     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
510         _transfer(sender, recipient, amount);
511         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
512         return true;
513     }
514 
515     /**
516      * @dev Atomically increases the allowance granted to `spender` by the caller.
517      *
518      * This is an alternative to {approve} that can be used as a mitigation for
519      * problems described in {IERC20-approve}.
520      *
521      * Emits an {Approval} event indicating the updated allowance.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      */
527     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
528         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
529         return true;
530     }
531 
532     /**
533      * @dev Atomically decreases the allowance granted to `spender` by the caller.
534      *
535      * This is an alternative to {approve} that can be used as a mitigation for
536      * problems described in {IERC20-approve}.
537      *
538      * Emits an {Approval} event indicating the updated allowance.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      * - `spender` must have allowance for the caller of at least
544      * `subtractedValue`.
545      */
546     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
547         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
548         return true;
549     }
550 
551     /**
552      * @dev Moves tokens `amount` from `sender` to `recipient`.
553      *
554      * This is internal function is equivalent to {transfer}, and can be used to
555      * e.g. implement automatic token fees, slashing mechanisms, etc.
556      *
557      * Emits a {Transfer} event.
558      *
559      * Requirements:
560      *
561      * - `sender` cannot be the zero address.
562      * - `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      */
565     function _transfer(address sender, address recipient, uint256 amount) internal {
566         require(sender != address(0), "ERC20: transfer from the zero address");
567         require(recipient != address(0), "ERC20: transfer to the zero address");
568 
569         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
570         _balances[recipient] = _balances[recipient].add(amount);
571         emit Transfer(sender, recipient, amount);
572     }
573 
574     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
575      * the total supply.
576      *
577      * Emits a {Transfer} event with `from` set to the zero address.
578      *
579      * Requirements
580      *
581      * - `to` cannot be the zero address.
582      */
583     function _mint(address account, uint256 amount) internal {
584         require(account != address(0), "ERC20: mint to the zero address");
585 
586         _totalSupply = _totalSupply.add(amount);
587         _balances[account] = _balances[account].add(amount);
588         emit Transfer(address(0), account, amount);
589     }
590 
591      /**
592      * @dev Destroys `amount` tokens from `account`, reducing the
593      * total supply.
594      *
595      * Emits a {Transfer} event with `to` set to the zero address.
596      *
597      * Requirements
598      *
599      * - `account` cannot be the zero address.
600      * - `account` must have at least `amount` tokens.
601      */
602     function _burn(address account, uint256 amount) internal {
603         require(account != address(0), "ERC20: burn from the zero address");
604 
605         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
606         _totalSupply = _totalSupply.sub(amount);
607         emit Transfer(account, address(0), amount);
608     }
609 
610     /**
611      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
612      *
613      * This is internal function is equivalent to `approve`, and can be used to
614      * e.g. set automatic allowances for certain subsystems, etc.
615      *
616      * Emits an {Approval} event.
617      *
618      * Requirements:
619      *
620      * - `owner` cannot be the zero address.
621      * - `spender` cannot be the zero address.
622      */
623     function _approve(address owner, address spender, uint256 amount) internal {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     /**
632      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
633      * from the caller's allowance.
634      *
635      * See {_burn} and {_approve}.
636      */
637     function _burnFrom(address account, uint256 amount) internal {
638         _burn(account, amount);
639         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
640     }
641 }
642 
643 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
644 
645 pragma solidity ^0.5.0;
646 
647 
648 
649 contract MinterRole is Context {
650     using Roles for Roles.Role;
651 
652     event MinterAdded(address indexed account);
653     event MinterRemoved(address indexed account);
654 
655     Roles.Role private _minters;
656 
657     constructor () internal {
658         _addMinter(_msgSender());
659     }
660 
661     modifier onlyMinter() {
662         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
663         _;
664     }
665 
666     function isMinter(address account) public view returns (bool) {
667         return _minters.has(account);
668     }
669 
670     function addMinter(address account) public onlyMinter {
671         _addMinter(account);
672     }
673 
674     function renounceMinter() public {
675         _removeMinter(_msgSender());
676     }
677 
678     function _addMinter(address account) internal {
679         _minters.add(account);
680         emit MinterAdded(account);
681     }
682 
683     function _removeMinter(address account) internal {
684         _minters.remove(account);
685         emit MinterRemoved(account);
686     }
687 }
688 
689 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
690 
691 pragma solidity ^0.5.0;
692 
693 
694 
695 /**
696  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
697  * which have permission to mint (create) new tokens as they see fit.
698  *
699  * At construction, the deployer of the contract is the only minter.
700  */
701 contract ERC20Mintable is ERC20, MinterRole {
702     /**
703      * @dev See {ERC20-_mint}.
704      *
705      * Requirements:
706      *
707      * - the caller must have the {MinterRole}.
708      */
709     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
710         _mint(account, amount);
711         return true;
712     }
713 }
714 
715 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
716 
717 pragma solidity ^0.5.0;
718 
719 
720 /**
721  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
722  */
723 contract ERC20Capped is ERC20Mintable {
724     uint256 private _cap;
725 
726     /**
727      * @dev Sets the value of the `cap`. This value is immutable, it can only be
728      * set once during construction.
729      */
730     constructor (uint256 cap) public {
731         require(cap > 0, "ERC20Capped: cap is 0");
732         _cap = cap;
733     }
734 
735     /**
736      * @dev Returns the cap on the token's total supply.
737      */
738     function cap() public view returns (uint256) {
739         return _cap;
740     }
741 
742     /**
743      * @dev See {ERC20Mintable-mint}.
744      *
745      * Requirements:
746      *
747      * - `value` must not cause the total supply to go over the cap.
748      */
749     function _mint(address account, uint256 value) internal {
750         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
751         super._mint(account, value);
752     }
753 }
754 
755 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
756 
757 pragma solidity ^0.5.0;
758 
759 
760 /**
761  * @dev Optional functions from the ERC20 standard.
762  */
763 contract ERC20Detailed is IERC20 {
764     string private _name;
765     string private _symbol;
766     uint8 private _decimals;
767 
768     /**
769      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
770      * these values are immutable: they can only be set once during
771      * construction.
772      */
773     constructor (string memory name, string memory symbol, uint8 decimals) public {
774         _name = name;
775         _symbol = symbol;
776         _decimals = decimals;
777     }
778 
779     /**
780      * @dev Returns the name of the token.
781      */
782     function name() public view returns (string memory) {
783         return _name;
784     }
785 
786     /**
787      * @dev Returns the symbol of the token, usually a shorter version of the
788      * name.
789      */
790     function symbol() public view returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev Returns the number of decimals used to get its user representation.
796      * For example, if `decimals` equals `2`, a balance of `505` tokens should
797      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
798      *
799      * Tokens usually opt for a value of 18, imitating the relationship between
800      * Ether and Wei.
801      *
802      * NOTE: This information is only used for _display_ purposes: it in
803      * no way affects any of the arithmetic of the contract, including
804      * {IERC20-balanceOf} and {IERC20-transfer}.
805      */
806     function decimals() public view returns (uint8) {
807         return _decimals;
808     }
809 }
810 
811 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
812 
813 pragma solidity ^0.5.0;
814 
815 
816 
817 contract PauserRole is Context {
818     using Roles for Roles.Role;
819 
820     event PauserAdded(address indexed account);
821     event PauserRemoved(address indexed account);
822 
823     Roles.Role private _pausers;
824 
825     constructor () internal {
826         _addPauser(_msgSender());
827     }
828 
829     modifier onlyPauser() {
830         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
831         _;
832     }
833 
834     function isPauser(address account) public view returns (bool) {
835         return _pausers.has(account);
836     }
837 
838     function addPauser(address account) public onlyPauser {
839         _addPauser(account);
840     }
841 
842     function renouncePauser() public {
843         _removePauser(_msgSender());
844     }
845 
846     function _addPauser(address account) internal {
847         _pausers.add(account);
848         emit PauserAdded(account);
849     }
850 
851     function _removePauser(address account) internal {
852         _pausers.remove(account);
853         emit PauserRemoved(account);
854     }
855 }
856 
857 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
858 
859 pragma solidity ^0.5.0;
860 
861 
862 
863 /**
864  * @dev Contract module which allows children to implement an emergency stop
865  * mechanism that can be triggered by an authorized account.
866  *
867  * This module is used through inheritance. It will make available the
868  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
869  * the functions of your contract. Note that they will not be pausable by
870  * simply including this module, only once the modifiers are put in place.
871  */
872 contract Pausable is Context, PauserRole {
873     /**
874      * @dev Emitted when the pause is triggered by a pauser (`account`).
875      */
876     event Paused(address account);
877 
878     /**
879      * @dev Emitted when the pause is lifted by a pauser (`account`).
880      */
881     event Unpaused(address account);
882 
883     bool private _paused;
884 
885     /**
886      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
887      * to the deployer.
888      */
889     constructor () internal {
890         _paused = false;
891     }
892 
893     /**
894      * @dev Returns true if the contract is paused, and false otherwise.
895      */
896     function paused() public view returns (bool) {
897         return _paused;
898     }
899 
900     /**
901      * @dev Modifier to make a function callable only when the contract is not paused.
902      */
903     modifier whenNotPaused() {
904         require(!_paused, "Pausable: paused");
905         _;
906     }
907 
908     /**
909      * @dev Modifier to make a function callable only when the contract is paused.
910      */
911     modifier whenPaused() {
912         require(_paused, "Pausable: not paused");
913         _;
914     }
915 
916     /**
917      * @dev Called by a pauser to pause, triggers stopped state.
918      */
919     function pause() public onlyPauser whenNotPaused {
920         _paused = true;
921         emit Paused(_msgSender());
922     }
923 
924     /**
925      * @dev Called by a pauser to unpause, returns to normal state.
926      */
927     function unpause() public onlyPauser whenPaused {
928         _paused = false;
929         emit Unpaused(_msgSender());
930     }
931 }
932 
933 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
934 
935 pragma solidity ^0.5.0;
936 
937 
938 
939 /**
940  * @title Pausable token
941  * @dev ERC20 with pausable transfers and allowances.
942  *
943  * Useful if you want to stop trades until the end of a crowdsale, or have
944  * an emergency switch for freezing all token transfers in the event of a large
945  * bug.
946  */
947 contract ERC20Pausable is ERC20, Pausable {
948     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
949         return super.transfer(to, value);
950     }
951 
952     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
953         return super.transferFrom(from, to, value);
954     }
955 
956     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
957         return super.approve(spender, value);
958     }
959 
960     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
961         return super.increaseAllowance(spender, addedValue);
962     }
963 
964     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
965         return super.decreaseAllowance(spender, subtractedValue);
966     }
967 }
968 
969 // File: contracts/Token.sol
970 
971 pragma solidity >=0.4.21 <0.6.0;
972 
973 
974 
975 
976 
977 
978 /**
979  * @title Token
980  * @dev A token that enables paying timely dividends to whitelisted token holder accounts
981  */
982 
983 contract Token is WhitelistedRole, ERC20Capped, ERC20Detailed, ERC20Pausable {
984     using SafeMath for uint256;
985 
986     uint8 private _decimals = 18;
987     uint256 private _initialSupply = 300_000_000e18;
988     uint256 private _maxSupply = 100_000_000_000e18;
989     
990     /**
991      * @dev Last time tick for an address (for time-dependent ROI calculation).
992      */
993     mapping (address=>uint256) private _lastTicked;
994 
995     /**
996      * @dev Constructor that gives msg.sender the initial token supply.
997      * @param name The deployed token name.
998      * @param symbol The deployed token symbol.
999      */
1000     constructor (string memory name, string memory symbol)
1001         ERC20Detailed(name, symbol, _decimals)
1002         ERC20Capped(_maxSupply)
1003         public
1004     {
1005         mint(msg.sender, _initialSupply);
1006     }
1007 
1008     /**
1009     * @dev A method to add a token holder account to the whitelist.
1010     * @param account The address to add.
1011     */
1012     function addWhitelisted(address account) public onlyWhitelistAdmin {
1013         super.addWhitelisted(account);
1014         _lastTicked[account] = now;
1015     }
1016 
1017     /**
1018     * @dev A method to remove a token holder account from the whitelist.
1019     * @notice It gives the dividend amount due for the holder before
1020     * removing it from the whitelist.
1021     * @param account The address to remove.
1022     */
1023     function removeWhitelisted(address account) public onlyWhitelistAdmin {
1024         giveDividend(account);
1025         super.removeWhitelisted(account);
1026         delete _lastTicked[account];
1027     }
1028 
1029     /**
1030     * @dev A method to calculate time-dependent ROI due for an account.
1031     * @return uint256 The time-dependent ROI due (Monthly_ROI% x 100_000 x timeScale).
1032     */
1033     function _calculateROI(address account) private view returns(uint256) {
1034         uint256 balance = balanceOf(account);
1035         if(balance >=1e18 && balance <= 1_000e18) {
1036             return uint256(10_000).mul(now - _lastTicked[account]).div(30 days);
1037         } else if(balance >=1_001e18 && balance <= 10_000e18) {
1038             return uint256(12_000).mul(now - _lastTicked[account]).div(30 days);
1039         } else if(balance >=10_001e18 && balance <= 100_000e18) {
1040             return uint256(14_000).mul(now - _lastTicked[account]).div(30 days);
1041         } else if(balance >=100_001e18 && balance <= 1_000_000e18) {
1042             return uint256(16_000).mul(now - _lastTicked[account]).div(30 days);
1043         } else if(balance >=1_000_001e18 && balance <= 10_000_000e18) {
1044             return uint256(18_000).mul(now - _lastTicked[account]).div(30 days);
1045         } else if(balance >=10_000_001e18) {
1046             return uint256(20_000).mul(now - _lastTicked[account]).div(30 days);
1047         }
1048     }
1049 
1050     /**
1051     * @dev A method to calculate dividend for an account.
1052     * @return uint256 The token dividend amount.
1053     */
1054     function _calculateDividend(address account) private view returns(uint256) {
1055         uint256 roi_100_000 = _calculateROI(account);
1056         uint256 dividend = balanceOf(account).mul(roi_100_000).div(100_000);
1057         return dividend;
1058     }
1059 
1060     /**
1061     * @dev A method to give dividend due to a whitelisted account.
1062     * @return uint256 The token dividend amount.
1063     */
1064     function giveDividend(address account)
1065         onlyMinter
1066         whenNotPaused
1067         public
1068     {
1069         require(isWhitelisted(account), "Token: account does not have the Whitelisted role");
1070         uint256 dividend = _calculateDividend(account);
1071         mint(account, dividend);
1072         _lastTicked[account] = now;
1073     }
1074 }