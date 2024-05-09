1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-05
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on
27      * overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a, "SafeMath: subtraction overflow");
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Solidity only automatically asserts when dividing by 0
93         require(b > 0, "SafeMath: division by zero");
94         uint256 c = a / b;
95         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
102      * Reverts when dividing by zero.
103      *
104      * Counterpart to Solidity's `%` operator. This function uses a `revert`
105      * opcode (which leaves remaining gas untouched) while Solidity uses an
106      * invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b != 0, "SafeMath: modulo by zero");
113         return a % b;
114     }
115 }
116 
117 /**
118  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
119  * the optional functions; to access them see `ERC20Detailed`.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a `Transfer` event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through `transferFrom`. This is
144      * zero by default.
145      *
146      * This value changes when `approve` or `transferFrom` are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * > Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an `Approval` event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a `Transfer` event.
174      */
175     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to `approve`. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
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
415 /**
416  * @dev Optional functions from the ERC20 standard.
417  */
418 contract ERC20Detailed is IERC20 {
419     string private _name;
420     string private _symbol;
421     uint8 private _decimals;
422 
423     /**
424      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
425      * these values are immutable: they can only be set once during
426      * construction.
427      */
428     constructor (string memory name, string memory symbol, uint8 decimals) public {
429         _name = name;
430         _symbol = symbol;
431         _decimals = decimals;
432     }
433 
434     /**
435      * @dev Returns the name of the token.
436      */
437     function name() public view returns (string memory) {
438         return _name;
439     }
440 
441     /**
442      * @dev Returns the symbol of the token, usually a shorter version of the
443      * name.
444      */
445     function symbol() public view returns (string memory) {
446         return _symbol;
447     }
448 
449     /**
450      * @dev Returns the number of decimals used to get its user representation.
451      * For example, if `decimals` equals `2`, a balance of `505` tokens should
452      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
453      *
454      * Tokens usually opt for a value of 18, imitating the relationship between
455      * Ether and Wei.
456      *
457      * > Note that this information is only used for _display_ purposes: it in
458      * no way affects any of the arithmetic of the contract, including
459      * `IERC20.balanceOf` and `IERC20.transfer`.
460      */
461     function decimals() public view returns (uint8) {
462         return _decimals;
463     }
464 }
465 
466 /**
467  * @title SimpleToken
468  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
469  * Note they can later distribute these tokens as they wish using `transfer` and other
470  * `ERC20` functions.
471  */
472 contract MS is ERC20, ERC20Detailed {
473 
474     /**
475      * @dev Constructor that gives msg.sender all of existing tokens.
476      */
477     constructor () public ERC20Detailed("Mobile radio station ", "MS", 18) {
478         _mint(0x7DDC67f52434A629979b0b43E12a472005c5CFBf,210000 * (10 ** uint256(decimals())));
479     }   
480 }