1 /*
2 $INU - Inu.
3 
4 In crypto, the success of a strong community has led countless individuals 
5 to a life of financial freedom; many of whom would have stayed poor forever,
6 even if they worked every day saving each penny until the day they died.
7 
8 The rise of Shiba Inu caused a cultural and monetary shift in the world on levels
9 never seen before. Thousands of "Something-Inu" tokens have launched since then 
10 attempting to capitalize on both whatever the current "trend" is as well as those 
11 hoping to buy in early on the "NEXT SHIBA INU", thus destroying trust in the INU name 
12 and the promises that came along with it.
13 
14 Today, even Shiba Inu itself has strayed far away from the original vision its creator 
15 intended.
16 
17 Filling up the market with these "Trend-Inu" tokens has left many hopeful investors burned
18 and rugged, and has fractured the Memecoin community as a whole. Nowadays, building the 
19 "Next Shiba Inu" feels like an impossible task, as there is seemingly no place for the 
20 laymen to come together and build outside of trend-chasing dog coins with dev teams who 
21 always let their communities down.
22 
23 Until now.
24 
25 INU is a safe haven for all.
26 
27 A token with no team, no dev, no tax, no temporary meme trend name, no expectations past what
28 YOU (the community) bring to the table.
29 
30 INU represents the lost memories of a time when community was truly all that was needed for
31 generations of riches to be created.
32 
33 Liquidity has been burned upon creation, 50% of supply has been burned, there is no official
34 site, telegram, twitter, logo, or anything past the INU contract itself.
35 
36 It is up to YOU, the individual, to bring glory and wealth back to the INU name.
37 
38 All hail the Inu.
39 
40 */
41 
42 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
43 
44 pragma solidity ^0.5.0;
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
48  * the optional functions; to access them see `ERC20Detailed`.
49  */
50 interface IERC20 {
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     /**
62      * @dev Moves `amount` tokens from the caller's account to `recipient`.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a `Transfer` event.
67      */
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Returns the remaining number of tokens that `spender` will be
72      * allowed to spend on behalf of `owner` through `transferFrom`. This is
73      * zero by default.
74      *
75      * This value changes when `approve` or `transferFrom` are called.
76      */
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * > Beware that changing an allowance with this method brings the risk
85      * that someone may use both the old and the new allowance by unfortunate
86      * transaction ordering. One possible solution to mitigate this race
87      * condition is to first reduce the spender's allowance to 0 and set the
88      * desired value afterwards:
89      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an `Approval` event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` tokens from `sender` to `recipient` using the
97      * allowance mechanism. `amount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a `Transfer` event.
103      */
104     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
108      * another (`to`).
109      *
110      * Note that `value` may be zero.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     /**
115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
116      * a call to `approve`. `value` is the new allowance.
117      */
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
122 
123 pragma solidity ^0.5.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b <= a, "SafeMath: subtraction overflow");
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         // Solidity only automatically asserts when dividing by 0
207         require(b > 0, "SafeMath: division by zero");
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         require(b != 0, "SafeMath: modulo by zero");
227         return a % b;
228     }
229 }
230 
231 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
232 
233 pragma solidity ^0.5.0;
234 
235 
236 
237 /**
238  * @dev Implementation of the `IERC20` interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using `_mint`.
242  * For a generic mechanism see `ERC20Mintable`.
243  *
244  * *For a detailed writeup see our guide [How to implement supply
245  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
246  *
247  * We have followed general OpenZeppelin guidelines: functions revert instead
248  * of returning `false` on failure. This behavior is nonetheless conventional
249  * and does not conflict with the expectations of ERC20 applications.
250  *
251  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See `IERC20.approve`.
259  */
260 contract ERC20 is IERC20 {
261     using SafeMath for uint256;
262 
263     mapping (address => uint256) private _balances;
264 
265     mapping (address => mapping (address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     /**
270      * @dev See `IERC20.totalSupply`.
271      */
272     function totalSupply() public view returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277      * @dev See `IERC20.balanceOf`.
278      */
279     function balanceOf(address account) public view returns (uint256) {
280         return _balances[account];
281     }
282 
283     /**
284      * @dev See `IERC20.transfer`.
285      *
286      * Requirements:
287      *
288      * - `recipient` cannot be the zero address.
289      * - the caller must have a balance of at least `amount`.
290      */
291     function transfer(address recipient, uint256 amount) public returns (bool) {
292         _transfer(msg.sender, recipient, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See `IERC20.allowance`.
298      */
299     function allowance(address owner, address spender) public view returns (uint256) {
300         return _allowances[owner][spender];
301     }
302 
303     /**
304      * @dev See `IERC20.approve`.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function approve(address spender, uint256 value) public returns (bool) {
311         _approve(msg.sender, spender, value);
312         return true;
313     }
314 
315     /**
316      * @dev See `IERC20.transferFrom`.
317      *
318      * Emits an `Approval` event indicating the updated allowance. This is not
319      * required by the EIP. See the note at the beginning of `ERC20`;
320      *
321      * Requirements:
322      * - `sender` and `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `value`.
324      * - the caller must have allowance for `sender`'s tokens of at least
325      * `amount`.
326      */
327     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to `approve` that can be used as a mitigation for
337      * problems described in `IERC20.approve`.
338      *
339      * Emits an `Approval` event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
346         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to `approve` that can be used as a mitigation for
354      * problems described in `IERC20.approve`.
355      *
356      * Emits an `Approval` event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
365         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
366         return true;
367     }
368 
369     /**
370      * @dev Moves tokens `amount` from `sender` to `recipient`.
371      *
372      * This is internal function is equivalent to `transfer`, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a `Transfer` event.
376      *
377      * Requirements:
378      *
379      * - `sender` cannot be the zero address.
380      * - `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      */
383     function _transfer(address sender, address recipient, uint256 amount) internal {
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386 
387         _balances[sender] = _balances[sender].sub(amount);
388         _balances[recipient] = _balances[recipient].add(amount);
389         emit Transfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a `Transfer` event with `from` set to the zero address.
396      *
397      * Requirements
398      *
399      * - `to` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _totalSupply = _totalSupply.add(amount);
405         _balances[account] = _balances[account].add(amount);
406         emit Transfer(address(0), account, amount);
407     }
408 
409      /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a `Transfer` event with `to` set to the zero address.
414      *
415      * Requirements
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 value) internal {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _totalSupply = _totalSupply.sub(value);
424         _balances[account] = _balances[account].sub(value);
425         emit Transfer(account, address(0), value);
426     }
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
430      *
431      * This is internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an `Approval` event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(address owner, address spender, uint256 value) internal {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = value;
446         emit Approval(owner, spender, value);
447     }
448 
449     /**
450      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
451      * from the caller's allowance.
452      *
453      * See `_burn` and `_approve`.
454      */
455     function _burnFrom(address account, uint256 amount) internal {
456         _burn(account, amount);
457         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
458     }
459 }
460 
461 // File: contracts\ERC20\TokenMintERC20Token.sol
462 
463 pragma solidity ^0.5.0;
464 
465 
466 /**
467  * @title TokenMintERC20Token
468  * @author TokenMint (visit https://tokenmint.io)
469  *
470  * @dev Standard ERC20 token with burning and optional functions implemented.
471  * For full specification of ERC-20 standard see:
472  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
473  */
474 contract TokenMintERC20Token is ERC20 {
475 
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     /**
481      * @dev Constructor.
482      * @param name name of the token
483      * @param symbol symbol of the token, 3-4 chars is recommended
484      * @param decimals number of decimal places of one token unit, 18 is widely used
485      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
486      * @param tokenOwnerAddress address that gets 100% of token supply
487      */
488     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
489       _name = name;
490       _symbol = symbol;
491       _decimals = decimals;
492 
493       // set tokenOwnerAddress as owner of all tokens
494       _mint(tokenOwnerAddress, totalSupply);
495 
496       // pay the service fee for contract deployment
497       feeReceiver.transfer(msg.value);
498     }
499 
500     /**
501      * @dev Burns a specific amount of tokens.
502      * @param value The amount of lowest token units to be burned.
503      */
504     function burn(uint256 value) public {
505       _burn(msg.sender, value);
506     }
507 
508     // optional functions from ERC20 stardard
509 
510     /**
511      * @return the name of the token.
512      */
513     function name() public view returns (string memory) {
514       return _name;
515     }
516 
517     /**
518      * @return the symbol of the token.
519      */
520     function symbol() public view returns (string memory) {
521       return _symbol;
522     }
523 
524     /**
525      * @return the number of decimals of the token.
526      */
527     function decimals() public view returns (uint8) {
528       return _decimals;
529     }
530 }