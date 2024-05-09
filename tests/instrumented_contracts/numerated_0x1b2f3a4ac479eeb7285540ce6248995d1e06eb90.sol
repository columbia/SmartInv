1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-26
3 */
4 /**
5  *Submitted for verification at Etherscan.io on 2019-08-02
6 */
7 
8 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
9 
10 pragma solidity ^0.5.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
14  * the optional functions; to access them see `ERC20Detailed`.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a `Transfer` event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through `transferFrom`. This is
39      * zero by default.
40      *
41      * This value changes when `approve` or `transferFrom` are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * > Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an `Approval` event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a `Transfer` event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to `approve`. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
88 
89 pragma solidity ^0.5.0;
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b <= a, "SafeMath: subtraction overflow");
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Solidity only automatically asserts when dividing by 0
173         require(b > 0, "SafeMath: division by zero");
174         uint256 c = a / b;
175         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         require(b != 0, "SafeMath: modulo by zero");
193         return a % b;
194     }
195 }
196 
197 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
198 
199 pragma solidity ^0.5.0;
200 
201 
202 
203 /**
204  * @dev Implementation of the `IERC20` interface.
205  *
206  * This implementation is agnostic to the way tokens are created. This means
207  * that a supply mechanism has to be added in a derived contract using `_mint`.
208  * For a generic mechanism see `ERC20Mintable`.
209  *
210  * *For a detailed writeup see our guide [How to implement supply
211  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
212  *
213  * We have followed general OpenZeppelin guidelines: functions revert instead
214  * of returning `false` on failure. This behavior is nonetheless conventional
215  * and does not conflict with the expectations of ERC20 applications.
216  *
217  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
218  * This allows applications to reconstruct the allowance for all accounts just
219  * by listening to said events. Other implementations of the EIP may not emit
220  * these events, as it isn't required by the specification.
221  *
222  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
223  * functions have been added to mitigate the well-known issues around setting
224  * allowances. See `IERC20.approve`.
225  */
226 contract ERC20 is IERC20 {
227     using SafeMath for uint256;
228 
229     mapping (address => uint256) private _balances;
230 
231     mapping (address => mapping (address => uint256)) private _allowances;
232 
233     uint256 private _totalSupply;
234 
235     /**
236      * @dev See `IERC20.totalSupply`.
237      */
238     function totalSupply() public view returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See `IERC20.balanceOf`.
244      */
245     function balanceOf(address account) public view returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See `IERC20.transfer`.
251      *
252      * Requirements:
253      *
254      * - `recipient` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address recipient, uint256 amount) public returns (bool) {
258         _transfer(msg.sender, recipient, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See `IERC20.allowance`.
264      */
265     function allowance(address owner, address spender) public view returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See `IERC20.approve`.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      */
276     function approve(address spender, uint256 value) public returns (bool) {
277         _approve(msg.sender, spender, value);
278         return true;
279     }
280 
281     /**
282      * @dev See `IERC20.transferFrom`.
283      *
284      * Emits an `Approval` event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of `ERC20`;
286      *
287      * Requirements:
288      * - `sender` and `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `value`.
290      * - the caller must have allowance for `sender`'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
294         _transfer(sender, recipient, amount);
295         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to `approve` that can be used as a mitigation for
303      * problems described in `IERC20.approve`.
304      *
305      * Emits an `Approval` event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Atomically decreases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to `approve` that can be used as a mitigation for
320      * problems described in `IERC20.approve`.
321      *
322      * Emits an `Approval` event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      * - `spender` must have allowance for the caller of at least
328      * `subtractedValue`.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
331         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
332         return true;
333     }
334 
335     /**
336      * @dev Moves tokens `amount` from `sender` to `recipient`.
337      *
338      * This is internal function is equivalent to `transfer`, and can be used to
339      * e.g. implement automatic token fees, slashing mechanisms, etc.
340      *
341      * Emits a `Transfer` event.
342      *
343      * Requirements:
344      *
345      * - `sender` cannot be the zero address.
346      * - `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      */
349     function _transfer(address sender, address recipient, uint256 amount) internal {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352 
353         _balances[sender] = _balances[sender].sub(amount);
354         _balances[recipient] = _balances[recipient].add(amount);
355         emit Transfer(sender, recipient, amount);
356     }
357 
358     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
359      * the total supply.
360      *
361      * Emits a `Transfer` event with `from` set to the zero address.
362      *
363      * Requirements
364      *
365      * - `to` cannot be the zero address.
366      */
367     function _mint(address account, uint256 amount) internal {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370         _totalSupply = _totalSupply.add(amount);
371         _balances[account] = _balances[account].add(amount);
372         emit Transfer(address(0), account, amount);
373     }
374 
375      /**
376      * @dev Destroys `amount` tokens from `account`, reducing the
377      * total supply.
378      *
379      * Emits a `Transfer` event with `to` set to the zero address.
380      *
381      * Requirements
382      *
383      * - `account` cannot be the zero address.
384      * - `account` must have at least `amount` tokens.
385      */
386     function _burn(address account, uint256 value) internal {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _totalSupply = _totalSupply.sub(value);
390         _balances[account] = _balances[account].sub(value);
391         emit Transfer(account, address(0), value);
392     }
393 
394     /**
395      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
396      *
397      * This is internal function is equivalent to `approve`, and can be used to
398      * e.g. set automatic allowances for certain subsystems, etc.
399      *
400      * Emits an `Approval` event.
401      *
402      * Requirements:
403      *
404      * - `owner` cannot be the zero address.
405      * - `spender` cannot be the zero address.
406      */
407     function _approve(address owner, address spender, uint256 value) internal {
408         require(owner != address(0), "ERC20: approve from the zero address");
409         require(spender != address(0), "ERC20: approve to the zero address");
410 
411         _allowances[owner][spender] = value;
412         emit Approval(owner, spender, value);
413     }
414 
415     /**
416      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
417      * from the caller's allowance.
418      *
419      * See `_burn` and `_approve`.
420      */
421     function _burnFrom(address account, uint256 amount) internal {
422         _burn(account, amount);
423         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
424     }
425 }
426 
427 // File: contracts\ERC20\TokenMintERC20Token.sol
428 
429 pragma solidity ^0.5.0;
430 
431 
432 /**
433  * @title TokenMintERC20Token
434  * @author TokenMint (visit https://tokenmint.io)
435  *
436  * @dev Standard ERC20 token with burning and optional functions implemented.
437  * For full specification of ERC-20 standard see:
438  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
439  */
440 contract TokenMintERC20Token is ERC20 {
441 
442     string private _name;
443     string private _symbol;
444     uint8 private _decimals;
445 
446     /**
447      * @dev Constructor.
448      * @param name name of the token
449      * @param symbol symbol of the token, 3-4 chars is recommended
450      * @param decimals number of decimal places of one token unit, 18 is widely used
451      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
452      * @param tokenOwnerAddress address that gets 100% of token supply
453      */
454     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
455       _name = name;
456       _symbol = symbol;
457       _decimals = decimals;
458 
459       // set tokenOwnerAddress as owner of all tokens
460       _mint(tokenOwnerAddress, totalSupply);
461 
462       // pay the service fee for contract deployment
463       feeReceiver.transfer(msg.value);
464     }
465 
466     /**
467      * @dev Burns a specific amount of tokens.
468      * @param value The amount of lowest token units to be burned.
469      */
470     function burn(uint256 value) public {
471       _burn(msg.sender, value);
472     }
473 
474     // optional functions from ERC20 stardard
475 
476     /**
477      * @return the name of the token.
478      */
479     function name() public view returns (string memory) {
480       return _name;
481     }
482 
483     /**
484      * @return the symbol of the token.
485      */
486     function symbol() public view returns (string memory) {
487       return _symbol;
488     }
489 
490     /**
491      * @return the number of decimals of the token.
492      */
493     function decimals() public view returns (uint8) {
494       return _decimals;
495     }
496 }