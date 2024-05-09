1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
33  * the optional functions; to access them see {ERC20Detailed}.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      * - Subtraction cannot overflow.
160      *
161      * _Available since v2.4.0._
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         // Solidity only automatically asserts when dividing by 0
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      *
256      * _Available since v2.4.0._
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 
265 
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20Mintable}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin guidelines: functions revert instead
278  * of returning `false` on failure. This behavior is nonetheless conventional
279  * and does not conflict with the expectations of ERC20 applications.
280  *
281  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
282  * This allows applications to reconstruct the allowance for all accounts just
283  * by listening to said events. Other implementations of the EIP may not emit
284  * these events, as it isn't required by the specification.
285  *
286  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
287  * functions have been added to mitigate the well-known issues around setting
288  * allowances. See {IERC20-approve}.
289  */
290 contract ERC20 is Context, IERC20 {
291     using SafeMath for uint256;
292 
293     mapping (address => uint256) private _balances;
294 
295     mapping (address => mapping (address => uint256)) private _allowances;
296 
297     uint256 private _totalSupply;
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329     function allowance(address owner, address spender) public view returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     /**
334      * @dev See {IERC20-approve}.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20};
350      *
351      * Requirements:
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for `sender`'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
358         _transfer(sender, recipient, amount);
359         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
360         return true;
361     }
362 
363     /**
364      * @dev Atomically increases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
377         return true;
378     }
379 
380     /**
381      * @dev Atomically decreases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      * - `spender` must have allowance for the caller of at least
392      * `subtractedValue`.
393      */
394     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
396         return true;
397     }
398 
399     /**
400      * @dev Moves tokens `amount` from `sender` to `recipient`.
401      *
402      * This is internal function is equivalent to {transfer}, and can be used to
403      * e.g. implement automatic token fees, slashing mechanisms, etc.
404      *
405      * Emits a {Transfer} event.
406      *
407      * Requirements:
408      *
409      * - `sender` cannot be the zero address.
410      * - `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      */
413     function _transfer(address sender, address recipient, uint256 amount) internal {
414         require(sender != address(0), "ERC20: transfer from the zero address");
415         require(recipient != address(0), "ERC20: transfer to the zero address");
416 
417         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
418         _balances[recipient] = _balances[recipient].add(amount);
419         emit Transfer(sender, recipient, amount);
420     }
421 
422     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
423      * the total supply.
424      *
425      * Emits a {Transfer} event with `from` set to the zero address.
426      *
427      * Requirements
428      *
429      * - `to` cannot be the zero address.
430      */
431     function _mint(address account, uint256 amount) internal {
432         require(account != address(0), "ERC20: mint to the zero address");
433 
434         _totalSupply = _totalSupply.add(amount);
435         _balances[account] = _balances[account].add(amount);
436         emit Transfer(address(0), account, amount);
437     }
438 
439      /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal {
451         require(account != address(0), "ERC20: burn from the zero address");
452 
453         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
454         _totalSupply = _totalSupply.sub(amount);
455         emit Transfer(account, address(0), amount);
456     }
457 
458     /**
459      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
460      *
461      * This is internal function is equivalent to `approve`, and can be used to
462      * e.g. set automatic allowances for certain subsystems, etc.
463      *
464      * Emits an {Approval} event.
465      *
466      * Requirements:
467      *
468      * - `owner` cannot be the zero address.
469      * - `spender` cannot be the zero address.
470      */
471     function _approve(address owner, address spender, uint256 amount) internal {
472         require(owner != address(0), "ERC20: approve from the zero address");
473         require(spender != address(0), "ERC20: approve to the zero address");
474 
475         _allowances[owner][spender] = amount;
476         emit Approval(owner, spender, amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
481      * from the caller's allowance.
482      *
483      * See {_burn} and {_approve}.
484      */
485     function _burnFrom(address account, uint256 amount) internal {
486         _burn(account, amount);
487         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
488     }
489 }
490 
491 
492 /**
493  * @dev Optional functions from the ERC20 standard.
494  */
495 contract ERC20Detailed is IERC20 {
496     string private _name;
497     string private _symbol;
498     uint8 private _decimals;
499 
500     /**
501      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
502      * these values are immutable: they can only be set once during
503      * construction.
504      */
505     constructor (string memory name, string memory symbol, uint8 decimals) public {
506         _name = name;
507         _symbol = symbol;
508         _decimals = decimals;
509     }
510 
511     /**
512      * @dev Returns the name of the token.
513      */
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     /**
519      * @dev Returns the symbol of the token, usually a shorter version of the
520      * name.
521      */
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @dev Returns the number of decimals used to get its user representation.
528      * For example, if `decimals` equals `2`, a balance of `505` tokens should
529      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
530      *
531      * Tokens usually opt for a value of 18, imitating the relationship between
532      * Ether and Wei.
533      *
534      * NOTE: This information is only used for _display_ purposes: it in
535      * no way affects any of the arithmetic of the contract, including
536      * {IERC20-balanceOf} and {IERC20-transfer}.
537      */
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 }
542 
543 contract UPToken is ERC20, ERC20Detailed {
544     constructor(uint256 initialSupply) ERC20Detailed("Unicorn Project", "UP", 18) public {
545         _mint(msg.sender, initialSupply);
546     }
547 }