1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.7.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 // File: @openzeppelin/contracts/GSN/Context.sol
163 
164 pragma solidity ^0.7.0;
165 
166 /*
167  * @dev Provides information about the current execution context, including the
168  * sender of the transaction and its data. While these are generally available
169  * via msg.sender and msg.data, they should not be accessed in such a direct
170  * manner, since when dealing with GSN meta-transactions the account sending and
171  * paying for execution may not be the actual sender (as far as an application
172  * is concerned).
173  *
174  * This contract is only required for intermediate, library-like contracts.
175  */
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address payable) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes memory) {
182         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
187 
188 pragma solidity ^0.7.0;
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
216      * zero by default.
217      *
218      * This value changes when {approve} or {transferFrom} are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
264 
265 pragma solidity ^0.7.0;
266 
267 
268 /**
269  * @dev Implementation of the {IERC20} interface.
270  *
271  * This implementation is agnostic to the way tokens are created. This means
272  * that a supply mechanism has to be added in a derived contract using {_mint}.
273  * For a generic mechanism see {ERC20PresetMinterPauser}.
274  *
275  * TIP: For a detailed writeup see our guide
276  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
277  * to implement supply mechanisms].
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     string private _name;
302     string private _symbol;
303     uint8 private _decimals;
304 
305     /**
306      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
307      * a default value of 18.
308      *
309      * To select a different value for {decimals}, use {_setupDecimals}.
310      *
311      * All three of these values are immutable: they can only be set once during
312      * construction.
313      */
314     constructor (string memory name_, string memory symbol_) public {
315         _name = name_;
316         _symbol = symbol_;
317         _decimals = 18;
318     }
319 
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() public view returns (string memory) {
324         return _name;
325     }
326 
327     /**
328      * @dev Returns the symbol of the token, usually a shorter version of the
329      * name.
330      */
331     function symbol() public view returns (string memory) {
332         return _symbol;
333     }
334 
335     /**
336      * @dev Returns the number of decimals used to get its user representation.
337      * For example, if `decimals` equals `2`, a balance of `505` tokens should
338      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
339      *
340      * Tokens usually opt for a value of 18, imitating the relationship between
341      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
342      * called.
343      *
344      * NOTE: This information is only used for _display_ purposes: it in
345      * no way affects any of the arithmetic of the contract, including
346      * {IERC20-balanceOf} and {IERC20-transfer}.
347      */
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view override returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account) public view override returns (uint256) {
363         return _balances[account];
364     }
365 
366     /**
367      * @dev See {IERC20-transfer}.
368      *
369      * Requirements:
370      *
371      * - `recipient` cannot be the zero address.
372      * - the caller must have a balance of at least `amount`.
373      */
374     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender) public view virtual override returns (uint256) {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function approve(address spender, uint256 amount) public virtual override returns (bool) {
394         _approve(_msgSender(), spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * Requirements:
405      *
406      * - `sender` and `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      * - the caller must have allowance for ``sender``'s tokens of at least
409      * `amount`.
410      */
411     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
412         _transfer(sender, recipient, amount);
413         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
430         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
431         return true;
432     }
433 
434     /**
435      * @dev Atomically decreases the allowance granted to `spender` by the caller.
436      *
437      * This is an alternative to {approve} that can be used as a mitigation for
438      * problems described in {IERC20-approve}.
439      *
440      * Emits an {Approval} event indicating the updated allowance.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      * - `spender` must have allowance for the caller of at least
446      * `subtractedValue`.
447      */
448     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
449         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
450         return true;
451     }
452 
453     /**
454      * @dev Moves tokens `amount` from `sender` to `recipient`.
455      *
456      * This is internal function is equivalent to {transfer}, and can be used to
457      * e.g. implement automatic token fees, slashing mechanisms, etc.
458      *
459      * Emits a {Transfer} event.
460      *
461      * Requirements:
462      *
463      * - `sender` cannot be the zero address.
464      * - `recipient` cannot be the zero address.
465      * - `sender` must have a balance of at least `amount`.
466      */
467     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
468         require(sender != address(0), "ERC20: transfer from the zero address");
469         require(recipient != address(0), "ERC20: transfer to the zero address");
470 
471         _beforeTokenTransfer(sender, recipient, amount);
472 
473         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
474         _balances[recipient] = _balances[recipient].add(amount);
475         emit Transfer(sender, recipient, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `to` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply = _totalSupply.add(amount);
493         _balances[account] = _balances[account].add(amount);
494         emit Transfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
514         _totalSupply = _totalSupply.sub(amount);
515         emit Transfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(address owner, address spender, uint256 amount) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Sets {decimals} to a value other than the default one of 18.
541      *
542      * WARNING: This function should only be called from the constructor. Most
543      * applications that interact with token contracts will not expect
544      * {decimals} to ever change, and may work incorrectly if it does.
545      */
546     function _setupDecimals(uint8 decimals_) internal {
547         _decimals = decimals_;
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be to transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
565 }
566 
567 contract KYFI is ERC20 {
568     constructor() ERC20("moneyearn.finance", "KYFI") {
569         _mint(msg.sender, 50000E18);
570     }
571 }