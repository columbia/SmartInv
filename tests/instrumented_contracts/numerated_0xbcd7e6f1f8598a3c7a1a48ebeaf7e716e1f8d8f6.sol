1 pragma solidity ^0.5.0;
2 
3 
4 
5 
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      *
164      * _Available since v2.4.0._
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      *
222      * _Available since v2.4.0._
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         // Solidity only automatically asserts when dividing by 0
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      *
259      * _Available since v2.4.0._
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 
268 /**
269  * @dev Implementation of the {IERC20} interface.
270  *
271  * This implementation is agnostic to the way tokens are created. This means
272  * that a supply mechanism has to be added in a derived contract using {_mint}.
273  * For a generic mechanism see {ERC20Mintable}.
274  *
275  * TIP: For a detailed writeup see our guide
276  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
277  * to implement supply mechanisms].
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     /**
302      * @dev See {IERC20-totalSupply}.
303      */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See {IERC20-balanceOf}.
310      */
311     function balanceOf(address account) public view returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {IERC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public returns (bool) {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 amount) public returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20};
352      *
353      * Requirements:
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for `sender`'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
360         _transfer(sender, recipient, amount);
361         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(address sender, address recipient, uint256 amount) internal {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _totalSupply = _totalSupply.add(amount);
437         _balances[account] = _balances[account].add(amount);
438         emit Transfer(address(0), account, amount);
439     }
440 
441     /**
442      * @dev Destroys `amount` tokens from `account`, reducing the
443      * total supply.
444      *
445      * Emits a {Transfer} event with `to` set to the zero address.
446      *
447      * Requirements
448      *
449      * - `account` cannot be the zero address.
450      * - `account` must have at least `amount` tokens.
451      */
452     function _burn(address account, uint256 amount) internal {
453         require(account != address(0), "ERC20: burn from the zero address");
454 
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
462      *
463      * This is internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 amount) internal {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
483      * from the caller's allowance.
484      *
485      * See {_burn} and {_approve}.
486      */
487     function _burnFrom(address account, uint256 amount) internal {
488         _burn(account, amount);
489         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
490     }
491 }
492 
493 
494 
495 
496 
497 /**
498  * @dev Optional functions from the ERC20 standard.
499  */
500 contract ERC20Detailed is IERC20 {
501     string private _name;
502     string private _symbol;
503     uint8 private _decimals;
504 
505     /**
506      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
507      * these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor (string memory name, string memory symbol, uint8 decimals) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = decimals;
514     }
515 
516     /**
517      * @dev Returns the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev Returns the symbol of the token, usually a shorter version of the
525      * name.
526      */
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev Returns the number of decimals used to get its user representation.
533      * For example, if `decimals` equals `2`, a balance of `505` tokens should
534      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
535      *
536      * Tokens usually opt for a value of 18, imitating the relationship between
537      * Ether and Wei.
538      *
539      * NOTE: This information is only used for _display_ purposes: it in
540      * no way affects any of the arithmetic of the contract, including
541      * {IERC20-balanceOf} and {IERC20-transfer}.
542      */
543     function decimals() public view returns (uint8) {
544         return _decimals;
545     }
546 }
547 
548 
549 /**
550  * @title MirthCoin
551  */
552 contract MirthCoin is ERC20, ERC20Detailed {
553     uint8 public constant DECIMALS = 8;
554     uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(DECIMALS));
555 
556     /**
557      * @dev Constructor that gives msg.sender all of existing tokens.
558      */
559     constructor (address owner) public ERC20Detailed("Mirth Coin", "MIC", DECIMALS) {
560         _mint(owner, INITIAL_SUPPLY);
561     }
562 }