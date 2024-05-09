1 pragma solidity ^0.6.1;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
56      * @dev Get it via `npm install @openzeppelin/contracts@next`.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
114      * @dev Get it via `npm install @openzeppelin/contracts@next`.
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
152      * @dev Get it via `npm install @openzeppelin/contracts@next`.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 library Roles {
161     struct Role {
162         mapping (address => bool) bearer;
163     }
164 
165     /**
166      * @dev Give an account access to this role.
167      */
168     function add(Role storage role, address account) internal {
169         require(!has(role, account), "Roles: account already has role");
170         role.bearer[account] = true;
171     }
172 
173     /**
174      * @dev Remove an account's access to this role.
175      */
176     function remove(Role storage role, address account) internal {
177         require(has(role, account), "Roles: account does not have role");
178         role.bearer[account] = false;
179     }
180 
181     /**
182      * @dev Check if an account has this role.
183      * @return bool
184      */
185     function has(Role storage role, address account) internal view returns (bool) {
186         require(account != address(0), "Roles: account is the zero address");
187         return role.bearer[account];
188     }
189 }
190 
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 contract Context {
202     // Empty internal constructor, to prevent people from mistakenly deploying
203     // an instance of this contract, which should be used via inheritance.
204     constructor () internal { }
205     // solhint-disable-previous-line no-empty-blocks
206 
207     function _msgSender() internal view returns (address payable) {
208         return msg.sender;
209     }
210 
211     function _msgData() internal view returns (bytes memory) {
212         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
213         return msg.data;
214     }
215 }
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
219  * the optional functions; to access them see {ERC20Detailed}.
220  */
221 interface IERC20 {
222     /**
223      * @dev Returns the amount of tokens in existence.
224      */
225     function totalSupply() external view returns (uint256);
226 
227     /**
228      * @dev Returns the amount of tokens owned by `account`.
229      */
230     function balanceOf(address account) external view returns (uint256);
231 
232     /**
233      * @dev Moves `amount` tokens from the caller's account to `recipient`.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transfer(address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Returns the remaining number of tokens that `spender` will be
243      * allowed to spend on behalf of `owner` through {transferFrom}. This is
244      * zero by default.
245      *
246      * This value changes when {approve} or {transferFrom} are called.
247      */
248     function allowance(address owner, address spender) external view returns (uint256);
249 
250     /**
251      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * IMPORTANT: Beware that changing an allowance with this method brings the risk
256      * that someone may use both the old and the new allowance by unfortunate
257      * transaction ordering. One possible solution to mitigate this race
258      * condition is to first reduce the spender's allowance to 0 and set the
259      * desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address spender, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Moves `amount` tokens from `sender` to `recipient` using the
268      * allowance mechanism. `amount` is then deducted from the caller's
269      * allowance.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
276 
277     /**
278      * @dev Emitted when `value` tokens are moved from one account (`from`) to
279      * another (`to`).
280      *
281      * Note that `value` may be zero.
282      */
283     event Transfer(address indexed from, address indexed to, uint256 value);
284 
285     /**
286      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
287      * a call to {approve}. `value` is the new allowance.
288      */
289     event Approval(address indexed owner, address indexed spender, uint256 value);
290 }
291 
292 
293 /**
294  * @dev Contract module which provides a basic access control mechanism, where
295  * there is an account (an owner) that can be granted exclusive access to
296  * specific functions.
297  *
298  * This module is used through inheritance. It will make available the modifier
299  * `onlyOwner`, which can be applied to your functions to restrict their use to
300  * the owner.
301  */
302 contract Ownable is Context {
303     address private _owner;
304 
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     /**
308      * @dev Initializes the contract setting the deployer as the initial owner.
309      */
310     constructor () internal {
311         address msgSender = _msgSender();
312         _owner = msgSender;
313         emit OwnershipTransferred(address(0), msgSender);
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if called by any account other than the owner.
325      */
326     modifier onlyOwner() {
327         require(isOwner(), "Ownable: caller is not the owner");
328         _;
329     }
330 
331     /**
332      * @dev Returns true if the caller is the current owner.
333      */
334     function isOwner() public view returns (bool) {
335         return _msgSender() == _owner;
336     }
337 
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         _transferOwnership(newOwner);
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      */
350     function _transferOwnership(address newOwner) internal virtual {
351         require(newOwner != address(0), "Ownable: new owner is the zero address");
352         emit OwnershipTransferred(_owner, newOwner);
353         _owner = newOwner;
354     }
355 }
356 
357 contract PauserRole is Context, Ownable {
358     using Roles for Roles.Role;
359 
360     event PauserAdded(address indexed account);
361     event PauserRemoved(address indexed account);
362 
363     Roles.Role private _pausers;
364 
365     constructor () internal {
366         _addPauser(_msgSender());
367     }
368 
369     modifier onlyPauser() {
370         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
371         _;
372     }
373 
374     function isPauser(address account) public view returns (bool) {
375         return _pausers.has(account);
376     }
377 
378     function addPauser(address account) public onlyOwner {
379         _addPauser(account);
380     }
381 
382     function renouncePauser() public {
383         _removePauser(_msgSender());
384     }
385 
386     function _addPauser(address account) internal {
387         _pausers.add(account);
388         emit PauserAdded(account);
389     }
390 
391     function _removePauser(address account) internal {
392         _pausers.remove(account);
393         emit PauserRemoved(account);
394     }
395 }
396 
397 contract ExchangeRole is Context, Ownable {
398     using Roles for Roles.Role;
399 
400     event ExchangeAdded(address indexed account);
401     event ExchangeRemoved(address indexed account);
402 
403     Roles.Role private _exchanges;
404 
405     constructor () internal {
406         _addExchange(_msgSender());
407     }
408 
409     modifier onlyExchange() {
410         require(isExchange(_msgSender()), "ExchangeRole: caller does not have the Exchange role");
411         _;
412     }
413 
414     function isExchange(address account) public view returns (bool) {
415         return _exchanges.has(account);
416     }
417 
418     function addExchange(address account) public onlyOwner {
419         _addExchange(account);
420     }
421 
422     function renounceExchange() public {
423         _removeExchange(_msgSender());
424     }
425 
426     function _addExchange(address account) internal {
427         _exchanges.add(account);
428         emit ExchangeAdded(account);
429     }
430 
431     function _removeExchange(address account) internal {
432         _exchanges.remove(account);
433         emit ExchangeRemoved(account);
434     }
435 }
436 
437 contract LockedWallets is Context {
438     
439     address internal constant lockedWallet = 0xf8Fab9fa6C154bd2A59035283AD508705aa49641; 
440     uint256 internal constant _releaseTime = 1619827200;
441     
442     
443     modifier notLockedWallet() {
444         require(_msgSender() != lockedWallet || _releaseTime < block.timestamp, "This wallet is locked");
445         _;
446     }
447     
448     function unlockTime() public pure returns (uint256) {
449         return _releaseTime;
450     }
451     
452 } 
453 
454 /**
455  * @dev Contract module which allows children to implement an emergency stop
456  * mechanism that can be triggered by an authorized account.
457  *
458  * This module is used through inheritance. It will make available the
459  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
460  * the functions of your contract. Note that they will not be pausable by
461  * simply including this module, only once the modifiers are put in place.
462  */
463 contract Pausable is Context, PauserRole, ExchangeRole {
464     /**
465      * @dev Emitted when the pause is triggered by a pauser (`account`).
466      */
467     event Paused(address account);
468 
469     /**
470      * @dev Emitted when the pause is lifted by a pauser (`account`).
471      */
472     event Unpaused(address account);
473 
474     bool private _paused;
475 
476     /**
477      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
478      * to the deployer.
479      */
480     constructor () internal {
481         _paused = false;
482     }
483 
484     /**
485      * @dev Returns true if the contract is paused, and false otherwise.
486      */
487     function paused() public view returns (bool) {
488         return _paused;
489     }
490 
491     /**
492      * @dev Modifier to make a function callable only when the contract is not paused.
493      */
494     modifier whenNotPaused() {
495         require(!_paused || isExchange(_msgSender()), "Pausable: paused");
496         //require(!_paused, "Pausable: paused");
497         _;
498     }
499 
500     /**
501      * @dev Modifier to make a function callable only when the contract is paused.
502      */
503     modifier whenPaused() {
504         require(_paused, "Pausable: not paused");
505         _;
506     }
507     
508 
509     /**
510      * @dev Called by a pauser to pause, triggers stopped state.
511      */
512     function pause() public onlyPauser whenNotPaused {
513         _paused = true;
514         emit Paused(_msgSender());
515     }
516 
517     /**
518      * @dev Called by a pauser to unpause, returns to normal state.
519      */
520     function unpause() public onlyPauser whenPaused {
521         _paused = false;
522         emit Unpaused(_msgSender());
523     }
524 }
525 
526 /**
527  * @dev Implementation of the {IERC20} interface.
528  *
529  * This implementation is agnostic to the way tokens are created. This means
530  * that a supply mechanism has to be added in a derived contract using {_mint}.
531  * For a generic mechanism see {ERC20Mintable}.
532  *
533  * TIP: For a detailed writeup see our guide
534  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
535  * to implement supply mechanisms].
536  *
537  * We have followed general OpenZeppelin guidelines: functions revert instead
538  * of returning `false` on failure. This behavior is nonetheless conventional
539  * and does not conflict with the expectations of ERC20 applications.
540  *
541  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
542  * This allows applications to reconstruct the allowance for all accounts just
543  * by listening to said events. Other implementations of the EIP may not emit
544  * these events, as it isn't required by the specification.
545  *
546  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
547  * functions have been added to mitigate the well-known issues around setting
548  * allowances. See {IERC20-approve}.
549  */
550 contract ERC20 is IERC20, Pausable, LockedWallets  {
551     using SafeMath for uint256;
552 
553     mapping (address => uint256) private _balances;
554 
555     mapping (address => mapping (address => uint256)) private _allowances;
556 
557     uint256 private _totalSupply;
558     
559     constructor() internal {
560         uint256 crowdsaleSupply = 186000000 * 10 ** uint256(18);
561         uint256 lockedSupply = 114000000 * 10 ** uint256(18);
562         _totalSupply = crowdsaleSupply + lockedSupply;
563         _balances[lockedWallet] = lockedSupply;
564         _balances[_msgSender()] = crowdsaleSupply;
565     }
566     
567   
568 
569     /**
570      * @dev See {IERC20-totalSupply}.
571      */
572     function totalSupply() public view override returns (uint256) {
573         return _totalSupply;
574     }
575 
576     /**
577      * @dev See {IERC20-balanceOf}.
578      */
579     function balanceOf(address account) public view override returns (uint256) {
580         return _balances[account];
581     }
582 
583     /**
584      * @dev See {IERC20-transfer}.
585      *
586      * Requirements:
587      *
588      * - `recipient` cannot be the zero address.
589      * - the caller must have a balance of at least `amount`.
590      */
591     function transfer(address recipient, uint256 amount) whenNotPaused notLockedWallet public override returns (bool) {
592         _transfer(_msgSender(), recipient, amount);
593         return true;
594     }
595 
596    /**
597      * @dev See {IERC20-allowance}.
598      */
599     function allowance(address owner, address spender) public view virtual override returns (uint256) {
600         return _allowances[owner][spender];
601     }
602 
603     /**
604      * @dev See {IERC20-approve}.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      */
610     function approve(address spender, uint256 amount) public virtual override returns (bool) {
611         _approve(_msgSender(), spender, amount);
612         return true;
613     }
614 
615     /**
616      * @dev See {IERC20-transferFrom}.
617      *
618      * Emits an {Approval} event indicating the updated allowance. This is not
619      * required by the EIP. See the note at the beginning of {ERC20};
620      *
621      * Requirements:
622      * - `sender` and `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      * - the caller must have allowance for `sender`'s tokens of at least
625      * `amount`.
626      */
627     function transferFrom(address sender, address recipient, uint256 amount) whenNotPaused notLockedWallet public virtual override returns (bool) {
628         _transfer(sender, recipient, amount);
629         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
630         return true;
631     }
632 
633     /**
634      * @dev Atomically increases the allowance granted to `spender` by the caller.
635      *
636      * This is an alternative to {approve} that can be used as a mitigation for
637      * problems described in {IERC20-approve}.
638      *
639      * Emits an {Approval} event indicating the updated allowance.
640      *
641      * Requirements:
642      *
643      * - `spender` cannot be the zero address.
644      */
645     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
646         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
647         return true;
648     }
649 
650     /**
651      * @dev Atomically decreases the allowance granted to `spender` by the caller.
652      *
653      * This is an alternative to {approve} that can be used as a mitigation for
654      * problems described in {IERC20-approve}.
655      *
656      * Emits an {Approval} event indicating the updated allowance.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      * - `spender` must have allowance for the caller of at least
662      * `subtractedValue`.
663      */
664     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
665         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
666         return true;
667     }
668 
669     /**
670      * @dev Moves tokens `amount` from `sender` to `recipient`.
671      *
672      * This is internal function is equivalent to {transfer}, and can be used to
673      * e.g. implement automatic token fees, slashing mechanisms, etc.
674      *
675      * Emits a {Transfer} event.
676      *
677      * Requirements:
678      *
679      * - `sender` cannot be the zero address.
680      * - `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      */
683     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
684         require(sender != address(0), "ERC20: transfer from the zero address");
685         require(recipient != address(0), "ERC20: transfer to the zero address");
686 
687         _beforeTokenTransfer(sender, recipient, amount);
688 
689         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
690         _balances[recipient] = _balances[recipient].add(amount);
691         emit Transfer(sender, recipient, amount);
692     }
693 
694 
695     /**
696      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
697      *
698      * This is internal function is equivalent to `approve`, and can be used to
699      * e.g. set automatic allowances for certain subsystems, etc.
700      *
701      * Emits an {Approval} event.
702      *
703      * Requirements:
704      *
705      * - `owner` cannot be the zero address.
706      * - `spender` cannot be the zero address.
707      */
708     function _approve(address owner, address spender, uint256 amount) internal virtual {
709         require(owner != address(0), "ERC20: approve from the zero address");
710         require(spender != address(0), "ERC20: approve to the zero address");
711 
712         _allowances[owner][spender] = amount;
713         emit Approval(owner, spender, amount);
714     }
715 
716     /**
717      * @dev Hook that is called before any transfer of tokens. This includes
718      * minting and burning.
719      *
720      * Calling conditions:
721      *
722      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
723      * will be to transferred to `to`.
724      * - when `from` is zero, `amount` tokens will be minted for `to`.
725      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
726      * - `from` and `to` are never both zero.
727      *
728      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
729      */
730     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
731 }
732 
733 /**
734  * @dev Optional functions from the ERC20 standard.
735  */
736 contract CryptoDailyToken is ERC20 {
737     string private _name = "Crypto Daily Token";
738     string private _symbol = "CRDT";
739     uint8 private _decimals = 18;
740     
741     
742     /**
743      * @dev Returns the name of the token.
744      */
745     function name() public view returns (string memory) {
746         return _name;
747     }
748 
749     /**
750      * @dev Returns the symbol of the token, usually a shorter version of the
751      * name.
752      */
753     function symbol() public view returns (string memory) {
754         return _symbol;
755     }
756 
757     /**
758      * @dev Returns the number of decimals used to get its user representation.
759      * For example, if `decimals` equals `2`, a balance of `505` tokens should
760      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
761      *
762      * Tokens usually opt for a value of 18, imitating the relationship between
763      * Ether and Wei.
764      *
765      * NOTE: This information is only used for _display_ purposes: it in
766      * no way affects any of the arithmetic of the contract, including
767      * {IERC20-balanceOf} and {IERC20-transfer}.
768      */
769     function decimals() public view returns (uint8) {
770         return _decimals;
771     }
772 }