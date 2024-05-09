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
27  * @dev Wrappers over Solidity's arithmetic operations with added overflow
28  * checks.
29  *
30  * Arithmetic operations in Solidity wrap on overflow. This can easily result
31  * in bugs, because programmers usually assume that an overflow raises an
32  * error, which is the standard behavior in high level programming languages.
33  * `SafeMath` restores this intuition by reverting the transaction when an
34  * operation overflows.
35  *
36  * Using this library instead of the unchecked operations eliminates an entire
37  * class of bugs, so it's recommended to use it always.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      *
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      *
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return mod(a, b, "SafeMath: modulo by zero");
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts with custom message when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b != 0, errorMessage);
178         return a % b;
179     }
180 }
181 
182 /**
183  * @dev Interface of the ERC20 standard as defined in the EIP.
184  */
185 interface IERC20 {
186     /**
187      * @dev Returns the amount of tokens in existence.
188      */
189     function totalSupply() external view returns (uint256);
190 
191     /**
192      * @dev Returns the amount of tokens owned by `account`.
193      */
194     function balanceOf(address account) external view returns (uint256);
195 
196     /**
197      * @dev Moves `amount` tokens from the caller's account to `recipient`.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transfer(address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Returns the remaining number of tokens that `spender` will be
207      * allowed to spend on behalf of `owner` through {transferFrom}. This is
208      * zero by default.
209      *
210      * This value changes when {approve} or {transferFrom} are called.
211      */
212     function allowance(address owner, address spender) external view returns (uint256);
213 
214     /**
215      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * IMPORTANT: Beware that changing an allowance with this method brings the risk
220      * that someone may use both the old and the new allowance by unfortunate
221      * transaction ordering. One possible solution to mitigate this race
222      * condition is to first reduce the spender's allowance to 0 and set the
223      * desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address spender, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Moves `amount` tokens from `sender` to `recipient` using the
232      * allowance mechanism. `amount` is then deducted from the caller's
233      * allowance.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Emitted when `value` tokens are moved from one account (`from`) to
243      * another (`to`).
244      *
245      * Note that `value` may be zero.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 
249     /**
250      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251      * a call to {approve}. `value` is the new allowance.
252      */
253     event Approval(address indexed owner, address indexed spender, uint256 value);
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
280 contract ERC20 is Context, IERC20 {
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
302     constructor (string memory name_, string memory symbol_) public {
303         _name = name_;
304         _symbol = symbol_;
305         _decimals = 18;
306     }
307 
308     /**
309      * @dev Returns the name of the token.
310      */
311     function name() public view returns (string memory) {
312         return _name;
313     }
314 
315     /**
316      * @dev Returns the symbol of the token, usually a shorter version of the
317      * name.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @dev Returns the number of decimals used to get its user representation.
325      * For example, if `decimals` equals `2`, a balance of `505` tokens should
326      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
327      *
328      * Tokens usually opt for a value of 18, imitating the relationship between
329      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
330      * called.
331      *
332      * NOTE: This information is only used for _display_ purposes: it in
333      * no way affects any of the arithmetic of the contract, including
334      * {IERC20-balanceOf} and {IERC20-transfer}.
335      */
336     function decimals() public view returns (uint8) {
337         return _decimals;
338     }
339 
340     /**
341      * @dev See {IERC20-totalSupply}.
342      */
343     function totalSupply() public view override returns (uint256) {
344         return _totalSupply;
345     }
346 
347     /**
348      * @dev See {IERC20-balanceOf}.
349      */
350     function balanceOf(address account) public view override returns (uint256) {
351         return _balances[account];
352     }
353 
354     /**
355      * @dev See {IERC20-transfer}.
356      *
357      * Requirements:
358      *
359      * - `recipient` cannot be the zero address.
360      * - the caller must have a balance of at least `amount`.
361      */
362     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
363         _transfer(_msgSender(), recipient, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender) public view virtual override returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function approve(address spender, uint256 amount) public virtual override returns (bool) {
382         _approve(_msgSender(), spender, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-transferFrom}.
388      *
389      * Emits an {Approval} event indicating the updated allowance. This is not
390      * required by the EIP. See the note at the beginning of {ERC20}.
391      *
392      * Requirements:
393      *
394      * - `sender` and `recipient` cannot be the zero address.
395      * - `sender` must have a balance of at least `amount`.
396      * - the caller must have allowance for ``sender``'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
400         _transfer(sender, recipient, amount);
401         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
438         return true;
439     }
440 
441     /**
442      * @dev Moves tokens `amount` from `sender` to `recipient`.
443      *
444      * This is internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
456         require(sender != address(0), "ERC20: transfer from the zero address");
457         require(recipient != address(0), "ERC20: transfer to the zero address");
458 
459         _beforeTokenTransfer(sender, recipient, amount);
460 
461         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
462         _balances[recipient] = _balances[recipient].add(amount);
463         emit Transfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `to` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply = _totalSupply.add(amount);
481         _balances[account] = _balances[account].add(amount);
482         emit Transfer(address(0), account, amount);
483     }
484 
485     /**
486      * @dev Destroys `amount` tokens from `account`, reducing the
487      * total supply.
488      *
489      * Emits a {Transfer} event with `to` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      * - `account` must have at least `amount` tokens.
495      */
496     function _burn(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: burn from the zero address");
498 
499         _beforeTokenTransfer(account, address(0), amount);
500 
501         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
502         _totalSupply = _totalSupply.sub(amount);
503         emit Transfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(address owner, address spender, uint256 amount) internal virtual {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     /**
528      * @dev Sets {decimals} to a value other than the default one of 18.
529      *
530      * WARNING: This function should only be called from the constructor. Most
531      * applications that interact with token contracts will not expect
532      * {decimals} to ever change, and may work incorrectly if it does.
533      */
534     function _setupDecimals(uint8 decimals_) internal {
535         _decimals = decimals_;
536     }
537 
538     /**
539      * @dev Hook that is called before any transfer of tokens. This includes
540      * minting and burning.
541      *
542      * Calling conditions:
543      *
544      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
545      * will be to transferred to `to`.
546      * - when `from` is zero, `amount` tokens will be minted for `to`.
547      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
548      * - `from` and `to` are never both zero.
549      *
550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
551      */
552     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
553 }
554 
555 contract HTG is ERC20 {
556     address public owner;
557     
558     modifier onlyOwner() {
559         require(msg.sender == owner);
560         _;
561     }
562     
563     constructor () public ERC20("Hedge Tech Governance", "HTG") {
564         owner = msg.sender;
565         _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
566     }
567     
568 }