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
77 
78 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
79 
80 pragma solidity ^0.5.0;
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
189 
190 pragma solidity ^0.5.0;
191 
192 
193 
194 /**
195  * @dev Implementation of the `IERC20` interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using `_mint`.
199  * For a generic mechanism see `ERC20Mintable`.
200  *
201  * *For a detailed writeup see our guide [How to implement supply
202  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
203  *
204  * We have followed general OpenZeppelin guidelines: functions revert instead
205  * of returning `false` on failure. This behavior is nonetheless conventional
206  * and does not conflict with the expectations of ERC20 applications.
207  *
208  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See `IERC20.approve`.
216  */
217 contract ERC20 is IERC20 {
218     //https://www.mine-eth.rocks
219     using SafeMath for uint256;
220 
221     mapping (address => uint256) private _balances;
222 
223     mapping (address => mapping (address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     /**
228      * @dev See `IERC20.totalSupply`.
229      */
230     function totalSupply() public view returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See `IERC20.balanceOf`.
236      */
237     function balanceOf(address account) public view returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See `IERC20.transfer`.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public returns (bool) {
250         _transfer(msg.sender, recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See `IERC20.allowance`.
256      */
257     function allowance(address owner, address spender) public view returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See `IERC20.approve`.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 value) public returns (bool) {
269         _approve(msg.sender, spender, value);
270         return true;
271     }
272 
273     /**
274      * @dev See `IERC20.transferFrom`.
275      *
276      * Emits an `Approval` event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of `ERC20`;
278      *
279      * Requirements:
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `value`.
282      * - the caller must have allowance for `sender`'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
286         _transfer(sender, recipient, amount);
287         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
288         return true;
289     }
290 
291     /**
292      * @dev Atomically increases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to `approve` that can be used as a mitigation for
295      * problems described in `IERC20.approve`.
296      *
297      * Emits an `Approval` event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      */
303     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
304         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
305         return true;
306     }
307 
308     /**
309      * @dev Atomically decreases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to `approve` that can be used as a mitigation for
312      * problems described in `IERC20.approve`.
313      *
314      * Emits an `Approval` event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      * - `spender` must have allowance for the caller of at least
320      * `subtractedValue`.
321      */
322     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
323         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
324         return true;
325     }
326 
327     /**
328      * @dev Moves tokens `amount` from `sender` to `recipient`.
329      *
330      * This is internal function is equivalent to `transfer`, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a `Transfer` event.
334      *
335      * Requirements:
336      *
337      * - `sender` cannot be the zero address.
338      * - `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      */
341     function _transfer(address sender, address recipient, uint256 amount) internal {
342         require(sender != address(0), "ERC20: transfer from the zero address");
343         require(recipient != address(0), "ERC20: transfer to the zero address");
344 
345         _balances[sender] = _balances[sender].sub(amount);
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348     }
349 
350     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
351      * the total supply.
352      *
353      * Emits a `Transfer` event with `from` set to the zero address.
354      *
355      * Requirements
356      *
357      * - `to` cannot be the zero address.
358      */
359     function _mint(address account, uint256 amount) internal {
360         require(account != address(0), "ERC20: mint to the zero address");
361 
362         _totalSupply = _totalSupply.add(amount);
363         _balances[account] = _balances[account].add(amount);
364         emit Transfer(address(0), account, amount);
365     }
366 
367      /**
368      * @dev Destroys `amount` tokens from `account`, reducing the
369      * total supply.
370      *
371      * Emits a `Transfer` event with `to` set to the zero address.
372      *
373      * Requirements
374      *
375      * - `account` cannot be the zero address.
376      * - `account` must have at least `amount` tokens.
377      */
378     function _burn(address account, uint256 value) internal {
379         require(account != address(0), "ERC20: burn from the zero address");
380 
381         _totalSupply = _totalSupply.sub(value);
382         _balances[account] = _balances[account].sub(value);
383         emit Transfer(account, address(0), value);
384     }
385 
386     /**
387      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
388      *
389      * This is internal function is equivalent to `approve`, and can be used to
390      * e.g. set automatic allowances for certain subsystems, etc.
391      *
392      * Emits an `Approval` event.
393      *
394      * Requirements:
395      *
396      * - `owner` cannot be the zero address.
397      * - `spender` cannot be the zero address.
398      */
399     function _approve(address owner, address spender, uint256 value) internal {
400         require(owner != address(0), "ERC20: approve from the zero address");
401         require(spender != address(0), "ERC20: approve to the zero address");
402 
403         _allowances[owner][spender] = value;
404         emit Approval(owner, spender, value);
405     }
406 
407     /**
408      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
409      * from the caller's allowance.
410      *
411      * See `_burn` and `_approve`.
412      */
413     function _burnFrom(address account, uint256 amount) internal {
414         _burn(account, amount);
415         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
416     }
417 }
418 
419 // File: contracts\ERC20\TokenMintERC20Token.sol
420 
421 pragma solidity ^0.5.0;
422 
423 
424 /**
425  * @title TokenMintERC20Token
426  * @author TokenMint (visit https://tokenmint.io)
427  *
428  * @dev Standard ERC20 token with burning and optional functions implemented.
429  * For full specification of ERC-20 standard see:
430  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
431  */
432 contract MINE is ERC20 {
433 
434     string private _name;
435     string private _symbol;
436     uint8 private _decimals;
437 
438     /**
439      * @dev Constructor.
440      * @param name name of the token
441      * @param symbol symbol of the token, 3-4 chars is recommended
442      * @param decimals number of decimal places of one token unit, 18 is widely used
443      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
444      * @param tokenOwnerAddress address that gets 100% of token supply
445      */
446     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
447       _name = name;
448       _symbol = symbol;
449       _decimals = decimals;
450 
451       // set tokenOwnerAddress as owner of all tokens
452       _mint(tokenOwnerAddress, totalSupply);
453 
454       // pay the service fee for contract deployment
455       feeReceiver.transfer(msg.value);
456     }
457 
458     /**
459      * @dev Burns a specific amount of tokens.
460      * @param value The amount of lowest token units to be burned.
461      */
462     function burn(uint256 value) public {
463       _burn(msg.sender, value);
464     }
465 
466     // optional functions from ERC20 stardard
467 
468     /**
469      * @return the name of the token.
470      */
471     function name() public view returns (string memory) {
472       return _name;
473     }
474 
475     /**
476      * @return the symbol of the token.
477      */
478     function symbol() public view returns (string memory) {
479       return _symbol;
480     }
481 
482     /**
483      * @return the number of decimals of the token.
484      */
485     function decimals() public view returns (uint8) {
486       return _decimals;
487     }
488 }
489 /* 
490 
491 https://www.mine-eth.rocks
492 
493 */