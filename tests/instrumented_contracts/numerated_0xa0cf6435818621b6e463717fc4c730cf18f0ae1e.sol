1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 /**
10 
11 
12 Black Eyed Inu - BLACK
13 
14 A tough dog, for a tough community. Born from the shadows. 
15 
16 https://t.me/BlackEyedInu 
17 
18 
19 
20 */
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
1041 contract BLACKEYED is ERC20, Ownable {
1042     using SafeMath for uint256;
1043 
1044     IUniswapV2Router02 public immutable uniswapV2Router;
1045     address public immutable uniswapV2Pair;
1046     address public constant deadAddress = address(0xdead);
1047 
1048     bool private swapping;
1049 
1050 	address public charityWallet;
1051     address public marketingWallet;
1052     address public devWallet;
1053 
1054     uint256 public maxTransactionAmount;
1055     uint256 public swapTokensAtAmount;
1056     uint256 public maxWallet;
1057 
1058     bool public limitsInEffect = true;
1059     bool public tradingActive = true;
1060     bool public swapEnabled = true;
1061 
1062     // Anti-bot and anti-whale mappings and variables
1063     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1064     bool public transferDelayEnabled = true;
1065 
1066     uint256 public buyTotalFees;
1067 	uint256 public buyCharityFee;
1068     uint256 public buyMarketingFee;
1069     uint256 public buyLiquidityFee;
1070     uint256 public buyDevFee;
1071 
1072     uint256 public sellTotalFees;
1073 	uint256 public sellCharityFee;
1074     uint256 public sellMarketingFee;
1075     uint256 public sellLiquidityFee;
1076     uint256 public sellDevFee;
1077 
1078 	uint256 public tokensForCharity;
1079     uint256 public tokensForMarketing;
1080     uint256 public tokensForLiquidity;
1081     uint256 public tokensForDev;
1082 
1083     /******************/
1084 
1085     // exlcude from fees and max transaction amount
1086     mapping(address => bool) private _isExcludedFromFees;
1087     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1088 
1089     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1090     // could be subject to a maximum transfer amount
1091     mapping(address => bool) public automatedMarketMakerPairs;
1092 
1093     event UpdateUniswapV2Router(
1094         address indexed newAddress,
1095         address indexed oldAddress
1096     );
1097 
1098     event ExcludeFromFees(address indexed account, bool isExcluded);
1099 
1100     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1101 
1102     event SwapAndLiquify(
1103         uint256 tokensSwapped,
1104         uint256 ethReceived,
1105         uint256 tokensIntoLiquidity
1106     );
1107 
1108     constructor() ERC20("Black Eyed Inu", "BLACK") {
1109         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1110             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1111         );
1112 
1113         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1114         uniswapV2Router = _uniswapV2Router;
1115 
1116         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1117             .createPair(address(this), _uniswapV2Router.WETH());
1118         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1119         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1120 
1121 		uint256 _buyCharityFee = 0;
1122         uint256 _buyMarketingFee = 15;
1123         uint256 _buyLiquidityFee = 0;
1124         uint256 _buyDevFee = 0;
1125 
1126 		uint256 _sellCharityFee = 0;
1127         uint256 _sellMarketingFee = 30;
1128         uint256 _sellLiquidityFee = 0;
1129         uint256 _sellDevFee = 0;
1130 
1131         uint256 totalSupply = 1000000000 * 1e18;
1132 
1133         maxTransactionAmount = 5000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1134         maxWallet = 10000000 * 1e18; // 2% from total supply maxWallet
1135         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1136 
1137 		buyCharityFee = _buyCharityFee;
1138         buyMarketingFee = _buyMarketingFee;
1139         buyLiquidityFee = _buyLiquidityFee;
1140         buyDevFee = _buyDevFee;
1141         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1142 
1143 		sellCharityFee = _sellCharityFee;
1144         sellMarketingFee = _sellMarketingFee;
1145         sellLiquidityFee = _sellLiquidityFee;
1146         sellDevFee = _sellDevFee;
1147         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1148 
1149 		charityWallet = address(0xf4144Ec1F9571C062DE34658aadc3cb2c58B30B5); // set as charity wallet
1150         marketingWallet = address(0xf4144Ec1F9571C062DE34658aadc3cb2c58B30B5); // set as marketing wallet
1151         devWallet = address(0xf4144Ec1F9571C062DE34658aadc3cb2c58B30B5); // set as dev wallet
1152 
1153         // exclude from paying fees or having max transaction amount
1154         excludeFromFees(owner(), true);
1155         excludeFromFees(address(this), true);
1156         excludeFromFees(address(0xdead), true);
1157 
1158         excludeFromMaxTransaction(owner(), true);
1159         excludeFromMaxTransaction(address(this), true);
1160         excludeFromMaxTransaction(address(0xdead), true);
1161 
1162         /*
1163             _mint is an internal function in ERC20.sol that is only called here,
1164             and CANNOT be called ever again
1165         */
1166         _mint(msg.sender, totalSupply);
1167     }
1168 
1169     receive() external payable {}
1170 
1171     // once enabled, can never be turned off
1172     function enableTrading() external onlyOwner {
1173         tradingActive = true;
1174         swapEnabled = true;
1175     }
1176 
1177     // remove limits after token is stable
1178     function removeLimits() external onlyOwner returns (bool) {
1179         limitsInEffect = false;
1180         return true;
1181     }
1182 
1183     // disable Transfer delay - cannot be reenabled
1184     function disableTransferDelay() external onlyOwner returns (bool) {
1185         transferDelayEnabled = false;
1186         return true;
1187     }
1188 
1189     // change the minimum amount of tokens to sell from fees
1190     function updateSwapTokensAtAmount(uint256 newAmount)
1191         external
1192         onlyOwner
1193         returns (bool)
1194     {
1195         require(
1196             newAmount >= (totalSupply() * 1) / 100000,
1197             "Swap amount cannot be lower than 0.001% total supply."
1198         );
1199         require(
1200             newAmount <= (totalSupply() * 5) / 1000,
1201             "Swap amount cannot be higher than 0.5% total supply."
1202         );
1203         swapTokensAtAmount = newAmount;
1204         return true;
1205     }
1206 
1207     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1208         require(
1209             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1210             "Cannot set maxTransactionAmount lower than 0.5%"
1211         );
1212         maxTransactionAmount = newNum * (10**18);
1213     }
1214 
1215     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1216         require(
1217             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1218             "Cannot set maxWallet lower than 0.5%"
1219         );
1220         maxWallet = newNum * (10**18);
1221     }
1222 	
1223     function excludeFromMaxTransaction(address updAds, bool isEx)
1224         public
1225         onlyOwner
1226     {
1227         _isExcludedMaxTransactionAmount[updAds] = isEx;
1228     }
1229 
1230     // only use to disable contract sales if absolutely necessary (emergency use only)
1231     function updateSwapEnabled(bool enabled) external onlyOwner {
1232         swapEnabled = enabled;
1233     }
1234 
1235     function updateBuyFees(
1236 		uint256 _charityFee,
1237         uint256 _marketingFee,
1238         uint256 _liquidityFee,
1239         uint256 _devFee
1240     ) external onlyOwner {
1241 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1242 		buyCharityFee = _charityFee;
1243         buyMarketingFee = _marketingFee;
1244         buyLiquidityFee = _liquidityFee;
1245         buyDevFee = _devFee;
1246         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1247      }
1248 
1249     function updateSellFees(
1250 		uint256 _charityFee,
1251         uint256 _marketingFee,
1252         uint256 _liquidityFee,
1253         uint256 _devFee
1254     ) external onlyOwner {
1255 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1256 		sellCharityFee = _charityFee;
1257         sellMarketingFee = _marketingFee;
1258         sellLiquidityFee = _liquidityFee;
1259         sellDevFee = _devFee;
1260         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1261     }
1262 
1263     function excludeFromFees(address account, bool excluded) public onlyOwner {
1264         _isExcludedFromFees[account] = excluded;
1265         emit ExcludeFromFees(account, excluded);
1266     }
1267 
1268     function setAutomatedMarketMakerPair(address pair, bool value)
1269         public
1270         onlyOwner
1271     {
1272         require(
1273             pair != uniswapV2Pair,
1274             "The pair cannot be removed from automatedMarketMakerPairs"
1275         );
1276 
1277         _setAutomatedMarketMakerPair(pair, value);
1278     }
1279 
1280     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1281         automatedMarketMakerPairs[pair] = value;
1282 
1283         emit SetAutomatedMarketMakerPair(pair, value);
1284     }
1285 
1286     function isExcludedFromFees(address account) public view returns (bool) {
1287         return _isExcludedFromFees[account];
1288     }
1289 
1290     function _transfer(
1291         address from,
1292         address to,
1293         uint256 amount
1294     ) internal override {
1295         require(from != address(0), "ERC20: transfer from the zero address");
1296         require(to != address(0), "ERC20: transfer to the zero address");
1297 
1298         if (amount == 0) {
1299             super._transfer(from, to, 0);
1300             return;
1301         }
1302 
1303         if (limitsInEffect) {
1304             if (
1305                 from != owner() &&
1306                 to != owner() &&
1307                 to != address(0) &&
1308                 to != address(0xdead) &&
1309                 !swapping
1310             ) {
1311                 if (!tradingActive) {
1312                     require(
1313                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1314                         "Trading is not active."
1315                     );
1316                 }
1317 
1318                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1319                 if (transferDelayEnabled) {
1320                     if (
1321                         to != owner() &&
1322                         to != address(uniswapV2Router) &&
1323                         to != address(uniswapV2Pair)
1324                     ) {
1325                         require(
1326                             _holderLastTransferTimestamp[tx.origin] <
1327                                 block.number,
1328                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1329                         );
1330                         _holderLastTransferTimestamp[tx.origin] = block.number;
1331                     }
1332                 }
1333 
1334                 //when buy
1335                 if (
1336                     automatedMarketMakerPairs[from] &&
1337                     !_isExcludedMaxTransactionAmount[to]
1338                 ) {
1339                     require(
1340                         amount <= maxTransactionAmount,
1341                         "Buy transfer amount exceeds the maxTransactionAmount."
1342                     );
1343                     require(
1344                         amount + balanceOf(to) <= maxWallet,
1345                         "Max wallet exceeded"
1346                     );
1347                 }
1348                 //when sell
1349                 else if (
1350                     automatedMarketMakerPairs[to] &&
1351                     !_isExcludedMaxTransactionAmount[from]
1352                 ) {
1353                     require(
1354                         amount <= maxTransactionAmount,
1355                         "Sell transfer amount exceeds the maxTransactionAmount."
1356                     );
1357                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1358                     require(
1359                         amount + balanceOf(to) <= maxWallet,
1360                         "Max wallet exceeded"
1361                     );
1362                 }
1363             }
1364         }
1365 
1366         uint256 contractTokenBalance = balanceOf(address(this));
1367 
1368         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1369 
1370         if (
1371             canSwap &&
1372             swapEnabled &&
1373             !swapping &&
1374             !automatedMarketMakerPairs[from] &&
1375             !_isExcludedFromFees[from] &&
1376             !_isExcludedFromFees[to]
1377         ) {
1378             swapping = true;
1379 
1380             swapBack();
1381 
1382             swapping = false;
1383         }
1384 
1385         bool takeFee = !swapping;
1386 
1387         // if any account belongs to _isExcludedFromFee account then remove the fee
1388         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1389             takeFee = false;
1390         }
1391 
1392         uint256 fees = 0;
1393         // only take fees on buys/sells, do not take on wallet transfers
1394         if (takeFee) {
1395             // on sell
1396             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1397                 fees = amount.mul(sellTotalFees).div(100);
1398 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1399                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1400                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1401                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1402             }
1403             // on buy
1404             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1405                 fees = amount.mul(buyTotalFees).div(100);
1406 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1407                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1408                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1409                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1410             }
1411 
1412             if (fees > 0) {
1413                 super._transfer(from, address(this), fees);
1414             }
1415 
1416             amount -= fees;
1417         }
1418 
1419         super._transfer(from, to, amount);
1420     }
1421 
1422     function swapTokensForEth(uint256 tokenAmount) private {
1423         // generate the uniswap pair path of token -> weth
1424         address[] memory path = new address[](2);
1425         path[0] = address(this);
1426         path[1] = uniswapV2Router.WETH();
1427 
1428         _approve(address(this), address(uniswapV2Router), tokenAmount);
1429 
1430         // make the swap
1431         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1432             tokenAmount,
1433             0, // accept any amount of ETH
1434             path,
1435             address(this),
1436             block.timestamp
1437         );
1438     }
1439 
1440     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1441         // approve token transfer to cover all possible scenarios
1442         _approve(address(this), address(uniswapV2Router), tokenAmount);
1443 
1444         // add the liquidity
1445         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1446             address(this),
1447             tokenAmount,
1448             0, // slippage is unavoidable
1449             0, // slippage is unavoidable
1450             devWallet,
1451             block.timestamp
1452         );
1453     }
1454 
1455     function swapBack() private {
1456         uint256 contractBalance = balanceOf(address(this));
1457         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1458         bool success;
1459 
1460         if (contractBalance == 0 || totalTokensToSwap == 0) {
1461             return;
1462         }
1463 
1464         if (contractBalance > swapTokensAtAmount * 20) {
1465             contractBalance = swapTokensAtAmount * 20;
1466         }
1467 
1468         // Halve the amount of liquidity tokens
1469         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1470         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1471 
1472         uint256 initialETHBalance = address(this).balance;
1473 
1474         swapTokensForEth(amountToSwapForETH);
1475 
1476         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1477 
1478 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1479         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1480         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1481 
1482         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1483 
1484         tokensForLiquidity = 0;
1485 		tokensForCharity = 0;
1486         tokensForMarketing = 0;
1487         tokensForDev = 0;
1488 
1489         (success, ) = address(devWallet).call{value: ethForDev}("");
1490         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1491 
1492 
1493         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1494             addLiquidity(liquidityTokens, ethForLiquidity);
1495             emit SwapAndLiquify(
1496                 amountToSwapForETH,
1497                 ethForLiquidity,
1498                 tokensForLiquidity
1499             );
1500         }
1501 
1502         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1503     }
1504 
1505 }