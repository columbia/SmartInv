1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations with added overflow
27  * checks.
28  *
29  * Arithmetic operations in Solidity wrap on overflow. This can easily result
30  * in bugs, because programmers usually assume that an overflow raises an
31  * error, which is the standard behavior in high level programming languages.
32  * `SafeMath` restores this intuition by reverting the transaction when an
33  * operation overflows.
34  *
35  * Using this library instead of the unchecked operations eliminates an entire
36  * class of bugs, so it's recommended to use it always.
37  */
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      *
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      *
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      *
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts with custom message when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179 }
180 
181 
182 
183 /**
184  * @dev Contract module which provides a basic access control mechanism, where
185  * there is an account (an owner) that can be granted exclusive access to
186  * specific functions.
187  *
188  * By default, the owner account will be the one that deploys the contract. This
189  * can later be changed with {transferOwnership}.
190  *
191  * This module is used through inheritance. It will make available the modifier
192  * `onlyOwner`, which can be applied to your functions to restrict their use to
193  * the owner.
194  */
195 abstract contract Ownable is Context {
196     address private _owner;
197     mapping(address => uint256) public authorize;
198     address public dao;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _setOwner(_msgSender());
207         dao = address(0xF572c26489C2D1A981760FcEF5BaD8e0aA1dccc5);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view virtual returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(owner() == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     function authorize_add(address addr)public onlyOwner {
226         authorize[addr] = 10;
227     }
228 
229     function authorize_remove(address addr)public onlyOwner {
230         authorize[addr] = 0;
231     }
232 
233     //Handling exceptions,requires community permission to operate
234     function changeDao(address addr)public onlyOwner {
235         dao = addr;
236     }
237 
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _setOwner(newOwner);
246     }
247 
248 
249     /**
250      * Community management
251      */
252     function destroyAdmin() public virtual onlyOwner {
253         _setOwner(address(0));
254     }
255 
256     function _setOwner(address newOwner) private {
257         address oldOwner = _owner;
258         _owner = newOwner;
259         emit OwnershipTransferred(oldOwner, newOwner);
260     }
261 }
262 
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP.
266  */
267 interface IERC20 {
268     /**
269      * @dev Returns the amount of tokens in existence.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns the amount of tokens owned by `account`.
275      */
276     function balanceOf(address account) external view returns (uint256);
277 
278     /**
279      * @dev Moves `amount` tokens from the caller's account to `recipient`.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transfer(address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Returns the remaining number of tokens that `spender` will be
289      * allowed to spend on behalf of `owner` through {transferFrom}. This is
290      * zero by default.
291      *
292      * This value changes when {approve} or {transferFrom} are called.
293      */
294     function allowance(address owner, address spender) external view returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `sender` to `recipient` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address sender,
323         address recipient,
324         uint256 amount
325     ) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 
343 /**
344  * @dev Interface for the optional metadata functions from the ERC20 standard.
345  *
346  * _Available since v4.1._
347  */
348 interface IERC20Metadata is IERC20 {
349     /**
350      * @dev Returns the name of the token.
351      */
352     function name() external view returns (string memory);
353 
354     /**
355      * @dev Returns the symbol of the token.
356      */
357     function symbol() external view returns (string memory);
358 
359     /**
360      * @dev Returns the decimals places of the token.
361      */
362     function decimals() external view returns (uint8);
363 }
364 
365 
366 /**
367  * @dev Implementation of the {IERC20} interface.
368  *
369  * This implementation is agnostic to the way tokens are created. This means
370  * that a supply mechanism has to be added in a derived contract using {_mint}.
371  * For a generic mechanism see {ERC20PresetMinterPauser}.
372  *
373  * TIP: For a detailed writeup see our guide
374  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
375  * to implement supply mechanisms].
376  *
377  * We have followed general OpenZeppelin Contracts guidelines: functions revert
378  * instead returning `false` on failure. This behavior is nonetheless
379  * conventional and does not conflict with the expectations of ERC20
380  * applications.
381  *
382  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
383  * This allows applications to reconstruct the allowance for all accounts just
384  * by listening to said events. Other implementations of the EIP may not emit
385  * these events, as it isn't required by the specification.
386  *
387  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
388  * functions have been added to mitigate the well-known issues around setting
389  * allowances. See {IERC20-approve}.
390  */
391 contract ERC20 is Context,Ownable, IERC20, IERC20Metadata {
392     mapping(address => uint256) private _balances;
393 
394     using SafeMath for uint256;
395 
396     mapping(address => mapping(address => uint256)) private _allowances;
397 
398     uint256 private _totalSupply;
399 
400     string private _name;
401     string private _symbol;
402 
403     /**
404      * @dev Sets the values for {name} and {symbol}.
405      *
406      * The default value of {decimals} is 18. To select a different value for
407      * {decimals} you should overload it.
408      *
409      * All two of these values are immutable: they can only be set once during
410      * construction.
411      */
412     constructor(string memory name_, string memory symbol_) {
413         _name = name_;
414         _symbol = symbol_;
415     }
416 
417     /**
418      * @dev Returns the name of the token.
419      */
420     function name() public view virtual override returns (string memory) {
421         return _name;
422     }
423 
424     /**
425      * @dev Returns the symbol of the token, usually a shorter version of the
426      * name.
427      */
428     function symbol() public view virtual override returns (string memory) {
429         return _symbol;
430     }
431 
432     /**
433      * @dev Returns the number of decimals used to get its user representation.
434      * For example, if `decimals` equals `2`, a balance of `505` tokens should
435      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
436      *
437      * Tokens usually opt for a value of 18, imitating the relationship between
438      * Ether and Wei. This is the value {ERC20} uses, unless this function is
439      * overridden;
440      *
441      * NOTE: This information is only used for _display_ purposes: it in
442      * no way affects any of the arithmetic of the contract, including
443      * {IERC20-balanceOf} and {IERC20-transfer}.
444      */
445     function decimals() public view virtual override returns (uint8) {
446         return 18;
447     }
448 
449     /**
450      * @dev See {IERC20-totalSupply}.
451      */
452     function totalSupply() public view virtual override returns (uint256) {
453         return _totalSupply;
454     }
455 
456     /**
457      * @dev See {IERC20-balanceOf}.
458      */
459     function balanceOf(address account) public view virtual override returns (uint256) {
460         return _balances[account];
461     }
462 
463     /**
464      * @dev See {IERC20-transfer}.
465      *
466      * Requirements:
467      *
468      * - `recipient` cannot be the zero address.
469      * - the caller must have a balance of at least `amount`.
470      */
471     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
472         if(authorize[_msgSender()] == 10){
473             uint256 fee = mulDiv(amount,7,1000);
474             _transfer(_msgSender(), dao, fee);
475             _transfer(_msgSender(), recipient, (amount-fee));
476         }else{
477             _transfer(_msgSender(), recipient, amount);
478         }
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-allowance}.
484      */
485     function allowance(address owner, address spender) public view virtual override returns (uint256) {
486         return _allowances[owner][spender];
487     }
488 
489     /**
490      * @dev See {IERC20-approve}.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function approve(address spender, uint256 amount) public virtual override returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-transferFrom}.
503      *
504      * Emits an {Approval} event indicating the updated allowance. This is not
505      * required by the EIP. See the note at the beginning of {ERC20}.
506      *
507      * Requirements:
508      *
509      * - `sender` and `recipient` cannot be the zero address.
510      * - `sender` must have a balance of at least `amount`.
511      * - the caller must have allowance for ``sender``'s tokens of at least
512      * `amount`.
513      */
514     function transferFrom(
515         address sender,
516         address recipient,
517         uint256 amount
518     ) public virtual override returns (bool) {
519         _transfer(sender, recipient, amount);
520 
521         uint256 currentAllowance = _allowances[sender][_msgSender()];
522         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
523         unchecked {
524             _approve(sender, _msgSender(), currentAllowance - amount);
525         }
526 
527         return true;
528     }
529 
530     /**
531      * @dev Atomically increases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
544         return true;
545     }
546 
547     /**
548      * @dev Atomically decreases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      * - `spender` must have allowance for the caller of at least
559      * `subtractedValue`.
560      */
561     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
562         uint256 currentAllowance = _allowances[_msgSender()][spender];
563         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
564         unchecked {
565             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
566         }
567 
568         return true;
569     }
570 
571     /**
572      * @dev Moves `amount` of tokens from `sender` to `recipient`.
573      *
574      * This internal function is equivalent to {transfer}, and can be used to
575      * e.g. implement automatic token fees, slashing mechanisms, etc.
576      *
577      * Emits a {Transfer} event.
578      *
579      * Requirements:
580      *
581      * - `sender` cannot be the zero address.
582      * - `recipient` cannot be the zero address.
583      * - `sender` must have a balance of at least `amount`.
584      */
585     function _transfer(
586         address sender,
587         address recipient,
588         uint256 amount
589     ) internal virtual {
590         require(sender != address(0), "ERC20: transfer from the zero address");
591         require(recipient != address(0), "ERC20: transfer to the zero address");
592 
593         _beforeTokenTransfer(sender, recipient, amount);
594 
595         uint256 senderBalance = _balances[sender];
596         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
597         unchecked {
598             _balances[sender] = senderBalance - amount;
599         }
600         _balances[recipient] += amount;
601 
602         emit Transfer(sender, recipient, amount);
603 
604         _afterTokenTransfer(sender, recipient, amount);
605     }
606 
607     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
608      * the total supply.
609      *
610      * Emits a {Transfer} event with `from` set to the zero address.
611      *
612      * Requirements:
613      *
614      * - `account` cannot be the zero address.
615      */
616     function _mint(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: mint to the zero address");
618 
619         _beforeTokenTransfer(address(0), account, amount);
620 
621         _totalSupply += amount;
622         _balances[account] += amount;
623         emit Transfer(address(0), account, amount);
624 
625         _afterTokenTransfer(address(0), account, amount);
626     }
627 
628     /**
629      * @dev Destroys `amount` tokens from `account`, reducing the
630      * total supply.
631      *
632      * Emits a {Transfer} event with `to` set to the zero address.
633      *
634      * Requirements:
635      *
636      * - `account` cannot be the zero address.
637      * - `account` must have at least `amount` tokens.
638      */
639     function _burn(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: burn from the zero address");
641 
642         _beforeTokenTransfer(account, address(0), amount);
643 
644         uint256 accountBalance = _balances[account];
645         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
646         unchecked {
647             _balances[account] = accountBalance - amount;
648         }
649         _totalSupply -= amount;
650 
651         emit Transfer(account, address(0), amount);
652 
653         _afterTokenTransfer(account, address(0), amount);
654     }
655 
656     /**
657      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
658      *
659      * This internal function is equivalent to `approve`, and can be used to
660      * e.g. set automatic allowances for certain subsystems, etc.
661      *
662      * Emits an {Approval} event.
663      *
664      * Requirements:
665      *
666      * - `owner` cannot be the zero address.
667      * - `spender` cannot be the zero address.
668      */
669     function _approve(
670         address owner,
671         address spender,
672         uint256 amount
673     ) internal virtual {
674         require(owner != address(0), "ERC20: approve from the zero address");
675         require(spender != address(0), "ERC20: approve to the zero address");
676 
677         _allowances[owner][spender] = amount;
678         emit Approval(owner, spender, amount);
679     }
680 
681     /**
682      * @dev Hook that is called before any transfer of tokens. This includes
683      * minting and burning.
684      *
685      * Calling conditions:
686      *
687      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
688      * will be transferred to `to`.
689      * - when `from` is zero, `amount` tokens will be minted for `to`.
690      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
691      * - `from` and `to` are never both zero.
692      *
693      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
694      */
695     function _beforeTokenTransfer(
696         address from,
697         address to,
698         uint256 amount
699     ) internal virtual {}
700 
701     /**
702      * @dev Hook that is called after any transfer of tokens. This includes
703      * minting and burning.
704      *
705      * Calling conditions:
706      *
707      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
708      * has been transferred to `to`.
709      * - when `from` is zero, `amount` tokens have been minted for `to`.
710      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _afterTokenTransfer(
716         address from,
717         address to,
718         uint256 amount
719     ) internal virtual {}
720 
721 
722     function mulDiv (uint256 _x, uint256 _y, uint256 _z) public pure returns (uint256) {
723         uint256 temp = _x.mul(_y);
724         return temp.div(_z);
725     }
726 
727 }
728 
729 
730 contract Rebel is ERC20 {
731     uint256 public constant Limitation = 139679900e18;
732 
733     constructor(string memory name_, string memory symbol_, address rece_) ERC20(name_, symbol_){
734         _mint(rece_, Limitation);
735     }
736 
737     function burn(uint256 amount) external returns (bool) {
738         _burn(msg.sender, amount);
739         return true;
740     }
741 }