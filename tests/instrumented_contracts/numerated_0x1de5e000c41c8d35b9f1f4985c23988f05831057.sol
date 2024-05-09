1 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Implementation of the `IERC20` interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using `_mint`.
199  * For a generic mechanism see `ERC20Mintable`.
200  *
201  * *For a detailed writeup see our guide [How to implement supply
202  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
203  *
204  * We have followed general OpenZeppelin guidelines: functions revert instead
205  * of returning `false` on failure. This behavior is nonetheless conventional
206  * and does not conflict with the expectations of ERC20 applications.
207  *
208  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See `IERC20.approve`.
216  */
217 contract ERC20 is IERC20 {
218     using SafeMath for uint256;
219 
220     mapping (address => uint256) private _balances;
221 
222     mapping (address => mapping (address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     /**
227      * @dev See `IERC20.totalSupply`.
228      */
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See `IERC20.balanceOf`.
235      */
236     function balanceOf(address account) public view returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See `IERC20.transfer`.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public returns (bool) {
249         _transfer(msg.sender, recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See `IERC20.allowance`.
255      */
256     function allowance(address owner, address spender) public view returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See `IERC20.approve`.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 value) public returns (bool) {
268         _approve(msg.sender, spender, value);
269         return true;
270     }
271 
272     /**
273      * @dev See `IERC20.transferFrom`.
274      *
275      * Emits an `Approval` event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of `ERC20`;
277      *
278      * Requirements:
279      * - `sender` and `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `value`.
281      * - the caller must have allowance for `sender`'s tokens of at least
282      * `amount`.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
285         _transfer(sender, recipient, amount);
286         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
287         return true;
288     }
289 
290     /**
291      * @dev Atomically increases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to `approve` that can be used as a mitigation for
294      * problems described in `IERC20.approve`.
295      *
296      * Emits an `Approval` event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
303         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
304         return true;
305     }
306 
307     /**
308      * @dev Atomically decreases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to `approve` that can be used as a mitigation for
311      * problems described in `IERC20.approve`.
312      *
313      * Emits an `Approval` event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      * - `spender` must have allowance for the caller of at least
319      * `subtractedValue`.
320      */
321     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
322         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
323         return true;
324     }
325 
326     /**
327      * @dev Moves tokens `amount` from `sender` to `recipient`.
328      *
329      * This is internal function is equivalent to `transfer`, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a `Transfer` event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(address sender, address recipient, uint256 amount) internal {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _balances[sender] = _balances[sender].sub(amount);
345         _balances[recipient] = _balances[recipient].add(amount);
346         emit Transfer(sender, recipient, amount);
347     }
348 
349     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
350      * the total supply.
351      *
352      * Emits a `Transfer` event with `from` set to the zero address.
353      *
354      * Requirements
355      *
356      * - `to` cannot be the zero address.
357      */
358     function _mint(address account, uint256 amount) internal {
359         require(account != address(0), "ERC20: mint to the zero address");
360 
361         _totalSupply = _totalSupply.add(amount);
362         _balances[account] = _balances[account].add(amount);
363         emit Transfer(address(0), account, amount);
364     }
365 
366      /**
367      * @dev Destroys `amount` tokens from `account`, reducing the
368      * total supply.
369      *
370      * Emits a `Transfer` event with `to` set to the zero address.
371      *
372      * Requirements
373      *
374      * - `account` cannot be the zero address.
375      * - `account` must have at least `amount` tokens.
376      */
377     function _burn(address account, uint256 value) internal {
378         require(account != address(0), "ERC20: burn from the zero address");
379 
380         _totalSupply = _totalSupply.sub(value);
381         _balances[account] = _balances[account].sub(value);
382         emit Transfer(account, address(0), value);
383     }
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
387      *
388      * This is internal function is equivalent to `approve`, and can be used to
389      * e.g. set automatic allowances for certain subsystems, etc.
390      *
391      * Emits an `Approval` event.
392      *
393      * Requirements:
394      *
395      * - `owner` cannot be the zero address.
396      * - `spender` cannot be the zero address.
397      */
398     function _approve(address owner, address spender, uint256 value) internal {
399         require(owner != address(0), "ERC20: approve from the zero address");
400         require(spender != address(0), "ERC20: approve to the zero address");
401 
402         _allowances[owner][spender] = value;
403         emit Approval(owner, spender, value);
404     }
405 
406     /**
407      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
408      * from the caller's allowance.
409      *
410      * See `_burn` and `_approve`.
411      */
412     function _burnFrom(address account, uint256 amount) internal {
413         _burn(account, amount);
414         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
415     }
416 }
417 
418 // File: contracts\ERC20\Test.sol
419 
420 pragma solidity ^0.5.0;
421 
422 /**
423  * @title Test
424  * @author Test
425  *
426  * @dev Standard ERC20 token with burning and optional functions implemented.
427  * For full specification of ERC-20 standard see:
428  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
429  */
430 contract BonFi is ERC20 {
431 
432     string private _name;
433     string private _symbol;
434     uint8 private _decimals;
435 
436     /**
437      * @dev Constructor.
438      * @param name name of the token
439      * @param symbol symbol of the token, 3-4 chars is recommended
440      * @param decimals number of decimal places of one token unit, 18 is widely used
441      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
442      * @param tokenOwnerAddress address that gets 100% of token supply
443      */
444     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
445       _name = name;
446       _symbol = symbol;
447       _decimals = decimals;
448 
449       // set tokenOwnerAddress as owner of all tokens
450       _mint(tokenOwnerAddress, totalSupply);
451     }
452 
453     /**
454      * @dev Burns a specific amount of tokens.
455      * @param value The amount of lowest token units to be burned.
456      */
457     function burn(uint256 value) public {
458       _burn(msg.sender, value);
459     }
460 
461     // optional functions from ERC20 stardard
462 
463     /**
464      * @return the name of the token.
465      */
466     function name() public view returns (string memory) {
467       return _name;
468     }
469 
470     /**
471      * @return the symbol of the token.
472      */
473     function symbol() public view returns (string memory) {
474       return _symbol;
475     }
476 
477     /**
478      * @return the number of decimals of the token.
479      */
480     function decimals() public view returns (uint8) {
481       return _decimals;
482     }
483 }