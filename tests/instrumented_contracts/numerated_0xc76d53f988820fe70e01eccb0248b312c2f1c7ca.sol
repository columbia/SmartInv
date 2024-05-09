1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a `Transfer` event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through `transferFrom`. This is
26      * zero by default.
27      *
28      * This value changes when `approve` or `transferFrom` are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * > Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an `Approval` event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a `Transfer` event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to `approve`. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
75 
76 pragma solidity ^0.5.0;
77 
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
183 
184 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
185 
186 pragma solidity ^0.5.0;
187 
188 
189 
190 /**
191  * @dev Implementation of the `IERC20` interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using `_mint`.
195  * For a generic mechanism see `ERC20Mintable`.
196  *
197  * *For a detailed writeup see our guide [How to implement supply
198  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
199  *
200  * We have followed general OpenZeppelin guidelines: functions revert instead
201  * of returning `false` on failure. This behavior is nonetheless conventional
202  * and does not conflict with the expectations of ERC20 applications.
203  *
204  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
205  * This allows applications to reconstruct the allowance for all accounts just
206  * by listening to said events. Other implementations of the EIP may not emit
207  * these events, as it isn't required by the specification.
208  *
209  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
210  * functions have been added to mitigate the well-known issues around setting
211  * allowances. See `IERC20.approve`.
212  */
213 contract ERC20 is IERC20 {
214     using SafeMath for uint256;
215 
216     mapping (address => uint256) private _balances;
217 
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     /**
223      * @dev See `IERC20.totalSupply`.
224      */
225     function totalSupply() public view returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See `IERC20.balanceOf`.
231      */
232     function balanceOf(address account) public view returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See `IERC20.transfer`.
238      *
239      * Requirements:
240      *
241      * - `recipient` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address recipient, uint256 amount) public returns (bool) {
245         _transfer(msg.sender, recipient, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See `IERC20.allowance`.
251      */
252     function allowance(address owner, address spender) public view returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See `IERC20.approve`.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function approve(address spender, uint256 value) public returns (bool) {
264         _approve(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev See `IERC20.transferFrom`.
270      *
271      * Emits an `Approval` event indicating the updated allowance. This is not
272      * required by the EIP. See the note at the beginning of `ERC20`;
273      *
274      * Requirements:
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `value`.
277      * - the caller must have allowance for `sender`'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to `approve` that can be used as a mitigation for
290      * problems described in `IERC20.approve`.
291      *
292      * Emits an `Approval` event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
299         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
300         return true;
301     }
302 
303     /**
304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to `approve` that can be used as a mitigation for
307      * problems described in `IERC20.approve`.
308      *
309      * Emits an `Approval` event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      * - `spender` must have allowance for the caller of at least
315      * `subtractedValue`.
316      */
317     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
318         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
319         return true;
320     }
321 
322     /**
323      * @dev Moves tokens `amount` from `sender` to `recipient`.
324      *
325      * This is internal function is equivalent to `transfer`, and can be used to
326      * e.g. implement automatic token fees, slashing mechanisms, etc.
327      *
328      * Emits a `Transfer` event.
329      *
330      * Requirements:
331      *
332      * - `sender` cannot be the zero address.
333      * - `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      */
336     function _transfer(address sender, address recipient, uint256 amount) internal {
337         require(sender != address(0), "ERC20: transfer from the zero address");
338         require(recipient != address(0), "ERC20: transfer to the zero address");
339 
340         _balances[sender] = _balances[sender].sub(amount);
341         _balances[recipient] = _balances[recipient].add(amount);
342         emit Transfer(sender, recipient, amount);
343     }
344 
345     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
346      * the total supply.
347      *
348      * Emits a `Transfer` event with `from` set to the zero address.
349      *
350      * Requirements
351      *
352      * - `to` cannot be the zero address.
353      */
354     function _mint(address account, uint256 amount) internal {
355         require(account != address(0), "ERC20: mint to the zero address");
356 
357         _totalSupply = _totalSupply.add(amount);
358         _balances[account] = _balances[account].add(amount);
359         emit Transfer(address(0), account, amount);
360     }
361 
362      /**
363      * @dev Destroys `amount` tokens from `account`, reducing the
364      * total supply.
365      *
366      * Emits a `Transfer` event with `to` set to the zero address.
367      *
368      * Requirements
369      *
370      * - `account` cannot be the zero address.
371      * - `account` must have at least `amount` tokens.
372      */
373     function _burn(address account, uint256 value) internal {
374         require(account != address(0), "ERC20: burn from the zero address");
375 
376         _totalSupply = _totalSupply.sub(value);
377         _balances[account] = _balances[account].sub(value);
378         emit Transfer(account, address(0), value);
379     }
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
383      *
384      * This is internal function is equivalent to `approve`, and can be used to
385      * e.g. set automatic allowances for certain subsystems, etc.
386      *
387      * Emits an `Approval` event.
388      *
389      * Requirements:
390      *
391      * - `owner` cannot be the zero address.
392      * - `spender` cannot be the zero address.
393      */
394     function _approve(address owner, address spender, uint256 value) internal {
395         require(owner != address(0), "ERC20: approve from the zero address");
396         require(spender != address(0), "ERC20: approve to the zero address");
397 
398         _allowances[owner][spender] = value;
399         emit Approval(owner, spender, value);
400     }
401 
402     /**
403      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
404      * from the caller's allowance.
405      *
406      * See `_burn` and `_approve`.
407      */
408     function _burnFrom(address account, uint256 amount) internal {
409         _burn(account, amount);
410         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
411     }
412 }
413 
414 // File: contracts\ERC20\TokenMintERC20Token.sol
415 
416 pragma solidity ^0.5.0;
417 
418 
419 /**
420  * @title TokenMintERC20Token
421  * @author TokenMint (visit https://tokenmint.io)
422  *
423  * @dev Standard ERC20 token with burning and optional functions implemented.
424  * For full specification of ERC-20 standard see:
425  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
426  */
427 contract Inu is ERC20 {
428 
429     string private _name;
430     string private _symbol;
431     uint8 private _decimals;
432 
433     /**
434      * @dev Constructor.
435      * @param name name of the token
436      * @param symbol symbol of the token, 3-4 chars is recommended
437      * @param decimals number of decimal places of one token unit, 18 is widely used
438      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
439      * @param tokenOwnerAddress address that gets 100% of token supply
440      */
441     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
442       _name = name;
443       _symbol = symbol;
444       _decimals = decimals;
445 
446       // set tokenOwnerAddress as owner of all tokens
447       _mint(tokenOwnerAddress, totalSupply);
448 
449       // pay the service fee for contract deployment
450       feeReceiver.transfer(msg.value);
451     }
452 
453     /**
454      * @dev Burns a specific amount of tokens.
455      * @param value The amount of lowest token units to be burned.
456      */
457     function burn(uint256 value) public {
458       _burn(msg.sender, value);
459     }
460 
461     // optional functions from ERC20 stardard
462 
463     /**
464      * @return the name of the token.
465      */
466     function name() public view returns (string memory) {
467       return _name;
468     }
469 
470     /**
471      * @return the symbol of the token.
472      */
473     function symbol() public view returns (string memory) {
474       return _symbol;
475     }
476 
477     /**
478      * @return the number of decimals of the token.
479      */
480     function decimals() public view returns (uint8) {
481       return _decimals;
482     }
483 }