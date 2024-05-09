1 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity >=0.6.0 <0.8.0;
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
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 
219 // Dependency file: @openzeppelin/contracts/math/Math.sol
220 
221 
222 // pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @dev Standard math utilities missing in the Solidity language.
226  */
227 library Math {
228     /**
229      * @dev Returns the largest of two numbers.
230      */
231     function max(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a >= b ? a : b;
233     }
234 
235     /**
236      * @dev Returns the smallest of two numbers.
237      */
238     function min(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a < b ? a : b;
240     }
241 
242     /**
243      * @dev Returns the average of two numbers. The result is rounded towards
244      * zero.
245      */
246     function average(uint256 a, uint256 b) internal pure returns (uint256) {
247         // (a + b) / 2 can overflow, so we distribute
248         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
249     }
250 }
251 
252 
253 // Dependency file: @openzeppelin/contracts/utils/Arrays.sol
254 
255 
256 // pragma solidity >=0.6.0 <0.8.0;
257 
258 // import "@openzeppelin/contracts/math/Math.sol";
259 
260 /**
261  * @dev Collection of functions related to array types.
262  */
263 library Arrays {
264    /**
265      * @dev Searches a sorted `array` and returns the first index that contains
266      * a value greater or equal to `element`. If no such index exists (i.e. all
267      * values in the array are strictly less than `element`), the array length is
268      * returned. Time complexity O(log n).
269      *
270      * `array` is expected to be sorted in ascending order, and to contain no
271      * repeated elements.
272      */
273     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
274         if (array.length == 0) {
275             return 0;
276         }
277 
278         uint256 low = 0;
279         uint256 high = array.length;
280 
281         while (low < high) {
282             uint256 mid = Math.average(low, high);
283 
284             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
285             // because Math.average rounds down (it does integer division with truncation).
286             if (array[mid] > element) {
287                 high = mid;
288             } else {
289                 low = mid + 1;
290             }
291         }
292 
293         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
294         if (low > 0 && array[low - 1] == element) {
295             return low - 1;
296         } else {
297             return low;
298         }
299     }
300 }
301 
302 
303 // Dependency file: @openzeppelin/contracts/utils/Counters.sol
304 
305 
306 // pragma solidity >=0.6.0 <0.8.0;
307 
308 // import "@openzeppelin/contracts/math/SafeMath.sol";
309 
310 /**
311  * @title Counters
312  * @author Matt Condon (@shrugs)
313  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
314  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
315  *
316  * Include with `using Counters for Counters.Counter;`
317  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
318  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
319  * directly accessed.
320  */
321 library Counters {
322     using SafeMath for uint256;
323 
324     struct Counter {
325         // This variable should never be directly accessed by users of the library: interactions must be restricted to
326         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
327         // this feature: see https://github.com/ethereum/solidity/issues/4637
328         uint256 _value; // default: 0
329     }
330 
331     function current(Counter storage counter) internal view returns (uint256) {
332         return counter._value;
333     }
334 
335     function increment(Counter storage counter) internal {
336         // The {SafeMath} overflow check can be skipped here, see the comment at the top
337         counter._value += 1;
338     }
339 
340     function decrement(Counter storage counter) internal {
341         counter._value = counter._value.sub(1);
342     }
343 }
344 
345 
346 // Dependency file: @openzeppelin/contracts/utils/Context.sol
347 
348 
349 // pragma solidity >=0.6.0 <0.8.0;
350 
351 /*
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with GSN meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address payable) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes memory) {
367         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
368         return msg.data;
369     }
370 }
371 
372 
373 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
374 
375 
376 // pragma solidity >=0.6.0 <0.8.0;
377 
378 /**
379  * @dev Interface of the ERC20 standard as defined in the EIP.
380  */
381 interface IERC20 {
382     /**
383      * @dev Returns the amount of tokens in existence.
384      */
385     function totalSupply() external view returns (uint256);
386 
387     /**
388      * @dev Returns the amount of tokens owned by `account`.
389      */
390     function balanceOf(address account) external view returns (uint256);
391 
392     /**
393      * @dev Moves `amount` tokens from the caller's account to `recipient`.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * Emits a {Transfer} event.
398      */
399     function transfer(address recipient, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Returns the remaining number of tokens that `spender` will be
403      * allowed to spend on behalf of `owner` through {transferFrom}. This is
404      * zero by default.
405      *
406      * This value changes when {approve} or {transferFrom} are called.
407      */
408     function allowance(address owner, address spender) external view returns (uint256);
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * IMPORTANT: Beware that changing an allowance with this method brings the risk
416      * that someone may use both the old and the new allowance by unfortunate
417      * transaction ordering. One possible solution to mitigate this race
418      * condition is to first reduce the spender's allowance to 0 and set the
419      * desired value afterwards:
420      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address spender, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Moves `amount` tokens from `sender` to `recipient` using the
428      * allowance mechanism. `amount` is then deducted from the caller's
429      * allowance.
430      *
431      * Returns a boolean value indicating whether the operation succeeded.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
436 
437     /**
438      * @dev Emitted when `value` tokens are moved from one account (`from`) to
439      * another (`to`).
440      *
441      * Note that `value` may be zero.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 value);
444 
445     /**
446      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
447      * a call to {approve}. `value` is the new allowance.
448      */
449     event Approval(address indexed owner, address indexed spender, uint256 value);
450 }
451 
452 
453 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
454 
455 
456 // pragma solidity >=0.6.0 <0.8.0;
457 
458 // import "@openzeppelin/contracts/utils/Context.sol";
459 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
460 // import "@openzeppelin/contracts/math/SafeMath.sol";
461 
462 /**
463  * @dev Implementation of the {IERC20} interface.
464  *
465  * This implementation is agnostic to the way tokens are created. This means
466  * that a supply mechanism has to be added in a derived contract using {_mint}.
467  * For a generic mechanism see {ERC20PresetMinterPauser}.
468  *
469  * TIP: For a detailed writeup see our guide
470  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
471  * to implement supply mechanisms].
472  *
473  * We have followed general OpenZeppelin guidelines: functions revert instead
474  * of returning `false` on failure. This behavior is nonetheless conventional
475  * and does not conflict with the expectations of ERC20 applications.
476  *
477  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
478  * This allows applications to reconstruct the allowance for all accounts just
479  * by listening to said events. Other implementations of the EIP may not emit
480  * these events, as it isn't required by the specification.
481  *
482  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
483  * functions have been added to mitigate the well-known issues around setting
484  * allowances. See {IERC20-approve}.
485  */
486 contract ERC20 is Context, IERC20 {
487     using SafeMath for uint256;
488 
489     mapping (address => uint256) private _balances;
490 
491     mapping (address => mapping (address => uint256)) private _allowances;
492 
493     uint256 private _totalSupply;
494 
495     string private _name;
496     string private _symbol;
497     uint8 private _decimals;
498 
499     /**
500      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
501      * a default value of 18.
502      *
503      * To select a different value for {decimals}, use {_setupDecimals}.
504      *
505      * All three of these values are immutable: they can only be set once during
506      * construction.
507      */
508     constructor (string memory name_, string memory symbol_) public {
509         _name = name_;
510         _symbol = symbol_;
511         _decimals = 18;
512     }
513 
514     /**
515      * @dev Returns the name of the token.
516      */
517     function name() public view virtual returns (string memory) {
518         return _name;
519     }
520 
521     /**
522      * @dev Returns the symbol of the token, usually a shorter version of the
523      * name.
524      */
525     function symbol() public view virtual returns (string memory) {
526         return _symbol;
527     }
528 
529     /**
530      * @dev Returns the number of decimals used to get its user representation.
531      * For example, if `decimals` equals `2`, a balance of `505` tokens should
532      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
533      *
534      * Tokens usually opt for a value of 18, imitating the relationship between
535      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
536      * called.
537      *
538      * NOTE: This information is only used for _display_ purposes: it in
539      * no way affects any of the arithmetic of the contract, including
540      * {IERC20-balanceOf} and {IERC20-transfer}.
541      */
542     function decimals() public view virtual returns (uint8) {
543         return _decimals;
544     }
545 
546     /**
547      * @dev See {IERC20-totalSupply}.
548      */
549     function totalSupply() public view virtual override returns (uint256) {
550         return _totalSupply;
551     }
552 
553     /**
554      * @dev See {IERC20-balanceOf}.
555      */
556     function balanceOf(address account) public view virtual override returns (uint256) {
557         return _balances[account];
558     }
559 
560     /**
561      * @dev See {IERC20-transfer}.
562      *
563      * Requirements:
564      *
565      * - `recipient` cannot be the zero address.
566      * - the caller must have a balance of at least `amount`.
567      */
568     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
569         _transfer(_msgSender(), recipient, amount);
570         return true;
571     }
572 
573     /**
574      * @dev See {IERC20-allowance}.
575      */
576     function allowance(address owner, address spender) public view virtual override returns (uint256) {
577         return _allowances[owner][spender];
578     }
579 
580     /**
581      * @dev See {IERC20-approve}.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      */
587     function approve(address spender, uint256 amount) public virtual override returns (bool) {
588         _approve(_msgSender(), spender, amount);
589         return true;
590     }
591 
592     /**
593      * @dev See {IERC20-transferFrom}.
594      *
595      * Emits an {Approval} event indicating the updated allowance. This is not
596      * required by the EIP. See the note at the beginning of {ERC20}.
597      *
598      * Requirements:
599      *
600      * - `sender` and `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      * - the caller must have allowance for ``sender``'s tokens of at least
603      * `amount`.
604      */
605     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
606         _transfer(sender, recipient, amount);
607         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically increases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      */
623     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
624         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
625         return true;
626     }
627 
628     /**
629      * @dev Atomically decreases the allowance granted to `spender` by the caller.
630      *
631      * This is an alternative to {approve} that can be used as a mitigation for
632      * problems described in {IERC20-approve}.
633      *
634      * Emits an {Approval} event indicating the updated allowance.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      * - `spender` must have allowance for the caller of at least
640      * `subtractedValue`.
641      */
642     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
643         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
644         return true;
645     }
646 
647     /**
648      * @dev Moves tokens `amount` from `sender` to `recipient`.
649      *
650      * This is internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
662         require(sender != address(0), "ERC20: transfer from the zero address");
663         require(recipient != address(0), "ERC20: transfer to the zero address");
664 
665         _beforeTokenTransfer(sender, recipient, amount);
666 
667         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
668         _balances[recipient] = _balances[recipient].add(amount);
669         emit Transfer(sender, recipient, amount);
670     }
671 
672     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
673      * the total supply.
674      *
675      * Emits a {Transfer} event with `from` set to the zero address.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      */
681     function _mint(address account, uint256 amount) internal virtual {
682         require(account != address(0), "ERC20: mint to the zero address");
683 
684         _beforeTokenTransfer(address(0), account, amount);
685 
686         _totalSupply = _totalSupply.add(amount);
687         _balances[account] = _balances[account].add(amount);
688         emit Transfer(address(0), account, amount);
689     }
690 
691     /**
692      * @dev Destroys `amount` tokens from `account`, reducing the
693      * total supply.
694      *
695      * Emits a {Transfer} event with `to` set to the zero address.
696      *
697      * Requirements:
698      *
699      * - `account` cannot be the zero address.
700      * - `account` must have at least `amount` tokens.
701      */
702     function _burn(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: burn from the zero address");
704 
705         _beforeTokenTransfer(account, address(0), amount);
706 
707         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
708         _totalSupply = _totalSupply.sub(amount);
709         emit Transfer(account, address(0), amount);
710     }
711 
712     /**
713      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
714      *
715      * This internal function is equivalent to `approve`, and can be used to
716      * e.g. set automatic allowances for certain subsystems, etc.
717      *
718      * Emits an {Approval} event.
719      *
720      * Requirements:
721      *
722      * - `owner` cannot be the zero address.
723      * - `spender` cannot be the zero address.
724      */
725     function _approve(address owner, address spender, uint256 amount) internal virtual {
726         require(owner != address(0), "ERC20: approve from the zero address");
727         require(spender != address(0), "ERC20: approve to the zero address");
728 
729         _allowances[owner][spender] = amount;
730         emit Approval(owner, spender, amount);
731     }
732 
733     /**
734      * @dev Sets {decimals} to a value other than the default one of 18.
735      *
736      * WARNING: This function should only be called from the constructor. Most
737      * applications that interact with token contracts will not expect
738      * {decimals} to ever change, and may work incorrectly if it does.
739      */
740     function _setupDecimals(uint8 decimals_) internal virtual {
741         _decimals = decimals_;
742     }
743 
744     /**
745      * @dev Hook that is called before any transfer of tokens. This includes
746      * minting and burning.
747      *
748      * Calling conditions:
749      *
750      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
751      * will be to transferred to `to`.
752      * - when `from` is zero, `amount` tokens will be minted for `to`.
753      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
754      * - `from` and `to` are never both zero.
755      *
756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
757      */
758     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
759 }
760 
761 
762 // Root file: contracts/BitDAO.sol
763 
764 pragma solidity >=0.6.5 <0.8.0;
765 
766 // import '/Users/stone/Desktop/BitDAO/node_modules/@openzeppelin/contracts/math/SafeMath.sol';
767 // import '/Users/stone/Desktop/BitDAO/node_modules/@openzeppelin/contracts/utils/Arrays.sol';
768 // import '/Users/stone/Desktop/BitDAO/node_modules/@openzeppelin/contracts/utils/Counters.sol';
769 // import '/Users/stone/Desktop/BitDAO/node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol';
770 
771 contract BitDAO is ERC20 {
772 	using SafeMath for uint256;
773 	using Arrays for uint256[];
774 	using Counters for Counters.Counter;
775 
776 	uint256 public MAX_SUPPLY = 1e28; // 1e10 * 1e18
777 
778 	address public admin;
779 
780 	address public pendingAdmin;
781 
782 	mapping(address => address) public delegates;
783 
784 	struct Checkpoint {
785 		uint256 fromBlock;
786 		uint256 votes;
787 	}
788 
789 	mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;
790 
791 	mapping(address => uint256) public numCheckpoints;
792 
793 	bytes32 public constant DOMAIN_TYPEHASH =
794 		keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)');
795 
796 	bytes32 public constant DELEGATION_TYPEHASH =
797 		keccak256('Delegation(address delegatee,uint256 nonce,uint256 expiry)');
798 
799 	mapping(address => uint256) public nonces;
800 
801 	struct Snapshots {
802 		uint256[] ids;
803 		uint256[] values;
804 	}
805 
806 	mapping(address => Snapshots) private _accountBalanceSnapshots;
807 
808 	Snapshots private _totalSupplySnapshots;
809 
810 	Counters.Counter private _currentSnapshotId;
811 
812 	event Snapshot(uint256 id);
813 
814 	event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
815 
816 	event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
817 
818 	event NewPendingAdmin(address indexed oldPendingAdmin, address indexed newPendingAdmin);
819 
820 	event NewAdmin(address indexed oldAdmin, address indexed newAdmin);
821 
822 	modifier onlyAdmin {
823 		require(msg.sender == admin, 'Caller is not a admin');
824 		_;
825 	}
826 
827 	constructor(address _admin) ERC20('BitDAO', 'BIT') {
828 		admin = _admin;
829 		_mint(_admin, MAX_SUPPLY);
830 	}
831 
832 	function setPendingAdmin(address newPendingAdmin) external returns (bool) {
833 		if (msg.sender != admin) {
834 			revert('BitDAO:setPendingAdmin:illegal address');
835 		}
836 		address oldPendingAdmin = pendingAdmin;
837 		pendingAdmin = newPendingAdmin;
838 
839 		emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
840 
841 		return true;
842 	}
843 
844 	function acceptAdmin() external returns (bool) {
845 		if (msg.sender != pendingAdmin || msg.sender == address(0)) {
846 			revert('BitDAO:acceptAdmin:illegal address');
847 		}
848 		address oldAdmin = admin;
849 		address oldPendingAdmin = pendingAdmin;
850 		admin = pendingAdmin;
851 		pendingAdmin = address(0);
852 
853 		emit NewAdmin(oldAdmin, admin);
854 		emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
855 
856 		return true;
857 	}
858 
859 	function snapshot() external virtual onlyAdmin returns (uint256) {
860 		_currentSnapshotId.increment();
861 
862 		uint256 currentId = _currentSnapshotId.current();
863 		emit Snapshot(currentId);
864 		return currentId;
865 	}
866 
867 	function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
868 		(bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
869 
870 		return snapshotted ? value : balanceOf(account);
871 	}
872 
873 	function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
874 		(bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
875 
876 		return snapshotted ? value : totalSupply();
877 	}
878 
879 	function _beforeTokenTransfer(
880 		address from,
881 		address to,
882 		uint256 amount
883 	) internal virtual override {
884 		super._beforeTokenTransfer(from, to, amount);
885 		if (from == address(0)) {
886 			// mint
887 			_updateAccountSnapshot(to);
888 			_updateTotalSupplySnapshot();
889 		} else if (to == address(0)) {
890 			// burn
891 			_updateAccountSnapshot(from);
892 			_updateTotalSupplySnapshot();
893 		} else {
894 			// transfer
895 			_updateAccountSnapshot(from);
896 			_updateAccountSnapshot(to);
897 		}
898 	}
899 
900 	function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
901 		require(snapshotId > 0, 'ERC20Snapshot: id is 0');
902 		require(snapshotId <= _currentSnapshotId.current(), 'ERC20Snapshot: nonexistent id');
903 
904 		uint256 index = snapshots.ids.findUpperBound(snapshotId);
905 
906 		if (index == snapshots.ids.length) {
907 			return (false, 0);
908 		} else {
909 			return (true, snapshots.values[index]);
910 		}
911 	}
912 
913 	function _updateAccountSnapshot(address account) private {
914 		_updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
915 	}
916 
917 	function _updateTotalSupplySnapshot() private {
918 		_updateSnapshot(_totalSupplySnapshots, totalSupply());
919 	}
920 
921 	function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
922 		uint256 currentId = _currentSnapshotId.current();
923 		if (_lastSnapshotId(snapshots.ids) < currentId) {
924 			snapshots.ids.push(currentId);
925 			snapshots.values.push(currentValue);
926 		}
927 	}
928 
929 	function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
930 		if (ids.length == 0) {
931 			return 0;
932 		} else {
933 			return ids[ids.length - 1];
934 		}
935 	}
936 
937 	function delegate(address delegatee) external {
938 		return _delegate(msg.sender, delegatee);
939 	}
940 
941 	function delegateBySig(
942 		address delegatee,
943 		uint256 nonce,
944 		uint256 expiry,
945 		uint8 v,
946 		bytes32 r,
947 		bytes32 s
948 	) external {
949 		bytes32 domainSeparator =
950 			keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this)));
951 		bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
952 		bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
953 		address signatory = ecrecover(digest, v, r, s);
954 		require(signatory != address(0), 'BitDAO::delegateBySig: invalid signature');
955 		require(nonce == nonces[signatory]++, 'BitDAO::delegateBySig: invalid nonce');
956 		require(block.timestamp <= expiry, 'BitDAO::delegateBySig: signature expired');
957 		return _delegate(signatory, delegatee);
958 	}
959 
960 	function getCurrentVotes(address account) external view returns (uint256) {
961 		uint256 nCheckpoints = numCheckpoints[account];
962 		return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
963 	}
964 
965 	function getPriorVotes(address account, uint256 blockNumber) public view returns (uint256) {
966 		require(blockNumber < block.number, 'BitDAO::getPriorVotes: not yet determined');
967 
968 		uint256 nCheckpoints = numCheckpoints[account];
969 		if (nCheckpoints == 0) {
970 			return 0;
971 		}
972 
973 		if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
974 			return checkpoints[account][nCheckpoints - 1].votes;
975 		}
976 
977 		if (checkpoints[account][0].fromBlock > blockNumber) {
978 			return 0;
979 		}
980 
981 		uint256 lower = 0;
982 		uint256 upper = nCheckpoints - 1;
983 		while (upper > lower) {
984 			uint256 center = upper - (upper - lower) / 2;
985 			Checkpoint memory cp = checkpoints[account][center];
986 			if (cp.fromBlock == blockNumber) {
987 				return cp.votes;
988 			} else if (cp.fromBlock < blockNumber) {
989 				lower = center;
990 			} else {
991 				upper = center - 1;
992 			}
993 		}
994 		return checkpoints[account][lower].votes;
995 	}
996 
997 	function _delegate(address delegator, address delegatee) internal {
998 		address currentDelegate = delegates[delegator];
999 		uint256 delegatorBalance = balanceOf(delegator);
1000 		delegates[delegator] = delegatee;
1001 
1002 		emit DelegateChanged(delegator, currentDelegate, delegatee);
1003 
1004 		_moveDelegates(currentDelegate, delegatee, delegatorBalance);
1005 	}
1006 
1007 	function _transfer(
1008 		address sender,
1009 		address recipient,
1010 		uint256 amount
1011 	) internal virtual override {
1012 		super._transfer(sender, recipient, amount);
1013 		_moveDelegates(delegates[sender], delegates[recipient], amount);
1014 	}
1015 
1016 	function _moveDelegates(
1017 		address srcRep,
1018 		address dstRep,
1019 		uint256 amount
1020 	) internal {
1021 		if (srcRep != dstRep && amount > 0) {
1022 			if (srcRep != address(0)) {
1023 				uint256 srcRepNum = numCheckpoints[srcRep];
1024 				uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1025 				uint256 srcRepNew = srcRepOld.sub(amount);
1026 				_writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1027 			}
1028 
1029 			if (dstRep != address(0)) {
1030 				uint256 dstRepNum = numCheckpoints[dstRep];
1031 				uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1032 				uint256 dstRepNew = dstRepOld.add(amount);
1033 				_writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1034 			}
1035 		}
1036 	}
1037 
1038 	function _writeCheckpoint(
1039 		address delegatee,
1040 		uint256 nCheckpoints,
1041 		uint256 oldVotes,
1042 		uint256 newVotes
1043 	) internal {
1044 		uint256 blockNumber = safe32(block.number, 'BitDAO::_writeCheckpoint: block number exceeds 32 bits');
1045 
1046 		if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1047 			checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1048 		} else {
1049 			checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1050 			numCheckpoints[delegatee] = nCheckpoints + 1;
1051 		}
1052 
1053 		emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1054 	}
1055 
1056 	function safe32(uint256 n, string memory errorMessage) internal pure returns (uint256) {
1057 		require(n < 2**32, errorMessage);
1058 		return uint256(n);
1059 	}
1060 
1061 	function getChainId() internal pure returns (uint256) {
1062 		uint256 chainId;
1063 		assembly {
1064 			chainId := chainid()
1065 		}
1066 		return chainId;
1067 	}
1068 }