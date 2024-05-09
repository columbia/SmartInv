1 pragma solidity ^0.5.0;
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
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      *
129      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
130      * @dev Get it via `npm install @openzeppelin/contracts@next`.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187 
188      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
189      * @dev Get it via `npm install @openzeppelin/contracts@next`.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
227      * @dev Get it via `npm install @openzeppelin/contracts@next`.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 contract ERC20 is Context, IERC20 {
236     using SafeMath for uint256;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20};
295      *
296      * Requirements:
297      * - `sender` and `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      * - the caller must have allowance for `sender`'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343 
344     /**
345      * @dev Moves tokens `amount` from `sender` to `recipient`.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(address sender, address recipient, uint256 amount) internal {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361 
362         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
363         _balances[recipient] = _balances[recipient].add(amount);
364         emit Transfer(sender, recipient, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements
373      *
374      * - `to` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _totalSupply = _totalSupply.add(amount);
380         _balances[account] = _balances[account].add(amount);
381         emit Transfer(address(0), account, amount);
382     }
383 
384     /**
385      * @dev Destroys `amount` tokens from `account`, reducing the
386      * total supply.
387      *
388      * Emits a {Transfer} event with `to` set to the zero address.
389      *
390      * Requirements
391      *
392      * - `account` cannot be the zero address.
393      * - `account` must have at least `amount` tokens.
394      */
395     function _burn(address account, uint256 amount) internal {
396         require(account != address(0), "ERC20: burn from the zero address");
397 
398         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
399         _totalSupply = _totalSupply.sub(amount);
400         emit Transfer(account, address(0), amount);
401     }
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
405      *
406      * This is internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(address owner, address spender, uint256 amount) internal {
417         require(owner != address(0), "ERC20: approve from the zero address");
418         require(spender != address(0), "ERC20: approve to the zero address");
419 
420         _allowances[owner][spender] = amount;
421         emit Approval(owner, spender, amount);
422     }
423 
424     /**
425      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
426      * from the caller's allowance.
427      *
428      * See {_burn} and {_approve}.
429      */
430     function _burnFrom(address account, uint256 amount) internal {
431         _burn(account, amount);
432         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
433     }
434 }
435 
436 contract ERC20Detailed is IERC20 {
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     /**
442      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
443      * these values are immutable: they can only be set once during
444      * construction.
445      */
446     constructor (string memory name, string memory symbol, uint8 decimals) public {
447         _name = name;
448         _symbol = symbol;
449         _decimals = decimals;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei.
474      *
475      * NOTE: This information is only used for _display_ purposes: it in
476      * no way affects any of the arithmetic of the contract, including
477      * {IERC20-balanceOf} and {IERC20-transfer}.
478      */
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 }
483 
484 library Roles {
485     struct Role {
486         mapping (address => bool) bearer;
487     }
488 
489     /**
490      * @dev Give an account access to this role.
491      */
492     function add(Role storage role, address account) internal {
493         require(!has(role, account), "Roles: account already has role");
494         role.bearer[account] = true;
495     }
496 
497     /**
498      * @dev Remove an account's access to this role.
499      */
500     function remove(Role storage role, address account) internal {
501         require(has(role, account), "Roles: account does not have role");
502         role.bearer[account] = false;
503     }
504 
505     /**
506      * @dev Check if an account has this role.
507      * @return bool
508      */
509     function has(Role storage role, address account) internal view returns (bool) {
510         require(account != address(0), "Roles: account is the zero address");
511         return role.bearer[account];
512     }
513 }
514 
515 contract MinterRole is Context {
516     using Roles for Roles.Role;
517 
518     event MinterAdded(address indexed account);
519     event MinterRemoved(address indexed account);
520 
521     Roles.Role private _minters;
522 
523     constructor () internal {
524         _addMinter(_msgSender());
525     }
526 
527     modifier onlyMinter() {
528         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
529         _;
530     }
531 
532     function isMinter(address account) public view returns (bool) {
533         return _minters.has(account);
534     }
535 
536     function addMinter(address account) public onlyMinter {
537         _addMinter(account);
538     }
539 
540     function renounceMinter() public {
541         _removeMinter(_msgSender());
542     }
543 
544     function _addMinter(address account) internal {
545         _minters.add(account);
546         emit MinterAdded(account);
547     }
548 
549     function _removeMinter(address account) internal {
550         _minters.remove(account);
551         emit MinterRemoved(account);
552     }
553 }
554 
555 contract ERC20Mintable is ERC20, MinterRole {
556     /**
557      * @dev See {ERC20-_mint}.
558      *
559      * Requirements:
560      *
561      * - the caller must have the {MinterRole}.
562      */
563     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
564         _mint(account, amount);
565         return true;
566     }
567 }
568 
569 /**
570  * @title SimpleToken
571  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
572  * Note they can later distribute these tokens as they wish using `transfer` and other
573  * `ERC20` functions.
574  */
575 contract Simbcoin is Context, ERC20, ERC20Detailed {
576 
577     /**
578      * @dev Constructor that gives _msgSender() all of existing tokens.
579      */
580     constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _initsupply) public ERC20Detailed(_name, _symbol, _decimals) {
581         _mint(_msgSender(), _initsupply * (10 ** uint256(decimals())));
582     }
583 }