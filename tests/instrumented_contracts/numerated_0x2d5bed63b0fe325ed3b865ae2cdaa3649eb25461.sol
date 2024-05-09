1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
269 
270 
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20PresetMinterPauser}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     string private _name;
310     string private _symbol;
311     uint8 private _decimals;
312 
313     /**
314      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
315      * a default value of 18.
316      *
317      * To select a different value for {decimals}, use {_setupDecimals}.
318      *
319      * All three of these values are immutable: they can only be set once during
320      * construction.
321      */
322     constructor (string memory name_, string memory symbol_) public {
323         _name = name_;
324         _symbol = symbol_;
325         _decimals = 18;
326     }
327 
328     /**
329      * @dev Returns the name of the token.
330      */
331     function name() public view returns (string memory) {
332         return _name;
333     }
334 
335     /**
336      * @dev Returns the symbol of the token, usually a shorter version of the
337      * name.
338      */
339     function symbol() public view returns (string memory) {
340         return _symbol;
341     }
342 
343     /**
344      * @dev Returns the number of decimals used to get its user representation.
345      * For example, if `decimals` equals `2`, a balance of `505` tokens should
346      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
347      *
348      * Tokens usually opt for a value of 18, imitating the relationship between
349      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
350      * called.
351      *
352      * NOTE: This information is only used for _display_ purposes: it in
353      * no way affects any of the arithmetic of the contract, including
354      * {IERC20-balanceOf} and {IERC20-transfer}.
355      */
356     function decimals() public view returns (uint8) {
357         return _decimals;
358     }
359 
360     /**
361      * @dev See {IERC20-totalSupply}.
362      */
363     function totalSupply() public view override returns (uint256) {
364         return _totalSupply;
365     }
366 
367     /**
368      * @dev See {IERC20-balanceOf}.
369      */
370     function balanceOf(address account) public view override returns (uint256) {
371         return _balances[account];
372     }
373 
374     /**
375      * @dev See {IERC20-transfer}.
376      *
377      * Requirements:
378      *
379      * - `recipient` cannot be the zero address.
380      * - the caller must have a balance of at least `amount`.
381      */
382     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
383         _transfer(_msgSender(), recipient, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-allowance}.
389      */
390     function allowance(address owner, address spender) public view virtual override returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     /**
395      * @dev See {IERC20-approve}.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 amount) public virtual override returns (bool) {
402         _approve(_msgSender(), spender, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-transferFrom}.
408      *
409      * Emits an {Approval} event indicating the updated allowance. This is not
410      * required by the EIP. See the note at the beginning of {ERC20}.
411      *
412      * Requirements:
413      *
414      * - `sender` and `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      * - the caller must have allowance for ``sender``'s tokens of at least
417      * `amount`.
418      */
419     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
420         _transfer(sender, recipient, amount);
421         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
457         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
458         return true;
459     }
460 
461     /**
462      * @dev Moves tokens `amount` from `sender` to `recipient`.
463      *
464      * This is internal function is equivalent to {transfer}, and can be used to
465      * e.g. implement automatic token fees, slashing mechanisms, etc.
466      *
467      * Emits a {Transfer} event.
468      *
469      * Requirements:
470      *
471      * - `sender` cannot be the zero address.
472      * - `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      */
475     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
476         require(sender != address(0), "ERC20: transfer from the zero address");
477         require(recipient != address(0), "ERC20: transfer to the zero address");
478 
479         _beforeTokenTransfer(sender, recipient, amount);
480 
481         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
482         _balances[recipient] = _balances[recipient].add(amount);
483         emit Transfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `to` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply = _totalSupply.add(amount);
501         _balances[account] = _balances[account].add(amount);
502         emit Transfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
522         _totalSupply = _totalSupply.sub(amount);
523         emit Transfer(account, address(0), amount);
524     }
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
528      *
529      * This internal function is equivalent to `approve`, and can be used to
530      * e.g. set automatic allowances for certain subsystems, etc.
531      *
532      * Emits an {Approval} event.
533      *
534      * Requirements:
535      *
536      * - `owner` cannot be the zero address.
537      * - `spender` cannot be the zero address.
538      */
539     function _approve(address owner, address spender, uint256 amount) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     /**
548      * @dev Sets {decimals} to a value other than the default one of 18.
549      *
550      * WARNING: This function should only be called from the constructor. Most
551      * applications that interact with token contracts will not expect
552      * {decimals} to ever change, and may work incorrectly if it does.
553      */
554     function _setupDecimals(uint8 decimals_) internal {
555         _decimals = decimals_;
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be to transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
573 }
574 
575 pragma solidity ^0.6.0;
576 
577 
578 contract TeslafanToken is ERC20 {
579     constructor() public ERC20("Teslafan", "TESLF") {
580         _mint(msg.sender, 700000000 * 10**18);
581     }
582 }