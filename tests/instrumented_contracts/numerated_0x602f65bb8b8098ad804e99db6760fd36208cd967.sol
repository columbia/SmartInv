1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-02
7 */
8 
9 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
15  * the optional functions; to access them see `ERC20Detailed`.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a `Transfer` event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through `transferFrom`. This is
40      * zero by default.
41      *
42      * This value changes when `approve` or `transferFrom` are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * > Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an `Approval` event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a `Transfer` event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to `approve`. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
89 
90 pragma solidity ^0.5.0;
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b <= a, "SafeMath: subtraction overflow");
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Solidity only automatically asserts when dividing by 0
174         require(b > 0, "SafeMath: division by zero");
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b != 0, "SafeMath: modulo by zero");
194         return a % b;
195     }
196 }
197 
198 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
199 
200 pragma solidity ^0.5.0;
201 
202 
203 
204 /**
205  * @dev Implementation of the `IERC20` interface.
206  *
207  * This implementation is agnostic to the way tokens are created. This means
208  * that a supply mechanism has to be added in a derived contract using `_mint`.
209  * For a generic mechanism see `ERC20Mintable`.
210  *
211  * *For a detailed writeup see our guide [How to implement supply
212  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
213  *
214  * We have followed general OpenZeppelin guidelines: functions revert instead
215  * of returning `false` on failure. This behavior is nonetheless conventional
216  * and does not conflict with the expectations of ERC20 applications.
217  *
218  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
219  * This allows applications to reconstruct the allowance for all accounts just
220  * by listening to said events. Other implementations of the EIP may not emit
221  * these events, as it isn't required by the specification.
222  *
223  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
224  * functions have been added to mitigate the well-known issues around setting
225  * allowances. See `IERC20.approve`.
226  */
227 contract ERC20 is IERC20 {
228     using SafeMath for uint256;
229 
230     mapping (address => uint256) private _balances;
231 
232     mapping (address => mapping (address => uint256)) private _allowances;
233 
234     uint256 private _totalSupply;
235 
236     /**
237      * @dev See `IERC20.totalSupply`.
238      */
239     function totalSupply() public view returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See `IERC20.balanceOf`.
245      */
246     function balanceOf(address account) public view returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See `IERC20.transfer`.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public returns (bool) {
259         _transfer(msg.sender, recipient, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See `IERC20.allowance`.
265      */
266     function allowance(address owner, address spender) public view returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See `IERC20.approve`.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 value) public returns (bool) {
278         _approve(msg.sender, spender, value);
279         return true;
280     }
281 
282     /**
283      * @dev See `IERC20.transferFrom`.
284      *
285      * Emits an `Approval` event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of `ERC20`;
287      *
288      * Requirements:
289      * - `sender` and `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `value`.
291      * - the caller must have allowance for `sender`'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
295         _transfer(sender, recipient, amount);
296         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to `approve` that can be used as a mitigation for
304      * problems described in `IERC20.approve`.
305      *
306      * Emits an `Approval` event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
313         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to `approve` that can be used as a mitigation for
321      * problems described in `IERC20.approve`.
322      *
323      * Emits an `Approval` event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
332         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
333         return true;
334     }
335 
336     /**
337      * @dev Moves tokens `amount` from `sender` to `recipient`.
338      *
339      * This is internal function is equivalent to `transfer`, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a `Transfer` event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(address sender, address recipient, uint256 amount) internal {
351         require(sender != address(0), "ERC20: transfer from the zero address");
352         require(recipient != address(0), "ERC20: transfer to the zero address");
353 
354         _balances[sender] = _balances[sender].sub(amount);
355         _balances[recipient] = _balances[recipient].add(amount);
356         emit Transfer(sender, recipient, amount);
357     }
358 
359     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
360      * the total supply.
361      *
362      * Emits a `Transfer` event with `from` set to the zero address.
363      *
364      * Requirements
365      *
366      * - `to` cannot be the zero address.
367      */
368     function _mint(address account, uint256 amount) internal {
369         require(account != address(0), "ERC20: mint to the zero address");
370 
371         _totalSupply = _totalSupply.add(amount);
372         _balances[account] = _balances[account].add(amount);
373         emit Transfer(address(0), account, amount);
374     }
375 
376      /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a `Transfer` event with `to` set to the zero address.
381      *
382      * Requirements
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 value) internal {
388         require(account != address(0), "ERC20: burn from the zero address");
389 
390         _totalSupply = _totalSupply.sub(value);
391         _balances[account] = _balances[account].sub(value);
392         emit Transfer(account, address(0), value);
393     }
394 
395     /**
396      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
397      *
398      * This is internal function is equivalent to `approve`, and can be used to
399      * e.g. set automatic allowances for certain subsystems, etc.
400      *
401      * Emits an `Approval` event.
402      *
403      * Requirements:
404      *
405      * - `owner` cannot be the zero address.
406      * - `spender` cannot be the zero address.
407      */
408     function _approve(address owner, address spender, uint256 value) internal {
409         require(owner != address(0), "ERC20: approve from the zero address");
410         require(spender != address(0), "ERC20: approve to the zero address");
411 
412         _allowances[owner][spender] = value;
413         emit Approval(owner, spender, value);
414     }
415 
416     /**
417      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
418      * from the caller's allowance.
419      *
420      * See `_burn` and `_approve`.
421      */
422     function _burnFrom(address account, uint256 amount) internal {
423         _burn(account, amount);
424         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
425     }
426 }
427 
428 // File: contracts\ERC20\TokenMintERC20Token.sol
429 
430 pragma solidity ^0.5.0;
431 
432 
433 /**
434  * @title TokenMintERC20Token
435  * @author TokenMint (visit https://tokenmint.io)
436  *
437  * @dev Standard ERC20 token with burning and optional functions implemented.
438  * For full specification of ERC-20 standard see:
439  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
440  */
441 contract TokenMintERC20Token is ERC20 {
442 
443     string private _name;
444     string private _symbol;
445     uint8 private _decimals;
446 
447     /**
448      * @dev Constructor.
449      * @param name name of the token
450      * @param symbol symbol of the token, 3-4 chars is recommended
451      * @param decimals number of decimal places of one token unit, 18 is widely used
452      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
453      * @param tokenOwnerAddress address that gets 100% of token supply
454      */
455     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
456       _name = name;
457       _symbol = symbol;
458       _decimals = decimals;
459 
460       // set tokenOwnerAddress as owner of all tokens
461       _mint(tokenOwnerAddress, totalSupply);
462 
463       // pay the service fee for contract deployment
464       feeReceiver.transfer(msg.value);
465     }
466 
467     /**
468      * @dev Burns a specific amount of tokens.
469      * @param value The amount of lowest token units to be burned.
470      */
471     function burn(uint256 value) public {
472       _burn(msg.sender, value);
473     }
474 
475     // optional functions from ERC20 stardard
476 
477     /**
478      * @return the name of the token.
479      */
480     function name() public view returns (string memory) {
481       return _name;
482     }
483 
484     /**
485      * @return the symbol of the token.
486      */
487     function symbol() public view returns (string memory) {
488       return _symbol;
489     }
490 
491     /**
492      * @return the number of decimals of the token.
493      */
494     function decimals() public view returns (uint8) {
495       return _decimals;
496     }
497 }