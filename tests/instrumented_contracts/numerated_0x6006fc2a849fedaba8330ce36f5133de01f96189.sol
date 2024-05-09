1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /**
162  * @title Roles
163  * @dev Library for managing addresses assigned to a Role.
164  */
165 library Roles {
166     struct Role {
167         mapping (address => bool) bearer;
168     }
169 
170     /**
171      * @dev give an account access to this role
172      */
173     function add(Role storage role, address account) internal {
174         require(account != address(0));
175         require(!has(role, account));
176 
177         role.bearer[account] = true;
178     }
179 
180     /**
181      * @dev remove an account's access to this role
182      */
183     function remove(Role storage role, address account) internal {
184         require(account != address(0));
185         require(has(role, account));
186 
187         role.bearer[account] = false;
188     }
189 
190     /**
191      * @dev check if an account has this role
192      * @return bool
193      */
194     function has(Role storage role, address account) internal view returns (bool) {
195         require(account != address(0));
196         return role.bearer[account];
197     }
198 }
199 
200 contract MinterRole  {
201     using Roles for Roles.Role;
202 
203     event MinterAdded(address indexed account);
204     event MinterRemoved(address indexed account);
205 
206     Roles.Role private _minters;
207 
208     constructor(address sender) public  {
209         if (!isMinter(sender)) {
210             _addMinter(sender);
211         }
212     }
213 
214     modifier onlyMinter() {
215         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
216         _;
217     }
218 
219     function isMinter(address account) public view returns (bool) {
220         return _minters.has(account);
221     }
222 
223     function addMinter(address account) public onlyMinter {
224         _addMinter(account);
225     }
226 
227     function renounceMinter() public {
228         _removeMinter(msg.sender);
229     }
230 
231     function _addMinter(address account) internal {
232         _minters.add(account);
233         emit MinterAdded(account);
234     }
235 
236     function _removeMinter(address account) internal {
237         _minters.remove(account);
238         emit MinterRemoved(account);
239     }
240 
241 }
242 
243 /**
244  * @dev Interface of the ERC20 standard as defined in the EIP.
245  */
246 interface IERC20 {
247     /**
248      * @dev Returns the amount of tokens in existence.
249      */
250     function totalSupply() external view returns (uint256);
251 
252     /**
253      * @dev Returns the amount of tokens owned by `account`.
254      */
255     function balanceOf(address account) external view returns (uint256);
256 
257     /**
258      * @dev Moves `amount` tokens from the caller's account to `recipient`.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transfer(address recipient, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Returns the remaining number of tokens that `spender` will be
268      * allowed to spend on behalf of `owner` through {transferFrom}. This is
269      * zero by default.
270      *
271      * This value changes when {approve} or {transferFrom} are called.
272      */
273     function allowance(address owner, address spender) external view returns (uint256);
274 
275     /**
276      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * IMPORTANT: Beware that changing an allowance with this method brings the risk
281      * that someone may use both the old and the new allowance by unfortunate
282      * transaction ordering. One possible solution to mitigate this race
283      * condition is to first reduce the spender's allowance to 0 and set the
284      * desired value afterwards:
285      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286      *
287      * Emits an {Approval} event.
288      */
289     function approve(address spender, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Moves `amount` tokens from `sender` to `recipient` using the
293      * allowance mechanism. `amount` is then deducted from the caller's
294      * allowance.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Emitted when `value` tokens are moved from one account (`from`) to
304      * another (`to`).
305      *
306      * Note that `value` may be zero.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 value);
309 
310     /**
311      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
312      * a call to {approve}. `value` is the new allowance.
313      */
314     event Approval(address indexed owner, address indexed spender, uint256 value);
315 }
316 
317 /**
318  * @title Standard ERC20 token
319  *
320  * @dev Implementation of the basic standard token.
321  * https://eips.ethereum.org/EIPS/eip-20
322  * Originally based on code by FirstBlood:
323  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
324  *
325  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
326  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
327  * compliant implementations may not do it.
328  */
329 contract ERC20 is  IERC20 {
330     using SafeMath for uint256;
331 
332     mapping (address => uint256) private _balances;
333 
334     mapping (address => mapping (address => uint256)) private _allowances;
335 
336     uint256 private _totalSupply;
337 
338     string private _name;
339     string private _symbol;
340     uint8 private _decimals;
341 
342     /**
343      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
344      * a default value of 18.
345      *
346      * To select a different value for {decimals}, use {_setupDecimals}.
347      *
348      * All three of these values are immutable: they can only be set once during
349      * construction.
350      */
351     constructor (string memory name, string memory symbol) public {
352         _name = name;
353         _symbol = symbol;
354         _decimals = 18;
355     }
356 
357     /**
358      * @dev Returns the name of the token.
359      */
360     function name() public view returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @dev Returns the symbol of the token, usually a shorter version of the
366      * name.
367      */
368     function symbol() public view returns (string memory) {
369         return _symbol;
370     }
371 
372     /**
373      * @dev Returns the number of decimals used to get its user representation.
374      * For example, if `decimals` equals `2`, a balance of `505` tokens should
375      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
376      *
377      * Tokens usually opt for a value of 18, imitating the relationship between
378      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
379      * called.
380      *
381      * NOTE: This information is only used for _display_ purposes: it in
382      * no way affects any of the arithmetic of the contract, including
383      * {IERC20-balanceOf} and {IERC20-transfer}.
384      */
385     function decimals() public view returns (uint8) {
386         return _decimals;
387     }
388 
389     /**
390      * @dev See {IERC20-totalSupply}.
391      */
392     function totalSupply() public view override returns (uint256) {
393         return _totalSupply;
394     }
395 
396     /**
397      * @dev See {IERC20-balanceOf}.
398      */
399     function balanceOf(address account) public view override returns (uint256) {
400         return _balances[account];
401     }
402 
403     /**
404      * @dev See {IERC20-transfer}.
405      *
406      * Requirements:
407      *
408      * - `recipient` cannot be the zero address.
409      * - the caller must have a balance of at least `amount`.
410      */
411     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
412         _transfer(msg.sender, recipient, amount);
413         return true;
414     }
415 
416     /**
417      * @dev See {IERC20-allowance}.
418      */
419     function allowance(address owner, address spender) public view virtual override returns (uint256) {
420         return _allowances[owner][spender];
421     }
422 
423     /**
424      * @dev See {IERC20-approve}.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      */
430     function approve(address spender, uint256 amount) public virtual override returns (bool) {
431         _approve(msg.sender, spender, amount);
432         return true;
433     }
434 
435     /**
436      * @dev See {IERC20-transferFrom}.
437      *
438      * Emits an {Approval} event indicating the updated allowance. This is not
439      * required by the EIP. See the note at the beginning of {ERC20}.
440      *
441      * Requirements:
442      *
443      * - `sender` and `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `amount`.
445      * - the caller must have allowance for ``sender``'s tokens of at least
446      * `amount`.
447      */
448     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
449         _transfer(sender, recipient, amount);
450         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
451         return true;
452     }
453 
454     /**
455      * @dev Atomically increases the allowance granted to `spender` by the caller.
456      *
457      * This is an alternative to {approve} that can be used as a mitigation for
458      * problems described in {IERC20-approve}.
459      *
460      * Emits an {Approval} event indicating the updated allowance.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
467         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
468         return true;
469     }
470 
471     /**
472      * @dev Atomically decreases the allowance granted to `spender` by the caller.
473      *
474      * This is an alternative to {approve} that can be used as a mitigation for
475      * problems described in {IERC20-approve}.
476      *
477      * Emits an {Approval} event indicating the updated allowance.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      * - `spender` must have allowance for the caller of at least
483      * `subtractedValue`.
484      */
485     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
486         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
487         return true;
488     }
489 
490     /**
491      * @dev Moves tokens `amount` from `sender` to `recipient`.
492      *
493      * This is internal function is equivalent to {transfer}, and can be used to
494      * e.g. implement automatic token fees, slashing mechanisms, etc.
495      *
496      * Emits a {Transfer} event.
497      *
498      * Requirements:
499      *
500      * - `sender` cannot be the zero address.
501      * - `recipient` cannot be the zero address.
502      * - `sender` must have a balance of at least `amount`.
503      */
504     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
505         require(sender != address(0), "ERC20: transfer from the zero address");
506         require(recipient != address(0), "ERC20: transfer to the zero address");
507 
508         _beforeTokenTransfer(sender, recipient, amount);
509 
510         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
511         _balances[recipient] = _balances[recipient].add(amount);
512         emit Transfer(sender, recipient, amount);
513     }
514 
515     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
516      * the total supply.
517      *
518      * Emits a {Transfer} event with `from` set to the zero address.
519      *
520      * Requirements:
521      *
522      * - `to` cannot be the zero address.
523      */
524     function _mint(address account, uint256 amount) internal virtual {
525         require(account != address(0), "ERC20: mint to the zero address");
526 
527         _beforeTokenTransfer(address(0), account, amount);
528 
529         _totalSupply = _totalSupply.add(amount);
530         _balances[account] = _balances[account].add(amount);
531         emit Transfer(address(0), account, amount);
532     }
533 
534     /**
535      * @dev Destroys `amount` tokens from `account`, reducing the
536      * total supply.
537      *
538      * Emits a {Transfer} event with `to` set to the zero address.
539      *
540      * Requirements:
541      *
542      * - `account` cannot be the zero address.
543      * - `account` must have at least `amount` tokens.
544      */
545     function _burn(address account, uint256 amount) internal virtual {
546         require(account != address(0), "ERC20: burn from the zero address");
547 
548         _beforeTokenTransfer(account, address(0), amount);
549 
550         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
551         _totalSupply = _totalSupply.sub(amount);
552         emit Transfer(account, address(0), amount);
553     }
554 
555     /**
556      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
557      *
558      * This internal function is equivalent to `approve`, and can be used to
559      * e.g. set automatic allowances for certain subsystems, etc.
560      *
561      * Emits an {Approval} event.
562      *
563      * Requirements:
564      *
565      * - `owner` cannot be the zero address.
566      * - `spender` cannot be the zero address.
567      */
568     function _approve(address owner, address spender, uint256 amount) internal virtual {
569         require(owner != address(0), "ERC20: approve from the zero address");
570         require(spender != address(0), "ERC20: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575 
576     
577     /**
578      * @dev Hook that is called before any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * will be to transferred to `to`.
585      * - when `from` is zero, `amount` tokens will be minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
592 }
593 
594 
595 /**
596  * @title Standard ERC20 token, with minting and burn functionality.
597  *
598  */
599 contract ShakeERC20 is  ERC20, MinterRole {
600     uint256 public immutable MAX_TOTAL_SUPPLY;
601 
602     uint256 public totalMinted = 0;
603     uint256 public totalBurned = 0;
604 
605     constructor(
606         //string memory name, string memory symbol
607     ) public  
608       ERC20('SHAKE token by SpaceSwap v2', 'SHAKE')
609       MinterRole(address(msg.sender))
610     { 
611         MAX_TOTAL_SUPPLY = 10000*10**18; //10 000 SHAKE
612     }
613 
614     /**
615      * @dev Function to mint tokens
616      * @param to The address that will receive the minted tokens.
617      * @param value The amount of tokens to mint.
618      * @return A boolean that indicates if the operation was successful.
619      */
620     function mint(address to, uint256 value) public onlyMinter returns (bool) {
621         require(totalSupply().add(value) <= MAX_TOTAL_SUPPLY, "Can`t mint more than MAX_TOTAL_SUPPLY");
622         _mint(to, value);
623         totalMinted = totalMinted.add(value);
624         return true;
625     } 
626 
627     /**
628      * @dev Function to burn tokens
629      * @param to The address that tokens will burn.
630      * @param value The amount of tokens to burn.
631      * @return A boolean that indicates if the operation was successful.
632      */
633     function burn(address to, uint256 value) public onlyMinter returns (bool) {
634         _burn(to, value);
635         totalBurned = totalBurned.add(value);
636         return true;
637     } 
638      
639     /**
640      * @dev Minter can claim any tokens that transfered to this contract address
641      */
642     function reclaimToken(ERC20 token) external onlyMinter {
643         require(address(token) != address(0));
644         uint256 balance = token.balanceOf(address(this));
645         token.transfer(msg.sender, balance);
646     }
647 }