1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b <= a, "SafeMath: subtraction overflow");
118         uint256 c = a - b;
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
136         if (a == 0) {
137             return 0;
138         }
139 
140         uint256 c = a * b;
141         require(c / a == b, "SafeMath: multiplication overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers. Reverts on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b > 0, "SafeMath: division by zero");
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         require(b != 0, "SafeMath: modulo by zero");
179         return a % b;
180     }
181 }
182 /**
183  * @dev Implementation of the `IERC20` interface.
184  *
185  * This implementation is agnostic to the way tokens are created. This means
186  * that a supply mechanism has to be added in a derived contract using `_mint`.
187  * For a generic mechanism see `ERC20Mintable`.
188  *
189  * *For a detailed writeup see our guide [How to implement supply
190  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
191  *
192  * We have followed general OpenZeppelin guidelines: functions revert instead
193  * of returning `false` on failure. This behavior is nonetheless conventional
194  * and does not conflict with the expectations of ERC20 applications.
195  *
196  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
197  * This allows applications to reconstruct the allowance for all accounts just
198  * by listening to said events. Other implementations of the EIP may not emit
199  * these events, as it isn't required by the specification.
200  *
201  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
202  * functions have been added to mitigate the well-known issues around setting
203  * allowances. See `IERC20.approve`.
204  */
205 contract ERC20 is IERC20 {
206     using SafeMath for uint256;
207 
208     mapping (address => uint256) private _balances;
209 
210     mapping (address => mapping (address => uint256)) private _allowances;
211 
212     uint256 private _totalSupply;
213 
214     /**
215      * @dev See `IERC20.totalSupply`.
216      */
217     function totalSupply() public view returns (uint256) {
218         return _totalSupply;
219     }
220 
221     /**
222      * @dev See `IERC20.balanceOf`.
223      */
224     function balanceOf(address account) public view returns (uint256) {
225         return _balances[account];
226     }
227 
228     /**
229      * @dev See `IERC20.transfer`.
230      *
231      * Requirements:
232      *
233      * - `recipient` cannot be the zero address.
234      * - the caller must have a balance of at least `amount`.
235      */
236     function transfer(address recipient, uint256 amount) public returns (bool) {
237         _transfer(msg.sender, recipient, amount);
238         return true;
239     }
240 
241     /**
242      * @dev See `IERC20.allowance`.
243      */
244     function allowance(address owner, address spender) public view returns (uint256) {
245         return _allowances[owner][spender];
246     }
247 
248     /**
249      * @dev See `IERC20.approve`.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      */
255     function approve(address spender, uint256 value) public returns (bool) {
256         _approve(msg.sender, spender, value);
257         return true;
258     }
259 
260     /**
261      * @dev See `IERC20.transferFrom`.
262      *
263      * Emits an `Approval` event indicating the updated allowance. This is not
264      * required by the EIP. See the note at the beginning of `ERC20`;
265      *
266      * Requirements:
267      * - `sender` and `recipient` cannot be the zero address.
268      * - `sender` must have a balance of at least `value`.
269      * - the caller must have allowance for `sender`'s tokens of at least
270      * `amount`.
271      */
272     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
275         return true;
276     }
277 
278     /**
279      * @dev Atomically increases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to `approve` that can be used as a mitigation for
282      * problems described in `IERC20.approve`.
283      *
284      * Emits an `Approval` event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
291         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
292         return true;
293     }
294 
295     /**
296      * @dev Atomically decreases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to `approve` that can be used as a mitigation for
299      * problems described in `IERC20.approve`.
300      *
301      * Emits an `Approval` event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      * - `spender` must have allowance for the caller of at least
307      * `subtractedValue`.
308      */
309     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
310         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
311         return true;
312     }
313 
314     /**
315      * @dev Moves tokens `amount` from `sender` to `recipient`.
316      *
317      * This is internal function is equivalent to `transfer`, and can be used to
318      * e.g. implement automatic token fees, slashing mechanisms, etc.
319      *
320      * Emits a `Transfer` event.
321      *
322      * Requirements:
323      *
324      * - `sender` cannot be the zero address.
325      * - `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `amount`.
327      */
328     function _transfer(address sender, address recipient, uint256 amount) internal {
329         require(sender != address(0), "ERC20: transfer from the zero address");
330         require(recipient != address(0), "ERC20: transfer to the zero address");
331 
332         _balances[sender] = _balances[sender].sub(amount);
333         _balances[recipient] = _balances[recipient].add(amount);
334         emit Transfer(sender, recipient, amount);
335     }
336 
337     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
338      * the total supply.
339      *
340      * Emits a `Transfer` event with `from` set to the zero address.
341      *
342      * Requirements
343      *
344      * - `to` cannot be the zero address.
345      */
346     function _mint(address account, uint256 amount) internal {
347         require(account != address(0), "ERC20: mint to the zero address");
348 
349         _totalSupply = _totalSupply.add(amount);
350         _balances[account] = _balances[account].add(amount);
351         emit Transfer(address(0), account, amount);
352     }
353 
354      /**
355      * @dev Destoys `amount` tokens from `account`, reducing the
356      * total supply.
357      *
358      * Emits a `Transfer` event with `to` set to the zero address.
359      *
360      * Requirements
361      *
362      * - `account` cannot be the zero address.
363      * - `account` must have at least `amount` tokens.
364      */
365     function _burn(address account, uint256 value) internal {
366         require(account != address(0), "ERC20: burn from the zero address");
367 
368         _totalSupply = _totalSupply.sub(value);
369         _balances[account] = _balances[account].sub(value);
370         emit Transfer(account, address(0), value);
371     }
372 
373     /**
374      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
375      *
376      * This is internal function is equivalent to `approve`, and can be used to
377      * e.g. set automatic allowances for certain subsystems, etc.
378      *
379      * Emits an `Approval` event.
380      *
381      * Requirements:
382      *
383      * - `owner` cannot be the zero address.
384      * - `spender` cannot be the zero address.
385      */
386     function _approve(address owner, address spender, uint256 value) internal {
387         require(owner != address(0), "ERC20: approve from the zero address");
388         require(spender != address(0), "ERC20: approve to the zero address");
389 
390         _allowances[owner][spender] = value;
391         emit Approval(owner, spender, value);
392     }
393 
394     /**
395      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
396      * from the caller's allowance.
397      *
398      * See `_burn` and `_approve`.
399      */
400     function _burnFrom(address account, uint256 amount) internal {
401         _burn(account, amount);
402         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
403     }
404 }
405 /**
406  * @dev Optional functions from the ERC20 standard.
407  */
408 contract ERC20Detailed is IERC20 {
409     string private _name;
410     string private _symbol;
411     uint8 private _decimals;
412 
413     /**
414      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
415      * these values are immutable: they can only be set once during
416      * construction.
417      */
418     constructor (string memory name, string memory symbol, uint8 decimals) public {
419         _name = name;
420         _symbol = symbol;
421         _decimals = decimals;
422     }
423 
424     /**
425      * @dev Returns the name of the token.
426      */
427     function name() public view returns (string memory) {
428         return _name;
429     }
430 
431     /**
432      * @dev Returns the symbol of the token, usually a shorter version of the
433      * name.
434      */
435     function symbol() public view returns (string memory) {
436         return _symbol;
437     }
438 
439     /**
440      * @dev Returns the number of decimals used to get its user representation.
441      * For example, if `decimals` equals `2`, a balance of `505` tokens should
442      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
443      *
444      * Tokens usually opt for a value of 18, imitating the relationship between
445      * Ether and Wei.
446      *
447      * > Note that this information is only used for _display_ purposes: it in
448      * no way affects any of the arithmetic of the contract, including
449      * `IERC20.balanceOf` and `IERC20.transfer`.
450      */
451     function decimals() public view returns (uint8) {
452         return _decimals;
453     }
454 }
455 contract NeuronxDCoin is ERC20, ERC20Detailed {
456 
457     string private _name = "NeuronxD";
458     string private _symbol = "NXDD";
459     uint8 private _decimals = 2;
460 
461     address account = msg.sender;
462     uint256 value = 13 * 1e3 * 1e2; // 13 000 total with decimals;
463 
464     constructor() ERC20Detailed( _name, _symbol, _decimals) public {
465         _mint(account, value);
466     }
467 }