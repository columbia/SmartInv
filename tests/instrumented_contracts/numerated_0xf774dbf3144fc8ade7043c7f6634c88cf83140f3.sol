1 /**
2 
3     website: https://void.cash/
4     twitter: https://twitter.com/voidcasherc
5     telegram: https://t.me/voidcashportal
6     medium: https://medium.com/@voidcash
7     
8     prepare to enter the
9     ██╗   ██╗ ██████╗ ██╗██████╗ 
10     ██║   ██║██╔═══██╗██║██╔══██╗
11     ██║   ██║██║   ██║██║██║  ██║
12     ╚██╗ ██╔╝██║   ██║██║██║  ██║
13      ╚████╔╝ ╚██████╔╝██║██████╔╝
14       ╚═══╝   ╚═════╝ ╚═╝╚═════╝ 
15 
16  */
17 
18 // SPDX-License-Identifier: MIT
19 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
20 pragma experimental ABIEncoderV2;
21 
22 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
23 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
24 
25 /* pragma solidity ^0.8.0; */
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
48 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
49 
50 /* pragma solidity ^0.8.0; */
51 
52 /* import "../utils/Context.sol"; */
53 
54 /**
55  * @dev Contract module which provides a basic access control mechanism, where
56  * there is an account (an owner) that can be granted exclusive access to
57  * specific functions.
58  *
59  * By default, the owner account will be the one that deploys the contract. This
60  * can later be changed with {transferOwnership}.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions anymore. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby removing any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOwner {
101         _transferOwnership(address(0));
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Internal function without access restriction.
116      */
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
125 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
126 
127 /* pragma solidity ^0.8.0; */
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP.
131  */
132 interface IERC20 {
133     /**
134      * @dev Returns the amount of tokens in existence.
135      */
136     function totalSupply() external view returns (uint256);
137 
138     /**
139      * @dev Returns the amount of tokens owned by `account`.
140      */
141     function balanceOf(address account) external view returns (uint256);
142 
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `recipient`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     /**
162      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * IMPORTANT: Beware that changing an allowance with this method brings the risk
167      * that someone may use both the old and the new allowance by unfortunate
168      * transaction ordering. One possible solution to mitigate this race
169      * condition is to first reduce the spender's allowance to 0 and set the
170      * desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      *
173      * Emits an {Approval} event.
174      */
175     function approve(address spender, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Moves `amount` tokens from `sender` to `recipient` using the
179      * allowance mechanism. `amount` is then deducted from the caller's
180      * allowance.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) external returns (bool);
191 
192     /**
193      * @dev Emitted when `value` tokens are moved from one account (`from`) to
194      * another (`to`).
195      *
196      * Note that `value` may be zero.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     /**
201      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
202      * a call to {approve}. `value` is the new allowance.
203      */
204     event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
208 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
209 
210 /* pragma solidity ^0.8.0; */
211 
212 /* import "../IERC20.sol"; */
213 
214 /**
215  * @dev Interface for the optional metadata functions from the ERC20 standard.
216  *
217  * _Available since v4.1._
218  */
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
237 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
238 
239 /* pragma solidity ^0.8.0; */
240 
241 /* import "./IERC20.sol"; */
242 /* import "./extensions/IERC20Metadata.sol"; */
243 /* import "../../utils/Context.sol"; */
244 
245 /**
246  * @dev Implementation of the {IERC20} interface.
247  *
248  * This implementation is agnostic to the way tokens are created. This means
249  * that a supply mechanism has to be added in a derived contract using {_mint}.
250  * For a generic mechanism see {ERC20PresetMinterPauser}.
251  *
252  * TIP: For a detailed writeup see our guide
253  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
254  * to implement supply mechanisms].
255  *
256  * We have followed general OpenZeppelin Contracts guidelines: functions revert
257  * instead returning `false` on failure. This behavior is nonetheless
258  * conventional and does not conflict with the expectations of ERC20
259  * applications.
260  *
261  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See {IERC20-approve}.
269  */
270 contract ERC20 is Context, IERC20, IERC20Metadata {
271     mapping(address => uint256) private _balances;
272 
273     mapping(address => mapping(address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     string private _name;
278     string private _symbol;
279 
280     /**
281      * @dev Sets the values for {name} and {symbol}.
282      *
283      * The default value of {decimals} is 18. To select a different value for
284      * {decimals} you should overload it.
285      *
286      * All two of these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor(string memory name_, string memory symbol_) {
290         _name = name_;
291         _symbol = symbol_;
292     }
293 
294     /**
295      * @dev Returns the name of the token.
296      */
297     function name() public view virtual override returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @dev Returns the symbol of the token, usually a shorter version of the
303      * name.
304      */
305     function symbol() public view virtual override returns (string memory) {
306         return _symbol;
307     }
308 
309     /**
310      * @dev Returns the number of decimals used to get its user representation.
311      * For example, if `decimals` equals `2`, a balance of `505` tokens should
312      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
313      *
314      * Tokens usually opt for a value of 18, imitating the relationship between
315      * Ether and Wei. This is the value {ERC20} uses, unless this function is
316      * overridden;
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() public view virtual override returns (uint8) {
323         return 18;
324     }
325 
326     /**
327      * @dev See {IERC20-totalSupply}.
328      */
329     function totalSupply() public view virtual override returns (uint256) {
330         return _totalSupply;
331     }
332 
333     /**
334      * @dev See {IERC20-balanceOf}.
335      */
336     function balanceOf(address account) public view virtual override returns (uint256) {
337         return _balances[account];
338     }
339 
340     /**
341      * @dev See {IERC20-transfer}.
342      *
343      * Requirements:
344      *
345      * - `recipient` cannot be the zero address.
346      * - the caller must have a balance of at least `amount`.
347      */
348     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
349         _transfer(_msgSender(), recipient, amount);
350         return true;
351     }
352 
353     /**
354      * @dev See {IERC20-allowance}.
355      */
356     function allowance(address owner, address spender) public view virtual override returns (uint256) {
357         return _allowances[owner][spender];
358     }
359 
360     /**
361      * @dev See {IERC20-approve}.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function approve(address spender, uint256 amount) public virtual override returns (bool) {
368         _approve(_msgSender(), spender, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-transferFrom}.
374      *
375      * Emits an {Approval} event indicating the updated allowance. This is not
376      * required by the EIP. See the note at the beginning of {ERC20}.
377      *
378      * Requirements:
379      *
380      * - `sender` and `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      * - the caller must have allowance for ``sender``'s tokens of at least
383      * `amount`.
384      */
385     function transferFrom(
386         address sender,
387         address recipient,
388         uint256 amount
389     ) public virtual override returns (bool) {
390         _transfer(sender, recipient, amount);
391 
392         uint256 currentAllowance = _allowances[sender][_msgSender()];
393         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
394         unchecked {
395             _approve(sender, _msgSender(), currentAllowance - amount);
396         }
397 
398         return true;
399     }
400 
401     /**
402      * @dev Atomically increases the allowance granted to `spender` by the caller.
403      *
404      * This is an alternative to {approve} that can be used as a mitigation for
405      * problems described in {IERC20-approve}.
406      *
407      * Emits an {Approval} event indicating the updated allowance.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      */
413     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
415         return true;
416     }
417 
418     /**
419      * @dev Atomically decreases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      * - `spender` must have allowance for the caller of at least
430      * `subtractedValue`.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
433         uint256 currentAllowance = _allowances[_msgSender()][spender];
434         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
435         unchecked {
436             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
437         }
438 
439         return true;
440     }
441 
442     /**
443      * @dev Moves `amount` of tokens from `sender` to `recipient`.
444      *
445      * This internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `sender` cannot be the zero address.
453      * - `recipient` cannot be the zero address.
454      * - `sender` must have a balance of at least `amount`.
455      */
456     function _transfer(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) internal virtual {
461         require(sender != address(0), "ERC20: transfer from the zero address");
462         require(recipient != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(sender, recipient, amount);
465 
466         uint256 senderBalance = _balances[sender];
467         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
468         unchecked {
469             _balances[sender] = senderBalance - amount;
470         }
471         _balances[recipient] += amount;
472 
473         emit Transfer(sender, recipient, amount);
474 
475         _afterTokenTransfer(sender, recipient, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply += amount;
493         _balances[account] += amount;
494         emit Transfer(address(0), account, amount);
495 
496         _afterTokenTransfer(address(0), account, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements:
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _beforeTokenTransfer(account, address(0), amount);
514 
515         uint256 accountBalance = _balances[account];
516         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
517         unchecked {
518             _balances[account] = accountBalance - amount;
519         }
520         _totalSupply -= amount;
521 
522         emit Transfer(account, address(0), amount);
523 
524         _afterTokenTransfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
529      *
530      * This internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(
541         address owner,
542         address spender,
543         uint256 amount
544     ) internal virtual {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = amount;
549         emit Approval(owner, spender, amount);
550     }
551 
552     /**
553      * @dev Hook that is called before any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * will be transferred to `to`.
560      * - when `from` is zero, `amount` tokens will be minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 
572     /**
573      * @dev Hook that is called after any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * has been transferred to `to`.
580      * - when `from` is zero, `amount` tokens have been minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _afterTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 }
592 
593 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
594 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
595 
596 /* pragma solidity ^0.8.0; */
597 
598 // CAUTION
599 // This version of SafeMath should only be used with Solidity 0.8 or later,
600 // because it relies on the compiler's built in overflow checks.
601 
602 /**
603  * @dev Wrappers over Solidity's arithmetic operations.
604  *
605  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
606  * now has built in overflow checking.
607  */
608 library SafeMath {
609     /**
610      * @dev Returns the addition of two unsigned integers, with an overflow flag.
611      *
612      * _Available since v3.4._
613      */
614     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
615         unchecked {
616             uint256 c = a + b;
617             if (c < a) return (false, 0);
618             return (true, c);
619         }
620     }
621 
622     /**
623      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
624      *
625      * _Available since v3.4._
626      */
627     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             if (b > a) return (false, 0);
630             return (true, a - b);
631         }
632     }
633 
634     /**
635      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
636      *
637      * _Available since v3.4._
638      */
639     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
640         unchecked {
641             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
642             // benefit is lost if 'b' is also tested.
643             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
644             if (a == 0) return (true, 0);
645             uint256 c = a * b;
646             if (c / a != b) return (false, 0);
647             return (true, c);
648         }
649     }
650 
651     /**
652      * @dev Returns the division of two unsigned integers, with a division by zero flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             if (b == 0) return (false, 0);
659             return (true, a / b);
660         }
661     }
662 
663     /**
664      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
665      *
666      * _Available since v3.4._
667      */
668     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
669         unchecked {
670             if (b == 0) return (false, 0);
671             return (true, a % b);
672         }
673     }
674 
675     /**
676      * @dev Returns the addition of two unsigned integers, reverting on
677      * overflow.
678      *
679      * Counterpart to Solidity's `+` operator.
680      *
681      * Requirements:
682      *
683      * - Addition cannot overflow.
684      */
685     function add(uint256 a, uint256 b) internal pure returns (uint256) {
686         return a + b;
687     }
688 
689     /**
690      * @dev Returns the subtraction of two unsigned integers, reverting on
691      * overflow (when the result is negative).
692      *
693      * Counterpart to Solidity's `-` operator.
694      *
695      * Requirements:
696      *
697      * - Subtraction cannot overflow.
698      */
699     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
700         return a - b;
701     }
702 
703     /**
704      * @dev Returns the multiplication of two unsigned integers, reverting on
705      * overflow.
706      *
707      * Counterpart to Solidity's `*` operator.
708      *
709      * Requirements:
710      *
711      * - Multiplication cannot overflow.
712      */
713     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a * b;
715     }
716 
717     /**
718      * @dev Returns the integer division of two unsigned integers, reverting on
719      * division by zero. The result is rounded towards zero.
720      *
721      * Counterpart to Solidity's `/` operator.
722      *
723      * Requirements:
724      *
725      * - The divisor cannot be zero.
726      */
727     function div(uint256 a, uint256 b) internal pure returns (uint256) {
728         return a / b;
729     }
730 
731     /**
732      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
733      * reverting when dividing by zero.
734      *
735      * Counterpart to Solidity's `%` operator. This function uses a `revert`
736      * opcode (which leaves remaining gas untouched) while Solidity uses an
737      * invalid opcode to revert (consuming all remaining gas).
738      *
739      * Requirements:
740      *
741      * - The divisor cannot be zero.
742      */
743     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a % b;
745     }
746 
747     /**
748      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
749      * overflow (when the result is negative).
750      *
751      * CAUTION: This function is deprecated because it requires allocating memory for the error
752      * message unnecessarily. For custom revert reasons use {trySub}.
753      *
754      * Counterpart to Solidity's `-` operator.
755      *
756      * Requirements:
757      *
758      * - Subtraction cannot overflow.
759      */
760     function sub(
761         uint256 a,
762         uint256 b,
763         string memory errorMessage
764     ) internal pure returns (uint256) {
765         unchecked {
766             require(b <= a, errorMessage);
767             return a - b;
768         }
769     }
770 
771     /**
772      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
773      * division by zero. The result is rounded towards zero.
774      *
775      * Counterpart to Solidity's `/` operator. Note: this function uses a
776      * `revert` opcode (which leaves remaining gas untouched) while Solidity
777      * uses an invalid opcode to revert (consuming all remaining gas).
778      *
779      * Requirements:
780      *
781      * - The divisor cannot be zero.
782      */
783     function div(
784         uint256 a,
785         uint256 b,
786         string memory errorMessage
787     ) internal pure returns (uint256) {
788         unchecked {
789             require(b > 0, errorMessage);
790             return a / b;
791         }
792     }
793 
794     /**
795      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
796      * reverting with custom message when dividing by zero.
797      *
798      * CAUTION: This function is deprecated because it requires allocating memory for the error
799      * message unnecessarily. For custom revert reasons use {tryMod}.
800      *
801      * Counterpart to Solidity's `%` operator. This function uses a `revert`
802      * opcode (which leaves remaining gas untouched) while Solidity uses an
803      * invalid opcode to revert (consuming all remaining gas).
804      *
805      * Requirements:
806      *
807      * - The divisor cannot be zero.
808      */
809     function mod(
810         uint256 a,
811         uint256 b,
812         string memory errorMessage
813     ) internal pure returns (uint256) {
814         unchecked {
815             require(b > 0, errorMessage);
816             return a % b;
817         }
818     }
819 }
820 
821 /* pragma solidity 0.8.10; */
822 /* pragma experimental ABIEncoderV2; */
823 
824 interface IUniswapV2Factory {
825     event PairCreated(
826         address indexed token0,
827         address indexed token1,
828         address pair,
829         uint256
830     );
831 
832     function feeTo() external view returns (address);
833 
834     function feeToSetter() external view returns (address);
835 
836     function getPair(address tokenA, address tokenB)
837         external
838         view
839         returns (address pair);
840 
841     function allPairs(uint256) external view returns (address pair);
842 
843     function allPairsLength() external view returns (uint256);
844 
845     function createPair(address tokenA, address tokenB)
846         external
847         returns (address pair);
848 
849     function setFeeTo(address) external;
850 
851     function setFeeToSetter(address) external;
852 }
853 
854 /* pragma solidity 0.8.10; */
855 /* pragma experimental ABIEncoderV2; */
856 
857 interface IUniswapV2Pair {
858     event Approval(
859         address indexed owner,
860         address indexed spender,
861         uint256 value
862     );
863     event Transfer(address indexed from, address indexed to, uint256 value);
864 
865     function name() external pure returns (string memory);
866 
867     function symbol() external pure returns (string memory);
868 
869     function decimals() external pure returns (uint8);
870 
871     function totalSupply() external view returns (uint256);
872 
873     function balanceOf(address owner) external view returns (uint256);
874 
875     function allowance(address owner, address spender)
876         external
877         view
878         returns (uint256);
879 
880     function approve(address spender, uint256 value) external returns (bool);
881 
882     function transfer(address to, uint256 value) external returns (bool);
883 
884     function transferFrom(
885         address from,
886         address to,
887         uint256 value
888     ) external returns (bool);
889 
890     function DOMAIN_SEPARATOR() external view returns (bytes32);
891 
892     function PERMIT_TYPEHASH() external pure returns (bytes32);
893 
894     function nonces(address owner) external view returns (uint256);
895 
896     function permit(
897         address owner,
898         address spender,
899         uint256 value,
900         uint256 deadline,
901         uint8 v,
902         bytes32 r,
903         bytes32 s
904     ) external;
905 
906     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
907     event Burn(
908         address indexed sender,
909         uint256 amount0,
910         uint256 amount1,
911         address indexed to
912     );
913     event Swap(
914         address indexed sender,
915         uint256 amount0In,
916         uint256 amount1In,
917         uint256 amount0Out,
918         uint256 amount1Out,
919         address indexed to
920     );
921     event Sync(uint112 reserve0, uint112 reserve1);
922 
923     function MINIMUM_LIQUIDITY() external pure returns (uint256);
924 
925     function factory() external view returns (address);
926 
927     function token0() external view returns (address);
928 
929     function token1() external view returns (address);
930 
931     function getReserves()
932         external
933         view
934         returns (
935             uint112 reserve0,
936             uint112 reserve1,
937             uint32 blockTimestampLast
938         );
939 
940     function price0CumulativeLast() external view returns (uint256);
941 
942     function price1CumulativeLast() external view returns (uint256);
943 
944     function kLast() external view returns (uint256);
945 
946     function mint(address to) external returns (uint256 liquidity);
947 
948     function burn(address to)
949         external
950         returns (uint256 amount0, uint256 amount1);
951 
952     function swap(
953         uint256 amount0Out,
954         uint256 amount1Out,
955         address to,
956         bytes calldata data
957     ) external;
958 
959     function skim(address to) external;
960 
961     function sync() external;
962 
963     function initialize(address, address) external;
964 }
965 
966 /* pragma solidity 0.8.10; */
967 /* pragma experimental ABIEncoderV2; */
968 
969 interface IUniswapV2Router02 {
970     function factory() external pure returns (address);
971 
972     function WETH() external pure returns (address);
973 
974     function addLiquidity(
975         address tokenA,
976         address tokenB,
977         uint256 amountADesired,
978         uint256 amountBDesired,
979         uint256 amountAMin,
980         uint256 amountBMin,
981         address to,
982         uint256 deadline
983     )
984         external
985         returns (
986             uint256 amountA,
987             uint256 amountB,
988             uint256 liquidity
989         );
990 
991     function addLiquidityETH(
992         address token,
993         uint256 amountTokenDesired,
994         uint256 amountTokenMin,
995         uint256 amountETHMin,
996         address to,
997         uint256 deadline
998     )
999         external
1000         payable
1001         returns (
1002             uint256 amountToken,
1003             uint256 amountETH,
1004             uint256 liquidity
1005         );
1006 
1007     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1008         uint256 amountIn,
1009         uint256 amountOutMin,
1010         address[] calldata path,
1011         address to,
1012         uint256 deadline
1013     ) external;
1014 
1015     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1016         uint256 amountOutMin,
1017         address[] calldata path,
1018         address to,
1019         uint256 deadline
1020     ) external payable;
1021 
1022     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1023         uint256 amountIn,
1024         uint256 amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint256 deadline
1028     ) external;
1029 }
1030 
1031 /* pragma solidity >=0.8.10; */
1032 
1033 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1034 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1035 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1036 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1037 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1038 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1039 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1040 
1041 contract voidcash is ERC20, Ownable {
1042     using SafeMath for uint256;
1043 
1044     IUniswapV2Router02 public immutable uniswapV2Router;
1045     address public immutable uniswapV2Pair;
1046     address public constant deadAddress = address(0xdead);
1047 
1048     bool private swapping;
1049 
1050     address public devWallet;
1051     address public lpWallet = deadAddress;
1052 
1053     uint256 public maxTransactionAmount;
1054     uint256 public swapTokensAtAmount;
1055     uint256 public maxWallet;
1056 
1057     bool public limitsInEffect = true;
1058     bool public tradingActive = false;
1059     bool public swapEnabled = false;
1060 
1061     uint256 public buyLiquidityFee;
1062     uint256 public buyDevFee;
1063     uint256 public buyTotalFees = buyLiquidityFee + buyDevFee;
1064 
1065     uint256 public sellLiquidityFee;
1066     uint256 public sellDevFee;
1067     uint256 public sellTotalFees = sellLiquidityFee + sellDevFee;
1068 
1069 	uint256 public tokensForLiquidity;
1070     uint256 public tokensForDev;
1071 
1072     /******************/
1073 
1074     // exlcude from fees and max transaction amount
1075     mapping(address => bool) private _isExcludedFromFees;
1076     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1077 
1078     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1079     // could be subject to a maximum transfer amount
1080     mapping(address => bool) public automatedMarketMakerPairs;
1081 
1082     event UpdateUniswapV2Router(
1083         address indexed newAddress,
1084         address indexed oldAddress
1085     );
1086 
1087     event ExcludeFromFees(address indexed account, bool isExcluded);
1088 
1089     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1090 
1091     event SwapAndLiquify(
1092         uint256 tokensSwapped,
1093         uint256 ethReceived,
1094         uint256 tokensIntoLiquidity
1095     );
1096 
1097     constructor() ERC20("void.cash", unicode"VCASH") {
1098         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1099             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1100         );
1101 
1102         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1103         uniswapV2Router = _uniswapV2Router;
1104 
1105         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1106             .createPair(address(this), _uniswapV2Router.WETH());
1107         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1108         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1109 
1110         uint256 _buyLiquidityFee = 2;
1111         uint256 _buyDevFee = 4;
1112 
1113         uint256 _sellLiquidityFee = 2;
1114         uint256 _sellDevFee = 6;
1115 
1116         uint256 totalSupply = 1 * 1e9 * 1e18;
1117 
1118         maxTransactionAmount = 2 * 1e7 * 1e18; // 2% from total supply maxTransactionAmountTxn
1119         maxWallet = 2 * 1e7 * 1e18; // 2% from total supply maxWallet
1120         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1121 
1122         buyLiquidityFee = _buyLiquidityFee;
1123         buyDevFee = _buyDevFee;
1124         buyTotalFees = buyLiquidityFee + buyDevFee;
1125 
1126         sellLiquidityFee = _sellLiquidityFee;
1127         sellDevFee = _sellDevFee;
1128         sellTotalFees = sellLiquidityFee + sellDevFee;
1129 
1130         devWallet = address(0xBd6B81EddEee88395DBB3A1bb68684A2A83C0E7C); // set as dev wallet
1131 
1132         // exclude from paying fees or having max transaction amount
1133         excludeFromFees(owner(), true);
1134         excludeFromFees(address(this), true);
1135         excludeFromFees(address(0xdead), true);
1136 
1137         excludeFromMaxTransaction(owner(), true);
1138         excludeFromMaxTransaction(address(this), true);
1139         excludeFromMaxTransaction(address(0xdead), true);
1140 
1141         /*
1142             _mint is an internal function in ERC20.sol that is only called here,
1143             and CANNOT be called ever again
1144         */
1145         _mint(msg.sender, totalSupply);
1146     }
1147 
1148     receive() external payable {}
1149 
1150     // once enabled, can never be turned off
1151     function enableTrading() external onlyOwner {
1152         tradingActive = true;
1153         swapEnabled = true;
1154     }
1155 
1156     // remove limits after token is stable
1157     function removeLimits() external onlyOwner returns (bool) {
1158         limitsInEffect = false;
1159         return true;
1160     }
1161 
1162     // edit fees, cannot exceed 3%
1163     function setFees(uint256 newBuyLiquidityFee, uint256 newBuyDevFee, uint256 newSellLiquidityFee, uint256 newSellDevFee) external onlyOwner {
1164         buyLiquidityFee = newBuyLiquidityFee;
1165         buyDevFee = newBuyDevFee;
1166         sellLiquidityFee = newSellLiquidityFee;
1167         sellDevFee = newSellDevFee;
1168 
1169         require(buyLiquidityFee + buyDevFee <= 3, "fee too high");
1170         require(sellLiquidityFee + sellDevFee <=3, "fee too high");
1171     }
1172 
1173     // change the minimum amount of tokens to sell from fees
1174     function updateSwapTokensAtAmount(uint256 newAmount)
1175         external
1176         onlyOwner
1177         returns (bool)
1178     {
1179         require(
1180             newAmount >= (totalSupply() * 1) / 100000,
1181             "Swap amount cannot be lower than 0.001% total supply."
1182         );
1183         require(
1184             newAmount <= (totalSupply() * 5) / 1000,
1185             "Swap amount cannot be higher than 0.5% total supply."
1186         );
1187         swapTokensAtAmount = newAmount;
1188         return true;
1189     }
1190 	
1191     function excludeFromMaxTransaction(address updAds, bool isEx)
1192         public
1193         onlyOwner
1194     {
1195         _isExcludedMaxTransactionAmount[updAds] = isEx;
1196     }
1197 
1198     // only use to disable contract sales if absolutely necessary (emergency use only)
1199     function updateSwapEnabled(bool enabled) external onlyOwner {
1200         swapEnabled = enabled;
1201     }
1202 
1203     function excludeFromFees(address account, bool excluded) public onlyOwner {
1204         _isExcludedFromFees[account] = excluded;
1205         emit ExcludeFromFees(account, excluded);
1206     }
1207 
1208     function setAutomatedMarketMakerPair(address pair, bool value)
1209         public
1210         onlyOwner
1211     {
1212         require(
1213             pair != uniswapV2Pair,
1214             "The pair cannot be removed from automatedMarketMakerPairs"
1215         );
1216 
1217         _setAutomatedMarketMakerPair(pair, value);
1218     }
1219 
1220     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1221         automatedMarketMakerPairs[pair] = value;
1222 
1223         emit SetAutomatedMarketMakerPair(pair, value);
1224     }
1225 
1226     function isExcludedFromFees(address account) public view returns (bool) {
1227         return _isExcludedFromFees[account];
1228     }
1229 
1230     function _transfer(
1231         address from,
1232         address to,
1233         uint256 amount
1234     ) internal override {
1235         require(from != address(0), "ERC20: transfer from the zero address");
1236         require(to != address(0), "ERC20: transfer to the zero address");
1237 
1238         if (amount == 0) {
1239             super._transfer(from, to, 0);
1240             return;
1241         }
1242 
1243         if (limitsInEffect) {
1244             if (
1245                 from != owner() &&
1246                 to != owner() &&
1247                 to != address(0) &&
1248                 to != address(0xdead) &&
1249                 !swapping
1250             ) {
1251                 if (!tradingActive) {
1252                     require(
1253                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1254                         "Trading is not active."
1255                     );
1256                 }
1257 
1258                 //when buy
1259                 if (
1260                     automatedMarketMakerPairs[from] &&
1261                     !_isExcludedMaxTransactionAmount[to]
1262                 ) {
1263                     require(
1264                         amount <= maxTransactionAmount,
1265                         "Buy transfer amount exceeds the maxTransactionAmount."
1266                     );
1267                     require(
1268                         amount + balanceOf(to) <= maxWallet,
1269                         "Max wallet exceeded"
1270                     );
1271                 }
1272                 //when sell
1273                 else if (
1274                     automatedMarketMakerPairs[to] &&
1275                     !_isExcludedMaxTransactionAmount[from]
1276                 ) {
1277                     require(
1278                         amount <= maxTransactionAmount,
1279                         "Sell transfer amount exceeds the maxTransactionAmount."
1280                     );
1281                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1282                     require(
1283                         amount + balanceOf(to) <= maxWallet,
1284                         "Max wallet exceeded"
1285                     );
1286                 }
1287             }
1288         }
1289 
1290         uint256 contractTokenBalance = balanceOf(address(this));
1291 
1292         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1293 
1294         if (
1295             canSwap &&
1296             swapEnabled &&
1297             !swapping &&
1298             !automatedMarketMakerPairs[from] &&
1299             !_isExcludedFromFees[from] &&
1300             !_isExcludedFromFees[to]
1301         ) {
1302             swapping = true;
1303 
1304             swapBack();
1305 
1306             swapping = false;
1307         }
1308 
1309         bool takeFee = !swapping;
1310 
1311         // if any account belongs to _isExcludedFromFee account then remove the fee
1312         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1313             takeFee = false;
1314         }
1315 
1316         uint256 fees = 0;
1317         // only take fees on buys/sells, do not take on wallet transfers
1318         if (takeFee) {
1319             // on sell
1320             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1321                 fees = amount.mul(sellTotalFees).div(100);
1322                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1323                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
1324             }
1325             // on buy
1326             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1327                 fees = amount.mul(buyTotalFees).div(100);
1328                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1329                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1330             }
1331 
1332             if (fees > 0) {
1333                 super._transfer(from, address(this), fees);
1334             }
1335 
1336             amount -= fees;
1337         }
1338 
1339         super._transfer(from, to, amount);
1340     }
1341 
1342     function swapTokensForEth(uint256 tokenAmount) private {
1343         // generate the uniswap pair path of token -> weth
1344         address[] memory path = new address[](2);
1345         path[0] = address(this);
1346         path[1] = uniswapV2Router.WETH();
1347 
1348         _approve(address(this), address(uniswapV2Router), tokenAmount);
1349 
1350         // make the swap
1351         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1352             tokenAmount,
1353             0, // accept any amount of ETH
1354             path,
1355             address(this),
1356             block.timestamp
1357         );
1358     }
1359 
1360     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1361         // approve token transfer to cover all possible scenarios
1362         _approve(address(this), address(uniswapV2Router), tokenAmount);
1363 
1364         // add the liquidity
1365         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1366             address(this),
1367             tokenAmount,
1368             0, // slippage is unavoidable
1369             0, // slippage is unavoidable
1370             lpWallet,
1371             block.timestamp
1372         );
1373     }
1374 
1375     function swapBack() private {
1376         uint256 contractBalance = balanceOf(address(this));
1377         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1378         bool success;
1379 
1380         if (contractBalance == 0 || totalTokensToSwap == 0) {
1381             return;
1382         }
1383 
1384         if (contractBalance > swapTokensAtAmount * 20) {
1385             contractBalance = swapTokensAtAmount * 20;
1386         }
1387 
1388         // Halve the amount of liquidity tokens
1389         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1390         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1391 
1392         uint256 initialETHBalance = address(this).balance;
1393 
1394         swapTokensForEth(amountToSwapForETH);
1395 
1396         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1397 	
1398         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1399 
1400         uint256 ethForLiquidity = ethBalance - ethForDev;
1401 
1402         tokensForLiquidity = 0;
1403         tokensForDev = 0;
1404 
1405         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1406             addLiquidity(liquidityTokens, ethForLiquidity);
1407             emit SwapAndLiquify(
1408                 amountToSwapForETH,
1409                 ethForLiquidity,
1410                 tokensForLiquidity
1411             );
1412         }
1413 
1414         (success, ) = address(devWallet).call{value: address(this).balance}("");
1415     }
1416 
1417 }