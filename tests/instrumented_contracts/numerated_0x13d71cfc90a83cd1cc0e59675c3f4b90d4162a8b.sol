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
79 
80 
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
125      * > Note that this information is only used for _display_ purposes: it in
126      * no way affects any of the arithmetic of the contract, including
127      * `IERC20.balanceOf` and `IERC20.transfer`.
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
138 
139 
140 
141 /**
142  * @dev Wrappers over Solidity's arithmetic operations with added overflow
143  * checks.
144  *
145  * Arithmetic operations in Solidity wrap on overflow. This can easily result
146  * in bugs, because programmers usually assume that an overflow raises an
147  * error, which is the standard behavior in high level programming languages.
148  * `SafeMath` restores this intuition by reverting the transaction when an
149  * operation overflows.
150  *
151  * Using this library instead of the unchecked operations eliminates an entire
152  * class of bugs, so it's recommended to use it always.
153  */
154 library SafeMath {
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      * - Addition cannot overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b <= a, "SafeMath: subtraction overflow");
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Solidity only automatically asserts when dividing by 0
223         require(b > 0, "SafeMath: division by zero");
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
242         require(b != 0, "SafeMath: modulo by zero");
243         return a % b;
244     }
245 }
246 
247 
248 /**
249  * @dev Implementation of the `IERC20` interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using `_mint`.
253  * For a generic mechanism see `ERC20Mintable`.
254  *
255  * *For a detailed writeup see our guide [How to implement supply
256  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
257  *
258  * We have followed general OpenZeppelin guidelines: functions revert instead
259  * of returning `false` on failure. This behavior is nonetheless conventional
260  * and does not conflict with the expectations of ERC20 applications.
261  *
262  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
263  * This allows applications to reconstruct the allowance for all accounts just
264  * by listening to said events. Other implementations of the EIP may not emit
265  * these events, as it isn't required by the specification.
266  *
267  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
268  * functions have been added to mitigate the well-known issues around setting
269  * allowances. See `IERC20.approve`.
270  */
271 contract ERC20 is IERC20 {
272     using SafeMath for uint256;
273 
274     mapping (address => uint256) private _balances;
275 
276     mapping (address => mapping (address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     /**
281      * @dev See `IERC20.totalSupply`.
282      */
283     function totalSupply() public view returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See `IERC20.balanceOf`.
289      */
290     function balanceOf(address account) public view returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See `IERC20.transfer`.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public returns (bool) {
303         _transfer(msg.sender, recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See `IERC20.allowance`.
309      */
310     function allowance(address owner, address spender) public view returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See `IERC20.approve`.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 value) public returns (bool) {
322         _approve(msg.sender, spender, value);
323         return true;
324     }
325 
326     /**
327      * @dev See `IERC20.transferFrom`.
328      *
329      * Emits an `Approval` event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of `ERC20`;
331      *
332      * Requirements:
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `value`.
335      * - the caller must have allowance for `sender`'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
339         _transfer(sender, recipient, amount);
340         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to `approve` that can be used as a mitigation for
348      * problems described in `IERC20.approve`.
349      *
350      * Emits an `Approval` event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
357         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
358         return true;
359     }
360 
361     /**
362      * @dev Atomically decreases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to `approve` that can be used as a mitigation for
365      * problems described in `IERC20.approve`.
366      *
367      * Emits an `Approval` event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      * - `spender` must have allowance for the caller of at least
373      * `subtractedValue`.
374      */
375     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
376         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
377         return true;
378     }
379 
380     /**
381      * @dev Moves tokens `amount` from `sender` to `recipient`.
382      *
383      * This is internal function is equivalent to `transfer`, and can be used to
384      * e.g. implement automatic token fees, slashing mechanisms, etc.
385      *
386      * Emits a `Transfer` event.
387      *
388      * Requirements:
389      *
390      * - `sender` cannot be the zero address.
391      * - `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      */
394     function _transfer(address sender, address recipient, uint256 amount) internal {
395         require(sender != address(0), "ERC20: transfer from the zero address");
396         require(recipient != address(0), "ERC20: transfer to the zero address");
397 
398         _balances[sender] = _balances[sender].sub(amount);
399         _balances[recipient] = _balances[recipient].add(amount);
400         emit Transfer(sender, recipient, amount);
401     }
402 
403     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
404      * the total supply.
405      *
406      * Emits a `Transfer` event with `from` set to the zero address.
407      *
408      * Requirements
409      *
410      * - `to` cannot be the zero address.
411      */
412     function _mint(address account, uint256 amount) internal {
413         require(account != address(0), "ERC20: mint to the zero address");
414 
415         _totalSupply = _totalSupply.add(amount);
416         _balances[account] = _balances[account].add(amount);
417         emit Transfer(address(0), account, amount);
418     }
419 
420      /**
421      * @dev Destoys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a `Transfer` event with `to` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 value) internal {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         _totalSupply = _totalSupply.sub(value);
435         _balances[account] = _balances[account].sub(value);
436         emit Transfer(account, address(0), value);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
441      *
442      * This is internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an `Approval` event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(address owner, address spender, uint256 value) internal {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = value;
457         emit Approval(owner, spender, value);
458     }
459 
460     /**
461      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
462      * from the caller's allowance.
463      *
464      * See `_burn` and `_approve`.
465      */
466     function _burnFrom(address account, uint256 amount) internal {
467         _burn(account, amount);
468         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
469     }
470 }
471 
472 
473 /**
474  * @dev Extension of `ERC20` that allows token holders to destroy both their own
475  * tokens and those that they have an allowance for, in a way that can be
476  * recognized off-chain (via event analysis).
477  */
478 contract ERC20Burnable is ERC20 {
479     /**
480      * @dev Destoys `amount` tokens from the caller.
481      *
482      * See `ERC20._burn`.
483      */
484     function burn(uint256 amount) public {
485         _burn(msg.sender, amount);
486     }
487 
488     /**
489      * @dev See `ERC20._burnFrom`.
490      */
491     function burnFrom(address account, uint256 amount) public {
492         _burnFrom(account, amount);
493     }
494 }
495 
496 
497 contract SwipeToken is ERC20Detailed, ERC20Burnable {
498 
499     constructor () public ERC20Detailed("Swipe Token", "SWIPE", 8) {
500         _mint(msg.sender, 1500000000 * (10 ** uint256(decimals())));
501     }
502     
503 }