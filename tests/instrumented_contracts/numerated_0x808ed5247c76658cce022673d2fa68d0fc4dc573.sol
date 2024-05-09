1 /*
2 
3 Time is truly a flat circle. 
4 
5 Time and time again we return to OG memecoin derivatives and feed tax hungry devs... will we ever learn?
6 
7 I like to think yes, that teh people just need a reminder of what a true community looks like.
8 
9 Shiba Inu 2.0 is for teh people. We utilize the original $SHIB contract to bring peace, harmony, and a truly fair launch back to the space.
10 
11 No official website, no official TG. Yet we are here still...
12 
13 The "official" Twitter account is as such: https://twitter.com/ShibtokenTwo
14 
15 Forever Shiba, forever $SHIB2.0
16 
17 */
18 
19 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
20 
21 pragma solidity ^0.5.0;
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
25  * the optional functions; to access them see `ERC20Detailed`.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a `Transfer` event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through `transferFrom`. This is
50      * zero by default.
51      *
52      * This value changes when `approve` or `transferFrom` are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * > Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an `Approval` event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a `Transfer` event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to `approve`. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
99 
100 pragma solidity ^0.5.0;
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a, "SafeMath: subtraction overflow");
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Solidity only automatically asserts when dividing by 0
184         require(b > 0, "SafeMath: division by zero");
185         uint256 c = a / b;
186         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * Reverts when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b != 0, "SafeMath: modulo by zero");
204         return a % b;
205     }
206 }
207 
208 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
209 
210 pragma solidity ^0.5.0;
211 
212 
213 
214 /**
215  * @dev Implementation of the `IERC20` interface.
216  *
217  * This implementation is agnostic to the way tokens are created. This means
218  * that a supply mechanism has to be added in a derived contract using `_mint`.
219  * For a generic mechanism see `ERC20Mintable`.
220  *
221  * *For a detailed writeup see our guide [How to implement supply
222  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
223  *
224  * We have followed general OpenZeppelin guidelines: functions revert instead
225  * of returning `false` on failure. This behavior is nonetheless conventional
226  * and does not conflict with the expectations of ERC20 applications.
227  *
228  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See `IERC20.approve`.
236  */
237 contract ERC20 is IERC20 {
238     using SafeMath for uint256;
239 
240     mapping (address => uint256) private _balances;
241 
242     mapping (address => mapping (address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     /**
247      * @dev See `IERC20.totalSupply`.
248      */
249     function totalSupply() public view returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See `IERC20.balanceOf`.
255      */
256     function balanceOf(address account) public view returns (uint256) {
257         return _balances[account];
258     }
259 
260     /**
261      * @dev See `IERC20.transfer`.
262      *
263      * Requirements:
264      *
265      * - `recipient` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address recipient, uint256 amount) public returns (bool) {
269         _transfer(msg.sender, recipient, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See `IERC20.allowance`.
275      */
276     function allowance(address owner, address spender) public view returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See `IERC20.approve`.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 value) public returns (bool) {
288         _approve(msg.sender, spender, value);
289         return true;
290     }
291 
292     /**
293      * @dev See `IERC20.transferFrom`.
294      *
295      * Emits an `Approval` event indicating the updated allowance. This is not
296      * required by the EIP. See the note at the beginning of `ERC20`;
297      *
298      * Requirements:
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `value`.
301      * - the caller must have allowance for `sender`'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to `approve` that can be used as a mitigation for
314      * problems described in `IERC20.approve`.
315      *
316      * Emits an `Approval` event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
323         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to `approve` that can be used as a mitigation for
331      * problems described in `IERC20.approve`.
332      *
333      * Emits an `Approval` event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
342         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
343         return true;
344     }
345 
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to `transfer`, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a `Transfer` event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(address sender, address recipient, uint256 amount) internal {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _balances[sender] = _balances[sender].sub(amount);
365         _balances[recipient] = _balances[recipient].add(amount);
366         emit Transfer(sender, recipient, amount);
367     }
368 
369     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
370      * the total supply.
371      *
372      * Emits a `Transfer` event with `from` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `to` cannot be the zero address.
377      */
378     function _mint(address account, uint256 amount) internal {
379         require(account != address(0), "ERC20: mint to the zero address");
380 
381         _totalSupply = _totalSupply.add(amount);
382         _balances[account] = _balances[account].add(amount);
383         emit Transfer(address(0), account, amount);
384     }
385 
386      /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a `Transfer` event with `to` set to the zero address.
391      *
392      * Requirements
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 value) internal {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _totalSupply = _totalSupply.sub(value);
401         _balances[account] = _balances[account].sub(value);
402         emit Transfer(account, address(0), value);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
407      *
408      * This is internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an `Approval` event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 value) internal {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = value;
423         emit Approval(owner, spender, value);
424     }
425 
426     /**
427      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
428      * from the caller's allowance.
429      *
430      * See `_burn` and `_approve`.
431      */
432     function _burnFrom(address account, uint256 amount) internal {
433         _burn(account, amount);
434         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
435     }
436 }
437 
438 // File: contracts\ERC20\TokenMintERC20Token.sol
439 
440 pragma solidity ^0.5.0;
441 
442 
443 /**
444  * @title TokenMintERC20Token
445  * @author TokenMint (visit https://tokenmint.io)
446  *
447  * @dev Standard ERC20 token with burning and optional functions implemented.
448  * For full specification of ERC-20 standard see:
449  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
450  */
451 contract TokenMintERC20Token is ERC20 {
452 
453     string private _name;
454     string private _symbol;
455     uint8 private _decimals;
456 
457     /**
458      * @dev Constructor.
459      * @param name name of the token
460      * @param symbol symbol of the token, 3-4 chars is recommended
461      * @param decimals number of decimal places of one token unit, 18 is widely used
462      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
463      * @param tokenOwnerAddress address that gets 100% of token supply
464      */
465     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
466       _name = name;
467       _symbol = symbol;
468       _decimals = decimals;
469 
470       // set tokenOwnerAddress as owner of all tokens
471       _mint(tokenOwnerAddress, totalSupply);
472 
473       // pay the service fee for contract deployment
474       feeReceiver.transfer(msg.value);
475     }
476 
477     /**
478      * @dev Burns a specific amount of tokens.
479      * @param value The amount of lowest token units to be burned.
480      */
481     function burn(uint256 value) public {
482       _burn(msg.sender, value);
483     }
484 
485     // optional functions from ERC20 stardard
486 
487     /**
488      * @return the name of the token.
489      */
490     function name() public view returns (string memory) {
491       return _name;
492     }
493 
494     /**
495      * @return the symbol of the token.
496      */
497     function symbol() public view returns (string memory) {
498       return _symbol;
499     }
500 
501     /**
502      * @return the number of decimals of the token.
503      */
504     function decimals() public view returns (uint8) {
505       return _decimals;
506     }
507 }