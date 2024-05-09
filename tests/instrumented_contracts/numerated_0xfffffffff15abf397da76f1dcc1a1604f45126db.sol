1 pragma solidity ^0.6.0;
2 
3 //  ______    _                 _____                     
4 //  |  ___|  | |               /  ___|                    
5 //  | |_ __ _| | ___ ___  _ __ \ `--.__      ____ _ _ __  
6 //  |  _/ _` | |/ __/ _ \| '_ \ `--. \ \ /\ / / _` | '_ \ 
7 //  | || (_| | | (_| (_) | | | /\__/ /\ V  V / (_| | |_) |
8 //  \_| \__,_|_|\___\___/|_| |_\____/  \_/\_/ \__,_| .__/ 
9 //                                                 | |    
10 //  FalconSwap: https://falconswap.com
11 //  Symbol: FSW
12 //  Decimals: 18
13 
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 
92 
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 
251 
252 
253 /*
254  * @dev Provides information about the current execution context, including the
255  * sender of the transaction and its data. While these are generally available
256  * via msg.sender and msg.data, they should not be accessed in such a direct
257  * manner, since when dealing with GSN meta-transactions the account sending and
258  * paying for execution may not be the actual sender (as far as an application
259  * is concerned).
260  *
261  * This contract is only required for intermediate, library-like contracts.
262  */
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address payable) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 
275 
276 
277 /**
278  * @dev Implementation of the {IERC20} interface.
279  *
280  * This implementation is agnostic to the way tokens are created. This means
281  * that a supply mechanism has to be added in a derived contract using {_mint}.
282  * For a generic mechanism see {ERC20PresetMinterPauser}.
283  *
284  * TIP: For a detailed writeup see our guide
285  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
286  * to implement supply mechanisms].
287  *
288  * We have followed general OpenZeppelin guidelines: functions revert instead
289  * of returning `false` on failure. This behavior is nonetheless conventional
290  * and does not conflict with the expectations of ERC20 applications.
291  *
292  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
293  * This allows applications to reconstruct the allowance for all accounts just
294  * by listening to said events. Other implementations of the EIP may not emit
295  * these events, as it isn't required by the specification.
296  *
297  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
298  * functions have been added to mitigate the well-known issues around setting
299  * allowances. See {IERC20-approve}.
300  */
301 contract ERC20 is Context, IERC20 {
302     using SafeMath for uint256;
303 
304     mapping (address => uint256) private _balances;
305 
306     mapping (address => mapping (address => uint256)) private _allowances;
307 
308     uint256 private _totalSupply;
309 
310     string private _name;
311     string private _symbol;
312     uint8 private _decimals;
313 
314     /**
315      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
316      * a default value of 18.
317      *
318      * To select a different value for {decimals}, use {_setupDecimals}.
319      *
320      * All three of these values are immutable: they can only be set once during
321      * construction.
322      */
323     constructor () public {
324         _name = "FalconSwap Token";
325         _symbol = "FSW";
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
410      * required by the EIP. See the note at the beginning of {ERC20};
411      *
412      * Requirements:
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
490      * Requirements
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
510      * Requirements
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
526      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
527      *
528      * This is internal function is equivalent to `approve`, and can be used to
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
574 
575 
576 contract FalconSwapToken is ERC20 {
577     constructor() public {
578         uint8 decimals_ = 18;
579         uint256 supply_ = 100000000 * 10**uint256(decimals_);
580         
581         _mint(msg.sender, supply_);
582         _setupDecimals(decimals_);
583     }
584     
585     function burn(uint256 amount) external {
586         _burn(msg.sender, amount);
587     }
588 }