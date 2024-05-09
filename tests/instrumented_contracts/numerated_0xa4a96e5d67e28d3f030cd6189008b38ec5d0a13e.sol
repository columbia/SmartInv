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
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 /**
91  * @dev Interface of the ERC20 standard as defined in the EIP.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 /**
165  * @dev Wrappers over Solidity's arithmetic operations with added overflow
166  * checks.
167  *
168  * Arithmetic operations in Solidity wrap on overflow. This can easily result
169  * in bugs, because programmers usually assume that an overflow raises an
170  * error, which is the standard behavior in high level programming languages.
171  * `SafeMath` restores this intuition by reverting the transaction when an
172  * operation overflows.
173  *
174  * Using this library instead of the unchecked operations eliminates an entire
175  * class of bugs, so it's recommended to use it always.
176  */
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return sub(a, b, "SafeMath: subtraction overflow");
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b <= a, errorMessage);
221         uint256 c = a - b;
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return div(a, b, "SafeMath: division by zero");
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b > 0, errorMessage);
280         uint256 c = a / b;
281         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return mod(a, b, "SafeMath: modulo by zero");
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts with custom message when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b != 0, errorMessage);
316         return a % b;
317     }
318 }
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20PresetMinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * We have followed general OpenZeppelin guidelines: functions revert instead
332  * of returning `false` on failure. This behavior is nonetheless conventional
333  * and does not conflict with the expectations of ERC20 applications.
334  *
335  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
336  * This allows applications to reconstruct the allowance for all accounts just
337  * by listening to said events. Other implementations of the EIP may not emit
338  * these events, as it isn't required by the specification.
339  *
340  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
341  * functions have been added to mitigate the well-known issues around setting
342  * allowances. See {IERC20-approve}.
343  */
344 contract ERC20 is Context, IERC20 {
345     using SafeMath for uint256;
346 
347     mapping (address => uint256) private _balances;
348 
349     mapping (address => mapping (address => uint256)) private _allowances;
350 
351     uint256 private _totalSupply;
352 
353     string private _name;
354     string private _symbol;
355     uint8 private _decimals;
356 
357     /**
358      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
359      * a default value of 18.
360      *
361      * To select a different value for {decimals}, use {_setupDecimals}.
362      *
363      * All three of these values are immutable: they can only be set once during
364      * construction.
365      */
366     constructor (string memory name_, string memory symbol_) public {
367         _name = name_;
368         _symbol = symbol_;
369         _decimals = 18;
370     }
371 
372     /**
373      * @dev Returns the name of the token.
374      */
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     /**
380      * @dev Returns the symbol of the token, usually a shorter version of the
381      * name.
382      */
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     /**
388      * @dev Returns the number of decimals used to get its user representation.
389      * For example, if `decimals` equals `2`, a balance of `505` tokens should
390      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
391      *
392      * Tokens usually opt for a value of 18, imitating the relationship between
393      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
394      * called.
395      *
396      * NOTE: This information is only used for _display_ purposes: it in
397      * no way affects any of the arithmetic of the contract, including
398      * {IERC20-balanceOf} and {IERC20-transfer}.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 
404     /**
405      * @dev See {IERC20-totalSupply}.
406      */
407     function totalSupply() public view override returns (uint256) {
408         return _totalSupply;
409     }
410 
411     /**
412      * @dev See {IERC20-balanceOf}.
413      */
414     function balanceOf(address account) public view override returns (uint256) {
415         return _balances[account];
416     }
417 
418     /**
419      * @dev See {IERC20-transfer}.
420      *
421      * Requirements:
422      *
423      * - `recipient` cannot be the zero address.
424      * - the caller must have a balance of at least `amount`.
425      */
426     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-allowance}.
433      */
434     function allowance(address owner, address spender) public view virtual override returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     /**
439      * @dev See {IERC20-approve}.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function approve(address spender, uint256 amount) public virtual override returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-transferFrom}.
452      *
453      * Emits an {Approval} event indicating the updated allowance. This is not
454      * required by the EIP. See the note at the beginning of {ERC20}.
455      *
456      * Requirements:
457      *
458      * - `sender` and `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``sender``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     }
504 
505     /**
506      * @dev Moves tokens `amount` from `sender` to `recipient`.
507      *
508      * This is internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `sender` cannot be the zero address.
516      * - `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      */
519     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
520         require(sender != address(0), "ERC20: transfer from the zero address");
521         require(recipient != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(sender, recipient, amount);
524 
525         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
526         _balances[recipient] = _balances[recipient].add(amount);
527         emit Transfer(sender, recipient, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
572      *
573      * This internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(address owner, address spender, uint256 amount) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Sets {decimals} to a value other than the default one of 18.
593      *
594      * WARNING: This function should only be called from the constructor. Most
595      * applications that interact with token contracts will not expect
596      * {decimals} to ever change, and may work incorrectly if it does.
597      */
598     function _setupDecimals(uint8 decimals_) internal {
599         _decimals = decimals_;
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be to transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
617 }
618 
619 /**
620  * @dev Extension of {ERC20} that allows token holders to destroy both their own
621  * tokens and those that they have an allowance for, in a way that can be
622  * recognized off-chain (via event analysis).
623  */
624 abstract contract ERC20Burnable is Context, ERC20 {
625     using SafeMath for uint256;
626 
627     /**
628      * @dev Destroys `amount` tokens from the caller.
629      *
630      * See {ERC20-_burn}.
631      */
632     function burn(uint256 amount) public virtual {
633         _burn(_msgSender(), amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
638      * allowance.
639      *
640      * See {ERC20-_burn} and {ERC20-allowance}.
641      *
642      * Requirements:
643      *
644      * - the caller must have allowance for ``accounts``'s tokens of at least
645      * `amount`.
646      */
647     function burnFrom(address account, uint256 amount) public virtual {
648         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
649 
650         _approve(account, _msgSender(), decreasedAllowance);
651         _burn(account, amount);
652     }
653 }
654 
655 /**
656  * @dev Standard math utilities missing in the Solidity language.
657  */
658 library Math {
659     /**
660      * @dev Returns the largest of two numbers.
661      */
662     function max(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a >= b ? a : b;
664     }
665 
666     /**
667      * @dev Returns the smallest of two numbers.
668      */
669     function min(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a < b ? a : b;
671     }
672 
673     /**
674      * @dev Returns the average of two numbers. The result is rounded towards
675      * zero.
676      */
677     function average(uint256 a, uint256 b) internal pure returns (uint256) {
678         // (a + b) / 2 can overflow, so we distribute
679         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
680     }
681 }
682 
683 /**
684  * @dev Collection of functions related to array types.
685  */
686 library Arrays {
687    /**
688      * @dev Searches a sorted `array` and returns the first index that contains
689      * a value greater or equal to `element`. If no such index exists (i.e. all
690      * values in the array are strictly less than `element`), the array length is
691      * returned. Time complexity O(log n).
692      *
693      * `array` is expected to be sorted in ascending order, and to contain no
694      * repeated elements.
695      */
696     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
697         if (array.length == 0) {
698             return 0;
699         }
700 
701         uint256 low = 0;
702         uint256 high = array.length;
703 
704         while (low < high) {
705             uint256 mid = Math.average(low, high);
706 
707             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
708             // because Math.average rounds down (it does integer division with truncation).
709             if (array[mid] > element) {
710                 high = mid;
711             } else {
712                 low = mid + 1;
713             }
714         }
715 
716         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
717         if (low > 0 && array[low - 1] == element) {
718             return low - 1;
719         } else {
720             return low;
721         }
722     }
723 }
724 
725 /**
726  * @title Counters
727  * @author Matt Condon (@shrugs)
728  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
729  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
730  *
731  * Include with `using Counters for Counters.Counter;`
732  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
733  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
734  * directly accessed.
735  */
736 library Counters {
737     using SafeMath for uint256;
738 
739     struct Counter {
740         // This variable should never be directly accessed by users of the library: interactions must be restricted to
741         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
742         // this feature: see https://github.com/ethereum/solidity/issues/4637
743         uint256 _value; // default: 0
744     }
745 
746     function current(Counter storage counter) internal view returns (uint256) {
747         return counter._value;
748     }
749 
750     function increment(Counter storage counter) internal {
751         // The {SafeMath} overflow check can be skipped here, see the comment at the top
752         counter._value += 1;
753     }
754 
755     function decrement(Counter storage counter) internal {
756         counter._value = counter._value.sub(1);
757     }
758 }
759 
760 /**
761  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
762  * total supply at the time are recorded for later access.
763  *
764  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
765  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
766  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
767  * used to create an efficient ERC20 forking mechanism.
768  *
769  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
770  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
771  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
772  * and the account address.
773  *
774  * ==== Gas Costs
775  *
776  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
777  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
778  * smaller since identical balances in subsequent snapshots are stored as a single entry.
779  *
780  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
781  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
782  * transfers will have normal cost until the next snapshot, and so on.
783  */
784 abstract contract ERC20Snapshot is ERC20 {
785     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
786     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
787 
788     using SafeMath for uint256;
789     using Arrays for uint256[];
790     using Counters for Counters.Counter;
791 
792     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
793     // Snapshot struct, but that would impede usage of functions that work on an array.
794     struct Snapshots {
795         uint256[] ids;
796         uint256[] values;
797     }
798 
799     mapping (address => Snapshots) private _accountBalanceSnapshots;
800     Snapshots private _totalSupplySnapshots;
801 
802     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
803     Counters.Counter private _currentSnapshotId;
804 
805     /**
806      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
807      */
808     event Snapshot(uint256 id);
809 
810     /**
811      * @dev Creates a new snapshot and returns its snapshot id.
812      *
813      * Emits a {Snapshot} event that contains the same id.
814      *
815      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
816      * set of accounts, for example using {AccessControl}, or it may be open to the public.
817      *
818      * [WARNING]
819      * ====
820      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
821      * you must consider that it can potentially be used by attackers in two ways.
822      *
823      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
824      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
825      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
826      * section above.
827      *
828      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
829      * ====
830      */
831     function _snapshot() internal virtual returns (uint256) {
832         _currentSnapshotId.increment();
833 
834         uint256 currentId = _currentSnapshotId.current();
835         emit Snapshot(currentId);
836         return currentId;
837     }
838 
839     /**
840      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
841      */
842     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
843         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
844 
845         return snapshotted ? value : balanceOf(account);
846     }
847 
848     /**
849      * @dev Retrieves the total supply at the time `snapshotId` was created.
850      */
851     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
852         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
853 
854         return snapshotted ? value : totalSupply();
855     }
856 
857 
858     // Update balance and/or total supply snapshots before the values are modified. This is implemented
859     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
860     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
861       super._beforeTokenTransfer(from, to, amount);
862 
863       if (from == address(0)) {
864         // mint
865         _updateAccountSnapshot(to);
866         _updateTotalSupplySnapshot();
867       } else if (to == address(0)) {
868         // burn
869         _updateAccountSnapshot(from);
870         _updateTotalSupplySnapshot();
871       } else {
872         // transfer
873         _updateAccountSnapshot(from);
874         _updateAccountSnapshot(to);
875       }
876     }
877 
878     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
879         private view returns (bool, uint256)
880     {
881         require(snapshotId > 0, "ERC20Snapshot: id is 0");
882         // solhint-disable-next-line max-line-length
883         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
884 
885         // When a valid snapshot is queried, there are three possibilities:
886         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
887         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
888         //  to this id is the current one.
889         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
890         //  requested id, and its value is the one to return.
891         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
892         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
893         //  larger than the requested one.
894         //
895         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
896         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
897         // exactly this.
898 
899         uint256 index = snapshots.ids.findUpperBound(snapshotId);
900 
901         if (index == snapshots.ids.length) {
902             return (false, 0);
903         } else {
904             return (true, snapshots.values[index]);
905         }
906     }
907 
908     function _updateAccountSnapshot(address account) private {
909         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
910     }
911 
912     function _updateTotalSupplySnapshot() private {
913         _updateSnapshot(_totalSupplySnapshots, totalSupply());
914     }
915 
916     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
917         uint256 currentId = _currentSnapshotId.current();
918         if (_lastSnapshotId(snapshots.ids) < currentId) {
919             snapshots.ids.push(currentId);
920             snapshots.values.push(currentValue);
921         }
922     }
923 
924     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
925         if (ids.length == 0) {
926             return 0;
927         } else {
928             return ids[ids.length - 1];
929         }
930     }
931 }
932 
933 /**
934  * @title MOI Token
935  * @dev Mitable, Burnable, ERC20 Snapshot Token
936  */
937 contract OA is ERC20Burnable, ERC20Snapshot, Ownable {
938     using SafeMath for uint256;
939 
940     constructor(
941         uint256 _totalSupply,
942         string memory _name,
943         string memory _symbol
944     ) public ERC20(_name, _symbol) {
945         _mint(msg.sender, _totalSupply);
946     }
947 
948     function snapshot() public onlyOwner {
949         _snapshot();
950     }
951 
952     function _beforeTokenTransfer(
953         address from,
954         address to,
955         uint256 amount
956     ) internal virtual override(ERC20, ERC20Snapshot) {
957         super._beforeTokenTransfer(from, to, amount);
958     }
959 }