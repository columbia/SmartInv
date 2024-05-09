1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-02
3 */
4 
5 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
11  * the optional functions; to access them see `ERC20Detailed`.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a `Transfer` event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through `transferFrom`. This is
36      * zero by default.
37      *
38      * This value changes when `approve` or `transferFrom` are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * > Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an `Approval` event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a `Transfer` event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to `approve`. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
85 
86 pragma solidity ^0.5.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Solidity only automatically asserts when dividing by 0
170         require(b > 0, "SafeMath: division by zero");
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0, "SafeMath: modulo by zero");
190         return a % b;
191     }
192 }
193 
194 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
195 
196 pragma solidity ^0.5.0;
197 
198 
199 
200 /**
201  * @dev Implementation of the `IERC20` interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using `_mint`.
205  * For a generic mechanism see `ERC20Mintable`.
206  *
207  * *For a detailed writeup see our guide [How to implement supply
208  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
209  *
210  * We have followed general OpenZeppelin guidelines: functions revert instead
211  * of returning `false` on failure. This behavior is nonetheless conventional
212  * and does not conflict with the expectations of ERC20 applications.
213  *
214  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See `IERC20.approve`.
222  */
223 contract ERC20 is IERC20 {
224     using SafeMath for uint256;
225 
226     mapping (address => uint256) private _balances;
227 
228     mapping (address => mapping (address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
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
369         emit Transfer(address(0), account, amount);
370     }
371 
372      /**
373      * @dev Destroys `amount` tokens from `account`, reducing the
374      * total supply.
375      *
376      * Emits a `Transfer` event with `to` set to the zero address.
377      *
378      * Requirements
379      *
380      * - `account` cannot be the zero address.
381      * - `account` must have at least `amount` tokens.
382      */
383     function _burn(address account, uint256 value) internal {
384         require(account != address(0), "ERC20: burn from the zero address");
385 
386         _totalSupply = _totalSupply.sub(value);
387         _balances[account] = _balances[account].sub(value);
388         emit Transfer(account, address(0), value);
389     }
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
393      *
394      * This is internal function is equivalent to `approve`, and can be used to
395      * e.g. set automatic allowances for certain subsystems, etc.
396      *
397      * Emits an `Approval` event.
398      *
399      * Requirements:
400      *
401      * - `owner` cannot be the zero address.
402      * - `spender` cannot be the zero address.
403      */
404     function _approve(address owner, address spender, uint256 value) internal {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = value;
409         emit Approval(owner, spender, value);
410     }
411 
412     /**
413      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
414      * from the caller's allowance.
415      *
416      * See `_burn` and `_approve`.
417      */
418     function _burnFrom(address account, uint256 amount) internal {
419         _burn(account, amount);
420         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
421     }
422 }
423 
424 // File: contracts\ERC20\TokenMintERC20Token.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 /**
430  * @title TokenMintERC20Token
431  * @author TokenMint (visit https://tokenmint.io)
432  *
433  * @dev Standard ERC20 token with burning and optional functions implemented.
434  * For full specification of ERC-20 standard see:
435  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
436  */
437 contract TokenMintERC20Token is ERC20 {
438 
439     string private _name;
440     string private _symbol;
441     uint8 private _decimals;
442 
443     /**
444      * @dev Constructor.
445      * @param name name of the token
446      * @param symbol symbol of the token, 3-4 chars is recommended
447      * @param decimals number of decimal places of one token unit, 18 is widely used
448      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
449      * @param tokenOwnerAddress address that gets 100% of token supply
450      */
451     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
452       _name = name;
453       _symbol = symbol;
454       _decimals = decimals;
455 
456       // set tokenOwnerAddress as owner of all tokens
457       _mint(tokenOwnerAddress, totalSupply);
458 
459       // pay the service fee for contract deployment
460       feeReceiver.transfer(msg.value);
461     }
462 
463     /**
464      * @dev Burns a specific amount of tokens.
465      * @param value The amount of lowest token units to be burned.
466      */
467     function burn(uint256 value) public {
468       _burn(msg.sender, value);
469     }
470 
471     // optional functions from ERC20 stardard
472 
473     /**
474      * @return the name of the token.
475      */
476     function name() public view returns (string memory) {
477       return _name;
478     }
479 
480     /**
481      * @return the symbol of the token.
482      */
483     function symbol() public view returns (string memory) {
484       return _symbol;
485     }
486 
487     /**
488      * @return the number of decimals of the token.
489      */
490     function decimals() public view returns (uint8) {
491       return _decimals;
492     }
493 }