1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract Context {
79     // Empty internal constructor, to prevent people from mistakenly deploying
80     // an instance of this contract, which should be used via inheritance.
81     constructor () internal { }
82     // solhint-disable-previous-line no-empty-blocks
83 
84     function _msgSender() internal view returns (address) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view returns (bytes memory) {
89         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
90         return msg.data;
91     }
92 }
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
133      * @dev Get it via `npm install @openzeppelin/contracts@next`.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
191      * @dev Get it via `npm install @openzeppelin/contracts@next`.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         // Solidity only automatically asserts when dividing by 0
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      *
228      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
229      * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
287     function approve(address spender, uint256 value) public returns (bool) {
288         _approve(_msgSender(), spender, value);
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
300      * - `sender` must have a balance of at least `value`.
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
386      /**
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
397     function _burn(address account, uint256 value) internal {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
401         _totalSupply = _totalSupply.sub(value);
402         emit Transfer(account, address(0), value);
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
418     function _approve(address owner, address spender, uint256 value) internal {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = value;
423         emit Approval(owner, spender, value);
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
438 contract ERC20Burnable is Context, ERC20 {
439     /**
440      * @dev Destroys `amount` tokens from the caller.
441      *
442      * See {ERC20-_burn}.
443      */
444     function burn(uint256 amount) public {
445         _burn(_msgSender(), amount);
446     }
447 
448     /**
449      * @dev See {ERC20-_burnFrom}.
450      */
451     function burnFrom(address account, uint256 amount) public {
452         _burnFrom(account, amount);
453     }
454 }
455 
456 contract ERC20Detailed is IERC20 {
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460 
461     /**
462      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
463      * these values are immutable: they can only be set once during
464      * construction.
465      */
466     constructor (string memory name, string memory symbol, uint8 decimals) public {
467         _name = name;
468         _symbol = symbol;
469         _decimals = decimals;
470     }
471 
472     /**
473      * @dev Returns the name of the token.
474      */
475     function name() public view returns (string memory) {
476         return _name;
477     }
478 
479     /**
480      * @dev Returns the symbol of the token, usually a shorter version of the
481      * name.
482      */
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     /**
488      * @dev Returns the number of decimals used to get its user representation.
489      * For example, if `decimals` equals `2`, a balance of `505` tokens should
490      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
491      *
492      * Tokens usually opt for a value of 18, imitating the relationship between
493      * Ether and Wei.
494      *
495      * NOTE: This information is only used for _display_ purposes: it in
496      * no way affects any of the arithmetic of the contract, including
497      * {IERC20-balanceOf} and {IERC20-transfer}.
498      */
499     function decimals() public view returns (uint8) {
500         return _decimals;
501     }
502 }
503 
504 library Roles {
505     struct Role {
506         mapping (address => bool) bearer;
507     }
508 
509     /**
510      * @dev Give an account access to this role.
511      */
512     function add(Role storage role, address account) internal {
513         require(!has(role, account), "Roles: account already has role");
514         role.bearer[account] = true;
515     }
516 
517     /**
518      * @dev Remove an account's access to this role.
519      */
520     function remove(Role storage role, address account) internal {
521         require(has(role, account), "Roles: account does not have role");
522         role.bearer[account] = false;
523     }
524 
525     /**
526      * @dev Check if an account has this role.
527      * @return bool
528      */
529     function has(Role storage role, address account) internal view returns (bool) {
530         require(account != address(0), "Roles: account is the zero address");
531         return role.bearer[account];
532     }
533 }
534 contract MinterRole is Context {
535     using Roles for Roles.Role;
536 
537     event MinterAdded(address indexed account);
538     event MinterRemoved(address indexed account);
539 
540     Roles.Role private _minters;
541 
542     constructor () internal {
543         _addMinter(_msgSender());
544     }
545 
546     modifier onlyMinter() {
547         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
548         _;
549     }
550 
551     function isMinter(address account) public view returns (bool) {
552         return _minters.has(account);
553     }
554 
555     function addMinter(address account) public onlyMinter {
556         _addMinter(account);
557     }
558 
559     function renounceMinter() public {
560         _removeMinter(_msgSender());
561     }
562 
563     function _addMinter(address account) internal {
564         _minters.add(account);
565         emit MinterAdded(account);
566     }
567 
568     function _removeMinter(address account) internal {
569         _minters.remove(account);
570         emit MinterRemoved(account);
571     }
572 }
573 
574 
575 contract ERC20Mintable is ERC20, MinterRole {
576     /**
577      * @dev See {ERC20-_mint}.
578      *
579      * Requirements:
580      *
581      * - the caller must have the {MinterRole}.
582      */
583     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
584         _mint(account, amount);
585         return true;
586     }
587 }
588 
589 contract Ownable {
590     address private _owner;
591 
592     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
593 
594     /**
595      * @dev Initializes the contract setting the deployer as the initial owner.
596      */
597     constructor () internal {
598         _owner = msg.sender;
599         emit OwnershipTransferred(address(0), _owner);
600     }
601 
602     /**
603      * @dev Returns the address of the current owner.
604      */
605     function owner() public view returns (address) {
606         return _owner;
607     }
608 
609     /**
610      * @dev Throws if called by any account other than the owner.
611      */
612     modifier onlyOwner() {
613         require(isOwner(), "Ownable: caller is not the owner");
614         _;
615     }
616 
617     /**
618      * @dev Returns true if the caller is the current owner.
619      */
620     function isOwner() public view returns (bool) {
621         return msg.sender == _owner;
622     }
623 
624     /**
625      * @dev Leaves the contract without owner. It will not be possible to call
626      * `onlyOwner` functions anymore. Can only be called by the current owner.
627      *
628      * > Note: Renouncing ownership will leave the contract without an owner,
629      * thereby removing any functionality that is only available to the owner.
630      */
631     function renounceOwnership() public onlyOwner {
632         emit OwnershipTransferred(_owner, address(0));
633         _owner = address(0);
634     }
635 
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      * Can only be called by the current owner.
639      */
640     function transferOwnership(address newOwner) public onlyOwner {
641         _transferOwnership(newOwner);
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      */
647     function _transferOwnership(address newOwner) internal {
648         require(newOwner != address(0), "Ownable: new owner is the zero address");
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 
655 contract EGORAS is ERC20Mintable,  Ownable, ERC20Detailed, ERC20Burnable{
656      
657     constructor(
658         string memory name,
659         string memory symbol,
660         uint8 decimals,
661         
662         uint256 initialSupply
663     )
664         public
665         ERC20Detailed(name, symbol, decimals)
666         
667     {
668         if (initialSupply > 0) {
669             _mint(owner(), initialSupply);
670         }
671     }
672 }