1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
112  * the optional functions; to access them see `ERC20Detailed`.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a `Transfer` event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through `transferFrom`. This is
137      * zero by default.
138      *
139      * This value changes when `approve` or `transferFrom` are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * > Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an `Approval` event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a `Transfer` event.
167      */
168     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to `approve`. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
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
410 /**
411  * @dev Optional functions from the ERC20 standard.
412  */
413 contract ERC20Detailed is IERC20 {
414     string private _name;
415     string private _symbol;
416     uint8 private _decimals;
417 
418     /**
419      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
420      * these values are immutable: they can only be set once during
421      * construction.
422      */
423     constructor (string memory name, string memory symbol, uint8 decimals) public {
424         _name = name;
425         _symbol = symbol;
426         _decimals = decimals;
427     }
428 
429     /**
430      * @dev Returns the name of the token.
431      */
432     function name() public view returns (string memory) {
433         return _name;
434     }
435 
436     /**
437      * @dev Returns the symbol of the token, usually a shorter version of the
438      * name.
439      */
440     function symbol() public view returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445      * @dev Returns the number of decimals used to get its user representation.
446      * For example, if `decimals` equals `2`, a balance of `505` tokens should
447      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
448      *
449      * Tokens usually opt for a value of 18, imitating the relationship between
450      * Ether and Wei.
451      *
452      * > Note that this information is only used for _display_ purposes: it in
453      * no way affects any of the arithmetic of the contract, including
454      * `IERC20.balanceOf` and `IERC20.transfer`.
455      */
456     function decimals() public view returns (uint8) {
457         return _decimals;
458     }
459 }
460 
461 contract SimpleSwapCoin is ERC20, ERC20Detailed {
462     constructor() ERC20Detailed("SimpleSwap Coin", "SWAP", 8) public {
463         _mint(msg.sender, 100000000 * (10 ** 8));
464     }
465 }