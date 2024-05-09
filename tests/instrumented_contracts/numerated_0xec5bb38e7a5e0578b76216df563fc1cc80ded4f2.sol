1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, "SafeMath: division by zero");
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95      * Reverts when dividing by zero.
96      *
97      * Counterpart to Solidity's `%` operator. This function uses a `revert`
98      * opcode (which leaves remaining gas untouched) while Solidity uses an
99      * invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "SafeMath: modulo by zero");
106         return a % b;
107     }
108 }
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
185 /**
186  * @dev Optional functions from the ERC20 standard.
187  */
188 contract ERC20Detailed is IERC20 {
189     string private _name;
190     string private _symbol;
191     uint8 private _decimals;
192 
193     /**
194      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
195      * these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor (string memory name, string memory symbol, uint8 decimals) public {
199         _name = name;
200         _symbol = symbol;
201         _decimals = decimals;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei.
226      *
227      * > Note that this information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * `IERC20.balanceOf` and `IERC20.transfer`.
230      */
231     function decimals() public view returns (uint8) {
232         return _decimals;
233     }
234 }
235 
236 
237 /**
238  * @dev Implementation of the `IERC20` interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using `_mint`.
242  * For a generic mechanism see `ERC20Mintable`.
243  *
244  * *For a detailed writeup see our guide [How to implement supply
245  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
246  *
247  * We have followed general OpenZeppelin guidelines: functions revert instead
248  * of returning `false` on failure. This behavior is nonetheless conventional
249  * and does not conflict with the expectations of ERC20 applications.
250  *
251  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See `IERC20.approve`.
259  */
260 contract ERC20 is IERC20 {
261     using SafeMath for uint256;
262 
263     mapping (address => uint256) private _balances;
264 
265     mapping (address => mapping (address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     /**
270      * @dev See `IERC20.totalSupply`.
271      */
272     function totalSupply() public view returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277      * @dev See `IERC20.balanceOf`.
278      */
279     function balanceOf(address account) public view returns (uint256) {
280         return _balances[account];
281     }
282 
283     /**
284      * @dev See `IERC20.transfer`.
285      *
286      * Requirements:
287      *
288      * - `recipient` cannot be the zero address.
289      * - the caller must have a balance of at least `amount`.
290      */
291     function transfer(address recipient, uint256 amount) public returns (bool) {
292         _transfer(msg.sender, recipient, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See `IERC20.allowance`.
298      */
299     function allowance(address owner, address spender) public view returns (uint256) {
300         return _allowances[owner][spender];
301     }
302 
303     /**
304      * @dev See `IERC20.approve`.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function approve(address spender, uint256 value) public returns (bool) {
311         _approve(msg.sender, spender, value);
312         return true;
313     }
314 
315     /**
316      * @dev See `IERC20.transferFrom`.
317      *
318      * Emits an `Approval` event indicating the updated allowance. This is not
319      * required by the EIP. See the note at the beginning of `ERC20`;
320      *
321      * Requirements:
322      * - `sender` and `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `value`.
324      * - the caller must have allowance for `sender`'s tokens of at least
325      * `amount`.
326      */
327     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to `approve` that can be used as a mitigation for
337      * problems described in `IERC20.approve`.
338      *
339      * Emits an `Approval` event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
346         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to `approve` that can be used as a mitigation for
354      * problems described in `IERC20.approve`.
355      *
356      * Emits an `Approval` event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
365         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
366         return true;
367     }
368 
369     /**
370      * @dev Moves tokens `amount` from `sender` to `recipient`.
371      *
372      * This is internal function is equivalent to `transfer`, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a `Transfer` event.
376      *
377      * Requirements:
378      *
379      * - `sender` cannot be the zero address.
380      * - `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      */
383     function _transfer(address sender, address recipient, uint256 amount) internal {
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386 
387         _balances[sender] = _balances[sender].sub(amount);
388         _balances[recipient] = _balances[recipient].add(amount);
389         emit Transfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a `Transfer` event with `from` set to the zero address.
396      *
397      * Requirements
398      *
399      * - `to` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _totalSupply = _totalSupply.add(amount);
405         _balances[account] = _balances[account].add(amount);
406         emit Transfer(address(0), account, amount);
407     }
408 
409      /**
410      * @dev Destoys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a `Transfer` event with `to` set to the zero address.
414      *
415      * Requirements
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 value) internal {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _totalSupply = _totalSupply.sub(value);
424         _balances[account] = _balances[account].sub(value);
425         emit Transfer(account, address(0), value);
426     }
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
430      *
431      * This is internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an `Approval` event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(address owner, address spender, uint256 value) internal {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = value;
446         emit Approval(owner, spender, value);
447     }
448 
449     /**
450      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
451      * from the caller's allowance.
452      *
453      * See `_burn` and `_approve`.
454      */
455     function _burnFrom(address account, uint256 amount) internal {
456         _burn(account, amount);
457         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
458     }
459 }
460 
461 /**
462  * @title MyToken
463  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
464  * Note they can later distribute these tokens as they wish using `transfer` and other
465  * `ERC20` functions.
466  */
467 contract DcoinToken is ERC20, ERC20Detailed {
468     uint8 public constant DECIMALS = 18;
469     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
470     /**
471      * @dev Constructor that gives msg.sender all of existing tokens.
472      */
473     constructor () public ERC20Detailed("DcoinToken", "DT", DECIMALS) {
474         _mint(msg.sender, INITIAL_SUPPLY);
475     }
476 }