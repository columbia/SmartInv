1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 /**
257  * @dev Implementation of the {IERC20} interface.
258  *
259  * This implementation is agnostic to the way tokens are created. This means
260  * that a supply mechanism has to be added in a derived contract using {_mint}.
261  * For a generic mechanism see {ERC20PresetMinterPauser}.
262  *
263  * TIP: For a detailed writeup see our guide
264  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
265  * to implement supply mechanisms].
266  *
267  * We have followed general OpenZeppelin guidelines: functions revert instead
268  * of returning `false` on failure. This behavior is nonetheless conventional
269  * and does not conflict with the expectations of ERC20 applications.
270  *
271  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
272  * This allows applications to reconstruct the allowance for all accounts just
273  * by listening to said events. Other implementations of the EIP may not emit
274  * these events, as it isn't required by the specification.
275  *
276  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
277  * functions have been added to mitigate the well-known issues around setting
278  * allowances. See {IERC20-approve}.
279  */
280 contract YfDFI_finance is Context, IERC20 {
281     using SafeMath for uint256;
282 
283     mapping (address => uint256) private _balances;
284 
285     mapping (address => mapping (address => uint256)) private _allowances;
286 
287     uint256 private _totalSupply;
288 
289     string private _name;
290     string private _symbol;
291     uint8 private _decimals;
292 
293     /**
294      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
295      * a default value of 18.
296      *
297      * To select a different value for {decimals}, use {_setupDecimals}.
298      *
299      * All three of these values are immutable: they can only be set once during
300      * construction.
301      */
302     constructor (string memory name, string memory symbol) public {
303         _name = name;
304         _symbol = symbol;
305         _decimals = 18;
306         
307         _mint(msg.sender, 20000000000000000000000);
308    
309     }
310 
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() public view returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @dev Returns the symbol of the token, usually a shorter version of the
320      * name.
321      */
322     function symbol() public view returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @dev Returns the number of decimals used to get its user representation.
328      * For example, if `decimals` equals `2`, a balance of `505` tokens should
329      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
330      *
331      * Tokens usually opt for a value of 18, imitating the relationship between
332      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
333      * called.
334      *
335      * NOTE: This information is only used for _display_ purposes: it in
336      * no way affects any of the arithmetic of the contract, including
337      * {IERC20-balanceOf} and {IERC20-transfer}.
338      */
339     function decimals() public view returns (uint8) {
340         return _decimals;
341     }
342 
343     /**
344      * @dev See {IERC20-totalSupply}.
345      */
346     function totalSupply() public view override returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account) public view override returns (uint256) {
354         return _balances[account];
355     }
356 
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `recipient` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender) public view virtual override returns (uint256) {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-transferFrom}.
391      *
392      * Emits an {Approval} event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of {ERC20}.
394      *
395      * Requirements:
396      *
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
465         _balances[recipient] = _balances[recipient].add(amount);
466         emit Transfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `to` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply = _totalSupply.add(amount);
484         _balances[account] = _balances[account].add(amount);
485         emit Transfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498       
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
505         _totalSupply = _totalSupply.sub(amount);
506         emit Transfer(account, address(0), amount);
507     }
508 */
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(address owner, address spender, uint256 amount) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Sets {decimals} to a value other than the default one of 18.
532      *
533      * WARNING: This function should only be called from the constructor. Most
534      * applications that interact with token contracts will not expect
535      * {decimals} to ever change, and may work incorrectly if it does.
536      */
537     function _setupDecimals(uint8 decimals_) internal {
538         _decimals = decimals_;
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be to transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
556 }