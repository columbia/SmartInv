1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-24
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 
8 pragma solidity 0.6.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Implementation of the {IERC20} interface.
263  *
264  * This implementation is agnostic to the way tokens are created. This means
265  * that a supply mechanism has to be added in a derived contract using {_mint}.
266  * For a generic mechanism see {ERC20PresetMinterPauser}.
267  *
268  * TIP: For a detailed writeup see our guide
269  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
270  * to implement supply mechanisms].
271  *
272  * We have followed general OpenZeppelin guidelines: functions revert instead
273  * of returning `false` on failure. This behavior is nonetheless conventional
274  * and does not conflict with the expectations of ERC20 applications.
275  *
276  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
277  * This allows applications to reconstruct the allowance for all accounts just
278  * by listening to said events. Other implementations of the EIP may not emit
279  * these events, as it isn't required by the specification.
280  *
281  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
282  * functions have been added to mitigate the well-known issues around setting
283  * allowances. See {IERC20-approve}.
284  */
285 contract ERC20 is Context, IERC20 {
286     using SafeMath for uint256;
287 
288     mapping (address => uint256) private _balances;
289 
290     mapping (address => mapping (address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     /**
299      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
300      * a default value of 18.
301      *
302      * To select a different value for {decimals}, use {_setupDecimals}.
303      *
304      * All three of these values are immutable: they can only be set once during
305      * construction.
306      */
307     constructor (string memory name_, string memory symbol_) public {
308         _name = name_;
309         _symbol = symbol_;
310         _decimals = 18;
311     }
312 
313     /**
314      * @dev Returns the name of the token.
315      */
316     function name() public view returns (string memory) {
317         return _name;
318     }
319 
320     /**
321      * @dev Returns the symbol of the token, usually a shorter version of the
322      * name.
323      */
324     function symbol() public view returns (string memory) {
325         return _symbol;
326     }
327 
328     /**
329      * @dev Returns the number of decimals used to get its user representation.
330      * For example, if `decimals` equals `2`, a balance of `505` tokens should
331      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
332      *
333      * Tokens usually opt for a value of 18, imitating the relationship between
334      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
335      * called.
336      *
337      * NOTE: This information is only used for _display_ purposes: it in
338      * no way affects any of the arithmetic of the contract, including
339      * {IERC20-balanceOf} and {IERC20-transfer}.
340      */
341     function decimals() public view returns (uint8) {
342         return _decimals;
343     }
344 
345     /**
346      * @dev See {IERC20-totalSupply}.
347      */
348     function totalSupply() public view override returns (uint256) {
349         return _totalSupply;
350     }
351 
352     /**
353      * @dev See {IERC20-balanceOf}.
354      */
355     function balanceOf(address account) public view override returns (uint256) {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See {IERC20-transfer}.
361      *
362      * Requirements:
363      *
364      * - `recipient` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
368         _transfer(_msgSender(), recipient, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-allowance}.
374      */
375     function allowance(address owner, address spender) public view virtual override returns (uint256) {
376         return _allowances[owner][spender];
377     }
378 
379     /**
380      * @dev See {IERC20-approve}.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function approve(address spender, uint256 amount) public virtual override returns (bool) {
387         _approve(_msgSender(), spender, amount);
388         return true;
389     }
390 
391     /**
392      * @dev See {IERC20-transferFrom}.
393      *
394      * Emits an {Approval} event indicating the updated allowance. This is not
395      * required by the EIP. See the note at the beginning of {ERC20}.
396      *
397      * Requirements:
398      *
399      * - `sender` and `recipient` cannot be the zero address.
400      * - `sender` must have a balance of at least `amount`.
401      * - the caller must have allowance for ``sender``'s tokens of at least
402      * `amount`.
403      */
404     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
405         _transfer(sender, recipient, amount);
406         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
407         return true;
408     }
409 
410     /**
411      * @dev Atomically increases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      */
422     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
423         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
424         return true;
425     }
426 
427     /**
428      * @dev Atomically decreases the allowance granted to `spender` by the caller.
429      *
430      * This is an alternative to {approve} that can be used as a mitigation for
431      * problems described in {IERC20-approve}.
432      *
433      * Emits an {Approval} event indicating the updated allowance.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      * - `spender` must have allowance for the caller of at least
439      * `subtractedValue`.
440      */
441     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
443         return true;
444     }
445 
446     /**
447      * @dev Moves tokens `amount` from `sender` to `recipient`.
448      *
449      * This is internal function is equivalent to {transfer}, and can be used to
450      * e.g. implement automatic token fees, slashing mechanisms, etc.
451      *
452      * Emits a {Transfer} event.
453      *
454      * Requirements:
455      *
456      * - `sender` cannot be the zero address.
457      * - `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      */
460     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
461         require(sender != address(0), "ERC20: transfer from the zero address");
462         require(recipient != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(sender, recipient, amount);
465 
466         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
467         _balances[recipient] = _balances[recipient].add(amount);
468         emit Transfer(sender, recipient, amount);
469     }
470 
471     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
472      * the total supply.
473      *
474      * Emits a {Transfer} event with `from` set to the zero address.
475      *
476      * Requirements:
477      *
478      * - `to` cannot be the zero address.
479      */
480     function _mint(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: mint to the zero address");
482 
483         _beforeTokenTransfer(address(0), account, amount);
484 
485         _totalSupply = _totalSupply.add(amount);
486         _balances[account] = _balances[account].add(amount);
487         emit Transfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
507         _totalSupply = _totalSupply.sub(amount);
508         emit Transfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(address owner, address spender, uint256 amount) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Sets {decimals} to a value other than the default one of 18.
534      *
535      * WARNING: This function should only be called from the constructor. Most
536      * applications that interact with token contracts will not expect
537      * {decimals} to ever change, and may work incorrectly if it does.
538      */
539     function _setupDecimals(uint8 decimals_) internal {
540         _decimals = decimals_;
541     }
542 
543     /**
544      * @dev Hook that is called before any transfer of tokens. This includes
545      * minting and burning.
546      *
547      * Calling conditions:
548      *
549      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
550      * will be to transferred to `to`.
551      * - when `from` is zero, `amount` tokens will be minted for `to`.
552      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
553      * - `from` and `to` are never both zero.
554      *
555      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
556      */
557     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
558 }
559 
560 contract WAHToken is ERC20 {
561     constructor() public ERC20("FM Gallery", "FMG") {
562         _mint(msg.sender, 100000000 * 10**18);
563     }
564 }