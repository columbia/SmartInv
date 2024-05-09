1 /**
2 
3 Hachikō - the dog who waited.
4 
5 Known in Japan as chūken Hachikō (faithful dog Hachikō) Hachikō 
6 is more than just a dog, he is a symbol.  If you don’t know his 
7 story I will briefly summarize:
8 
9 Born in 1923, Hachikō was owned by Hidesaburō Ueno.  He loved 
10 his owner more than anything and waited for him every single 
11 ay at Shibuya Station to get off work (this story takes a very 
12 sad turn if you weren’t already aware).  
13 
14 One day - Ueno died while at work, yet where was Hachikō?  
15 Waiting at the station for his owner.  His owner was never 
16 coming back.  
17 
18 An excerpt from Wikipedia - “Each day, for the next nine years, 
19 nine months and fifteen days, Hachikō awaited Ueno's return, 
20 appearing precisely when the train was due at the station.”  
21 
22 As his story spread, articles were published about his loyalty, 
23 a famous statue was erected in his honor, and he became a symbol 
24 of loyalty across Japan.  
25 
26 $HACHI 
27 
28 In the current cryptocurrency environment, much like the rest of 
29 the market, we are experiencing a historic low.  As expected, the 
30 subsection of the market primarily dictated by memes and even deeper 
31 than that, culture itself, is suffering particularly.  This culture, 
32 which at one point was rich with variety, strength, and fidelity, 
33 has been reduced to copies of copies, pretending to be rich people 
34 to bait others into investing, and an overwhelming influx of tokens 
35 that have a lifespan of less than a single day.  
36 
37 How have we fallen so far?
38 
39 The bear market is of course partially to blame, but where is the shining 
40 light through the darkness?  Many are awaiting its emergence with great 
41 patience, but just like the dog who waited its entire life for an owner 
42 that was already dead, just simply waiting will not bring it to fruition.  
43 $HACHI represents the fierce loyalty that is so desperately needed right 
44 now, and is a symbol of hope for many.  
45 
46 Hachikō waits, and so do we.  
47 
48 Don't just wait around, create your own bull market with $HACHI.
49 
50 */
51 
52 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
53 
54 pragma solidity ^0.5.0;
55 
56 /**
57  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
58  * the optional functions; to access them see `ERC20Detailed`.
59  */
60 interface IERC20 {
61     /**
62      * @dev Returns the amount of tokens in existence.
63      */
64     function totalSupply() external view returns (uint256);
65 
66     /**
67      * @dev Returns the amount of tokens owned by `account`.
68      */
69     function balanceOf(address account) external view returns (uint256);
70 
71     /**
72      * @dev Moves `amount` tokens from the caller's account to `recipient`.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a `Transfer` event.
77      */
78     function transfer(address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Returns the remaining number of tokens that `spender` will be
82      * allowed to spend on behalf of `owner` through `transferFrom`. This is
83      * zero by default.
84      *
85      * This value changes when `approve` or `transferFrom` are called.
86      */
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * > Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an `Approval` event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `sender` to `recipient` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a `Transfer` event.
113      */
114     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to `approve`. `value` is the new allowance.
127      */
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
132 
133 pragma solidity ^0.5.0;
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b <= a, "SafeMath: subtraction overflow");
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Solidity only automatically asserts when dividing by 0
217         require(b > 0, "SafeMath: division by zero");
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b != 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 }
240 
241 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
242 
243 pragma solidity ^0.5.0;
244 
245 
246 
247 /**
248  * @dev Implementation of the `IERC20` interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using `_mint`.
252  * For a generic mechanism see `ERC20Mintable`.
253  *
254  * *For a detailed writeup see our guide [How to implement supply
255  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
256  *
257  * We have followed general OpenZeppelin guidelines: functions revert instead
258  * of returning `false` on failure. This behavior is nonetheless conventional
259  * and does not conflict with the expectations of ERC20 applications.
260  *
261  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See `IERC20.approve`.
269  */
270 contract ERC20 is IERC20 {
271     using SafeMath for uint256;
272 
273     mapping (address => uint256) private _balances;
274 
275     mapping (address => mapping (address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     /**
280      * @dev See `IERC20.totalSupply`.
281      */
282     function totalSupply() public view returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See `IERC20.balanceOf`.
288      */
289     function balanceOf(address account) public view returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See `IERC20.transfer`.
295      *
296      * Requirements:
297      *
298      * - `recipient` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address recipient, uint256 amount) public returns (bool) {
302         _transfer(msg.sender, recipient, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See `IERC20.allowance`.
308      */
309     function allowance(address owner, address spender) public view returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See `IERC20.approve`.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function approve(address spender, uint256 value) public returns (bool) {
321         _approve(msg.sender, spender, value);
322         return true;
323     }
324 
325     /**
326      * @dev See `IERC20.transferFrom`.
327      *
328      * Emits an `Approval` event indicating the updated allowance. This is not
329      * required by the EIP. See the note at the beginning of `ERC20`;
330      *
331      * Requirements:
332      * - `sender` and `recipient` cannot be the zero address.
333      * - `sender` must have a balance of at least `value`.
334      * - the caller must have allowance for `sender`'s tokens of at least
335      * `amount`.
336      */
337     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
338         _transfer(sender, recipient, amount);
339         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
340         return true;
341     }
342 
343     /**
344      * @dev Atomically increases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to `approve` that can be used as a mitigation for
347      * problems described in `IERC20.approve`.
348      *
349      * Emits an `Approval` event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
356         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
357         return true;
358     }
359 
360     /**
361      * @dev Atomically decreases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to `approve` that can be used as a mitigation for
364      * problems described in `IERC20.approve`.
365      *
366      * Emits an `Approval` event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      * - `spender` must have allowance for the caller of at least
372      * `subtractedValue`.
373      */
374     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
375         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Moves tokens `amount` from `sender` to `recipient`.
381      *
382      * This is internal function is equivalent to `transfer`, and can be used to
383      * e.g. implement automatic token fees, slashing mechanisms, etc.
384      *
385      * Emits a `Transfer` event.
386      *
387      * Requirements:
388      *
389      * - `sender` cannot be the zero address.
390      * - `recipient` cannot be the zero address.
391      * - `sender` must have a balance of at least `amount`.
392      */
393     function _transfer(address sender, address recipient, uint256 amount) internal {
394         require(sender != address(0), "ERC20: transfer from the zero address");
395         require(recipient != address(0), "ERC20: transfer to the zero address");
396 
397         _balances[sender] = _balances[sender].sub(amount);
398         _balances[recipient] = _balances[recipient].add(amount);
399         emit Transfer(sender, recipient, amount);
400     }
401 
402     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
403      * the total supply.
404      *
405      * Emits a `Transfer` event with `from` set to the zero address.
406      *
407      * Requirements
408      *
409      * - `to` cannot be the zero address.
410      */
411     function _mint(address account, uint256 amount) internal {
412         require(account != address(0), "ERC20: mint to the zero address");
413 
414         _totalSupply = _totalSupply.add(amount);
415         _balances[account] = _balances[account].add(amount);
416         emit Transfer(address(0), account, amount);
417     }
418 
419      /**
420      * @dev Destroys `amount` tokens from `account`, reducing the
421      * total supply.
422      *
423      * Emits a `Transfer` event with `to` set to the zero address.
424      *
425      * Requirements
426      *
427      * - `account` cannot be the zero address.
428      * - `account` must have at least `amount` tokens.
429      */
430     function _burn(address account, uint256 value) internal {
431         require(account != address(0), "ERC20: burn from the zero address");
432 
433         _totalSupply = _totalSupply.sub(value);
434         _balances[account] = _balances[account].sub(value);
435         emit Transfer(account, address(0), value);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
440      *
441      * This is internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an `Approval` event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(address owner, address spender, uint256 value) internal {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = value;
456         emit Approval(owner, spender, value);
457     }
458 
459     /**
460      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
461      * from the caller's allowance.
462      *
463      * See `_burn` and `_approve`.
464      */
465     function _burnFrom(address account, uint256 amount) internal {
466         _burn(account, amount);
467         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
468     }
469 }
470 
471 // File: contracts\ERC20\TokenMintERC20Token.sol
472 
473 pragma solidity ^0.5.0;
474 
475 
476 /**
477  * @title TokenMintERC20Token
478  * @author TokenMint (visit https://tokenmint.io)
479  *
480  * @dev Standard ERC20 token with burning and optional functions implemented.
481  * For full specification of ERC-20 standard see:
482  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
483  */
484 contract TokenMintERC20Token is ERC20 {
485 
486     string private _name;
487     string private _symbol;
488     uint8 private _decimals;
489 
490     /**
491      * @dev Constructor.
492      * @param name name of the token
493      * @param symbol symbol of the token, 3-4 chars is recommended
494      * @param decimals number of decimal places of one token unit, 18 is widely used
495      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
496      * @param tokenOwnerAddress address that gets 100% of token supply
497      */
498     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
499       _name = name;
500       _symbol = symbol;
501       _decimals = decimals;
502 
503       // set tokenOwnerAddress as owner of all tokens
504       _mint(tokenOwnerAddress, totalSupply);
505 
506       // pay the service fee for contract deployment
507       feeReceiver.transfer(msg.value);
508     }
509 
510     /**
511      * @dev Burns a specific amount of tokens.
512      * @param value The amount of lowest token units to be burned.
513      */
514     function burn(uint256 value) public {
515       _burn(msg.sender, value);
516     }
517 
518     // optional functions from ERC20 stardard
519 
520     /**
521      * @return the name of the token.
522      */
523     function name() public view returns (string memory) {
524       return _name;
525     }
526 
527     /**
528      * @return the symbol of the token.
529      */
530     function symbol() public view returns (string memory) {
531       return _symbol;
532     }
533 
534     /**
535      * @return the number of decimals of the token.
536      */
537     function decimals() public view returns (uint8) {
538       return _decimals;
539     }
540 }