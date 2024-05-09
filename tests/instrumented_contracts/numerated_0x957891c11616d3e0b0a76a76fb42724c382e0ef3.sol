1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: None
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 pragma solidity >=0.6.0 <0.8.0;
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // File: @openzeppelin/contracts/math/SafeMath.sol
106 
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         uint256 c = a + b;
131         if (c < a) return (false, 0);
132         return (true, c);
133     }
134 
135     /**
136      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         if (b > a) return (false, 0);
142         return (true, a - b);
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) return (true, 0);
155         uint256 c = a * b;
156         if (c / a != b) return (false, 0);
157         return (true, c);
158     }
159 
160     /**
161      * @dev Returns the division of two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b == 0) return (false, 0);
167         return (true, a / b);
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         if (b == 0) return (false, 0);
177         return (true, a % b);
178     }
179 
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      *
188      * - Addition cannot overflow.
189      */
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         uint256 c = a + b;
192         require(c >= a, "SafeMath: addition overflow");
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         require(b <= a, "SafeMath: subtraction overflow");
208         return a - b;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         if (a == 0) return 0;
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225         return c;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers, reverting on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         require(b > 0, "SafeMath: division by zero");
242         return a / b;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         require(b > 0, "SafeMath: modulo by zero");
259         return a % b;
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
264      * overflow (when the result is negative).
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {trySub}.
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         return a - b;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
282      * division by zero. The result is rounded towards zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryDiv}.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a / b;
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * reverting with custom message when dividing by zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryMod}.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b > 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
322 
323 
324 pragma solidity >=0.6.0 <0.8.0;
325 
326 
327 
328 
329 /**
330  * @dev Implementation of the {IERC20} interface.
331  *
332  * This implementation is agnostic to the way tokens are created. This means
333  * that a supply mechanism has to be added in a derived contract using {_mint}.
334  * For a generic mechanism see {ERC20PresetMinterPauser}.
335  *
336  * TIP: For a detailed writeup see our guide
337  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
338  * to implement supply mechanisms].
339  *
340  * We have followed general OpenZeppelin guidelines: functions revert instead
341  * of returning `false` on failure. This behavior is nonetheless conventional
342  * and does not conflict with the expectations of ERC20 applications.
343  *
344  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
345  * This allows applications to reconstruct the allowance for all accounts just
346  * by listening to said events. Other implementations of the EIP may not emit
347  * these events, as it isn't required by the specification.
348  *
349  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
350  * functions have been added to mitigate the well-known issues around setting
351  * allowances. See {IERC20-approve}.
352  */
353 contract ERC20 is Context, IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowances;
359 
360     uint256 private _totalSupply;
361 
362     string private _name;
363     string private _symbol;
364     uint8 private _decimals;
365 
366     /**
367      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
368      * a default value of 18.
369      *
370      * To select a different value for {decimals}, use {_setupDecimals}.
371      *
372      * All three of these values are immutable: they can only be set once during
373      * construction.
374      */
375     constructor (string memory name_, string memory symbol_) public {
376         _name = name_;
377         _symbol = symbol_;
378         _decimals = 18;
379     }
380 
381     /**
382      * @dev Returns the name of the token.
383      */
384     function name() public view virtual returns (string memory) {
385         return _name;
386     }
387 
388     /**
389      * @dev Returns the symbol of the token, usually a shorter version of the
390      * name.
391      */
392     function symbol() public view virtual returns (string memory) {
393         return _symbol;
394     }
395 
396     /**
397      * @dev Returns the number of decimals used to get its user representation.
398      * For example, if `decimals` equals `2`, a balance of `505` tokens should
399      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
400      *
401      * Tokens usually opt for a value of 18, imitating the relationship between
402      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
403      * called.
404      *
405      * NOTE: This information is only used for _display_ purposes: it in
406      * no way affects any of the arithmetic of the contract, including
407      * {IERC20-balanceOf} and {IERC20-transfer}.
408      */
409     function decimals() public view virtual returns (uint8) {
410         return _decimals;
411     }
412 
413     /**
414      * @dev See {IERC20-totalSupply}.
415      */
416     function totalSupply() public view virtual override returns (uint256) {
417         return _totalSupply;
418     }
419 
420     /**
421      * @dev See {IERC20-balanceOf}.
422      */
423     function balanceOf(address account) public view virtual override returns (uint256) {
424         return _balances[account];
425     }
426 
427     /**
428      * @dev See {IERC20-transfer}.
429      *
430      * Requirements:
431      *
432      * - `recipient` cannot be the zero address.
433      * - the caller must have a balance of at least `amount`.
434      */
435     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
436         _transfer(_msgSender(), recipient, amount);
437         return true;
438     }
439 
440     /**
441      * @dev See {IERC20-allowance}.
442      */
443     function allowance(address owner, address spender) public view virtual override returns (uint256) {
444         return _allowances[owner][spender];
445     }
446 
447     /**
448      * @dev See {IERC20-approve}.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function approve(address spender, uint256 amount) public virtual override returns (bool) {
455         _approve(_msgSender(), spender, amount);
456         return true;
457     }
458 
459     /**
460      * @dev See {IERC20-transferFrom}.
461      *
462      * Emits an {Approval} event indicating the updated allowance. This is not
463      * required by the EIP. See the note at the beginning of {ERC20}.
464      *
465      * Requirements:
466      *
467      * - `sender` and `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      * - the caller must have allowance for ``sender``'s tokens of at least
470      * `amount`.
471      */
472     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
473         _transfer(sender, recipient, amount);
474         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
475         return true;
476     }
477 
478     /**
479      * @dev Atomically increases the allowance granted to `spender` by the caller.
480      *
481      * This is an alternative to {approve} that can be used as a mitigation for
482      * problems described in {IERC20-approve}.
483      *
484      * Emits an {Approval} event indicating the updated allowance.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      */
490     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
491         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
492         return true;
493     }
494 
495     /**
496      * @dev Atomically decreases the allowance granted to `spender` by the caller.
497      *
498      * This is an alternative to {approve} that can be used as a mitigation for
499      * problems described in {IERC20-approve}.
500      *
501      * Emits an {Approval} event indicating the updated allowance.
502      *
503      * Requirements:
504      *
505      * - `spender` cannot be the zero address.
506      * - `spender` must have allowance for the caller of at least
507      * `subtractedValue`.
508      */
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     /**
515      * @dev Moves tokens `amount` from `sender` to `recipient`.
516      *
517      * This is internal function is equivalent to {transfer}, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a {Transfer} event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
529         require(sender != address(0), "ERC20: transfer from the zero address");
530         require(recipient != address(0), "ERC20: transfer to the zero address");
531 
532         _beforeTokenTransfer(sender, recipient, amount);
533 
534         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
535         _balances[recipient] = _balances[recipient].add(amount);
536         emit Transfer(sender, recipient, amount);
537     }
538 
539     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
540      * the total supply.
541      *
542      * Emits a {Transfer} event with `from` set to the zero address.
543      *
544      * Requirements:
545      *
546      * - `to` cannot be the zero address.
547      */
548     function _mint(address account, uint256 amount) internal virtual {
549         require(account != address(0), "ERC20: mint to the zero address");
550 
551         _beforeTokenTransfer(address(0), account, amount);
552 
553         _totalSupply = _totalSupply.add(amount);
554         _balances[account] = _balances[account].add(amount);
555         emit Transfer(address(0), account, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`, reducing the
560      * total supply.
561      *
562      * Emits a {Transfer} event with `to` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      * - `account` must have at least `amount` tokens.
568      */
569     function _burn(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: burn from the zero address");
571 
572         _beforeTokenTransfer(account, address(0), amount);
573 
574         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
575         _totalSupply = _totalSupply.sub(amount);
576         emit Transfer(account, address(0), amount);
577     }
578 
579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
581      *
582      * This internal function is equivalent to `approve`, and can be used to
583      * e.g. set automatic allowances for certain subsystems, etc.
584      *
585      * Emits an {Approval} event.
586      *
587      * Requirements:
588      *
589      * - `owner` cannot be the zero address.
590      * - `spender` cannot be the zero address.
591      */
592     function _approve(address owner, address spender, uint256 amount) internal virtual {
593         require(owner != address(0), "ERC20: approve from the zero address");
594         require(spender != address(0), "ERC20: approve to the zero address");
595 
596         _allowances[owner][spender] = amount;
597         emit Approval(owner, spender, amount);
598     }
599 
600     /**
601      * @dev Sets {decimals} to a value other than the default one of 18.
602      *
603      * WARNING: This function should only be called from the constructor. Most
604      * applications that interact with token contracts will not expect
605      * {decimals} to ever change, and may work incorrectly if it does.
606      */
607     function _setupDecimals(uint8 decimals_) internal virtual {
608         _decimals = decimals_;
609     }
610 
611     /**
612      * @dev Hook that is called before any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * will be to transferred to `to`.
619      * - when `from` is zero, `amount` tokens will be minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
629 
630 
631 pragma solidity >=0.6.0 <0.8.0;
632 
633 
634 
635 /**
636  * @dev Extension of {ERC20} that allows token holders to destroy both their own
637  * tokens and those that they have an allowance for, in a way that can be
638  * recognized off-chain (via event analysis).
639  */
640 abstract contract ERC20Burnable is Context, ERC20 {
641     using SafeMath for uint256;
642 
643     /**
644      * @dev Destroys `amount` tokens from the caller.
645      *
646      * See {ERC20-_burn}.
647      */
648     function burn(uint256 amount) public virtual {
649         _burn(_msgSender(), amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
654      * allowance.
655      *
656      * See {ERC20-_burn} and {ERC20-allowance}.
657      *
658      * Requirements:
659      *
660      * - the caller must have allowance for ``accounts``'s tokens of at least
661      * `amount`.
662      */
663     function burnFrom(address account, uint256 amount) public virtual {
664         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
665 
666         _approve(account, _msgSender(), decreasedAllowance);
667         _burn(account, amount);
668     }
669 }
670 
671 // File: contracts/AddrArrayLib.sol
672 
673 pragma solidity ^0.7.6;
674 
675 library AddrArrayLib {
676     using AddrArrayLib for Addresses;
677 
678     struct Addresses {
679       address[]  _items;
680     }
681 
682     /**
683      * @notice push an address to the array
684      * @dev if the address already exists, it will not be added again
685      * @param self Storage array containing address type variables
686      * @param element the element to add in the array
687      */
688     function pushAddress(Addresses storage self, address element) internal {
689       if (!exists(self, element)) {
690         self._items.push(element);
691       }
692     }
693 
694     /**
695      * @notice remove an address from the array
696      * @dev finds the element, swaps it with the last element, and then deletes it;
697      *      returns a boolean whether the element was found and deleted
698      * @param self Storage array containing address type variables
699      * @param element the element to remove from the array
700      */
701     function removeAddress(Addresses storage self, address element) internal returns (bool) {
702         for (uint i = 0; i < self.size(); i++) {
703             if (self._items[i] == element) {
704                 self._items[i] = self._items[self.size() - 1];
705                 self._items.pop();
706                 return true;
707             }
708         }
709         return false;
710     }
711 
712     /**
713      * @notice get the address at a specific index from array
714      * @dev revert if the index is out of bounds
715      * @param self Storage array containing address type variables
716      * @param index the index in the array
717      */
718     function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {
719         require(index < size(self), "the index is out of bounds");
720         return self._items[index];
721     }
722 
723     /**
724      * @notice get the size of the array
725      * @param self Storage array containing address type variables
726      */
727     function size(Addresses storage self) internal view returns (uint256) {
728       return self._items.length;
729     }
730 
731     /**
732      * @notice check if an element exist in the array
733      * @param self Storage array containing address type variables
734      * @param element the element to check if it exists in the array
735      */
736     function exists(Addresses storage self, address element) internal view returns (bool) {
737         for (uint i = 0; i < self.size(); i++) {
738             if (self._items[i] == element) {
739                 return true;
740             }
741         }
742         return false;
743     }
744 
745     /**
746      * @notice get the array
747      * @param self Storage array containing address type variables
748      */
749     function getAllAddresses(Addresses storage self) internal view returns(address[] memory) {
750         return self._items;
751     }
752 
753 }
754 
755 // File: contracts/COLL.sol
756 
757 pragma solidity ^0.7.6;
758 
759 
760 
761 
762 contract CollToken is ERC20Burnable {
763     using SafeMath for uint256;
764     using AddrArrayLib for AddrArrayLib.Addresses;
765 
766     /**
767      * @dev Emitted when owner change fee account and fee amount.
768      */
769     event UpdateTaxInfo(address indexed owner, uint indexed feePercent);
770 
771 
772     uint public constant PRECISION = 100;
773     uint public constant INITIAL_SUPPLY = 50000000 * 10**18;
774 
775     address public _owner;
776     address public _feeAccount;
777     uint   public _feePercent;
778     
779     // List of no fee addresses when transfer token
780     AddrArrayLib.Addresses noFeeAddrs;
781 
782     constructor(address feeAccount, uint feePercent) ERC20("Collateral", "COLL") {
783         require(feeAccount != address(0), "Coll: fee account from the zero address");
784         _feeAccount = feeAccount;
785         _feePercent = feePercent;
786         _owner = _msgSender();
787         _mint(_msgSender(), INITIAL_SUPPLY);
788     }
789     
790     /**
791      * @dev Update the fee collector and the percent of fee from transfer operation
792      */
793     function updateTaxInfo(address feeAccount, uint feePercent) external {
794         require(feeAccount != address(0), "Coll: fee account from the zero address");
795         require(feePercent <= PRECISION, "Coll: incorrect fee percent");
796         require(_owner == _msgSender(), "Coll: updated tax info from no-owner address");
797         _feeAccount = feeAccount;
798         _feePercent = feePercent;
799         emit UpdateTaxInfo(feeAccount, feePercent);
800     }
801     
802     /**
803      * @dev Push non-fee address
804      */
805     function addNoFeeAddress(address addr) external {
806         require(_owner == _msgSender(), "Address: pushed address from no-owner address");
807         noFeeAddrs.pushAddress(addr);
808     }
809     
810     /**
811      * @dev Pop non-fee address
812      */
813     function removeNoFeeAddress(address addr) external {
814         require(_owner == _msgSender(), "Address: pop address from no-owner address");
815         require(noFeeAddrs.removeAddress(addr), "Address: address does not exist");
816     }
817 
818     /**
819      * @dev Check if address is existed in non-fee address list
820      */
821     function isExisted(address addr) public view returns (bool) {
822         return noFeeAddrs.exists(addr);
823     }
824 
825 
826     /**
827      * @dev Moves tokens `amount` from `sender` to `recipient`.
828      *
829      * This is internal function is equivalent to `transfer`, and can be used to
830      * e.g. implement automatic token fees, slashing mechanisms, etc.
831      *
832      * Emits a `Transfer` event.
833      *
834      * Requirements:
835      *
836      * - `sender` cannot be the zero address.
837      * - `recipient` cannot be the zero address.
838      * - `sender` must have a balance of at least `amount`.
839      */
840     function _transfer(address sender, address recipient, uint256 amount) internal override {
841         require(sender != address(0), "Coll: transfer from the zero address");
842         require(recipient != address(0), "Coll: transfer to the zero address");
843 
844         
845         if (isExisted(sender) || _feePercent == 0) {     
846             super._transfer(sender, recipient, amount);
847         } else {
848             uint256 _fee = amount.mul(_feePercent).div(PRECISION);
849             uint256 _recepientAmount = amount.sub(_fee);
850 
851             super._transfer(sender, recipient, _recepientAmount);
852             super._transfer(sender, _feeAccount, _fee);
853         }
854     }
855 }