1 // Sources flattened with hardhat v2.0.10 https://hardhat.org
2 
3 // File contracts/utils/Context.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File contracts/access/Ownable.sol
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 // File contracts/token/ERC20/IERC20.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 
183 // File contracts/token/ERC20/ERC20.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @dev Implementation of the {IERC20} interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using {_mint}.
195  * For a generic mechanism see {ERC20PresetMinterPauser}.
196  *
197  * TIP: For a detailed writeup see our guide
198  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
199  * to implement supply mechanisms].
200  *
201  * We have followed general OpenZeppelin guidelines: functions revert instead
202  * of returning `false` on failure. This behavior is nonetheless conventional
203  * and does not conflict with the expectations of ERC20 applications.
204  *
205  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
206  * This allows applications to reconstruct the allowance for all accounts just
207  * by listening to said events. Other implementations of the EIP may not emit
208  * these events, as it isn't required by the specification.
209  *
210  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
211  * functions have been added to mitigate the well-known issues around setting
212  * allowances. See {IERC20-approve}.
213  */
214 contract ERC20 is Context, IERC20 {
215     mapping (address => uint256) private _balances;
216 
217     mapping (address => mapping (address => uint256)) private _allowances;
218 
219     uint256 private _totalSupply;
220 
221     string private _name;
222     string private _symbol;
223 
224     /**
225      * @dev Sets the values for {name} and {symbol}.
226      *
227      * The defaut value of {decimals} is 18. To select a different value for
228      * {decimals} you should overload it.
229      *
230      * All three of these values are immutable: they can only be set once during
231      * construction.
232      */
233     constructor (string memory name_, string memory symbol_) {
234         _name = name_;
235         _symbol = symbol_;
236     }
237 
238     /**
239      * @dev Returns the name of the token.
240      */
241     function name() public view virtual returns (string memory) {
242         return _name;
243     }
244 
245     /**
246      * @dev Returns the symbol of the token, usually a shorter version of the
247      * name.
248      */
249     function symbol() public view virtual returns (string memory) {
250         return _symbol;
251     }
252 
253     /**
254      * @dev Returns the number of decimals used to get its user representation.
255      * For example, if `decimals` equals `2`, a balance of `505` tokens should
256      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
257      *
258      * Tokens usually opt for a value of 18, imitating the relationship between
259      * Ether and Wei. This is the value {ERC20} uses, unless this function is
260      * overloaded;
261      *
262      * NOTE: This information is only used for _display_ purposes: it in
263      * no way affects any of the arithmetic of the contract, including
264      * {IERC20-balanceOf} and {IERC20-transfer}.
265      */
266     function decimals() public view virtual returns (uint8) {
267         return 18;
268     }
269 
270     /**
271      * @dev See {IERC20-totalSupply}.
272      */
273     function totalSupply() public view virtual override returns (uint256) {
274         return _totalSupply;
275     }
276 
277     /**
278      * @dev See {IERC20-balanceOf}.
279      */
280     function balanceOf(address account) public view virtual override returns (uint256) {
281         return _balances[account];
282     }
283 
284     /**
285      * @dev See {IERC20-transfer}.
286      *
287      * Requirements:
288      *
289      * - `recipient` cannot be the zero address.
290      * - the caller must have a balance of at least `amount`.
291      */
292     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
293         _transfer(_msgSender(), recipient, amount);
294         return true;
295     }
296 
297     /**
298      * @dev See {IERC20-allowance}.
299      */
300     function allowance(address owner, address spender) public view virtual override returns (uint256) {
301         return _allowances[owner][spender];
302     }
303 
304     /**
305      * @dev See {IERC20-approve}.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function approve(address spender, uint256 amount) public virtual override returns (bool) {
312         _approve(_msgSender(), spender, amount);
313         return true;
314     }
315 
316     /**
317      * @dev See {IERC20-transferFrom}.
318      *
319      * Emits an {Approval} event indicating the updated allowance. This is not
320      * required by the EIP. See the note at the beginning of {ERC20}.
321      *
322      * Requirements:
323      *
324      * - `sender` and `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      * - the caller must have allowance for ``sender``'s tokens of at least
327      * `amount`.
328      */
329     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
330         _transfer(sender, recipient, amount);
331 
332         uint256 currentAllowance = _allowances[sender][_msgSender()];
333         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
334         _approve(sender, _msgSender(), currentAllowance - amount);
335 
336         return true;
337     }
338 
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
352         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
353         return true;
354     }
355 
356     /**
357      * @dev Atomically decreases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      * - `spender` must have allowance for the caller of at least
368      * `subtractedValue`.
369      */
370     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
371         uint256 currentAllowance = _allowances[_msgSender()][spender];
372         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
373         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
374 
375         return true;
376     }
377 
378     /**
379      * @dev Moves tokens `amount` from `sender` to `recipient`.
380      *
381      * This is internal function is equivalent to {transfer}, and can be used to
382      * e.g. implement automatic token fees, slashing mechanisms, etc.
383      *
384      * Emits a {Transfer} event.
385      *
386      * Requirements:
387      *
388      * - `sender` cannot be the zero address.
389      * - `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      */
392     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
393         require(sender != address(0), "ERC20: transfer from the zero address");
394         require(recipient != address(0), "ERC20: transfer to the zero address");
395 
396         _beforeTokenTransfer(sender, recipient, amount);
397 
398         uint256 senderBalance = _balances[sender];
399         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
400         _balances[sender] = senderBalance - amount;
401         _balances[recipient] += amount;
402 
403         emit Transfer(sender, recipient, amount);
404     }
405 
406     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
407      * the total supply.
408      *
409      * Emits a {Transfer} event with `from` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `to` cannot be the zero address.
414      */
415     function _mint(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: mint to the zero address");
417 
418         _beforeTokenTransfer(address(0), account, amount);
419 
420         _totalSupply += amount;
421         _balances[account] += amount;
422         emit Transfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _beforeTokenTransfer(account, address(0), amount);
440 
441         uint256 accountBalance = _balances[account];
442         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
443         _balances[account] = accountBalance - amount;
444         _totalSupply -= amount;
445 
446         emit Transfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
451      *
452      * This internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(address owner, address spender, uint256 amount) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be to transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
485 }
486 
487 
488 // File contracts/math/SafeMath.sol
489 
490 
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @dev Wrappers over Solidity's arithmetic operations.
496  */
497 library SafeMath {
498     /**
499      * @dev Returns the addition of two unsigned integers, with an overflow flag.
500      *
501      * _Available since v3.4._
502      */
503     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
504         unchecked {
505             uint256 c = a + b;
506             if (c < a) return (false, 0);
507             return (true, c);
508         }
509     }
510 
511     /**
512      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
513      *
514      * _Available since v3.4._
515      */
516     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
517         unchecked {
518             if (b > a) return (false, 0);
519             return (true, a - b);
520         }
521     }
522 
523     /**
524      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
525      *
526      * _Available since v3.4._
527      */
528     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
529         unchecked {
530             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531             // benefit is lost if 'b' is also tested.
532             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533             if (a == 0) return (true, 0);
534             uint256 c = a * b;
535             if (c / a != b) return (false, 0);
536             return (true, c);
537         }
538     }
539 
540     /**
541      * @dev Returns the division of two unsigned integers, with a division by zero flag.
542      *
543      * _Available since v3.4._
544      */
545     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
546         unchecked {
547             if (b == 0) return (false, 0);
548             return (true, a / b);
549         }
550     }
551 
552     /**
553      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             if (b == 0) return (false, 0);
560             return (true, a % b);
561         }
562     }
563 
564     /**
565      * @dev Returns the addition of two unsigned integers, reverting on
566      * overflow.
567      *
568      * Counterpart to Solidity's `+` operator.
569      *
570      * Requirements:
571      *
572      * - Addition cannot overflow.
573      */
574     function add(uint256 a, uint256 b) internal pure returns (uint256) {
575         return a + b;
576     }
577 
578     /**
579      * @dev Returns the subtraction of two unsigned integers, reverting on
580      * overflow (when the result is negative).
581      *
582      * Counterpart to Solidity's `-` operator.
583      *
584      * Requirements:
585      *
586      * - Subtraction cannot overflow.
587      */
588     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
589         return a - b;
590     }
591 
592     /**
593      * @dev Returns the multiplication of two unsigned integers, reverting on
594      * overflow.
595      *
596      * Counterpart to Solidity's `*` operator.
597      *
598      * Requirements:
599      *
600      * - Multiplication cannot overflow.
601      */
602     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
603         return a * b;
604     }
605 
606     /**
607      * @dev Returns the integer division of two unsigned integers, reverting on
608      * division by zero. The result is rounded towards zero.
609      *
610      * Counterpart to Solidity's `/` operator.
611      *
612      * Requirements:
613      *
614      * - The divisor cannot be zero.
615      */
616     function div(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a / b;
618     }
619 
620     /**
621      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
622      * reverting when dividing by zero.
623      *
624      * Counterpart to Solidity's `%` operator. This function uses a `revert`
625      * opcode (which leaves remaining gas untouched) while Solidity uses an
626      * invalid opcode to revert (consuming all remaining gas).
627      *
628      * Requirements:
629      *
630      * - The divisor cannot be zero.
631      */
632     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a % b;
634     }
635 
636     /**
637      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
638      * overflow (when the result is negative).
639      *
640      * CAUTION: This function is deprecated because it requires allocating memory for the error
641      * message unnecessarily. For custom revert reasons use {trySub}.
642      *
643      * Counterpart to Solidity's `-` operator.
644      *
645      * Requirements:
646      *
647      * - Subtraction cannot overflow.
648      */
649     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         unchecked {
651             require(b <= a, errorMessage);
652             return a - b;
653         }
654     }
655 
656     /**
657      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
658      * division by zero. The result is rounded towards zero.
659      *
660      * Counterpart to Solidity's `%` operator. This function uses a `revert`
661      * opcode (which leaves remaining gas untouched) while Solidity uses an
662      * invalid opcode to revert (consuming all remaining gas).
663      *
664      * Counterpart to Solidity's `/` operator. Note: this function uses a
665      * `revert` opcode (which leaves remaining gas untouched) while Solidity
666      * uses an invalid opcode to revert (consuming all remaining gas).
667      *
668      * Requirements:
669      *
670      * - The divisor cannot be zero.
671      */
672     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
673         unchecked {
674             require(b > 0, errorMessage);
675             return a / b;
676         }
677     }
678 
679     /**
680      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
681      * reverting with custom message when dividing by zero.
682      *
683      * CAUTION: This function is deprecated because it requires allocating memory for the error
684      * message unnecessarily. For custom revert reasons use {tryMod}.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         unchecked {
696             require(b > 0, errorMessage);
697             return a % b;
698         }
699     }
700 }
701 
702 
703 // File contracts/math/Math.sol
704 
705 
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev Standard math utilities missing in the Solidity language.
711  */
712 library Math {
713     /**
714      * @dev Returns the largest of two numbers.
715      */
716     function max(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a >= b ? a : b;
718     }
719 
720     /**
721      * @dev Returns the smallest of two numbers.
722      */
723     function min(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a < b ? a : b;
725     }
726 
727     /**
728      * @dev Returns the average of two numbers. The result is rounded towards
729      * zero.
730      */
731     function average(uint256 a, uint256 b) internal pure returns (uint256) {
732         // (a + b) / 2 can overflow, so we distribute
733         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
734     }
735 }
736 
737 
738 // File contracts/utils/Arrays.sol
739 
740 
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @dev Collection of functions related to array types.
746  */
747 library Arrays {
748     /**
749      * @dev Searches a sorted `array` and returns the first index that contains
750      * a value greater or equal to `element`. If no such index exists (i.e. all
751      * values in the array are strictly less than `element`), the array length is
752      * returned. Time complexity O(log n).
753      *
754      * `array` is expected to be sorted in ascending order, and to contain no
755      * repeated elements.
756      */
757     function findUpperBound(uint256[] storage array, uint256 element)
758         internal
759         view
760         returns (uint256)
761     {
762         if (array.length == 0) {
763             return 0;
764         }
765 
766         uint256 low = 0;
767         uint256 high = array.length;
768 
769         while (low < high) {
770             uint256 mid = Math.average(low, high);
771 
772             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
773             // because Math.average rounds down (it does integer division with truncation).
774             if (array[mid] > element) {
775                 high = mid;
776             } else {
777                 low = mid + 1;
778             }
779         }
780 
781         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
782         if (low > 0 && array[low - 1] == element) {
783             return low - 1;
784         } else {
785             return low;
786         }
787     }
788 }
789 
790 
791 // File hardhat/console.sol@v2.0.10
792 
793 pragma solidity >= 0.4.22 <0.9.0;
794 
795 library console {
796 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
797 
798 	function _sendLogPayload(bytes memory payload) private view {
799 		uint256 payloadLength = payload.length;
800 		address consoleAddress = CONSOLE_ADDRESS;
801 		assembly {
802 			let payloadStart := add(payload, 32)
803 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
804 		}
805 	}
806 
807 	function log() internal view {
808 		_sendLogPayload(abi.encodeWithSignature("log()"));
809 	}
810 
811 	function logInt(int p0) internal view {
812 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
813 	}
814 
815 	function logUint(uint p0) internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
817 	}
818 
819 	function logString(string memory p0) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
821 	}
822 
823 	function logBool(bool p0) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
825 	}
826 
827 	function logAddress(address p0) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
829 	}
830 
831 	function logBytes(bytes memory p0) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
833 	}
834 
835 	function logBytes1(bytes1 p0) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
837 	}
838 
839 	function logBytes2(bytes2 p0) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
841 	}
842 
843 	function logBytes3(bytes3 p0) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
845 	}
846 
847 	function logBytes4(bytes4 p0) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
849 	}
850 
851 	function logBytes5(bytes5 p0) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
853 	}
854 
855 	function logBytes6(bytes6 p0) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
857 	}
858 
859 	function logBytes7(bytes7 p0) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
861 	}
862 
863 	function logBytes8(bytes8 p0) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
865 	}
866 
867 	function logBytes9(bytes9 p0) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
869 	}
870 
871 	function logBytes10(bytes10 p0) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
873 	}
874 
875 	function logBytes11(bytes11 p0) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
877 	}
878 
879 	function logBytes12(bytes12 p0) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
881 	}
882 
883 	function logBytes13(bytes13 p0) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
885 	}
886 
887 	function logBytes14(bytes14 p0) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
889 	}
890 
891 	function logBytes15(bytes15 p0) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
893 	}
894 
895 	function logBytes16(bytes16 p0) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
897 	}
898 
899 	function logBytes17(bytes17 p0) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
901 	}
902 
903 	function logBytes18(bytes18 p0) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
905 	}
906 
907 	function logBytes19(bytes19 p0) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
909 	}
910 
911 	function logBytes20(bytes20 p0) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
913 	}
914 
915 	function logBytes21(bytes21 p0) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
917 	}
918 
919 	function logBytes22(bytes22 p0) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
921 	}
922 
923 	function logBytes23(bytes23 p0) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
925 	}
926 
927 	function logBytes24(bytes24 p0) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
929 	}
930 
931 	function logBytes25(bytes25 p0) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
933 	}
934 
935 	function logBytes26(bytes26 p0) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
937 	}
938 
939 	function logBytes27(bytes27 p0) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
941 	}
942 
943 	function logBytes28(bytes28 p0) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
945 	}
946 
947 	function logBytes29(bytes29 p0) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
949 	}
950 
951 	function logBytes30(bytes30 p0) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
953 	}
954 
955 	function logBytes31(bytes31 p0) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
957 	}
958 
959 	function logBytes32(bytes32 p0) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
961 	}
962 
963 	function log(uint p0) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
965 	}
966 
967 	function log(string memory p0) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
969 	}
970 
971 	function log(bool p0) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
973 	}
974 
975 	function log(address p0) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
977 	}
978 
979 	function log(uint p0, uint p1) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
981 	}
982 
983 	function log(uint p0, string memory p1) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
985 	}
986 
987 	function log(uint p0, bool p1) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
989 	}
990 
991 	function log(uint p0, address p1) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
993 	}
994 
995 	function log(string memory p0, uint p1) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
997 	}
998 
999 	function log(string memory p0, string memory p1) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1001 	}
1002 
1003 	function log(string memory p0, bool p1) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1005 	}
1006 
1007 	function log(string memory p0, address p1) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1009 	}
1010 
1011 	function log(bool p0, uint p1) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1013 	}
1014 
1015 	function log(bool p0, string memory p1) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1017 	}
1018 
1019 	function log(bool p0, bool p1) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1021 	}
1022 
1023 	function log(bool p0, address p1) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1025 	}
1026 
1027 	function log(address p0, uint p1) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1029 	}
1030 
1031 	function log(address p0, string memory p1) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1033 	}
1034 
1035 	function log(address p0, bool p1) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1037 	}
1038 
1039 	function log(address p0, address p1) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1041 	}
1042 
1043 	function log(uint p0, uint p1, uint p2) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1045 	}
1046 
1047 	function log(uint p0, uint p1, string memory p2) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1049 	}
1050 
1051 	function log(uint p0, uint p1, bool p2) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1053 	}
1054 
1055 	function log(uint p0, uint p1, address p2) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1057 	}
1058 
1059 	function log(uint p0, string memory p1, uint p2) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1061 	}
1062 
1063 	function log(uint p0, string memory p1, string memory p2) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1065 	}
1066 
1067 	function log(uint p0, string memory p1, bool p2) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1069 	}
1070 
1071 	function log(uint p0, string memory p1, address p2) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1073 	}
1074 
1075 	function log(uint p0, bool p1, uint p2) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1077 	}
1078 
1079 	function log(uint p0, bool p1, string memory p2) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1081 	}
1082 
1083 	function log(uint p0, bool p1, bool p2) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1085 	}
1086 
1087 	function log(uint p0, bool p1, address p2) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1089 	}
1090 
1091 	function log(uint p0, address p1, uint p2) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1093 	}
1094 
1095 	function log(uint p0, address p1, string memory p2) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1097 	}
1098 
1099 	function log(uint p0, address p1, bool p2) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1101 	}
1102 
1103 	function log(uint p0, address p1, address p2) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1105 	}
1106 
1107 	function log(string memory p0, uint p1, uint p2) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1109 	}
1110 
1111 	function log(string memory p0, uint p1, string memory p2) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1113 	}
1114 
1115 	function log(string memory p0, uint p1, bool p2) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1117 	}
1118 
1119 	function log(string memory p0, uint p1, address p2) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1121 	}
1122 
1123 	function log(string memory p0, string memory p1, uint p2) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1125 	}
1126 
1127 	function log(string memory p0, string memory p1, string memory p2) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1129 	}
1130 
1131 	function log(string memory p0, string memory p1, bool p2) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1133 	}
1134 
1135 	function log(string memory p0, string memory p1, address p2) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1137 	}
1138 
1139 	function log(string memory p0, bool p1, uint p2) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1141 	}
1142 
1143 	function log(string memory p0, bool p1, string memory p2) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1145 	}
1146 
1147 	function log(string memory p0, bool p1, bool p2) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1149 	}
1150 
1151 	function log(string memory p0, bool p1, address p2) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1153 	}
1154 
1155 	function log(string memory p0, address p1, uint p2) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1157 	}
1158 
1159 	function log(string memory p0, address p1, string memory p2) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1161 	}
1162 
1163 	function log(string memory p0, address p1, bool p2) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1165 	}
1166 
1167 	function log(string memory p0, address p1, address p2) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1169 	}
1170 
1171 	function log(bool p0, uint p1, uint p2) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1173 	}
1174 
1175 	function log(bool p0, uint p1, string memory p2) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1177 	}
1178 
1179 	function log(bool p0, uint p1, bool p2) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1181 	}
1182 
1183 	function log(bool p0, uint p1, address p2) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1185 	}
1186 
1187 	function log(bool p0, string memory p1, uint p2) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1189 	}
1190 
1191 	function log(bool p0, string memory p1, string memory p2) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1193 	}
1194 
1195 	function log(bool p0, string memory p1, bool p2) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1197 	}
1198 
1199 	function log(bool p0, string memory p1, address p2) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1201 	}
1202 
1203 	function log(bool p0, bool p1, uint p2) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1205 	}
1206 
1207 	function log(bool p0, bool p1, string memory p2) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1209 	}
1210 
1211 	function log(bool p0, bool p1, bool p2) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1213 	}
1214 
1215 	function log(bool p0, bool p1, address p2) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1217 	}
1218 
1219 	function log(bool p0, address p1, uint p2) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1221 	}
1222 
1223 	function log(bool p0, address p1, string memory p2) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1225 	}
1226 
1227 	function log(bool p0, address p1, bool p2) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1229 	}
1230 
1231 	function log(bool p0, address p1, address p2) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1233 	}
1234 
1235 	function log(address p0, uint p1, uint p2) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1237 	}
1238 
1239 	function log(address p0, uint p1, string memory p2) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1241 	}
1242 
1243 	function log(address p0, uint p1, bool p2) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1245 	}
1246 
1247 	function log(address p0, uint p1, address p2) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1249 	}
1250 
1251 	function log(address p0, string memory p1, uint p2) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1253 	}
1254 
1255 	function log(address p0, string memory p1, string memory p2) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1257 	}
1258 
1259 	function log(address p0, string memory p1, bool p2) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1261 	}
1262 
1263 	function log(address p0, string memory p1, address p2) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1265 	}
1266 
1267 	function log(address p0, bool p1, uint p2) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1269 	}
1270 
1271 	function log(address p0, bool p1, string memory p2) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1273 	}
1274 
1275 	function log(address p0, bool p1, bool p2) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1277 	}
1278 
1279 	function log(address p0, bool p1, address p2) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1281 	}
1282 
1283 	function log(address p0, address p1, uint p2) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1285 	}
1286 
1287 	function log(address p0, address p1, string memory p2) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1289 	}
1290 
1291 	function log(address p0, address p1, bool p2) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1293 	}
1294 
1295 	function log(address p0, address p1, address p2) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1297 	}
1298 
1299 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1301 	}
1302 
1303 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1305 	}
1306 
1307 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(uint p0, uint p1, address p2, address p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(uint p0, bool p1, address p2, address p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(uint p0, address p1, uint p2, address p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(uint p0, address p1, bool p2, address p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(uint p0, address p1, address p2, uint p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(uint p0, address p1, address p2, bool p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(uint p0, address p1, address p2, address p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1557 	}
1558 
1559 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1561 	}
1562 
1563 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1565 	}
1566 
1567 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1569 	}
1570 
1571 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1573 	}
1574 
1575 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1577 	}
1578 
1579 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1581 	}
1582 
1583 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1585 	}
1586 
1587 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1589 	}
1590 
1591 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1593 	}
1594 
1595 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1597 	}
1598 
1599 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1601 	}
1602 
1603 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1605 	}
1606 
1607 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1609 	}
1610 
1611 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1613 	}
1614 
1615 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1617 	}
1618 
1619 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1621 	}
1622 
1623 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1625 	}
1626 
1627 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1629 	}
1630 
1631 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1633 	}
1634 
1635 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1637 	}
1638 
1639 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1641 	}
1642 
1643 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1645 	}
1646 
1647 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1649 	}
1650 
1651 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1653 	}
1654 
1655 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1657 	}
1658 
1659 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1661 	}
1662 
1663 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1665 	}
1666 
1667 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1669 	}
1670 
1671 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1673 	}
1674 
1675 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1677 	}
1678 
1679 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1681 	}
1682 
1683 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1685 	}
1686 
1687 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1689 	}
1690 
1691 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1693 	}
1694 
1695 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1697 	}
1698 
1699 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1701 	}
1702 
1703 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1705 	}
1706 
1707 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1709 	}
1710 
1711 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1713 	}
1714 
1715 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1717 	}
1718 
1719 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1721 	}
1722 
1723 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1725 	}
1726 
1727 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1729 	}
1730 
1731 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1733 	}
1734 
1735 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1737 	}
1738 
1739 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1741 	}
1742 
1743 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1745 	}
1746 
1747 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1749 	}
1750 
1751 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1753 	}
1754 
1755 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1757 	}
1758 
1759 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1761 	}
1762 
1763 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1765 	}
1766 
1767 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1769 	}
1770 
1771 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1773 	}
1774 
1775 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1777 	}
1778 
1779 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1781 	}
1782 
1783 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1785 	}
1786 
1787 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1789 	}
1790 
1791 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1793 	}
1794 
1795 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1797 	}
1798 
1799 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1801 	}
1802 
1803 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1805 	}
1806 
1807 	function log(string memory p0, address p1, address p2, address p3) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1809 	}
1810 
1811 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1813 	}
1814 
1815 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(bool p0, uint p1, address p2, address p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(bool p0, bool p1, address p2, address p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(bool p0, address p1, uint p2, address p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(bool p0, address p1, bool p2, address p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(bool p0, address p1, address p2, uint p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(bool p0, address p1, address p2, bool p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(bool p0, address p1, address p2, address p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(address p0, uint p1, uint p2, address p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(address p0, uint p1, bool p2, address p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(address p0, uint p1, address p2, uint p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(address p0, uint p1, address p2, bool p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(address p0, uint p1, address p2, address p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(address p0, string memory p1, address p2, address p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(address p0, bool p1, uint p2, address p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(address p0, bool p1, bool p2, address p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(address p0, bool p1, address p2, uint p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(address p0, bool p1, address p2, bool p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(address p0, bool p1, address p2, address p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(address p0, address p1, uint p2, uint p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(address p0, address p1, uint p2, bool p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(address p0, address p1, uint p2, address p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(address p0, address p1, string memory p2, address p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(address p0, address p1, bool p2, uint p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(address p0, address p1, bool p2, bool p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(address p0, address p1, bool p2, address p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(address p0, address p1, address p2, uint p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(address p0, address p1, address p2, string memory p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(address p0, address p1, address p2, bool p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(address p0, address p1, address p2, address p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2321 	}
2322 
2323 }
2324 
2325 
2326 // File contracts/ERC20Vested.sol
2327 
2328 pragma solidity ^0.8.1;
2329 
2330 
2331 
2332 
2333 
2334 contract ERC20Vested is ERC20, Ownable {
2335     event Vesting(address indexed recipient, uint256 value, uint256 startDate);
2336 
2337     uint256 constant BASIS_POINT_DIVISOR = 10000;
2338 
2339     struct vesting {
2340         uint256 amount;
2341         uint256 startDate;
2342     }
2343 
2344     /**
2345      * @dev Since Solidity 0.8.0 reverting on overflow is the default but
2346      * let's keep SafeMath nevertheless in case someone messes with the compiler version.
2347      */
2348     using SafeMath for uint256;
2349 
2350     using Arrays for uint256[];
2351 
2352     uint256[] private _vestingDays;
2353 
2354     uint256[] private _vestingBasisPoints;
2355 
2356     mapping(address => vesting) private _vesting;
2357 
2358     constructor(
2359         string memory name,
2360         string memory symbol,
2361         uint256 totalSupply,
2362         uint256[] memory vestingDays,
2363         uint256[] memory vestingBasisPoints
2364     ) payable Ownable() ERC20(name, symbol) {
2365         require(
2366             vestingDays.length == vestingBasisPoints.length,
2367             "ERC20Vested: Date array and basis points array have different lengths."
2368         );
2369         _mint(owner(), totalSupply);
2370         _vestingDays = vestingDays;
2371         _vestingBasisPoints = vestingBasisPoints;
2372     }
2373 
2374     function _hasVesting(address account) private view returns (bool) {
2375         return _vesting[account].amount > 0;
2376     }
2377 
2378     function transferOwnership(address newOwner)
2379         public
2380         virtual
2381         override
2382         onlyOwner
2383     {
2384         require(
2385             !_hasVesting(newOwner),
2386             "ERC20Vested: New owner must not have vesting."
2387         );
2388         super.transferOwnership(newOwner);
2389         transfer(newOwner, balanceOf(_msgSender()));
2390     }
2391 
2392     function today() public view virtual returns (uint128) {
2393         return uint128(block.timestamp);
2394     }
2395 
2396     function transferVested(
2397         address recipient,
2398         uint256 amount,
2399         uint256 startDate
2400     ) public onlyOwner {
2401         address owner = owner();
2402         require(
2403             recipient != owner,
2404             "ERC20Vested: Owner must not have vesting."
2405         );
2406         require(
2407             amount > 0,
2408             "ERC20Vested: Amount vested must be larger than 0."
2409         );
2410         require(
2411             !_hasVesting(recipient),
2412             "ERC20Vested: Recipient already has vesting."
2413         );
2414         _vesting[recipient] = vesting(amount, startDate);
2415         emit Vesting(recipient, amount, startDate);
2416         _transfer(owner, recipient, amount);
2417     }
2418 
2419     function _amountAvailable(address from) internal view returns (uint256) {
2420         vesting memory vested = _vesting[from];
2421         uint256 totalBalance = _totalBalanceOf(from);
2422         if (vested.amount > 0) {
2423             // vesting applies
2424             uint256 vestingIndex =
2425                 _vestingDays.findUpperBound(today() - vested.startDate);
2426 
2427             if (vestingIndex < _vestingDays.length) {
2428                 // still in vesting phase
2429                 uint256 vestingBasisPoints = _vestingBasisPoints[vestingIndex];
2430                 uint256 maxAmountAvailable =
2431                     vested.amount.mul(vestingBasisPoints).div(
2432                         BASIS_POINT_DIVISOR
2433                     );
2434                 uint256 remainingVestedAmount =
2435                     vested.amount.sub(maxAmountAvailable);
2436                 return totalBalance.sub(remainingVestedAmount);
2437             } else {
2438                 return totalBalance;
2439             }
2440         } else {
2441             return totalBalance;
2442         }
2443     }
2444 
2445     function totalBalanceOf(address account) public view returns (uint256) {
2446         return _totalBalanceOf(account);
2447     }
2448 
2449     function _totalBalanceOf(address account)
2450         internal
2451         view
2452         virtual
2453         returns (uint256)
2454     {
2455         return super.balanceOf(account);
2456     }
2457 
2458     function balanceOf(address account)
2459         public
2460         view
2461         virtual
2462         override
2463         returns (uint256)
2464     {
2465         return _amountAvailable(account);
2466     }
2467 
2468     function _beforeTokenTransfer(
2469         address from,
2470         address to,
2471         uint256 amount
2472     ) internal virtual override {
2473         super._beforeTokenTransfer(from, to, amount);
2474 
2475         if (from == address(0)) {
2476             // When minting tokens
2477             require(
2478                 owner() == _msgSender(),
2479                 "ERC20Vested: Only owner is allowed to mint tokens."
2480             );
2481         } else {
2482             uint256 amountAvailable = _amountAvailable(from);
2483             require(
2484                 amountAvailable >= amount,
2485                 "ERC20Vested: Amount exceeds amount available"
2486             );
2487         }
2488     }
2489 }
2490 
2491 
2492 // File contracts/ERC20VestedView.sol
2493 
2494 
2495 pragma solidity ^0.8.1;
2496 
2497 
2498 
2499 
2500 
2501 
2502 contract ERC20VestedView is ERC20 {
2503     ERC20Vested private _vestingContract;
2504 
2505     constructor(
2506         string memory name,
2507         string memory symbol,
2508         uint256 totalSupply,
2509         ERC20Vested vestingContract
2510     ) payable ERC20(name, symbol) {
2511         _vestingContract = vestingContract;
2512         _mint(_msgSender(), totalSupply);
2513     }
2514 
2515     function balanceOf(address account)
2516         public
2517         view
2518         virtual
2519         override
2520         returns (uint256)
2521     {
2522         return _vestingContract.totalBalanceOf(account);
2523     }
2524 
2525     function transfer(address recipient, uint256 amount)
2526         public
2527         pure
2528         override
2529         returns (bool)
2530     {
2531         revert();
2532     }
2533 
2534     function allowance(address owner, address spender)
2535         public
2536         pure
2537         override
2538         returns (uint256)
2539     {
2540         return 0;
2541     }
2542 
2543     function approve(address spender, uint256 amount)
2544         public
2545         pure
2546         override
2547         returns (bool)
2548     {
2549         revert();
2550     }
2551 
2552     function transferFrom(
2553         address sender,
2554         address recipient,
2555         uint256 amount
2556     ) public pure override returns (bool) {
2557         revert();
2558     }
2559 }
2560 
2561 
2562 // File contracts/math/SignedSafeMath.sol
2563 
2564 
2565 
2566 pragma solidity ^0.8.0;
2567 
2568 /**
2569  * @title SignedSafeMath
2570  * @dev Signed math operations that revert on error.
2571  */
2572 library SignedSafeMath {
2573     /**
2574      * @dev Returns the multiplication of two signed integers, reverting on
2575      * overflow.
2576      *
2577      * Counterpart to Solidity's `*` operator.
2578      *
2579      * Requirements:
2580      *
2581      * - Multiplication cannot overflow.
2582      */
2583     function mul(int256 a, int256 b) internal pure returns (int256) {
2584         return a * b;
2585     }
2586 
2587     /**
2588      * @dev Returns the integer division of two signed integers. Reverts on
2589      * division by zero. The result is rounded towards zero.
2590      *
2591      * Counterpart to Solidity's `/` operator.
2592      *
2593      * Requirements:
2594      *
2595      * - The divisor cannot be zero.
2596      */
2597     function div(int256 a, int256 b) internal pure returns (int256) {
2598         return a / b;
2599     }
2600 
2601     /**
2602      * @dev Returns the subtraction of two signed integers, reverting on
2603      * overflow.
2604      *
2605      * Counterpart to Solidity's `-` operator.
2606      *
2607      * Requirements:
2608      *
2609      * - Subtraction cannot overflow.
2610      */
2611     function sub(int256 a, int256 b) internal pure returns (int256) {
2612         return a - b;
2613     }
2614 
2615     /**
2616      * @dev Returns the addition of two signed integers, reverting on
2617      * overflow.
2618      *
2619      * Counterpart to Solidity's `+` operator.
2620      *
2621      * Requirements:
2622      *
2623      * - Addition cannot overflow.
2624      */
2625     function add(int256 a, int256 b) internal pure returns (int256) {
2626         return a + b;
2627     }
2628 }