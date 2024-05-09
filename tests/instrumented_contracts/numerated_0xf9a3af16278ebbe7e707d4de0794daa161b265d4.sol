1 pragma solidity ^0.5.0;
2 
3 
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
8  * the optional functions; to access them see `ERC20Detailed`.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a `Transfer` event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through `transferFrom`. This is
33      * zero by default.
34      *
35      * This value changes when `approve` or `transferFrom` are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * > Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an `Approval` event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a `Transfer` event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to `approve`. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 /**
83  * @dev Optional functions from the ERC20 standard.
84  */
85 contract ERC20Detailed is IERC20 {
86     string private _name;
87     string private _symbol;
88     uint8 private _decimals;
89 
90     /**
91      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
92      * these values are immutable: they can only be set once during
93      * construction.
94      */
95     constructor (string memory name, string memory symbol, uint8 decimals) public {
96         _name = name;
97         _symbol = symbol;
98         _decimals = decimals;
99     }
100 
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() public view returns (string memory) {
105         return _name;
106     }
107 
108     /**
109      * @dev Returns the symbol of the token, usually a shorter version of the
110      * name.
111      */
112     function symbol() public view returns (string memory) {
113         return _symbol;
114     }
115 
116     /**
117      * @dev Returns the number of decimals used to get its user representation.
118      * For example, if `decimals` equals `2`, a balance of `505` tokens should
119      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
120      *
121      * Tokens usually opt for a value of 18, imitating the relationship between
122      * Ether and Wei.
123      *
124      * > Note that this information is only used for _display_ purposes: it in
125      * no way affects any of the arithmetic of the contract, including
126      * `IERC20.balanceOf` and `IERC20.transfer`.
127      */
128     function decimals() public view returns (uint8) {
129         return _decimals;
130     }
131 }
132 
133 
134 
135 
136 
137 
138 /**
139  * @dev Wrappers over Solidity's arithmetic operations with added overflow
140  * checks.
141  *
142  * Arithmetic operations in Solidity wrap on overflow. This can easily result
143  * in bugs, because programmers usually assume that an overflow raises an
144  * error, which is the standard behavior in high level programming languages.
145  * `SafeMath` restores this intuition by reverting the transaction when an
146  * operation overflows.
147  *
148  * Using this library instead of the unchecked operations eliminates an entire
149  * class of bugs, so it's recommended to use it always.
150  */
151 library SafeMath {
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;
163         require(c >= a, "SafeMath: addition overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178         require(b <= a, "SafeMath: subtraction overflow");
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0, "SafeMath: division by zero");
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b != 0, "SafeMath: modulo by zero");
240         return a % b;
241     }
242 }
243 
244 
245 /**
246  * @dev Implementation of the `IERC20` interface.
247  *
248  * This implementation is agnostic to the way tokens are created. This means
249  * that a supply mechanism has to be added in a derived contract using `_mint`.
250  * For a generic mechanism see `ERC20Mintable`.
251  *
252  * *For a detailed writeup see our guide [How to implement supply
253  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
254  *
255  * We have followed general OpenZeppelin guidelines: functions revert instead
256  * of returning `false` on failure. This behavior is nonetheless conventional
257  * and does not conflict with the expectations of ERC20 applications.
258  *
259  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See `IERC20.approve`.
267  */
268 contract ERC20 is IERC20 {
269     using SafeMath for uint256;
270 
271     mapping (address => uint256) private _balances;
272 
273     mapping (address => mapping (address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     /**
278      * @dev See `IERC20.totalSupply`.
279      */
280     function totalSupply() public view returns (uint256) {
281         return _totalSupply;
282     }
283 
284     /**
285      * @dev See `IERC20.balanceOf`.
286      */
287     function balanceOf(address account) public view returns (uint256) {
288         return _balances[account];
289     }
290 
291     /**
292      * @dev See `IERC20.transfer`.
293      *
294      * Requirements:
295      *
296      * - `recipient` cannot be the zero address.
297      * - the caller must have a balance of at least `amount`.
298      */
299     function transfer(address recipient, uint256 amount) public returns (bool) {
300         _transfer(msg.sender, recipient, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See `IERC20.allowance`.
306      */
307     function allowance(address owner, address spender) public view returns (uint256) {
308         return _allowances[owner][spender];
309     }
310 
311     /**
312      * @dev See `IERC20.approve`.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function approve(address spender, uint256 value) public returns (bool) {
319         _approve(msg.sender, spender, value);
320         return true;
321     }
322 
323     /**
324      * @dev See `IERC20.transferFrom`.
325      *
326      * Emits an `Approval` event indicating the updated allowance. This is not
327      * required by the EIP. See the note at the beginning of `ERC20`;
328      *
329      * Requirements:
330      * - `sender` and `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `value`.
332      * - the caller must have allowance for `sender`'s tokens of at least
333      * `amount`.
334      */
335     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
336         _transfer(sender, recipient, amount);
337         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
338         return true;
339     }
340 
341     /**
342      * @dev Atomically increases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to `approve` that can be used as a mitigation for
345      * problems described in `IERC20.approve`.
346      *
347      * Emits an `Approval` event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
354         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
355         return true;
356     }
357 
358     /**
359      * @dev Atomically decreases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to `approve` that can be used as a mitigation for
362      * problems described in `IERC20.approve`.
363      *
364      * Emits an `Approval` event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      * - `spender` must have allowance for the caller of at least
370      * `subtractedValue`.
371      */
372     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
373         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
374         return true;
375     }
376 
377     /**
378      * @dev Moves tokens `amount` from `sender` to `recipient`.
379      *
380      * This is internal function is equivalent to `transfer`, and can be used to
381      * e.g. implement automatic token fees, slashing mechanisms, etc.
382      *
383      * Emits a `Transfer` event.
384      *
385      * Requirements:
386      *
387      * - `sender` cannot be the zero address.
388      * - `recipient` cannot be the zero address.
389      * - `sender` must have a balance of at least `amount`.
390      */
391     function _transfer(address sender, address recipient, uint256 amount) internal {
392         require(sender != address(0), "ERC20: transfer from the zero address");
393         require(recipient != address(0), "ERC20: transfer to the zero address");
394 
395         _balances[sender] = _balances[sender].sub(amount);
396         _balances[recipient] = _balances[recipient].add(amount);
397         emit Transfer(sender, recipient, amount);
398     }
399 
400     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
401      * the total supply.
402      *
403      * Emits a `Transfer` event with `from` set to the zero address.
404      *
405      * Requirements
406      *
407      * - `to` cannot be the zero address.
408      */
409     function _mint(address account, uint256 amount) internal {
410         require(account != address(0), "ERC20: mint to the zero address");
411 
412         _totalSupply = _totalSupply.add(amount);
413         _balances[account] = _balances[account].add(amount);
414         emit Transfer(address(0), account, amount);
415     }
416 
417      /**
418      * @dev Destoys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a `Transfer` event with `to` set to the zero address.
422      *
423      * Requirements
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 value) internal {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _totalSupply = _totalSupply.sub(value);
432         _balances[account] = _balances[account].sub(value);
433         emit Transfer(account, address(0), value);
434     }
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
438      *
439      * This is internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an `Approval` event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(address owner, address spender, uint256 value) internal {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = value;
454         emit Approval(owner, spender, value);
455     }
456 
457     /**
458      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
459      * from the caller's allowance.
460      *
461      * See `_burn` and `_approve`.
462      */
463     function _burnFrom(address account, uint256 amount) internal {
464         _burn(account, amount);
465         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
466     }
467 }
468 
469 
470 contract ETPIG is ERC20, ERC20Detailed {
471     constructor() ERC20Detailed("ETPIG", "PIGE", 18) public {
472         _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
473     }
474 }