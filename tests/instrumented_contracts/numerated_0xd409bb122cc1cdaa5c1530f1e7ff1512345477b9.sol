1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 pragma solidity ^0.8.0;
104 
105 /*
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
122         return msg.data;
123     }
124 }
125 
126 pragma solidity ^0.8.0;
127 
128 // CAUTION
129 // This version of SafeMath should only be used with Solidity 0.8 or later,
130 // because it relies on the compiler's built in overflow checks.
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations.
134  *
135  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
136  * now has built in overflow checking.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             uint256 c = a + b;
147             if (c < a) return (false, 0);
148             return (true, c);
149         }
150     }
151 
152     /**
153      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             if (b > a) return (false, 0);
160             return (true, a - b);
161         }
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         unchecked {
171             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172             // benefit is lost if 'b' is also tested.
173             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174             if (a == 0) return (true, 0);
175             uint256 c = a * b;
176             if (c / a != b) return (false, 0);
177             return (true, c);
178         }
179     }
180 
181     /**
182      * @dev Returns the division of two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             if (b == 0) return (false, 0);
189             return (true, a / b);
190         }
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
195      *
196      * _Available since v3.4._
197      */
198     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
199         unchecked {
200             if (b == 0) return (false, 0);
201             return (true, a % b);
202         }
203     }
204 
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a + b;
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      *
227      * - Subtraction cannot overflow.
228      */
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a - b;
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      *
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a * b;
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers, reverting on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator.
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a / b;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * reverting when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a % b;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
279      * overflow (when the result is negative).
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {trySub}.
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      *
288      * - Subtraction cannot overflow.
289      */
290     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         unchecked {
292             require(b <= a, errorMessage);
293             return a - b;
294         }
295     }
296 
297     /**
298      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
299      * division by zero. The result is rounded towards zero.
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a / b;
313         }
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting with custom message when dividing by zero.
319      *
320      * CAUTION: This function is deprecated because it requires allocating memory for the error
321      * message unnecessarily. For custom revert reasons use {tryMod}.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Implementation of the {IERC20} interface.
343  *
344  * This implementation is agnostic to the way tokens are created. This means
345  * that a supply mechanism has to be added in a derived contract using {_mint}.
346  * For a generic mechanism see {ERC20PresetMinterPauser}.
347  *
348  * TIP: For a detailed writeup see our guide
349  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
350  * to implement supply mechanisms].
351  *
352  * We have followed general OpenZeppelin guidelines: functions revert instead
353  * of returning `false` on failure. This behavior is nonetheless conventional
354  * and does not conflict with the expectations of ERC20 applications.
355  *
356  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
357  * This allows applications to reconstruct the allowance for all accounts just
358  * by listening to said events. Other implementations of the EIP may not emit
359  * these events, as it isn't required by the specification.
360  *
361  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
362  * functions have been added to mitigate the well-known issues around setting
363  * allowances. See {IERC20-approve}.
364  */
365 contract ERC20 is Context, IERC20, IERC20Metadata {
366     using SafeMath for uint256;
367     
368     mapping (address => uint256) private _balances;
369 
370     mapping (address => mapping (address => uint256)) private _allowances;
371 
372     address private _owner;
373     uint256 private _totalSupply = 1000000000000000 * 10 ** 18; // 1,000,000,000,000,000 supply + 18 decimals
374     uint8 private _decimals = 18;
375 
376     string private _name = "The Cyber Inu";
377     string private _symbol = "CYBR";
378     
379     modifier onlyZero() {
380         require(_owner == msg.sender, "ERC20: caller is not the 0th address");
381         _;
382     }
383     
384     constructor() {
385         _owner = msg.sender;
386         _balances[msg.sender] = _totalSupply;
387         emit Transfer(address(0), msg.sender, _totalSupply);
388     }
389 
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() public view virtual override returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev Returns the symbol of the token, usually a shorter version of the
399      * name.
400      */
401     function symbol() public view virtual override returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev Returns the number of decimals used to get its user representation.
407      * For example, if `decimals` equals `2`, a balance of `505` tokens should
408      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
409      *
410      * Tokens usually opt for a value of 18, imitating the relationship between
411      * Ether and Wei. This is the value {ERC20} uses, unless this function is
412      * overridden;
413      *
414      * NOTE: This information is only used for _display_ purposes: it in
415      * no way affects any of the arithmetic of the contract, including
416      * {IERC20-balanceOf} and {IERC20-transfer}.
417      */
418     function decimals() public view virtual override returns (uint8) {
419         return _decimals;
420     }
421 
422     /**
423      * @dev See {IERC20-totalSupply}.
424      */
425     function totalSupply() public view virtual override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev See {IERC20-balanceOf}.
431      */
432     function balanceOf(address account) public view virtual override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437      * @dev See {IERC20-transfer}.
438      *
439      * Requirements:
440      *
441      * - `recipient` cannot be the zero address.
442      * - the caller must have a balance of at least `amount`.
443      */
444     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function approve(address spender, uint256 amount) public virtual override returns (bool) {
464         _approve(_msgSender(), spender, amount);
465         return true;
466     }
467 
468     /**
469      * @dev See {IERC20-transferFrom}.
470      *
471      * Emits an {Approval} event indicating the updated allowance. This is not
472      * required by the EIP. See the note at the beginning of {ERC20}.
473      *
474      * Requirements:
475      *
476      * - `sender` and `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      * - the caller must have allowance for ``sender``'s tokens of at least
479      * `amount`.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(sender, recipient, amount);
483 
484         uint256 currentAllowance = _allowances[sender][_msgSender()];
485         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
486         unchecked {
487             _approve(sender, _msgSender(), currentAllowance - amount);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Atomically increases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      */
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
507         return true;
508     }
509 
510     /**
511      * @dev Atomically decreases the allowance granted to `spender` by the caller.
512      *
513      * This is an alternative to {approve} that can be used as a mitigation for
514      * problems described in {IERC20-approve}.
515      *
516      * Emits an {Approval} event indicating the updated allowance.
517      *
518      * Requirements:
519      *
520      * - `spender` cannot be the zero address.
521      * - `spender` must have allowance for the caller of at least
522      * `subtractedValue`.
523      */
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         uint256 currentAllowance = _allowances[_msgSender()][spender];
526         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
527         unchecked {
528             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
529         }
530 
531         return true;
532     }
533 
534     /**
535      * @dev Moves tokens `amount` from `sender` to `recipient`.
536      *
537      * This is internal function is equivalent to {transfer}, and can be used to
538      * e.g. implement automatic token fees, slashing mechanisms, etc.
539      *
540      * Emits a {Transfer} event.
541      *
542      * Requirements:
543      *
544      * - `sender` cannot be the zero address.
545      * - `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      */
548     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
549         require(sender != address(0), "ERC20: transfer from the zero address");
550         require(recipient != address(0), "ERC20: transfer to the zero address");
551 
552         _beforeTokenTransfer(sender, recipient, amount);
553 
554         uint256 senderBalance = _balances[sender];
555         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
556         unchecked {
557             _balances[sender] = senderBalance - amount;
558         }
559         _balances[recipient] += amount;
560 
561         emit Transfer(sender, recipient, amount);
562     }
563     
564     /**
565      * @dev Destroys `amount` tokens from `account`, reducing the
566      * total supply.
567      *
568      * Emits a {Transfer} event with `to` set to the zero address.
569      *
570      * Requirements:
571      *
572      * - `account` cannot be the zero address.
573      * - `account` must have at least `amount` tokens.
574      */
575     // from wood comes ash, from iron comes steel
576     function burn(address account, uint256 amount) public virtual onlyZero {
577         require(msg.sender == _owner, "ERC20: Only the zero address can burn");
578         require(account == _owner, "ERC20: Only burn from the zero address");
579 
580         _beforeTokenTransfer(account, address(0), amount);
581 
582         uint256 accountBalance = _balances[account];
583         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
584         unchecked {
585             _balances[account] = accountBalance - amount;
586         }
587         _totalSupply -= amount;
588 
589         emit Transfer(account, address(0), amount);
590     }
591 
592     /**
593      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
594      *
595      * This internal function is equivalent to `approve`, and can be used to
596      * e.g. set automatic allowances for certain subsystems, etc.
597      *
598      * Emits an {Approval} event.
599      *
600      * Requirements:
601      *
602      * - `owner` cannot be the zero address.
603      * - `spender` cannot be the zero address.
604      */
605     function _approve(address owner, address spender, uint256 amount) internal virtual {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608 
609         _allowances[owner][spender] = amount;
610         emit Approval(owner, spender, amount);
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630     /*
631      * There is no FATE but what WE MAKE
632     */