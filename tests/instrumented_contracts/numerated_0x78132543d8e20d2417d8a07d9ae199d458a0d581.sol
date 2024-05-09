1 /**
2 LunaInu $LINU
3 https://t.me/LunaInuERC20
4 */
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
9  * the optional functions; to access them see `ERC20Detailed`.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a `Transfer` event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through `transferFrom`. This is
34      * zero by default.
35      *
36      * This value changes when `approve` or `transferFrom` are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * > Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an `Approval` event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a `Transfer` event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to `approve`. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
83 
84 pragma solidity ^0.5.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a, "SafeMath: subtraction overflow");
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      * - Multiplication cannot overflow.
140      */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143         // benefit is lost if 'b' is also tested.
144         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, "SafeMath: division by zero");
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * Reverts when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b != 0, "SafeMath: modulo by zero");
188         return a % b;
189     }
190 }
191 
192 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
193 
194 pragma solidity ^0.5.0;
195 
196 
197 
198 /**
199  * @dev Implementation of the `IERC20` interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using `_mint`.
203  * For a generic mechanism see `ERC20Mintable`.
204  *
205  * *For a detailed writeup see our guide [How to implement supply
206  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
207  *
208  * We have followed general OpenZeppelin guidelines: functions revert instead
209  * of returning `false` on failure. This behavior is nonetheless conventional
210  * and does not conflict with the expectations of ERC20 applications.
211  *
212  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
213  * This allows applications to reconstruct the allowance for all accounts just
214  * by listening to said events. Other implementations of the EIP may not emit
215  * these events, as it isn't required by the specification.
216  *
217  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
218  * functions have been added to mitigate the well-known issues around setting
219  * allowances. See `IERC20.approve`.
220  */
221 contract ERC20 is IERC20 {
222     using SafeMath for uint256;
223 
224     mapping (address => uint256) private _balances;
225 
226     mapping (address => mapping (address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     /**
231      * @dev See `IERC20.totalSupply`.
232      */
233     function totalSupply() public view returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See `IERC20.balanceOf`.
239      */
240     function balanceOf(address account) public view returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See `IERC20.transfer`.
246      *
247      * Requirements:
248      *
249      * - `recipient` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address recipient, uint256 amount) public returns (bool) {
253         _transfer(msg.sender, recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See `IERC20.allowance`.
259      */
260     function allowance(address owner, address spender) public view returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See `IERC20.approve`.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 value) public returns (bool) {
272         _approve(msg.sender, spender, value);
273         return true;
274     }
275 
276     /**
277      * @dev See `IERC20.transferFrom`.
278      *
279      * Emits an `Approval` event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of `ERC20`;
281      *
282      * Requirements:
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `value`.
285      * - the caller must have allowance for `sender`'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
291         return true;
292     }
293 
294     /**
295      * @dev Atomically increases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to `approve` that can be used as a mitigation for
298      * problems described in `IERC20.approve`.
299      *
300      * Emits an `Approval` event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically decreases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to `approve` that can be used as a mitigation for
315      * problems described in `IERC20.approve`.
316      *
317      * Emits an `Approval` event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      * - `spender` must have allowance for the caller of at least
323      * `subtractedValue`.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Moves tokens `amount` from `sender` to `recipient`.
332      *
333      * This is internal function is equivalent to `transfer`, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a `Transfer` event.
337      *
338      * Requirements:
339      *
340      * - `sender` cannot be the zero address.
341      * - `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      */
344     function _transfer(address sender, address recipient, uint256 amount) internal {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _balances[sender] = _balances[sender].sub(amount);
349         _balances[recipient] = _balances[recipient].add(amount);
350         emit Transfer(sender, recipient, amount);
351     }
352 
353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
354      * the total supply.
355      *
356      * Emits a `Transfer` event with `from` set to the zero address.
357      *
358      * Requirements
359      *
360      * - `to` cannot be the zero address.
361      */
362     function _mint(address account, uint256 amount) internal {
363         require(account != address(0), "ERC20: mint to the zero address");
364 
365         _totalSupply = _totalSupply.add(amount);
366         _balances[account] = _balances[account].add(amount);
367         emit Transfer(address(0), account, amount);
368     }
369 
370      /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a `Transfer` event with `to` set to the zero address.
375      *
376      * Requirements
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 value) internal {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _totalSupply = _totalSupply.sub(value);
385         _balances[account] = _balances[account].sub(value);
386         emit Transfer(account, address(0), value);
387     }
388 
389     /**
390      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
391      *
392      * This is internal function is equivalent to `approve`, and can be used to
393      * e.g. set automatic allowances for certain subsystems, etc.
394      *
395      * Emits an `Approval` event.
396      *
397      * Requirements:
398      *
399      * - `owner` cannot be the zero address.
400      * - `spender` cannot be the zero address.
401      */
402     function _approve(address owner, address spender, uint256 value) internal {
403         require(owner != address(0), "ERC20: approve from the zero address");
404         require(spender != address(0), "ERC20: approve to the zero address");
405 
406         _allowances[owner][spender] = value;
407         emit Approval(owner, spender, value);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
412      * from the caller's allowance.
413      *
414      * See `_burn` and `_approve`.
415      */
416     function _burnFrom(address account, uint256 amount) internal {
417         _burn(account, amount);
418         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
419     }
420 }
421 
422 // File: contracts\ERC20\TokenMintERC20Token.sol
423 
424 pragma solidity ^0.5.0;
425 
426 
427 /**
428  * @title TokenMintERC20Token
429  * @author TokenMint (visit https://tokenmint.io)
430  *
431  * @dev Standard ERC20 token with burning and optional functions implemented.
432  * For full specification of ERC-20 standard see:
433  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
434  */
435 contract TokenMintERC20Token is ERC20 {
436 
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     /**
442      * @dev Constructor.
443      * @param name name of the token
444      * @param symbol symbol of the token, 3-4 chars is recommended
445      * @param decimals number of decimal places of one token unit, 18 is widely used
446      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
447      * @param tokenOwnerAddress address that gets 100% of token supply
448      */
449     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
450       _name = name;
451       _symbol = symbol;
452       _decimals = decimals;
453 
454       // set tokenOwnerAddress as owner of all tokens
455       _mint(tokenOwnerAddress, totalSupply);
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