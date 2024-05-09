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
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see `ERC20Detailed`.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a `Transfer` event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through `transferFrom`. This is
136      * zero by default.
137      *
138      * This value changes when `approve` or `transferFrom` are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * > Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an `Approval` event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a `Transfer` event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to `approve`. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using `_mint`.
189  * For a generic mechanism see `ERC20Mintable`.
190  *
191  * *For a detailed writeup see our guide [How to implement supply
192  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
193  *
194  * We have followed general OpenZeppelin guidelines: functions revert instead
195  * of returning `false` on failure. This behavior is nonetheless conventional
196  * and does not conflict with the expectations of ERC20 applications.
197  *
198  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
199  * This allows applications to reconstruct the allowance for all accounts just
200  * by listening to said events. Other implementations of the EIP may not emit
201  * these events, as it isn't required by the specification.
202  *
203  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
204  * functions have been added to mitigate the well-known issues around setting
205  * allowances. See `IERC20.approve`.
206  */
207 contract ERC20 is IERC20 {
208     using SafeMath for uint256;
209 
210     mapping (address => uint256) private _balances;
211 
212     mapping (address => mapping (address => uint256)) private _allowances;
213 
214     uint256 private _totalSupply;
215 
216     /**
217      * @dev See `IERC20.totalSupply`.
218      */
219     function totalSupply() public view returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See `IERC20.balanceOf`.
225      */
226     function balanceOf(address account) public view returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See `IERC20.transfer`.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public returns (bool) {
239         _transfer(msg.sender, recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See `IERC20.allowance`.
245      */
246     function allowance(address owner, address spender) public view returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See `IERC20.approve`.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         _approve(msg.sender, spender, value);
259         return true;
260     }
261 
262     /**
263      * @dev See `IERC20.transferFrom`.
264      *
265      * Emits an `Approval` event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of `ERC20`;
267      *
268      * Requirements:
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `value`.
271      * - the caller must have allowance for `sender`'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to `approve` that can be used as a mitigation for
284      * problems described in `IERC20.approve`.
285      *
286      * Emits an `Approval` event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
293         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to `approve` that can be used as a mitigation for
301      * problems described in `IERC20.approve`.
302      *
303      * Emits an `Approval` event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to `transfer`, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a `Transfer` event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _balances[sender] = _balances[sender].sub(amount);
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
340      * the total supply.
341      *
342      * Emits a `Transfer` event with `from` set to the zero address.
343      *
344      * Requirements
345      *
346      * - `to` cannot be the zero address.
347      */
348     function _mint(address account, uint256 amount) internal {
349         require(account != address(0), "ERC20: mint to the zero address");
350 
351         _totalSupply = _totalSupply.add(amount);
352         _balances[account] = _balances[account].add(amount);
353         emit Transfer(address(0), account, amount);
354     }
355 
356      /**
357      * @dev Destoys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a `Transfer` event with `to` set to the zero address.
361      *
362      * Requirements
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
377      *
378      * This is internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an `Approval` event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 value) internal {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = value;
393         emit Approval(owner, spender, value);
394     }
395 
396     /**
397      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
398      * from the caller's allowance.
399      *
400      * See `_burn` and `_approve`.
401      */
402     function _burnFrom(address account, uint256 amount) internal {
403         _burn(account, amount);
404         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
405     }
406 }
407 /**
408  * @dev Optional functions from the ERC20 standard.
409  */
410 contract ERC20Detailed is IERC20 {
411     string private _name;
412     string private _symbol;
413     uint8 private _decimals;
414 
415     /**
416      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
417      * these values are immutable: they can only be set once during
418      * construction.
419      */
420     constructor (string memory name, string memory symbol, uint8 decimals) public {
421         _name = name;
422         _symbol = symbol;
423         _decimals = decimals;
424     }
425 
426     /**
427      * @dev Returns the name of the token.
428      */
429     function name() public view returns (string memory) {
430         return _name;
431     }
432 
433     /**
434      * @dev Returns the symbol of the token, usually a shorter version of the
435      * name.
436      */
437     function symbol() public view returns (string memory) {
438         return _symbol;
439     }
440 
441     /**
442      * @dev Returns the number of decimals used to get its user representation.
443      * For example, if `decimals` equals `2`, a balance of `505` tokens should
444      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
445      *
446      * Tokens usually opt for a value of 18, imitating the relationship between
447      * Ether and Wei.
448      *
449      * > Note that this information is only used for _display_ purposes: it in
450      * no way affects any of the arithmetic of the contract, including
451      * `IERC20.balanceOf` and `IERC20.transfer`.
452      */
453     function decimals() public view returns (uint8) {
454         return _decimals;
455     }
456 }
457 
458 /**
459  * @title SimpleToken
460  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
461  * Note they can later distribute these tokens as they wish using `transfer` and other
462  * `ERC20` functions.
463  */
464 contract GLO is ERC20, ERC20Detailed {
465 
466     /**
467      * @dev Constructor that gives msg.sender all of existing tokens.
468      */
469     constructor () public ERC20Detailed("GLOSFER TOKEN", "GLO", 18) {
470         _mint(0xA563c54bc9dc24D60D172A5C82799348230D35B0, 4000000000 * (10 ** uint256(decimals())));
471     }   
472 }