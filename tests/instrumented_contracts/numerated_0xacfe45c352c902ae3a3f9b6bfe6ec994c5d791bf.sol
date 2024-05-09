1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
4 
5 //                                    ____     _____   __  __  __  __     
6 //                                   /\  _`\  /\  __`\/\ \/\ \/\ \/\ \    
7 //   ___ ___      __     __      __  \ \ \L\ \\ \ \/\ \ \ `\\ \ \ \/'/'   
8 // /' __` __`\  /'__`\ /'_ `\  /'__`\ \ \  _ <'\ \ \ \ \ \ , ` \ \ , <    
9 // /\ \/\ \/\ \/\  __//\ \L\ \/\ \L\.\_\ \ \L\ \\ \ \_\ \ \ \`\ \ \ \\`\  
10 // \ \_\ \_\ \_\ \____\ \____ \ \__/.\_\\ \____/ \ \_____\ \_\ \_\ \_\ \_\
11 //  \/_/\/_/\/_/\/____/\/___L\ \/__/\/_/ \/___/   \/_____/\/_/\/_/\/_/\/_/
12 //                       /\____/                                          
13 //                       \_/__/                                           
14 
15 
16 pragma solidity >=0.6.0 <0.8.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
40 
41 pragma solidity >=0.6.0 <0.8.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
118 
119 pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
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
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
278 
279 pragma solidity >=0.6.0 <0.8.0;
280 
281 
282 
283 
284 /**
285  * @dev Implementation of the {IERC20} interface.
286  *
287  * This implementation is agnostic to the way tokens are created. This means
288  * that a supply mechanism has to be added in a derived contract using {_mint}.
289  * For a generic mechanism see {ERC20PresetMinterPauser}.
290  *
291  * TIP: For a detailed writeup see our guide
292  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
293  * to implement supply mechanisms].
294  *
295  * We have followed general OpenZeppelin guidelines: functions revert instead
296  * of returning `false` on failure. This behavior is nonetheless conventional
297  * and does not conflict with the expectations of ERC20 applications.
298  *
299  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
300  * This allows applications to reconstruct the allowance for all accounts just
301  * by listening to said events. Other implementations of the EIP may not emit
302  * these events, as it isn't required by the specification.
303  *
304  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
305  * functions have been added to mitigate the well-known issues around setting
306  * allowances. See {IERC20-approve}.
307  */
308 contract ERC20 is Context, IERC20 {
309     using SafeMath for uint256;
310 
311     mapping (address => uint256) private _balances;
312 
313     mapping (address => mapping (address => uint256)) private _allowances;
314 
315     uint256 private _totalSupply;
316 
317     string private _name;
318     string private _symbol;
319     uint8 private _decimals;
320 
321     /**
322      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
323      * a default value of 18.
324      *
325      * To select a different value for {decimals}, use {_setupDecimals}.
326      *
327      * All three of these values are immutable: they can only be set once during
328      * construction.
329      */
330     constructor (string memory name_, string memory symbol_) public {
331         _name = name_;
332         _symbol = symbol_;
333         _decimals = 18;
334     }
335 
336     /**
337      * @dev Returns the name of the token.
338      */
339     function name() public view returns (string memory) {
340         return _name;
341     }
342 
343     /**
344      * @dev Returns the symbol of the token, usually a shorter version of the
345      * name.
346      */
347     function symbol() public view returns (string memory) {
348         return _symbol;
349     }
350 
351     /**
352      * @dev Returns the number of decimals used to get its user representation.
353      * For example, if `decimals` equals `2`, a balance of `505` tokens should
354      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
355      *
356      * Tokens usually opt for a value of 18, imitating the relationship between
357      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
358      * called.
359      *
360      * NOTE: This information is only used for _display_ purposes: it in
361      * no way affects any of the arithmetic of the contract, including
362      * {IERC20-balanceOf} and {IERC20-transfer}.
363      */
364     function decimals() public view returns (uint8) {
365         return _decimals;
366     }
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view override returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view override returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
391         _transfer(_msgSender(), recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-allowance}.
397      */
398     function allowance(address owner, address spender) public view virtual override returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount) public virtual override returns (bool) {
410         _approve(_msgSender(), spender, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-transferFrom}.
416      *
417      * Emits an {Approval} event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of {ERC20}.
419      *
420      * Requirements:
421      *
422      * - `sender` and `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      * - the caller must have allowance for ``sender``'s tokens of at least
425      * `amount`.
426      */
427     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(sender, recipient, amount);
429         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
446         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically decreases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      * - `spender` must have allowance for the caller of at least
462      * `subtractedValue`.
463      */
464     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
466         return true;
467     }
468 
469     /**
470      * @dev Moves tokens `amount` from `sender` to `recipient`.
471      *
472      * This is internal function is equivalent to {transfer}, and can be used to
473      * e.g. implement automatic token fees, slashing mechanisms, etc.
474      *
475      * Emits a {Transfer} event.
476      *
477      * Requirements:
478      *
479      * - `sender` cannot be the zero address.
480      * - `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      */
483     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485         require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487         _beforeTokenTransfer(sender, recipient, amount);
488 
489         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
490         _balances[recipient] = _balances[recipient].add(amount);
491         emit Transfer(sender, recipient, amount);
492     }
493 
494     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
495      * the total supply.
496      *
497      * Emits a {Transfer} event with `from` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `to` cannot be the zero address.
502      */
503     function _mint(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: mint to the zero address");
505 
506         _beforeTokenTransfer(address(0), account, amount);
507 
508         _totalSupply = _totalSupply.add(amount);
509         _balances[account] = _balances[account].add(amount);
510         emit Transfer(address(0), account, amount);
511     }
512 
513     /**
514      * @dev Destroys `amount` tokens from `account`, reducing the
515      * total supply.
516      *
517      * Emits a {Transfer} event with `to` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `account` cannot be the zero address.
522      * - `account` must have at least `amount` tokens.
523      */
524     function _burn(address account, uint256 amount) internal virtual {
525         require(account != address(0), "ERC20: burn from the zero address");
526 
527         _beforeTokenTransfer(account, address(0), amount);
528 
529         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
530         _totalSupply = _totalSupply.sub(amount);
531         emit Transfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(address owner, address spender, uint256 amount) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Sets {decimals} to a value other than the default one of 18.
557      *
558      * WARNING: This function should only be called from the constructor. Most
559      * applications that interact with token contracts will not expect
560      * {decimals} to ever change, and may work incorrectly if it does.
561      */
562     function _setupDecimals(uint8 decimals_) internal {
563         _decimals = decimals_;
564     }
565 
566     /**
567      * @dev Hook that is called before any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * will be to transferred to `to`.
574      * - when `from` is zero, `amount` tokens will be minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
581 }
582 
583 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
584 
585 pragma solidity >=0.6.0 <0.8.0;
586 
587 
588 
589 /**
590  * @dev Extension of {ERC20} that allows token holders to destroy both their own
591  * tokens and those that they have an allowance for, in a way that can be
592  * recognized off-chain (via event analysis).
593  */
594 abstract contract ERC20Burnable is Context, ERC20 {
595     using SafeMath for uint256;
596 
597     /**
598      * @dev Destroys `amount` tokens from the caller.
599      *
600      * See {ERC20-_burn}.
601      */
602     function burn(uint256 amount) public virtual {
603         _burn(_msgSender(), amount);
604     }
605 
606     /**
607      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
608      * allowance.
609      *
610      * See {ERC20-_burn} and {ERC20-allowance}.
611      *
612      * Requirements:
613      *
614      * - the caller must have allowance for ``accounts``'s tokens of at least
615      * `amount`.
616      */
617     function burnFrom(address account, uint256 amount) public virtual {
618         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
619 
620         _approve(account, _msgSender(), decreasedAllowance);
621         _burn(account, amount);
622     }
623 }
624 
625 // File: node_modules\@openzeppelin\contracts\math\Math.sol
626 
627 pragma solidity >=0.6.0 <0.8.0;
628 
629 /**
630  * @dev Standard math utilities missing in the Solidity language.
631  */
632 library Math {
633     /**
634      * @dev Returns the largest of two numbers.
635      */
636     function max(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a >= b ? a : b;
638     }
639 
640     /**
641      * @dev Returns the smallest of two numbers.
642      */
643     function min(uint256 a, uint256 b) internal pure returns (uint256) {
644         return a < b ? a : b;
645     }
646 
647     /**
648      * @dev Returns the average of two numbers. The result is rounded towards
649      * zero.
650      */
651     function average(uint256 a, uint256 b) internal pure returns (uint256) {
652         // (a + b) / 2 can overflow, so we distribute
653         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
654     }
655 }
656 
657 // File: node_modules\@openzeppelin\contracts\utils\Arrays.sol
658 
659 pragma solidity >=0.6.0 <0.8.0;
660 
661 
662 /**
663  * @dev Collection of functions related to array types.
664  */
665 library Arrays {
666     /**
667       * @dev Searches a sorted `array` and returns the first index that contains
668       * a value greater or equal to `element`. If no such index exists (i.e. all
669       * values in the array are strictly less than `element`), the array length is
670       * returned. Time complexity O(log n).
671       *
672       * `array` is expected to be sorted in ascending order, and to contain no
673       * repeated elements.
674       */
675     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
676         if (array.length == 0) {
677             return 0;
678         }
679 
680         uint256 low = 0;
681         uint256 high = array.length;
682 
683         while (low < high) {
684             uint256 mid = Math.average(low, high);
685 
686             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
687             // because Math.average rounds down (it does integer division with truncation).
688             if (array[mid] > element) {
689                 high = mid;
690             } else {
691                 low = mid + 1;
692             }
693         }
694 
695         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
696         if (low > 0 && array[low - 1] == element) {
697             return low - 1;
698         } else {
699             return low;
700         }
701     }
702 }
703 
704 // File: node_modules\@openzeppelin\contracts\utils\Counters.sol
705 
706 pragma solidity >=0.6.0 <0.8.0;
707 
708 
709 /**
710  * @title Counters
711  * @author Matt Condon (@shrugs)
712  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
713  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
714  *
715  * Include with `using Counters for Counters.Counter;`
716  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
717  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
718  * directly accessed.
719  */
720 library Counters {
721     using SafeMath for uint256;
722 
723     struct Counter {
724         // This variable should never be directly accessed by users of the library: interactions must be restricted to
725         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
726         // this feature: see https://github.com/ethereum/solidity/issues/4637
727         uint256 _value; // default: 0
728     }
729 
730     function current(Counter storage counter) internal view returns (uint256) {
731         return counter._value;
732     }
733 
734     function increment(Counter storage counter) internal {
735         // The {SafeMath} overflow check can be skipped here, see the comment at the top
736         counter._value += 1;
737     }
738 
739     function decrement(Counter storage counter) internal {
740         counter._value = counter._value.sub(1);
741     }
742 }
743 
744 // File: @openzeppelin\contracts\token\ERC20\ERC20Snapshot.sol
745 
746 pragma solidity >=0.6.0 <0.8.0;
747 
748 
749 
750 
751 
752 /**
753  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
754  * total supply at the time are recorded for later access.
755  *
756  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
757  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
758  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
759  * used to create an efficient ERC20 forking mechanism.
760  *
761  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
762  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
763  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
764  * and the account address.
765  *
766  * ==== Gas Costs
767  *
768  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
769  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
770  * smaller since identical balances in subsequent snapshots are stored as a single entry.
771  *
772  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
773  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
774  * transfers will have normal cost until the next snapshot, and so on.
775  */
776 abstract contract ERC20Snapshot is ERC20 {
777     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
778     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
779 
780     using SafeMath for uint256;
781     using Arrays for uint256[];
782     using Counters for Counters.Counter;
783 
784     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
785     // Snapshot struct, but that would impede usage of functions that work on an array.
786     struct Snapshots {
787         uint256[] ids;
788         uint256[] values;
789     }
790 
791     mapping (address => Snapshots) private _accountBalanceSnapshots;
792     Snapshots private _totalSupplySnapshots;
793 
794     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
795     Counters.Counter private _currentSnapshotId;
796 
797     /**
798      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
799      */
800     event Snapshot(uint256 id);
801 
802     /**
803      * @dev Creates a new snapshot and returns its snapshot id.
804      *
805      * Emits a {Snapshot} event that contains the same id.
806      *
807      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
808      * set of accounts, for example using {AccessControl}, or it may be open to the public.
809      *
810      * [WARNING]
811      * ====
812      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
813      * you must consider that it can potentially be used by attackers in two ways.
814      *
815      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
816      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
817      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
818      * section above.
819      *
820      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
821      * ====
822      */
823     function _snapshot() internal virtual returns (uint256) {
824         _currentSnapshotId.increment();
825 
826         uint256 currentId = _currentSnapshotId.current();
827         emit Snapshot(currentId);
828         return currentId;
829     }
830 
831     /**
832      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
833      */
834     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
835         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
836 
837         return snapshotted ? value : balanceOf(account);
838     }
839 
840     /**
841      * @dev Retrieves the total supply at the time `snapshotId` was created.
842      */
843     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
844         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
845 
846         return snapshotted ? value : totalSupply();
847     }
848 
849 
850     // Update balance and/or total supply snapshots before the values are modified. This is implemented
851     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
852     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
853         super._beforeTokenTransfer(from, to, amount);
854 
855         if (from == address(0)) {
856             // mint
857             _updateAccountSnapshot(to);
858             _updateTotalSupplySnapshot();
859         } else if (to == address(0)) {
860             // burn
861             _updateAccountSnapshot(from);
862             _updateTotalSupplySnapshot();
863         } else {
864             // transfer
865             _updateAccountSnapshot(from);
866             _updateAccountSnapshot(to);
867         }
868     }
869 
870     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
871     private view returns (bool, uint256)
872     {
873         require(snapshotId > 0, "ERC20Snapshot: id is 0");
874         // solhint-disable-next-line max-line-length
875         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
876 
877         // When a valid snapshot is queried, there are three possibilities:
878         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
879         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
880         //  to this id is the current one.
881         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
882         //  requested id, and its value is the one to return.
883         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
884         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
885         //  larger than the requested one.
886         //
887         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
888         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
889         // exactly this.
890 
891         uint256 index = snapshots.ids.findUpperBound(snapshotId);
892 
893         if (index == snapshots.ids.length) {
894             return (false, 0);
895         } else {
896             return (true, snapshots.values[index]);
897         }
898     }
899 
900     function _updateAccountSnapshot(address account) private {
901         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
902     }
903 
904     function _updateTotalSupplySnapshot() private {
905         _updateSnapshot(_totalSupplySnapshots, totalSupply());
906     }
907 
908     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
909         uint256 currentId = _currentSnapshotId.current();
910         if (_lastSnapshotId(snapshots.ids) < currentId) {
911             snapshots.ids.push(currentId);
912             snapshots.values.push(currentValue);
913         }
914     }
915 
916     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
917         if (ids.length == 0) {
918             return 0;
919         } else {
920             return ids[ids.length - 1];
921         }
922     }
923 }
924 
925 // File: @openzeppelin\contracts\access\Ownable.sol
926 
927 pragma solidity >=0.6.0 <0.8.0;
928 
929 /**
930  * @dev Contract module which provides a basic access control mechanism, where
931  * there is an account (an owner) that can be granted exclusive access to
932  * specific functions.
933  *
934  * By default, the owner account will be the one that deploys the contract. This
935  * can later be changed with {transferOwnership}.
936  *
937  * This module is used through inheritance. It will make available the modifier
938  * `onlyOwner`, which can be applied to your functions to restrict their use to
939  * the owner.
940  */
941 abstract contract Ownable is Context {
942     address private _owner;
943 
944     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
945 
946     /**
947      * @dev Initializes the contract setting the deployer as the initial owner.
948      */
949     constructor () internal {
950         address msgSender = _msgSender();
951         _owner = msgSender;
952         emit OwnershipTransferred(address(0), msgSender);
953     }
954 
955     /**
956      * @dev Returns the address of the current owner.
957      */
958     function owner() public view returns (address) {
959         return _owner;
960     }
961 
962     /**
963      * @dev Throws if called by any account other than the owner.
964      */
965     modifier onlyOwner() {
966         require(_owner == _msgSender(), "Ownable: caller is not the owner");
967         _;
968     }
969 
970     /**
971      * @dev Leaves the contract without owner. It will not be possible to call
972      * `onlyOwner` functions anymore. Can only be called by the current owner.
973      *
974      * NOTE: Renouncing ownership will leave the contract without an owner,
975      * thereby removing any functionality that is only available to the owner.
976      */
977     function renounceOwnership() public virtual onlyOwner {
978         emit OwnershipTransferred(_owner, address(0));
979         _owner = address(0);
980     }
981 
982     /**
983      * @dev Transfers ownership of the contract to a new account (`newOwner`).
984      * Can only be called by the current owner.
985      */
986     function transferOwnership(address newOwner) public virtual onlyOwner {
987         require(newOwner != address(0), "Ownable: new owner is the zero address");
988         emit OwnershipTransferred(_owner, newOwner);
989         _owner = newOwner;
990     }
991 }
992 
993 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
994 
995 pragma solidity >=0.6.0 <0.8.0;
996 
997 /**
998  * @dev Library for managing
999  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1000  * types.
1001  *
1002  * Sets have the following properties:
1003  *
1004  * - Elements are added, removed, and checked for existence in constant time
1005  * (O(1)).
1006  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1007  *
1008  * ```
1009  * contract Example {
1010  *     // Add the library methods
1011  *     using EnumerableSet for EnumerableSet.AddressSet;
1012  *
1013  *     // Declare a set state variable
1014  *     EnumerableSet.AddressSet private mySet;
1015  * }
1016  * ```
1017  *
1018  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1019  * and `uint256` (`UintSet`) are supported.
1020  */
1021 library EnumerableSet {
1022     // To implement this library for multiple types with as little code
1023     // repetition as possible, we write it in terms of a generic Set type with
1024     // bytes32 values.
1025     // The Set implementation uses private functions, and user-facing
1026     // implementations (such as AddressSet) are just wrappers around the
1027     // underlying Set.
1028     // This means that we can only create new EnumerableSets for types that fit
1029     // in bytes32.
1030 
1031     struct Set {
1032         // Storage of set values
1033         bytes32[] _values;
1034 
1035         // Position of the value in the `values` array, plus 1 because index 0
1036         // means a value is not in the set.
1037         mapping (bytes32 => uint256) _indexes;
1038     }
1039 
1040     /**
1041      * @dev Add a value to a set. O(1).
1042      *
1043      * Returns true if the value was added to the set, that is if it was not
1044      * already present.
1045      */
1046     function _add(Set storage set, bytes32 value) private returns (bool) {
1047         if (!_contains(set, value)) {
1048             set._values.push(value);
1049             // The value is stored at length-1, but we add 1 to all indexes
1050             // and use 0 as a sentinel value
1051             set._indexes[value] = set._values.length;
1052             return true;
1053         } else {
1054             return false;
1055         }
1056     }
1057 
1058     /**
1059      * @dev Removes a value from a set. O(1).
1060      *
1061      * Returns true if the value was removed from the set, that is if it was
1062      * present.
1063      */
1064     function _remove(Set storage set, bytes32 value) private returns (bool) {
1065         // We read and store the value's index to prevent multiple reads from the same storage slot
1066         uint256 valueIndex = set._indexes[value];
1067 
1068         if (valueIndex != 0) { // Equivalent to contains(set, value)
1069             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1070             // the array, and then remove the last element (sometimes called as 'swap and pop').
1071             // This modifies the order of the array, as noted in {at}.
1072 
1073             uint256 toDeleteIndex = valueIndex - 1;
1074             uint256 lastIndex = set._values.length - 1;
1075 
1076             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1077             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1078 
1079             bytes32 lastvalue = set._values[lastIndex];
1080 
1081             // Move the last value to the index where the value to delete is
1082             set._values[toDeleteIndex] = lastvalue;
1083             // Update the index for the moved value
1084             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1085 
1086             // Delete the slot where the moved value was stored
1087             set._values.pop();
1088 
1089             // Delete the index for the deleted slot
1090             delete set._indexes[value];
1091 
1092             return true;
1093         } else {
1094             return false;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Returns true if the value is in the set. O(1).
1100      */
1101     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1102         return set._indexes[value] != 0;
1103     }
1104 
1105     /**
1106      * @dev Returns the number of values on the set. O(1).
1107      */
1108     function _length(Set storage set) private view returns (uint256) {
1109         return set._values.length;
1110     }
1111 
1112     /**
1113      * @dev Returns the value stored at position `index` in the set. O(1).
1114      *
1115      * Note that there are no guarantees on the ordering of values inside the
1116      * array, and it may change when more values are added or removed.
1117      *
1118      * Requirements:
1119      *
1120      * - `index` must be strictly less than {length}.
1121      */
1122     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1123         require(set._values.length > index, "EnumerableSet: index out of bounds");
1124         return set._values[index];
1125     }
1126 
1127     // Bytes32Set
1128 
1129     struct Bytes32Set {
1130         Set _inner;
1131     }
1132 
1133     /**
1134      * @dev Add a value to a set. O(1).
1135      *
1136      * Returns true if the value was added to the set, that is if it was not
1137      * already present.
1138      */
1139     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1140         return _add(set._inner, value);
1141     }
1142 
1143     /**
1144      * @dev Removes a value from a set. O(1).
1145      *
1146      * Returns true if the value was removed from the set, that is if it was
1147      * present.
1148      */
1149     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1150         return _remove(set._inner, value);
1151     }
1152 
1153     /**
1154      * @dev Returns true if the value is in the set. O(1).
1155      */
1156     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1157         return _contains(set._inner, value);
1158     }
1159 
1160     /**
1161      * @dev Returns the number of values in the set. O(1).
1162      */
1163     function length(Bytes32Set storage set) internal view returns (uint256) {
1164         return _length(set._inner);
1165     }
1166 
1167     /**
1168      * @dev Returns the value stored at position `index` in the set. O(1).
1169      *
1170      * Note that there are no guarantees on the ordering of values inside the
1171      * array, and it may change when more values are added or removed.
1172      *
1173      * Requirements:
1174      *
1175      * - `index` must be strictly less than {length}.
1176      */
1177     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1178         return _at(set._inner, index);
1179     }
1180 
1181     // AddressSet
1182 
1183     struct AddressSet {
1184         Set _inner;
1185     }
1186 
1187     /**
1188      * @dev Add a value to a set. O(1).
1189      *
1190      * Returns true if the value was added to the set, that is if it was not
1191      * already present.
1192      */
1193     function add(AddressSet storage set, address value) internal returns (bool) {
1194         return _add(set._inner, bytes32(uint256(value)));
1195     }
1196 
1197     /**
1198      * @dev Removes a value from a set. O(1).
1199      *
1200      * Returns true if the value was removed from the set, that is if it was
1201      * present.
1202      */
1203     function remove(AddressSet storage set, address value) internal returns (bool) {
1204         return _remove(set._inner, bytes32(uint256(value)));
1205     }
1206 
1207     /**
1208      * @dev Returns true if the value is in the set. O(1).
1209      */
1210     function contains(AddressSet storage set, address value) internal view returns (bool) {
1211         return _contains(set._inner, bytes32(uint256(value)));
1212     }
1213 
1214     /**
1215      * @dev Returns the number of values in the set. O(1).
1216      */
1217     function length(AddressSet storage set) internal view returns (uint256) {
1218         return _length(set._inner);
1219     }
1220 
1221     /**
1222      * @dev Returns the value stored at position `index` in the set. O(1).
1223      *
1224      * Note that there are no guarantees on the ordering of values inside the
1225      * array, and it may change when more values are added or removed.
1226      *
1227      * Requirements:
1228      *
1229      * - `index` must be strictly less than {length}.
1230      */
1231     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1232         return address(uint256(_at(set._inner, index)));
1233     }
1234 
1235 
1236     // UintSet
1237 
1238     struct UintSet {
1239         Set _inner;
1240     }
1241 
1242     /**
1243      * @dev Add a value to a set. O(1).
1244      *
1245      * Returns true if the value was added to the set, that is if it was not
1246      * already present.
1247      */
1248     function add(UintSet storage set, uint256 value) internal returns (bool) {
1249         return _add(set._inner, bytes32(value));
1250     }
1251 
1252     /**
1253      * @dev Removes a value from a set. O(1).
1254      *
1255      * Returns true if the value was removed from the set, that is if it was
1256      * present.
1257      */
1258     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1259         return _remove(set._inner, bytes32(value));
1260     }
1261 
1262     /**
1263      * @dev Returns true if the value is in the set. O(1).
1264      */
1265     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1266         return _contains(set._inner, bytes32(value));
1267     }
1268 
1269     /**
1270      * @dev Returns the number of values on the set. O(1).
1271      */
1272     function length(UintSet storage set) internal view returns (uint256) {
1273         return _length(set._inner);
1274     }
1275 
1276     /**
1277      * @dev Returns the value stored at position `index` in the set. O(1).
1278      *
1279      * Note that there are no guarantees on the ordering of values inside the
1280      * array, and it may change when more values are added or removed.
1281      *
1282      * Requirements:
1283      *
1284      * - `index` must be strictly less than {length}.
1285      */
1286     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1287         return uint256(_at(set._inner, index));
1288     }
1289 }
1290 
1291 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
1292 
1293 pragma solidity >=0.6.2 <0.8.0;
1294 
1295 /**
1296  * @dev Collection of functions related to the address type
1297  */
1298 library Address {
1299     /**
1300      * @dev Returns true if `account` is a contract.
1301      *
1302      * [IMPORTANT]
1303      * ====
1304      * It is unsafe to assume that an address for which this function returns
1305      * false is an externally-owned account (EOA) and not a contract.
1306      *
1307      * Among others, `isContract` will return false for the following
1308      * types of addresses:
1309      *
1310      *  - an externally-owned account
1311      *  - a contract in construction
1312      *  - an address where a contract will be created
1313      *  - an address where a contract lived, but was destroyed
1314      * ====
1315      */
1316     function isContract(address account) internal view returns (bool) {
1317         // This method relies on extcodesize, which returns 0 for contracts in
1318         // construction, since the code is only stored at the end of the
1319         // constructor execution.
1320 
1321         uint256 size;
1322         // solhint-disable-next-line no-inline-assembly
1323         assembly { size := extcodesize(account) }
1324         return size > 0;
1325     }
1326 
1327     /**
1328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1329      * `recipient`, forwarding all available gas and reverting on errors.
1330      *
1331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1333      * imposed by `transfer`, making them unable to receive funds via
1334      * `transfer`. {sendValue} removes this limitation.
1335      *
1336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1337      *
1338      * IMPORTANT: because control is transferred to `recipient`, care must be
1339      * taken to not create reentrancy vulnerabilities. Consider using
1340      * {ReentrancyGuard} or the
1341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1342      */
1343     function sendValue(address payable recipient, uint256 amount) internal {
1344         require(address(this).balance >= amount, "Address: insufficient balance");
1345 
1346         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1347         (bool success, ) = recipient.call{ value: amount }("");
1348         require(success, "Address: unable to send value, recipient may have reverted");
1349     }
1350 
1351     /**
1352      * @dev Performs a Solidity function call using a low level `call`. A
1353      * plain`call` is an unsafe replacement for a function call: use this
1354      * function instead.
1355      *
1356      * If `target` reverts with a revert reason, it is bubbled up by this
1357      * function (like regular Solidity function calls).
1358      *
1359      * Returns the raw returned data. To convert to the expected return value,
1360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1361      *
1362      * Requirements:
1363      *
1364      * - `target` must be a contract.
1365      * - calling `target` with `data` must not revert.
1366      *
1367      * _Available since v3.1._
1368      */
1369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1370         return functionCall(target, data, "Address: low-level call failed");
1371     }
1372 
1373     /**
1374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1375      * `errorMessage` as a fallback revert reason when `target` reverts.
1376      *
1377      * _Available since v3.1._
1378      */
1379     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1380         return functionCallWithValue(target, data, 0, errorMessage);
1381     }
1382 
1383     /**
1384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1385      * but also transferring `value` wei to `target`.
1386      *
1387      * Requirements:
1388      *
1389      * - the calling contract must have an ETH balance of at least `value`.
1390      * - the called Solidity function must be `payable`.
1391      *
1392      * _Available since v3.1._
1393      */
1394     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1396     }
1397 
1398     /**
1399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1400      * with `errorMessage` as a fallback revert reason when `target` reverts.
1401      *
1402      * _Available since v3.1._
1403      */
1404     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1405         require(address(this).balance >= value, "Address: insufficient balance for call");
1406         require(isContract(target), "Address: call to non-contract");
1407 
1408         // solhint-disable-next-line avoid-low-level-calls
1409         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1410         return _verifyCallResult(success, returndata, errorMessage);
1411     }
1412 
1413     /**
1414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1415      * but performing a static call.
1416      *
1417      * _Available since v3.3._
1418      */
1419     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1420         return functionStaticCall(target, data, "Address: low-level static call failed");
1421     }
1422 
1423     /**
1424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1425      * but performing a static call.
1426      *
1427      * _Available since v3.3._
1428      */
1429     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1430         require(isContract(target), "Address: static call to non-contract");
1431 
1432         // solhint-disable-next-line avoid-low-level-calls
1433         (bool success, bytes memory returndata) = target.staticcall(data);
1434         return _verifyCallResult(success, returndata, errorMessage);
1435     }
1436 
1437     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1438         if (success) {
1439             return returndata;
1440         } else {
1441             // Look for revert reason and bubble it up if present
1442             if (returndata.length > 0) {
1443                 // The easiest way to bubble the revert reason is using memory via assembly
1444 
1445                 // solhint-disable-next-line no-inline-assembly
1446                 assembly {
1447                     let returndata_size := mload(returndata)
1448                     revert(add(32, returndata), returndata_size)
1449                 }
1450             } else {
1451                 revert(errorMessage);
1452             }
1453         }
1454     }
1455 }
1456 
1457 // File: @openzeppelin\contracts\access\AccessControl.sol
1458 
1459 pragma solidity >=0.6.0 <0.8.0;
1460 
1461 
1462 
1463 
1464 /**
1465  * @dev Contract module that allows children to implement role-based access
1466  * control mechanisms.
1467  *
1468  * Roles are referred to by their `bytes32` identifier. These should be exposed
1469  * in the external API and be unique. The best way to achieve this is by
1470  * using `public constant` hash digests:
1471  *
1472  * ```
1473  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1474  * ```
1475  *
1476  * Roles can be used to represent a set of permissions. To restrict access to a
1477  * function call, use {hasRole}:
1478  *
1479  * ```
1480  * function foo() public {
1481  *     require(hasRole(MY_ROLE, msg.sender));
1482  *     ...
1483  * }
1484  * ```
1485  *
1486  * Roles can be granted and revoked dynamically via the {grantRole} and
1487  * {revokeRole} functions. Each role has an associated admin role, and only
1488  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1489  *
1490  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1491  * that only accounts with this role will be able to grant or revoke other
1492  * roles. More complex role relationships can be created by using
1493  * {_setRoleAdmin}.
1494  *
1495  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1496  * grant and revoke this role. Extra precautions should be taken to secure
1497  * accounts that have been granted it.
1498  */
1499 abstract contract AccessControl is Context {
1500     using EnumerableSet for EnumerableSet.AddressSet;
1501     using Address for address;
1502 
1503     struct RoleData {
1504         EnumerableSet.AddressSet members;
1505         bytes32 adminRole;
1506     }
1507 
1508     mapping (bytes32 => RoleData) private _roles;
1509 
1510     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1511 
1512     /**
1513      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1514      *
1515      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1516      * {RoleAdminChanged} not being emitted signaling this.
1517      *
1518      * _Available since v3.1._
1519      */
1520     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1521 
1522     /**
1523      * @dev Emitted when `account` is granted `role`.
1524      *
1525      * `sender` is the account that originated the contract call, an admin role
1526      * bearer except when using {_setupRole}.
1527      */
1528     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1529 
1530     /**
1531      * @dev Emitted when `account` is revoked `role`.
1532      *
1533      * `sender` is the account that originated the contract call:
1534      *   - if using `revokeRole`, it is the admin role bearer
1535      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1536      */
1537     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1538 
1539     /**
1540      * @dev Returns `true` if `account` has been granted `role`.
1541      */
1542     function hasRole(bytes32 role, address account) public view returns (bool) {
1543         return _roles[role].members.contains(account);
1544     }
1545 
1546     /**
1547      * @dev Returns the number of accounts that have `role`. Can be used
1548      * together with {getRoleMember} to enumerate all bearers of a role.
1549      */
1550     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1551         return _roles[role].members.length();
1552     }
1553 
1554     /**
1555      * @dev Returns one of the accounts that have `role`. `index` must be a
1556      * value between 0 and {getRoleMemberCount}, non-inclusive.
1557      *
1558      * Role bearers are not sorted in any particular way, and their ordering may
1559      * change at any point.
1560      *
1561      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1562      * you perform all queries on the same block. See the following
1563      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1564      * for more information.
1565      */
1566     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1567         return _roles[role].members.at(index);
1568     }
1569 
1570     /**
1571      * @dev Returns the admin role that controls `role`. See {grantRole} and
1572      * {revokeRole}.
1573      *
1574      * To change a role's admin, use {_setRoleAdmin}.
1575      */
1576     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1577         return _roles[role].adminRole;
1578     }
1579 
1580     /**
1581      * @dev Grants `role` to `account`.
1582      *
1583      * If `account` had not been already granted `role`, emits a {RoleGranted}
1584      * event.
1585      *
1586      * Requirements:
1587      *
1588      * - the caller must have ``role``'s admin role.
1589      */
1590     function grantRole(bytes32 role, address account) public virtual {
1591         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1592 
1593         _grantRole(role, account);
1594     }
1595 
1596     /**
1597      * @dev Revokes `role` from `account`.
1598      *
1599      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1600      *
1601      * Requirements:
1602      *
1603      * - the caller must have ``role``'s admin role.
1604      */
1605     function revokeRole(bytes32 role, address account) public virtual {
1606         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1607 
1608         _revokeRole(role, account);
1609     }
1610 
1611     /**
1612      * @dev Revokes `role` from the calling account.
1613      *
1614      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1615      * purpose is to provide a mechanism for accounts to lose their privileges
1616      * if they are compromised (such as when a trusted device is misplaced).
1617      *
1618      * If the calling account had been granted `role`, emits a {RoleRevoked}
1619      * event.
1620      *
1621      * Requirements:
1622      *
1623      * - the caller must be `account`.
1624      */
1625     function renounceRole(bytes32 role, address account) public virtual {
1626         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1627 
1628         _revokeRole(role, account);
1629     }
1630 
1631     /**
1632      * @dev Grants `role` to `account`.
1633      *
1634      * If `account` had not been already granted `role`, emits a {RoleGranted}
1635      * event. Note that unlike {grantRole}, this function doesn't perform any
1636      * checks on the calling account.
1637      *
1638      * [WARNING]
1639      * ====
1640      * This function should only be called from the constructor when setting
1641      * up the initial roles for the system.
1642      *
1643      * Using this function in any other way is effectively circumventing the admin
1644      * system imposed by {AccessControl}.
1645      * ====
1646      */
1647     function _setupRole(bytes32 role, address account) internal virtual {
1648         _grantRole(role, account);
1649     }
1650 
1651     /**
1652      * @dev Sets `adminRole` as ``role``'s admin role.
1653      *
1654      * Emits a {RoleAdminChanged} event.
1655      */
1656     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1657         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1658         _roles[role].adminRole = adminRole;
1659     }
1660 
1661     function _grantRole(bytes32 role, address account) private {
1662         if (_roles[role].members.add(account)) {
1663             emit RoleGranted(role, account, _msgSender());
1664         }
1665     }
1666 
1667     function _revokeRole(bytes32 role, address account) private {
1668         if (_roles[role].members.remove(account)) {
1669             emit RoleRevoked(role, account, _msgSender());
1670         }
1671     }
1672 }
1673 
1674 // File: contracts\interfaces\ICallable.sol
1675 
1676 pragma solidity ^0.7.5;
1677 
1678 interface ICallable {
1679 
1680     function tokenCallback(address _from, uint _tokens, bytes calldata _data) external returns (bool);
1681 
1682 }
1683 
1684 // File: contracts\interfaces\IDrainer.sol
1685 
1686 pragma solidity ^0.7.5;
1687 
1688 interface IDrainer {
1689 
1690     /**
1691      * @dev allows withdrawal of ETH in case it was sent by accident
1692      * @param _beneficiary address where to send the eth.
1693      */
1694     function drainEth(address payable _beneficiary) external;
1695 
1696     /**
1697     * @dev allows withdrawal of ERC20 token in case it was sent by accident
1698     * @param _token address of ERC20 token.
1699     * @param _beneficiary address where to send the tokens.
1700     * @param _amount amount to send.
1701     */
1702     function drainTokens(address _token, address _beneficiary, uint _amount) external;
1703 }
1704 
1705 // File: contracts\Drainer.sol
1706 
1707 pragma solidity ^0.7.5;
1708 
1709 
1710 
1711 
1712 abstract contract Drainer is IDrainer, Ownable {
1713 
1714     function drainEth(address payable _beneficiary)
1715     public
1716     onlyOwner
1717     virtual
1718     override
1719     {
1720         uint balance = address(this).balance;
1721         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1722         _beneficiary.call{ value : balance}("");
1723     }
1724 
1725     function drainTokens(address _token, address _beneficiary, uint _amount)
1726     public
1727     onlyOwner
1728     virtual
1729     override
1730     {
1731         require(_amount > 0, "0 amount");
1732         IERC20(_token).transfer(_beneficiary, _amount);
1733     }
1734 }
1735 
1736 // File: contracts\BonkToken.sol
1737 
1738 pragma solidity ^0.7.5;
1739 
1740 
1741 
1742 
1743 
1744 
1745 
1746 contract BonkToken is ERC20Burnable, ERC20Snapshot, Ownable, AccessControl, Drainer {
1747 
1748     using SafeMath for uint;
1749 
1750     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1751     bytes32 public constant WHITELIST_TRANSFER_ROLE = keccak256("WHITELIST_TRANSFER_ROLE");
1752 
1753     bool public transfersEnabled = false;
1754 
1755     constructor(
1756         string memory _name,
1757         string memory _symbol,
1758         uint _initialSupplyWithoutDecimals
1759     )
1760     ERC20(_name, _symbol)
1761     {
1762         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1763         _setupRole(WHITELIST_TRANSFER_ROLE, _msgSender());
1764         _mint(_msgSender(), _initialSupplyWithoutDecimals * (10 ** uint(decimals())));
1765     }
1766 
1767     function snapshot()
1768     public
1769     returns (uint)
1770     {
1771         require(hasRole(SNAPSHOT_ROLE, msg.sender), "Not snapshot address");
1772         return super._snapshot();
1773     }
1774 
1775     function enableTransfers()
1776     external
1777     onlyOwner
1778     {
1779         transfersEnabled = true;
1780     }
1781 
1782     function transferAndCall(address _to, uint _tokens, bytes calldata _data)
1783     external
1784     returns (bool)
1785     {
1786         transfer(_to, _tokens);
1787         uint32 _size;
1788         assembly {
1789             _size := extcodesize(_to)
1790         }
1791         if (_size > 0) {
1792             require(ICallable(_to).tokenCallback(msg.sender, _tokens, _data));
1793         }
1794         return true;
1795     }
1796 
1797     function drainTokens(address _token, address _beneficiary, uint _amount)
1798     public
1799     override
1800     {
1801         require(_token != address(this), "Invalid token");
1802         super.drainTokens(_token, _beneficiary, _amount);
1803     }
1804 
1805     function _beforeTokenTransfer(address _from, address _to, uint _amount)
1806     internal
1807     virtual
1808     override(ERC20, ERC20Snapshot)
1809     {
1810         require(transfersEnabled || hasRole(WHITELIST_TRANSFER_ROLE, msg.sender), "Transfers disabled");
1811         super._beforeTokenTransfer(_from, _to, _amount);
1812     }
1813 }