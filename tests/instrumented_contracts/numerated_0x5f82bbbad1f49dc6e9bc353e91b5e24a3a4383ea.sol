1 /*                                               
2  _      ____  _____ 
3 / \  /|/  _ \/__ __\
4 | |  ||| / \|  / \  
5 | |/\||| |-||  | |  
6 \_/  \|\_/ \|  \_/  
7                     
8 
9 Meet Wat, Matt Furie's pet rat also Hoppy's BFF...
10 Watch the video on our website of Matt and Wat.
11 
12 Website: https://wat-therat.com
13 Telegram: https://t.me/WATratPortal
14 Twitter: https://twitter.com/WATtheRat
15 
16 */
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
821 ////// src/IUniswapV2Factory.sol
822 /* pragma solidity 0.8.10; */
823 /* pragma experimental ABIEncoderV2; */
824 
825 interface IUniswapV2Factory {
826     event PairCreated(
827         address indexed token0,
828         address indexed token1,
829         address pair,
830         uint256
831     );
832 
833     function feeTo() external view returns (address);
834 
835     function feeToSetter() external view returns (address);
836 
837     function getPair(address tokenA, address tokenB)
838         external
839         view
840         returns (address pair);
841 
842     function allPairs(uint256) external view returns (address pair);
843 
844     function allPairsLength() external view returns (uint256);
845 
846     function createPair(address tokenA, address tokenB)
847         external
848         returns (address pair);
849 
850     function setFeeTo(address) external;
851 
852     function setFeeToSetter(address) external;
853 }
854 
855 ////// src/IUniswapV2Pair.sol
856 /* pragma solidity 0.8.10; */
857 /* pragma experimental ABIEncoderV2; */
858 
859 interface IUniswapV2Pair {
860     event Approval(
861         address indexed owner,
862         address indexed spender,
863         uint256 value
864     );
865     event Transfer(address indexed from, address indexed to, uint256 value);
866 
867     function name() external pure returns (string memory);
868 
869     function symbol() external pure returns (string memory);
870 
871     function decimals() external pure returns (uint8);
872 
873     function totalSupply() external view returns (uint256);
874 
875     function balanceOf(address owner) external view returns (uint256);
876 
877     function allowance(address owner, address spender)
878         external
879         view
880         returns (uint256);
881 
882     function approve(address spender, uint256 value) external returns (bool);
883 
884     function transfer(address to, uint256 value) external returns (bool);
885 
886     function transferFrom(
887         address from,
888         address to,
889         uint256 value
890     ) external returns (bool);
891 
892     function DOMAIN_SEPARATOR() external view returns (bytes32);
893 
894     function PERMIT_TYPEHASH() external pure returns (bytes32);
895 
896     function nonces(address owner) external view returns (uint256);
897 
898     function permit(
899         address owner,
900         address spender,
901         uint256 value,
902         uint256 deadline,
903         uint8 v,
904         bytes32 r,
905         bytes32 s
906     ) external;
907 
908     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
909     event Burn(
910         address indexed sender,
911         uint256 amount0,
912         uint256 amount1,
913         address indexed to
914     );
915     event Swap(
916         address indexed sender,
917         uint256 amount0In,
918         uint256 amount1In,
919         uint256 amount0Out,
920         uint256 amount1Out,
921         address indexed to
922     );
923     event Sync(uint112 reserve0, uint112 reserve1);
924 
925     function MINIMUM_LIQUIDITY() external pure returns (uint256);
926 
927     function factory() external view returns (address);
928 
929     function token0() external view returns (address);
930 
931     function token1() external view returns (address);
932 
933     function getReserves()
934         external
935         view
936         returns (
937             uint112 reserve0,
938             uint112 reserve1,
939             uint32 blockTimestampLast
940         );
941 
942     function price0CumulativeLast() external view returns (uint256);
943 
944     function price1CumulativeLast() external view returns (uint256);
945 
946     function kLast() external view returns (uint256);
947 
948     function mint(address to) external returns (uint256 liquidity);
949 
950     function burn(address to)
951         external
952         returns (uint256 amount0, uint256 amount1);
953 
954     function swap(
955         uint256 amount0Out,
956         uint256 amount1Out,
957         address to,
958         bytes calldata data
959     ) external;
960 
961     function skim(address to) external;
962 
963     function sync() external;
964 
965     function initialize(address, address) external;
966 }
967 
968 ////// src/IUniswapV2Router02.sol
969 /* pragma solidity 0.8.10; */
970 /* pragma experimental ABIEncoderV2; */
971 
972 interface IUniswapV2Router02 {
973     function factory() external pure returns (address);
974 
975     function WETH() external pure returns (address);
976 
977     function addLiquidity(
978         address tokenA,
979         address tokenB,
980         uint256 amountADesired,
981         uint256 amountBDesired,
982         uint256 amountAMin,
983         uint256 amountBMin,
984         address to,
985         uint256 deadline
986     )
987         external
988         returns (
989             uint256 amountA,
990             uint256 amountB,
991             uint256 liquidity
992         );
993 
994     function addLiquidityETH(
995         address token,
996         uint256 amountTokenDesired,
997         uint256 amountTokenMin,
998         uint256 amountETHMin,
999         address to,
1000         uint256 deadline
1001     )
1002         external
1003         payable
1004         returns (
1005             uint256 amountToken,
1006             uint256 amountETH,
1007             uint256 liquidity
1008         );
1009 
1010     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1011         uint256 amountIn,
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external;
1017 
1018     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external payable;
1024 
1025     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1026         uint256 amountIn,
1027         uint256 amountOutMin,
1028         address[] calldata path,
1029         address to,
1030         uint256 deadline
1031     ) external;
1032 }
1033 
1034 /* pragma solidity >=0.8.10; */
1035 
1036 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1037 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1038 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1039 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1040 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1041 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1042 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1043 
1044 contract WAT is ERC20, Ownable {
1045     using SafeMath for uint256;
1046 
1047     IUniswapV2Router02 public immutable uniswapV2Router;
1048     address public immutable uniswapV2Pair;
1049     address public constant deadAddress = address(0xdead);
1050 
1051     bool private swapping;
1052 
1053     address public marketingWallet;
1054     address public devWallet;
1055 
1056     uint256 public maxTransactionAmount;
1057     uint256 public swapTokensAtAmount;
1058     uint256 public maxWallet;
1059 
1060     uint256 public percentForLPBurn = 25; // 25 = .25%
1061     bool public lpBurnEnabled = true;
1062     uint256 public lpBurnFrequency = 3600 seconds;
1063     uint256 public lastLpBurnTime;
1064 
1065     uint256 public manualBurnFrequency = 30 minutes;
1066     uint256 public lastManualLpBurnTime;
1067 
1068     bool public limitsInEffect = true;
1069     bool public tradingActive = false;
1070     bool public swapEnabled = false;
1071 
1072     // Anti-bot and anti-whale mappings and variables
1073     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1074     bool public transferDelayEnabled = true;
1075 
1076     uint256 public buyTotalFees;
1077     uint256 public buyMarketingFee;
1078     uint256 public buyLiquidityFee;
1079     uint256 public buyDevFee;
1080 
1081     uint256 public sellTotalFees;
1082     uint256 public sellMarketingFee;
1083     uint256 public sellLiquidityFee;
1084     uint256 public sellDevFee;
1085 
1086     uint256 public tokensForMarketing;
1087     uint256 public tokensForLiquidity;
1088     uint256 public tokensForDev;
1089 
1090     /******************/
1091 
1092     // exlcude from fees and max transaction amount
1093     mapping(address => bool) private _isExcludedFromFees;
1094     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1095 
1096     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1097     // could be subject to a maximum transfer amount
1098     mapping(address => bool) public automatedMarketMakerPairs;
1099 
1100     event UpdateUniswapV2Router(
1101         address indexed newAddress,
1102         address indexed oldAddress
1103     );
1104 
1105     event ExcludeFromFees(address indexed account, bool isExcluded);
1106 
1107     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1108 
1109     event marketingWalletUpdated(
1110         address indexed newWallet,
1111         address indexed oldWallet
1112     );
1113 
1114     event devWalletUpdated(
1115         address indexed newWallet,
1116         address indexed oldWallet
1117     );
1118 
1119     event SwapAndLiquify(
1120         uint256 tokensSwapped,
1121         uint256 ethReceived,
1122         uint256 tokensIntoLiquidity
1123     );
1124 
1125     event AutoNukeLP();
1126 
1127     event ManualNukeLP();
1128 
1129     constructor() ERC20("WAT", "WAT") {
1130         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1131             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1132         );
1133 
1134         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1135         uniswapV2Router = _uniswapV2Router;
1136 
1137         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1138             .createPair(address(this), _uniswapV2Router.WETH());
1139         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1140         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1141 
1142         uint256 _buyMarketingFee = 0;
1143         uint256 _buyLiquidityFee = 0;
1144         uint256 _buyDevFee = 20;
1145 
1146         uint256 _sellMarketingFee = 0;
1147         uint256 _sellLiquidityFee = 0;
1148         uint256 _sellDevFee = 60;
1149 
1150         uint256 totalSupply = 420_690_000_000_000 * 1e18;
1151 
1152         maxTransactionAmount = 8_413_800_000_000 * 1e18; 
1153         maxWallet = 8_413_800_000_000 * 1e18; 
1154         swapTokensAtAmount = (totalSupply * 5) / 10000; 
1155 
1156         buyMarketingFee = _buyMarketingFee;
1157         buyLiquidityFee = _buyLiquidityFee;
1158         buyDevFee = _buyDevFee;
1159         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1160 
1161         sellMarketingFee = _sellMarketingFee;
1162         sellLiquidityFee = _sellLiquidityFee;
1163         sellDevFee = _sellDevFee;
1164         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1165 
1166         marketingWallet = address(0x7663c2A980dD80364017031a49823ABFA7349531); // set as marketing wallet
1167         devWallet = address(0x7663c2A980dD80364017031a49823ABFA7349531); // set as dev wallet
1168 
1169         // exclude from paying fees or having max transaction amount
1170         excludeFromFees(owner(), true);
1171         excludeFromFees(address(this), true);
1172         excludeFromFees(address(0xdead), true);
1173 
1174         excludeFromMaxTransaction(owner(), true);
1175         excludeFromMaxTransaction(address(this), true);
1176         excludeFromMaxTransaction(address(0xdead), true);
1177 
1178         /*
1179             _mint is an internal function in ERC20.sol that is only called here,
1180             and CANNOT be called ever again
1181         */
1182         _mint(msg.sender, totalSupply);
1183     }
1184 
1185     receive() external payable {}
1186 
1187     // once enabled, can never be turned off
1188     function enableTrading() external onlyOwner {
1189         tradingActive = true;
1190         swapEnabled = true;
1191         lastLpBurnTime = block.timestamp;
1192     }
1193 
1194     // remove limits after token is stable
1195     function removeLimits() external onlyOwner returns (bool) {
1196         limitsInEffect = false;
1197         return true;
1198     }
1199 
1200     // disable Transfer delay - cannot be reenabled
1201     function disableTransferDelay() external onlyOwner returns (bool) {
1202         transferDelayEnabled = false;
1203         return true;
1204     }
1205 
1206     // change the minimum amount of tokens to sell from fees
1207     function updateSwapTokensAtAmount(uint256 newAmount)
1208         external
1209         onlyOwner
1210         returns (bool)
1211     {
1212         require(
1213             newAmount >= (totalSupply() * 1) / 100000,
1214             "Swap amount cannot be lower than 0.001% total supply."
1215         );
1216         require(
1217             newAmount <= (totalSupply() * 5) / 1000,
1218             "Swap amount cannot be higher than 0.5% total supply."
1219         );
1220         swapTokensAtAmount = newAmount;
1221         return true;
1222     }
1223 
1224     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1225         require(
1226             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1227             "Cannot set maxTransactionAmount lower than 0.1%"
1228         );
1229         maxTransactionAmount = newNum * (10**18);
1230     }
1231 
1232     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1233         require(
1234             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1235             "Cannot set maxWallet lower than 0.5%"
1236         );
1237         maxWallet = newNum * (10**18);
1238     }
1239 
1240     function excludeFromMaxTransaction(address updAds, bool isEx)
1241         public
1242         onlyOwner
1243     {
1244         _isExcludedMaxTransactionAmount[updAds] = isEx;
1245     }
1246 
1247     // only use to disable contract sales if absolutely necessary (emergency use only)
1248     function updateSwapEnabled(bool enabled) external onlyOwner {
1249         swapEnabled = enabled;
1250     }
1251 
1252     function updateBuyFees(
1253         uint256 _marketingFee,
1254         uint256 _liquidityFee,
1255         uint256 _devFee
1256     ) external onlyOwner {
1257         buyMarketingFee = _marketingFee;
1258         buyLiquidityFee = _liquidityFee;
1259         buyDevFee = _devFee;
1260         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1261         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1262     }
1263 
1264     function updateSellFees(
1265         uint256 _marketingFee,
1266         uint256 _liquidityFee,
1267         uint256 _devFee
1268     ) external onlyOwner {
1269         sellMarketingFee = _marketingFee;
1270         sellLiquidityFee = _liquidityFee;
1271         sellDevFee = _devFee;
1272         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1273         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1274     }
1275 
1276     function excludeFromFees(address account, bool excluded) public onlyOwner {
1277         _isExcludedFromFees[account] = excluded;
1278         emit ExcludeFromFees(account, excluded);
1279     }
1280 
1281     function setAutomatedMarketMakerPair(address pair, bool value)
1282         public
1283         onlyOwner
1284     {
1285         require(
1286             pair != uniswapV2Pair,
1287             "The pair cannot be removed from automatedMarketMakerPairs"
1288         );
1289 
1290         _setAutomatedMarketMakerPair(pair, value);
1291     }
1292 
1293     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1294         automatedMarketMakerPairs[pair] = value;
1295 
1296         emit SetAutomatedMarketMakerPair(pair, value);
1297     }
1298 
1299     function updateMarketingWallet(address newMarketingWallet)
1300         external
1301         onlyOwner
1302     {
1303         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1304         marketingWallet = newMarketingWallet;
1305     }
1306 
1307     function updateDevWallet(address newWallet) external onlyOwner {
1308         emit devWalletUpdated(newWallet, devWallet);
1309         devWallet = newWallet;
1310     }
1311 
1312     function isExcludedFromFees(address account) public view returns (bool) {
1313         return _isExcludedFromFees[account];
1314     }
1315 
1316     event BoughtEarly(address indexed sniper);
1317 
1318     function _transfer(
1319         address from,
1320         address to,
1321         uint256 amount
1322     ) internal override {
1323         require(from != address(0), "ERC20: transfer from the zero address");
1324         require(to != address(0), "ERC20: transfer to the zero address");
1325 
1326         if (amount == 0) {
1327             super._transfer(from, to, 0);
1328             return;
1329         }
1330 
1331         if (limitsInEffect) {
1332             if (
1333                 from != owner() &&
1334                 to != owner() &&
1335                 to != address(0) &&
1336                 to != address(0xdead) &&
1337                 !swapping
1338             ) {
1339                 if (!tradingActive) {
1340                     require(
1341                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1342                         "Trading is not active."
1343                     );
1344                 }
1345 
1346                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1347                 if (transferDelayEnabled) {
1348                     if (
1349                         to != owner() &&
1350                         to != address(uniswapV2Router) &&
1351                         to != address(uniswapV2Pair)
1352                     ) {
1353                         require(
1354                             _holderLastTransferTimestamp[tx.origin] <
1355                                 block.number,
1356                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1357                         );
1358                         _holderLastTransferTimestamp[tx.origin] = block.number;
1359                     }
1360                 }
1361 
1362                 //when buy
1363                 if (
1364                     automatedMarketMakerPairs[from] &&
1365                     !_isExcludedMaxTransactionAmount[to]
1366                 ) {
1367                     require(
1368                         amount <= maxTransactionAmount,
1369                         "Buy transfer amount exceeds the maxTransactionAmount."
1370                     );
1371                     require(
1372                         amount + balanceOf(to) <= maxWallet,
1373                         "Max wallet exceeded"
1374                     );
1375                 }
1376                 //when sell
1377                 else if (
1378                     automatedMarketMakerPairs[to] &&
1379                     !_isExcludedMaxTransactionAmount[from]
1380                 ) {
1381                     require(
1382                         amount <= maxTransactionAmount,
1383                         "Sell transfer amount exceeds the maxTransactionAmount."
1384                     );
1385                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1386                     require(
1387                         amount + balanceOf(to) <= maxWallet,
1388                         "Max wallet exceeded"
1389                     );
1390                 }
1391             }
1392         }
1393 
1394         uint256 contractTokenBalance = balanceOf(address(this));
1395 
1396         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1397 
1398         if (
1399             canSwap &&
1400             swapEnabled &&
1401             !swapping &&
1402             !automatedMarketMakerPairs[from] &&
1403             !_isExcludedFromFees[from] &&
1404             !_isExcludedFromFees[to]
1405         ) {
1406             swapping = true;
1407 
1408             swapBack();
1409 
1410             swapping = false;
1411         }
1412 
1413         if (
1414             !swapping &&
1415             automatedMarketMakerPairs[to] &&
1416             lpBurnEnabled &&
1417             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1418             !_isExcludedFromFees[from]
1419         ) {
1420             autoBurnLiquidityPairTokens();
1421         }
1422 
1423         bool takeFee = !swapping;
1424 
1425         // if any account belongs to _isExcludedFromFee account then remove the fee
1426         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1427             takeFee = false;
1428         }
1429 
1430         uint256 fees = 0;
1431         // only take fees on buys/sells, do not take on wallet transfers
1432         if (takeFee) {
1433             // on sell
1434             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1435                 fees = amount.mul(sellTotalFees).div(100);
1436                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1437                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1438                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1439             }
1440             // on buy
1441             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1442                 fees = amount.mul(buyTotalFees).div(100);
1443                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1444                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1445                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1446             }
1447 
1448             if (fees > 0) {
1449                 super._transfer(from, address(this), fees);
1450             }
1451 
1452             amount -= fees;
1453         }
1454 
1455         super._transfer(from, to, amount);
1456     }
1457 
1458     function swapTokensForEth(uint256 tokenAmount) private {
1459         // generate the uniswap pair path of token -> weth
1460         address[] memory path = new address[](2);
1461         path[0] = address(this);
1462         path[1] = uniswapV2Router.WETH();
1463 
1464         _approve(address(this), address(uniswapV2Router), tokenAmount);
1465 
1466         // make the swap
1467         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1468             tokenAmount,
1469             0, // accept any amount of ETH
1470             path,
1471             address(this),
1472             block.timestamp
1473         );
1474     }
1475 
1476     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1477         // approve token transfer to cover all possible scenarios
1478         _approve(address(this), address(uniswapV2Router), tokenAmount);
1479 
1480         // add the liquidity
1481         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1482             address(this),
1483             tokenAmount,
1484             0, // slippage is unavoidable
1485             0, // slippage is unavoidable
1486             deadAddress,
1487             block.timestamp
1488         );
1489     }
1490 
1491     function swapBack() private {
1492         uint256 contractBalance = balanceOf(address(this));
1493         uint256 totalTokensToSwap = tokensForLiquidity +
1494             tokensForMarketing +
1495             tokensForDev;
1496         bool success;
1497 
1498         if (contractBalance == 0 || totalTokensToSwap == 0) {
1499             return;
1500         }
1501 
1502         if (contractBalance > swapTokensAtAmount * 20) {
1503             contractBalance = swapTokensAtAmount * 20;
1504         }
1505 
1506         // Halve the amount of liquidity tokens
1507         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1508             totalTokensToSwap /
1509             2;
1510         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1511 
1512         uint256 initialETHBalance = address(this).balance;
1513 
1514         swapTokensForEth(amountToSwapForETH);
1515 
1516         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1517 
1518         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1519             totalTokensToSwap
1520         );
1521         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1522 
1523         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1524 
1525         tokensForLiquidity = 0;
1526         tokensForMarketing = 0;
1527         tokensForDev = 0;
1528 
1529         (success, ) = address(devWallet).call{value: ethForDev}("");
1530 
1531         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1532             addLiquidity(liquidityTokens, ethForLiquidity);
1533             emit SwapAndLiquify(
1534                 amountToSwapForETH,
1535                 ethForLiquidity,
1536                 tokensForLiquidity
1537             );
1538         }
1539 
1540         (success, ) = address(marketingWallet).call{
1541             value: address(this).balance
1542         }("");
1543     }
1544 
1545     function setAutoLPBurnSettings(
1546         uint256 _frequencyInSeconds,
1547         uint256 _percent,
1548         bool _Enabled
1549     ) external onlyOwner {
1550         require(
1551             _frequencyInSeconds >= 600,
1552             "cannot set buyback more often than every 10 minutes"
1553         );
1554         require(
1555             _percent <= 1000 && _percent >= 0,
1556             "Must set auto LP burn percent between 0% and 10%"
1557         );
1558         lpBurnFrequency = _frequencyInSeconds;
1559         percentForLPBurn = _percent;
1560         lpBurnEnabled = _Enabled;
1561     }
1562 
1563     function autoBurnLiquidityPairTokens() internal returns (bool) {
1564         lastLpBurnTime = block.timestamp;
1565 
1566         // get balance of liquidity pair
1567         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1568 
1569         // calculate amount to burn
1570         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1571             10000
1572         );
1573 
1574         // pull tokens from pancakePair liquidity and move to dead address permanently
1575         if (amountToBurn > 0) {
1576             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1577         }
1578 
1579         //sync price since this is not in a swap transaction!
1580         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1581         pair.sync();
1582         emit AutoNukeLP();
1583         return true;
1584     }
1585 
1586     function manualBurnLiquidityPairTokens(uint256 percent)
1587         external
1588         onlyOwner
1589         returns (bool)
1590     {
1591         require(
1592             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1593             "Must wait for cooldown to finish"
1594         );
1595         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1596         lastManualLpBurnTime = block.timestamp;
1597 
1598         // get balance of liquidity pair
1599         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1600 
1601         // calculate amount to burn
1602         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1603 
1604         // pull tokens from pancakePair liquidity and move to dead address permanently
1605         if (amountToBurn > 0) {
1606             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1607         }
1608 
1609         //sync price since this is not in a swap transaction!
1610         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1611         pair.sync();
1612         emit ManualNukeLP();
1613         return true;
1614     }
1615 }