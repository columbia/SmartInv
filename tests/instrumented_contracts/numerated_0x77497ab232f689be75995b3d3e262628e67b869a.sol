1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see `ERC20Detailed`.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a `Transfer` event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through `transferFrom`. This is
31      * zero by default.
32      *
33      * This value changes when `approve` or `transferFrom` are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * > Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an `Approval` event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a `Transfer` event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to `approve`. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 /**
184  * @dev Implementation of the `IERC20` interface.
185  *
186  * This implementation is agnostic to the way tokens are created. This means
187  * that a supply mechanism has to be added in a derived contract using `_mint`.
188  * For a generic mechanism see `ERC20Mintable`.
189  *
190  * *For a detailed writeup see our guide [How to implement supply
191  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
192  *
193  * We have followed general OpenZeppelin guidelines: functions revert instead
194  * of returning `false` on failure. This behavior is nonetheless conventional
195  * and does not conflict with the expectations of ERC20 applications.
196  *
197  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
198  * This allows applications to reconstruct the allowance for all accounts just
199  * by listening to said events. Other implementations of the EIP may not emit
200  * these events, as it isn't required by the specification.
201  *
202  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
203  * functions have been added to mitigate the well-known issues around setting
204  * allowances. See `IERC20.approve`.
205  */
206 contract ERC20 is IERC20 {
207     using SafeMath for uint256;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowances;
212 
213     uint256 private _totalSupply;
214 
215     /**
216      * @dev See `IERC20.totalSupply`.
217      */
218     function totalSupply() public view returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See `IERC20.balanceOf`.
224      */
225     function balanceOf(address account) public view returns (uint256) {
226         return _balances[account];
227     }
228 
229     /**
230      * @dev See `IERC20.transfer`.
231      *
232      * Requirements:
233      *
234      * - `recipient` cannot be the zero address.
235      * - the caller must have a balance of at least `amount`.
236      */
237     function transfer(address recipient, uint256 amount) public returns (bool) {
238         _transfer(msg.sender, recipient, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See `IERC20.allowance`.
244      */
245     function allowance(address owner, address spender) public view returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     /**
250      * @dev See `IERC20.approve`.
251      *
252      * Requirements:
253      *
254      * - `spender` cannot be the zero address.
255      */
256     function approve(address spender, uint256 value) public returns (bool) {
257         _approve(msg.sender, spender, value);
258         return true;
259     }
260 
261     /**
262      * @dev See `IERC20.transferFrom`.
263      *
264      * Emits an `Approval` event indicating the updated allowance. This is not
265      * required by the EIP. See the note at the beginning of `ERC20`;
266      *
267      * Requirements:
268      * - `sender` and `recipient` cannot be the zero address.
269      * - `sender` must have a balance of at least `value`.
270      * - the caller must have allowance for `sender`'s tokens of at least
271      * `amount`.
272      */
273     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
276         return true;
277     }
278 
279     /**
280      * @dev Atomically increases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to `approve` that can be used as a mitigation for
283      * problems described in `IERC20.approve`.
284      *
285      * Emits an `Approval` event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
292         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
293         return true;
294     }
295 
296     /**
297      * @dev Atomically decreases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to `approve` that can be used as a mitigation for
300      * problems described in `IERC20.approve`.
301      *
302      * Emits an `Approval` event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `spender` must have allowance for the caller of at least
308      * `subtractedValue`.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
311         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
312         return true;
313     }
314 
315     /**
316      * @dev Moves tokens `amount` from `sender` to `recipient`.
317      *
318      * This is internal function is equivalent to `transfer`, and can be used to
319      * e.g. implement automatic token fees, slashing mechanisms, etc.
320      *
321      * Emits a `Transfer` event.
322      *
323      * Requirements:
324      *
325      * - `sender` cannot be the zero address.
326      * - `recipient` cannot be the zero address.
327      * - `sender` must have a balance of at least `amount`.
328      */
329     function _transfer(address sender, address recipient, uint256 amount) internal {
330         require(sender != address(0), "ERC20: transfer from the zero address");
331         require(recipient != address(0), "ERC20: transfer to the zero address");
332 
333         _balances[sender] = _balances[sender].sub(amount);
334         _balances[recipient] = _balances[recipient].add(amount);
335         emit Transfer(sender, recipient, amount);
336     }
337 
338     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
339      * the total supply.
340      *
341      * Emits a `Transfer` event with `from` set to the zero address.
342      *
343      * Requirements
344      *
345      * - `to` cannot be the zero address.
346      */
347     function _mint(address account, uint256 amount) internal {
348         require(account != address(0), "ERC20: mint to the zero address");
349 
350         _totalSupply = _totalSupply.add(amount);
351         _balances[account] = _balances[account].add(amount);
352         emit Transfer(address(0), account, amount);
353     }
354 
355      /**
356      * @dev Destoys `amount` tokens from `account`, reducing the
357      * total supply.
358      *
359      * Emits a `Transfer` event with `to` set to the zero address.
360      *
361      * Requirements
362      *
363      * - `account` cannot be the zero address.
364      * - `account` must have at least `amount` tokens.
365      */
366     function _burn(address account, uint256 value) internal {
367         require(account != address(0), "ERC20: burn from the zero address");
368 
369         _totalSupply = _totalSupply.sub(value);
370         _balances[account] = _balances[account].sub(value);
371         emit Transfer(account, address(0), value);
372     }
373 
374     /**
375      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
376      *
377      * This is internal function is equivalent to `approve`, and can be used to
378      * e.g. set automatic allowances for certain subsystems, etc.
379      *
380      * Emits an `Approval` event.
381      *
382      * Requirements:
383      *
384      * - `owner` cannot be the zero address.
385      * - `spender` cannot be the zero address.
386      */
387     function _approve(address owner, address spender, uint256 value) internal {
388         require(owner != address(0), "ERC20: approve from the zero address");
389         require(spender != address(0), "ERC20: approve to the zero address");
390 
391         _allowances[owner][spender] = value;
392         emit Approval(owner, spender, value);
393     }
394 
395     /**
396      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
397      * from the caller's allowance.
398      *
399      * See `_burn` and `_approve`.
400      */
401     function _burnFrom(address account, uint256 amount) internal {
402         _burn(account, amount);
403         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
404     }
405 }
406 /**
407  * @dev Optional functions from the ERC20 standard.
408  */
409 contract ERC20Detailed is IERC20 {
410     string private _name;
411     string private _symbol;
412     uint8 private _decimals;
413 
414     /**
415      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
416      * these values are immutable: they can only be set once during
417      * construction.
418      */
419     constructor (string memory name, string memory symbol, uint8 decimals) public {
420         _name = name;
421         _symbol = symbol;
422         _decimals = decimals;
423     }
424 
425     /**
426      * @dev Returns the name of the token.
427      */
428     function name() public view returns (string memory) {
429         return _name;
430     }
431 
432     /**
433      * @dev Returns the symbol of the token, usually a shorter version of the
434      * name.
435      */
436     function symbol() public view returns (string memory) {
437         return _symbol;
438     }
439 
440     /**
441      * @dev Returns the number of decimals used to get its user representation.
442      * For example, if `decimals` equals `2`, a balance of `505` tokens should
443      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
444      *
445      * Tokens usually opt for a value of 18, imitating the relationship between
446      * Ether and Wei.
447      *
448      * > Note that this information is only used for _display_ purposes: it in
449      * no way affects any of the arithmetic of the contract, including
450      * `IERC20.balanceOf` and `IERC20.transfer`.
451      */
452     function decimals() public view returns (uint8) {
453         return _decimals;
454     }
455 }
456 contract QBToken is ERC20, ERC20Detailed {
457 
458   uint private INITIAL_SUPPLY = 2000000000e18;
459 
460   constructor() public
461     ERC20Detailed("QB Token", "QB", 18)
462   {
463     _mint(msg.sender, INITIAL_SUPPLY);
464   }
465 
466 }