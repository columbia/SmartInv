1 pragma solidity >=0.6.0 <0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
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
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor () internal {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 interface IERC20 {
79     /**
80      * @dev Returns the amount of tokens in existence.
81      */
82     function totalSupply() external view returns (uint256);
83 
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function balanceOf(address account) external view returns (uint256);
88 
89     /**
90      * @dev Moves `amount` tokens from the caller's account to `recipient`.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transfer(address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Returns the remaining number of tokens that `spender` will be
100      * allowed to spend on behalf of `owner` through {transferFrom}. This is
101      * zero by default.
102      *
103      * This value changes when {approve} or {transferFrom} are called.
104      */
105     function allowance(address owner, address spender) external view returns (uint256);
106 
107     /**
108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
113      * that someone may use both the old and the new allowance by unfortunate
114      * transaction ordering. One possible solution to mitigate this race
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Moves `amount` tokens from `sender` to `recipient` using the
125      * allowance mechanism. `amount` is then deducted from the caller's
126      * allowance.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 library SafeMath {
150     /**
151      * @dev Returns the addition of two unsigned integers, with an overflow flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         uint256 c = a + b;
157         if (c < a) return (false, 0);
158         return (true, c);
159     }
160 
161     /**
162      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
163      *
164      * _Available since v3.4._
165      */
166     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         if (b > a) return (false, 0);
168         return (true, a - b);
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) return (true, 0);
181         uint256 c = a * b;
182         if (c / a != b) return (false, 0);
183         return (true, c);
184     }
185 
186     /**
187      * @dev Returns the division of two unsigned integers, with a division by zero flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
192         if (b == 0) return (false, 0);
193         return (true, a / b);
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
198      *
199      * _Available since v3.4._
200      */
201     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
202         if (b == 0) return (false, 0);
203         return (true, a % b);
204     }
205 
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      *
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         require(b <= a, "SafeMath: subtraction overflow");
234         return a - b;
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      *
245      * - Multiplication cannot overflow.
246      */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         if (a == 0) return 0;
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers, reverting on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         require(b > 0, "SafeMath: division by zero");
268         return a / b;
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * reverting when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284         require(b > 0, "SafeMath: modulo by zero");
285         return a % b;
286     }
287 
288     /**
289      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
290      * overflow (when the result is negative).
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {trySub}.
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         return a - b;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * CAUTION: This function is deprecated because it requires allocating memory for the error
311      * message unnecessarily. For custom revert reasons use {tryDiv}.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b > 0, errorMessage);
323         return a / b;
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * reverting with custom message when dividing by zero.
329      *
330      * CAUTION: This function is deprecated because it requires allocating memory for the error
331      * message unnecessarily. For custom revert reasons use {tryMod}.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b > 0, errorMessage);
343         return a % b;
344     }
345 }
346 
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) private _balances;
351 
352     mapping (address => mapping (address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358     uint8 private _decimals;
359 
360     /**
361      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
362      * a default value of 18.
363      *
364      * To select a different value for {decimals}, use {_setupDecimals}.
365      *
366      * All three of these values are immutable: they can only be set once during
367      * construction.
368      */
369     constructor (string memory name_, string memory symbol_) public {
370         _name = name_;
371         _symbol = symbol_;
372         _decimals = 18;
373     }
374 
375     /**
376      * @dev Returns the name of the token.
377      */
378     function name() public view virtual returns (string memory) {
379         return _name;
380     }
381 
382     /**
383      * @dev Returns the symbol of the token, usually a shorter version of the
384      * name.
385      */
386     function symbol() public view virtual returns (string memory) {
387         return _symbol;
388     }
389 
390     /**
391      * @dev Returns the number of decimals used to get its user representation.
392      * For example, if `decimals` equals `2`, a balance of `505` tokens should
393      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
394      *
395      * Tokens usually opt for a value of 18, imitating the relationship between
396      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
397      * called.
398      *
399      * NOTE: This information is only used for _display_ purposes: it in
400      * no way affects any of the arithmetic of the contract, including
401      * {IERC20-balanceOf} and {IERC20-transfer}.
402      */
403     function decimals() public view virtual returns (uint8) {
404         return _decimals;
405     }
406 
407     /**
408      * @dev See {IERC20-totalSupply}.
409      */
410     function totalSupply() public view virtual override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     /**
415      * @dev See {IERC20-balanceOf}.
416      */
417     function balanceOf(address account) public view virtual override returns (uint256) {
418         return _balances[account];
419     }
420 
421     /**
422      * @dev See {IERC20-transfer}.
423      *
424      * Requirements:
425      *
426      * - `recipient` cannot be the zero address.
427      * - the caller must have a balance of at least `amount`.
428      */
429     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-allowance}.
436      */
437     function allowance(address owner, address spender) public view virtual override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440 
441     /**
442      * @dev See {IERC20-approve}.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function approve(address spender, uint256 amount) public virtual override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-transferFrom}.
455      *
456      * Emits an {Approval} event indicating the updated allowance. This is not
457      * required by the EIP. See the note at the beginning of {ERC20}.
458      *
459      * Requirements:
460      *
461      * - `sender` and `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      * - the caller must have allowance for ``sender``'s tokens of at least
464      * `amount`.
465      */
466     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
467         _transfer(sender, recipient, amount);
468         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
469         return true;
470     }
471 
472     /**
473      * @dev Atomically increases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to {approve} that can be used as a mitigation for
476      * problems described in {IERC20-approve}.
477      *
478      * Emits an {Approval} event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      */
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically decreases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      * - `spender` must have allowance for the caller of at least
501      * `subtractedValue`.
502      */
503     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
505         return true;
506     }
507 
508     /**
509      * @dev Moves tokens `amount` from `sender` to `recipient`.
510      *
511      * This is internal function is equivalent to {transfer}, and can be used to
512      * e.g. implement automatic token fees, slashing mechanisms, etc.
513      *
514      * Emits a {Transfer} event.
515      *
516      * Requirements:
517      *
518      * - `sender` cannot be the zero address.
519      * - `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `amount`.
521      */
522     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525 
526         _beforeTokenTransfer(sender, recipient, amount);
527 
528         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
529         _balances[recipient] = _balances[recipient].add(amount);
530         emit Transfer(sender, recipient, amount);
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements:
539      *
540      * - `to` cannot be the zero address.
541      */
542     function _mint(address account, uint256 amount) internal virtual {
543         require(account != address(0), "ERC20: mint to the zero address");
544 
545         _beforeTokenTransfer(address(0), account, amount);
546 
547         _totalSupply = _totalSupply.add(amount);
548         _balances[account] = _balances[account].add(amount);
549         emit Transfer(address(0), account, amount);
550     }
551 
552     /**
553      * @dev Destroys `amount` tokens from `account`, reducing the
554      * total supply.
555      *
556      * Emits a {Transfer} event with `to` set to the zero address.
557      *
558      * Requirements:
559      *
560      * - `account` cannot be the zero address.
561      * - `account` must have at least `amount` tokens.
562      */
563     function _burn(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: burn from the zero address");
565 
566         _beforeTokenTransfer(account, address(0), amount);
567 
568         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
569         _totalSupply = _totalSupply.sub(amount);
570         emit Transfer(account, address(0), amount);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
575      *
576      * This internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an {Approval} event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(address owner, address spender, uint256 amount) internal virtual {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     /**
595      * @dev Sets {decimals} to a value other than the default one of 18.
596      *
597      * WARNING: This function should only be called from the constructor. Most
598      * applications that interact with token contracts will not expect
599      * {decimals} to ever change, and may work incorrectly if it does.
600      */
601     function _setupDecimals(uint8 decimals_) internal virtual {
602         _decimals = decimals_;
603     }
604 
605     /**
606      * @dev Hook that is called before any transfer of tokens. This includes
607      * minting and burning.
608      *
609      * Calling conditions:
610      *
611      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
612      * will be to transferred to `to`.
613      * - when `from` is zero, `amount` tokens will be minted for `to`.
614      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
615      * - `from` and `to` are never both zero.
616      *
617      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
618      */
619     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
620 }
621 
622 abstract contract ERC20Burnable is Context, ERC20 {
623     using SafeMath for uint256;
624 
625     /**
626      * @dev Destroys `amount` tokens from the caller.
627      *
628      * See {ERC20-_burn}.
629      */
630     function burn(uint256 amount) public virtual {
631         _burn(_msgSender(), amount);
632     }
633 
634     /**
635      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
636      * allowance.
637      *
638      * See {ERC20-_burn} and {ERC20-allowance}.
639      *
640      * Requirements:
641      *
642      * - the caller must have allowance for ``accounts``'s tokens of at least
643      * `amount`.
644      */
645     function burnFrom(address account, uint256 amount) public virtual {
646         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
647 
648         _approve(account, _msgSender(), decreasedAllowance);
649         _burn(account, amount);
650     }
651 }
652 
653 library Math {
654     /**
655      * @dev Returns the largest of two numbers.
656      */
657     function max(uint256 a, uint256 b) internal pure returns (uint256) {
658         return a >= b ? a : b;
659     }
660 
661     /**
662      * @dev Returns the smallest of two numbers.
663      */
664     function min(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a < b ? a : b;
666     }
667 
668     /**
669      * @dev Returns the average of two numbers. The result is rounded towards
670      * zero.
671      */
672     function average(uint256 a, uint256 b) internal pure returns (uint256) {
673         // (a + b) / 2 can overflow, so we distribute
674         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
675     }
676 }
677 
678 library Arrays {
679    /**
680      * @dev Searches a sorted `array` and returns the first index that contains
681      * a value greater or equal to `element`. If no such index exists (i.e. all
682      * values in the array are strictly less than `element`), the array length is
683      * returned. Time complexity O(log n).
684      *
685      * `array` is expected to be sorted in ascending order, and to contain no
686      * repeated elements.
687      */
688     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
689         if (array.length == 0) {
690             return 0;
691         }
692 
693         uint256 low = 0;
694         uint256 high = array.length;
695 
696         while (low < high) {
697             uint256 mid = Math.average(low, high);
698 
699             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
700             // because Math.average rounds down (it does integer division with truncation).
701             if (array[mid] > element) {
702                 high = mid;
703             } else {
704                 low = mid + 1;
705             }
706         }
707 
708         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
709         if (low > 0 && array[low - 1] == element) {
710             return low - 1;
711         } else {
712             return low;
713         }
714     }
715 }
716 
717 library Counters {
718     using SafeMath for uint256;
719 
720     struct Counter {
721         // This variable should never be directly accessed by users of the library: interactions must be restricted to
722         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
723         // this feature: see https://github.com/ethereum/solidity/issues/4637
724         uint256 _value; // default: 0
725     }
726 
727     function current(Counter storage counter) internal view returns (uint256) {
728         return counter._value;
729     }
730 
731     function increment(Counter storage counter) internal {
732         // The {SafeMath} overflow check can be skipped here, see the comment at the top
733         counter._value += 1;
734     }
735 
736     function decrement(Counter storage counter) internal {
737         counter._value = counter._value.sub(1);
738     }
739 }
740 
741 abstract contract ERC20Snapshot is ERC20 {
742     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
743     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
744 
745     using SafeMath for uint256;
746     using Arrays for uint256[];
747     using Counters for Counters.Counter;
748 
749     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
750     // Snapshot struct, but that would impede usage of functions that work on an array.
751     struct Snapshots {
752         uint256[] ids;
753         uint256[] values;
754     }
755 
756     mapping (address => Snapshots) private _accountBalanceSnapshots;
757     Snapshots private _totalSupplySnapshots;
758 
759     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
760     Counters.Counter private _currentSnapshotId;
761 
762     /**
763      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
764      */
765     event Snapshot(uint256 id);
766 
767     /**
768      * @dev Creates a new snapshot and returns its snapshot id.
769      *
770      * Emits a {Snapshot} event that contains the same id.
771      *
772      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
773      * set of accounts, for example using {AccessControl}, or it may be open to the public.
774      *
775      * [WARNING]
776      * ====
777      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
778      * you must consider that it can potentially be used by attackers in two ways.
779      *
780      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
781      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
782      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
783      * section above.
784      *
785      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
786      * ====
787      */
788     function _snapshot() internal virtual returns (uint256) {
789         _currentSnapshotId.increment();
790 
791         uint256 currentId = _currentSnapshotId.current();
792         emit Snapshot(currentId);
793         return currentId;
794     }
795 
796     /**
797      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
798      */
799     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
800         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
801 
802         return snapshotted ? value : balanceOf(account);
803     }
804 
805     /**
806      * @dev Retrieves the total supply at the time `snapshotId` was created.
807      */
808     function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {
809         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
810 
811         return snapshotted ? value : totalSupply();
812     }
813 
814 
815     // Update balance and/or total supply snapshots before the values are modified. This is implemented
816     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
817     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
818       super._beforeTokenTransfer(from, to, amount);
819 
820       if (from == address(0)) {
821         // mint
822         _updateAccountSnapshot(to);
823         _updateTotalSupplySnapshot();
824       } else if (to == address(0)) {
825         // burn
826         _updateAccountSnapshot(from);
827         _updateTotalSupplySnapshot();
828       } else {
829         // transfer
830         _updateAccountSnapshot(from);
831         _updateAccountSnapshot(to);
832       }
833     }
834 
835     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
836         private view returns (bool, uint256)
837     {
838         require(snapshotId > 0, "ERC20Snapshot: id is 0");
839         // solhint-disable-next-line max-line-length
840         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
841 
842         // When a valid snapshot is queried, there are three possibilities:
843         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
844         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
845         //  to this id is the current one.
846         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
847         //  requested id, and its value is the one to return.
848         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
849         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
850         //  larger than the requested one.
851         //
852         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
853         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
854         // exactly this.
855 
856         uint256 index = snapshots.ids.findUpperBound(snapshotId);
857 
858         if (index == snapshots.ids.length) {
859             return (false, 0);
860         } else {
861             return (true, snapshots.values[index]);
862         }
863     }
864 
865     function _updateAccountSnapshot(address account) private {
866         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
867     }
868 
869     function _updateTotalSupplySnapshot() private {
870         _updateSnapshot(_totalSupplySnapshots, totalSupply());
871     }
872 
873     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
874         uint256 currentId = _currentSnapshotId.current();
875         if (_lastSnapshotId(snapshots.ids) < currentId) {
876             snapshots.ids.push(currentId);
877             snapshots.values.push(currentValue);
878         }
879     }
880 
881     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
882         if (ids.length == 0) {
883             return 0;
884         } else {
885             return ids[ids.length - 1];
886         }
887     }
888 }
889 
890 contract KLAYG is ERC20Burnable, ERC20Snapshot, Ownable {
891     using SafeMath for uint256;
892 
893     constructor(
894         uint256 _totalSupply,
895         string memory _name,
896         string memory _symbol
897     ) public ERC20(_name, _symbol) {
898         _mint(msg.sender, _totalSupply);
899     }
900 
901     function snapshot() public onlyOwner {
902         _snapshot();
903     }
904 
905     function _beforeTokenTransfer(
906         address from,
907         address to,
908         uint256 amount
909     ) internal virtual override(ERC20, ERC20Snapshot) {
910         super._beforeTokenTransfer(from, to, amount);
911     }
912 }