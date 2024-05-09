1 pragma solidity 0.5.16;
2 
3 
4 contract ModuleKeys {
5 
6     // Governance
7     // ===========
8                                                 // Phases
9     // keccak256("Governance");                 // 2.x
10     bytes32 internal constant KEY_GOVERNANCE = 0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
11     //keccak256("Staking");                     // 1.2
12     bytes32 internal constant KEY_STAKING = 0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
13     //keccak256("ProxyAdmin");                  // 1.0
14     bytes32 internal constant KEY_PROXY_ADMIN = 0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;
15 
16     // mStable
17     // =======
18     // keccak256("OracleHub");                  // 1.2
19     bytes32 internal constant KEY_ORACLE_HUB = 0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
20     // keccak256("Manager");                    // 1.2
21     bytes32 internal constant KEY_MANAGER = 0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
22     //keccak256("Recollateraliser");            // 2.x
23     bytes32 internal constant KEY_RECOLLATERALISER = 0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
24     //keccak256("MetaToken");                   // 1.1
25     bytes32 internal constant KEY_META_TOKEN = 0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
26     // keccak256("SavingsManager");             // 1.0
27     bytes32 internal constant KEY_SAVINGS_MANAGER = 0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
28 }
29 
30 interface INexus {
31     function governor() external view returns (address);
32     function getModule(bytes32 key) external view returns (address);
33 
34     function proposeModule(bytes32 _key, address _addr) external;
35     function cancelProposedModule(bytes32 _key) external;
36     function acceptProposedModule(bytes32 _key) external;
37     function acceptProposedModules(bytes32[] calldata _keys) external;
38 
39     function requestLockModule(bytes32 _key) external;
40     function cancelLockModule(bytes32 _key) external;
41     function lockModule(bytes32 _key) external;
42 }
43 
44 contract Module is ModuleKeys {
45 
46     INexus public nexus;
47 
48     /**
49      * @dev Initialises the Module by setting publisher addresses,
50      *      and reading all available system module information
51      */
52     constructor(address _nexus) internal {
53         require(_nexus != address(0), "Nexus is zero address");
54         nexus = INexus(_nexus);
55     }
56 
57     /**
58      * @dev Modifier to allow function calls only from the Governor.
59      */
60     modifier onlyGovernor() {
61         require(msg.sender == _governor(), "Only governor can execute");
62         _;
63     }
64 
65     /**
66      * @dev Modifier to allow function calls only from the Governance.
67      *      Governance is either Governor address or Governance address.
68      */
69     modifier onlyGovernance() {
70         require(
71             msg.sender == _governor() || msg.sender == _governance(),
72             "Only governance can execute"
73         );
74         _;
75     }
76 
77     /**
78      * @dev Modifier to allow function calls only from the ProxyAdmin.
79      */
80     modifier onlyProxyAdmin() {
81         require(
82             msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
83         );
84         _;
85     }
86 
87     /**
88      * @dev Modifier to allow function calls only from the Manager.
89      */
90     modifier onlyManager() {
91         require(msg.sender == _manager(), "Only manager can execute");
92         _;
93     }
94 
95     /**
96      * @dev Returns Governor address from the Nexus
97      * @return Address of Governor Contract
98      */
99     function _governor() internal view returns (address) {
100         return nexus.governor();
101     }
102 
103     /**
104      * @dev Returns Governance Module address from the Nexus
105      * @return Address of the Governance (Phase 2)
106      */
107     function _governance() internal view returns (address) {
108         return nexus.getModule(KEY_GOVERNANCE);
109     }
110 
111     /**
112      * @dev Return Staking Module address from the Nexus
113      * @return Address of the Staking Module contract
114      */
115     function _staking() internal view returns (address) {
116         return nexus.getModule(KEY_STAKING);
117     }
118 
119     /**
120      * @dev Return ProxyAdmin Module address from the Nexus
121      * @return Address of the ProxyAdmin Module contract
122      */
123     function _proxyAdmin() internal view returns (address) {
124         return nexus.getModule(KEY_PROXY_ADMIN);
125     }
126 
127     /**
128      * @dev Return MetaToken Module address from the Nexus
129      * @return Address of the MetaToken Module contract
130      */
131     function _metaToken() internal view returns (address) {
132         return nexus.getModule(KEY_META_TOKEN);
133     }
134 
135     /**
136      * @dev Return OracleHub Module address from the Nexus
137      * @return Address of the OracleHub Module contract
138      */
139     function _oracleHub() internal view returns (address) {
140         return nexus.getModule(KEY_ORACLE_HUB);
141     }
142 
143     /**
144      * @dev Return Manager Module address from the Nexus
145      * @return Address of the Manager Module contract
146      */
147     function _manager() internal view returns (address) {
148         return nexus.getModule(KEY_MANAGER);
149     }
150 
151     /**
152      * @dev Return SavingsManager Module address from the Nexus
153      * @return Address of the SavingsManager Module contract
154      */
155     function _savingsManager() internal view returns (address) {
156         return nexus.getModule(KEY_SAVINGS_MANAGER);
157     }
158 
159     /**
160      * @dev Return Recollateraliser Module address from the Nexus
161      * @return  Address of the Recollateraliser Module contract (Phase 2)
162      */
163     function _recollateraliser() internal view returns (address) {
164         return nexus.getModule(KEY_RECOLLATERALISER);
165     }
166 }
167 
168 /*
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with GSN meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 contract Context {
179     // Empty internal constructor, to prevent people from mistakenly deploying
180     // an instance of this contract, which should be used via inheritance.
181     constructor () internal { }
182     // solhint-disable-previous-line no-empty-blocks
183 
184     function _msgSender() internal view returns (address payable) {
185         return msg.sender;
186     }
187 
188     function _msgData() internal view returns (bytes memory) {
189         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
190         return msg.data;
191     }
192 }
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
196  * the optional functions; to access them see {ERC20Detailed}.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 /**
270  * @dev Wrappers over Solidity's arithmetic operations with added overflow
271  * checks.
272  *
273  * Arithmetic operations in Solidity wrap on overflow. This can easily result
274  * in bugs, because programmers usually assume that an overflow raises an
275  * error, which is the standard behavior in high level programming languages.
276  * `SafeMath` restores this intuition by reverting the transaction when an
277  * operation overflows.
278  *
279  * Using this library instead of the unchecked operations eliminates an entire
280  * class of bugs, so it's recommended to use it always.
281  */
282 library SafeMath {
283     /**
284      * @dev Returns the addition of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `+` operator.
288      *
289      * Requirements:
290      * - Addition cannot overflow.
291      */
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         uint256 c = a + b;
294         require(c >= a, "SafeMath: addition overflow");
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      * - Subtraction cannot overflow.
307      */
308     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309         return sub(a, b, "SafeMath: subtraction overflow");
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      * - Subtraction cannot overflow.
320      *
321      * _Available since v2.4.0._
322      */
323     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b <= a, errorMessage);
325         uint256 c = a - b;
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the multiplication of two unsigned integers, reverting on
332      * overflow.
333      *
334      * Counterpart to Solidity's `*` operator.
335      *
336      * Requirements:
337      * - Multiplication cannot overflow.
338      */
339     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
340         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341         // benefit is lost if 'b' is also tested.
342         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
343         if (a == 0) {
344             return 0;
345         }
346 
347         uint256 c = a * b;
348         require(c / a == b, "SafeMath: multiplication overflow");
349 
350         return c;
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers. Reverts on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator. Note: this function uses a
358      * `revert` opcode (which leaves remaining gas untouched) while Solidity
359      * uses an invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      * - The divisor cannot be zero.
363      */
364     function div(uint256 a, uint256 b) internal pure returns (uint256) {
365         return div(a, b, "SafeMath: division by zero");
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      * - The divisor cannot be zero.
378      *
379      * _Available since v2.4.0._
380      */
381     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
382         // Solidity only automatically asserts when dividing by 0
383         require(b > 0, errorMessage);
384         uint256 c = a / b;
385         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
386 
387         return c;
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * Reverts when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      * - The divisor cannot be zero.
400      */
401     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
402         return mod(a, b, "SafeMath: modulo by zero");
403     }
404 
405     /**
406      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
407      * Reverts with custom message when dividing by zero.
408      *
409      * Counterpart to Solidity's `%` operator. This function uses a `revert`
410      * opcode (which leaves remaining gas untouched) while Solidity uses an
411      * invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      * - The divisor cannot be zero.
415      *
416      * _Available since v2.4.0._
417      */
418     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
419         require(b != 0, errorMessage);
420         return a % b;
421     }
422 }
423 
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426 
427     mapping (address => uint256) private _balances;
428 
429     mapping (address => mapping (address => uint256)) private _allowances;
430 
431     uint256 private _totalSupply;
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view returns (uint256) {
437         return _totalSupply;
438     }
439 
440     /**
441      * @dev See {IERC20-balanceOf}.
442      */
443     function balanceOf(address account) public view returns (uint256) {
444         return _balances[account];
445     }
446 
447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `recipient` cannot be the zero address.
453      * - the caller must have a balance of at least `amount`.
454      */
455     function transfer(address recipient, uint256 amount) public returns (bool) {
456         _transfer(_msgSender(), recipient, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-allowance}.
462      */
463     function allowance(address owner, address spender) public view returns (uint256) {
464         return _allowances[owner][spender];
465     }
466 
467     /**
468      * @dev See {IERC20-approve}.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function approve(address spender, uint256 amount) public returns (bool) {
475         _approve(_msgSender(), spender, amount);
476         return true;
477     }
478 
479     /**
480      * @dev See {IERC20-transferFrom}.
481      *
482      * Emits an {Approval} event indicating the updated allowance. This is not
483      * required by the EIP. See the note at the beginning of {ERC20};
484      *
485      * Requirements:
486      * - `sender` and `recipient` cannot be the zero address.
487      * - `sender` must have a balance of at least `amount`.
488      * - the caller must have allowance for `sender`'s tokens of at least
489      * `amount`.
490      */
491     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
492         _transfer(sender, recipient, amount);
493         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically increases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      */
509     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
511         return true;
512     }
513 
514     /**
515      * @dev Atomically decreases the allowance granted to `spender` by the caller.
516      *
517      * This is an alternative to {approve} that can be used as a mitigation for
518      * problems described in {IERC20-approve}.
519      *
520      * Emits an {Approval} event indicating the updated allowance.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      * - `spender` must have allowance for the caller of at least
526      * `subtractedValue`.
527      */
528     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
530         return true;
531     }
532 
533     /**
534      * @dev Moves tokens `amount` from `sender` to `recipient`.
535      *
536      * This is internal function is equivalent to {transfer}, and can be used to
537      * e.g. implement automatic token fees, slashing mechanisms, etc.
538      *
539      * Emits a {Transfer} event.
540      *
541      * Requirements:
542      *
543      * - `sender` cannot be the zero address.
544      * - `recipient` cannot be the zero address.
545      * - `sender` must have a balance of at least `amount`.
546      */
547     function _transfer(address sender, address recipient, uint256 amount) internal {
548         require(sender != address(0), "ERC20: transfer from the zero address");
549         require(recipient != address(0), "ERC20: transfer to the zero address");
550 
551         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
552         _balances[recipient] = _balances[recipient].add(amount);
553         emit Transfer(sender, recipient, amount);
554     }
555 
556     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
557      * the total supply.
558      *
559      * Emits a {Transfer} event with `from` set to the zero address.
560      *
561      * Requirements
562      *
563      * - `to` cannot be the zero address.
564      */
565     function _mint(address account, uint256 amount) internal {
566         require(account != address(0), "ERC20: mint to the zero address");
567 
568         _totalSupply = _totalSupply.add(amount);
569         _balances[account] = _balances[account].add(amount);
570         emit Transfer(address(0), account, amount);
571     }
572 
573     /**
574      * @dev Destroys `amount` tokens from `account`, reducing the
575      * total supply.
576      *
577      * Emits a {Transfer} event with `to` set to the zero address.
578      *
579      * Requirements
580      *
581      * - `account` cannot be the zero address.
582      * - `account` must have at least `amount` tokens.
583      */
584     function _burn(address account, uint256 amount) internal {
585         require(account != address(0), "ERC20: burn from the zero address");
586 
587         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
588         _totalSupply = _totalSupply.sub(amount);
589         emit Transfer(account, address(0), amount);
590     }
591 
592     /**
593      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
594      *
595      * This is internal function is equivalent to `approve`, and can be used to
596      * e.g. set automatic allowances for certain subsystems, etc.
597      *
598      * Emits an {Approval} event.
599      *
600      * Requirements:
601      *
602      * - `owner` cannot be the zero address.
603      * - `spender` cannot be the zero address.
604      */
605     function _approve(address owner, address spender, uint256 amount) internal {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608 
609         _allowances[owner][spender] = amount;
610         emit Approval(owner, spender, amount);
611     }
612 
613     /**
614      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
615      * from the caller's allowance.
616      *
617      * See {_burn} and {_approve}.
618      */
619     function _burnFrom(address account, uint256 amount) internal {
620         _burn(account, amount);
621         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
622     }
623 }
624 
625 library Roles {
626     struct Role {
627         mapping (address => bool) bearer;
628     }
629 
630     /**
631      * @dev Give an account access to this role.
632      */
633     function add(Role storage role, address account) internal {
634         require(!has(role, account), "Roles: account already has role");
635         role.bearer[account] = true;
636     }
637 
638     /**
639      * @dev Remove an account's access to this role.
640      */
641     function remove(Role storage role, address account) internal {
642         require(has(role, account), "Roles: account does not have role");
643         role.bearer[account] = false;
644     }
645 
646     /**
647      * @dev Check if an account has this role.
648      * @return bool
649      */
650     function has(Role storage role, address account) internal view returns (bool) {
651         require(account != address(0), "Roles: account is the zero address");
652         return role.bearer[account];
653     }
654 }
655 
656 contract GovernedMinterRole is Module {
657 
658     using Roles for Roles.Role;
659 
660     event MinterAdded(address indexed account);
661     event MinterRemoved(address indexed account);
662 
663     Roles.Role private _minters;
664 
665     constructor(address _nexus) internal Module(_nexus) {
666     }
667 
668     modifier onlyMinter() {
669         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
670         _;
671     }
672 
673     function isMinter(address account) public view returns (bool) {
674         return _minters.has(account);
675     }
676 
677     function addMinter(address account) public onlyGovernor {
678         _addMinter(account);
679     }
680 
681     function removeMinter(address account) public onlyGovernor {
682         _removeMinter(account);
683     }
684 
685     function renounceMinter() public {
686         _removeMinter(msg.sender);
687     }
688 
689     function _addMinter(address account) internal {
690         _minters.add(account);
691         emit MinterAdded(account);
692     }
693 
694     function _removeMinter(address account) internal {
695         _minters.remove(account);
696         emit MinterRemoved(account);
697     }
698 }
699 
700 contract ERC20Detailed is IERC20 {
701     string private _name;
702     string private _symbol;
703     uint8 private _decimals;
704 
705     /**
706      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
707      * these values are immutable: they can only be set once during
708      * construction.
709      */
710     constructor (string memory name, string memory symbol, uint8 decimals) public {
711         _name = name;
712         _symbol = symbol;
713         _decimals = decimals;
714     }
715 
716     /**
717      * @dev Returns the name of the token.
718      */
719     function name() public view returns (string memory) {
720         return _name;
721     }
722 
723     /**
724      * @dev Returns the symbol of the token, usually a shorter version of the
725      * name.
726      */
727     function symbol() public view returns (string memory) {
728         return _symbol;
729     }
730 
731     /**
732      * @dev Returns the number of decimals used to get its user representation.
733      * For example, if `decimals` equals `2`, a balance of `505` tokens should
734      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
735      *
736      * Tokens usually opt for a value of 18, imitating the relationship between
737      * Ether and Wei.
738      *
739      * NOTE: This information is only used for _display_ purposes: it in
740      * no way affects any of the arithmetic of the contract, including
741      * {IERC20-balanceOf} and {IERC20-transfer}.
742      */
743     function decimals() public view returns (uint8) {
744         return _decimals;
745     }
746 }
747 
748 /**
749  * @dev Implementation of the {IERC20} interface.
750  *
751  * This implementation is agnostic to the way tokens are created. This means
752  * that a supply mechanism has to be added in a derived contract using {_mint}.
753  * For a generic mechanism see {ERC20Mintable}.
754  *
755  * TIP: For a detailed writeup see our guide
756  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
757  * to implement supply mechanisms].
758  *
759  * We have followed general OpenZeppelin guidelines: functions revert instead
760  * of returning `false` on failure. This behavior is nonetheless conventional
761  * and does not conflict with the expectations of ERC20 applications.
762  *
763  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
764  * This allows applications to reconstruct the allowance for all accounts just
765  * by listening to said events. Other implementations of the EIP may not emit
766  * these events, as it isn't required by the specification.
767  *
768  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
769  * functions have been added to mitigate the well-known issues around setting
770  * allowances. See {IERC20-approve}.
771  */
772 
773 contract ERC20Burnable is Context, ERC20 {
774     /**
775      * @dev Destroys `amount` tokens from the caller.
776      *
777      * See {ERC20-_burn}.
778      */
779     function burn(uint256 amount) public {
780         _burn(_msgSender(), amount);
781     }
782 
783     /**
784      * @dev See {ERC20-_burnFrom}.
785      */
786     function burnFrom(address account, uint256 amount) public {
787         _burnFrom(account, amount);
788     }
789 }
790 
791 /**
792  * @title  MetaToken
793  * @dev    MetaToken is an ERC20 token, with mint privileges governed by mStable
794  * governors
795  */
796 contract MetaToken is
797     ERC20,
798     GovernedMinterRole,
799     ERC20Detailed,
800     ERC20Burnable
801 {
802 
803     /**
804      * @dev MetaToken simply implements a detailed ERC20 token,
805      * and a governed list of minters
806      */
807     constructor(
808         address _nexus,
809         address _initialRecipient
810     )
811         public
812         GovernedMinterRole(_nexus)
813         ERC20Detailed(
814             "Meta",
815             "MTA",
816             18
817         )
818     {
819         // 100m initial supply
820         _mint(_initialRecipient, 100000000 * (10 ** 18));
821     }
822 
823     // Forked from @openzeppelin
824     /**
825      * @dev See {ERC20-_mint}.
826      *
827      * Requirements:
828      *
829      * - the caller must have the {MinterRole}.
830      */
831     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
832         _mint(account, amount);
833         return true;
834     }
835 }