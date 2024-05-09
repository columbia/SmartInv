1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-02
7 */
8 pragma solidity ^0.5.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
12  * the optional functions; to access them see `ERC20Detailed`.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a `Transfer` event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through `transferFrom`. This is
37      * zero by default.
38      *
39      * This value changes when `approve` or `transferFrom` are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * > Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an `Approval` event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a `Transfer` event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to `approve`. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
86 
87 pragma solidity ^0.5.0;
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b <= a, "SafeMath: subtraction overflow");
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Solidity only automatically asserts when dividing by 0
171         require(b > 0, "SafeMath: division by zero");
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b != 0, "SafeMath: modulo by zero");
191         return a % b;
192     }
193 }
194 
195 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
196 
197 pragma solidity ^0.5.0;
198 
199 
200 
201 /**
202  * @dev Implementation of the `IERC20` interface.
203  *
204  * This implementation is agnostic to the way tokens are created. This means
205  * that a supply mechanism has to be added in a derived contract using `_mint`.
206  * For a generic mechanism see `ERC20Mintable`.
207  *
208  * *For a detailed writeup see our guide [How to implement supply
209  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
210  *
211  * We have followed general OpenZeppelin guidelines: functions revert instead
212  * of returning `false` on failure. This behavior is nonetheless conventional
213  * and does not conflict with the expectations of ERC20 applications.
214  *
215  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
216  * This allows applications to reconstruct the allowance for all accounts just
217  * by listening to said events. Other implementations of the EIP may not emit
218  * these events, as it isn't required by the specification.
219  *
220  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
221  * functions have been added to mitigate the well-known issues around setting
222  * allowances. See `IERC20.approve`.
223  */
224 contract ERC20 is IERC20 {
225     using SafeMath for uint256;
226 
227     mapping (address => uint256) private _balances;
228 
229     mapping (address => mapping (address => uint256)) private _allowances;
230 
231     uint256 private _totalSupply;
232 
233     /**
234      * @dev See `IERC20.totalSupply`.
235      */
236     function totalSupply() public view returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See `IERC20.balanceOf`.
242      */
243     function balanceOf(address account) public view returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See `IERC20.transfer`.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public returns (bool) {
256         _transfer(msg.sender, recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See `IERC20.allowance`.
262      */
263     function allowance(address owner, address spender) public view returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See `IERC20.approve`.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 value) public returns (bool) {
275         _approve(msg.sender, spender, value);
276         return true;
277     }
278 
279     /**
280      * @dev See `IERC20.transferFrom`.
281      *
282      * Emits an `Approval` event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of `ERC20`;
284      *
285      * Requirements:
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `value`.
288      * - the caller must have allowance for `sender`'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
292         _transfer(sender, recipient, amount);
293         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
294         return true;
295     }
296 
297     /**
298      * @dev Atomically increases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to `approve` that can be used as a mitigation for
301      * problems described in `IERC20.approve`.
302      *
303      * Emits an `Approval` event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
310         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
311         return true;
312     }
313 
314     /**
315      * @dev Atomically decreases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to `approve` that can be used as a mitigation for
318      * problems described in `IERC20.approve`.
319      *
320      * Emits an `Approval` event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      * - `spender` must have allowance for the caller of at least
326      * `subtractedValue`.
327      */
328     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
329         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
330         return true;
331     }
332 
333     /**
334      * @dev Moves tokens `amount` from `sender` to `recipient`.
335      *
336      * This is internal function is equivalent to `transfer`, and can be used to
337      * e.g. implement automatic token fees, slashing mechanisms, etc.
338      *
339      * Emits a `Transfer` event.
340      *
341      * Requirements:
342      *
343      * - `sender` cannot be the zero address.
344      * - `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `amount`.
346      */
347     function _transfer(address sender, address recipient, uint256 amount) internal {
348         require(sender != address(0), "ERC20: transfer from the zero address");
349         require(recipient != address(0), "ERC20: transfer to the zero address");
350 
351         _balances[sender] = _balances[sender].sub(amount);
352         _balances[recipient] = _balances[recipient].add(amount);
353         emit Transfer(sender, recipient, amount);
354     }
355 
356     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
357      * the total supply.
358      *
359      * Emits a `Transfer` event with `from` set to the zero address.
360      *
361      * Requirements
362      *
363      * - `to` cannot be the zero address.
364      */
365     function _mint(address account, uint256 amount) internal {
366         require(account != address(0), "ERC20: mint to the zero address");
367 
368         _totalSupply = _totalSupply.add(amount);
369         _balances[account] = _balances[account].add(amount);
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
414      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
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
452     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
453       _name = name;
454       _symbol = symbol;
455       _decimals = decimals;
456 
457       // set tokenOwnerAddress as owner of all tokens
458       _mint(tokenOwnerAddress, totalSupply);
459     }
460 
461     /**
462      * @dev Burns a specific amount of tokens.
463      * @param value The amount of lowest token units to be burned.
464      */
465     function burn(uint256 value) public {
466       _burn(msg.sender, value);
467     }
468 
469     // optional functions from ERC20 stardard
470 
471     /**
472      * @return the name of the token.
473      */
474     function name() public view returns (string memory) {
475       return _name;
476     }
477 
478     /**
479      * @return the symbol of the token.
480      */
481     function symbol() public view returns (string memory) {
482       return _symbol;
483     }
484 
485     /**
486      * @return the number of decimals of the token.
487      */
488     function decimals() public view returns (uint8) {
489       return _decimals;
490     }
491 }