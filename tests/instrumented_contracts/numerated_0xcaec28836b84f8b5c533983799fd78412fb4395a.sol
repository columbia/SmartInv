1 /*
2 $INU - INU.
3 
4 In this wonderful world of crypto currency, everybody has heard a wild 
5 overnight success story. Maybe you’ve been a lucky participant and 
6 experienced said success for yourself. Maybe you’ve experienced financial 
7 freedom and have been liberated from the chains of poverty. Those who have 
8 had fortune shine upon them will be the first to tell you, it’s the power 
9 of the collective that allows any success to be had at all. 
10 
11 As we rip back into the “trend inu” cycle, we must pay homage to that 
12 which began it all - Shiba Inu. Shib’s rise proved that all it took was 
13 tenacity and collective action to achieve the dreams of so many market 
14 participants: that financial liberation that is so sought after. Shib’s 
15 legacy is tainted by the use of the “inu” name by pump and dump influencers 
16 and scammers, people who are tarnishing the all important community based 
17 nature of an “Inu” token.   
18 
19 We find ourselves barreling toward the end of a mini bull cycle before it 
20 even begins. Meme coins are fertile ground for ill intended characters.  
21 Be them influencers or just dirty devs, those who use the “inu” name for 
22 their own good rather than the good of the community need a reminder - a 
23 reminder what exactly “inu” stands for.
24 
25 Here is one for you.  
26 
27 INU is that reminder.
28 
29 INU has no dev, no team, no taxes, no trends, no influencers or insidoors. 
30 
31 INU just has everyone who reads this and you.
32 
33 A reminder of the past but a beacon towards the future, a point in which WGMI.  
34 
35 Liquidity is burned, 50% supply is burned. No dev. No socials. No official telegram.
36 
37 This one is yours, $INU
38 
39 */
40 
41 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
42 
43 pragma solidity ^0.5.0;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
47  * the optional functions; to access them see `ERC20Detailed`.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a `Transfer` event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through `transferFrom`. This is
72      * zero by default.
73      *
74      * This value changes when `approve` or `transferFrom` are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * > Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an `Approval` event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a `Transfer` event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to `approve`. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
121 
122 pragma solidity ^0.5.0;
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a, "SafeMath: subtraction overflow");
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         // Solidity only automatically asserts when dividing by 0
206         require(b > 0, "SafeMath: division by zero");
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         require(b != 0, "SafeMath: modulo by zero");
226         return a % b;
227     }
228 }
229 
230 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
231 
232 pragma solidity ^0.5.0;
233 
234 
235 
236 /**
237  * @dev Implementation of the `IERC20` interface.
238  *
239  * This implementation is agnostic to the way tokens are created. This means
240  * that a supply mechanism has to be added in a derived contract using `_mint`.
241  * For a generic mechanism see `ERC20Mintable`.
242  *
243  * *For a detailed writeup see our guide [How to implement supply
244  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
245  *
246  * We have followed general OpenZeppelin guidelines: functions revert instead
247  * of returning `false` on failure. This behavior is nonetheless conventional
248  * and does not conflict with the expectations of ERC20 applications.
249  *
250  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See `IERC20.approve`.
258  */
259 contract ERC20 is IERC20 {
260     using SafeMath for uint256;
261 
262     mapping (address => uint256) private _balances;
263 
264     mapping (address => mapping (address => uint256)) private _allowances;
265 
266     uint256 private _totalSupply;
267 
268     /**
269      * @dev See `IERC20.totalSupply`.
270      */
271     function totalSupply() public view returns (uint256) {
272         return _totalSupply;
273     }
274 
275     /**
276      * @dev See `IERC20.balanceOf`.
277      */
278     function balanceOf(address account) public view returns (uint256) {
279         return _balances[account];
280     }
281 
282     /**
283      * @dev See `IERC20.transfer`.
284      *
285      * Requirements:
286      *
287      * - `recipient` cannot be the zero address.
288      * - the caller must have a balance of at least `amount`.
289      */
290     function transfer(address recipient, uint256 amount) public returns (bool) {
291         _transfer(msg.sender, recipient, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See `IERC20.allowance`.
297      */
298     function allowance(address owner, address spender) public view returns (uint256) {
299         return _allowances[owner][spender];
300     }
301 
302     /**
303      * @dev See `IERC20.approve`.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function approve(address spender, uint256 value) public returns (bool) {
310         _approve(msg.sender, spender, value);
311         return true;
312     }
313 
314     /**
315      * @dev See `IERC20.transferFrom`.
316      *
317      * Emits an `Approval` event indicating the updated allowance. This is not
318      * required by the EIP. See the note at the beginning of `ERC20`;
319      *
320      * Requirements:
321      * - `sender` and `recipient` cannot be the zero address.
322      * - `sender` must have a balance of at least `value`.
323      * - the caller must have allowance for `sender`'s tokens of at least
324      * `amount`.
325      */
326     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
327         _transfer(sender, recipient, amount);
328         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
329         return true;
330     }
331 
332     /**
333      * @dev Atomically increases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to `approve` that can be used as a mitigation for
336      * problems described in `IERC20.approve`.
337      *
338      * Emits an `Approval` event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
345         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
346         return true;
347     }
348 
349     /**
350      * @dev Atomically decreases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to `approve` that can be used as a mitigation for
353      * problems described in `IERC20.approve`.
354      *
355      * Emits an `Approval` event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      * - `spender` must have allowance for the caller of at least
361      * `subtractedValue`.
362      */
363     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
364         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
365         return true;
366     }
367 
368     /**
369      * @dev Moves tokens `amount` from `sender` to `recipient`.
370      *
371      * This is internal function is equivalent to `transfer`, and can be used to
372      * e.g. implement automatic token fees, slashing mechanisms, etc.
373      *
374      * Emits a `Transfer` event.
375      *
376      * Requirements:
377      *
378      * - `sender` cannot be the zero address.
379      * - `recipient` cannot be the zero address.
380      * - `sender` must have a balance of at least `amount`.
381      */
382     function _transfer(address sender, address recipient, uint256 amount) internal {
383         require(sender != address(0), "ERC20: transfer from the zero address");
384         require(recipient != address(0), "ERC20: transfer to the zero address");
385 
386         _balances[sender] = _balances[sender].sub(amount);
387         _balances[recipient] = _balances[recipient].add(amount);
388         emit Transfer(sender, recipient, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a `Transfer` event with `from` set to the zero address.
395      *
396      * Requirements
397      *
398      * - `to` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _totalSupply = _totalSupply.add(amount);
404         _balances[account] = _balances[account].add(amount);
405         emit Transfer(address(0), account, amount);
406     }
407 
408      /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a `Transfer` event with `to` set to the zero address.
413      *
414      * Requirements
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 value) internal {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _totalSupply = _totalSupply.sub(value);
423         _balances[account] = _balances[account].sub(value);
424         emit Transfer(account, address(0), value);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
429      *
430      * This is internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an `Approval` event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(address owner, address spender, uint256 value) internal {
441         require(owner != address(0), "ERC20: approve from the zero address");
442         require(spender != address(0), "ERC20: approve to the zero address");
443 
444         _allowances[owner][spender] = value;
445         emit Approval(owner, spender, value);
446     }
447 
448     /**
449      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
450      * from the caller's allowance.
451      *
452      * See `_burn` and `_approve`.
453      */
454     function _burnFrom(address account, uint256 amount) internal {
455         _burn(account, amount);
456         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
457     }
458 }
459 
460 // File: contracts\ERC20\TokenMintERC20Token.sol
461 
462 pragma solidity ^0.5.0;
463 
464 
465 /**
466  * @title TokenMintERC20Token
467  * @author TokenMint (visit https://tokenmint.io)
468  *
469  * @dev Standard ERC20 token with burning and optional functions implemented.
470  * For full specification of ERC-20 standard see:
471  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
472  */
473 contract TokenMintERC20Token is ERC20 {
474 
475     string private _name;
476     string private _symbol;
477     uint8 private _decimals;
478 
479     /**
480      * @dev Constructor.
481      * @param name name of the token
482      * @param symbol symbol of the token, 3-4 chars is recommended
483      * @param decimals number of decimal places of one token unit, 18 is widely used
484      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
485      * @param tokenOwnerAddress address that gets 100% of token supply
486      */
487     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
488       _name = name;
489       _symbol = symbol;
490       _decimals = decimals;
491 
492       // set tokenOwnerAddress as owner of all tokens
493       _mint(tokenOwnerAddress, totalSupply);
494 
495       // pay the service fee for contract deployment
496       feeReceiver.transfer(msg.value);
497     }
498 
499     /**
500      * @dev Burns a specific amount of tokens.
501      * @param value The amount of lowest token units to be burned.
502      */
503     function burn(uint256 value) public {
504       _burn(msg.sender, value);
505     }
506 
507     // optional functions from ERC20 stardard
508 
509     /**
510      * @return the name of the token.
511      */
512     function name() public view returns (string memory) {
513       return _name;
514     }
515 
516     /**
517      * @return the symbol of the token.
518      */
519     function symbol() public view returns (string memory) {
520       return _symbol;
521     }
522 
523     /**
524      * @return the number of decimals of the token.
525      */
526     function decimals() public view returns (uint8) {
527       return _decimals;
528     }
529 }