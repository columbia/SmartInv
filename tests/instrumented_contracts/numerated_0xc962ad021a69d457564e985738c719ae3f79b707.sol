1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-19
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
9  * the optional functions; to access them see {ERC20Detailed}.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract Context {
83     // Empty internal constructor, to prevent people from mistakenly deploying
84     // an instance of this contract, which should be used via inheritance.
85     constructor () internal { }
86     // solhint-disable-previous-line no-empty-blocks
87 
88     function _msgSender() internal view returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view returns (bytes memory) {
93         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
94         return msg.data;
95     }
96 }
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
137      * @dev Get it via `npm install @openzeppelin/contracts@next`.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
195      * @dev Get it via `npm install @openzeppelin/contracts@next`.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         // Solidity only automatically asserts when dividing by 0
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      *
232      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
233      * @dev Get it via `npm install @openzeppelin/contracts@next`.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 contract ERC20 is Context, IERC20 {
242     using SafeMath for uint256;
243 
244     mapping (address => uint256) private _balances;
245 
246     mapping (address => mapping (address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() public view returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) public view returns (uint256) {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `recipient` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address recipient, uint256 amount) public returns (bool) {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-allowance}.
279      */
280     function allowance(address owner, address spender) public view returns (uint256) {
281         return _allowances[owner][spender];
282     }
283 
284     /**
285      * @dev See {IERC20-approve}.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 value) public returns (bool) {
292         _approve(_msgSender(), spender, value);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20};
301      *
302      * Requirements:
303      * - `sender` and `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `value`.
305      * - the caller must have allowance for `sender`'s tokens of at least
306      * `amount`.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313 
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349 
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(address sender, address recipient, uint256 amount) internal {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367 
368         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
369         _balances[recipient] = _balances[recipient].add(amount);
370         emit Transfer(sender, recipient, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements
379      *
380      * - `to` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _totalSupply = _totalSupply.add(amount);
386         _balances[account] = _balances[account].add(amount);
387         emit Transfer(address(0), account, amount);
388     }
389 
390      /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 value) internal {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
405         _totalSupply = _totalSupply.sub(value);
406         emit Transfer(account, address(0), value);
407     }
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
411      *
412      * This is internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an {Approval} event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(address owner, address spender, uint256 value) internal {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = value;
427         emit Approval(owner, spender, value);
428     }
429 
430     /**
431      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
432      * from the caller's allowance.
433      *
434      * See {_burn} and {_approve}.
435      */
436     function _burnFrom(address account, uint256 amount) internal {
437         _burn(account, amount);
438         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
439     }
440 }
441 
442 contract ERC20Burnable is Context, ERC20 {
443     /**
444      * @dev Destroys `amount` tokens from the caller.
445      *
446      * See {ERC20-_burn}.
447      */
448     function burn(uint256 amount) public {
449         _burn(_msgSender(), amount);
450     }
451 
452     /**
453      * @dev See {ERC20-_burnFrom}.
454      */
455     function burnFrom(address account, uint256 amount) public {
456         _burnFrom(account, amount);
457     }
458 }
459 
460 contract ERC20Detailed is IERC20 {
461     string private _name;
462     string private _symbol;
463     uint8 private _decimals;
464 
465     /**
466      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
467      * these values are immutable: they can only be set once during
468      * construction.
469      */
470     constructor (string memory name, string memory symbol, uint8 decimals) public {
471         _name = name;
472         _symbol = symbol;
473         _decimals = decimals;
474     }
475 
476     /**
477      * @dev Returns the name of the token.
478      */
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     /**
484      * @dev Returns the symbol of the token, usually a shorter version of the
485      * name.
486      */
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     /**
492      * @dev Returns the number of decimals used to get its user representation.
493      * For example, if `decimals` equals `2`, a balance of `505` tokens should
494      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
495      *
496      * Tokens usually opt for a value of 18, imitating the relationship between
497      * Ether and Wei.
498      *
499      * NOTE: This information is only used for _display_ purposes: it in
500      * no way affects any of the arithmetic of the contract, including
501      * {IERC20-balanceOf} and {IERC20-transfer}.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 }
507 
508 library Roles {
509     struct Role {
510         mapping (address => bool) bearer;
511     }
512 
513     /**
514      * @dev Give an account access to this role.
515      */
516     function add(Role storage role, address account) internal {
517         require(!has(role, account), "Roles: account already has role");
518         role.bearer[account] = true;
519     }
520 
521     /**
522      * @dev Remove an account's access to this role.
523      */
524     function remove(Role storage role, address account) internal {
525         require(has(role, account), "Roles: account does not have role");
526         role.bearer[account] = false;
527     }
528 
529     /**
530      * @dev Check if an account has this role.
531      * @return bool
532      */
533     function has(Role storage role, address account) internal view returns (bool) {
534         require(account != address(0), "Roles: account is the zero address");
535         return role.bearer[account];
536     }
537 }
538 contract MinterRole is Context {
539     using Roles for Roles.Role;
540 
541     event MinterAdded(address indexed account);
542     event MinterRemoved(address indexed account);
543 
544     Roles.Role private _minters;
545 
546     constructor () internal {
547         _addMinter(_msgSender());
548     }
549 
550     modifier onlyMinter() {
551         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
552         _;
553     }
554 
555     function isMinter(address account) public view returns (bool) {
556         return _minters.has(account);
557     }
558 
559     function addMinter(address account) public onlyMinter {
560         _addMinter(account);
561     }
562 
563     function renounceMinter() public {
564         _removeMinter(_msgSender());
565     }
566 
567     function _addMinter(address account) internal {
568         _minters.add(account);
569         emit MinterAdded(account);
570     }
571 
572     function _removeMinter(address account) internal {
573         _minters.remove(account);
574         emit MinterRemoved(account);
575     }
576 }
577 
578 
579 contract ERC20Mintable is ERC20, MinterRole {
580     /**
581      * @dev See {ERC20-_mint}.
582      *
583      * Requirements:
584      *
585      * - the caller must have the {MinterRole}.
586      */
587     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
588         _mint(account, amount);
589         return true;
590     }
591 }
592 
593 contract Ownable {
594     address private _owner;
595 
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597 
598     /**
599      * @dev Initializes the contract setting the deployer as the initial owner.
600      */
601     constructor () internal {
602         _owner = msg.sender;
603         emit OwnershipTransferred(address(0), _owner);
604     }
605 
606     /**
607      * @dev Returns the address of the current owner.
608      */
609     function owner() public view returns (address) {
610         return _owner;
611     }
612 
613     /**
614      * @dev Throws if called by any account other than the owner.
615      */
616     modifier onlyOwner() {
617         require(isOwner(), "Ownable: caller is not the owner");
618         _;
619     }
620 
621     /**
622      * @dev Returns true if the caller is the current owner.
623      */
624     function isOwner() public view returns (bool) {
625         return msg.sender == _owner;
626     }
627 
628     /**
629      * @dev Leaves the contract without owner. It will not be possible to call
630      * `onlyOwner` functions anymore. Can only be called by the current owner.
631      *
632      * > Note: Renouncing ownership will leave the contract without an owner,
633      * thereby removing any functionality that is only available to the owner.
634      */
635     function renounceOwnership() public onlyOwner {
636         emit OwnershipTransferred(_owner, address(0));
637         _owner = address(0);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Can only be called by the current owner.
643      */
644     function transferOwnership(address newOwner) public onlyOwner {
645         _transferOwnership(newOwner);
646     }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      */
651     function _transferOwnership(address newOwner) internal {
652         require(newOwner != address(0), "Ownable: new owner is the zero address");
653         emit OwnershipTransferred(_owner, newOwner);
654         _owner = newOwner;
655     }
656 }
657 
658 
659 contract IFX24 is ERC20Mintable,  Ownable, ERC20Detailed, ERC20Burnable{
660      
661     constructor(
662         string memory name,
663         string memory symbol,
664         uint8 decimals,
665         
666         uint256 initialSupply
667     )
668         public
669         ERC20Detailed(name, symbol, decimals)
670         
671     {
672         if (initialSupply > 0) {
673             _mint(owner(), initialSupply);
674         }
675     }
676 }