1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 
163 /*
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with GSN meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP.
186  */
187 interface IERC20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `recipient`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through {transferFrom}. This is
210      * zero by default.
211      *
212      * This value changes when {approve} or {transferFrom} are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `sender` to `recipient` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 /**
259  * @dev Implementation of the {IERC20} interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using {_mint}.
263  * For a generic mechanism see {ERC20PresetMinterPauser}.
264  *
265  * TIP: For a detailed writeup see our guide
266  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
267  * to implement supply mechanisms].
268  *
269  * We have followed general OpenZeppelin guidelines: functions revert instead
270  * of returning `false` on failure. This behavior is nonetheless conventional
271  * and does not conflict with the expectations of ERC20 applications.
272  *
273  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
274  * This allows applications to reconstruct the allowance for all accounts just
275  * by listening to said events. Other implementations of the EIP may not emit
276  * these events, as it isn't required by the specification.
277  *
278  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
279  * functions have been added to mitigate the well-known issues around setting
280  * allowances. See {IERC20-approve}.
281  */
282 contract ERC20 is Context, IERC20 {
283     using SafeMath for uint256;
284 
285     mapping (address => uint256) private _balances;
286 
287     mapping (address => mapping (address => uint256)) private _allowances;
288 
289     uint256 private _totalSupply;
290 
291     string private _name;
292     string private _symbol;
293     uint8 private _decimals;
294 
295     /**
296      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
297      * a default value of 18.
298      *
299      * To select a different value for {decimals}, use {_setupDecimals}.
300      *
301      * All three of these values are immutable: they can only be set once during
302      * construction.
303      */
304     constructor (string memory name, string memory symbol) public {
305         _name = name;
306         _symbol = symbol;
307         _decimals = 18;
308     }
309 
310     /**
311      * @dev Returns the name of the token.
312      */
313     function name() public view returns (string memory) {
314         return _name;
315     }
316 
317     /**
318      * @dev Returns the symbol of the token, usually a shorter version of the
319      * name.
320      */
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @dev Returns the number of decimals used to get its user representation.
327      * For example, if `decimals` equals `2`, a balance of `505` tokens should
328      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
329      *
330      * Tokens usually opt for a value of 18, imitating the relationship between
331      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
332      * called.
333      *
334      * NOTE: This information is only used for _display_ purposes: it in
335      * no way affects any of the arithmetic of the contract, including
336      * {IERC20-balanceOf} and {IERC20-transfer}.
337      */
338     function decimals() public view returns (uint8) {
339         return _decimals;
340     }
341 
342     /**
343      * @dev See {IERC20-totalSupply}.
344      */
345     function totalSupply() public view override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     /**
350      * @dev See {IERC20-balanceOf}.
351      */
352     function balanceOf(address account) public view override returns (uint256) {
353         return _balances[account];
354     }
355 
356     /**
357      * @dev See {IERC20-transfer}.
358      *
359      * Requirements:
360      *
361      * - `recipient` cannot be the zero address.
362      * - the caller must have a balance of at least `amount`.
363      */
364     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
365         _transfer(_msgSender(), recipient, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-allowance}.
371      */
372     function allowance(address owner, address spender) public view virtual override returns (uint256) {
373         return _allowances[owner][spender];
374     }
375 
376     /**
377      * @dev See {IERC20-approve}.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function approve(address spender, uint256 amount) public virtual override returns (bool) {
384         _approve(_msgSender(), spender, amount);
385         return true;
386     }
387 
388     /**
389      * @dev See {IERC20-transferFrom}.
390      *
391      * Emits an {Approval} event indicating the updated allowance. This is not
392      * required by the EIP. See the note at the beginning of {ERC20}.
393      *
394      * Requirements:
395      *
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      * - the caller must have allowance for ``sender``'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
402         _transfer(sender, recipient, amount);
403         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
440         return true;
441     }
442 
443     /**
444      * @dev Moves tokens `amount` from `sender` to `recipient`.
445      *
446      * This is internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `sender` cannot be the zero address.
454      * - `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      */
457     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(sender, recipient, amount);
462 
463         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
464         _balances[recipient] = _balances[recipient].add(amount);
465         emit Transfer(sender, recipient, amount);
466     }
467 
468     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
469      * the total supply.
470      *
471      * Emits a {Transfer} event with `from` set to the zero address.
472      *
473      * Requirements:
474      *
475      * - `to` cannot be the zero address.
476      */
477     function _mint(address account, uint256 amount) internal virtual {
478         require(account != address(0), "ERC20: mint to the zero address");
479 
480         _beforeTokenTransfer(address(0), account, amount);
481 
482         _totalSupply = _totalSupply.add(amount);
483         _balances[account] = _balances[account].add(amount);
484         emit Transfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
504         _totalSupply = _totalSupply.sub(amount);
505         emit Transfer(account, address(0), amount);
506     }
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
510      *
511      * This internal function is equivalent to `approve`, and can be used to
512      * e.g. set automatic allowances for certain subsystems, etc.
513      *
514      * Emits an {Approval} event.
515      *
516      * Requirements:
517      *
518      * - `owner` cannot be the zero address.
519      * - `spender` cannot be the zero address.
520      */
521     function _approve(address owner, address spender, uint256 amount) internal virtual {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     /**
530      * @dev Sets {decimals} to a value other than the default one of 18.
531      *
532      * WARNING: This function should only be called from the constructor. Most
533      * applications that interact with token contracts will not expect
534      * {decimals} to ever change, and may work incorrectly if it does.
535      */
536     function _setupDecimals(uint8 decimals_) internal {
537         _decimals = decimals_;
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be to transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
555 }
556 contract Unifty is ERC20 {
557 
558     uint256 public constant INITIAL_SUPPLY = 5000000 * 10**18;
559     address private primary;
560   
561     constructor() public ERC20("Unifty", "NIF") {
562         _setupDecimals(18);
563         _mint(msg.sender, INITIAL_SUPPLY);
564         primary = msg.sender;
565     }
566 
567 }