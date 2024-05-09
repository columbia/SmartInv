1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-14
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: @openzeppelin/contracts/math/SafeMath.sol
113 
114 // SPDX-License-Identifier: MIT
115 
116 pragma solidity >=0.6.0 <0.8.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
275 
276 // SPDX-License-Identifier: MIT
277 
278 pragma solidity >=0.6.0 <0.8.0;
279 
280 
281 
282 
283 /**
284  * @dev Implementation of the {IERC20} interface.
285  *
286  * This implementation is agnostic to the way tokens are created. This means
287  * that a supply mechanism has to be added in a derived contract using {_mint}.
288  * For a generic mechanism see {ERC20PresetMinterPauser}.
289  *
290  * TIP: For a detailed writeup see our guide
291  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
292  * to implement supply mechanisms].
293  *
294  * We have followed general OpenZeppelin guidelines: functions revert instead
295  * of returning `false` on failure. This behavior is nonetheless conventional
296  * and does not conflict with the expectations of ERC20 applications.
297  *
298  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
299  * This allows applications to reconstruct the allowance for all accounts just
300  * by listening to said events. Other implementations of the EIP may not emit
301  * these events, as it isn't required by the specification.
302  *
303  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
304  * functions have been added to mitigate the well-known issues around setting
305  * allowances. See {IERC20-approve}.
306  */
307 contract ERC20 is Context, IERC20 {
308     using SafeMath for uint256;
309 
310     mapping (address => uint256) private _balances;
311 
312     mapping (address => mapping (address => uint256)) private _allowances;
313 
314     uint256 private _totalSupply;
315 
316     string private _name;
317     string private _symbol;
318     uint8 private _decimals;
319 
320     /**
321      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
322      * a default value of 18.
323      *
324      * To select a different value for {decimals}, use {_setupDecimals}.
325      *
326      * All three of these values are immutable: they can only be set once during
327      * construction.
328      */
329     constructor (string memory name_, string memory symbol_) public {
330         _name = name_;
331         _symbol = symbol_;
332         _decimals = 18;
333     }
334 
335     /**
336      * @dev Returns the name of the token.
337      */
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     /**
343      * @dev Returns the symbol of the token, usually a shorter version of the
344      * name.
345      */
346     function symbol() public view returns (string memory) {
347         return _symbol;
348     }
349 
350     /**
351      * @dev Returns the number of decimals used to get its user representation.
352      * For example, if `decimals` equals `2`, a balance of `505` tokens should
353      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
354      *
355      * Tokens usually opt for a value of 18, imitating the relationship between
356      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
357      * called.
358      *
359      * NOTE: This information is only used for _display_ purposes: it in
360      * no way affects any of the arithmetic of the contract, including
361      * {IERC20-balanceOf} and {IERC20-transfer}.
362      */
363     function decimals() public view returns (uint8) {
364         return _decimals;
365     }
366 
367     /**
368      * @dev See {IERC20-totalSupply}.
369      */
370     function totalSupply() public view override returns (uint256) {
371         return _totalSupply;
372     }
373 
374     /**
375      * @dev See {IERC20-balanceOf}.
376      */
377     function balanceOf(address account) public view override returns (uint256) {
378         return _balances[account];
379     }
380 
381     /**
382      * @dev See {IERC20-transfer}.
383      *
384      * Requirements:
385      *
386      * - `recipient` cannot be the zero address.
387      * - the caller must have a balance of at least `amount`.
388      */
389     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
390         _transfer(_msgSender(), recipient, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-allowance}.
396      */
397     function allowance(address owner, address spender) public view virtual override returns (uint256) {
398         return _allowances[owner][spender];
399     }
400 
401     /**
402      * @dev See {IERC20-approve}.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function approve(address spender, uint256 amount) public virtual override returns (bool) {
409         _approve(_msgSender(), spender, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-transferFrom}.
415      *
416      * Emits an {Approval} event indicating the updated allowance. This is not
417      * required by the EIP. See the note at the beginning of {ERC20}.
418      *
419      * Requirements:
420      *
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      * - the caller must have allowance for ``sender``'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         _beforeTokenTransfer(sender, recipient, amount);
487 
488         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
489         _balances[recipient] = _balances[recipient].add(amount);
490         emit Transfer(sender, recipient, amount);
491     }
492 
493     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
494      * the total supply.
495      *
496      * Emits a {Transfer} event with `from` set to the zero address.
497      *
498      * Requirements:
499      *
500      * - `to` cannot be the zero address.
501      */
502     function _mint(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: mint to the zero address");
504 
505         _beforeTokenTransfer(address(0), account, amount);
506 
507         _totalSupply = _totalSupply.add(amount);
508         _balances[account] = _balances[account].add(amount);
509         emit Transfer(address(0), account, amount);
510     }
511 
512     /**
513      * @dev Destroys `amount` tokens from `account`, reducing the
514      * total supply.
515      *
516      * Emits a {Transfer} event with `to` set to the zero address.
517      *
518      * Requirements:
519      *
520      * - `account` cannot be the zero address.
521      * - `account` must have at least `amount` tokens.
522      */
523     function _burn(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: burn from the zero address");
525 
526         _beforeTokenTransfer(account, address(0), amount);
527 
528         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
529         _totalSupply = _totalSupply.sub(amount);
530         emit Transfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(address owner, address spender, uint256 amount) internal virtual {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     /**
555      * @dev Sets {decimals} to a value other than the default one of 18.
556      *
557      * WARNING: This function should only be called from the constructor. Most
558      * applications that interact with token contracts will not expect
559      * {decimals} to ever change, and may work incorrectly if it does.
560      */
561     function _setupDecimals(uint8 decimals_) internal {
562         _decimals = decimals_;
563     }
564 
565     /**
566      * @dev Hook that is called before any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * will be to transferred to `to`.
573      * - when `from` is zero, `amount` tokens will be minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
580 }
581 
582 // File: contracts/MUSHToken.sol
583 
584 // contracts/MUSHToken.sol
585 
586 
587 contract MUSHToken is ERC20 {
588     constructor(uint256 initialSupply) public ERC20("MUSH", "MUSH") {
589         _mint(msg.sender, initialSupply);
590     }
591 }