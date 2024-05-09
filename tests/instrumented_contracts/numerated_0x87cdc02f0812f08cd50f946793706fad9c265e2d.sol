1 pragma solidity 0.5.0;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
21  * the optional functions; to access them see {ERC20Detailed}.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      *
146      * _Available since v2.4.0._
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      *
204      * _Available since v2.4.0._
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         // Solidity only automatically asserts when dividing by 0
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      *
241      * _Available since v2.4.0._
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 contract ERC20 is Context, IERC20 {
250     using SafeMath for uint256;
251 
252     mapping (address => uint256) private _balances;
253 
254     mapping (address => mapping (address => uint256)) private _allowances;
255 
256     uint256 private _totalSupply;
257 
258     /**
259      * @dev See {IERC20-totalSupply}.
260      */
261     function totalSupply() public view returns (uint256) {
262         return _totalSupply;
263     }
264 
265     /**
266      * @dev See {IERC20-balanceOf}.
267      */
268     function balanceOf(address account) public view returns (uint256) {
269         return _balances[account];
270     }
271 
272     /**
273      * @dev See {IERC20-transfer}.
274      *
275      * Requirements:
276      *
277      * - `recipient` cannot be the zero address.
278      * - the caller must have a balance of at least `amount`.
279      */
280     function transfer(address recipient, uint256 amount) public returns (bool) {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-allowance}.
287      */
288     function allowance(address owner, address spender) public view returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     /**
293      * @dev See {IERC20-approve}.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function approve(address spender, uint256 amount) public returns (bool) {
300         _approve(_msgSender(), spender, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-transferFrom}.
306      *
307      * Emits an {Approval} event indicating the updated allowance. This is not
308      * required by the EIP. See the note at the beginning of {ERC20};
309      *
310      * Requirements:
311      * - `sender` and `recipient` cannot be the zero address.
312      * - `sender` must have a balance of at least `amount`.
313      * - the caller must have allowance for `sender`'s tokens of at least
314      * `amount`.
315      */
316     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
335         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
336         return true;
337     }
338 
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
355         return true;
356     }
357 
358     /**
359      * @dev Moves tokens `amount` from `sender` to `recipient`.
360      *
361      * This is internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(address sender, address recipient, uint256 amount) internal {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements
387      *
388      * - `to` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397 
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
413         _totalSupply = _totalSupply.sub(amount);
414         emit Transfer(account, address(0), amount);
415     }
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
419      *
420      * This is internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(address owner, address spender, uint256 amount) internal {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
440      * from the caller's allowance.
441      *
442      * See {_burn} and {_approve}.
443      */
444     function _burnFrom(address account, uint256 amount) internal {
445         _burn(account, amount);
446         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
447     }
448 }
449 
450 /**
451  * @title Roles
452  * @dev Library for managing addresses assigned to a Role.
453  */
454 library Roles {
455     struct Role {
456         mapping (address => bool) bearer;
457     }
458 
459     /**
460      * @dev Give an account access to this role.
461      */
462     function add(Role storage role, address account) internal {
463         require(!has(role, account), "Roles: account already has role");
464         role.bearer[account] = true;
465     }
466 
467     /**
468      * @dev Remove an account's access to this role.
469      */
470     function remove(Role storage role, address account) internal {
471         require(has(role, account), "Roles: account does not have role");
472         role.bearer[account] = false;
473     }
474 
475     /**
476      * @dev Check if an account has this role.
477      * @return bool
478      */
479     function has(Role storage role, address account) internal view returns (bool) {
480         require(account != address(0), "Roles: account is the zero address");
481         return role.bearer[account];
482     }
483 }
484 
485 
486 contract MinterRole is Context {
487     using Roles for Roles.Role;
488 
489     event MinterAdded(address indexed account);
490     event MinterRemoved(address indexed account);
491 
492     Roles.Role private _minters;
493 
494     constructor () internal {
495         _addMinter(_msgSender());
496     }
497 
498     modifier onlyMinter() {
499         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
500         _;
501     }
502 
503     function isMinter(address account) public view returns (bool) {
504         return _minters.has(account);
505     }
506 
507     function addMinter(address account) public onlyMinter {
508         _addMinter(account);
509     }
510 
511     function renounceMinter() public {
512         _removeMinter(_msgSender());
513     }
514 
515     function _addMinter(address account) internal {
516         _minters.add(account);
517         emit MinterAdded(account);
518     }
519 
520     function _removeMinter(address account) internal {
521         _minters.remove(account);
522         emit MinterRemoved(account);
523     }
524 }
525 
526 /**
527  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
528  * which have permission to mint (create) new tokens as they see fit.
529  *
530  * At construction, the deployer of the contract is the only minter.
531  */
532 contract ERC20Mintable is ERC20, MinterRole {
533     /**
534      * @dev See {ERC20-_mint}.
535      *
536      * Requirements:
537      *
538      * - the caller must have the {MinterRole}.
539      */
540     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
541         _mint(account, amount);
542         return true;
543     }
544 }
545 
546 
547 /**
548  * @dev Extension of {ERC20} that allows token holders to destroy both their own
549  * tokens and those that they have an allowance for, in a way that can be
550  * recognized off-chain (via event analysis).
551  */
552 contract ERC20Burnable is Context, ERC20, MinterRole {
553     /**
554      * @dev Destroys `amount` tokens from the caller.
555      *
556      * See {ERC20-_burn}.
557      */
558     function burn(uint256 amount) public onlyMinter {
559         _burn(_msgSender(), amount);
560     }
561 
562     /**
563      * @dev See {ERC20-_burnFrom}.
564      */
565     function burnFrom(address account, uint256 amount) public onlyMinter {
566         _burnFrom(account, amount);
567     }
568 }
569 
570 
571 /**
572  * @dev Optional functions from the ERC20 standard.
573  */
574 contract ERC20Detailed is IERC20 {
575     string private _name;
576     string private _symbol;
577     uint8 private _decimals;
578 
579     /**
580      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
581      * these values are immutable: they can only be set once during
582      * construction.
583      */
584     constructor (string memory name, string memory symbol, uint8 decimals) public {
585         _name = name;
586         _symbol = symbol;
587         _decimals = decimals;
588     }
589 
590     /**
591      * @dev Returns the name of the token.
592      */
593     function name() public view returns (string memory) {
594         return _name;
595     }
596 
597     /**
598      * @dev Returns the symbol of the token, usually a shorter version of the
599      * name.
600      */
601     function symbol() public view returns (string memory) {
602         return _symbol;
603     }
604 
605     /**
606      * @dev Returns the number of decimals used to get its user representation.
607      * For example, if `decimals` equals `2`, a balance of `505` tokens should
608      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
609      *
610      * Tokens usually opt for a value of 18, imitating the relationship between
611      * Ether and Wei.
612      *
613      * NOTE: This information is only used for _display_ purposes: it in
614      * no way affects any of the arithmetic of the contract, including
615      * {IERC20-balanceOf} and {IERC20-transfer}.
616      */
617     function decimals() public view returns (uint8) {
618         return _decimals;
619     }
620 }
621 
622 /**
623  * @notice  This contract is for the Swarm BZZ token. This contract inherits
624  *          from all the above imported contracts indirectly through the
625  *          implemented contracts. ERC20Capped is Mintable, Burnable is an ERC20
626  */
627 contract Token is ERC20Detailed, ERC20Mintable, ERC20Burnable {
628     /**
629       * @dev    Initialises all the inherited smart contracts
630       */
631     constructor(
632         string memory _name,
633         string memory _symbol,
634         uint8 _decimals
635     ) 
636         ERC20()
637         ERC20Detailed(
638             _name,
639             _symbol,
640             _decimals
641         )
642         ERC20Mintable()
643         ERC20Burnable()
644         public
645     {
646         _mint(msg.sender,1e26);
647     }
648 }