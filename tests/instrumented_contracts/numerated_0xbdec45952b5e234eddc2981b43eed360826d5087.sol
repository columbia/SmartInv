1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, "SafeMath: division by zero");
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95      * Reverts when dividing by zero.
96      *
97      * Counterpart to Solidity's `%` operator. This function uses a `revert`
98      * opcode (which leaves remaining gas untouched) while Solidity uses an
99      * invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "SafeMath: modulo by zero");
106         return a % b;
107     }
108 }
109 
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
113  * the optional functions; to access them see `ERC20Detailed`.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a `Transfer` event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through `transferFrom`. This is
138      * zero by default.
139      *
140      * This value changes when `approve` or `transferFrom` are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * > Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an `Approval` event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a `Transfer` event.
168      */
169     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to `approve`. `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 /**
187  * @dev Implementation of the `IERC20` interface.
188  *
189  * This implementation is agnostic to the way tokens are created. This means
190  * that a supply mechanism has to be added in a derived contract using `_mint`.
191  * For a generic mechanism see `ERC20Mintable`.
192  *
193  * *For a detailed writeup see our guide [How to implement supply
194  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
195  *
196  * We have followed general OpenZeppelin guidelines: functions revert instead
197  * of returning `false` on failure. This behavior is nonetheless conventional
198  * and does not conflict with the expectations of ERC20 applications.
199  *
200  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
201  * This allows applications to reconstruct the allowance for all accounts just
202  * by listening to said events. Other implementations of the EIP may not emit
203  * these events, as it isn't required by the specification.
204  *
205  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
206  * functions have been added to mitigate the well-known issues around setting
207  * allowances. See `IERC20.approve`.
208  */
209 contract ERC20 is IERC20 {
210     using SafeMath for uint256;
211 
212     mapping (address => uint256) private _balances;
213 
214     mapping (address => mapping (address => uint256)) private _allowances;
215 
216     uint256 private _totalSupply;
217 
218     /**
219      * @dev See `IERC20.totalSupply`.
220      */
221     function totalSupply() public view returns (uint256) {
222         return _totalSupply;
223     }
224 
225     /**
226      * @dev See `IERC20.balanceOf`.
227      */
228     function balanceOf(address account) public view returns (uint256) {
229         return _balances[account];
230     }
231 
232     /**
233      * @dev See `IERC20.transfer`.
234      *
235      * Requirements:
236      *
237      * - `recipient` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(address recipient, uint256 amount) public returns (bool) {
241         _transfer(msg.sender, recipient, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See `IERC20.allowance`.
247      */
248     function allowance(address owner, address spender) public view returns (uint256) {
249         return _allowances[owner][spender];
250     }
251 
252     /**
253      * @dev See `IERC20.approve`.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function approve(address spender, uint256 value) public returns (bool) {
260         _approve(msg.sender, spender, value);
261         return true;
262     }
263 
264     /**
265      * @dev See `IERC20.transferFrom`.
266      *
267      * Emits an `Approval` event indicating the updated allowance. This is not
268      * required by the EIP. See the note at the beginning of `ERC20`;
269      *
270      * Requirements:
271      * - `sender` and `recipient` cannot be the zero address.
272      * - `sender` must have a balance of at least `value`.
273      * - the caller must have allowance for `sender`'s tokens of at least
274      * `amount`.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
279         return true;
280     }
281 
282     /**
283      * @dev Atomically increases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to `approve` that can be used as a mitigation for
286      * problems described in `IERC20.approve`.
287      *
288      * Emits an `Approval` event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
295         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
296         return true;
297     }
298 
299     /**
300      * @dev Atomically decreases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to `approve` that can be used as a mitigation for
303      * problems described in `IERC20.approve`.
304      *
305      * Emits an `Approval` event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      * - `spender` must have allowance for the caller of at least
311      * `subtractedValue`.
312      */
313     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
314         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
315         return true;
316     }
317 
318     /**
319      * @dev Moves tokens `amount` from `sender` to `recipient`.
320      *
321      * This is internal function is equivalent to `transfer`, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a `Transfer` event.
325      *
326      * Requirements:
327      *
328      * - `sender` cannot be the zero address.
329      * - `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      */
332     function _transfer(address sender, address recipient, uint256 amount) internal {
333         require(sender != address(0), "ERC20: transfer from the zero address");
334         require(recipient != address(0), "ERC20: transfer to the zero address");
335 
336         _balances[sender] = _balances[sender].sub(amount);
337         _balances[recipient] = _balances[recipient].add(amount);
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
342      * the total supply.
343      *
344      * Emits a `Transfer` event with `from` set to the zero address.
345      *
346      * Requirements
347      *
348      * - `to` cannot be the zero address.
349      */
350     function _mint(address account, uint256 amount) internal {
351         require(account != address(0), "ERC20: mint to the zero address");
352 
353         _totalSupply = _totalSupply.add(amount);
354         _balances[account] = _balances[account].add(amount);
355         emit Transfer(address(0), account, amount);
356     }
357 
358      /**
359      * @dev Destoys `amount` tokens from `account`, reducing the
360      * total supply.
361      *
362      * Emits a `Transfer` event with `to` set to the zero address.
363      *
364      * Requirements
365      *
366      * - `account` cannot be the zero address.
367      * - `account` must have at least `amount` tokens.
368      */
369     function _burn(address account, uint256 value) internal {
370         require(account != address(0), "ERC20: burn from the zero address");
371 
372         _totalSupply = _totalSupply.sub(value);
373         _balances[account] = _balances[account].sub(value);
374         emit Transfer(account, address(0), value);
375     }
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
379      *
380      * This is internal function is equivalent to `approve`, and can be used to
381      * e.g. set automatic allowances for certain subsystems, etc.
382      *
383      * Emits an `Approval` event.
384      *
385      * Requirements:
386      *
387      * - `owner` cannot be the zero address.
388      * - `spender` cannot be the zero address.
389      */
390     function _approve(address owner, address spender, uint256 value) internal {
391         require(owner != address(0), "ERC20: approve from the zero address");
392         require(spender != address(0), "ERC20: approve to the zero address");
393 
394         _allowances[owner][spender] = value;
395         emit Approval(owner, spender, value);
396     }
397 
398     /**
399      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
400      * from the caller's allowance.
401      *
402      * See `_burn` and `_approve`.
403      */
404     function _burnFrom(address account, uint256 amount) internal {
405         _burn(account, amount);
406         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
407     }
408 }
409 
410 
411 /**
412  * @dev Optional functions from the ERC20 standard.
413  */
414 contract ERC20Detailed is IERC20 {
415     string private _name;
416     string private _symbol;
417     uint8 private _decimals;
418 
419     /**
420      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
421      * these values are immutable: they can only be set once during
422      * construction.
423      */
424     constructor (string memory name, string memory symbol, uint8 decimals) public {
425         _name = name;
426         _symbol = symbol;
427         _decimals = decimals;
428     }
429 
430     /**
431      * @dev Returns the name of the token.
432      */
433     function name() public view returns (string memory) {
434         return _name;
435     }
436 
437     /**
438      * @dev Returns the symbol of the token, usually a shorter version of the
439      * name.
440      */
441     function symbol() public view returns (string memory) {
442         return _symbol;
443     }
444 
445     /**
446      * @dev Returns the number of decimals used to get its user representation.
447      * For example, if `decimals` equals `2`, a balance of `505` tokens should
448      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
449      *
450      * Tokens usually opt for a value of 18, imitating the relationship between
451      * Ether and Wei.
452      *
453      * > Note that this information is only used for _display_ purposes: it in
454      * no way affects any of the arithmetic of the contract, including
455      * `IERC20.balanceOf` and `IERC20.transfer`.
456      */
457     function decimals() public view returns (uint8) {
458         return _decimals;
459     }
460 }
461 
462 /**
463  * @dev Extension of `ERC20` that allows token holders to destroy both their own
464  * tokens and those that they have an allowance for, in a way that can be
465  * recognized off-chain (via event analysis).
466  */
467 contract ERC20Burnable is ERC20 {
468     /**
469      * @dev Destoys `amount` tokens from the caller.
470      *
471      * See `ERC20._burn`.
472      */
473     function burn(uint256 amount) public {
474         _burn(msg.sender, amount);
475     }
476 
477     /**
478      * @dev See `ERC20._burnFrom`.
479      */
480     function burnFrom(address account, uint256 amount) public {
481         _burnFrom(account, amount);
482     }
483 }
484 
485 contract MoguToken is ERC20, ERC20Detailed, ERC20Burnable {
486     constructor(uint256 initialSupply) ERC20Detailed("Mogu Token", "MOGX", 18) public {
487         _mint(msg.sender, initialSupply);
488     }
489 }