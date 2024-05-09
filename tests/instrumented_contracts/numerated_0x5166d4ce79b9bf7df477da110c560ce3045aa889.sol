1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
99 
100 
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 
181 
182 pragma solidity >=0.6.0 <0.8.0;
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a, "SafeMath: addition overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         uint256 c = a - b;
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `*` operator.
251      *
252      * Requirements:
253      *
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b != 0, errorMessage);
336         return a % b;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
341 
342 
343 
344 pragma solidity >=0.6.0 <0.8.0;
345 
346 
347 
348 
349 /**
350  * @dev Implementation of the {IERC20} interface.
351  *
352  * This implementation is agnostic to the way tokens are created. This means
353  * that a supply mechanism has to be added in a derived contract using {_mint}.
354  * For a generic mechanism see {ERC20PresetMinterPauser}.
355  *
356  * TIP: For a detailed writeup see our guide
357  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
358  * to implement supply mechanisms].
359  *
360  * We have followed general OpenZeppelin guidelines: functions revert instead
361  * of returning `false` on failure. This behavior is nonetheless conventional
362  * and does not conflict with the expectations of ERC20 applications.
363  *
364  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
365  * This allows applications to reconstruct the allowance for all accounts just
366  * by listening to said events. Other implementations of the EIP may not emit
367  * these events, as it isn't required by the specification.
368  *
369  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
370  * functions have been added to mitigate the well-known issues around setting
371  * allowances. See {IERC20-approve}.
372  */
373 contract ERC20 is Context, IERC20 {
374     using SafeMath for uint256;
375 
376     mapping (address => uint256) private _balances;
377 
378     mapping (address => mapping (address => uint256)) private _allowances;
379 
380     uint256 private _totalSupply;
381 
382     string private _name;
383     string private _symbol;
384     uint8 private _decimals;
385 
386     /**
387      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
388      * a default value of 18.
389      *
390      * To select a different value for {decimals}, use {_setupDecimals}.
391      *
392      * All three of these values are immutable: they can only be set once during
393      * construction.
394      */
395     constructor (string memory name_, string memory symbol_) public {
396         _name = name_;
397         _symbol = symbol_;
398         _decimals = 18;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
423      * called.
424      *
425      * NOTE: This information is only used for _display_ purposes: it in
426      * no way affects any of the arithmetic of the contract, including
427      * {IERC20-balanceOf} and {IERC20-transfer}.
428      */
429     function decimals() public view returns (uint8) {
430         return _decimals;
431     }
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view virtual override returns (uint256) {
437         return _totalSupply;
438     }
439 
440     /**
441      * @dev See {IERC20-balanceOf}.
442      */
443     function balanceOf(address account) public view virtual override returns (uint256) {
444         return _balances[account];
445     }
446 
447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `recipient` cannot be the zero address.
453      * - the caller must have a balance of at least `amount`.
454      */
455     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
456         _transfer(_msgSender(), recipient, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-allowance}.
462      */
463     function allowance(address owner, address spender) public view virtual override returns (uint256) {
464         return _allowances[owner][spender];
465     }
466 
467     /**
468      * @dev See {IERC20-approve}.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function approve(address spender, uint256 amount) public virtual override returns (bool) {
475         _approve(_msgSender(), spender, amount);
476         return true;
477     }
478 
479     /**
480      * @dev See {IERC20-transferFrom}.
481      *
482      * Emits an {Approval} event indicating the updated allowance. This is not
483      * required by the EIP. See the note at the beginning of {ERC20}.
484      *
485      * Requirements:
486      *
487      * - `sender` and `recipient` cannot be the zero address.
488      * - `sender` must have a balance of at least `amount`.
489      * - the caller must have allowance for ``sender``'s tokens of at least
490      * `amount`.
491      */
492     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
493         _transfer(sender, recipient, amount);
494         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically increases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      */
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514 
515     /**
516      * @dev Atomically decreases the allowance granted to `spender` by the caller.
517      *
518      * This is an alternative to {approve} that can be used as a mitigation for
519      * problems described in {IERC20-approve}.
520      *
521      * Emits an {Approval} event indicating the updated allowance.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      * - `spender` must have allowance for the caller of at least
527      * `subtractedValue`.
528      */
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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
554         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
555         _balances[recipient] = _balances[recipient].add(amount);
556         emit Transfer(sender, recipient, amount);
557     }
558 
559     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
560      * the total supply.
561      *
562      * Emits a {Transfer} event with `from` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `to` cannot be the zero address.
567      */
568     function _mint(address account, uint256 amount) internal virtual {
569         require(account != address(0), "ERC20: mint to the zero address");
570 
571         _beforeTokenTransfer(address(0), account, amount);
572 
573         _totalSupply = _totalSupply.add(amount);
574         _balances[account] = _balances[account].add(amount);
575         emit Transfer(address(0), account, amount);
576     }
577 
578     /**
579      * @dev Destroys `amount` tokens from `account`, reducing the
580      * total supply.
581      *
582      * Emits a {Transfer} event with `to` set to the zero address.
583      *
584      * Requirements:
585      *
586      * - `account` cannot be the zero address.
587      * - `account` must have at least `amount` tokens.
588      */
589     function _burn(address account, uint256 amount) internal virtual {
590         require(account != address(0), "ERC20: burn from the zero address");
591 
592         _beforeTokenTransfer(account, address(0), amount);
593 
594         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
595         _totalSupply = _totalSupply.sub(amount);
596         emit Transfer(account, address(0), amount);
597     }
598 
599     /**
600      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
601      *
602      * This internal function is equivalent to `approve`, and can be used to
603      * e.g. set automatic allowances for certain subsystems, etc.
604      *
605      * Emits an {Approval} event.
606      *
607      * Requirements:
608      *
609      * - `owner` cannot be the zero address.
610      * - `spender` cannot be the zero address.
611      */
612     function _approve(address owner, address spender, uint256 amount) internal virtual {
613         require(owner != address(0), "ERC20: approve from the zero address");
614         require(spender != address(0), "ERC20: approve to the zero address");
615 
616         _allowances[owner][spender] = amount;
617         emit Approval(owner, spender, amount);
618     }
619 
620     /**
621      * @dev Sets {decimals} to a value other than the default one of 18.
622      *
623      * WARNING: This function should only be called from the constructor. Most
624      * applications that interact with token contracts will not expect
625      * {decimals} to ever change, and may work incorrectly if it does.
626      */
627     function _setupDecimals(uint8 decimals_) internal {
628         _decimals = decimals_;
629     }
630 
631     /**
632      * @dev Hook that is called before any transfer of tokens. This includes
633      * minting and burning.
634      *
635      * Calling conditions:
636      *
637      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
638      * will be to transferred to `to`.
639      * - when `from` is zero, `amount` tokens will be minted for `to`.
640      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
646 }
647 
648 // File: contracts/lib/SafeMathInt.sol
649 
650 /*
651 MIT License
652 
653 Copyright (c) 2018 requestnetwork
654 Copyright (c) 2018 Fragments, Inc.
655 Copyright (c) 2020 Base Protocol, Inc.
656 
657 Permission is hereby granted, free of charge, to any person obtaining a copy
658 of this software and associated documentation files (the "Software"), to deal
659 in the Software without restriction, including without limitation the rights
660 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
661 copies of the Software, and to permit persons to whom the Software is
662 furnished to do so, subject to the following conditions:
663 
664 The above copyright notice and this permission notice shall be included in all
665 copies or substantial portions of the Software.
666 
667 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
668 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
669 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
670 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
671 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
672 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
673 SOFTWARE.
674 */
675 
676 pragma solidity 0.6.12;
677 
678 
679 /**
680  * @title SafeMathInt
681  * @dev Math operations for int256 with overflow safety checks.
682  */
683 library SafeMathInt {
684     int256 private constant MIN_INT256 = int256(1) << 255;
685     int256 private constant MAX_INT256 = ~(int256(1) << 255);
686 
687     /**
688      * @dev Multiplies two int256 variables and fails on overflow.
689      */
690     function mul(int256 a, int256 b)
691         internal
692         pure
693         returns (int256)
694     {
695         int256 c = a * b;
696 
697         // Detect overflow when multiplying MIN_INT256 with -1
698         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
699         require((b == 0) || (c / b == a));
700         return c;
701     }
702 
703     /**
704      * @dev Division of two int256 variables and fails on overflow.
705      */
706     function div(int256 a, int256 b)
707         internal
708         pure
709         returns (int256)
710     {
711         // Prevent overflow when dividing MIN_INT256 by -1
712         require(b != -1 || a != MIN_INT256);
713 
714         // Solidity already throws when dividing by 0.
715         return a / b;
716     }
717 
718     /**
719      * @dev Subtracts two int256 variables and fails on overflow.
720      */
721     function sub(int256 a, int256 b)
722         internal
723         pure
724         returns (int256)
725     {
726         int256 c = a - b;
727         require((b >= 0 && c <= a) || (b < 0 && c > a));
728         return c;
729     }
730 
731     /**
732      * @dev Adds two int256 variables and fails on overflow.
733      */
734     function add(int256 a, int256 b)
735         internal
736         pure
737         returns (int256)
738     {
739         int256 c = a + b;
740         require((b >= 0 && c >= a) || (b < 0 && c < a));
741         return c;
742     }
743 
744     /**
745      * @dev Converts to absolute value, and fails on overflow.
746      */
747     function abs(int256 a)
748         internal
749         pure
750         returns (int256)
751     {
752         require(a != MIN_INT256);
753         return a < 0 ? -a : a;
754     }
755 }
756 
757 // File: contracts/interfaces/ERC677.sol
758 
759 pragma solidity 0.6.12;
760 
761 
762 abstract contract ERC677 {
763     function transfer(address to, uint256 value) public virtual returns (bool);
764     function transferAndCall(address to, uint value, bytes memory data) public virtual returns (bool success);
765 
766     // event Transfer(address indexed from, address indexed to, uint value, bytes data);
767 }
768 
769 // File: contracts/interfaces/ERC677Receiver.sol
770 
771 pragma solidity 0.6.12;
772 
773 
774 abstract contract ERC677Receiver {
775     function onTokenTransfer(address _sender, uint _value, bytes memory _data) virtual public;
776 }
777 
778 // File: contracts/ERC677Token.sol
779 
780 pragma solidity 0.6.12;
781 
782 
783 
784 
785 abstract contract ERC677Token is ERC677 {
786     /**
787     * @dev transfer token to a contract address with additional data if the recipient is a contact.
788     * @param _to The address to transfer to.
789     * @param _value The amount to be transferred.
790     * @param _data The extra data to be passed to the receiving contract.
791     */
792     function transferAndCall(address _to, uint _value, bytes memory _data)
793         public
794         override
795         returns (bool success)
796     {
797         transfer(_to, _value);
798         if (isContract(_to)) {
799             contractFallback(_to, _value, _data);
800         }
801         return true;
802     }
803 
804     function contractFallback(address _to, uint _value, bytes memory _data)
805         private
806     {
807         ERC677Receiver receiver = ERC677Receiver(_to);
808         receiver.onTokenTransfer(msg.sender, _value, _data);
809     }
810 
811     function isContract(address _addr)
812         private
813         view
814         returns (bool hasCode)
815     {
816         uint length;
817         // solhint-disable-next-line no-inline-assembly
818         assembly { length := extcodesize(_addr) }
819         return length > 0;
820     }
821 }
822 
823 // File: contracts/XdefToken.sol
824 
825 pragma solidity 0.6.12;
826 
827 
828 
829 
830 
831 /**
832  * @title Xdef ERC20 token
833  * @dev This is part of an implementation of the Xdef Index Fund protocol.
834  *      Xdef is a normal ERC20 token, but its supply can be adjusted by splitting and
835  *      combining tokens proportionally across all wallets.
836  *
837  *      Xdef balances are internally represented with a hidden denomination, 'shares'.
838  *      We support splitting the currency in expansion and combining the currency on contraction by
839  *      changing the exchange rate between the hidden 'shares' and the public 'Xdef'.
840  */
841 contract XdefToken is ERC20("xDEF Finance", "xDEF2"), ERC677Token, Ownable {
842     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
843     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
844     // order to minimize this risk, we adhere to the following guidelines:
845     // 1) The conversion rate adopted is the number of shares that equals 1 Xdef.
846     //    The inverse rate must not be used--totalShares is always the numerator and _totalSupply is
847     //    always the denominator. (i.e. If you want to convert shares to Xdef instead of
848     //    multiplying by the inverse rate, you should divide by the normal rate)
849     // 2) Share balances converted into XdefToken are always rounded down (truncated).
850     //
851     // We make the following guarantees:
852     // - If address 'A' transfers x XdefToken to address 'B'. A's resulting external balance will
853     //   be decreased by precisely x XdefToken, and B's external balance will be precisely
854     //   increased by x XdefToken.
855     //
856     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
857     // This is because, for any conversion function 'f()' that has non-zero rounding error,
858     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
859     using SafeMath for uint256;
860     using SafeMathInt for int256;
861 
862     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
863     event LogMonetaryPolicyUpdated(address monetaryPolicy);
864     event LogUserBanStatusUpdated(address user, bool banned);
865 
866     // Used for authentication
867     address public monetaryPolicy;
868 
869     modifier validRecipient(address to) {
870         require(to != address(0x0));
871         require(to != address(this));
872         _;
873     }
874 
875     uint256 private constant DECIMALS = 9;
876     uint256 private constant MAX_UINT256 = ~uint256(0);
877     uint256 private constant INITIAL_SUPPLY = 17000000 * 10**DECIMALS;
878     uint256 private constant INITIAL_SHARES =
879         (MAX_UINT256 / (10**36)) - ((MAX_UINT256 / (10**36)) % INITIAL_SUPPLY);
880     uint256 private constant MAX_SUPPLY = ~uint128(0);
881 
882     uint256 private _totalShares;
883     uint256 private _totalSupply;
884     uint256 private _sharesPerXdef;
885     mapping(address => uint256) private _shareBalances;
886 
887     mapping(address => bool) public bannedUsers;
888 
889     // This is denominated in XdefToken, because the shares-Xdef conversion might change before
890     // it's fully paid.
891     mapping(address => mapping(address => uint256)) private _allowedXdef;
892 
893     bool public transfersPaused;
894     bool public rebasesPaused;
895 
896     mapping(address => bool) public transferPauseExemptList;
897 
898     constructor() public {
899         _setupDecimals(uint8(DECIMALS));
900 
901         _totalShares = INITIAL_SHARES;
902         _totalSupply = INITIAL_SUPPLY;
903         _shareBalances[owner()] = _totalShares;
904         _sharesPerXdef = _totalShares.div(_totalSupply);
905 
906         emit Transfer(address(0x0), owner(), _totalSupply);
907     }
908 
909     function setTransfersPaused(bool _transfersPaused) external onlyOwner {
910         transfersPaused = _transfersPaused;
911     }
912 
913     function setTransferPauseExempt(address user, bool exempt)
914         external
915         onlyOwner
916     {
917         if (exempt) {
918             transferPauseExemptList[user] = true;
919         } else {
920             delete transferPauseExemptList[user];
921         }
922     }
923 
924     function setRebasesPaused(bool _rebasesPaused) public onlyOwner {
925         rebasesPaused = _rebasesPaused;
926     }
927 
928     /**
929      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
930      */
931     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
932         monetaryPolicy = monetaryPolicy_;
933         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
934     }
935 
936     /**
937      * @dev Notifies XdefToken contract about a new rebase cycle.
938      * @param supplyDelta The number of new Xdef tokens to add into circulation via expansion.
939      * @return The total number of Xdef after the supply adjustment.
940      */
941     function rebase(uint256 epoch, int256 supplyDelta)
942         external
943         returns (uint256)
944     {
945         require(msg.sender == monetaryPolicy, "only monetary policy");
946         require(!rebasesPaused, "rebases paused");
947 
948         if (supplyDelta == 0) {
949             emit LogRebase(epoch, _totalSupply);
950             return _totalSupply;
951         }
952 
953         if (supplyDelta < 0) {
954             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
955         } else {
956             _totalSupply = _totalSupply.add(uint256(supplyDelta));
957         }
958 
959         if (_totalSupply > MAX_SUPPLY) {
960             _totalSupply = MAX_SUPPLY;
961         }
962 
963         _sharesPerXdef = _totalShares.div(_totalSupply);
964 
965         // From this point forward, _sharesPerXdef is taken as the source of truth.
966         // We recalculate a new _totalSupply to be in agreement with the _sharesPerXdef
967         // conversion rate.
968         // This means our applied supplyDelta can deviate from the requested supplyDelta,
969         // but this deviation is guaranteed to be < (_totalSupply^2)/(totalShares - _totalSupply).
970         //
971         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
972         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
973         // ever increased, it must be re-included.
974 
975         emit LogRebase(epoch, _totalSupply);
976         return _totalSupply;
977     }
978 
979     function totalShares() public view returns (uint256) {
980         return _totalShares;
981     }
982 
983     function sharesOf(address user) external view returns (uint256) {
984         return _shareBalances[user];
985     }
986 
987     function setUserBanStatus(address user, bool banned) external onlyOwner {
988         if (banned) {
989             bannedUsers[user] = true;
990         } else {
991             delete bannedUsers[user];
992         }
993         emit LogUserBanStatusUpdated(user, banned);
994     }
995 
996     /**
997      * @return The total number of Xdef.
998      */
999     function totalSupply() public view override returns (uint256) {
1000         return _totalSupply;
1001     }
1002 
1003     /**
1004      * @param who The address to query.
1005      * @return The balance of the specified address.
1006      */
1007     function balanceOf(address who) public view override returns (uint256) {
1008         return _shareBalances[who].div(_sharesPerXdef);
1009     }
1010 
1011     /**
1012      * @dev Transfer tokens to a specified address.
1013      * @param to The address to transfer to.
1014      * @param value The amount to be transferred.
1015      * @return True on success, false otherwise.
1016      */
1017     function transfer(address to, uint256 value)
1018         public
1019         override(ERC20, ERC677)
1020         validRecipient(to)
1021         returns (bool)
1022     {
1023         require(bannedUsers[msg.sender] == false, "you are banned");
1024         require(
1025             !transfersPaused || transferPauseExemptList[msg.sender],
1026             "paused"
1027         );
1028 
1029         uint256 shareValue = value.mul(_sharesPerXdef);
1030         _shareBalances[msg.sender] = _shareBalances[msg.sender].sub(shareValue);
1031         _shareBalances[to] = _shareBalances[to].add(shareValue);
1032         emit Transfer(msg.sender, to, value);
1033         return true;
1034     }
1035 
1036     /**
1037      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1038      * @param owner_ The address which owns the funds.
1039      * @param spender The address which will spend the funds.
1040      * @return The number of tokens still available for the spender.
1041      */
1042     function allowance(address owner_, address spender)
1043         public
1044         view
1045         override
1046         returns (uint256)
1047     {
1048         return _allowedXdef[owner_][spender];
1049     }
1050 
1051     /**
1052      * @dev Transfer tokens from one address to another.
1053      * @param from The address you want to send tokens from.
1054      * @param to The address you want to transfer to.
1055      * @param value The amount of tokens to be transferred.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 value
1061     ) public override validRecipient(to) returns (bool) {
1062         require(bannedUsers[msg.sender] == false, "you are banned");
1063         require(
1064             !transfersPaused || transferPauseExemptList[msg.sender],
1065             "paused"
1066         );
1067 
1068         _allowedXdef[from][msg.sender] = _allowedXdef[from][msg.sender].sub(
1069             value
1070         );
1071 
1072         uint256 shareValue = value.mul(_sharesPerXdef);
1073         _shareBalances[from] = _shareBalances[from].sub(shareValue);
1074         _shareBalances[to] = _shareBalances[to].add(shareValue);
1075         emit Transfer(from, to, value);
1076 
1077         return true;
1078     }
1079 
1080     /**
1081      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1082      * msg.sender. This method is included for ERC20 compatibility.
1083      * increaseAllowance and decreaseAllowance should be used instead.
1084      * Changing an allowance with this method brings the risk that someone may transfer both
1085      * the old and the new allowance - if they are both greater than zero - if a transfer
1086      * transaction is mined before the later approve() call is mined.
1087      *
1088      * @param spender The address which will spend the funds.
1089      * @param value The amount of tokens to be spent.
1090      */
1091     function approve(address spender, uint256 value)
1092         public
1093         override
1094         returns (bool)
1095     {
1096         require(
1097             !transfersPaused || transferPauseExemptList[msg.sender],
1098             "paused"
1099         );
1100 
1101         _allowedXdef[msg.sender][spender] = value;
1102         emit Approval(msg.sender, spender, value);
1103         return true;
1104     }
1105 
1106     /**
1107      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1108      * This method should be used instead of approve() to avoid the double approval vulnerability
1109      * described above.
1110      * @param spender The address which will spend the funds.
1111      * @param addedValue The amount of tokens to increase the allowance by.
1112      */
1113     function increaseAllowance(address spender, uint256 addedValue)
1114         public
1115         override
1116         returns (bool)
1117     {
1118         require(
1119             !transfersPaused || transferPauseExemptList[msg.sender],
1120             "paused"
1121         );
1122 
1123         _allowedXdef[msg.sender][spender] = _allowedXdef[msg.sender][spender]
1124             .add(addedValue);
1125         emit Approval(msg.sender, spender, _allowedXdef[msg.sender][spender]);
1126         return true;
1127     }
1128 
1129     /**
1130      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1131      *
1132      * @param spender The address which will spend the funds.
1133      * @param subtractedValue The amount of tokens to decrease the allowance by.
1134      */
1135     function decreaseAllowance(address spender, uint256 subtractedValue)
1136         public
1137         override
1138         returns (bool)
1139     {
1140         require(
1141             !transfersPaused || transferPauseExemptList[msg.sender],
1142             "paused"
1143         );
1144 
1145         uint256 oldValue = _allowedXdef[msg.sender][spender];
1146         if (subtractedValue >= oldValue) {
1147             _allowedXdef[msg.sender][spender] = 0;
1148         } else {
1149             _allowedXdef[msg.sender][spender] = oldValue.sub(subtractedValue);
1150         }
1151         emit Approval(msg.sender, spender, _allowedXdef[msg.sender][spender]);
1152         return true;
1153     }
1154 }