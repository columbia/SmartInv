1 pragma solidity ^0.5.13;
2 
3 
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
8  * the optional functions; to access them see {ERC20Detailed}.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 /**
83  * @dev Optional functions from the ERC20 standard.
84  */
85 contract ERC20Detailed is IERC20 {
86     string private _name;
87     string private _symbol;
88     uint8 private _decimals;
89 
90     /**
91      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
92      * these values are immutable: they can only be set once during
93      * construction.
94      */
95     constructor (string memory name, string memory symbol, uint8 decimals) public {
96         _name = name;
97         _symbol = symbol;
98         _decimals = decimals;
99     }
100 
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() public view returns (string memory) {
105         return _name;
106     }
107 
108     /**
109      * @dev Returns the symbol of the token, usually a shorter version of the
110      * name.
111      */
112     function symbol() public view returns (string memory) {
113         return _symbol;
114     }
115 
116     /**
117      * @dev Returns the number of decimals used to get its user representation.
118      * For example, if `decimals` equals `2`, a balance of `505` tokens should
119      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
120      *
121      * Tokens usually opt for a value of 18, imitating the relationship between
122      * Ether and Wei.
123      *
124      * NOTE: This information is only used for _display_ purposes: it in
125      * no way affects any of the arithmetic of the contract, including
126      * {IERC20-balanceOf} and {IERC20-transfer}.
127      */
128     function decimals() public view returns (uint8) {
129         return _decimals;
130     }
131 }
132 
133 
134 
135 
136 
137 /*
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with GSN meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 contract Context {
148     // Empty internal constructor, to prevent people from mistakenly deploying
149     // an instance of this contract, which should be used via inheritance.
150     constructor () internal { }
151     // solhint-disable-previous-line no-empty-blocks
152 
153     function _msgSender() internal view returns (address payable) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view returns (bytes memory) {
158         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
159         return msg.data;
160     }
161 }
162 
163 
164 
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return sub(a, b, "SafeMath: subtraction overflow");
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      * - Subtraction cannot overflow.
217      *
218      * _Available since v2.4.0._
219      */
220     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b <= a, errorMessage);
222         uint256 c = a - b;
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         return div(a, b, "SafeMath: division by zero");
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      *
276      * _Available since v2.4.0._
277      */
278     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         // Solidity only automatically asserts when dividing by 0
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return mod(a, b, "SafeMath: modulo by zero");
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts with custom message when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      *
313      * _Available since v2.4.0._
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 
322 /**
323  * @dev Implementation of the {IERC20} interface.
324  *
325  * This implementation is agnostic to the way tokens are created. This means
326  * that a supply mechanism has to be added in a derived contract using {_mint}.
327  * For a generic mechanism see {ERC20Mintable}.
328  *
329  * TIP: For a detailed writeup see our guide
330  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
331  * to implement supply mechanisms].
332  *
333  * We have followed general OpenZeppelin guidelines: functions revert instead
334  * of returning `false` on failure. This behavior is nonetheless conventional
335  * and does not conflict with the expectations of ERC20 applications.
336  *
337  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
338  * This allows applications to reconstruct the allowance for all accounts just
339  * by listening to said events. Other implementations of the EIP may not emit
340  * these events, as it isn't required by the specification.
341  *
342  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
343  * functions have been added to mitigate the well-known issues around setting
344  * allowances. See {IERC20-approve}.
345  */
346 contract ERC20 is Context, IERC20 {
347     using SafeMath for uint256;
348 
349     mapping (address => uint256) private _balances;
350 
351     mapping (address => mapping (address => uint256)) private _allowances;
352 
353     uint256 private _totalSupply;
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() public view returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) public view returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `recipient` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address recipient, uint256 amount) public returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-allowance}.
384      */
385     function allowance(address owner, address spender) public view returns (uint256) {
386         return _allowances[owner][spender];
387     }
388 
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) public returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20};
406      *
407      * Requirements:
408      * - `sender` and `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      * - the caller must have allowance for `sender`'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
414         _transfer(sender, recipient, amount);
415         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
452         return true;
453     }
454 
455     /**
456      * @dev Moves tokens `amount` from `sender` to `recipient`.
457      *
458      * This is internal function is equivalent to {transfer}, and can be used to
459      * e.g. implement automatic token fees, slashing mechanisms, etc.
460      *
461      * Emits a {Transfer} event.
462      *
463      * Requirements:
464      *
465      * - `sender` cannot be the zero address.
466      * - `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      */
469     function _transfer(address sender, address recipient, uint256 amount) internal {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
474         _balances[recipient] = _balances[recipient].add(amount);
475         emit Transfer(sender, recipient, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements
484      *
485      * - `to` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _totalSupply = _totalSupply.add(amount);
491         _balances[account] = _balances[account].add(amount);
492         emit Transfer(address(0), account, amount);
493     }
494 
495      /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
510         _totalSupply = _totalSupply.sub(amount);
511         emit Transfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
516      *
517      * This is internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(address owner, address spender, uint256 amount) internal {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
537      * from the caller's allowance.
538      *
539      * See {_burn} and {_approve}.
540      */
541     function _burnFrom(address account, uint256 amount) internal {
542         _burn(account, amount);
543         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
544     }
545 }
546 
547 
548 
549 
550 
551 
552 /**
553  * @dev Extension of {ERC20} that allows token holders to destroy both their own
554  * tokens and those that they have an allowance for, in a way that can be
555  * recognized off-chain (via event analysis).
556  */
557 contract ERC20Burnable is Context, ERC20 {
558     /**
559      * @dev Destroys `amount` tokens from the caller.
560      *
561      * See {ERC20-_burn}.
562      */
563     function burn(uint256 amount) public {
564         _burn(_msgSender(), amount);
565     }
566 
567     /**
568      * @dev See {ERC20-_burnFrom}.
569      */
570     function burnFrom(address account, uint256 amount) public {
571         _burnFrom(account, amount);
572     }
573 }
574 
575 
576 contract LVD is ERC20, ERC20Detailed,ERC20Burnable {
577     constructor() ERC20Detailed("YoTuBang Eco Pass", "LVD", 18) public {
578         _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
579     }
580 }