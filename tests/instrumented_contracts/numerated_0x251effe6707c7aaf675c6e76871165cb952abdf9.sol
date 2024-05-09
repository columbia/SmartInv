1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 contract IERC20 {
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
77 
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a, "SafeMath: subtraction overflow");
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Solidity only automatically asserts when dividing by 0
161         require(b > 0, "SafeMath: division by zero");
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b != 0, "SafeMath: modulo by zero");
181         return a % b;
182     }
183 }
184 
185 /**
186  * @dev Implementation of the `IERC20` interface.
187  *
188  * This implementation is agnostic to the way tokens are created. This means
189  * that a supply mechanism has to be added in a derived contract using `_mint`.
190  * For a generic mechanism see `ERC20Mintable`.
191  *
192  * *For a detailed writeup see our guide [How to implement supply
193  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
194  *
195  * We have followed general OpenZeppelin guidelines: functions revert instead
196  * of returning `false` on failure. This behavior is nonetheless conventional
197  * and does not conflict with the expectations of ERC20 applications.
198  *
199  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
200  * This allows applications to reconstruct the allowance for all accounts just
201  * by listening to said events. Other implementations of the EIP may not emit
202  * these events, as it isn't required by the specification.
203  *
204  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
205  * functions have been added to mitigate the well-known issues around setting
206  * allowances. See `IERC20.approve`.
207  */
208 contract ERC20 is IERC20 {
209     using SafeMath for uint256;
210 
211     mapping (address => uint256) private _balances;
212 
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     /**
218      * @dev See `IERC20.totalSupply`.
219      */
220     function totalSupply() public view returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev See `IERC20.balanceOf`.
226      */
227     function balanceOf(address account) public view returns (uint256) {
228         return _balances[account];
229     }
230 
231     /**
232      * @dev See `IERC20.transfer`.
233      *
234      * Requirements:
235      *
236      * - `recipient` cannot be the zero address.
237      * - the caller must have a balance of at least `amount`.
238      */
239     function transfer(address recipient, uint256 amount) public returns (bool) {
240         _transfer(msg.sender, recipient, amount);
241         return true;
242     }
243 
244     /**
245      * @dev See `IERC20.allowance`.
246      */
247     function allowance(address owner, address spender) public view returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     /**
252      * @dev See `IERC20.approve`.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      */
258     function approve(address spender, uint256 value) public returns (bool) {
259         _approve(msg.sender, spender, value);
260         return true;
261     }
262 
263     /**
264      * @dev See `IERC20.transferFrom`.
265      *
266      * Emits an `Approval` event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of `ERC20`;
268      *
269      * Requirements:
270      * - `sender` and `recipient` cannot be the zero address.
271      * - `sender` must have a balance of at least `value`.
272      * - the caller must have allowance for `sender`'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to `approve` that can be used as a mitigation for
285      * problems described in `IERC20.approve`.
286      *
287      * Emits an `Approval` event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to `approve` that can be used as a mitigation for
302      * problems described in `IERC20.approve`.
303      *
304      * Emits an `Approval` event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
313         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
314         return true;
315     }
316 
317     /**
318      * @dev Moves tokens `amount` from `sender` to `recipient`.
319      *
320      * This is internal function is equivalent to `transfer`, and can be used to
321      * e.g. implement automatic token fees, slashing mechanisms, etc.
322      *
323      * Emits a `Transfer` event.
324      *
325      * Requirements:
326      *
327      * - `sender` cannot be the zero address.
328      * - `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      */
331     function _transfer(address sender, address recipient, uint256 amount) internal {
332         require(sender != address(0), "ERC20: transfer from the zero address");
333         require(recipient != address(0), "ERC20: transfer to the zero address");
334 
335         _balances[sender] = _balances[sender].sub(amount);
336         _balances[recipient] = _balances[recipient].add(amount);
337         emit Transfer(sender, recipient, amount);
338     }
339 
340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
341      * the total supply.
342      *
343      * Emits a `Transfer` event with `from` set to the zero address.
344      *
345      * Requirements
346      *
347      * - `to` cannot be the zero address.
348      */
349     function _mint(address account, uint256 amount) internal {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _totalSupply = _totalSupply.add(amount);
353         _balances[account] = _balances[account].add(amount);
354         emit Transfer(address(0), account, amount);
355     }
356 
357      /**
358      * @dev Destroys `amount` tokens from `account`, reducing the
359      * total supply.
360      *
361      * Emits a `Transfer` event with `to` set to the zero address.
362      *
363      * Requirements
364      *
365      * - `account` cannot be the zero address.
366      * - `account` must have at least `amount` tokens.
367      */
368     function _burn(address account, uint256 value) internal {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _totalSupply = _totalSupply.sub(value);
372         _balances[account] = _balances[account].sub(value);
373         emit Transfer(account, address(0), value);
374     }
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
378      *
379      * This is internal function is equivalent to `approve`, and can be used to
380      * e.g. set automatic allowances for certain subsystems, etc.
381      *
382      * Emits an `Approval` event.
383      *
384      * Requirements:
385      *
386      * - `owner` cannot be the zero address.
387      * - `spender` cannot be the zero address.
388      */
389     function _approve(address owner, address spender, uint256 value) internal {
390         require(owner != address(0), "ERC20: approve from the zero address");
391         require(spender != address(0), "ERC20: approve to the zero address");
392 
393         _allowances[owner][spender] = value;
394         emit Approval(owner, spender, value);
395     }
396 
397     /**
398      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
399      * from the caller's allowance.
400      *
401      * See `_burn` and `_approve`.
402      */
403     function _burnFrom(address account, uint256 amount) internal {
404         _burn(account, amount);
405         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
406     }
407 }
408 
409 /**
410  * @title ERC20Token
411  *
412  * @dev Standard ERC20 token with burning and optional functions implemented.
413  * For full specification of ERC-20 standard see:
414  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
415  */
416 contract ERC20Token is ERC20 {
417 
418     string private _name;
419     string private _symbol;
420     uint8 private _decimals;
421 
422     /**
423      * @dev Constructor.
424      * @param name name of the token
425      * @param symbol symbol of the token, 3-4 chars is recommended
426      * @param decimals number of decimal places of one token unit, 18 is widely used
427      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
428      * @param tokenOwnerAddress address that gets 100% of token supply
429      */
430     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
431       _name = name;
432       _symbol = symbol;
433       _decimals = decimals;
434 
435       // set tokenOwnerAddress as owner of all tokens
436       _mint(tokenOwnerAddress, totalSupply);
437     }
438 
439     /**
440      * @dev Burns a specific amount of tokens.
441      * @param value The amount of lowest token units to be burned.
442      */
443     function burn(uint256 value) public {
444       _burn(msg.sender, value);
445     }
446 
447     // optional functions from ERC20 stardard
448 
449     /**
450      * @return the name of the token.
451      */
452     function name() public view returns (string memory) {
453       return _name;
454     }
455 
456     /**
457      * @return the symbol of the token.
458      */
459     function symbol() public view returns (string memory) {
460       return _symbol;
461     }
462 
463     /**
464      * @return the number of decimals of the token.
465      */
466     function decimals() public view returns (uint8) {
467       return _decimals;
468     }
469 }