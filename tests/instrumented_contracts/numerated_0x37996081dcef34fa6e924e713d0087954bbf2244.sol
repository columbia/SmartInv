1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-05
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, "SafeMath: division by zero");
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
98      * Reverts when dividing by zero.
99      *
100      * Counterpart to Solidity's `%` operator. This function uses a `revert`
101      * opcode (which leaves remaining gas untouched) while Solidity uses an
102      * invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b != 0, "SafeMath: modulo by zero");
109         return a % b;
110     }
111 }
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
115  * the optional functions; to access them see `ERC20Detailed`.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a `Transfer` event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through `transferFrom`. This is
140      * zero by default.
141      *
142      * This value changes when `approve` or `transferFrom` are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * > Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an `Approval` event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a `Transfer` event.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to `approve`. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
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
463  * @title SimpleToken
464  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
465  * Note they can later distribute these tokens as they wish using `transfer` and other
466  * `ERC20` functions.
467  */
468 contract GLOS is ERC20, ERC20Detailed {
469 
470     /**
471      * @dev Constructor that gives msg.sender all of existing tokens.
472      */
473     constructor () public ERC20Detailed("GLOS", "GLOS", 18) {
474         _mint(0xB476f4628F9d2fE6B0fe6cDfE4dd4f4355BfB23b, 5000000000 * (10 ** uint256(decimals())));
475     }   
476 }