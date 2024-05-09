1 
2 pragma solidity ^0.5.13;
3 
4 
5 
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
82 
83 /**
84  * @dev Optional functions from the ERC20 standard.
85  */
86 contract ERC20Detailed is IERC20 {
87     string private _name;
88     string private _symbol;
89     uint8 private _decimals;
90 
91     /**
92      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
93      * these values are immutable: they can only be set once during
94      * construction.
95      */
96     constructor (string memory name, string memory symbol, uint8 decimals) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = decimals;
100     }
101 
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() public view returns (string memory) {
106         return _name;
107     }
108 
109     /**
110      * @dev Returns the symbol of the token, usually a shorter version of the
111      * name.
112      */
113     function symbol() public view returns (string memory) {
114         return _symbol;
115     }
116 
117     /**
118      * @dev Returns the number of decimals used to get its user representation.
119      * For example, if `decimals` equals `2`, a balance of `505` tokens should
120      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
121      *
122      * Tokens usually opt for a value of 18, imitating the relationship between
123      * Ether and Wei.
124      *
125      * NOTE: This information is only used for _display_ purposes: it in
126      * no way affects any of the arithmetic of the contract, including
127      * {IERC20-balanceOf} and {IERC20-transfer}.
128      */
129     function decimals() public view returns (uint8) {
130         return _decimals;
131     }
132 }
133 
134 
135 
136 
137 
138 /*
139  * @dev Provides information about the current execution context, including the
140  * sender of the transaction and its data. While these are generally available
141  * via msg.sender and msg.data, they should not be accessed in such a direct
142  * manner, since when dealing with GSN meta-transactions the account sending and
143  * paying for execution may not be the actual sender (as far as an application
144  * is concerned).
145  *
146  * This contract is only required for intermediate, library-like contracts.
147  */
148 contract Context {
149     // Empty internal constructor, to prevent people from mistakenly deploying
150     // an instance of this contract, which should be used via inheritance.
151     constructor () internal { }
152     // solhint-disable-previous-line no-empty-blocks
153 
154     function _msgSender() internal view returns (address payable) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view returns (bytes memory) {
159         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
160         return msg.data;
161     }
162 }
163 
164 
165 
166 
167 /**
168  * @dev Wrappers over Solidity's arithmetic operations with added overflow
169  * checks.
170  *
171  * Arithmetic operations in Solidity wrap on overflow. This can easily result
172  * in bugs, because programmers usually assume that an overflow raises an
173  * error, which is the standard behavior in high level programming languages.
174  * `SafeMath` restores this intuition by reverting the transaction when an
175  * operation overflows.
176  *
177  * Using this library instead of the unchecked operations eliminates an entire
178  * class of bugs, so it's recommended to use it always.
179  */
180 library SafeMath {
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      * - Addition cannot overflow.
189      */
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         uint256 c = a + b;
192         require(c >= a, "SafeMath: addition overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting on
199      * overflow (when the result is negative).
200      *
201      * Counterpart to Solidity's `-` operator.
202      *
203      * Requirements:
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         return sub(a, b, "SafeMath: subtraction overflow");
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      * - Subtraction cannot overflow.
218      *
219      * _Available since v2.4.0._
220      */
221     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b <= a, errorMessage);
223         uint256 c = a - b;
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the multiplication of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `*` operator.
233      *
234      * Requirements:
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239         // benefit is lost if 'b' is also tested.
240         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241         if (a == 0) {
242             return 0;
243         }
244 
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return div(a, b, "SafeMath: division by zero");
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      * - The divisor cannot be zero.
276      *
277      * _Available since v2.4.0._
278      */
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         // Solidity only automatically asserts when dividing by 0
281         require(b > 0, errorMessage);
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * Reverts when dividing by zero.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return mod(a, b, "SafeMath: modulo by zero");
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts with custom message when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      * - The divisor cannot be zero.
313      *
314      * _Available since v2.4.0._
315      */
316     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
317         require(b != 0, errorMessage);
318         return a % b;
319     }
320 }
321 
322 
323 /**
324  * @dev Implementation of the {IERC20} interface.
325  *
326  * This implementation is agnostic to the way tokens are created. This means
327  * that a supply mechanism has to be added in a derived contract using {_mint}.
328  * For a generic mechanism see {ERC20Mintable}.
329  *
330  * TIP: For a detailed writeup see our guide
331  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
332  * to implement supply mechanisms].
333  *
334  * We have followed general OpenZeppelin guidelines: functions revert instead
335  * of returning `false` on failure. This behavior is nonetheless conventional
336  * and does not conflict with the expectations of ERC20 applications.
337  *
338  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
339  * This allows applications to reconstruct the allowance for all accounts just
340  * by listening to said events. Other implementations of the EIP may not emit
341  * these events, as it isn't required by the specification.
342  *
343  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
344  * functions have been added to mitigate the well-known issues around setting
345  * allowances. See {IERC20-approve}.
346  */
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) private _balances;
351 
352     mapping (address => mapping (address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     /**
357      * @dev See {IERC20-totalSupply}.
358      */
359     function totalSupply() public view returns (uint256) {
360         return _totalSupply;
361     }
362 
363     /**
364      * @dev See {IERC20-balanceOf}.
365      */
366     function balanceOf(address account) public view returns (uint256) {
367         return _balances[account];
368     }
369 
370     /**
371      * @dev See {IERC20-transfer}.
372      *
373      * Requirements:
374      *
375      * - `recipient` cannot be the zero address.
376      * - the caller must have a balance of at least `amount`.
377      */
378     function transfer(address recipient, uint256 amount) public returns (bool) {
379         _transfer(_msgSender(), recipient, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-allowance}.
385      */
386     function allowance(address owner, address spender) public view returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount) public returns (bool) {
398         _approve(_msgSender(), spender, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20};
407      *
408      * Requirements:
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for `sender`'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
415         _transfer(sender, recipient, amount);
416         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
453         return true;
454     }
455 
456     /**
457      * @dev Moves tokens `amount` from `sender` to `recipient`.
458      *
459      * This is internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(address sender, address recipient, uint256 amount) internal {
471         require(sender != address(0), "ERC20: transfer from the zero address");
472         require(recipient != address(0), "ERC20: transfer to the zero address");
473 
474         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
475         _balances[recipient] = _balances[recipient].add(amount);
476         emit Transfer(sender, recipient, amount);
477     }
478 
479     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
480      * the total supply.
481      *
482      * Emits a {Transfer} event with `from` set to the zero address.
483      *
484      * Requirements
485      *
486      * - `to` cannot be the zero address.
487      */
488     function _mint(address account, uint256 amount) internal {
489         require(account != address(0), "ERC20: mint to the zero address");
490 
491         _totalSupply = _totalSupply.add(amount);
492         _balances[account] = _balances[account].add(amount);
493         emit Transfer(address(0), account, amount);
494     }
495 
496      /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
511         _totalSupply = _totalSupply.sub(amount);
512         emit Transfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
517      *
518      * This is internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(address owner, address spender, uint256 amount) internal {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
538      * from the caller's allowance.
539      *
540      * See {_burn} and {_approve}.
541      */
542     function _burnFrom(address account, uint256 amount) internal {
543         _burn(account, amount);
544         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
545     }
546 }
547 
548 
549 
550 
551 
552 
553 /**
554  * @dev Extension of {ERC20} that allows token holders to destroy both their own
555  * tokens and those that they have an allowance for, in a way that can be
556  * recognized off-chain (via event analysis).
557  */
558 contract ERC20Burnable is Context, ERC20 {
559     /**
560      * @dev Destroys `amount` tokens from the caller.
561      *
562      * See {ERC20-_burn}.
563      */
564     function burn(uint256 amount) public {
565         _burn(_msgSender(), amount);
566     }
567 
568     /**
569      * @dev See {ERC20-_burnFrom}.
570      */
571     function burnFrom(address account, uint256 amount) public {
572         _burnFrom(account, amount);
573     }
574 }
575 
576 
577 contract DILK is ERC20, ERC20Detailed,ERC20Burnable {
578     constructor() ERC20Detailed("DigitalToken", "DILK", 18) public {
579         _mint(msg.sender, 21000000 * (10 ** uint256(decimals())));
580     }
581 }
