1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
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
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
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
59      * Emits a `Transfer` event.
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
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 pragma solidity ^0.5.0;
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b <= a, "SafeMath: subtraction overflow");
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0, "SafeMath: division by zero");
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         require(b != 0, "SafeMath: modulo by zero");
183         return a % b;
184     }
185 }
186 
187 
188 pragma solidity ^0.5.0;
189 
190 
191 
192 /**
193  * @dev Implementation of the `IERC20` interface.
194  *
195  * This implementation is agnostic to the way tokens are created. This means
196  * that a supply mechanism has to be added in a derived contract using `_mint`.
197  * For a generic mechanism see `ERC20Mintable`.
198  *
199  * *For a detailed writeup see our guide [How to implement supply
200  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
201  *
202  * We have followed general OpenZeppelin guidelines: functions revert instead
203  * of returning `false` on failure. This behavior is nonetheless conventional
204  * and does not conflict with the expectations of ERC20 applications.
205  *
206  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See `IERC20.approve`.
214  */
215 contract ERC20 is IERC20 {
216     using SafeMath for uint256;
217 
218     mapping (address => uint256) private _balances;
219 
220     mapping (address => mapping (address => uint256)) private _allowances;
221 
222     uint256 private _totalSupply;
223 
224     /**
225      * @dev See `IERC20.totalSupply`.
226      */
227     function totalSupply() public view returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See `IERC20.balanceOf`.
233      */
234     function balanceOf(address account) public view returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * @dev See `IERC20.transfer`.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public returns (bool) {
247         _transfer(msg.sender, recipient, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See `IERC20.allowance`.
253      */
254     function allowance(address owner, address spender) public view returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See `IERC20.approve`.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 value) public returns (bool) {
266         _approve(msg.sender, spender, value);
267         return true;
268     }
269 
270     /**
271      * @dev See `IERC20.transferFrom`.
272      *
273      * Emits an `Approval` event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of `ERC20`;
275      *
276      * Requirements:
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `value`.
279      * - the caller must have allowance for `sender`'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to `approve` that can be used as a mitigation for
292      * problems described in `IERC20.approve`.
293      *
294      * Emits an `Approval` event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
301         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to `approve` that can be used as a mitigation for
309      * problems described in `IERC20.approve`.
310      *
311      * Emits an `Approval` event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
320         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Moves tokens `amount` from `sender` to `recipient`.
326      *
327      * This is internal function is equivalent to `transfer`, and can be used to
328      * e.g. implement automatic token fees, slashing mechanisms, etc.
329      *
330      * Emits a `Transfer` event.
331      *
332      * Requirements:
333      *
334      * - `sender` cannot be the zero address.
335      * - `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      */
338     function _transfer(address sender, address recipient, uint256 amount) internal {
339         require(sender != address(0), "ERC20: transfer from the zero address");
340         require(recipient != address(0), "ERC20: transfer to the zero address");
341 
342         _balances[sender] = _balances[sender].sub(amount);
343         _balances[recipient] = _balances[recipient].add(amount);
344         emit Transfer(sender, recipient, amount);
345     }
346 
347     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
348      * the total supply.
349      *
350      * Emits a `Transfer` event with `from` set to the zero address.
351      *
352      * Requirements
353      *
354      * - `to` cannot be the zero address.
355      */
356     function _mint(address account, uint256 amount) internal {
357         require(account != address(0), "ERC20: mint to the zero address");
358 
359         _totalSupply = _totalSupply.add(amount);
360         _balances[account] = _balances[account].add(amount);
361         emit Transfer(address(0), account, amount);
362     }
363 
364      /**
365      * @dev Destoys `amount` tokens from `account`, reducing the
366      * total supply.
367      *
368      * Emits a `Transfer` event with `to` set to the zero address.
369      *
370      * Requirements
371      *
372      * - `account` cannot be the zero address.
373      * - `account` must have at least `amount` tokens.
374      */
375     function _burn(address account, uint256 value) internal {
376         require(account != address(0), "ERC20: burn from the zero address");
377 
378         _totalSupply = _totalSupply.sub(value);
379         _balances[account] = _balances[account].sub(value);
380         emit Transfer(account, address(0), value);
381     }
382 
383     /**
384      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
385      *
386      * This is internal function is equivalent to `approve`, and can be used to
387      * e.g. set automatic allowances for certain subsystems, etc.
388      *
389      * Emits an `Approval` event.
390      *
391      * Requirements:
392      *
393      * - `owner` cannot be the zero address.
394      * - `spender` cannot be the zero address.
395      */
396     function _approve(address owner, address spender, uint256 value) internal {
397         require(owner != address(0), "ERC20: approve from the zero address");
398         require(spender != address(0), "ERC20: approve to the zero address");
399 
400         _allowances[owner][spender] = value;
401         emit Approval(owner, spender, value);
402     }
403 
404     /**
405      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
406      * from the caller's allowance.
407      *
408      * See `_burn` and `_approve`.
409      */
410     function _burnFrom(address account, uint256 amount) internal {
411         _burn(account, amount);
412         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
413     }
414 }
415 
416 
417 pragma solidity ^0.5.0;
418 
419 
420 /**
421  * @dev Optional functions from the ERC20 standard.
422  */
423 contract ERC20Detailed is IERC20 {
424     string private _name;
425     string private _symbol;
426     uint8 private _decimals;
427 
428     /**
429      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
430      * these values are immutable: they can only be set once during
431      * construction.
432      */
433     constructor (string memory name, string memory symbol, uint8 decimals) public {
434         _name = name;
435         _symbol = symbol;
436         _decimals = decimals;
437     }
438 
439     /**
440      * @dev Returns the name of the token.
441      */
442     function name() public view returns (string memory) {
443         return _name;
444     }
445 
446     /**
447      * @dev Returns the symbol of the token, usually a shorter version of the
448      * name.
449      */
450     function symbol() public view returns (string memory) {
451         return _symbol;
452     }
453 
454     /**
455      * @dev Returns the number of decimals used to get its user representation.
456      * For example, if `decimals` equals `2`, a balance of `505` tokens should
457      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
458      *
459      * Tokens usually opt for a value of 18, imitating the relationship between
460      * Ether and Wei.
461      *
462      * > Note that this information is only used for _display_ purposes: it in
463      * no way affects any of the arithmetic of the contract, including
464      * `IERC20.balanceOf` and `IERC20.transfer`.
465      */
466     function decimals() public view returns (uint8) {
467         return _decimals;
468     }
469 }
470 
471 
472 pragma solidity ^0.5.16;
473 
474 
475 
476 
477 
478 contract MoonBase is ERC20, ERC20Detailed {
479     using SafeMath for uint256;
480 
481     IERC20 public based;
482 
483     constructor (address _based, string memory name, string memory symbol)
484         public
485         ERC20Detailed(name, symbol, 18)
486     {
487         based = IERC20(_based);
488     }
489 
490     function balance() public view returns (uint) {
491         return based.balanceOf(address(this));
492     }
493 
494     /// Returns price in BASED per share e18
495     function getPricePerFullShare() public view returns (uint) {
496         uint256 supply = totalSupply();
497         if (supply == 0) return 0;
498         return balance().mul(1e18).div(supply);
499     }
500 
501     function depositAll() external {
502         deposit(based.balanceOf(msg.sender));
503     }
504 
505     /// @param _amount amount in BASED to deposit
506     function deposit(uint _amount) public {
507         require(_amount > 0, "Nothing to deposit");
508 
509         uint _pool = balance();
510         based.transferFrom(msg.sender, address(this), _amount);
511         uint _after = balance();
512         _amount = _after.sub(_pool); // Additional check for deflationary baseds
513         uint shares = 0;
514         if (totalSupply() == 0) {
515             shares = _amount;
516         } else {
517             shares = (_amount.mul(totalSupply())).div(_pool);
518         }
519         _mint(msg.sender, shares);
520     }
521 
522     function withdrawAll() external {
523         withdraw(balanceOf(msg.sender));
524     }
525 
526     function withdraw(uint _shares) public {
527         uint _pool = balance();
528         uint _basedAmount = _pool.mul(_shares).div(totalSupply());
529         based.transfer(msg.sender, _basedAmount);
530         _burn(msg.sender, _shares);
531     }
532 }