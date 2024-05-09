1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-21
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
9  * the optional functions; to access them see `ERC20Detailed`.
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
27      * Emits a `Transfer` event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through `transferFrom`. This is
34      * zero by default.
35      *
36      * This value changes when `approve` or `transferFrom` are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * > Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an `Approval` event.
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
63      * Emits a `Transfer` event.
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
77      * a call to `approve`. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 /**
189  * @dev Implementation of the `IERC20` interface.
190  *
191  * This implementation is agnostic to the way tokens are created. This means
192  * that a supply mechanism has to be added in a derived contract using `_mint`.
193  * For a generic mechanism see `ERC20Mintable`.
194  *
195  * *For a detailed writeup see our guide [How to implement supply
196  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
197  *
198  * We have followed general OpenZeppelin guidelines: functions revert instead
199  * of returning `false` on failure. This behavior is nonetheless conventional
200  * and does not conflict with the expectations of ERC20 applications.
201  *
202  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
203  * This allows applications to reconstruct the allowance for all accounts just
204  * by listening to said events. Other implementations of the EIP may not emit
205  * these events, as it isn't required by the specification.
206  *
207  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
208  * functions have been added to mitigate the well-known issues around setting
209  * allowances. See `IERC20.approve`.
210  */
211 contract ERC20 is IERC20 {
212     using SafeMath for uint256;
213 
214     mapping (address => uint256) private _balances;
215 
216     mapping (address => mapping (address => uint256)) private _allowances;
217 
218     uint256 private _totalSupply;
219 
220     /**
221      * @dev See `IERC20.totalSupply`.
222      */
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See `IERC20.balanceOf`.
229      */
230     function balanceOf(address account) public view returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See `IERC20.transfer`.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public returns (bool) {
243         _transfer(msg.sender, recipient, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See `IERC20.allowance`.
249      */
250     function allowance(address owner, address spender) public view returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See `IERC20.approve`.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 value) public returns (bool) {
262         _approve(msg.sender, spender, value);
263         return true;
264     }
265 
266     /**
267      * @dev See `IERC20.transferFrom`.
268      *
269      * Emits an `Approval` event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of `ERC20`;
271      *
272      * Requirements:
273      * - `sender` and `recipient` cannot be the zero address.
274      * - `sender` must have a balance of at least `value`.
275      * - the caller must have allowance for `sender`'s tokens of at least
276      * `amount`.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to `approve` that can be used as a mitigation for
288      * problems described in `IERC20.approve`.
289      *
290      * Emits an `Approval` event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
297         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
298         return true;
299     }
300 
301     /**
302      * @dev Atomically decreases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to `approve` that can be used as a mitigation for
305      * problems described in `IERC20.approve`.
306      *
307      * Emits an `Approval` event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      * - `spender` must have allowance for the caller of at least
313      * `subtractedValue`.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
316         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
317         return true;
318     }
319 
320     /**
321      * @dev Moves tokens `amount` from `sender` to `recipient`.
322      *
323      * This is internal function is equivalent to `transfer`, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a `Transfer` event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(address sender, address recipient, uint256 amount) internal {
335         require(sender != address(0), "ERC20: transfer from the zero address");
336         require(recipient != address(0), "ERC20: transfer to the zero address");
337 
338         _balances[sender] = _balances[sender].sub(amount);
339         _balances[recipient] = _balances[recipient].add(amount);
340         emit Transfer(sender, recipient, amount);
341     }
342 
343     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
344      * the total supply.
345      *
346      * Emits a `Transfer` event with `from` set to the zero address.
347      *
348      * Requirements
349      *
350      * - `to` cannot be the zero address.
351      */
352     function _mint(address account, uint256 amount) internal {
353         require(account != address(0), "ERC20: mint to the zero address");
354 
355         _totalSupply = _totalSupply.add(amount);
356         _balances[account] = _balances[account].add(amount);
357         emit Transfer(address(0), account, amount);
358     }
359 
360      /**
361      * @dev Destoys `amount` tokens from `account`, reducing the
362      * total supply.
363      *
364      * Emits a `Transfer` event with `to` set to the zero address.
365      *
366      * Requirements
367      *
368      * - `account` cannot be the zero address.
369      * - `account` must have at least `amount` tokens.
370      */
371     function _burn(address account, uint256 value) internal {
372         require(account != address(0), "ERC20: burn from the zero address");
373 
374         _totalSupply = _totalSupply.sub(value);
375         _balances[account] = _balances[account].sub(value);
376         emit Transfer(account, address(0), value);
377     }
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
381      *
382      * This is internal function is equivalent to `approve`, and can be used to
383      * e.g. set automatic allowances for certain subsystems, etc.
384      *
385      * Emits an `Approval` event.
386      *
387      * Requirements:
388      *
389      * - `owner` cannot be the zero address.
390      * - `spender` cannot be the zero address.
391      */
392     function _approve(address owner, address spender, uint256 value) internal {
393         require(owner != address(0), "ERC20: approve from the zero address");
394         require(spender != address(0), "ERC20: approve to the zero address");
395 
396         _allowances[owner][spender] = value;
397         emit Approval(owner, spender, value);
398     }
399 
400     /**
401      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
402      * from the caller's allowance.
403      *
404      * See `_burn` and `_approve`.
405      */
406     function _burnFrom(address account, uint256 amount) internal {
407         _burn(account, amount);
408         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
409     }
410 }
411 
412 /**
413  * @dev Optional functions from the ERC20 standard.
414  */
415 contract ERC20Detailed is IERC20 {
416     string private _name;
417     string private _symbol;
418     uint8 private _decimals;
419 
420     /**
421      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
422      * these values are immutable: they can only be set once during
423      * construction.
424      */
425     constructor (string memory name, string memory symbol, uint8 decimals) public {
426         _name = name;
427         _symbol = symbol;
428         _decimals = decimals;
429     }
430 
431     /**
432      * @dev Returns the name of the token.
433      */
434     function name() public view returns (string memory) {
435         return _name;
436     }
437 
438     /**
439      * @dev Returns the symbol of the token, usually a shorter version of the
440      * name.
441      */
442     function symbol() public view returns (string memory) {
443         return _symbol;
444     }
445 
446     /**
447      * @dev Returns the number of decimals used to get its user representation.
448      * For example, if `decimals` equals `2`, a balance of `505` tokens should
449      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
450      *
451      * Tokens usually opt for a value of 18, imitating the relationship between
452      * Ether and Wei.
453      *
454      * > Note that this information is only used for _display_ purposes: it in
455      * no way affects any of the arithmetic of the contract, including
456      * `IERC20.balanceOf` and `IERC20.transfer`.
457      */
458     function decimals() public view returns (uint8) {
459         return _decimals;
460     }
461 }
462 
463 contract MyToken is ERC20, ERC20Detailed {
464     constructor() ERC20Detailed("Lunohod Ordinary Token", "LOT", 18) public {
465         _mint(msg.sender, 100000000e18);
466     }
467 }