1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-14
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-26
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2019-08-02
11 */
12 pragma solidity ^0.5.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
16  * the optional functions; to access them see `ERC20Detailed`.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a `Transfer` event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through `transferFrom`. This is
41      * zero by default.
42      *
43      * This value changes when `approve` or `transferFrom` are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * > Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an `Approval` event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a `Transfer` event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to `approve`. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b <= a, "SafeMath: subtraction overflow");
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0, "SafeMath: division by zero");
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b != 0, "SafeMath: modulo by zero");
195         return a % b;
196     }
197 }
198 
199 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
200 
201 pragma solidity ^0.5.0;
202 
203 
204 
205 /**
206  * @dev Implementation of the `IERC20` interface.
207  *
208  * This implementation is agnostic to the way tokens are created. This means
209  * that a supply mechanism has to be added in a derived contract using `_mint`.
210  * For a generic mechanism see `ERC20Mintable`.
211  *
212  * *For a detailed writeup see our guide [How to implement supply
213  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
214  *
215  * We have followed general OpenZeppelin guidelines: functions revert instead
216  * of returning `false` on failure. This behavior is nonetheless conventional
217  * and does not conflict with the expectations of ERC20 applications.
218  *
219  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
220  * This allows applications to reconstruct the allowance for all accounts just
221  * by listening to said events. Other implementations of the EIP may not emit
222  * these events, as it isn't required by the specification.
223  *
224  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
225  * functions have been added to mitigate the well-known issues around setting
226  * allowances. See `IERC20.approve`.
227  */
228 contract ERC20 is IERC20 {
229     using SafeMath for uint256;
230 
231     mapping (address => uint256) private _balances;
232 
233     mapping (address => mapping (address => uint256)) private _allowances;
234 
235     uint256 private _totalSupply;
236 
237     /**
238      * @dev See `IERC20.totalSupply`.
239      */
240     function totalSupply() public view returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See `IERC20.balanceOf`.
246      */
247     function balanceOf(address account) public view returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See `IERC20.transfer`.
253      *
254      * Requirements:
255      *
256      * - `recipient` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address recipient, uint256 amount) public returns (bool) {
260         _transfer(msg.sender, recipient, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See `IERC20.allowance`.
266      */
267     function allowance(address owner, address spender) public view returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See `IERC20.approve`.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 value) public returns (bool) {
279         _approve(msg.sender, spender, value);
280         return true;
281     }
282 
283     /**
284      * @dev See `IERC20.transferFrom`.
285      *
286      * Emits an `Approval` event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of `ERC20`;
288      *
289      * Requirements:
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `value`.
292      * - the caller must have allowance for `sender`'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to `approve` that can be used as a mitigation for
305      * problems described in `IERC20.approve`.
306      *
307      * Emits an `Approval` event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
314         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to `approve` that can be used as a mitigation for
322      * problems described in `IERC20.approve`.
323      *
324      * Emits an `Approval` event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
333         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
334         return true;
335     }
336 
337     /**
338      * @dev Moves tokens `amount` from `sender` to `recipient`.
339      *
340      * This is internal function is equivalent to `transfer`, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a `Transfer` event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(address sender, address recipient, uint256 amount) internal {
352         require(sender != address(0), "ERC20: transfer from the zero address");
353         require(recipient != address(0), "ERC20: transfer to the zero address");
354 
355         _balances[sender] = _balances[sender].sub(amount);
356         _balances[recipient] = _balances[recipient].add(amount);
357         emit Transfer(sender, recipient, amount);
358     }
359 
360     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
361      * the total supply.
362      *
363      * Emits a `Transfer` event with `from` set to the zero address.
364      *
365      * Requirements
366      *
367      * - `to` cannot be the zero address.
368      */
369     function _mint(address account, uint256 amount) internal {
370         require(account != address(0), "ERC20: mint to the zero address");
371 
372         _totalSupply = _totalSupply.add(amount);
373         _balances[account] = _balances[account].add(amount);
374         emit Transfer(address(0), account, amount);
375     }
376 
377      /**
378      * @dev Destroys `amount` tokens from `account`, reducing the
379      * total supply.
380      *
381      * Emits a `Transfer` event with `to` set to the zero address.
382      *
383      * Requirements
384      *
385      * - `account` cannot be the zero address.
386      * - `account` must have at least `amount` tokens.
387      */
388     function _burn(address account, uint256 value) internal {
389         require(account != address(0), "ERC20: burn from the zero address");
390 
391         _totalSupply = _totalSupply.sub(value);
392         _balances[account] = _balances[account].sub(value);
393         emit Transfer(account, address(0), value);
394     }
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
398      *
399      * This is internal function is equivalent to `approve`, and can be used to
400      * e.g. set automatic allowances for certain subsystems, etc.
401      *
402      * Emits an `Approval` event.
403      *
404      * Requirements:
405      *
406      * - `owner` cannot be the zero address.
407      * - `spender` cannot be the zero address.
408      */
409     function _approve(address owner, address spender, uint256 value) internal {
410         require(owner != address(0), "ERC20: approve from the zero address");
411         require(spender != address(0), "ERC20: approve to the zero address");
412 
413         _allowances[owner][spender] = value;
414         emit Approval(owner, spender, value);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
419      * from the caller's allowance.
420      *
421      * See `_burn` and `_approve`.
422      */
423     function _burnFrom(address account, uint256 amount) internal {
424         _burn(account, amount);
425         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
426     }
427 }
428 
429 // File: contracts\ERC20\TokenMintERC20Token.sol
430 
431 pragma solidity ^0.5.0;
432 
433 
434 /**
435  * @title TokenMintERC20Token
436  * @author TokenMint (visit https://tokenmint.io)
437  *
438  * @dev Standard ERC20 token with burning and optional functions implemented.
439  * For full specification of ERC-20 standard see:
440  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
441  */
442 contract TokenMintERC20Token is ERC20 {
443 
444     string private _name;
445     string private _symbol;
446     uint8 private _decimals;
447 
448     /**
449      * @dev Constructor.
450      * @param name name of the token
451      * @param symbol symbol of the token, 3-4 chars is recommended
452      * @param decimals number of decimal places of one token unit, 18 is widely used
453      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
454      * @param tokenOwnerAddress address that gets 100% of token supply
455      */
456     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
457       _name = name;
458       _symbol = symbol;
459       _decimals = decimals;
460 
461       // set tokenOwnerAddress as owner of all tokens
462       _mint(tokenOwnerAddress, totalSupply);
463     }
464 
465     /**
466      * @dev Burns a specific amount of tokens.
467      * @param value The amount of lowest token units to be burned.
468      */
469     function burn(uint256 value) public {
470       _burn(msg.sender, value);
471     }
472 
473     // optional functions from ERC20 stardard
474 
475     /**
476      * @return the name of the token.
477      */
478     function name() public view returns (string memory) {
479       return _name;
480     }
481 
482     /**
483      * @return the symbol of the token.
484      */
485     function symbol() public view returns (string memory) {
486       return _symbol;
487     }
488 
489     /**
490      * @return the number of decimals of the token.
491      */
492     function decimals() public view returns (uint8) {
493       return _decimals;
494     }
495 }