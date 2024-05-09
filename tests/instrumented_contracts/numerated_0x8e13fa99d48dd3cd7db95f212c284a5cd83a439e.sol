1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
267 
268 
269 pragma solidity >=0.6.0 <0.8.0;
270 
271 
272 
273 
274 /**
275  * @dev Implementation of the {IERC20} interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using {_mint}.
279  * For a generic mechanism see {ERC20PresetMinterPauser}.
280  *
281  * TIP: For a detailed writeup see our guide
282  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
283  * to implement supply mechanisms].
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See {IERC20-approve}.
297  */
298 contract ERC20 is Context, IERC20 {
299     using SafeMath for uint256;
300 
301     mapping (address => uint256) private _balances;
302 
303     mapping (address => mapping (address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     string private _name;
308     string private _symbol;
309     uint8 private _decimals;
310 
311     /**
312      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
313      * a default value of 18.
314      *
315      * To select a different value for {decimals}, use {_setupDecimals}.
316      *
317      * All three of these values are immutable: they can only be set once during
318      * construction.
319      */
320     constructor (string memory name_, string memory symbol_) public {
321         _name = name_;
322         _symbol = symbol_;
323         _decimals = 18;
324     }
325 
326     /**
327      * @dev Returns the name of the token.
328      */
329     function name() public view returns (string memory) {
330         return _name;
331     }
332 
333     /**
334      * @dev Returns the symbol of the token, usually a shorter version of the
335      * name.
336      */
337     function symbol() public view returns (string memory) {
338         return _symbol;
339     }
340 
341     /**
342      * @dev Returns the number of decimals used to get its user representation.
343      * For example, if `decimals` equals `2`, a balance of `505` tokens should
344      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
345      *
346      * Tokens usually opt for a value of 18, imitating the relationship between
347      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
348      * called.
349      *
350      * NOTE: This information is only used for _display_ purposes: it in
351      * no way affects any of the arithmetic of the contract, including
352      * {IERC20-balanceOf} and {IERC20-transfer}.
353      */
354     function decimals() public view returns (uint8) {
355         return _decimals;
356     }
357 
358     /**
359      * @dev See {IERC20-totalSupply}.
360      */
361     function totalSupply() public view override returns (uint256) {
362         return _totalSupply;
363     }
364 
365     /**
366      * @dev See {IERC20-balanceOf}.
367      */
368     function balanceOf(address account) public view override returns (uint256) {
369         return _balances[account];
370     }
371 
372     /**
373      * @dev See {IERC20-transfer}.
374      *
375      * Requirements:
376      *
377      * - `recipient` cannot be the zero address.
378      * - the caller must have a balance of at least `amount`.
379      */
380     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
381         _transfer(_msgSender(), recipient, amount);
382         return true;
383     }
384 
385     /**
386      * @dev See {IERC20-allowance}.
387      */
388     function allowance(address owner, address spender) public view virtual override returns (uint256) {
389         return _allowances[owner][spender];
390     }
391 
392     /**
393      * @dev See {IERC20-approve}.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function approve(address spender, uint256 amount) public virtual override returns (bool) {
400         _approve(_msgSender(), spender, amount);
401         return true;
402     }
403 
404     /**
405      * @dev See {IERC20-transferFrom}.
406      *
407      * Emits an {Approval} event indicating the updated allowance. This is not
408      * required by the EIP. See the note at the beginning of {ERC20}.
409      *
410      * Requirements:
411      *
412      * - `sender` and `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      * - the caller must have allowance for ``sender``'s tokens of at least
415      * `amount`.
416      */
417     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     /**
424      * @dev Atomically increases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      */
435     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
436         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
437         return true;
438     }
439 
440     /**
441      * @dev Atomically decreases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `spender` must have allowance for the caller of at least
452      * `subtractedValue`.
453      */
454     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
456         return true;
457     }
458 
459     /**
460      * @dev Moves tokens `amount` from `sender` to `recipient`.
461      *
462      * This is internal function is equivalent to {transfer}, and can be used to
463      * e.g. implement automatic token fees, slashing mechanisms, etc.
464      *
465      * Emits a {Transfer} event.
466      *
467      * Requirements:
468      *
469      * - `sender` cannot be the zero address.
470      * - `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      */
473     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
474         require(sender != address(0), "ERC20: transfer from the zero address");
475         require(recipient != address(0), "ERC20: transfer to the zero address");
476 
477         _beforeTokenTransfer(sender, recipient, amount);
478 
479         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
480         _balances[recipient] = _balances[recipient].add(amount);
481         emit Transfer(sender, recipient, amount);
482     }
483 
484     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
485      * the total supply.
486      *
487      * Emits a {Transfer} event with `from` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `to` cannot be the zero address.
492      */
493     function _mint(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: mint to the zero address");
495 
496         _beforeTokenTransfer(address(0), account, amount);
497 
498         _totalSupply = _totalSupply.add(amount);
499         _balances[account] = _balances[account].add(amount);
500         emit Transfer(address(0), account, amount);
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         _beforeTokenTransfer(account, address(0), amount);
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _totalSupply = _totalSupply.sub(amount);
521         emit Transfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
526      *
527      * This internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Sets {decimals} to a value other than the default one of 18.
547      *
548      * WARNING: This function should only be called from the constructor. Most
549      * applications that interact with token contracts will not expect
550      * {decimals} to ever change, and may work incorrectly if it does.
551      */
552     function _setupDecimals(uint8 decimals_) internal {
553         _decimals = decimals_;
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be to transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
571 }
572 
573 // File: contracts/WinnieXiPooh.sol
574 
575 pragma solidity 0.6.8;
576 
577 
578 contract WinnieXiPooh is ERC20("Winnie Xi Pooh", "XIPOOH") {
579     constructor() public {
580         _mint(msg.sender, 1444216107 ether);
581     }
582 }