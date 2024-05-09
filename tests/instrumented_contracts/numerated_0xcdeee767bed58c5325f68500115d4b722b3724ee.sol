1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
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
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
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
79      * Emits a {Transfer} event.
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
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 /**
255  * @dev Implementation of the {IERC20} interface.
256  *
257  * This implementation is agnostic to the way tokens are created. This means
258  * that a supply mechanism has to be added in a derived contract using {_mint}.
259  * For a generic mechanism see {ERC20PresetMinterPauser}.
260  *
261  * TIP: For a detailed writeup see our guide
262  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
263  * to implement supply mechanisms].
264  *
265  * We have followed general OpenZeppelin guidelines: functions revert instead
266  * of returning `false` on failure. This behavior is nonetheless conventional
267  * and does not conflict with the expectations of ERC20 applications.
268  *
269  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
270  * This allows applications to reconstruct the allowance for all accounts just
271  * by listening to said events. Other implementations of the EIP may not emit
272  * these events, as it isn't required by the specification.
273  *
274  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
275  * functions have been added to mitigate the well-known issues around setting
276  * allowances. See {IERC20-approve}.
277  */
278 contract ERC20 is Context, IERC20 {
279     using SafeMath for uint256;
280 
281     mapping (address => uint256) private _balances;
282 
283     mapping (address => mapping (address => uint256)) private _allowances;
284 
285     uint256 private _totalSupply;
286 
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     /**
292      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
293      * a default value of 18.
294      *
295      * To select a different value for {decimals}, use {_setupDecimals}.
296      *
297      * All three of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor (string memory name, string memory symbol) public {
301         _name = name;
302         _symbol = symbol;
303         _decimals = 18;
304     }
305 
306     /**
307      * @dev Returns the name of the token.
308      */
309     function name() public view returns (string memory) {
310         return _name;
311     }
312 
313     /**
314      * @dev Returns the symbol of the token, usually a shorter version of the
315      * name.
316      */
317     function symbol() public view returns (string memory) {
318         return _symbol;
319     }
320 
321     /**
322      * @dev Returns the number of decimals used to get its user representation.
323      * For example, if `decimals` equals `2`, a balance of `505` tokens should
324      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
325      *
326      * Tokens usually opt for a value of 18, imitating the relationship between
327      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
328      * called.
329      *
330      * NOTE: This information is only used for _display_ purposes: it in
331      * no way affects any of the arithmetic of the contract, including
332      * {IERC20-balanceOf} and {IERC20-transfer}.
333      */
334     function decimals() public view returns (uint8) {
335         return _decimals;
336     }
337 
338     /**
339      * @dev See {IERC20-totalSupply}.
340      */
341     function totalSupply() public view override returns (uint256) {
342         return _totalSupply;
343     }
344 
345     /**
346      * @dev See {IERC20-balanceOf}.
347      */
348     function balanceOf(address account) public view override returns (uint256) {
349         return _balances[account];
350     }
351 
352     /**
353      * @dev See {IERC20-transfer}.
354      *
355      * Requirements:
356      *
357      * - `recipient` cannot be the zero address.
358      * - the caller must have a balance of at least `amount`.
359      */
360     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
361         _transfer(_msgSender(), recipient, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-allowance}.
367      */
368     function allowance(address owner, address spender) public view virtual override returns (uint256) {
369         return _allowances[owner][spender];
370     }
371 
372     /**
373      * @dev See {IERC20-approve}.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function approve(address spender, uint256 amount) public virtual override returns (bool) {
380         _approve(_msgSender(), spender, amount);
381         return true;
382     }
383 
384     /**
385      * @dev See {IERC20-transferFrom}.
386      *
387      * Emits an {Approval} event indicating the updated allowance. This is not
388      * required by the EIP. See the note at the beginning of {ERC20}.
389      *
390      * Requirements:
391      *
392      * - `sender` and `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      * - the caller must have allowance for ``sender``'s tokens of at least
395      * `amount`.
396      */
397     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
398         _transfer(sender, recipient, amount);
399         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
400         return true;
401     }
402 
403     /**
404      * @dev Atomically increases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      */
415     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
416         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically decreases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      * - `spender` must have allowance for the caller of at least
432      * `subtractedValue`.
433      */
434     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
435         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
436         return true;
437     }
438 
439     /**
440      * @dev Moves tokens `amount` from `sender` to `recipient`.
441      *
442      * This is internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `sender` cannot be the zero address.
450      * - `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      */
453     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
454         require(sender != address(0), "ERC20: transfer from the zero address");
455         require(recipient != address(0), "ERC20: transfer to the zero address");
456 
457         _beforeTokenTransfer(sender, recipient, amount);
458 
459         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
460         _balances[recipient] = _balances[recipient].add(amount);
461         emit Transfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `to` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _beforeTokenTransfer(address(0), account, amount);
477 
478         _totalSupply = _totalSupply.add(amount);
479         _balances[account] = _balances[account].add(amount);
480         emit Transfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
500         _totalSupply = _totalSupply.sub(amount);
501         emit Transfer(account, address(0), amount);
502     }
503 
504     /**
505      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
506      *
507      * This internal function is equivalent to `approve`, and can be used to
508      * e.g. set automatic allowances for certain subsystems, etc.
509      *
510      * Emits an {Approval} event.
511      *
512      * Requirements:
513      *
514      * - `owner` cannot be the zero address.
515      * - `spender` cannot be the zero address.
516      */
517     function _approve(address owner, address spender, uint256 amount) internal virtual {
518         require(owner != address(0), "ERC20: approve from the zero address");
519         require(spender != address(0), "ERC20: approve to the zero address");
520 
521         _allowances[owner][spender] = amount;
522         emit Approval(owner, spender, amount);
523     }
524 
525     /**
526      * @dev Sets {decimals} to a value other than the default one of 18.
527      *
528      * WARNING: This function should only be called from the constructor. Most
529      * applications that interact with token contracts will not expect
530      * {decimals} to ever change, and may work incorrectly if it does.
531      */
532     function _setupDecimals(uint8 decimals_) internal {
533         _decimals = decimals_;
534     }
535 
536     /**
537      * @dev Hook that is called before any transfer of tokens. This includes
538      * minting and burning.
539      *
540      * Calling conditions:
541      *
542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
543      * will be to transferred to `to`.
544      * - when `from` is zero, `amount` tokens will be minted for `to`.
545      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
546      * - `from` and `to` are never both zero.
547      *
548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
549      */
550     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
551 }
552 
553 contract CARBON is ERC20 {
554     constructor(uint256 initialSupply) public ERC20("Carbon", "CRBN") {
555         _mint(msg.sender, initialSupply);
556     }
557 }