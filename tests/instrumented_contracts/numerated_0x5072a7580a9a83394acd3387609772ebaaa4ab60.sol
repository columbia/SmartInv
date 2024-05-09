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
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
109 pragma solidity ^0.5.0;
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
186 pragma solidity ^0.5.0;
187 
188 
189 /**
190  * @dev Optional functions from the ERC20 standard.
191  */
192 contract ERC20Detailed is IERC20 {
193     string private _name;
194     string private _symbol;
195     uint8 private _decimals;
196 
197     /**
198      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
199      * these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor (string memory name, string memory symbol, uint8 decimals) public {
203         _name = name;
204         _symbol = symbol;
205         _decimals = decimals;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei.
230      *
231      * > Note that this information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * `IERC20.balanceOf` and `IERC20.transfer`.
234      */
235     function decimals() public view returns (uint8) {
236         return _decimals;
237     }
238 }
239 
240 pragma solidity ^0.5.0;
241 
242 /**
243  * @dev Implementation of the `IERC20` interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using `_mint`.
247  * For a generic mechanism see `ERC20Mintable`.
248  *
249  * *For a detailed writeup see our guide [How to implement supply
250  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
251  *
252  * We have followed general OpenZeppelin guidelines: functions revert instead
253  * of returning `false` on failure. This behavior is nonetheless conventional
254  * and does not conflict with the expectations of ERC20 applications.
255  *
256  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See `IERC20.approve`.
264  */
265 contract ERC20 is IERC20 {
266     using SafeMath for uint256;
267 
268     mapping (address => uint256) private _balances;
269 
270     mapping (address => mapping (address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     /**
275      * @dev See `IERC20.totalSupply`.
276      */
277     function totalSupply() public view returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See `IERC20.balanceOf`.
283      */
284     function balanceOf(address account) public view returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See `IERC20.transfer`.
290      *
291      * Requirements:
292      *
293      * - `recipient` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address recipient, uint256 amount) public returns (bool) {
297         _transfer(msg.sender, recipient, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See `IERC20.allowance`.
303      */
304     function allowance(address owner, address spender) public view returns (uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     /**
309      * @dev See `IERC20.approve`.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function approve(address spender, uint256 value) public returns (bool) {
316         _approve(msg.sender, spender, value);
317         return true;
318     }
319 
320     /**
321      * @dev See `IERC20.transferFrom`.
322      *
323      * Emits an `Approval` event indicating the updated allowance. This is not
324      * required by the EIP. See the note at the beginning of `ERC20`;
325      *
326      * Requirements:
327      * - `sender` and `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `value`.
329      * - the caller must have allowance for `sender`'s tokens of at least
330      * `amount`.
331      */
332     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
333         _transfer(sender, recipient, amount);
334         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
335         return true;
336     }
337 
338     /**
339      * @dev Atomically increases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to `approve` that can be used as a mitigation for
342      * problems described in `IERC20.approve`.
343      *
344      * Emits an `Approval` event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
351         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
352         return true;
353     }
354 
355     /**
356      * @dev Atomically decreases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to `approve` that can be used as a mitigation for
359      * problems described in `IERC20.approve`.
360      *
361      * Emits an `Approval` event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      * - `spender` must have allowance for the caller of at least
367      * `subtractedValue`.
368      */
369     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
370         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
371         return true;
372     }
373 
374     /**
375      * @dev Moves tokens `amount` from `sender` to `recipient`.
376      *
377      * This is internal function is equivalent to `transfer`, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a `Transfer` event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(address sender, address recipient, uint256 amount) internal {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _balances[sender] = _balances[sender].sub(amount);
393         _balances[recipient] = _balances[recipient].add(amount);
394         emit Transfer(sender, recipient, amount);
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a `Transfer` event with `from` set to the zero address.
401      *
402      * Requirements
403      *
404      * - `to` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _totalSupply = _totalSupply.add(amount);
410         _balances[account] = _balances[account].add(amount);
411         emit Transfer(address(0), account, amount);
412     }
413 
414      /**
415      * @dev Destoys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a `Transfer` event with `to` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 value) internal {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _totalSupply = _totalSupply.sub(value);
429         _balances[account] = _balances[account].sub(value);
430         emit Transfer(account, address(0), value);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
435      *
436      * This is internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an `Approval` event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(address owner, address spender, uint256 value) internal {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = value;
451         emit Approval(owner, spender, value);
452     }
453 
454     /**
455      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
456      * from the caller's allowance.
457      *
458      * See `_burn` and `_approve`.
459      */
460     function _burnFrom(address account, uint256 amount) internal {
461         _burn(account, amount);
462         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
463     }
464 }
465 
466 pragma solidity ^0.5.0;
467 
468 /**
469  * @dev Extension of `ERC20` that allows token holders to destroy both their own
470  * tokens and those that they have an allowance for, in a way that can be
471  * recognized off-chain (via event analysis).
472  */
473 contract ERC20Burnable is ERC20 {
474     /**
475      * @dev Destroys `amount` tokens from the caller.
476      *
477      * See `ERC20._burn`.
478      */
479     function burn(uint256 amount) public {
480         _burn(msg.sender, amount);
481     }
482 
483     /**
484      * @dev See `ERC20._burnFrom`.
485      */
486     function burnFrom(address account, uint256 amount) public {
487         _burnFrom(account, amount);
488     }
489 }
490 
491 pragma solidity ^0.5.0;
492 
493 
494 /**
495  * @title SimpleToken
496  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
497  * Note they can later distribute these tokens as they wish using `transfer` and other
498  * `ERC20` functions.
499  */
500 contract SimpleToken is ERC20, ERC20Detailed, ERC20Burnable {
501 
502     /**
503      * @dev Constructor that gives msg.sender all of existing tokens.
504      */
505     constructor () public ERC20Detailed("Ethereum Vault", "ETHV", 18) {
506         _mint(msg.sender, 18000000 * (10 ** uint256(decimals())));
507     }
508 }