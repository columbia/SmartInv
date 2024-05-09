1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-09-12
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2019-08-12
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2019-08-05
15 */
16 
17 pragma solidity ^0.5.0;
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a, "SafeMath: subtraction overflow");
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, "SafeMath: division by zero");
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
110      * Reverts when dividing by zero.
111      *
112      * Counterpart to Solidity's `%` operator. This function uses a `revert`
113      * opcode (which leaves remaining gas untouched) while Solidity uses an
114      * invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b != 0, "SafeMath: modulo by zero");
121         return a % b;
122     }
123 }
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
127  * the optional functions; to access them see `ERC20Detailed`.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a `Transfer` event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through `transferFrom`. This is
152      * zero by default.
153      *
154      * This value changes when `approve` or `transferFrom` are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * > Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an `Approval` event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a `Transfer` event.
182      */
183     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to `approve`. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 /**
201  * @dev Implementation of the `IERC20` interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using `_mint`.
205  * For a generic mechanism see `ERC20Mintable`.
206  *
207  * *For a detailed writeup see our guide [How to implement supply
208  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
209  *
210  * We have followed general OpenZeppelin guidelines: functions revert instead
211  * of returning `false` on failure. This behavior is nonetheless conventional
212  * and does not conflict with the expectations of ERC20 applications.
213  *
214  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See `IERC20.approve`.
222  */
223 contract ERC20 is IERC20 {
224     using SafeMath for uint256;
225 
226     mapping (address => uint256) private _balances;
227 
228     mapping (address => mapping (address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     /**
233      * @dev See `IERC20.totalSupply`.
234      */
235     function totalSupply() public view returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See `IERC20.balanceOf`.
241      */
242     function balanceOf(address account) public view returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See `IERC20.transfer`.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See `IERC20.allowance`.
261      */
262     function allowance(address owner, address spender) public view returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See `IERC20.approve`.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         _approve(msg.sender, spender, value);
275         return true;
276     }
277 
278     /**
279      * @dev See `IERC20.transferFrom`.
280      *
281      * Emits an `Approval` event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of `ERC20`;
283      *
284      * Requirements:
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `value`.
287      * - the caller must have allowance for `sender`'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to `approve` that can be used as a mitigation for
300      * problems described in `IERC20.approve`.
301      *
302      * Emits an `Approval` event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to `approve` that can be used as a mitigation for
317      * problems described in `IERC20.approve`.
318      *
319      * Emits an `Approval` event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
328         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to `transfer`, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a `Transfer` event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _balances[sender] = _balances[sender].sub(amount);
351         _balances[recipient] = _balances[recipient].add(amount);
352         emit Transfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a `Transfer` event with `from` set to the zero address.
359      *
360      * Requirements
361      *
362      * - `to` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _totalSupply = _totalSupply.add(amount);
368         _balances[account] = _balances[account].add(amount);
369         emit Transfer(address(0), account, amount);
370     }
371 
372      /**
373      * @dev Destoys `amount` tokens from `account`, reducing the
374      * total supply.
375      *
376      * Emits a `Transfer` event with `to` set to the zero address.
377      *
378      * Requirements
379      *
380      * - `account` cannot be the zero address.
381      * - `account` must have at least `amount` tokens.
382      */
383     function _burn(address account, uint256 value) internal {
384         require(account != address(0), "ERC20: burn from the zero address");
385 
386         _totalSupply = _totalSupply.sub(value);
387         _balances[account] = _balances[account].sub(value);
388         emit Transfer(account, address(0), value);
389     }
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
393      *
394      * This is internal function is equivalent to `approve`, and can be used to
395      * e.g. set automatic allowances for certain subsystems, etc.
396      *
397      * Emits an `Approval` event.
398      *
399      * Requirements:
400      *
401      * - `owner` cannot be the zero address.
402      * - `spender` cannot be the zero address.
403      */
404     function _approve(address owner, address spender, uint256 value) internal {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = value;
409         emit Approval(owner, spender, value);
410     }
411 
412     /**
413      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
414      * from the caller's allowance.
415      *
416      * See `_burn` and `_approve`.
417      */
418     function _burnFrom(address account, uint256 amount) internal {
419         _burn(account, amount);
420         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
421     }
422 }
423 /**
424  * @dev Optional functions from the ERC20 standard.
425  */
426 contract ERC20Detailed is IERC20 {
427     string private _name;
428     string private _symbol;
429     uint8 private _decimals;
430 
431     /**
432      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
433      * these values are immutable: they can only be set once during
434      * construction.
435      */
436     constructor (string memory name, string memory symbol, uint8 decimals) public {
437         _name = name;
438         _symbol = symbol;
439         _decimals = decimals;
440     }
441 
442     /**
443      * @dev Returns the name of the token.
444      */
445     function name() public view returns (string memory) {
446         return _name;
447     }
448 
449     /**
450      * @dev Returns the symbol of the token, usually a shorter version of the
451      * name.
452      */
453     function symbol() public view returns (string memory) {
454         return _symbol;
455     }
456 
457     /**
458      * @dev Returns the number of decimals used to get its user representation.
459      * For example, if `decimals` equals `2`, a balance of `505` tokens should
460      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
461      *
462      * Tokens usually opt for a value of 18, imitating the relationship between
463      * Ether and Wei.
464      *
465      * > Note that this information is only used for _display_ purposes: it in
466      * no way affects any of the arithmetic of the contract, including
467      * `IERC20.balanceOf` and `IERC20.transfer`.
468      */
469     function decimals() public view returns (uint8) {
470         return _decimals;
471     }
472 }
473 
474 /**
475  * @title SimpleToken
476  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
477  * Note they can later distribute these tokens as they wish using `transfer` and other
478  * `ERC20` functions.
479  */
480 contract ConchCoin is ERC20, ERC20Detailed {
481 
482     /**
483      * @dev Constructor that gives msg.sender all of existing tokens.
484      */
485     constructor () public ERC20Detailed("Conch Coin", "CC", 18) {
486         _mint(0x788Ad5C5561dA04EfE7dbcc6be4b543C68C632fF, 660000000 * (10 ** uint256(decimals())));
487     }   
488 }