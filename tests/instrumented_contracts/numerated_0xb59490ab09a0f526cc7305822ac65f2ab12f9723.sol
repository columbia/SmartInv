1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
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
108 
109 pragma solidity >=0.6.0 <0.8.0;
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
268 
269 
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 
273 
274 
275 /**
276  * @dev Implementation of the {IERC20} interface.
277  *
278  * This implementation is agnostic to the way tokens are created. This means
279  * that a supply mechanism has to be added in a derived contract using {_mint}.
280  * For a generic mechanism see {ERC20PresetMinterPauser}.
281  *
282  * TIP: For a detailed writeup see our guide
283  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
284  * to implement supply mechanisms].
285  *
286  * We have followed general OpenZeppelin guidelines: functions revert instead
287  * of returning `false` on failure. This behavior is nonetheless conventional
288  * and does not conflict with the expectations of ERC20 applications.
289  *
290  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
291  * This allows applications to reconstruct the allowance for all accounts just
292  * by listening to said events. Other implementations of the EIP may not emit
293  * these events, as it isn't required by the specification.
294  *
295  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
296  * functions have been added to mitigate the well-known issues around setting
297  * allowances. See {IERC20-approve}.
298  */
299 contract ERC20 is Context, IERC20 {
300     using SafeMath for uint256;
301 
302     mapping (address => uint256) private _balances;
303 
304     mapping (address => mapping (address => uint256)) private _allowances;
305 
306     uint256 private _totalSupply;
307 
308     string private _name;
309     string private _symbol;
310     uint8 private _decimals;
311 
312     /**
313      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
314      * a default value of 18.
315      *
316      * To select a different value for {decimals}, use {_setupDecimals}.
317      *
318      * All three of these values are immutable: they can only be set once during
319      * construction.
320      */
321     constructor (string memory name_, string memory symbol_) public {
322         _name = name_;
323         _symbol = symbol_;
324         _decimals = 18;
325     }
326 
327     /**
328      * @dev Returns the name of the token.
329      */
330     function name() public view returns (string memory) {
331         return _name;
332     }
333 
334     /**
335      * @dev Returns the symbol of the token, usually a shorter version of the
336      * name.
337      */
338     function symbol() public view returns (string memory) {
339         return _symbol;
340     }
341 
342     /**
343      * @dev Returns the number of decimals used to get its user representation.
344      * For example, if `decimals` equals `2`, a balance of `505` tokens should
345      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
346      *
347      * Tokens usually opt for a value of 18, imitating the relationship between
348      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
349      * called.
350      *
351      * NOTE: This information is only used for _display_ purposes: it in
352      * no way affects any of the arithmetic of the contract, including
353      * {IERC20-balanceOf} and {IERC20-transfer}.
354      */
355     function decimals() public view returns (uint8) {
356         return _decimals;
357     }
358 
359     /**
360      * @dev See {IERC20-totalSupply}.
361      */
362     function totalSupply() public view override returns (uint256) {
363         return _totalSupply;
364     }
365 
366     /**
367      * @dev See {IERC20-balanceOf}.
368      */
369     function balanceOf(address account) public view override returns (uint256) {
370         return _balances[account];
371     }
372 
373     /**
374      * @dev See {IERC20-transfer}.
375      *
376      * Requirements:
377      *
378      * - `recipient` cannot be the zero address.
379      * - the caller must have a balance of at least `amount`.
380      */
381     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-allowance}.
388      */
389     function allowance(address owner, address spender) public view virtual override returns (uint256) {
390         return _allowances[owner][spender];
391     }
392 
393     /**
394      * @dev See {IERC20-approve}.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount) public virtual override returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-transferFrom}.
407      *
408      * Emits an {Approval} event indicating the updated allowance. This is not
409      * required by the EIP. See the note at the beginning of {ERC20}.
410      *
411      * Requirements:
412      *
413      * - `sender` and `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      * - the caller must have allowance for ``sender``'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
419         _transfer(sender, recipient, amount);
420         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
438         return true;
439     }
440 
441     /**
442      * @dev Atomically decreases the allowance granted to `spender` by the caller.
443      *
444      * This is an alternative to {approve} that can be used as a mitigation for
445      * problems described in {IERC20-approve}.
446      *
447      * Emits an {Approval} event indicating the updated allowance.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      * - `spender` must have allowance for the caller of at least
453      * `subtractedValue`.
454      */
455     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
457         return true;
458     }
459 
460     /**
461      * @dev Moves tokens `amount` from `sender` to `recipient`.
462      *
463      * This is internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `sender` cannot be the zero address.
471      * - `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      */
474     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478         _beforeTokenTransfer(sender, recipient, amount);
479 
480         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
481         _balances[recipient] = _balances[recipient].add(amount);
482         emit Transfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply = _totalSupply.add(amount);
500         _balances[account] = _balances[account].add(amount);
501         emit Transfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
521         _totalSupply = _totalSupply.sub(amount);
522         emit Transfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(address owner, address spender, uint256 amount) internal virtual {
539         require(owner != address(0), "ERC20: approve from the zero address");
540         require(spender != address(0), "ERC20: approve to the zero address");
541 
542         _allowances[owner][spender] = amount;
543         emit Approval(owner, spender, amount);
544     }
545 
546     /**
547      * @dev Sets {decimals} to a value other than the default one of 18.
548      *
549      * WARNING: This function should only be called from the constructor. Most
550      * applications that interact with token contracts will not expect
551      * {decimals} to ever change, and may work incorrectly if it does.
552      */
553     function _setupDecimals(uint8 decimals_) internal {
554         _decimals = decimals_;
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be to transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
572 }
573 
574 pragma solidity ^0.6.0;
575 
576 
577 contract LITToken is ERC20 {
578     constructor() public ERC20("Litentry", "LIT") {
579         _mint(msg.sender, 100000000 * 10**18);
580     }
581 }